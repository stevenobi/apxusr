--- APEX User Management Objects Drop ---


-----------------------------------------------------------------------------------------------------
--
-- Stefan Obermeyer 12.2016
--
-- 12.12.2016 SOB created
-- 27.01.2017 SOB Outfactored into separate file.
--
-----------------------------------------------------------------------------------------------------

drop sequence    "APEX_APP_USER_ID_SEQ";
drop trigger     "APEX_APP_USER_BIU_TRG" ;
drop sequence    "APEX_APP_ROLE_ID_SEQ";
drop trigger     "APEX_APP_ROLE_BIU_TRG" ;
drop sequence    "APEX_APP_STATUS_ID_SEQ";
drop trigger     "APEX_APP_STATUS_BIU_TRG";
drop sequence    "APEX_APP_USERROLE_SEQ";
drop trigger     "APEX_APP_USRROL_BIU_TRG";
drop trigger     "APEX_APPUSRDEFROL_TRG";

drop table       "APEX_APP_USER_ROLE_MAP"  purge;
drop table       "APEX_APP_USER"           purge;
drop table       "APEX_APP_ROLE"           purge;
drop table       "APEX_APP_STATUS"         purge;
drop table       "APEX_SYS_PRINCIPALS"     purge;

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
