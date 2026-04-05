var chatWrapper = {
    'agentVisible': false,
    'hoops': false,
    'chatReady': false,
    'wrapperInit': false,
    'chatbotVisible': false,
    'conversationStarted': false,
    'prechatValues': {},
    'chatbotPayload': {},
    'timeoutInterval': 120000, //2(120)  1 (60) minute timeout
    'EVENT_INVOKE_AGENT': 'launchagent',
    'EVENT_INVOKE_CHATBOT': 'launchchatbot',
    'EVENT_CLOSE_CHATBOT': 'closechatbot',
    'EVENT_AGENT_AVAILABLE': 'isagentavailable',
    'AFTER_HOURS_ERROR': 'You can not chat at this time',
};
var chatWrapperConstants = {
    'mapping': { //Mapping for JSON Structure and PreChat Details.
        'EMAIL': { jsonName: 'email', channelPrechatName: 'EmmaEmail' },
        'PHONE': { jsonName: 'phone', channelPrechatName: 'EmmaPhone' },
        'MAILING_POSTAL_CODE': { jsonName: 'mailingPostalCode', channelPrechatName: 'Postal_Code' },
        'LANGUAGE': { jsonName: 'language', channelPrechatName: 'Language' },
        'INTENT': { jsonName: 'intent', channelPrechatName: 'Intent' },
        'DESCRIPTION': { jsonName: 'reason', channelPrechatName: 'Description' },
        'RECEIPT_NUMBER': { jsonName: 'receiptNumber', channelPrechatName: 'Receipt_Number' },
        'IS_MILITARY': { jsonName: 'isMilitary', channelPrechatName: 'EmmaIsMilitary' },
        'OPTED_IN': { jsonName: 'smsOptIn', channelPrechatName: 'EmmaSMSOptIn' },
        //        'TESTING': {jsonName:'testSTring', channelPrechatName: 'testSTring'},
        'G_28': { jsonName: 'g28', channelPrechatName: 'EmmaG28' },
    },
    'browser': '',
    'browserLang': '',
    'windowDestroyedManually': false,
    'agentAvailable': false,
    'chatRequested': false,
    'handlersAdded': false,
    'timeoutId': ''
}
const CONFIG = {
    "pfix": {
        "domain": "uscis--s1pfix1.sandbox.my.salesforce.com",
        "baseCoreURL": "https://uscis--s1pfix1.sandbox.my.salesforce.com",
        'channel': 'OAIS_Emma_Channel',
        'channelUrl': 'https://uscis--s1pfix1.sandbox.my.site.com/ESWOAISEmmaChannel1762967866941',
        'channelScrt2URL': 'https://uscis--s1pfix1.sandbox.my.salesforce-scrt.com',
        "orgId": "00DSL000003oRJR"
    },
    "production": {
        "domain": "uscis.my.salesforce.com",
        "baseCoreURL": "https://uscis.my.salesforce.com",
        'channel': 'OAIS_Emma_Channel',
        'channelUrl': 'https://uscis.my.site.com/ESWOAISEmmaChannel1763090369120',
        'channelScrt2URL': 'https://uscis.my.salesforce-scrt.com',
        "orgId": "00DG0000000hO5S"
    },
     "qa": {
        "domain": "uscis--s1qa1.sandbox.my.salesforce.com",
        "baseCoreURL": "https://uscis--s1qa1.sandbox.my.salesforce.com",
        'channel': 'OAIS_Emma_Channel',
        'channelUrl': 'https://uscis--s1qa1.sandbox.my.site.com/ESWOAISEmmaChannel1760017247469',
        'channelScrt2URL': 'https://uscis--s1qa1.sandbox.my.salesforce-scrt.com',
        "orgId": "00DSL000003ohHl"
    },
    "uat": {
        "domain": "uscis--uatg.sandbox.my.salesforce.com",
        "baseCoreURL": "https://uscis--uatg.sandbox.my.salesforce.com",
        'channel': 'OAIS_Emma_Channel',
        'channelUrl': 'https://uscis--uatg.sandbox.my.site.com/ESWOAISEmmaChannel1761076040040',
        'channelScrt2URL': 'https://uscis--uatg.sandbox.my.salesforce-scrt.com',
        "orgId": "00DSL000003m8BW"
    },
    "sandbox": {
        "domain": "uscis--s1dev1.sandbox.my.salesforce.com",
        "baseCoreURL": "https://uscis--s1dev1.sandbox.my.salesforce.com",
        'channel': 'OAIS_MIAW_DEMO',
        'channelUrl': 'https://uscis--s1dev1.sandbox.my.site.com/ESWOAISMIAWDEMO1758806754814',
        'channelScrt2URL': 'https://uscis--s1dev1.sandbox.my.salesforce-scrt.com',
        "orgId": "00DSL000003ohBJ"
    },
    "dev": {
        "domain": "uscis--s1dev1.sandbox.my.salesforce.com",
        "baseCoreURL": "https://uscis--s1dev1.sandbox.my.salesforce.com",
        'channel': 'OAIS_Emma_Channel',
        'channelUrl': 'https://uscis--s1dev1.sandbox.my.site.com/ESWOAISEmmaChannel1759248377039',
        'channelScrt2URL': 'https://uscis--s1dev1.sandbox.my.salesforce-scrt.com',
        "orgId": "00DSL000003ohBJ"
    }
};

