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



-- Is Token for User still valid in APEX_USER table?
create or replace function "IS_VALID_RESET_TOKEN" (
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
               from "APEX_USER"
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


/*
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
*/


-- Edit Apex User in Application Table and Apex Workspace if specified
create or replace procedure "APX_EDIT_USER" (
      p_username                    in       varchar2
    , p_result                      in out   pls_integer
    , p_email_address               in       varchar2        := null
    , p_first_name                  in       varchar2        := null
    , p_last_name                   in       varchar2        := null
    , p_params                      in       clob            := null
    , p_values                      in       clob            := null
    , p_topic                       in       varchar2        := null
    , p_userid                      in       number          := null
    , p_domain_id                   in       pls_integer     := null
    , p_token                       in       varchar2        := null
    , p_description                 in       varchar2        := null
    , p_new_password                in       varchar2        := null
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
    , p_expire_apex_user            in       boolean         := null
    , p_workspace                   in       varchar2        := null
    , p_start_date                  in       date            := null
    , p_end_date                    in       date            := null
    , p_employee_id                 in       number          := null
    , p_person_type                 in       varchar2        := null
    , p_developer_roles             in       varchar2        := null
    , p_failed_access_attempts      in       number          := null
    , p_first_password_use_occurred in       varchar2        := null
)
is
    -- Local Variables
    l_username                      varchar2(128);
    l_result_text                   varchar2(4000);
    l_result_code                   pls_integer;
    l_email_address                 varchar2(128);
    l_first_name                    varchar2(128);
    l_last_name                     varchar2(128);
    l_params                        clob;
    l_values                        clob;
    l_topic                         varchar2(64);
    l_userid                        number;
    l_domain_id                     pls_integer;
    l_token                         varchar2(4000);
    l_description                   varchar2(1000);
    l_web_password                  varchar2(1000);
    l_web_password_format           varchar2(1000);
    l_groups                        varchar2(1000);
    l_group_ids                     varchar2(1000);
    l_developer_privs               varchar2(1000);
    l_developer_role                varchar2(1000);
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
    l_expire_apex_user              boolean;
    l_workspace                     varchar2(255);
    l_start_date                    date;
    l_end_date                      date;
    l_employee_id                   number(15,0);
    l_person_type                   varchar2(1);
    l_developer_roles               varchar2(60);
    l_failed_access_attempts        number;
    l_first_password_use_occurred   varchar2(1);
    l_new_password                  varchar2(255);

    EDIT_USER_ERROR                 exception;

    -- Constants
    C_TOPIC                         constant          varchar2(1000)  := 'EDIT';
    C_PASSWORD_FORMAT               constant          varchar2(1000)  := 'CLEAR_TEXT';
    C_ACCOUNT_LOCKED                constant          varchar2(10)    := 'N';
    C_ACCOUNT_EXPIRED               constant          date            := TRUNC(SYSDATE);
    C_CHANGE_PASSWORD_ON_FIRST_USE  constant          varchar2(10)    := 'N';
    C_APP_ID                        constant          pls_integer     := 100;
    C_RESULT_CODE                   constant          pls_integer     := null;
    C_DEBUG                         constant          boolean         := false;
    C_SEND_MAIL                     constant          boolean         := false;
    C_CREATE_APEX_USER              constant          boolean         := true;
    C_DEVELOPER_PRIVS               constant          varchar2(1000)  := null;
    C_DEVELOPER_ROLES               constant          varchar2(1000)  := 'CREATE:EDIT:HELP';
    C_EXPIRE_APEX_USER              constant          boolean         := false;
    C_ALLOW_ACCESS_TO_SCHEMAS       constant          varchar2(1000)  := null;

begin

   -- Setting Locals Defaults
    l_email_address                 := p_email_address;
    l_username                      := upper(trim(nvl(p_username, p_email_address)));
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
    l_new_password                  := p_new_password;
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
    l_result_code                   := C_RESULT_CODE;
    l_debug                         := nvl(p_debug            , C_DEBUG);
    l_send_mail                     := nvl(p_send_mail        , C_SEND_MAIL);
    l_expire_apex_user              := nvl(p_expire_apex_user , C_EXPIRE_APEX_USER);
    l_developer_roles               := nvl(p_developer_roles  , C_DEVELOPER_ROLES);

    -- create local app user first

    if (l_token is not null) then
        if ("IS_VALID_RESET_TOKEN"(l_username, l_token)) then
            begin
                -- set Apex Environment
                for c1 in (
                    select workspace_id
                    from apex_applications
                    where application_id = l_app_id ) loop
                    apex_util.set_security_group_id(
                        p_security_group_id => c1.workspace_id
                        );
                end loop;

                --raise_application_error(-20001, 'User: "'||l_username||'"');
                l_userid := apex_util.get_user_id (l_username);

                apex_util.fetch_user (
                    p_user_id                       => l_userid,
                    p_workspace                     => l_workspace,
                    p_user_name                     => l_username,
                    p_first_name                    => l_first_name,
                    p_last_name                     => l_last_name,
                    p_web_password                  => l_web_password,
                    p_email_address                 => l_email_address,
                    p_start_date                    => l_start_date,
                    p_end_date                      => l_end_date,
                    p_employee_id                   => l_employee_id,
                    p_allow_access_to_schemas       => l_allow_access_to_schemas,
                    p_person_type                   => l_person_type,
                    p_default_schema                => l_default_schema,
                    p_groups                        => l_groups,
                    p_developer_role                => l_developer_role,
                    p_description                   => l_description,
                    p_account_expiry                => l_account_expiry,
                    p_account_locked                => l_account_locked,
                    p_failed_access_attempts        => l_failed_access_attempts,
                    p_change_password_on_first_use  => l_change_password_on_first_use,
                    p_first_password_use_occurred   => l_first_password_use_occurred
                    );

                apex_util.edit_user (
                    p_user_id                       => l_userid,
                    p_user_name                     => l_username,
                    p_first_name                    => l_first_name,
                    p_last_name                     => l_last_name,
                    p_web_password                  => l_new_password,
                    p_new_password                  => l_new_password,
                    p_email_address                 => l_email_address,
                    p_start_date                    => l_start_date,
                    p_end_date                      => l_end_date,
                    p_employee_id                   => l_employee_id,
                    p_allow_access_to_schemas       => l_allow_access_to_schemas,
                    p_person_type                   => l_person_type,
                    p_default_schema                => l_default_schema,
                    p_group_ids                     => l_groups,
                    p_developer_roles               => l_developer_roles,
                    p_description                   => l_description,
                    p_account_expiry                => l_account_expiry,
                    p_account_locked                => l_account_locked,
                    p_failed_access_attempts        => l_failed_access_attempts,
                    p_change_password_on_first_use  => l_change_password_on_first_use,
                    p_first_password_use_occurred   => l_first_password_use_occurred
                    );

                commit;
                l_result_code := 0;
                p_result  := l_result_code;

            exception when others then
                l_result_code := sqlcode;
                l_result_text := sqlerrm;
                p_result := l_result_code;
                raise;
            end;
        else
            l_result_code := 2;
            l_result_text := 'No User Data for Token found.';
            raise edit_user_error;
        end if;
    else
        l_result_code := 1;
        l_result_text := 'Invalid Token';
        raise edit_user_error;
    end if;

exception when edit_user_error then
    p_result  := l_result_code;
   raise_application_error (-20001, 'User Edit Error ' || l_result_code || ' ' ||l_result_text);
when others then
  l_result_code := sqlcode;
  l_result_text := sqlerrm;
   raise_application_error (-20002, 'User Edit Error ' || l_result_code || ' ' ||l_result_text);
end;
/
-------------------------------------------------------------------------------------
-- Reset Password Request for Apex User in Application Table and Apex Workspace
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
						   
						   			   
with pks
as (
select  c2.owner, c2.table_name, c2.constraint_name, c2.constraint_type as  constraint_type, c2.delete_rule, c2.status
from dba_constraints c2 
where c2.owner in ('RAS', 'RAS_INTERN') 
and c2.CONSTRAINT_TYPE = 'P'
),
cons
as (
select  c2.owner, c2.table_name, c2.constraint_name, c2.constraint_type as  constraint_type,
            c.owner as ref_owner, c.table_name as ref_table, c.constraint_name as ref_constraint, 
            c.constraint_type as ref_constraint_type, c.delete_rule as ref_delete_rule,
            c.status as ref_status,  c2.table_name as primary_table
from dba_constraints c2 
left outer join
(select c.owner, c.table_name, c.constraint_name, 
            c.r_constraint_name,  
            c.constraint_type,  
            c.delete_rule, c.status
 from dba_constraints c 
 where c.constraint_type = 'R')  c
on (c2.constraint_name = c.r_constraint_name)
where c2.owner in ('RAS', 'RAS_INTERN') 
and c2.CONSTRAINT_TYPE = 'P'
and C.TABLE_NAME is not null
)
select 1 as cnt, p.owner, p.table_name, p.constraint_name, null as ref_table, p.constraint_type as constraint_type,  'n.a.' as delete_rule, p.status
from pks p
union
select 2 as cnt, c.ref_owner, c.table_name, c.ref_constraint, c.ref_table, c.ref_constraint_type as constraint_type,  c.ref_delete_rule, c.ref_status
from cons c
where exists (select 1 from pks p1 where p1.constraint_name = c.constraint_name)
order by  2, 3, 1 asc;						   
						   
select * 
from DBA_IND_EXPRESSIONS 
where TABLE_OWNER in ('SYS', 'SYSTEM');


create table IND_EXP (
index_owner varchar2(100), 
table_name  varchar2(100), 
index_name varchar2(100), 
column_expression varchar2(4000), 
column_position number
);

declare
l_long long;
l_vchr varchar2(4000);
begin
    for i in (select index_owner, table_name, index_name, column_expression, column_position 
                 from DBA_IND_EXPRESSIONS 
                 where index_OWNER in ('SYS', 'SYSTEM')) loop
        l_long := i.column_expression;
        l_vchr := substr(l_long, 1, 4000);
        insert into IND_EXP
        values (i.index_owner, i.table_name, i.index_name, l_vchr, i.column_position);
    end loop;
    commit;
end;
/


select * from IND_EXP;


with unq
as (
select owner, table_name, index_name 
from dba_indexes
where uniqueness = 'UNIQUE'
and owner in ('SYSTEM', 'SYS')
),
ind_exp
as
(select index_owner, table_name, index_name, column_expression, column_position 
 from IND_EXP 
 where index_OWNER in ('SYS', 'SYSTEM')
)
select distinct  u.owner, u.table_name, ic.index_name,  IC.COLUMN_NAME, ie.column_expression, IC.COLUMN_POSITION
from unq u right outer join dba_ind_columns ic
on (U.OWNER = IC.INDEX_OWNER
     and U.TABLE_NAME = IC.TABLE_NAME
     and U.INDEX_NAME = IC.INDEX_NAME)
left outer join ind_exp ie
on (IC.INDEX_OWNER = ie.INDEX_OWNER
     and IC.INDEX_NAME = IE.INDEX_NAME
     and ic.COLUMN_POSITION = ie.column_position)
where ic.index_owner in ('SYSTEM', 'SYS')
and not exists (select 1 from dba_constraints c where c.constraint_name = u.index_name and c.constraint_type in ('P', 'R'))
and u.owner is not null
and u.table_name is not null
order by 1, 2, 3, 6;
						   
