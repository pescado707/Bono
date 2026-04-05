"""
Legal AI Agentic System - Jac-compatible rewrite.
Uses walker/node/enum graph primitives with correct Jac syntax.

RAG pipeline:
  - rights_protections and legal_glossary nodes use US_CONSTITUTION.txt.
  - All other nodes use docs/<label>.md.
  - Retrieval uses Ollama embeddings (nomic-embed-text) via ollama_client.py.
  - Embedding vectors are cached to constitution_embeddings_cache.json on first run.
  - TF-IDF keyword scoring is used as a fallback when Ollama is unavailable.
  - If max similarity < SIMILARITY_THRESHOLD the node sets needs_followup = True
    and the response includes a low-confidence notice.
  - If similarity >= threshold the node returns an LLM summary + curated links.
"""

import os;
import from ollama_client { ollama_embed, ollama_generate, rag_retrieve, join_chunks, score_to_str }

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

glob SIMILARITY_THRESHOLD: float = 0.45;
glob EMBED_MODEL: str = "nomic-embed-text";
glob CONSTITUTION_NODES: list = ["rights_protections", "legal_glossary"];

# ---------------------------------------------------------------------------
# Enum
# ---------------------------------------------------------------------------

enum ImmigrationAspect {
    CASE_ASSESSMENT,
    RIGHTS_PROTECTIONS,
    URGENT_STEPS,
    CRITICAL_WARNINGS,
    FOLLOW_UP_QUESTIONS,
    LEGAL_GLOSSARY,
    HELP_CONTACTS,
    PROCESS_OUTLOOK
}

# ---------------------------------------------------------------------------
# Nodes
# ---------------------------------------------------------------------------