// determine where we are coming from to set channel variables
//const currentDomain = window.location.hostname;
const configEnviornment = detectEnvironment();
console.log('config ' + configEnviornment);

var config = CONFIG[configEnviornment];
console.log('config obj' + JSON.stringify(config));

//Set chatwrapper constants for browser and browser lang
setBrowserInfo();



// event listeners for emma events
document.addEventListener(chatWrapper.EVENT_INVOKE_AGENT, (evt) => chatWrapper.invokeAgent(evt));


// make sure the right bootstrap is loaded 
let bootstrapScript = document.createElement('script');
let bootstrapURL = config.channelUrl + '/assets/js/bootstrap.min.js';
console.log('bootstrap url' + bootstrapURL);
bootstrapScript.setAttribute('src', bootstrapURL);

const bodyElement = document.body;
bodyElement.appendChild(bootstrapScript);




// detect where we are coming from.  NOTE: may need to add config for qa/uatg
function detectEnvironment() {
    const hostname = window.location.hostname;
    console.log('host name ' + hostname);
    // check production first, uat, then others.
    if (hostname.startsWith('www.uscis.gov') || hostname.startsWith('uscis.gov') || hostname.includes('uscis--c') || hostname.startsWith('staging.uscis.gov')){
        console.log('sending prod');
          return 'production';
    }
    if (hostname.includes('.cloudfront.net') || hostname.includes('testint.uscis.gov') || hostname.includes('uatg') ) {
        return 'uat';
    }
    if (hostname.includes('s1qa1')){
        return 'qa';
    } else if (hostname.includes('s1pfix1')){
        return 'pfix';
    } else if (hostname.includes('.sandbox.')) {
        //Temp - demo channel 
        const pathname = window.location.pathname;
        if (pathname.includes('Demo')){
            return 'sandbox';
        } 
        else if (hostname.includes('dev')) return 'dev';
        return 'sandbox';
    }
  
}


