
---------------------------------------------------------------
       ---- 17/12/19 22:54 Begin of SQL Build APX ----


-- SQL Drop File
-- whenever oserror exit;
--whenever sqlerror exit sql.sqlcode;
set pages 0 line 120 define on verify off feed off echo off
alter session set nls_date_format='DD.MM.YYYY HH24:MI:SS';
select sysdate || '     Dropping: "&1. Objects"' as install_message
from dual;

---------------------------------------------------------------
prompt
prompt Dropping DB Model (Tables)
prompt


--@"/Users/stefan/Library/Mobile Documents/com~apple~CloudDocs/Projects/APEX/apx/workarea/plsql/packages/apxusr/workarea/model/apxusr_drop.sql"


-------------------------------------------------------------------------------
-- Apex User, Groups, Domains Tables and Views
prompt APX$BUILTIN
drop synonym     "APEX_BUILTIN";
drop table       "APX$BUILTIN"       purge;


prompt APX$USER_ROLE_MAP
drop synonym     "APEX_USER_ROLE_MAP";
drop trigger     "APX$USRDEFROL_TRG";
drop sequence    "APX$USERROLE_SEQ";
drop trigger     "APX$USRROL_BIU_TRG";
drop table       "APX$USER_ROLE_MAP" purge;


prompt APX$USER_REGISTRATION
drop synonym     "APEX_USER_REGISTRATION";
drop synonym     "APEX_USREG";
drop sequence    "APX$USREG_ID_SEQ";
drop trigger     "APX$USRREG_BIU_TRG";
drop table       "APX$USER_REG"      purge;

prompt APX$USER
drop synonym     "APEX_USER";
drop sequence    "APX$USER_ID_SEQ";
drop trigger     "APX$USER_BIU_TRG" ;
drop table       "APX$USER"          purge;


prompt APX$ROLE
drop synonym     "APEX_ROLE";
drop sequence    "APX$ROLE_ID_SEQ";
drop trigger     "APX$ROLE_BIU_TRG" ;
drop table       "APX$ROLE"          purge;


prompt APX$PRIVILEGE
drop synonym     "APEX_PRIVILEGE";
drop sequence    "APX$PRIV_ID_SEQ";
drop trigger     "APX$PRIV_BIU_TRG";
drop table       "APX$PRIVILEGE"     purge;


prompt APX$DOMAIN
drop synonym     "APEX_DOMAIN";
drop sequence    "APX$DOMAIN_ID_SEQ";
drop trigger     "APX$DOMAIN_BIU_TRG";
drop table       "APX$DOMAIN"        purge;


prompt APX$GROUP
drop synonym     "APEX_GROUP";
drop sequence    "APX$GROUP_ID_SEQ";
drop trigger     "APX$GROUP_BIU_TRG";
drop table       "APX$GROUP"         purge;


set pages 0 line 120 define off verify off feed off echo off timing off

--exit;

---------------------------------------------------------------

--- APEX User Management ---

-- SQL Create File
-- whenever oserror exit;
whenever sqlerror exit sql.sqlcode; -- useful only if drop.sql is used or in production mode
set pages 0 line 120 define on verify off feed off echo off
alter session set nls_date_format='DD.MM.YYYY HH24:MI:SS';
select sysdate || '     Creating: "&1. Database Model"' as install_message
from dual;
set feed on timing on


---------------------------------------------------------------
prompt
prompt Creating &1 DB Model (Tables)


-----------------------------------------------------------------------------------------------------
--
-- Stefan Obermeyer 12.2016
--
-- 12.12.2016 SOB created
-- 19.12.2016 SOB modified INSERT/UPDATE Trigger to get UserID for DB and APEX Users
-- 08.01.2017 SOB added Trigger for User INSERTs and Default Role changes.
-- 02.06.2017 SOB added BUILTINs
-- 06.11.2017 SOB added Scopes, Domains, Groups and Privileges
-- 17.12.2017 SOB renamed to apx_ and switched Domain Group paradigm
--
-----------------------------------------------------------------------------------------------------

-- @requires APX$ model (Status, Context, ...)


--------------------------------------------------------------------------------
-- APEX User's, Groups, Domains,...
--------------------------------------------------------------------------------

-- -- Apex User Session Tables and Views

-- -- -- drop first

-- -- -- comes with apx
-- -- drop synonym     "APEX_USER_SESSION";
-- -- drop view        "APEX_USER_SESSIONS";
-- -- drop sequence    "APX$USERSESS_SEQ";
-- -- drop trigger     "APX$USERSESS_BI_TRG";
-- -- drop table       "APX$USR_SESSION"  purge;


