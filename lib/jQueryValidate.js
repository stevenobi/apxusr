///////////////////////////////////////////////////////////////////////////////////////////
// Globals
var form = $('#wwvFlowForm'); // ID of form to check
var buttonID = '#REG'; //static ID of register button
var checkField = '#P3_EMAIL'; // field to validate
var errorField = checkField + '-error'; // email error field (for form validation)
var url = 'https://ol7:8443/ords/apx/apxusr/usr/';
var userStatus = null;

// avoids form submit
jQuery.validator.setDefaults({
    debug: true,
    success: "valid"
});


// Password Complexity
jQuery.validator.addMethod("pwcheck", function(value) {
    return /^[A-Za-z0-9\d=!\-+#.,:@._*]*$/.test(value) // consists of only these
        &&
        /[=!\-+#.,:@._*]/.test(value) // a special char
        &&
        /[a-z]/.test(value) // has a lowercase letter
        &&
        /\d/.test(value) // has a digit
});


// Validate
var validator = form.validate({
    lang: 'de',
    // This global normalizer will trim
    // the value of all elements before validatng them.
    normalizer: function(value) {
        return $.trim(value);
    },
    rules: {
        P3_FIRSTNAME: {
            required: true
        },
        P3_LASTNAME: {
            required: true
        },
        P3_EMAIL: {
            required: true,
            email: true
        },
        P3_PASSWORD: {
            required: true,
            pwcheck: true,
        },
        P3_PASSWORD_VERIFY: {
            required: true,
            equalTo: "#P3_PASSWORD"
        }
    },
    messages: {
        P3_PASSWORD: {
            pwcheck: 'Bitte mind. 1 Klein-, Groß-, Sonderzeichen und Zahl.'
        }
    }
});


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
                    var msg;
                    if (us < 0) {
                        msg = 'User Domain invalid!';
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



//////////////////////////////////////////////////////////////////////////////////////////////////////////
// PageLoad Events


// hide confirmation region
$('#REG_CONFIRM').hide();

// check key pressed and act
form.on('keyup keydown keypress', function(e) {
    var keyCode = e.keyCode || e.which;
    //console.log('keyCode: ' + keyCode);
    if (keyCode === 13 || keyCode === 9) {
        //console.log('Enter or Tab pressed');
        // Prevent Submit on pressing Enter key
        (keyCode === 13 ? e.preventDefault() : null);
        // validate again
        checkInput();
    }
});