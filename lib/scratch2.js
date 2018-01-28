/*
////////////////////////////////////////////////////////////////////////////////
// Globals
var form = $('#wwvFlowForm'); // ID of form to check
var buttonID = '#REG'; //static ID of button to set enabled state on
var checkField = '#P102_EMAIL'; // field to validate
var errorField = checkField + '-error'; // ID of error label field

// Apex Bug: static regions dont take static id
var regRegion     = '#R10618508300570882';
var successRegion = '#R5693737528074247';
var errorRegion   = '#R5690431702074214';

// Instance - set global items with pl/sql expression values
var browserLangItem = 'P0_BROWSER_LANG';  // :BROWSER_LANGUAGE
var hostItem        = 'P0_APEX_HOST';     // apex_mail.get_instance_url();
var restUrl         = '/apx/apxusr/usr/'; // rest api url to validate user

// Fields to validate (see rules for details)
var FIRSTNAME = 'P102_FIRSTNAME';
var LASTNAME  = 'P102_LASTNAME';
var EMAIL     = 'P102_EMAIL';
var USERNAME  = 'P102_USERNAME';
var PASSWORD  = 'P102_PASSWORD';
var PASSWORDV = 'P102_PASSWORD_VERIFY';

// App Globals
var JS_INCLUDE = '#WORKSPACE_IMAGES#js';
var CSS_INCLUDE = '#WORKSPACE_IMAGES#css';
var VALIDATOR_NAMESPACE = '/validate/'; // include leading and trailing slashes
var VALIDATOR_JS_INCLUDE = JS_INCLUDE + VALIDATOR_NAMESPACE;
var VALIDATOR_CSS_INCLUDE = CSS_INCLUDE + VALIDATOR_NAMESPACE;

// Language
var lang = 'de'; // unset to use Default Language
*/
/*
////////////////////////////////////////////////////////////////////////////////

// Global user status
var userStatus = null;

// Host and Url for user status callback
var host        = $v(hostItem);  // see global item for value
var url         = host + restUrl;

// Language Settings
var LANG = 'en'; // Default Language
var browserLang   = $v(browserLangItem);
var defaultLang   = (browserLang ? browserLang : LANG);
var Lang = (lang ? lang : defaultLang); // Language used in Functions

// Include Language Files
// https://stackoverflow.com/questions/26979733/how-to-include-an-external-javascript-file-conditionally
function include(filename)
{
   var head = document.getElementsByTagName('head')[0];
   var script = document.createElement('script');
   script.src = filename;
   script.type = 'text/javascript';
   head.appendChild(script)
}

// Check for language settings and include file to set validator messages
// works only if file is found in VALIDATOR_JS_INCLUDE server path
if (Lang && Lang !== LANG) {
    include(VALIDATOR_JS_INCLUDE + 'messages_' + Lang + '.min.js');
}

// Avoids form submit
jQuery.validator.setDefaults({
    debug: true,
    success: "valid"
});

// Password Complexity
jQuery.validator.addMethod("pwcheck", function(value) {
   return /^[A-Za-z0-9\d=!\-+#.,:@._*]*$/.test(value) // consists of only these
       && /[=!\-+#.,:@._*]/.test(value) // a special char
       && /[a-z]/.test(value) // has a lowercase letter
       && /\d/.test(value) // has a digit
});

// Custom Messages for Password Validation
var PWCHECK_MSG = 'Please enter at least 1 Lower-, Upper- Specialchar and Number.';

// add messages here
if (Lang && Lang === 'de' ) {
  PWCHECK_MSG = 'Bitte mind. 1 Klein-, Groß-, Sonderzeichen und Zahl.';
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
            pwcheck: true,
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

//console.log('Lang User Var: ' + lang + ' LANG Default: ' + LANG +
//            ' Validator.Settings.Lang: ' + validator.settings.lang +
//            ' browserLang: ' + browserLang + ' Language used: ' + Lang);

// Append Error Label after Element if not present, else set Label Text
function setErrorLabel(msg, field, label) {
    //console.log('Setting Label for Message: ' + msg +
    //            ' Field: ' + field + ' Label: ' + label);
    var errLabel = '<label id="' + label.substr(1, label.length) +
        '" class="error" for="' + field.substr(1, field.length) +
        '" style="display: block;">' + msg + '</label>';
    var errLabelLen = $(label).length;
    // console.log('Error Len: ' + errLabelLen + 'LabelText ' + errLabel);
    if (errLabelLen === 0) {
        $(errLabel).insertAfter($('input' + field));
    } else {
        $(label).text(msg);
        $(label).show();
    }
}


// set disabled attribute for register (b)utton = ID via (s)tate = true
function setButtonState(b, s) {
    if (s) {
        $(b).removeAttr("disabled");
    } else {
        $(b).attr("disabled", "disabled");
    }
}


// get current User Reg Status as ID and process output
function userStatusValid(value, apiurl) {
    //console.log('Value In UserStatus Function: ' + value +
    //            ' Field: ' + checkField + ' Label: ' + errorField);
    if (value) {
        var val = value;
        // rest api url to get user reg status - returns JSON [ -1 - n ]
        var curl = (apiurl ? apiurl + val : url + val);
        var curl_last = val.substr(val.length - 1);
        if (curl_last !== ".") {
            //var dat = $.get(curl); // cannot async here :-0
            var dat = $.ajax({
                url: curl,
                dataType: 'json',
                async: false,
                success: function(data) {
                    //stuff to do with data - if called async
                    // console.log('Response: ' + data);
                }
            });
            var us = dat.responseJSON.user_status;
            //console.log('User Status JSON: ' + us);
            if (us) {
                userStatus = us;
                if (us != 0) {
                    var msg, msg_en, msg_de;
                    if (us < 0) {
                        msg_en = 'User Domain invalid!';
                        msg_de = 'Benutzer Domaine ungültig';
                    } else if (us == 3) {
                        msg_en = 'Maximum Registration Attempts exceeded for User ' + val +
                                  '.Please contact our Support.';
                        msg_de = 'Benutzer ' + val + ' hat die maximalen Registrierungsversuche überschritten.'
                                 'Bitte setzen sich mit unserem Support in Verbindung.';
                    } else if (us == 4 || us == 12 || us > 100) {
                        msg_en = 'User ' + val + ' exists. Please reset your password.';
                        msg_de = 'Benutzer ' + val + ' existiert. Bitte setzen Sie Ihr Kennwort zurück.';
                    } else if (us == 11) {
                        msg_en = 'User ' + val + ' exists. Please confirm your Registration.';
                        msg_de = 'Benutzer ' + val + ' existiert. Bitte bestätigen Sie Ihre Registrierung.';
                    } else if (us == 1 || us == 2 || us == 10) {
                        msg_en = 'Your Registration expired. Please register again.';
                        msg_de = 'Ihre Registrierung ist abgelaufen. Bitte registrieren Sie sich erneut.';
                    }
                    // remove validator to not overwrite our error label
                    validator.destroy();
                    // need to extend this for more languages
                    msg = (Lang === 'de' ? msg_de : msg_en);
                    setErrorLabel(msg, checkField, errorField);
                }
            }
        }
    }
    return (us === 0 ? true : false);
}


// Wrapper to check for formValid and userStatus and set button state
function checkInput() {
    var formV = form.valid();
    var val = $(checkField).val();
    //console.log('Form Valid: ' + formV + ' User ' + val +
    //            ' User Status ' + userStatus);
    if (formV) {
        var userV =  userStatusValid(val)
        // console.log('UserV: ' + userV);
        if (userV) {
            setButtonState(buttonID, userV);
            return userV;
        } else {
            setButtonState(buttonID, false);
            return false;
        }
    } else {
        setButtonState(buttonID, false);
        return false;
    }
    return false;
}


// Check for Enter key or Tab pressed
form.on('keyup keydown keypress', function(e) {
    var keyCode = e.keyCode || e.which;
    //console.log('keyCode: ' + keyCode);
    if (keyCode === 13 || keyCode === 9) {
        //console.log('Enter or Tab pressed');
        // Prevent Submit on pressing Enter key
        (keyCode === 13 ? e.preventDefault() : null);
        checkInput();
    }
});
*/