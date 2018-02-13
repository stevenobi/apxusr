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
-- 07.01.2018 SOB moved Email Tables and Functions into Top Level APX Project APX$MAIL
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


-- drop function    "IS_VALID_USER_TOKEN";
-- drop function    "IS_VALID_APEX_USER_TOKEN";
-- drop function    "IS_VALID_REG_TOKEN";
-- drop function    "IS_VALID_TOKEN";
-- drop procedure   "APX_CREATE_USER";
-- drop procedure   "APX_USER_CONFIRMATION";

-- drop view        "APEX_WS_USER_ACCOUNT_STATUS";


-- drop synonym     "APEX_BUILTIN";
-- drop table       "APX$BUILTIN"       purge;

-- drop view        "APEX_USER_ROLES";
-- drop synonym     "APEX_USER_ROLE_MAP";
-- drop trigger     "APX$USRDEFROL_TRG";
-- drop sequence    "APX$USERROLE_SEQ";
-- drop trigger     "APX$USRROL_BIU_TRG";
-- drop table       "APX$USER_ROLE_MAP" purge;

-- drop view        "APEX_USER_REG_STATUS";
-- drop view        "APEX_USER_REGISTRATIONS";
-- drop synonym     "APEX_USER_REGISTRATION";
-- drop synonym     "APEX_USER_ALL_REG";
-- drop view        "APEX_USER_REGISTRATIONS_ALL";
-- drop synonym     "APEX_USREG";
-- drop sequence    "APX$USREG_ID_SEQ";
-- drop trigger     "APX$USRREG_BIU_TRG";
-- drop trigger     "APX$USRREG_BU_TKN_TRG";
-- drop trigger     "APX$USRREG_BU_REG_CNT_TRG";
-- drop table       "APX$USER_REG"      purge;


-- drop synonym     "APEX_APP_USERS";
-- drop view        "APEX_USERS";
-- drop synonym     "APEX_USER";
-- drop sequence    "APX$USER_ID_SEQ";
-- drop trigger     "APX$USER_BIU_TRG" ;
-- drop table       "APX$USER"          purge;


-- drop synonym     "APEX_APP_ROLES";
-- drop view        "APEX_ROLES";
-- drop synonym     "APEX_ROLE";
-- drop sequence    "APX$ROLE_ID_SEQ";
-- drop trigger     "APX$ROLE_BIU_TRG" ;
-- drop table       "APX$ROLE"          purge;

-- drop view        "APEX_PRIVILEGES";
-- drop synonym     "APEX_USER_PRIVILEGES";
-- drop synonym     "APEX_PRIVILEGE";
-- drop sequence    "APX$PRIV_ID_SEQ";
-- drop trigger     "APX$PRIV_BIU_TRG";
-- drop table       "APX$PRIVILEGE"     purge;


---- drop function    "PARSE_DOMAIN_FROM_EMAIL"; -- comes with APX$MAIL 2018.01
-- drop function    "IS_VALID_DOMAIN";
-- drop view        "APEX_VALID_DOMAINS";
-- drop view        "APEX_DOMAINS";
-- drop synonym     "APEX_USER_DOMAINS";
-- drop synonym     "APEX_DOMAIN";
-- drop sequence    "APX$DOMAIN_ID_SEQ";
-- drop trigger     "APX$DOMAIN_BIU_TRG";
-- drop table       "APX$DOMAIN"        purge;


-- drop synonym     "APEX_USER_GROUPS"
-- drop view        "APEX_GROUPS"
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


create sequence "APX$GROUP_ID_SEQ" start with 1 increment by 1 nocache;

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
-- APEX_GROUP Test Data
insert into "APEX_GROUP" (apx_group_id, apx_group_name, apx_group_code, apx_group_description, apx_group_status_id, apx_group_context_id)
values (0, 'DEFAULT', 'DEFAULT', 'Default Application Group', 0, 0);
insert into "APEX_GROUP" (apx_group_name, apx_group_code, apx_group_description, apx_group_status_id, apx_group_context_id, apx_parent_group_id)
values ('APPLICATION DOMAIN', 'APPDOM', 'Application Domain Group', 3, 10, 0);
insert into "APEX_GROUP" (apx_group_name, apx_group_code, apx_group_description, apx_group_status_id, apx_group_context_id, apx_parent_group_id)
values ('APPLICATION TEST DOMAIN', 'APPTDOM', 'Application Test Domain Group', 3, 10, 1);
insert into "APEX_GROUP" (apx_group_name, apx_group_code, apx_group_description, apx_group_status_id, apx_group_context_id, apx_parent_group_id)
values ('APPLICATION PRODUCTION DOMAIN', 'APPPDOM', 'Application Production Domain Group', 3, 10, 1);

commit;


--------------------------------------------------------------------------------------
-- Views and more Synonyms on APEX_GROUP
create view "APEX_GROUPS"
as
select
g.apx_group_id as apex_group_id,
g.apx_group_name as apex_group,
g.apx_group_code as apex_group_code,
g.apx_group_description as apex_group_description,
s.apex_status as apex_group_status,
c.apex_context as apex_group_context,
(select b.apx_group_name from "APEX_GROUP" b
 where b.apx_group_id = g.apx_parent_group_id) as apex_parent_group,
g.apx_group_sec_level as apex_group_security_level,
g.app_id as app_id,
g.created,
g.created_by,
g.modified,
g.modified_by
from "APEX_GROUP" g
left outer join "APEX_STATUS" s
on (g.apx_group_status_id = s.apex_status_id)
left outer join "APEX_CONTEXT" c
on (g.apx_group_context_id = c.apex_context_id)
order by 1, 2, 3;


create synonym "APEX_USER_GROUPS" for "APEX_GROUPS";


