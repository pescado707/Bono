"""
Ollama HTTP client helpers — called from server.jac.

Separating requests calls here keeps Jac's type checker happy,
since it cannot introspect the dynamic return types of requests.post().
"""

import json
import math
import os
import requests

OLLAMA_BASE = "http://localhost:11434"


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
    """Keyword overlap score used as a fallback when embeddings are unavailable."""
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

    # Build — may take ~1-2 min on first call (100 chunks × ~1 s each)
    embeddings = []
    for chunk in chunks:
        emb = ollama_embed(chunk, embed_model)
        embeddings.append(emb)

    has_valid = any(len(e) > 0 for e in embeddings)
    if has_valid:
        with open(cache_path, "w") as f:
            json.dump({"chunk_count": len(chunks), "embeddings": embeddings}, f)

    return embeddings


def rag_retrieve(query: str, text: str, top_k: int, cache_path: str, embed_model: str) -> list:
    """
    Retrieve the *top_k* most relevant chunks from *text* for *query*.
    Returns [list_of_chunk_strings, max_similarity_score].
    Uses Ollama embeddings with cosine similarity; falls back to TF-IDF.
    """
    # Chunk by ~400 words
    words = text.split()
    chunks = []
    i = 0
    while i < len(words):
        chunks.append(" ".join(words[i:i + 400]))
        i += 400

    # Score each chunk
    scored = []  # list of {"score": float, "chunk": str}
    query_emb = ollama_embed(query, embed_model)

    if len(query_emb) > 0:
        chunk_embeddings = load_or_build_embedding_cache(chunks, cache_path, embed_model)
        for idx, chunk in enumerate(chunks):
            emb = chunk_embeddings[idx] if idx < len(chunk_embeddings) else []
            score = cosine_similarity(query_emb, emb)
            scored.append({"score": score, "chunk": chunk})
    else:
        for chunk in chunks:
            score = tfidf_score(query, chunk)
            scored.append({"score": score, "chunk": chunk})

    scored.sort(key=lambda x: x["score"], reverse=True)

    top_chunks = [s["chunk"] for s in scored[:top_k]]
    max_score = scored[0]["score"] if scored else 0.0

    return [top_chunks, max_score]


def join_chunks(chunks: list, sep: str = "\n\n---\n\n") -> str:
    """Join retrieved chunks into a single context string."""
    return sep.join(str(c) for c in chunks)


def score_to_str(score: float) -> str:
    """Format a similarity score as a 2-decimal string."""
    return str(round(score, 2))
