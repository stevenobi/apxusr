--- APEX User Management Data ---


-----------------------------------------------------------------------------------------------------
--
-- Stefan Obermeyer 12.2016
--
-- 12.12.2016 SOB created
-- 27.01.2017 SOB Outfactored into separate file.
--
-----------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------

-- Sample Data

-----------------------------------------------------------------------------------------------------

-- Scopes

-- DEFAULT Scopes first
insert into "APX$APP_SCOPE" (APP_SCOPE_ID, APP_SCOPE, APP_SCOPE_CODE, APP_ID) 
values ('0', 'DEFAULT', 'DEF', V('FB_FLOW_ID'));
-- App Scopes
insert into "APX$APP_SCOPE" (APP_SCOPE, APP_SCOPE_CODE, APP_ID) 
values ('ALL', 'ALL', V('FB_FLOW_ID'));
insert into "APX$APP_SCOPE" (APP_SCOPE, APP_SCOPE_CODE, APP_ID) 
values ('DOMAIN', 'DOM', V('FB_FLOW_ID'));
insert into "APX$APP_SCOPE" (APP_SCOPE, APP_SCOPE_CODE, APP_ID) 
values ('APPLICATION', 'APP', V('FB_FLOW_ID'));
insert into "APX$APP_SCOPE" (APP_SCOPE, APP_SCOPE_CODE, APP_ID) 
values ('PAGE', 'PAGE', V('FB_FLOW_ID'));
insert into "APX$APP_SCOPE" (APP_SCOPE, APP_SCOPE_CODE, APP_ID) 
values ('ITEM', 'ITEM', V('FB_FLOW_ID'));
insert into "APX$APP_SCOPE" (APP_SCOPE, APP_SCOPE_CODE, APP_ID) 
values ('AUTHENTICATION', 'AUTH', V('FB_FLOW_ID'));
insert into "APX$APP_SCOPE" (APP_SCOPE, APP_SCOPE_CODE, APP_ID) 
values ('AUTHORIZATION', 'AUT', V('FB_FLOW_ID'));
insert into "APX$APP_SCOPE" (APP_SCOPE, APP_SCOPE_CODE, APP_ID) 
values ('PRIVILEGE', 'PRIV', V('FB_FLOW_ID'));
insert into "APX$APP_SCOPE" (APP_SCOPE, APP_SCOPE_CODE, APP_ID) 
values ('GROUP', 'GRP', V('FB_FLOW_ID'));
insert into "APX$APP_SCOPE" (APP_SCOPE, APP_SCOPE_CODE, APP_ID) 
values ('ROLE', 'ROLE', V('FB_FLOW_ID'));
insert into "APX$APP_SCOPE" (APP_SCOPE, APP_SCOPE_CODE, APP_ID) 
values ('USER', 'USER', V('FB_FLOW_ID'));
insert into "APX$APP_SCOPE" ( APP_SCOPE, APP_SCOPE_CODE, APP_ID) 
values ('ACCOUNT', 'ACC', V('FB_FLOW_ID'));

commit;


-----------------------------------------------------------------------------------------------------
-- Status

-- DEFAULT Status first

insert into APX$APP_STATUS (APP_STATUS_ID, APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE_ID, APP_ID)
values ('0', 'DEFAULT', 'DEF', (SELECT APP_SCOPE_ID from APX$APP_SCOPE WHERE APP_SCOPE = 'ALL'), V('FB_FLOW_ID'));
-- Status by Scope
insert into "APX$APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE_ID, APP_ID) 
values ('OPEN', 'OPN', (SELECT APP_SCOPE_ID from APX$APP_SCOPE where APP_SCOPE = 'ACCOUNT'), v('FB_FLOW_ID'));
insert into "APX$APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE_ID, APP_ID) 
values ('LOCKED', 'LCK', (SELECT APP_SCOPE_ID from APX$APP_SCOPE WHERE APP_SCOPE = 'ACCOUNT'), V('FB_FLOW_ID'));
insert into "APX$APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE_ID, APP_ID) 
VALUES ('EXPIRED', 'XPR', (SELECT APP_SCOPE_ID from APX$APP_SCOPE WHERE APP_SCOPE = 'ACCOUNT'), v('FB_FLOW_ID'));
insert into "APX$APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE_ID, APP_ID)
values ('SUSPENDED', 'SUS', (SELECT APP_SCOPE_ID from APX$APP_SCOPE WHERE APP_SCOPE = 'ACCOUNT'), V('FB_FLOW_ID'));
insert into "APX$APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE_ID, APP_ID) 
values ('UP', 'UP', (SELECT APP_SCOPE_ID from APX$APP_SCOPE WHERE APP_SCOPE = 'APPLICATION'), V('FB_FLOW_ID'));
insert into "APX$APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE_ID, APP_ID) 
values ('DOWN', 'DWN', (select APP_SCOPE_ID from APX$APP_SCOPE where APP_SCOPE = 'APPLICATION'), V('FB_FLOW_ID'));
insert into "APX$APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE_ID, APP_ID) 
VALUES ('NEW', 'NEW', (SELECT APP_SCOPE_ID from APX$APP_SCOPE WHERE APP_SCOPE = 'USER'), v('FB_FLOW_ID'));
insert into "APX$APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE_ID, APP_ID) 
values ('REGISTERED', 'REG', (select APP_SCOPE_ID from APX$APP_SCOPE where APP_SCOPE = 'USER'), V('FB_FLOW_ID'));
insert into "APX$APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE_ID, APP_ID) 
VALUES ('VERIFIED', 'VER', (SELECT APP_SCOPE_ID from APX$APP_SCOPE WHERE APP_SCOPE = 'USER'), v('FB_FLOW_ID'));
insert into "APX$APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE_ID, APP_ID) 
values ('VALID', 'VAL', (select APP_SCOPE_ID from APX$APP_SCOPE where APP_SCOPE = 'USER'), V('FB_FLOW_ID'));