-- drop synonym     "APEX_BUILTIN";
-- drop table       "APX$BUILTIN"       purge;


-- drop synonym     "APEX_USER_ROLE_MAP";
-- drop trigger     "APX$USRDEFROL_TRG";
-- drop sequence    "APX$USERROLE_SEQ";
-- drop trigger     "APX$USRROL_BIU_TRG";
-- drop table       "APX$USER_ROLE_MAP" purge;


-- drop synonym     "APEX_USER_REGISTRATION";
-- drop synonym     "APEX_USREG";
-- drop sequence    "APX$USREG_ID_SEQ";
-- drop trigger     "APX$USRREG_BIU_TRG";
-- drop table       "APX$USER_REG"      purge;


-- drop synonym     "APEX_USER";
-- drop sequence    "APX$USER_ID_SEQ";
-- drop trigger     "APX$USER_BIU_TRG" ;
-- drop table       "APX$USER"          purge;


-- drop synonym     "APEX_ROLE";
-- drop sequence    "APX$ROLE_ID_SEQ";
-- drop trigger     "APX$ROLE_BIU_TRG" ;
-- drop table       "APX$ROLE"          purge;


-- drop synonym     "APEX_PRIVILEGE";
-- drop sequence    "APX$PRIV_ID_SEQ";
-- drop trigger     "APX$PRIV_BIU_TRG";
-- drop table       "APX$PRIVILEGE"     purge;


-- drop synonym     "APEX_DOMAIN";
-- drop sequence    "APX$DOMAIN_ID_SEQ";
-- drop trigger     "APX$DOMAIN_BIU_TRG";
-- drop table       "APX$DOMAIN"        purge;


-- drop synonym     "APEX_GROUP";
-- drop sequence    "APX$GROUP_ID_SEQ";
-- drop trigger     "APX$GROUP_BIU_TRG";
-- drop table       "APX$GROUP"         purge;


--------------------------------------------------------------------------------------
-- Application Groups
create table "APX$GROUP" (
apx_group_id number not null,
apx_group_name varchar2(64) not null,
apx_group_code varchar2(8) null,
apx_group_description varchar2(128),
apx_group_status_id number,
apx_group_context_id number,
apx_parent_group_id number,
apx_group_sec_level number default 0,
app_id number,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX$GROUP_GROUP_ID" primary key (apx_group_id),
constraint "APX$GROUP_CTX_FK" foreign key (apx_group_context_id) references "APX$CTX"(apx_context_id) on delete set null,
constraint "APX$GROUP_STATUS_FK" foreign key (apx_group_status_id) references "APX$STATUS"(apx_status_id) on delete set null,
constraint "APX$GROUP_PARENT_FK" foreign key (apx_parent_group_id) references "APX$GROUP"(apx_group_id) on delete set null
);

create unique index "APX$GROUP_UNQ1"   on "APX$GROUP"(upper(trim(apx_group_name)), apx_group_context_id, app_id);
create unique index "APX$GROUP_UNQ2"   on "APX$GROUP"(upper(trim(apx_group_code)), apx_group_context_id, app_id);
create unique index "APX$GROUP_UNQ3"   on "APX$GROUP"(upper(trim(apx_group_name)), upper(trim(apx_group_code)), apx_group_context_id, app_id);
create index "APX$GROUP_STATUS_FK_IDX" on "APX$GROUP"(apx_group_status_id);
create index "APX$GROUP_PARENT_FK_IDX" on "APX$GROUP"(apx_parent_group_id);
create index "APX$GROUP_SECLEV"        on "APX$GROUP"(apx_group_sec_level);
create index "APX$GROUP_APX_ID"        on "APX$GROUP"(app_id);


create sequence "APX$GROUP_ID_SEQ" start with 10 increment by 1 nocache;

create or replace trigger "APX$GROUP_BIU_TRG"
before insert or update on "APX$GROUP"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.apx_group_id is null) then
        select "APX$GROUP_ID_SEQ".NEXTVAL
        into :new.apx_group_id
        from dual;
    end if;
    if (:new.app_id is null) then
        select nvl2(v('FB_FLOW_ID'), v('FB_FLOW_ID'), v('APP_ID'))
        into :new.app_id
        from dual;
    end if;
    select sysdate, nvl(v('APX_USER'), user)
    into :new.created, :new.created_by
    from dual;
  elsif updating then
    select sysdate, nvl(v('APX_USER'), user)
    into :new.modified, :new.modified_by
    from dual;
  end if;
end;
/


