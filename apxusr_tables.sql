--- APEX User Management ---



-----------------------------------------------------------------------------------------------------
--
-- Stefan Obermeyer 12.2016
--
-- 12.12.2016 SOB created
-- 19.12.2016 SOB modified INSERT/UPDATE Trigger to get UserID for DB and APEX Users
-- 08.01.2017 SOB added Trigger for User INSERTs and Default Role changes.
-- 02.06.2017 SOB added BUILTINs
-- 06.11.2017 SOB added Scopes, Domains, Groups and Privileges
--
-----------------------------------------------------------------------------------------------------

-- requires APX$ model (Status, Context, ...)

--------------------------------------------------------------------------------------
-- Application Domains
create table "APX$APP_DOMAIN" (
app_domain_id number not null,
app_domain varchar2(64) not null, -- fully qualified domain name (f.e.: mydomain.net)
app_domain_name varchar2(64) not null, -- conceptual name like MyDomain
app_domain_code varchar2(8) null,
app_domain_description varchar2(128),
app_id number,
app_parent_domain_id number,
app_domain_status_id number,
app_domain_sec_level number default 0,
app_domain_ctx_id number default 0,
app_domain_homepage varchar2(1000),
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX$APPDOMAIN_DOMAIN_ID" primary key (app_domain_id),
constraint "APX$APPDOMAIN_CTX_FK" foreign key (app_domain_ctx_id) references "APX$APP_CTX"(app_ctx_id) on delete set null,
constraint "APX$APPDOMAIN_STATUS_FK" foreign key (app_domain_status_id) references "APX$STATUS"(app_status_id) on delete set null,
constraint "APX$APPDOMAIN_PARENT_FK" foreign key (app_parent_domain_id) references "APX$APP_DOMAIN"(app_domain_id) on delete set null
);

create unique index "APX$APP_DOMAIN_UNQ1" on "APX$APP_DOMAIN"(APP_DOMAIN_ID, APP_ID);
create unique index "APX$APP_DOMAIN_UNQ2" on "APX$APP_DOMAIN"(upper(app_domain_name), app_id);
create unique index "APX$APP_DOMAIN_UNQ3" on "APX$APP_DOMAIN"(upper(app_domain), app_id);
create unique index "APX$APP_DOMAIN_UNQ4" on "APX$APP_DOMAIN"(upper(app_domain_name), upper(app_domain), app_id);
create index "APX$APP_DOMAIN_STATUS_FK_IDX" on "APX$APP_DOMAIN"(app_domain_status_id);
create index "APX$APP_DOMAIN_PARENT_FK_IDX" on "APX$APP_DOMAIN"(app_parent_domain_id);
create index "APX$APP_DOMAIN_SECLEV" on "APX$APP_DOMAIN"(app_domain_sec_level);
create index "APX$APP_DOMAIN_APP_ID" on "APX$APP_DOMAIN"(app_id);

create sequence "APX$APP_DOMAIN_ID_SEQ" start with 10 increment by 1 nocache;

create or replace trigger "APX$APP_DOMAIN_BIU_TRG"
before insert or update on "APX$APP_DOMAIN"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.app_domain_id is null) then
        select "APX$APP_DOMAIN_ID_SEQ".NEXTVAL
        into :new.app_domain_id
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
-- Application Privileges
create table "APX$APP_PRIVILEGE" (
app_priv_id number not null,
app_privilege varchar2(64) not null,
app_priv_code varchar2(12) null,
app_priv_description varchar2(128),
app_priv_status_id number,
app_priv_ctx_id number,
app_id number,
app_parent_priv_id number,
app_priv_sec_level number default 0,
app_priv_domain_id number default 0,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX$APPPRIV_PRIV_ID" primary key (app_priv_id),
constraint "APX$APPPRIV_CTX_FK" foreign key (app_priv_ctx_id) references "APX$APP_CTX"(app_ctx_id) on delete set null,
constraint "APX$APPPRIV_STATUS_FK" foreign key (app_priv_status_id) references "APX$STATUS"(app_status_id) on delete set null,
constraint "APX$APPPRIV_PARENT_FK" foreign key (app_parent_priv_id) references "APX$APP_PRIVILEGE"(app_priv_id) on delete set null
);

