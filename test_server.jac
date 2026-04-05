include server;

# ---------------------------------------------------------------------------
# Test 1: AnalyzeSituation populates all 8 nodes
# ---------------------------------------------------------------------------

walker TestAnalyzeSituation {
    has test_input: str = "I was arrested by ICE at my door.";
    has passed: bool = False;

    can run with `root entry {
        analyzer = AnalyzeSituation(user_input=self.test_input);
        root spawn analyzer;

        results = analyzer.results;
        expected_keys = [
            "situation_summary", "your_rights", "to_do", "not_to_do",
            "questions", "legal_jargon", "who_can_help", "what_happens_next"
        ];

        all_present = True;
        for key in expected_keys {
            if key not in results {
                all_present = False;
            } elif results[key]["value"] == "" {
                all_present = False;
            }
        }

        self.passed = all_present;
        report {
            "test": "TestAnalyzeSituation",
            "passed": self.passed,
            "result_keys": list(results.keys())
        };
    }
}

# ---------------------------------------------------------------------------
# Test 2: SwitchModel updates the correct node's model
# ---------------------------------------------------------------------------

walker TestSwitchModel {
    has passed: bool = False;

    can run with `root entry {
        switcher = SwitchModel(
            target_label="situation_summary",
            new_model="claude-sonnet-4-6"
        );
        root spawn switcher;

        for n in [-->] {
            if n is LegalNode and n.label == "situation_summary" {
                self.passed = (n.model == "claude-sonnet-4-6");
            }
        }

        report {
            "test": "TestSwitchModel",
            "passed": self.passed
        };
    }
}

# ---------------------------------------------------------------------------
# Test 3: SwitchModel rejects invalid models
# ---------------------------------------------------------------------------

walker TestSwitchModelInvalid {
    has passed: bool = False;

    can run with `root entry {
        switcher = SwitchModel(
            target_label="your_rights",
            new_model="fake-model-xyz"
        );
        root spawn switcher;

        for n in [-->] {
            if n is LegalNode and n.label == "your_rights" {
                self.passed = (n.model != "fake-model-xyz");
            }
        }

        report {
            "test": "TestSwitchModelInvalid",
            "passed": self.passed
        };
    }
}

# ---------------------------------------------------------------------------
# Test 4: ResetAll clears all nodes
# ---------------------------------------------------------------------------

walker TestResetAll {
    has passed: bool = False;

    can run with `root entry {
        # First populate nodes
        analyzer = AnalyzeSituation(user_input="Test input for reset.");
        root spawn analyzer;

        # Then reset
        resetter = ResetAll();
        root spawn resetter;

        # Check all nodes are cleared
        all_reset = True;
        for n in [-->] {
            if n is LegalNode {
                if n.value != "" or n.loop_count != 0 or n.is_ready != False {
                    all_reset = False;
                }
            }
        }

        self.passed = all_reset;
        report {
            "test": "TestResetAll",
            "passed": self.passed
        };
    }
}

# ---------------------------------------------------------------------------
# Test 5: FollowUp accumulates context and updates nodes
# ---------------------------------------------------------------------------

walker TestFollowUp {
    has passed: bool = False;

    can run with `root entry {
        # First analyze
        analyzer = AnalyzeSituation(user_input="ICE is at my door.");
        root spawn analyzer;

        # Then follow up
        followup = FollowUp(
            original_input="ICE is at my door.",
            follow_up_answer="I have a valid visa and no criminal record."
        );
        root spawn followup;

        results = followup.results;
        self.passed = len(results) > 0;

        report {
            "test": "TestFollowUp",
            "passed": self.passed,
            "result_keys": list(results.keys())
        };
    }
}

# ---------------------------------------------------------------------------
# Test 6: FollowUp hits max_loops and triggers Summarize
# ---------------------------------------------------------------------------

walker TestMaxLoops {
    has passed: bool = False;

    can run with `root entry {
        analyzer = AnalyzeSituation(user_input="I need help with my visa.");
        root spawn analyzer;

        i = 0;
        while i < 3 {
            followup = FollowUp(
                original_input="I need help with my visa.",
                follow_up_answer="Answer number " + str(i + 1)
            );
            root spawn followup;
            i += 1;
        }

        self.passed = followup.limit_reached;
        report {
            "test": "TestMaxLoops",
            "passed": self.passed,
            "limit_reached": followup.limit_reached
        };
    }
}

# ---------------------------------------------------------------------------
# Test 7: IngestDocument creates DocumentChunk nodes
# ---------------------------------------------------------------------------

walker TestIngestDocument {
    has passed: bool = False;

    can run with `root entry {
        ingestor = IngestDocument(
            content="You have the right to remain silent. Do not answer questions about your immigration status.",
            source="ACLU Rights Guide",
            topic="detention"
        );
        root spawn ingestor;

        chunk_count = 0;
        for n in [-->] {
            if n is DocumentChunk {
                chunk_count += 1;
            }
        }

        self.passed = (chunk_count > 0);
        report {
            "test": "TestIngestDocument",
            "passed": self.passed,
            "chunk_count": chunk_count
        };
    }
}

# ---------------------------------------------------------------------------
# Run all tests
# ---------------------------------------------------------------------------

with entry {
    print("Running test suite...\n");

    root spawn TestAnalyzeSituation();
    root spawn TestSwitchModel();
    root spawn TestSwitchModelInvalid();
    root spawn TestResetAll();
    root spawn TestFollowUp();
    root spawn TestMaxLoops();
    root spawn TestIngestDocument();

    print("\nAll tests complete.");
}