--------------------------------------------------------------------------------------
-- Synonyms on APX$GROUP
create synonym  "APEX_GROUP"           for "APX$GROUP";


--------------------------------------------------------------------------------------
-- Application Domains
create table "APX$DOMAIN" (
apx_domain_id number not null,
apx_domain varchar2(64) not null, -- fully qualified domain name (f.e.: mydomain.net)
apx_domain_name varchar2(64) not null, -- conceptual name like MyDomain
apx_domain_code varchar2(8) null,
apx_domain_description varchar2(128),
apx_parent_domain_id number,
apx_domain_status_id number,
apx_domain_group_id number default 1,
apx_domain_sec_level number default 0,
apx_domain_context_id number default 0,
apx_domain_homepage varchar2(1000),
app_id number default 0,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX$DOMAIN_DOMAIN_ID" primary key (apx_domain_id),
constraint "APX$DOMAIN_CTX_ID_FK" foreign key (apx_domain_context_id) references "APX$CTX"(apx_context_id) on delete set null,
constraint "APX$DOMAIN_STATUS_FK" foreign key (apx_domain_status_id) references "APX$STATUS"(apx_status_id) on delete set null,
constraint "APX$DOMAIN_GROUP_ID_FK" foreign key (apx_domain_group_id) references "APX$GROUP"(apx_group_id) on delete set null,
constraint "APX$DOMAIN_PARENT_FK" foreign key (apx_parent_domain_id) references "APX$DOMAIN"(apx_domain_id) on delete set null
);

create unique index "APX$DOMAIN_UNQ1"   on "APX$DOMAIN"(upper(trim(apx_domain_name)), app_id);
create unique index "APX$DOMAIN_UNQ2"   on "APX$DOMAIN"(upper(trim(apx_domain)), app_id);
create unique index "APX$DOMAIN_UNQ3"   on "APX$DOMAIN"(upper(trim(apx_domain_name)), upper(trim(apx_domain)), app_id);
create index "APX$DOMAIN_GROUP_FK_IDX"  on "APX$DOMAIN"(apx_domain_group_id);
create index "APX$DOMAIN_STATUS_FK_IDX" on "APX$DOMAIN"(apx_domain_status_id);
create index "APX$DOMAIN_PARENT_FK_IDX" on "APX$DOMAIN"(apx_parent_domain_id);
create index "APX$DOMAIN_SECLEV"        on "APX$DOMAIN"(apx_domain_sec_level);
create index "APX$DOMAIN_APX_ID"        on "APX$DOMAIN"(app_id);


create sequence "APX$DOMAIN_ID_SEQ" start with 10 increment by 1 nocache;

create or replace trigger "APX$DOMAIN_BIU_TRG"
before insert or update on "APX$DOMAIN"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.apx_domain_id is null) then
        select "APX$DOMAIN_ID_SEQ".NEXTVAL
        into :new.apx_domain_id
        from dual;
    end if;
    if (:new.app_id is null) then
        select nvl2(v('FB_FLOW_ID'), v('FB_FLOW_ID'), v('APP_ID'))
        into :new.app_id
        from dual;
    end if;
    select sysdate, nvl(v('APX_USER'), user)
    into :new.created, :new.created_by
    from dual;
  elsif updating then
    select sysdate, nvl(v('APX_USER'), user)
    into :new.modified, :new.modified_by
    from dual;
  end if;
end;
/

--------------------------------------------------------------------------------------
-- Synonyms on APX$DOMAIN
create synonym  "APEX_DOMAIN"           for "APX$DOMAIN";


--------------------------------------------------------------------------------------
-- Application Privileges
create table "APX$PRIVILEGE" (
apx_priv_id number not null,
apx_privilege varchar2(64) not null,
apx_priv_code varchar2(12) null,
apx_priv_description varchar2(128),
apx_priv_status_id number,
apx_priv_context_id number,
app_id number,
apx_parent_priv_id number,
apx_priv_sec_level number default 0,
apx_priv_domain_id number default 0,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX$PRIV_PRIV_ID" primary key (apx_priv_id),
constraint "APX$PRIV_CTX_FK" foreign key (apx_priv_context_id) references "APX$CTX"(apx_context_id) on delete set null,
constraint "APX$PRIV_STATUS_FK" foreign key (apx_priv_status_id) references "APX$STATUS"(apx_status_id) on delete set null,
constraint "APX$PRIV_PARENT_FK" foreign key (apx_parent_priv_id) references "APX$PRIVILEGE"(apx_priv_id) on delete set null
);

