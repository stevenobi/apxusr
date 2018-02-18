create or replace procedure "APX_CREATE_USER" (
      p_username                    in       varchar2
    , p_result                      in out   number
    , p_email_address               in       varchar2        := null
    , p_first_name                  in       varchar2        := null
    , p_last_name                   in       varchar2        := null
    , p_params                      in       clob            := null
    , p_values                      in       clob            := null
    , p_topic                       in       varchar2        := null
    , p_userid                      in       number          := null
    , p_domain_id                   in       number          := null
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
    , p_attribute_06                in       varchar2        := null
    , p_attribute_07                in       varchar2        := null
    , p_attribute_08                in       varchar2        := null
    , p_attribute_09                in       varchar2        := null
    , p_attribute_10                in       varchar2        := null
    , p_app_id                      in       number          := v('APP_ID')
    , p_debug                       in       boolean         := null
    , p_send_mail                   in       boolean         := null
    , p_create_apex_user            in       boolean         := null
    , p_fetch_before_update                  boolean         := null
    , p_update_if_exists                     boolean         := null
    , p_drop_if_exists                       boolean         := null
    , p_unlock_if_exists                     varchar2        := null
    , p_unexpire_if_exists                   varchar2        := null
) authid current_user
is
    -- Local Variables
    l_username                      varchar2(128);
    l_result                        number;
    l_result_code                   number;
    l_result_text                   varchar2(1000);
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
    l_attribute_06                  varchar2(1000);
    l_attribute_07                  varchar2(1000);
    l_attribute_08                  varchar2(1000);
    l_attribute_09                  varchar2(1000);
    l_attribute_10                  varchar2(1000);
    l_app_id                        number;
    l_debug                         boolean;
    l_send_mail                     boolean;
    l_create_apex_user              boolean;
    l_user_exists                   number;
    l_fetch_before_update           boolean;
    l_update_if_exists              boolean;
    l_drop_if_exists                boolean;
    l_unlock_if_exists              varchar2(1);
    l_unexpire_if_exists            varchar2(1);

    CREATE_USER_ERROR               exception;

    -- Constants
    C_TOPIC                         constant          varchar2(1000)  := 'CREATE';
    C_PASSWORD_FORMAT               constant          varchar2(1000)  := 'CLEAR_TEXT';
    C_ACCOUNT_LOCKED                constant          varchar2(10)    := 'N';
    C_ACCOUNT_EXPIRED               constant          date            := TRUNC(SYSDATE);
    C_RESET_DATE                    constant          date            := TO_DATE('01.01.1900', 'DD.MM.YYYY');
    C_CHANGE_PASSWORD_ON_FIRST_USE  constant          varchar2(10)    := 'N';
    C_APP_ID                        constant          pls_integer     := 100;
    C_RESULT_CODE                   constant          number          := 0;
    C_DEBUG                         constant          boolean         := false;
    C_SEND_MAIL                     constant          boolean         := false;
    C_CREATE_APEX_USER              constant          boolean         := true;
    C_DEVELOPER_PRIVS               constant          varchar2(1000)  := null;
    C_ALLOW_ACCESS_TO_SCHEMAS       constant          varchar2(1000)  := null;
    -- Custom Attributes
    C_Y                             constant          varchar2(10)    := 'Y';
    C_N                             constant          varchar2(10)    := 'N';
    C_UNLOCK_IF_EXISTS              constant          varchar2(1)     := C_N;
    C_UNEXPIRE_IF_EXISTS            constant          varchar2(1)     := C_N;
    C_UPDATE_IF_EXISTS              constant          boolean         := false;
    C_DROP_IF_EXISTS                constant          boolean         := false;
    C_FETCH_BEFORE_UPDATE           constant          boolean         := false;

