"""
Legal AI Agentic System - Jac-compatible rewrite.
Uses walker/node/enum graph primitives with correct Jac syntax.
"""

# ---------------------------------------------------------------------------
# Enum
# ---------------------------------------------------------------------------

enum LegalAspect {
    SITUATION_SUMMARY,
    YOUR_RIGHTS,
    TO_DO,
    NOT_TO_DO,
    QUESTIONS,
    LEGAL_JARGON,
    WHO_CAN_HELP,
    WHAT_HAPPENS_NEXT
}

# ---------------------------------------------------------------------------
# Nodes
# ---------------------------------------------------------------------------

node LegalNode {
    has aspect: LegalAspect;
    has label: str = "";
    has value: str = "";
    has is_ready: bool = False;
    has history: list = [];
    has model: str = "claude-haiku-4-5-20251001";
    has loop_count: int = 0;
    has dataset: str = "";
    has is_done: bool = False;
    has final_summary: str = "";

    def retrieve_value(prompt: str) -> str {
        return "Mock legal document content relevant to: " + prompt;
    }

    def generate_summary() -> str {
        self.final_summary = (
            "Final Summary for " + self.label + ":\n\n"
            + "Advice: Based on USCIS guidelines (Section 214 of INA), ensure all documents are submitted.\n\n"
            + "Key Links:\n"
            + "- USCIS H-1B page: uscis.gov/working-in-the-united-states/h-1b\n"
            + "- Cite: INA Section 101(a)(15)(H)(i)\n\n"
            + "Loopholes to check: Verify specialty occupation requirements to avoid denials.\n\n"
            + "Do your own research with these sources."
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
        allowed = [
            "claude-haiku-4-5-20251001",
            "claude-sonnet-4-6",
            "claude-opus-4-6",
            "gpt-4o",
            "gpt-4o-mini",
            "gemini-1.5-pro"
        ];
        if new_model in allowed {
            self.model = new_model;
        }
    }

    def get_history() -> list {
        return self.history;
    }

    def reset() -> None {
        self.history = [];
        self.value = "";
        self.is_ready = False;
        self.loop_count = 0;
        self.is_done = False;
        self.final_summary = "";
    }
}

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

walker SwitchModel {
    has target_label: str = "";
    has new_model: str = "";

    can visit_root with `root entry {
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

walker AnalyzeSituation {
    has user_input: str = "";
    has results: dict = {};
    has retrieved_context: str = "";

    can visit_root with `root entry {
        # Mock RAG context — replace with vectorstore.search when plugin is ready
        self.retrieved_context = (
            "You have the right to remain silent. "
            + "Do not sign anything without a lawyer. "
            + "You can ask to contact your consulate if foreign-born."
        );

        visit [-->];
    }

    can visit_node with LegalNode entry {
        here.reset();
        node_prompt = self.get_node_specific_prompt(here.label);
        here.update_value(node_prompt);

        self.results[here.label] = {
            "value": here.value,
            "model": here.model,
            "is_ready": here.is_ready,
            "loop_count": here.loop_count
        };

        visit [-->];
    }

    can report_results with `root exit {
        report self.results;
    }

    def get_node_specific_prompt(label: str) -> str {
        prompts = {
            "situation_summary": "Summarize the legal urgency of this input.",
            "your_rights": "What constitutional rights apply here?",
            "to_do": "What is the immediate first step?",
            "not_to_do": "What actions should be avoided to prevent self-incrimination?",
            "questions": "What is the single most important follow-up question to better understand the legal risk?",
            "legal_jargon": "Define any complex legal terms found in this scenario.",
            "who_can_help": "List types of organizations or legal aid needed.",
            "what_happens_next": "What is the typical timeline for this legal process?"
        };
        base = prompts.get(label, "");
        return base + " User Input: " + self.user_input + " Context: " + self.retrieved_context;
    }
}

# ---------------------------------------------------------------------------

walker FollowUp {
    has original_input: str = "";
    has follow_up_answer: str = "";
    has accumulated_context: str = "";
    has max_loops: int = 3;
    has results: dict = {};
    has limit_reached: bool = False;
    has node_outputs: dict = {};

    can start with `root entry {
        self.accumulated_context = (
            self.original_input
            + " Additional context from follow-up: "
            + self.follow_up_answer
        );

        for n in [-->] {
            if n is LegalNode {
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

        prompt = self.build_prompt(here.label);
        here.update_value(prompt);

        if here.label == "questions" {
            val_lower = here.value.lower();
            if "no more" in val_lower or "sufficient" in val_lower {
                here.is_done = True;
                here.generate_summary();
            }
        }

        self.results[here.label] = {
            "value": here.value,
            "model": here.model,
            "loop_count": here.loop_count,
            "history_count": len(here.history),
            "limit_reached": False,
            "is_done": here.is_done,
            "final_summary": here.final_summary
        };
        visit [-->];
    }

    can finish with `root exit {
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

    def build_prompt(role: str) -> str {
        ctx = self.accumulated_context;
        if role == "situation_summary" {
            return "Summarize this legal situation in 2 plain sentences, incorporating the latest context: " + ctx;
        } elif role == "your_rights" {
            return "List the 2-3 most critical legal rights that apply, incorporating the latest context: " + ctx;
        } elif role == "to_do" {
            return "Most important action in the next 60 minutes given everything known so far: " + ctx;
        } elif role == "not_to_do" {
            return "Most dangerous mistake to avoid given everything known so far: " + ctx;
        } elif role == "questions" {
            return "What are the 2 most important follow-up questions still needed given: " + ctx;
        } elif role == "legal_jargon" {
            return "Explain any legal terms relevant to: " + ctx;
        } elif role == "who_can_help" {
            return "Who specifically should this person contact given everything known: " + ctx;
        } elif role == "what_happens_next" {
            return "What does the legal process look like from here given: " + ctx;
        } else {
            return ctx;
        }
    }
}

# ---------------------------------------------------------------------------

walker Summarize {
    has node_outputs: dict = {};
    has accumulated_context: str = "";
    has summary: str = "";

    can build_summary with `root entry {
        situation  = self.node_outputs.get("situation_summary", "");
        rights     = self.node_outputs.get("your_rights", "");
        to_do      = self.node_outputs.get("to_do", "");
        not_to_do  = self.node_outputs.get("not_to_do", "");
        who        = self.node_outputs.get("who_can_help", "");
        next_steps = self.node_outputs.get("what_happens_next", "");

        self.summary = (
            "CASE SUMMARY\n\n"
            + "Situation: " + situation + "\n\n"
            + "Your rights: " + rights + "\n\n"
            + "Do this now: " + to_do + "\n\n"
            + "Avoid this: " + not_to_do + "\n\n"
            + "Who to contact: " + who + "\n\n"
            + "What happens next: " + next_steps + "\n\n"
            + "Full context gathered: " + self.accumulated_context
        );

        for n in [-->] {
            if n is SummaryNode {
                n.value = self.summary;
                n.is_ready = True;
                n.generated_at_loop = 3;
            }
        }

        report {
            "summary": self.summary,
            "limit_reached": True,
            "message": "Maximum follow-up rounds reached. Here is your full case summary to share with a lawyer."
        };
    }
}

# ---------------------------------------------------------------------------

walker GetHistory {
    has target_label: str = "all";
    has results: list = [];

    can start with `root entry {
        visit [-->];
    }

    can collect with LegalNode entry {
        if here.label == self.target_label or self.target_label == "all" {
            self.results.append({
                "label": here.label,
                "current_value": here.value,
                "model": here.model,
                "loop_count": here.loop_count,
                "history": here.get_history()
            });
        }
        visit [-->];
    }
}

# ---------------------------------------------------------------------------

walker ResetAll {
    has results: list = [];

    can start with `root entry {
        visit [-->];
    }

    can do_reset with LegalNode entry {
        here.reset();
        self.results.append({"label": here.label, "status": "reset"});
        visit [-->];
    }

    can finish with `root exit {
        report self.results;
    }
}

# ---------------------------------------------------------------------------

walker IngestDocument {
    has content: str = "";
    has source: str = "";
    has topic: str = "";

    can ingest with `root entry {
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
    situation_summary_node = LegalNode(
        label="situation_summary",
        aspect=LegalAspect.SITUATION_SUMMARY
    );
    your_rights_node = LegalNode(
        label="your_rights",
        aspect=LegalAspect.YOUR_RIGHTS
    );
    to_do_node = LegalNode(
        label="to_do",
        aspect=LegalAspect.TO_DO
    );
    not_to_do_node = LegalNode(
        label="not_to_do",
        aspect=LegalAspect.NOT_TO_DO
    );
    questions_node = LegalNode(
        label="questions",
        aspect=LegalAspect.QUESTIONS
    );
    legal_jargon_node = LegalNode(
        label="legal_jargon",
        aspect=LegalAspect.LEGAL_JARGON
    );
    who_can_help_node = LegalNode(
        label="who_can_help",
        aspect=LegalAspect.WHO_CAN_HELP
    );
    what_happens_next_node = LegalNode(
        label="what_happens_next",
        aspect=LegalAspect.WHAT_HAPPENS_NEXT
    );
    case_summary = SummaryNode();

    root ++> situation_summary_node;
    root ++> your_rights_node;
    root ++> to_do_node;
    root ++> not_to_do_node;
    root ++> questions_node;
    root ++> legal_jargon_node;
    root ++> who_can_help_node;
    root ++> what_happens_next_node;
    root ++> case_summary;
}