--------------------------------------------------------------------------------------
-- Application Domains
create table "APX$DOMAIN" (
apx_domain_id number not null,
apx_domain varchar2(64) not null, -- fully qualified domain name (f.e.: mydomain.net)
apx_domain_name varchar2(64) not null, -- conceptual name like MyDomain
apx_domain_code varchar2(8) null,
apx_domain_description varchar2(128),
apx_parent_domain_id number,
apx_domain_status_id number default 17,
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
-- APX$DOMAIN Test Data
insert into "APEX_DOMAIN" (apx_domain_id, apx_domain, apx_domain_name, apx_domain_code, apx_domain_description, apx_domain_status_id, apx_domain_group_id, apx_domain_sec_level, apx_domain_context_id)
values (0, 'default.domain', 'Default Domain', 'DEFDOM', 'Default Application Domain', 0, 0, 0, 0);
insert into "APEX_DOMAIN" (apx_domain, apx_domain_name, apx_domain_code, apx_domain_description, apx_domain_status_id, apx_domain_group_id, apx_domain_sec_level, apx_domain_context_id)
values ('t-online.de', 'Deutsche Telekom', 'TKOM', 'Deutsche Telekom Domain', 17, 1, 1, 10);
insert into "APEX_DOMAIN" (apx_domain, apx_domain_name, apx_domain_code, apx_domain_description, apx_domain_status_id, apx_domain_group_id, apx_domain_sec_level, apx_domain_context_id)
values ('timeframes.de', 'Timeframes Inc.', 'TFRM', 'Timeframes Inc. Domain', 17, 1, 1, 10);

commit;

--------------------------------------------------------------------------------------
-- Views on APX$DOMAIN

-- Apex Domains
create view "APEX_DOMAINS"
as
select
d.apx_domain_id as apex_domain_id,
d.apx_domain as apex_domain,
d.apx_domain_name as apex_fqdn,
d.apx_domain_code as apex_domain_code,
d.apx_domain_description as apex_domain_description,
(select b.apx_domain from "APEX_DOMAIN" b
 where b.apx_domain_id = d.apx_parent_domain_id) as apex_parent_domain,
g.apex_group as apex_domain_group,
d.apx_domain_sec_level as apex_domain_security_level,
s.apex_status as apex_domain_status,
c.apex_context as apex_domain_context,
d.apx_domain_homepage as apex_domain_home_page,
d.app_id as app_id,
d.created,
d.created_by,
d.modified,
d.modified_by
from  "APEX_DOMAIN" d
left outer join "APEX_GROUPS" g
on (d.apx_domain_group_id = g.apex_group_id)
left outer join "APEX_STATUS" s
on (d.apx_domain_status_id = s.apex_status_id)
left outer join "APEX_CONTEXT" c
on (d.apx_domain_context_id = c.apex_context_id)
order by 1, 2, 3;

create synonym "APEX_USER_DOMAINS" for "APEX_DOMAINS";


-- User Valid Domains
create view "APEX_VALID_DOMAINS"
as
select
    apex_domain_id,
    apex_domain,
    apex_fqdn,
    apex_domain_code,
    apex_domain_description,
    apex_parent_domain,
    apex_domain_group,
    apex_domain_security_level,
    apex_domain_status,
    apex_domain_context,
    apex_domain_home_page,
    app_id,
    created,
    created_by,
    modified,
    modified_by
from "APEX_DOMAINS"
where apex_domain_status = 'VALID';


-----------------------------------------------------------------------------------------------------
-- comes with APX$MAIL
-- Parse Domain Part from Emai Address
-- create function "PARSE_DOMAIN_FROM_EMAIL" (
--     p_address varchar2
-- ) return varchar2
-- as
-- l_domain varchar2(1000);
-- begin
--     if instr(p_address, '@') > 0 then
--       l_domain := trim(substr(p_address, instr(p_address, '@') +1, length(p_address)));
--     else
--       l_domain := trim(p_address);
--     end if;
--   return (l_domain);
-- end;
-- /

--select parse_domain_from_email( 's.obermeyer@t-online.de') as domain from dual;

-----------------------------------------------------------------------------------------------------
-- User Valid Domains
create function "IS_VALID_DOMAIN" (
    p_domain varchar2,
    p_return_as_offset varchar2 := 'FALSE',
    p_return_offset pls_integer := null
) return pls_integer
is
l_return pls_integer;
l_domain varchar2(1000);
l_config_value pls_integer;
l_return_offset pls_integer;
C_RETURN_OFFSET pls_integer := -1; -- Default Offset if none specified by p_return_offset
begin
    -- check if domain conatins email characters
    if instr(p_domain, '@') > 0 then
        l_domain := "PARSE_DOMAIN_FROM_EMAIL"(p_domain);
    else
        l_domain := p_domain;
    end if;

    -- check if domain is in valid_domains
    select count(1) as domain_is_valid
    into l_return
    from "APEX_VALID_DOMAINS"
    where upper(trim(apex_domain)) = upper(trim(l_domain));

    -- if called by ajax in apex we reduce return by 1
    -- since 0 is reserved for ok instead of "not found"
    if (upper(trim(p_return_as_offset)) = 'TRUE') then
        if (p_return_offset) is null then
            begin
              select count(1) * C_RETURN_OFFSET
              into l_return_offset
              from "APEX_CONFIGURATION"
              where apex_config_item = 'ENFORCE_VALID_DOMAIN'
              and apex_config_item_value = 'TRUE';
            exception when no_data_found then
            l_return_offset := 0;
            end;
        else
            l_return_offset := p_return_offset;
        end if;
    else
        l_return_offset := 0;
    end if;

    -- honor local config value by adding (-1 for ajax callbacks)
    l_return := l_return + l_return_offset;

    -- return final result
    return (l_return);

exception when no_data_found then
return null;
when others then
raise;
return null;
end;
/

-- select IS_VALID_DOMAIN( 's.obermeyer@t-online.de') as is_valid_domain from dual;

-- needed for ORDS
grant execute on "IS_VALID_DOMAIN" to public;


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

-- Apex Privileges
create view "APEX_PRIVILEGES"
as
select
p.apx_priv_id as apex_privilege_id,
p.apx_privilege as apex_privilege,
p.apx_priv_code as apex_privilege_code,
p.apx_priv_description as apex_priv_description,
s.apex_status as apex_priv_status,
c.apex_context as apex_priv_context,
(select b.apx_privilege from "APEX_PRIVILEGE" b
 where b.apx_priv_id = p.apx_parent_priv_id) as apex_parent_privilege,
p.apx_priv_sec_level as apex_priv_security_level,
d.apex_domain,
p.app_id,
p.created,
p.created_by,
p.modified,
p.modified_by
from "APEX_PRIVILEGE" p
left outer join "APEX_STATUS" s
on (p.apx_priv_status_id = s.apex_status_id)
left outer join "APEX_CONTEXT" c
on (p.apx_priv_context_id = c.apex_context_id)
left outer join "APEX_DOMAINS" d
on (p.apx_priv_domain_id = d.apex_domain_id)
order by 1, 2, 3;

create synonym "APEX_USER_PRIVILEGES" for "APEX_PRIVILEGES";


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
-- APEX_ROLE Test Data
insert into "APEX_ROLE" (apx_role_id, apx_role_name, apx_role_code, apx_role_description, apx_role_sec_level, apx_role_domain_id, apx_role_status_id, apx_role_context_id)
values (0, 'PUBLIC', 'PUB', 'Public User Role', 0, 0, 4, 0);
insert into "APEX_ROLE" (apx_role_id, apx_role_name, apx_role_code, apx_role_description, apx_role_sec_level, apx_role_domain_id, apx_role_status_id, apx_role_context_id)
values (-1, 'ADMINISTRATOR', 'ADMIN', 'Application Administrator Role', 1000, 0, 3, 10);
insert into "APEX_ROLE" (apx_role_id, apx_role_name, apx_role_code, apx_role_description, apx_role_sec_level, apx_role_domain_id, apx_role_status_id, apx_role_context_id)
values (1, 'USER', 'USR', 'Default Application User Role', 1, 0, 3, 10);
insert into "APEX_ROLE" (apx_role_name, apx_role_code, apx_role_description, apx_role_sec_level, apx_role_domain_id, apx_role_status_id, apx_role_context_id)
values ('READER', 'READ', 'Application User Read Role', 2, 0, 3, 10);
insert into "APEX_ROLE" (apx_role_name, apx_role_code, apx_role_description, apx_role_sec_level, apx_role_domain_id, apx_role_status_id, apx_role_context_id)
values ('WRITER', 'WRITE', 'Application User Write Role', 3, 0, 3, 10);
insert into "APEX_ROLE" (apx_role_name, apx_role_code, apx_role_description, apx_role_sec_level, apx_role_domain_id, apx_role_status_id, apx_role_context_id)
values ('EDITOR', 'EDIT', 'Application User Editor Role', 5, 0, 3, 10);

commit;


--------------------------------------------------------------------------------------
-- Views on Apex Roles
create view "APEX_ROLES"
as
select
r.apx_role_id as apex_role_id,
r.apx_role_name as apex_role,
r.apx_role_code as apex_role_code,
r.apx_role_description as apex_role_description,
(select b.apx_role_name from "APEX_ROLE" b
 where b.apx_role_id = r.apx_parent_role_id) as apex_parent_role,
s.apex_status as apex_priv_status,
c.apex_context as apex_priv_context,
d.apex_domain,
r.apx_role_sec_level as apex_role_security_level,
r.app_id as app_id,
r.created,
r.created_by,
r.modified,
r.modified_by
from  "APEX_ROLE" r
left outer join "APEX_STATUS" s
on (r.apx_role_status_id = s.apex_status_id)
left outer join "APEX_CONTEXT" c
on (r.apx_role_context_id = c.apex_context_id)
left outer join "APEX_DOMAINS" d
on (r.apx_role_domain_id = d.apex_domain_id)
order by 1, 2, 3;

create synonym "APEX_APP_ROLES" for "APEX_ROLES";


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
apx_app_user_id number,
apex_user_id number,
apx_user_last_login date,
apx_user_token_created date,
apx_user_token_valid_until date,
apx_user_token_ts timestamp(6) with time zone,
apx_user_token varchar2(4000),
apx_user_domain_id number default 0,
apx_user_status_id number default 7, -- new
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
declare
l_domain varchar2(100);
l_token_valid_for_hours pls_integer;
l_enforce_valid_domain pls_integer;
C_DEFAULT_TOKEN_VALID_FOR_HOUR pls_integer := 24;
invalid_domain exception;
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
    if (:new.app_id is null) then
        select nvl2(v('FB_FLOW_ID'), v('FB_FLOW_ID'), v('APP_ID'))
        into :new.app_id
        from dual;
    end if;
    if (nullif(:new.apx_user_status_id, 0) is null) then
      begin
        select apx_status_id
        into :new.apx_user_status_id
        from "APX$STATUS"
        where apx_status = 'OPEN'
        and apx_status_ctx_id  = (select apx_context_id
                                  from "APX$CTX"
                                  where apx_context = 'ACCOUNT');
      exception when no_data_found then
          :new.apx_user_status_id := 0;
      end;
    end if;
    if (nullif(:new.apx_user_domain_id, 0) is null) then
      begin
        select apx_domain_id, apx_domain
        into :new.apx_user_domain_id, l_domain
        from "APX$DOMAIN"
        where upper(trim(apx_domain)) =
        upper(trim("PARSE_DOMAIN_FROM_EMAIL"(:new.apx_user_email)))
        and apx_domain_status_id = (select apx_status_id
                                    from "APX$STATUS"
                                    where apx_status = 'VALID'
                                    and apx_status_ctx_id = (select apx_context_id
                                                             from "APX$CTX"
                                                             where apx_context = 'DOMAIN'));
      exception when no_data_found then
        begin
          select count(1)
          into l_enforce_valid_domain
          from "APEX_CONFIGURATION"
          where apex_config_item = 'ENFORCE_VALID_DOMAIN'
          and apex_config_item_value = 'TRUE';
        exception when no_data_found then
            l_enforce_valid_domain := 0;
        end;
        if (l_enforce_valid_domain = 0) then
          -- accept user's domain
          l_domain := "PARSE_DOMAIN_FROM_EMAIL"(:new.apx_user_email);
        else
          raise invalid_domain;
        end if;
      end;
    end if;
    if (:new.apx_user_context_id is null) then
      begin
        select apx_context_id
        into :new.apx_user_context_id
        from "APX$CTX"
        where apx_context = 'USER';
        exception when no_data_found then
            :new.apx_user_context_id := 0;
      end;
    end if;
    if (:new.apx_username is null or :new.apx_username = 'AppUser') then
      begin
        if (:new.apx_user_first_name is not null or :new.apx_user_last_name is not null) then
            select :new.apx_user_first_name||' '||:new.apx_user_last_name
            into :new.apx_username
            from dual;
        end if;
        exception when no_data_found then
          if (:new.apx_user_email is not null) then
            :new.apx_username := :new.apx_user_email;
          else
            select 'AppUser '||
            nvl(:new.apx_user_id, to_number(SYS_GUID(),'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'))
            into :new.apx_username
            from dual;
          end if;
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

-- Apex Users
create view "APEX_USERS"
as
select
  u.apx_user_id as apex_user_id,
  u.apx_username as apex_username,
  u.apx_user_email as apex_user_email,
  r.apex_role as apex_user_default_role,
  u.apx_user_code as apex_user_code,
  s.apex_status as apex_user_status,
  c.apex_context as apex_user_context,
  d.apex_domain as apex_user_domain,
  u.apx_user_sec_level as apex_user_security_level,
 (select b.apx_username from "APEX_USER" b
  where b.apx_user_id = u.apx_user_parent_user_id) as apex_parent_user,
  u.app_id as app_id,
  u.apx_user_first_name as apex_user_first_name,
  u.apx_user_last_name as apex_user_last_name,
  u.apx_user_ad_login as apex_user_ldap_login,
  u.apx_user_host_login as apex_user_host_login,
  u.apx_user_email2 as apex_user_email2,
  u.apx_user_email3 as apex_user_email3,
  u.apx_user_twitter as apex_user_twitter,
  u.apx_user_facebook as apex_user_facebook,
  u.apx_user_linkedin as apex_user_linkedin,
  u.apx_user_xing as apex_user_xing,
  u.apx_user_other_social_media as apex_user_other_soial_media,
  u.apx_user_phone1 as apex_user_phone1,
  u.apx_user_phone2 as apex_user_phone2,
  u.apx_user_adress as apex_user_full_adress,
  u.apx_user_description as apex_user_description,
  u.created,
  u.created_by,
  u.modified,
  u.modified_by
from "APEX_USER" u
left outer join "APEX_ROLES" r
on (u.apx_user_default_role_id = r.apex_role_id)
left outer join "APEX_STATUS" s
on (u.apx_user_status_id = s.apex_status_id)
left outer join "APEX_CONTEXT" c
on (u.apx_user_context_id = c.apex_context_id)
left outer join "APEX_DOMAINS" d
on (u.apx_user_domain_id = d.apex_domain_id)
order by 1, 2, 3;


create synonym "APEX_APP_USERS" for "APEX_USERS";


--------------------------------------------------------------------------------------
-- Application User Registration
create table "APX$USER_REG" (
apx_user_id number not null,
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
apx_user_description varchar2(4000),
apx_app_user_id number,
apex_user_id number,
apx_user_reg_attempt number default 1,
apx_user_token_created date,
apx_user_token_valid_until date,
apx_user_token_ts timestamp(6) with time zone,
apx_user_token varchar2(4000),
apx_user_domain_id number default 0,
apx_user_status_id number default 11, -- New User
apx_user_sec_level number default 0,
apx_user_context_id number,
apx_user_parent_user_id number,
app_id number,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX$USREG_ID" primary key(apx_user_id),
constraint "APX$USREG_STATUS_FK" foreign key (apx_user_status_id) references "APX$STATUS"(apx_status_id) on delete set null,
constraint "APX$USREG_CONTEXT_FK" foreign key (apx_user_context_id) references "APX$CTX"(apx_context_id) on delete set null,
constraint "APX$USREG_DOMAIN_FK" foreign key (apx_user_domain_id) references "APX$DOMAIN"(apx_domain_id) on delete set null,
constraint "APX$USREG_APP_USER_ID_FK" foreign key (apx_app_user_id) references "APX$USER"(apx_user_id) on delete cascade,
constraint "APX$USREG_DEF_ROLE_FK" foreign key (apx_user_default_role_id) references "APX$ROLE"(apx_role_id) on delete set null
);

create unique index "APX$USREG_UNQ1"    on "APX$USER_REG"(apx_user_id, app_id);
create unique index "APX$USREG_UNQ2"    on "APX$USER_REG"(apx_user_token);
create unique index "APX$USREG_UNQ3"    on "APX$USER_REG"(upper(apx_user_email), app_id);
create unique index "APX$USREG_UNQ4"    on "APX$USER_REG"(upper(trim(apx_username)), app_id); -- only needed when apx_username_format = username
create index "APX$USRREG_DOMAIN_FK_IDX" on "APX$USER_REG"(apx_user_domain_id);
create index "APX$USRREG_CTX_FK_IDX"    on "APX$USER_REG"(apx_user_context_id);
create index "APX$USRREG_STATUS_FK_IDX" on "APX$USER_REG"(apx_user_status_id);
create index "APX$USRREG_APXUSR_FK_IDX" on "APX$USER_REG"(apx_app_user_id);
create index "APX$USRREG_ROLE_FK_IDX"   on "APX$USER_REG"(apx_user_default_role_id);

create sequence "APX$USREG_ID_SEQ" start with 100 increment by 1 nocache;


-- Apex Register User Trigger
create or replace trigger "APX$USRREG_BIU_TRG"
before insert or update on "APX$USER_REG"
referencing old as old new as new
for each row
declare
l_domain varchar2(100);
l_token_valid_for_hours pls_integer;
l_enforce_valid_domain pls_integer;
C_DEFAULT_TOKEN_VALID_FOR_HOUR pls_integer := 24;
invalid_domain exception;
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
    if (nullif(:new.apx_user_domain_id, 0) is null) then
      begin
        select apx_domain_id, apx_domain
        into :new.apx_user_domain_id, l_domain
        from "APX$DOMAIN"
        where upper(trim(apx_domain)) =
        upper(trim("PARSE_DOMAIN_FROM_EMAIL"(:new.apx_user_email)))
        and apx_domain_status_id = (select apx_status_id
                                    from "APX$STATUS"
                                    where apx_status = 'VALID'
                                    and apx_status_ctx_id = (select apx_context_id
                                                             from "APX$CTX"
                                                             where apx_context = 'DOMAIN'));
      exception when no_data_found then
        begin
          select count(1)
          into l_enforce_valid_domain
          from "APEX_CONFIGURATION"
          where apex_config_item = 'ENFORCE_VALID_DOMAIN'
          and apex_config_item_value = 'TRUE';
        exception when no_data_found then
            l_enforce_valid_domain := 0;
        end;
        if (l_enforce_valid_domain = 0) then
          -- accept user's domain
          l_domain := "PARSE_DOMAIN_FROM_EMAIL"(:new.apx_user_email);
        else
          raise invalid_domain;
        end if;
      end;
    end if;
    if (:new.apx_user_context_id is null) then
      begin
        select apx_context_id
        into :new.apx_user_context_id
        from "APX$CTX"
        where apx_context = 'USER';
        exception when no_data_found then
            :new.apx_user_context_id := 0;
      end;
    end if;
    if (:new.apx_user_token is null) then
      begin
        select  apex_config_item_value
        into l_token_valid_for_hours
        from "APEX_CONFIGURATION"
        where  apex_config_item = 'USER_TOKEN_VALID_FOR_HOURS';
      exception when no_data_found then
        l_token_valid_for_hours := C_DEFAULT_TOKEN_VALID_FOR_HOUR;
      end;
      -- set token data
      select sysdate,
             sysdate + l_token_valid_for_hours / 24,
             systimestamp,
             "APX_GET_TOKEN"(l_domain)
        into
             :new.apx_user_token_created,
             :new.apx_user_token_valid_until,
             :new.apx_user_token_ts,
             :new.apx_user_token
      from dual;
    end if;
    if (:new.apx_username is null or :new.apx_username = 'NewAppUser') then
      begin
        if (:new.apx_user_first_name is not null or :new.apx_user_last_name is not null) then
            select :new.apx_user_first_name||' '||:new.apx_user_last_name
            into :new.apx_username
            from dual;
        end if;
        exception when no_data_found then
          if (:new.apx_user_email is not null) then
              :new.apx_username := :new.apx_user_email;
          else
            select 'NewAppUser '||
            nvl(:new.apx_user_id, to_number(SYS_GUID(),'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'))
            into :new.apx_username
            from dual;
          end if;
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
exception when invalid_domain
          then RAISE_APPLICATION_ERROR (-20201, 'No valid Domain found.');
when others then
  raise;
end;
/


--------------------------------------------------------------------------------------
-- Synonyms on APX$USER_REG
create synonym  "APEX_USER_REGISTRATION"        for "APX$USER_REG";
create synonym  "APEX_USREG"                    for "APX$USER_REG";


-- Apex User Basic Registration
create view "APEX_USER_REGISTRATIONS"
as
select
  r.app_id,
  r.apx_user_id as apex_user_id,
  d.apex_domain as apex_user_domain,
  r.apx_username as apex_username,
  r.apx_user_email as apex_user_email,
  r.apx_user_token_created as apex_user_token_created,
  r.apx_user_token_valid_until as apex_user_token_valid_until,
  case  when r.apx_user_token_valid_until >= sysdate
        then 'TRUE'
        else 'FALSE'
  end as apex_token_is_valid,
  r.apx_user_token_ts as apex_token_timestamp,
  r.apx_user_token as apex_user_token,
  r.apx_user_sec_level as apex_user_security_level,
  c.apex_context as apex_user_context,
  s.apex_status as apex_user_status,
  (select b.apx_username from "APEX_USER" b
  where b.apx_user_id = r.apx_user_parent_user_id) as apex_parent_user,
  r.apx_user_domain_id as apex_user_domain_id,
  r.apx_app_user_id as apex_app_user_id,
  r.apex_user_id as apex_ws_user_id,
  r.apx_user_reg_attempt as apex_user_reg_attempts,
  r.apx_user_description as apex_user_remarks,
  r.created,
  r.created_by,
  r.modified,
  r.modified_by
from "APEX_USER_REGISTRATION" r
left outer join "APEX_DOMAINS" d
on (r.apx_user_domain_id = d.apex_domain_id)
left outer join "APEX_STATUS" s
on (r.apx_user_status_id = s.apex_status_id)
left outer join "APEX_CONTEXT" c
on (r.apx_user_context_id = c.apex_context_id)
order by 1, 2, 3;


-- All User Registration Details
create view "APEX_USER_REGISTRATIONS_ALL"
as
select
  u.apx_user_id as apex_user_id,
  u.apx_username as apex_username,
  u.apx_user_email as apex_user_email,
  r.apex_role as apex_user_default_role,
  u.apx_user_code as apex_user_code,
  s.apex_status as apex_user_status,
  c.apex_context as apex_user_context,
  d.apex_domain as apex_user_domain,
  u.apx_user_token_created as apex_user_token_created,
  u.apx_user_token_valid_until as apex_user_token_valid_until,
  case  when u.apx_user_token_valid_until >= sysdate
        then 'TRUE'
        else 'FALSE'
  end as apex_token_is_valid,
  u.apx_user_token_ts as apex_token_timestamp,
  u.apx_user_token as apex_user_token,
  u.apx_user_sec_level as apex_user_security_level,
 (select b.apx_username from "APEX_USER" b
  where b.apx_user_id = u.apx_user_parent_user_id) as apex_parent_user,
  u.apx_user_domain_id as apex_user_domain_id,
  u.apx_app_user_id as apex_app_user_id,
  u.apex_user_id as apex_ws_user_id,
  u.apx_user_reg_attempt as apex_user_reg_attempts,
  u.app_id as app_id,
  u.apx_user_first_name as apex_user_first_name,
  u.apx_user_last_name as apex_user_last_name,
  u.apx_user_ad_login as apex_user_ldap_login,
  u.apx_user_host_login as apex_user_host_login,
  u.apx_user_email2 as apex_user_email2,
  u.apx_user_email3 as apex_user_email3,
  u.apx_user_twitter as apex_user_twitter,
  u.apx_user_facebook as apex_user_facebook,
  u.apx_user_linkedin as apex_user_linkedin,
  u.apx_user_xing as apex_user_xing,
  u.apx_user_other_social_media as apex_user_other_soial_media,
  u.apx_user_phone1 as apex_user_phone1,
  u.apx_user_phone2 as apex_user_phone2,
  u.apx_user_adress as apex_user_full_adress,
  u.apx_user_description as apex_user_description,
  u.created,
  u.created_by,
  u.modified,
  u.modified_by
from "APEX_USER_REGISTRATION" u
left outer join "APEX_ROLES" r
on (u.apx_user_default_role_id = r.apex_role_id)
left outer join "APEX_STATUS" s
on (u.apx_user_status_id = s.apex_status_id)
left outer join "APEX_CONTEXT" c
on (u.apx_user_context_id = c.apex_context_id)
left outer join "APEX_DOMAINS" d
on (u.apx_user_domain_id = d.apex_domain_id)
order by 1, 2, 3;


create synonym "APEX_USER_ALL_REG" for "APEX_USER_REGISTRATIONS_ALL";


--------------------------------------------------------------------------------------------------------------------------------
-- APX$USER_REG Updates on Token Columns increment the reg attempt counter
create or replace trigger "APX$USRREG_BU_TKN_TRG"
before update of apx_user_token_created,
                 apx_user_token_valid_until,
                 apx_user_token_ts,
                 apx_user_token
on "APX$USER_REG"
referencing old as old new as new
for each row
declare
C_DEFAULT_TOKEN_VALID_FOR_HOUR pls_integer := 24;
C_DEFAULT_REG_ATTEMPTS pls_integer := 5;
C_DEFAULT_USER_EXCEEDED_STATUS pls_integer := 0;
l_user_reg_max_attempts pls_integer;
l_token_valid_for_hours pls_integer;
l_user_status_exceeded_id pls_integer;
begin
    -- increment reg attempts
    :new.apx_user_reg_attempt := :old.apx_user_reg_attempt + 1;

    -- get config value for Max Attempts and and Token valid for Hours or default to CONSTANT
    begin
        select apex_config_item_value
        into l_user_reg_max_attempts
        from "APEX_CONFIGURATION"
        where apex_config_item = 'USER_REGISTRATION_ATTEMPTS';

        select apex_config_item_value
        into l_token_valid_for_hours
        from "APEX_CONFIGURATION"
        where  apex_config_item = 'USER_TOKEN_VALID_FOR_HOURS';
    exception when no_data_found then
      l_user_reg_max_attempts := C_DEFAULT_REG_ATTEMPTS;
      l_token_valid_for_hours := C_DEFAULT_TOKEN_VALID_FOR_HOUR;
    end;
    -- get config value for Status Reg Attempts Exceeded or default to CONSTANT
    begin
        select apex_status_id
        into l_user_status_exceeded_id
        from "APEX_STATUS"
        where apex_status = 'REG_ATTEMPTS_EXCEEDED';
    exception when no_data_found then
      l_user_status_exceeded_id := C_DEFAULT_USER_EXCEEDED_STATUS;
    end;
    ----------------------------------------------------------------------------
    -- manage altered values for token and token created to be compliant with system model
    if (:new.apx_user_reg_attempt <= l_user_reg_max_attempts) then
      -- still in range so make sure timestamp and valid until are set correctly
      select nvl(:new.apx_user_token_created, :old.apx_user_token_created) + l_token_valid_for_hours / 24,
             to_timestamp(nvl(:new.apx_user_token_created, :old.apx_user_token_created))
      into :new.apx_user_token_valid_until,
           :new.apx_user_token_ts
      from dual;
    else -- range exceeded, so lock down everything around token management for the first entry
      select
          to_date('01.01.1900', 'DD.MM.YYYY'),
          to_date('01.01.1900', 'DD.MM.YYYY') + l_token_valid_for_hours / 24,
          to_timestamp(to_date('01.01.1900', 'DD.MM.YYYY')),
          'MAX_REG_ATTEMPTS_EXCEEDED',
          l_user_status_exceeded_id,
          :old.apx_user_description || sysdate ||
          ' User exceeded max registration attempts (Total '||:new.apx_user_reg_attempt||
          ' out of '||l_user_reg_max_attempts||').'||chr(10)
      into
          :new.apx_user_token_created,
          :new.apx_user_token_valid_until,
          :new.apx_user_token_ts,
          :new.apx_user_token,
          :new.apx_user_status_id,
          :new.apx_user_description
      from dual;
    end if;
end;
/


--------------------------------------------------------------------------------------------------------------------------------
-- APX$USER_REG Update Reg Attempt Count
create or replace trigger "APX$USRREG_BU_REG_CNT_TRG"
before update of "APX_USER_REG_ATTEMPT"
on "APX$USER_REG"
referencing new as new old as old
for each row
declare
l_token_valid_for_hours pls_integer;
l_user_status_id pls_integer;
l_enforce_valid_domain pls_integer;
C_DEFAULT_TOKEN_VALID_FOR_HOUR pls_integer := 24;
C_DEFAULT_USER_REGISTER_STATUS pls_integer := 0;
l_domain varchar2(100);
invalid_domain exception;
begin
    if (:new.apx_user_reg_attempt = 1) then
        -- get domain for user token first
        begin
            select apex_user_domain
            into l_domain
            from "APEX_USER_REGISTRATIONS"
            where upper(trim(nvl(apex_username, apex_user_email))) =
                  upper(trim(nvl(:new.apx_username, :new.apx_user_email)));
        exception when no_data_found then
            begin
              select count(1)
              into l_enforce_valid_domain
              from "APEX_CONFIGURATION"
              where apex_config_item = 'ENFORCE_VALID_DOMAIN'
              and apex_config_item_value = 'TRUE';
            exception when no_data_found then
                l_enforce_valid_domain := 0;
            end;
            if (l_enforce_valid_domain = 0) then
              l_domain := 'NewAppUserDomain.net';
            else
              raise invalid_domain;
            end if;
        end;
        -- reset user status to registered
        begin
           select apex_status_id
            into l_user_status_id
            from "APEX_STATUS"
            where apex_status = 'REGISTERED';
        exception when no_data_found then
          l_user_status_id := C_DEFAULT_USER_REGISTER_STATUS;
        end;
        -- get config values for token grace period
        begin
            select  apex_config_item_value
            into l_token_valid_for_hours
            from "APEX_CONFIGURATION"
            where  apex_config_item = 'USER_TOKEN_VALID_FOR_HOURS';
        exception when no_data_found then
            l_token_valid_for_hours := C_DEFAULT_TOKEN_VALID_FOR_HOUR;
        end;
        -- now reset the token data
        select sysdate,
               sysdate + l_token_valid_for_hours / 24,
               systimestamp,
               "APX_GET_TOKEN"(l_domain),
               l_user_status_id,
               :old.apx_user_description || sysdate ||
               ' User Reset after exceeding max registration attempts (Total '||
               :old.apx_user_reg_attempt||').'||chr(10)
          into
               :new.apx_user_token_created,
               :new.apx_user_token_valid_until,
               :new.apx_user_token_ts,
               :new.apx_user_token,
               :new.apx_user_status_id,
               :new.apx_user_description
        from dual;
    else
        -- we dont allow any other updates than reset to 1, and this should only be done by an admin
        :new.apx_user_reg_attempt := :old.apx_user_reg_attempt;
    end if;
exception when invalid_domain
          then RAISE_APPLICATION_ERROR (-20201, 'No valid Domain found.');
when others then
  raise;
end;
/

--------------------------------------------------------------------------------------
-- Test Data
insert into "APEX_USER_REGISTRATION" (apx_username, apx_user_email, apx_user_status_id, app_id)
values('s.obermeyer@t-online.de', 's.obermeyer@t-online.de', 12, nvl2(v('FB_FLOW_ID'), v('FB_FLOW_ID'), v('APP_ID')));

insert into "APEX_USER_REGISTRATION" (apx_username, apx_user_email, app_id)
values('djo@timeframes.de', 'djo@timeframes.de', nvl2(v('FB_FLOW_ID'), v('FB_FLOW_ID'), v('APP_ID')));

commit;


-----------------------------------------------------------------------------------------------------
-- User Registration Status for Restful Requests
--
-- determines user registration status by compiling
-- its properties and current status in registration table
--
--               s = ((t + s) + (a + w))
--
-- status = ( (token_valid [ 1 = false | 10 = true ] + user_status [ 0 - 3 ]) +
--            (is_app_user [ 0 | 101 ] + is_apex_ws_user [ 0 | 201 ]) )
--
-- possible results see below
--
--------------------------------------------------------------------------------------------------------------------------------
create view "APEX_USER_REG_STATUS"
as
with user_status
as
(select apx_status_id,
        apx_status,
        case when apx_status = 'REG_ATTEMPTS_EXCEEDED'
             then 0
             else 1
        end as apx_status_quote
 from "APX$STATUS"
 where apx_status_ctx_id =
     (select apx_context_id
      from "APX$CTX"
      where apx_context = 'USER'
      )
)
select q.username, (q.token_valid + q.user_status) + (q.is_app_user + q.is_apex_user) as user_status
from (
    select
      apex_username              as username,
      user_status                as user_status,
      token_valid                as token_valid,
      is_app_user                as is_app_user,
      is_apex_user               as is_apex_user
    from (
    select  u.apx_username as apex_username,
            s.apx_status as apex_status,
            nvl(s.apx_status_quote, 1) as apx_status_quote,
            case nvl(s.apx_status, 'UNKNOWN')
              when ('UNKNOWN')                  then 0
              when ('NEW')                      then 0
              when ('REGISTERED')               then 1
              when ('REG_ATTEMPTS_EXCEEDED')    then 2
                                                else 3
            end as user_status,
            case when sysdate > u.apx_user_token_valid_until
                 then 0 * nvl(s.apx_status_quote, 1) + 1
                 else 9 * nvl(s.apx_status_quote, 1) + 1
            end as token_valid,
            case when apx_app_user_id is not null
                 then 101 * nvl(s.apx_status_quote, 1)
                 else 0
            end as is_app_user,
            case when apex_user_id is not null
                 then 201 * nvl(s.apx_status_quote, 1)
                 else 0
            end as is_apex_user
    from "APX$USER_REG" u left outer join "USER_STATUS" s
    on (u.apx_user_status_id = s.apx_status_id)
  )
) q;


-- Enable APEX_USER_REG_STATUS as REST Object
--
declare
  pragma autonomous_transaction;
begin

    "ORDS"."ENABLE_SCHEMA";

    "ORDS"."ENABLE_OBJECT"(p_enabled => TRUE,
                       p_schema => 'APXUSR',
                       p_object => 'APEX_USER_REG_STATUS',
                       p_object_type => 'VIEW',
                       p_object_alias => 'apex_user_reg_status',
                       p_auto_rest_auth => TRUE);

    "ORDS"."ENABLE_OBJECT"(p_enabled => TRUE,
                       p_schema => 'APXUSR',
                       p_object => 'APX$USER_REG',
                       p_object_type => 'TABLE',
                       p_object_alias => 'apex_user_reg',
                       p_auto_rest_auth => TRUE);

    "ORDS"."ENABLE_OBJECT"(p_enabled => TRUE,
                       p_schema => 'APXUSR',
                       p_object => 'APX$STATUS',
                       p_object_type => 'TABLE',
                       p_object_alias => 'apex_user_status',
                       p_auto_rest_auth => TRUE);

    commit;

end;
/

-- needed for ORDS
grant select on "APX$USER_REG"                to "PUBLIC";
grant select on "APX$STATUS"                  to "PUBLIC";
grant select on "APEX_USER_REG_STATUS"        to "PUBLIC";
grant select on "APEX_USER_REGISTRATIONS"     to "PUBLIC";

-----------------------–––––––––––––––––––––---------------------------------–––––––––––––––––––––----------
-- REST Query to be used in Resource Handler
--
-- possible results:
--
-- <0 user does not exist and domain is invalid ((0 * (a+b)) + 0) + -1  =>  display error region
-- 0  user does not exist in app nor apex        (0 * (a+b)) + 0        =>  no action
-- >= 100 apex_app_user                          (c * (a + b)) + 100    =>  reset password
-- >= 200 apex_user                              (c * (a + b)) + 200    =>  reset password
-- 1  user exists, token invalid, user new       (1 * (1 + 0)) + 0      =>  register again
-- 2  user exists, token invalid, user reg       (1 * (1 + 1)) + 0      =>  register again
-- 3  user_exists, max reg attempts exceeded     (1 * (1 + 2)) + 0      =>  contact support to reset reg attempts
-- 4  user_exists, token invalid, status > reg   (1 * (1 + 3)) + 0      =>  reset password
-- 10 user_exists, token valid (10), user new    (1 * (10 + 0)) + 0     =>  register again
-- 11 user_exists, token valid, user registered  (1 * (10 + 1)) + 0     =>  confirm registration
-- 12 user exists, token valid, user > reg       (1 * (10 + 2)) + 0     =>  reset password
--                                                                          (usually only when within
--                                                                           first 24 hrs. since reg attempt)
--
-----------------------------------------------------------------------------------------------------------
-- -- Rest Query for User Status Code apxusr/ue/{username}
--
---- Rest User {username} Status Code
-- select user_status + valid_domain as user_status
-- from (
--     select case when user_exists =  0
--                       then 0
--                       else user_status
--                end as user_status,
--                case when user_exists = 0
--                -- without any more args to is_valid_domain, the offset is determined by then system setting ENFORCE_VALID_DOMAIN in apx$cfg
--                then "IS_VALID_DOMAIN"(upper(trim(:USRNAME)), p_return_as_offset => 'TRUE')
--                else 0
--                end as valid_domain
--     from
--     (select count(1)             as user_exists,
--                max(user_status) as user_status
--      from "APEX_USER_REG_STATUS"
--      where upper(trim(username)) = upper(trim(:USRNAME))
--     )
--  );



-- returns -1, 0 or status_id (see table above for details)
--
-- Sample User yet unknown, but Domain valid Call  {"user_status":0}
-- https://ol7:8443/ords/apx/apxusr/usr/stefan.obermeyer@t-online.de -- 0 (user does not exist and domain is valid)
--
-- Sample User Exists but Max Reg Attempts exceeded Call  {"user_status":3}
-- https://ol7:8443/ords/apx/apxusr/usr/s.obermeyer@t-online.de -- 3 (user exists, max reg attempts exceeded)
--
-- Sample User Exists Call  {"user_status":2}
-- https://ol7:8443/ords/apx/apxusr/usr/s.obermeyer@t-online.de -- 2 (user exists, token inalid, domain ok - else not in table :-)
--
-- Sample Invalid Domain Error Call   {"user_status":-1}
-- https://ol7:8443/ords/apx/apxusr/usr/s.obermeyer@t-online.di  -- -1 (user does not exist and domain invalid)


-----------------------------------------------------------------------------------------------------------
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

-- Apex User Roles
create view "APEX_USER_ROLES"
as
select
  rm.apx_user_role_map_id as apex_user_loe_map_id,
  rm.apx_user_id as apex_user_id,
  u.apex_username,
  u.apex_user_email,
  u.apex_user_security_level,
  rm.apx_role_id as apex_role_id,
  r.apex_role,
  r.apex_role_security_level,
  s.apex_status_id as apex_user_role_status,
  rm.app_id,
  rm.created,
  rm.created_by,
  rm.modified,
  rm.modified_by
from "APEX_USER_ROLE_MAP" rm
left outer join "APEX_USERS" u
on (rm.apx_user_id = u.apex_user_id)
left outer join "APEX_ROLES" r
on (rm.apx_role_id = r.apex_role_id)
left outer join "APEX_STATUS" s
on (rm.apx_user_role_status_id = s.apex_status_id)
order by 1, 2, 3;


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


create procedure "APX_USER_REGISTRATION" (
     p_mailto                        varchar2
   , p_username                      varchar2        := null
   , p_first_name                    varchar2        := null
   , p_last_name                     varchar2        := null
   , p_params                        clob            := null
   , p_values                        clob            := null
   , p_topic                         varchar2        := null
   , p_userid                        pls_integer     := null
   , p_domain_id                     pls_integer     := null
   , p_token                         varchar2        := null
   , p_from                          varchar2        := null
   , p_app_id                        pls_integer     := v('APP_ID')
   , p_result                        pls_integer     := null
   , p_debug                         boolean         := null
   , p_send_mail                     boolean         := null

)
is
    -- Local Variables
    l_mailto                        varchar2(64);
    l_username                      varchar2(64);
    l_first_name                    varchar2(64);
    l_last_name                     varchar2(64);
    l_params                        varchar2(4000);
    l_values                        varchar2(4000);
    l_topic                         varchar2(64);
    l_userid                        pls_integer;
    l_domain_id                     pls_integer;
    l_token                         varchar2(4000);
    l_from                          varchar2(64);
    l_app_id                        pls_integer;
    l_result                        pls_integer;
    l_debug                         boolean;
    l_send_mail                     boolean;

    -- Constants
    C_TOPIC                         constant          varchar2(1000)  := 'REGISTER';
    C_FROM                          constant          varchar2(1000)  := 's.obermeyer@t-online.de';
    C_APP_ID                        constant          pls_integer     := 100;
    C_RESULT                        constant          pls_integer     := 0;
    C_DEBUG                         constant          boolean         := false;
    C_SEND_MAIL                     constant          boolean         := true;

begin

   -- Setting Locals Defaults
    l_mailto                        := p_mailto;
    l_username                      := nvl(p_username, l_mailto);
    l_first_name                    := p_first_name;
    l_last_name                     := p_last_name;
    l_params                        := p_params;
    l_values                        := p_values;
    l_topic                         := nvl(p_topic    , C_TOPIC);
    l_userid                        := p_userid;
    l_domain_id                     := p_domain_id;
    l_token                         := p_token;
    l_from                          := nvl(p_from     , C_FROM);
    l_app_id                        := nvl(p_app_id   , C_APP_ID);
    l_result                        := nvl(p_result   , C_RESULT);
    l_debug                         := nvl(p_debug    , C_DEBUG);
    l_send_mail                     := nvl(p_send_mail, C_SEND_MAIL);


    if (l_topic = 'REGISTER') then
        insert into "APEX_USER_REGISTRATION" (
                                                apx_username
                                            ,   apx_user_email
                                            ,   apx_user_first_name
                                            ,   apx_user_last_name
                                            )
                                    values (
                                                l_username
                                            ,   l_mailto
                                            ,   l_first_name
                                            ,   l_last_name
                                            )
        returning apx_user_id, apx_username, apx_user_token
        into l_userid, l_username, l_token;
    elsif (l_topic = 'REREGISTER') then
        update "APEX_USER_REGISTRATION"
            set apx_user_token = apx_get_token(upper(l_username)),
                apx_user_token_created = sysdate,
                apx_user_reg_attempt = least(apx_user_reg_attempt, 3)
            where upper(trim(apx_user_email)) = upper(trim(l_mailto))
        returning apx_user_id, apx_username, apx_user_token
        into l_userid, l_username, l_token;
    end if;

    -- send confirmation mail if specified
    if l_send_mail then

        "SEND_MAIL" (
            p_result      =>  l_result
          , p_mailto      =>  l_mailto
          , p_username    =>  l_username
          , p_topic       =>  l_topic
          , p_params      =>  l_params
          , p_values      =>  l_values
          , p_app_id      =>  l_app_id
          , p_debug_only  =>  l_debug
        );

    end if;


    if (l_result = 0) then
        -- set status to registered
        update "APEX_USER_REGISTRATION"
        set apx_user_status_id = (select apex_status_id
                                    from apex_status
                                   where app_id is null
                                     and apex_status_context = 'USER'
                                     and apex_status = 'REGISTERED')
        where apx_user_id = l_userid;

    end if;

    commit;

exception when dup_val_on_index then
rollback;
when others then
rollback;
raise;
end;
/


------------------------------------------------------------------------------------------
-- Is a Token valid in either table?
create or replace function "IS_VALID_TOKEN" (
    p_token       in    varchar2
  , p_table       in    varchar2 := null
  , p_col         in    varchar2 := null
  , p_where       in    clob     := null
  , p_sql         in    clob     := null
)  return boolean
is
l_table      varchar2(200)  := null;
l_col        varchar2(100)  := null;
l_token      varchar2(4000) := null;
l_sql        clob := 'select count(1) from ##TABLE## where ##COL## = ##TOKEN##';
l_where      clob := null;
l_result     pls_integer    := 0;
l_return     boolean        := false;
begin

    l_table      := upper(trim(p_table));
    l_col        := upper(trim(p_col));
    l_token      := p_token;
    l_sql        := p_sql;
    l_where      := upper(trim(p_where));

    l_sql := replace(l_sql, '##TABLE##' , l_table);
    l_sql := replace(l_sql, '##COL##'   , l_col);
    l_sql := replace(l_sql, '##TOKEN##' , l_token);

    if (substr(l_where, 1, 5) != 'WHERE') then
        l_where := 'where ' || l_where;
    end if;

    l_sql := l_sql || ' ' || l_where;

    execute immediate l_sql into l_result;

    if (l_result = 0) then
        l_return := false;
    else
        l_return := true;
    end if;

    return l_return;

exception when others then
    return false;
end;
/


-- Exists a Token in APEX_USER_REGISTRATION table?
create function "IS_VALID_REG_TOKEN" (
    p_token       in    varchar2
)  return boolean
is
l_table      varchar2(200)  := 'APEX_USER_REGISTRATION';
l_col        varchar2(100)  := 'APX_USER_TOKEN';
l_where      varchar2(4000) := 'APX_USER_TOKEN_VALID_UNTIL >= SYSDATE';
l_token      varchar2(4000) := null;
l_return     boolean        := false;
begin
    l_token  := p_token;
    l_return := "IS_VALID_TOKEN"(l_token, l_table, l_col, l_where);
    return l_return;
exception when others then
return false;
end;
/


-- Exists a Token in APEX_USER table?
create or replace function "IS_VALID_APEX_USER_TOKEN" (
    p_username    in    varchar2
  , p_token       in    varchar2
)  return boolean
is
l_table      varchar2(200)  := 'APEX_USER';
l_col        varchar2(100)  := 'APX_USER_TOKEN';
l_where      varchar2(4000) := 'APX_USER_TOKEN_VALID_UNTIL >= SYSDATE';
l_token      varchar2(4000) := null;
l_username   varchar2(128)  := null;
l_return     boolean        := false;
begin
    l_token     := p_token;
    l_username  := upper(trim(p_username));
    l_where     := l_where || ' AND apx_username = ' || l_username;
    l_return    := "IS_VALID_TOKEN"(l_token, l_table, l_col, l_where);
    return l_return;
exception when others then
return false;
end;
/


-- Is Token for User still valid in APEX_USER_REGISTRATION table?
create or replace function "IS_VALID_USER_TOKEN" (
     p_username    in    varchar2
   , p_token       in    varchar2
)  return boolean
is
l_table      varchar2(200)  := 'APEX_USER_REGISTRATION';
l_col        varchar2(100)  := 'APX_USER_TOKEN';
l_where      varchar2(4000) := 'APX_USER_TOKEN_VALID_UNTIL >= SYSDATE';
l_token      varchar2(4000) := null;
l_username   varchar2(128)  := null;
l_return     boolean        := false;
begin
    l_token     := p_token;
    l_username  := upper(trim(p_username));
    l_where     := l_where || ' AND apx_username = ''' || l_username ||'';
    l_return    := "IS_VALID_TOKEN"(l_token, l_table, l_col, l_where);
    return l_return;
exception when others then
return false;
end;
/


----------------------------------------------------------------------------
-- Create Apex User in Application Table and Apex Workspace if specified
create procedure "APX_CREATE_USER" (
      p_username                    in       varchar2
    , p_result                      in out   pls_integer
    , p_email_address               in       varchar2        := null
    , p_first_name                  in       varchar2        := null
    , p_last_name                   in       varchar2        := null
    , p_params                      in       clob            := null
    , p_values                      in       clob            := null
    , p_topic                       in       varchar2        := null
    , p_userid                      in       pls_integer     := null
    , p_domain_id                   in       pls_integer     := null
    , p_token                       in       varchar2        := null
    , p_description                 in       varchar2        := null
    , p_web_password                in       varchar2        := null
    , p_web_password_format         in       varchar2        := null
    , p_change_password_on_first_use in      varchar2        := null
    , p_group_ids                   in       varchar2        := null
    , p_developer_privs             in       varchar2        := null
    , p_default_schema              in       varchar2        := null
    , p_allow_access_to_schemas     in       varchar2        := null
    , p_account_expiry              in       date            := null
    , p_account_locked              in       varchar2        := null
    , p_attribute_01                in       varchar2        := null
    , p_attribute_02                in       varchar2        := null
    , p_attribute_03                in       varchar2        := null
    , p_attribute_04                in       varchar2        := null
    , p_attribute_05                in       varchar2        := null
    , p_app_id                      in       pls_integer     := null
    , p_debug                       in       boolean         := null
    , p_send_mail                   in       boolean         := null
    , p_create_apex_user            in       boolean         := null
) authid current_user
is
    -- Local Variables
    l_username                      varchar2(128);
    l_result                        pls_integer;
    l_result_code                   pls_integer;
    l_email_address                 varchar2(128);
    l_first_name                    varchar2(128);
    l_last_name                     varchar2(128);
    l_params                        clob;
    l_values                        clob;
    l_topic                         varchar2(64);
    l_userid                        pls_integer;
    l_domain_id                     pls_integer;
    l_token                         varchar2(4000);
    l_description                   varchar2(1000);
    l_web_password                  varchar2(1000);
    l_web_password_format           varchar2(1000);
    l_group_ids                     varchar2(1000);
    l_developer_privs               varchar2(1000);
    l_default_schema                varchar2(1000);
    l_allow_access_to_schemas       varchar2(1000);
    l_change_password_on_first_use  varchar2(10);
    l_account_expiry                date;
    l_account_locked                varchar2(1000);
    l_attribute_01                  varchar2(1000);
    l_attribute_02                  varchar2(1000);
    l_attribute_03                  varchar2(1000);
    l_attribute_04                  varchar2(1000);
    l_attribute_05                  varchar2(1000);
    l_app_id                        pls_integer;
    l_debug                         boolean;
    l_send_mail                     boolean;
    l_create_apex_user              boolean;

    CREATE_USER_ERROR               exception;

    -- Constants
    C_TOPIC                         constant          varchar2(1000)  := 'CREATE';
    C_PASSWORD_FORMAT               constant          varchar2(1000)  := 'CLEAR_TEXT';
    C_ACCOUNT_LOCKED                constant          varchar2(10)    := 'N';
    C_ACCOUNT_EXPIRED               constant          varchar2(10)    := TRUNC(SYSDATE);
    C_CHANGE_PASSWORD_ON_FIRST_USE  constant          varchar2(10)    := 'N';
    C_APP_ID                        constant          pls_integer     := 100;
    C_RESULT                        constant          pls_integer     := null;
    C_DEBUG                         constant          boolean         := false;
    C_SEND_MAIL                     constant          boolean         := false;
    C_CREATE_APEX_USER              constant          boolean         := true;
    C_DEVELOPER_PRIVS               constant          varchar2(1000)  := null;
    C_ALLOW_ACCESS_TO_SCHEMAS       constant          varchar2(1000)  := null;

begin

   -- Setting Locals Defaults
    l_email_address                 := p_email_address;
    l_username                      := p_username;
    l_first_name                    := p_first_name;
    l_last_name                     := p_last_name;
    l_params                        := p_params;
    l_values                        := p_values;
    l_topic                         := nvl(p_topic            , C_TOPIC);
    l_userid                        := p_userid;
    l_domain_id                     := p_domain_id;
    l_token                         := p_token;
    l_description                   := p_description;
    l_web_password                  := p_web_password;
    l_web_password_format           := p_web_password_format;
    l_group_ids                     := p_group_ids;
    l_developer_privs               := p_developer_privs;
    l_default_schema                := p_default_schema;
    l_allow_access_to_schemas       := p_allow_access_to_schemas;
    l_change_password_on_first_use  := nvl(p_change_password_on_first_use, C_CHANGE_PASSWORD_ON_FIRST_USE);
    l_account_expiry                := nvl(p_account_expiry   , C_ACCOUNT_EXPIRED);
    l_account_locked                := nvl(p_account_locked   , C_ACCOUNT_LOCKED);
    l_attribute_01                  := p_attribute_01;
    l_attribute_02                  := p_attribute_02;
    l_attribute_03                  := p_attribute_03;
    l_attribute_04                  := p_attribute_04;
    l_attribute_05                  := p_attribute_05;
    l_app_id                        := nvl(p_app_id           , C_APP_ID);
    l_result                        := nvl(p_result           , C_RESULT);
    l_result_code                   := 0;
    l_debug                         := nvl(p_debug            , C_DEBUG);
    l_send_mail                     := nvl(p_send_mail        , C_SEND_MAIL);
    l_create_apex_user              := nvl(p_create_apex_user , C_CREATE_APEX_USER);

    -- create local app user first

    if (l_token is not null) then
        if ("IS_VALID_USER_TOKEN"(l_username, l_token)) then
            begin
                insert into "APEX_USER" (
                    apx_username,
                    apx_user_email,
                    apx_user_default_role_id,
                    apx_user_code,
                    apx_user_first_name,
                    apx_user_last_name,
                    apx_user_ad_login,
                    apx_user_host_login,
                    apx_user_email2,
                    apx_user_email3,
                    apx_user_twitter,
                    apx_user_facebook,
                    apx_user_linkedin,
                    apx_user_xing,
                    apx_user_other_social_media,
                    apx_user_phone1,
                    apx_user_phone2,
                    apx_user_adress,
                    apx_user_description,
                    apx_app_user_id,
                    apex_user_id,
                    apx_user_last_login,
                    apx_user_token_created,
                    apx_user_token_valid_until,
                    apx_user_token_ts,
                    apx_user_token,
                    apx_user_domain_id,
                    apx_user_status_id,
                    apx_user_sec_level,
                    apx_user_context_id,
                    apx_user_parent_user_id,
                    app_id)
                (select
                    apx_username,
                    apx_user_email,
                    apx_user_default_role_id,
                    apx_user_code,
                    apx_user_first_name,
                    apx_user_last_name,
                    apx_user_ad_login,
                    apx_user_host_login,
                    apx_user_email2,
                    apx_user_email3,
                    apx_user_twitter,
                    apx_user_facebook,
                    apx_user_linkedin,
                    apx_user_xing,
                    apx_user_other_social_media,
                    apx_user_phone1,
                    apx_user_phone2,
                    apx_user_adress,
                    apx_user_description,
                    apx_app_user_id,
                    apex_user_id,
                    null,
                    apx_user_token_created,
                    apx_user_token_valid_until,
                    apx_user_token_ts,
                    apx_user_token,
                    apx_user_domain_id,
                    apx_user_status_id,
                    apx_user_sec_level,
                    apx_user_context_id,
                    apx_user_parent_user_id,
                    app_id
                FROM "APEX_USER_REGISTRATION"
                where apx_user_token = l_token);
            -- returning apx_user_id, apx_username, apx_user_email
            -- into l_userid, l_username, l_email_address;

            commit;
            l_result_code := 0;

            exception when no_data_found then
                l_result_code := 2;
                l_result      := 'No User Data for Token found.';
                raise create_user_error;
            end;
        else
           l_result_code := 1;
           l_result      := 'Invalid Token';
           raise create_user_error;
        end if;
    else
        insert into "APEX_USER" (
                                  apx_username
                                , apx_user_email
                                , apx_user_first_name
                                , apx_user_last_name
                                , apx_user_description
                                )
                            values (
                                  l_username
                                , l_email_address
                                , l_first_name
                                , l_last_name
                                , l_description
                                )
        returning apx_user_id, apx_username, apx_user_email
        into l_userid, l_username, l_email_address;

        commit;
        l_result_code := 0;

    end if;


    if l_create_apex_user then

        -- set Apex Environment
        for c1 in (
            select workspace_id
            from apex_applications
            where application_id = l_app_id ) loop
            apex_util.set_security_group_id(
                p_security_group_id => c1.workspace_id
                );
        end loop;

        apex_util.create_user (
              p_user_id                       => l_userid
            , p_user_name                     => l_username
            , p_first_name                    => l_first_name
            , p_last_name                     => l_last_name
            , p_description                   => l_description
            , p_email_address                 => l_email_address
            , p_web_password                  => l_web_password
            , p_developer_privs               => l_developer_privs
            , p_default_schema                => l_default_schema
            , p_allow_access_to_schemas       => l_allow_access_to_schemas
            , p_change_password_on_first_use  => l_change_password_on_first_use
            , p_account_expiry                => l_account_expiry
            , p_account_locked                => l_account_locked
            , p_attribute_01                  => l_attribute_01
            , p_attribute_02                  => l_attribute_02
            , p_attribute_03                  => l_attribute_03
            , p_attribute_04                  => l_attribute_04
            , p_attribute_05                  => l_attribute_05
        );

        commit;
        l_result_code := 0;

    end if;

    -- send confirmation mail if specified
    if l_send_mail then

        "SEND_MAIL" (
            p_result      =>  l_result
          , p_mailto      =>  l_email_address
          , p_username    =>  l_username
          , p_topic       =>  l_topic
          , p_params      =>  l_params
          , p_values      =>  l_values
          , p_app_id      =>  l_app_id
          , p_debug_only  =>  l_debug
        );

        commit;
        l_result_code := l_result;

    end if;

    if (l_result_code = 0) then
        -- set status to registered
        update "APEX_USER_REGISTRATION"
        set apx_user_status_id = (select apex_status_id
                                    from "APEX_STATUS"
                                   where app_id is null
                                     and apex_status_context = 'USER'
                                     and apex_status = 'CREATED'),
            apx_app_user_id  = l_userid,
            apex_user_id     = l_userid
        where apx_user_token = l_token;

    end if;

    commit;

exception when create_user_error then
    l_result  := l_result_code ||' '||l_result;
    p_result  := l_result;
when dup_val_on_index then
    rollback;
    l_result  := -1 ||' ERROR: User exists!';
    p_result  := l_result;
when others then
rollback;
raise;
end "APX_CREATE_USER";
/




--------------------------------------------------------------------------------
--- DBMS_SCHEDULER Job to create Users
--
-- User needs by SYS:
-- GRANT MANAGE SCHEDULER TO apxusr;
-- GRANT CREATE JOB TO apxusr;
begin
    dbms_scheduler.create_job (
    job_name => 'CREATE_APEX_USER_JOB',
    job_type => 'STORED_PROCEDURE',
    job_action => 'APX_CREATE_USER',
    number_of_arguments => 9,
    enabled => false );
end;
/

--------------------------------------------------------------------------------
--- Run DBMS_SCHEDULER Job to create Users
create or replace procedure "APX_RUN_CREATE_USER_JOB" (
    p_result   in out  number
  , p_username         varchar2
  , p_first_name       varchar2 := null
  , p_last_name        varchar2 := null
  , p_web_password     varchar2
  , p_email_address    varchar2
  , p_token            varchar2
  , p_app_id           number
  , p_default_schema   varchar2
) authid current_user
is
begin
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_APEX_USER_JOB',
        argument_position => 1,
        argument_value => p_result
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_APEX_USER_JOB',
        argument_position => 2,
        argument_value => p_username
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_APEX_USER_JOB',
        argument_position => 3,
        argument_value => p_first_name
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_APEX_USER_JOB',
        argument_position => 4,
        argument_value =>  p_last_name
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_APEX_USER_JOB',
        argument_position => 5,
        argument_value => p_web_password
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_APEX_USER_JOB',
        argument_position => 6,
        argument_value => p_email_address
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_APEX_USER_JOB',
        argument_position => 7,
        argument_value => p_token
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_APEX_USER_JOB',
        argument_position => 8,
        argument_value => p_app_id
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_APEX_USER_JOB',
        argument_position => 9,
        argument_value => p_default_schema
        );

    dbms_scheduler.run_job (
        job_name => 'CREATE_APEX_USER_JOB',
        use_current_session => false );

    p_result := 0;

