"""
Legal AI Agentic System - Jac-compatible rewrite.
Uses walker/node/enum graph primitives with correct Jac syntax.
"""

import os;

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
    has model: str = "qwen2.5";
    has loop_count: int = 0;
    has dataset: str = "";
    has is_done: bool = False;
    has final_summary: str = "";

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

    # def get_advice_py(user_situation: str, context: str) -> str {
    #     import requests
    #     import json

    #     url = "http://localhost:11434/api/generate";
        
    #     # --- CUSTOM TASK LOGIC ---
    #     # This ensures 'follow_up_questions' actually generates questions
    #     task_instruction = f"Provide legal guidance for the {self.label} section.";
        
    #     if self.label == "follow_up_questions" {
    #         task_instruction = "Do not provide a summary. Instead, generate a list of 3-5 critical follow-up questions the user should ask an immigration attorney based on their situation.";
    #     }
        
    #     full_prompt = f"Context from USCIS: {context}\n\nUser Situation: {user_situation}\n\nTask: {task_instruction}";

    #     payload = {
    #         "model": self.model,
    #         "prompt": full_prompt,
    #         "stream": False
    #     };

    #     try {
    #         response = requests.post(url, json=payload, timeout=45);
    #         if response.status_code == 200 {
    #             return response.json().get("response", "No response from model.");
    #         } else {
    #             return f"Error: Server returned status {response.status_code}";
    #         }
    #     } except Exception as e {
    #         # This keeps the app from crashing and tells the user exactly what's wrong
    #         return f"Ollama Connection Error. Ensure 'ollama serve' is running and you have downloaded {self.model}.";
    #     }
    # }

    def get_advice_py(user_situation: str, context: str) -> str {
        # Temporarily bypass the network call to test the UI
        return f"MOCK DATA: Analysis for {self.label}. This proves the frontend-to-backend bridge is working!";
    }

    def retrieve_value(prompt: str) -> str {
        context = self.load_context();
        # Calls the Python method which now handles the 'follow_up' logic internally
        new_val = self.get_advice_py(user_situation=prompt, context=context);
        return new_val;
    }

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
        # Updated allowed list to include your local qwen
        allowed = ["qwen2.5", "llama3", "ollama", "gpt-4o", "gemini-1.5-pro"];
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
    }
}

sem LegalNode.get_advice = """You are an immigration legal assistant. Using ONLY the content in the 'context' parameter (a government/legal reference document), provide specific and actionable advice for the user's situation. Cite relevant form numbers, INA statutes, or deadlines from the document. Do not invent information not present in the context.""";

sem LegalNode.get_advice.user_situation = "The user's immigration situation as they described it.";
sem LegalNode.get_advice.context = "A government or legal reference document covering this specific aspect of US immigration law. Ground your answer strictly in this document.";

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

walker:pub AnalyzeSituation {
    has user_input: str = "";
    has results: dict = {};

    can visit_root with Root entry {
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
            "loop_count": here.loop_count
        };

        # visit [-->];
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
            "final_summary": here.final_summary
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
            if n is SummaryNode {
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
                "history": here.get_history()
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