create unique index "APX$PRIV_UNQ1"   on "APX$PRIVILEGE"(upper(trim(apx_privilege)), apx_priv_context_id, app_id);
create unique index "APX$PRIV_UNQ2"   on "APX$PRIVILEGE"(upper(trim(apx_priv_code)), apx_priv_context_id, app_id);
create index "APX$PRIV_STATUS_FK_IDX" on "APX$PRIVILEGE"(apx_priv_status_id);
create index "APX$PRIV_PARENT_FK_IDX" on "APX$PRIVILEGE"(apx_parent_priv_id);
create index "APX$PRIV_SECLEV"        on "APX$PRIVILEGE"(apx_priv_sec_level);
create index "APX$PRIV_APP_ID"        on "APX$PRIVILEGE"(app_id);

create sequence "APX$PRIV_ID_SEQ" start with 10 increment by 1 nocache;

create or replace trigger "APX$PRIV_BIU_TRG"
before insert or update on "APX$PRIVILEGE"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.apx_priv_id is null) then
        select "APX$PRIV_ID_SEQ".NEXTVAL
        into :new.apx_priv_id
        from dual;
    end if;
    if (:new.app_id is null) then
        select nvl2(v('FB_FLOW_ID'), v('FB_FLOW_ID'), v('APP_ID'))
        into :new.app_id
        from dual;
    end if;
    select sysdate, nvl(v('APX_USER'), user)
    into :new.created, :new.created_by
    from dual;
  elsif updating then
    select sysdate, nvl(v('APX_USER'), user)
    into :new.modified, :new.modified_by
    from dual;
  end if;
end;
/

--------------------------------------------------------------------------------------
-- Synonyms on APX$PRIVILEGE
create synonym  "APEX_PRIVILEGE"        for "APX$PRIVILEGE";


--------------------------------------------------------------------------------------
-- Application Roles
create table "APX$ROLE" (
APX_ROLE_ID number not null,
apx_role_name varchar2(64) not null,
apx_role_code varchar2(8) null,
apx_role_description varchar2(128),
apx_role_sec_level number default 0,
apx_role_domain_id number default 0,
apx_role_status_id number,
apx_role_context_id number,
app_id number,
apx_parent_role_id number,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX$ROLE_ROLE_ID" primary key (apx_role_id),
constraint "APX$ROLE_CTX_FK" foreign key (apx_role_context_id) references "APX$CTX"(apx_context_id) on delete set null,
constraint "APX$ROLE_STATUS_FK" foreign key (apx_role_status_id) references "APX$STATUS"(apx_status_id) on delete set null,
constraint "APX$ROLE_DOMAIN_FK" foreign key (apx_role_domain_id) references "APX$DOMAIN"(apx_domain_id) on delete set null,
constraint "APX$ROLE_PARENT_FK" foreign key (apx_parent_role_id) references "APX$ROLE"(apx_role_id) on delete set null
);

create unique index "APX$ROLE_UNQ1" on "APX$ROLE"(apx_role_id, app_id);
create unique index "APX$ROLE_UNQ2" on "APX$ROLE"(upper(apx_role_name), apx_role_context_id, app_id);

create index "APX$ROLE_DOMAIN_FK_IDX" on "APX$ROLE"(apx_role_domain_id);
create index "APX$ROLE_CTX_FK_IDX"    on "APX$ROLE"(apx_role_context_id);
create index "APX$ROLE_STATUS_FK_IDX" on "APX$ROLE"(apx_role_status_id);
create index "APX$ROLE_PARENT_FK_IDX" on "APX$ROLE"(apx_parent_role_id);
create index "APX$ROLE_SECLEV"        on "APX$ROLE"(apx_role_sec_level);
create index "APX$ROLE_APX_ID"        on "APX$ROLE"(app_id);

create sequence "APX$ROLE_ID_SEQ" start with 10 increment by 1 nocache;

create or replace trigger "APX$ROLE_BIU_TRG"
before insert or update on "APX$ROLE"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.apx_role_id is null) then
        select "APX$ROLE_ID_SEQ".NEXTVAL
        into :new.apx_role_id
        from dual;
    end if;
    if (:new.app_id is null) then
        select nvl2(v('FB_FLOW_ID'), v('FB_FLOW_ID'), v('APP_ID'))
        into :new.app_id
        from dual;
    end if;
    select sysdate, nvl(v('APX_USER'), user)
    into :new.created, :new.created_by
    from dual;
  elsif updating then
    select sysdate, nvl(v('APX_USER'), user)
    into :new.modified, :new.modified_by
    from dual;
  end if;
end;
/

--------------------------------------------------------------------------------------
-- Synonyms on APX$USER
create synonym  "APEX_ROLE"             for "APX$ROLE";