function applyEmbeddedServiceHandlers() {

    window.addEventListener("onEmbeddedMessagingBusinessHoursStarted", (event) => {
        console.log("Received the onEmbeddedMessagingBusinessHoursStarted event…");
        console.log("Event detail - hours start: ", event.detail);
        chatWrapperConstants.agentAvailable = true;

    });
    window.addEventListener("onEmbeddedMessagingBusinessHoursEnded", (event) => {
        console.log("Received the onEmbeddedMessagingBusinessHoursEnded event…");
        console.log("Event detail hours end: ", event.detail);
        chatWrapperConstants.agentAvailable = false;
        chatWrapper.notifiyAgentAvailable(chatWrapperConstants.agentAvailable);
        // possibly need to do more here
        // should we end session? Maybe not if this arrives in the middle of the last chat of the day 
    });

    window.addEventListener("onEmbeddedMessagingButtonCreated", (event) => {
        console.log("Received the Button Created event…");
        console.log("Event detail button created: ", event.detail);
        let evtResponse = JSON.parse(JSON.stringify(event.detail));
        console.log('flag ' + evtResponse.buttonVisibility);
        chatWrapperConstants.agentAvailable = (evtResponse.buttonVisibility === "Show") ? true : false;
        embeddedservice_bootstrap.utilAPI.hideChatButton();


        chatWrapper.notifiyAgentAvailable(chatWrapperConstants.agentAvailable);
        if (chatWrapperConstants.agentAvailable && chatWrapper.agentVisible) {
            launchChat();
        } else if (chatWrapper.agentVisible && !chatWrapperConstants.agentAvailable) {
            // agent requested but outside office hours
            displayUnavailableWindow();
        }

    });
    window.addEventListener("onEmbeddedMessagingReady", e => {
        embeddedservice_bootstrap.utilAPI.hideChatButton();
        // fires when loaded and when conversation has ended and user closes chat window
        console.log('Ready to send prechat');
        console.log('Messaging ready - ', e.detail);
    });

    window.addEventListener("onEmbeddedMessagingConversationOpened", e => {
        console.log('Conversation Opened - ', e.detail);
    });

    window.addEventListener("onEmbeddedMessagingConversationClosed", (event) => {
        console.log('in closed');
        console.log("Event detail conversation closed: ", event.detail);
        if (chatWrapperConstants.timeoutId) {
            clearTimeout(chatWrapperConstants.timeoutId);
        }

        chatWrapper.invokeChatbot({
            "chatSuccessful": true,
            "message": "",
            "routeToContactUs": false
        });
    });

    window.addEventListener("onEmbeddedMessagingConversationStarted", (event) => {
        console.log("Received the onEmbeddedMessagingConversationStarted event…");
        console.log("Event detail conversation start: ", event.detail);
        chatWrapper.conversationStarted = true;

    });


    window.addEventListener("onEmbeddedMessagingWindowClosed", (event) => {
        console.log('MIAW X closed');
        console.log("Window Closed: ", event.detail);
        chatWrapper.conversationStarted = false;
        if (chatWrapperConstants.timeoutId) {
            clearTimeout(chatWrapperConstants.timeoutId);
        }
        closeChatSession(0);

    });

    window.addEventListener("onEmbeddedMessagingConversationParticipantChanged", (event) => {
        console.log("onEmbeddedMessagingConversationParticipantChanged... entry");
        console.log("Event " + event);
        console.log("Event Detail " + event.detail);
        console.log("Event Payload " + event.detail.conversationEntry.entryPayload);
        let entryPayloyConversation = JSON.parse(event.detail.conversationEntry.entryPayload);
        console.log("Event Conversaion payload " + entryPayloyConversation);
        console.log("Event Payload Entries " + entryPayloyConversation.entries[0].operation);
        console.log('total entries ' + entryPayloyConversation.entries.length);
        if ((entryPayloyConversation.entries[0].operation === "remove") && (entryPayloyConversation.entries.length == 1)) {
            console.log("agent remove");
           // createBlockMessage();

            chatWrapper.invokeChatbot({
                "chatSuccessful": true,
                "message": "",
                "routeToContactUs": false
            });
        }
        else if (entryPayloyConversation.entries[0].operation === "add"){
            console.log('agent add');
            // if here - agent might have been added as a result of transfer
                    const messageArea = document.getElementById('blockMessage');
            if (messageArea) {
                //hide the div
                console.log('remove block');
                messageArea.classList.add('blockHidden');
            }
            if (chatWrapperConstants.timeoutId) {
                clearTimeout(chatWrapperConstants.timeoutId);
            }
        }
    });

    window.addEventListener("onEmbeddedMessagingWindowMinimized", e => {
        console.log('Conversation lowered - ', e.detail);
        const messageArea = document.getElementById('blockMessage');
        if (messageArea) {
            //hide the div
            messageArea.classList.add('blockHidden');
        }
    });

    window.addEventListener("onEmbeddedMessagingWindowMaximized", e => {
        console.log('Conversation Raised - ', e.detail);
        const messageArea = document.getElementById('blockMessage');
        if (messageArea) {
            //hide the div
            messageArea.classList.remove('blockHidden');
        }
    });


    window.addEventListener("onEmbeddedMessagingSessionStatusUpdate", e=> {
        console.log('status change ' + JSON.stringify(e.detail));
        let entryPayloadConversation = JSON.parse(e.detail.conversationEntry.entryPayload);
        let entryStatus = entryPayloadConversation.sessionStatus;
        console.log('New Status ' + entryStatus);
        if (entryStatus == 'Inactive'){
            closeChatSession(0);

        }

    });


     window.addEventListener("onEmbeddedMessageSent", (event) => {
      
        console.log("Event Msg Sent " + event);
        // console.log("Event Detail " + event.detail);
        // console.log("Event Payload " + event.detail.conversationEntry.entryPayload);
        let entryPayloadConversation = JSON.parse(event.detail.conversationEntry.entryPayload);
        
        
        if (entryPayloadConversation.abstractMessage.messageType == 'StaticContentMessage') {
            console.log('got static msg') ;
            //console.log('test' + entryPayloadConversation.abstractMessage.staticContent.text);
            if (entryPayloadConversation.abstractMessage.staticContent.text == chatWrapper.AFTER_HOURS_ERROR){
                closeChatSession(1000);
            }
            
        }
        
    });


}
// Closes MIAW chatbot and calls routine to notitiy Emma of status of chat
function closeChatSession(interval) {
    chatWrapper.agentVisible = false;

    const timeoutId = setTimeout(() => {
        const messageArea = document.getElementById('blockMessage');
        if (messageArea) {
            messageArea.remove();
            // get body div and unobserver it
            let bodyDiv = document.querySelector('body');
            //divObserver.unobserve(bodyDiv);// 
        }
        embeddedservice_bootstrap.userVerificationAPI
            .clearSession()
            .then(() => {
                console.log("clearSession then>>>");
            })
            .catch((error) => {
                console.log("clearSession error>>>");
            })
            .finally(() => {
                console.log("clearSession finally>>>");
                chatWrapper.toggleChatbotOn(chatWrapper.chatbotPayload);
            });
    }, interval);
    chatWrapperConstants.timeoutId = timeoutId;
}

