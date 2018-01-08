
---------------------------------------------------------------------------------------------------------
-- previous page process
declare
   l_new_user_id                   pls_integer;
   l_from                             varchar2(100) := 's.obermeyer@t-online.de';  -- C_MAIL_FROM in Production
   l_email                            varchar2(100) := 's.obermeyer@t-online.de';  -- v('P102_EMAIL')
   l_username                      varchar2(100) := null;                                -- v('P102_USERNAME')
   l_app_id                           pls_integer    := nvl(v('APP_ID'), 110);         -- v('APP_ID')
   l_token                             varchar2(1000);
   l_user_domain                   varchar2(100);
   l_domain_id                       pls_integer;
   l_token_valid_for_hours       pls_integer;
   l_send_mail                       boolean := false;
   l_body                              clob;
   l_body_html                       clob;
   -- into package with those...
   c_token_valid_for constant pls_integer  := 24;
   c_default_domain constant pls_integer  := 0;
   c_user_domain constant varchar2(100)  := 'ThisUserDomain.net';
begin
/*
raise_application_error(-20002, 'In User Reg Process');
*/

if (l_email is not null and instr(l_email, '@') > 0) then

    l_user_domain := nvl(upper(trim(substr(l_email, instr(l_email, '@') + 1, length(l_email)))), c_user_domain);

    begin
        select apex_domain_id
        into l_domain_id
        from "APEX_DOMAINS"
        where upper(trim(apex_domain)) = l_user_domain;
    exception when no_data_found then
    l_domain_id := c_default_domain;
    end;

    begin
        select  apex_config_item_value
        into l_token_valid_for_hours
        from "APEX_CONFIGURATION"
        where  apex_config_item = 'USER_TOKEN_VALID_FOR_HOURS';
    exception when others then
    l_token_valid_for_hours := c_token_valid_for;
    end;

    -- get token for new user
    l_token := apx_get_token( l_email || l_user_domain );

    insert into APEX_USER_REGISTRATION (apx_username, apx_user_email, apx_user_token, apx_user_token_created,
                                                           apx_user_token_valid_until, apx_user_token_ts, apx_user_domain_id, app_id)
    values(nvl(l_username, l_email), l_email, l_token, sysdate,
               sysdate + l_token_valid_for_hours / 24, systimestamp, l_domain_id, l_app_id)
    returning apx_user_id into l_new_user_id;

    commit;

    -- send confirmation mail if specified
    if l_send_mail then

        -- l_reg_types collection := [REGISTER, REREGISTER, RESETPW, UNLOCK,..]
        -- l_subject := APXUSR.GET_EMAIL_SUBJECT(l_type [REGISTER, REREGISTER, RESETPW, UNLOCK,..]) return clob;
        -- l_body := APXUSR.GET_EMAIL_BODY_TEXT(l_text) return clob;
        -- l_body_html := APXUSR.GET_EMAIL_BODY_HTML(l_type [REGISTER, REREGISTER, RESETPW, UNLOCK,..], l_username, l_email, l_token) return clob;
        -- APXUSR.SEND_MAIL (l_email, l_from, l_subject, l_body, l_body_html)


        -- l_body := 'To view the content of this message, please use an HTML enabled mail client.' || utl_tcp.crlf;

        -- l_body_html := '<html><body>' || utl_tcp.crlf ||
        --                '<p>Please confirm your registration at <a href="' ||
        --                apex_mail.get_instance_url || 'f?p='||v('APP_ID')||
        --                ':USRREGC::CONFIRM:NO::NEWUSER,TOKEN:'||nvl(l_username, l_email)||','||l_token||
        --                '">Registration Confirmation</a> page.</p>' || utl_tcp.crlf ||
        --                '<p>Sincerely,<br />' || utl_tcp.crlf ||
        --                'Yo Bro from Next Do''<br />' || utl_tcp.crlf ||
        --                '<img src="http://zapt1.staticworld.net/images/article/2013/04/oracle-logo-100033308-gallery.png" alt="Oracle Logo"></p>' || utl_tcp.crlf ||
        --                '</body></html>';


    end if;

    -- set status to registered
    update "APEX_USER_REGISTRATION"
    set apx_user_status_id = (select apex_status_id
                                from apex_status
                               where app_id is null
                                 and apex_status_context = 'USER'
                                 and apex_status = 'REGISTERED')
    where apx_user_id = l_new_user_id;

    htp.p('User '||nvl(l_username, l_email)||' successfully registered.');
    apex_util.set_session_state('P102_EMAIL', l_email);
    apex_util.set_session_state('P0_USER', nvl(l_username, l_email));
    apex_util.set_session_state('P0_USER_STATUS', 'REGISTERED');

    commit;