--------------------------------------------------------------------------------------
-- Application User
create table "APX$USER" (
apx_user_id number not null,
apx_username varchar2(64) default 'AppUser' not null,
apx_user_email varchar2(64) not null,
apx_user_default_role_id number default 1 not null, -- 0 PUBLIC, 1 USER
apx_user_code varchar2(8),
apx_user_first_name varchar2(32),
apx_user_last_name varchar2(32),
apx_user_ad_login varchar2(64),
apx_user_host_login varchar2(64),
apx_user_email2 varchar2(64),
apx_user_email3 varchar2(64),
apx_user_twitter varchar2(64),
apx_user_facebook varchar2(64),
apx_user_linkedin varchar2(64),
apx_user_xing varchar2(64),
apx_user_other_social_media varchar2(64),
apx_user_phone1 varchar2(64),
apx_user_phone2 varchar2(64),
apx_user_adress varchar2(128),
apx_user_description varchar2(128),
apx_user_domain_id number default 0,
apx_user_status_id number default 1,
apx_user_sec_level number default 0,
apx_user_context_id number,
apx_user_parent_user_id number,
app_id number,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX$USER_ID" primary key(apx_user_id),
constraint "APX$USER_CTX_FK" foreign key (apx_user_context_id) references "APX$CTX"(apx_context_id) on delete set null,
constraint "APX$USER_STATUS_FK" foreign key (apx_user_status_id) references "APX$STATUS"(apx_status_id) on delete set null,
constraint "APX$USER_DEFROLE_FK" foreign key (apx_user_default_role_id) references "APX$ROLE"(apx_role_id) on delete set null,
constraint "APX$USER_DOMAIN_FK" foreign key (apx_user_domain_id) references "APX$DOMAIN"(apx_domain_id) on delete set null,
constraint "APX$USER_PARENT_FK" foreign key (apx_user_parent_user_id) references "APX$USER"(apx_user_id) on delete set null
);

create unique index "APX$USER_UNQ1"    on "APX$USER"(upper(trim(apx_user_email)), app_id);
create unique index "APX$USER_UNQ2"    on "APX$USER"(upper(trim(apx_username)), app_id);
create index "APX$USER_APX_ID"         on "APX$USER"(app_id);
create index "APX$USER_DOMAIN_FK_IDX"  on "APX$USER"(apx_user_domain_id);
create index "APX$USER_CTX_FK_IDX"     on "APX$USER"(apx_user_context_id);
create index "APX$USER_STATUS_FK_IDX"  on "APX$USER"(apx_user_status_id);
create index "APX$USER_DEFROLE_FK_IDX" on "APX$USER"(apx_user_default_role_id);
create index "APX$USER_PARENT_FK_IDX"  on "APX$USER"(apx_user_parent_user_id);
create index "APX$USER_SECLEV"         on "APX$USER"(apx_user_sec_level);

create sequence "APX$USER_ID_SEQ" start with 10 increment by 1 nocache;

create or replace trigger "APX$USER_BIU_TRG"
before insert or update on "APX$USER"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.apx_user_id is null) then
        select "APX$USER_ID_SEQ".NEXTVAL
        into :new.apx_user_id
        from dual;
    end if;
    if (:new.app_id is null) then
        select nvl2(v('FB_FLOW_ID'), v('FB_FLOW_ID'), v('APP_ID'))
        into :new.app_id
        from dual;
    end if;
    if (:new.apx_user_context_id is null) then
      begin
        select apx_context_id
        into :new.apx_user_context_id
        from "APX$CTX"
        where upper(apx_context) = 'USER';
        exception when no_data_found then
        select 0 into :new.apx_user_context_id from dual;
      end;
    end if;
    if (:new.apx_username is null) then
      begin
        select :new.apx_user_first_name||' '||:new.apx_user_last_name
        into :new.apx_username
        from dual;
        exception when no_data_found then
        select 'AppUser '||nvl(:new.apx_user_id, to_number(SYS_GUID(),'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'))
        into :new.apx_username from dual;
      end;
    end if;
    select sysdate, nvl(v('APX_USER'), user)
    into :new.created, :new.created_by
    from dual;
  elsif updating then
    select sysdate, nvl(v('APX_USER'), user)
    into :new.modified, :new.modified_by
    from dual;
  end if;
end;
/

--------------------------------------------------------------------------------------
-- Synonyms on APX$USER
create synonym  "APEX_USER"             for "APX$USER";


