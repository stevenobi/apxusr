// non specific Globals
var form = $("#wwvFlowForm"); // ID of form to check
var buttonID = "#SIGNUP"; //static ID of button to set enabled state on
var checkField = "#NUPWV"; // field to validate
var errorField = checkField + "-error"; // ID of error label field

// Language
var lang = 'de'; // = "en"; // unset to use Default Language

// Apex Bug: static regions dont take static id
var regRegion = "#R16360515279745656";
var successRegion = "#R12826221698767930";
var errorRegion = "#R12830582728770359";

// Selectors for Dynamic Actions
var pwField = '#NUPW';
var pwFieldV = '#NUPWV'

// ReRegister Button
var reRegButton = '#USR_REG_SUB_BUTTONS > div > div > div:nth-child(2)';

// Instance - set global items with pl/sql expression values
var browserLangItem = "P0_BROWSER_LANG"; // :BROWSER_LANGUAGE
var hostItem = "P0_APEX_HOST"; // apex_mail.get_instance_url();
var restUrl = "/apx/apxusr/usr/"; // rest api url to validate user

// Fields to validate (see rules for details)
var USERNAME = "NEWUSER";
var NUPW = 'NUPW';
var NUPWV = 'NUPWV';

// App Globals
var JS_INCLUDE = "#WORKSPACE_IMAGES#js";
var CSS_INCLUDE = "#WORKSPACE_IMAGES#css";
var VALIDATOR_NAMESPACE = "/validate/"; // include leading and trailing slashes
var VALIDATOR_JS_INCLUDE = JS_INCLUDE + VALIDATOR_NAMESPACE;
var VALIDATOR_CSS_INCLUDE = CSS_INCLUDE + VALIDATOR_NAMESPACE;

// Global user status
var userStatus = null;

// Host and Url for user status callback
var host = $v(hostItem); // see global item for value
var url = host + restUrl;

// Language Settings
var LANG = "en"; // Default Language
var browserLang = $v(browserLangItem);
var defaultLang = (browserLang ? browserLang : LANG);
var Lang = (lang ? lang : defaultLang); // Language used in Functions


// Custom Messages for Password Validation
var PWCHECK_MSG =
    "Please enter at least 1 Lower-, Upper- SpecialChar and Number.";

// add messages here
if (Lang && Lang === "de") {
    PWCHECK_MSG = "Bitte mind. 1 Klein-, Groß-, Sonderzeichen und Zahl.";
}

function setErrorLabel(msg, field, label) {
    // console.log('Setting Label for Message: ' + msg +
    //             ' Field: ' + field + ' Label: ' + label);
    var errLabel =
        '<label id="' +
        label.substr(1, label.length) +
        '" class="error" for="' +
        field.substr(1, field.length) +
        '" style="display: block;">' +
        msg +
        "</label>";
    var errLabelLen = $(label).length;
    // console.log('Error Len: ' + errLabelLen + 'LabelText ' + errLabel);
    if (errLabelLen === 0) {
        $(errLabel).insertAfter($("input" + field));
    } else {
        $(label).text(msg);
        $(label).show();
    }
}

function setButtonState(b, s) {
    if (s) {
        $(b).removeAttr("disabled");
    } else {
        $(b).attr("disabled", "disabled");
    }
}


// ReRegistration
function setReRegButton(userStatus) {
    if (userStatus && (userStatus === 1 || userStatus === 2 || userStatus === 10)) {
        $(reRegButton).show();
    } else {
        $(reRegButton).hide();
    }
}

// Wrapper to check for formValid and userStatus and set button state
function checkInput() {
    var formV = form.valid();
    // console.log('Form Valid: ' + formV);
    if ($(pwField).val() !== $(pwFieldV).val() ) {
        setErrorLabel('Bitte denselben Wert eingeben', checkField, errorField);
        return false;
    } else {
        if (formV) {
            //setButtonState(buttonID, formV);
            return formV;
        } else {
            //setButtonState(buttonID, false);
            return false;
        }
    } 
    return false;
}

