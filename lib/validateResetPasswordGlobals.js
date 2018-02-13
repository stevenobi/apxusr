////////////////////////////////////////////////////////////////////////////////
// Globals"
var form = $("#wwvFlowForm"); // ID of form to check
var buttonID = "#RESET"; //static ID of button to set enabled state on
var checkField = "#RUSER"; // field to validate
var errorField = checkField + "-error"; // ID of error label field

// Apex Bug: static regions dont take static id
var regRegion = "#USRRST";
var successRegion = "#USRRST_CONFIRM";
var errorRegion = "#USRRST_ERROR";

// ReRegister Button (use Region ID)
var reRegButton = '#USRRST > div > div > div:nth-child(2)';

// Instance - set global items with pl/sql expression values
var browserLangItem = "P0_BROWSER_LANG"; // :BROWSER_LANGUAGE
var hostItem = "P0_INSTANCE_URL"; // apex_mail.get_instance_url();
var restUrl = "/apex/ras/ras/apxusr/"; // rest api url to validate user

// Fields to validate (see rules for details)
var FIRSTNAME = "P115_FIRSTNAME";
var LASTNAME = "P115_LASTNAME";
var EMAIL = "P115_EMAIL";

// Language
var lang = "de"; // unset to use Default Language