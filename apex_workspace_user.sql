--- APEX User Management Apex Authentication Users ---


----------------------------------------------------------------------------------------------------
--
-- Stefan Obermeyer 02.2018
--
-- 18.02.2018 SOB created
--
----------------------------------------------------------------------------------------------------

-- @requires APX$ model (Status, Context, ...), Grants on APEX Dictionary Objects

----------------------------------------------------------------------------------------------------
-- APEX Authentication User's, Groups...
----------------------------------------------------------------------------------------------------

------ Grants on APEX Dictionary Objects -----------------------------------------------------------
------ To be executed as APEX Owner or SYS or similar Admin User. ----------------------------------
------ Apex Schema to be adjusted to your needs. ---------------------------------------------------

-- GRANT APEX_ADMINISTRATOR_ROLE                TO APXUSR;

-- GRANT MANAGE SCHEDULER                       TO APXUSR;
-- GRANT CREATE JOB                             TO APXUSR;

-- GRANT EXECUTE ON APEX_050100.WWV_FLOW_CRYPTO TO APXUSR;
-- GRANT EXECUTE ON APEX_050100.APEX_UTIL       TO APXUSR;

-- --GRANT INSERT, UPDATE, DELETE, SELECT, REFERENCES ON APEX_050100.WWV_FLOW_FND_USER TO APXUSR;
-- GRANT ALL ON APEX_050100.WWV_FLOW_FND_USER   TO    APXUSR;

-- CREATE SYNONYM APXUSR.APEX_WORKSPACE_USER    FOR   APEX_050100.WWV_FLOW_FND_USER;
-- CREATE SYNONYM APXUSR.APEX_CRYPTO            FOR   APEX_050100.WWV_FLOW_CRYPTO;

-- ALTER USER APXUSR DEFAULT ROLE ALL;

------ directly updating dictionary objects is usually not a good choice, --------------------------
------ but APEX_UTIL as Version 5.0 seems buggy and the recoomended workaround runs unstable -------