exception when others then
p_result := -1;
raise;
end "APX_RUN_CREATE_USER_JOB";
/

create synonym "APEX_CREATE_USER" for "APX_RUN_CREATE_USER_JOB";

-----------------------------------------------------------------------
-- Apex User Account Status
create view "APEX_WS_USER_ACCOUNT_STATUS"
as
with app_ws
as (
select  /*+ MATERIALIZE */
             workspace_id
           , application_id
           , application_name
           , last_updated_by
           , last_updated_on
           , session_state_protection
           , maximum_session_life_seconds
           , maximum_session_idle_seconds
from "APEX_APPLICATIONS"
where application_id = nvl(v('APP_ID'), 110)
)
select       a.application_id
           , a.application_name
           , u.workspace_id
           , u.workspace_name
           , u.workspace_display_name
           , u.first_schema_provisioned
           , u.user_name
           , u.first_name
           , u.last_name
           , u.email
           , a.last_updated_by
           , a.last_updated_on
           , a.session_state_protection
           , a.maximum_session_life_seconds
           , a.maximum_session_idle_seconds
           , u.date_created
           , u.date_last_updated
           , u.available_schemas
           , u.is_admin
           , u.is_application_developer
           , u.description
           , u.password_version
           , u.account_expiry as last_password_change
           , u.failed_access_attempts
           , u.account_locked as account_is_locked
           , case "APX_IS_APEX_USR_EXPIRED_INT"(u.user_name)
             when 0 then 'No' else 'Yes' end as  account_is_expired
          ,  "APX_GET_APEX_USR_DAYS_LEFT"(u.user_name) as account_days_left
 from  "APEX_WORKSPACE_APEX_USERS" u join "APP_WS" a
 on (u.workspace_id = a.workspace_id);


-- select * from APEX_WS_USER_ACCOUNT_STATUS;


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




------------------------------------------------------------------
-- Funtion to Set and Get Values from / to APX Tables and Collections

-- drop procedure "APX_SET";
-- drop function "APX_GET_VALUE";

--
-- 2018/01/14 SO: created
--
-- @requires: APX Model
--
------------------------------------------------------------------

-- Set Value/s to a specific Table, View or Collection

------------------------------------------------------------------------------------------------------
-- APX Set Value/s
-- Get a Value from a specific Table, View or Collection
create or replace function  "APX_GET_VALUE" (
      p_what       in   varchar2
    , p_id         in   varchar2
    , p_tab        in   varchar2     := null
    , p_col        in   varchar2     := null
    , p_id_col     in   varchar2     := null
    , p_param      in   varchar2     := null
    , p_value      in   varchar2     := null
    , p_query      in   varchar2     := null
    , p_where      in   varchar2     := null
    , p_debug      in   pls_integer  := 0
) return varchar2
is
l_id      varchar2(100) ; -- id or value to lookup
l_tab     varchar2(1000); -- name of the value column
l_col     varchar2(1000); -- name of the value column
l_id_col  varchar2(1000); -- name of the value column
l_what    varchar2(1000); -- string to specify what to get (f.e. STATUS, CONTEXT,...)
l_param   varchar2(4000); -- sub items like configuration parameter
l_value   varchar2(4000); -- sub items like query values
l_query   varchar2(4000); -- sql query string
l_sql     clob   := null; -- dynamic sql query string
l_where   clob   := null; -- dynamic sql where clause to be appended to query string
l_return  varchar2(4000); -- return string
l_debug   boolean;
begin

    -- Setting Inputs and Defaults
    l_debug  := case when nvl(p_debug, 0) = 0 then true else false end;

    l_id     := p_id;
    l_what   := nvl(nullif(upper(trim(p_what)), ''), 'EMPTY');
    l_sql    := 'select ##COL## from ##TAB## where ##ID_COL## = :i ';
    l_where  := nvl(l_where, p_where);

    if (l_what = 'EMPTY')  then
        l_query  := null;
        l_sql    := null;
    elsif (l_what = 'QUERY' and p_query is not null) then
        l_query  := p_query;
        l_tab    := p_tab;
        l_col    := p_col;
        l_id_col := p_id_col;
        if (p_param is not null) then
            l_param := p_param;
            l_query := replace(l_query, '##PARAM##', l_param);
        end if;
        if (p_value is not null) then
            l_value := p_value;
            l_query := replace(l_query, '##VALUE##', l_value);
        end if;
        l_sql    := l_query;
        l_sql    := replace(l_sql, '##TAB##'    , l_tab);
        l_sql    := replace(l_sql, '##COL##'    , l_col);
        l_sql    := replace(l_sql, '##ID_COL##' , l_id_col);
    elsif (l_what = 'OBJECT')       then
        l_sql   := replace(l_sql, '##COL##'     , 'APX_OBJECT');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_ID');
    elsif (l_what = 'STATUS')       then
        l_sql   := replace(l_sql, '##COL##'     , 'APX_STATUS');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$STATUS');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_STATUS_ID');
    elsif (l_what = 'CONTEXT')      then
        l_sql   := replace(l_sql, '##COL##'     , 'APX_CONTEXT');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$CTX');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_CONTEXT_ID');
    elsif (l_what = 'OPTION')       then
        l_sql   := replace(l_sql, '##COL##'     , 'APX_OPTION');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$OPT');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_OPTION_ID');
    elsif (l_what = 'OPTION_VALUE') then
        l_sql   := replace(l_sql, '##COL##'     , 'nvl(APX_OPTION_VALUE, APX_DEFAULT_VALUE)');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$OPT');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_OPTION');
        l_sql   := replace(l_sql, ':i'          , 'upper(trim(to_char(:i)))');
    elsif (l_what = 'PROCESS')      then
        l_sql   := replace(l_sql, '##COL##'     , 'APX_PROCESS');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$PRC');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_ROCESS_ID');
    elsif (l_what = 'PRIVILEGE')    then
        l_sql   := replace(l_sql, '##COL##'     , 'APX_PRIVILEGE');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$PRIVILGE');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_PRIV_ID');
    elsif (l_what = 'CONFIG')       then
        l_sql   := replace(l_sql, '##COL##'     , 'APX_CONFIG_NAME');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$CFG');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_CONFIG_ID');
    elsif (l_what = 'CONFIG_VALUE') then
        l_sql   := replace(l_sql, '##COL##'     , 'nvl(APX_CONFIG_VALUE, APX_CONFIG_DEF_VALUE)');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$CFG');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_CONFIG_NAME');
        l_sql   := replace(l_sql, ':i'          , 'upper(trim(to_char(:i)))');
    else
        l_sql    := l_what || ' parameter not found!';
        l_return := null;
    end if;

    -- prepare where clause
    if (l_sql is not null and instr(lower(l_sql)  , 'where ') > 0 ) then
        if (l_where is not null and instr(lower(l_where), 'where ') > 0) then
            l_where := replace(lower(l_where), 'where ', 'and ');
        end if;
    end if;

    -- append where clause
    l_sql    := l_sql || l_where;

    -- determine sql query end execute
    if (l_sql is not null and substr(l_sql, 1, 7) = 'select ') then
        if (l_id is not null) then
            if (regexp_like(l_id, '^[[:digit:]]+$')) then
                begin
                    execute immediate l_sql into l_return using to_number(l_id);
                exception when no_data_found then
                    l_return := null;
                when others then
                raise;
                end;
            else
                begin
                    execute immediate l_sql into l_return using upper(trim(l_id));
                exception when no_data_found then
                    l_return := null;
                when others then
                raise;
                end;
            end if;
        end if;
    else
        l_return  := 'Error: '|| nvl(l_sql, '(null)');
    end if;

    -- Return Output String
    return l_return;

exception
    when no_data_found then
        l_return := null;
    when others then
    raise;
END "APX_GET_VALUE";
/


--------------------------------------------------------------------------------
-- Sample Queries on APX_GET_VALUE
select apx_get_value('Status', 1)
from dual; -- UP
select apx_get_value('conFIG', 1)
from dual; -- HOST
select apx_get_value('CONFIG_value', 'host')
from dual; -- ol7
select apx_get_value('config_value', 24)
from dual; -- (null)  /* number item doesnt exist */
select apx_get_value('context', 12)
from dual; -- REGION
select apx_get_value('option_value', '13')
from dual; -- (null) /* is handled as number by function - value does not exist */
select apx_get_value('option_value', 5)
from dual; -- (null) /* is handled as number by function - value does not exist */
select apx_get_value('optio_value', 'Option')
from dual; -- Error: OPTIO_VALUE parameter not found! /* not a valid dimension */

declare
invalid_domain exception;
begin
raise invalid_domain;
exception when invalid_domain
then RAISE_APPLICATION_ERROR (-20201, 'domain does not exist');
end;
/


    -- constants // TODO global ones in packages
    C_TRUE                   constant boolean     := true;
    C_FALSE                  constant boolean     := false;
    T                        constant boolean     := C_TRUE;
    F                        constant boolean     := C_FALSE;
    C_TRUE_NUM               constant pls_integer := 1;
    C_FALSE_NUM              constant pls_integer := 0;
    TN                       constant pls_integer := C_TRUE_NUM;
    FN                       constant pls_integer := C_FALSE_NUM;
    C_NO_TO_NULL             constant boolean     := C_FALSE;
       if (p_no_to_null = FN) then
        l_no_to_null := F;
    else
        l_no_to_null := T;
    end if;


            -- check Topic and set Page Alias and Request
            if    (l_topic in ('HOME', 'DEFAULT')) then
                l_app       := nvl(p_app , nvl(v('APP_ID'), C_APP_ID));
                l_page      := nvl(p_page, C_HOME_PAGE);
                l_request   := nvl(p_request, 'WELCOME');
            elsif (l_topic = 'LOCK') then
                l_page      := nvl(p_page, C_ACCOUNT_LOCKED_PAGE);
                l_request   := nvl(p_request, 'LOCKED');
            elsif (l_topic = 'UNLOCK') then
                l_page      := nvl(p_page, C_RESETPW_PAGE);
                l_request   := nvl(p_request, 'RESETPW');
            elsif (l_topic = 'REGISTER') then
                l_page      := nvl(p_page, C_REGISTER_PAGE);
                l_request   := nvl(p_request, 'REGISTER');
            elsif (l_topic = 'REREGISTER') then
                l_page      := nvl(p_page, C_REGISTER_PAGE);
                l_request   := nvl(p_request, 'REGISTER');
            elsif (l_topic = 'DEREGISTER') then
                l_page      := nvl(p_page, C_DEREGISTER_PAGE);
                l_request   := nvl(p_request, 'DEREGISTER');
            elsif (l_topic = 'RESET_PW') then
                l_page      := nvl(p_page, C_RESETPW_PAGE);
                l_request   := nvl(p_request, 'RESETPW');
            elsif (l_topic = 'RESET_REG_ATTEMPTS') then
                l_page      := nvl(p_page, C_REGISTER_PAGE);
                l_request   := nvl(p_request, 'REGISTER');
            elsif (l_topic = 'REG_ATTEMPTS_EXCEEDED') then
                l_page      := nvl(p_page, C_SUPPORT_PAGE);
                l_request   := nvl(p_request, 'LOCKEDOUT');




    if     (l_topic = 'LOCK') then
        l_subject   := 'Account locked!';
        l_body_html := l_mail_head|| LF ||
                       '<p>Your Account was locked!<br />'|| LF ||
                       'Please reset your password to unlock Your account at our <a href="' ||
                       "GET_URL"(l_topic, p_params => p_params, p_values => p_values, p_no_to_null => 1) ||
                       '">Passwod Reset</a> page.</p>' || LF ||
                       l_mail_tail;
    elsif (l_topic = 'UNLOCK') then
        l_subject   := 'Account unlocked!';
        l_body_html := l_mail_head|| LF ||
                       '<p>Your Account was successfully unlocked.<br />' || LF ||
                       'Please reset your password on first use at our <a href="' ||
                       "GET_URL"(l_topic, p_params => p_params, p_values => p_values, p_no_to_null => 1) ||
                       '">Passwod Reset</a> page.</p>' || LF ||
                       l_mail_tail;
    elsif (l_topic = 'REGISTER') then
        l_subject   := 'Registration Confirmation.';
        l_body_html := l_mail_head|| LF ||
                       '<p>Please confirm your registration at <a href="' ||
                       "GET_URL"(l_topic, p_params => p_params, p_values => p_values, p_no_to_null => 1) ||
                       '">Registration Confirmation</a> page.</p>' || LF ||
                       l_mail_tail;
    elsif (l_topic = 'REREGISTER') then
        l_subject   := 'Registration Confirmation.';
        l_body_html := l_mail_head|| LF ||
                       '<p>Thank You for registering again.<br />'|| LF ||
                       'Please confirm your registration at <a href="' ||
                       "GET_URL"(l_topic, p_params => p_params, p_values => p_values, p_no_to_null => 1) ||
                       '">Registration Confirmation</a> page.</p>' || LF ||
                       l_mail_tail;
    elsif (l_topic = 'DEREGISTER') then
        l_subject   := 'Deregistration Confirmation.';
        l_body_html := l_mail_head|| LF ||
                       '<p>We are sorry to see You go...</p>' || LF ||
                       l_mail_tail;
    elsif (l_topic = 'RESET_PW') then
        l_subject   := 'Reset Password Information';
        l_body_html := l_mail_head|| LF ||
                       '<p>You receive this mail in return to Your Pasword Reset Request.<br />'|| LF ||
                       'Please reset your password at our <a href="' ||
                       "GET_URL"(l_topic, p_params => p_params, p_values => p_values, p_no_to_null => 1) ||
                       '">Passwod Reset</a> page.</p>' || LF ||
                       l_mail_tail;
    elsif (l_topic = 'RESET_REG_ATTEMPTS') then
        l_subject   := 'Registration Confirmation.';
        l_body_html := l_mail_head|| LF ||
                       '<p>Your Account was reset for registering again.<br />'|| LF ||
                       'Please confirm your registration at <a href="' ||
                       "GET_URL"(l_topic, p_params => p_params, p_values => p_values, p_no_to_null => 1) ||
                       '">Registration Confirmation</a> page.</p>' || LF ||
                       l_mail_tail;
    elsif (l_topic = 'REG_ATTEMPTS_EXCEEDED') then
        l_subject   := 'Registration Attempts exceeded.';
        l_body_html := l_mail_head|| LF ||
                       '<p>Your Registration was invalidated, because you exceeded maximum registration attempts.<br />'|| LF ||
                       'Please contact our <a href="' ||
                       "GET_URL"(l_topic, p_params => p_params, p_values => p_values, p_no_to_null => 1) ||
                       '">Customer Support</a> page for further information.</p>' || LF ||
                       l_mail_tail;

    else  -- default subject mail body
        l_subject   := nvl(l_subject, C_SUBJECT);
        l_body_html := l_mail_body;
    end if;

    -- l_mail_head    :=  '<html><body>' || LF ||
    --                         replace(C_MAIL_HEAD, '##MAIL_TO##', nvl(p_mailto, C_MAIL_TO));
    -- l_mail_tail    :=  LF || C_MAIL_TAIL || LF || C_MAIL_IMG3||LF||'</body></html>';

--------------------------------------------------------------------------------


declare
l_var pls_integer;
l_return clob;
C_RESULT_OFFSET                 constant  pls_integer := 10;
begin
select 1 into l_var
from all_users
where username = 'ME';
exception when others then
l_return := rpad(SQLCODE, C_RESULT_OFFSET)|| ' IS_VALID_EMAIL_ADDRESS Error: ' || SQLERRM;
dbms_output.put_line(l_return);
end;
/


--------------------------------------------------------------------------------
-- Check Email Address Status by Code.
create or replace function "GET_EMAIL_STATUS_TEXT" (
     p_code             in  pls_integer
   , p_append_suffix    in  boolean := false
) return varchar2
is

    type l_status_tab       is table of varchar2(4000)
    index by pls_integer;
    l_status                l_status_tab;
    l_return                varchar2(4000);

    C_SUFFIX                constant varchar2(1) := ':';


begin

    -- Check Email Status Codes
    l_status(-1) := 'Error'; -- Error
    l_status(0)  := 'Unknown'; -- OK
    l_status(1)  := 'Invalid Email Address Format';
    l_status(2)  := 'Invalid Domain Format';
    l_status(3)  := 'Invalid Domain Response';
    l_status(4)  := 'Invalid Recipient';
    l_status(5)  := 'Invalid Email Address Response';
    l_status(6)  := 'Invalid Email Address Response';
    l_status(7)  := 'UTL_SMTP.TRANSIENT_ERROR or UTL_SMTP.PERMANENT_ERROR!';

-- check status code
    if (l_status.exists(p_code)) then
        l_return := l_status(p_code) ||
                    case when (p_append_suffix)
                         then C_SUFFIX
                    end;
    else
        l_return := l_status(0);
    end if;

    return l_return;

exception when others then
    l_return := rpad(SQLCODE, 10) || ' GET_EMAIL_STATUS_TEXT Error: ' || SQLERRM;
    return l_return;
    raise;
end;
/

'<html><body>'                         || LF ||
                                                    '<p><h3>Welcome Dear User...</h3><br />'    ||
                                                    'This is a Testmail from our System.<br />' ||
                                                    'You can safely ignore this message.<br />' ||
                                                    ' best regards...</p>'                || LF ||
                                                    '</body></html>';



insert into apex_domain (apx_domain_id, apx_domain, apx_domain_name, apx_domain_code)
values (11, 't-online.de', 'T-Online Deutschland', 'TON');

commit;

alter table apx$domain modify apx_domain_status_id default 17;

drop index "APX$USREG_UNQ4";
create unique index "APX$USREG_UNQ4" on "APX$USER_REG"(upper(trim(apx_username)), app_id); -- only needed when apx_username_format = username

select upper(trim(apex_username)), app_id
from  "APEX_USER_REGISTRATIONS";

-----------------------------------------------------------------------------------------------------
-- User Domain for Restful Requests
drop  view "APEX_VALID_DOMAINS";

create view "APEX_VALID_DOMAINS"
as
select
    apex_domain_id,
    apex_domain,
    apex_fqdn,
    apex_domain_code,
    apex_domain_description,
    apex_parent_domain,
    apex_domain_group,
    apex_domain_security_level,
    apex_domain_status,
    apex_domain_context,
    apex_domain_home_page,
    app_id,
    created,
    created_by,
    modified,
    modified_by