create unique index "APX$APP_PRIV_UNQ1" on "APX$APP_PRIVILEGE"(APP_PRIV_ID, APP_ID);
create unique index "APX$APP_PRIV_UNQ2" on "APX$APP_PRIVILEGE"(upper(app_privilege), app_priv_ctx_id, app_id);
create index "APX$APP_PRIV_STATUS_FK_IDX" on "APX$APP_PRIVILEGE"(app_priv_status_id);
create index "APX$APP_PRIV_PARENT_FK_IDX" on "APX$APP_PRIVILEGE"(app_parent_priv_id);
create index "APX$APP_PRIV_SECLEV" on "APX$APP_PRIVILEGE"(app_priv_sec_level);
create index "APX$APP_PRIV_APP_ID" on "APX$APP_PRIVILEGE"(app_id);

create sequence "APX$APP_PRIV_ID_SEQ" start with 10 increment by 1 nocache;

create or replace trigger "APX$APP_PRIV_BIU_TRG"
before insert or update on "APX$APP_PRIVILEGE"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.app_priv_id is null) then
        select "APX$APP_PRIV_ID_SEQ".NEXTVAL
        into :new.app_priv_id
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
-- Application Groups
create table "APX$APP_GROUP" (
app_group_id number not null,
app_group_name varchar2(64) not null,
app_group_code varchar2(8) null,
app_group_description varchar2(128),
app_group_domain_id number default 0,
app_group_status_id number,
app_group_ctx_id number,
app_id number,
app_parent_group_id number,
app_group_sec_level number default 0,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX$APPGROUP_GROUP_ID" primary key (app_group_id),
constraint "APX$APPGROUP_CTX_FK" foreign key (app_group_ctx_id) references "APX$APP_CTX"(app_ctx_id) on delete set null,
constraint "APX$APPGROUP_STATUS_FK" foreign key (app_group_status_id) references "APX$STATUS"(app_status_id) on delete set null,
constraint "APX$APPGROUP_DOMAIN_FK" foreign key (app_group_domain_id) references "APX$APP_DOMAIN"(app_domain_id) on delete set null,
constraint "APX$APPGROUP_PARENT_FK" foreign key (app_parent_group_id) references "APX$APP_GROUP"(app_group_id) on delete set null
);

create unique index "APX$APP_GROUP_UNQ1" on "APX$APP_GROUP"(APP_GROUP_ID, APP_ID);
create unique index "APX$APP_GROUP_UNQ2" on "APX$APP_GROUP"(upper(app_group_name), app_group_ctx_id, app_id);
create index "APX$APP_GROUP_STATUS_FK_IDX" on "APX$APP_GROUP"(app_group_status_id);
create index "APX$APP_GROUP_PARENT_FK_IDX" on "APX$APP_GROUP"(app_parent_group_id);
create index "APX$APP_GROUP_APP_ID" on "APX$APP_GROUP"(app_id);
create index "APX$APP_GROUP_SECLEV" on "APX$APP_GROUP"(app_group_sec_level);

create sequence "APX$APP_GROUP_ID_SEQ" start with 10 increment by 1 nocache;

create or replace trigger "APX$APP_GROUP_BIU_TRG"
before insert or update on "APX$APP_GROUP"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.app_group_id is null) then
        select "APX$APP_GROUP_ID_SEQ".NEXTVAL
        into :new.app_group_id
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
create table "APX$APP_ROLE" (
APP_ROLE_ID number not null,
app_role_name varchar2(64) not null,
app_role_code varchar2(8) null,
app_role_description varchar2(128),
app_role_sec_level number default 0,
app_role_domain_id number default 0,
app_role_status_id number,
app_role_ctx_id number,
app_id number,
app_parent_role_id number,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX$APPROLE_ROLE_ID" primary key (app_role_id),
constraint "APX$APPROLE_CTX_FK" foreign key (app_role_ctx_id) references "APX$APP_CTX"(app_ctx_id) on delete set null,
constraint "APX$APPROLE_STATUS_FK" foreign key (app_role_status_id) references "APX$STATUS"(app_status_id) on delete set null,
constraint "APX$APPROLE_DOMAIN_FK" foreign key (app_role_domain_id) references "APX$APP_DOMAIN"(app_domain_id) on delete set null,
constraint "APX$APPROLE_PARENT_FK" foreign key (app_parent_role_id) references "APX$APP_ROLE"(app_role_id) on delete set null
);