----------------------------------------------------------------------------------------------------
-- Modify APEX_WORKSPACE_USERs
create or replace procedure "APX_APEX_USER_EDIT" (
     p_result                       in out  number
   , p_user_name                            varchar2
   , p_user_id                              number      := null
   , p_edit_action                          varchar2    := null
   , p_security_group_id                    number      := null
   , p_first_name                           varchar2    := null
   , p_last_name                            varchar2    := null
   , p_creation_date                        date        := sysdate
   , p_created_by                           varchar2    := null
   , p_last_update_date                     date        := sysdate
   , p_last_updated_by                      varchar2    := null
   , p_start_date                           date        := null
   , p_end_date                             date        := null
   , p_person_type                          varchar2    := null
   , p_email_address                        varchar2    := null
   , p_web_password2                        raw         := null
   , p_web_password_version                 varchar2    := apex_crypto.get_current_password_version
   , p_last_login                           date        := null
   , p_builder_login_count                  number      := null
   , p_last_agent                           varchar2    := null
   , p_last_ip                              varchar2    := null
   , p_account_locked                       varchar2    := null
   , p_account_expiry                       date        := null
   , p_failed_access_attempts               number      := null
   , p_last_failed_login                    date        := null
   , p_first_password_use_occurred          varchar2    := null
   , p_change_password_on_first_use         varchar2    := null
   , p_allow_app_building_yn                varchar2    := null
   , p_allow_sql_workshop_yn                varchar2    := null
   , p_allow_websheet_dev_yn                varchar2    := null
   , p_allow_team_development_yn            varchar2    := null
   , p_default_schema                       varchar2    := null
   , p_allow_access_to_schemas              varchar2    := null
   , p_description                          varchar2    := null
   , p_web_password                         varchar2    := null
   , p_web_password_raw                     raw	        := null
   , p_password_date                        date        := null
   , p_password_accesses_left               number      := null
   , p_password_lifespan_accesses           number      := null
   , p_password_lifespan_days               number      := null
   , p_default_date_format                  varchar2    := null
   , p_known_as                             varchar2    := null
   , p_employee_id                          number      := null
   , p_person_id                            number      := null
   , p_profile_image                        blob        := null
   , p_profile_image_name                   varchar2    := null
   , p_profile_mimetype                     varchar2    := null
   , p_profile_filename                     varchar2    := null
   , p_profile_last_update                  date        := null
   , p_profile_charset                      varchar2    := null
   , p_attribute_01                         varchar2    := null
   , p_attribute_02                         varchar2    := null
   , p_attribute_03                         varchar2    := null
   , p_attribute_04                         varchar2    := null
   , p_attribute_05                         varchar2    := null
   , p_attribute_06                         varchar2    := null
   , p_attribute_07                         varchar2    := null
   , p_attribute_08                         varchar2    := null
   , p_attribute_09                         varchar2    := null
   , p_attribute_10                         varchar2    := null
   , p_app_id                               number      := v('APP_ID')
   , p_fetch_before_update                  boolean     := null
   , p_update_if_exists                     boolean     := null
   , p_drop_if_exists                       boolean     := null
   , p_unlock_if_exists                     varchar2    := null
   , p_unexpire_if_exists                   varchar2    := null
) authid definer
is
    -- Local Variables
    l_user_id	                            number;
    l_security_group_id	                    number;
    l_user_name                             varchar2(100);
    l_first_name                            varchar2(255);
    l_last_name                             varchar2(255);
    l_creation_date                         date;
    l_created_by                            varchar2(255);
    l_last_update_date                      date;
    l_last_updated_by                       varchar2(255);
    l_start_date                            date;
    l_end_date                              date;
    l_person_type	                        varchar2(1);
    l_email_address	                        varchar2(240);
    l_web_password2	                        raw(1000);
    l_web_password_version	                varchar2(20);
    l_last_login	                        date;
    l_builder_login_count	                number;
    l_last_agent	                        varchar2(4000);
    l_last_ip	                            varchar2(4000);
    l_account_locked	                    varchar2(1);
    l_account_expiry	                    date;
    l_failed_access_attempts	            number;
    l_last_failed_login                   	date;
    l_first_password_use_occurred	        varchar2(1);
    l_change_password_on_first_use	        varchar2(1);
    l_allow_app_building_yn	                varchar2(1);
    l_allow_sql_workshop_yn	                varchar2(1);
    l_allow_websheet_dev_yn	                varchar2(1);
    l_allow_team_development_yn	            varchar2(1);
    l_default_schema	                    varchar2(128);
    l_allow_access_to_schemas	            varchar2(4000);
    l_description	                        varchar2(240);
    l_web_password	                        varchar2(255);
    l_web_password_raw	                    raw(1000);
    l_password_date	                        date;
    l_password_accesses_left	            number(15,0);
    l_password_lifespan_accesses	        number(15,0);
    l_password_lifespan_days	            number(15,0);
    l_default_date_format	                varchar2(255);
    l_known_as	                            varchar2(255);
    l_employee_id	                        number(15,0);
    l_person_id	                            number;
    l_profile_image	                        blob;
    l_profile_image_name	                varchar2(100);
    l_profile_mimetype	                    varchar2(255);
    l_profile_filename	                    varchar2(255);
    l_profile_last_update	                date;
    l_profile_charset	                    varchar2(128);
    l_attribute_01	                        varchar2(4000);
    l_attribute_02	                        varchar2(4000);
    l_attribute_03	                        varchar2(4000);
    l_attribute_04	                        varchar2(4000);
    l_attribute_05	                        varchar2(4000);
    l_attribute_06	                        varchar2(4000);
    l_attribute_07	                        varchar2(4000);
    l_attribute_08	                        varchar2(4000);
    l_attribute_09                        	varchar2(4000);
    l_attribute_10	                        varchar2(4000);
    l_app_id                                number;
    l_today                                 date;
    l_now                                   date;
    l_result_code                           number;
    l_result_text                           varchar2(4000);
    l_edit_action                           varchar2(30);  -- FETCH, INSERT, UPDATE, DROP, UN/LOCK, UN/EXPIRE
    l_fetch_before_update                   boolean;
    l_update_if_exists                      boolean;
    l_drop_if_exists                        boolean;
    l_unlock_if_exists                      varchar2(1);
    l_unexpire_if_exists                    varchar2(1);
    l_user_exists                           pls_integer;

    -- Exceptions
    APEX_USER_EDIT_ERROR                    exception;

    -- Custom Attributes
    C_DEFAULT_SCHEMA                        constant    varchar2(100)   := 'RAS_INTERN';
    C_TODAY                                 constant    date            := trunc(sysdate);
    C_NOW                                   constant    date            := sysdate;
    C_D                                     constant    date            := C_NOW;
    C_Y                                     constant    varchar2(10)    := 'Y';
    C_N                                     constant    varchar2(10)    := 'N';
    C_APP_ID                                constant    number          := 100000;
    C_RESULT_CODE                           constant    number          := -1;
    C_RESULT_TEXT                           constant    varchar2(4000)  := 'APX Edit Apex User';
    C_EDIT_ACTION                           constant    varchar2(30)    := 'FETCH';
    C_EXPIRY_DAYS                           constant    pls_integer     := 60;
    C_UNLOCK_IF_EXISTS                      constant    varchar2(1)     := C_N;
    C_UNEXPIRE_IF_EXISTS                    constant    varchar2(1)     := C_N;
    C_UPDATE_IF_EXISTS                      constant    boolean         := false;
    C_DROP_IF_EXISTS                        constant    boolean         := false;
    C_FETCH_BEFORE_UPDATE                   constant    boolean         := false;
    -- Apex User Constants
    C_USER_ID	                            constant    number          := 0;  -- UNKNOWN
    C_SECURITY_GROUP_ID	                    constant    number          := 10; -- INTERNAL
    C_USER_NAME                             constant    varchar2(100)   := 'USR';
    C_CREATION_DATE                         constant    date            := C_D;
    C_LAST_UPDATE_DATE                      constant    date            := C_D;
    C_EXPIRY_DATE                           constant    date            := C_D;
    C_WEB_PASSWORD_VERSION  	            constant    varchar2(20)    := '5;5;00000';
    C_ACCOUNT_LOCKED                        constant    varchar2(1)     := C_N;
    C_CHANGE_PASSWORD_ON_FIRST_USE          constant    varchar2(1)     := C_N;
    C_ALLOW_APP_BUILDING_YN                 constant    varchar2(1)     := C_N;
    C_ALLOW_SQL_WORKSHOP_YN                 constant    varchar2(1)     := C_N;
    C_ALLOW_WEBSHEET_DEV_YN                 constant    varchar2(1)     := C_N;
    C_ALLOW_TEAM_DEVELOPMENT_YN             constant    varchar2(1)     := C_N;
    C_ALLOW_ACCESS_TO_SCHEMAS               constant    varchar2(1)     := null;
    C_DEFAULT_DATE_FORMAT                   constant    varchar2(30)    := 'DD.MM.YYYY HH24:MI:SS';
    C_PROFILE_CHARSET                       constant    varchar2(30)    := 'UTF-8';

    procedure "FETCH_USER" (
        p_user_id   in  number      := null
      , p_username  in  varchar2    := null
    ) is
    l_userid number;
    l_username varchar2(100);
    begin
        l_user_id   := p_user_id;
        l_username  := upper(trim(p_username));
        select
              coalesce(security_group_id, l_security_group_id)
            , coalesce(user_name, l_user_name)
            , coalesce(first_name, l_first_name)
            , coalesce(last_name, l_last_name)
            , coalesce(creation_date, l_creation_date)
            , coalesce(created_by, l_created_by)
            , coalesce(last_update_date, l_last_update_date)
            , coalesce(last_updated_by, l_last_updated_by)
            , coalesce(start_date, l_start_date)
            , coalesce(end_date, l_end_date)
            , coalesce(person_type, l_person_type)
            , coalesce(email_address, l_email_address)
            , coalesce(web_password2, l_web_password2)
            , coalesce(web_password_version, l_web_password_version)
            , coalesce(last_login, l_last_login)
            , coalesce(builder_login_count, l_builder_login_count)
            , coalesce(last_agent, l_last_agent)
            , coalesce(last_ip, l_last_ip)
            , coalesce(account_locked, l_account_locked)
            , coalesce(account_expiry, l_account_expiry)
            , coalesce(failed_access_attempts, l_failed_access_attempts)
            , coalesce(last_failed_login, l_last_failed_login)
            , coalesce(first_password_use_occurred, l_first_password_use_occurred)
            , coalesce(change_password_on_first_use, l_change_password_on_first_use)
            , coalesce(allow_app_building_yn, l_allow_app_building_yn)
            , coalesce(allow_sql_workshop_yn, l_allow_sql_workshop_yn)
            , coalesce(allow_websheet_dev_yn, l_allow_websheet_dev_yn)
            , coalesce(allow_team_development_yn, l_allow_team_development_yn)
            , coalesce(default_schema, l_default_schema)
            , coalesce(allow_access_to_schemas, l_allow_access_to_schemas)
            , coalesce(description, l_description)
            , coalesce(web_password, l_web_password)
            , coalesce(web_password_raw, l_web_password_raw)
            , coalesce(password_date, l_password_date)
            , coalesce(password_accesses_left, l_password_accesses_left)
            , coalesce(password_lifespan_accesses, l_password_lifespan_accesses)
            , coalesce(password_lifespan_days, l_password_lifespan_days)
            , coalesce(default_date_format, l_default_date_format)
            , coalesce(known_as, l_known_as)
            , coalesce(employee_id, l_employee_id)
            , coalesce(person_id, l_person_id)
            , coalesce(profile_image, l_profile_image)
            , coalesce(profile_image_name, l_profile_image_name)
            , coalesce(profile_mimetype, l_profile_mimetype)
            , coalesce(profile_filename, l_profile_filename)
            , coalesce(profile_last_update, l_profile_last_update)
            , coalesce(profile_charset, l_profile_charset)
            , coalesce(attribute_01, l_attribute_01)
            , coalesce(attribute_02, l_attribute_02)
            , coalesce(attribute_03, l_attribute_03)
            , coalesce(attribute_04, l_attribute_04)
            , coalesce(attribute_05, l_attribute_05)
            , coalesce(attribute_06, l_attribute_06)
            , coalesce(attribute_07, l_attribute_07)
            , coalesce(attribute_08, l_attribute_08)
            , coalesce(attribute_09, l_attribute_09)
            , coalesce(attribute_10, l_attribute_10)
        into
              l_security_group_id
            , l_user_name
            , l_first_name
            , l_last_name
            , l_creation_date
            , l_created_by
            , l_last_update_date
            , l_last_updated_by
            , l_start_date
            , l_end_date
            , l_person_type
            , l_email_address
            , l_web_password2
            , l_web_password_version
            , l_last_login
            , l_builder_login_count
            , l_last_agent
            , l_last_ip
            , l_account_locked
            , l_account_expiry
            , l_failed_access_attempts
            , l_last_failed_login
            , l_first_password_use_occurred
            , l_change_password_on_first_use
            , l_allow_app_building_yn
            , l_allow_sql_workshop_yn
            , l_allow_websheet_dev_yn
            , l_allow_team_development_yn
            , l_default_schema
            , l_allow_access_to_schemas
            , l_description
            , l_web_password
            , l_web_password_raw
            , l_password_date
            , l_password_accesses_left
            , l_password_lifespan_accesses
            , l_password_lifespan_days
            , l_default_date_format
            , l_known_as
            , l_employee_id
            , l_person_id
            , l_profile_image
            , l_profile_image_name
            , l_profile_mimetype
            , l_profile_filename
            , l_profile_last_update
            , l_profile_charset
            , l_attribute_01
            , l_attribute_02
            , l_attribute_03
            , l_attribute_04
            , l_attribute_05
            , l_attribute_06
            , l_attribute_07
            , l_attribute_08
            , l_attribute_09
            , l_attribute_10
        from "APEX_WORKSPACE_USER"
        where user_id = nvl(l_user_id, user_id)
        and user_name  = nvl(l_username, user_name);

        l_result_code := 0;

    exception when others then
        l_result_code := sqlcode;
        l_result_text := 'FETCH_USER - '|| sqlerrm;
        raise apex_user_edit_error;
    end "FETCH_USER";


    -- Wrapper to FETCH_USER
    procedure "FETCH_APEX_USER" (
        p_user_id   in  number      := null
      , p_username  in  varchar2    := null
    ) is
    l_userid number;
    l_username varchar2(100);
    begin
        l_user_id   := p_user_id;
        l_username  :=  upper(trim(p_username));
        if (l_user_id is not null) then
            "FETCH_USER"(l_user_id, null);
        elsif (l_user_name is not null) then
            "FETCH_USER"(null, l_user_name);
        else
            l_result_code := 3;
            l_result_text := 'FETCH_APEX_USER - No User to fetch.';
            raise apex_user_edit_error;
        end if;
    end "FETCH_APEX_USER";


    -- Un/Lock User Account
    procedure "LOCK_USER" (
        p_user_id   in  number      := null
      , p_username  in  varchar2    := null
      , p_action    in  varchar2    := 'LOCK'
    ) is
    l_userid   number;
    l_username varchar2(100);
    l_action   varchar2(100);
    begin
        l_user_id   := p_user_id;
        l_username  := upper(trim(p_username));
        l_action    := upper(trim(p_action));

        if  (l_action = 'LOCK') then
                l_account_locked := C_Y;
        elsif (l_action = 'UNLOCK') then
                l_account_locked := C_N;
        end if;

        if (l_user_id is not null) then
            update "APEX_WORKSPACE_USER"
            set account_locked = l_account_locked
            where user_id = l_user_id;
        elsif (l_user_name is not null) then
            update "APEX_WORKSPACE_USER"
            set account_locked = l_account_locked
            where user_name = l_user_name;
        end if;

        l_result_code := 0;

    exception when others then
        l_result_code := sqlcode;
        l_result_text := 'LOCK_USER - '|| sqlerrm;
        raise apex_user_edit_error;
    end "LOCK_USER";


    -- Un/Expire User Account
    procedure "EXPIRE_USER" (
        p_user_id   in  number      := null
      , p_username  in  varchar2    := null
      , p_action    in  varchar2    := 'EXPIRE'
    ) is
    l_userid   number;
    l_username varchar2(100);
    l_action   varchar2(100);
    begin
        l_user_id   := p_user_id;
        l_username  := upper(trim(p_username));
        l_action    := upper(trim(p_action));

        if  (l_action = 'EXPIRE') then
                l_account_expiry := C_NOW - C_EXPIRY_DAYS;
        elsif (l_action = 'UNEXPIRE') then
                l_account_expiry := C_NOW;
        end if;

        if (l_user_id is not null) then
            update "APEX_WORKSPACE_USER"
            set account_expiry = l_account_expiry
            where user_id = l_user_id;
        elsif (l_user_name is not null) then
            update "APEX_WORKSPACE_USER"
            set account_expiry = l_account_expiry
            where user_name = l_user_name;
        end if;

        l_result_code := 0;

    exception when others then
        l_result_code := sqlcode;
        l_result_text := 'EXPIRE_USER - '|| sqlerrm;
        raise apex_user_edit_error;
    end "EXPIRE_USER";