// Adds MIAW event listeners, sets the language for this instance and initializes the service
function initEmbeddedMessaging(emmaLanguage) {
    console.log('in initembed');
    if (!chatWrapperConstants.handlersAdded) {
        applyEmbeddedServiceHandlers();
        chatWrapperConstants.handlersAdded = true;
    }

    // set language for MIAW.  
    if (emmaLanguage == 'Spanish') {
        embeddedservice_bootstrap.settings.language = 'es';
    } else {
        embeddedservice_bootstrap.settings.language = 'en_US'; 
    }

    console.log('server lang' + embeddedservice_bootstrap.settings.language);
 



    try {
        embeddedservice_bootstrap.init(
            config.orgId,
            config.channel,
            config.channelUrl,
            {
                scrt2URL: config.channelScrt2URL
            }

        );
    } catch (err) {
        console.log('Error loading Embedded Messaging: ', err);
        chatWrapper.invokeChatbot({
            "chatSuccessful": false,
            "message": "A connection error with the chat client has occurred",
            "routeToContactUs": true
        });
    }
    console.log('bootstrap', window.embeddedservice_bootstrap);

}



chatWrapper.invokeChatbot = function (evt, args) {
    chatWrapperConstants.windowDestroyedManually = true;
    this.toggleAgentOff();
    chatWrapper.chatbotPayload = evt;
};

