import ".server";

walker TestAnalyzeSituation {
    has test_input: str = "I was arrested by ICE at my door.";

    can visit with `root entry {
        spawn AnalyzeSituation on root;
        report {"test": "analyze_situation", "input": self.test_input};
    }
}

walker TestSwitchModel {
    can visit with `root entry {
        # Test switching model
        spawn SwitchModel(target_label="situation_summary", new_model="gpt-4o") on root;
        report {"test": "switch_model", "target": "situation_summary", "model": "gpt-4o"};
    }
}

walker TestResetAll {
    can visit with `root entry {
        # Test reset
        spawn ResetAll on root;
        report {"test": "reset_all"};
    }
}

walker TestGetHistory {
    can visit with `root entry {
        # Test get history
        spawn GetHistory(target_label="all") on root;
        report {"test": "get_history"};
    }
}

walker TestIngestDocument {
    can visit with `root entry {
        # Test ingest document
        test_content = "This is a test legal document about immigration rights.";
        spawn IngestDocument(content=test_content, source="test.pdf", topic="immigration") on root;
        report {"test": "ingest", "content_length": len(test_content)};
    }
}

with entry {
    # The server.jac with entry creates the nodes
    # So here we can spawn the test walkers
    spawn TestAnalyzeSituation on root;
    spawn TestSwitchModel on root;
    spawn TestResetAll on root;
    spawn TestGetHistory on root;
    spawn TestIngestDocument on root;
}