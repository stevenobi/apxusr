////////////////////////////////////////////////////////////////////////////////
// Globals"
var form = $("#wwvFlowForm"); // ID of form to check
var buttonID = "#RST"; //static ID of button to set enabled state on
var checkField = "#P105_EMAIL"; // field to validate
var errorField = checkField + "-error"; // ID of error label field

// Apex Bug: static regions dont take static id
var regRegion = "#R17843469529762470";
var successRegion = "#R12915392931265802";
var errorRegion = "#R12918698757265835";

// ReRegister Button (use Region ID)
var reRegButton = '#R19971449613015888 > div > div > div:nth-child(2)';

// Instance - set global items with pl/sql expression values
var browserLangItem = "P0_BROWSER_LANG"; // :BROWSER_LANGUAGE
var hostItem = "P0_APEX_HOST"; // apex_mail.get_instance_url();
var restUrl = "/apx/apxusr/usr/"; // rest api url to validate user

// Fields to validate (see rules for details)
var FIRSTNAME = "P105_FIRSTNAME";
var LASTNAME = "P105_LASTNAME";
var EMAIL = "P105_EMAIL";

// Language
var lang = "de"; // unset to use Default Language