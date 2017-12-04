--- APEX User Management Views ---



-----------------------------------------------------------------------------------------------------
--
-- Stefan Obermeyer 12.2016
--
-- 19.12.2016 SOB created
-- 02.06.2017 SOB updated and added builtin users and roles
--
-----------------------------------------------------------------------------------------------------


set define off

--------------------------------------------------------------------------------------
-- All APEX Application Username format
create or replace view "APP_USERNAME_FORMAT"
as
select nvl(apx_config_value, apx_config_def_value) as username_format
from "APEX_SETTINGS"
where apx_config_name = 'USERNAME_FORMAT';


--------------------------------------------------------------------------------------
-- All APEX_APPLICATIONS
create  view "APEX_ALL_APPLICATIONS"
as
select a.workspace_id, a.workspace, a.application_id, a.owner, a.application_name, a.compatibility_mode,  a.home_link as home_link,
replace(replace (a.home_link, '&APP_ID.', a.application_id), ':&SESSION.', '') as home_link_apex,
a.login_url, a.theme_number, a.alias, a.pages, a.application_items, a.last_updated_by, a.last_updated_on,
a.authentication_schemes, a.authentication_scheme_type, a.authorization_schemes, a.authorization_scheme
from "APEX_APPLICATIONS" a
order by 2, 3;


-- all Applications that are not INTERNAL
create  view "APEX_USER_APPLICATIONS"
as
select workspace_id,
  workspace,
  application_id,
  owner,
  application_name,
  compatibility_mode,
  home_link,
  home_link_apex,
  login_url,
  theme_number,
  alias,
  pages,
  application_items,
  last_updated_by,
  last_updated_on,
  authentication_schemes,
  authentication_scheme_type,
  authorization_schemes,
  authorization_scheme
from "APEX_ALL_APPLICATIONS"
where workspace != 'INTERNAL' -- Apex INTERNAL Applications
order by 2, 3;


-- all Applications that are INTERNAL
create  view "APEX_INTERNAL_APPLICATIONS"
as
select workspace_id,
  workspace,
  application_id,
  owner,
  application_name,
  compatibility_mode,
  home_link,
  home_link_apex,
  login_url,
  theme_number,
  alias,
  pages,
  application_items,
  last_updated_by,
  last_updated_on,
  authentication_schemes,
  authentication_scheme_type,
  authorization_schemes,
  authorization_scheme
from "APEX_ALL_APPLICATIONS"
where workspace = 'INTERNAL' -- Apex INTERNAL Applications
order by 1, 3;


-- All APEX_APPLICATIONS except INTERNAL
create  view "APEX_WORKSPACE_APPLICATIONS"
as
select workspace_id, workspace, application_id, owner, application_name, compatibility_mode, home_link, home_link_apex, login_url, theme_number,
           alias, pages, application_items, last_updated_by, last_updated_on, authentication_schemes, authentication_scheme_type, authorization_schemes,
           authorization_scheme
from "APEX_ALL_APPLICATIONS"
where workspace != 'INTERNAL'
order by 2, 3;


-- current APEX_APPLICATION only
create  view "APEX_APPLICATION"
as
SELECT WORKSPACE_ID,
  WORKSPACE,
  APPLICATION_ID,
  OWNER,
  APPLICATION_NAME,
  COMPATIBILITY_MODE,
  HOME_LINK,
  HOME_LINK_APEX,
  LOGIN_URL,
  THEME_NUMBER,
  ALIAS,
  PAGES,
  APPLICATION_ITEMS,
  LAST_UPDATED_BY,
  LAST_UPDATED_ON,
  AUTHENTICATION_SCHEMES,
  AUTHENTICATION_SCHEME_TYPE,
  AUTHORIZATION_SCHEMES,
  AUTHORIZATION_SCHEME
FROM "APEX_ALL_APPLICATIONS"
WHERE APPLICATION_ID = v('APP_ID');

--------------------------------------------------------------------------------------
-- APEX Workspace
create view "APEX_WORKSPACE"
as
select workspace_id, workspace, application_id, owner
from "APEX_APPLICATION";

-- Workspace Users
create view "APEX_WORKSPACE_USERS"
as
  select au.workspace_id, au.workspace_name, au.first_schema_provisioned,
       au.user_name, au.first_name, au.last_name, au.email,
       au.date_created, au.date_last_updated, au.account_expiry,
       au.available_schemas, au.is_admin, au.is_application_developer,
       au.failed_access_attempts, au.account_locked