end if;

exception when dup_val_on_index then
rollback;
    l_username := nvl(l_username, l_email);
    htp.p ('<p>User ' ||l_username || ' already registered. Do You want to reset your password?</p>');
    dbms_output.put_line ('User ' ||l_username || ' already registered. Want to reset Your Password?');
when others then
rollback;
    htp.p ('<p>Exception: ' || SQLERRM || ' occured</p>');
    dbms_output.put_line ('Exception: ' || SQLERRM || ' occured');
raise;
end;
/


------------------------------------------------------------------------------------------------------------

/*
for c1 in (
   select workspace_id
     from apex_applications
    where application_id = :p_app_id )
loop
   apex_util.set_security_group_id(p_security_group_id =>
c1.workspace_id);
end loop;

    l_body := 'To view the content of this message, please use an HTML enabled mail client.' || utl_tcp.crlf;

    l_body_html := '<html><body>' || utl_tcp.crlf ||
                   '<p>Please confirm your registration at <a href="' ||
                   apex_mail.get_instance_url || 'f?p='||v('APP_ID')||
                   ':103::CONFIRM:NO::NEWUSER,TOKEN:'||v('P102_EMAIL')||','||l_token||'">Registration Confirmation</a> page.</p>' || utl_tcp.crlf ||
                   '<p>Sincerely,<br />' || utl_tcp.crlf ||
                   'Yo Bro from Next Do''<br />' || utl_tcp.crlf ||
                   '<img src="http://zapt1.staticworld.net/images/article/2013/04/oracle-logo-100033308-gallery.png" alt="Oracle Logo"></p>' || utl_tcp.crlf ||
                   '</body></html>';
    apex_mail.send (
        p_to        => v('P102_EMAIL'),   -- change to your email address
        p_from      => 's.obermeyer@t-online.de', -- change to a real senders email address
        p_body      => l_body,
        p_body_html => l_body_html,
        p_subj      => 'Registration Confirmation' );
htp.p('User '||v('P102_EMAIL')||' successfully registered.');
apex_util.set_session_state('P102_EMAIL', v('P102_EMAIL'));
commit;
end;
*/

alter table apx$user_reg drop column apx_reg_attempt;
alter table apx$user_reg add apx_user_reg_attempt number default 1;
alter table apx$user_reg add apx_app_user_id number;
alter table apx$user_reg add apex_user_id number;
alter table apx$user_reg add constraint "APX$USREG_APP_USER_ID_FK" foreign key (apx_app_user_id) references "APX$USER"(apx_user_id) on delete cascade;


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
C_DEFAULT_TOKEN_VALID_FOR_HOUR constant pls_integer := 24;
C_DEFAULT_REG_ATTEMPTS constant pls_integer := 5;
C_DEFAULT_USER_EXCEEDED_STATUS constant pls_integer := 0;
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
        where APEX_CONFIG_ITEM = 'USER_REGISTRATION_ATTEMPTS';

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
    -- if max attempts reached set status to exceeded
    if (:new.apx_user_reg_attempt = l_user_reg_max_attempts) then
      :new.apx_user_status_id := l_user_status_exceeded_id;
    end if;
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
          l_user_status_exceeded_id
      into
          :new.apx_user_token_created,
          :new.apx_user_token_valid_until,
          :new.apx_user_token_ts,
          :new.apx_user_token,
          :new.apx_user_status_id
      from dual;
    end if;
end;
/


