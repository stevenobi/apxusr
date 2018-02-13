
// Password Complexity
jQuery.validator.addMethod("pwcheck", function(value) {
    return (
        /^[A-Za-z0-9\d=!\-+#.,:@._*]*$/.test(value) && // consists of only these
        /[=!\-+#.,:@._*]/.test(value) && // a special char
        /[a-z]/.test(value) && // has a lowercase letter
        /\d/.test(value)
    ); // has a digit
});

var validator = form.validate({
    lang: Lang,
    // This global normalizer will trim
    // the value of all elements before validatng them.
    normalizer: function(value) {
        return $.trim(value);
    },
    rules: {
        NUPW: {
            required: true,
            pwcheck: true
        },
        NUPWV: {
            required: true /*,
            equalTo: NUPW
            */
        }
    },
    messages: {
        NUPW: {
            pwcheck: PWCHECK_MSG
        }
    }
});

// Check for Enter key or Tab pressed
form.on("keyup keydown keypress", function(e) {
    var keyCode = e.keyCode || e.which;
    //console.log('keyCode: ' + keyCode);
    if (keyCode === 13 || keyCode === 9) {
        //console.log('Enter or Tab pressed');
        // Prevent Submit on pressing Enter key
        keyCode === 13 ? e.preventDefault() : null;
        checkInput();
        //setReRegButton(userStatus);
    }
});