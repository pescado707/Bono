"""
Ollama HTTP client helpers — called from server.jac.

Now includes a self-contained TF-IDF vector embedding pipeline so the
system works fast with zero external dependencies when Ollama is
unavailable.  The LLM generation path (ollama_generate) is kept for
optional use but retrieve_value in server.jac no longer calls it by
default.
"""

import json
import math
import os
import re
import requests

OLLAMA_BASE = "http://localhost:11434"

# ---------------------------------------------------------------------------
# Ollama helpers (kept but not used in the hot path)
# ---------------------------------------------------------------------------

def ollama_embed(text: str, model: str = "nomic-embed-text") -> list:
    """Return the embedding vector for *text*, or [] if Ollama is unavailable."""
    try:
        resp = requests.post(
            f"{OLLAMA_BASE}/api/embeddings",
            json={"model": model, "prompt": text},
            timeout=30,
        )
        if resp.ok:
            return resp.json().get("embedding", [])
    except Exception:
        pass
    return []


def ollama_generate(prompt: str, model: str = "qwen2.5:1.5b") -> str:
    """Return the model's text response, or an error string."""
    try:
        resp = requests.post(
            f"{OLLAMA_BASE}/api/generate",
            json={"model": model, "prompt": prompt, "stream": False,
                  "options": {"num_gpu": 0}},
            timeout=120,
        )
        if resp.ok:
            return resp.json().get("response", "No response from model.")
        return f"Error: Ollama returned status {resp.status_code}."
    except Exception as e:
        return (
            f"Ollama connection error: {e}. "
            "Ensure 'ollama serve' is running and the model is downloaded."
        )


# ---------------------------------------------------------------------------
# TF-IDF vector embedding  (pure Python, no dependencies)
# ---------------------------------------------------------------------------

_STOP_WORDS = {
    "a", "an", "the", "and", "or", "but", "in", "on", "at", "to", "for",
    "of", "with", "by", "is", "are", "was", "were", "be", "been", "being",
    "have", "has", "had", "do", "does", "did", "not", "this", "that", "it",
    "its", "as", "from", "will", "would", "can", "could", "may", "might",
    "shall", "should", "i", "you", "he", "she", "we", "they", "my", "your",
    "their", "our", "if", "then", "so", "also", "into", "up", "out", "about",
    "than", "more", "all", "any", "both", "each", "few", "most", "other",
    "some", "such", "no", "nor", "own", "same", "too", "very", "just", "s",
    "t", "don", "re", "ll", "ve", "m",
}


def _tokenize(text: str) -> list:
    """Lowercase, strip punctuation, split on whitespace, remove stop-words."""
    tokens = re.sub(r"[^a-z0-9\s]", " ", text.lower()).split()
    return [t for t in tokens if t not in _STOP_WORDS and len(t) > 1]


def _term_freq(tokens: list) -> dict:
    """Raw term frequency dict for a token list."""
    tf: dict = {}
    for t in tokens:
        tf[t] = tf.get(t, 0) + 1
    n = len(tokens) or 1
    return {t: c / n for t, c in tf.items()}


def _idf(term: str, chunk_tfs: list) -> float:
    """
    Smoothed IDF: log((1 + N) / (1 + df)) + 1
    where df = number of chunks containing *term*.
    """
    N = len(chunk_tfs)
    df = sum(1 for tf in chunk_tfs if term in tf)
    return math.log((1 + N) / (1 + df)) + 1.0


def _build_tfidf_vectors(chunks: list) -> tuple:
    """
    Build TF-IDF vectors for all chunks.
    Returns (vocabulary list, list of {term: tfidf_score} dicts).
    """
    chunk_tfs = [_term_freq(_tokenize(c)) for c in chunks]

    # Collect global vocabulary
    vocab: set = set()
    for tf in chunk_tfs:
        vocab.update(tf.keys())
    vocab_list = sorted(vocab)

    # Build TF-IDF dicts
    tfidf_vecs = []
    for tf in chunk_tfs:
        vec: dict = {}
        for term in tf:
            vec[term] = tf[term] * _idf(term, chunk_tfs)
        tfidf_vecs.append(vec)

    return vocab_list, tfidf_vecs


def _query_tfidf_vector(query_tokens: list, chunk_tfs: list) -> dict:
    """TF-IDF vector for a query, using corpus IDF values."""
    tf = _term_freq(query_tokens)
    vec: dict = {}
    for term in tf:
        vec[term] = tf[term] * _idf(term, chunk_tfs)
    return vec


def _cosine_sparse(v1: dict, v2: dict) -> float:
    """Cosine similarity between two sparse TF-IDF vectors (dicts)."""
    common = set(v1.keys()) & set(v2.keys())
    dot = sum(v1[t] * v2[t] for t in common)
    mag1 = math.sqrt(sum(x * x for x in v1.values()))
    mag2 = math.sqrt(sum(x * x for x in v2.values()))
    if mag1 == 0.0 or mag2 == 0.0:
        return 0.0
    return dot / (mag1 * mag2)


# ---------------------------------------------------------------------------
# Ollama dense embedding helpers (legacy path)
# ---------------------------------------------------------------------------

def cosine_similarity(vec1: list, vec2: list) -> float:
    """Cosine similarity between two equal-length float vectors."""
    n = len(vec1)
    if n == 0 or len(vec2) != n:
        return 0.0
    dot = 0.0
    sq1 = 0.0
    sq2 = 0.0
    for i in range(n):
        dot += vec1[i] * vec2[i]
        sq1 += vec1[i] * vec1[i]
        sq2 += vec2[i] * vec2[i]
    mag1 = math.sqrt(sq1)
    mag2 = math.sqrt(sq2)
    if mag1 == 0.0 or mag2 == 0.0:
        return 0.0
    return dot / (mag1 * mag2)