node LegalNode {
    has aspect: ImmigrationAspect;
    has label: str = "";
    has value: str = "";
    has is_ready: bool = False;
    has history: list = [];
    has model: str = "qwen2.5:1.5b";
    has loop_count: int = 0;
    has dataset: str = "";
    has is_done: bool = False;
    has final_summary: str = "";
    has needs_followup: bool = False;
    has similarity_score: float = 0.0;

    # ------------------------------------------------------------------
    # Context loading
    # ------------------------------------------------------------------

    def load_context() -> str {
        import os;
        docs_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "docs");
        doc_path = os.path.join(docs_dir, self.label + ".md");
        if os.path.exists(doc_path) {
            with open(doc_path, "r") as f {
                return f.read();
            }
        }
        return "";
    }

    def load_constitution() -> str {
        import os;
        const_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "US_CONSTITUTION.txt");
        if os.path.exists(const_path) {
            with open(const_path, "r") as f {
                return f.read();
            }
        }
        return "";
    }

    # ------------------------------------------------------------------
    # LLM calls — delegate to ollama_client.py
    # ------------------------------------------------------------------

    def get_advice_py(user_situation: str, context: str) -> str {
        if self.label == "follow_up_questions" {
            task_instruction = (
                "Generate a numbered list of 3-5 critical follow-up questions "
                "the user should answer to clarify their immigration situation. "
                "Base the questions on the context document. "
                "Do NOT provide legal advice — only ask clarifying questions."
            );
        } else {
            task_instruction = (
                "Using ONLY the information in the context below, provide specific "
                "and actionable legal guidance for the '" + self.label + "' aspect "
                "of this immigration situation. Cite relevant constitutional "
                "amendments, form numbers, INA statutes, or deadlines. "
                "Do not invent information absent from the context."
            );
        }

        full_prompt = (
            "Context:\n" + context
            + "\n\nUser Situation:\n" + user_situation
            + "\n\nTask: " + task_instruction
        );

        return ollama_generate(full_prompt, self.model);
    }

    def get_follow_up_questions(user_situation: str, context: str) -> list {
        prompt = (
            "Context from legal document:\n" + context
            + "\n\nUser Situation:\n" + user_situation
            + "\n\nTask: Review the 'Follow-up Questions' section of the context. "
            "List 2-4 targeted questions most relevant to the user's situation. "
            "Write each question on its own line starting with '- '. "
            "If no more information is needed, write only: NONE"
        );

        raw = ollama_generate(prompt, self.model);
        questions = [];

        if raw != "NONE" and len(raw) > 0 {
            for line in raw.splitlines() {
                stripped = line.strip();
                if stripped.startswith("- ") {
                    questions.append(stripped[2:]);
                } elif stripped.endswith("?") and len(stripped) > 10 {
                    questions.append(stripped);
                }
            }
        }

        if len(questions) == 0 {
            questions = [
                "Has USCIS or ICE sent you any formal documents? If so, what type?",
                "Do you currently have an attorney representing you?",
                "What is your current immigration status or visa type?"
            ];
        }
        return questions;
    }

    # ------------------------------------------------------------------
    # Curated links per node
    # ------------------------------------------------------------------

    def get_relevant_links() -> str {
        rights_links = (
            "\n\n**Relevant Resources:**\n"
            "- Fourth Amendment (searches): constitution.congress.gov/constitution/amendment-4/\n"
            "- Fifth Amendment (silence): constitution.congress.gov/constitution/amendment-5/\n"
            "- Fourteenth Amendment (due process): constitution.congress.gov/constitution/amendment-14/\n"
            "- USCIS Know Your Rights: uscis.gov/rights\n"
            "- ICE detainee locator: locator.ice.gov\n"
            "- AILA attorney finder: aila.org/find-a-lawyer"
        );
        glossary_links = (
            "\n\n**Relevant Resources:**\n"
            "- INA full text: uscis.gov/laws-and-policy/legislation/immigration-and-nationality-act\n"
            "- USCIS forms library: uscis.gov/forms\n"
            "- I-94 arrival record: i94.cbp.dhs.gov\n"
            "- Visa Bulletin: travel.state.gov/content/travel/en/legal/visa-law0/visa-bulletin.html\n"
            "- BIA decisions: justice.gov/eoir/board-of-immigration-appeals"
        );
        assessment_links = (
            "\n\n**Relevant Resources:**\n"
            "- USCIS case status: uscis.gov/case-status\n"
            "- Immigration court info: justice.gov/eoir\n"
            "- CLINIC legal aid: cliniclegal.org"
        );
        urgent_links = (
            "\n\n**Relevant Resources:**\n"
            "- Emergency legal help: immigrationadvocates.org\n"
            "- National Immigration Law Center: nilc.org\n"
            "- USCIS emergency: uscis.gov/about-us/contact-us"
        );
        warnings_links = (
            "\n\n**Relevant Resources:**\n"
            "- USCIS policy manual: uscis.gov/policy-manual\n"
            "- INA inadmissibility grounds: uscis.gov/laws-and-policy"
        );
        contacts_links = (
            "\n\n**Relevant Resources:**\n"
            "- AILA attorney finder: aila.org/find-a-lawyer\n"
            "- Pro bono legal help: probono.net\n"
            "- National Immigration Project: nationalimmigrationproject.org\n"
            "- ACLU immigrants rights: aclu.org/know-your-rights/immigrants-rights"
        );
        outlook_links = (
            "\n\n**Relevant Resources:**\n"
            "- USCIS processing times: egov.uscis.gov/processing-times/\n"
            "- Visa Bulletin: travel.state.gov/content/travel/en/legal/visa-law0/visa-bulletin.html\n"
            "- EOIR case status: acis.eoir.justice.gov"
        );

        if self.label == "rights_protections" {
            return rights_links;
        } elif self.label == "legal_glossary" {
            return glossary_links;
        } elif self.label == "case_assessment" {
            return assessment_links;
        } elif self.label == "urgent_steps" {
            return urgent_links;
        } elif self.label == "critical_warnings" {
            return warnings_links;
        } elif self.label == "help_contacts" {
            return contacts_links;
        } elif self.label == "process_outlook" {
            return outlook_links;
        }
        return "";
    }

    # ------------------------------------------------------------------
    # Main retrieval entry point
    # ------------------------------------------------------------------

    def retrieve_value(prompt: str) -> str {
        import os;
        if self.label in CONSTITUTION_NODES {
            constitution = self.load_constitution();
            if len(constitution) > 0 {
                cache_path = os.path.join(
                    os.path.dirname(os.path.abspath(__file__)),
                    "constitution_embeddings_cache.json"
                );
                rag_result = rag_retrieve(
                    query=prompt,
                    text=constitution,
                    top_k=3,
                    cache_path=cache_path,
                    embed_model=EMBED_MODEL
                );
                top_chunks = rag_result[0];
                max_sim = rag_result[1];
                self.similarity_score = max_sim;

                context = join_chunks(top_chunks);
                advice = self.get_advice_py(user_situation=prompt, context=context);

                if max_sim < SIMILARITY_THRESHOLD {
                    self.needs_followup = True;
                    score_str = score_to_str(float(max_sim));
                    return (
                        advice
                        + "\n\n*[Low confidence score: " + score_str
                        + " — follow-up questions below will help narrow down the guidance.]*"
                        + self.get_relevant_links()
                    );
                } else {
                    return advice + self.get_relevant_links();
                }
            }
            # Fall through to .md doc if constitution file is missing
        }

        context = self.load_context();
        advice = self.get_advice_py(user_situation=prompt, context=context);
        return advice + self.get_relevant_links();
    }

    # ------------------------------------------------------------------
    # Summary generation
    # ------------------------------------------------------------------

    def generate_summary() -> str {
        self.final_summary = (
            "Immigration Case Summary for " + self.label + ":\n\n"
            + "Advice: Based on INA and USCIS policy, document your status and maintain all official correspondence.\n\n"
            + "Key Resources:\n"
            + "- USCIS main portal: uscis.gov\n"
            + "- ICE detainee locator: locator.ice.gov\n"
            + "- AILA attorney finder: aila.org/find-a-lawyer\n\n"
            + "Critical: Do not miss any Notice to Appear (NTA) deadlines."
        );
        return self.final_summary;
    }

    def update_value(new_value: str) -> None {
        self.history.append({
            "previous": self.value,
            "timestamp": "now"
        });
        self.value = new_value;
        self.is_ready = True;
        self.loop_count += 1;
    }

    def switch_model(new_model: str) -> None {
        allowed = ["qwen2.5", "llama3", "llama3.1", "mistral", "ollama", "gpt-4o", "gemini-1.5-pro", "claude-sonnet-4-6"];
        if new_model in allowed {
            self.model = new_model;
        }
    }

    def reset() -> None {
        self.history = [];
        self.value = "";
        self.is_ready = False;
        self.loop_count = 0;
        self.is_done = False;
        self.final_summary = "";
        self.needs_followup = False;
        self.similarity_score = 0.0;
    }
}

