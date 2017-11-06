--- APEX User Management ---



-----------------------------------------------------------------------------------------------------
--
-- Trivadis GmbH 12.2016
--
-- 12.12.2016 SOB created
-- 19.12.2016 SOB modified INSERT/UPDATE Trigger to get UserID for DB and APEX Users
-- 08.01.2017 SOB added Trigger for User INSERTs and Default Role changes.
-- 02.06.2017 SOB added BUILTINs
--
-----------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
-- Status Table for Application, Users, Roles,...
create table "APEX_APP_STATUS" (
app_status_id number not null primary key,
app_status varchar2(64) not null,
app_status_code varchar2(3),
app_status_scope varchar2(20),
app_id number,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64)
);

create unique index "APEX_APP_STATUS_UNQ" on "APEX_APP_STATUS"(upper(app_status), upper(app_status_scope), app_id);
create index "APEX_APP_STATUS_CODE" on "APEX_APP_STATUS"(app_status_code, app_status);
create index "APEX_APP_STATUS_APP_ID" on "APEX_APP_STATUS"(app_id);

create sequence "APEX_APP_STATUS_ID_SEQ" start with 1 increment by 1 nocache;

create or replace trigger "APEX_APP_STATUS_BIU_TRG"
before insert or update on APEX_APP_STATUS
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.app_status_id is null) then
        select APEX_APP_STATUS_ID_SEQ.nextval
        into :new.app_status_id
        from dual;
    end if;
    select sysdate, nvl(v('APP_USER'), user)
    into :new.created, :new.created_by
    from dual;
  elsif updating then
    select sysdate, nvl(v('APP_USER'), user)
    into :new.modified, :new.modified_by
    from dual;
  end if;
end;
/

--------------------------------------------------------------------------------------
-- Application Roles
create table "APEX_APP_ROLE" (
app_role_id number not null primary key,
app_rolename varchar2(64) not null,
app_role_code varchar2(8) null,
app_role_description varchar2(128),
app_role_status_id number,
app_role_scope number,
app_id number,
app_parent_role_id number,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APXAPPROLE_STATUS_FK" foreign key (app_role_status_id) references "APEX_APP_STATUS"(app_status_id) on delete set null
);

alter table "APEX_APP_ROLE" add constraint "APXAPPROLE_PARENT_FK" foreign key (app_parent_role_id)
references "APEX_APP_ROLE"(app_role_id) on delete set null;

create unique index "APEX_APP_ROLE_UNQ" on "APEX_APP_ROLE"(upper(app_rolename), upper(app_role_scope), app_id);
create index "APEX_APP_ROLE_CODE" on "APEX_APP_ROLE"(app_role_code, app_rolename);
create index "APEX_APP_ROLENAME" on "APEX_APP_ROLE"(app_rolename);
create index "APEX_APP_ROLE_STATUS_FK" on "APEX_APP_ROLE"(app_role_status_id);
create index "APEX_APP_ROLE_APP_ID" on "APEX_APP_ROLE"(app_id);

create sequence "APEX_APP_ROLE_ID_SEQ" start with 50 increment by 10 nocache;

create or replace trigger "APEX_APP_ROLE_BIU_TRG"
before insert or update on APEX_APP_ROLE
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.app_role_id is null) then
        select apex_app_role_id_seq.nextval
        into :new.app_role_id
        from dual;
    end if;
    select sysdate, nvl(v('APP_USER'), user)
    into :new.created, :new.created_by
    from dual;
  elsif updating then
    select sysdate, nvl(v('APP_USER'), user)
    into :new.modified, :new.modified_by
    from dual;
  end if;
end;
/

--------------------------------------------------------------------------------------
-- Application User
create table "APEX_APP_USER" (
app_user_id number not null primary key,
app_username varchar2(64) not null,
app_user_email varchar2(64) not null,
app_user_default_role_id number default 1 not null, -- 0 PUBLIC, 1 USER
app_user_code varchar2(8),
app_user_ad_login varchar2(64),
app_user_novell_login varchar2(64),
app_user_first_name varchar2(32),
app_user_last_name varchar2(32),
app_user_adress varchar2(64),
app_user_phone1 varchar2(64),
app_user_phone2 varchar2(64),
app_user_description varchar2(128),
app_user_status_id number default 1,
app_user_parent_user_id number,
app_id number,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APXAPPUSER_STATUS_FK" foreign key (app_user_status_id) references "APEX_APP_STATUS"(app_status_id) on delete set null,
constraint "APXAPPUSER_DEFROLE_FK" foreign key (app_user_default_role_id) references "APEX_APP_ROLE"(app_role_id)
);