def tfidf_score(query: str, chunk: str) -> float:
    """Legacy keyword overlap score (kept for compatibility)."""
    terms = query.lower().split()
    chunk_words = chunk.lower().split()
    n = len(chunk_words)
    if n == 0:
        return 0.0
    score = 0.0
    for term in terms:
        score += chunk_words.count(term) / n
    return score


def load_or_build_embedding_cache(chunks: list, cache_path: str, embed_model: str) -> list:
    """
    Load chunk embeddings from *cache_path* if it exists and matches
    the current chunk count; otherwise call Ollama to build and save them.
    Returns a list of embedding vectors parallel to *chunks*.
    """
    if os.path.exists(cache_path):
        with open(cache_path, "r") as f:
            cached = json.load(f)
        if cached.get("chunk_count") == len(chunks):
            return cached.get("embeddings", [])

    embeddings = []
    for chunk in chunks:
        emb = ollama_embed(chunk, embed_model)
        embeddings.append(emb)

    has_valid = any(len(e) > 0 for e in embeddings)
    if has_valid:
        with open(cache_path, "w") as f:
            json.dump({"chunk_count": len(chunks), "embeddings": embeddings}, f)

    return embeddings


# ---------------------------------------------------------------------------
# Fast TF-IDF retrieval (primary path — no Ollama required)
# ---------------------------------------------------------------------------

def _split_chunks(text: str, chunk_words: int = 400) -> list:
    words = text.split()
    chunks = []
    i = 0
    while i < len(words):
        chunks.append(" ".join(words[i:i + chunk_words]))
        i += chunk_words
    return chunks


def retrieve_tfidf(query: str, text: str, top_k: int = 3) -> tuple:
    """
    Pure TF-IDF vector embedding retrieval.  No network calls required.

    Returns (top_k_chunk_strings, max_similarity_score).
    """
    chunks = _split_chunks(text)
    if not chunks:
        return ([], 0.0)

    query_tokens = _tokenize(query)
    chunk_tfs = [_term_freq(_tokenize(c)) for c in chunks]

    query_vec = _query_tfidf_vector(query_tokens, chunk_tfs)

    # Build chunk TF-IDF vectors
    _, chunk_tfidf_vecs = _build_tfidf_vectors(chunks)

    scored = []
    for i, chunk in enumerate(chunks):
        score = _cosine_sparse(query_vec, chunk_tfidf_vecs[i])
        scored.append({"score": score, "chunk": chunk})

    scored.sort(key=lambda x: x["score"], reverse=True)
    top = scored[:top_k]
    top_chunks = [s["chunk"] for s in top]
    max_score = top[0]["score"] if top else 0.0
    return (top_chunks, max_score)


def rag_retrieve(query: str, text: str, top_k: int, cache_path: str, embed_model: str) -> list:
    """
    Retrieve the *top_k* most relevant chunks from *text* for *query*.
    Returns [list_of_chunk_strings, max_similarity_score].

    Priority:
      1. Ollama dense embeddings (if available)
      2. TF-IDF vector embeddings (always available, fast)
    """
    chunks = _split_chunks(text)
    scored = []

    # Try Ollama dense embeddings first
    query_emb = ollama_embed(query, embed_model)

    if len(query_emb) > 0:
        chunk_embeddings = load_or_build_embedding_cache(chunks, cache_path, embed_model)
        for idx, chunk in enumerate(chunks):
            emb = chunk_embeddings[idx] if idx < len(chunk_embeddings) else []
            score = cosine_similarity(query_emb, emb)
            scored.append({"score": score, "chunk": chunk})
    else:
        # TF-IDF vector embedding fallback
        query_tokens = _tokenize(query)
        chunk_tfs = [_term_freq(_tokenize(c)) for c in chunks]
        query_vec = _query_tfidf_vector(query_tokens, chunk_tfs)
        _, chunk_tfidf_vecs = _build_tfidf_vectors(chunks)
        for i, chunk in enumerate(chunks):
            score = _cosine_sparse(query_vec, chunk_tfidf_vecs[i])
            scored.append({"score": score, "chunk": chunk})

    scored.sort(key=lambda x: x["score"], reverse=True)
    top_chunks = [s["chunk"] for s in scored[:top_k]]
    max_score = scored[0]["score"] if scored else 0.0
    return [top_chunks, max_score]


# ---------------------------------------------------------------------------
# Fast retrieval-only response (replaces LLM generation)
# ---------------------------------------------------------------------------

def format_retrieved_response(query: str, chunks: list, label: str, score: float) -> str:
    """
    Format retrieved chunks into a readable response without any LLM call.
    This is the fast path used when LLM generation is disabled.
    """
    header = f"**Relevant information for '{label.replace('_', ' ').title()}'**\n\n"
    body_parts = []
    for i, chunk in enumerate(chunks, 1):
        body_parts.append(f"**Excerpt {i}:**\n{chunk.strip()}")
    body = "\n\n".join(body_parts)
    score_note = ""
    if score < 0.45:
        score_note = (
            f"\n\n*[Low relevance match (score: {round(score, 2)}) — "
            "the documents may not directly address your situation. "
            "Consider providing more details.]*"
        )
    return header + body + score_note


def join_chunks(chunks: list, sep: str = "\n\n---\n\n") -> str:
    """Join retrieved chunks into a single context string."""
    return sep.join(str(c) for c in chunks)


def score_to_str(score: float) -> str:
    """Format a similarity score as a 2-decimal string."""
    return str(round(score, 2))