from "APEX_DOMAINS"
where apex_domain_status = 'VALID';

-----------------------------------------------------------------------------------------------------

set define off;

-----------------------------------------------------------------------------------------------------
-- Parse Domain Part from Emai Address
drop function    "PARSE_USERNAME_FROM_EMAIL";

create function "PARSE_USERNAME_FROM_EMAIL" (
    p_address varchar2
) return varchar2
as
l_username varchar2(1000);
begin
    if instr(p_address, '@') > 0 then
      l_username := trim(substr(p_address, 1, instr(p_address, '@') - 1));
    else
      l_username := trim(p_address);
    end if;
  return (l_username);
end;
/

-- select parse_username_from_email( 's.obermeyer@t-online.de') as username
-- from dual; -- s.obermeyer

-----------------------------------------------------------------------------------------------------
-- Parse Domain Part from Emai Address
drop function    "PARSE_DOMAIN_FROM_EMAIL";

create function "PARSE_DOMAIN_FROM_EMAIL" (
    p_address varchar2
) return varchar2
as
l_domain varchar2(1000);
begin
    if instr(p_address, '@') > 0 then
      l_domain := trim(substr(p_address, instr(p_address, '@') +1, length(p_address)));
    else
      l_domain := trim(p_address);
    end if;
  return (l_domain);
end;
/

--select parse_domain_from_email( 's.obermeyer@t-online.de') as domain from dual;

-----------------------------------------------------------------------------------------------------
-- User Valid Domains
drop function "IS_VALID_DOMAIN";

create function "IS_VALID_DOMAIN" (
    p_domain varchar2,
    p_return_as_offset varchar2 := 'FALSE',
    p_return_offset pls_integer := null
) return pls_integer
is
l_return pls_integer;
l_domain varchar2(1000);
l_config_value pls_integer;
l_return_offset pls_integer;
C_RETURN_OFFSET constant pls_integer := -1; -- Default Offset if none specified by p_return_offset
begin
    -- check if domain conatins email characters
    if instr(p_domain, '@') > 0 then
        l_domain := "PARSE_DOMAIN_FROM_EMAIL"(p_domain);
    else
        l_domain := p_domain;
    end if;

    -- check if domain is in valid_domains
    select count(1) as domain_is_valid
    into l_return
    from "APEX_VALID_DOMAINS"
    where upper(trim(apex_domain)) = upper(trim(l_domain));

    -- if called by ajax in apex we reduce return by 1
    -- since 0 is reserved for ok instead of "not found"
    if (upper(trim(p_return_as_offset)) = 'TRUE') then
        if (p_return_offset) is null then
            begin
              select count(1) * C_RETURN_OFFSET
              into l_return_offset
              from "APEX_CONFIGURATION"
              where apex_config_item = 'ENFORCE_VALID_DOMAIN'
              and apex_config_item_value = 'TRUE';
            exception when no_data_found then
            l_return_offset := 0;
            end;
        else
            l_return_offset := p_return_offset;
        end if;
    else
        l_return_offset := 0;
    end if;

    -- honor local config value by adding (-1 for ajax callbacks)
    l_return := l_return + l_return_offset;

    -- return final result
    return (l_return);

exception when no_data_found then
return null;
when others then
raise;
return 0;
end;
/


-- select IS_VALID_DOMAIN( 's.obermeyer@t-online.de') as is_valid_domain from dual;


-----------------------------------------------------------------------------------------------------
-- User Registration Status for Restful Requests
--
-- determines user registration status by compiling her properties and current status in registration table
--
-- s = ((u * (t + s)) + a) + d
--
-- status = (user_exists [ 0  = no | 1 = yes ] * (token_valid [ 1 = false | 10 = true ] + user_status [ 11 - 15 ]) + is_apex_user [ 0 | 100 ] + valid_domain [ 0 | -1 ]
--
-- results see below
--
--------------------------------------------------------------------------------------------------------------------------------
drop  view "APEX_USER_REG_STATUS";

create view "APEX_USER_REG_STATUS"
as
with user_status
as
(select apx_status_id,
        apx_status,
        case when apx_status = 'REG_ATTEMPTS_EXCEEDED'
             then 0
             else 1
        end as apx_status_quote
 from "APX$STATUS"
 where apx_status_ctx_id =
     (select apx_context_id
      from "APX$CTX"
      where apx_context = 'USER'
      )
)
select q.username, (q.token_valid + q.user_status) + (q.is_app_user + q.is_apex_user) as user_status
from (
    select
      apex_username              as username,
      user_status                as user_status,
      token_valid                as token_valid,
      is_app_user                as is_app_user,
      is_apex_user               as is_apex_user
    from (
    select  u.apx_username as apex_username,
            s.apx_status as apex_status,
            nvl(s.apx_status_quote, 1) as apx_status_quote,
            case nvl(s.apx_status, 'UNKNOWN')
              when ('UNKNOWN')                  then 0
              when ('NEW')                      then 0
              when ('REGISTERED')               then 1
              when ('REG_ATTEMPTS_EXCEEDED')    then 2
                                                else 3
            end as user_status,
            case when sysdate > u.apx_user_token_valid_until
                 then 0 * nvl(s.apx_status_quote, 1) + 1
                 else 9 * nvl(s.apx_status_quote, 1) + 1
            end as token_valid,
            case when apx_app_user_id is not null
                 then 101 * nvl(s.apx_status_quote, 1)
                 else 0
            end as is_app_user,
            case when apex_user_id is not null
                 then 201 * nvl(s.apx_status_quote, 1)
                 else 0
            end as is_apex_user
    from "APX$USER_REG" u left outer join "USER_STATUS" s
    on (u.apx_user_status_id = s.apx_status_id)
  )
) q;


-- Enable APEX_USER_REG_STATUS as REST Object
--
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'APXUSR',
                       p_object => 'APEX_USER_REG_STATUS',
                       p_object_type => 'VIEW',
                       p_object_alias => 'apex_user_reg_status',
                       p_auto_rest_auth => TRUE);

    commit;

END;
/

--grant select on APEX_USER_REG_STATUS to "APEX_050100";
--grant select on APEX_USER_REG_STATUS to "ANONYMOUS";
grant select on APEX_USER_REG_STATUS to "PUBLIC";

--------------------------------------------------------------------------------------------------------------------------------
-- REST Query
--
-- possible results:
--
-- <0 user does not exist and domain is invalid ((0 * (a+b)) + 0) + -1  =>  display error region (added to query at runtime)
-- 0  user does not exist in app nor apex        (0 * (a+b)) + 0        =>  no action
-- >= 100 apex_app_user                          (1 * (a + b)) + 100    =>  reset password
-- >= 200 apex_user                              (1 * (a + b)) + 200    =>  reset password
-- 1  user exists, token invalid, user new       (1 * (1 + 0)) + 0      =>  register again
-- 2  user exists, token invalid, user reg       (1 * (1 + 1)) + 0      =>  register again
-- 3  user_exists, max reg attempts exceeded     (1 * (1 + 2)) + 0      =>  contact support to reset reg attempts
-- 4  user_exists, token invalid, user > reg     (1 * (1 + 3)) + 0      =>  reset password
-- 10 user_exists, token valid (10), user new    (1 * (10 + 0)) + 0     =>  register again
-- 11 user_exists, token valid, user registered  (1 * (10 + 1)) + 0     =>  confirm registration
-- 12 user exists, token valid, user > reg       (1 * (10 + 2)) + 0     =>  reset password
--                                                                          (usually only when within
--                                                                           first 24 hrs. since reg attempt)
--
--------------------------------------------------------------------------------------------------------------------------------
-- Rest User {username} Status Code
select user_status + valid_domain as user_status
from (
    select case when user_exists =  0
                      then 0
                      else user_status
               end as user_status,
               case when user_exists = 0
               -- without any more args to is_valid_domain, the offset is determined by then system setting ENFORCE_VALID_DOMAIN in apx$cfg
               then "IS_VALID_DOMAIN"(upper(trim(:USRNAME)), p_return_as_offset => 'TRUE')
               else 0
               end as valid_domain
    from
    (select count(1)             as user_exists,
               max(user_status) as user_status
     from "APEX_USER_REG_STATUS"
     where upper(trim(username)) = upper(trim(:USRNAME))
    )
 );



--select decode(count(1), 1, 'yes', 'no') as user_exists
--from  "APXUSR"."APEX_USER_REGISTRATIONS"
--where upper(trim(apex_username)) = upper(trim(:USRNAME))

---------------------------------------------------------------------------------------------------------------------------


declare
l_result pls_integer;
l_app_id pls_integer := 110;
begin
    for c1 in (
        select workspace_id
        from apex_applications
        where application_id = l_app_id ) loop
        apex_util.set_security_group_id(p_security_group_id => c1.workspace_id);
    end loop;
    apex_mail.send (
        p_to             => 's.obermeyer@t-online.de',   -- change to your email address
        p_from           => 's.obermeyer@t-online.de',    -- change to a real senders email address
        p_body           => 'Hi There',
        p_body_html      => '<html><body><p>Hi There>/p></body></html>',
        p_subj           => 'Testmail'
    );

    l_result := 0;

exception when others then
    l_result := 1;
    htp.p ('<p>'||SYSDATE||' *** Exception: ' || SQLERRM || ' occured.</p>');
    dbms_output.put_line (SYSDATE || ' *** Exception: ' || SQLERRM || ' occured.');
raise;
end;
/


---------------------------------------------------------------------------------------------------------------------------

grant select on "APEX_USER_REGISTRATIONS" to "PUBLIC";

grant select on "APX$USER_REG" to "PUBLIC"; -- needed for ORDS to work :-|

---------------------------------------------------------------------------------------------------------------------------

exec ords.enable_schema;

commit;

select id, parsing_schema from user_ords_schemas;


BEGIN
  ORDS.enable_schema(
    p_enabled             => TRUE,
    p_schema              => 'APXUSR',
    p_url_mapping_type    => 'BASE_PATH',
    p_url_mapping_pattern => 'apxusr',
    p_auto_rest_auth      => FALSE
  );

  COMMIT;
END;
/

DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'APXUSR',
                       p_object => 'APX$USER_REG',
                       p_object_type => 'TABLE',
                       p_object_alias => 'apx_user_reg',
                       p_auto_rest_auth => TRUE);

    commit;
END;
/

DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'APXUSR',
                       p_object => 'APEX_USER_REGISTRATIONS',
                       p_object_type => 'VIEW',
                       p_object_alias => 'apex_user_registrations',
                       p_auto_rest_auth => FALSE);

    commit;

END;
/

select apex_domain_id
--into l_domain_id
from "APEX_DOMAINS"
where upper(trim(apex_domain)) = 'T-ONLINE.DE';

select substr('s.obermeyer@t-online.de', instr('s.obermeyer@t-online.de', '@') + 1, length('s.obermeyer@t-online.de')) from dual;



------------------------------------------------------------------------------------------------------------
-- Mail Procedures and Functions


/*
create or replace function "GET_EMAIL_BODY_HTML" (
    p_topic        varchar2,
    p_username     varchar2 default null,
    p_user_email   varchar2 default null,
    p_user_token   varchar2 default null,
    p_body_html    clob default null -- [REGISTER, REREGISTER, RESETPW, UNLOCK, RESET_REG_ATTEMPTS,..])
) return clob
is
l_topic     varchar2(64);
l_username  varchar2(64);
l_email     varchar2(64);
l_token     varchar2(4000);
l_mail_text clob;
l_mail_head varchar2(1000);
l_mail_tail varchar2(1000);
l_body_html clob;
l_html      clob;
l_return    clob;
begin
    -- Init Vars
    l_topic     :=  nvl(upper(trim(p_topic)), 'WELCOME');
    l_html      :=  '<html><body>' || utl_tcp.crlf ||'<p>##MAIL_TEXT##</p>' ||utl_tcp.crlf ||'</body></html>';
    l_mail_head :=  'Please confirm your registration at <a href="' || apex_mail.get_instance_url;
    l_mail_tail :=  '<p>Sincerely,<br />' || utl_tcp.crlf ||
                    'Yo Bro from Next Do''<br />' || utl_tcp.crlf ||
                    '<img src="http://zapt1.staticworld.net/images/article/2013/04/oracle-logo-100033308-gallery.png" alt="Oracle Logo"></p>' || utl_tcp.crlf;
    -- check Topic and set Body Text
    if (l_topic = 'REGISTER') then
        l_mail_head := l_mail_head;
        l_mail_tail := l_mail_tail;
        -- set mail body
        l_mail_text := l_mail_head ||
            'f?p='||v('APP_ID')||':USRREGC::CONFIRM:NO::NEWUSER,TOKEN:'||
            nvl(l_username, l_email)||','||l_token||
            '">Registration Confirmation</a> page.</p>' ||
            utl_tcp.crlf || l_mail_tail;
    elsif (l_topic = 'REREGISTER') then
        l_mail_head := l_mail_head;
        l_mail_tail := l_mail_tail;
        -- set mail body
        l_mail_text := l_mail_head ||
            ':USRREREGC::CONFIRM:NO::NEWUSER,TOKEN:'||
            nvl(l_username, l_email)||','||l_token||
            '>Registration Confirmation</a> page.</p>'||
            utl_tcp.crlf || l_mail_tail;
    elsif (l_topic = 'DEREGISTER') then
        l_mail_head := 'Thank You for being with us, we are sorry to see You go...</p>'||utl_tcp.crlf;
        l_mail_tail := l_mail_tail;
        -- set mail body
        l_mail_text := l_mail_head ||
            '<p>Deregistration completed.</p>' ||
            utl_tcp.crlf || l_mail_tail;
    elsif (l_topic = 'RESET_PW') then
        l_mail_head := 'Please set a new Password at our';
        l_mail_tail := l_mail_tail;
        -- set mail body
        l_mail_text := l_mail_head ||
            ' <a href="' || apex_mail.get_instance_url||':USRRESETPW::RESET:::USER,TOKEN:'||
            nvl(l_username, l_email)||','||l_token||
            '">Reset Password</a> Page.</p>'||
            utl_tcp.crlf || l_mail_tail;
    elsif (l_topic = 'UNLOCK') then
        l_mail_head := 'Your Account was unlocked. Please set a new Password at our';
        l_mail_tail := l_mail_tail;
        -- set mail body
        l_mail_text := l_mail_head ||
            ' <a href="' || apex_mail.get_instance_url||':USRRESETPW::RESET:::USER,TOKEN:'||
            nvl(l_username, l_email)||','||l_token||
            '">Reset Password</a> Page.</p>'||
            utl_tcp.crlf || l_mail_tail;
    elsif (l_topic = 'RESET_REG_ATTEMPTS') then
        l_mail_head := 'Your Registration was reset. Please confirm your registration at <a href="' || apex_mail.get_instance_url;
        l_mail_tail := l_mail_tail;
        -- set mail body
        l_mail_text := l_mail_head ||
            ' <a href="' || apex_mail.get_instance_url||':USRREREGC::CONFIRM:NO::NEWUSER,TOKEN:'||
            nvl(l_username, l_email)||','||l_token||
            '">Reset Password</a> Request Page.</p>'||
            utl_tcp.crlf || l_mail_tail;
    else
        l_return := nvl(p_body_html, '<html><body>' || utl_tcp.crlf ||'<p>Welcome...</p>' ||utl_tcp.crlf ||'</body></html>');
    end if;

    l_body_html := to_clob(replace(l_html, '##MAIL_TEXT##', l_mail_text));
    l_return := nvl(p_body_html, l_body_html);
    return l_return;

exception when others then
    return to_clob(SQLERRM);
end;
/
*/



------------------------------------------------------------------------------------------------------
-- Set Apex URL
create or replace procedure "SET_URL" (
      p_url         in out     clob
    , p_topic       in         varchar2    := null
    , p_app         in         varchar2    := null
    , p_page        in         varchar2    := null
    , p_session     in         varchar2    := null
    , p_request     in         varchar2    := null
    , p_debug       in         varchar2    := null
    , p_clearcache  in         varchar2    := null
    , p_params      in         varchar2    := null
    , p_values      in         varchar2    := null
    , p_printerf    in         varchar2    := null
    , p_query       in         varchar2    := null
    , p_no_to_null  in         boolean     := false
 )