alter table "APEX_APP_USER" add constraint "APXAPPUSER_PARENT_FK" foreign key (app_user_parent_user_id)
references "APEX_APP_USER"(app_user_id) on delete set null;

create unique index "APEX_APP_USER_UNQ" on "APEX_APP_USER"(upper(app_username), upper(app_user_email), app_id);
create index "APEX_APP_USER_EMAIL" on "APEX_APP_USER"(app_user_email);
create index "APEX_APP_USERNAME" on "APEX_APP_USER"(app_username);
create index "APEX_APP_USER_ADLOG" on "APEX_APP_USER"(app_user_ad_login, app_user_novell_login);
create index "APEX_APP_USER_APP_ID" on "APEX_APP_USER"(app_id);
create index "APEX_APP_USER_STATUS_FK" on "APEX_APP_USER"(app_user_status_id);
create index "APEX_APP_USER_DEFROLE_FK" on "APEX_APP_USER"(app_user_default_role_id);

create sequence "APEX_APP_USER_ID_SEQ" start with 2 increment by 1 nocache;

create or replace trigger "APEX_APP_USER_BIU_TRG"
before insert or update on "APEX_APP_USER"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.app_user_id is null) then
        select apex_app_user_id_seq.nextval
        into :new.app_user_id
        from dual;
    end if;
    select sysdate, nvl(v('APP_USER'), user)
    into :new.created, :new.created_by
    from dual;
  elsif updating then
    select sysdate, nvl(v('APP_USER'), user)
    into :new.modified, :new.modified_by
    from dual;
  end if;
end;
/

--------------------------------------------------------------------------------------
-- User Role Assignement
create table "APEX_APP_USER_ROLE_MAP" (
app_user_role_map_id number not null,
app_user_id number not null,
app_role_id number not null,
app_id number,
app_user_role_status_id number default 1,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX_APP_USERROLEMAP_PK" primary key (app_user_role_map_id),
constraint "APXAPPUSERROLE_STAT_FK" foreign key (app_user_role_status_id) references "APEX_APP_STATUS"(app_status_id) on delete set null,
constraint "APXAPPUSER_ID_FK" foreign key (app_user_id) references "APEX_APP_USER"(app_user_id) on delete cascade,
constraint "APXAPPROLE_ID_FK" foreign key (app_role_id) references "APEX_APP_ROLE"(app_role_id) on delete cascade
) organization index;

create index "APEX_APP_USERROLMAP_STAT" on "APEX_APP_USER_ROLE_MAP"(app_user_role_status_id);
create unique index "APEX_APP_USERROLEMAP_UNQ" on  "APEX_APP_USER_ROLE_MAP"(app_id, app_user_id, app_role_id);

create sequence "APEX_APP_USERROLE_SEQ" minvalue 0 start with 0 increment by 1 nocache;

create or replace trigger "APEX_APP_USRROL_BIU_TRG"
before insert or update on "APEX_APP_USER_ROLE_MAP"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.app_user_role_map_id is null) then
        select apex_app_userrole_seq.nextval
        into :new.app_user_role_map_id
        from dual;
    end if;
    select sysdate, nvl(v('APP_USER'), user)
    into :new.created, :new.created_by
    from dual;
  elsif updating then
    select sysdate, nvl(v('APP_USER'), user)
    into :new.modified, :new.modified_by
    from dual;
  end if;
end;
/

------------------------------------------------------------
-- set Roles based on default role setting in APEXP_APP_USER
-- Default Role for each new User = USER
create or replace trigger "APEX_APPUSRDEFROL_TRG"
after insert or update of app_user_default_role_id on "APEX_APP_USER"
referencing old as old new as new
for each row
declare
l_entries number;
begin
  if inserting then
      insert into "APEX_APP_USER_ROLE_MAP" (app_id, app_user_id, app_role_id)
      values (:new.app_id, :new.app_user_id, :new.app_user_default_role_id);
  elsif updating then
        update "APEX_APP_USER_ROLE_MAP"
        set  (app_role_id) = :new.app_user_default_role_id
        where app_user_id = :new.app_user_id
		  and app_id = :new.app_id
        and app_role_id = :old.app_user_default_role_id;
  end if;
