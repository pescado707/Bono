cl def:pub app() -> JsxElement {
    has selectedScenario: str = "ice";
    has selectedLanguage: str = "english";
    has languageSearch: str = "";
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
        if kind == "portuguese" {
            return "Português";
        }
        if kind == "mandarin" {
            return "中文（普通话）";
        }
        if kind == "cantonese" {
            return "中文（廣東話）";
        }
        if kind == "hindi" {
            return "हिन्दी";
        }
        if kind == "urdu" {
            return "اردو";
        }
        if kind == "bengali" {
            return "বাংলা";
        }
        if kind == "punjabi" {
            return "ਪੰਜਾਬੀ";
        }
        if kind == "russian" {
            return "Русский";
        }
        if kind == "ukrainian" {
            return "Українська";
        }
        if kind == "korean" {
            return "한국어";
        }
        if kind == "vietnamese" {
            return "Tiếng Việt";
        }
        if kind == "tagalog" {
            return "Tagalog";
        }
        if kind == "haitian_creole" {
            return "Kreyòl Ayisyen";
        }
        if kind == "somali" {
            return "Soomaali";
        }
        if kind == "swahili" {
            return "Kiswahili";
        }
        if kind == "farsi" {
            return "فارسی";
        }
        if kind == "turkish" {
            return "Türkçe";
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
        if lang == "portuguese" {
            return "Mantenha a calma. Fique em silêncio. Não assine nada sem falar com um advogado.";
        }
        if lang == "mandarin" {
            return "保持冷静。保持沉默。没有律师前不要签署任何文件。";
        }
        if lang == "cantonese" {
            return "保持冷靜。保持沉默。未同律師傾之前唔好簽任何文件。";
        }
        if lang == "hindi" {
            return "शांत रहें। चुप रहें। वकील से बात किए बिना कुछ भी हस्ताक्षर न करें।";
        }
        if lang == "urdu" {
            return "پرسکون رہیں۔ خاموش رہیں۔ وکیل سے بات کیے بغیر کسی چیز پر دستخط نہ کریں۔";
        }
        if lang == "bengali" {
            return "শান্ত থাকুন। চুপ থাকুন। আইনজীবীর সঙ্গে কথা না বলে কিছু সই করবেন না।";
        }
        if lang == "punjabi" {
            return "ਸ਼ਾਂਤ ਰਹੋ। ਚੁੱਪ ਰਹੋ। ਵਕੀਲ ਨਾਲ ਗੱਲ ਕੀਤੇ ਬਿਨਾਂ ਕਿਸੇ ਵੀ ਕਾਗਜ਼ 'ਤੇ ਦਸਤਖਤ ਨਾ ਕਰੋ।";
        }
        if lang == "russian" {
            return "Сохраняйте спокойствие. Храните молчание. Ничего не подписывайте без разговора с адвокатом.";
        }
        if lang == "ukrainian" {
            return "Зберігайте спокій. Мовчіть. Нічого не підписуйте без розмови з адвокатом.";
        }
        if lang == "korean" {
            return "침착하세요. 침묵을 지키세요. 변호사와 상의하기 전에는 어떤 서류에도 서명하지 마세요.";
        }
        if lang == "vietnamese" {
            return "Hãy bình tĩnh. Giữ im lặng. Đừng ký bất cứ giấy tờ nào trước khi nói chuyện với luật sư.";
        }
        if lang == "tagalog" {
            return "Manatiling kalmado. Manahimik. Huwag pumirma ng anuman nang hindi muna nakakausap ang abogado.";
        }
        if lang == "haitian_creole" {
            return "Rete kalm. Pa pale. Pa siyen anyen san ou pa pale ak yon avoka.";
        }
        if lang == "somali" {
            return "Is deji. Aamus. Waxba ha saxiixin adigoon la hadlin qareen.";
        }
        if lang == "swahili" {
            return "Tulia. Kaa kimya. Usisaini chochote kabla ya kuzungumza na wakili.";
        }
        if lang == "farsi" {
            return "آرام بمانید. سکوت کنید. بدون صحبت با وکیل هیچ چیزی را امضا نکنید.";
        }
        if lang == "turkish" {
            return "Sakin olun. Sessiz kalın. Bir avukatla konuşmadan hiçbir şeyi imzalamayın.";
        }
        return "Stay calm. Remain silent. Do not sign anything without speaking to a lawyer.";
    }

    def languageMatches(kind: str, query: str) -> bool {
        if query == "" {
            return True;
        }
        if kind == "english" {
            return "english" in query or "ing" in query;
        }
        if kind == "spanish" {
            return "spanish" in query or "espanol" in query or "español" in query;
        }
        if kind == "french" {
            return "french" in query or "francais" in query or "français" in query;
        }
        if kind == "arabic" {
            return "arabic" in query or "العربية" in query;
        }
        if kind == "portuguese" {
            return "portuguese" in query or "portugues" in query or "português" in query;
        }
        if kind == "mandarin" {
            return "mandarin" in query or "chinese" in query or "中文" in query or "普通话" in query;
        }
        if kind == "cantonese" {
            return "cantonese" in query or "廣東話" in query or "广东话" in query;
        }
        if kind == "hindi" {
            return "hindi" in query or "हिन्दी" in query;
        }
        if kind == "urdu" {
            return "urdu" in query or "اردو" in query;
        }
        if kind == "bengali" {
            return "bengali" in query or "bangla" in query or "বাংলা" in query;
        }
        if kind == "punjabi" {
            return "punjabi" in query or "ਪੰਜਾਬੀ" in query;
        }
        if kind == "russian" {
            return "russian" in query or "русский" in query;
        }
        if kind == "ukrainian" {
            return "ukrainian" in query or "українська" in query;
        }
        if kind == "korean" {
            return "korean" in query or "한국어" in query;
        }
        if kind == "vietnamese" {
            return "vietnamese" in query or "tiếng việt" in query or "viet" in query;
        }
        if kind == "tagalog" {
            return "tagalog" in query or "filipino" in query;
        }
        if kind == "haitian_creole" {
            return "haitian" in query or "creole" in query or "kreyol" in query or "kreyòl" in query;
        }
        if kind == "somali" {
            return "somali" in query or "soomaali" in query;
        }
        if kind == "swahili" {
            return "swahili" in query or "kiswahili" in query;
        }
        if kind == "farsi" {
            return "farsi" in query or "persian" in query or "فارسی" in query;
        }
        if kind == "turkish" {
            return "turkish" in query or "türkçe" in query or "turkce" in query;
        }
        return False;
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

    def searchLanguage(e: any) -> None { languageSearch = e.target.value.lower(); }
    def chooseEnglish() -> None { selectedLanguage = "english"; }
    def chooseSpanish() -> None { selectedLanguage = "spanish"; }
    def chooseFrench() -> None { selectedLanguage = "french"; }
    def chooseArabic() -> None { selectedLanguage = "arabic"; }
    def choosePortuguese() -> None { selectedLanguage = "portuguese"; }
    def chooseMandarin() -> None { selectedLanguage = "mandarin"; }
    def chooseCantonese() -> None { selectedLanguage = "cantonese"; }
    def chooseHindi() -> None { selectedLanguage = "hindi"; }
    def chooseUrdu() -> None { selectedLanguage = "urdu"; }
    def chooseBengali() -> None { selectedLanguage = "bengali"; }
    def choosePunjabi() -> None { selectedLanguage = "punjabi"; }
    def chooseRussian() -> None { selectedLanguage = "russian"; }
    def chooseUkrainian() -> None { selectedLanguage = "ukrainian"; }
    def chooseKorean() -> None { selectedLanguage = "korean"; }
    def chooseVietnamese() -> None { selectedLanguage = "vietnamese"; }
    def chooseTagalog() -> None { selectedLanguage = "tagalog"; }
    def chooseHaitianCreole() -> None { selectedLanguage = "haitian_creole"; }
    def chooseSomali() -> None { selectedLanguage = "somali"; }
    def chooseSwahili() -> None { selectedLanguage = "swahili"; }
    def chooseFarsi() -> None { selectedLanguage = "farsi"; }
    def chooseTurkish() -> None { selectedLanguage = "turkish"; }

    def enablePanic() -> None { panicMode = True; }
    def disablePanic() -> None { panicMode = False; }
    def closeSession() -> None { sessionClosed = True; }
    def reopenSession() -> None { sessionClosed = False; }
    def autoExitSite() -> None {
        sessionClosed = True;
        window.location.href = "about:blank";
    }

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
            <header className="sticky top-0 z-30 border-b border-red-200 bg-white/95 backdrop-blur">
                <div className="mx-auto flex max-w-7xl flex-col gap-4 px-6 py-4 lg:flex-row lg:items-center lg:justify-between lg:px-10">
                    <div>
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-green-700">Session auto-erase available</p>
                        <p className="mt-1 text-sm leading-6 text-gray-700">Use Auto Exit any time to close this session quickly. Keyboard shortcut: press <span className="font-bold">Esc</span> to exit the website fast.</p>
                    </div>
                    <div className="flex flex-wrap gap-3">
                        <button className="rounded-full border border-green-300 bg-green-50 px-5 py-3 text-sm font-semibold text-green-800 transition hover:bg-green-100" onClick={closeSession}><span>Confirm auto-erase</span></button>
                        <button className="rounded-full bg-gray-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-black" onClick={autoExitSite}><span>Auto Exit</span></button>
                    </div>
                </div>
            </header>
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
                        <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
                            <div className="min-w-0 flex-1">
                                <div className="mb-3 text-sm font-semibold uppercase tracking-[0.2em] text-red-700">Critical first reminder</div>
                                <p className="text-2xl font-bold text-gray-900">Do not sign anything without a lawyer.</p>
                            </div>
                            <div className="w-full shrink-0 rounded-2xl border border-border bg-slate-50 p-3 sm:w-56">
                                <label className="text-[11px] font-semibold uppercase tracking-[0.2em] text-slate-600">Language</label>
                                <input className="mt-2 w-full rounded-xl border border-border bg-white px-3 py-2 text-sm text-gray-900 outline-none transition focus:border-blue-500 focus:ring-2 focus:ring-blue-200" value={languageSearch} onChange={searchLanguage} placeholder="Search language" />
                                <div className="mt-2 max-h-40 overflow-y-auto rounded-xl border border-border bg-white p-1">
                                    {languageMatches("english", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "english" else "text-gray-800 hover:bg-card-hover")} onClick={chooseEnglish}><span>English</span></button>)}
                                    {languageMatches("spanish", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "spanish" else "text-gray-800 hover:bg-card-hover")} onClick={chooseSpanish}><span>Español</span></button>)}
                                    {languageMatches("french", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "french" else "text-gray-800 hover:bg-card-hover")} onClick={chooseFrench}><span>Français</span></button>)}
                                    {languageMatches("arabic", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "arabic" else "text-gray-800 hover:bg-card-hover")} onClick={chooseArabic}><span>العربية</span></button>)}
                                    {languageMatches("portuguese", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "portuguese" else "text-gray-800 hover:bg-card-hover")} onClick={choosePortuguese}><span>Português</span></button>)}
                                    {languageMatches("mandarin", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "mandarin" else "text-gray-800 hover:bg-card-hover")} onClick={chooseMandarin}><span>中文（普通话）</span></button>)}
                                    {languageMatches("cantonese", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "cantonese" else "text-gray-800 hover:bg-card-hover")} onClick={chooseCantonese}><span>中文（廣東話）</span></button>)}
                                    {languageMatches("hindi", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "hindi" else "text-gray-800 hover:bg-card-hover")} onClick={chooseHindi}><span>हिन्दी</span></button>)}
                                    {languageMatches("urdu", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "urdu" else "text-gray-800 hover:bg-card-hover")} onClick={chooseUrdu}><span>اردو</span></button>)}
                                    {languageMatches("bengali", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "bengali" else "text-gray-800 hover:bg-card-hover")} onClick={chooseBengali}><span>বাংলা</span></button>)}
                                    {languageMatches("punjabi", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "punjabi" else "text-gray-800 hover:bg-card-hover")} onClick={choosePunjabi}><span>ਪੰਜਾਬੀ</span></button>)}
                                    {languageMatches("russian", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "russian" else "text-gray-800 hover:bg-card-hover")} onClick={chooseRussian}><span>Русский</span></button>)}
                                    {languageMatches("ukrainian", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "ukrainian" else "text-gray-800 hover:bg-card-hover")} onClick={chooseUkrainian}><span>Українська</span></button>)}
                                    {languageMatches("korean", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "korean" else "text-gray-800 hover:bg-card-hover")} onClick={chooseKorean}><span>한국어</span></button>)}
                                    {languageMatches("vietnamese", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "vietnamese" else "text-gray-800 hover:bg-card-hover")} onClick={chooseVietnamese}><span>Tiếng Việt</span></button>)}
                                    {languageMatches("tagalog", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "tagalog" else "text-gray-800 hover:bg-card-hover")} onClick={chooseTagalog}><span>Tagalog</span></button>)}
                                    {languageMatches("haitian_creole", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "haitian_creole" else "text-gray-800 hover:bg-card-hover")} onClick={chooseHaitianCreole}><span>Kreyòl Ayisyen</span></button>)}
                                    {languageMatches("somali", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "somali" else "text-gray-800 hover:bg-card-hover")} onClick={chooseSomali}><span>Soomaali</span></button>)}
                                    {languageMatches("swahili", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "swahili" else "text-gray-800 hover:bg-card-hover")} onClick={chooseSwahili}><span>Kiswahili</span></button>)}
                                    {languageMatches("farsi", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "farsi" else "text-gray-800 hover:bg-card-hover")} onClick={chooseFarsi}><span>فارسی</span></button>)}
                                    {languageMatches("turkish", languageSearch) and (<button className={"flex w-full items-center justify-between rounded-lg px-3 py-2 text-left text-sm font-semibold transition " + ("bg-blue-600 text-white" if selectedLanguage == "turkish" else "text-gray-800 hover:bg-card-hover")} onClick={chooseTurkish}><span>Türkçe</span></button>)}
                                </div>
                                <p className="mt-2 text-xs leading-5 text-slate-600">Current: {languageLabel(selectedLanguage)}</p>
                            </div>
                        </div>
                        <ul className="mt-5 space-y-3 text-sm leading-6 text-gray-700">
                            <li>• You have the right to remain silent.</li>
                            <li>• You can ask to call a lawyer or trusted person.</li>
                            <li>• If foreign-born, you can ask to contact your consulate.</li>
                            <li>• Many people still have the right to a hearing before an immigration judge.</li>
                        </ul>
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
                            <p className="mt-2 text-sm leading-6 text-gray-700">The assistant keeps the full crisis flow in the user’s language, not just the interface. The language selector now stays beside the critical first reminder for faster access.</p>
                            <div className="mt-4 rounded-2xl bg-blue-50 p-4">
                                <p className="text-sm font-semibold uppercase tracking-[0.2em] text-blue-700">Translated urgent message</p>
                                <p className="mt-2 text-base font-semibold text-gray-900">{translatedUrgentLine(selectedLanguage)}</p>
                                <p className="mt-2 text-sm text-blue-900">Current conversation language: {languageLabel(selectedLanguage)}</p>
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

                <div className="mt-6 rounded-3xl border border-border bg-gray-900 p-6 text-white shadow-card">
                    <p className="text-sm font-semibold uppercase tracking-[0.2em] text-orange-300">Emergency legal contacts</p>
                    <div className="mt-4 grid gap-4 text-sm leading-6 text-gray-200 sm:grid-cols-2">
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
            </section>
        </div>
    );
}
