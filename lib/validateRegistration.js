// get current User Reg Status as ID and process output
function userStatusValid(value, apiurl) {
    // console.log('Value In UserStatus Function: ' + value +
    //             ' Field: ' + checkField + ' Label: ' + errorField);
    if (value) {
        var val = value;
        // rest api url to get user reg status - returns JSON [ -1 - n ]
        var curl = apiurl ? apiurl + val : url + val;
        var curl_last = val.substr(val.length - 1);
        if (curl_last !== ".") {
            //var dat = $.get(curl); // cannot async here :-0
            var dat = $.ajax({
                url: curl,
                dataType: "json",
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
                        msg_en = "User Domain invalid!";
                        msg_de = "Benutzer Domaine ungültig";
                    } else if (us == 3) {
                        msg_en =
                            "Maximum Registration Attempts exceeded for User " +
                            val +
                            ".Please contact our Support.";
                        msg_de =
                            "Benutzer " +
                            val +
                            " hat die maximalen Registrierungsversuche überschritten.";
                        ("Bitte setzen sich mit unserem Support in Verbindung.");
                    } else if (us == 4 || us == 12 || us > 100) {
                        msg_en = "User " + val + " exists. Please reset your password.";
                        msg_de =
                            "Benutzer " +
                            val +
                            " existiert. Bitte setzen Sie Ihr Kennwort zurück.";
                    } else if (us == 11) {
                        msg_en =
                            "User " + val + " exists. Please confirm your Registration.";
                        msg_de =
                            "Benutzer " +
                            val +
                            " existiert. Bitte bestätigen Sie Ihre Registrierung.";
                    } else if (us == 1 || us == 2 || us == 10) {
                        msg_en = "Your Registration expired. Please register again.";
                        msg_de =
                            "Ihre Registrierung ist abgelaufen. Bitte registrieren Sie sich erneut.";
                    }
                    // remove validator to not overwrite our error label
                    validator.destroy();
                    // need to extend this for more languages
                    msg = Lang === "de" ? msg_de : msg_en;
                    setErrorLabel(msg, checkField, errorField);
                }
            }
        }
    }
    return us === 0 ? true : false;
}

// Wrapper to check for formValid and userStatus and set button state
function checkInput() {
    var formV = form.valid();
    var val = $(checkField).val();
    // console.log('Form Valid: ' + formV + ' User ' + val +
    //             ' User Status ' + userStatus);
    if (formV) {
        var userV = userStatusValid(val);
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
form.on("keyup keydown keypress", function(e) {
    var keyCode = e.keyCode || e.which;
    //console.log('keyCode: ' + keyCode);
    if (keyCode === 13 || keyCode === 9) {
        //console.log('Enter or Tab pressed');
        // Prevent Submit on pressing Enter key
        keyCode === 13 ? e.preventDefault() : null;
        checkInput();
    }
});