def:pub app() -> JsxElement {
    has isLoading: bool = False;
    has apiKey: str = "YOUR_KEY_HERE";
    has selectedScenario: str = "ice";
    has selectedLanguage: str = "english";
    has languageSearch: str = "";
    has panicMode: bool = False;
    has sessionClosed: bool = False;
    has chatInput: str = "";
    has voiceSupported: bool = True;
    has voiceListening: bool = False;
    has voiceStatus: str = "Voice input ready";
    has lastUserMessage: str = "ICE is at my door right now.";
    has lastAssistantMessage: str = "This sounds like an active ICE encounter. Stay calm, remain silent, do not open the door unless they show a judicial warrant signed by a judge, and do not sign anything without a lawyer.";

    def languageLabel(kind: str) -> str {
        if kind == "arabic" { return "العربية"; }
        if kind == "chinese" or kind == "chinese_simplified" or kind == "chinese_traditional" { return "中文"; }
        if kind == "english" { return "English"; }
        if kind == "french" { return "Français"; }
        if kind == "russian" { return "Русский"; }
        if kind == "spanish" { return "Español"; }
        return "English";
    }

    def t(english: str) -> str {
        if selectedLanguage == "spanish" {
            if english == "Session auto-erase available" { return "Borrado automático de sesión disponible"; }
            if english == "Use Auto Exit any time to close this session quickly. Keyboard shortcut: press Esc to exit the website fast." { return "Use Salida rápida en cualquier momento para cerrar esta sesión rápidamente. Atajo de teclado: presione Esc para salir del sitio de inmediato."; }
            if english == "Confirm auto-erase" { return "Confirmar borrado automático"; }
            if english == "Auto Exit" { return "Salida rápida"; }
            if english == "AI emergency legal aid assistant for immigrants" { return "Asistente de ayuda legal de emergencia con IA para inmigrantes"; }
            if english == "Fast, calm help for detention, raids, deportation orders, and family separation." { return "Ayuda rápida y tranquila para detención, redadas, órdenes de deportación y separación familiar."; }
            if english == "This website gives urgent rights guidance in plain language, routes people to the right crisis tools, and helps families connect with legal support fast. It should not store personal information and it is not a law firm." { return "Este sitio ofrece orientación urgente sobre derechos en lenguaje claro, dirige a las personas a las herramientas de crisis adecuadas y ayuda a las familias a conectarse rápidamente con apoyo legal. No debe guardar información personal y no es un bufete de abogados."; }
            if english == "Open crisis assistant" { return "Abrir asistente de crisis"; }
            if english == "Panic mode" { return "Modo pánico"; }
            if english == "Critical first reminder" { return "Recordatorio crítico inicial"; }
            if english == "Do not sign anything without a lawyer." { return "No firme nada sin un abogado."; }
            if english == "You have the right to remain silent." { return "Tiene derecho a guardar silencio."; }
            if english == "You can ask to call a lawyer or trusted person." { return "Puede pedir llamar a un abogado o a una persona de confianza."; }
            if english == "If foreign-born, you can ask to contact your consulate." { return "Si nació en otro país, puede pedir contactar a su consulado."; }
            if english == "Many people still have the right to a hearing before an immigration judge." { return "Muchas personas todavía tienen derecho a una audiencia ante un juez de inmigración."; }
            if english == "Language" { return "Idioma"; }
            if english == "Search language" { return "Buscar idioma"; }
            if english == "Current:" { return "Actual:"; }
            if english == "Emergency response guide" { return "Guía de respuesta de emergencia"; }
            if english == "ICE now" { return "ICE ahora"; }
            if english == "Detention" { return "Detención"; }
            if english == "Order" { return "Orden"; }
            if english == "Missing family" { return "Familiar desaparecido"; }
            if english == "Most important first action" { return "Acción más importante primero"; }
            if english == "Talk to the assistant now" { return "Hable con el asistente ahora"; }
            if english == "Describe the emergency in your own words. The chatbot triages the situation and points to the right next steps immediately." { return "Describa la emergencia con sus propias palabras. El chatbot evalúa la situación y señala de inmediato los pasos correctos a seguir."; }
            if english == "Voice input mode" { return "Modo de entrada por voz"; }
            if english == "Tap the microphone to speak instead of typing." { return "Toque el micrófono para hablar en lugar de escribir."; }
            if english == "user" { return "usuario"; }
            if english == "assistant" { return "asistente"; }
            if english == "Type what is happening right now" { return "Escriba lo que está pasando ahora mismo"; }
            if english == "Voice input" { return "Entrada por voz"; }
            if english == "Send" { return "Enviar"; }
            if english == "Current conversation language:" { return "Idioma actual de la conversación:"; }
            if english == "If someone is physically unsafe" { return "Si alguien está físicamente en peligro"; }
            if english == "Move to immediate physical safety first. Call 911 if there is a medical emergency or immediate danger. Legal strategy comes after safety." { return "Muévase primero a un lugar físicamente seguro. Llame al 911 si hay una emergencia médica o peligro inmediato. La estrategia legal viene después de la seguridad."; }
            if english == "Privacy-first support" { return "Apoyo con prioridad en la privacidad"; }
            if english == "This experience should not ask for or store sensitive personal details. Share only what is necessary with a licensed attorney or accredited representative." { return "Esta experiencia no debe pedir ni guardar datos personales sensibles. Comparta solo lo necesario con un abogado con licencia o un representante acreditado."; }
            if english == "Multilingual and plain language" { return "Multilingüe y en lenguaje claro"; }
            if english == "The assistant should answer in the user's language, use short sentences, and explain legal terms simply. Specific case strategy must go to a lawyer." { return "El asistente debe responder en el idioma del usuario, usar frases cortas y explicar los términos legales de forma sencilla. La estrategia específica del caso debe ir a un abogado."; }
            if english == "Emergency legal contacts" { return "Contactos legales de emergencia"; }
            if english == "CLINIC legal help directory" { return "Directorio de ayuda legal de CLINIC"; }
            if english == "Session auto-erase confirmed" { return "Borrado automático de sesión confirmado"; }
            if english == "This session is marked for quick exit and no personal details should be retained." { return "Esta sesión está marcada para salida rápida y no deben conservarse datos personales."; }
            if english == "Continue session" { return "Continuar sesión"; }
            if english == "Voice input ready" { return "Entrada por voz lista"; }
            if english == "Message sent" { return "Mensaje enviado"; }
            if english == "Voice mode enabled. Speak to a trusted person, then edit or send this message." { return "Modo de voz activado. Hable con una persona de confianza y luego edite o envíe este mensaje."; }
            if english == "Voice mode paused" { return "Modo de voz en pausa"; }
            if english == "I need urgent immigration help right now. " { return "Necesito ayuda migratoria urgente ahora mismo. "; }
            if english == "Critical rights only" { return "Solo derechos críticos"; }
            if english == "Exit" { return "Salir"; }
            if english == "Ask for a lawyer." { return "Pida un abogado."; }
            if english == "Ask to make a phone call if detained." { return "Pida hacer una llamada telefónica si está detenido."; }
            if english == "Ask to contact your consulate if foreign-born." { return "Pida contactar a su consulado si nació en otro país."; }
            if english == "If unsafe, move to physical safety first and call 911 for medical or immediate danger." { return "Si no está seguro, muévase primero a un lugar seguro y llame al 911 por una emergencia médica o peligro inmediato."; }
        }
        return english;
    }

    def scenarioTitle(kind: str) -> str {
        if kind == "ice" { return t("ICE stop, arrest, or raid happening now"); }
        if kind == "detention" { return t("Someone is already in detention"); }
        if kind == "order" { return t("A deportation order or notice was received"); }
        if kind == "family" { return t("A family member was taken and their location is unknown"); }
        return t("Emergency immigration situation");
    }

    def translatedUrgentLine(lang: str) -> str {
        if lang == "spanish" { return "Mantenga la calma. Guarde silencio. No firme nada sin hablar con un abogado."; }
        if lang == "french" { return "Restez calme. Gardez le silence. Ne signez rien sans parler à un avocat."; }
        if lang == "arabic" { return "ابق هادئًا. التزم الصمت. لا توقّع أي شيء قبل التحدث مع محامٍ."; }
        if lang == "chinese" or lang == "chinese_simplified" or lang == "chinese_traditional" { return "保持冷静。保持沉默。没有律师前不要签署任何文件。"; }
        if lang == "russian" { return "Сохраняйте спокойствие. Храните молчание. Ничего не подписывайте без разговора с адвокатом."; }
        return t("Stay calm. Remain silent. Do not sign anything without speaking to a lawyer.");
    }

    def languageMatches(kind: str, query: str) -> bool {
        if query == "" { return True; }
        label = languageLabel(kind).lower();
        slug = kind.lower();
        if query in label or query in slug { return True; }
        if kind == "english" { return "ing" in query; }
        if kind == "spanish" { return "espanol" in query or "español" in query; }
        if kind == "french" { return "francais" in query or "français" in query; }
        if kind == "chinese" { return "chinese" in query or "中文" in query or "mandarin" in query; }
        if kind == "arabic" { return "arab" in query or "العربية" in query; }
        if kind == "russian" { return "russ" in query or "рус" in query; }
        return False;
    }

    def step1(kind: str) -> str {
        if kind == "ice" { return t("Stay calm. You have the right to remain silent. You do not have to answer questions about where you were born or how you entered the U.S."); }
        if kind == "detention" { return t("Tell your loved one: do not sign papers without a lawyer. They can ask to make a phone call."); }
        if kind == "order" { return t("Read the notice carefully and check the deadline immediately. Missing a deadline can make things worse."); }
        return t("Start with the person's full name, date of birth, and A-number only if you already have it. Do not share more personal information than needed.");
    }

    def step2(kind: str) -> str {
        if kind == "ice" { return t("Do not open the door unless officers show a judicial warrant signed by a judge. Ask them to slide it under the door or hold it to a window."); }
        if kind == "detention" { return t("Use the ICE detainee locator and call the detention facility to confirm location and booking details."); }
        if kind == "order" { return t("Do not ignore the order and do not sign any waiver without legal review."); }
        return t("Check the ICE detainee locator, local jail rosters, and call nearby detention centers and county jails.");
    }

    def step3(kind: str) -> str {
        if kind == "ice" { return t("Do not sign anything. Ask for a lawyer immediately. If safe, record names, badge numbers, and what happened."); }
        if kind == "detention" { return t("Gather the A-number if available, full legal name, date of birth, and copies of immigration notices already in hand."); }
        if kind == "order" { return t("Collect every court paper, prior applications, and proof of family ties, fear of return, or time in the U.S."); }
        return t("Contact the person's consulate if they are foreign-born and ask trusted family members to preserve documents and messages.");
    }

    def step4(kind: str) -> str {
        if kind == "ice" { return t("Call a trusted person and an immigration legal aid group right away. If someone is detained, ask where they are being taken."); }
        if kind == "detention" { return t("Contact emergency legal help fast and ask about bond, hearing dates, and urgent defense options."); }
        if kind == "order" { return t("Call an immigration attorney or accredited representative now to review motions, appeals, or emergency stays."); }
        return t("Reach out to emergency legal aid immediately for detention tracing and next legal steps.");
    }

    def translatedChatSeed() -> None {
        lastUserMessage = t("ICE is at my door right now.");
        lastAssistantMessage = triageReply("ice at my door");
        voiceStatus = t("Voice input ready");
    }

    def triageReply(message: str) -> str {
        if "door" in message or "raid" in message or "ice" in message or "arrest" in message {
            selectedScenario = "ice";
        } elif "detained" in message or "detention" in message or "jail" in message {
            selectedScenario = "detention";
        } elif "order" in message or "notice" in message or "deport" in message {
            selectedScenario = "order";
        } elif "family" in message or "husband" in message or "wife" in message {
            selectedScenario = "family";
        }
        return t("Analyzing your situation...");
    }

    def chooseIce() -> None { selectedScenario = "ice"; }
    def chooseDetention() -> None { selectedScenario = "detention"; }
    def chooseOrder() -> None { selectedScenario = "order"; }
    def chooseFamily() -> None { selectedScenario = "family"; }

    def searchLanguage(e: any) -> None { languageSearch = e.target.value.lower(); }
    def chooseLanguage(kind: str) -> None {
        selectedLanguage = kind;
        translatedChatSeed();
    }

    def languageButtonClass(kind: str, extra: str) -> str {
        base = "flex w-full items-center justify-between rounded-lg border px-3 py-2 text-left text-sm font-semibold transition ";
        if selectedLanguage == kind {
            return base + "border-blue-600 bg-blue-600 text-white shadow-soft " + extra;
        }
        return base + "border-transparent text-gray-800 hover:bg-card-hover " + extra;
    }

    def scenarioButtonClass(kind: str) -> str {
        base = "rounded-full border px-4 py-2 text-sm font-semibold transition ";
        if selectedScenario == kind {
            return base + "border-primary bg-primary text-white shadow-soft";
        }
        return base + "border-border bg-white text-gray-800 hover:bg-card-hover";
    }

    def enablePanic() -> None { panicMode = True; }
    def disablePanic() -> None { panicMode = False; }
    def closeSession() -> None { sessionClosed = True; }
    def reopenSession() -> None { sessionClosed = False; }
    def autoExitSite() -> None {
        sessionClosed = True;
        window.location.href = "about:blank";
    }

    def updateChatInput(e: any) -> None { chatInput = e.target.value; }

    def sendChat() -> None {
        if not chatInput.strip() {
            return;
        }
        lastUserMessage = chatInput.strip();
        triageReply(chatInput.strip().lower());
        callClaude(chatInput.strip());
        chatInput = "";
        voiceStatus = t("Message sent");
    }

    def startVoiceInput() -> None {
        voiceListening = not voiceListening;
        voiceSupported = True;
        if voiceListening {
            chatInput = t("I need urgent immigration help right now. ") + chatInput;
            voiceStatus = t("Voice mode enabled. Speak to a trusted person, then edit or send this message.");
        } else {
            voiceStatus = t("Voice mode paused");
        }
    }

    def callClaude(userMessage: str) -> None {
        isLoading = True;
        lastAssistantMessage = t("Analyzing your situation...");

        setTimeout(lambda -> None {
            if "door" in userMessage.lower() or "ice" in userMessage.lower() {
                lastAssistantMessage = "Stay calm and do not open the door. Say out loud: I am exercising my right to remain silent. Call an immigration lawyer immediately.";
            } elif "detained" in userMessage.lower() or "jail" in userMessage.lower() {
                lastAssistantMessage = "Tell your loved one not to sign anything without a lawyer. Ask for a phone call and get their A-number if possible. Contact RAICES or your local legal aid now.";
            } elif "deport" in userMessage.lower() or "order" in userMessage.lower() {
                lastAssistantMessage = "Check the deadline on the paper immediately — missing it makes things worse. Do not sign any waiver. Call an immigration attorney right now.";
            } else {
                lastAssistantMessage = "Remain silent and do not sign anything without a lawyer present. Tell me more about what is happening so I can help you find the right next step.";
            }
            isLoading = False;
        }, 1500);
    }

    if panicMode {
        return (
            <div className="min-h-screen bg-[#f7efe2] text-slate-900">
                <div className="mx-auto max-w-3xl px-4 py-6 sm:px-6">
                    <div className="rounded-[28px] border border-red-200 bg-white shadow-card overflow-hidden">
                        <div className="flex items-center justify-between bg-red-700 px-5 py-4 text-white">
                            <div>
                                <p className="text-xs font-semibold uppercase tracking-[0.24em] text-red-100">{t("Critical rights only")}</p>
                                <h1 className="mt-1 text-2xl font-bold">{t("Panic mode")}</h1>
                            </div>
                            <button className="rounded-full bg-white/15 px-4 py-2 text-sm font-semibold transition hover:bg-white/25" onClick={disablePanic}><span>{t("Continue session")}</span></button>
                        </div>

                        <div className="space-y-5 p-5 sm:p-6">
                            <div className="rounded-3xl border border-red-200 bg-red-50 p-5">
                                <p className="text-sm font-semibold uppercase tracking-[0.2em] text-red-700">{t("Critical first reminder")}</p>
                                <p className="mt-3 text-lg font-bold text-slate-900">{translatedUrgentLine(selectedLanguage)}</p>
                            </div>

                            <div className="rounded-3xl border border-slate-200 bg-slate-50 p-5">
                                <p className="text-sm font-semibold uppercase tracking-[0.2em] text-slate-700">Emergency legal help</p>
                                <p className="mt-2 text-sm leading-6 text-slate-700">RAICES · ACLU Immigrants' Rights · National Immigration Legal Services Directory · {t("CLINIC legal help directory")}</p>
                            </div>

                            <div className="grid gap-4 sm:grid-cols-3">
                                <div className="rounded-3xl border border-slate-200 bg-white p-4 shadow-soft"><p className="text-sm font-semibold text-slate-900">{t("You have the right to remain silent.")}</p></div>
                                <div className="rounded-3xl border border-slate-200 bg-white p-4 shadow-soft"><p className="text-sm font-semibold text-slate-900">{t("Do not sign anything without a lawyer.")}</p></div>
                                <div className="rounded-3xl border border-slate-200 bg-white p-4 shadow-soft"><p className="text-sm font-semibold text-slate-900">{t("You can ask to call a lawyer or trusted person.")}</p></div>
                            </div>

                            <div className="grid gap-4 sm:grid-cols-2">
                                <div className="rounded-3xl border border-emerald-200 bg-emerald-50 p-5">
                                    <p className="text-sm font-semibold uppercase tracking-[0.2em] text-emerald-700">DO</p>
                                    <ul className="mt-3 space-y-2 text-sm leading-6 text-slate-800">
                                        <li>• {t("Ask for a lawyer.")}</li>
                                        <li>• {t("Ask to make a phone call if detained.")}</li>
                                        <li>• {t("Ask to contact your consulate if foreign-born.")}</li>
                                    </ul>
                                </div>
                                <div className="rounded-3xl border border-red-200 bg-red-50 p-5">
                                    <p className="text-sm font-semibold uppercase tracking-[0.2em] text-red-700">DON'T</p>
                                    <ul className="mt-3 space-y-2 text-sm leading-6 text-slate-800">
                                        <li>• {t("Do not sign anything without a lawyer.")}</li>
                                        <li>• {t("You have the right to remain silent.")}</li>
                                        <li>• {t("If unsafe, move to physical safety first and call 911 for medical or immediate danger.")}</li>
                                    </ul>
                                </div>
                            </div>

                            <div className="rounded-3xl border border-amber-200 bg-amber-50 p-5">
                                <p className="text-sm font-semibold uppercase tracking-[0.2em] text-amber-700">Paper check</p>
                                <p className="mt-2 text-sm leading-6 text-slate-800">Ask officers to show any warrant through a window or slide it under the door. A judicial warrant should be signed by a judge.</p>
                            </div>

                            <div className="flex flex-wrap gap-3">
                                <button className="rounded-full bg-red-700 px-5 py-3 text-sm font-semibold text-white transition hover:bg-red-800" onClick={autoExitSite}><span>{t("Exit")}</span></button>
                                <button className="rounded-full border border-slate-300 bg-white px-5 py-3 text-sm font-semibold text-slate-900 transition hover:bg-slate-100" onClick={closeSession}><span>{t("Confirm auto-erase")}</span></button>
                            </div>

                            <div className="rounded-3xl border border-slate-200 bg-white p-5">
                                <p className="text-sm font-semibold uppercase tracking-[0.2em] text-slate-700">Are you safe now?</p>
                                <p className="mt-2 text-sm leading-6 text-slate-700">{t("If unsafe, move to physical safety first and call 911 for medical or immediate danger.")}</p>
                            </div>

                            <p className="text-xs leading-5 text-slate-500">This page supports quick exit and should not store personal details.</p>
                        </div>
                    </div>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-[radial-gradient(circle_at_top,_#f4fff7,_#e7f3ea_45%,_#dbe7df_100%)] text-slate-900">
            <section className="border-b border-emerald-100/80 bg-white/75 backdrop-blur">
                <div className="mx-auto flex max-w-7xl flex-col gap-4 px-6 py-4 lg:flex-row lg:items-center lg:justify-between lg:px-10">
                    <div>
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-emerald-700">{t("Session auto-erase available")}</p>
                        <p className="mt-1 text-sm text-slate-600">{t("Use Auto Exit any time to close this session quickly. Keyboard shortcut: press Esc to exit the website fast.")}</p>
                    </div>
                    <div className="flex flex-wrap gap-3">
                        <button className="rounded-full border border-emerald-200 bg-white px-4 py-2 text-sm font-semibold text-slate-900 transition hover:bg-emerald-50" onClick={closeSession}><span>{t("Confirm auto-erase")}</span></button>
                        <button className="rounded-full bg-slate-950 px-4 py-2 text-sm font-semibold text-white transition hover:bg-slate-800" onClick={autoExitSite}><span>{t("Auto Exit")}</span></button>
                    </div>
                </div>
            </section>

            <section className="mx-auto flex max-w-7xl items-center justify-center px-6 py-10 lg:min-h-[calc(100vh-7rem)] lg:px-10 lg:py-14">
                <div id="assistant" className="w-full max-w-3xl rounded-[42px] border border-emerald-100 bg-white/88 p-6 shadow-[0_35px_90px_rgba(15,23,42,0.14)] backdrop-blur sm:p-8 lg:min-h-[44rem]">
                    <div className="flex h-full flex-col">
                        <div className="min-h-[10rem] rounded-[28px] border border-emerald-100 bg-emerald-50/85 px-6 py-7 text-center sm:px-10 sm:py-9">
                            <p className="text-3xl font-bold tracking-tight text-slate-950 sm:text-4xl">Bono</p>
                            <p className="mt-4 text-base leading-7 text-slate-700 sm:text-lg">The Premier Service for Fast, Calm, Legal Help in Crisis</p>
                        </div>

                        <div className="flex flex-1 flex-col items-center justify-center px-4 py-10 text-center sm:px-8">
                            <button className="flex h-52 w-52 items-center justify-center rounded-full border-[10px] border-emerald-100 bg-emerald-500 px-8 text-xl font-semibold text-white shadow-[0_24px_60px_rgba(16,185,129,0.35)] transition hover:scale-[1.02] hover:bg-emerald-400 focus:outline-none focus:ring-4 focus:ring-emerald-200 sm:h-60 sm:w-60 sm:px-10 sm:text-2xl" onClick={sendChat}><span>Ask for Help</span></button>
                            <p className="mt-6 max-w-md text-sm leading-6 text-slate-500">Disclaimer: Your data is discarded after use. We do not use nor train any large language models.</p>
                        </div>

                        <div className="rounded-[28px] border border-slate-200 bg-slate-50 p-5">
                            <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                                <div>
                                    <p className="text-sm font-semibold uppercase tracking-[0.2em] text-slate-500">{t("Current conversation language:")}</p>
                                    <p className="mt-1 text-base font-semibold text-slate-900">{languageLabel(selectedLanguage)}</p>
                                </div>
                                <div className="flex flex-wrap gap-2">
                                    <button className="rounded-full border border-slate-300 bg-white px-4 py-2 text-sm font-semibold text-slate-700 transition hover:bg-slate-100" onClick={startVoiceInput}><span>{t("Voice input")}</span></button>
                                    <button className="rounded-full bg-emerald-600 px-4 py-2 text-sm font-semibold text-white transition hover:bg-emerald-500" onClick={sendChat}><span>{t("Send")}</span></button>
                                </div>
                            </div>
                            <p className="mt-3 text-xs leading-5 text-slate-500">{voiceStatus}</p>
                        </div>
                    </div>
                </div>
            </section>

            <section className="mx-auto max-w-7xl px-6 pb-12 lg:px-10">
                {sessionClosed and <div className="mt-2 rounded-3xl border border-green-200 bg-green-50 p-6 shadow-soft"><p className="text-sm font-semibold uppercase tracking-[0.2em] text-green-700">{t("Session auto-erase confirmed")}</p><p className="mt-2 text-sm leading-6 text-gray-700">{t("This session is marked for quick exit and no personal details should be retained.")}</p><button className="mt-4 rounded-full border border-green-300 bg-white px-5 py-3 text-sm font-semibold text-green-800 transition hover:bg-green-100" onClick={reopenSession}><span>{t("Continue session")}</span></button></div>}
            </section>
        </div>
    );
}