sem LegalNode.get_advice_py = """You are an immigration legal assistant. Using ONLY the content in the 'context' parameter (a government/legal reference document), provide specific and actionable advice for the user's situation. Cite relevant form numbers, INA statutes, or deadlines from the document. Do not invent information not present in the context.""";

sem LegalNode.get_advice_py.user_situation = "The user's immigration situation as they described it.";
sem LegalNode.get_advice_py.context = "Relevant passages retrieved from a government or legal reference document. Ground your answer strictly in this text.";

sem LegalNode.get_follow_up_questions = """You are an immigration legal assistant. Review the 'Follow-up Questions' section of the context document. Return a list of 2-3 targeted questions from that section that are most relevant to the user's situation and would help clarify the case. If the situation is already fully described and no critical information is missing, return an empty list.""";

sem LegalNode.get_follow_up_questions.user_situation = "The user's immigration situation as described so far.";
sem LegalNode.get_follow_up_questions.context = "A government or legal reference document whose 'Follow-up Questions' section contains question templates for this aspect of immigration law.";

node SummaryNode {
    has value: str = "";
    has is_ready: bool = False;
    has generated_at_loop: int = 0;
}

node DocumentChunk {
    has content: str = "";
    has source: str = "";
    has topic: str = "";
}

# ---------------------------------------------------------------------------
# Walkers
# ---------------------------------------------------------------------------

walker:pub SwitchModel {
    has target_label: str = "";
    has new_model: str = "";

    can visit_root with Root entry {
        visit [-->];
    }

    can switch with LegalNode entry {
        if here.label == self.target_label or self.target_label == "all" {
            here.switch_model(self.new_model);
            report {
                "label": here.label,
                "model": here.model
            };
        }
        visit [-->];
    }
}

# ---------------------------------------------------------------------------

