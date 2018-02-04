////////////////////////////////////////////////////////////////////////////////
// Globals
var userStatus = null;
var form = $('#wwvFlowForm'); // ID of form to check
var buttonID = '#REG'; //static ID of register button
var checkField = '#P102_EMAIL'; // field to validate
var errorField = checkField + '-error'; // email error field (for form validation)
var host = $v('P0_APEX_HOST'); // see global item for value
var url = host + '/apx/apxusr/usr/'; // rest api url to validate user

// Apex Bug: static regions dont take static id
var regRegion = '#R10618508300570882';
var successRegion = '#R5693737528074247';
var errorRegion = '#R5690431702074214';

// Language Settings
var browserLang = $v('P0_BROWSER_LANG');
var Lang = 'de'; // unset to use default language  = 'en'
var defaultLang = (browserLang ? browserLang : 'en');
var validatorLang = (Lang ? Lang : defaultLang);

// Include Language Files
function include(filename) {
    var head = document.getElementsByTagName('head')[0];

    var script = document.createElement('script');
    script.src = filename;
    script.type = 'text/javascript';

    head.appendChild(script)
}


// Avoids form submit
jQuery.validator.setDefaults({
    debug: true,
    success: "valid"
});

// Validate
var validator = form.validate({
    lang: validatorLang,
    // This global normalizer will trim
    // the value of all elements before validatng them.
    normalizer: function(value) {
        return $.trim(value);
    },
    rules: {
        P102_FIRSTNAME: {
            required: true
        },
        P102_LASTNAME: {
            required: true
        },
        P102_EMAIL: {
            required: true,
            email: true
        }
    }
});

//console.log('Lang: ' + Lang +
//            ' validatorLang: ' + validator.settings.lang +
//            ' browserLang: ' + browserLang);

// set Error Label after Element if not present, else set Label Text
function setErrorLabel(msg, field, label) {
    // console.log('Setting Label for Message: ' + msg + ' Field: ' + field + ' Label: ' + label);
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
    // console.log('Value In UserStatus Function: ' + value + ' Field: ' + checkField + ' Label: ' + errorField);
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
                        msg_de = 'Benutzer Domaine ungültig';
                        msg_en = 'User Domain invalid!';
                    } else if (us == 3) {
                        msg = 'Maximum Registration Attempts exceeded for User ' + val +
                            '.Please contact <a href="#">Support</a>.';
                    } else if (us == 4 || us == 12 || us > 100) {
                        msg = 'User ' + val + ' exists. Please reset your password.';
                    } else if (us == 11) {
                        msg = 'User ' + val + ' exists. Please confirm your Registration.';
                    } else if (us == 1 || us == 2 || us == 10) {
                        msg = 'Your Registration expired. Please register again.';
                    }
                    // remove validator to not overwrite our error label
                    validator.destroy();
                    msg = (lang === 'en' ? msg_en : msg_de);
                    setErrorLabel(msg, checkField, errorField);
                }
            }
        }
    }
    return (us === 0 ? true : false);
}


// wrapper to check for formValid and userStatus and set button state
function checkInput() {
    var formV = form.valid();
    var val = $(checkField).val();
    // console.log('Form Valid: ' + formV + ' User ' + val + ' User Status ' + userStatus);
    if (formV) {
        var userV = userStatusValid(val)
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



// non specific Globals
var form = $("#myForm"); // ID of form to check
var buttonID = "#BUTTON"; //static ID of button to set enabled state on
var checkField = "#USERNAME"; // field to validate
var errorField = checkField + "-error"; // ID of error label field

// Apex Bug: static regions dont take static id
var regRegion = "#R1";
var successRegion = "#R2";
var errorRegion = "#R3";

// Instance - set global items with pl/sql expression values
var browserLangItem = "P0_BROWSER_LANG"; // :BROWSER_LANGUAGE
var hostItem = "P0_APEX_HOST"; // apex_mail.get_instance_url();
var restUrl = "/apx/apxusr/usr/"; // rest api url to validate user

// Fields to validate (see rules for details)
var FIRSTNAME = "FIRSTNAME";
var LASTNAME = "LASTNAME";
var EMAIL = "EMAIL";
var USERNAME = "USERNAME";
var PASSWORD = "PASSWORD";
var PASSWORDV = "PASSWORD_VERIFY";

// App Globals
var JS_INCLUDE = "#WORKSPACE_IMAGES#js";
var CSS_INCLUDE = "#WORKSPACE_IMAGES#css";
var VALIDATOR_NAMESPACE = "/validate/"; // include leading and trailing slashes
var VALIDATOR_JS_INCLUDE = JS_INCLUDE + VALIDATOR_NAMESPACE;
var VALIDATOR_CSS_INCLUDE = CSS_INCLUDE + VALIDATOR_NAMESPACE;

// Language
var lang; // = "en"; // unset to use Default Language


////////////////////////////////////////////////////////////////////////////////
// Globals"
var form = $("#wwvFlowForm"); // ID of form to check
var buttonID = "#REG"; //static ID of button to set enabled state on
var checkField = "#P102_EMAIL"; // field to validate
var errorField = checkField + "-error"; // ID of error label field

// Apex Bug: static regions dont take static id
var regRegion = "#R10618508300570882";
var successRegion = "#R5693737528074247";
var errorRegion = "#R5690431702074214";

// Instance - set global items with pl/sql expression values
var browserLangItem = "P0_BROWSER_LANG"; // :BROWSER_LANGUAGE
var hostItem = "P0_APEX_HOST"; // apex_mail.get_instance_url();
var restUrl = "/apx/apxusr/usr/"; // rest api url to validate user

// Fields to validate (see rules for details)
var FIRSTNAME = "P102_FIRSTNAME";
var LASTNAME = "P102_LASTNAME";
var EMAIL = "P102_EMAIL";
var USERNAME = "P102_USERNAME";
var PASSWORD = "P102_PASSWORD";
var PASSWORDV = "P102_PASSWORD_VERIFY";

// App Globals
var JS_INCLUDE = "#WORKSPACE_IMAGES#js";
var CSS_INCLUDE = "#WORKSPACE_IMAGES#css";
var VALIDATOR_NAMESPACE = "/validate/"; // include leading and trailing slashes
var VALIDATOR_JS_INCLUDE = JS_INCLUDE + VALIDATOR_NAMESPACE;
var VALIDATOR_CSS_INCLUDE = CSS_INCLUDE + VALIDATOR_NAMESPACE;

// Language
var lang = "de"; // unset to use Default Language