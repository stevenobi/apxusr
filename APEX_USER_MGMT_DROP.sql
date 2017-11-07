--- APEX User Management Objects Drop ---


-----------------------------------------------------------------------------------------------------
--
-- Stefan Obermeyer 12.2016
--
-- 12.12.2016 SOB created
-- 27.01.2017 SOB Outfactored into separate file.
--
-----------------------------------------------------------------------------------------------------

drop sequence    "APX$APP_SCOPE_ID_SEQ";
drop trigger     "APX$APP_SCOPE_BIU_TRG";
drop sequence    "APX$APP_PRIV_ID_SEQ";
drop trigger     "APX$APP_PRIV_BIU_TRG";
drop sequence    "APX$APP_DOMAIN_ID_SEQ";
drop trigger     "APX$APP_DOMAIN_BIU_TRG";
drop sequence    "APX$APP_GROUP_ID_SEQ";
drop trigger     "APX$APP_GROUP_BIU_TRG";
drop sequence    "APX$APP_USER_ID_SEQ";
drop trigger     "APX$APP_USER_BIU_TRG" ;
drop sequence    "APX$APP_ROLE_ID_SEQ";
drop trigger     "APX$APP_ROLE_BIU_TRG" ;
drop sequence    "APX$APP_STATUS_ID_SEQ";
drop trigger     "APX$APP_STATUS_BIU_TRG";
drop sequence    "APX$APP_USERROLE_SEQ";
drop trigger     "APX$APP_USRROL_BIU_TRG";
drop trigger     "APX$APP_USRDEFROL_TRG";
drop sequence    "APX$APP_SETTING_SEQ";
drop trigger     "APX$APP_SETTING_BIU_TRG";
drop sequence    "APX$APP_USREG_ID_SEQ";
drop trigger     "APX$APP_USRREG_BIU_TRG";

drop table       "APX$SYS_BUILTINS"      purge;
drop table       "APX$APP_SETTINGS"      purge;
drop table       "APX$APP_USER_ROLE_MAP" purge;
drop table       "APX$APP_USER_REG"      purge;
drop table       "APX$APP_USER"          purge;
drop table       "APX$APP_ROLE"          purge;
drop table       "APX$APP_GROUP"         purge;
drop table       "APX$APP_PRIVILEGES"    purge;
drop table       "APX$APP_DOMAIN"        purge;
drop table       "APX$APP_STATUS"        purge;
drop table       "APX$APP_SCOPE"         purge;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Snapshots and Views

drop view "APEX_ALL_APPLICATIONS";
drop view "APEX_USER_APPLICATIONS";
drop view "APEX_INTERNAL_APPLICATIONS";
drop view "APEX_WORKSPACE_APPLICATIONS";
drop view "APEX_APPLICATION";
drop view "APEX_STATUS";
drop view "APEX_ACCOUNT_STATUS";
drop view "APEX_APPLICATION_STATUS";
drop view "APEX_ALL_ROLES";
drop view "APEX_ROLES";
drop view "APEX_APPLICATION_ROLES";
drop view "APEX_DEFAULT_ROLE";
drop view "APEX_ALL_USERS";
drop view "APEX_USERS"; 
drop view "APEX_USER_ROLES";
drop view "WORKSPACE_ADMINS";
drop view "APPLICATION_ADMINS";
drop view "APEX_APP_SYS_BUILTINS";

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Functions

drop function "GET_CODE_SECURITY_LEVEL";
drop function "GET_ROLE_CODE_SECURITY_LEVEL";
drop function "GET_ROLE_SECURITY_LEVEL";
drop function "GET_SECURITY_LEVEL";
drop function "GET_USER_SECURITY_LEVEL";
drop function "HAS_ROLE";
drop function "IS_SYS_CODE";
drop function "IS_SYS_ROLE";
drop function "IS_SYS_USER";
drop function "IS_USER";