commit;


-----------------------------------------------------------------------------------------------------
-- Domain

-- DEFAULT Domain first
insert into "APX$APP_DOMAIN" (APP_DOMAIN_ID, APP_DOMAIN_NAME, APP_DOMAIN, APP_DOMAIN_CODE, APP_DOMAIN_DESCRIPTION)
VALUES (0, 'Default Domain', 'default.net', 'DEF', 'Default Domain for Public or not yet registered Users');

-- Test Data
insert into "APX$APP_DOMAIN" (APP_DOMAIN_NAME, APP_DOMAIN, APP_DOMAIN_CODE, APP_DOMAIN_DESCRIPTION)
values ('My Domain', 'mydomain.de', 'MYD', 'Test Domain for Registration');


commit;


-----------------------------------------------------------------------------------------------------
-- Roles 
-- can provide security levels groupwise in a up- or downwards security classification. 
-- In this case we go upwards, means the higher the group_id the higher the privileges, except for root, who is allways allowed to all at any time.
-- So we can ask if the role_id is greater/equal to the security level, or if user has_root (min(users_role_id = 0)) in VPD functions or Authorizations Schemes.
-- and thus the higher the Security Level of an object, item or page the higher the Role Security Level (i.e. the ROLE_ID) needs to be to access it.

-- Public and Internal Roles
insert into "APX$APP_ROLE" (APP_ROLE_ID, APP_ROLE_NAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
VALUES (0, 'PUBLIC', 'PUB', 'Public User', '2', v('FB_FLOW_ID'));

INSERT INTO "APX$APP_ROLE" (APP_ROLE_ID, APP_ROLE_NAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
values (1, 'USER', 'USR', 'Application User.', '1', V('FB_FLOW_ID'));

-- Higher Privileged Roles
INSERT INTO "APX$APP_ROLE" (APP_ROLE_ID, APP_ROLE_NAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
values ('1000', 'ADMINISTRATOR', 'ADM', 'Application Administrators', '1', V('FB_FLOW_ID'));
INSERT INTO "APX$APP_ROLE" (APP_ROLE_ID, APP_ROLE_NAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
VALUES ('1010', 'MANAGEMENT', 'MGM', 'Company Managers', '1', v('FB_FLOW_ID'));

-- The Super User Role
--INSERT INTO "APX$APP_ROLE" (APP_ROLE_ID, APP_ROLENAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
--VALUES ('1000000', 'ROOT', 'ROOT', 'The Super User Role', '1', v('FB_FLOW_ID'));

commit;



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- User Registration

-- Test User Registrations
insert into APX$APP_USER_REG (APP_USERNAME,APP_USER_EMAIL,APP_USER_FIRST_NAME,APP_USER_LAST_NAME) 
values ('NewAppUser','someone@mydomain.de','Some','One');
insert into APX$APP_USER_REG (APP_USERNAME,APP_USER_EMAIL,APP_USER_FIRST_NAME,APP_USER_LAST_NAME)
values ('Someone Else','someoneelse@mydomain.de','Someone','Else');
insert into APX$APP_USER_REG (APP_USERNAME,APP_USER_EMAIL,APP_USER_FIRST_NAME,APP_USER_LAST_NAME)
values ('Yo Un','youn@mydomain.de','Yo','Un');

commit;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Default User

-- Public Account a.k.a. ANONYMOUS
INSERT INTO "APX$APP_USER" (APP_USER_ID, APP_USERNAME, APP_USER_EMAIL, APP_USER_CODE, APP_USER_DESCRIPTION, 
                                                                 APP_USER_STATUS_ID, APP_USER_DEFAULT_ROLE_ID, APP_ID) 
VALUES (0, 'PUBLIC', 'public@myComp.de', 'PUB', 'Application Public Account', 2, 0, v('FB_FLOW_ID'));

-- The Default APEX User (ADMIN) inherited from Workspace
INSERT INTO "APX$APP_USER" (APP_USER_ID, APP_USERNAME, APP_USER_EMAIL, APP_USER_CODE, APP_USER_DESCRIPTION, 
                                                                 APP_USER_STATUS_ID, APP_USER_DEFAULT_ROLE_ID, APP_ID) 
VALUES (1, 'ADMIN', 'admin@myComp.de', 'ADM', 'Application Admin Account (Apex Default)', 1, 1000, v('FB_FLOW_ID'));

commit;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- System BuiltIn Users and Roles
INSERT INTO "APEX_SYS_BUILTINS" (APP_BUILTIN_ID, APP_ID, APP_USER_ID, APP_ROLE_ID, IS_ADMIN, IS_PUBLIC, IS_DEFAULT)
(select rownum as id,  v('FB_FLOW_ID') as app_id,  app_user_id, 
  null as role_id,
  case when  app_username = 'ADMIN' then 1 else 0 end as is_admin,
  case when  app_username = 'PUBLIC' then 1 else 0 end as is_public,
  1 as is_default
 from "APX$APP_USER" where app_username in ('PUBLIC', 'ADMIN')
 UNION
 select rownum+2, v('FB_FLOW_ID') as app_id, null, app_role_id,
  case when  app_role_code = 'ADM' then 1 else 0 end as is_admin,
  case when  app_role_code = 'PUB' then 1 else 0 end as is_public,
  1 as is_default
 from "APX$APP_ROLE" where app_role_code in ('PUB', 'USR', 'ADM'));

commit;