is
    ------------------------------------------------------------------------------------------------------
    -- Apex URL Format (see also: https://docs.oracle.com/cd/E14373_01/appdev.32/e11838/concept.htm#HTMDB03020)
    -- http[s]://host:port/f?p={APP_ID}:{PAGE}:{SESSION}:{REQUEST}:{DEBUG}:{CLEARCACHE}:{PARAMS}:{VALUES}:{PRINTER_FRIENDLY}{?QUERY}

    l_url                    clob;
    l_url_prefix             varchar2(32);
    l_topic                  varchar2(64);   -- when used inside APXUSR context (see code for values)
    l_app                    varchar2(64);
    l_page                   varchar2(64);
    l_session                varchar2(64);
    l_request                varchar2(1000);
    l_debug                  varchar2(64);
    l_clearcache             varchar2(1000); -- RP = ResetPagination, APP = All Pages for current app, SESSION = Same as APP just with all items in current session, 1,2,3,..comma separated PAGE_ID list to clear cache on.
    l_params                 varchar2(4000); -- Comma-delimited list of item names used to set session state with a URL. (f.e.'USR,TOKEN').
    l_values                 varchar2(4000); -- List of item values used to set session state within a URL. Item values cannot include colons, but can contain commas.
    l_printerf               varchar2(64);   -- If PrinterFriendly is set to Yes, the page is being rendered in printer friendly mode.
    l_query                  varchar2(4000); -- ? URL query string (optional and used with RESTful Requests or APP Alias Requests wher Workspace is specified by the &c argument).
    l_rowcnt                 pls_integer := 0;

    -- Constants
    D                        constant varchar2(1)    := ':';    -- URL Delimiter
    APX_U                    constant varchar2(4)    := 'f?p='; -- Apex URL Prefix
    C_APP_ID                 constant pls_integer    := 100;    -- default App ID
    C_APP_PAGE_ID            constant pls_integer    := 1;      -- default Page ID (1 = usually Home)
    -- If the pages within an application are public and do not require authentication,
    -- you make it easier for application users to bookmark pages by using zero as the session ID.
    C_APP_SESSION            constant pls_integer    := 0;
    -- Page Aliases for Topic Pages (You need to set these aliases in your Apex Application)
    C_HOME_PAGE              constant varchar2(64)   := 'HOME';
    C_ERROR_PAGE             constant varchar2(64)   := 'ERR';
    C_BRANCH_PAGE            constant varchar2(64)   := 'NAV';
    -- Custom App Pages
    C_RESETPW_PAGE           constant varchar2(64)   := 'RESETPW';
    C_CONFIRM_PAGE           constant varchar2(64)   := 'CONFIRM';
    C_SUPPORT_PAGE           constant varchar2(64)   := 'SUPPORT';
    C_REGISTER_PAGE          constant varchar2(64)   := 'USRREG';
    C_CONFIRM_REGISTER_PAGE  constant varchar2(64)   := 'USRREGC';
    C_DEREGISTER_PAGE        constant varchar2(64)   := 'USRDEREG';
    C_ACCOUNT_LOCKED_PAGE    constant varchar2(64)   := 'USRLOCKED';
    C_ACCOUNT_UNLOCKED_PAGE  constant varchar2(64)   := 'USRUNLOCKED';
    C_ACCOUNT_REG_RESET_PAGE constant varchar2(64)   := 'RESETUSR';
    -- Defauts
    C_TOPIC                  constant varchar2(64)   := 'HOME';
    C_APP                    constant varchar2(64)   := '100';
    C_PAGE                   constant varchar2(64)   := '1';
    C_SESSION                constant varchar2(64)   := '0';
    C_REQUEST                constant varchar2(1000) := null;
    C_DEBUG                  constant varchar2(64)   := null;
    C_CLEARCACHE             constant varchar2(1000) := null;
    C_PARAMS                 constant varchar2(4000) := null;
    C_VALUES                 constant varchar2(4000) := null;
    C_PRINTERF               constant varchar2(64)   := null;
    C_QUERY                  constant varchar2(4000) := null;

begin

    -- Process Inputs and Defaults
    l_url_prefix             := apex_mail.get_instance_url || APX_U;
    l_topic                  := nvl(upper(trim(p_topic))        , C_TOPIC);
    l_app                    := nvl(p_app                       , nvl(v('APP_ID')      , C_APP_ID));
    l_page                   := nvl(p_page                      , nvl(v('APP_PAGE_ID') , C_APP_PAGE_ID));
    l_session                := nvl(p_session                   , nvl(v('APP_SESSION') , C_APP_SESSION));
    l_request                := nvl(p_request                   , nvl(v('REQUEST')     , C_REQUEST));
    l_clearcache             := nvl(upper(trim(p_clearcache))   , C_CLEARCACHE);
    l_params                 := nvl(p_params                    , C_PARAMS);
    l_values                 := nvl(p_values                    , C_VALUES);
    l_query                  := nvl(p_query                     , C_QUERY);
    l_debug                  := nvl(upper(trim(p_debug))        , case  when (v('DEBUG') = 'NO' and p_no_to_null)
                                                                        then null
                                                                        else nvl(v('DEBUG'), C_DEBUG)
                                                                  end);
    l_printerf               := nvl(p_printerf                  , case  when (v('PRINTER_FRIENDLY') = 'NO' and p_no_to_null)
                                                                        then null
                                                                        else nvl(v('PRINTER_FRIENDLY'), C_PRINTERF)
                                                                  end);

    -- check if a URL string shall be just formatted or returned with defaults
    if (p_url is not null) then
        if (lower(substr(trim(p_url), 1, 4)) != 'http') then
            -- we assume an incomplete url string and prepend the apex url prefix
            l_url :=  l_url_prefix || p_url;
        else
            l_url := p_url;
        end if;
    else
        -- get values from table
        for t in (select app_id,
                         apx_app_page,
                         apx_app_request
                  from "APEX_MAIL_TOPICS"
                  where upper(trim(apx_mail_topic)) = l_topic)
        loop
            l_app       := nvl(t.app_id           , nvl(v('APP_ID'), C_APP_ID));
            l_page      := nvl(t.apx_app_page     , C_HOME_PAGE);
            l_request   := nvl(t.apx_app_request  , 'WELCOME');
            l_rowcnt    := l_rowcnt + 1;
        end loop;

        -- nothing found, so error out
        if (l_rowcnt = 0) then
            -- return error page
            l_page      := nvl(p_page, C_ERROR_PAGE);
            l_request   := nvl(p_request, 'INVALID_TOPIC_'||l_topic);
        end if;

        -- now set URL String
        l_url := to_clob(l_url_prefix||l_app||D||l_page||D||l_session||D||l_request||D||l_debug||D||l_clearcache||D||l_params||D||l_values||D||l_printerf||l_query);

    end if;

    -- Set Output String
    p_url := l_url;

exception when others then
    p_url := SQLERRM;
end;
/


------------------------------------------------------------------------------------------------------
-- Test Call to Set Apex URL
declare
l_url    clob;
l_topic  clob := 'REGISTER';
l_params clob := 'USR,TOKEN';
l_values clob := 'User@Domain.net,NTA2Mjc3ODJ0LW9ubGluZS5kZTEzNDAyNTY1MDI=';
begin
  "SET_URL"(l_url, l_topic, p_params => l_params, p_values => l_values);
  dbms_output.put_line('URL: '|| l_url);
end;
/


------------------------------------------------------------------------------------------------------
-- Get Apex URL
create or replace function "GET_URL" (
      p_topic       in         varchar2    := null
    , p_app         in         varchar2    := null
    , p_page        in         varchar2    := null
    , p_session     in         varchar2    := null
    , p_request     in         varchar2    := null
    , p_debug       in         varchar2    := null
    , p_clearcache  in         varchar2    := null
    , p_params      in         varchar2    := null
    , p_values      in         varchar2    := null
    , p_printerf    in         varchar2    := null
    , p_query       in         varchar2    := null
    , p_url         in         clob        := null
    , p_no_to_null  in         pls_integer := 0
 ) return clob
is
    ------------------------------------------------------------------------------------------------------
    -- Apex URL Format (see also: https://docs.oracle.com/cd/E14373_01/appdev.32/e11838/concept.htm#HTMDB03020)
    -- http[s]://host:port/f?p={APP_ID}:{PAGE}:{SESSION}:{REQUEST}:{DEBUG}:{CLEARCACHE}:{PARAMS}:{VALUES}:{PRINTER_FRIENDLY}{?QUERY}

    l_url                    clob;

    l_topic                  varchar2(64);     -- when used inside APXUSR context (see code for values)
    l_app                    varchar2(64);
    l_page                   varchar2(64);
    l_session                varchar2(64);
    l_request                varchar2(1000);
    l_debug                  varchar2(64);
    l_clearcache             varchar2(1000);   -- RP = ResetPagination, APP = All Pages for current app, SESSION = Same as APP just with all items in current session, 1,2,3,..comma separated PAGE_ID list to clear cache on.
    l_params                 varchar2(4000);   -- Comma-delimited list of item names used to set session state with a URL. (f.e.'USR,TOKEN').
    l_values                 varchar2(4000);   -- List of item values used to set session state within a URL. Item values cannot include colons, but can contain commas.
    l_printerf               varchar2(64);     -- If PrinterFriendly is set to Yes, the page is being rendered in printer friendly mode.
    l_query                  varchar2(4000);   -- ? URL query string (optional and used with RESTful Requests or APP Alias Requests wher Workspace is specified by the &c argument f.e:: f?p=common_alias:home:&APP_SESSION.&c=WORKSPACE_A).
    l_no_to_null             boolean;

    -- constants
    C_NO_TO_NULL             constant boolean  := false; -- if true, NO values get pruned

begin

    l_topic                  := p_topic;
    l_app                    := p_app;
    l_page                   := p_page;
    l_session                := p_session;
    l_request                := p_request;
    l_debug                  := p_debug;
    l_clearcache             := p_clearcache;
    l_params                 := p_params;
    l_values                 := p_values;
    l_printerf               := p_printerf;
    l_query                  := p_query;
    -- converting number to boolean
    if (p_no_to_null = 0) then
        l_no_to_null := false;
    elsif (p_no_to_null = 1) then
        l_no_to_null := true;
    else
        l_no_to_null := C_NO_TO_NULL;
    end if;

    -- a url string was passed, so use this for further processing
    if (p_url is not null) then
        l_url := p_url;
    end if;

    -- set the URL return string based on inputs
    "SET_URL"(
          p_url              => l_url
        , p_topic            => l_topic
        , p_app              => l_app
        , p_page             => l_page
        , p_session          => l_session
        , p_request          => l_request
        , p_debug            => l_debug
        , p_clearcache       => l_clearcache
        , p_params           => l_params
        , p_values           => l_values
        , p_printerf         => l_printerf
        , p_query            => l_query
        , p_no_to_null       => l_no_to_null
    );

    return l_url;

exception when others then
    l_url := SQLERRM;
    return (l_url);
end;
/

------------------------------------------------------------------------------------------------------
-- Test Calls to Get Apex URL
select "GET_URL" as apex_url from dual;                            -- https://ol7:8443/ords/f?p=100:HOME:0:WELCOME:NO::::
select "GET_URL"('REGISTER') as apex_url from dual;                -- https://ol7:8443/ords/f?p=100:USRREG:0:REGISTER:NO::::
select "GET_URL"('REGISTERi') as apex_url from dual;               -- https://ol7:8443/ords/f?p=100:ERR:0:INVALID_TOPIC_REGISTERI:NO::::NO
select "GET_URL"('REREGISTER') as apex_url from dual;              -- https://ol7:8443/ords/f?p=100:USRREG:0:REGISTER:NO::::
select "GET_URL"('DEREGISTER') as apex_url from dual;              -- https://ol7:8443/ords/f?p=100:USRDEREG:0:DEREGISTER:NO::::
select "GET_URL"('RESET_PW') as apex_url from dual;                -- https://ol7:8443/ords/f?p=100:RESETPW:0:RESETPW:NO::::
select "GET_URL"('RESET_REG_ATTEMPTS') as apex_url from dual;      -- https://ol7:8443/ords/f?p=100:USRREG:0:REGISTER:NO::::
select "GET_URL"('REG_ATTEMPTS_EXCEEDED') as apex_url from dual;   -- https://ol7:8443/ords/f?p=100:SUPPORT:0:LOCKEDOUT:NO::::
select "GET_URL"('LOCK') as apex_url from dual;                    -- https://ol7:8443/ords/f?p=100:USRLOCKED:0:LOCKED:NO::::
select "GET_URL"('UNLOCK') as apex_url from dual;                  -- https://ol7:8443/ords/f?p=100:RESETPW:0:RESETPW:NO::::
select "GET_URL"('HOME') as apex_url from dual;                    -- https://ol7:8443/ords/f?p=100:HOME:0:WELCOME:NO::::
select "GET_URL"(p_url => '100:10:'||nvl(v('APP_SESSION'), 0)||':RESTAPI::P102:'||to_char(sysdate, 'ddmmyyyy')) as apex_url from dual; -- https://ol7:8443/ords/f?p=100:10:0:::
select "GET_URL"('REGISTER', p_params => 'USR,TKN', p_values => 'User@Domain.net,NTA2Mjc3ODJ0LW9ubGluZS5kZTEzNDAyNTY1MDI=') as apex_url from dual;
--https://ol7:8443/ords/f?p=100:USRREG:0:REGISTER:NO::USR,TKN:User@Domain.net,NTA2Mjc3ODJ0LW9ubGluZS5kZTEzNDAyNTY1MDI=:
select "GET_URL"('REGISTER', p_params => 'USR,TKN', p_values => 'User@Domain.net,NTA2Mjc3ODJ0LW9ubGluZS5kZTEzNDAyNTY1MDI=', p_no_to_null => 1) as apex_url from dual;
-- https://ol7:8443/ords/f?p=100:USRREG:0:REGISTER:::USR,TKN:User@Domain.net,NTA2Mjc3ODJ0LW9ubGluZS5kZTEzNDAyNTY1MDI=:


------------------------------------------------------------------------------------------------------
-- Set Apex Email Content
-- @requires GET_URL and SET_URL
--
create or replace procedure "SET_EMAIL_CONTENT" (
      p_topic           in varchar2        := null
    , p_mailto          in varchar2        := null
    , p_subject         in out clob
    , p_body            in out clob
    , p_body_html       in out clob
    , p_params          in varchar2        := null
    , p_values          in varchar2        := null
    , p_query           in varchar2        := null
    , p_app_id          in pls_integer     := null
    , p_mail_id         in pls_integer     := null
    , p_debug           in boolean         := false
 )
is
    l_topic                     varchar2(64);
    l_mailto                    varchar2(128);
    l_subject                   clob;
    l_body                      clob;
    l_body_html                 clob;
    l_mail_head                 clob;
    l_mail_tail                 clob;
    l_mail_body                 clob;
    l_params                    clob;
    l_values                    clob;
    l_query                     clob;
    l_app_id                    pls_integer;
    l_mail_id                   pls_integer;
    l_rowcnt                    pls_integer := 0;
    l_debug                     boolean;

    -- Constants and Defaults
    LF              constant    varchar2(2)     := utl_tcp.crlf;
    QP              constant    varchar2(4)     := chr(38)||'c='; -- url query prefix for app alias urls &c=WORKSPACE_NAME
    C_APP_ID        constant    pls_integer     := 100;
    C_MAIL_ID       constant    pls_integer     := null;
    C_DEBUG         constant    boolean         := false;

    -- Mail Topic Defaults
    C_TOPIC         constant    clob := 'WELCOME';
    C_SUBJECT       constant    clob := 'Apex Welcome Testmail'; -- Default Subject
    C_MAIL_TO       constant    clob := 'Dear User'; -- Default Mail To
    C_MAIL_HEAD     constant    clob := '<h2>Hello ##MAIL_TO##</h2>';  -- Headline
    C_MAIL_TAIL     constant    clob := '<p>Sincerely,<br />' || LF ||'Yo Bro from Next Do''<br />'; -- Greeting and Signature
    C_MAIL_IMG1     constant    clob := ''; -- Image 1
    C_MAIL_IMG2     constant    clob := ''; -- Image 2
    C_MAIL_IMG3     constant    clob := '  <img src="http://zapt1.staticworld.net/images/article/2013/04/oracle-logo-100033308-gallery.png" alt="Oracle Logo">'|| LF ||'</p>' || LF; -- Image 3 (included in MAIL_TAIL, so closing p tag needed)

    -- Default Mail Body HTML Text (Head and Tail will be pre- and appended)
    C_MAIL_BODY     constant    clob :=  LF ||
        C_MAIL_IMG1|| LF || C_MAIL_HEAD || LF || C_MAIL_IMG2 || LF ||
        '<p>This is a Testmail from our System.<br />'|| LF ||
        'You can safely ignore this message.</p>'||
        LF || C_MAIL_TAIL || LF || C_MAIL_IMG3;
    C_BODY          constant    clob := 'To view the content of this message, please use an HTML enabled mail client.';
    C_BODY_HTML     constant    clob := '<html><body>'  || LF ||
                                        '##MAIL_BODY##' || LF ||
                                        '</body></html>';
    C_PARAMS        constant    clob := null;
    C_VALUES        constant    clob := null;
    C_QUERY         constant    clob := null;

begin

    -- Init Vars
    l_body          :=  C_BODY; -- using same default for all non-html emails
    l_mailto        :=  nvl(p_mailto    , C_MAIL_TO);
    l_mail_body     :=  replace(C_BODY_HTML, '##MAIL_BODY##',
                            replace(C_MAIL_BODY, '##MAIL_TO##', l_mailto)
                                );
    l_topic         :=  nvl(upper(trim(p_topic)), C_TOPIC);
    l_app_id        :=  nvl(p_app_id    , nvl(v('APP_ID'), C_APP_ID));
    l_debug         :=  nvl(p_debug     , C_DEBUG);
    l_mail_id       :=  nvl(p_mail_id   , C_MAIL_ID);
    l_params        :=  nvl(p_params    , C_PARAMS);
    l_values        :=  nvl(p_values    , C_VALUES);

    if (instr(p_query, QP) > 0 or instr(p_query, '?') > 0) then
        -- we assume a valid query string
        l_query     :=        nvl(p_query     , C_QUERY);
    else
        l_query     :=  QP || nvl(p_query     , C_QUERY);
    end if;

    -- check Topic and set Body Text get values from table
    for t in   (
                select  apex_mail_id,
                        mail_subject,
                        mail_body,
                        mail_body_html,
                        replace (
                            replace (
                                replace(
                                    replace(mail_body_html , '##PARAMS##', l_params),
                                        '##VALUES##', l_values),
                                    '##QUERY##', l_query),
                            '##MAIL_TO##', l_mailto
                        ) as mail_body_html_escaped,
                        apex_app_id
                from   "APEX_MAIL_TOPIC_CONTENTS"
               where    apex_mail_id = nvl(p_mail_id   , apex_mail_id)
                 and    apex_app_id  = nvl(l_app_id    , apex_app_id)
                 and    upper(trim(apex_mail_topic))   = l_topic
                )
    loop
        l_app_id    := nvl(t.apex_app_id              , l_app_id    );
        l_mail_id   := nvl(t.apex_mail_id             , C_MAIL_ID   );
        l_body      := nvl(t.mail_body                , C_BODY      );
        l_subject   := nvl(t.mail_subject             , C_SUBJECT   );
        l_body_html := nvl(t.mail_body_html_escaped   , l_mail_body );
        l_rowcnt    := l_rowcnt + 1;
    end loop;

    -- nothing found, so set default subject and mail body
    if (l_rowcnt = 0) then
        l_subject   := nvl(l_subject, C_SUBJECT);
        l_body_html := l_mail_body;
    end if;

    -- Process Defaults for input parameters

    -- subject
    if (p_subject is not null) then
        l_subject := p_subject;
    else
        l_subject := nvl(l_subject, C_SUBJECT);
    end if;

    -- body text
    if (p_body is not null) then
        l_body := p_body;
    else
        l_body := nvl(l_body, C_BODY);
    end if;

    -- body_html
    if (p_body_html is not null) then
        if (instr(lower(p_body_html), '<html>') > 0 and
            instr(lower(p_body_html), '</body>') > 0) then
            -- we assume a valid HTML document
            l_body_html := p_body_html;
        else
            l_body_html := replace(C_BODY_HTML, '##MAIL_BODY##', p_body_html);
        end if;
    else -- set Default Mail Body
        l_body_html := nvl(l_body_html, l_mail_body);
    end if;

    -- set output variables
    p_subject     := l_subject;
    p_body        := l_body;
    p_body_html   := l_body_html;

    if (l_debug) then -- show what we got
        dbms_output.put_line (
        '*** SET EMAIL CONTENT Debug:'     || chr(10) ||
        '  p_topic     => ' || l_topic     || chr(10) ||
        ', p_mailto    => ' || l_mailto    || chr(10) ||
        ', p_subject   => ' || l_subject   || chr(10) ||
        ', p_body      => ' || l_body      || chr(10) ||
        ', p_body_html => ' || l_body_html || chr(10) ||
        ', p_params    => ' || l_params    || chr(10) ||
        ', p_values    => ' || l_values    || chr(10) ||
        ', p_query     => ' || l_query     || chr(10) ||
        ', p_app_id    => ' || l_app_id    || chr(10)
        );
    end if;

exception when others then
    -- (re)set output variables
    p_subject     := '-2 ' || SQLERRM;
    p_body        := SQLERRM;
    p_body_html   := '<html><body>' || LF || to_char(SYSDATE, 'DD.MM.YYYY HH24:MI:SS') ||
                     LF || SQLERRM  || LF ||'</body></html>';
end;
/


----------------------------------------------------------------------------------------------------------
-- Test Set Mail Content
declare
    l_app_id             pls_integer  := 110;
    l_topic              varchar2(64) := 'REGISTER';
    l_mailto             varchar2(64) := 's.obermeyer@t-online.de';
    l_subject            clob := null; --'the new way of getting paid';
    l_body               clob := null; --'get a html client';
    l_body_html          clob := null; --'<p>Hi Bro''</p>';
    l_params             varchar2(4000) := 'USR,TOKEN'; -- target page items
    l_values             varchar2(4000) := 's.obermeyer@t-online.de,NTA2Mjc3ODJ0LW9ubGluZS5kZTEzNDAyNTY1MDI='; --nvl(l_username, l_email)||','||l_token
    l_query              varchar2(4000) := null;
begin
    "SET_EMAIL_CONTENT"(l_topic, l_mailto,
                        l_subject,
                        l_body,
                        l_body_html,
                        p_params => l_params,
                        p_values => l_values,
                        p_query => l_query,
                        p_app_id => l_app_id );
    dbms_output.put_line('Subject: '   || l_subject);
    dbms_output.put_line('Body: '      || l_body);
    dbms_output.put_line('Body HTML: ' || l_body_html);
    dbms_output.put_line('Params: '    || l_params);
    dbms_output.put_line('Values: '    || l_values);
    dbms_output.put_line('Query: '     || l_query);
end;
/

----------------------------------------------------------------------------------------------------------
-- Test Set Mail Content Sample Output

-- 'REGISTER'

-- Subject: Registration Confirmation.
-- Body: To view the content of this message, please use an HTML enabled mail client.

-- Body HTML: <html><body>
-- <h2>Hello s.obermeyer@t-online.de</h2>
-- <p>Thank You for registering again.<br />
-- Please confirm your registration at <a href="https://ol7:8443/ords/f?p=:USRREGC::CONFIRM:NO::NEWUSER,TOKEN:s.obermeyer@t-online.de,NTA2Mjc3ODJ0LW9ubGluZS5kZTEzNDAyNTY1MDI=">Registration Confirmation</a> page.</p>

-- <p>Sincerely,<br />
-- Yo Bro from Next Do'<br />
--   <img src="http://zapt1.staticworld.net/images/article/2013/04/oracle-logo-100033308-gallery.png" alt="Oracle Logo">
-- </p>

-- </body></html>

-- Param 1: s.obermeyer@t-online.de,NTA2Mjc3ODJ0LW9ubGluZS5kZTEzNDAyNTY1MDI=


-- 'REG_ATTEMPTS_EXCEEDED'

-- Subject: Registration Attempts exceeded.
-- Body: To view the content of this message, please use an HTML enabled mail client.

-- Body HTML: <html><body>
-- <h2>Hello s.obermeyer@t-online.de</h2>
-- <p>Your Registration was invalidated, because you exceeded maximum registration attempts.<br />
-- Please contact our <a href="https://ol7:8443/ords/f?p=:SUPPORT::FEEDBACK:NO::USR,TOKEN:s.obermeyer@t-online.de,NTA2Mjc3ODJ0LW9ubGluZS5kZTEzNDAyNTY1MDI=">Customer Support</a> page for further information.</p>

-- <p>Sincerely,<br />
-- Yo Bro from Next Do'<br />
--   <img src="http://zapt1.staticworld.net/images/article/2013/04/oracle-logo-100033308-gallery.png" alt="Oracle Logo">
-- </p>

-- </body></html>

-- Param 1: s.obermeyer@t-online.de,NTA2Mjc3ODJ0LW9ubGluZS5kZTEzNDAyNTY1MDI=


-- 'RESET_PW'

-- Subject: Reset Password Information
-- Body: To view the content of this message, please use an HTML enabled mail client.

-- Body HTML: <html><body>
-- <h2>Hello s.obermeyer@t-online.de</h2>
-- <p>You receive this mail in return to Your Pasword Reset Request.<br />
-- Please reset your password at our <a href="https://ol7:8443/ords/f?p=:USRRPWD::RESET:NO::USR,TOKEN:s.obermeyer@t-online.de,NTA2Mjc3ODJ0LW9ubGluZS5kZTEzNDAyNTY1MDI=">Passwod Reset</a> page.</p>

-- <p>Sincerely,<br />
-- Yo Bro from Next Do'<br />
--   <img src="http://zapt1.staticworld.net/images/article/2013/04/oracle-logo-100033308-gallery.png" alt="Oracle Logo">
-- </p>

-- </body></html>

----------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------
-- Set Apex Email Content
-- @requires GET_URL and SET_URL
--
create or replace function "GET_EMAIL_CONTENT" (
      p_topic            in          varchar2        := null
    , p_what_to_return   in          varchar2        := null
    , p_mailto           in          varchar2        := null
    , p_subject          in          clob            := null
    , p_body             in          clob            := null
    , p_body_html        in          clob            := null
    , p_params           in          clob            := null
    , p_values           in          clob            := null
    , p_query            in          clob            := null
    , p_app_id           in          pls_integer     := null
    , p_mail_id          in          pls_integer     := null
 )  return clob
is
    l_topic              varchar2(64);
    l_mailto             varchar2(128);
    l_what_to_return     varchar2(32); -- [ SUBJECT, BODY, BODY_HTML, ALL (default) ]
    l_subject            clob;
    l_body               clob;
    l_body_html          clob;
    l_params             clob;
    l_values             clob;
    l_query              clob;
    l_return             clob;
    l_return_all         clob;
    l_app_id             pls_integer;
    l_mail_id            pls_integer;

    LF                   constant varchar2(2)  := utl_tcp.crlf;
    C_WHAT_TO_RETURN     constant varchar2(32) := 'ALL';

begin

    -- set inputs and defaults
    l_topic              := p_topic;
    l_what_to_return     := nvl(upper(trim(p_what_to_return)), C_WHAT_TO_RETURN);
    l_mailto             := p_mailto;
    l_subject            := p_subject;
    l_body               := p_body;
    l_body_html          := p_body_html;
    l_params             := p_params;
    l_values             := p_values;
    l_query              := p_query;
    l_app_id             := p_app_id;
    l_mail_id            := p_mail_id;

    -- set content based on inputs
    "SET_EMAIL_CONTENT" (
          p_topic        =>    l_topic
        , p_mailto       =>    l_mailto
        , p_subject      =>    l_subject
        , p_body         =>    l_body
        , p_body_html    =>    l_body_html
        , p_params       =>    l_params
        , p_values       =>    l_values
        , p_query        =>    l_query
        , p_app_id       =>    l_app_id
        , p_mail_id      =>    l_mail_id
    );

    -- set default return
    l_return_all  :=    '##MAIL_CONTENT: ' || SYSDATE     || LF ||
                        '##APP_ID: '       || l_app_id    || LF ||
                        '##MAIL_ID: '      || l_mail_id   || LF ||
                        '##TOPIC: '        || l_topic     || LF ||
                        '##MAILTO: '       || l_mailto    || LF ||
                        '##SUBJECT: '      || l_subject   || LF ||
                        '##BODY: '         || l_body      || LF ||
                        '##BODY_HTML: '    || l_body_html || LF ||
                        '##PARAMS: '       || l_params    || LF ||
                        '##VALUES: '       || l_values    || LF ||
                        '##QUERY: '        || l_query     || LF ;

    -- evaluate return
    if (l_what_to_return = 'ALL') then
        l_return    := l_return_all;
    elsif (l_what_to_return = 'TOPIC') then
        l_return    := l_topic;
    elsif (l_what_to_return = 'SUBJECT') then
        l_return    := l_subject;
    elsif (l_what_to_return = 'BODY') then
        l_return    := l_body;
    elsif (l_what_to_return = 'BODY_HTML') then
        l_return    := l_body_html;
    elsif (l_what_to_return = 'PARAMS') then
        l_return    := l_params;
    elsif (l_what_to_return = 'VALUES') then
        l_return    := l_values;
    elsif (l_what_to_return = 'QUERY') then
        l_return    := l_query;
    elsif (l_what_to_return = 'APP') then
        l_return    := to_clob(l_app_id);
    elsif (l_what_to_return = 'MAIL_ID') then
        l_return    := to_clob(l_mail_id);
    else -- return default
        l_return    := l_return_all;
    end if;

    -- Return final output
    return l_return;

exception when others then
    l_return := SQLERRM;
    return l_return;
end;
/

--------------------------------------------------------------------------------
-- Test Get Mail Content
select "GET_EMAIL_CONTENT" from dual;

--##MAIL_CONTENT:02.01.2018 23:23:25
--##TOPIC:
--##SUBJECT: Apex Welcome Testmail
--##BODY: To view the content of this message, please use an HTML enabled mail client.
--##BODY_HTML: <html><body>
--
--
--<h2>Hello Dear User</h2>
--
--<p>This is a Testmail from our System.<br />
--You can safely ignore this message.</p>
--<p>Sincerely,<br />
--Yo Bro from Next Do'<br />
--  <img src="http://zapt1.staticworld.net/images/article/2013/04/oracle-logo-100033308-gallery.png" alt="Oracle Logo">
--</p>
--
--</body></html>
--##PARAMS:
--##VALUES:
--##QUERY:


select "GET_EMAIL_CONTENT"('REGISTER') from dual;

--##MAIL_CONTENT:02.01.2018 23:24:10
--##TOPIC: REGISTER
--##SUBJECT: Registration Confirmation.
--##BODY: To view the content of this message, please use an HTML enabled mail client.
--##BODY_HTML: <html><body>
--<h2>Hello Dear User</h2>
--<p>Please confirm your registration at <a href="https://ol7:8443/ords/f?p=100:USRREG:0:REGISTER:::::">Registration Confirmation</a> page.</p>
--
--<p>Sincerely,<br />
--Yo Bro from Next Do'<br />
--  <img src="http://zapt1.staticworld.net/images/article/2013/04/oracle-logo-100033308-gallery.png" alt="Oracle Logo">
--</p>
--
--</body></html>
--##PARAMS:
--##VALUES:
--##QUERY:


select "GET_EMAIL_CONTENT"('REGISTER', p_mailto => 'user@domain.net', p_params => 'USR,TKN', p_values => 'user@domain.net,NTA2Mjc3ODJ0LW9ubGluZS5kZTEzNDAyNTY1MDI=') from dual;

--##MAIL_CONTENT: 02.01.2018 23:39:55
--##TOPIC: REGISTER
--##MAILTO: user@domain.net
--##SUBJECT: Registration Confirmation.
--##BODY: To view the content of this message, please use an HTML enabled mail client.
--##BODY_HTML: <html><body>
--<h2>Hello user@domain.net</h2>
--<p>Please confirm your registration at <a href="https://ol7:8443/ords/f?p=100:USRREG:0:REGISTER:::USR,TKN:user@domain.net,NTA2Mjc3ODJ0LW9ubGluZS5kZTEzNDAyNTY1MDI=:">Registration Confirmation</a> page.</p>
--
--<p>Sincerely,<br />
--Yo Bro from Next Do'<br />
--  <img src="http://zapt1.staticworld.net/images/article/2013/04/oracle-logo-100033308-gallery.png" alt="Oracle Logo">
--</p>
--
--</body></html>
--##PARAMS: USR,TKN
--##VALUES: user@domain.net,NTA2Mjc3ODJ0LW9ubGluZS5kZTEzNDAyNTY1MDI=
--##QUERY:


select "GET_EMAIL_CONTENT"('LOCK') from dual;

--##MAIL_CONTENT:02.01.2018 23:25:01
--##TOPIC: LOCK
--##SUBJECT: Account locked!
--##BODY: To view the content of this message, please use an HTML enabled mail client.
--##BODY_HTML: <html><body>
--<h2>Hello Dear User</h2>
--<p>Your Account was locked!<br />
--Please reset your password to unlock Your account at our <a href="https://ol7:8443/ords/f?p=100:USRLOCKED:0:LOCKED:::::">Passwod Reset</a> page.</p>
--
--<p>Sincerely,<br />
--Yo Bro from Next Do'<br />
--  <img src="http://zapt1.staticworld.net/images/article/2013/04/oracle-logo-100033308-gallery.png" alt="Oracle Logo">
--</p>
--
--</body></html>
--##PARAMS:
--##VALUES:
--##QUERY:

-- Pricey - runs all for one result
select "GET_EMAIL_CONTENT"('LOCK', 'Subject') as subject from dual;

--Account locked!


select "GET_EMAIL_CONTENT"('REGISTER', 'SUBJECT') as subject from dual;

-- Registration Confirmation.


--------------------------------------------------------------------------------
-- Wrapper Functions to Email Properties

-- Email Subject
create or replace function "GET_EMAIL_SUBJECT" (
    p_topic     in varchar2  := null, -- [REGISTER, REREGISTER, RESETPW, UNLOCK,..])
    p_subject   in varchar2  := null
) return varchar2
is
l_subject varchar2(1000);
begin
    l_subject := "GET_EMAIL_CONTENT"(p_topic, 'SUBJECT', p_subject => p_subject);
return l_subject;
exception when others then
    l_subject := SQLERRM;
    return l_subject;
end;
/


-- Email Text Body
create or replace function "GET_EMAIL_BODY" (
    p_topic     in varchar2  := null, -- [REGISTER, REREGISTER, RESETPW, UNLOCK,..])
    p_body_text in clob      := null
) return clob
is
l_body_text clob;
begin
    l_body_text := "GET_EMAIL_CONTENT"(p_topic, 'BODY', p_body => p_body_text);
return l_body_text;
exception when others then
    l_body_text := SQLERRM;
    return l_body_text;
end;
/

-- Email HTML Body
create or replace function "GET_EMAIL_BODY_HTML" (
    p_topic     in varchar2  := null, -- [REGISTER, REREGISTER, RESETPW, UNLOCK,..])
    p_body_html in clob      := null
) return clob
is
l_body_html clob;
begin
    l_body_html := "GET_EMAIL_CONTENT"(p_topic, 'BODY_HTML', p_body_html => p_body_html);
return l_body_html;
exception when others then
    l_body_html := '<html><body>'||SQLERRM||'</body></html>';
    return l_body_html;
end;
/


--------------------------------------------------------------------------------
-- SMTP Reply Text by Code.
create or replace function "GET_SMTP_REPLY_TEXT" (
    p_code     in           pls_integer
) return varchar2
is

    type l_replies_tab  is table of varchar2(4000)
    index by pls_integer;
    l_replies      l_replies_tab;
    l_return       varchar2(4000);

    C_RESULT_OFFSET             constant pls_integer    := 10;

begin
    -- List of SMTP reply codes.
    -- https://docs.oracle.com/cd/B19306_01/appdev.102/b14258/u_smtp.htm#i1006659
    -- Table 178-3 SMTP Reply Codes
    l_replies(0)   := 'Unknown'; -- not official and used for fallback
    l_replies(211) := 'System status, or system help reply)';
    l_replies(214) := 'Help message [Information on how to use the receiver or the meaning of a particular non-standard command; this reply is useful only to the human user])';
    l_replies(220) := '<domain> Service ready)';
    l_replies(221) := '<domain> Service closing transmission channel)';
    l_replies(250) := 'Requested mail action okay, completed)';
    l_replies(251) := 'User not local; will forward to <forward-path>)';
    l_replies(252) := 'OK, pending messages for node <node> started. Cannot VRFY user (for example, info is not local), but will take message for this user and attempt delivery.)';
    l_replies(253) := 'OK, <messages> pending messages for node <node> started)';
    l_replies(354) := 'Start mail input; end with <CRLF>.<CRLF>)';
    l_replies(355) := 'Octet-offset is the transaction offset)';
    l_replies(421) := '<domain> Service not available, closing transmission channel (This may be a reply to any command if the service knows it must shut down.))';
    l_replies(450) := 'Requested mail action not taken: mailbox unavailable [for example, mailbox busy])';
    l_replies(451) := 'Requested action terminated: local error in processing)';
    l_replies(452) := 'Requested action not taken: insufficient system storage)';
    l_replies(453) := 'You have no mail.)';
    l_replies(454) := 'TLS not available due to temporary reason. Encryption required for requested authentication mechanism.)';
    l_replies(458) := 'Unable to queue messages for node <node>)';
    l_replies(459) := 'Node <node> not allowed: reason)';
    l_replies(500) := 'Syntax error, command unrecognized (This may include errors such as command line too long.))';
    l_replies(501) := 'Syntax error in parameters or arguments)';
    l_replies(502) := 'Command not implemented)';
    l_replies(503) := 'Bad sequence of commands)';
    l_replies(504) := 'Command parameter not implemented)';
    l_replies(521) := '<Machine> does not accept mail.)';
    l_replies(530) := 'Must issue a STARTTLS command first. Encryption required for requested authentication mechanism.)';
    l_replies(534) := 'Authentication mechanism is too weak.)';
    l_replies(538) := 'Encryption required for requested authentication mechanism.)';
    l_replies(550) := 'Requested action not taken: mailbox unavailable [for , mailbox not found, no access])';
    l_replies(551) := 'User not local; please try <forward-path>)';
    l_replies(552) := 'Requested mail action terminated: exceeded storage allocation)';
    l_replies(553) := 'Requested action not taken: mailbox name not allowed [for example, mailbox syntax incorrect])';
    l_replies(554) := 'Transaction failed)';

    -- check reply code
    if (l_replies.exists(p_code)) then
        l_return := l_replies(p_code);
    else
        l_return := l_replies(0);
    end if;

    return l_return;

exception when others then
    l_return := rpad(SQLCODE, C_RESULT_OFFSET)             ||
                     ' GET_SMTP_REPLY_TEXT Error: ' ||
                     SQLERRM;
    return l_return;
    raise;
end;
/

--------------------------------------------------------------------------------
-- Check Email Address Status by Code.
create or replace function "GET_EMAIL_STATUS_TEXT" (
     p_code                     in  pls_integer
) return varchar2
is

    type l_status_tab           is table of varchar2(4000)
    index by pls_integer;
    l_status                    l_status_tab;

    l_code                      pls_integer;
    l_return                    varchar2(4000);

    C_CODE                      constant pls_integer    := 0;
    C_RESULT_OFFSET             constant pls_integer    := 10;