chatWrapper.toggleAgentOff = function () {
    this.agentVisible = false;
    closeChatSession(chatWrapper.timeoutInterval);
}

chatWrapper.invokeAgent = function (evt, args) {
    console.log('In invoke');
    // called by emma to start chat
    console.log('evt ' + evt);
    this.toggleAgentOn(evt);
    this.toggleChatbotOff();
};

chatWrapper.toggleAgentOn = function (evt, args) {

    this.agentVisible = true; // this means agent has been requested
    chatWrapperConstants.chatRequested = true;
    let payload = evt.detail ? evt.detail : evt;

    console.log('incomingdata ' + payload.channel);
    console.log('payload from toggle on' + JSON.stringify(payload));

    chatWrapper.prechatValues = payload;
    console.log('values' + JSON.stringify(chatWrapper.prechatValues));

    chatWrapper.initChat(payload); //still pass payload for now 
};

chatWrapper.toggleChatbotOff = function () {
    console.log('in togglechatbotoff');
    this.chatbotVisible = false;
    const chatbotEvent = new CustomEvent(chatWrapper.EVENT_CLOSE_CHATBOT);
    document.dispatchEvent(chatbotEvent);
   
};

chatWrapper.toggleChatbotOn = function (payload) {
    console.log('intogglechatboton');
    this.chatbotVisible = true;
    if (chatWrapperConstants.timeoutId) {
        clearTimeout(chatWrapperConstants.timeoutId);
    }
    const chatbotEvent = new CustomEvent(chatWrapper.EVENT_INVOKE_CHATBOT, { detail: payload });
    document.dispatchEvent(chatbotEvent);
    chatWrapper.agentVisible = false;

};

chatWrapper.notifiyAgentAvailable = function (isAgentAvailable) {
    chatWrapperConstants.agentAvailable = isAgentAvailable;
    const agentAvailableEvent = new CustomEvent(chatWrapper.EVENT_AGENT_AVAILABLE, { detail: { isAgentAvailable: isAgentAvailable } });
    document.dispatchEvent(agentAvailableEvent);
};

chatWrapper.checkAvailability = function () {
    return new Promise((resolve, reject) => {
        let hoopsURL = config.channelUrl + 'vforcesit/services/apexrest/EmmaHoopsCheck';
        //fetch('https://uscis--s1dev2.sandbox.my.site.com/ESWOAISEmmaChannel1756398174643vforcesit/services/apexrest/EmmaHoopsCheck')
        fetch(hoopsURL)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error - status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                chatWrapperConstants.agentAvailable = data;
                resolve({ agentAvailable: data });
            })
            .catch(error => {
                reject(error);
            });
    });

}

// let foo = chatWrapper.checkAvailability()
// console.log('foo ', foo);


async function hoopsCheck (){
    let isWithinHours = await chatWrapper.checkAvailability();
    const hoopsEvent = new CustomEvent('hoopsEvent', { detail: isWithinHours });
    document.dispatchEvent(hoopsEvent);
    console.log ('bar ', isWithinHours);
}
 //temp code

//hoopsCheck();

chatWrapper.initChat = function (payload) {

    console.log('agent ' + chatWrapper.agentVisible);

    console.log('isMil ' + chatWrapper.isMil);
    console.log('initChat ready ' + chatWrapper.chatReady);
    console.log('agent avail' + chatWrapperConstants.agentAvailable);


    if (!chatWrapper.wrapperInit) {
        loadCustomStyles();
        initEmbeddedMessaging(payload.language)
        chatWrapper.wrapperInit = true;
        chatWrapper.chatReady = true;
    } else {
        // wrapper has been inited already.  Check agent avail flag - if false launch unavail otherwise launch chat
        if (!chatWrapperConstants.agentAvailable) {
            displayUnavailableWindow();
        } else {
            launchChat(payload);
        }
    }

}