create unique index "APX$APP_ROLE_UNQ1" on "APX$APP_ROLE"(app_role_id, app_id);
create unique index "APX$APP_ROLE_UNQ2" on "APX$APP_ROLE"(upper(app_role_name), app_role_ctx_id, app_id);

create index "APX$APP_ROLE_DOMAIN_FK_IDX" on "APX$APP_ROLE"(app_role_domain_id);
create index "APX$APP_ROLE_CTX_FK_IDX" on "APX$APP_ROLE"(app_role_ctx_id);
create index "APX$APP_ROLE_STATUS_FK_IDX" on "APX$APP_ROLE"(app_role_status_id);
create index "APX$APP_ROLE_PARENT_FK_IDX" on "APX$APP_ROLE"(APP_PARENT_ROLE_ID);
create index "APX$APP_ROLE_SECLEV" on "APX$APP_ROLE"(app_role_sec_level);
create index "APX$APP_ROLE_APP_ID" on "APX$APP_ROLE"(app_id);

create sequence "APX$APP_ROLE_ID_SEQ" start with 10 increment by 1 nocache;

create or replace trigger "APX$APP_ROLE_BIU_TRG"
before insert or update on "APX$APP_ROLE"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.app_role_id is null) then
        select "APX$APP_ROLE_ID_SEQ".NEXTVAL
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
create table "APX$APP_USER" (
app_user_id number not null,
app_username varchar2(64) default 'AppUser' not null,
app_user_email varchar2(64) not null,
app_user_default_role_id number default 1 not null, -- 0 PUBLIC, 1 USER
app_user_code varchar2(8),
app_user_first_name varchar2(32),
app_user_last_name varchar2(32),
app_user_ad_login varchar2(64),
app_user_host_login varchar2(64),
app_user_email2 varchar2(64),
app_user_email3 varchar2(64),
app_user_twitter varchar2(64),
app_user_facebook varchar2(64),
app_user_linkedin varchar2(64),
app_user_xing varchar2(64),
app_user_other_social_media varchar2(64),
app_user_phone1 varchar2(64),
app_user_phone2 varchar2(64),
app_user_adress varchar2(128),
app_user_description varchar2(128),
app_user_domain_id number default 0,
app_user_status_id number default 1,
app_user_sec_level number default 0,
app_user_ctx_id number,
app_user_parent_user_id number,
app_id number,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX$APP_USER_ID" primary key(app_user_id),
constraint "APX$APP_USER_CTX_FK" foreign key (app_user_ctx_id) references "APX$APP_CTX"(app_ctx_id) on delete set null,
constraint "APX$APP_USER_STATUS_FK" foreign key (app_user_status_id) references "APX$STATUS"(app_status_id) on delete set null,
constraint "APX$APP_USER_DEFROLE_FK" foreign key (app_user_default_role_id) references "APX$APP_ROLE"(app_role_id) on delete set null,
constraint "APX$APP_USER_DOMAIN_FK" foreign key (app_user_domain_id) references "APX$APP_DOMAIN"(app_domain_id) on delete set null,
constraint "APX$APP_USER_PARENT_FK" foreign key (app_user_parent_user_id) references "APX$APP_USER"(app_user_id) on delete set null
);

create unique index "APX$APP_USER_UNQ1" on "APX$APP_USER"(app_user_id, app_id);
create unique index "APX$APP_USER_UNQ2" on "APX$APP_USER"(upper(app_user_email), app_id);
--create unique index "APX$APP_USER_UNQ3" on "APX$APP_USER"(upper(app_username), app_id);

create index "APX$APP_USER_APP_ID" on "APX$APP_USER"(app_id);
create index "APX$APP_USER_DOMAIN_FK_IDX" on "APX$APP_USER"(app_user_domain_id);
create index "APX$APP_USER_CTX_FK_IDX" on "APX$APP_USER"(app_user_ctx_id);
create index "APX$APP_USER_STATUS_FK_IDX" on "APX$APP_USER"(app_user_status_id);
create index "APX$APP_USER_DEFROLE_FK_IDX" on "APX$APP_USER"(app_user_default_role_id);
create index "APX$APP_USER_PARENT_FK_IDX" on "APX$APP_USER"(app_user_parent_user_id);
create index "APX$APP_USER_SECLEV" on "APX$APP_USER"(app_user_sec_level);