--------------------------------------------------------------------------------------------------------------------------------
-- APX$USER_REG Update Reg Attempt Count
create or replace trigger "APX$USRREG_BU_REG_CNT_TRG"
before update of apx_user_reg_attempt
on "APX$USER_REG"
referencing new as new
for each row
declare
l_domain varchar2(100);
l_token_valid_for_hours pls_integer;
l_user_status_id pls_integer;
l_enforce_valid_domain pls_integer;
C_DEFAULT_TOKEN_VALID_FOR_HOUR constant pls_integer := 24;
C_DEFAULT_USER_REGISTER_STATUS constant pls_integer := 0;
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
               APX_GET_TOKEN(l_domain),
               l_user_status_id
          into :new.apx_user_token_created,
               :new.apx_user_token_valid_until,
               :new.apx_user_token_ts,
               :new.apx_user_token,
               :new.apx_user_status_id
        from dual;
    end if;
exception when invalid_domain
          then RAISE_APPLICATION_ERROR (-20201, 'No valid Domain found.');
when others then
    rollback;
  raise;
end;
/

grant select on APEX_USER_REG_STATUS to "PUBLIC";
grant select on "APX$USER_REG" to "PUBLIC";
grant select on "APX$STATUS" to "PUBLIC";


DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'APXUSR',
                       p_object => 'APX$USER_REG',
                       p_object_type => 'TABLE',
                       p_object_alias => 'apex_user_reg',
                       p_auto_rest_auth => TRUE);

    commit;

END;
/

DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'APXUSR',
                       p_object => 'APX$STATUS',
                       p_object_type => 'TABLE',
                       p_object_alias => 'apex_user_status',
                       p_auto_rest_auth => TRUE);

    commit;

END;
/

grant execute on "IS_VALID_DOMAIN" to public;

--------------------------------------------------------------------------------------------------------------------------------
-- re-register
declare
p_username varchar2(64) := 's.obermeyer@t-online.de';
-- local
C_DEFAULT_USER_REGISTER_STATUS constant pls_integer := 0;
l_user_status_id pls_integer;
l_domain varchar2(128);
l_enforce_valid_domain pls_integer;
invalid_domain exception;
begin
  begin
       select apex_status_id
        into l_user_status_id
        from "APEX_STATUS"
        where apex_status = 'REGISTERED';
    exception when no_data_found then
      l_user_status_id := C_DEFAULT_USER_REGISTER_STATUS;
  end;
  begin
    select apex_user_domain
    into l_domain
    from "APEX_USER_REGISTRATIONS"
    where upper(trim(nvl(apex_username, apex_user_email))) =
    upper(trim(p_username));
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
  update "APX$USER_REG"
  set apx_user_token = apx_get_token(l_domain), apx_user_status_id = l_user_status_id
  where upper(trim(nvl(apx_username, apx_user_email))) = upper(trim(p_username));
  commit;
exception when invalid_domain
then RAISE_APPLICATION_ERROR (-20201, 'No valid Domain found.');
when others then
rollback;
raise;
end;
/





--------------------------------------------------------------------------------------------------------------------------------

select apex_user_domain
--   into l_domain
from "APEX_USER_REGISTRATIONS"
where upper(trim(nvl(apex_username, apex_user_email))) = upper(trim(:p_username));


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

select to_timestamp(apx_user_token_created), to_timestamp(to_date('01.01.1900', 'DD.MM.YYYY'))
from APX$USER_REG
where apx_user_id = 111;

select apex_config_item_value
--    into l_token_valid_for_hours
from "APEX_CONFIGURATION"
where  apex_config_item = 'USER_TOKEN_VALID_FOR_HOURS'
and apex_config_item_value = 24;

create index "APX$CFG_ITEM_IDX" on "APX$CFG" (apx_config_name);
create index "APX$CFG_ITEM_VAL_IDX" on "APX$CFG" (apx_config_name, nvl(apx_config_value, apx_config_def_value));

        select apex_config_item_value
       -- into l_user_reg_max_attempts
        from "APEX_CONFIGURATION"
        where APEX_CONFIG_ITEM = 'USER_REGISTRATION_ATTEMPTS'
        union all
        select apex_config_item_value
       -- into l_token_valid_for_hours
        from "APEX_CONFIGURATION"
        where  apex_config_item = 'USER_TOKEN_VALID_FOR_HOURS';
/
create index "APX$CTX_CONTEXT_IDX" on "APX$CTX"(apx_context);

select apx_context_id
--into :new.apx_user_context_id
from "APX$CTX"
where apx_context = 'USER';



-----------------------------------------------------------------------------------------------------

set define on;