function launchChat() {

    if (chatWrapper.agentVisible && chatWrapperConstants.agentAvailable) {
        applyPrechatFields();

        console.log('launching');
        embeddedservice_bootstrap.utilAPI.launchChat()
            .then(() => {
                // Success handler used to perform actions
                // when the chat client launches successfully.
                // For example, create a method that disables the launch chat button.
                console.log('in launched');
                //disableLaunchChatButton();
            }).catch(() => {
                // Error handler used to perform actions
                // if the chat client fails to launch.
                // For example, create a method that hides the launch chat button.
                // hideLaunchChatButton();
                console.log('failed to launch');
                chatWrapper.invokeChatbot({
                    "chatSuccessful": false,
                    "message": "A connection error with the chat client has occurred",
                    "routeToContactUs": true
                });
            }).finally(() => {
                // Finally handler used to perform any clean-up actions
                // regardless of whether the chat client launches successfully or not.
                // For example, create a method that logs the user’s attempt to chat.
                //logEndUserAttemptToChat();
                console.log('finally done');
            });
    } else {
        chatWrapper.notifiyAgentAvailable(chatWrapper.agentVisible);
    }
}

function applyPrechatFields() {

    console.log('in apply prechat');
    prechatData = chatWrapper.prechatValues;
    console.log('data' + JSON.stringify(prechatData));
    if (prechatData && prechatData.intent) {
        if (prechatData.intent.includes('GREEN_CARD')) {
            prechatData.intent = 'Green Card';
        } else if (prechatData.intent.includes('TECH_SUPPORT')) {
            prechatData.intent = 'THD';
        } else if (prechatData.intent.includes('INFOPASS')) {
            prechatData.intent = 'InfoPass';
        }
    }
    if (prechatData.isMilitary == true) {
        prechatData.isMilitary = '1';
    }
    if (prechatData.smsOptIn == true) {
        prechatData.smsOptIn = '1';
    }
    if ((prechatData.g28 == 'true') || prechatData.g28 == true) {
        prechatData.g28 = '1';
    }

    // validate email address
    if (!validateEmail(prechatData.email)){
        prechatData.email = '';
    }

    //PreChat
    var preChatDetails = {};
    for (field in chatWrapperConstants.mapping) {
        let fieldValue = chatWrapperConstants.mapping[field];
        var columnName = fieldValue.channelPrechatName;
        var columnValue = fieldValue.jsonName;
        preChatDetails[columnName] = prechatData[columnValue];

    }
    // add browser data 
    preChatDetails['Browser'] = chatWrapperConstants.browser;
    preChatDetails['BrowserLanguage'] = chatWrapperConstants.browserLang;



    console.log('prechat detail ' + JSON.stringify(preChatDetails));
    embeddedservice_bootstrap.prechatAPI.setHiddenPrechatFields(preChatDetails);



}

function validateEmail(email) {
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailPattern.test(email);
}

function loadCustomStyles() {
    console.log('Custom Styles to be Added!');
    var link = document.createElement('link');
    link.setAttribute('rel', 'stylesheet');
    link.setAttribute('href', config.baseCoreURL + '/resource/' + Math.floor(Date.now()) + '/MIAWclient?');
    document.head.appendChild(link);
    console.log('Custom Styles Added!');
}
function removeUnavailableMessage() {
    console.log('remove unavailable');
    const messageArea = document.getElementById('loadingWindow');
    if (messageArea) {
        messageArea.remove();
    }
    closeChatSession(0);
}