walker:pub AnalyzeSituation {
    has user_input: str = "";
    has results: dict = {};

    can visit_root with Root entry {
        has_nodes = False;
        for n in [root -->] {
            if isinstance(n, LegalNode) {
                has_nodes = True;
                break;
            }
        }
        if not has_nodes {
            root ++> LegalNode(label="case_assessment",      aspect=ImmigrationAspect.CASE_ASSESSMENT);
            root ++> LegalNode(label="rights_protections",   aspect=ImmigrationAspect.RIGHTS_PROTECTIONS);
            root ++> LegalNode(label="urgent_steps",         aspect=ImmigrationAspect.URGENT_STEPS);
            root ++> LegalNode(label="critical_warnings",    aspect=ImmigrationAspect.CRITICAL_WARNINGS);
            root ++> LegalNode(label="follow_up_questions",  aspect=ImmigrationAspect.FOLLOW_UP_QUESTIONS);
            root ++> LegalNode(label="legal_glossary",       aspect=ImmigrationAspect.LEGAL_GLOSSARY);
            root ++> LegalNode(label="help_contacts",        aspect=ImmigrationAspect.HELP_CONTACTS);
            root ++> LegalNode(label="process_outlook",      aspect=ImmigrationAspect.PROCESS_OUTLOOK);
            root ++> SummaryNode();
        }
        visit [-->];
    }

    can visit_node with LegalNode entry {
        here.reset();
        new_val = here.retrieve_value(self.user_input);
        here.update_value(new_val);

        self.results[here.label] = {
            "value": here.value,
            "model": here.model,
            "is_ready": here.is_ready,
            "loop_count": here.loop_count,
            "needs_followup": here.needs_followup,
            "similarity_score": here.similarity_score
        };
    }

    can report_results with Root exit {
        report self.results;
    }
}

# ---------------------------------------------------------------------------

walker:pub FollowUp {
    has original_input: str = "";
    has follow_up_answer: str = "";
    has accumulated_context: str = "";
    has max_loops: int = 3;
    has results: dict = {};
    has limit_reached: bool = False;
    has node_outputs: dict = {};

    can start with Root entry {
        self.accumulated_context = (
            self.original_input
            + " Additional context from follow-up: "
            + self.follow_up_answer
        );

        for n in [-->] {
            if isinstance(n, LegalNode) {
                self.node_outputs[n.label] = n.value;
            }
        }

        visit [-->];
    }

    can collect with LegalNode entry {
        if here.loop_count >= self.max_loops {
            self.limit_reached = True;
            self.node_outputs[here.label] = here.value;
            visit [-->];
            return;
        }

        if here.label == "follow_up_questions" {
            questions = here.get_follow_up_questions(
                user_situation=self.accumulated_context,
                context=here.load_context()
            );
            if len(questions) == 0 {
                here.is_done = True;
                here.generate_summary();
                here.update_value("No further questions needed.");
            } else {
                here.update_value("\n".join(questions));
            }
        } else {
            new_val = here.retrieve_value(self.accumulated_context);
            here.update_value(new_val);
        }

        self.results[here.label] = {
            "value": here.value,
            "model": here.model,
            "loop_count": here.loop_count,
            "history_count": len(here.history),
            "limit_reached": False,
            "is_done": here.is_done,
            "final_summary": here.final_summary,
            "needs_followup": here.needs_followup,
            "similarity_score": here.similarity_score
        };
        visit [-->];
    }

    can finish with Root exit {
        if self.limit_reached {
            summarizer = Summarize(
                node_outputs=self.node_outputs,
                accumulated_context=self.accumulated_context
            );
            root spawn summarizer;
        } else {
            report {
                "results": self.results,
                "limit_reached": False
            };
        }
    }
}

# ---------------------------------------------------------------------------

