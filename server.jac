from llama_index.core import VectorStoreIndex, SimpleDirectoryReader

enum LegalAspect {
    situation_summary,
    your_rights,
    to_do,
    not_to_do,
    questions,
    legal_jargon,
    who_can_help,
    what_happens_next
}

node LegalNode {
    has label: str = "";
    has aspect: LegalAspect;
    has value: str = "";
    has is_ready: bool = False;
    has history: list = [];
    has model: str = "claude-haiku-4-5-20251001";
    has loop_count: int = 0;
    has dataset: str = "";

    can retrieve_value(prompt: str) -> str {
        search_params = {"query": prompt, "top_k": 5};
        if self.dataset {
            search_params["filter"] = {"topic": self.dataset};
        }
        relevant_chunks = vectorstore.search(**search_params);

        context = "";
        for chunk in relevant_chunks {
            context += chunk.content + "\n\n";
        }
        return context;
    }

    can update_value(new_value: str) -> None {
        self.history.append({
            "previous": self.value,
            "timestamp": "now"
        });
        self.value = new_value;
        self.is_ready = True;
        self.loop_count += 1;
    }

    can switch_model(new_model: str) -> None {
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

    can get_history() -> list {
        return self.history;
    }

    can reset() -> None {
        self.history = [];
        self.value = "";
        self.is_ready = False;
        self.loop_count = 0;
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
    has embedding: list = [];
}

walker SwitchModel {
    has target_label: str = "";
    has new_model: str = "";

    can visit with `root entry {
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

walker AnalyzeSituation {
    has user_input: str = "";
    has results: dict = {};
    has retrieved_context: str = "";
    has relevant_aspects: list = [];

    can visit with `root entry {
        # Determine relevant aspects based on user input
        if "arrest" in self.user_input.lower() or "raid" in self.user_input.lower() or "ice" in self.user_input.lower() or "door" in self.user_input.lower() {
            self.relevant_aspects = [LegalAspect.situation_summary, LegalAspect.your_rights, LegalAspect.to_do, LegalAspect.not_to_do, LegalAspect.who_can_help];
        } elif "detention" in self.user_input.lower() or "jail" in self.user_input.lower() {
            self.relevant_aspects = [LegalAspect.situation_summary, LegalAspect.your_rights, LegalAspect.to_do, LegalAspect.questions, LegalAspect.who_can_help, LegalAspect.what_happens_next];
        } elif "order" in self.user_input.lower() or "deport" in self.user_input.lower() or "notice" in self.user_input.lower() {
            self.relevant_aspects = [LegalAspect.situation_summary, LegalAspect.your_rights, LegalAspect.to_do, LegalAspect.not_to_do, LegalAspect.questions, LegalAspect.what_happens_next];
        } elif "family" in self.user_input.lower() or "missing" in self.user_input.lower() {
            self.relevant_aspects = [LegalAspect.situation_summary, LegalAspect.questions, LegalAspect.who_can_help, LegalAspect.what_happens_next];
        } else {
            self.relevant_aspects = [LegalAspect.situation_summary, LegalAspect.questions];
        }

        relevant_chunks = vectorstore.search(
            query=self.user_input,
            top_k=3
        );

        self.retrieved_context = "";
        for chunk in relevant_chunks {
            self.retrieved_context += chunk.content + "\n\n";
        }

        visit [-->] by (here.aspect in self.relevant_aspects);
        report self.results;
    }

    can visit with LegalNode entry {
        here.reset();
        here.update_value(self.get_prompt(here.label));
        self.results[here.label] = {
            "value": here.value,
            "model": here.model,
            "loop_count": here.loop_count,
            "sources": []  # relevant_chunks from entry
        };
        visit [-->];
    }
}

walker FollowUp {
    has original_input: str = "";
    has follow_up_answer: str = "";
    has accumulated_context: str = "";
    has max_loops: int = 3;
    has results: dict = {};
    has limit_reached: bool = False;
    has node_outputs: dict = {};

    can visit with `root entry {
        self.accumulated_context = self.original_input
            + " Additional context from follow-up: "
            + self.follow_up_answer;

        for node in [-->] {
            if node is LegalNode {
                self.node_outputs[node.label] = node.value;
            }
        }

        visit [-->];

        if self.limit_reached {
            spawn Summarize(node_outputs=self.node_outputs, accumulated_context=self.accumulated_context) on here;
        }
    }

    can collect with LegalNode entry {
        if here.loop_count >= self.max_loops {
            self.limit_reached = True;
            self.node_outputs[here.label] = here.value;
            visit [-->];
            return;
        }

        here.update_value(self.get_prompt(here.label));
        self.results[here.label] = {
            "value": here.value,
            "model": here.model,
            "loop_count": here.loop_count,
            "history_count": here.history.length,
            "limit_reached": False
        };
        visit [-->];
    }

    can get_prompt(role: str) -> str {
        prompts = {
            "situation_summary": f"Summarize this legal situation in 2 plain sentences, incorporating the latest context: {self.accumulated_context}",
            "your_rights": f"List the 2-3 most critical legal rights that apply, incorporating the latest context: {self.accumulated_context}",
            "to_do": f"Most important action in the next 60 minutes given everything known so far: {self.accumulated_context}",
            "not_to_do": f"Most dangerous mistake to avoid given everything known so far: {self.accumulated_context}",
            "questions": f"What are the 2 most important follow-up questions still needed given: {self.accumulated_context}",
            "legal_jargon": f"Explain any legal terms relevant to: {self.accumulated_context}",
            "who_can_help": f"Who specifically should this person contact given everything known: {self.accumulated_context}",
            "what_happens_next": f"What does the legal process look like from here given: {self.accumulated_context}"
        };
        return prompts[role] if role in prompts else self.accumulated_context;
    }
}

walker Summarize {
    has node_outputs: dict = {};
    has accumulated_context: str = "";
    has summary: str = "";

    can visit with `root entry {
        situation = self.node_outputs.get("situation_summary", "");
        rights = self.node_outputs.get("your_rights", "");
        to_do = self.node_outputs.get("to_do", "");
        not_to_do = self.node_outputs.get("not_to_do", "");
        who = self.node_outputs.get("who_can_help", "");
        next_steps = self.node_outputs.get("what_happens_next", "");

        self.summary = "CASE SUMMARY\n\n"
            + "Situation: " + situation + "\n\n"
            + "Your rights: " + rights + "\n\n"
            + "Do this now: " + to_do + "\n\n"
            + "Avoid this: " + not_to_do + "\n\n"
            + "Who to contact: " + who + "\n\n"
            + "What happens next: " + next_steps + "\n\n"
            + "Full context gathered: " + self.accumulated_context;

        for node in [-->] {
            if node is SummaryNode {
                node.value = self.summary;
                node.is_ready = True;
                node.generated_at_loop = 3;
            }
        }

        report {
            "summary": self.summary,
            "limit_reached": True,
            "message": "Maximum follow-up rounds reached. Here is your full case summary to share with a lawyer."
        };
    }
}

walker GetHistory {
    has target_label: str = "all";
    has results: list = [];

    can visit with `root entry {
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

walker ResetAll {
    can visit with `root entry {
        visit [-->];
    }

    can reset with LegalNode entry {
        here.reset();
        report {"label": here.label, "status": "reset"};
        visit [-->];
    }
}

walker IngestDocument {
    has content: str = "";
    has source: str = "";
    has topic: str = "";

    can visit with `root entry {
        chunks = self.chunk_text(self.content);

        for chunk in chunks {
            doc = DocumentChunk(
                content=chunk,
                source=self.source,
                topic=self.topic
            );
            root ++> doc;
            vectorstore.add(
                text=chunk,
                metadata={"source": self.source, "topic": self.topic}
            );
        }
        report {"status": "ingested", "chunks": chunks.length};
    }

    can chunk_text(text: str) -> list {
        words = text.split(" ");
        chunks = [];
        chunk_size = 200;
        i = 0;
        while i < words.length {
            chunk = words[i:i+chunk_size].join(" ");
            chunks.append(chunk);
            i += chunk_size;
        }
        return chunks;
    }
}

with entry {
    situation_summary = LegalNode(label="situation_summary", aspect=LegalAspect.situation_summary);
    your_rights = LegalNode(label="your_rights", aspect=LegalAspect.your_rights);
    to_do = LegalNode(label="to_do", aspect=LegalAspect.to_do);
    not_to_do = LegalNode(label="not_to_do", aspect=LegalAspect.not_to_do);
    questions = LegalNode(label="questions", aspect=LegalAspect.questions);
    legal_jargon = LegalNode(label="legal_jargon", aspect=LegalAspect.legal_jargon);
    who_can_help = LegalNode(label="who_can_help", aspect=LegalAspect.who_can_help);
    what_happens_next = LegalNode(label="what_happens_next", aspect=LegalAspect.what_happens_next);
    case_summary = SummaryNode();

    root ++> situation_summary;
    root ++> your_rights;
    root ++> to_do;
    root ++> not_to_do;
    root ++> questions;
    root ++> legal_jargon;
    root ++> who_can_help;
    root ++> what_happens_next;
    root ++> case_summary;
}