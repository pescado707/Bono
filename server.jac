node LegalNode {
    has label: str = "";
    has value: str = "";
    has is_ready: bool = False;
    has history: list = [];
    has model: str = "claude-haiku-4-5-20251001";

    can update_value(new_value: str) -> None {
        self.history.append({
            "previous": self.value,
            "timestamp": "now"
        });
        self.value = new_value;
        self.is_ready = True;
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

    can visit with `root entry {
        for node in [-->] {
            node.update_value(self.get_prompt(node.label));
            self.results[node.label] = {
                "value": node.value,
                "model": node.model,
                "history_count": node.history.length
            };
        }
        report self.results;
    }

    can get_prompt(role: str) -> str {
        prompts = {
            "situation_summary": f"Summarize this legal situation in 2 plain sentences: {self.user_input}",
            "your_rights": f"List the 2-3 most critical legal rights that apply to this situation: {self.user_input}",
            "to_do": f"What is the single most important action to take in the next 60 minutes given this situation: {self.user_input}",
            "not_to_do": f"What is the most dangerous mistake someone could make in this situation and why: {self.user_input}",
            "questions": f"What are the 2 most important follow-up questions needed to give better guidance on: {self.user_input}",
            "legal_jargon": f"Identify and explain in plain language any legal terms relevant to: {self.user_input}",
            "who_can_help": f"What specific type of lawyer or free resource should this person contact given: {self.user_input}",
            "what_happens_next": f"Briefly describe what the legal process typically looks like from this point given: {self.user_input}"
        };
        return prompts[role] if role in prompts else self.user_input;
    }
}

walker GetHistory {
    has target_label: str = "";
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
                "history": here.get_history()
            });
        }
        visit [-->];
    }
}

with entry {
    situation_summary = LegalNode(label="situation_summary");
    your_rights = LegalNode(label="your_rights");
    to_do = LegalNode(label="to_do");
    not_to_do = LegalNode(label="not_to_do");
    questions = LegalNode(label="questions");
    legal_jargon = LegalNode(label="legal_jargon");
    who_can_help = LegalNode(label="who_can_help");
    what_happens_next = LegalNode(label="what_happens_next");

    root ++> situation_summary;
    root ++> your_rights;
    root ++> to_do;
    root ++> not_to_do;
    root ++> questions;
    root ++> legal_jargon;
    root ++> who_can_help;
    root ++> what_happens_next;
}