--------------------------------------------------------------------------------------
-- Application User Registration
create table "APX$USER_REG" (
APX_USER_ID number not null,
apx_username varchar2(64) default 'NewAppUser' not null,
apx_user_email varchar2(64) not null,
apx_user_default_role_id number default 1 not null, -- 0 PUBLIC, 1 USER
apx_user_code varchar2(8),
apx_user_first_name varchar2(32),
apx_user_last_name varchar2(32),
apx_user_ad_login varchar2(64),
apx_user_host_login varchar2(64),
apx_user_email2 varchar2(64),
apx_user_email3 varchar2(64),
apx_user_twitter varchar2(64),
apx_user_facebook varchar2(64),
apx_user_linkedin varchar2(64),
apx_user_xing varchar2(64),
apx_user_other_social_media varchar2(64),
apx_user_phone1 varchar2(64),
apx_user_phone2 varchar2(64),
apx_user_adress varchar2(128),
apx_user_description varchar2(128),
apx_user_token_created date,
apx_user_token_valid_until date,
apx_user_token_ts timestamp(6) with time zone,
apx_user_token varchar2(4000),
apx_user_domain_id number default 0,
apx_user_status_id number default 7, -- New User
apx_user_sec_level number default 0,
apx_user_context_id number,
apx_user_parent_user_id number,
app_id number,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX$USREG_ID" primary key(apx_user_id),
constraint "APX$USREG_CTX_FK" foreign key (apx_user_context_id) references "APX$CTX"(apx_context_id) on delete set null,
constraint "APX$USREG_STATUS_FK" foreign key (apx_user_status_id) references "APX$STATUS"(apx_status_id) on delete set null,
constraint "APX$USREG_DOMAIN_FK" foreign key (apx_user_domain_id) references "APX$DOMAIN"(apx_domain_id) on delete set null,
constraint "APX$USREG_DEFROLE_FK" foreign key (apx_user_default_role_id) references "APX$ROLE"(apx_role_id) on delete set null
);

create unique index "APX$USREG_UNQ1"    on "APX$USER_REG"(apx_user_id, app_id);
create unique index "APX$USREG_UNQ2"    on "APX$USER_REG"(apx_user_token);
create unique index "APX$USREG_UNQ3"    on "APX$USER_REG"(upper(apx_user_email), app_id);
-- create unique index "APX$USREG_UNQ4" on "APX$USER_REG"(upper(apx_username), apx_id); -- only needed when apx_username_format = username
create index "APX$USRREG_DOMAIN_FK_IDX" on "APX$USER_REG"(apx_user_domain_id);
create index "APX$USRREG_CTX_FK_IDX"    on "APX$USER_REG"(apx_user_context_id);

create sequence "APX$USREG_ID_SEQ" start with 100 increment by 1 nocache;

create or replace trigger "APX$USRREG_BIU_TRG"
before insert or update on "APX$USER_REG"
referencing old as old new as new
for each row
declare
l_domain varchar2(100);
l_token_valid_for_hours pls_integer;
begin
  if inserting then
    if (:new.apx_user_id is null) then
        select "APX$USREG_ID_SEQ".NEXTVAL
        into :new.apx_user_id
        from dual;
    end if;
    if (:new.app_id is null) then
        select nvl2(v('FB_FLOW_ID'), v('FB_FLOW_ID'), v('APP_ID'))
        into :new.app_id
        from dual;
    end if;
    if (:new.apx_user_token is null) then
      begin
        select apx_domain_name
        into l_domain
        from "APX$DOMAIN"
        where apx_domain_id = :new.apx_user_domain_id;
      exception when no_data_found then
        l_domain := 'NewAppUserDomain.net';
      end;
      begin
        select  apex_config_item_value
        into l_token_valid_for_hours
        from "APEX_CONFIGURATION"
        where  apex_config_item = 'USER_TOKEN_VALID_FOR_HOURS';
        select sysdate,
               sysdate + l_token_valid_for_hours / 24,
               systimestamp,
               apx_get_token(l_domain)
          into :new.apx_user_token_created,
               :new.apx_user_token_valid_until,
               :new.apx_user_token_ts,
               :new.apx_user_token
        from dual;
      exception when no_data_found then
        select 0 into :new.apx_user_context_id from dual;
      end;
    end if;
    if (:new.apx_user_context_id is null) then
      begin
        select apx_context_id
        into :new.apx_user_context_id
        from "APX$CTX"
        where upper(apx_context) = 'USER';
        exception when no_data_found then
        select 0 into :new.apx_user_context_id from dual;
      end;
    end if;
    if (:new.apx_username is null or :new.apx_username = 'NewAppUser') then
      begin
        select nvl(:new.apx_user_first_name, 'New')||' '||nvl(:new.apx_user_last_name, 'User')
        into :new.apx_username
        from dual;
        exception when no_data_found then
        select 'AppUser '||nvl(to_char(:new.apx_user_id), to_number(SYS_GUID(),'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'))
        into :new.apx_username from dual;
      end;
    end if;
    select sysdate, nvl(v('APX_USER'), user)
    into :new.created, :new.created_by
    from dual;
  elsif updating then
    select sysdate, nvl(v('APX_USER'), user)
    into :new.modified, :new.modified_by
    from dual;
  end if;
