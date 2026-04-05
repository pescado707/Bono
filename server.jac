node LegalNode {
    has label: str = "";
    has value: str = "";
    has is_ready: bool = False;
}

walker AnalyzeSituation {
    has user_input: str = "";
    has results: dict = {};

    can visit with `root entry {
        # grab all 8 child nodes and populate each one
        for node in [-->] {
            node.value = self.ask_claude(node.label, self.user_input);
            node.is_ready = True;
            self.results[node.label] = node.value;
        }
        report self.results;
    }

    can ask_claude(role: str, input: str) -> str {
        prompts = {
            "situation_summary": "Summarize this legal situation in 2 plain sentences: ",
            "your_rights": "List the 2-3 most critical legal rights that apply to this situation: ",
            "to_do": "What is the single most important action to take in the next 60 minutes: ",
            "not_to_do": "What is the most dangerous mistake someone could make in this situation and why: ",
            "questions": "What are the 2 most important follow-up questions needed to give better guidance: ",
            "legal_jargon": "Identify and explain in plain language any legal terms in this situation: ",
            "who_can_help": "What specific type of lawyer or resource should this person contact and what should they say: ",
            "what_happens_next": "Briefly describe what the legal process typically looks like from this point forward: "
        };

        prompt = prompts[role] + input if role in prompts else input;

        by llm(
            model="claude",
            temperature=0.3
        );
        return f"Response for {role}: {prompt}";
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