end;
/

--------------------------------------------------------------------------------------
-- Application System Users, Roles,...
create table "APEX_SYS_BUILTINS" (
app_builtin_id number not null,
app_builtin_parent_id number,
app_id number,
app_user_id number,
app_role_id number,
is_admin number,
is_public number, 
is_default number,
constraint "APXSYSBUILTIN_IA_CHK" check (is_admin in(0, 1)),
constraint "APXSYSBUILTIN_IP_CHK" check (is_public in(0, 1)),
constraint "APXSYSBUILTIN_ID_CHK" check (is_default in(0, 1)),
constraint "APXSYSBUILTIN_PK" primary key (app_builtin_id),
constraint "APXAPPUSR_ID_FK" foreign key (app_user_id) references "APEX_APP_USER"(app_user_id) on delete cascade,
constraint "APXAPPROL_ID_FK" foreign key (app_role_id) references "APEX_APP_ROLE"(app_role_id) on delete cascade,
constraint "APXSYSBUILTINS_FK" foreign key (app_builtin_parent_id) references "APEX_SYS_BUILTINS"(app_builtin_id) on delete set null
) organization index;

create unique index "APEX_SYS_BUILTINS_UNQ" on  "APEX_SYS_BUILTINS"(app_id, app_user_id, app_role_id);

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Gather Stats for new/all Objects
--------------------------------------------------------------------------------------
begin
dbms_stats.gather_schema_stats(user);
end;
/

--------------------------------------------------------------------------------------
-- Grants
--------------------------------------------------------------------------------------

-- Tables
grant all on "APEX_APP_USER" to "APXADM";
grant all on "APEX_APP_ROLE" to "APXADM";
grant all on "APEX_APP_USER_ROLE_MAP" to "APXADM";
grant all on "APEX_APP_STATUS" to "APXADM";
grant all on "APEX_SYS_BUILTINS" to "APXADM";



Rem
Rem  APEX_USER_MGMT_DATA
Rem
--- APEX User Management Data ---


-----------------------------------------------------------------------------------------------------
--
-- Trivadis GmbH 12.2016
--
-- 12.12.2016 SOB created
-- 27.01.2017 SOB Outfactored into separate file.
--
-----------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Sample Data
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Status

-- DEFAULT Status first
INSERT INTO "APEX_APP_STATUS" (APP_STATUS_ID, APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE, APP_ID) 
VALUES ('0', 'DEFAULT', 'DEF', 'ALL', v('FB_FLOW_ID'));
-- Status by Scope
INSERT INTO "APEX_APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE, APP_ID) VALUES ('OPEN', 'OPN', 'ACCOUNT', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE, APP_ID) VALUES ('LOCKED', 'LCK', 'ACCOUNT', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE, APP_ID) VALUES ('EXPIRED', 'XPR', 'ACCOUNT', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE, APP_ID) VALUES ('SUSPENDED', 'SUS', 'ACCOUNT', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE, APP_ID) VALUES ('UP', 'UP', 'APPLICATION', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_STATUS" (APP_STATUS, APP_STATUS_CODE, APP_STATUS_SCOPE, APP_ID) VALUES ('DOWN', 'DWN', 'APPLICATION', v('FB_FLOW_ID'));

commit;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Roles 
-- can provide security levels groupwise in a up- or downwards security classification. 
-- In this case we go upwards, means the higher the group_id the higher the privileges, except for root, who is allways allowed to all at any time.
-- So we can ask if the role_id is greater/equal to the security level, or if user has_root (min(users_role_id = 0)) in VPD functions or Authorizations Schemes.
-- and thus the higher the Security Level of an object, item or page the higher the Role Security Level (i.e. the ROLE_ID) needs to be to access it.