begin

    l_code                     := nvl(p_code            , C_CODE);

    -- Check Email Status Codes
    l_status(-3) := 'Error in Apex Send Mail';
    l_status(-2) := 'Cannot set Email Content';
    l_status(-1) := 'Error';
    l_status(0)  := 'OK';
    l_status(1)  := 'Invalid Email Address Format';
    l_status(2)  := 'Invalid Domain Format';
    l_status(3)  := 'Invalid Domain Response';
    l_status(4)  := 'Invalid Recipient';
    l_status(5)  := 'Invalid Email Address Response';
    l_status(6)  := 'Invalid Email Address Response';
    l_status(7)  := 'SMTP Transient or Permanent Error!';

    -- check status code
    if (l_status.exists(l_code)) then
        l_return := l_status(p_code);
    else
        l_return := l_status(-1) || ': Status ID [' || l_code || '] out of range!';
    end if;

    return l_return;

exception when others then
    l_return := rpad(SQLCODE, C_RESULT_OFFSET)             ||
                     ' GET_EMAIL_STATUS_TEXT Error: ' ||
                     SQLERRM;
    return l_return;
    raise;
end;
/

--------------------------------------------------------------------------------
-- Test Call to EMAIL_STATUS_TEXT API
select "GET_EMAIL_STATUS_TEXT"(0) as result_text
from dual; -- " OK: "
select "GET_EMAIL_STATUS_TEXT"(-1) as result_text
from dual; --"Error"
select "GET_EMAIL_STATUS_TEXT"(3) as result_text
from dual; --"Invalid Domain Response:"


--------------------------------------------------------------------------------
-- Return Email Address, SMTP or both (ALL) Status by Code.
create or replace function "GET_RESULT_TEXT" (
     p_code                     in  pls_integer
   , p_which                    in  varchar2             := null
   , p_append_suffix            in  varchar2             := 'FALSE'
   , p_suffix                   in  varchar2             := ':'
   , p_wrap_result              in  varchar2             := 'FALSE'
   , p_wrap_char                in  varchar2             := ' '

) return varchar2
is

    l_append_suffix             varchar2(10);
    l_wrap_result               varchar2(10);
    l_wrap_char                 varchar2(10);

    l_code                      pls_integer;
    l_which                     varchar2(10);  -- EMAIL | SMPT
    l_return                    varchar2(4000);

    C_CODE                      constant pls_integer    := 0;
    C_WHICH                     constant varchar2(10)   := 'MAIL'; -- default collection
    C_RESULT_OFFSET             constant pls_integer    := 10;
    C_SUFFIX                    constant varchar2(10)   := ':';
    C_WRAP_CHAR                 constant varchar2(10)   := ' ';
    C_TRUE_CHAR                 constant varchar2(10)   := 'TRUE';
    C_T                         constant varchar2(10)   := C_TRUE_CHAR;
    C_APPEND_SUFFIX             constant varchar2(10)   := C_T;
    C_WRAP_RESULT               constant varchar2(10)   := C_T;

begin

    l_code                     := nvl(p_code, C_CODE);
    l_which                    := nvl(upper(trim(p_which)),         C_WHICH);
    l_append_suffix            := nvl(upper(trim(p_append_suffix)), C_APPEND_SUFFIX);
    l_wrap_result              := nvl(upper(trim(p_wrap_result)),   C_WRAP_RESULT);
    l_wrap_char                := nvl(upper(p_wrap_char),           C_WRAP_CHAR);

    -- check status code
    if (l_which = 'EMAIL') then
        l_return := case when (l_wrap_result   = C_T)
                         then l_wrap_char
                    end ||
                    "GET_EMAIL_STATUS_TEXT"(l_code) ||
                    case when (l_append_suffix = C_T)
                         then C_SUFFIX
                    end ||
                    case when (l_wrap_result   = C_T)
                         then l_wrap_char
                    end;
    elsif (l_which = 'SMTP') then
        l_return := case when (l_wrap_result   = C_T)
                         then l_wrap_char
                    end ||
                    "GET_SMTP_REPLY_TEXT"(l_code)   ||
                    case when (l_append_suffix = C_T)
                         then C_SUFFIX
                    end ||
                    case when (l_wrap_result   = C_T)
                         then l_wrap_char
                    end;
    elsif (l_which = 'ALL') then
        l_return := case when (l_wrap_result   = C_T)
                         then l_wrap_char
                    end ||
                    case when nvl("GET_SMTP_REPLY_TEXT"(l_code)  ,  '0') != '0'
                         then nvl("GET_SMTP_REPLY_TEXT"(l_code)  , '-1') -- fallback if null
                         else nvl("GET_EMAIL_STATUS_TEXT"(l_code), '-1') -- fallback to error
                    end ||
                    case when (l_append_suffix = C_T)
                         then C_SUFFIX
                    end ||
                    case when (l_wrap_result   = C_T)
                         then l_wrap_char
                    end;
    else
        l_return := "GET_EMAIL_STATUS_TEXT"(-1) || ': Parameter [' || l_which || '] out of range!';
    end if;

    return l_return;

exception when others then
    l_return := rpad(SQLCODE, C_RESULT_OFFSET)             ||
                     ' GET_RESULT_TEXT Error: ' ||
                     SQLERRM;
    return l_return;
    raise;
end;
/

--------------------------------------------------------------------------------
-- Test Calls to GET_RESULT_TEXT API
select "GET_RESULT_TEXT"(3, 'EMAIL') as result_text
from dual; -- "Invalid Domain Response"
select "GET_RESULT_TEXT"(5, 'EMAIL', p_wrap_result => 'TRUE') as result_text
from dual; -- "  Invalid Email Address Response  "
select "GET_RESULT_TEXT"(250, 'SMTP', p_wrap_result => 'TRUE') as result_text
from dual; -- " Requested mail action okay, completed) "
select "GET_RESULT_TEXT"(3, 'EMAIL', p_wrap_result => 'TRUE', p_append_suffix => 'TRUE') as result_text
from dual; -- " Invalid Domain Response "
select "GET_RESULT_TEXT"(10, 'EMAIL', p_wrap_result => 'TRUE', p_wrap_char => '#') as result_text
from dual; -- "#Error: Status ID [10] out of range!#"
select "GET_RESULT_TEXT"(7, 'EMAIL', p_wrap_result => 'TRUE', p_wrap_char => ' *** ') as result_text
from dual; -- " *** SMTP Transient or Permanent Error! *** "
select trim("GET_RESULT_TEXT"(7, 'EMAIL', p_wrap_result => 'TRUE', p_wrap_char => ' *** ')) as result_text
from dual; -- "*** SMTP Transient or Permanent Error! ***" -- above trimmed
select trim("GET_RESULT_TEXT"(252, 'SMTP', p_wrap_result => 'TRUE', p_wrap_char => ' $$$ ')) as result_text
from dual; -- "$$$ OK, pending messages for node <node> started. Cannot VRFY user (for example, info is not local), but will take message for this user and attempt delivery.) $$$"


--------------------------------------------------------------------------------
-- Return Email Address formatted for Result Output.
create or replace function "GET_EMAIL_STATUS_FORMATTED" (
      p_code                    in  pls_integer
    , p_style                   in  varchar2 := null
    , p_trim_output             in  varchar2 := 'FALSE'
) return varchar2
is

    l_code                      pls_integer;
    l_style                     varchar2(128);
    l_trim_output               varchar2(10);
    l_return                    varchar2(4000);

    C_RESULT_OFFSET             constant pls_integer    := 10;

begin

    l_code                      := nvl(p_code, -1);
    l_style                     := nvl(upper(trim(p_style)), 'RESULT_TEXT');
    l_trim_output               := nvl(upper(trim(p_trim_output)), 'TRUE');

    -- more styles to be added later
    if (l_style = 'RESULT_TEXT') then
        l_return :=   "GET_RESULT_TEXT"(  l_code
                                        , p_which             => 'EMAIL'
                                        , p_append_suffix     => 'TRUE'
                                        , p_suffix            => ':'
                                        , p_wrap_result       => 'TRUE'
                                        , p_wrap_char         => ' '
                                        );
    end if;

    if (l_trim_output = 'TRUE') then
        l_return    :=  trim(l_return);
    elsif (instr(l_return, 'Error:') > 0) then
        l_return := rtrim(l_return);
        l_return := substr(l_return, 1, length(l_return) -1) || ' '; -- removed trailing ":"
    end if;

    return l_return;

exception when others then
    l_return := rpad(SQLCODE, C_RESULT_OFFSET)             ||
                     ' GET_EMAIL_STATUS_FORMATTED Error: ' ||
                     SQLERRM;
    return l_return;
    raise;
end;
/


--------------------------------------------------------------------------------
-- Test Calls to GET_EMAIL_STATUS_FORMATTED API
select "GET_EMAIL_STATUS_FORMATTED" (0) as status_text
from dual; -- " OK: "
select "GET_EMAIL_STATUS_FORMATTED" (3) as status_text
from dual; -- " Invalid Domain Response: "
select "GET_EMAIL_STATUS_FORMATTED" (10) as status_text
from dual; -- " Error: Status ID [10] out of range! " -- removed : at end


--------------------------------------------------------------------------------
-- Check Email Address and Domain Name Format and Accessibility
create or replace procedure "CHECK_EMAIL_ADDRESS" (
    p_mailto                    in         varchar2
  , p_result                    in out     clob
  , p_domain                    in         varchar2     := null
  , p_smtp                      in         varchar2     := null
  , p_from                      in         varchar2     := null
  , p_check_format              in         boolean      := true
  , p_check_smtp                in         boolean      := false
  , p_treat_252_as_ok           in         boolean      := true
  , p_secure_conn_before_smtp   in         boolean      := false
)
is

    l_conn                      utl_smtp.connection;
    l_reply                     utl_smtp.reply;
    l_mailto                    varchar2(128)           := null;
    l_result                    clob                    := null;
    l_domain                    varchar2(128)           := null;
    l_smtp                      varchar2(128)           := null;
    l_from                      varchar2(128)           := null;
    l_email_format_valid        boolean                 := false;
    l_domain_format_valid       boolean                 := false;
    l_check_format              boolean                 := false;
    l_check_smtp                boolean                 := false;
    l_step                      pls_integer             := 0;

    C_SMTP                      constant varchar2(128)  := 'localhost'; -- 'securesmtp.t-online.de requires a certificate and startssl';
    C_FROM                      constant varchar2(128)  := 's.obermeyer@t-online.de';
    C_DOMAIN                    constant varchar2(128)  := 'example.com';
    C_MAILTO                    constant varchar2(128)  := 'user@'||C_DOMAIN;
    C_RESULT                    constant varchar2(1000) := 0;
    C_CHECK_FORMAT              constant boolean        := true;
    C_CHECK_SMTP                constant boolean        := false;  -- check if email adress can be verified by SMTP
    C_RESULT_OFFSET             constant pls_integer    := 10;
    C_EMAIL_REGEXP              constant clob           := '^.*@[a-z0-9][-a-z.0-9]*[a-z0-9]$';
    C_EMAIL_NOT_REGEXP          constant clob           := '^.*\.$';
    C_DOMAIN_REGEXP             constant clob           := '^[a-z0-9][-a-z.0-9]*[a-z0-9]$';
    C_DOMAIN_NOT_REGEXP         constant clob           := '\.\.';
    C_SECURE_CONN_BEFORE_SMTP   constant boolean        := false;
    C_TREAT_252_AS_OK           constant boolean        := true;  -- determines if User VRFY Reply with Code: 252 will treated as ok (for development and testing purposes)
    C_TRUE_CHAR                 constant varchar2(6)    := 'TRUE';
    C_T                         constant varchar2(6)    := C_TRUE_CHAR;

    email_address_error         exception;

begin

    -- set Inputs and Defaults
    l_result                    := '0';
    l_mailto                    := nvl(p_mailto, C_MAILTO);
    l_domain                    := "PARSE_DOMAIN_FROM_EMAIL"(l_mailto);
    l_check_smtp                := nvl(p_check_smtp, C_CHECK_SMTP);
    l_check_format              := nvl(p_check_format, C_CHECK_FORMAT);

    -- check email address format, if specified to do so
    if (l_check_format) then
        l_email_format_valid    :=  (regexp_like(l_mailto, C_EMAIL_REGEXP)
                                    and not regexp_like(l_domain, C_EMAIL_NOT_REGEXP)
                                    );
        l_domain_format_valid   := (regexp_like(l_domain, C_DOMAIN_REGEXP)
                                    and not regexp_like(l_domain, C_DOMAIN_NOT_REGEXP)
                                    );

        l_step  := 1;
        if not l_email_format_valid then
            l_result := rpad(l_step, C_RESULT_OFFSET) ||
                        "GET_EMAIL_STATUS_FORMATTED" (l_step) || l_mailto ;
            raise email_address_error;
        end if;

        l_step  := 2;
        if not l_domain_format_valid then
            l_result := rpad(l_step, C_RESULT_OFFSET) ||
                        "GET_EMAIL_STATUS_FORMATTED" (l_step) || l_domain ;
            raise email_address_error;
        end if;

    end if;

    if (l_check_smtp) then
        -- verify Domain and Email accessibility
        utl_tcp.close_all_connections;

        l_conn      := utl_smtp.open_connection (
                            nvl(l_smtp, C_SMTP),
                            secure_connection_before_smtp =>
                                nvl(p_secure_conn_before_smtp,
                                        C_SECURE_CONN_BEFORE_SMTP)
                            );
        l_smtp      := nvl(p_smtp    , C_SMTP);
        l_from      := nvl(p_from    , C_FROM);

        -- SMTP checks
        l_step  := 3;
        l_reply := utl_smtp.helo(l_conn, l_domain);
            if (l_reply.code != 250) then
            l_result := rpad(l_step, C_RESULT_OFFSET)   ||
                        "GET_EMAIL_STATUS_FORMATTED" (l_step) || l_domain ||
                        ' Reply: ' ||  l_reply.code  ||  ' '  ||
                         "GET_SMTP_REPLY_TEXT" (l_reply.code) ||
                        ' Reply Text: ' || l_reply.text;
            raise email_address_error;
        end if;
        l_step  := 4;
        l_reply := utl_smtp.mail(l_conn, l_from);
        if (l_reply.code != 250) then
            l_result := rpad(l_step, C_RESULT_OFFSET) ||
                        "GET_EMAIL_STATUS_FORMATTED" (l_step) || l_from ||
                        ' Reply: ' ||   l_reply.code  || ' '  ||
                         "GET_SMTP_REPLY_TEXT" (l_reply.code) ||
                        ' Reply Text: ' || l_reply.text;
            raise email_address_error;
        end if;
        l_step := 5;
        l_reply := utl_smtp.rcpt(l_conn, l_from);
        if (l_reply.code != 250) then
            l_result := rpad(l_step, C_RESULT_OFFSET) ||
                        "GET_EMAIL_STATUS_FORMATTED" (l_step) || l_from  ||
                        ' Reply: ' ||   l_reply.code  || ' '  ||
                         "GET_SMTP_REPLY_TEXT" (l_reply.code) ||
                        ' Reply Text: ' || l_reply.text;
            raise email_address_error;
        end if;
        l_step := 6;
        l_reply := utl_smtp.vrfy(l_conn, l_mailto);
        if (nvl(p_treat_252_as_ok, C_TREAT_252_AS_OK)) then
            if (l_reply.code not in (250, 251, 252)) then
                l_result := rpad(l_step, C_RESULT_OFFSET) ||
                            "GET_EMAIL_STATUS_FORMATTED" (l_step) || l_mailto ||
                            ' Reply: '  ||  l_reply.code  ||  ' ' ||
                             "GET_SMTP_REPLY_TEXT" (l_reply.code) ||
                            ' Reply Text: ' || l_reply.text;
                raise email_address_error;
            else --reset result
                l_result := '0';
            end if;
        elsif (l_reply.code not in (250, 251)) then
            l_result := rpad(l_step, C_RESULT_OFFSET) ||
                        "GET_EMAIL_STATUS_FORMATTED" (l_step) || l_mailto ||
                        ' Reply: '  || l_reply.code  ||  ' '  ||
                         "GET_SMTP_REPLY_TEXT" (l_reply.code) ||
                        ' Reply Text: ' || l_reply.text;
                raise email_address_error;
        else  --reset result
                l_result := '0';
        end if;

        utl_smtp.quit(l_conn);

    end if;

    if ( nvl(l_result, '0') = '0') then
        p_result    :=  rpad(nvl(l_result, '0'), C_RESULT_OFFSET) ||
                                ' OK ' ||
                                case when l_reply.code is null  -- check_smtp = false
                                     then 'Email Address Format'
                                     else 'SMTP'
                                end ||  ' succeeded. ' || l_reply.code;
    end if;

exception
    -- email address check failed
    when email_address_error then
        p_result := l_result;
        begin
            utl_smtp.quit(l_conn);
            exception when  utl_smtp.transient_error or
                            utl_smtp.permanent_error then null;
                            -- when the smtp server is down or unavailable, we don't have
                            -- a connection to the server. The QUIT call raises an
                            -- exception that we can ignore.
        end;
    -- generic mail errors
    when    UTL_SMTP.TRANSIENT_ERROR or
            UTL_SMTP.PERMANENT_ERROR then
            l_step      :=  7;
            l_result    :=  rpad(l_step, C_RESULT_OFFSET)         ||
                            "GET_EMAIL_STATUS_FORMATTED" (l_step) ||
                            SQLERRM ;
            p_result := l_result;
            begin
            utl_smtp.quit(l_conn);
            exception
                when utl_smtp.transient_error or utl_smtp.permanent_error then
                null;
            end;

    when others then
            l_result  := rpad(SQLCODE, C_RESULT_OFFSET)             ||
                                   ' GET_EMAIL_STATUS_FORMATTED Error: ' ||
                                   SQLERRM;
            p_result := l_result;
    raise;
end;
/



--------------------------------------------------------------------------------
-- Function IS_VALID_EMAIL returns BOOLEAN
create or replace function "IS_VALID_EMAIL" (
    p_email                         in         varchar2
  , p_check_format                  in         boolean  := false
  , p_check_smtp                    in         boolean  := true
  , p_treat_252_as_ok               in         boolean  := true
  , p_secure_conn_before_smtp       in         boolean  := false
  , p_output_result                 in         boolean  := false
) return boolean
is
    l_result                        clob;
    l_return                        boolean;
    l_check_format                  boolean;
    l_check_smtp                    boolean;
    l_treat_252_as_ok               boolean;
    l_secure_conn_before_smtp       boolean;
begin

    l_check_format                  := p_check_format;
    l_check_smtp                    := p_check_smtp;
    l_treat_252_as_ok               := p_treat_252_as_ok;
    l_secure_conn_before_smtp       := p_secure_conn_before_smtp;

    "CHECK_EMAIL_ADDRESS"(
        p_mailto                     =>   p_email
      , p_result                     =>   l_result
      , p_check_format               =>   l_check_format
      , p_check_smtp                 =>   l_check_smtp
      , p_treat_252_as_ok            =>   l_treat_252_as_ok
      , p_secure_conn_before_smtp    =>   l_secure_conn_before_smtp
    );

    if (p_output_result) then
        dbms_output.put_line(SYSDATE ||
                             ' IS_VALID_EMAIL Function Result:  '|| chr(10) ||
                             SYSDATE || ' Code: ' || substr(l_result, 1, 1) ||
                             substr(l_result, 10));
    end if;

    if (to_number(substr(l_result, 1, 1)) = 0) then
        l_return := true;
    else
        l_return := false;
    end if;

    return l_return;

exception when others then
return false;
end;
/


--------------------------------------------------------------------------------
-- Test Call to IS_VALID_EMAIL API returning Boolean
declare
l_email varchar2(100) := 's.obermeyer@t-online.de';
begin
  if (IS_VALID_EMAIL(  l_email
                     , p_treat_252_as_ok => true
                     , p_output_result => true
                     , p_check_smtp => true
                     )
      ) then
      dbms_output.put_line(l_email || ' is valid');
  else
      dbms_output.put_line(l_email || ' is invalid');
  end if;
end;
/

--------------------------------------------------------------------------------
-- Function IS_VALID_EMAIL_ADDRESS returns CLOB
create or replace function "IS_VALID_EMAIL_ADDRESS" (
    p_email                         in         varchar2
  , p_check_format                  in         varchar2 := 'FALSE'
  , p_check_smtp                    in         varchar2 := 'TRUE'
  , p_treat_252_as_ok               in         varchar2 := 'TRUE'
  , p_secure_conn_before_smtp       in         varchar2 := 'FALSE'
) return clob
is
    l_result                        clob;
    l_return                        clob;
    l_check_format                  boolean;
    l_check_smtp                    boolean;
    l_treat_252_as_ok               boolean;
    l_secure_conn_before_smtp       boolean;

    C_RESULT_OFFSET                 constant  pls_integer := 10;
    C_TRUE_CHAR                     constant varchar2(6)  := 'TRUE';
    C_T                             constant varchar2(6)  := C_TRUE_CHAR;

begin

    l_check_format                  := case upper(p_check_format)
                                       when C_T then true else false end;
    l_check_smtp                    := case upper(p_check_smtp)
                                       when C_T then true else false end;
    l_treat_252_as_ok               := case upper(p_treat_252_as_ok)
                                       when C_T then true else false end;
    l_secure_conn_before_smtp       := case upper(p_secure_conn_before_smtp)
                                       when C_T then true else false end;


    "CHECK_EMAIL_ADDRESS"(
        p_mailto                     =>   p_email
      , p_result                     =>   l_result
      , p_check_format               =>   l_check_format
      , p_check_smtp                 =>   l_check_smtp
      , p_treat_252_as_ok            =>   l_treat_252_as_ok
      , p_secure_conn_before_smtp    =>   l_secure_conn_before_smtp
    );

    if (l_result is not null) then
        l_return := substr(l_result, 1, 2) ||
                    substr(l_result, C_RESULT_OFFSET);
    else
        l_return := rpad('-1', C_RESULT_OFFSET) || 'Unkown Result';
    end if;

    return l_return;

exception when others then
    l_return := rpad(SQLCODE, C_RESULT_OFFSET)    ||
                ' IS_VALID_EMAIL_ADDRESS Error: ' ||
                SQLERRM;
    return l_return;
end;
/

--------------------------------------------------------------------------------
-- Test Call to IS_VALID_EMAIL_ADDRESS
select is_valid_email_address('s.obermeyer@t-online.de') as is_valid_email_address
from dual; -- "0   OK SMTP succeeded. 252"

select is_valid_email_address(  's.obermeyer@t-online.de'
                              , p_treat_252_as_ok => 'TRUE') as is_valid_email_address
from dual; -- "0   OK SMTP succeeded. 252"

select is_valid_email_address(  's.obermeyer@t-online.de'
                              , p_treat_252_as_ok => 'FALSE') as is_valid_email_address
from dual; -- "6   Invalid Email Address Response: s.obermeyer@t-online.de Reply: 252 OK, pending messages for node <node> started. Cannot VRFY user (for example, info is not local), but will take message for this user and attempt delivery.) Reply Text: 2.0.0 s.obermeyer@t-online.de"


--------------------------------------------------------------------------------
-- Function IS_VALID_EMAIL_ADDRESS returns CLOB
create or replace function "IS_VALID_EMAIL_ADDRESS_CODE" (
    p_email                         in         varchar2
  , p_check_format                  in         varchar2 := 'TRUE'
  , p_check_smtp                    in         varchar2 := 'FALSE'
  , p_treat_252_as_ok               in         varchar2 := 'TRUE'
  , p_secure_conn_before_smtp       in         varchar2 := 'FALSE'
  , p_shift_result                  in         pls_integer := null
) return pls_integer
is
    l_result                        clob;
    l_return                        pls_integer;
    l_shift_result                  pls_integer;
    l_check_format                  boolean;
    l_check_smtp                    boolean;
    l_treat_252_as_ok               boolean;
    l_secure_conn_before_smtp       boolean;

    C_RESULT_OFFSET                 constant  pls_integer := 10;
    C_SHIFT_RESULT                  constant  pls_integer :=  0;
    C_TRUE_CHAR                     constant varchar2(6)  := 'TRUE';
    C_T                             constant varchar2(6)  := C_TRUE_CHAR;

begin

    l_check_format                  := case upper(p_check_format)
                                       when C_T
                                       then true else false end;
    l_check_smtp                    := case upper(p_check_smtp)
                                       when C_T
                                       then true else false end;
    l_treat_252_as_ok               := case upper(p_treat_252_as_ok)
                                       when C_T
                                       then true else false end;
    l_secure_conn_before_smtp       := case upper(p_secure_conn_before_smtp)
                                       when C_T
                                       then true else false end;
    l_shift_result                  := nvl(p_shift_result, C_SHIFT_RESULT);

    "CHECK_EMAIL_ADDRESS"(
        p_mailto                     =>   p_email
      , p_result                     =>   l_result
      , p_check_format               =>   l_check_format
      , p_check_smtp                 =>   l_check_smtp
      , p_treat_252_as_ok            =>   l_treat_252_as_ok
      , p_secure_conn_before_smtp    =>   l_secure_conn_before_smtp
    );

    if (l_result is not null) then
        l_return := to_number(substr(l_result, 1, C_RESULT_OFFSET)) + l_shift_result;
    else
        l_return := -1 + l_shift_result;
    end if;

    return l_return;

exception when others then
    l_return := -1 + l_shift_result;
    return l_return;
    raise;
end;
/

--------------------------------------------------------------------------------
-- Test Call to IS_VALID_EMAIL_ADDRESS_CODE
select "IS_VALID_EMAIL_ADDRESS_CODE"('s.obermeyer@t-online.de') as is_valid_email_address
from dual; -- "0" is true in this model

select "IS_VALID_EMAIL_ADDRESS_CODE"( 's.obermeyer@t-online.de'
                                     , p_treat_252_as_ok => 'TRUE'
                                     , p_shift_result  => 1) as is_valid_email_address
from dual; -- "1"

select "IS_VALID_EMAIL_ADDRESS_CODE"('s.obermeyer@t-online.de'
                                     , p_treat_252_as_ok => 'FALSE') as is_valid_email_address_code
from dual; -- "6"

select "IS_VALID_EMAIL_ADDRESS_CODE"('s.obermeyer@t-online.de'
                                     , p_treat_252_as_ok => 'FALSE'
                                     , p_shift_result  => 1) as is_valid_email_address_code
from dual; -- "7"

-- get the text for a status
select "IS_VALID_EMAIL_ADDRESS_CODE"('s.obermeyer@t-online.de'
                                     , p_treat_252_as_ok => 'TRUE') as is_valid_email_address_code,
       "GET_EMAIL_STATUS_TEXT"(is_valid_email_address_code('s.obermeyer@t-online.de'
                                  , p_treat_252_as_ok => 'TRUE')) as email_address_status
from dual; -- "0"	"OK"

select "IS_VALID_EMAIL_ADDRESS_CODE"('s.obermeyer@t-online.de'
                                     , p_treat_252_as_ok => 'FALSE') as is_valid_email_address_code,
       "GET_EMAIL_STATUS_TEXT"(is_valid_email_address_code('s.obermeyer@t-online.de'
                                  , p_treat_252_as_ok => 'FALSE')) as email_address_status
from dual; -- "6"	"Invalid Email Address Response"


--------------------------------------------------------------------------------
--
-- Send Mail
--
-- https://docs.oracle.com/cd/E14373_01/apirefs.32/e13369/apex_mail.htm#AEAPI342
-- This procedure sends an outbound email message from an application.
-- Although you can use this procedure to pass in either a
-- VARCHAR2 or a CLOB to p_body and  p_body_html, the data types must be the same.
-- In other words, you cannot pass a CLOB to P_BODY and a VARCHAR2 to p_body_html.
-- When using APEX_MAIL.SEND, remember the following:
-- No single line may exceed 1000 characters. The SMTP/MIME specification dictates
-- that no single line shall exceed 1000 characters.
-- To comply with this restriction, you must add a carriage return or
-- line feed characters to break up your p_body or p_body_html parameters into chunks
-- of 1000 characters or less. Failing to do so will result in erroneous email messages,
-- including partial messages or messages with extraneous exclamation points.
-- Plain text and HTML email content. Passing a value to p_body, but not p_body_html results
-- in a plain text message. Passing a value to p_body and  p_body_html yields a multi-part message
-- that includes both plain text and HTML content. The settings and capabilities of the recipient's
-- email client determine what displays.
-- Although most modern email clients can read an HTML formatted email,
-- remember that some users disable this functionality to address security issues.
-- Avoid images. When referencing images in p_body_html using the <img /> tag,
-- remember that the images must be accessible to the recipient's email client
-- in order for them to see the image.