from "APEX_WORKSPACE_APEX_USERS" au join "APEX_WORKSPACE" aw
on (au.workspace_id = aw.workspace_id);


--------------------------------------------------------------------------------------
-- All Status
create  view "APEX_STATUS"
as
select
  app_id,
  app_status_id as status_id,
  app_status as status,
  app_status_code as status_code,
  app_status_scope as status_scope,
  created,
  created_by,
  modified,
  modified_by
from "APEX_APP_STATUS"
where app_id = v('APP_ID')
order by 1, 3;


-- User and Roles
create  view "APEX_ACCOUNT_STATUS"
as
select
  app_id,
  status_id,
  status,
  status_code,
  created,
  created_by,
  modified,
  modified_by
from "APEX_STATUS"
where STATUS_SCOPE = 'ACCOUNT'
order by 1, 3;


-- Application
create  view "APEX_APPLICATION_STATUS"
as
select
  app_id,
  status_id,
  status,
  status_code,
  created,
  created_by,
  modified,
  modified_by
from "APEX_STATUS"
where STATUS_SCOPE = 'APPLICATION'
order by 1, 3;


--------------------------------------------------------------------------------------
-- All Application Roles
create view "APEX_ALL_ROLES"
as
  select
  r.APP_ID,
  r.APP_ROLE_ID,
  r.APP_ROLENAME,
  r.APP_ROLE_CODE,
  r.APP_ROLE_DESCRIPTION,
  a.status as app_role_status ,
  r.APP_ROLE_SCOPE,
  r.APP_PARENT_ROLE_ID,
  (select ar.APP_ROLENAME
   from "APEX_APP_ROLE" ar
   where ar.APP_ROLE_ID = r.APP_PARENT_ROLE_ID) as parent_role,
  r.CREATED,
  r.CREATED_BY,
  r.MODIFIED,
  r.MODIFIED_BY
from "APEX_APP_ROLE" r left outer join  "APEX_ACCOUNT_STATUS" a
  on (r.APP_ROLE_STATUS_ID) = (a.status_id)
order by 1, 2
;


-- All Roles in current app
create or replace view "APEX_ROLES"
as
select
  APP_ID,
  APP_ROLE_ID,
  APP_ROLENAME,
  APP_ROLE_CODE,
  APP_ROLE_DESCRIPTION,
  APP_ROLE_STATUS,
  APP_ROLE_SCOPE,
  APP_PARENT_ROLE_ID,
  PARENT_ROLE
FROM "APEX_ALL_ROLES"
order by 1, 2;



-- All assigned Roles to currently connected APEX User
create view "APEX_USER_ROLE"
as
select
  ar.APP_ID,
  ar.APP_ROLE_ID,
  ar.APP_ROLENAME,
  ar.APP_ROLE_CODE,
  ar.APP_ROLE_DESCRIPTION,
  ar.APP_ROLE_STATUS,
  ar.APP_ROLE_SCOPE,
  ar.APP_PARENT_ROLE_ID,
  ar.PARENT_ROLE
FROM "APEX_ALL_ROLES" ar
WHERE exists (select 1 from APEX_APP_USER u
                        where u.APP_USER_DEFAULT_ROLE_ID = ar.APP_ROLE_ID
                        and u.APP_USERNAME = nvl(v('APP_USER'), user))
order by 1, 2
;


-- User's Default Role
create view "APEX_DEFAULT_ROLE"
as
SELECT u.APP_USER_ID,
  u.APP_USERNAME,
  u.APP_USER_EMAIL,
  u.APP_USER_CODE,
  u.APP_USER_DEFAULT_ROLE_ID,
  r.APP_ROLENAME as APP_USER_DEFAULT_ROLE,
  r.APP_ROLE_CODE as APP_USER_DEFAULT_ROLE_CODE,
  u.APP_USER_FIRST_NAME,
  u.APP_USER_LAST_NAME,
  r.APP_ROLE_DESCRIPTION
FROM "APEX_APP_USER" u
left outer join "APEX_APP_ROLE" r
on (u.APP_USER_DEFAULT_ROLE_ID = r.APP_ROLE_ID
    and u.APP_ID = r.APP_ID);