function displayUnavailableWindow() {
    console.log('in display unavail');
    //Create div which will display message
    let offlineSupportUI = document.querySelector('body');


    let unavailableMessage = document.createElement('div');
    unavailableMessage.className = 'loading-window';
    unavailableMessage.id = 'loadingWindow';
    let unavailableHeader = document.createElement('div');
    unavailableHeader.className = 'loading-window-header';

    let endChatBtn = document.createElement("button");




    let unavailableBody = document.createElement('div');

    unavailableBody.classList.add('offlineFormConfirmation');
    if (embeddedservice_bootstrap.settings.language == 'en_US') {
        unavailableBody.innerHTML = `
            <h2>No Chat Agents Available</h2>
            <p>
                Thank you for contacting USCIS. Currently there are no chat agents available. Please try us again later.
            </p>`;
        endChatBtn.innerHTML = `
                <Span>Close Session</Span>
            `;
    } else {
        unavailableBody.innerHTML = `
            <h2>No hay Agentes de Chat Disponibles</h2>
            <p>
               Gracias por comunicarse con USCIS. Actualmente no hay agentes de chat disponibles. Por favor, inténtelo de nuevo más tarde.
            </p>`;
        endChatBtn.innerHTML = `
                <Span>Close Session (Translated)</Span>
            `;
    }
    endChatBtn.classList.add('endChatBtn');
    endChatBtn.addEventListener('click', removeUnavailableMessage);
    unavailableHeader.appendChild(endChatBtn);
    unavailableMessage.appendChild(unavailableHeader);
    unavailableMessage.appendChild(unavailableBody);
    offlineSupportUI.appendChild(unavailableMessage);

}
// Create a div to cover the enter text box when the 2 minute timer is in effect to prevent the applicant from restarting the chat
function createBlockMessage() {
    console.log('in create block');

    const iframe = document.querySelectorAll('#embeddedMessagingFrame');
    const testing = document.querySelectorAll('#embedded-messaging');
    // iframe not going to work from emma.

    let bodyDiv = document.querySelector('body');
    console.log('body ' + bodyDiv.offsetWidth);
    let divWidth = iframe[0].offsetWidth;
    let bodyWidth = bodyDiv.offsetWidth;
    let divWidthPixels = divWidth + 'px';

    let blockMessage = document.createElement('div');
    blockMessage.id = 'blockMessage';

    //blockMessage.innerHTML='<h2>Use End Chat to close session sooner</h2>';

    let button = document.createElement('button');
    button.id = 'blockButton';
    button.innerHTML = 'End Chat Now';
    button.addEventListener('click', function () {
        if (chatWrapperConstants.timeoutId) {
            clearTimeout(chatWrapperConstants.timeoutId);
        }
        closeChatSession(0);
    });

    blockMessage.appendChild(button);
    blockMessage.classList.remove('blockHidden');


    blockMessage.style.width = divWidthPixels;
    if (divWidth > 0.60 * bodyWidth) {
        blockMessage.style.width = '100%';
    } else {
        blockMessage.style.width = divWidthPixels;
    }
    //bodyDiv.appendChild(blockMessage);
    testing[0].appendChild(blockMessage);

    // add observer code....
    const divObserver = new ResizeObserver(entries => {
        for (const entry of entries) {
            const { width, hieght } = entry.contentRect;
            if (divWidth > 0.65 * width) {
                blockMessage.style.width = '100%';
            } else {
                blockMessage.style.width = divWidthPixels;
            }
        }
    })
    divObserver.observe(bodyDiv);
}

function setBrowserInfo(){
    const isSmallDevice = window.matchMedia("(max-width: 767px)").matches;
    let isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|Windows Phone|Mobi/i.test(navigator.userAgent);
    const hasTouch = navigator.maxTouchPoints > 0;

    if (!isMobile){
        // check if small screen & touch -- probably a mobile device
        // note - hastouch without small screen could be touch laptop so need to check for both being true
        isMobile = (isSmallDevice && hasTouch)? true:false;
        
        isMobile = isSmallDevice; 
    }

    chatWrapperConstants.browser = (isMobile)? 'Mobile': 'Desktop';
    chatWrapperConstants.browserLang = navigator.language;

    console.log('Browser' + chatWrapperConstants.browser + ' lang ' + chatWrapperConstants.browserLang)


}
