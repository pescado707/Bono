import from "@jac/runtime" { JsxElement };

def:pub app() -> JsxElement {
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
        if kind == "afrikaans" { return "Afrikaans"; }
        if kind == "albanian" { return "Shqip"; }
        if kind == "amharic" { return "አማርኛ"; }
        if kind == "arabic" { return "العربية"; }
        if kind == "armenian" { return "Հայերեն"; }
        if kind == "assamese" { return "অসমীয়া"; }
        if kind == "aymara" { return "Aymar aru"; }
        if kind == "azerbaijani" { return "Azərbaycanca"; }
        if kind == "bambara" { return "Bamanankan"; }
        if kind == "basque" { return "Euskara"; }
        if kind == "belarusian" { return "Беларуская"; }
        if kind == "bengali" { return "বাংলা"; }
        if kind == "bhojpuri" { return "भोजपुरी"; }
        if kind == "bosnian" { return "Bosanski"; }
        if kind == "bulgarian" { return "Български"; }
        if kind == "catalan" { return "Català"; }
        if kind == "cebuano" { return "Cebuano"; }
        if kind == "chinese_simplified" { return "中文（简体）"; }
        if kind == "chinese_traditional" { return "中文（繁體）"; }
        if kind == "corsican" { return "Corsu"; }
        if kind == "croatian" { return "Hrvatski"; }
        if kind == "czech" { return "Čeština"; }
        if kind == "danish" { return "Dansk"; }
        if kind == "dhivehi" { return "ދިވެހި"; }
        if kind == "dogri" { return "डोगरी"; }
        if kind == "dutch" { return "Nederlands"; }
        if kind == "english" { return "English"; }
        if kind == "esperanto" { return "Esperanto"; }
        if kind == "estonian" { return "Eesti"; }
        if kind == "ewe" { return "Eʋegbe"; }
        if kind == "filipino" { return "Filipino"; }
        if kind == "finnish" { return "Suomi"; }
        if kind == "french" { return "Français"; }
        if kind == "frisian" { return "Frysk"; }
        if kind == "galician" { return "Galego"; }
        if kind == "georgian" { return "ქართული"; }
        if kind == "german" { return "Deutsch"; }
        if kind == "greek" { return "Ελληνικά"; }
        if kind == "guarani" { return "Avañe'ẽ"; }
        if kind == "gujarati" { return "ગુજરાતી"; }
        if kind == "haitian_creole" { return "Kreyòl Ayisyen"; }
        if kind == "hausa" { return "Hausa"; }
        if kind == "hawaiian" { return "ʻŌlelo Hawaiʻi"; }
        if kind == "hebrew" { return "עברית"; }
        if kind == "hindi" { return "हिन्दी"; }
        if kind == "hmong" { return "Hmong"; }
        if kind == "hungarian" { return "Magyar"; }
        if kind == "icelandic" { return "Íslenska"; }
        if kind == "igbo" { return "Igbo"; }
        if kind == "ilocano" { return "Ilocano"; }
        if kind == "indonesian" { return "Indonesia"; }
        if kind == "irish" { return "Gaeilge"; }
        if kind == "italian" { return "Italiano"; }
        if kind == "japanese" { return "日本語"; }
        if kind == "javanese" { return "Basa Jawa"; }
        if kind == "kannada" { return "ಕನ್ನಡ"; }
        if kind == "kazakh" { return "Қазақ тілі"; }
        if kind == "khmer" { return "ខ្មែរ"; }
        if kind == "kinyarwanda" { return "Kinyarwanda"; }
        if kind == "konkani" { return "कोंकणी"; }
        if kind == "korean" { return "한국어"; }
        if kind == "krio" { return "Krio"; }
        if kind == "kurdish_kurmanji" { return "Kurdî (Kurmancî)"; }
        if kind == "kurdish_sorani" { return "کوردی (سۆرانی)"; }
        if kind == "kyrgyz" { return "Кыргызча"; }
        if kind == "lao" { return "ລາວ"; }
        if kind == "latin" { return "Latina"; }
        if kind == "latvian" { return "Latviešu"; }
        if kind == "lingala" { return "Lingála"; }
        if kind == "lithuanian" { return "Lietuvių"; }
        if kind == "luganda" { return "Luganda"; }
        if kind == "luxembourgish" { return "Lëtzebuergesch"; }
        if kind == "macedonian" { return "Македонски"; }
        if kind == "maithili" { return "मैथिली"; }
        if kind == "malagasy" { return "Malagasy"; }
        if kind == "malay" { return "Bahasa Melayu"; }
        if kind == "malayalam" { return "മലയാളം"; }
        if kind == "maltese" { return "Malti"; }
        if kind == "maori" { return "Māori"; }
        if kind == "marathi" { return "मराठी"; }
        if kind == "meiteilon" { return "ꯃꯤꯇꯩꯂꯣꯟ"; }
        if kind == "mizo" { return "Mizo tawng"; }
        if kind == "mongolian" { return "Монгол"; }
        if kind == "myanmar_burmese" { return "မြန်မာ"; }
        if kind == "nepali" { return "नेपाली"; }
        if kind == "norwegian" { return "Norsk"; }
        if kind == "nyanja" { return "Nyanja"; }
        if kind == "odia" { return "ଓଡ଼ିଆ"; }
        if kind == "oromo" { return "Afaan Oromoo"; }
        if kind == "pashto" { return "پښتو"; }
        if kind == "persian" { return "فارسی"; }
        if kind == "polish" { return "Polski"; }
        if kind == "portuguese" { return "Português"; }
        if kind == "punjabi" { return "ਪੰਜਾਬੀ"; }
        if kind == "quechua" { return "Runasimi"; }
        if kind == "romanian" { return "Română"; }
        if kind == "russian" { return "Русский"; }
        if kind == "samoan" { return "Gagana Samoa"; }
        if kind == "sanskrit" { return "संस्कृतम्"; }
        if kind == "scots_gaelic" { return "Gàidhlig"; }
        if kind == "sepedi" { return "Sepedi"; }
        if kind == "serbian" { return "Српски"; }
        if kind == "sesotho" { return "Sesotho"; }
        if kind == "shona" { return "Shona"; }
        if kind == "sindhi" { return "سنڌي"; }
        if kind == "sinhala" { return "සිංහල"; }
        if kind == "slovak" { return "Slovenčina"; }
        if kind == "slovenian" { return "Slovenščina"; }
        if kind == "somali" { return "Soomaali"; }
        if kind == "spanish" { return "Español"; }
        if kind == "sundanese" { return "Basa Sunda"; }
        if kind == "swahili" { return "Kiswahili"; }
        if kind == "swedish" { return "Svenska"; }
        if kind == "tajik" { return "Тоҷикӣ"; }
        if kind == "tamil" { return "தமிழ்"; }
        if kind == "tatar" { return "Татарча"; }
        if kind == "telugu" { return "తెలుగు"; }
        if kind == "thai" { return "ไทย"; }
        if kind == "tigrinya" { return "ትግርኛ"; }
        if kind == "tsonga" { return "Xitsonga"; }
        if kind == "turkish" { return "Türkçe"; }
        if kind == "turkmen" { return "Türkmençe"; }
        if kind == "twi" { return "Twi"; }
        if kind == "ukrainian" { return "Українська"; }
        if kind == "urdu" { return "اردو"; }
        if kind == "uyghur" { return "ئۇيغۇرچە"; }
        if kind == "uzbek" { return "Oʻzbekcha"; }
        if kind == "vietnamese" { return "Tiếng Việt"; }
        if kind == "welsh" { return "Cymraeg"; }
        if kind == "xhosa" { return "isiXhosa"; }
        if kind == "yiddish" { return "ייִדיש"; }
        if kind == "yoruba" { return "Yorùbá"; }
        if kind == "zulu" { return "isiZulu"; }
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
            if english == "Crisis Triangle chatbot" { return "Chatbot Triángulo de Crisis"; }
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
            if english == "Real-time language translation" { return "Traducción de idioma en tiempo real"; }
            if english == "The assistant keeps the full crisis flow in the user’s language, not just the interface. The language selector stays immediately visible near the top for faster access." { return "El asistente mantiene todo el flujo de crisis en el idioma del usuario, no solo la interfaz. El selector de idioma permanece visible arriba para un acceso más rápido."; }
            if english == "Translated urgent message" { return "Mensaje urgente traducido"; }
            if english == "Core rights to reinforce" { return "Derechos clave para reforzar"; }
            if english == "Right to remain silent" { return "Derecho a guardar silencio"; }
            if english == "You do not have to answer questions about immigration status, birthplace, or how you entered the country." { return "No tiene que responder preguntas sobre su estatus migratorio, lugar de nacimiento o cómo entró al país."; }
            if english == "Right to refuse to sign" { return "Derecho a negarse a firmar"; }
            if english == "Do not sign forms, waivers, or departure papers until a lawyer reviews them with you." { return "No firme formularios, renuncias ni documentos de salida hasta que un abogado los revise con usted."; }
            if english == "Right to call for help" { return "Derecho a pedir ayuda"; }
            if english == "If detained, ask to make a phone call and ask to contact your consulate if you were born in another country." { return "Si está detenido, pida hacer una llamada telefónica y pida contactar a su consulado si nació en otro país."; }
            if english == "Possible right to a hearing" { return "Posible derecho a una audiencia"; }
            if english == "Many people have the right to see an immigration judge before removal. A lawyer can check exceptions and deadlines." { return "Muchas personas tienen derecho a ver a un juez de inmigración antes de la expulsión. Un abogado puede revisar excepciones y plazos."; }
            if english == "Crisis triage chatbot" { return "Chatbot de evaluación de crisis"; }
            if english == "Identifies detention, raids, deportation orders, or family separation and routes the user to the right information immediately." { return "Identifica detención, redadas, órdenes de deportación o separación familiar y dirige al usuario a la información correcta de inmediato."; }
            if english == "Know your rights explainer" { return "Explicación de sus derechos"; }
            if english == "Turns a user’s own words into plain-language rights, urgent steps, and reminders not to sign anything without a lawyer." { return "Convierte las propias palabras del usuario en derechos en lenguaje claro, pasos urgentes y recordatorios de no firmar nada sin un abogado."; }
            if english == "Document analyzer" { return "Analizador de documentos"; }
            if english == "Explains ICE notices, court orders, and warrants, including missing details like a judge’s signature and what to do next." { return "Explica avisos de ICE, órdenes judiciales y órdenes de registro, incluyendo detalles faltantes como la firma de un juez y qué hacer después."; }
            if english == "Real-time translation" { return "Traducción en tiempo real"; }
            if english == "Keeps the full crisis conversation in the user’s language from intake through legal handoff and phone scripts." { return "Mantiene toda la conversación de crisis en el idioma del usuario desde el inicio hasta la derivación legal y los guiones telefónicos."; }
            if english == "If someone is physically unsafe" { return "Si alguien está físicamente en peligro"; }
            if english == "Move to immediate physical safety first. Call 911 if there is a medical emergency or immediate danger. Legal strategy comes after safety." { return "Muévase primero a un lugar físicamente seguro. Llame al 911 si hay una emergencia médica o peligro inmediato. La estrategia legal viene después de la seguridad."; }
            if english == "Privacy-first support" { return "Apoyo con prioridad en la privacidad"; }
            if english == "This experience should not ask for or store sensitive personal details. Share only what is necessary with a licensed attorney or accredited representative." { return "Esta experiencia no debe pedir ni guardar datos personales sensibles. Comparta solo lo necesario con un abogado con licencia o un representante acreditado."; }
            if english == "Multilingual and plain language" { return "Multilingüe y en lenguaje claro"; }
            if english == "The assistant should answer in the user’s language, use short sentences, and explain legal terms simply. Specific case strategy must go to a lawyer." { return "El asistente debe responder en el idioma del usuario, usar frases cortas y explicar los términos legales de forma sencilla. La estrategia específica del caso debe ir a un abogado."; }
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
        if lang == "portuguese" { return "Mantenha a calma. Fique em silêncio. Não assine nada sem falar com um advogado."; }
        if lang == "chinese_simplified" { return "保持冷静。保持沉默。没有律师前不要签署任何文件。"; }
        if lang == "chinese_traditional" { return "保持冷靜。保持沉默。未與律師交談前不要簽署任何文件。"; }
        if lang == "hindi" { return "शांत रहें। चुप रहें। वकील से बात किए बिना कुछ भी हस्ताक्षर न करें।"; }
        if lang == "urdu" { return "پرسکون رہیں۔ خاموش رہیں۔ وکیل سے بات کیے بغیر کسی چیز پر دستخط نہ کریں۔"; }
        if lang == "bengali" { return "শান্ত থাকুন। চুপ থাকুন। আইনজীবীর সঙ্গে কথা না বলে কিছু সই করবেন না।"; }
        if lang == "punjabi" { return "ਸ਼ਾਂਤ ਰਹੋ। ਚੁੱਪ ਰਹੋ। ਵਕੀਲ ਨਾਲ ਗੱਲ ਕੀਤੇ ਬਿਨਾਂ ਕਿਸੇ ਵੀ ਕਾਗਜ਼ 'ਤੇ ਦਸਤਖਤ ਨਾ ਕਰੋ।"; }
        if lang == "russian" { return "Сохраняйте спокойствие. Храните молчание. Ничего не подписывайте без разговора с адвокатом."; }
        if lang == "ukrainian" { return "Зберігайте спокій. Мовчіть. Нічого не підписуйте без розмови з адвокатом."; }
        if lang == "korean" { return "침착하세요. 침묵을 지키세요. 변호사와 상의하기 전에는 어떤 서류에도 서명하지 마세요."; }
        if lang == "vietnamese" { return "Hãy bình tĩnh. Giữ im lặng. Đừng ký bất cứ giấy tờ nào trước khi nói chuyện với luật sư."; }
        if lang == "filipino" { return "Manatiling kalmado. Manahimik. Huwag pumirma ng anuman nang hindi muna nakakausap ang abogado."; }
        if lang == "haitian_creole" { return "Rete kalm. Pa pale. Pa siyen anyen san ou pa pale ak yon avoka."; }
        if lang == "somali" { return "Is deji. Aamus. Waxba ha saxiixin adigoon la hadlin qareen."; }
        if lang == "swahili" { return "Tulia. Kaa kimya. Usisaini chochote kabla ya kuzungumza na wakili."; }
        if lang == "persian" { return "آرام بمانید. سکوت کنید. بدون صحبت با وکیل هیچ چیزی را امضا نکنید."; }
        if lang == "turkish" { return "Sakin olun. Sessiz kalın. Bir avukatla konuşmadan hiçbir şeyi imzalamayın."; }
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
        if kind == "portuguese" { return "portugues" in query or "português" in query; }
        if kind == "chinese_simplified" { return "chinese" in query or "中文" in query or "简体" in query; }
        if kind == "chinese_traditional" { return "chinese" in query or "中文" in query or "繁體" in query or "traditional" in query; }
        if kind == "filipino" { return "tagalog" in query; }
        if kind == "haitian_creole" { return "haitian" in query or "creole" in query or "kreyol" in query or "kreyòl" in query; }
        if kind == "persian" { return "farsi" in query; }
        if kind == "kurdish_kurmanji" { return "kurmanji" in query; }
        if kind == "kurdish_sorani" { return "sorani" in query; }
        if kind == "myanmar_burmese" { return "burmese" in query; }
        if kind == "nyanja" { return "chichewa" in query; }
        if kind == "odia" { return "oriya" in query; }
        return False;
    }

    def step1(kind: str) -> str {
        if kind == "ice" { return t("Stay calm. You have the right to remain silent. You do not have to answer questions about where you were born or how you entered the U.S."); }
        if kind == "detention" { return t("Tell your loved one: do not sign papers without a lawyer. They can ask to make a phone call."); }
        if kind == "order" { return t("Read the notice carefully and check the deadline immediately. Missing a deadline can make things worse."); }
        return t("Start with the person’s full name, date of birth, and A-number only if you already have it. Do not share more personal information than needed.");
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
        return t("Contact the person’s consulate if they are foreign-born and ask trusted family members to preserve documents and messages.");
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
            return t("This sounds like an active ICE encounter. First: stay calm, remain silent, and do not open the door unless they show a judicial warrant signed by a judge. Do not sign anything. Call a lawyer or trusted person now.");
        }
        if "detained" in message or "detention" in message or "jail" in message or "taken" in message {
            selectedScenario = "detention";
            return t("This sounds like detention. First: tell the person not to sign anything without a lawyer. Ask for a phone call, get the full name and A-number if available, and start checking the ICE detainee locator and nearby facilities.");
        }
        if "order" in message or "notice" in message or "court" in message or "deport" in message {
            selectedScenario = "order";
            return t("This sounds like a deportation order or court notice. First: check the deadline on the paper right away. Do not ignore it and do not sign any waiver. Gather every immigration paper and contact an immigration lawyer or accredited representative immediately.");
        }
        if "family" in message or "husband" in message or "wife" in message or "mother" in message or "father" in message or "child" in message {
            selectedScenario = "family";
            return t("This sounds like a family separation emergency. First: gather only the facts you already know, like full name, date of birth, and A-number if you have it. Then check the ICE detainee locator, call nearby detention centers, and contact emergency legal aid fast.");
        }
        return t("I can help triage this. Tell me whether this is happening now, whether someone is already detained, or whether you received a court or ICE paper. Most important first: remain silent and do not sign anything without a lawyer.");
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
        lastAssistantMessage = triageReply(chatInput.strip().lower());
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

    if panicMode {
        return (
            <div className="min-h-screen bg-[#220708] text-[#f8e7e3]">
                <div className="border-b border-[#8f4a42] bg-[#d2553d] px-6 py-5 text-[#fff1ec] shadow-card">
                    <div className="mx-auto flex max-w-7xl items-center justify-between gap-4">
                        <div className="flex items-center gap-4">
                            <div className="h-4 w-4 rounded-full bg-[#ff8f86]"></div>
                            <p className="text-sm font-semibold uppercase tracking-[0.18em] sm:text-[2rem] sm:tracking-[0.14em]">{t("Panic mode — active")}</p>
                        </div>
                        <button className="rounded-xl border border-[#f3a08f] bg-[#d85f48] px-4 py-2 text-sm font-semibold text-[#ffe4dc] transition hover:bg-[#e06b54]" onClick={disablePanic}><span>{t("Session not saved")}</span></button>
                    </div>
                </div>
                <div className="mx-auto max-w-7xl px-6 py-10 sm:px-8 lg:px-10">
                    <div className="max-w-4xl">
                        <h1 className="text-4xl font-bold leading-tight text-white sm:text-6xl">{t("You have rights.")}</h1>
                        <h2 className="mt-2 text-4xl font-bold leading-tight text-white sm:text-6xl">{t("Here's what to do right now.")}</h2>
                        <p className="mt-5 text-xl text-[#b89a97] sm:text-2xl">{t("Stay calm. Read this carefully.")}</p>
                    </div>

                    <div className="mt-10 rounded-[1.75rem] border border-[#7d5a57] bg-[#2b0b0d] p-5 shadow-card sm:p-7">
                        <div className="flex items-center gap-5">
                            <div className="flex h-16 w-16 shrink-0 items-center justify-center rounded-full bg-[#5d4a4b] text-3xl">☎</div>
                            <div>
                                <p className="text-2xl font-semibold text-white sm:text-4xl">{t("Call emergency legal help now")}</p>
                                <p className="mt-2 text-lg text-[#b89a97] sm:text-2xl">{t("RAICES Hotline • 1-888-XXX-XXXX • free, 24/7")}</p>
                            </div>
                        </div>
                    </div>

                    <div className="mt-10">
                        <p className="text-sm font-semibold uppercase tracking-[0.22em] text-[#8f7a78] sm:text-xl">{t("Say these words out loud")}</p>
                        <div className="mt-5 space-y-4">
                            <div className="flex items-center gap-6 rounded-[1.5rem] border border-[#6f5a58] bg-[#3a2325] px-6 py-5 shadow-soft">
                                <span className="w-6 text-2xl font-semibold text-[#f0a8a0]">1</span>
                                <p className="text-2xl font-semibold text-[#ffb3ac] sm:text-4xl">{t("I do not consent to this search.")}</p>
                            </div>
                            <div className="flex items-center gap-6 rounded-[1.5rem] border border-[#6f5a58] bg-[#3a2325] px-6 py-5 shadow-soft">
                                <span className="w-6 text-2xl font-semibold text-[#f0a8a0]">2</span>
                                <p className="text-2xl font-semibold text-[#ffb3ac] sm:text-4xl">{t("I am exercising my right to remain silent.")}</p>
                            </div>
                            <div className="flex items-center gap-6 rounded-[1.5rem] border border-[#6f5a58] bg-[#3a2325] px-6 py-5 shadow-soft">
                                <span className="w-6 text-2xl font-semibold text-[#f0a8a0]">3</span>
                                <p className="text-2xl font-semibold text-[#ffb3ac] sm:text-4xl">{t("I want to speak to a lawyer.")}</p>
                            </div>
                        </div>
                    </div>

                    <div className="mt-10 border-t border-[#5a3d3d] pt-10">
                        <p className="text-sm font-semibold uppercase tracking-[0.22em] text-[#8f7a78] sm:text-xl">{t("Do and don't")}</p>
                        <div className="mt-5 grid gap-5 lg:grid-cols-2">
                            <div className="rounded-[1.5rem] border border-[#5f8d2f] bg-[#243507] p-6 shadow-card">
                                <p className="text-2xl font-semibold uppercase text-[#8fe06f]">{t("Do")}</p>
                                <ul className="mt-5 space-y-4 text-2xl text-white sm:text-3xl">
                                    <li>— {t("Stay calm")}</li>
                                    <li>— {t("Keep hands visible")}</li>
                                    <li>— {t("Memorize a phone number")}</li>
                                </ul>
                            </div>
                            <div className="rounded-[1.5rem] border border-[#a34a45] bg-[#5a1d1a] p-6 shadow-card">
                                <p className="text-2xl font-semibold uppercase text-[#ff8f86]">{t("Don't")}</p>
                                <ul className="mt-5 space-y-4 text-2xl text-white sm:text-3xl">
                                    <li>— {t("Sign anything")}</li>
                                    <li>— {t("Open the door")}</li>
                                    <li>— {t("Run or resist")}</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div className="mt-10 rounded-[1.5rem] border border-[#b47a1f] bg-[#6a3d10] p-6 shadow-card">
                        <p className="text-2xl font-semibold text-[#ffd98a] sm:text-4xl">{t("Do they have a piece of paper?")}</p>
                        <div className="mt-5 grid gap-4 md:grid-cols-2">
                            <button className="rounded-[1.2rem] border border-[#9f7b4f] bg-[#6b3b11] px-6 py-4 text-2xl font-semibold text-white transition hover:bg-[#7a4515] sm:text-3xl"><span>{t("Yes, they do ↗")}</span></button>
                            <button className="rounded-[1.2rem] border border-[#9f7b4f] bg-[#6b3b11] px-6 py-4 text-2xl font-semibold text-white transition hover:bg-[#7a4515]"><span>{t("No, they don't ↗")}</span></button>
                        </div>
                    </div>

                    <button className="mt-8 flex w-full items-center justify-between rounded-[1.5rem] border border-[#6f5a58] bg-[#2b0b0d] px-6 py-5 text-left text-2xl font-semibold text-white shadow-card transition hover:bg-[#341012] sm:text-3xl"><span>{t("Show rights card to hold up to window")}</span><span className="text-[#8f7a78]">↗</span></button>

                    <div className="mt-10 border-t border-[#5a3d3d] pt-10">
                        <p className="text-sm font-semibold uppercase tracking-[0.22em] text-[#8f7a78] sm:text-xl">{t("Are you safe now?")}</p>
                        <button className="mt-5 flex w-full items-center justify-center rounded-[1.5rem] border border-[#6f5a58] bg-[#2b0b0d] px-6 py-5 text-center text-2xl font-semibold text-white shadow-card transition hover:bg-[#341012] sm:text-3xl"><span>{t("I am safe — help me document this ↗")}</span></button>
                    </div>

                    <p className="mt-8 text-center text-lg text-[#8f7a78] sm:text-2xl">{t("Panic mode exits automatically after 2 hours • No data stored")}</p>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-background text-foreground">
            <header className="sticky top-0 z-30 border-b border-red-200 bg-white/95 backdrop-blur">
                <div className="mx-auto flex max-w-7xl flex-col gap-4 px-6 py-4 lg:flex-row lg:items-center lg:justify-between lg:px-10">
                    <div>
                        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-green-700">{t("Session auto-erase available")}</p>
                        <p className="mt-1 text-sm leading-6 text-gray-700">{t("Use Auto Exit any time to close this session quickly. Keyboard shortcut: press Esc to exit the website fast.")}</p>
                    </div>
                    <div className="flex flex-wrap gap-3">
                        <button className="rounded-full border border-green-300 bg-green-50 px-5 py-3 text-sm font-semibold text-green-800 transition hover:bg-green-100" onClick={closeSession}><span>{t("Confirm auto-erase")}</span></button>
                        <button className="rounded-full bg-gray-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-black" onClick={autoExitSite}><span>{t("Auto Exit")}</span></button>
                    </div>
                </div>
            </header>
            <section className="border-b border-border bg-gradient-to-b from-red-50 via-orange-50 to-background">
                <div className="mx-auto flex max-w-7xl flex-col gap-10 px-6 py-10 lg:flex-row lg:items-start lg:justify-between lg:px-10">
                    <div className="w-full lg:w-[56%] xl:w-[58%]">
                        <div className="mb-4 inline-flex items-center rounded-full border border-red-200 bg-white px-4 py-2 text-sm font-semibold text-red-700 shadow-soft">
                            {t("AI emergency legal aid assistant for immigrants")}
                        </div>
                        <h1 className="max-w-3xl text-4xl font-extrabold tracking-tight text-gray-900 sm:text-5xl lg:text-6xl">
                            {t("Fast, calm help for detention, raids, deportation orders, and family separation.")}
                        </h1>
                        <p className="mt-5 max-w-2xl text-lg leading-8 text-gray-700">
                            {t("This website gives urgent rights guidance in plain language, routes people to the right crisis tools, and helps families connect with legal support fast. It should not store personal information and it is not a law firm.")}
                        </p>
                        <div className="mt-8 flex flex-wrap gap-3">
                            <a href="#assistant" className="rounded-full bg-primary px-6 py-3 text-sm font-semibold text-primary-foreground shadow-soft transition hover:bg-primary/90 focus:outline-none focus:ring-2 focus:ring-primary">
                                {t("Open crisis assistant")}
                            </a>
                            <button className="rounded-full border border-red-300 bg-white px-6 py-3 text-sm font-semibold text-red-700 transition hover:bg-red-50 focus:outline-none focus:ring-2 focus:ring-red-500" onClick={enablePanic}><span>{t("Panic mode")}</span></button>
                        </div>
                    </div>
                    <div className="w-full max-w-xl space-y-4 lg:w-[40%] xl:w-[38%]">
                        <div className="rounded-3xl border border-red-200 bg-white p-6 shadow-card">
                            <div className="mb-3 text-sm font-semibold uppercase tracking-[0.2em] text-red-700">{t("Critical first reminder")}</div>
                            <p className="text-2xl font-bold text-gray-900">{t("Do not sign anything without a lawyer.")}</p>
                            <ul className="mt-5 space-y-3 text-sm leading-6 text-gray-700">
                                <li>• {t("You have the right to remain silent.")}</li>
                                <li>• {t("You can ask to call a lawyer or trusted person.")}</li>
                                <li>• {t("If foreign-born, you can ask to contact your consulate.")}</li>
                                <li>• {t("Many people still have the right to a hearing before an immigration judge.")}</li>
                            </ul>
                        </div>
                        <div className="w-full rounded-3xl border border-border bg-slate-50 p-4 shadow-card">
                            <label className="text-[11px] font-semibold uppercase tracking-[0.2em] text-slate-600">{t("Language")}</label>
                            <input className="mt-2 w-full rounded-xl border border-border bg-white px-3 py-2 text-sm text-gray-900 outline-none transition focus:border-blue-500 focus:ring-2 focus:ring-blue-200" value={languageSearch} onChange={searchLanguage} placeholder={t("Search language")} />
                            <div className="mt-2 max-h-40 overflow-y-auto rounded-xl border border-border bg-white p-1">
                                {languageMatches("afrikaans", languageSearch) and <button className={languageButtonClass("afrikaans", "")} onClick={lambda -> None { chooseLanguage("afrikaans"); }}><span>Afrikaans</span></button>}
                                {languageMatches("albanian", languageSearch) and <button className={languageButtonClass("albanian", "mt-1")} onClick={lambda -> None { chooseLanguage("albanian"); }}><span>Shqip</span></button>}
                                {languageMatches("amharic", languageSearch) and <button className={languageButtonClass("amharic", "mt-1")} onClick={lambda -> None { chooseLanguage("amharic"); }}><span>አማርኛ</span></button>}
                                {languageMatches("arabic", languageSearch) and <button className={languageButtonClass("arabic", "mt-1")} onClick={lambda -> None { chooseLanguage("arabic"); }}><span>العربية</span></button>}
                                {languageMatches("armenian", languageSearch) and <button className={languageButtonClass("armenian", "mt-1")} onClick={lambda -> None { chooseLanguage("armenian"); }}><span>Հայերեն</span></button>}
                                {languageMatches("assamese", languageSearch) and <button className={languageButtonClass("assamese", "mt-1")} onClick={lambda -> None { chooseLanguage("assamese"); }}><span>অসমীয়া</span></button>}
                                {languageMatches("aymara", languageSearch) and <button className={languageButtonClass("aymara", "mt-1")} onClick={lambda -> None { chooseLanguage("aymara"); }}><span>Aymar aru</span></button>}
                                {languageMatches("azerbaijani", languageSearch) and <button className={languageButtonClass("azerbaijani", "mt-1")} onClick={lambda -> None { chooseLanguage("azerbaijani"); }}><span>Azərbaycanca</span></button>}
                                {languageMatches("bambara", languageSearch) and <button className={languageButtonClass("bambara", "mt-1")} onClick={lambda -> None { chooseLanguage("bambara"); }}><span>Bamanankan</span></button>}
                                {languageMatches("basque", languageSearch) and <button className={languageButtonClass("basque", "mt-1")} onClick={lambda -> None { chooseLanguage("basque"); }}><span>Euskara</span></button>}
                                {languageMatches("belarusian", languageSearch) and <button className={languageButtonClass("belarusian", "mt-1")} onClick={lambda -> None { chooseLanguage("belarusian"); }}><span>Беларуская</span></button>}
                                {languageMatches("bengali", languageSearch) and <button className={languageButtonClass("bengali", "mt-1")} onClick={lambda -> None { chooseLanguage("bengali"); }}><span>বাংলা</span></button>}
                                {languageMatches("bhojpuri", languageSearch) and <button className={languageButtonClass("bhojpuri", "mt-1")} onClick={lambda -> None { chooseLanguage("bhojpuri"); }}><span>भोजपुरी</span></button>}
                                {languageMatches("bosnian", languageSearch) and <button className={languageButtonClass("bosnian", "mt-1")} onClick={lambda -> None { chooseLanguage("bosnian"); }}><span>Bosanski</span></button>}
                                {languageMatches("bulgarian", languageSearch) and <button className={languageButtonClass("bulgarian", "mt-1")} onClick={lambda -> None { chooseLanguage("bulgarian"); }}><span>Български</span></button>}
                                {languageMatches("catalan", languageSearch) and <button className={languageButtonClass("catalan", "mt-1")} onClick={lambda -> None { chooseLanguage("catalan"); }}><span>Català</span></button>}
                                {languageMatches("cebuano", languageSearch) and <button className={languageButtonClass("cebuano", "mt-1")} onClick={lambda -> None { chooseLanguage("cebuano"); }}><span>Cebuano</span></button>}
                                {languageMatches("chinese_simplified", languageSearch) and <button className={languageButtonClass("chinese_simplified", "mt-1")} onClick={lambda -> None { chooseLanguage("chinese_simplified"); }}><span>中文（简体）</span></button>}
                                {languageMatches("chinese_traditional", languageSearch) and <button className={languageButtonClass("chinese_traditional", "mt-1")} onClick={lambda -> None { chooseLanguage("chinese_traditional"); }}><span>中文（繁體）</span></button>}
                                {languageMatches("corsican", languageSearch) and <button className={languageButtonClass("corsican", "mt-1")} onClick={lambda -> None { chooseLanguage("corsican"); }}><span>Corsu</span></button>}
                                {languageMatches("croatian", languageSearch) and <button className={languageButtonClass("croatian", "mt-1")} onClick={lambda -> None { chooseLanguage("croatian"); }}><span>Hrvatski</span></button>}
                                {languageMatches("czech", languageSearch) and <button className={languageButtonClass("czech", "mt-1")} onClick={lambda -> None { chooseLanguage("czech"); }}><span>Čeština</span></button>}
                                {languageMatches("danish", languageSearch) and <button className={languageButtonClass("danish", "mt-1")} onClick={lambda -> None { chooseLanguage("danish"); }}><span>Dansk</span></button>}
                                {languageMatches("dhivehi", languageSearch) and <button className={languageButtonClass("dhivehi", "mt-1")} onClick={lambda -> None { chooseLanguage("dhivehi"); }}><span>ދިވެހި</span></button>}
                                {languageMatches("dogri", languageSearch) and <button className={languageButtonClass("dogri", "mt-1")} onClick={lambda -> None { chooseLanguage("dogri"); }}><span>डोगरी</span></button>}
                                {languageMatches("dutch", languageSearch) and <button className={languageButtonClass("dutch", "mt-1")} onClick={lambda -> None { chooseLanguage("dutch"); }}><span>Nederlands</span></button>}
                                {languageMatches("english", languageSearch) and <button className={languageButtonClass("english", "mt-1")} onClick={lambda -> None { chooseLanguage("english"); }}><span>English</span></button>}
                                {languageMatches("esperanto", languageSearch) and <button className={languageButtonClass("esperanto", "mt-1")} onClick={lambda -> None { chooseLanguage("esperanto"); }}><span>Esperanto</span></button>}
                                {languageMatches("estonian", languageSearch) and <button className={languageButtonClass("estonian", "mt-1")} onClick={lambda -> None { chooseLanguage("estonian"); }}><span>Eesti</span></button>}
                                {languageMatches("ewe", languageSearch) and <button className={languageButtonClass("ewe", "mt-1")} onClick={lambda -> None { chooseLanguage("ewe"); }}><span>Eʋegbe</span></button>}
                                {languageMatches("filipino", languageSearch) and <button className={languageButtonClass("filipino", "mt-1")} onClick={lambda -> None { chooseLanguage("filipino"); }}><span>Filipino</span></button>}
                                {languageMatches("finnish", languageSearch) and <button className={languageButtonClass("finnish", "mt-1")} onClick={lambda -> None { chooseLanguage("finnish"); }}><span>Suomi</span></button>}
                                {languageMatches("french", languageSearch) and <button className={languageButtonClass("french", "mt-1")} onClick={lambda -> None { chooseLanguage("french"); }}><span>Français</span></button>}
                                {languageMatches("frisian", languageSearch) and <button className={languageButtonClass("frisian", "mt-1")} onClick={lambda -> None { chooseLanguage("frisian"); }}><span>Frysk</span></button>}
                                {languageMatches("galician", languageSearch) and <button className={languageButtonClass("galician", "mt-1")} onClick={lambda -> None { chooseLanguage("galician"); }}><span>Galego</span></button>}
                                {languageMatches("georgian", languageSearch) and <button className={languageButtonClass("georgian", "mt-1")} onClick={lambda -> None { chooseLanguage("georgian"); }}><span>ქართული</span></button>}
                                {languageMatches("german", languageSearch) and <button className={languageButtonClass("german", "mt-1")} onClick={lambda -> None { chooseLanguage("german"); }}><span>Deutsch</span></button>}
                                {languageMatches("greek", languageSearch) and <button className={languageButtonClass("greek", "mt-1")} onClick={lambda -> None { chooseLanguage("greek"); }}><span>Ελληνικά</span></button>}
                                {languageMatches("guarani", languageSearch) and <button className={languageButtonClass("guarani", "mt-1")} onClick={lambda -> None { chooseLanguage("guarani"); }}><span>Avañe'ẽ</span></button>}
                                {languageMatches("gujarati", languageSearch) and <button className={languageButtonClass("gujarati", "mt-1")} onClick={lambda -> None { chooseLanguage("gujarati"); }}><span>ગુજરાતી</span></button>}
                                {languageMatches("haitian_creole", languageSearch) and <button className={languageButtonClass("haitian_creole", "mt-1")} onClick={lambda -> None { chooseLanguage("haitian_creole"); }}><span>Kreyòl Ayisyen</span></button>}
                                {languageMatches("hausa", languageSearch) and <button className={languageButtonClass("hausa", "mt-1")} onClick={lambda -> None { chooseLanguage("hausa"); }}><span>Hausa</span></button>}
                                {languageMatches("hawaiian", languageSearch) and <button className={languageButtonClass("hawaiian", "mt-1")} onClick={lambda -> None { chooseLanguage("hawaiian"); }}><span>ʻŌlelo Hawaiʻi</span></button>}
                                {languageMatches("hebrew", languageSearch) and <button className={languageButtonClass("hebrew", "mt-1")} onClick={lambda -> None { chooseLanguage("hebrew"); }}><span>עברית</span></button>}
                                {languageMatches("hindi", languageSearch) and <button className={languageButtonClass("hindi", "mt-1")} onClick={lambda -> None { chooseLanguage("hindi"); }}><span>हिन्दी</span></button>}
                                {languageMatches("hmong", languageSearch) and <button className={languageButtonClass("hmong", "mt-1")} onClick={lambda -> None { chooseLanguage("hmong"); }}><span>Hmong</span></button>}
                                {languageMatches("hungarian", languageSearch) and <button className={languageButtonClass("hungarian", "mt-1")} onClick={lambda -> None { chooseLanguage("hungarian"); }}><span>Magyar</span></button>}
                                {languageMatches("icelandic", languageSearch) and <button className={languageButtonClass("icelandic", "mt-1")} onClick={lambda -> None { chooseLanguage("icelandic"); }}><span>Íslenska</span></button>}
                                {languageMatches("igbo", languageSearch) and <button className={languageButtonClass("igbo", "mt-1")} onClick={lambda -> None { chooseLanguage("igbo"); }}><span>Igbo</span></button>}
                                {languageMatches("ilocano", languageSearch) and <button className={languageButtonClass("ilocano", "mt-1")} onClick={lambda -> None { chooseLanguage("ilocano"); }}><span>Ilocano</span></button>}
                                {languageMatches("indonesian", languageSearch) and <button className={languageButtonClass("indonesian", "mt-1")} onClick={lambda -> None { chooseLanguage("indonesian"); }}><span>Indonesia</span></button>}
                                {languageMatches("irish", languageSearch) and <button className={languageButtonClass("irish", "mt-1")} onClick={lambda -> None { chooseLanguage("irish"); }}><span>Gaeilge</span></button>}
                                {languageMatches("italian", languageSearch) and <button className={languageButtonClass("italian", "mt-1")} onClick={lambda -> None { chooseLanguage("italian"); }}><span>Italiano</span></button>}
                                {languageMatches("japanese", languageSearch) and <button className={languageButtonClass("japanese", "mt-1")} onClick={lambda -> None { chooseLanguage("japanese"); }}><span>日本語</span></button>}
                                {languageMatches("javanese", languageSearch) and <button className={languageButtonClass("javanese", "mt-1")} onClick={lambda -> None { chooseLanguage("javanese"); }}><span>Basa Jawa</span></button>}
                                {languageMatches("kannada", languageSearch) and <button className={languageButtonClass("kannada", "mt-1")} onClick={lambda -> None { chooseLanguage("kannada"); }}><span>ಕನ್ನಡ</span></button>}
                                {languageMatches("kazakh", languageSearch) and <button className={languageButtonClass("kazakh", "mt-1")} onClick={lambda -> None { chooseLanguage("kazakh"); }}><span>Қазақ тілі</span></button>}
                                {languageMatches("khmer", languageSearch) and <button className={languageButtonClass("khmer", "mt-1")} onClick={lambda -> None { chooseLanguage("khmer"); }}><span>ខ្មែរ</span></button>}
                                {languageMatches("kinyarwanda", languageSearch) and <button className={languageButtonClass("kinyarwanda", "mt-1")} onClick={lambda -> None { chooseLanguage("kinyarwanda"); }}><span>Kinyarwanda</span></button>}
                                {languageMatches("konkani", languageSearch) and <button className={languageButtonClass("konkani", "mt-1")} onClick={lambda -> None { chooseLanguage("konkani"); }}><span>कोंकणी</span></button>}
                                {languageMatches("korean", languageSearch) and <button className={languageButtonClass("korean", "mt-1")} onClick={lambda -> None { chooseLanguage("korean"); }}><span>한국어</span></button>}
                                {languageMatches("krio", languageSearch) and <button className={languageButtonClass("krio", "mt-1")} onClick={lambda -> None { chooseLanguage("krio"); }}><span>Krio</span></button>}
                                {languageMatches("kurdish_kurmanji", languageSearch) and <button className={languageButtonClass("kurdish_kurmanji", "mt-1")} onClick={lambda -> None { chooseLanguage("kurdish_kurmanji"); }}><span>Kurdî (Kurmancî)</span></button>}
                                {languageMatches("kurdish_sorani", languageSearch) and <button className={languageButtonClass("kurdish_sorani", "mt-1")} onClick={lambda -> None { chooseLanguage("kurdish_sorani"); }}><span>کوردی (سۆرانی)</span></button>}
                                {languageMatches("kyrgyz", languageSearch) and <button className={languageButtonClass("kyrgyz", "mt-1")} onClick={lambda -> None { chooseLanguage("kyrgyz"); }}><span>Кыргызча</span></button>}
                                {languageMatches("lao", languageSearch) and <button className={languageButtonClass("lao", "mt-1")} onClick={lambda -> None { chooseLanguage("lao"); }}><span>ລາວ</span></button>}
                                {languageMatches("latin", languageSearch) and <button className={languageButtonClass("latin", "mt-1")} onClick={lambda -> None { chooseLanguage("latin"); }}><span>Latina</span></button>}
                                {languageMatches("latvian", languageSearch) and <button className={languageButtonClass("latvian", "mt-1")} onClick={lambda -> None { chooseLanguage("latvian"); }}><span>Latviešu</span></button>}
                                {languageMatches("lingala", languageSearch) and <button className={languageButtonClass("lingala", "mt-1")} onClick={lambda -> None { chooseLanguage("lingala"); }}><span>Lingála</span></button>}
                                {languageMatches("lithuanian", languageSearch) and <button className={languageButtonClass("lithuanian", "mt-1")} onClick={lambda -> None { chooseLanguage("lithuanian"); }}><span>Lietuvių</span></button>}
                                {languageMatches("luganda", languageSearch) and <button className={languageButtonClass("luganda", "mt-1")} onClick={lambda -> None { chooseLanguage("luganda"); }}><span>Luganda</span></button>}
                                {languageMatches("luxembourgish", languageSearch) and <button className={languageButtonClass("luxembourgish", "mt-1")} onClick={lambda -> None { chooseLanguage("luxembourgish"); }}><span>Lëtzebuergesch</span></button>}
                                {languageMatches("macedonian", languageSearch) and <button className={languageButtonClass("macedonian", "mt-1")} onClick={lambda -> None { chooseLanguage("macedonian"); }}><span>Македонски</span></button>}
                                {languageMatches("maithili", languageSearch) and <button className={languageButtonClass("maithili", "mt-1")} onClick={lambda -> None { chooseLanguage("maithili"); }}><span>मैथिली</span></button>}
                                {languageMatches("malagasy", languageSearch) and <button className={languageButtonClass("malagasy", "mt-1")} onClick={lambda -> None { chooseLanguage("malagasy"); }}><span>Malagasy</span></button>}
                                {languageMatches("malay", languageSearch) and <button className={languageButtonClass("malay", "mt-1")} onClick={lambda -> None { chooseLanguage("malay"); }}><span>Bahasa Melayu</span></button>}
                                {languageMatches("malayalam", languageSearch) and <button className={languageButtonClass("malayalam", "mt-1")} onClick={lambda -> None { chooseLanguage("malayalam"); }}><span>മലയാളം</span></button>}
                                {languageMatches("maltese", languageSearch) and <button className={languageButtonClass("maltese", "mt-1")} onClick={lambda -> None { chooseLanguage("maltese"); }}><span>Malti</span></button>}
                                {languageMatches("maori", languageSearch) and <button className={languageButtonClass("maori", "mt-1")} onClick={lambda -> None { chooseLanguage("maori"); }}><span>Māori</span></button>}
                                {languageMatches("marathi", languageSearch) and <button className={languageButtonClass("marathi", "mt-1")} onClick={lambda -> None { chooseLanguage("marathi"); }}><span>मराठी</span></button>}
                                {languageMatches("meiteilon", languageSearch) and <button className={languageButtonClass("meiteilon", "mt-1")} onClick={lambda -> None { chooseLanguage("meiteilon"); }}><span>ꯃꯤꯇꯩꯂꯣꯟ</span></button>}
                                {languageMatches("mizo", languageSearch) and <button className={languageButtonClass("mizo", "mt-1")} onClick={lambda -> None { chooseLanguage("mizo"); }}><span>Mizo tawng</span></button>}
                                {languageMatches("mongolian", languageSearch) and <button className={languageButtonClass("mongolian", "mt-1")} onClick={lambda -> None { chooseLanguage("mongolian"); }}><span>Монгол</span></button>}
                                {languageMatches("myanmar_burmese", languageSearch) and <button className={languageButtonClass("myanmar_burmese", "mt-1")} onClick={lambda -> None { chooseLanguage("myanmar_burmese"); }}><span>မြန်မာ</span></button>}
                                {languageMatches("nepali", languageSearch) and <button className={languageButtonClass("nepali", "mt-1")} onClick={lambda -> None { chooseLanguage("nepali"); }}><span>नेपाली</span></button>}
                                {languageMatches("norwegian", languageSearch) and <button className={languageButtonClass("norwegian", "mt-1")} onClick={lambda -> None { chooseLanguage("norwegian"); }}><span>Norsk</span></button>}
                                {languageMatches("nyanja", languageSearch) and <button className={languageButtonClass("nyanja", "mt-1")} onClick={lambda -> None { chooseLanguage("nyanja"); }}><span>Nyanja</span></button>}
                                {languageMatches("odia", languageSearch) and <button className={languageButtonClass("odia", "mt-1")} onClick={lambda -> None { chooseLanguage("odia"); }}><span>ଓଡ଼ିଆ</span></button>}
                                {languageMatches("oromo", languageSearch) and <button className={languageButtonClass("oromo", "mt-1")} onClick={lambda -> None { chooseLanguage("oromo"); }}><span>Afaan Oromoo</span></button>}
                                {languageMatches("pashto", languageSearch) and <button className={languageButtonClass("pashto", "mt-1")} onClick={lambda -> None { chooseLanguage("pashto"); }}><span>پښتو</span></button>}
                                {languageMatches("persian", languageSearch) and <button className={languageButtonClass("persian", "mt-1")} onClick={lambda -> None { chooseLanguage("persian"); }}><span>فارسی</span></button>}
                                {languageMatches("polish", languageSearch) and <button className={languageButtonClass("polish", "mt-1")} onClick={lambda -> None { chooseLanguage("polish"); }}><span>Polski</span></button>}
                                {languageMatches("portuguese", languageSearch) and <button className={languageButtonClass("portuguese", "mt-1")} onClick={lambda -> None { chooseLanguage("portuguese"); }}><span>Português</span></button>}
                                {languageMatches("punjabi", languageSearch) and <button className={languageButtonClass("punjabi", "mt-1")} onClick={lambda -> None { chooseLanguage("punjabi"); }}><span>ਪੰਜਾਬੀ</span></button>}
                                {languageMatches("quechua", languageSearch) and <button className={languageButtonClass("quechua", "mt-1")} onClick={lambda -> None { chooseLanguage("quechua"); }}><span>Runasimi</span></button>}
                                {languageMatches("romanian", languageSearch) and <button className={languageButtonClass("romanian", "mt-1")} onClick={lambda -> None { chooseLanguage("romanian"); }}><span>Română</span></button>}
                                {languageMatches("russian", languageSearch) and <button className={languageButtonClass("russian", "mt-1")} onClick={lambda -> None { chooseLanguage("russian"); }}><span>Русский</span></button>}
                                {languageMatches("samoan", languageSearch) and <button className={languageButtonClass("samoan", "mt-1")} onClick={lambda -> None { chooseLanguage("samoan"); }}><span>Gagana Samoa</span></button>}
                                {languageMatches("sanskrit", languageSearch) and <button className={languageButtonClass("sanskrit", "mt-1")} onClick={lambda -> None { chooseLanguage("sanskrit"); }}><span>संस्कृतम्</span></button>}
                                {languageMatches("scots_gaelic", languageSearch) and <button className={languageButtonClass("scots_gaelic", "mt-1")} onClick={lambda -> None { chooseLanguage("scots_gaelic"); }}><span>Gàidhlig</span></button>}
                                {languageMatches("sepedi", languageSearch) and <button className={languageButtonClass("sepedi", "mt-1")} onClick={lambda -> None { chooseLanguage("sepedi"); }}><span>Sepedi</span></button>}
                                {languageMatches("serbian", languageSearch) and <button className={languageButtonClass("serbian", "mt-1")} onClick={lambda -> None { chooseLanguage("serbian"); }}><span>Српски</span></button>}
                                {languageMatches("sesotho", languageSearch) and <button className={languageButtonClass("sesotho", "mt-1")} onClick={lambda -> None { chooseLanguage("sesotho"); }}><span>Sesotho</span></button>}
                                {languageMatches("shona", languageSearch) and <button className={languageButtonClass("shona", "mt-1")} onClick={lambda -> None { chooseLanguage("shona"); }}><span>Shona</span></button>}
                                {languageMatches("sindhi", languageSearch) and <button className={languageButtonClass("sindhi", "mt-1")} onClick={lambda -> None { chooseLanguage("sindhi"); }}><span>سنڌي</span></button>}
                                {languageMatches("sinhala", languageSearch) and <button className={languageButtonClass("sinhala", "mt-1")} onClick={lambda -> None { chooseLanguage("sinhala"); }}><span>සිංහල</span></button>}
                                {languageMatches("slovak", languageSearch) and <button className={languageButtonClass("slovak", "mt-1")} onClick={lambda -> None { chooseLanguage("slovak"); }}><span>Slovenčina</span></button>}
                                {languageMatches("slovenian", languageSearch) and <button className={languageButtonClass("slovenian", "mt-1")} onClick={lambda -> None { chooseLanguage("slovenian"); }}><span>Slovenščina</span></button>}
                                {languageMatches("somali", languageSearch) and <button className={languageButtonClass("somali", "mt-1")} onClick={lambda -> None { chooseLanguage("somali"); }}><span>Soomaali</span></button>}
                                {languageMatches("spanish", languageSearch) and <button className={languageButtonClass("spanish", "mt-1")} onClick={lambda -> None { chooseLanguage("spanish"); }}><span>Español</span></button>}
                                {languageMatches("sundanese", languageSearch) and <button className={languageButtonClass("sundanese", "mt-1")} onClick={lambda -> None { chooseLanguage("sundanese"); }}><span>Basa Sunda</span></button>}
                                {languageMatches("swahili", languageSearch) and <button className={languageButtonClass("swahili", "mt-1")} onClick={lambda -> None { chooseLanguage("swahili"); }}><span>Kiswahili</span></button>}
                                {languageMatches("swedish", languageSearch) and <button className={languageButtonClass("swedish", "mt-1")} onClick={lambda -> None { chooseLanguage("swedish"); }}><span>Svenska</span></button>}
                                {languageMatches("tajik", languageSearch) and <button className={languageButtonClass("tajik", "mt-1")} onClick={lambda -> None { chooseLanguage("tajik"); }}><span>Тоҷикӣ</span></button>}
                                {languageMatches("tamil", languageSearch) and <button className={languageButtonClass("tamil", "mt-1")} onClick={lambda -> None { chooseLanguage("tamil"); }}><span>தமிழ்</span></button>}
                                {languageMatches("tatar", languageSearch) and <button className={languageButtonClass("tatar", "mt-1")} onClick={lambda -> None { chooseLanguage("tatar"); }}><span>Татарча</span></button>}
                                {languageMatches("telugu", languageSearch) and <button className={languageButtonClass("telugu", "mt-1")} onClick={lambda -> None { chooseLanguage("telugu"); }}><span>తెలుగు</span></button>}
                                {languageMatches("thai", languageSearch) and <button className={languageButtonClass("thai", "mt-1")} onClick={lambda -> None { chooseLanguage("thai"); }}><span>ไทย</span></button>}
                                {languageMatches("tigrinya", languageSearch) and <button className={languageButtonClass("tigrinya", "mt-1")} onClick={lambda -> None { chooseLanguage("tigrinya"); }}><span>ትግርኛ</span></button>}
                                {languageMatches("tsonga", languageSearch) and <button className={languageButtonClass("tsonga", "mt-1")} onClick={lambda -> None { chooseLanguage("tsonga"); }}><span>Xitsonga</span></button>}
                                {languageMatches("turkish", languageSearch) and <button className={languageButtonClass("turkish", "mt-1")} onClick={lambda -> None { chooseLanguage("turkish"); }}><span>Türkçe</span></button>}
                                {languageMatches("turkmen", languageSearch) and <button className={languageButtonClass("turkmen", "mt-1")} onClick={lambda -> None { chooseLanguage("turkmen"); }}><span>Türkmençe</span></button>}
                                {languageMatches("twi", languageSearch) and <button className={languageButtonClass("twi", "mt-1")} onClick={lambda -> None { chooseLanguage("twi"); }}><span>Twi</span></button>}
                                {languageMatches("ukrainian", languageSearch) and <button className={languageButtonClass("ukrainian", "mt-1")} onClick={lambda -> None { chooseLanguage("ukrainian"); }}><span>Українська</span></button>}
                                {languageMatches("urdu", languageSearch) and <button className={languageButtonClass("urdu", "mt-1")} onClick={lambda -> None { chooseLanguage("urdu"); }}><span>اردو</span></button>}
                                {languageMatches("uyghur", languageSearch) and <button className={languageButtonClass("uyghur", "mt-1")} onClick={lambda -> None { chooseLanguage("uyghur"); }}><span>ئۇيغۇرچە</span></button>}
                                {languageMatches("uzbek", languageSearch) and <button className={languageButtonClass("uzbek", "mt-1")} onClick={lambda -> None { chooseLanguage("uzbek"); }}><span>Oʻzbekcha</span></button>}
                                {languageMatches("vietnamese", languageSearch) and <button className={languageButtonClass("vietnamese", "mt-1")} onClick={lambda -> None { chooseLanguage("vietnamese"); }}><span>Tiếng Việt</span></button>}
                                {languageMatches("welsh", languageSearch) and <button className={languageButtonClass("welsh", "mt-1")} onClick={lambda -> None { chooseLanguage("welsh"); }}><span>Cymraeg</span></button>}
                                {languageMatches("xhosa", languageSearch) and <button className={languageButtonClass("xhosa", "mt-1")} onClick={lambda -> None { chooseLanguage("xhosa"); }}><span>isiXhosa</span></button>}
                                {languageMatches("yiddish", languageSearch) and <button className={languageButtonClass("yiddish", "mt-1")} onClick={lambda -> None { chooseLanguage("yiddish"); }}><span>ייִדיש</span></button>}
                                {languageMatches("yoruba", languageSearch) and <button className={languageButtonClass("yoruba", "mt-1")} onClick={lambda -> None { chooseLanguage("yoruba"); }}><span>Yorùbá</span></button>}
                                {languageMatches("zulu", languageSearch) and <button className={languageButtonClass("zulu", "mt-1")} onClick={lambda -> None { chooseLanguage("zulu"); }}><span>isiZulu</span></button>}
                            </div>
                            <p className="mt-2 text-xs leading-5 text-slate-600">{t("Current:")} {languageLabel(selectedLanguage)}</p>
                        </div>
                    </div>
                </div>
            </section>

            <section id="assistant" className="mx-auto max-w-7xl px-6 py-10 lg:px-10">
                <div className="grid gap-8 lg:grid-cols-[1.1fr_0.9fr]">
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-card sm:p-8">
                        <div className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
                            <div>
                                <p className="text-sm font-semibold uppercase tracking-[0.2em] text-red-700">{t("Emergency response guide")}</p>
                                <h2 className="mt-2 text-3xl font-bold text-gray-900">{scenarioTitle(selectedScenario)}</h2>
                            </div>
                            <div className="grid grid-cols-2 gap-2 sm:flex sm:flex-wrap">
                                <button className={scenarioButtonClass("ice")} onClick={chooseIce}><span>{t("ICE now")}</span></button>
                                <button className={scenarioButtonClass("detention")} onClick={chooseDetention}><span>{t("Detention")}</span></button>
                                <button className={scenarioButtonClass("order")} onClick={chooseOrder}><span>{t("Order")}</span></button>
                                <button className={scenarioButtonClass("family")} onClick={chooseFamily}><span>{t("Missing family")}</span></button>
                            </div>
                        </div>

                        <div className="mt-6 rounded-2xl border border-amber-200 bg-amber-50 p-4 text-amber-900">
                            <p className="text-sm font-semibold uppercase tracking-[0.2em]">{t("Most important first action")}</p>
                            <p className="mt-2 text-lg font-bold">{translatedUrgentLine(selectedLanguage)}</p>
                        </div>

                        <ol className="mt-6 space-y-4">
                            <li className="flex gap-4 rounded-2xl border border-border bg-orange-50/50 p-4"><div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-red-700 text-sm font-bold text-white">1</div><p className="text-sm leading-6 text-gray-800">{step1(selectedScenario)}</p></li>
                            <li className="flex gap-4 rounded-2xl border border-border bg-orange-50/50 p-4"><div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-red-700 text-sm font-bold text-white">2</div><p className="text-sm leading-6 text-gray-800">{step2(selectedScenario)}</p></li>
                            <li className="flex gap-4 rounded-2xl border border-border bg-orange-50/50 p-4"><div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-red-700 text-sm font-bold text-white">3</div><p className="text-sm leading-6 text-gray-800">{step3(selectedScenario)}</p></li>
                            <li className="flex gap-4 rounded-2xl border border-border bg-orange-50/50 p-4"><div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-red-700 text-sm font-bold text-white">4</div><p className="text-sm leading-6 text-gray-800">{step4(selectedScenario)}</p></li>
                        </ol>

                        <div className="mt-8 rounded-3xl border border-blue-200 bg-slate-950 p-5 text-white shadow-card">
                            <div className="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
                                <div>
                                    <p className="text-sm font-semibold uppercase tracking-[0.2em] text-cyan-300">{t("Crisis Triangle chatbot")}</p>
                                    <h3 className="mt-2 text-2xl font-bold">{t("Talk to the assistant now")}</h3>
                                    <p className="mt-2 text-sm leading-6 text-slate-300">{t("Describe the emergency in your own words. The chatbot triages the situation and points to the right next steps immediately.")}</p>
                                </div>
                                <div className="rounded-2xl border border-white/10 bg-white/5 px-4 py-3 text-sm text-slate-200">
                                    <p className="font-semibold text-white">{t("Voice input mode")}</p>
                                    <p className="mt-1 text-xs leading-5 text-slate-300">{t("Tap the microphone to speak instead of typing.")}</p>
                                </div>
                            </div>
                            <div className="mt-5 space-y-3 rounded-2xl border border-white/10 bg-black/20 p-4">
                                <div className="ml-auto max-w-[90%] rounded-2xl bg-cyan-500 px-4 py-3 text-sm leading-6 text-slate-950 shadow-soft">
                                    <p className="mb-1 text-[11px] font-semibold uppercase tracking-[0.2em] opacity-70">{t("user")}</p>
                                    <p>{lastUserMessage}</p>
                                </div>
                                <div className="max-w-[90%] rounded-2xl bg-white/10 px-4 py-3 text-sm leading-6 text-white shadow-soft">
                                    <p className="mb-1 text-[11px] font-semibold uppercase tracking-[0.2em] opacity-70">{t("assistant")}</p>
                                    <p>{lastAssistantMessage}</p>
                                </div>
                            </div>
                            <div className="mt-5 grid gap-3 lg:grid-cols-[1fr_auto_auto]">
                                <input className="w-full rounded-2xl border border-white/10 bg-white/10 px-4 py-3 text-sm text-white outline-none transition placeholder:text-slate-400 focus:border-cyan-400 focus:ring-2 focus:ring-cyan-400/30" value={chatInput} onChange={updateChatInput} placeholder={t("Type what is happening right now")} />
                                <button className="rounded-2xl bg-emerald-500 px-4 py-3 text-sm font-semibold text-slate-950 transition hover:bg-emerald-400" onClick={startVoiceInput}><span>{t("Voice input")}</span></button>
                                <button className="rounded-2xl bg-cyan-400 px-5 py-3 text-sm font-semibold text-slate-950 transition hover:bg-cyan-300" onClick={sendChat}><span>{t("Send")}</span></button>
                            </div>
                            <p className="mt-3 text-xs leading-5 text-slate-300">{voiceStatus}. {t("Current conversation language:")} {languageLabel(selectedLanguage)}.</p>
                        </div>
                    </div>

                    <div className="space-y-6">
                        <div className="rounded-3xl border border-border bg-card p-6 shadow-card">
                            <p className="text-sm font-semibold uppercase tracking-[0.2em] text-blue-700">{t("Real-time language translation")}</p>
                            <p className="mt-2 text-sm leading-6 text-gray-700">{t("The assistant keeps the full crisis flow in the user’s language, not just the interface. The language selector stays immediately visible near the top for faster access.")}</p>
                            <div className="mt-4 rounded-2xl bg-blue-50 p-4">
                                <p className="text-sm font-semibold uppercase tracking-[0.2em] text-blue-700">{t("Translated urgent message")}</p>
                                <p className="mt-2 text-base font-semibold text-gray-900">{translatedUrgentLine(selectedLanguage)}</p>
                                <p className="mt-2 text-sm text-blue-900">{t("Current conversation language:")} {languageLabel(selectedLanguage)}</p>
                            </div>
                        </div>

                        <div className="rounded-3xl border border-border bg-card p-6 shadow-card">
                            <p className="text-sm font-semibold uppercase tracking-[0.2em] text-blue-700">{t("Core rights to reinforce")}</p>
                            <div className="mt-4 space-y-4">
                                <div className="rounded-2xl bg-blue-50 p-4"><h3 className="font-bold text-gray-900">{t("Right to remain silent")}</h3><p className="mt-1 text-sm leading-6 text-gray-700">{t("You do not have to answer questions about immigration status, birthplace, or how you entered the country.")}</p></div>
                                <div className="rounded-2xl bg-red-50 p-4"><h3 className="font-bold text-gray-900">{t("Right to refuse to sign")}</h3><p className="mt-1 text-sm leading-6 text-gray-700">{t("Do not sign forms, waivers, or departure papers until a lawyer reviews them with you.")}</p></div>
                                <div className="rounded-2xl bg-emerald-50 p-4"><h3 className="font-bold text-gray-900">{t("Right to call for help")}</h3><p className="mt-1 text-sm leading-6 text-gray-700">{t("If detained, ask to make a phone call and ask to contact your consulate if you were born in another country.")}</p></div>
                                <div className="rounded-2xl bg-orange-50 p-4"><h3 className="font-bold text-gray-900">{t("Possible right to a hearing")}</h3><p className="mt-1 text-sm leading-6 text-gray-700">{t("Many people have the right to see an immigration judge before removal. A lawyer can check exceptions and deadlines.")}</p></div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section className="mx-auto max-w-7xl px-6 pb-12 lg:px-10">
                <div className="grid gap-6 md:grid-cols-2 xl:grid-cols-4">
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft"><p className="text-sm font-semibold uppercase tracking-[0.2em] text-red-700">{t("Crisis triage chatbot")}</p><p className="mt-3 text-sm leading-6 text-gray-700">{t("Identifies detention, raids, deportation orders, or family separation and routes the user to the right information immediately.")}</p></div>
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft"><p className="text-sm font-semibold uppercase tracking-[0.2em] text-blue-700">{t("Know your rights explainer")}</p><p className="mt-3 text-sm leading-6 text-gray-700">{t("Turns a user’s own words into plain-language rights, urgent steps, and reminders not to sign anything without a lawyer.")}</p></div>
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft"><p className="text-sm font-semibold uppercase tracking-[0.2em] text-orange-700">{t("Document analyzer")}</p><p className="mt-3 text-sm leading-6 text-gray-700">{t("Explains ICE notices, court orders, and warrants, including missing details like a judge’s signature and what to do next.")}</p></div>
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft"><p className="text-sm font-semibold uppercase tracking-[0.2em] text-emerald-700">{t("Real-time translation")}</p><p className="mt-3 text-sm leading-6 text-gray-700">{t("Keeps the full crisis conversation in the user’s language from intake through legal handoff and phone scripts.")}</p></div>
                </div>

                <div className="mt-6 grid gap-6 md:grid-cols-3">
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft"><h3 className="text-xl font-bold text-gray-900">{t("If someone is physically unsafe")}</h3><p className="mt-3 text-sm leading-6 text-gray-700">{t("Move to immediate physical safety first. Call 911 if there is a medical emergency or immediate danger. Legal strategy comes after safety.")}</p></div>
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft"><h3 className="text-xl font-bold text-gray-900">{t("Privacy-first support")}</h3><p className="mt-3 text-sm leading-6 text-gray-700">{t("This experience should not ask for or store sensitive personal details. Share only what is necessary with a licensed attorney or accredited representative.")}</p></div>
                    <div className="rounded-3xl border border-border bg-card p-6 shadow-soft"><h3 className="text-xl font-bold text-gray-900">{t("Multilingual and plain language")}</h3><p className="mt-3 text-sm leading-6 text-gray-700">{t("The assistant should answer in the user’s language, use short sentences, and explain legal terms simply. Specific case strategy must go to a lawyer.")}</p></div>
                </div>

                <div className="mt-6 rounded-3xl border border-border bg-gray-900 p-6 text-white shadow-card">
                    <p className="text-sm font-semibold uppercase tracking-[0.2em] text-orange-300">{t("Emergency legal contacts")}</p>
                    <div className="mt-4 grid gap-4 text-sm leading-6 text-gray-200 sm:grid-cols-2">
                        <div><p className="font-bold text-white">RAICES</p><p>raicestexas.org</p></div>
                        <div><p className="font-bold text-white">ACLU Immigrants’ Rights</p><p>aclu.org/issues/immigrants-rights</p></div>
                        <div><p className="font-bold text-white">National Immigration Legal Services Directory</p><p>immigrationadvocates.org/nonprofit/legaldirectory</p></div>
                        <div><p className="font-bold text-white">{t("CLINIC legal help directory")}</p><p>cliniclegal.org/find-legal-help</p></div>
                    </div>
                </div>

                {sessionClosed and <div className="mt-6 rounded-3xl border border-green-200 bg-green-50 p-6 shadow-soft"><p className="text-sm font-semibold uppercase tracking-[0.2em] text-green-700">{t("Session auto-erase confirmed")}</p><p className="mt-2 text-sm leading-6 text-gray-700">{t("This session is marked for quick exit and no personal details should be retained.")}</p><button className="mt-4 rounded-full border border-green-300 bg-white px-5 py-3 text-sm font-semibold text-green-800 transition hover:bg-green-100" onClick={reopenSession}><span>{t("Continue session")}</span></button></div>}
            </section>
        </div>
    );
}