--------------------------------------------------------------------------------------
-- All User Accounts
CREATE VIEW "APEX_ALL_USERS"
 AS
  select  distinct
  u.APP_ID as APP_ID,
  u.APP_USER_ID,
  u.APP_USER_EMAIL,
  u.APP_USERNAME,
  a.STATUS as APP_USER_ACCOUNT_STATUS,
  u.APP_USER_AD_LOGIN,
  u.APP_USER_NOVELL_LOGIN,
  u.APP_USER_DEFAULT_ROLE_ID,
  ar.APP_ROLENAME as DEFAULT_ROLE,
  u.APP_USER_PARENT_USER_ID,
  (select au.app_username
  from "APEX_APP_USER" au
  where au.app_user_id = u.app_user_parent_user_id) as parent_username,
  max(rm.app_role_id) over (partition by rm.app_user_id) as max_security_level,
  min(rm.app_role_id) over (partition by rm.app_user_id) as min_security_level,
  u.APP_USER_CODE,
  u.CREATED,
  u.CREATED_BY,
  u.MODIFIED,
  u.MODIFIED_BY
from "APEX_APP_USER" u
left outer join  "APEX_ACCOUNT_STATUS" a
on (u.APP_USER_STATUS_ID = a.status_id
   and u.APP_ID = a.APP_ID)
left outer join  "APEX_ROLES" ar
on (ar.APP_ROLE_ID = u.APP_USER_DEFAULT_ROLE_ID
    and ar.APP_ID = u.APP_ID)
left outer join "APEX_APP_USER_ROLE_MAP" rm
on (u.APP_USER_ID = rm.APP_USER_ID
    and u.APP_ID = rm.APP_ID)
;

-- User Accounts
create  view "APEX_USERS"
as
SELECT
  APP_ID,
  APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_ACCOUNT_STATUS,
  APP_USER_AD_LOGIN,
  APP_USER_NOVELL_LOGIN,
  APP_USER_CODE,
  APP_USER_DEFAULT_ROLE_ID as DEFAULT_SECURITY_LEVEL,
  MAX_SECURITY_LEVEL,
  MIN_SECURITY_LEVEL
FROM "APEX_ALL_USERS"
order by 1, 2;


--------------------------------------------------------------------------------------
-- Roles assigned to User
create  view "APEX_USER_ROLES"
as
select
  nvl(u.app_id, v('APP_ID')) as app_id,
  rm.app_user_id as user_id,
  u.app_username as username,
  u.app_user_email as user_email,
  s1.app_status as user_status,
  rm.app_role_id as role_id,
  r.app_rolename as role_name,
  s2.app_status as role_status,
  u.app_user_ad_login as ad_login,
  u.app_user_novell_login as novell_login,
  u.app_user_parent_user_id as parent_user_id,
  (select au.app_username
   from "APEX_APP_USER" au
   where au.app_user_id = u.app_user_parent_user_id) as parent_username,
   max(rm.app_role_id) over (partition by rm.app_user_id) as maximum_security_level,
   min(rm.app_role_id) over (partition by rm.app_user_id) as minimum_security_level,
  rm.created,
  rm.created_by,
  rm.modified,
  rm.modified_by
from "APEX_APP_USER_ROLE_MAP" rm
join "APEX_APP_USER" u
on rm.app_user_id = u.app_user_id
join "APEX_APP_STATUS" s1
on u.app_user_status_id = s1.app_status_id
left outer join "APEX_APPLICATIONS" a
on u.APP_ID = a.APPLICATION_ID
join "APEX_APP_ROLE" r
on rm.app_role_id = r.app_role_id
join "APEX_APP_STATUS" s2
on r.app_role_status_id = s2.app_status_id
order by 1, 2, 3;


--------------------------------------------------------------------------------------
-- Application System (BuiltIn) Users and Roles
create view "APEX_APP_SYS_BUILTINS"
as
select
  b.APP_ID,
  b.APP_BUILTIN_ID,
  b.APP_BUILTIN_PARENT_ID,
  b.APP_USER_ID,
  u.APP_USERNAME as APP_BUILTIN_NAME,
  u.APP_USER_CODE as APP_BUILTIN_CODE,
  b.IS_ADMIN,
  b.IS_PUBLIC,
  b.IS_DEFAULT,
  'USER' as APP_BUILTIN_TYPE