-- For example, suppose you reference an image on your network called hello.gif as follows:
-- <img src="http://someserver.com/hello.gif" alt="Hello" />]
-- In this example, the image is not attached to the email, but is referenced by the email.
-- For the recipient to see it, they must be able to access the image using a Web browser.
-- If the image is inside a firewall and the recipient is outside of the firewall,
-- the image will not display. For this reason, avoid using images. If you must include images,
-- be sure to include the ALT attribute to provide a textual description
-- in the event the image is not accessible.
--
--------------------------------------------------------------------------------
create or replace procedure "SEND_MAIL" (
      p_mailto          in varchar2
    , p_result          in out pls_integer
    , p_from            in varchar2        := null
    , p_subject         in varchar2        := null
    , p_body            in clob            := null
    , p_body_html       in clob            := null
    , p_params          in varchar2        := null
    , p_values          in varchar2        := null
    , p_query           in varchar2        := null
    , p_topic           in varchar2        := null
    , p_app_id          in pls_integer     := null
    , p_smtp_server     in varchar2        := null
    , p_check_address   in boolean         := null
    , p_check_smtp      in varchar2        := null
    , p_send_testmail   in boolean         := false
    , p_debug_only      in boolean         := false
    )
is

    l_mailto            varchar2(128);
    l_from              varchar2(128);
    l_subject           varchar2(128);
    l_topic             varchar2(128);
    l_body              clob;
    l_body_html         clob;
    l_params            clob;
    l_values            clob;
    l_query             clob;
    l_app_id            pls_integer;
    l_result            pls_integer;
    l_check_address     boolean;
    l_check_smtp        varchar2(6);
    l_smtp_server       varchar2(128);
    l_return_code       varchar2(10);
    l_return_text       varchar2(1000);
    l_send_testmail     boolean;
    l_debug_only        boolean;

    C_DEBUG_ONLY        constant boolean        := false; -- only dbms_output but dont send mail
    C_SEND_TESTMAIL     constant boolean        := true;  -- allow to send mail with Testmail Subject (see below)
    C_SMTP_SERVER       constant varchar2(128)  := 'localhost'; -- 'securesmtp.t-online.de requires a certificate and startssl';
    C_FROM              constant varchar2(128)  := 's.obermeyer@t-online.de';
    C_DOMAIN            constant varchar2(128)  := 'example.com';
    C_MAILTO            constant varchar2(128)  := 'user@'||C_DOMAIN;
    C_RESULT            constant pls_integer    := 0;
    C_CHECK_ADDRESS     constant boolean        := true;
    C_CHECK_SMTP        constant varchar2(6)    := 'FALSE';
    C_RESULT_OFFSET     constant pls_integer    := 10;
    C_TRUE_CHAR         constant varchar2(6)    := 'TRUE';
    C_T                 constant varchar2(6)    := C_TRUE_CHAR;
    -- Mail Topic Defaults
    LF                  constant varchar2(2)    := utl_tcp.crlf;
    QP                  constant varchar2(4)    := chr(38)||'c='; -- url query prefix for app alias urls &c=WORKSPACE_NAME
    C_APP_ID            constant pls_integer    := 100;
    C_MAIL_ID           constant pls_integer    := null;
    C_TOPIC             constant clob           := null;
    C_SUBJECT           constant clob           := null;
    C_BODY              constant clob           := null;
    C_BODY_HTML         constant clob           := null;
    C_PARAMS            constant clob           := null;
    C_VALUES            constant clob           := null;
    C_QUERY             constant clob           := null;

    EMAIL_SEND_ERROR    exception;

begin

    -- Init Vars
    l_mailto            := nvl(p_mailto,        C_MAILTO);
    l_from              := nvl(p_from,          C_FROM);
    l_topic             := nvl(p_topic,         C_TOPIC);
    l_subject           := nvl(p_subject,       C_SUBJECT);
    l_body              := nvl(p_body,          C_BODY);
    l_body_html         := nvl(p_body_html,     C_BODY_HTML);
    l_params            := nvl(p_params,        C_PARAMS);
    l_values            := nvl(p_values,        C_VALUES);
    l_result            := nvl(p_result,        C_RESULT);
    l_check_address     := nvl(p_check_address, C_CHECK_ADDRESS);
    l_check_smtp        := nvl(p_check_smtp,    C_CHECK_SMTP);
    l_smtp_server       := nvl(p_smtp_server,   C_SMTP_SERVER);
    l_send_testmail     := nvl(p_send_testmail, C_SEND_TESTMAIL);
    l_debug_only        := nvl(p_debug_only,    C_DEBUG_ONLY);
    l_app_id            := nvl(p_app_id,        nvl(p_app_id, nvl(v('APP_ID'), C_APP_ID)));
    -- url query parameter
    if (instr(p_query, QP) > 0
        or
        instr(p_query, '?') > 0) then
        -- we assume a valid query string
        l_query     :=        nvl(p_query     , C_QUERY);
    else
        l_query     :=  QP || nvl(p_query     , C_QUERY);
    end if;

    -- set Apex Environment
    for c1 in (
        select workspace_id
        from apex_applications
        where application_id = l_app_id ) loop
        apex_util.set_security_group_id(p_security_group_id => c1.workspace_id);
    end loop;

    -- check Email Address if specified to do so
    if (l_check_address) then
        l_result := "IS_VALID_EMAIL_ADDRESS_CODE"(l_mailto, p_check_smtp => l_check_smtp);
        if (l_result != 0) then
            l_return_code := l_result;
            l_return_text := "GET_EMAIL_STATUS_TEXT"(l_result);
            raise EMAIL_SEND_ERROR;
        end if;
    end if;

    -- use Email Topics to generate predefined Email Content (see SET_EMAIL_CONTENT for details)
    if (l_topic is not null) then
            "SET_EMAIL_CONTENT"(  p_topic     => l_topic
                                , p_mailto    => l_mailto
                                , p_subject   => l_subject
                                , p_body      => l_body
                                , p_body_html => l_body_html
                                , p_params    => l_params
                                , p_values    => l_values
                                , p_query     => l_query
                                , p_app_id    => l_app_id
                                , p_debug     => l_debug_only
                                );

        l_return_code := substr(l_subject, 1, 2);
        if (l_return_code = '-2') then
            l_return_code := l_result;
            l_return_text := 'Error in procedure SET_EMAIL_CONTENT: ' ||
                             "GET_EMAIL_STATUS_TEXT"(l_result);
            raise EMAIL_SEND_ERROR;
        end if;
    end if;

    if (    l_mailto    is not null
        and l_from      is not null
        and l_body      is not null
        and l_body_html is not null
        and l_subject   is not null
        or (l_send_testmail and instr(upper(l_subject), 'TESTMAIL') > 0)
        ) then

        if (l_debug_only) then
            dbms_output.put_line (
            '*** SEND EMAIL Debug:'            || chr(10) ||
            '  p_topic     => ' || l_topic     || chr(10) ||
            ', p_mailto    => ' || l_mailto    || chr(10) ||
            ', p_subject   => ' || l_subject   || chr(10) ||
            ', p_body      => ' || l_body      || chr(10) ||
            ', p_body_html => ' || l_body_html || chr(10) ||
            ', p_params    => ' || l_params    || chr(10) ||
            ', p_values    => ' || l_values    || chr(10) ||
            ', p_query     => ' || l_query     || chr(10) ||
            ', p_app_id    => ' || l_app_id    || chr(10)
            );

        else  -- send the mail
            apex_mail.send (
                p_to             => l_mailto,      -- change to your email address
                p_from           => l_from,        -- change to a real senders email address
                p_body           => l_body,
                p_body_html      => l_body_html,
                p_subj           => l_subject
            );

        end if;

        l_result := 0;

    else
        l_result := -3;
        l_return_code := l_result;
        l_return_text :=    "GET_EMAIL_STATUS_TEXT"(l_result)                  ||
                            case l_mailto    when null then ' Mail To '    end ||
                            case l_from      when null then ' From '       end ||
                            case l_subject   when null then ' Subject '    end ||
                            case l_body      when null then ' Body Text '  end ||
                            case l_body_html when null then ' Body HTML '  end ||
                            ' may not be null!';
        raise EMAIL_SEND_ERROR;
    end if;

    -- set the output variable
    p_result := l_result;

exception
    when EMAIL_SEND_ERROR then
        l_result      := 1;
        p_result      := l_result;
        l_return_text := SYSDATE||' *** SEND_EMAIL Runtime Exception: [' ||
                         l_return_code ||  ']: '  || l_return_text ;
        htp.p ('<p>'  || l_return_text || '</p>');
        dbms_output.put_line (l_return_text);
    when others then
        l_result := 1;
        p_result := l_result;
        l_return_text := SYSDATE||' *** SEND_MAIL SQL Exception: ' || SQLERRM;
        htp.p ('<p>' || l_return_text || '</p>');
        dbms_output.put_line (l_return_text);
    raise;
end "SEND_MAIL";
/


-----------------------------------------------------------------------------
-- Test Send Email
declare
l_result pls_integer;
begin
    send_mail(  p_mailto => 's.obermeyer@t-online.de'
              , p_result => l_result
              , p_topic  => 'REGISTER'
              , p_app_id => 110  -- needed for Topic to work :-)
              , p_debug_only => true);
    dbms_output.put_line('*** Send Mail returned: ' || l_result);
end;
/


create or replace procedure "APX_USER_REGISTRATION" (
     p_mailto                        varchar2
   , p_username                      varchar2        := null
   , p_first_name                    varchar2        := null
   , p_last_name                     varchar2        := null
   , p_params                        clob            := null
   , p_values                        clob            := null
   , p_topic                         varchar2        := null
   , p_userid                        pls_integer     := null
   , p_domain_id                     pls_integer     := null
   , p_token                         varchar2        := null
   , p_from                          varchar2        := null
   , p_app_id                        pls_integer     := v('APP_ID')
   , p_result                        pls_integer     := null
   , p_debug                         boolean         := null
   , p_send_mail                     boolean         := null

)
is
    -- Local Variables
    l_mailto                        varchar2(64);
    l_username                      varchar2(64);
    l_first_name                    varchar2(64);
    l_last_name                     varchar2(64);
    l_params                        varchar2(4000);
    l_values                        varchar2(4000);
    l_topic                         varchar2(64);
    l_userid                        pls_integer;
    l_domain_id                     pls_integer;
    l_token                         varchar2(4000);
    l_from                          varchar2(64);
    l_app_id                        pls_integer;
    l_result                        pls_integer;
    l_debug                         boolean;
    l_send_mail                     boolean;

    -- Constants
    C_TOPIC                         constant          varchar2(1000)  := 'REGISTER';
    C_FROM                          constant          varchar2(1000)  := 's.obermeyer@t-online.de';
    C_APP_ID                        constant          pls_integer     := 100;
    C_RESULT                        constant          pls_integer     := 0;
    C_DEBUG                         constant          boolean         := false;
    C_SEND_MAIL                     constant          boolean         := true;

begin

   -- Setting Locals Defaults
    l_mailto                        := p_mailto;
    l_username                      := nvl(p_username, l_mailto);
    l_first_name                    := p_first_name;
    l_last_name                     := p_last_name;
    l_params                        := p_params;
    l_values                        := p_values;
    l_topic                         := nvl(p_topic    , C_TOPIC);
    l_userid                        := p_userid;
    l_domain_id                     := p_domain_id;
    l_token                         := p_token;
    l_from                          := nvl(p_from     , C_FROM);
    l_app_id                        := nvl(p_app_id   , C_APP_ID);
    l_result                        := nvl(p_result   , C_RESULT);
    l_debug                         := nvl(p_debug    , C_DEBUG);
    l_send_mail                     := nvl(p_send_mail, C_SEND_MAIL);

    if (l_topic = 'REGISTER') then
        insert into "APEX_USER_REGISTRATION" (
                                                apx_username
                                            ,   apx_user_email
                                            ,   apx_user_first_name
                                            ,   apx_user_last_name
                                            )
                                    values (
                                                l_username
                                            ,   l_mailto
                                            ,   l_first_name
                                            ,   l_last_name
                                            )
        returning apx_user_id, apx_username, apx_user_token
        into l_userid, l_username, l_token;
    elsif (l_topic = 'REREGISTER') then
        update "APEX_USER_REGISTRATION"
            set apx_user_token = apx_get_token(upper(l_username)),
                apx_user_token_created = sysdate
            where upper(trim(apx_user_email)) = upper(trim(l_mailto))
        returning apx_user_id, apx_username, apx_user_token
        into l_userid, l_username, l_token;
    end if;


    -- send confirmation mail if specified
    if l_send_mail then

        "SEND_MAIL" (
            p_result      =>  l_result
          , p_mailto      =>  l_mailto
          , p_username    =>  l_username
          , p_topic       =>  l_topic
          , p_params      =>  l_params
          , p_values      =>  nvl(l_values, l_username||','||l_token)
          , p_app_id      =>  l_app_id
          , p_debug_only  =>  l_debug
        );

    end if;


    if (l_result = 0) then
        -- set status to registered
        update "APEX_USER_REGISTRATION"
        set apx_user_status_id = (select apex_status_id
                                    from apex_status
                                   where app_id is null
                                     and apex_status_context = 'USER'
                                     and apex_status = 'REGISTERED')
        where apx_user_id = l_userid;

    end if;

    commit;

exception when dup_val_on_index then
rollback;
when others then
rollback;
raise;
end;
/


---------------------------------------------------------------------------
-- User Reset Password Request
create or replace procedure "APX_USER_RESETP_REQUEST" (
     p_mailto                        varchar2
   , p_username                      varchar2        := null
   , p_first_name                    varchar2        := null
   , p_last_name                     varchar2        := null
   , p_params                        clob            := null
   , p_values                        clob            := null
   , p_topic                         varchar2        := null
   , p_userid                        pls_integer     := null
   , p_domain_id                     pls_integer     := null
   , p_token                         varchar2        := null
   , p_from                          varchar2        := null
   , p_app_id                        pls_integer     := v('APP_ID')
   , p_for_app_id                    pls_integer     := null
   , p_result                        pls_integer     := null
   , p_debug                         boolean         := null
   , p_send_mail                     boolean         := null

)
is
    -- Local Variables
    l_mailto                        varchar2(64);
    l_username                      varchar2(64);
    l_first_name                    varchar2(64);
    l_last_name                     varchar2(64);
    l_params                        varchar2(4000);
    l_values                        varchar2(4000);
    l_topic                         varchar2(64);
    l_userid                        pls_integer;
    l_domain_id                     pls_integer;
    l_token                         varchar2(4000);
    l_from                          varchar2(64);
    l_app_id                        pls_integer;
    l_for_app_id                    pls_integer;
    l_result                        pls_integer;
    l_debug                         boolean;
    l_send_mail                     boolean;

    -- Constants
    C_TOPIC                         constant          varchar2(1000)  := 'RESET_PW';
    C_FROM                          constant          varchar2(1000)  := 's.obermeyer@t-online.de';
    C_APP_ID                        constant          pls_integer     := 100;
    C_FOR_APP_ID                    constant          pls_integer     := 110;
    C_RESULT                        constant          pls_integer     := 0;
    C_DEBUG                         constant          boolean         := false;
    C_SEND_MAIL                     constant          boolean         := true;

begin

   -- Setting Locals Defaults
    l_mailto                        := p_mailto;
    l_username                      := nvl(p_username       , l_mailto);
    l_first_name                    := p_first_name;
    l_last_name                     := p_last_name;
    l_params                        := p_params;
    l_values                        := p_values;
    l_topic                         := nvl(p_topic          , C_TOPIC);
    l_userid                        := p_userid;
    l_domain_id                     := p_domain_id;
    l_token                         := p_token;
    l_from                          := nvl(p_from           , C_FROM);
    l_app_id                        := nvl(p_app_id         , C_APP_ID);
    l_for_app_id                    := nvl(p_for_app_id     , C_FOR_APP_ID);
    l_result                        := nvl(p_result         , C_RESULT);
    l_debug                         := nvl(p_debug          , C_DEBUG);
    l_send_mail                     := nvl(p_send_mail      , C_SEND_MAIL);

    update "APEX_USER"
    set apx_user_token = apx_get_token(upper(l_username)),
                apx_user_token_created = sysdate,
                apx_user_token_valid_until = sysdate + 1
    where upper(trim(apx_user_email)) = upper(trim(l_mailto))
    returning apx_user_id, apx_username, apx_user_token
    into l_userid, l_username, l_token;


    -- send confirmation mail if specified
    if l_send_mail then

        "SEND_MAIL" (
            p_result      =>  l_result
          , p_mailto      =>  l_mailto
          , p_username    =>  l_username
          , p_topic       =>  l_topic
          , p_params      =>  l_params
          , p_values      =>  nvl(l_values, l_username||','||l_token)
          , p_app_id      =>  l_app_id
          , p_debug_only  =>  l_debug
        );

    end if;

    commit;

exception when dup_val_on_index then
rollback;
when others then
rollback;
raise;
end;
/



------------------------------------------------------------------------------------------
-- Is a Token valid in either table?
create or replace function "IS_VALID_TOKEN" (
    p_token       in    varchar2
  , p_table       in    varchar2 := null
  , p_col         in    varchar2 := null
  , p_sql         in    clob     := null
)  return boolean
is
l_table      varchar2(200)  := null;
l_col        varchar2(100)  := null;
l_token      varchar2(4000) := null;
l_sql        varchar2(4000) := 'select count(1) from ##TABLE## where ##COL## = ##TOKEN##';
l_result     pls_integer    := 0;
l_return     boolean        := false;
begin

    l_table      := upper(trim(p_table));
    l_col        := upper(trim(p_col));
    l_token      := p_token;
    l_sql        := p_sql;

    l_sql := replace(l_sql, '##TABLE##' , l_table);
    l_sql := replace(l_sql, '##COL##'   , l_col);
    l_sql := replace(l_sql, '##TOKEN##' , l_token);

    execute immediate l_sql into l_result;

    if (l_result = 0) then
        l_return := false;
    else
        l_return := true;
    end if;

    return l_return;

exception when others then
raise;
end;
/

-- Exists a Token in APEX_USER_REGISTRATION table?
create or replace function "IS_VALID_REG_TOKEN" (
    p_token       in    varchar2
)  return boolean
is
l_table      varchar2(200)  := 'APEX_USER_REGISTRATION';
l_col        varchar2(100)  := 'APX_USER_TOKEN';
l_token      varchar2(4000) := null;
l_return     boolean        := false;
begin
    l_token  := p_token;
    l_return := "IS_VALID_TOKEN"(l_token, l_table, l_col, null);
    return l_return;
exception when others then
return false;
end;
/


-- Exists a Token in APEX_USER table?
create or replace function "IS_VALID_APEX_USER_TOKEN" (
    p_token       in    varchar2
)  return boolean
is
l_table      varchar2(200)  := 'APEX_USER';
l_col        varchar2(100)  := 'APX_USER_TOKEN';
l_token      varchar2(4000) := null;
l_return     boolean        := false;
begin
    l_token  := p_token;
    l_return := "IS_VALID_TOKEN"(l_token, l_table, l_col, null);
    return l_return;
exception when others then
return false;
end;
/


-- Is Token for User still valid in APEX_USER_REGISTRATION table?
create or replace function "IS_VALID_USER_TOKEN" (
     p_username    in    varchar2
   , p_token       in    varchar2
)  return boolean
is
l_username   varchar2(200)  := null;
l_token      varchar2(4000) := null;
l_return     boolean        := false;
begin
    l_username   := upper(trim(p_username));
    l_token      := p_token;
    for c1 in (select count(1) as token_valid
               from "APEX_USER_REGISTRATION"
               where upper(trim(apx_username)) = l_username
                 and apx_user_token = l_token
                 and apx_user_token_valid_until <= sysdate) loop
        l_return := case c1.token_valid when 1 then true end;
    end loop;
    return l_return;
exception when others then
raise;
end;
/


-- Create Apex User in Application Table and Apex Workspace if specified
create procedure "APX_CREATE_USER" (
      p_username                    in       varchar2
    , p_result                      in out   pls_integer
    , p_email_address               in       varchar2        := null
    , p_first_name                  in       varchar2        := null
    , p_last_name                   in       varchar2        := null
    , p_params                      in       clob            := null
    , p_values                      in       clob            := null
    , p_topic                       in       varchar2        := null
    , p_userid                      in       pls_integer     := null
    , p_domain_id                   in       pls_integer     := null
    , p_token                       in       varchar2        := null
    , p_description                 in       varchar2        := null
    , p_web_password                in       varchar2        := null
    , p_web_password_format         in       varchar2        := null
    , p_change_password_on_first_use in      varchar2        := null
    , p_group_ids                   in       varchar2        := null
    , p_developer_privs             in       varchar2        := null
    , p_default_schema              in       varchar2        := null
    , p_allow_access_to_schemas     in       varchar2        := null
    , p_account_expiry              in       date            := null
    , p_account_locked              in       varchar2        := null
    , p_attribute_01                in       varchar2        := null
    , p_attribute_02                in       varchar2        := null
    , p_attribute_03                in       varchar2        := null
    , p_attribute_04                in       varchar2        := null
    , p_attribute_05                in       varchar2        := null
    , p_app_id                      in       pls_integer     := v('APP_ID')
    , p_debug                       in       boolean         := null
    , p_send_mail                   in       boolean         := null
    , p_create_apex_user            in       boolean         := null
)
is
    -- Local Variables
    l_username                      varchar2(128);
    l_result                        pls_integer;
    l_result_code                   pls_integer;
    l_email_address                 varchar2(128);
    l_first_name                    varchar2(128);
    l_last_name                     varchar2(128);
    l_params                        clob;
    l_values                        clob;
    l_topic                         varchar2(64);
    l_userid                        pls_integer;
    l_domain_id                     pls_integer;
    l_token                         varchar2(4000);
    l_description                   varchar2(1000);
    l_web_password                  varchar2(1000);
    l_web_password_format           varchar2(1000);
    l_group_ids                     varchar2(1000);
    l_developer_privs               varchar2(1000);
    l_default_schema                varchar2(1000);
    l_allow_access_to_schemas       varchar2(1000);
    l_change_password_on_first_use  varchar2(10);
    l_account_expiry                date;
    l_account_locked                varchar2(1000);
    l_attribute_01                  varchar2(1000);
    l_attribute_02                  varchar2(1000);
    l_attribute_03                  varchar2(1000);
    l_attribute_04                  varchar2(1000);
    l_attribute_05                  varchar2(1000);
    l_app_id                        pls_integer;
    l_debug                         boolean;
    l_send_mail                     boolean;
    l_create_apex_user              boolean;

    CREATE_USER_ERROR               exception;

    -- Constants
    C_TOPIC                         constant          varchar2(1000)  := 'CREATE';
    C_PASSWORD_FORMAT               constant          varchar2(1000)  := 'CLEAR_TEXT';
    C_ACCOUNT_LOCKED                constant          varchar2(10)    := 'N';
    C_ACCOUNT_EXPIRED               constant          varchar2(10)    := TRUNC(SYSDATE);
    C_CHANGE_PASSWORD_ON_FIRST_USE  constant          varchar2(10)    := 'N';
    C_APP_ID                        constant          pls_integer     := 100;
    C_RESULT                        constant          pls_integer     := null;
    C_DEBUG                         constant          boolean         := false;
    C_SEND_MAIL                     constant          boolean         := false;
    C_CREATE_APEX_USER              constant          boolean         := true;
    C_DEVELOPER_PRIVS               constant          varchar2(1000)  := null;
    C_ALLOW_ACCESS_TO_SCHEMAS       constant          varchar2(1000)  := null;

begin

   -- Setting Locals Defaults
    l_email_address                 := p_email_address;
    l_username                      := p_username;
    l_first_name                    := p_first_name;
    l_last_name                     := p_last_name;
    l_params                        := p_params;
    l_values                        := p_values;
    l_topic                         := nvl(p_topic            , C_TOPIC);
    l_userid                        := p_userid;
    l_domain_id                     := p_domain_id;
    l_token                         := p_token;
    l_description                   := p_description;
    l_web_password                  := p_web_password;
    l_web_password_format           := p_web_password_format;
    l_group_ids                     := p_group_ids;
    l_developer_privs               := p_developer_privs;
    l_default_schema                := p_default_schema;
    l_allow_access_to_schemas       := p_allow_access_to_schemas;
    l_change_password_on_first_use  := nvl(p_change_password_on_first_use, C_CHANGE_PASSWORD_ON_FIRST_USE);
    l_account_expiry                := nvl(p_account_expiry   , C_ACCOUNT_EXPIRED);
    l_account_locked                := nvl(p_account_locked   , C_ACCOUNT_LOCKED);
    l_attribute_01                  := p_attribute_01;
    l_attribute_02                  := p_attribute_02;
    l_attribute_03                  := p_attribute_03;
    l_attribute_04                  := p_attribute_04;
    l_attribute_05                  := p_attribute_05;
    l_app_id                        := nvl(p_app_id           , C_APP_ID);
    l_result                        := nvl(p_result           , C_RESULT);
    l_result_code                   := 0;
    l_debug                         := nvl(p_debug            , C_DEBUG);
    l_send_mail                     := nvl(p_send_mail        , C_SEND_MAIL);
    l_create_apex_user              := nvl(p_create_apex_user , C_CREATE_APEX_USER);

    -- create local app user first

    if (l_token is not null) then
        if ("IS_VALID_USER_TOKEN"(l_username, l_token)) then
            begin
                insert into "APEX_USER" (
                    apx_username,
                    apx_user_email,
                    apx_user_default_role_id,
                    apx_user_code,
                    apx_user_first_name,
                    apx_user_last_name,
                    apx_user_ad_login,
                    apx_user_host_login,
                    apx_user_email2,
                    apx_user_email3,
                    apx_user_twitter,
                    apx_user_facebook,
                    apx_user_linkedin,
                    apx_user_xing,
                    apx_user_other_social_media,
                    apx_user_phone1,
                    apx_user_phone2,
                    apx_user_adress,
                    apx_user_description,
                    apx_app_user_id,
                    apex_user_id,
                    apx_user_last_login,
                    apx_user_token_created,
                    apx_user_token_valid_until,
                    apx_user_token_ts,
                    apx_user_token,
                    apx_user_domain_id,
                    apx_user_status_id,
                    apx_user_sec_level,
                    apx_user_context_id,
                    apx_user_parent_user_id,
                    app_id)
                (select
                    apx_username,
                    apx_user_email,
                    apx_user_default_role_id,
                    apx_user_code,
                    apx_user_first_name,
                    apx_user_last_name,
                    apx_user_ad_login,
                    apx_user_host_login,
                    apx_user_email2,
                    apx_user_email3,
                    apx_user_twitter,
                    apx_user_facebook,
                    apx_user_linkedin,
                    apx_user_xing,
                    apx_user_other_social_media,
                    apx_user_phone1,
                    apx_user_phone2,
                    apx_user_adress,
                    apx_user_description,
                    apx_app_user_id,
                    apex_user_id,
                    null,
                    apx_user_token_created,
                    apx_user_token_valid_until,
                    apx_user_token_ts,
                    apx_user_token,
                    apx_user_domain_id,
                    apx_user_status_id,
                    apx_user_sec_level,
                    apx_user_context_id,
                    apx_user_parent_user_id,
                    app_id
                FROM "APEX_USER_REGISTRATION"
                where apx_user_token = l_token);
            -- returning apx_user_id, apx_username, apx_user_email
            -- into l_userid, l_username, l_email_address;

            commit;
            l_result_code := 0;

            exception when no_data_found then
                l_result_code := 2;
                l_result      := 'No User Data for Token found.';
                raise create_user_error;
            end;
        else
           l_result_code := 1;
           l_result      := 'Invalid Token';
           raise create_user_error;
        end if;
    else
        insert into "APEX_USER" (
                                  apx_username
                                , apx_user_email
                                , apx_user_first_name
                                , apx_user_last_name
                                , apx_user_description
                                )
                            values (
                                  l_username
                                , l_email_address
                                , l_first_name
                                , l_last_name
                                , l_description
                                )
        returning apx_user_id, apx_username, apx_user_email
        into l_userid, l_username, l_email_address;

        commit;
        l_result_code := 0;

    end if;


    if l_create_apex_user then

        -- set Apex Environment
        for c1 in (
            select workspace_id
            from apex_applications
            where application_id = l_app_id ) loop
            apex_util.set_security_group_id(
                p_security_group_id => c1.workspace_id
                );
        end loop;

        apex_util.create_user (
              p_user_id                       => l_userid
            , p_user_name                     => l_username
            , p_first_name                    => l_first_name
            , p_last_name                     => l_last_name
            , p_description                   => l_description
            , p_email_address                 => l_email_address
            , p_web_password                  => l_web_password
            , p_developer_privs               => l_developer_privs
            , p_default_schema                => l_default_schema
            , p_allow_access_to_schemas       => l_allow_access_to_schemas
            , p_change_password_on_first_use  => l_change_password_on_first_use
            , p_account_expiry                => l_account_expiry
            , p_account_locked                => l_account_locked
            , p_attribute_01                  => l_attribute_01
            , p_attribute_02                  => l_attribute_02
            , p_attribute_03                  => l_attribute_03
            , p_attribute_04                  => l_attribute_04
            , p_attribute_05                  => l_attribute_05
        );

        commit;
        l_result_code := 0;

    end if;

    -- send confirmation mail if specified
    if l_send_mail then

        "SEND_MAIL" (
            p_result      =>  l_result
          , p_mailto      =>  l_email_address
          , p_username    =>  l_username
          , p_topic       =>  l_topic
          , p_params      =>  l_params
          , p_values      =>  l_values
          , p_app_id      =>  l_app_id
          , p_debug_only  =>  l_debug
        );

    end if;


    if (l_result_code = 0) then
        -- set status to registered
        update "APEX_USER_REGISTRATION"
        set apx_user_status_id = (select apex_status_id
                                    from "APEX_STATUS"
                                   where app_id is null
                                     and apex_status_context = 'USER'
                                     and apex_status = 'CREATED'),
            apx_app_user_id  = l_userid,
            apex_user_id     = l_userid
        where apx_user_token = l_token;

    end if;

    commit;