------------------------------------------------------------------------------
-- Main Procedure
begin

    -- Set Local Variables and Defaults
    l_app_id                                := coalesce(p_app_id, C_APP_ID);

    -- Workspace and Security Group ID
    if (l_security_group_id is null) then
        -- Set Environment
        for a in (  select workspace_id
                    from apex_applications
                    where application_id = l_app_id)
        loop
            l_security_group_id := a.workspace_id;
        end loop;
    end if;

    -- go for it, only if all is set...
    if (l_security_group_id is not null) then

        apex_util.set_security_group_id(
                p_security_group_id => l_security_group_id
                );

        -- set Apex Interface Variables
        l_user_name                         := coalesce(upper(trim(p_user_name)), C_USER_NAME);
        l_user_id                           := coalesce(p_user_id, nvl(apex_util.get_user_id(l_user_name), wwv_flow_id.next_val));
        l_first_name                        := p_first_name;
        l_last_name                         := p_last_name;
        l_creation_date                     := coalesce(p_creation_date, C_CREATION_DATE);
        l_created_by                        := coalesce(wwv_flow.g_user, user);
        l_last_update_date                  := coalesce(p_last_update_date, C_LAST_UPDATE_DATE);
        l_last_updated_by                   := coalesce(wwv_flow.g_user, user);
        l_start_date                        := coalesce(p_start_date, C_D);
        l_end_date                          := coalesce(p_end_date, C_D);
        l_person_type                       := p_person_type;
        l_email_address                     := p_email_address;
        l_web_password2                     := p_web_password2;
        l_web_password_version              := p_web_password_version;
        l_last_login                        := p_last_login;
        l_builder_login_count               := p_builder_login_count;
        l_last_agent                        := p_last_agent;
        l_last_ip                           := p_last_ip;
        l_account_locked                    := coalesce(p_account_locked, C_ACCOUNT_LOCKED);
        l_account_expiry                    := coalesce(p_account_expiry, C_EXPIRY_DATE);
        l_failed_access_attempts            := coalesce(p_failed_access_attempts, 0);
        l_last_failed_login                 := p_last_failed_login;
        l_first_password_use_occurred       := p_first_password_use_occurred;
        l_change_password_on_first_use      := coalesce(p_change_password_on_first_use, C_CHANGE_PASSWORD_ON_FIRST_USE);
        l_allow_app_building_yn             := coalesce(p_allow_app_building_yn, C_ALLOW_APP_BUILDING_YN);
        l_allow_sql_workshop_yn             := coalesce(p_allow_sql_workshop_yn, C_ALLOW_SQL_WORKSHOP_YN);
        l_allow_websheet_dev_yn             := coalesce(p_allow_websheet_dev_yn, C_ALLOW_WEBSHEET_DEV_YN);
        l_allow_team_development_yn         := coalesce(p_allow_team_development_yn, C_ALLOW_TEAM_DEVELOPMENT_YN);
        l_default_schema                    := coalesce(p_default_schema, C_DEFAULT_SCHEMA);
        l_allow_access_to_schemas           := coalesce(p_allow_access_to_schemas, C_ALLOW_ACCESS_TO_SCHEMAS);
        l_description                       := p_description;
        l_web_password                      := p_web_password;
        l_web_password_raw                  := p_web_password_raw;
        l_password_date                     :=  case when p_web_password is not null
                                                     then coalesce(p_password_date, C_D)
                                                     else null
                                                end;
        l_password_accesses_left            := p_password_accesses_left;
        l_password_lifespan_accesses        := p_password_lifespan_accesses;
        l_password_lifespan_days            := p_password_lifespan_days;
        l_default_date_format               := coalesce(p_default_date_format, C_DEFAULT_DATE_FORMAT);
        l_known_as                          := p_known_as;
        l_employee_id                       := p_employee_id;
        l_person_id                         := p_person_id;
        l_profile_image                     := p_profile_image;
        l_profile_image_name                := p_profile_image_name;
        l_profile_mimetype                  := p_profile_mimetype;
        l_profile_filename                  := p_profile_filename;
        l_profile_last_update               := p_profile_last_update;
        l_profile_charset                   :=  case when p_profile_image is not null
                                                     then coalesce(p_profile_charset, C_PROFILE_CHARSET)
                                                     else null
                                                end;
        l_attribute_01                      := p_attribute_01;
        l_attribute_02                      := p_attribute_02;
        l_attribute_03                      := p_attribute_03;
        l_attribute_04                      := p_attribute_04;
        l_attribute_05                      := p_attribute_05;
        l_attribute_06                      := p_attribute_06;
        l_attribute_07                      := p_attribute_07;
        l_attribute_08                      := p_attribute_08;
        l_attribute_09                      := p_attribute_09;
        l_attribute_10                      := p_attribute_10;
        -- custom interfaces
        l_today                             := C_TODAY;
        l_now                               := C_NOW;
        l_result_code                       := C_RESULT_CODE;
        l_result_text                       := C_RESULT_TEXT;
        l_edit_action                       := coalesce(upper(trim(p_edit_action)), C_EDIT_ACTION);
        l_fetch_before_update               := coalesce(p_fetch_before_update, C_FETCH_BEFORE_UPDATE);
        l_drop_if_exists                    := coalesce(p_drop_if_exists, C_DROP_IF_EXISTS);
        l_update_if_exists                  := coalesce(p_update_if_exists, C_UPDATE_IF_EXISTS);
        l_unlock_if_exists                  := coalesce(p_unlock_if_exists, C_UNLOCK_IF_EXISTS);
        l_unexpire_if_exists                := coalesce(p_unexpire_if_exists, C_UNEXPIRE_IF_EXISTS);

        -- check if user exists
        l_user_exists   := case when apex_util.get_user_id(l_user_name) is null
                                then 0 else 1 end;

        -- set action
        if    (l_edit_action = 'FETCH')     then
            -- fetch User by ID or Name
            "FETCH_APEX_USER"(l_user_id, l_user_name);

        elsif (l_edit_action = 'UPDATE')    then
            -- only update if exists
            if (l_user_exists = 1) then
                begin
                    if (l_fetch_before_update) then
                        "FETCH_APEX_USER"(l_user_id, l_user_name);
                    end if;
                    -- Update Existing with Input Values if different
                    update "APEX_WORKSPACE_USER"
                    set
                          security_group_id              = coalesce(l_security_group_id, security_group_id)
                        , user_name                      = coalesce(l_user_name, user_name)
                        , first_name                     = coalesce(l_first_name, first_name)
                        , last_name                      = coalesce(l_last_name, last_name)
                        , creation_date                  = coalesce(l_creation_date, creation_date)
                        , created_by                     = coalesce(l_created_by, created_by)
                        , last_update_date               = coalesce(l_last_update_date, last_update_date)
                        , last_updated_by                = coalesce(l_last_updated_by, last_updated_by)
                        , start_date                     = coalesce(l_start_date, start_date)
                        , end_date                       = coalesce(l_end_date, end_date)
                        , person_type                    = coalesce(l_person_type, person_type)
                        , email_address                  = coalesce(l_email_address, email_address)
                        , web_password2                  = coalesce(l_web_password2, web_password2)
                        , web_password_version           = coalesce(l_web_password_version, web_password_version)
                        , last_login                     = coalesce(l_last_login, last_login)
                        , builder_login_count            = coalesce(l_builder_login_count, builder_login_count)
                        , last_agent                     = coalesce(l_last_agent, last_agent)
                        , last_ip                        = coalesce(l_last_ip, last_ip)
                        , account_locked                 = coalesce(l_account_locked, account_locked)
                        , account_expiry                 = coalesce(l_account_expiry, account_expiry)
                        , failed_access_attempts         = coalesce(l_failed_access_attempts, failed_access_attempts)
                        , last_failed_login              = coalesce(l_last_failed_login, last_failed_login)
                        , first_password_use_occurred    = coalesce(l_first_password_use_occurred, first_password_use_occurred)
                        , change_password_on_first_use   = coalesce(l_change_password_on_first_use, change_password_on_first_use)
                        , allow_app_building_yn          = coalesce(l_allow_app_building_yn, allow_app_building_yn)
                        , allow_sql_workshop_yn          = coalesce(l_allow_sql_workshop_yn, allow_sql_workshop_yn)
                        , allow_websheet_dev_yn          = coalesce(l_allow_websheet_dev_yn, allow_websheet_dev_yn)
                        , allow_team_development_yn      = coalesce(l_allow_team_development_yn, allow_team_development_yn)
                        , default_schema                 = coalesce(l_default_schema, default_schema)
                        , allow_access_to_schemas        = coalesce(l_allow_access_to_schemas, allow_access_to_schemas)
                        , description                    = coalesce(l_description, description)
                        , web_password                   = coalesce(l_web_password, web_password)
                        , web_password_raw               = coalesce(l_web_password_raw, web_password_raw)
                        , password_date                  = coalesce(l_password_date, password_date)
                        , password_accesses_left         = coalesce(l_password_accesses_left, password_accesses_left)
                        , password_lifespan_accesses     = coalesce(l_password_lifespan_accesses, password_lifespan_accesses)
                        , password_lifespan_days         = coalesce(l_password_lifespan_days, password_lifespan_days)
                        , default_date_format            = coalesce(l_default_date_format, default_date_format)
                        , known_as                       = coalesce(l_known_as, known_as)
                        , employee_id                    = coalesce(l_employee_id, employee_id)
                        , person_id                      = coalesce(l_person_id, person_id)
                        , profile_image                  = coalesce(l_profile_image, profile_image)
                        , profile_image_name             = coalesce(l_profile_image_name, profile_image_name)
                        , profile_mimetype               = coalesce(l_profile_mimetype, profile_mimetype)
                        , profile_filename               = coalesce(l_profile_filename, profile_filename)
                        , profile_last_update            = coalesce(l_profile_last_update, profile_last_update)
                        , profile_charset                = coalesce(l_profile_charset, profile_charset)
                        , attribute_01                   = coalesce(l_attribute_01, attribute_01)
                        , attribute_02                   = coalesce(l_attribute_02, attribute_02)
                        , attribute_03                   = coalesce(l_attribute_03, attribute_03)
                        , attribute_04                   = coalesce(l_attribute_04, attribute_04)
                        , attribute_05                   = coalesce(l_attribute_05, attribute_05)
                        , attribute_06                   = coalesce(l_attribute_06, attribute_06)
                        , attribute_07                   = coalesce(l_attribute_07, attribute_07)
                        , attribute_08                   = coalesce(l_attribute_08, attribute_08)
                        , attribute_09                   = coalesce(l_attribute_09, attribute_09)
                        , attribute_10                   = coalesce(l_attribute_10, attribute_10)
                    where user_id = l_user_id;

                    l_result_code := 0;

                exception when others then
                    l_result_code := sqlcode;
                    l_result_text := l_edit_action ||' - '||sqlerrm;
                    raise apex_user_edit_error;
                end;
            end if;
        -- UPDATE END

        elsif (l_edit_action = 'MERGE')    then
            -- only merge if exists
            if (l_user_exists = 1) then
                begin
                    -- Merge Existing NULLs with Inputs if not NULL
                    update "APEX_WORKSPACE_USER"
                    set
                          security_group_id              = coalesce(security_group_id, l_security_group_id)
                        , user_name                      = coalesce(user_name, l_user_name)
                        , first_name                     = coalesce(first_name, l_first_name)
                        , last_name                      = coalesce(last_name, l_last_name)
                        , creation_date                  = coalesce(creation_date, l_creation_date)
                        , created_by                     = coalesce(created_by, l_created_by)
                        , last_update_date               = coalesce(last_update_date, l_last_update_date)
                        , last_updated_by                = coalesce(last_updated_by, l_last_updated_by)
                        , start_date                     = coalesce(start_date, l_start_date)
                        , end_date                       = coalesce(end_date, l_end_date)
                        , person_type                    = coalesce(person_type, l_person_type)
                        , email_address                  = coalesce(email_address, l_email_address)
                        , web_password2                  = coalesce(web_password2, l_web_password2)
                        , web_password_version           = coalesce(web_password_version, l_web_password_version)
                        , last_login                     = coalesce(last_login, l_last_login)
                        , builder_login_count            = coalesce(builder_login_count, l_builder_login_count)
                        , last_agent                     = coalesce(last_agent, l_last_agent)
                        , last_ip                        = coalesce(last_ip, l_last_ip)
                        , account_locked                 = coalesce(account_locked, l_account_locked)
                        , account_expiry                 = coalesce(account_expiry, l_account_expiry)
                        , failed_access_attempts         = coalesce(failed_access_attempts, l_failed_access_attempts)
                        , last_failed_login              = coalesce(last_failed_login, l_last_failed_login)
                        , first_password_use_occurred    = coalesce(first_password_use_occurred, l_first_password_use_occurred)
                        , change_password_on_first_use   = coalesce(change_password_on_first_use, l_change_password_on_first_use)
                        , allow_app_building_yn          = coalesce(allow_app_building_yn, l_allow_app_building_yn)
                        , allow_sql_workshop_yn          = coalesce(allow_sql_workshop_yn, l_allow_sql_workshop_yn)
                        , allow_websheet_dev_yn          = coalesce(allow_websheet_dev_yn, l_allow_websheet_dev_yn)
                        , allow_team_development_yn      = coalesce(allow_team_development_yn, l_allow_team_development_yn)
                        , default_schema                 = coalesce(default_schema, l_default_schema)
                        , allow_access_to_schemas        = coalesce(allow_access_to_schemas, l_allow_access_to_schemas)
                        , description                    = coalesce(description, l_description)
                        , web_password                   = coalesce(web_password, l_web_password)
                        , web_password_raw               = coalesce(web_password_raw, l_web_password_raw)
                        , password_date                  = coalesce(password_date, l_password_date)
                        , password_accesses_left         = coalesce(password_accesses_left, l_password_accesses_left)
                        , password_lifespan_accesses     = coalesce(password_lifespan_accesses, l_password_lifespan_accesses)
                        , password_lifespan_days         = coalesce(password_lifespan_days, l_password_lifespan_days)
                        , default_date_format            = coalesce(default_date_format, l_default_date_format)
                        , known_as                       = coalesce(known_as, l_known_as)
                        , employee_id                    = coalesce(employee_id, l_employee_id)
                        , person_id                      = coalesce(person_id, l_person_id)
                        , profile_image                  = coalesce(profile_image, l_profile_image)
                        , profile_image_name             = coalesce(profile_image_name, l_profile_image_name)
                        , profile_mimetype               = coalesce(profile_mimetype, l_profile_mimetype)
                        , profile_filename               = coalesce(profile_filename, l_profile_filename)
                        , profile_last_update            = coalesce(profile_last_update, l_profile_last_update)
                        , profile_charset                = coalesce(profile_charset, l_profile_charset)
                        , attribute_01                   = coalesce(attribute_01, l_attribute_01)
                        , attribute_02                   = coalesce(attribute_02, l_attribute_02)
                        , attribute_03                   = coalesce(attribute_03, l_attribute_03)
                        , attribute_04                   = coalesce(attribute_04, l_attribute_04)
                        , attribute_05                   = coalesce(attribute_05, l_attribute_05)
                        , attribute_06                   = coalesce(attribute_06, l_attribute_06)
                        , attribute_07                   = coalesce(attribute_07, l_attribute_07)
                        , attribute_08                   = coalesce(attribute_08, l_attribute_08)
                        , attribute_09                   = coalesce(attribute_09, l_attribute_09)
                        , attribute_10                   = coalesce(attribute_10, l_attribute_10)
                    where user_id = l_user_id;

                    l_result_code := 0;

                exception when others then
                    l_result_code := sqlcode;
                    l_result_text := l_edit_action ||' - '||sqlerrm;
                    raise apex_user_edit_error;
                end;
            end if;
        -- MERGE END

        elsif (l_edit_action = 'INSERT')    then
            begin
                insert into "APEX_WORKSPACE_USER"  (
                      user_id
                    , security_group_id
                    , user_name
                    , first_name
                    , last_name
                    , creation_date
                    , created_by
                    , last_update_date
                    , last_updated_by
                    , start_date
                    , end_date
                    , person_type
                    , email_address
                    , web_password2
                    , web_password_version
                    , last_login
                    , builder_login_count
                    , last_agent
                    , last_ip
                    , account_locked
                    , account_expiry
                    , failed_access_attempts
                    , last_failed_login
                    , first_password_use_occurred
                    , change_password_on_first_use
                    , allow_app_building_yn
                    , allow_sql_workshop_yn
                    , allow_websheet_dev_yn
                    , allow_team_development_yn
                    , default_schema
                    , allow_access_to_schemas
                    , description
                    , web_password
                    , web_password_raw
                    , password_date
                    , password_accesses_left
                    , password_lifespan_accesses
                    , password_lifespan_days
                    , default_date_format
                    , known_as
                    , employee_id
                    , person_id
                    , profile_image
                    , profile_image_name
                    , profile_mimetype
                    , profile_filename
                    , profile_last_update
                    , profile_charset
                    , attribute_01
                    , attribute_02
                    , attribute_03
                    , attribute_04
                    , attribute_05
                    , attribute_06
                    , attribute_07
                    , attribute_08
                    , attribute_09
                    , attribute_10
                ) values (
                      l_user_id
                    , l_security_group_id
                    , l_user_name
                    , l_first_name
                    , l_last_name
                    , l_creation_date
                    , l_created_by
                    , l_last_update_date
                    , l_last_updated_by
                    , l_start_date
                    , l_end_date
                    , l_person_type
                    , l_email_address
                    , l_web_password2
                    , l_web_password_version
                    , l_last_login
                    , l_builder_login_count
                    , l_last_agent
                    , l_last_ip
                    , l_account_locked
                    , l_account_expiry
                    , l_failed_access_attempts
                    , l_last_failed_login
                    , l_first_password_use_occurred
                    , l_change_password_on_first_use
                    , l_allow_app_building_yn
                    , l_allow_sql_workshop_yn
                    , l_allow_websheet_dev_yn
                    , l_allow_team_development_yn
                    , l_default_schema
                    , l_allow_access_to_schemas
                    , l_description
                    , l_web_password
                    , l_web_password_raw
                    , l_password_date
                    , l_password_accesses_left
                    , l_password_lifespan_accesses
                    , l_password_lifespan_days
                    , l_default_date_format
                    , l_known_as
                    , l_employee_id
                    , l_person_id
                    , l_profile_image
                    , l_profile_image_name
                    , l_profile_mimetype
                    , l_profile_filename
                    , l_profile_last_update
                    , l_profile_charset
                    , l_attribute_01
                    , l_attribute_02
                    , l_attribute_03
                    , l_attribute_04
                    , l_attribute_05
                    , l_attribute_06
                    , l_attribute_07
                    , l_attribute_08
                    , l_attribute_09
                    , l_attribute_10
                );

            l_result_code := 0;

            exception
            when dup_val_on_index then
                if (l_update_if_exists) then
                    begin
                        update "APEX_WORKSPACE_USER"
                        set
                            first_name          = l_first_name,
                            last_name           = l_last_name,
                            last_update_date    = l_last_update_date,
                            attribute_09        = l_attribute_09,  -- TOKEN
                            attribute_10        = l_attribute_10,  -- TOKEN_VALID_UNTIL
                            account_locked      = case
                                                    when l_unlock_if_exists = 'Y'
                                                    then l_account_locked
                                                    else p_account_locked
                                                end,
                            account_expiry      = case
                                                    when l_unexpire_if_exists = 'Y'
                                                    then l_account_expiry
                                                    else account_expiry
                                                end
                        where user_id = l_user_id;

                        l_result_code := 0;

                    exception when others then
                        l_result_code := sqlcode;
                        l_result_text := l_edit_action ||' - '||sqlerrm;
                        raise apex_user_edit_error;
                    end;
                elsif (l_drop_if_exists) then
                    begin
                        delete from "APEX_WORKSPACE_USER"
                        where user_id = l_user_id;

                        l_result_code := 0;

                    exception when others then
                        l_result_code := sqlcode;
                        l_result_text := l_edit_action ||' - '||sqlerrm;
                        raise apex_user_edit_error;
                    end;
                else
                    l_result_code := sqlcode;
                    l_result_text := l_edit_action ||' - '||sqlerrm;
                    raise apex_user_edit_error;
                    --raise_application_error(-20222, 'UserID: '||l_user_id||' '||upper(trim(l_user_name)));
                end if;
            when others then
                l_result_code := sqlcode;
                l_result_text := l_edit_action ||' - '||sqlerrm;
                raise apex_user_edit_error;
            end;

        -- INSERT END
        elsif (l_edit_action = 'DROP')      then

            if (l_user_exists = 1) then
                if (l_user_id is not null) then
                    delete from "APEX_WORKSPACE_USER"
                    where user_id = l_user_id;
                elsif (l_user_name is not null) then
                    delete from "APEX_WORKSPACE_USER"
                    where user_name = l_user_name;
                end if;
            end if;

            l_result_code := 0;

        elsif (l_edit_action = 'LOCK_AND_EXPIRE') then
            if (l_user_exists = 1) then
                "LOCK_USER"(l_user_id, l_user_name, 'LOCK');
                "EXPIRE_USER"(l_user_id, l_user_name, 'EXPIRE');
            end if;
            l_result_code := 0;
        elsif (l_edit_action = 'UNLOCK_AND_UNEXPIRE') then
            if (l_user_exists = 1) then
                "LOCK_USER"(l_user_id, l_user_name, 'UNLOCK');
                "EXPIRE_USER"(l_user_id, l_user_name, 'UNEXPIRE');
            end if;
            l_result_code := 0;
        elsif (l_edit_action = 'LOCK')      then
            if (l_user_exists = 1) then
                "LOCK_USER"(l_user_id, l_user_name, l_edit_action);
            end if;
            l_result_code := 0;
        elsif (l_edit_action = 'UNLOCK')    then
            if (l_user_exists = 1) then
                "LOCK_USER"(l_user_id, l_user_name, l_edit_action);
            end if;
            l_result_code := 0;
        elsif (l_edit_action = 'EXPIRE')    then
            if (l_user_exists = 1) then
                "EXPIRE_USER"(l_user_id, l_user_name, l_edit_action);
            end if;
            l_result_code := 0;
        elsif (l_edit_action = 'UNEXPIRE')  then
            if (l_user_exists = 1) then
                "EXPIRE_USER"(l_user_id, l_user_name, l_edit_action);
            end if;
            l_result_code := 0;
        else
            l_result_code := 2;
            l_result_text := 'No valid action: "'|| coalesce(l_edit_action, '(NULL)') ||'"';
            raise apex_user_edit_error;
        end if;

    else
        l_result_code := 1;
        l_result_text := 'No valid Workspace ID: "'|| l_security_group_id ||'"';
        raise apex_user_edit_error;
    end if;

    -- save changes
    commit;
    -- and set return value
    p_result := l_result_code;