end;
/

--------------------------------------------------------------------------------------
-- Synonyms on APX$USER_REG
create synonym  "APEX_USER_REGISTRATION"        for "APX$USER_REG";
create synonym  "APEX_USREG"                    for "APX$USER_REG";


--------------------------------------------------------------------------------------
-- User Role Assignement
create table "APX$USER_ROLE_MAP" (
apx_user_role_map_id number not null,
apx_user_id number not null,
apx_role_id number not null,
apx_user_role_status_id number default 1,
app_id number,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX$USERROLEMAP_ID" primary key (apx_user_role_map_id),
constraint "APX$USERROLE_STAT_FK" foreign key (apx_user_role_status_id) references "APX$STATUS"(apx_status_id) on delete set null,
constraint "APX$USER_ID_FK" foreign key (apx_user_id) references "APX$USER"(apx_user_id) on delete cascade,
constraint "APX$ROLE_ID_FK" foreign key (apx_role_id) references "APX$ROLE"(apx_role_id) on delete cascade
) organization index;

create index "APX$USERROLMAP_STAT" on "APX$USER_ROLE_MAP"(apx_user_role_status_id);
create unique index "APX$USERROLEMAP_UNQ" on  "APX$USER_ROLE_MAP"(app_id, apx_user_id, apx_role_id);

create sequence "APX$USERROLE_SEQ" minvalue 0 start with 0 increment by 1 nocache;

create or replace trigger "APX$USRROL_BIU_TRG"
before insert or update on "APX$USER_ROLE_MAP"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.apx_user_role_map_id is null) then
        select APX$userrole_seq.nextval
        into :new.apx_user_role_map_id
        from dual;
    end if;
    select sysdate, nvl(v('APX_USER'), user)
    into :new.created, :new.created_by
    from dual;
  elsif updating then
    select sysdate, nvl(v('APX_USER'), user)
    into :new.modified, :new.modified_by
    from dual;
  end if;
end;
/

------------------------------------------------------------
-- set Roles based on default role setting in APEXP_APX_USER
-- Default Role for each new User = USER
create or replace trigger "APX$USRDEFROL_TRG"
after insert or update of "APX_USER_DEFAULT_ROLE_ID" on "APX$USER"
referencing old as old new as new
for each row
declare
l_entries number;
begin
  if inserting then
      insert into "APX$USER_ROLE_MAP" (app_id, apx_user_id, apx_role_id)
      values (:new.app_id, :new.apx_user_id, :new.apx_user_default_role_id);
  elsif updating then
        update "APX$USER_ROLE_MAP"
        set  (apx_role_id) = :new.apx_user_default_role_id
        where apx_user_id = :new.apx_user_id
		  and app_id = :new.app_id
        and apx_role_id = :old.apx_user_default_role_id;
  end if;
end;
/

--------------------------------------------------------------------------------------
-- Synonyms on APX$USER_ROLE_MAP
create synonym  "APEX_USER_ROLE_MAP"    for "APX$USER_ROLE_MAP";


--------------------------------------------------------------------------------------
-- Application System Users, Roles,...
create table "APX$BUILTIN" (
apx_builtin_id number not null,
apx_builtin_parent_id number,
apx_builtin_status_id number,
apx_builtin_context_id number,
app_id number,
apx_user_id number,
apx_role_id number,
is_admin number,
is_public number,
is_default number,
constraint "APX$SYSBUILTIN_IA_CHK" check (is_admin in(0, 1)),
constraint "APX$SYSBUILTIN_IP_CHK" check (is_public in(0, 1)),
constraint "APX$SYSBUILTIN_ID_CHK" check (is_default in(0, 1)),
constraint "APX$SYSBUILTIN_ID" primary key (apx_builtin_id),
constraint "APX$USR_ID_FK" foreign key (apx_user_id) references "APX$USER"(apx_user_id) on delete cascade,
constraint "APX$ROL_ID_FK" foreign key (apx_role_id) references "APX$ROLE"(apx_role_id) on delete cascade,
constraint "APX$SYSBUILTIN_STATUS_FK" foreign key (apx_builtin_status_id) references "APX$STATUS"(apx_status_id) on delete set null,
constraint "APX$SYSBUILTIN_CTX_FK" foreign key (apx_builtin_context_id) references "APX$CTX"(apx_context_id) on delete set null,
constraint "APX$SYSBUILTINS_FK" foreign key (apx_builtin_parent_id) references "APX$BUILTIN"(apx_builtin_id) on delete set null
) organization index;