exception when create_user_error then
    l_result  := l_result_code ||' '||l_result;
    p_result  := l_result;
when dup_val_on_index then
    rollback;
    l_result  := -1 ||' ERROR: User exists!';
    p_result  := l_result;
when others then
rollback;
raise;
end;
/



-- Confirm Registration
create procedure "APX_USER_CONFIRMATION" (
     p_mailto                        varchar2
   , p_username                      varchar2        := null
   , p_first_name                    varchar2        := null
   , p_last_name                     varchar2        := null
   , p_params                        clob            := null
   , p_values                        clob            := null
   , p_topic                         varchar2        := null
   , p_userid                        pls_integer     := null
   , p_domain_id                     pls_integer     := null
   , p_token                         varchar2        := null
   , p_from                          varchar2        := null
   , p_app_id                        pls_integer     := v('APP_ID')
   , p_result                        pls_integer     := null
   , p_debug                         boolean         := null
   , p_send_mail                     boolean         := null
   , p_create_user                   boolean         := null
)
is
    -- Local Variables
    l_mailto                        varchar2(64);
    l_username                      varchar2(64);
    l_first_name                    varchar2(64);
    l_last_name                     varchar2(64);
    l_params                        varchar2(4000);
    l_values                        varchar2(4000);
    l_topic                         varchar2(64);
    l_userid                        pls_integer;
    l_domain_id                     pls_integer;
    l_token                         varchar2(4000);
    l_from                          varchar2(64);
    l_app_id                        pls_integer;
    l_result                        pls_integer;
    l_debug                         boolean;
    l_send_mail                     boolean;

    -- Constants
    C_TOPIC                         constant          varchar2(1000)  := 'REGISTER';
    C_FROM                          constant          varchar2(1000)  := 's.obermeyer@t-online.de';
    C_APP_ID                        constant          pls_integer     := 100;
    C_RESULT                        constant          pls_integer     := 0;
    C_DEBUG                         constant          boolean         := false;
    C_SEND_MAIL                     constant          boolean         := true;

begin

   -- Setting Locals Defaults
    l_mailto                        := p_mailto;
    l_username                      := p_username;
    l_first_name                    := p_first_name;
    l_last_name                     := p_last_name;
    l_params                        := p_params;
    l_values                        := p_values;
    l_topic                         := nvl(p_topic    , C_TOPIC);
    l_userid                        := p_userid;
    l_domain_id                     := p_domain_id;
    l_token                         := p_token;
    l_from                          := nvl(p_from     , C_FROM);
    l_app_id                        := nvl(p_app_id   , C_APP_ID);
    l_result                        := nvl(p_result   , C_RESULT);
    l_debug                         := nvl(p_debug    , C_DEBUG);
    l_send_mail                     := nvl(p_send_mail, C_SEND_MAIL);

    insert into "APEX_USER_REGISTRATION" (
                                          apx_username
                                        , apx_user_email
                                        , apx_user_first_name
                                        , apx_user_last_name
                                        )
                                 values (
                                          l_username
                                        , l_mailto
                                        , l_first_name
                                        , l_last_name
                                        )
    returning apx_user_id, apx_username, apx_user_token
    into l_userid, l_username, l_token;

    -- send confirmation mail if specified
    if l_send_mail then

        "SEND_MAIL" (
            p_result      =>  l_result
          , p_mailto      =>  l_mailto
          , p_username    =>  l_username
          , p_topic       =>  l_topic
          , p_params      =>  l_params
          , p_values      =>  l_values
          , p_app_id      =>  l_app_id
          , p_debug_only  =>  l_debug
        );

    end if;


    if (l_result = 0) then
        -- set status to registered
        update "APEX_USER_REGISTRATION"
        set apx_user_status_id = (select apex_status_id
                                    from apex_status
                                   where app_id is null
                                     and apex_status_context = 'USER'
                                     and apex_status = 'REGISTERED')
        where apx_user_id = l_userid;

    end if;

    commit;

exception when dup_val_on_index then
rollback;
when others then
rollback;
raise;
end;
/


create procedure "APX_USER_CONFIRMATION" (
     p_mailto                        varchar2
   , p_username                      varchar2        := null
   , p_first_name                    varchar2        := null
   , p_last_name                     varchar2        := null
   , p_params                        clob            := null
   , p_values                        clob            := null
   , p_topic                         varchar2        := null
   , p_userid                        pls_integer     := null
   , p_domain_id                     pls_integer     := null
   , p_token                         varchar2        := null
   , p_from                          varchar2        := null
   , p_app_id                        pls_integer     := v('APP_ID')
   , p_result                        pls_integer     := null
   , p_debug                         boolean         := null
   , p_send_mail                     boolean         := null
   , p_create_user                   boolean         := null
)
is
    -- Local Variables
    l_mailto                        varchar2(64);
    l_username                      varchar2(64);
    l_first_name                    varchar2(64);
    l_last_name                     varchar2(64);
    l_params                        varchar2(4000);
    l_values                        varchar2(4000);
    l_topic                         varchar2(64);
    l_userid                        pls_integer;
    l_domain_id                     pls_integer;
    l_token                         varchar2(4000);
    l_from                          varchar2(64);
    l_app_id                        pls_integer;
    l_result                        pls_integer;
    l_debug                         boolean;
    l_send_mail                     boolean;

    -- Constants
    C_TOPIC                         constant          varchar2(1000)  := 'REGISTER';
    C_FROM                          constant          varchar2(1000)  := 's.obermeyer@t-online.de';
    C_APP_ID                        constant          pls_integer     := 100;
    C_RESULT                        constant          pls_integer     := 0;
    C_DEBUG                         constant          boolean         := false;
    C_SEND_MAIL                     constant          boolean         := true;

begin

   -- Setting Locals Defaults
    l_mailto                        := p_mailto;
    l_username                      := p_username;
    l_first_name                    := p_first_name;
    l_last_name                     := p_last_name;
    l_params                        := p_params;
    l_values                        := p_values;
    l_topic                         := nvl(p_topic    , C_TOPIC);
    l_userid                        := p_userid;
    l_domain_id                     := p_domain_id;
    l_token                         := p_token;
    l_from                          := nvl(p_from     , C_FROM);
    l_app_id                        := nvl(p_app_id   , C_APP_ID);
    l_result                        := nvl(p_result   , C_RESULT);
    l_debug                         := nvl(p_debug    , C_DEBUG);
    l_send_mail                     := nvl(p_send_mail, C_SEND_MAIL);

    insert into "APEX_USER_REGISTRATION" (
                                          apx_username
                                        , apx_user_email
                                        , apx_user_first_name
                                        , apx_user_last_name
                                        )
                                 values (
                                          l_username
                                        , l_mailto
                                        , l_first_name
                                        , l_last_name
                                        )
    returning apx_user_id, apx_username, apx_user_token
    into l_userid, l_username, l_token;

    -- send confirmation mail if specified
    if l_send_mail then

        "SEND_MAIL" (
            p_result      =>  l_result
          , p_mailto      =>  l_mailto
          , p_username    =>  l_username
          , p_topic       =>  l_topic
          , p_params      =>  l_params
          , p_values      =>  l_values
          , p_app_id      =>  l_app_id
          , p_debug_only  =>  l_debug
        );

    end if;


    if (l_result = 0) then
        -- set status to registered
        update "APEX_USER_REGISTRATION"
        set apx_user_status_id = (select apex_status_id
                                    from apex_status
                                   where app_id is null
                                     and apex_status_context = 'USER'
                                     and apex_status = 'REGISTERED')
        where apx_user_id = l_userid;

    end if;

    commit;

exception when dup_val_on_index then
rollback;
when others then
rollback;
raise;
end;
/

/*
l_username   varchar2(200)  := null;
l_token      varchar2(4000) := null;
l_return     boolean        := false;
begin
    l_token      := p_token;
    l_username   := upper(trim(p_username));
    for c1 in (select count(1) as token_valid
               from "APEX_USER_REGISTRATION"
               where upper(trim(apx_username)) = l_username
                 and apx_user_token = l_token
                 and apx_user_token_valid_until >= sysdate) loop
        l_return := case c1.token_valid when 1 then true end;
    end loop;
    return l_return;
exception when others then
raise;
end;
/

*/








create or replace procedure "APX_USER_NAV" (
    p_usr           in  clob  -- :USR
  , p_token         in  clob  -- :TKN
  , p_request       in  clob    :=  null
  , p_errormsg      in  clob    :=  null
  , p_successmsg    in  clob    :=  null
)
is
l_usr               clob;
l_token             clob;
l_url               clob;
l_msg               clob;
l_params            clob;
l_values            clob;
l_register_url      clob;
l_support_url       clob;
l_result            varchar2(20);
l_session           varchar2(100);
l_request           varchar2(1000);
l_page_alias        varchar2(1000);
begin
    l_usr           := p_usr;
    l_token         := p_token;
    l_request       := p_request;
    l_session       := '0';
    l_url           := 'f?p=&APP_ID.';
    l_page_alias    := 'DESKTOP_LOGIN';
    l_register_url  := l_url || ':USRREG:'||l_session||':REGISTER::::#';
    l_support_url   := l_url || ':SUPPORT:'||l_session||':'||l_request||'::::#';

if (l_request = 'REGISTER') then
    if (is_valid_user_token(l_usr, l_token)) then
        l_result     := '0';
        l_page_alias := 'USRREG_CONFIRM';
        l_params     := 'NEWUSER,TOKEN';
        l_values     := l_usr||','||l_token;
    else
        l_result     := '-2';
        l_request    := 'TOKEN_INVALID';
        l_msg        := '<strong><h4>Error for User: '||l_usr||
        'Your Registration is invalid. </h4></strong>' ||chr(10)||
        '<h5 class="t-error">'||l_request||'</h5>' ||chr(10)||
        'Please try to <a href="'||l_register_url||'">register again</a> later' ||chr(10)||
        'and if You are still having trouble to register' ||chr(10)||
        'contact our <a href="'||l_support_url||'">Support</a> for help.'||chr(10)||chr(10)||
        'Thank You...';
    end if;
else
    l_result     := '-1';
    l_request    := 'UNKNOWN_REQUEST';
end if;

    if (l_result != '0') then
        l_page_alias := 'ERRPAGE';
        l_params     := 'ERR_USR';
        l_values     := l_usr;
        apex_util.set_session_state('ERRORMSG', l_msg);
    end if;

    l_url := l_url ||':'|| l_page_alias ||':'||l_session||':'||l_request||':::'||l_params||':'||l_values||'#';
    --    raise_application_error(-20001, 'In Proc: '||l_url);
    redirect(l_url);

end;


------------------------------------------------------------------
-- Funtion to Set and Get Values from / to APX Tables and Collections

-- drop procedure "APX_SET";
-- drop function "APX_GET_VALUE";

--
-- 2018/01/14 SO: created
--
-- @requires: APX Model
--
------------------------------------------------------------------

-- Set Value/s to a specific Table, View or Collection

------------------------------------------------------------------------------------------------------
-- APX Set Value/s
-- Get a Value from a specific Table, View or Collection
create or replace function  "APX_GET_VALUE" (
      p_what       in   varchar2
    , p_id         in   varchar2
    , p_tab        in   varchar2     := null
    , p_col        in   varchar2     := null
    , p_id_col     in   varchar2     := null
    , p_param      in   varchar2     := null
    , p_value      in   varchar2     := null
    , p_query      in   varchar2     := null
    , p_where      in   varchar2     := null
    , p_debug      in   pls_integer  := 0
) return varchar2
is
l_id      varchar2(100) ; -- id or value to lookup
l_tab     varchar2(1000); -- name of the value column
l_col     varchar2(1000); -- name of the value column
l_id_col  varchar2(1000); -- name of the value column
l_what    varchar2(1000); -- string to specify what to get (f.e. STATUS, CONTEXT,...)
l_param   varchar2(4000); -- sub items like configuration parameter
l_value   varchar2(4000); -- sub items like query values
l_query   varchar2(4000); -- sql query string
l_sql     clob   := null; -- dynamic sql query string
l_where   clob   := null; -- dynamic sql where clause to be appended to query string
l_return  varchar2(4000); -- return string
l_debug   boolean;
begin

    -- Setting Inputs and Defaults
    l_debug  := case when nvl(p_debug, 0) = 0 then true else false end;

    l_id     := p_id;
    l_what   := nvl(nullif(upper(trim(p_what)), ''), 'EMPTY');
    l_sql    := 'select ##COL## from ##TAB## where ##ID_COL## = :i ';
    l_where  := nvl(l_where, p_where);

    if (l_what = 'EMPTY')  then
        l_query  := null;
        l_sql    := null;
    elsif (l_what = 'QUERY' and p_query is not null) then
        l_query  := p_query;
        l_tab    := p_tab;
        l_col    := p_col;
        l_id_col := p_id_col;
        if (p_param is not null) then
            l_param := p_param;
            l_query := replace(l_query, '##PARAM##', l_param);
        end if;
        if (p_value is not null) then
            l_value := p_value;
            l_query := replace(l_query, '##VALUE##', l_value);
        end if;
        l_sql    := l_query;
        l_sql    := replace(l_sql, '##TAB##'    , l_tab);
        l_sql    := replace(l_sql, '##COL##'    , l_col);
        l_sql    := replace(l_sql, '##ID_COL##' , l_id_col);
    elsif (l_what = 'OBJECT')       then
        l_sql   := replace(l_sql, '##COL##'     , 'APX_OBJECT');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_ID');
    elsif (l_what = 'STATUS')       then
        l_sql   := replace(l_sql, '##COL##'     , 'APX_STATUS');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$STATUS');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_STATUS_ID');
    elsif (l_what = 'CONTEXT')      then
        l_sql   := replace(l_sql, '##COL##'     , 'APX_CONTEXT');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$CTX');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_CONTEXT_ID');
    elsif (l_what = 'OPTION')       then
        l_sql   := replace(l_sql, '##COL##'     , 'APX_OPTION');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$OPT');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_OPTION_ID');
    elsif (l_what = 'OPTION_VALUE') then
        l_sql   := replace(l_sql, '##COL##'     , 'nvl(APX_OPTION_VALUE, APX_DEFAULT_VALUE)');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$OPT');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_OPTION');
        l_sql   := replace(l_sql, ':i'          , 'upper(trim(to_char(:i)))');
    elsif (l_what = 'PROCESS')      then
        l_sql   := replace(l_sql, '##COL##'     , 'APX_PROCESS');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$PRC');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_ROCESS_ID');
    elsif (l_what = 'PRIVILEGE')    then
        l_sql   := replace(l_sql, '##COL##'     , 'APX_PRIVILEGE');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$PRIVILGE');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_PRIV_ID');
    elsif (l_what = 'CONFIG')       then
        l_sql   := replace(l_sql, '##COL##'     , 'APX_CONFIG_NAME');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$CFG');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_CONFIG_ID');
    elsif (l_what = 'CONFIG_VALUE') then
        l_sql   := replace(l_sql, '##COL##'     , 'nvl(APX_CONFIG_VALUE, APX_CONFIG_DEF_VALUE)');
        l_sql   := replace(l_sql, '##TAB##'     , 'APX$CFG');
        l_sql   := replace(l_sql, '##ID_COL##'  , 'APX_CONFIG_NAME');
        l_sql   := replace(l_sql, ':i'          , 'upper(trim(to_char(:i)))');
    else
        l_sql    := l_what || ' parameter not found!';
        l_return := null;
    end if;

    -- prepare where clause
    if (l_sql is not null and instr(lower(l_sql)  , 'where ') > 0 ) then
        if (l_where is not null and instr(lower(l_where), 'where ') > 0) then
            l_where := replace(lower(l_where), 'where ', 'and ');
        end if;
    end if;

    -- append where clause
    l_sql    := l_sql || l_where;

    -- determine sql query end execute
    if (l_sql is not null and substr(l_sql, 1, 7) = 'select ') then
        if (l_id is not null) then
            if (regexp_like(l_id, '^[[:digit:]]+$')) then
                begin
                    execute immediate l_sql into l_return using to_number(l_id);
                exception when no_data_found then
                    l_return := null;
                when others then
                raise;
                end;
            else
                begin
                    execute immediate l_sql into l_return using upper(trim(l_id));
                exception when no_data_found then
                    l_return := null;
                when others then
                raise;
                end;
            end if;
        end if;
    else
        l_return  := 'Error: '|| nvl(l_sql, '(null)');
    end if;

    -- Return Output String
    return l_return;

exception
    when no_data_found then
        l_return := null;
    when others then
    raise;
END "APX_GET_VALUE";
/


--------------------------------------------------------------------------------
-- Sample Queries on APX_GET_VALUE
select apx_get_value('Status', 1)
from dual; -- UP
select apx_get_value('conFIG', 1)
from dual; -- HOST
select apx_get_value('CONFIG_value', 'host')
from dual; -- ol7
select apx_get_value('config_value', 24)
from dual; -- (null)  /* number item doesnt exist */
select apx_get_value('context', 12)
from dual; -- REGION
select apx_get_value('option_value', '13')
from dual; -- (null) /* is handled as number by function - value does not exist */
select apx_get_value('option_value', 5)
from dual; -- (null) /* is handled as number by function - value does not exist */
select apx_get_value('optio_value', 'Option')
from dual; -- Error: OPTIO_VALUE parameter not found! /* not a valid dimension */




------------------------------------------------------------------
-- Funtion to return User Information for Apex Workspace
-- and APX Users


 drop function "APX_IS_APEX_USR";
 drop function "APX_IS_APEX_USR_LOCKED";
 drop function "APX_IS_APEX_USR_EXPIRED";

--
-- 2018/01/14 SO: created
--
-- @requires: WWV_FLOW_USERS, APEX_UTIL
--
------------------------------------------------------------------

-- Get User Infos



-- Is User Token valid?
create or replace function "IS_VALID_USER_TOKEN" (
     p_username    in    varchar2
   , p_token       in    varchar2
)  return boolean
is
l_username   varchar2(200)  := null;
l_token      varchar2(4000) := null;
l_return     boolean        := false;
begin
    l_username   := upper(trim(p_username));
    l_token      := p_token;
    for c1 in (select count(1) as token_valid
               from "APEX_USER_REGISTRATION"
               where upper(trim(apx_username)) = l_username
                 and apx_user_token = l_token
                 and apx_user_token_valid_until >= sysdate) loop
        l_return := case c1.token_valid when 1 then true end;
    end loop;
    return l_return;
exception when others then
raise;
end;
/


-- Number of Days before Apex User Account expires
create or replace  function "APX_GET_APEX_USR_DAYS_LEFT" (
    p_username    in    varchar2
)  return pls_integer
is
l_username   varchar2(200);
l_days_left  pls_integer;
l_return     pls_integer;
begin
    l_username   := upper(trim(p_username));
    for c1 in (select user_name
               from "WWV_FLOW_USERS"
               where upper(trim(user_name))
                   = l_username) loop
        l_days_left  := "APEX_UTIL"."END_USER_ACCOUNT_DAYS_LEFT" (
                        p_user_name => c1.user_name);
    end loop;
    return l_days_left;
exception when others then
raise;
end;
/

-- select "APX_GET_APEX_USR_DAYS_LEFT"('admin') as days_left from dual;

-- Is User an Apex User Account?
create or replace function "APX_IS_APEX_USR" (
    p_username     in    varchar2
)  return boolean
is
l_username   varchar2(200) := null;
l_return     boolean       := false;
begin
    l_username   := upper(trim(p_username));
    for c1 in (select count(1) as user_exists
               from "WWV_FLOW_USERS"
               where upper(trim(user_name))
                   = l_username) loop
        l_return := case c1.user_exists when 1 then true end;
    end loop;
    return l_return;
exception when others then
raise;
end;
/


-- Is Apex User Account Locked?
create or replace function "APX_IS_APEX_USR_LOCKED" (
    p_username    in    varchar2
)  return boolean
is
l_username   varchar2(200) := null;
l_return       boolean;
begin
    l_username   := upper(trim(p_username));
    for c1 in (select user_name
               from "WWV_FLOW_USERS"
               where upper(trim(user_name))
                     = l_username) loop
            l_return    := "APEX_UTIL"."GET_ACCOUNT_LOCKED_STATUS" (
                           p_user_name => c1.user_name);
    end loop;
    return l_return;
exception when others then
return null;
end;
/

-- Is Apex User Account expired?
create or replace  function "APX_IS_APEX_USR_EXPIRED" (
    p_username    in    varchar2
)  return boolean
is
l_username   varchar2(200);
l_days_left   pls_integer := 0;
l_return     boolean        := false;
begin
    l_username   := upper(trim(p_username));
    if (apx_is_apex_usr(l_username)) then
        l_days_left  := "APX_GET_APEX_USR_DAYS_LEFT"(l_username);
        if (l_days_left > 0) then
            l_return := false;
         else
            l_return := true;
        end if;
    else
        l_return := false;
    end if;
    return l_return;
exception when others then
return null;
end;
/

---------------------------------------------------
-- Is User an Apex User Account? return INTEGER
create or replace function "APX_IS_APEX_USR_INT" (
    p_username     in    varchar2
)  return pls_integer
is
l_username   varchar2(200);
l_return     pls_integer;
begin
    l_username   := upper(trim(p_username));
    if ("APX_IS_APEX_USR"(l_username)) then
        l_return := 1;
    else
        l_return := 0;
    end if;
    return nvl(l_return, 0);
exception when others then
raise;
end;
/

--select decode(apx_is_apex_usr_int('admin'), 1, 'Yes', 'No')  as is_apex_user from dual;


-- Is Apex User Account Locked?
create function "APX_IS_APEX_USR_LOCKED_INT" (
    p_username     in    varchar2
)  return pls_integer
is
l_username   varchar2(200);
l_return     pls_integer;
begin
    l_username   := upper(trim(p_username));
    if ("APX_IS_APEX_USR_LOCKED"(l_username)) then
        l_return := 1;
    else
        l_return := 0;
    end if;
    return nvl(l_return, 0);
exception when others then
raise;
end;
/

--select decode(apx_is_apex_usr_locked_int('admin'), 1, 'Yes', 'No') as apex_user_is_locked from dual;


-- Is Apex User Account expired?
create function "APX_IS_APEX_USR_EXPIRED_INT" (
    p_username     in    varchar2
)  return pls_integer
is
l_username   varchar2(200);
l_return     pls_integer;
begin
    l_username   := upper(trim(p_username));
    if ("APX_IS_APEX_USR_EXPIRED"(l_username)) then
        l_return := 1;
    else
        l_return := 0;
    end if;
    return nvl(l_return, 0);
exception when others then
raise;
end;
/

select decode(apx_is_apex_usr_expired_int('admin') , 1, 'Yes', 'No') as is_apex_user from dual;

---------------------------------------------------
-- Is User an Apex User Account (Text)?
create or replace function "APX_IS_APEX_USR_TXT" (
    p_username     in    varchar2
  , p_debug        in    pls_integer := 0
)  return varchar
is
l_debug        pls_integer;
l_debug_string varchar2(1000);
l_username     varchar2(200);
l_return       varchar2(10);
begin
    l_debug := nvl(p_debug, 0);
    l_username   := upper(trim(p_username));
    if ("APX_IS_APEX_USR"(l_username)) then
        l_return := 'Y';
    else
        l_return := 'N';
    end if;
    if (l_debug = 1) then
        dbms_output.put_line('User Account: '                 ||
                              initcap(l_username)             ||
                              case when nvl(l_return, 'N') = 'N'
                                   then ' does not exist '
                                   else ' exists '
                                   end                        ||
                             'in current Apex Workspace.');
    end if;
    return nvl(l_return, 'N');
exception when others then
raise;
end;
/

--select apx_is_apex_usr_txt('admin', 1) as is_apex_user from dual;


-- Is Apex User Account Locked?
create or replace function "APX_IS_APEX_USR_LOCKED_TXT" (
    p_username    in    varchar2
  , p_debug       in    pls_integer := 0
)  return varchar2
is
l_debug        pls_integer;
l_debug_string varchar2(1000);
l_username     varchar2(200);
l_return       varchar2(10);
begin
    l_debug      := nvl(p_debug, 0);
    l_username   := upper(trim(p_username));
    if ("APX_IS_APEX_USR_LOCKED"(l_username)) then
        l_return := 'Y';
        l_debug_string  := 'locked';
    else
        l_return := 'N';
        l_debug_string  := 'not locked';
    end if;
    if (l_debug != 0) then
        dbms_output.put_line('User Account: '||initcap(l_username)||
                             ' is ' || l_debug_string ||'.');
    end if;
    return nvl(l_return, 'N');
exception when others then
raise;
end;
/

--select apx_is_apex_usr_locked_txt('admin', 1) as is_apex_user from dual;

-- Is Apex User Account expired?
create function "APX_IS_APEX_USR_EXPIRED_TXT" (
    p_username    in    varchar2
  , p_debug       in    pls_integer := 0
)  return varchar2
is
l_debug        pls_integer;
l_debug_string varchar2(1000);
l_username     varchar2(200);
l_return       varchar2(10);
begin
    l_debug := nvl(p_debug, 0);
    l_username   := upper(trim(p_username));
    if ("APX_IS_APEX_USR_EXPIRED"(l_username)) then
        l_return := 'Y';
        l_debug_string := ' is expired.';
    else
        l_return := 'N';
        l_debug_string := ' is not expired.';
    end if;
    if (l_debug != 0) then
        dbms_output.put_line('End User Account: '||initcap(l_username)|| l_debug_string);
    end if;
    return nvl(l_return, 'N');
exception when others then
raise;
end;
/

select apx_is_apex_usr_expired_txt('admin', 1) as is_apex_user from dual;