create sequence "APX$APP_USER_ID_SEQ" start with 10 increment by 1 nocache;

create or replace trigger "APX$APP_USER_BIU_TRG"
before insert or update on "APX$APP_USER"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.app_user_id is null) then
        select "APX$APP_USER_ID_SEQ".NEXTVAL
        into :new.app_user_id
        from dual;
    end if;
    if (:new.APP_USER_CTX_ID is null) then
      begin
        select APP_CTX_ID
        into :new.APP_USER_CTX_ID
        from "APX$APP_CTX"
        where UPPER(APP_CTX) = 'USER';
        exception when no_data_found then
        select 0 into :new.APP_USER_CTX_ID from DUAL;
      end;
    end if;
    if (:new.APP_USERNAME is null) then
      begin
        select :new.app_user_first_name||' '||:new.app_user_last_name
        into :new.APP_USERNAME
        from dual;
        EXCEPTION when NO_DATA_FOUND then
        select 'AppUser '||nvl(:new.app_user_id, to_number(SYS_GUID(),'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'))
        into :new.APP_USERNAME from DUAL;
      end;
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
-- Application User Registration
create table "APX$APP_USER_REG" (
APP_USER_ID number not null,
app_username varchar2(64) default 'NewAppUser' not null,
app_user_email varchar2(64) not null,
app_user_default_role_id number default 1 not null, -- 0 PUBLIC, 1 USER
app_user_code varchar2(8),
app_user_first_name varchar2(32),
app_user_last_name varchar2(32),
app_user_ad_login varchar2(64),
app_user_host_login varchar2(64),
app_user_email2 varchar2(64),
app_user_email3 varchar2(64),
app_user_twitter varchar2(64),
app_user_facebook varchar2(64),
app_user_linkedin varchar2(64),
app_user_xing varchar2(64),
app_user_other_social_media varchar2(64),
app_user_phone1 varchar2(64),
app_user_phone2 varchar2(64),
app_user_adress varchar2(128),
app_user_description varchar2(128),
app_user_token_created date,
app_user_token_valid_until date,
app_user_token_ts timestamp(6) with time zone,
app_user_token varchar2(4000),
app_user_domain_id number default 0,
app_user_status_id number default 7, -- New User
app_user_sec_level number default 0,
app_user_ctx_id number,
app_user_parent_user_id number,
app_id number,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX$APP_USREG_ID" primary key(app_user_id),
constraint "APX$APP_USREG_CTX_FK" foreign key (app_user_ctx_id) references "APX$APP_CTX"(app_ctx_id) on delete set null,
constraint "APX$APP_USREG_STATUS_FK" foreign key (app_user_status_id) references "APX$STATUS"(app_status_id) on delete set null,
constraint "APX$APP_USREG_DOMAIN_FK" foreign key (app_user_domain_id) references "APX$APP_DOMAIN"(app_domain_id) on delete set null,
constraint "APX$APP_USREG_DEFROLE_FK" foreign key (app_user_default_role_id) references "APX$APP_ROLE"(app_role_id) on delete set null
);

create unique index "APX$APP_USREG_UNQ1" on "APX$APP_USER_REG"(APP_USER_ID, APP_ID);
create unique index "APX$APP_USREG_UNQ2" on "APX$APP_USER_REG"(APP_USER_TOKEN);
create unique index "APX$APP_USREG_UNQ3" on "APX$APP_USER_REG"(UPPER(APP_USER_EMAIL), APP_ID);
-- create unique index "APX$APP_USREG_UNQ4" on "APX$APP_USER_REG"(UPPER(APP_USERNAME), APP_ID); -- only needed when app_username_format = username

create index "APX$APP_USRREG_DOMAIN_FK_IDX" on "APX$APP_USER_REG"(app_user_domain_id);
create index "APX$APP_USRREG_CTX_FK_IDX" on "APX$APP_USER_REG"(app_user_ctx_id);