exception when apex_user_edit_error then
    p_result  := l_result_code;
    rollback;
    raise_application_error(-20000, to_char(l_result_code) ||' - '|| coalesce(l_result_text, sqlerrm));
when others then
    p_result  := l_result_code;
    rollback;
    raise_application_error(-20001, to_char(l_result_code) ||' - '|| sqlerrm);
end "APX_APEX_USER_EDIT";
/



----------------------------------------------------------------------------------------------------
--- APEX User Management Apex Authentication Users  Tests ---
declare
l_result number;
begin
   "APX_APEX_USER_EDIT"(
       p_result => l_result
     , p_edit_action => 'DROP'
     , p_user_name => 'Trivadis@bfarm.de'
   );
   dbms_output.put_line('Result: '||l_result); -- Result: 0
end;
/

declare
l_result number;
begin
   "APX_APEX_USER_EDIT"(
       p_result => l_result
     , p_user_name => 's.obermeyer@t-online.de'
     , p_edit_action => null
   );
   dbms_output.put_line('Result: '||l_result); -- Result: 0
end;
/


declare
l_result number;
begin
   "APX_APEX_USER_EDIT"(
       p_result => l_result
     , p_user_id => 177  
     , p_user_name => ' TRIVADIS@BFARM.DE'
     , p_web_password => 'Secret123#'
     , p_first_name =>  'Tri'
     , p_last_name => 'Vadis'     
     , p_edit_action => 'INSERT'
   );
   dbms_output.put_line('Result: '||l_result); -- Result: 0