FROM "APEX_SYS_BUILTINS" b join "APEX_USERS" u
on (b.APP_USER_ID = u.APP_USER_ID)
where b.APP_USER_ID is not null
  and b.APP_ID = v('APP_ID')
union all
select
  b.APP_ID,
  b.APP_BUILTIN_ID,
  b.APP_BUILTIN_PARENT_ID,
  b.APP_USER_ID,
  r.APP_ROLENAME as APP_BUILTIN_NAME,
  r.APP_ROLE_CODE as APP_BUILTIN_CODE,
  b.IS_ADMIN,
  b.IS_PUBLIC,
  b.IS_DEFAULT,
  'ROLE' as APP_BUILTIN_TYPE
FROM "APEX_SYS_BUILTINS" b join "APEX_ROLES" r
on (b.APP_USER_ID = r.APP_ROLE_ID)
where b.APP_ROLE_ID is not null
  and b.APP_ID = v('APP_ID');


-- Application System (BuiltIn) Users
create view "APEX_APP_SYS_USERS"
as
select
  APP_BUILTIN_ID,
  APP_BUILTIN_PARENT_ID,
  APP_ID,
  APP_USER_ID,
  APP_BUILTIN_NAME as APP_USERNAME,
  APP_BUILTIN_CODE as APP_USER_CODE
from "APEX_APP_SYS_BUILTINS"
where APP_BUILTIN_TYPE = 'USER'
;


-- Application System (BuiltIn) Roles
create view "APEX_APP_SYS_ROLES"
as
select
  APP_BUILTIN_ID,
  APP_BUILTIN_PARENT_ID,
  APP_ID,
  APP_USER_ID,
  APP_BUILTIN_NAME as APP_ROLENAME,
  APP_BUILTIN_CODE as APP_ROLE_CODE
from "APEX_APP_SYS_BUILTINS"
where APP_BUILTIN_TYPE = 'ROLE'
;


--------------------------------------------------------------------------------
-- Workspace Admins
create or replace view "WORKSPACE_ADMINS"
as
select user_name, 'WORKSPACE_ADMIN_USER' as "APPLICATION_ROLE"
from "APEX_WORKSPACE_USERS"
where IS_ADMIN = 'Yes'
union
select owner, 'APPLICATION_OWNER'  as "APPLICATION_ROLE"
from "APEX_WORKSPACE";

-- Application Admins
create or replace view "APPLICATION_ADMINS"
as
select app_builtin_name as "APP_USERNAME", 'APPLICATION_ADMIN_USER' as "APPLICATION_ROLE"
from "APEX_APP_SYS_BUILTINS"
where   app_builtin_type = 'USER'
and is_admin = 1;


create view "APEX_APPLICATION_ROLES"
as
  select
  APP_ID,
  APP_ROLE_ID,
  APP_ROLENAME,
  APP_ROLE_CODE,
  APP_ROLE_DESCRIPTION,
  APP_ROLE_STATUS,
  APP_ROLE_SCOPE,
  APP_PARENT_ROLE_ID,
  PARENT_ROLE,
  CREATED,
  CREATED_BY,
  MODIFIED,
  MODIFIED_BY
from "APEX_ALL_ROLES"
order by APP_ROLE_ID
;


set define on

-- View Grants
grant select on "APEX_APPLICATION" to "APXADM";
grant select on "APEX_STATUS" to "APXADM";
grant select on "APEX_ACCOUNT_STATUS" to "APXADM";
grant select on "APEX_APPLICATION_STATUS"to "APXADM";
grant select on "APEX_ALL_ROLES" to "APXADM";
grant select on "APEX_ROLES" to "APXADM";
grant select on "APEX_DEFAULT_ROLE" to "APXADM";
grant select on "APEX_ALL_USERS" to "APXADM";
grant select on "APEX_USERS" to "APXADM";
grant select on "APEX_USER_ROLES" to "APXADM";
grant select on "APEX_WORKSPACE" to "APXADM";
grant select on "APEX_WORKSPACE_USERS" to "APXADM";
grant select on "WORKSPACE_ADMINS" to "APXADM";
grant select on "APPLICATION_ADMINS" TO "APXADM";
grant select on "APEX_APP_SYS_USERS" TO "APXADM";
grant select on "APEX_APP_SYS_ROLES" TO "APXADM";
grant select on "APEX_APP_SYS_BUILTINS" TO "APXADM";