begin

   -- Setting Locals Defaults
    l_email_address                 := p_email_address;
    l_username                      := upper(trim(nvl(p_username, l_email_address)));
    l_first_name                    := p_first_name;
    l_last_name                     := p_last_name;
    l_params                        := p_params;
    l_values                        := p_values;
    l_topic                         := nvl(p_topic            , C_TOPIC);
    l_userid                        := coalesce(p_userid      , APX$USER_ID_SEQ.NEXTVAL);
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
    l_attribute_06                  := p_attribute_06;
    l_attribute_07                  := p_attribute_07;
    l_attribute_08                  := p_attribute_08;
    l_attribute_09                  := p_attribute_09;
    l_attribute_10                  := p_attribute_10;
    l_app_id                        := nvl(p_app_id           , C_APP_ID);
    l_result_text                   := 'Create APEX User Call';
    l_result_code                   := C_RESULT_CODE;
    l_debug                         := nvl(p_debug            , C_DEBUG);
    l_send_mail                     := nvl(p_send_mail        , C_SEND_MAIL);
    l_create_apex_user              := nvl(p_create_apex_user , C_CREATE_APEX_USER);
    l_fetch_before_update           := coalesce(p_fetch_before_update, C_FETCH_BEFORE_UPDATE);
    l_drop_if_exists                := coalesce(p_drop_if_exists, C_DROP_IF_EXISTS);
    l_update_if_exists              := coalesce(p_update_if_exists, C_UPDATE_IF_EXISTS);
    l_unlock_if_exists              := coalesce(p_unlock_if_exists, C_UNLOCK_IF_EXISTS);
    l_unexpire_if_exists            := coalesce(p_unexpire_if_exists, C_UNEXPIRE_IF_EXISTS);

    -- check if user exists
    l_user_exists   := case when apex_util.get_user_id(l_username) is null
                            then 0 else 1 end;


    -- create local app user first

    if (l_token is not null) then

        if ("IS_VALID_USER_TOKEN"(l_username, l_token)) then

            if l_create_apex_user and l_user_exists = 0 then

                -- set Apex Environment
                for c1 in (
                    select workspace_id
                    from apex_applications
                    where application_id = l_app_id ) loop
                    apex_util.set_security_group_id(
                        p_security_group_id => c1.workspace_id
                        );
                end loop;

                "APX_APEX_USER_EDIT"(
                      p_result                          => l_result_code
                    , p_edit_action                     => 'INSERT'
                    , p_update_if_exists                => true
                    , p_drop_if_exists                  => false
                    , p_unlock_if_exists                => 'N'
                    , p_unexpire_if_exists              => 'N'
                    , p_user_id                         => l_userid
                    , p_user_name                       => l_username
                    , p_first_name                      => l_first_name
                    , p_last_name                       => l_last_name
                    , p_description                     => l_description
                    , p_email_address                   => l_email_address
                    , p_web_password                    => l_web_password
                    , p_default_schema                  => l_default_schema
                    , p_allow_access_to_schemas         => l_allow_access_to_schemas
                    , p_change_password_on_first_use    => l_change_password_on_first_use
                    , p_account_expiry                  => l_account_expiry
                    , p_account_locked                  => l_account_locked
                    , p_attribute_01                    => l_attribute_01
                    , p_attribute_02                    => l_attribute_02
                    , p_attribute_03                    => l_attribute_03
                    , p_attribute_04                    => l_attribute_04
                    , p_attribute_05                    => l_attribute_05
                    , p_attribute_06                    => l_attribute_06
                    , p_attribute_07                    => l_attribute_07
                    , p_attribute_08                    => l_attribute_08
                    , p_attribute_09                    => l_attribute_09
                    , p_attribute_10                    => l_attribute_10
                );

            end if;

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

            l_result_code := 0;

            exception
            when dup_val_on_index then
                update "APEX_USER"
                set
                    apx_user_first_name = l_first_name,
                    apx_user_last_name = l_last_name,
                    apx_user_token = l_token,
                    apx_user_token_created = sysdate,
                    apx_user_token_valid_until = sysdate + 1
                where upper(trim(apx_username)) = upper(trim(l_username));
                commit;
                l_result_code := 0;
            when no_data_found then
                l_result_code := 1;
                l_result_text := 'No User Data for Token found.';
                raise create_user_error;
            end;
        else
           l_result_code := 2;
           l_result_text := 'Invalid Token';
           raise create_user_error;
        end if;
    else -- working without token system
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

        l_result_code := 0;

    end if;

    -- send confirmation mail if specified
    if l_send_mail then

        "SEND_MAIL" (
            p_result      =>  l_result_code
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
            apx_app_user_id            = l_userid,
            apex_user_id               = l_userid,
            apx_user_token_created     = C_RESET_DATE,
            apx_user_token_valid_until = C_RESET_DATE
        where apx_user_token = l_token;

    commit;
    l_result_code := 0;

    else
        rollback;
        raise_application_error(-20002, l_result_code ||' '|| l_result_text);
    end if;

    p_result := l_result_code;

exception when create_user_error then
    p_result  := l_result_code;
    raise_application_error(-20001, l_result_code ||' '|| l_result_text);
when dup_val_on_index then
    p_result  := l_result_code;
    rollback;
    raise_application_error(-20003, l_result_code ||' '|| l_result_text);
when others then
    l_result_code := -1;
    p_result  := l_result_code;
    rollback;
    raise_application_error(sqlcode, l_result_code ||' '|| sqlerrm);
end "APX_CREATE_USER";
/