create unique index "APX$BUILTIN_UNQ" on  "APX$BUILTIN"(app_id, apx_user_id, apx_role_id);
create index "APX$BUILTIN_CTX_FK_IDX" on "APX$BUILTIN"(apx_builtin_context_id);
create index "APX$BUILTIN_STAT_FK_IDX" on "APX$BUILTIN"(apx_builtin_status_id);

--------------------------------------------------------------------------------------
-- Synonyms on APX$BUITIN
create synonym  "APEX_BUILTIN"          for "APX$BUILTIN";

-- -- comes with axp.pkg
-- --------------------------------------------------------------------------------------
-- -- Apex App User Session
-- create table "APX$USR_SESSION" (
-- apx_user_session_id number not null,
-- apx_username varchar2(64) not null,
-- apx_user_email varchar2(64),
-- apx_user_session_status_id number,
-- app_id number,
-- app_ws_id number,
-- apx_user_cookie_name varchar2(64),
-- apx_user_last_page number,
-- apx_user_last_login timestamp default current_timestamp,
-- apx_user_last_logout timestamp default null,
-- apx_user_session_seconds number default 28800, -- 8 hrs.
-- apx_user_session_idle_sec number default 900, -- 15 min.
-- constraint "APX$SESSION_ID" primary key (apx_user_session_id),
-- constraint "APX$SESSION_STATUS_FK" foreign key (apx_user_session_status_id) references "APX$STATUS"(apx_status_id) on delete set null
-- );

-- create sequence "APX$USERSESS_SEQ" start with 1 increment by 1 nocache;

-- create or replace trigger "APX$USERSESS_BI_TRG"
-- before insert on "APX$USR_SESSION"
-- referencing old as old new as new
-- for each row
-- begin
--   if (:new.apx_user_session_id is null) then
--       select "APX$USERSESS_SEQ".nextval
--       into :new.apx_user_session_id
--       from dual;
--   end if;
--   select current_timestamp, nvl(v('APP_USER'), user)
--   into :new.apx_user_last_login, :new.apx_username
--   from dual;
-- end;
-- /

-- --------------------------------------------------------------------------------------
-- -- Synonyms
-- create synonym  "APEX_USER_SESSION"         for "APX$USR_SESSION";


-- --------------------------------------------------------------------------------------
-- -- Views on "APX$USR_SESSION" table
-- create view "APEX_USER_SESSIONS"
-- as
-- select apx_user_session_id,
--   apx_username,
--   apx_user_email,
--   app_id,
--   app_ws_id,
--   apx_user_session_status_id,
--   apx_user_last_login,
--   apx_user_last_logout,
--   trunc(apx_session_duration) as apx_session_duration_seconds,
--   nvl(nullif(apx_user_session_seconds,0), trunc(apx_session_duration)) -
--   trunc(apx_session_duration) as apx_session_remaining_seconds,
--   case when apx_session_duration <= apx_user_session_seconds
--           then 'Y'
--           else 'N'
--   end as apx_session_is_current
-- from (
-- select apx_user_session_id,
--   apx_username,
--   apx_user_email,
--   app_id,
--   app_ws_id,
--   apx_user_last_login,
--   apx_user_last_logout,
--   apx_user_session_seconds,
--   apx_user_session_status_id,
--   trunc((cast(current_timestamp as date) - date '1970-01-01')*24*60*60) as just_now,
--   ((cast(apx_user_last_login as date) - date '1970-01-01')*24*60*60) as login_second,
--   trunc((cast(current_timestamp as date) - date '1970-01-01')*24*60*60) -
--   ((cast(apx_user_last_login as date) - date '1970-01-01')*24*60*60) as apx_session_duration
-- from  "APX$USR_SESSION"
-- );


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Gather Stats for new/all Objects
--------------------------------------------------------------------------------------
prompt
prompt Gathering Stats...
begin
dbms_stats.gather_schema_stats(user);
end;
/

---------------------------------
prompt
---------------------------------

set pages 0 line 120 define off verify off feed off timing off echo off

EXIT SQL.SQLCODE;


       ---- 17/12/19 22:54  End of SQL Build APX  ----
---------------------------------------------------------------
