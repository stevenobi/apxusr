////////////////////////////////////////////////////////////////////////////////
// Globals"
var form = $("#wwvFlowForm"); // ID of form to check
var buttonID = "#CRE"; //static ID of button to set enabled state on
var checkField = "#P112_EMAIL"; // field to validate
var errorField = checkField + "-error"; // ID of error label field

// Apex Bug: static regions dont take static id
var regRegion = "#USRCRE";
var successRegion = "#USRCRE_CONFIRM";
var errorRegion = "#USRCRE_ERROR";

// ReRegister Button
var reRegButton = '#R12746488383824300 > div > div > div:nth-child(2)';

// Instance - set global items with pl/sql expression values
var browserLangItem = "P0_BROWSER_LANG"; // :BROWSER_LANGUAGE
var hostItem = "P0_INSTANCE_URL"; // apex_mail.get_instance_url();
var restUrl = "/ras/ras/apxusr/"; // rest api url to validate user

// Fields to validate (see rules for details)
var EMAIL = "EMAIL";
var USERNAME = "USERNAME";
var PASSWORD = "P112_PASSWORD_NEW";
var PASSWORDV = "P112_PASSWORD_NEW_VERIFY";

// Language
var lang = "de"; // unset to use Default Language