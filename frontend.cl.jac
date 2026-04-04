cl def:pub app() -> JsxElement {
    has selectedScenario: str = "ice";
    has selectedLanguage: str = "english";
    has panicMode: bool = False;
    has sessionClosed: bool = False;

    def scenarioTitle(kind: str) -> str {
        if kind == "ice" {
            return "ICE stop, arrest, or raid happening now";
        }
        if kind == "detention" {
            return "Someone is already in detention";
        }
        if kind == "order" {
            return "A deportation order or notice was received";
        }
        if kind == "family" {
            return "A family member was taken and their location is unknown";
        }
        return "Emergency immigration situation";
    }

    def languageLabel(kind: str) -> str {
        if kind == "spanish" {
            return "Español";
        }
        if kind == "french" {
            return "Français";
        }
        if kind == "arabic" {
            return "العربية";
        }
        return "English";
    }

    def translatedUrgentLine(lang: str) -> str {
        if lang == "spanish" {
            return "Mantenga la calma. Guarde silencio. No firme nada sin hablar con un abogado.";
        }
        if lang == "french" {
            return "Restez calme. Gardez le silence. Ne signez rien sans parler à un avocat.";
        }
        if lang == "arabic" {
            return "ابق هادئًا. التزم الصمت. لا توقّع أي شيء قبل التحدث مع محامٍ.";
        }
        return "Stay calm. Remain silent. Do not sign anything without speaking to a lawyer.";
    }

    def step1(kind: str) -> str {
        if kind == "ice" {
            return "Stay calm. You have the right to remain silent. You do not have to answer questions about where you were born or how you entered the U.S.";
        }
        if kind == "detention" {
            return "Tell your loved one: do not sign papers without a lawyer. They can ask to make a phone call.";
        }
        if kind == "order" {
            return "Read the notice carefully and check the deadline immediately. Missing a deadline can make things worse.";
        }
        return "Start with the person’s full name, date of birth, and A-number only if you already have it. Do not share more personal information than needed.";
    }

    def step2(kind: str) -> str {
        if kind == "ice" {
            return "Do not open the door unless officers show a judicial warrant signed by a judge. Ask them to slide it under the door or hold it to a window.";
        }
        if kind == "detention" {
            return "Use the ICE detainee locator and call the detention facility to confirm location and booking details.";
        }
        if kind == "order" {
            return "Do not ignore the order and do not sign any waiver without legal review.";
        }
        return "Check the ICE detainee locator, local jail rosters, and call nearby detention centers and county jails.";
    }

    def step3(kind: str) -> str {
        if kind == "ice" {
            return "Do not sign anything. Ask for a lawyer immediately. If safe, record names, badge numbers, and what happened.";
        }
        if kind == "detention" {
            return "Gather the A-number if available, full legal name, date of birth, and copies of immigration notices already in hand.";
        }
        if kind == "order" {
            return "Collect every court paper, prior applications, and proof of family ties, fear of return, or time in the U.S.";
        }
        return "Contact the person’s consulate if they are foreign-born and ask trusted family members to preserve documents and messages.";
    }

    def step4(kind: str) -> str {
        if kind == "ice" {
            return "Call a trusted person and an immigration legal aid group right away. If someone is detained, ask where they are being taken.";
        }
        if kind == "detention" {
            return "Contact emergency legal help fast and ask about bond, hearing dates, and urgent defense options.";
        }
        if kind == "order" {
            return "Call an immigration attorney or accredited representative now to review motions, appeals, or emergency stays.";
        }
        return "Reach out to emergency legal aid immediately for detention tracing and next legal steps.";
    }

    def chooseIce() -> None { selectedScenario = "ice"; }
    def chooseDetention() -> None { selectedScenario = "detention"; }
    def chooseOrder() -> None { selectedScenario = "order"; }
    def chooseFamily() -> None { selectedScenario = "family"; }

    def setEnglish() -> None { selectedLanguage = "english"; }
    def setSpanish() -> None { selectedLanguage = "spanish"; }
    def setFrench() -> None { selectedLanguage = "french"; }
    def setArabic() -> None { selectedLanguage = "arabic"; }

    def enablePanic() -> None { panicMode = True; }
    def disablePanic() -> None { panicMode = False; }
    def closeSession() -> None { sessionClosed = True; }
    def reopenSession() -> None { sessionClosed = False; }

    if panicMode {
        return (
            <div className="min-h-screen bg-gray-950 text-white">
                <div className="mx-auto flex min-h-screen max-w-3xl flex-col justify-center px-6 py-10">
                    <div className="rounded-3xl border border-red-500/40 bg-red-950/60 p-8 shadow-card">
                        <div className="flex items-center justify-between gap-4">
                            <div>
                                <p className="text-sm font-semibold uppercase tracking-[0.2em] text-red-300">Panic mode</p>
                                <h1 className="mt-2 text-4xl font-extrabold">Critical rights only</h1>
                            </div>
                            <button className="rounded-full border border-white/20 px-4 py-2 text-sm font-semibold transition hover:bg-white/10" onClick={disablePanic}><span>Exit</span></button>
                        </div>
                        <div className="mt-6 rounded-2xl bg-white/5 p-5">
                            <p className="text-2xl font-bold">{translatedUrgentLine(selectedLanguage)}</p>
                            <ul className="mt-5 space-y-3 text-base leading-7 text-red-50">
                                <li>• Ask for a lawyer.</li>
                                <li>• Ask to make a phone call if detained.</li>
                                <li>• Ask to contact your consulate if foreign-born.</li>
                                <li>• If unsafe, move to physical safety first and call 911 for medical or immediate danger.</li>
                            </ul>
                        </div>
                        <div className="mt-6 grid gap-4 sm:grid-cols-2">
                            <div className="rounded-2xl bg-white/5 p-4">
                                <p className="text-sm font-semibold uppercase tracking-[0.2em] text-red-200">Emergency legal help</p>
                                <p className="mt-3 text-sm leading-6">RAICES — raicestexas.org</p>
                                <p className="text-sm leading-6">ACLU Immigrants’ Rights — aclu.org/issues/immigrants-rights</p>
                            </div>
                            <div className="rounded-2xl bg-white/5 p-4">
                                <p className="text-sm font-semibold uppercase tracking-[0.2em] text-red-200">No data stored</p>
                                <p className="mt-3 text-sm leading-6">This stripped-down mode is designed for urgent use and should not retain personal details.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-background text-foreground">
            <section className="border-b border-border bg-gradient-to-b from-red-50 via-orange-50 to-background">
                <div className="mx-auto flex max-w-7xl flex-col gap-10 px-6 py-10 lg:flex-row lg:items-start lg:justify-between lg:px-10">
                    <div className="max-w-3xl">
                        <div className="mb-4 inline-flex items-center rounded-full border border-red-200 bg-white px-4 py-2 text-sm font-semibold text-red-700 shadow-soft">
                            AI emergency legal aid assistant for immigrants
                        </div>
                        <h1 className="max-w-3xl text-4xl font-extrabold tracking-tight text-gray-900 sm:text-5xl lg:text-6xl">
                            Fast, calm help for detention, raids, deportation orders, and family separation.
                        </h1>
                        <p className="mt-5 max-w-2xl text-lg leading-8 text-gray-700">
                            This website gives urgent rights guidance in plain language, routes people to the right crisis tools, and helps families connect with legal support fast. It should not store personal information and it is not a law firm.
                        </p>
                        <div className="mt-8 flex flex-wrap gap-3">
                            <a href="#assistant" className="rounded-full bg-primary px-6 py-3 text-sm font-semibold text-primary-foreground shadow-soft transition hover:bg-primary/90 focus:outline-none focus:ring-2 focus:ring-primary">
                                Open crisis assistant
                            </a>
                            <button className="rounded-full border border-red-300 bg-white px-6 py-3 text-sm font-semibold text-red-700 transition hover:bg-red-50 focus:outline-none focus:ring-2 focus:ring-red-500" onClick={enablePanic}><span>Panic mode</span></button>
                        </div>
                    </div>
                    <div className="w-full max-w-md rounded-3xl border border-red-200 bg-white p-6 shadow-card">
                        <div className="mb-3 text-sm font-semibold uppercase tracking-[0.2em] text-red-700">Critical first reminder</div>
                        <p className="text-2xl font-bold text-gray-900">Do not sign anything without a lawyer.</p>
                        <ul className="mt-5 space-y-3 text-sm leading-6 text-gray-700">
                            <li>• You have the right to remain silent.</li>
                            <li>• You can ask to call a lawyer or trusted person.</li>
                            <li>• If foreign-born, you can ask to contact your consulate.</li>
                            <li>• Many people still have the right to a hearing before an immigration judge.</li>
                        </ul>
                        <div className="mt-5 rounded-2xl bg-amber-50 p-4 text-sm leading-6 text-amber-900">
                            <p className="font-bold">Live language support</p>
                            <p className="mt-1">Current conversation language: {languageLabel(selectedLanguage)}</p>
                        </div>
                    </div>
                </div>
            </section>

            <section id="assistant" className="mx-auto max-w-7xl px-6 py-10 lg:px-10">
                <div className="grid gap-8 lg:grid-cols-[1.1fr_0.9fr]">
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-card sm:p-8">
                        <div className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
                            <div>
                                <p className="text-sm font-semibold uppercase tracking-[0.2em] text-red-700">Emergency response guide</p>
                                <h2 className="mt-2 text-3xl font-bold text-gray-900">{scenarioTitle(selectedScenario)}</h2>
                            </div>
                            <div className="grid grid-cols-2 gap-2 sm:flex sm:flex-wrap">
                                <button className={"rounded-full border border-border px-4 py-2 text-sm font-semibold transition hover:bg-card-hover " + ("bg-primary text-white" if selectedScenario == "ice" else "bg-white text-gray-800")} onClick={chooseIce}><span>ICE now</span></button>
                                <button className={"rounded-full border border-border px-4 py-2 text-sm font-semibold transition hover:bg-card-hover " + ("bg-primary text-white" if selectedScenario == "detention" else "bg-white text-gray-800")} onClick={chooseDetention}><span>Detention</span></button>
                                <button className={"rounded-full border border-border px-4 py-2 text-sm font-semibold transition hover:bg-card-hover " + ("bg-primary text-white" if selectedScenario == "order" else "bg-white text-gray-800")} onClick={chooseOrder}><span>Order</span></button>
                                <button className={"rounded-full border border-border px-4 py-2 text-sm font-semibold transition hover:bg-card-hover " + ("bg-primary text-white" if selectedScenario == "family" else "bg-white text-gray-800")} onClick={chooseFamily}><span>Missing family</span></button>
                            </div>
                        </div>

                        <div className="mt-6 rounded-2xl border border-amber-200 bg-amber-50 p-4 text-amber-900">
                            <p className="text-sm font-semibold uppercase tracking-[0.2em]">Most important first action</p>
                            <p className="mt-2 text-lg font-bold">{translatedUrgentLine(selectedLanguage)}</p>
                        </div>

                        <ol className="mt-6 space-y-4">
                            <li className="flex gap-4 rounded-2xl border border-border bg-orange-50/50 p-4">
                                <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-red-700 text-sm font-bold text-white">1</div>
                                <p className="text-sm leading-6 text-gray-800">{step1(selectedScenario)}</p>
                            </li>
                            <li className="flex gap-4 rounded-2xl border border-border bg-orange-50/50 p-4">
                                <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-red-700 text-sm font-bold text-white">2</div>
                                <p className="text-sm leading-6 text-gray-800">{step2(selectedScenario)}</p>
                            </li>
                            <li className="flex gap-4 rounded-2xl border border-border bg-orange-50/50 p-4">
                                <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-red-700 text-sm font-bold text-white">3</div>
                                <p className="text-sm leading-6 text-gray-800">{step3(selectedScenario)}</p>
                            </li>
                            <li className="flex gap-4 rounded-2xl border border-border bg-orange-50/50 p-4">
                                <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-red-700 text-sm font-bold text-white">4</div>
                                <p className="text-sm leading-6 text-gray-800">{step4(selectedScenario)}</p>
                            </li>
                        </ol>
                    </div>

                    <div className="space-y-6">
                        <div className="rounded-3xl border border-border bg-card p-6 shadow-card">
                            <p className="text-sm font-semibold uppercase tracking-[0.2em] text-blue-700">Real-time language translation</p>
                            <p className="mt-2 text-sm leading-6 text-gray-700">The assistant keeps the full crisis flow in the user’s language, not just the interface.</p>
                            <div className="mt-4 grid grid-cols-2 gap-2">
                                <button className={"rounded-2xl border px-4 py-3 text-sm font-semibold transition " + ("border-blue-600 bg-blue-600 text-white" if selectedLanguage == "english" else "border-border bg-white text-gray-800 hover:bg-card-hover")} onClick={setEnglish}><span>English</span></button>
                                <button className={"rounded-2xl border px-4 py-3 text-sm font-semibold transition " + ("border-blue-600 bg-blue-600 text-white" if selectedLanguage == "spanish" else "border-border bg-white text-gray-800 hover:bg-card-hover")} onClick={setSpanish}><span>Español</span></button>
                                <button className={"rounded-2xl border px-4 py-3 text-sm font-semibold transition " + ("border-blue-600 bg-blue-600 text-white" if selectedLanguage == "french" else "border-border bg-white text-gray-800 hover:bg-card-hover")} onClick={setFrench}><span>Français</span></button>
                                <button className={"rounded-2xl border px-4 py-3 text-sm font-semibold transition " + ("border-blue-600 bg-blue-600 text-white" if selectedLanguage == "arabic" else "border-border bg-white text-gray-800 hover:bg-card-hover")} onClick={setArabic}><span>العربية</span></button>
                            </div>
                            <div className="mt-4 rounded-2xl bg-blue-50 p-4">
                                <p className="text-sm font-semibold uppercase tracking-[0.2em] text-blue-700">Translated urgent message</p>
                                <p className="mt-2 text-base font-semibold text-gray-900">{translatedUrgentLine(selectedLanguage)}</p>
                            </div>
                        </div>

                        <div className="rounded-3xl border border-border bg-card p-6 shadow-card">
                            <p className="text-sm font-semibold uppercase tracking-[0.2em] text-blue-700">Core rights to reinforce</p>
                            <div className="mt-4 space-y-4">
                                <div className="rounded-2xl bg-blue-50 p-4">
                                    <h3 className="font-bold text-gray-900">Right to remain silent</h3>
                                    <p className="mt-1 text-sm leading-6 text-gray-700">You do not have to answer questions about immigration status, birthplace, or how you entered the country.</p>
                                </div>
                                <div className="rounded-2xl bg-red-50 p-4">
                                    <h3 className="font-bold text-gray-900">Right to refuse to sign</h3>
                                    <p className="mt-1 text-sm leading-6 text-gray-700">Do not sign forms, waivers, or departure papers until a lawyer reviews them with you.</p>
                                </div>
                                <div className="rounded-2xl bg-emerald-50 p-4">
                                    <h3 className="font-bold text-gray-900">Right to call for help</h3>
                                    <p className="mt-1 text-sm leading-6 text-gray-700">If detained, ask to make a phone call and ask to contact your consulate if you were born in another country.</p>
                                </div>
                                <div className="rounded-2xl bg-orange-50 p-4">
                                    <h3 className="font-bold text-gray-900">Possible right to a hearing</h3>
                                    <p className="mt-1 text-sm leading-6 text-gray-700">Many people have the right to see an immigration judge before removal. A lawyer can check exceptions and deadlines.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section className="mx-auto max-w-7xl px-6 pb-12 lg:px-10">
                <div className="grid gap-6 md:grid-cols-2 xl:grid-cols-4">
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft">
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-red-700">Crisis triage chatbot</p>
                        <p className="mt-3 text-sm leading-6 text-gray-700">Identifies detention, raids, deportation orders, or family separation and routes the user to the right information immediately.</p>
                    </div>
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft">
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-blue-700">Know your rights explainer</p>
                        <p className="mt-3 text-sm leading-6 text-gray-700">Turns a user’s own words into plain-language rights, urgent steps, and reminders not to sign anything without a lawyer.</p>
                    </div>
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft">
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-orange-700">Document analyzer</p>
                        <p className="mt-3 text-sm leading-6 text-gray-700">Explains ICE notices, court orders, and warrants, including missing details like a judge’s signature and what to do next.</p>
                    </div>
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft">
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-emerald-700">Real-time translation</p>
                        <p className="mt-3 text-sm leading-6 text-gray-700">Keeps the full crisis conversation in the user’s language from intake through legal handoff and phone scripts.</p>
                    </div>
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft">
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-violet-700">What just happened?</p>
                        <p className="mt-3 text-sm leading-6 text-gray-700">Reconstructs a timeline of the encounter and flags possible rights violations for a lawyer to review.</p>
                    </div>
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft">
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-rose-700">Lawyer match &amp; handoff</p>
                        <p className="mt-3 text-sm leading-6 text-gray-700">Creates a structured brief that can be sent quickly to pro bono attorneys and nonprofit legal teams.</p>
                    </div>
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft">
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-cyan-700">Detention locator assistant</p>
                        <p className="mt-3 text-sm leading-6 text-gray-700">Helps families search the ICE detention locator, try spelling variations, and interpret missing or delayed results.</p>
                    </div>
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft">
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-slate-700">Script generator</p>
                        <p className="mt-3 text-sm leading-6 text-gray-700">Creates short scripts for urgent calls to lawyers, detention centers, or consulates using only the facts the family knows.</p>
                    </div>
                </div>

                <div className="mt-6 grid gap-6 md:grid-cols-3">
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft">
                        <h3 className="text-xl font-bold text-gray-900">If someone is physically unsafe</h3>
                        <p className="mt-3 text-sm leading-6 text-gray-700">Move to immediate physical safety first. Call 911 if there is a medical emergency or immediate danger. Legal strategy comes after safety.</p>
                    </div>
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft">
                        <h3 className="text-xl font-bold text-gray-900">Privacy-first support</h3>
                        <p className="mt-3 text-sm leading-6 text-gray-700">This experience should not ask for or store sensitive personal details. Share only what is necessary with a licensed attorney or accredited representative.</p>
                    </div>
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft">
                        <h3 className="text-xl font-bold text-gray-900">Multilingual and plain language</h3>
                        <p className="mt-3 text-sm leading-6 text-gray-700">The assistant should answer in the user’s language, use short sentences, and explain legal terms simply. Specific case strategy must go to a lawyer.</p>
                    </div>
                </div>

                <div className="mt-6 grid gap-6 lg:grid-cols-[1.1fr_0.9fr]">
                    <div className="rounded-3xl border border-border bg-gray-900 p-6 text-white shadow-card">
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-orange-300">Emergency legal contacts</p>
                        <div className="mt-4 grid gap-4 sm:grid-cols-2 text-sm leading-6 text-gray-200">
                            <div>
                                <p className="font-bold text-white">RAICES</p>
                                <p>raicestexas.org</p>
                            </div>
                            <div>
                                <p className="font-bold text-white">ACLU Immigrants’ Rights</p>
                                <p>aclu.org/issues/immigrants-rights</p>
                            </div>
                            <div>
                                <p className="font-bold text-white">National Immigration Legal Services Directory</p>
                                <p>immigrationadvocates.org/nonprofit/legaldirectory</p>
                            </div>
                            <div>
                                <p className="font-bold text-white">CLINIC legal help directory</p>
                                <p>cliniclegal.org/find-legal-help</p>
                            </div>
                        </div>
                    </div>

                    <div className="rounded-3xl border border-border bg-card p-6 shadow-card">
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-green-700">Session auto-erase</p>
                        <p className="mt-2 text-sm leading-6 text-gray-700">At the end of every session, the assistant should clearly confirm that no personal data was retained.</p>
                        <div className="mt-4 rounded-2xl bg-green-50 p-4 text-sm leading-7 text-green-900">
                            {sessionClosed and (<p><span className="font-bold">Session closed.</span> No personal details were retained by this demo flow. For case-specific strategy, contact a licensed immigration attorney or accredited representative now.</p>) or (<p>When the user ends the session, the assistant will confirm that no personal details were retained and remind them to seek licensed legal help for case strategy.</p>)}
                        </div>
                        <div className="mt-4 flex gap-3">
                            <button className="rounded-full bg-green-700 px-5 py-3 text-sm font-semibold text-white transition hover:bg-green-800" onClick={closeSession}><span>End session</span></button>
                            <button className="rounded-full border border-border bg-white px-5 py-3 text-sm font-semibold text-gray-800 transition hover:bg-card-hover" onClick={reopenSession}><span>Reset</span></button>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    );
}
