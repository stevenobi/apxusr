// Global user status
var userStatus = null;

// Host and Url for user status callback
var host = $v(hostItem); // see global item for value
var url = host + restUrl;

// Language Settings
var LANG = "en"; // Default Language
var browserLang = $v(browserLangItem);
var defaultLang = browserLang ? browserLang : LANG;
var Lang = lang ? lang : defaultLang; // Language used in Functions

/* doesn't work when included as file in apex, since / is escaped
// Include Language Files
// https://stackoverflow.com/questions/26979733/how-to-include-an-external-javascript-file-conditionally
function include(filename) {
    var scrType = "text&#x2Fjavascript";
    var head = document.getElementsByTagName("head")[0];
    var script = document.createElement("script");
    script.src = filename;
    script.type = scrType;
    head.appendChild(script);
}

// Check for language settings and include file to set validator messages
// works only if file is found in VALIDATOR_JS_INCLUDE server path
if (Lang && Lang !== LANG) {
    include(VALIDATOR_JS_INCLUDE + "messages_" + Lang + ".min.js");
}

*/

// set disabled attribute for register (b)utton = ID via (s)tate = true
function setButtonState(b, s) {
    if (s) {
        $(b).removeAttr("disabled");
    } else {
        $(b).attr("disabled", "disabled");
    }
}

// Avoids form submit
jQuery.validator.setDefaults({
    debug: true,
    success: "valid"
});

// Password Complexity
jQuery.validator.addMethod("pwcheck", function(value) {
    return (
        /^[A-Za-z0-9\d=!\-+#.,:@._*]*$/.test(value) && // consists of only these
        /[=!\-+#.,:@._*]/.test(value) && // a special char
        /[a-z]/.test(value) && // has a lowercase letter
        /\d/.test(value)
    ); // has a digit
});

// Custom Messages for Password Validation
var PWCHECK_MSG =
    "Please enter at least 1 Lower-, Upper- SpecialChar and Number.";

// add messages here
if (Lang && Lang === "de") {
    PWCHECK_MSG = "Bitte mind. 1 Klein-, Groß-, Sonderzeichen und Zahl.";
}

////////////////////////////////////////////////////////////////////////////////
// Validate
var validator = form.validate({
    lang: Lang,
    // This global normalizer will trim
    // the value of all elements before validatng them.
    normalizer: function(value) {
        return $.trim(value);
    },
    rules: {
        FIRSTNAME: {
            required: true
        },
        LASTNAME: {
            required: true
        },
        EMAIL: {
            required: true,
            email: true
        },
        PASSWORD: {
            required: true,
            pwcheck: true
        },
        PASSWORDV: {
            required: true,
            equalTo: PASSWORD
        }
    },
    messages: {
        PASSWORD: {
            pwcheck: PWCHECK_MSG
        }
    }
});

// console.log('Lang User Var: ' + lang + ' LANG Default: ' + LANG +
//             ' Validator.Settings.Lang: ' + validator.settings.lang +
//             ' browserLang: ' + browserLang + ' Language used: ' + Lang);

// Append Error Label after Element if not present, else set Label Text
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
        "<\\/label>";
    var errLabelLen = $(label).length;
    // console.log('Error Len: ' + errLabelLen + 'LabelText ' + errLabel);
    if (errLabelLen === 0) {
        $(errLabel).insertAfter($("input" + field));
    } else {
        $(label).text(msg);
        $(label).show();
    }
}