end;
/

declare
l_result number;
begin
   "APX_APEX_USER_EDIT"(
       p_result => l_result
     , p_edit_action => 'UPDATE'
     , p_user_name => 'stefan.obermeyer@t-online.de'
     , p_web_password => 'Secret123#'
     , p_first_name =>  'Stefan'
     , p_last_name => 'Obermeyer'
   );
   dbms_output.put_line('Result: '||l_result); -- Result: 0
end;
/


declare
l_result number;
begin
   "APX_APEX_USER_EDIT"(
       p_result => l_result
     , p_user_name => 'stefan.obermeyer@t-online.de'
     , p_first_name =>  'StefanO'
     , p_last_name => 'Obermeyer'
     , p_edit_action => 'MERGE'
   );
   dbms_output.put_line('Result: '||l_result); -- Result: 0
end;
/

declare
l_result number;
begin
   "APX_APEX_USER_EDIT"(
       p_result => l_result
     , p_user_name => 'stefan.obermeyer@t-online.de'
     , p_attribute_09 => to_char(sysdate)
     , p_edit_action => 'INSERT'
     , p_update_if_exists => true
   );
   dbms_output.put_line('Result: '||l_result); -- Result: 0
end;
/


declare
l_result number;
begin
   "APX_APEX_USER_EDIT"(
       p_result => l_result
     , p_edit_action => 'LOCK'
     , p_user_name => 'stefan.obermeyer@t-online.de'
   );
   dbms_output.put_line('Result: '||l_result); -- Result: 0