create sequence "APX$APP_USREG_ID_SEQ" start with 100 increment by 1 nocache;

create or replace trigger "APX$APP_USRREG_BIU_TRG"
before insert or update on "APX$APP_USER_REG"
referencing old as old new as new
for each row
declare
l_domain varchar2(100);
begin
  if inserting then
    if (:new.app_user_id is null) then
        select "APX$APP_USREG_ID_SEQ".NEXTVAL
        into :new.app_user_id
        from dual;
    end if;
    if (:new.app_user_id is null) then
        select "APX$APP_USREG_ID_SEQ".NEXTVAL
        into :new.app_user_id
        from dual;
    end if;
    if (:new.APP_USER_TOKEN is null) then
      begin
        select APP_DOMAIN_NAME
        into L_DOMAIN
        from "APX$APP_DOMAIN"
        where APP_DOMAIN_ID = :new.APP_USER_DOMAIN_ID;
      exception when no_data_found then
        l_domain := 'NewAppUserDomain.net';
      end;
      begin
        select sysdate, sysdate +24/24, systimestamp,
        replace(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(ABS(DBMS_RANDOM.random())||
                l_domain||ABS(DBMS_RANDOM.random())))),
                CHR(13)||CHR(10),'')
        into :new.APP_USER_TOKEN_CREATED, :new.APP_USER_TOKEN_VALID_UNTIL, :new.APP_USER_TOKEN_TS, :new.APP_USER_TOKEN
        from dual;
      exception when no_data_found then
        select 0 into :new.app_user_ctx_id from DUAL;
      end;
    end if;
    if (:new.APP_USER_CTX_ID is null) then
      begin
        select APP_CTX_ID
        into :new.APP_USER_CTX_ID
        from "APX$APP_CTX"
        where UPPER(APP_CTX) = 'USER';
        exception when no_data_found then
        select 0 into :new.app_user_ctx_id from DUAL;
      end;
    end if;
    if (:new.APP_USERNAME is null or :new.APP_USERNAME = 'NewAppUser') then
      begin
        select nvl(:new.app_user_first_name, 'New')||' '||nvl(:new.app_user_last_name, 'User')
        into :new.APP_USERNAME
        from dual;
        EXCEPTION when NO_DATA_FOUND then
        select 'AppUser '||nvl(to_char(:new.app_user_id), SYS_GUID())
        into :new.app_username from DUAL;
      end;
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
create table "APX$APP_USER_ROLE_MAP" (
app_user_role_map_id number not null,
app_user_id number not null,
app_role_id number not null,
app_user_role_status_id number default 1,
app_id number,
created date,
created_by varchar2(64),
modified date,
modified_by varchar2(64),
constraint "APX$APP_USERROLEMAP_ID" primary key (app_user_role_map_id),
constraint "APX$APP_USERROLE_STAT_FK" foreign key (app_user_role_status_id) references "APX$STATUS"(app_status_id) on delete set null,
constraint "APX$APP_USER_ID_FK" foreign key (app_user_id) references "APX$APP_USER"(app_user_id) on delete cascade,
constraint "APX$APP_ROLE_ID_FK" foreign key (app_role_id) references "APX$APP_ROLE"(app_role_id) on delete cascade
) organization index;

create index "APX$APP_USERROLMAP_STAT" on "APX$APP_USER_ROLE_MAP"(app_user_role_status_id);
create unique index "APX$APP_USERROLEMAP_UNQ" on  "APX$APP_USER_ROLE_MAP"(app_id, app_user_id, app_role_id);

create sequence "APX$APP_USERROLE_SEQ" minvalue 0 start with 0 increment by 1 nocache;

create or replace trigger "APX$APP_USRROL_BIU_TRG"
before insert or update on "APX$APP_USER_ROLE_MAP"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.app_user_role_map_id is null) then
        select APX$APP_userrole_seq.nextval
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
create or replace trigger "APX$APP_USRDEFROL_TRG"
after insert or update of "APP_USER_DEFAULT_ROLE_ID" on "APX$APP_USER"
referencing old as old new as new
for each row
declare
l_entries number;
begin
  if inserting then
      insert into "APX$APP_USER_ROLE_MAP" (app_id, app_user_id, app_role_id)
      values (:new.app_id, :new.app_user_id, :new.app_user_default_role_id);
  elsif updating then
        update "APX$APP_USER_ROLE_MAP"
        set  (app_role_id) = :new.app_user_default_role_id
        where app_user_id = :new.app_user_id
		  and app_id = :new.app_id
        and app_role_id = :old.app_user_default_role_id;
  end if;