-- Public and Internal Roles
INSERT INTO "APEX_APP_ROLE" (APP_ROLE_ID, APP_ROLENAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
VALUES ('0', 'PUBLIC', 'PUB', 'Public User', '2', v('FB_FLOW_ID'));

INSERT INTO "APEX_APP_ROLE" (APP_ROLE_ID, APP_ROLENAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
VALUES ('1', 'BENUTZER', 'USR', 'Application User.', '1', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_ROLE" (APP_ROLE_ID, APP_ROLENAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
VALUES ('10', 'LESEN', 'READ', 'Application ReadOnly Users (May read but not change Data)', '1', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_ROLE" (APP_ROLE_ID, APP_ROLENAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
VALUES ('20', 'SCHREIBEN', 'WRITE', 'Application ReadWrite Users (May read, write and change Data)', '1', v('FB_FLOW_ID'));

-- Higher Privileged Roles
INSERT INTO "APEX_APP_ROLE" (APP_ROLE_ID, APP_ROLENAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
VALUES ('1000', 'ADMINISTRATOR', 'ADM', 'Application Administrators', '1', v('FB_FLOW_ID'));
INSERT INTO "APEX_APP_ROLE" (APP_ROLE_ID, APP_ROLENAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
VALUES ('1010', 'MANAGEMENT', 'MGM', 'Company Managers', '1', v('FB_FLOW_ID'));

-- The Super User Role
--INSERT INTO "APEX_APP_ROLE" (APP_ROLE_ID, APP_ROLENAME, APP_ROLE_CODE, APP_ROLE_DESCRIPTION, APP_ROLE_STATUS_ID, APP_ID) 
--VALUES ('1000000', 'ROOT', 'ROOT', 'The Super User Role', '1', v('FB_FLOW_ID'));

commit;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Default User

-- Public Account a.k.a. ANONYMOUS
INSERT INTO "APEX_APP_USER" (APP_USER_ID, APP_USERNAME, APP_USER_EMAIL, APP_USER_CODE, APP_USER_DESCRIPTION, 
                                                                 APP_USER_STATUS_ID, APP_USER_DEFAULT_ROLE_ID, APP_ID) 
VALUES (0, 'PUBLIC', 'public@myComp.de', 'PUB', 'Application Public Account', 2, 0, v('FB_FLOW_ID'));

-- The Default APEX User (ADMIN) inherited from Workspace
INSERT INTO "APEX_APP_USER" (APP_USER_ID, APP_USERNAME, APP_USER_EMAIL, APP_USER_CODE, APP_USER_DESCRIPTION, 
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
 from "APEX_APP_USER" where app_username in ('PUBLIC', 'ADMIN')
 UNION
 select rownum+2, v('FB_FLOW_ID') as app_id, null, app_role_id,
  case when  app_role_code = 'ADM' then 1 else 0 end as is_admin,
  case when  app_role_code = 'PUB' then 1 else 0 end as is_public,
  1 as is_default
 from "APEX_APP_ROLE" where app_role_code in ('PUB', 'USR', 'ADM'));

commit;



Rem
Rem  APEX_USER_MGMT_VIEWS
Rem
--- APEX User Management Views ---



-----------------------------------------------------------------------------------------------------
--
-- Trivadis GmbH 12.2016
--
-- 19.12.2016 SOB created
-- 02.06.2017 SOB updated and added builtin users and roles
--
-----------------------------------------------------------------------------------------------------


set define off

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
where application_id not between 4000 and 9999 -- Apex INTERNAL Applications
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



Rem
Rem  APEX_USER_MGMT_FUNCTIONS
Rem

---------------------------------------------------------------------------------

--- APEX User Management Admin Function ---


-----------------------------------------------------------------------------------------------------
--
-- Trivadis GmbH 05.2017
--
-- 08.05.2017 SOB created
-- 02.06.2017 SOB updated IS_SYS_* functions
-- 04.06.2017 SOB added no_data_found for all select intos
--
-----------------------------------------------------------------------------------------------------

-- Is User a System User
create or replace function "IS_SYS_USER" (
p_username in varchar2
) return boolean
is
l_is_user pls_integer;
begin
  select 1 into l_is_user
  from "APEX_APP_SYS_USERS"
  where app_id = v('APP_ID')
      and upper(trim(app_username)) = upper(trim(p_username));
  if (l_is_user = 1) then
    return true;
  else
    return false;
  end if;
exception when no_data_found then
  return false;
end;
/


-- Is it a System Role
create or replace function "IS_SYS_ROLE" (
p_rolename in varchar2
) return boolean
is
l_is_role pls_integer;
begin
  select 1 into l_is_role
  from "APEX_APP_SYS_ROLES"
   where app_id = v('APP_ID')
      and upper(trim(app_rolename)) = upper(trim(p_rolename));
  if (l_is_role = 1) then
    return true;
  else
    return false;
  end if;
exception when no_data_found then
  return false;
end;
/


-- Is it the Code of a System User
create or replace function "IS_SYS_CODE" (
p_sys_code in varchar2
) return boolean
is
l_is_sys_code pls_integer;
begin
  select 1 into l_is_sys_code
  from "APEX_APP_SYS_BUILTINS"
   where app_id = v('APP_ID')
      and upper(trim(app_builtin_code)) = upper(trim(p_sys_code));
  if (l_is_sys_code = 1) then
    return true;
  else
    return false;
  end if;
exception when no_data_found then
  return false;  
end;
/


-- Is it the Code of a System User
create or replace function "GET_SECURITY_LEVEL" (
p_name in varchar2,
p_scope in varchar2 := 'USER' -- or ROLE
) return number
is
l_seclev number := 0;
begin
  if upper(p_scope) = 'USER' then
    select max_security_level
    into l_seclev
    from "APEX_USERS"
    where upper(trim(app_username)) = upper(trim(p_name));  
  elsif upper(p_scope) = 'ROLE' then
    select app_role_id
    into l_seclev 
    from "APEX_ROLES"
    where upper(trim(app_rolename)) = upper(trim(p_name));
  else
    l_seclev := 0;
  end if;      
return l_seclev;
exception when no_data_found then
  return 0;
end;
/


-- Is it the Code of a System User or Role
create or replace function "GET_CODE_SECURITY_LEVEL" (
p_code in varchar2,
p_scope in varchar2 := 'USER' -- or ROLE
) return number
is
l_seclev number := 0;
begin
  if upper(p_scope) = 'USER' then
    select max_security_level
    into l_seclev
    from "APEX_USERS"
    where upper(trim(app_user_code)) = upper(trim(p_code));  
  elsif upper(p_scope) = 'ROLE' then
    select app_role_id
    into l_seclev 
    from "APEX_ROLES"
    where upper(trim(app_role_code)) = upper(trim(p_code));
  else
    l_seclev := 0;
  end if;      
return l_seclev;
exception when no_data_found then
  return 0;
end;
/

-- Wrapper Function for System User
create or replace function "GET_USER_SECURITY_LEVEL" (
p_name in varchar2)
return number
is
begin
  return "GET_SECURITY_LEVEL" (p_name, 'USER');
end;
/

-- Wrapper Function for System Roles
create or replace function "GET_ROLE_SECURITY_LEVEL" (
p_name in varchar2)
return number
is
begin
  return "GET_SECURITY_LEVEL" (p_name, 'ROLE');
end;
/

-- Wrapper Function for System Role Codes
create or replace function "GET_ROLE_CODE_SECURITY_LEVEL" (
p_code in varchar2)
return number
is
begin
  return "GET_CODE_SECURITY_LEVEL" (p_code, 'ROLE');
end;
/


-- User has Role?
create or replace function "HAS_ROLE" (
p_name in varchar2,
p_role in varchar2,
p_strict in boolean default false)
return boolean
is
l_has_role pls_integer := 0;
l_role_sec_level pls_integer;
l_user_sec_level pls_integer;
l_result boolean;
begin
 -- we want to check if the exact role is given
    select 1 into l_has_role
    from "APEX_USER_ROLES"
    where upper(trim(username)) = upper(trim(p_name))  
    and upper(trim(role_name)) = upper(trim(p_role));
  if l_has_role = 1 then
    l_result := true;
  else
    l_result := false;
  end if;    
return l_result;
end;
/


-- is User
create or replace function "IS_USER" (
p_name in varchar2,
p_role in varchar2)
return boolean
is
begin
  return "HAS_ROLE" (p_name, p_role);
end;
/