end;
/

declare
l_result number;
begin
   "APX_APEX_USER_EDIT"(
       p_result => l_result
     , p_edit_action => 'EXPIRE'
     , p_user_name => 'stefan.obermeyer@t-online.de'
   );
   dbms_output.put_line('Result: '||l_result); -- Result: 0
end;
/

declare
l_result number;
begin
   "APX_APEX_USER_EDIT"(
       p_result => l_result
     , p_edit_action => 'UNLOCK_AND_UNEXPIRE'
     , p_user_name => 'stefan.obermeyer@t-online.de'
   );
   dbms_output.put_line('Result: '||l_result); -- Result: 0
end;
/

declare
l_result number;
begin
   "APX_APEX_USER_EDIT"(
       p_result => l_result
     , p_edit_action => 'LOCK_AND_EXPIRE'
     , p_user_name => 'stefan.obermeyer@t-online.de'
   );
   dbms_output.put_line('Result: '||l_result); -- Result: 0
end;
/


alter table "APX$USER" add constraint "APX$USR_APEX_USER_ID_FK" foreign key(apex_user_id)
references "APEX_WORKSPACE_USER"(user_id) on delete cascade;

alter table "APX$USER_REG" add constraint "APX$USRREG_APEX_USER_ID_FK" foreign key(apex_user_id)
references "APEX_WORKSPACE_USER"(user_id) on delete cascade;