walker Summarize {
    has node_outputs: dict = {};
    has accumulated_context: str = "";
    has summary: str = "";

    can build_summary with Root entry {
        assessment  = str(self.node_outputs.get("case_assessment", ""));
        rights      = str(self.node_outputs.get("rights_protections", ""));
        urgent      = str(self.node_outputs.get("urgent_steps", ""));
        warnings    = str(self.node_outputs.get("critical_warnings", ""));
        who         = str(self.node_outputs.get("help_contacts", ""));
        outlook     = str(self.node_outputs.get("process_outlook", ""));

        self.summary = (
            "IMMIGRATION CASE SUMMARY\n\n"
            + "Situation Assessment: " + assessment + "\n\n"
            + "Your Rights: " + rights + "\n\n"
            + "Do This Now: " + urgent + "\n\n"
            + "Avoid This: " + warnings + "\n\n"
            + "Who to Contact: " + who + "\n\n"
            + "What Happens Next: " + outlook + "\n\n"
            + "Full context gathered: " + self.accumulated_context
        );

        for n in [-->] {
            if isinstance(n, SummaryNode) {
                n.value = self.summary;
                n.is_ready = True;
                n.generated_at_loop = 3;
            }
        }

        report {
            "summary": self.summary,
            "limit_reached": True,
            "message": "Maximum follow-up rounds reached. Here is your full case summary to share with an immigration attorney."
        };
    }
}

# ---------------------------------------------------------------------------

walker GetHistory {
    has target_label: str = "all";
    has results: list = [];

    can start with Root entry {
        visit [-->];
    }

    can collect with LegalNode entry {
        if here.label == self.target_label or self.target_label == "all" {
            self.results.append({
                "label": here.label,
                "current_value": here.value,
                "model": here.model,
                "loop_count": here.loop_count,
                "history": here.history
            });
        }
        visit [-->];
    }
}

# ---------------------------------------------------------------------------

walker:pub ResetAll {
    has results: list = [];

    can start with Root entry {
        visit [-->];
    }

    can do_reset with LegalNode entry {
        here.reset();
        self.results.append({"label": here.label, "status": "reset"});
        visit [-->];
    }

    can finish with Root exit {
        report self.results;
    }
}

# ---------------------------------------------------------------------------

walker IngestDocument {
    has content: str = "";
    has source: str = "";
    has topic: str = "";

    can ingest with Root entry {
        chunks = self.chunk_text(self.content);
        for chunk in chunks {
            doc = DocumentChunk(
                content=chunk,
                source=self.source,
                topic=self.topic
            );
            here ++> doc;
        }
        report {"status": "ingested", "chunks": len(chunks)};
    }

    def chunk_text(text: str) -> list {
        words = text.split(" ");
        chunks = [];
        chunk_size = 200;
        i = 0;
        while i < len(words) {
            chunk = " ".join(words[i:i + chunk_size]);
            chunks.append(chunk);
            i += chunk_size;
        }
        return chunks;
    }
}

# ---------------------------------------------------------------------------
# Graph bootstrap
# ---------------------------------------------------------------------------

with entry {
    case_assessment_node = LegalNode(
        label="case_assessment",
        aspect=ImmigrationAspect.CASE_ASSESSMENT
    );
    rights_protections_node = LegalNode(
        label="rights_protections",
        aspect=ImmigrationAspect.RIGHTS_PROTECTIONS
    );
    urgent_steps_node = LegalNode(
        label="urgent_steps",
        aspect=ImmigrationAspect.URGENT_STEPS
    );
    critical_warnings_node = LegalNode(
        label="critical_warnings",
        aspect=ImmigrationAspect.CRITICAL_WARNINGS
    );
    follow_up_questions_node = LegalNode(
        label="follow_up_questions",
        aspect=ImmigrationAspect.FOLLOW_UP_QUESTIONS
    );
    legal_glossary_node = LegalNode(
        label="legal_glossary",
        aspect=ImmigrationAspect.LEGAL_GLOSSARY
    );
    help_contacts_node = LegalNode(
        label="help_contacts",
        aspect=ImmigrationAspect.HELP_CONTACTS
    );
    process_outlook_node = LegalNode(
        label="process_outlook",
        aspect=ImmigrationAspect.PROCESS_OUTLOOK
    );
    case_summary = SummaryNode();

    root ++> case_assessment_node;
    root ++> rights_protections_node;
    root ++> urgent_steps_node;
    root ++> critical_warnings_node;
    root ++> follow_up_questions_node;
    root ++> legal_glossary_node;
    root ++> help_contacts_node;
    root ++> process_outlook_node;
    root ++> case_summary;
}
