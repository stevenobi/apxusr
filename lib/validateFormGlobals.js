// non specific Globals
var form = $("#myForm"); // ID of form to check
var buttonID = "#BUTTON"; //static ID of button to set enabled state on
var checkField = "#USERNAME"; // field to validate
var errorField = checkField + "-error"; // ID of error label field

// Apex Bug: static regions dont take static id
var regRegion = "#R1";
var successRegion = "#R2";
var errorRegion = "#R3";

// ReRegister Button
var reRegButton = '#R1 > div > div > div:nth-child(2)';

// Instance - set global items with pl/sql expression values
var browserLangItem = "P0_BROWSER_LANG"; // :BROWSER_LANGUAGE
var hostItem = "P0_APEX_HOST"; // apex_mail.get_instance_url();
var restUrl = "/apex/ras/ras/apxusr/"; // rest api url to validate user

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