---------------------------------------------------------------------------------
-- Page Process
declare
    l_result           number           := 0;
    l_app_id           varchar2(100)    := :APP_ID;
    l_username         varchar2(200)    := :NEWUSER;
    l_firstname        varchar2(100)    := null;
    l_lastname         varchar2(100)    := null;
    l_web_password     varchar2(200)    := :NUPWV;
    l_email_address    varchar2(200)    := :NEWUSER;
    l_token            varchar2(200)    := :TOKEN;
    l_default_schema   varchar2(200)    := 'APXUSR';
begin

     for c1 in (
            select workspace_id
            from apex_applications
            where application_id = l_app_id ) loop
            apex_util.set_security_group_id(
                p_security_group_id => c1.workspace_id
                );
        end loop;

    for i in (select  apx_user_first_name
                    , apx_user_last_name
              from "APX$USER_REG"
              where   upper(trim(apx_username)) = upper(trim(l_username))
              and     upper(trim(apx_user_token)) = upper(trim(l_token))
             )
    loop
        l_firstname := i.apx_user_first_name;
        l_lastname  := i.apx_user_last_name;
    end loop;

    apex_util.set_session_state('P0_USER_REG_STATUS', 'PRECREATED');

    /*
    raise_application_error(-20001, 'In Create User Function: '||
    l_result ||' '||
    l_username ||' '||
    l_firstname ||' '||
    l_lastname ||' '||
    regexp_replace(nvl(l_web_password, 'EMPTY'), '.', '?')||' '||
    l_email_address||' '||
    l_token||' '||
    l_app_id||' '||
    l_default_schema ||' '||
    apex_util.get_session_state('P0_USER_REG_STATUS')
    );
    */

    "APEX_CREATE_USER" (
        p_result           => l_result
      , p_username         => l_username
      , p_first_name       => l_firstname
      , p_last_name        => l_lastname
      , p_web_password     => l_web_password
      , p_email_address    => l_email_address
      , p_token            => l_token
      , p_app_id           => l_app_id
      , p_default_schema   => l_default_schema
    );

    if (l_result = 0) then
        apex_util.set_session_state('P0_USER_REG_STATUS', 'CREATED');
    else
        apex_util.set_session_state('P0_USER_REG_STATUS', to_char(l_result));
    end if;

commit;

--raise_application_error(-20001, 'In Create User Function "'||to_char(l_result)||'" P0STAT: '||v('P0_USER_REG_STATUS'));

exception when others then
raise;
end;
/


grant execute on  "APX_APEX_USER_EDIT" to ras_intern;



