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

// ReRegister Button
var reRegButton = '#R12746488383824300 > div > div > div:nth-child(2)';

// Instance - set global items with pl/sql expression values
var browserLangItem = "P0_BROWSER_LANG"; // :BROWSER_LANGUAGE
var hostItem = "P0_APEX_HOST"; // apex_mail.get_instance_url();
var restUrl = "/bfarm_apex_test/ras/apxusr"; // rest api url to validate user

// Fields to validate (see rules for details)
var FIRSTNAME = "P110_FIRSTNAME";
var LASTNAME = "P110_LASTNAME";
var EMAIL = "P110_EMAIL";

// Language
var lang = "de"; // unset to use Default Language