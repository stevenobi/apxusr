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