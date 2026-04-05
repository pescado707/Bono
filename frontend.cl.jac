async def run_analysis(user_input: str) -> str {
    return "Your situation was sent to AnalyzeSituation.";
}

def:pub app() -> JsxElement {
    has selectedMode: str = "text";
    has selectedLanguage: str = "english";
    has quietMode: bool = False;
    has autoErase: bool = False;
    has showPrompt: bool = False;
    has textPrompt: str = "";
    has isLoading: bool = False;
    has lastAssistantMessage: str = "Press GO to search for guidance.";

    def modeButtonClass(kind: str) -> str {
        base = "rounded-full border px-4 py-2 text-sm font-semibold transition ";
        if selectedMode == kind {
            return base + "border-emerald-700 bg-emerald-700 text-white";
        }
        return base + "border-emerald-300 bg-white text-emerald-900";
    }

    def languageButtonClass(kind: str) -> str {
        base = "rounded-full border px-4 py-2 text-sm font-semibold transition ";
        if selectedLanguage == kind {
            return base + "border-emerald-700 bg-emerald-700 text-white";
        }
        return base + "border-emerald-300 bg-white text-emerald-900";
    }

    def panelClass() -> str {
        if showPrompt {
            return "mt-8 rounded-3xl border border-emerald-200 bg-white p-5 shadow-sm";
        }
        return "hidden";
    }

    def quietBannerClass() -> str {
        if quietMode {
            return "mt-6 rounded-3xl border border-emerald-300 bg-emerald-50 p-4 text-sm text-emerald-900";
        }
        return "hidden";
    }

    def autoEraseClass() -> str {
        if autoErase {
            return "rounded-full bg-emerald-700 px-4 py-2 text-sm font-semibold text-white";
        }
        return "rounded-full border border-emerald-300 bg-white px-4 py-2 text-sm font-semibold text-emerald-900";
    }

    def statusText() -> str {
        if isLoading {
            return "Analyzing...";
        }
        return lastAssistantMessage;
    }

    def selectText() -> None { selectedMode = "text"; }
    def selectMic() -> None { selectedMode = "mic"; }
    def selectWritten() -> None { selectedMode = "written"; }
    def selectEnglish() -> None { selectedLanguage = "english"; }
    def selectChinese() -> None { selectedLanguage = "chinese"; }
    def enableQuietMode() -> None { quietMode = True; }
    def disableQuietMode() -> None { quietMode = False; }
    def toggleAutoErase() -> None { autoErase = not autoErase; }
    def closePrompt() -> None { showPrompt = False; }
    def updatePrompt(e: any) -> None { textPrompt = e.target.value; }

    def goAction() -> None {
        if selectedMode == "text" {
            showPrompt = True;
            return;
        }
        lastAssistantMessage = "AnalyzeSituation is ready for " + selectedMode + " mode.";
    }

    async def submitPrompt() -> None {
        if not textPrompt.strip() {
            return;
        }
        isLoading = True;
        lastAssistantMessage = "Analyzing your situation...";
        lastAssistantMessage = await run_analysis(textPrompt);
        showPrompt = False;
        textPrompt = "";
        isLoading = False;
    }

    return (
        <div className="min-h-screen bg-emerald-50 text-emerald-950">
            <div className="mx-auto max-w-5xl px-6 py-6">
                <div className="flex items-start justify-between gap-4">
                    <div className="flex flex-wrap gap-2">
                        <button className={modeButtonClass("text")} onClick={selectText}>Text</button>
                        <button className={modeButtonClass("mic")} onClick={selectMic}>Mic</button>
                        <button className={modeButtonClass("written")} onClick={selectWritten}>Written</button>
                    </div>
                    <div className="flex flex-wrap gap-2">
                        <button className={languageButtonClass("english")} onClick={selectEnglish}>English</button>
                        <button className={languageButtonClass("chinese")} onClick={selectChinese}>中文</button>
                    </div>
                </div>

                <div className="mt-6 flex flex-wrap gap-3">
                    <button className="rounded-full border border-emerald-300 bg-white px-4 py-2 text-sm font-semibold text-emerald-900" onClick={enableQuietMode}>Quiet Mode</button>
                    <button className="rounded-full border border-emerald-300 bg-white px-4 py-2 text-sm font-semibold text-emerald-900" onClick={disableQuietMode}>Normal Mode</button>
                    <button className={autoEraseClass()} onClick={toggleAutoErase}>Auto-erase</button>
                </div>

                <div className={quietBannerClass()}>
                    Quiet Mode is active. Press Enter to close the tab immediately if needed.
                </div>

                <div className="mt-10 flex justify-center">
                    <div className="flex h-80 w-80 items-center justify-center rounded-full border-8 border-emerald-200 bg-white shadow-xl">
                        <button className="flex h-64 w-64 items-center justify-center rounded-full bg-emerald-700 text-6xl font-black uppercase tracking-wide text-white" onClick={goAction}>GO</button>
                    </div>
                </div>

                <div className={panelClass()}>
                    <p className="text-sm font-semibold uppercase tracking-wide text-emerald-700">Text prompt</p>
                    <textarea className="mt-3 min-h-32 w-full rounded-2xl border border-emerald-200 p-4 text-base text-emerald-950" value={textPrompt} onChange={updatePrompt} />
                    <div className="mt-4 flex gap-3">
                        <button className="rounded-full bg-emerald-700 px-5 py-2 text-sm font-semibold text-white" onClick={submitPrompt}>Send to AnalyzeSituation</button>
                        <button className="rounded-full border border-emerald-300 bg-white px-5 py-2 text-sm font-semibold text-emerald-900" onClick={closePrompt}>Cancel</button>
                    </div>
                </div>

                <div className="mt-8 rounded-3xl border border-emerald-200 bg-white p-5 shadow-sm">
                    <p className="text-sm font-semibold uppercase tracking-wide text-emerald-700">Status</p>
                    <p className="mt-3 text-base text-emerald-950">{statusText()}</p>
                </div>
            </div>
        </div>
    );
}