end;
/

--------------------------------------------------------------------------------------
-- Application System Users, Roles,...
create table "APX$APP_BUILTIN" (
app_builtin_id number not null,
app_builtin_parent_id number,
app_builtin_status_id number,
app_builtin_ctx_id number,
app_id number,
app_user_id number,
app_role_id number,
is_admin number,
is_public number,
is_default number,
constraint "APX$SYSBUILTIN_IA_CHK" check (is_admin in(0, 1)),
constraint "APX$SYSBUILTIN_IP_CHK" check (is_public in(0, 1)),
constraint "APX$SYSBUILTIN_ID_CHK" check (is_default in(0, 1)),
constraint "APX$SYSBUILTIN_ID" primary key (app_builtin_id),
constraint "APX$APPUSR_ID_FK" foreign key (app_user_id) references "APX$APP_USER"(app_user_id) on delete cascade,
constraint "APX$APPROL_ID_FK" foreign key (app_role_id) references "APX$APP_ROLE"(app_role_id) on delete cascade,
constraint "APX$SYSBUILTIN_STATUS_FK" foreign key (app_builtin_status_id) references "APX$APP_STATUS"(app_status_id) on delete set null,
constraint "APX$SYSBUILTIN_CTX_FK" foreign key (app_builtin_ctx_id) references "APX$APP_CTX"(app_ctx_id) on delete set null,
constraint "APX$SYSBUILTINS_FK" foreign key (app_builtin_parent_id) references "APX$APP_BUILTIN"(app_builtin_id) on delete set null
) organization index;

create unique index "APX$APP_BUILTIN_UNQ" on  "APX$APP_BUILTIN"(app_id, app_user_id, app_role_id);
create index "APX$APP_BUILTIN_CTX_FK_IDX" on "APX$APP_BUILTIN"(app_builtin_ctx_id);
create index "APX$APP_BUILTIN_STAT_FK_IDX" on "APX$APP_BUILTIN"(app_builtin_status_id);


create table "APX$APP_USER_SESSION" (
  app_user_session_id number not null,
	app_username varchar2(64) not null,
	app_id number,
	app_ws_id number,
	app_user_token varchar2(4000),
  app_user_session_context number,
	app_last_page varchar2(32), -- using varchar2 for page alias
	app_user_cookie_name varchar2(64 byte),
	app_user_session_seconds number default 28800,
	app_user_session_idle_sec number default 900,
	app_user_last_login timestamp (6) with time zone default null,
	app_user_last_logout timestamp (6) with time zone default null,
constraint "APX$APPUSRSESSION_PK" primary key ("APP_USER_SESSION_ID"),
constraint "APX$APPUSRSESSION_CTX_FK" foreign key (app_user_session_context) references "APX$APP_CTX"(app_ctx_id) on delete set null
);

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Gather Stats for new/all Objects
--------------------------------------------------------------------------------------
begin
dbms_stats.gather_schema_stats(user);
end;
/

--------------------------------------------------------------------------------------
-- Synonyms
--------------------------------------------------------------------------------------

create synonym  "APEX_APP_USER_ROLE_MAP"    for "APX$APP_USER_ROLE_MAP";
create synonym  "APEX_USER_SESSION"         for "APX$APP_USER_SESSION";
create synonym  "APEX_APP_USER_REG"         for "APX$APP_USER_REG";
create synonym  "APEX_APP_USER"             for "APX$APP_USER";
create synonym  "APEX_APP_ROLE"             for "APX$APP_ROLE";
create synonym  "APEX_APP_GROUP"            for "APX$APP_GROUP";
create synonym  "APEX_APP_PRIVILEGE"        for "APX$APP_PRIVILEGE";
create synonym  "APEX_APP_DOMAIN"           for "APX$APP_DOMAIN";
create synonym  "APEX_APP_BUILTIN"          for "APX$APP_BUILTIN";


