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
                 and apx_user_token_valid_until >= sysdate) loop
        l_return := case c1.token_valid when 1 then true end;
    end loop;
    return l_return;
exception when others then
raise;
end;
/


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


begin
    if IS_VALID_RESET_TOKEN(:usr, :tkn) then
        dbms_output.put_line('is valid reset token');
    else
        dbms_output.put_line('is invalid reset token');
    end if;
end;
/

-----------------------------------------------------------------------------------------
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


/*
    l_token := replace(l_token, '#', '');
    l_token := replace(l_token, '+', '');
    l_token := replace(l_token, '=', '');
return l_token;
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
    , p_userid                      in       pls_integer     := null
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
    l_userid                        pls_integer;
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
                p_result := l_result_code;
                raise;
            end;
        else
            l_result_code := 2; -- No User Data for Token found.
            raise edit_user_error;
        end if;
    else
        l_result_code := 1; -- Invalid Token
        raise edit_user_error;
    end if;

exception when edit_user_error then
    p_result  := l_result_code;
when others then
    p_result := -1;
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





( user_id
, security_group_id
, user_name
, first_name
, last_name
, app_id
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
, l_app_id
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



-- Update Existing with Input Values if different
set
, user_id                        = coalesce(l_user_id, user_id)
, security_group_id              = coalesce(l_security_group_id, security_group_id)
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

-- Merge Existing NULLs with Inputs if not NULL
set
, user_id                        = coalesce(user_id, l_user_id)
, security_group_id              = coalesce(security_group_id, l_security_group_id)
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



, coalesce(user_id, l_user_id)
, coalesce(security_group_id, l_security_group_id)
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

            -- get a fresh ID from sequence
            if (l_userid is null) then 
                select "RAS_INTERN"."APEX_APP_USER_ID_SEQ".nextval
                into l_userid
                from dual;
            end if; 


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
                -- create local app user first
                insert into "RAS_INTERN"."APEX_APP_USER"  (
                    APP_USER_ID,
                    APP_USERNAME,
                    APP_USER_EMAIL,
                    APP_USER_DEFAULT_ROLE_ID,
                    APP_USER_CODE,
                    APP_USER_AD_LOGIN,
                    APP_USER_NOVELL_LOGIN,
                    APP_USER_FIRST_NAME,
                    APP_USER_LAST_NAME,
                    APP_USER_ADRESS,
                    APP_USER_PHONE1,
                    APP_USER_PHONE2,
                    APP_USER_DESCRIPTION,
                    APP_USER_STATUS_ID,
                    APP_USER_PARENT_USER_ID,
                    APP_ID,
                    APP_USER_TOKEN,
                    APP_USER_TOKEN_LAST_UPDATE,
                    APP_USER_DOMAIN_ID,
                    APP_USER_MELDER_ID) 
                ( select 
                    l_userid,
                    APX_USERNAME,
                    APX_USER_EMAIL,
                    APX_USER_DEFAULT_ROLE_ID,
                    APX_USER_CODE,
                    APX_USER_AD_LOGIN,
                    APX_USER_HOST_LOGIN,
                    APX_USER_FIRST_NAME,
                    APX_USER_LAST_NAME,
                    APX_USER_ADRESS,
                    APX_USER_PHONE1,
                    APX_USER_PHONE2,
                    APX_USER_DESCRIPTION,
                    (select  STATUS_ID
                        from "RAS_INTERN"."APEX_STATUS"
                        where status = 'OPEN' 
                        and status_scope = 'ACCOUNT'),
                    APX_USER_PARENT_USER_ID,
                    C_TARGET_APP,
                    APX_USER_TOKEN,
                    APX_USER_TOKEN_CREATED,
                    APX_USER_DOMAIN_ID,
                    (select ras_melder_id 
                    from  "RAS_INTERN"."RAS_DOMAIN_GRUPPEN" 
                    where ras_domain_id = APX_USER_DOMAIN_ID)
                    from APEX_USER_REGISTRATION
                    where apx_user_token = l_token
                );
                
                commit;
                l_result_code := 0;
                
            exception when no_data_found then
                l_result_code := 2;
                l_result      := 'No User Data for Token found.';
                raise create_user_error;
            end;

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



/*
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
*/

 drop table "RAS_DOMAINEN" ;

--- rename VALID_DOMAINS to RAS_DOMAINEN;
 create table "RAS_DOMAINEN" (
  "DOMAIN_ID" number not null, 
	"DOMAIN" varchar2(128), 
  "DOMAIN_OWNER" varchar2(512),
	"DOMAIN_CODE" varchar2(32),
  "DNS_NOT_RESOLVED" NUMBER,
	"MODIFIED" date, 
	"MODIFIED_BY" varchar2(30 byte), 
	"CREATED" date, 
	"CREATED_BY" varchar2(30 byte), 
	"GRUPPEN_ID" number,
  "DELETED" date,
  "DELETED_BY" varchar2(30 byte), 
  constraint "VALID_DOMAINS_PK" primary key ("DOMAIN_ID"),
  constraint "RAS_GRP_FK" foreign key ("GRUPPEN_ID") references "RAS_GRUPPEN" ("GRUPPEN_ID") on delete set null
);

drop sequence "VALID_DOMAINS_ID_SEQ";
create sequence "VALID_DOMAINS_ID_SEQ"  increment by 1 start with 69 nocache noorder nocycle;

-- regular before Update Insert Trigger
create or replace trigger "VALID_DOMAINS_BIU_TRG" 
before insert or update on "RAS_DOMAINEN"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.domain_id is null) then
        select valid_domains_id_seq.nextval
        into :new.domain_id
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

drop trigger "VALID_DOMAINS_BD_TRG" ;

create or replace trigger "VALID_DOMAINS_BD_TRG" 
before delete on "RAS_DOMAINEN"
referencing old as old new as new
for each row
  declare
  pragma autonomous_transaction;
  begin
    UPDATE  "APEX_APP_USER"
    SET APP_USER_STATUS_ID = (select app_status_id 
                                                  from "APEX_APP_STATUS" 
                                                  where app_status = 'LOCKED' )
    WHERE domain_id = :old.domain_id;
    UPDATE  "RAS_DOMAINEN"
    SET DELETED = sysdate,
           DELETED_BY = nvl(v('APP_USER'), user)
    where DOMAIN_ID = :old.domain_id;
    commit;
    RAISE_APPLICATION_ERROR (-20002, 'Domainen Daten koennen nicht gel�scht werden!', TRUE); 
  end;
/

create or replace view "RAS_DOMAINS"
as 
  select 
  domain_id,
  domain,
  domain_owner,
  domain_code,
  dns_not_resolved,
  modified,
  modified_by,
  created,
  created_by,
  deleted,
  deleted_by
from "RAS_DOMAINEN"
order by 1;

--INSERT INTO "RAS_DOMAINEN" (
--    DOMAIN_ID,
--    DOMAIN,
--    DOMAIN_OWNER,
--    DOMAIN_CODE,
--    DNS_NOT_RESOLVED,
--    MODIFIED,
--    MODIFIED_BY,
--    CREATED,
--    CREATED_BY)
--  (select  DOMAIN_ID,
--    DOMAIN,
--    DOMAIN_OWNER,
--    DOMAIN_CODE,
--    DNS_NOT_RESOLVED,
--    MODIFIED,
--    MODIFIED_BY,
--    CREATED,
--    CREATED_BY
--    from "BUNDESDOMAINEN");
--
--commit;

DROP SEQUENCE "RAS_DOMAINS_ID_SEQ";

CREATE SEQUENCE  "RAS_DOMAINS_ID_SEQ"  INCREMENT BY 1 START WITH 70 NOCACHE  NOORDER  NOCYCLE ;

CREATE SEQUENCE  "RAS_INTERN"."APX$APP_USERS_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;

CREATE OR REPLACE TRIGGER "VALID_DOMAINS_BIU_TRG" 
before insert or update on "RAS_DOMAINEN"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.domain_id is null) then
        select ras_domains_id_seq.nextval
        into :new.domain_id
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


create or replace view "RAS_DOMAIN_GRUPPEN"
as 
  select 
  r.DOMAIN_ID,
  r.DOMAIN,
  r.DOMAIN_CODE,
  r.DOMAIN_OWNER,
  r.DOMAIN_GROUP_ID as RAS_GRUPPEN_ID,
  g.INFO_GRUPPE as RAS_GRUPPE,
  g.INFO_GRUPPE_CODE as RAS_GRUPPEN_CODE
from "RAS_DOMAINEN" r left outer join "RAS_GRUPPEN" g
on (r.DOMAIN_GROUP_ID = g.GRUPPEN_ID);



alter table AMF_VORGANG modify AMF_MELDUNG_STATUS default 1;
alter table APEX_APP_USER add APP_USER_DOMAIN_ID number;
alter table APEX_APP_USER add constraint "APP_USER_DOMAIN_FK" foreign key (APP_USER_DOMAIN_ID) references  "RAS_DOMAINEN"(domain_id);



create or replace trigger "AMF_VORGANG_BIU_TRG"
before insert or update on "AMF_VORGANG"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.ID_VORGANG is null) then
        select AMF_VORGANG_SEQ.nextval
        into :new.ID_VORGANG
        from dual;
        :new.AMF_MELDUNG_STATUS := 1;
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

alter table AMF_VORGANG add ART_DER_ZUSTAENDIGKEIT varchar2(200);
alter table AMF_VORGANG add ART_DER_ZUSTAENDIGKEIT_SONST varchar2(1000);


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
    if (:new.app_user_domain_id is null or :new.app_user_group_id is null) then
        select d.domain_id, d.domain_group_id
        into :new.app_user_domain_id, :new.app_user_group_id
        from "RAS_DOMAINEN" d
        where lower(trim(d.domain)) = lower(substr(:new.app_user_email, instr(:new.app_user_email, '@') +1));
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


update "APEX_APP_USER" u set u.app_user_domain_id = 
(select d.domain_id 
from "RAS_DOMAINEN" d 
where lower(d.domain) = lower(substr(u.app_user_email, instr(u.app_user_email, '@') +1))
);

commit;

--- Status View New
create or replace view "APEX_STATUS"
as 
  select 
  app_id,
  app_status_id as status_id,
  app_status as status,
  app_status_code as status_code,
  app_status_scope as status_scope,
  is_default,
  created,
  created_by,
  modified,
  modified_by
from "APEX_APP_STATUS"
where app_id = nvl(v('APP_ID'), app_id)
order by 1, 3;


create or replace view "APEX_STATUS_DEFAULT"
as 
  select 
  app_id,
  app_status_id as status_id,
  app_status as status,
  app_status_code as status_code,
  app_status_scope as status_scope,
  is_default,
  created,
  created_by,
  modified,
  modified_by
from "APEX_APP_STATUS"
where app_id = nvl(v('APP_ID'), app_id)
and is_default = 1
order by 1, 3;


CREATE OR REPLACE VIEW "APEX_ALL_USERS"
  AS 
  select distinct
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
  u.MODIFIED_BY,
  u.DELETED,
  u.DELETED_BY
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


GRANT SELECT ON "RAS_INTERN"."APEX_ALL_USERS" TO "APEX_ADMIN";


CREATE OR REPLACE VIEW "APEX_APPLICATION_USERS"
AS 
  select APP_ID,
  APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_ACCOUNT_STATUS,
  APP_USER_AD_LOGIN as AD_LOGIN,
  APP_USER_NOVELL_LOGIN as NOVELL_LOGIN,
  APP_USER_DEFAULT_ROLE_ID,
  DEFAULT_ROLE,
  APP_USER_PARENT_USER_ID,
  PARENT_USERNAME,
  APP_USER_DEFAULT_ROLE_ID as USER_DEFAULT_SECURITY_LEVEL,
  MAX_SECURITY_LEVEL as USER_MAX_SECURITY_LEVEL,
  MIN_SECURITY_LEVEL as USER_MIN_SECURITY_LEVEL,  
  CREATED,
  CREATED_BY,
  MODIFIED,
  MODIFIED_BY,
  DELETED,
  DELETED_BY
from "APEX_ALL_USERS"
where APP_ID = nvl(v('APP_ID'), app_id)
order by 2 desc
;


GRANT SELECT ON "RAS_INTERN"."APEX_APPLICATION_USERS" TO "APEX_ADMIN";


alter table DOKUMENTE add DELETED date;
alter table DOKUMENTE add DELETED_BY varchar2(30);

alter table BOB_LAENDER_ROW_ERGAENZUNGEN add DELETED date;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN add DELETED_BY varchar2(30);


create or replace procedure "RAS_SOFT_DELETE" (
p_table in varchar2,
p_id number,
p_msg in varchar2 :=' k�nnen nicht gel�scht werden!',
p_new_status varchar2 := 'LOCKED'
) is
pragma autonomous_transaction;
l_status_id pls_integer;
l_msg varchar2(1000);
begin
    select app_status_id into l_status_id
    from "APEX_APP_STATUS"
    where app_status = upper(nvl(p_new_status, 'LOCKED'));
    if (upper(p_table) = 'APEX_APP_USER') then
        l_msg := 'Benutzer'||p_msg;
        commit;
        update  "APEX_APP_USER"
        set deleted  = sysdate,
              deleted_by  = nvl(v('APP_USER'), user),
              app_user_status_id = l_status_id
        where APP_USER_ID = p_id;
    elsif  (upper(p_table) = 'RAS_DOMAINEN') then
        l_msg := 'Domainen'||p_msg;
        commit;
        update  "APEX_APP_USER"
        set deleted  = sysdate,
              deleted_by  = nvl(v('APP_USER'), user),
              app_user_status_id = l_status_id
        where app_user_domain_id  = p_id;
        update "RAS_DOMAINEN"
        set deleted = sysdate,
              deleted_by     = nvl(v('APP_USER'), user)
        where domain_id = p_id;
    elsif (upper(p_table) = 'AMF_VORGANG') then
        l_msg := 'RAS Vorg�nge'||p_msg;
        commit;
        UPDATE "AMF_VORGANG"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user),
              AMF_MELDUNG_STATUS = l_status_id
        where ID_VORGANG = p_id;    
    elsif (upper(p_table) = 'DOKUMENTE') then
        l_msg := 'RAS Vorgangsdokumente'||p_msg;
        commit;
        UPDATE "DOKUMENTE"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user)
        where ID_VORGANG = p_id;    
    elsif (upper(p_table) = 'BOB_LAENDER_ROW_DOKUMENTE') then
        l_msg := 'RAS Vorgangsdokumente'||p_msg;
        commit;
        UPDATE "BOB_LAENDER_ROW_DOKUMENTE"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user)
        where ID_VORGANG = p_id;   
    elsif (upper(p_table) = 'BOB_LAENDER_ROW_ERGAENZUNGEN') then
        l_msg := 'RAS VorgangsERGAENZUNGEN'||p_msg;
        commit;
        UPDATE "BOB_LAENDER_ROW_ERGAENZUNGEN"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user)
        where ID_VORGANG = p_id;    
    end if;        
    commit;
    RAISE_APPLICATION_ERROR (-20002, l_msg, TRUE);
end;
/

/*

begin "RAS_SOFT_DELETE" ('APEX_APP_USER', 4); end;
/

begin "RAS_SOFT_DELETE" ('RAS_DOMAINEN', 70); end;
/

begin "RAS_SOFT_DELETE" ('AMF_VORGANG', 73); end;
/

delete from apex_app_user where app_user_id = 4; -- testuser
delete from RAS_DOMAINEN where domain_id = 70; -- testuser

*/


-- Dokumente Soft Delete Trigger
--drop  trigger "DOKUMENTE_BD_TRG";

create or replace trigger "DOKUMENTE_BD_TRG" 
before delete on "DOKUMENTE"
referencing old as old new as new
for each row
  declare
  pragma autonomous_transaction;
  begin
      "RAS_SOFT_DELETE" ('DOKUMENTE', :old.id_vorgang);
  end;
/


-- Dokumente Soft Delete Trigger
--drop  trigger "BOBLR_DOKUMENTE_BD_TRG";

create or replace trigger "BOBLR_DOKUMENTE_BD_TRG" 
before delete on "BOB_LAENDER_ROW_DOKUMENTE"
referencing old as old new as new
for each row
  declare
  pragma autonomous_transaction;
  begin
      "RAS_SOFT_DELETE" ('BOB_LAENDER_ROW_DOKUMENTE', :old.id_vorgang);
  end;
/

-- Dokumente Soft Delete Trigger
--drop  trigger "BOBLR_DOKUMENTE_BD_TRG";

create or replace trigger "BOBLR_ERGAENZ_BD_TRG" 
before delete on "BOB_LAENDER_ROW_ERGAENZUNGEN"
referencing old as old new as new
for each row
  declare
  pragma autonomous_transaction;
  begin
      "RAS_SOFT_DELETE" ('BOB_LAENDER_ROW_ERGAENZUNGEN', :old.id_vorgang);
  end;
/

-- Domain Soft Delete Trigger
--drop  trigger "VALID_DOMAINS_BD_TRG";

create or replace trigger "VALID_DOMAINS_BD_TRG" 
before delete on "RAS_DOMAINEN"
referencing old as old new as new
for each row
  declare
  pragma autonomous_transaction;
  begin
      "RAS_SOFT_DELETE" ('RAS_DOMAINEN', :old.domain_id);
  end;
/


-- User Soft Delete Trigger
--drop trigger "USER_BD_TRG" ;

create or replace trigger "USER_BD_TRG" 
before delete on "APEX_APP_USER"
referencing old as old new as new
for each row
declare
  pragma autonomous_transaction;
begin
  "RAS_SOFT_DELETE" ('APEX_APP_USER', :old.app_user_id);
end;
/


-- RAS Meldung Soft Delete Trigger
--drop  trigger "AMF_MELDUNG_BD_TRG";

create or replace trigger "AMF_MELDUNG_BD_TRG" 
before delete on "AMF_VORGANG"
referencing old as old new as new
for each row
declare
  pragma autonomous_transaction;
begin
      "RAS_SOFT_DELETE" ('AMF_VORGANG', :old.id_vorgang);
end;
/


-- User Soft Delete Trigger
drop trigger "AMF_STATUS_TRG" ;

create or replace trigger "AMF_STATUS_TRG" 
before update of AMF_MELDUNG_STATUS on "AMF_VORGANG"
referencing old as old new as new
for each row
begin
    if (:new.AMF_MELDUNG_STATUS = 2) then -- locked
      :new.DELETED := sysdate;
      :new.DELETED_BY := nvl(v('APP_USER'), user);
    elsif (:new.AMF_MELDUNG_STATUS = 1) then -- opened
      :new.DELETED := null;
      :new.DELETED_BY := null;
    end if;
end;
/


drop trigger "AMF_DEL_TRG" ;

create or replace trigger "AMF_DEL_TRG" 
before update of DELETED, DELETED_BY on "AMF_VORGANG"
referencing old as old new as new
for each row
begin
    if (:new.DELETED is not null) then -- locked
      :new.AMF_MELDUNG_STATUS := 2;
    end if;
end;
/


alter table amf_vorgang modify deleted_by varchar2(30) default user;
update amf_vorgang set DELETED_BY = user where DELETED is not null;
commit;

alter table amf_vorgang add amf_meldung_status number default null;
alter table amf_vorgang drop column amf_meldung_status;

update amf_vorgang set amf_meldung_status = 2 where DELETED is not null;
update amf_vorgang set amf_meldung_status = 1 where DELETED is null;

commit;


alter table dokumente add user_id number;  
alter table dokumente add domain_id number;  
  
alter table dokumente add constraint "DOK_USER_ID_FK" foreign key(user_id) references APEX_APP_USER(app_user_id);  
alter table dokumente add constraint "DOK_DOMAIN_ID_FK" foreign key(domain_id) references RAS_DOMAINEN(domain_id);

drop view "RAS_ALLE_DOKUMENTE";

create view "RAS_ALLE_DOKUMENTE"
as
SELECT 
  ID,
  ID_VORGANG,
  'BFARM' as MELDENDE_BEHOERDE,
  DATEINAME,
  DOKUMENTEN_INHALT,
  DATEIINHALT,
  MIMETYPE,
  MODIFIED,
  MODIFIED_BY,
  CREATED,
  CREATED_BY,
  DELETED,
  DELETED_BY,
  USER_ID,
  RAS_MELDER_ID
FROM DOKUMENTE
union all
SELECT 
  ID,
  ID_VORGANG,
  MELDENDE_BEHOERDE,
  DATEINAME,
  DOKUMENTEN_INHALT,
  DATEIINHALT,
  MIMETYPE,
  MODIFIED,
  MODIFIED_BY,
  CREATED,
  CREATED_BY,
  DELETED,
  DELETED_BY,
  USER_ID,
  RAS_MELDER_ID
FROM BOB_LAENDER_ROW_DOKUMENTE ;

select * from ras_alle_dokumente
where ID_VORGANG=87 and ID = 10;



SELECT 
  ID,
  ID_VORGANG,
  MELDENDE_BEHOERDE,
  DATEINAME,
  DOKUMENTEN_INHALT,
  MIMETYPE,
  count(1) over (partition by id_vorgang) as anzahl_fall_dokumente,
  MODIFIED,
  MODIFIED_BY,
  CREATED,
  CREATED_BY,
  DELETED,
  DELETED_BY,
  USER_ID,
  DOMAIN_ID
FROM "RAS_ALLE_DOKUMENTE";

SELECT 
  ID_VORGANG,
  VORGANGSNUMMER,
  BEZEICHNUNG,
  MELDENDE_STELLE,
  EINGANGSDATUM,
  ERSTELLUNGSDATUM,
  STAAT_ID,
  BUNDESLAND_ID,
  BUNDESOBERBEHOERDE,
  BEMERKUNG
FROM "AMF_VORGANG" ;

create or replace view "MIME_TYPE_ICONS"
as 
select 
  b.mime_name,
  b.mime_template as mime_type,
  b.mime_group,
  a.icon_id,
  a.icon,
  a.icon_mime_type,
  a.icon_file_name,
  a.icon_charset,
  a.created,
  a.created_by,
  a.modified,
  a.modified_by
from "MIME_TYPES" b join "MIME_ICONS" a
on (a.icon_id = b.icon_id);


  GRANT SELECT ON "APEX_ADMIN"."MIME_TYPE_ICONS" TO PUBLIC;

with 
"VORGANG" as (
SELECT ID_VORGANG, BEZEICHNUNG,VORGANGSNUMMER
FROM "AMF_VORGANG"
    WHERE ID_VORGANG = nvl(:P40_ID_VORGANG, ID_VORGANG)
),
"ERGAENZ" as (
SELECT 
 BEMERKUNG, MELDENDE_BEHOERDE, ID_VORGANG, CREATED, MODIFIED
 FROM "BOB_LAENDER_ROW_ERGAENZUNGEN"
),
"MASSN" as (
SELECT 
  m.ID_VORGANG,
  m.MELDENDE_BEHOERDE,
  m.MASSNAHME_ID,
  amm.MASSNAHME,
  m.MASSNAHME_UMGESETZT,
  m.MASSNAHME_UMGESETZT_AM,
  m.MASSNAHME_SONSTIGE,
  m.MASSNAHME_BEMERKUNG
FROM "BOB_LAENDER_ROW_MASSNAHMEN" m LEFT JOIN "AMF_MASSNAHMEN" amm
ON (m.MASSNAHME_ID = amm.ID)
)
SELECT
  v.ID_VORGANG,
  v.VORGANGSNUMMER,
  v.BEZEICHNUNG as VORGANG,
  m.CODE,
  m.BEHOERDE
--  e.BEMERKUNG,
--  ms.MASSNAHME,
--  ms.MASSNAHME_UMGESETZT,
--  ms.  MASSNAHME_UMGESETZT_AM,
--  e.CREATED as erstellt,
--  e.MODIFIED as zuletzt_geaendert
FROM "RAS_MELDESTELLEN" m LEFT OUTER JOIN "VORGANG" v
ON (1 = 1)
LEFT OUTER JOIN "MASSN" ma
ON ( );


create or replace view "APEX_ALL_USERS"
as 
  select distinct
  u.APP_ID as APP_ID, 
  u.APP_USER_ID, 
  u.APP_USER_EMAIL, 
  u.APP_USERNAME, 
  a.STATUS as APP_USER_ACCOUNT_STATUS, 
  u.APP_USER_AD_LOGIN, 
  u.APP_USER_NOVELL_LOGIN, 
  u.APP_USER_DEFAULT_ROLE_ID, 
  ar.APP_ROLENAME as DEFAULT_ROLE,
  vd.DOMAIN_CODE,
  vd.DOMAIN,
  rg.INFO_GRUPPE_CODE as GRUPPEN_CODE,
  rg.INFO_GRUPPE as GRUPPE,
  u.APP_USER_PARENT_USER_ID, 
  (select au.app_username  
  from "APEX_APP_USER" au 
  where au.app_user_id = u.app_user_parent_user_id) as parent_username, 
  max(rm.app_role_id) over (partition by rm.app_user_id) as max_security_level,  
  min(rm.app_role_id) over (partition by rm.app_user_id) as min_security_level, 
  u.APP_USER_CODE, 
  vd.DOMAIN_ID,
  rg.GRUPPEN_ID,
  u.CREATED, 
  u.CREATED_BY, 
  u.MODIFIED, 
  u.MODIFIED_BY,
  u.DELETED,
  u.DELETED_BY
from "APEX_APP_USER" u  
left outer join  "APEX_ACCOUNT_STATUS" a 
on (u.APP_USER_STATUS_ID = a.status_id 
   and u.APP_ID = a.APP_ID) 
left outer join  "APEX_ROLES" ar 
on (ar.APP_ROLE_ID = u.APP_USER_DEFAULT_ROLE_ID 
    and ar.APP_ID = u.APP_ID) 
left outer join  "RAS_DOMAINEN" vd 
on (vd.DOMAIN_ID = u.APP_USER_DOMAIN_ID)
left outer join  "RAS_GRUPPEN" rg 
on (rg.GRUPPEN_ID = u.APP_USER_GROUP_ID)
left outer join "APEX_APP_USER_ROLE_MAP" rm 
on (u.APP_USER_ID = rm.APP_USER_ID 
    and u.APP_ID = rm.APP_ID);


GRANT SELECT ON "RAS_INTERN"."APEX_ALL_USERS" TO "APEX_ADMIN";


CREATE OR REPLACE FORCE VIEW "RAS_INTERN"."APEX_APP_SYS_BUILTINS"
AS 
  select  
  b.APP_ID, 
  b.APP_BUILTIN_ID, 
  b.APP_BUILTIN_PARENT_ID, 
  b.APP_USER_ID as APP_USER_ID, 
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
  b.APP_ROLE_ID as APP_USER_ID, 
  r.APP_ROLENAME as APP_BUILTIN_NAME, 
  r.APP_ROLE_CODE as APP_BUILTIN_CODE, 
  b.IS_ADMIN, 
  b.IS_PUBLIC, 
  b.IS_DEFAULT, 
  'ROLE' as APP_BUILTIN_TYPE 
FROM "APEX_SYS_BUILTINS" b join "APEX_ROLES" r 
on (b.APP_ROLE_ID = r.APP_ROLE_ID) 
where b.APP_ROLE_ID is not null 
  and b.APP_ID = v('APP_ID')
;


CREATE OR REPLACE VIEW "APEX_USERS"
AS 
  select 
  APP_ID,
  APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_ACCOUNT_STATUS as USER_ACCOUNT_STATUS,
  AD_LOGIN,
  NOVELL_LOGIN,
  DEFAULT_ROLE,
  PARENT_USERNAME,
  USER_DEFAULT_SECURITY_LEVEL as DEFAULT_SECURITY_LEVEL,
  USER_MAX_SECURITY_LEVEL as MAX_SECURITY_LEVEL,
  USER_MIN_SECURITY_LEVEL as MIN_SECURITY_LEVEL
from "APEX_APPLICATION_USERS"
order by 1, 2
;


GRANT SELECT ON "RAS_INTERN"."APEX_USERS" TO "APEX_ADMIN";



CREATE OR REPLACE VIEW "APEX_APPLICATION_USERS"
AS 
  select APP_ID,
  APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_ACCOUNT_STATUS,
  APP_USER_AD_LOGIN as AD_LOGIN,
  APP_USER_NOVELL_LOGIN as NOVELL_LOGIN,
  APP_USER_DEFAULT_ROLE_ID,
  DEFAULT_ROLE,
  DOMAIN_CODE, 
  DOMAIN, 
  GRUPPEN_CODE, 
  GRUPPE  
  APP_USER_PARENT_USER_ID,
  PARENT_USERNAME,
  APP_USER_DEFAULT_ROLE_ID as USER_DEFAULT_SECURITY_LEVEL,
  MAX_SECURITY_LEVEL as USER_MAX_SECURITY_LEVEL,
  MIN_SECURITY_LEVEL as USER_MIN_SECURITY_LEVEL,  
  CREATED,
  CREATED_BY,
  MODIFIED,
  MODIFIED_BY,
  DELETED,
  DELETED_BY
from "APEX_ALL_USERS"
where APP_ID = nvl(v('APP_ID'), app_id)
order by 2 desc;

GRANT SELECT ON "RAS_INTERN"."APEX_APPLICATION_USERS" TO "APEX_ADMIN";


CREATE OR REPLACE VIEW "APP_BUILTIN_ADMINS" ("APP_USERNAME", "APPLICATION_ROLE") AS 
select app_builtin_name as "APP_USERNAME", 'APPLICATION_BUILTIN_ADMIN_USER' as "APPLICATION_ROLE" 
from "APEX_APP_SYS_BUILTINS" 
where   app_builtin_type = 'USER' 
and is_admin = 1;

CREATE OR REPLACE VIEW "APEX_APP_BUILTIN_ADMINS" ("APP_USERNAME", "APPLICATION_ROLE") AS 
select app_builtin_name as "APP_USERNAME", 'APPLICATION_BUILTIN_ADMIN_USER' as "APPLICATION_ROLE" 
from "APEX_APP_SYS_BUILTINS" 
where   app_builtin_type = 'USER' 
and is_admin = 1;


create or replace view "APEX_APP_SYS_ROLES"
as 
  select
  APP_BUILTIN_ID,
  APP_BUILTIN_PARENT_ID,
  APP_ID,
  APP_USER_ID,
  APP_BUILTIN_NAME as APP_ROLENAME,
  APP_BUILTIN_CODE as APP_ROLE_CODE
from "APEX_APP_SYS_BUILTINS"
where APP_BUILTIN_TYPE = 'ROLE';

GRANT SELECT ON "APEX_APP_SYS_ROLES" TO "APEX_ADMIN";

create or replace view "APEX_APP_SYS_USERS"
as 
  select
  APP_BUILTIN_ID,
  APP_BUILTIN_PARENT_ID,
  APP_ID,
  APP_USER_ID,
  APP_BUILTIN_NAME as APP_USERNAME,
  APP_BUILTIN_CODE as APP_USER_CODE
from "APEX_APP_SYS_BUILTINS"
where APP_BUILTIN_TYPE = 'USER';

GRANT SELECT ON "RAS_INTERN"."APEX_APP_SYS_USERS" TO "APEX_ADMIN";


CREATE OR REPLACE VIEW "APEX_ALL_USERS"
AS 
  select distinct
  u.APP_ID as APP_ID, 
  u.APP_USER_ID, 
  u.APP_USER_EMAIL, 
  u.APP_USERNAME, 
  a.STATUS as APP_USER_ACCOUNT_STATUS, 
  u.APP_USER_AD_LOGIN, 
  u.APP_USER_NOVELL_LOGIN, 
  u.APP_USER_DEFAULT_ROLE_ID, 
  ar.APP_ROLENAME as DEFAULT_ROLE,
  vd.DOMAIN_CODE,
  vd.DOMAIN,
  rg.INFO_GRUPPE_CODE as GRUPPEN_CODE,
  rg.INFO_GRUPPE as GRUPPE,
  u.APP_USER_PARENT_USER_ID, 
  (select au.app_username  
  from "APEX_APP_USER" au 
  where au.app_user_id = u.app_user_parent_user_id) as parent_username, 
  max(rm.app_role_id) over (partition by rm.app_user_id) as max_security_level,  
  min(rm.app_role_id) over (partition by rm.app_user_id) as min_security_level, 
  u.APP_USER_CODE, 
  vd.DOMAIN_ID,
  rg.GRUPPEN_ID,
  u.CREATED, 
  u.CREATED_BY, 
  u.MODIFIED, 
  u.MODIFIED_BY,
  u.DELETED,
  u.DELETED_BY
from "APEX_APP_USER" u  
left outer join  "APEX_ACCOUNT_STATUS" a 
on (u.APP_USER_STATUS_ID = a.status_id 
   and u.APP_ID = a.APP_ID) 
left outer join  "APEX_ROLES" ar 
on (ar.APP_ROLE_ID = u.APP_USER_DEFAULT_ROLE_ID 
    and ar.APP_ID = u.APP_ID) 
left outer join  "RAS_DOMAINEN" vd 
on (vd.DOMAIN_ID = u.APP_USER_DOMAIN_ID)
left outer join  "RAS_GRUPPEN" rg 
on (rg.GRUPPEN_ID = u.APP_USER_GROUP_ID)
left outer join "APEX_APP_USER_ROLE_MAP" rm 
on (u.APP_USER_ID = rm.APP_USER_ID 
    and u.APP_ID = rm.APP_ID);

GRANT SELECT ON "RAS_INTERN"."APEX_ALL_USERS" TO "APEX_ADMIN";


CREATE OR REPLACE FORCE VIEW "APEX_APPLICATION_USERS"
AS 
  select APP_ID,
  APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_AD_LOGIN as AD_LOGIN,
  APP_USER_NOVELL_LOGIN as NOVELL_LOGIN,
  APP_USER_DEFAULT_ROLE_ID,
  DEFAULT_ROLE,
  DOMAIN_CODE, 
  DOMAIN, 
  GRUPPEN_CODE, 
  GRUPPE,
  APP_USER_ACCOUNT_STATUS,
  APP_USER_PARENT_USER_ID,
  PARENT_USERNAME,
  APP_USER_DEFAULT_ROLE_ID as USER_DEFAULT_SECURITY_LEVEL,
  MAX_SECURITY_LEVEL as USER_MAX_SECURITY_LEVEL,
  MIN_SECURITY_LEVEL as USER_MIN_SECURITY_LEVEL,  
  CREATED,
  CREATED_BY,
  MODIFIED,
  MODIFIED_BY,
  DELETED,
  DELETED_BY
from "APEX_ALL_USERS"
where APP_ID = nvl(v('APP_ID'), app_id)
order by 1, 2;


GRANT SELECT ON "RAS_INTERN"."APEX_APPLICATION_USERS" TO "APEX_ADMIN";


CREATE OR REPLACE VIEW "RAS_DOMAIN_GRUPPEN"
AS 
SELECT 
  r.DOMAIN_ID,
  r.DOMAIN,
  r.DOMAIN_CODE,
  r.DOMAIN_OWNER,
  r.DOMAIN_GROUP_ID as RAS_GRUPPEN_ID,
  g.INFO_GRUPPE as RAS_GRUPPE,
  g.INFO_GRUPPE_CODE as RAS_GRUPPEN_CODE
FROM "RAS_DOMAINEN" r LEFT OUTER JOIN "RAS_GRUPPEN" g
ON (r.DOMAIN_GROUP_ID = g.GRUPPEN_ID)
ORDER BY 1;


create or replace view "RAS_DOMAINS"
as 
  select 
  rd.domain_id,
  rd.domain,
  rd.domain_owner,
  rd.domain_code,
  case rd.dns_not_resolved when 1 then 'Ja' else 'Nein' end as dns_gueltig,
  s.status,
  rd.modified,
  rd.modified_by,
  rd.created,
  rd.created_by,
  rd.deleted,
  rd.deleted_by
from "RAS_DOMAINEN" rd LEFT OUTER JOIN "APEX_STATUS" s
on (rd.status_id = s.status_id)
order by 1;

create or replace view "RAS_VALID_DOMAINS"
as 
select DOMAIN_ID,
  DOMAIN,
  DOMAIN_OWNER,
  DOMAIN_CODE,
  DNS_GUELTIG,
  CASE STATUS WHEN 'VALID' Then 'Gueltig' else 'Ungueltig' end as DOMAINEN_STATUS,
  MODIFIED,
  MODIFIED_BY,
  CREATED,
  CREATED_BY,
  DELETED,
  DELETED_BY
FROM "RAS_DOMAINS" 
WHERE STATUS = 'VALID';


create or replace view "APEX_ADMINS" ("APP_USERNAME", "APPLICATION_ROLE") 
as 
select app_username, application_role from "APPLICATION_ADMINS"
union
select user_name, application_role from "WORKSPACE_ADMINS";


GRANT SELECT ON "RAS_INTERN"."APEX_ADMINS" TO "APEX_ADMIN";


SELECT BEZEICHNUNG as d,
             ID_VORGANG as r
FROM "AMF_VORGANG" ;


alter table "APEX_APP_USER" drop column DOMAIN_ID;

alter table "APEX_APP_USER" add APP_USER_DOMAIN_ID number;
alter table "APEX_APP_USER" add APP_USER_GROUP_ID number;

alter table "APEX_APP_USER" add constraint "APP_USER_DOMAIN_FK" foreign key (APP_USER_DOMAIN_ID) references RAS_DOMAINEN (domain_id);
alter table "APEX_APP_USER" add constraint "APP_USER_GROUP_FK" foreign key (APP_USER_GROUP_ID) references RAS_GRUPPEN (gruppen_id);


update APEX_APP_USER u
set u.app_user_domain_id = (
select d.domain_id
from RAS_DOMAINEN d
where d.domain = substr(u.app_user_email, instr(u.app_user_email, '@')+1)
);

update APEX_APP_USER u
set u.app_user_group_id = (
select d.domain_group_id
from RAS_DOMAINEN d
where d.domain = substr(u.app_user_email, instr(u.app_user_email, '@')+1)
);

commit;


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
    if (:new.app_user_domain_id is null or :new.app_user_group_id is null) then
        select d.domain_id, d.domain_group_id into :new.app_user_domain_id, :new.app_user_group_id
        from "RAS_DOMAINEN" d
        where lower(trim(d.domain)) =lower(substr(:new.app_user_email, instr(:new.app_user_email, '@') +1));
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

alter table RAS_DOMAINEN add domain_group_id number;
alter table RAS_DOMAINEN add domain_bundesland_id number;
alter table RAS_DOMAINEN add constraint  "RAS_DOMAIN_GRP_FK" foreign key(domain_group_id) references "RAS_GRUPPEN"(gruppen_id) on delete set null;
alter table RAS_DOMAINEN add constraint  "RAS_DOMAIN_BL_FK" foreign key(domain_bundesland_id) references "BUNDESLAENDER"(bundesland_id) on delete set null;





create or replace view "RAS_USERS"
as
select 
  usr.app_user_id,
  usr.app_user_email,
  usr.app_username,
  usr.app_user_code,
  usr.app_user_account_status,
  usr.domain_code,
  usr.gruppen_code
from "APEX_APPLICATION_USERS" usr
where usr.app_user_email = (select u.APP_USER_EMAIL 
                                            from "APEX_APPLICATION_USERS" u
                                            where upper(trim(u.app_username)) = 
                                                       upper(trim(nvl(v('APP_USER'), usr.app_username))))
and usr.app_user_account_status = 'OPEN'
;


create or replace view "RAS_INTERN"."APEX_ALL_USERS" 
as 
  select distinct
  u.APP_ID as APP_ID, 
  u.APP_USER_ID, 
  u.APP_USER_EMAIL, 
  u.APP_USERNAME, 
  a.STATUS as APP_USER_ACCOUNT_STATUS, 
  u.APP_USER_AD_LOGIN, 
  u.APP_USER_NOVELL_LOGIN, 
  u.APP_USER_DEFAULT_ROLE_ID, 
  ar.APP_ROLENAME as DEFAULT_ROLE,
  vd.DOMAIN_CODE,
  vd.DOMAIN,
  rg.INFO_GRUPPE_CODE as GRUPPEN_CODE,
  rg.INFO_GRUPPE as GRUPPE,
  u.APP_USER_PARENT_USER_ID, 
  (select au.app_username  
  from "APEX_APP_USER" au 
  where au.app_user_id = u.app_user_parent_user_id) as parent_username, 
  max(rm.app_role_id) over (partition by rm.app_user_id) as max_security_level,  
  min(rm.app_role_id) over (partition by rm.app_user_id) as min_security_level, 
  u.APP_USER_CODE, 
  vd.DOMAIN_ID,
  rg.GRUPPEN_ID,
  u.CREATED, 
  u.CREATED_BY, 
  u.MODIFIED, 
  u.MODIFIED_BY,
  u.DELETED,
  u.DELETED_BY
from "APEX_APP_USER" u  
left outer join  "APEX_ACCOUNT_STATUS" a 
on (u.APP_USER_STATUS_ID = a.status_id 
   and u.APP_ID = a.APP_ID) 
left outer join  "APEX_ROLES" ar 
on (ar.APP_ROLE_ID = u.APP_USER_DEFAULT_ROLE_ID 
    and ar.APP_ID = u.APP_ID) 
left outer join  "RAS_DOMAINS" vd 
on (vd.DOMAIN_ID = u.APP_USER_DOMAIN_ID)
left outer join  "RAS_GRUPPEN" rg 
on (rg.GRUPPEN_ID = u.APP_USER_GROUP_ID)
left outer join "APEX_APP_USER_ROLE_MAP" rm 
on (u.APP_USER_ID = rm.APP_USER_ID 
    and u.APP_ID = rm.APP_ID);


GRANT SELECT ON "RAS_INTERN"."APEX_ALL_USERS" TO "APEX_ADMIN";




CREATE OR REPLACE FORCE VIEW "RAS_INTERN"."APEX_APP_SYS_BUILTINS"
AS 
  select  
  b.APP_ID, 
  b.APP_BUILTIN_ID, 
  b.APP_BUILTIN_PARENT_ID, 
  b.APP_USER_ID as APP_USER_ID, 
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
  b.APP_ROLE_ID as APP_USER_ID, 
  r.APP_ROLENAME as APP_BUILTIN_NAME, 
  r.APP_ROLE_CODE as APP_BUILTIN_CODE, 
  b.IS_ADMIN, 
  b.IS_PUBLIC, 
  b.IS_DEFAULT, 
  'ROLE' as APP_BUILTIN_TYPE 
FROM "APEX_SYS_BUILTINS" b join "APEX_ROLES" r 
on (b.APP_ROLE_ID = r.APP_ROLE_ID) 
where b.APP_ROLE_ID is not null 
  and b.APP_ID = v('APP_ID')
;


CREATE OR REPLACE VIEW "APEX_USERS"
AS 
  select 
  APP_ID,
  APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_ACCOUNT_STATUS as USER_ACCOUNT_STATUS,
  AD_LOGIN,
  NOVELL_LOGIN,
  DEFAULT_ROLE,
  PARENT_USERNAME,
  USER_DEFAULT_SECURITY_LEVEL as DEFAULT_SECURITY_LEVEL,
  USER_MAX_SECURITY_LEVEL as MAX_SECURITY_LEVEL,
  USER_MIN_SECURITY_LEVEL as MIN_SECURITY_LEVEL
from "APEX_APPLICATION_USERS"
order by 1, 2
;


GRANT SELECT ON "RAS_INTERN"."APEX_USERS" TO "APEX_ADMIN";



CREATE OR REPLACE VIEW "APEX_APPLICATION_USERS"
AS 
  select APP_ID,
  APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_ACCOUNT_STATUS,
  APP_USER_AD_LOGIN as AD_LOGIN,
  APP_USER_NOVELL_LOGIN as NOVELL_LOGIN,
  APP_USER_DEFAULT_ROLE_ID,
  DEFAULT_ROLE,
  DOMAIN_CODE, 
  DOMAIN, 
  GRUPPEN_CODE, 
  GRUPPE  
  APP_USER_PARENT_USER_ID,
  PARENT_USERNAME,
  APP_USER_DEFAULT_ROLE_ID as USER_DEFAULT_SECURITY_LEVEL,
  MAX_SECURITY_LEVEL as USER_MAX_SECURITY_LEVEL,
  MIN_SECURITY_LEVEL as USER_MIN_SECURITY_LEVEL,  
  CREATED,
  CREATED_BY,
  MODIFIED,
  MODIFIED_BY,
  DELETED,
  DELETED_BY
from "APEX_ALL_USERS"
where APP_ID = nvl(v('APP_ID'), app_id)
order by 2 desc;


GRANT SELECT ON "RAS_INTERN"."APEX_APPLICATION_USERS" TO "APEX_ADMIN";

CREATE OR REPLACE FORCE VIEW "RAS_INTERN"."APP_BUILTIN_ADMINS" ("APP_USERNAME", "APPLICATION_ROLE") AS 
select app_builtin_name as "APP_USERNAME", 'APPLICATION_BUILTIN_ADMIN_USER' as "APPLICATION_ROLE" 
from "APEX_APP_SYS_BUILTINS" 
where   app_builtin_type = 'USER' 
and is_admin = 1
;

CREATE OR REPLACE FORCE VIEW "RAS_INTERN"."APEX_APP_BUILTIN_ADMINS" ("APP_USERNAME", "APPLICATION_ROLE") AS 
select app_builtin_name as "APP_USERNAME", 'APPLICATION_BUILTIN_ADMIN_USER' as "APPLICATION_ROLE" 
from "APEX_APP_SYS_BUILTINS" 
where   app_builtin_type = 'USER' 
and is_admin = 1
;

  CREATE OR REPLACE FORCE VIEW "RAS_INTERN"."APEX_APP_SYS_ROLES" ("APP_BUILTIN_ID", "APP_BUILTIN_PARENT_ID", "APP_ID", "APP_USER_ID", "APP_ROLENAME", "APP_ROLE_CODE") AS 
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

GRANT SELECT ON "RAS_INTERN"."APEX_APP_SYS_ROLES" TO "APEX_ADMIN";

CREATE OR REPLACE FORCE VIEW "RAS_INTERN"."APEX_APP_SYS_USERS" ("APP_BUILTIN_ID", "APP_BUILTIN_PARENT_ID", "APP_ID", "APP_USER_ID", "APP_USERNAME", "APP_USER_CODE") AS 
  select
  APP_BUILTIN_ID,
  APP_BUILTIN_PARENT_ID,
  APP_ID,
  APP_USER_ID,
  APP_BUILTIN_NAME as APP_USERNAME,
  APP_BUILTIN_CODE as APP_USER_CODE
from "APEX_APP_SYS_BUILTINS"
where APP_BUILTIN_TYPE = 'USER';

GRANT SELECT ON "RAS_INTERN"."APEX_APP_SYS_USERS" TO "APEX_ADMIN";


CREATE OR REPLACE FORCE VIEW "RAS_INTERN"."APEX_ADMINS" ("APP_USERNAME", "APPLICATION_ROLE") 
AS 
select app_username, application_role from "APPLICATION_ADMINS"
union
select user_name, application_role from "WORKSPACE_ADMINS";

GRANT SELECT ON "RAS_INTERN"."APEX_ADMINS" TO "APEX_ADMIN";


SELECT ID_VORGANG,
             BEZEICHNUNG
FROM AMF_VORGANG ;

SELECT MELDENDE_BEHOERDE FROM BOB_LAENDER_ROW_MASSNAHMEN;

SELECT DOMAIN_ID,
            DOMAIN
FROM RAS_DOMAINEN ;


CREATE OR REPLACE VIEW "RAS_BUNDESLAENDER"
AS 
  select 
  bundesland_id,
  bundesland,
  bundesland_code,
  bundesland_wappen,
  modified,
  modified_by,
  created,
  created_by
from "BUNDESLAENDER";

alter table BOB_LAENDER_ROW_DOKUMENTE add domain_id number;
alter table BOB_LAENDER_ROW_DOKUMENTE add constraint "DOKU_ERGAENZ_DOMAIN_ID_FK" foreign key (domain_id)
references "RAS_DOMAINEN" (domain_id);

alter table BOB_LAENDER_ROW_MASSNAHMEN add domain_id number;
alter table BOB_LAENDER_ROW_MASSNAHMEN add constraint "DOKU_MASSN_DOMAIN_ID_FK" foreign key (domain_id)
references "RAS_DOMAINEN" (domain_id);

alter table BOB_LAENDER_ROW_ERGAENZUNGEN add domain_id number;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN add constraint "DOKU_ERGAENZN_DOMAIN_ID_FK" foreign key (domain_id)
references "RAS_DOMAINEN" (domain_id);


drop index BLR_ERGAENZ_DOMAIN_ID_ID;
drop index BLR_MASSN_DOMAIN_ID_ID;
drop index BLR_DOKU_DOMAIN_ID_ID;

create index BLR_ERGAENZ_DOMAIN_ID_IDX on BOB_LAENDER_ROW_ERGAENZUNGEN (domain_id);
create index BLR_MASSN_DOMAIN_ID_IDX on BOB_LAENDER_ROW_MASSNAHMEN (domain_id);
create index BLR_DOKU_DOMAIN_ID_IDX on BOB_LAENDER_ROW_DOKUMENTE (domain_id);

create index BLR_ERGAENZ_USER_ID_IDX on BOB_LAENDER_ROW_ERGAENZUNGEN (user_id);
create index BLR_MASSN_USER_ID_IDX on BOB_LAENDER_ROW_MASSNAHMEN (user_id);
create index BLR_DOKU_USER_ID_IDX on BOB_LAENDER_ROW_DOKUMENTE (user_id);

alter table BOB_LAENDER_ROW_MASSNAHMEN modify user_id number;
alter table BOB_LAENDER_ROW_MASSNAHMEN drop constraint "BOB_MASSN_MELDER_ID_FK";
alter table BOB_LAENDER_ROW_MASSNAHMEN add constraint "BLR_MASSNAHME_USER_ID_FK" foreign key (user_id)
references "APEX_APP_USER" (app_user_id);

alter table BOB_LAENDER_ROW_ERGAENZUNGEN modify user_id number;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN drop constraint BOB_ERGAENZ_USER_ID_FK;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN add constraint "ERGAENZ_BOB_LNDR_ROW_USER_ID" foreign key (user_id)
references "APEX_APP_USER" (app_user_id);

alter table BOB_LAENDER_ROW_DOKUMENTE add domain_id number;
alter table BOB_LAENDER_ROW_DOKUMENTE add constraint "DOKU_ERGAENZ_DOMAIN_ID_FK" foreign key (domain_id)
references "RAS_DOMAINEN" (domain_id);

update BOB_LAENDER_ROW_DOKUMENTE set domain_id = 1;

commit;


alter table BOB_LAENDER_ROW_MASSNAHMEN add domain_id number;
alter table BOB_LAENDER_ROW_MASSNAHMEN add constraint "DOKU_MASSN_DOMAIN_ID_FK" foreign key (domain_id)
references "RAS_DOMAINEN" (domain_id);

alter table BOB_LAENDER_ROW_ERGAENZUNGEN add domain_id number;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN add constraint "DOKU_ERGAENZN_DOMAIN_ID_FK" foreign key (domain_id)
references "RAS_DOMAINEN" (domain_id);


drop index BLR_ERGAENZ_DOMAIN_ID_ID;
drop index BLR_MASSN_DOMAIN_ID_ID;
drop index BLR_DOKU_DOMAIN_ID_ID;

create index BLR_ERGAENZ_DOMAIN_ID_IDX on BOB_LAENDER_ROW_ERGAENZUNGEN (domain_id);
create index BLR_MASSN_DOMAIN_ID_IDX on BOB_LAENDER_ROW_MASSNAHMEN (domain_id);
create index BLR_DOKU_DOMAIN_ID_IDX on BOB_LAENDER_ROW_DOKUMENTE (domain_id);

create index BLR_ERGAENZ_USER_ID_IDX on BOB_LAENDER_ROW_ERGAENZUNGEN (user_id);
create index BLR_MASSN_USER_ID_IDX on BOB_LAENDER_ROW_MASSNAHMEN (user_id);
create index BLR_DOKU_USER_ID_IDX on BOB_LAENDER_ROW_DOKUMENTE (user_id);

alter table BOB_LAENDER_ROW_MASSNAHMEN modify user_id number;
alter table BOB_LAENDER_ROW_MASSNAHMEN drop constraint "BOB_MASSN_MELDER_ID_FK";
alter table BOB_LAENDER_ROW_MASSNAHMEN add constraint "BLR_MASSNAHME_USER_ID_FK" foreign key (user_id)
references "APEX_APP_USER" (app_user_id);

alter table BOB_LAENDER_ROW_ERGAENZUNGEN modify user_id number;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN drop constraint BOB_ERGAENZ_USER_ID_FK;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN add constraint "ERGAENZ_BOB_LNDR_ROW_USER_ID" foreign key (user_id)
references "APEX_APP_USER" (app_user_id);


SELECT ID,
  ID_VORGANG,
  MELDENDE_BEHOERDE,
  KOMMENTAR,
  USER_ID
FROM "BOB_LAENDER_ROW_ERGAENZUNGEN";

 select BLR_ERGAENZUNGEN_SEQ.nextval from dual;



SELECT ID,
  ID_VORGANG,
  MELDENDE_BEHOERDE,
  KOMMENTAR,
  USER_ID
FROM "BOB_LAENDER_ROW_ERGAENZUNGEN";

 select BLR_ERGAENZUNGEN_SEQ.nextval from dual;

--CREATE OR REPLACE FORCE VIEW "RAS_INTERN"."RAS_MELDESTELLEN" ("GRP", "BEHOERDEN_ID", "BEHOERDE", "CODE", "DISPLAY_NAME", "RAS_GRUPPEN_ID", "RAS_GRUPPE", "RAS_GRUPPEN_CODE", "DOMAIN") AS 
with "RASGRP" as (
SELECT DOMAIN_ID,
  DOMAIN,
  DOMAIN_CODE,
  DOMAIN_OWNER,
  RAS_GRUPPEN_ID,
  RAS_GRUPPE,
  RAS_GRUPPEN_CODE
FROM "RAS_DOMAIN_GRUPPEN" 
)
  SELECT 1 as GRP, 
  b.BEHOERDEN_ID, 
  b.BUNDESBEHOERDE as BEHOERDE,
  b.BUNDESBEHOERDE_CODE as CODE,
  b.BUNDESBEHOERDE_CODE as DISPLAY_NAME,
  g.RAS_GRUPPEN_ID,
  g.RAS_GRUPPE,
  g.RAS_GRUPPEN_CODE,
  g.DOMAIN
FROM"RASGRP" g LEFT JOIN  "RAS_BUNDESOBERBEHOERDEN" b 
ON (b.BUNDESBEHOERDE_CODE = G.DOMAIN_CODE)
UNION
SELECT 2 as GRP, 
  b.BEHOERDEN_ID, 
  b.BUNDESBEHOERDE as BEHOERDE,
  b.BUNDESBEHOERDE_CODE as CODE,
  b.BUNDESBEHOERDE_CODE||' - '||b.BUNDESBEHOERDE as DISPLAY_NAME,
  g.RAS_GRUPPEN_ID,
  g.RAS_GRUPPE,
  g.RAS_GRUPPEN_CODE,
  g.DOMAIN  
FROM "RASGRP" g LEFT JOIN  "BUNDESBEHOERDEN" b 
ON (b.BUNDESBEHOERDE_CODE = G.DOMAIN_CODE)
UNION
SELECT 3 as GRP,
  b.BUNDESLAND_ID,
  b.BUNDESLAND,
  b.BUNDESLAND_CODE as CODE,
  b.BUNDESLAND_CODE ||' - ' ||b.BUNDESLAND as DISPLAY_NAME,
  min(g.RAS_GRUPPEN_ID) over(),
  min(g.RAS_GRUPPE) over(),
  'BL',
  null  
FROM "RASGRP" g LEFT JOIN  "RAS_BUNDESLAENDER" b
ON ('BL' = G.RAS_GRUPPEN_CODE);



create or replace view "RAS_DOMAIN_GRUPPEN"
as 
  select 
  r.domain_id,
  r.domain,
  r.domain_code,
  r.domain_owner,
  r.domain_group_id as RAS_GRUPPEN_ID,
  nvl(r.domain_bundesland_id, 0) as RAS_BL_ID,
  nvl(bl.bundesland, g.info_gruppe) as RAS_BUNDESLAND,
  nvl(bl.bundesland_code,  r.domain_code) as RAS_BL_CODE,
  g.info_gruppe  as RAS_GRUPPE,
  g.info_gruppe_code as RAS_GRUPPEN_CODE
from "RAS_DOMAINEN" r left outer join "RAS_GRUPPEN" g
on (r.domain_group_id = g.gruppen_id)
left outer join "BUNDESLAENDER" bl
on (r.domain_bundesland_id = bl.bundesland_id)
order by 1;



#P40_ID_VORGANG_CONTAINER > div.t-Form-inputContainer.col.col-9 {
    margin-left: 0px;
    margin-top: 0px;
    width: 64%;
    left: 3px;
}



declare
l_id number;
begin
  select 1 into l_id
  from BOB_LAENDER_ROW_MASSNAHMEN
  where id = :P38_ID
  and DELETED is null;
if l_id = 1 then
return false;
end if;
exception when no_data_found then
return true;
end;
/

--style="background-color: #890d49; color: #ffffff;"

alter table BOB_LAENDER_ROW_MASSNAHMEN add MELDENDE_STELLE_CODE varchar2(200);
alter table BOB_LAENDER_ROW_DOKUMENTE add MELDENDE_STELLE_CODE varchar2(200);
alter table BOB_LAENDER_ROW_ERGAENZUNGEN add MELDENDE_STELLE_CODE varchar2(200);


--CREATE OR REPLACE FORCE VIEW "RAS_INTERN"."RAS_USERS"
--AS 
  select 
  usr.app_user_id,
  usr.app_user_email,
  usr.app_username,
  usr.app_user_code,
  usr.app_user_account_status,
  usr.domain_code,
  usr.gruppen_code,
 (select nvl(DOMAIN_BUNDESLAND_ID, 0) from RAS_DOMAINEN where domain_code = usr.domain_code)
from "APEX_APPLICATION_USERS" usr
where usr.app_user_email = (select u.APP_USER_EMAIL 
                                            from "APEX_APPLICATION_USERS" u
                                            where upper(trim(u.app_username)) = 
                                                       upper(trim(nvl(v('APP_USER'), usr.app_username))))
and usr.app_user_account_status = 'OPEN';


select ras_bl_code 
from RAS_DOMAIN_GRUPPEN
where domain_code = (select domain_code
from RAS_USERS
where upper(trim(app_username)) = upper(trim(:APP_USER)));

alter table BOB_LAENDER_ROW_DOKUMENTE modify melder_id number;
alter table BOB_LAENDER_ROW_DOKUMENTE add constraint "BOB_MELDER_ID_FK" foreign key (melder_id)
references "RAS_MELDER" (ras_melder_id);

alter table BOB_LAENDER_ROW_MASSNAHMEN modify melder_id number;
alter table BOB_LAENDER_ROW_MASSNAHMEN add constraint "BOB_MASSN_MELDER_ID_FK" foreign key (melder_id)
references "RAS_MELDER" (ras_melder_id);

alter table BOB_LAENDER_ROW_ERGAENZUNGEN modify melder_id number;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN add constraint "BOB_ERGAENZ_MELDER_ID_FK" foreign key (melder_id)
references "RAS_MELDER" (ras_melder_id);


update BOB_LAENDER_ROW_ERGAENZUNGEN set melder_id = 1;
update BOB_LAENDER_ROW_MASSNAHMEN set melder_id = 1;
update BOB_LAENDER_ROW_DOKUMENTE set melder_id = 1;

commit;

alter table APEX_APP_USER drop constraint APP_USER_MELDER_ID;
alter table APEX_APP_USER add constraint "APEXAPPUSER_MELDER_ID" foreign key (app_user_melder_id) references RAS_MELDER(ras_melder_id);


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- RAS Malder (alle Beteiligten)
drop table "RAS_MELDER" purge;

create table "RAS_MELDER"
as
select rownum as RAS_MELDER_ID, BEHOERDEN_ID as RAS_MELDEBEHORDE_ID, BEHOERDE as RAS_MELDER, CODE as RAS_MELDER_CODE, 
           DISPLAY_NAME as RAS_DISPLAY_NAME, BEHOERDEN_GRUPPEN_ID as RAS_GRUPPEN_ID, GRP as SORT_SEQ
from (
 SELECT case when BUNDESBEHOERDE_CODE 
  in ('BFARM' , 'PEI', 'BVL', 'BMEL') 
  then 1
  else 2
  end as GRP, BEHOERDEN_ID, 
  BUNDESBEHOERDE as BEHOERDE,
  BUNDESBEHOERDE_CODE as CODE,
  BUNDESBEHOERDE_CODE as DISPLAY_NAME,
  case when BUNDESBEHOERDE_CODE 
  in ('BFARM' , 'PEI', 'BVL', 'BMEL') 
  then 1
  else 5
  end as BEHOERDEN_GRUPPEN_ID
FROM "RAS_BUNDESOBERBEHOERDEN"
UNION
SELECT 3 as GRP,
  BUNDESLAND_ID,
  BUNDESLAND,
  BUNDESLAND_CODE as CODE,
  BUNDESLAND_CODE ||' - ' ||BUNDESLAND as DISPLAY_NAME,
  2 as BEHOERDEN_GRUPPEN_ID
FROM "RAS_BUNDESLAENDER"
) 
order by grp, behoerden_id;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Views auf RAS_MELDER
create or replace view "RAS_DOMAIN_GRUPPEN"
as 
  select 
  d.domain_id as ras_domain_id,
  d.domain as ras_domain,
  d.domain_code as ras_domain_code,
  d.domain_owner as ras_domain_owner,
  g.ras_gruppe_code,  
  g.ras_gruppe as ras_gruppe,
  m.ras_melder  as ras_melder,
  d.domain_melder_id as ras_melder_id,
  m.ras_gruppen_id as ras_melder_gruppen_id
from "RAS_DOMAINEN" d left outer join "RAS_MELDER" m
on (d.domain_melder_id = m.ras_melder_id)
left outer join "RAS_GRUPPEN" g
on (m.ras_gruppen_id = g.gruppen_id)
order by 1;


create or replace view "RAS_DOMAINS"
as 
  select 
  rd.domain_id,
  rd.domain,
  rd.domain_owner,
  rd.domain_code,
  case rd.dns_not_resolved when 0 then 'Ja' else 'Nein' end as dns_gueltig,
  s.status,
  m.ras_melder  as ras_behoerde,
  m.ras_gruppen_id as ras_melder_gruppen_id,
  rd.modified,
  rd.modified_by,
  rd.created,
  rd.created_by,
  rd.deleted,
  rd.deleted_by
from "RAS_DOMAINEN" rd LEFT OUTER JOIN "APEX_STATUS" s
on (rd.status_id = s.status_id)
 left outer join "RAS_MELDER" m
on (rd.domain_melder_id = m.ras_melder_id)
order by 1;


create or replace view "RAS_MELDEGRUPPEN"
as 
select
  m.ras_melder_id,
  m.ras_meldebehorde_id,
  m.ras_melder,
  m.ras_melder_code,
  m.ras_display_name,
  m.ras_gruppen_id,
  g.ras_gruppe,
  g.ras_gruppe_code,
  m.sort_seq,
  m.app_id
from "RAS_MELDER" m left outer join "RAS_GRUPPEN" g
on (m.ras_gruppen_id = g.gruppen_id);

 
 CREATE OR REPLACE VIEW "RAS_MELDEDOMAINEN"
 as
select
  m.ras_melder_id,
  m.ras_melder,
  m.ras_melder_code,
  m.ras_display_name,
  g.ras_gruppe,
  g.ras_gruppe_code,
  d.domain,
  d.domain_code,
  m.app_id,
  m.ras_meldebehorde_id,
  m.ras_gruppen_id,
  g.gruppen_id,
  m.sort_seq,
  m.created,
  m.created_by,
  m.modified,
  m.modified_by
FROM   "RAS_MELDER" m left outer join "RAS_GRUPPEN" g
on (m.ras_gruppen_id   = g.gruppen_id)
right outer join "RAS_DOMAINEN" d
on (d.domain_melder_id = m.ras_melder_id)
order by m.sort_seq, m.app_id, m.ras_melder_id;



create or replace view "APEX_ALL_USERS"
as 
  select distinct
  u.app_id as app_id, 
  u.app_user_id, 
  u.app_user_email, 
  u.app_username, 
  a.status as app_user_account_status, 
  u.app_user_ad_login, 
  u.app_user_novell_login, 
  u.app_user_default_role_id, 
  ar.app_rolename as default_role,
  vd.domain_code,
  vd.domain,
  m.ras_melder_code as meldegruppen_code,
  m.ras_melder as meldegruppe,
  g.ras_gruppe as ras_gruppe,
  g.ras_gruppe_code as ras_gruppe_code,
  u.app_user_parent_user_id, 
  (select au.app_username  
  from "APEX_APP_USER" au 
  where au.app_user_id = u.app_user_parent_user_id) as parent_username, 
  max(rm.app_role_id) over (partition by rm.app_user_id) as max_security_level,  
  min(rm.app_role_id) over (partition by rm.app_user_id) as min_security_level, 
  u.app_user_code, 
  vd.domain_id,
  m.ras_melder_id,
  g.gruppen_id as ras_gruppe_id,
  u.created, 
  u.created_by, 
  u.modified, 
  u.modified_by,
  u.deleted,
  u.deleted_by
from "APEX_APP_USER" u  
left outer join  "APEX_ACCOUNT_STATUS" a 
on (u.app_user_status_id = a.status_id 
   and u.app_id = a.app_id) 
left outer join  "APEX_ROLES" ar 
on (ar.app_role_id = u.app_user_default_role_id 
    and ar.app_id = u.app_id) 
left outer join  "RAS_DOMAINEN" vd 
on (vd.domain_id = u.app_user_domain_id)
left outer join  "RAS_MELDER" m 
on (m.ras_melder_id = u.app_user_melder_id)
left outer join "RAS_GRUPPEN" g
on (m.ras_gruppen_id = g.gruppen_id)
left outer join "APEX_APP_USER_ROLE_MAP" rm 
on (u.app_user_id = rm.app_user_id 
      and u.app_id = rm.app_id)
order by 1, 2;


create or replace view "APEX_APPLICATION_USERS"
as 
  select APP_ID,
  APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_AD_LOGIN as AD_LOGIN,
  APP_USER_NOVELL_LOGIN as NOVELL_LOGIN,
  APP_USER_DEFAULT_ROLE_ID,
  DEFAULT_ROLE,
  DOMAIN_CODE, 
  DOMAIN,
  MELDEGRUPPE,
  MELDEGRUPPEN_CODE,
  RAS_GRUPPE_CODE, 
  RAS_GRUPPE,
  APP_USER_ACCOUNT_STATUS,
  APP_USER_PARENT_USER_ID,
  PARENT_USERNAME,
  APP_USER_DEFAULT_ROLE_ID as USER_DEFAULT_SECURITY_LEVEL,
  MAX_SECURITY_LEVEL as USER_MAX_SECURITY_LEVEL,
  MIN_SECURITY_LEVEL as USER_MIN_SECURITY_LEVEL,  
  DOMAIN_ID,
  RAS_MELDER_ID,
  RAS_GRUPPE_ID,
  CREATED,
  CREATED_BY,
  MODIFIED,
  MODIFIED_BY,
  DELETED,
  DELETED_BY
from "APEX_ALL_USERS"
where APP_ID = nvl(v('APP_ID'), app_id)
order by 1, 2;



create or replace view "RAS_USERS"
as 
  select 
  usr.app_user_id,
  usr.app_user_email,
  usr.app_username,
  usr.app_user_code,
  usr.app_user_account_status,
  usr.domain_code, 
  usr.domain,
  usr.meldegruppen_code,
  usr.meldegruppe,
  usr.ras_gruppe_code, 
  usr.ras_gruppe,
  usr.domain_id,
  usr.ras_melder_id,
  usr.ras_gruppe_id
from "APEX_APPLICATION_USERS" usr
where usr.app_user_account_status = 'OPEN';


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Vorgangs�bersicht
with 
"VORGANG" as (
SELECT ID_VORGANG, BEZEICHNUNG,VORGANGSNUMMER
FROM "AMF_VORGANG"
    WHERE ID_VORGANG = nvl(:P40_ID_VORGANG, ID_VORGANG)
),
"ERGAENZ" as (
SELECT 
 BEMERKUNG, MELDENDE_BEHOERDE, ID_VORGANG, CREATED, MODIFIED
 FROM "BOB_LAENDER_ROW_ERGAENZUNGEN"
),
"MASSN" as (
SELECT 
  m.ID_VORGANG,
  m.MELDENDE_BEHOERDE,
  m.MASSNAHME_ID,
  amm.MASSNAHME,
  m.MASSNAHME_UMGESETZT,
  m.MASSNAHME_UMGESETZT_AM,
  m.MASSNAHME_SONSTIGE,
  m.MASSNAHME_BEMERKUNG
FROM "BOB_LAENDER_ROW_MASSNAHMEN" m LEFT JOIN "AMF_MASSNAHMEN" amm
ON (m.MASSNAHME_ID = amm.ID)
)
SELECT
  v.ID_VORGANG,
  v.VORGANGSNUMMER,
  v.BEZEICHNUNG as VORGANG,
  m.CODE ,
  m.BEHOERDE,
  (select count(*) from BOB_LAENDER_ROW_DOKUMENTE where 
FROM "RAS_MELDESTELLEN" m LEFT OUTER JOIN "VORGANG" v
ON (1 = 1)
LEFT OUTER JOIN "MASSN" ma
ON ( )
;


create or replace view "RAS_RUECKMELDUNG_STATS"
as
-- docs
select 'DOKUMENTE' as note_type, count(1) as num_notes, d.id_vorgang, g.ras_melder_id
from BOB_LAENDER_ROW_DOKUMENTE d JOIN RAS_DOMAIN_GRUPPEN g
on (d.domain_id = g.ras_domain_id)
where d.deleted is null
group by d.id_vorgang, g.ras_melder_id
union --notes
select 'ANMERKUNGEN' as mtype, count(1) as num_notes, d.id_vorgang, g.ras_melder_id
from BOB_LAENDER_ROW_ERGAENZUNGEN d JOIN RAS_DOMAIN_GRUPPEN g
on (d.domain_id = g.ras_domain_id)
where d.deleted is null
group by d.id_vorgang, g.ras_melder_id
union --notes
select 'MASSNAHMEN' as mtype, count(1) as num_notes, d.id_vorgang, g.ras_melder_id
from BOB_LAENDER_ROW_MASSNAHMEN d JOIN RAS_DOMAIN_GRUPPEN g
on (d.domain_id = g.ras_domain_id)
where d.deleted is null
group by d.id_vorgang, g.ras_melder_id;



create or replace view "RAS_RUECKMELDUNG_STATISTIK"
as
with
rueckmeldungen
as (
select 
  note_type,
  num_notes,
  id_vorgang,
  ras_melder_id
from "RAS_RUECKMELDUNG_STATS"
)
select 
  m.ras_melder_id,
  m.ras_meldebehorde_id,
  v.id_vorgang,
  m.ras_display_name,
  (select r.num_notes from "RUECKMELDUNGEN" r
   where r.ras_melder_id = m.ras_melder_id
       and r.id_vorgang     = v.id_vorgang
       and r.note_type = 'MASSNAHMEN') as anzahl_massnahmen,
  (select r.num_notes from "RUECKMELDUNGEN" r
   where r.ras_melder_id = m.ras_melder_id
       and r.id_vorgang     = v.id_vorgang
       and r.note_type = 'ANMERKUNGEN') as anzahl_anmerkungen,
  (select r.num_notes from "RUECKMELDUNGEN" r
   where r.ras_melder_id = m.ras_melder_id
       and r.id_vorgang     = v.id_vorgang
       and r.note_type = 'DOKUMENTE') as anzahl_dokumente,       
  m.ras_gruppen_id,
  g.ras_gruppe,
  g.ras_gruppe_code,
  m.ras_melder,
  m.ras_melder_code,
  m.sort_seq,
  m.app_id,
  m.created,
  m.created_by,
  m.modified,
  m.modified_by
from "RAS_MELDER" m left outer join "AMF_VORGANG" v
on (1 = 1)
left outer join "RAS_GRUPPEN" g
on (m.RAS_GRUPPEN_ID = g.GRUPPEN_ID)
order by 3;



SELECT RAS_MELDER_ID,
  RAS_MELDEBEHORDE_ID,
  ID_VORGANG,
  RAS_DISPLAY_NAME,
  ANZAHL_MASSNAHMEN,
  ANZAHL_ANMERKUNGEN,
  ANZAHL_DOKUMENTE,
  RAS_GRUPPEN_ID,
  RAS_GRUPPE,
  RAS_GRUPPE_CODE,
  RAS_MELDER,
  RAS_MELDER_CODE,
  SORT_SEQ,
  APP_ID,
  CREATED,
  CREATED_BY,
  MODIFIED,
  MODIFIED_BY
FROM RAS_RUECKMELDUNG_STATISTIK ;

SELECT ID,
  ID_VORGANG,
  DATEINAME,
  MIMETYPE,
  DATEIINHALT
FROM DOKUMENTE ;

SELECT ID,
  ID_VORGANG,
  MELDENDE_BEHOERDE,
  DATEINAME,
  MIMETYPE,
  DATEIINHALT,
  USER_ID,
  DOMAIN_ID
FROM BOB_LAENDER_ROW_DOKUMENTE ;




begin begin  select "MASSNAHME_ID",to_char("MASSNAHME_UMGESETZT_AM", :p$_format_mask1),"MASSNAHME_BEMERKUNG","ID_VORGANG","ID","MASSNAHME_UMGESETZT","MELDENDE_BEHOERDE","USER_ID","DOMAIN_ID" into wwv_flow.g_column_values(1),wwv_flow.g_column_values(2),wwv_flow.g_column_values(3),wwv_flow.g_column_values(4),wwv_flow.g_column_values(5),wwv_flow.g_column_values(6),wwv_flow.g_column_values(7),wwv_flow.g_column_values(8),wwv_flow.g_column_values(9) 
from "RAS_INTERN"."BOB_LAENDER_ROW_MASSNAHMEN" 
where "ID" = :p_rowid and DOMAIN_ID = :LOGIN_RAS_DOMAIN_ID; end;
end;


http://testapex.bfarm.de:8080/apex/f?p=100002:38:12259384022904::NO:RP,38:P38_ID,P0_P38_ID_VORGANG,P38_ART_DER_FAELSCHUNG,P38_EINGANGSDATUM,P38_MELDENDE_STELLE,P38_ARZNEIMITTELBEZEICHNUNG,P38_HALTBARKEITSDATUM_FAELSCHUNG,P38_HALTBARKEITSDATUM_ORIGINAL,P38_PHARM_UNTERNEHMEN,P38_WIRKSTOFF,P38_CHARGENBEZEICHNUNG_FAELSCHUNG,P38_CHARGENBEZEICHNUNG_ORIGINAL,P38_LAND,P0_P38_FROM_PAGE:38,94,Wirkstoff-F%C3%A4lschung,05.12.2017,BFARM,CALCIDURAN%20100,01.01.2017,01.01.2017,ASTA%20Medica%20GmbH,Calciumhydrogenphosphat,%20Colecalciferol-Cholesterol,CALCID-B001,CALCIDU-01B,Deutschland,19



#P120_ID_VORGANG { width: 400px; }
#P120_DOKUMENTEN_INHALT { width: 400px; }
#B28234277840768129 { margin-left: 38px; }
#P120_DATEIINHALT_DISPLAY_CONTAINER > div.t-Form-inputContainer.col.col-9 { width: 75%; }


trigger "APEX_APP_USER_BIU_TRG"
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
    if (:new.app_user_domain_id is null or :new.app_user_melder_id is null) then
        select d.domain_id, d.domain_melder_id 
        into :new.app_user_domain_id, :new.app_user_melder_id
        from "RAS_DOMAINEN" d
        where lower(trim(d.domain)) =lower(substr(:new.app_user_email, instr(:new.app_user_email, '@') +1));
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


select d.domain_id, d.domain_melder_id 
        --into :new.app_user_domain_id, :new.app_user_melder_id
        from "RAS_DOMAINEN" d
        where lower(trim(d.domain)) =lower(substr(:app_user_email, instr(:app_user_email, '@') +1));
        
         select apex_app_user_id_seq.nextval from dual;
         
drop sequence apex_app_user_id_seq;         

create sequence apex_app_user_id_seq start with 100 increment by 1 nocache noorder nocycle;         


create index BLR_DOKU_RAS_MELDER_ID_IDX on BOB_LAENDER_ROW_DOKUMENTE(ras_melder_id);
create index BLR_DOKU_DEL_IDX on BOB_LAENDER_ROW_DOKUMENTE(deleted);

drop index BLR_ERGAENZ_DOMAIN_ID_IDX;
create index BLR_ERGAENZ_RAS_MELDER_ID_IDX on BOB_LAENDER_ROW_ERGAENZUNGEN(ras_melder_id);
create index BLR_ERGAENZ_DEL_IDX on BOB_LAENDER_ROW_ERGAENZUNGEN(deleted);

drop index BLR_MASSN_DOMAIN_ID_IDX;
create index BLR_MASSN_RAS_MELDER_ID_IDX on  BOB_LAENDER_ROW_MASSNAHMEN(ras_melder_id);
create index BLR_MASSN_DEL_IDX on  BOB_LAENDER_ROW_MASSNAHMEN(deleted);

create index APEX_USER_DOMAIN_ID_IDX on APEX_APP_USER(APP_USER_DOMAIN_ID);
create index APEX_USER_MELDER_ID_IDX on APEX_APP_USER(APP_USER_MELDER_ID);

create index AMF_VORGANG_DEL_IDX on AMF_VORGANG(deleted);

create index RAS_DOK_DEL_IDX on DOKUMENTE(deleted);
create index RAS_DOM_DEL_IDX on RAS_DOMAINEN (deleted);



begin
  dbms_stats.gather_schema_stats(user);
end;
/


.a-IRR-table { white-space: nowrap; }

.a-GV-floatingItem {
    max-width: 100%;
}

#RAS_DOK {  
  border: 1px solid #f4f4f4;
  padding: 12px;
}


td > p { font-size: 13px; line-height: 0.2 };

select ras_gruppe_code
from RAS_USERS
where upper(trim(app_username)) = upper(trim(:APP_USER));


SELECT APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_ACCOUNT_STATUS,
  DOMAIN_CODE,
  DOMAIN,
  MELDEGRUPPEN_CODE,
  MELDEGRUPPE,
  RAS_GRUPPE_CODE,
  RAS_GRUPPE,
  DOMAIN_ID,
  RAS_MELDER_ID,
  RAS_GRUPPE_ID
FROM RAS_USERS ;

SELECT RAS_MELDER_ID,
  RAS_MELDER,
  RAS_MELDER_CODE,
  RAS_DISPLAY_NAME,
  RAS_GRUPPE,
  RAS_GRUPPE_CODE,
  DOMAIN,
  DOMAIN_CODE,
  APP_ID,
  RAS_MELDEBEHORDE_ID,
  RAS_GRUPPEN_ID,
  GRUPPEN_ID,
  SORT_SEQ,
  CREATED,
  CREATED_BY,
  MODIFIED,
  MODIFIED_BY
FROM RAS_MELDEDOMAINEN ;


SELECT 
  e.ID,
  e.ID_VORGANG,
  nvl(e.MELDENDE_BEHOERDE, :LOGIN_RAS_DOMAIN) as MELDENDE_BEHOERDE,
  dbms_lob.getlength(e.DATEIINHALT)||' Bytes' as DATEIGROESSE,
  e.DATEINAME,
  e.DOKUMENTEN_INHALT,
  e.MIMETYPE,
 '<img src="'||apex_util.get_blob_file_src('P125_ICON', i.icon_id)||'" style="width:32px; height:32px;" alt="'||i.ICON_FILE_NAME||'"/>' as ICON_DISPLAY,
 I.ICON_ID,
 e.USER_ID
FROM "BOB_LAENDER_ROW_DOKUMENTE" e left outer join "MIME_TYPE_ICONS" i
ON (e.MIMETYPE = I.MIME_TYPE)
WHERE e.ID_VORGANG = :P125_ID_VORGANG
AND e.RAS_MELDER_ID = :P125_RAS_MELDER_ID
AND e.DELETED is null;

select * from BOB_LAENDER_ROW_DOKUMENTE where id_vorgang = 94;
select * from MIME_TYPE_ICONS;-- where mime_type = 'image/jpeg';




select * from (
SELECT 
  ID_VORGANG,
  VORGANGSNUMMER,
  BEZEICHNUNG,
  MELDENDE_STELLE,
  EINGANGSDATUM,
  RAS_FALL,
  AM_NAME,
  AM_PU,
  AM_CHRG_ORIG,
  AM_CHRG_FAELSCH,
  AM_CHRG_HLTB,
  AM_CHRG_F_HLTB,
  ART_DER_FAELSCHUNG,
  FAELSCHUNGSART_SONSTIGE,
  AM_CHRG_STATUS,
  AM_WIRKSTOFF,
  DELETED_BY,
  DELETED,
  ZUST_LANDESBEHOERDE,
  AM_ENR,
  AM_PNR,
  AMF_MELDUNG_STATUS,
  ART_DER_ZUSTAENDIGKEIT,
  ART_DER_ZUSTAENDIGKEIT_SONST,
  ERSTELLUNGSDATUM,
  STAAT_ID,
  BUNDESLAND_ID,
  BUNDESOBERBEHOERDE
FROM AMF_VORGANG
ORDER BY EINGANGSDATUM desc
) where rownum < 8;



select d.domain_id
from "RAS_DOMAINEN" d
where lower(trim(d.domain)) = lower(substr(:new.app_user_email, instr(:new.app_user_email, '@') +1));

select * from USER_ROLE_PRIVS;

select count(*) from user_objects where status != 'VALID';

-- old
CREATE OR REPLACE FORCE VIEW "RAS_INTERN"."APEX_APP_USERNAME_FORMAT" ("USERNAME_FORMAT") AS 
  select app_setting_value as username_format
from "APEX_APP_SETTINGS"
where app_id = v('APP_ID') 
and app_setting_category = 'AUTHENTICATION'
and app_setting_name = 'USERNAME_FORMAT'
;

--- new
CREATE OR REPLACE FORCE VIEW "APEX_USERNAME_FORMAT" ("USERNAME_FORMAT") AS 
  select apex_config_item_value as username_format
from "APEX_CONFIGURATION"
where apex_config_item = 'USERNAME_FORMAT';

create or replace view "APEX_APP_USERNAME_FORMAT" ("USERNAME_FORMAT") 
as 
select USERNAME_FORMAT
from "APEX_USERNAME_FORMAT";

-- old
  CREATE OR REPLACE FORCE VIEW "RAS_INTERN"."APEX_APPLICATION" ("WORKSPACE_ID", "WORKSPACE", "APPLICATION_ID", "OWNER", "APPLICATION_NAME", "COMPATIBILITY_MODE", "HOME_LINK", "HOME_LINK_APEX", "LOGIN_URL", "THEME_NUMBER", "ALIAS", "PAGES", "APPLICATION_ITEMS", "LAST_UPDATED_BY", "LAST_UPDATED_ON", "AUTHENTICATION_SCHEMES", "AUTHENTICATION_SCHEME_TYPE", "AUTHORIZATION_SCHEMES", "AUTHORIZATION_SCHEME") AS 
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

-- new
create or replace view "APEX_APPLICATION" 
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
where application_id = nvl(v('APP_ID'), application_id);

  select workspace_id,
  workspace,
  application_id,
  owner,
  application_name
  from "APEX_APPLICATION" ;


declare
l_auth_type varchar2(100);
l_text varchar2(1000);
begin
  select
    case AUTHENTICATION_SCHEME_TYPE
    when 'Application Express Accounts'
    then 'APEX Application Express'
    when 'LDAP Directory'
    then 'Windows'
    when 'Database Accounts'
    then 'Oracle Datenbank'    
    end
--  into l_auth_type
FROM "APEX_APPLICATION" 
where AUTHENTICATION_SCHEME_TYPE in ('Application Express Accounts', 'LDAP Directory', 'Database Accounts');
--return l_auth_type;
exception when no_data_found then
 null;
end;
/

select application_name
from "APEX_APPLICATION";

select * from  "APEX_APPLICATION" ;


select * from "APEX_APPLICATION" ;

select owner, object_type from all_objects where object_name = 'APEX_APP_USERNAME_FORMAT';

select username_format
from "APEX_APP_USERNAME_FORMAT";

select upper(username_format)
from "APEX_APP_USERNAME_FORMAT";


select user_status + valid_domain as user_status
from (
    select case when user_exists =  0
                      then 0
                      else user_status
               end as user_status,
               case when user_exists = 0
               -- without any more args to is_valid_domain, the offset is determined by then system setting ENFORCE_VALID_DOMAIN in apx$cfg
               then "IS_VALID_DOMAIN"(upper(trim(:USERNAME)), p_return_as_offset => 'TRUE', p_return_offset => -1)
               else 0
               end as valid_domain
    from
    (select count(1)             as user_exists,
               max(user_status) as user_status
     from "APEX_USER_REG_STATUS"
     where upper(trim(username)) = upper(trim(:USERNAME))
    )
 );


grant select on "APX$USER_REG"                to "PUBLIC";
grant select on "APX$STATUS"                  to "PUBLIC";
grant select on "APEX_USER_REG_STATUS"        to "PUBLIC";
grant select on "APEX_USER_REGISTRATIONS"     to "PUBLIC";


select "IS_VALID_DOMAIN"(upper(trim(:USERNAME)), p_return_as_offset => 'FALSE') from dual;

DROP TABLE "AMF_VORGANG" cascade constraints;
--DROP TABLE "BUNDESSTAATEN" cascade constraints;
--------------------------------------------------------
--  DDL for Table AMF_VORGANG
--------------------------------------------------------

  CREATE TABLE "AMF_VORGANG" 
   (	"ID_VORGANG" NUMBER, 
	"VORGANGSNUMMER" VARCHAR2(128 BYTE), 
	"BEZEICHNUNG" VARCHAR2(512 BYTE), 
	"MELDENDE_STELLE" VARCHAR2(512 BYTE), 
	"EINGANGSDATUM" DATE DEFAULT sysdate, 
	"ERSTELLUNGSDATUM" DATE, 
	"STAAT_ID" NUMBER, 
	"BUNDESLAND_ID" NUMBER, 
	"BUNDESOBERBEHOERDE" VARCHAR2(128 BYTE), 
	"BEMERKUNG" VARCHAR2(1000 BYTE), 
	"MODIFIED" DATE, 
	"MODIFIED_BY" VARCHAR2(30 BYTE), 
	"CREATED" DATE, 
	"CREATED_BY" VARCHAR2(30 BYTE), 
	"BEARB_INSPEKTOR" VARCHAR2(200 BYTE), 
	"BETEIL_INSPEKTOR" VARCHAR2(200 BYTE), 
	"STELLUNGNAHME_ANGEFORDERT" DATE, 
	"STUFENPLANBEAUFTRAG" VARCHAR2(200 BYTE), 
	"RISIKO_STELLUNGNAHME" DATE, 
	"CHARGEN_MAENGEL" NUMBER, 
	"RAS_FALL" NUMBER, 
	"AM_NAME" VARCHAR2(200 BYTE), 
	"AM_ZNR" VARCHAR2(200 BYTE), 
	"AM_PU" VARCHAR2(200 BYTE), 
	"AM_CHRG_ORIG" VARCHAR2(200 BYTE), 
	"AM_CHRG_FAELSCH" VARCHAR2(200 BYTE), 
	"AM_CHRG_HLTB" DATE, 
	"AM_CHRG_F_HLTB" DATE, 
	"ART_DER_FAELSCHUNG" NUMBER, 
	"FAELSCHUNGSART_SONSTIGE" VARCHAR2(400 BYTE), 
	"AM_CHRG_STATUS" VARCHAR2(50 BYTE), 
	"AM_WIRKSTOFF" VARCHAR2(1000 BYTE), 
	"DELETED_BY" VARCHAR2(30 BYTE) DEFAULT user, 
	"DELETED" DATE, 
	"ZUST_LANDESBEHOERDE" VARCHAR2(400 BYTE), 
	"AM_ENR" VARCHAR2(200 BYTE), 
	"AM_PNR" VARCHAR2(200 BYTE), 
	"AMF_MELDUNG_STATUS" NUMBER DEFAULT 1, 
	"ART_DER_ZUSTAENDIGKEIT" VARCHAR2(200 BYTE), 
	"ART_DER_ZUSTAENDIGKEIT_SONST" VARCHAR2(1000 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table BUNDESSTAATEN
--------------------------------------------------------

--  CREATE TABLE "BUNDESSTAATEN" 
--   (	"STAAT_ID" NUMBER, 
--	"STAAT" VARCHAR2(128 BYTE), 
--	"AMTLICHE_VOLLFORM" VARCHAR2(512 BYTE), 
--	"ISO_2" VARCHAR2(10 BYTE), 
--	"ISO_3" VARCHAR2(30 BYTE), 
--	"ISO_NUM" VARCHAR2(30 BYTE), 
--	"MODIFIED" DATE, 
--	"MODIFIED_BY" VARCHAR2(30 BYTE), 
--	"CREATED" DATE, 
--	"CREATED_BY" VARCHAR2(30 BYTE)
--   ) ;
--------------------------------------------------------
--  DDL for Sequence AMF_VORGANG_SEQ
--------------------------------------------------------

CREATE SEQUENCE  "AMF_VORGANG_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 101 NOCACHE  NOORDER  NOCYCLE ;

-- INSERTING into AMF_VORGANG
SET DEFINE OFF;
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('93','DE345675423','Testfall1','BFARM',to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','7',null,'<p>viel zu sagen gibt es hier nicht</p>
',to_date('21.12.2017 11:50:46','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('04.12.2017 15:31:15','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'ASTAPECT-KODEIN',null,'ASTA Medica GmbH','Blo2','Bla1',to_date('01.12.2022 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.08.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),'6','Verpackung',null,'Codeinphosphat-Hemihydrat, Ephedrinhydrochlorid, Sulfogaiacol',null,null,'Hessen','0000371','3000621','1','�rtlicher Vertreter',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('59','DE2345678','Test','BFARM',to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('25.07.2017 10:35:20','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('60','DE1324','NENEEN','BFARM',to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('25.07.2017 10:47:48','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('61','fzfhzj','cgh','BFARM',to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('25.07.2017 14:40:01','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('62','DE879','TestBez','BW - Baden-Wuerttemberg',to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 11:51:07','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA',null,null,null,null,null,null,null,'Avamigran N',null,'AWD.pharma GmbH',null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('63','DE12345','Fall 3','BFARM',to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 14:03:52','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('64','xxy','Xeplion','BFARM',to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 14:07:30','DD.MM.YYYY HH24:MI:SS'),'MWITTSTOCK',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('87','DE00007','Test','BFARM',to_date('02.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('02.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','10',null,'<p>Bemerk</p>
',to_date('05.12.2017 15:31:39','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('02.11.2017 11:16:28','DD.MM.YYYY HH24:MI:SS'),'ADMIN','hshshs','hshshs',null,'hshshsh',null,'1','1','Aspirin Nasenspray',null,'Bayer Vital GmbH','Aspirin Nasenspray 400ml','Aspirin N�senspray 400ml',to_date('01.09.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.09.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'2','Oxymetazolinhydrochlorid','APEX_PUBLIC_USER',to_date('05.12.2017 15:31:39','DD.MM.YYYY HH24:MI:SS'),null,'2137607','8011204','2',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('47','DE12345','Harvoni 3','BFARM',to_date('19.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('19.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,'<p>die Inspektoren sind nicht miteinander verwandt, sondern kommen aus demselben Dorf!</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('19.07.2017 18:33:08','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Unterm�ller-Krainersohn','Unterkrainer-M�llersohn',null,'Neo Goodheart',to_date('10.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','1','Harvoni 90 mg/400 mg','EU/1/14/958/002','Gilead Sciences International Limited',null,'GHERT32DE',null,to_date('01.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'6','alles total falsch!','3',null,null,null,'Landeskriminalamt Oberbayern',null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('48','DE3456','TAPESTRY','BFARM',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('19.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,'<p>so was hat die Welt noch nicht gesehen.</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('19.07.2017 18:50:54','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Unterm�ller','Huber',null,'Sr. Rodrig�z',to_date('10.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','0','Harvoni 90 mg/400 mg','EU/1/14/958/002','Gilead Sciences International Limited','HSFRDE34','HGDSER34',to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'2','Ledipasvir, Sofosbuvir',null,null,'Landeskriminalamt Niedersachsen','2711769','8030549','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('88','5665475','657457','543245',to_date('07.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('07.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('07.11.2017 20:19:49','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('89','DE1239780','Norditalien','BFARM',to_date('08.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('08.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,null,to_date('11.12.2017 17:34:02','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('08.11.2017 14:59:43','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'Harvoni','EU/1/14/958/002','Gilead Sciences International Limited',null,null,to_date('01.12.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,null,'Ledipasvir, Sofosbuvir',null,null,null,'2711769','8030549','1','Zulassungsinhaber',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('14','DE123456','Harvoni','BFARM - Bundesinstitut f�r Arzneimittel und Medizinprodukte (BfArM)',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:22:36','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('15','DE34567','Cement','BVL - Bundesamt f�r Verbraucherschutz und Lebensmittelsicherheit (BVL)',to_date('15.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 15:28:33','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:25:38','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('16','DE3455677','Chaos in Hamburg','BKA - Bundeskriminalamt',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','2','17','<p>Voll die <strong><u>Bemerkung!!!</u></strong></p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:27:25','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Oberm�ller','Unterkrainer',null,'Mr. Smith',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','1','Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Milinda GmbH',null,'DETRAE123',null,to_date('31.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'3',null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('17','DE2345','Aspirin','BFARM - Bundesinstitut f�r Arzneimittel und Medizinprodukte (BfArM)',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,'17','<p>Bemrk</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:31:52','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Oberm�ller','Unterkrainer',null,'Mr. Smith',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','1','Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Gilead Sciences International Limited',null,'SEFER3453',null,to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'1',null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('18','DE234556','Harvoni','BFARM - Bundesinstitut f�r Arzneimittel und Medizinprodukte (BfArM)',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','3','18','<p>Bemrrk</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:36:05','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Oberm�ller','UNterkrainer',null,'Mr. Smith',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','1','Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Milinda GmbH',null,'BFER23',null,to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,'3',null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('19','DE23456','NHEHEHE','BFARM - Bundesinstitut f�r Arzneimittel und Medizinprodukte (BfArM)',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','2','17',null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:40:03','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Oberm�ller','UNterkrainer',null,'Smith',null,'1','1','Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Milinda GmbH','JDJDJDJ','GSGSSG',to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'1',null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('20','DE12345','BAGAGA','BFARM',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,'3','<p>Bemerkl</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:44:42','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Oberm�ller','Unterbayer',null,'M�ller',to_date('10.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','1','Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Gilead Sciences International Limited','HFHFH','BGGER45',to_date('01.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'3',null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('50','454634356','Test','Test',to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('20.07.2017 09:05:31','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'Aspirin Nasenspray',null,'Bayer Vital GmbH',null,null,null,null,null,null,null,'Oxymetazolinhydrochlorid',null,null,null,'2137607','8011204','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('51','DE222','Test','BFARM',to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('20.07.2017 09:32:30','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('49','DE1239','Test','BFARM',to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,'<p>Status der Verifizierung angelegt</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('20.07.2017 08:51:18','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA','Lisa M�ller','Max Mustermensch',null,null,null,'1','0','CODEINE UND ASPIRIN UND PHENACETIN TABLETTEN',null,'Holsten Pharma GmbH',null,null,null,null,'6','Testf�lschung','2','Acetylsalicyls�ure (Ph.Eur.), Codeinphosphat-Hemihydrat, Phenacetin',null,null,null,'0912712','3001738','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('53','1234','Test Fall','BKA - Bundeskriminalamt',to_date('21.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('21.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('21.07.2017 11:06:20','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('54','DE12345','Neuer Fall','BFARM',to_date('30.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('21.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('24.07.2017 10:43:36','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('55','DE3425','Ganz Neuer Fall','BFARM',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('24.07.2017 13:38:20','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('56','DE12233','Ganz Neuer Fall','BFARM',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 15:15:23','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('24.07.2017 14:49:50','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('57','DE2343343','Ganz Ganz Neuer Fall','BFARM',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('24.07.2017 15:15:29','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('58','GERER','HDHDH','BFARM',to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('24.07.2017 17:29:30','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('83','123','TestKlose','BFARM',to_date('19.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('19.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','12',null,'<p>ecdfsd</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('19.09.2017 14:56:39','DD.MM.YYYY HH24:MI:SS'),'TKLOSE','frgase','sefg',null,'esggvdfs',null,null,'1','Aspirine Direkt','vdsfbv','cvsef','sergxcvyed','fresfagfe',null,null,null,null,'2','Acetylsalicyls�ure (Ph.Eur.)',null,null,'Bayern','2140249','3216120','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('67','DE1','Diebstahl IT','BB - Brandenburg',to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,'<p>fhhfsdhdsflsdlhdfsljhsjlh&ouml;.</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 15:12:10','DD.MM.YYYY HH24:MI:SS'),'TKLOSE','Dr. mmm','dddd',null,'ddd; jujj; zhhh',null,null,'1','diverse','EU/1/11/672/002','diverse','xx5','xx5',to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'6','unbekannt','2','diverse',null,null,'Bezirksregierung D�sseldorf','2750363','8090132','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('75','0815','Testf�lschung','Apotheke zur F�lschung',to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('31.07.2017 15:56:36','DD.MM.YYYY HH24:MI:SS'),'NPAESCHKE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('85','5',null,null,to_date('27.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('27.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('27.09.2017 13:10:33','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('86','DE2017-001','QD2017-149/H/Sprycel/ falsification','EMA',to_date('28.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('29.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'36',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('29.09.2017 17:02:57','DD.MM.YYYY HH24:MI:SS'),'GOMLOR',null,null,null,null,null,null,'1','Sprycel','EU/1/06/363/003','Abacus',null,'AAK7575',to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.10.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),'4',null,'3',null,null,null,'Bayern',null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('90','DE000999','Testfaelschung','BFARM',to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('04.12.2017 10:46:57','DD.MM.YYYY HH24:MI:SS'),'ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('91','DE0123454','Testfall','BFARM',to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','9',null,'<p>Bemerk</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('04.12.2017 10:54:37','DD.MM.YYYY HH24:MI:SS'),'ADMIN',null,null,null,null,null,null,null,'ASPIRIN-PHENACETIN-CODEIN',null,'Delta Distribution GmbH',null,null,to_date('01.12.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.12.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1',null,null,'Acetylsalicyls�ure (Ph.Eur.), Codeinphosphat-Hemihydrat, Phenacetin',null,null,null,'0612513','3000288','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('92','DE12345678','Test','BFARM',to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','12',null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('04.12.2017 11:23:04','DD.MM.YYYY HH24:MI:SS'),'ADMIN',null,null,null,null,null,null,null,'Aspirine Direkt',null,'kohlpharma GmbH',null,null,null,null,'6',null,null,'Acetylsalicyls�ure (Ph.Eur.)',null,null,null,'2140249','3216120','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('11','Harvoni','Harvoni','Regierungspr�sidium Oberbayern',to_date('07.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('07.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','2','1','m�glicherweise gef�lschte Tabletten in Apotheke entdeckt anhand von Farbabweichung entdeckt(wei� statt ockerfarben)',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('07.07.2017 13:16:04','DD.MM.YYYY HH24:MI:SS'),'NPAESCHKE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('1','NEU12345DEF','Harvoni�','BfArM',to_date('12.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('12.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','8','3','Die gef�lschten Tabletten sind nicht wie �blich orange, sondern wei� und sollten keinesfalls eingenommen werden.',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('28.06.2017 19:06:16','DD.MM.YYYY HH24:MI:SS'),'RAS_INTERN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('2','NEU12341DE','Lore Ipsum (c)','LKA',to_date('07.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'68',null,'1','Where does it come from?
Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.
And everything else is FAKE NEWS!',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('28.06.2017 19:06:16','DD.MM.YYYY HH24:MI:SS'),'RAS_INTERN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('84','2',null,null,to_date('27.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('27.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('27.09.2017 09:17:57','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'dewdf',null,null,null,null,to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('21','1','Test von Herrn Klose','Italien',to_date('19.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('19.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('19.07.2017 08:53:29','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('94','DE1234567','Testfall','BFARM',to_date('05.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('05.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','7',null,null,to_date('15.12.2017 14:33:35','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('05.12.2017 18:05:36','DD.MM.YYYY HH24:MI:SS'),'ADMIN',null,null,null,null,null,null,null,'CALCIDURAN 100',null,'ASTA Medica GmbH','CALCIDU-01B','CALCID-B001',to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,null,'Calciumhydrogenphosphat, Colecalciferol-Cholesterol',null,null,null,'0000342','3000621','1','Freitext','Unbekannte Zust�ndigkeit');
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('9','NEUNEU1234','Neu','BVL',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,'1','<p>alles neu war gestern</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('03.07.2017 15:17:25','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Harvoni 90 mg/400 mg Filmtabletten - OP(3x28)','EU/1/14/958/002','Gilead Sciences International Limited',null,null,null,null,null,null,null,'Ledipasvir, Sofosbuvir',null,null,null,'2711769','8030549','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('95','QD2017-0001','AVACAN BW','BW - Baden-Wuerttemberg',to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','7',null,null,to_date('15.12.2017 17:19:22','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('11.12.2017 11:25:31','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'AVACAN',null,'ASTA Medica GmbH',null,null,to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'3',null,null,'Camylofindihydrochlorid',null,null,null,'0000299','3000621','1','Zulassungsinhaber',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('96','RAS2017-007','TEST01','BE - Berlin',to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,'<p>Bemerkungen zu dem Fall</p>
',to_date('11.12.2017 16:28:23','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('11.12.2017 12:27:36','DD.MM.YYYY HH24:MI:SS'),'JDUSSA',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('99','QD2017-183','Arzneimittel Xermelo 250 mg Filmtabletten der Firma Ipsen Innovation in FR - (expiry date and lot number inversion) - StN AT','EMA',to_date('08.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('12.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,'<p>Wird bearbeitet!</p>
',to_date('14.12.2017 10:52:54','DD.MM.YYYY HH24:MI:SS'),'JDUSSA',to_date('12.12.2017 08:19:33','DD.MM.YYYY HH24:MI:SS'),'JDUSSA',null,null,null,null,null,null,null,'EMEND 80 mg Hartkapseln - OP(5x1)','EU/1/03/262/003','Merck Sharp','XY-21555','XY-20147',to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1',null,null,'Aprepitant',null,null,null,'2702452','3316407','1','Zulassungsinhaber',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('100','DE000100','Testfall34','BMEL',to_date('22.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('22.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','9',null,null,to_date('22.12.2017 09:38:56','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('22.12.2017 09:35:30','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Echter Warthaer Balsam',null,'Berg-Apotheke Othfresen','NRTAE2','NRET45',to_date('01.06.2020 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.02.2021 00:00:00','DD.MM.YYYY HH24:MI:SS'),'3',null,null,'Alantwurzelstock, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Aloe, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Benzoe, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Bitterkleebl�tter, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Campher, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Enzianwurzel, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Galgantwurzelstock, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Johanniskraut, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Kalmuswurzelstock, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Meisterwurzwurzelstock, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Myrrhe, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Rhabarberwurzel, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Sassafraswurzelholz, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Schwertlilienwurzelstock, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Tausendg�ldenkraut, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Weihrauch, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Zaunr�be, FE mit Ethanol/Ethanol-Wasser (%-Angaben)',null,null,'Landeskriminalamt Niedersachsen','0000738','0091824','1','Zulassungsinhaber',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('8','CGN4711','K�lle','erwr',to_date('29.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('29.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','4','1','jhsdjfhsdjkfhsdjfh',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('29.06.2017 13:19:44','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('76','DE12345','Neu','BFARM',to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','12',null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('31.07.2017 17:55:24','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Milinda GmbH','GE4321','gr34215',to_date('01.06.2025 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.05.2022 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,null,'Ledipasvir, Sofosbuvir',null,null,'Bezirksregierung D�sseldorf','2750150','3078936','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('80','DE111','fdfd','BVL',to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 15:13:42','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('02.08.2017 08:54:12','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('70','DE2453','Neuer Fall','BFARM',to_date('05.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 17:58:10','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Harvoni 90 mg/400 mg Filmtabletten - OP(3x28)','EU/1/14/958/002','Gilead Sciences International Limited',null,null,null,to_date('01.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,'Ledipasvir, Sofosbuvir',null,null,null,'2711769','8030549','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('71','DE23456','Harvoni2','BFARM',to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,'<p>bpuibdcpIUB&Uuml;OKINc</p>
',to_date('05.12.2017 14:20:16','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 18:57:52','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Gilead Sciences International Limited',null,null,to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,'Ledipasvir, Sofosbuvir',null,null,null,'2711768','8030549','2',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('72','DE1234','Beizeichnung','BFARM',to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('31.07.2017 11:40:48','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('73','DE','Beu','BFARM',to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 16:29:30','DD.MM.YYYY HH24:MI:SS'),'RAS_INTERN',to_date('31.07.2017 11:42:15','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'RAS_INTERN',to_date('05.12.2017 16:29:30','DD.MM.YYYY HH24:MI:SS'),null,null,null,'2',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('74','DE1234','Son Ding','BFARM',to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 16:53:22','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('31.07.2017 11:58:48','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Aspirinuom',null,'Bayer',null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('81','DE000081','Arzneimitteldiebstahl in K�ln','NW - Nordrhein-Westfalen',to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,'<p>Alle betroffenen AM sind als F&auml;lschung von Markt zu nehmen.</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('02.08.2017 09:22:18','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'mehrere','mehrere','mehrere','mehrere','mehrere',null,null,'1',null,null,'mehrere',null,null,'mehrere',null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('82','ghjkfkzzf',null,null,to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','10',null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('02.08.2017 09:34:33','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'Aspirin Nasenspray',null,null,null,null,to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,'Oxymetazolinhydrochlorid',null,null,null,'2137607','8011204','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('97','DE1234','Shanghai Fall','BFARM',to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','2',null,null,to_date('15.12.2017 17:05:13','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('11.12.2017 17:33:17','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'CiNU I',null,'Bristol Arzneimittel GmbH   [HIST]','YIAN01','YOIAN00',to_date('01.01.2020 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.02.2021 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,null,'Lomustin',null,null,null,'0027878','3336692','1','�rtlicher Vertreter',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,RAS_FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('98','DE1223454','Schleswig Container','BFARM',to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('14.12.2017 15:40:41','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('11.12.2017 17:54:05','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
--------------------------------------------------------
--  DDL for Index AMF_VORGANG_DEL_IDX
--------------------------------------------------------

  CREATE INDEX "AMF_VORGANG_DEL_IDX" ON "AMF_VORGANG" ("DELETED") 
  ;
--------------------------------------------------------
--  DDL for Index AMF_VORGANG_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "AMF_VORGANG_PK" ON "AMF_VORGANG" ("ID_VORGANG") 
  ;
  
  commit;
--------------------------------------------------------
--  DDL for Trigger AMF_VORGANG_STAAT_AU_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMF_VORGANG_STAAT_AU_TRG" 
before update of STAAT_ID on "AMF_VORGANG"
referencing old as old new as new
for each row
declare
l_de_id number;
begin
    select staat_id into l_de_id
    from bundesstaaten
    where iso_2 = 'DE';
    if :new.staat_id != l_de_id then
      :new.bundesland_id := null;
    end if;  
end;
/
ALTER TRIGGER "AMF_VORGANG_STAAT_AU_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger AMF_VORGANG_BIU_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMF_VORGANG_BIU_TRG" 
before insert or update on "AMF_VORGANG"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.ID_VORGANG is null) then
        select AMF_VORGANG_SEQ.nextval
        into :new.ID_VORGANG
        from dual;
        :new.AMF_MELDUNG_STATUS := 1;
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
ALTER TRIGGER "AMF_VORGANG_BIU_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger AMF_MELDUNG_BD_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMF_MELDUNG_BD_TRG" 
before delete on "AMF_VORGANG"
referencing old as old new as new
for each row
declare
  pragma autonomous_transaction;
begin
      "RAS_SOFT_DELETE" ('AMF_VORGANG', :old.id_vorgang);
end;
/
ALTER TRIGGER "AMF_MELDUNG_BD_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger AMF_STATUS_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMF_STATUS_TRG" 
before update of AMF_MELDUNG_STATUS on "AMF_VORGANG"
referencing old as old new as new
for each row
begin
    if (:new.AMF_MELDUNG_STATUS = 2) then -- locked
      :new.DELETED := sysdate;
      :new.DELETED_BY := nvl(v('APP_USER'), user);
    elsif (:new.AMF_MELDUNG_STATUS = 1) then -- opened
      :new.DELETED := null;
      :new.DELETED_BY := null;
    end if;
end;
/
ALTER TRIGGER "AMF_STATUS_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger AMF_DEL_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMF_DEL_TRG" 
before update of DELETED, DELETED_BY on "AMF_VORGANG"
referencing old as old new as new
for each row
begin
    if (:new.DELETED is not null) then -- locked
      :new.AMF_MELDUNG_STATUS := 2;
    end if;
end;
/
ALTER TRIGGER "AMF_DEL_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Procedure RAS_SOFT_DELETE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "RAS_SOFT_DELETE" (
p_table in varchar2,
p_id number,
p_msg in varchar2 :=' k�nnen nicht gel�scht werden!',
p_new_status varchar2 := 'LOCKED'
) is
pragma autonomous_transaction;
l_status_id pls_integer;
l_msg varchar2(1000);
begin
    select app_status_id into l_status_id
    from "APEX_APP_STATUS"
    where app_status = upper(nvl(p_new_status, 'LOCKED'));
    if (upper(p_table) = 'APEX_APP_USER') then
        l_msg := 'Benutzer'||p_msg;
        commit;
        update  "APEX_APP_USER"
        set deleted  = sysdate,
              deleted_by  = nvl(v('APP_USER'), user),
              app_user_status_id = l_status_id
        where APP_USER_ID = p_id;
    elsif  (upper(p_table) = 'RAS_DOMAINEN') then
        l_msg := 'Domainen'||p_msg;
        commit;
        update  "APEX_APP_USER"
        set deleted  = sysdate,
              deleted_by  = nvl(v('APP_USER'), user),
              app_user_status_id = l_status_id
        where app_user_domain_id  = p_id;
        update "RAS_DOMAINEN"
        set deleted = sysdate,
              deleted_by     = nvl(v('APP_USER'), user)
        where domain_id = p_id;
    elsif (upper(p_table) = 'AMF_VORGANG') then
        l_msg := 'RAS Vorg�nge'||p_msg;
        commit;
        UPDATE "AMF_VORGANG"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user),
              AMF_MELDUNG_STATUS = l_status_id
        where ID_VORGANG = p_id;    
    elsif (upper(p_table) = 'DOKUMENTE') then
        l_msg := 'RAS Vorgangsdokumente'||p_msg;
        commit;
        UPDATE "DOKUMENTE"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user)
        where ID_VORGANG = p_id;    
    elsif (upper(p_table) = 'BOB_LAENDER_ROW_DOKUMENTE') then
        l_msg := 'RAS Vorgangsdokumente'||p_msg;
        commit;
        UPDATE "BOB_LAENDER_ROW_DOKUMENTE"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user)
        where ID_VORGANG = p_id;   
    elsif (upper(p_table) = 'BOB_LAENDER_ROW_ERGAENZUNGEN') then
        l_msg := 'RAS Vorgangserg�nzungen'||p_msg;
        commit;
        UPDATE "BOB_LAENDER_ROW_ERGAENZUNGEN"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user)
        where ID_VORGANG = p_id;    
    end if;        
    commit;
    RAISE_APPLICATION_ERROR (-20002, l_msg, TRUE);
end;

/


 declare
 l_result pls_integer;
 begin
     send_mail(  p_mailto => 'Trivadis@bfarm.de'
               , p_result => l_result
               , p_topic  => 'REGISTER'
               , p_app_id => 100000   -- needed for Topic to work :-)
               , p_debug_only => false);
     dbms_output.put_line('*** Send Mail returned: ' || l_result);
 end;
 /
 

declare
l_result pls_integer;
l_userid pls_integer;
 begin
    insert into "APEX_USER_REGISTRATION" (apx_username, apx_user_email)
    values (nvl(:P102_USERNAME, :P102_USER_EMAIL), :P102_USER_EMAIL)
    returning apx_user_id into l_userid;
 
     send_mail(  p_mailto => :P102_USER_EMAIL
               , p_result => l_result
               , p_topic  => 'REGISTER'
               , p_app_id => v('APP_ID')
               , p_debug_only => false);
               
    if (l_result = 0) then
        update "APEX_USER_REGISTRATION"
        set apx_user_status_id = (select apx_status_id
                                    from "APX$STATUS"
                                    where apx_status = 'REGISTERED'
                                    and apx_status_ctx_id = (select apx_context_id
                                                             from "APX$CTX"
                                                             where apx_context = 'USER'))
       where apx_user_id = l_userid;
   end if;
    commit;
exception when others then
    apex_util.set_session_state('P0_USER_REG_STATUS', '-1');
end;

 


-- https://mathijsbruggink.com/2013/10/24/sending-mail-from-an-11g-oracle-database-utl_smtp/
-- If you set it up not for public but for dedicated users.
-- M Bruggink
-- Enabling  Mail functionality in Oracle
-- 20131024

connect / as sysdba;

-- @?/rdbms/admin/utlmail.sql
-- @?/rdbms/admin/prvtmail.plb


grant execute on utl_mail to public;

alter system set smtp_out_server = 'mail.bfarm.de:25' scope=both;

BEGIN
   DBMS_NETWORK_ACL_ADMIN.DROP_ACL(
      acl => 'smtp_access.xml');
END;
/

--Create an access control list:
BEGIN
   DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (
    acl          => 'smtp_access.xml',
    description  => 'Permissions to access e-mail server.',
    principal    => 'SYS',
    is_grant     => TRUE,
    privilege    => 'connect');
   COMMIT;
 END;
/

-- Assign the list to the smtp ( mail server ):
-- Note Default port is 25!

BEGIN
   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'smtp_access.xml',
    host         => 'mail.bfarm.de',
    lower_port   => 25,
    upper_port   => 25
    );
   COMMIT;
 END;
/
BEGIN
   DBMS_NETWORK_ACL_ADMIN.add_privilege (
    acl          => 'smtp_access.xml',
    principal    => 'SYSTEM',
    is_grant     => TRUE,
    privilege    => 'connect');
   COMMIT;
 END;
/

BEGIN
   DBMS_NETWORK_ACL_ADMIN.add_privilege (
    acl          => 'smtp_access.xml',
    principal    => 'RAS_INTERN',
    is_grant     => TRUE,
    privilege    => 'connect');
   COMMIT;
 END;
/

BEGIN
   DBMS_NETWORK_ACL_ADMIN.add_privilege (
    acl          => 'smtp_access.xml',
    principal    => 'RAS',
    is_grant     => TRUE,
    privilege    => 'connect');
   COMMIT;
 END;
/
-- check the setup
COLUMN host FORMAT A30
COLUMN acl FORMAT A30

SELECT host, lower_port, upper_port, acl
FROM   dba_network_acls;

COLUMN acl FORMAT A30
COLUMN principal FORMAT A30
set lines 200

SELECT acl,
       principal,
       privilege,
       is_grant,
       TO_CHAR(start_date, 'DD-MON-YYYY') AS start_date,
       TO_CHAR(end_date, 'DD-MON-YYYY') AS end_date
FROM   dba_network_acl_privileges;
spool off


SELECT acl,
       principal,
       privilege,
       is_grant,
       TO_CHAR(start_date, 'DD-MON-YYYY') AS start_date,
       TO_CHAR(end_date, 'DD-MON-YYYY') AS end_date
FROM   dba_network_acl_privileges;


fa-cog


style="display:none;"

fa-check-circle


t-success  = #USREG_CONFIRM > div.t-Login-header > span { color: green; font-size: 72px; }

P112_USERNAME
P112_USER_EMAIL


declare
    l_protocol varchar2(2000);
    l_host varchar2(4000);
    l_script varchar2(4000);
    
    l_instance_url varchar2(4000);
begin


   l_protocol      := owa_util.get_cgi_env('REQUEST_PROTOCOL');
--   l_host          := owa_util.get_cgi_env('HTTP_HOST');
--    l_script        := owa_util.get_cgi_env('SCRIPT_NAME');
    
--    l_instance_url := l_protocol;
--    l_instance_url := l_instance_url || '://';
--    l_instance_url := l_instance_url || l_host;
--    l_instance_url := l_instance_url || l_script;
--    l_instance_url := l_instance_url || '/';
    
    dbms_output.put_line(l_protocol);
  end;  
/

select  owa_util.get_cgi_env('HTTP_HOST') from dual;



       select apx_domain_id, apx_domain
      --  into :new_apx_user_domain_id, l_domain
        from "APX$DOMAIN"
        where upper(trim(apx_domain)) =
        upper(trim("PARSE_DOMAIN_FROM_EMAIL"(:new_apx_user_email)))
        and apx_domain_status_id = (select apx_status_id
                                    from "APX$STATUS"
                                    where apx_status = 'VALID'
                                    and apx_status_ctx_id = (select apx_context_id
                                                             from "APX$CTX"
                                                             where apx_context = 'DOMAIN'));


alter table APX$DOMAIN modify apx_domain_code varchar2(64);
alter table APX$DOMAIN modify apx_domain_name varchar2(512);

drop index "APX$DOMAIN_UNQ1";
drop index "APX$DOMAIN_UNQ3";

create unique index "APX$DOMAIN_UNQ1"   on "APX$DOMAIN"(upper(trim(apx_domain_name)), app_id);
--create unique index "APX$DOMAIN_UNQ2"   on "APX$DOMAIN"(upper(trim(apx_domain)), app_id);
create unique index "APX$DOMAIN_UNQ3"   on "APX$DOMAIN"(upper(trim(apx_domain_name)), upper(trim(apx_domain)), app_id);

grant insert, update, delete on "APX$DOMAIN" to ras_intern;


insert into "RAS"."APX$DOMAIN" (apx_domain_id, apx_domain, apx_domain_name, apx_domain_code, apx_domain_description)
SELECT DOMAIN_ID,  DOMAIN, DOMAIN_OWNER||' ' ||DOMAIN_CODE, DOMAIN_CODE, DOMAIN_OWNER
FROM "RAS_INTERN"."RAS_DOMAINEN"
;

commit;

SELECT count(*), upper(trim(DOMAIN_OWNER))
FROM RAS_INTERN.RAS_DOMAINEN
group by upper(trim(DOMAIN_OWNER))
having count (*) > 1;

drop sequence "APX$DOMAIN_ID_SEQ";
create sequence "APX$DOMAIN_ID_SEQ" start with 80 nocache nocycle;




alter table "RAS_DOMAINEN" modify STATUS_ID number default 15;


grant select on ras_domainen to ras;

commit;

create or replace trigger "RAS_DOMAINEN_BIUD_TRG" 
before insert or update or delete on "RAS_DOMAINEN"
referencing new as new old as old
for each row
begin
  if inserting then
    insert into "RAS"."APX$DOMAIN" (apx_domain_id, apx_domain, apx_domain_name, apx_domain_code, apx_domain_description)
    values (:new.DOMAIN_ID,  :new.DOMAIN, :new.DOMAIN_OWNER||' ' ||:new.DOMAIN_CODE, :new.DOMAIN_CODE, :new.DOMAIN_OWNER);
  elsif updating then
    update "RAS"."APX$DOMAIN"
    set   apx_domain                   =  :new.DOMAIN
          , apx_domain_name         =  :new.DOMAIN_OWNER||' ' ||:new.DOMAIN_CODE
          , apx_domain_code          = :new.DOMAIN_CODE
          , apx_domain_description = :new.DOMAIN_OWNER
    where apx_domain_id = :new.DOMAIN_ID;
  elsif deleting then
        update "RAS"."APX$DOMAIN"
    set   apx_domain_status_id =  5
    where apx_domain_id = :old.DOMAIN_ID;
  end if;
end;
/

select ras_domains_id_seq.nextval from dual;

create or replace trigger "RAS_DOMAINEN_BD_TRG" 
before delete on "RAS_DOMAINEN"
referencing old as old new as new
for each row
  declare
  pragma autonomous_transaction;
  begin
    -- now soft delete
      "RAS_SOFT_DELETE" ('RAS_DOMAINEN', :old.domain_id);
  end;
/

create or replace trigger "RAS_DOMAINEN_BU_DEL_TRG" 
before update of DELETED on "RAS_DOMAINEN"
referencing new as new
for each row
begin
    if (:new.deleted is not null) then
       update "RAS"."APX$DOMAIN"
       set   apx_domain_status_id =  5
       where upper(trim(apx_domain)) = upper(trim(:new.DOMAIN));
  end if;  
end;
/


alter table APX$USER add apx_user_last_login date;
alter table APX$USER add apx_user_token_created date;
alter table APX$USER add apx_user_token_valid_until date;
alter table APX$USER add apx_user_token_ts timestamp(6) with time zone;
alter table APX$USER add apx_user_token varchar2(4000);
alter table APX$USER add apx_app_user_id number;
alter table APX$USER add apex_user_id number;



create or replace procedure "APX_CREATE_USER" (
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
            if (l_userid is null) then -- get a fresh ID from sequence
                select ras_intern.apex_app_user_id_seq.nextval
                into l_userid
                from dual;
            end if;    
            begin
            /* -- double bookkeeping not needed for BFARM
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
   */
            insert into "RAS_INTERN"."APEX_APP_USER"  (
                APP_USER_ID,
                APP_USERNAME,
                APP_USER_EMAIL,
                APP_USER_DEFAULT_ROLE_ID,
                APP_USER_CODE,
                APP_USER_AD_LOGIN,
                APP_USER_NOVELL_LOGIN,
                APP_USER_FIRST_NAME,
                APP_USER_LAST_NAME,
                APP_USER_ADRESS,
                APP_USER_PHONE1,
                APP_USER_PHONE2,
                APP_USER_DESCRIPTION,
                APP_USER_STATUS_ID,
                APP_USER_PARENT_USER_ID,
                APP_ID,
                APP_USER_TOKEN,
                APP_USER_TOKEN_LAST_UPDATE,
                APP_USER_DOMAIN_ID,
                APP_USER_MELDER_ID) 
            (select 
              APX_USER_ID,
              APX_USERNAME,
              APX_USER_EMAIL,
              APX_USER_DEFAULT_ROLE_ID,
              APX_USER_CODE,
              APX_USER_AD_LOGIN,
              APX_USER_HOST_LOGIN,
              APX_USER_FIRST_NAME,
              APX_USER_LAST_NAME,
              APX_USER_ADRESS,
              APX_USER_PHONE1,
              APX_USER_PHONE2,
              APX_USER_DESCRIPTION,
              (select  STATUS_ID
               from "RAS_INTERN"."APEX_STATUS"
               where status = 'OPEN' 
               and status_scope = 'ACCOUNT'),
              APX_USER_PARENT_USER_ID,
              APP_ID,
              APX_USER_TOKEN,
              APX_USER_TOKEN_CREATED,
              APX_USER_DOMAIN_ID,
             (select ras_melder_id 
              from  "RAS_INTERN"."RAS_DOMAIN_GRUPPEN" 
              where ras_domain_id = APX_USER_DOMAIN_ID)
            from APEX_USER_REGISTRATION
            where apx_user_token = l_token
            );

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


---------------------------------------------------------------------------------------------------
--1. create package+body in sqlplus (connected as workspace schema)

--------------------------------------------------------------------------------

create or replace package "APEX_CREATE_USER_PKG" 
authid current_user
as

-- create and set job
  procedure "CREATE_USER_JOB" (
      p_result           number
    , p_username         varchar2
    , p_first_name       varchar2
    , p_last_name        varchar2
    , p_web_password     varchar2
    , p_email_address    varchar2
    , p_token            varchar2
    , p_app_id           number
    , p_default_schema   varchar2
  );

procedure "DO_CREATE_USER" (
      p_result           number
    , p_username         varchar2
    , p_first_name       varchar2
    , p_last_name        varchar2
    , p_web_password     varchar2
    , p_email_address    varchar2
    , p_token            varchar2
    , p_app_id           number
    , p_default_schema   varchar2
    );

end "APEX_CREATE_USER_PKG";
/

create or replace package body "APEX_CREATE_USER_PKG" 
as

-- create and set job
procedure "CREATE_USER_JOB" (
    p_result           number
  , p_username         varchar2
  , p_first_name       varchar2
  , p_last_name        varchar2
  , p_web_password     varchar2
  , p_email_address    varchar2
  , p_token            varchar2
  , p_app_id           number
  , p_default_schema   varchar2
)
is
begin
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 1,
        argument_value => p_result 
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 2,
        argument_value => p_username 
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 3,
        argument_value => p_first_name 
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 4,
        argument_value =>  p_last_name
        );        
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 5,
        argument_value => p_web_password 
        );        
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 6,
        argument_value => p_email_address 
        );                        
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 7,
        argument_value => p_token 
        ); 
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 8,
        argument_value => p_app_id 
        ); 
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 9,
        argument_value => p_default_schema 
        ); 

    dbms_scheduler.run_job (
        job_name => 'CREATE_USER_JOB',
        use_current_session => false );

end "CREATE_USER_JOB";

-- create apex user
procedure "DO_CREATE_USER" (
      p_result           number
    , p_username         varchar2
    , p_first_name       varchar2
    , p_last_name        varchar2
    , p_web_password     varchar2
    , p_email_address    varchar2
    , p_token            varchar2
    , p_app_id           number
    , p_default_schema   varchar2
    )
is
    -- Local Variables
    l_username           varchar2(128);
    l_result             varchar2(4000);
    l_result_code        pls_integer;
    l_email_address      varchar2(128);
    l_first_name         varchar2(128);
    l_last_name          varchar2(128);
    l_token              varchar2(4000);
    l_web_password       varchar2(1000);
    l_default_schema     varchar2(1000);
    l_app_id             number;
begin

  -- Setting Locals Defaults
    l_email_address                 := p_email_address;
    l_username                      := nvl(p_username, p_email_address);
    l_first_name                    := p_first_name;
    l_last_name                     := p_last_name;
    l_token                         := p_token;
    l_web_password                  := p_web_password;
    l_default_schema                := nvl(p_default_schema   , 'RAS_INTERN');
    l_app_id                        := nvl(p_app_id           , v('APP_ID'));
    l_result                        := nvl(p_result           , 0);

    -- set Apex Environment
    for c1 in (
        select workspace_id
        from apex_applications
        where application_id = l_app_id 
        ) loop
        apex_util.set_security_group_id(
            p_security_group_id => c1.workspace_id
            );
    end loop;
    

    "APX_CREATE_USER" (  p_result           => l_result
                       , p_username         => l_username
                       , p_first_name       => l_first_name
                       , p_last_name        => l_first_name
                       , p_web_password     => l_web_password
                       , p_email_address    => l_email_address
                       , p_token            => l_token
                       , p_app_id           => l_app_id
                       , p_default_schema   => l_default_schema);

end "DO_CREATE_USER";

end "APEX_CREATE_USER_PKG";
/


--- DBMS_SCHEDULER Job to create Users
begin
    dbms_scheduler.create_job (
    job_name => 'CREATE_APEX_USER_JOB',
    job_type => 'STORED_PROCEDURE',
    job_action => 'APEX_CREATE_USER_PKG."DO_CREATE_USER"',
    number_of_arguments => 9,
    enabled => false );
end;
/


/*
3. create application with item P1_USERNAME and button
4. create submit process that calls
jobtest.run_reset_pwd_job(:P1_USERNAME);
*/





HOME	Willkommen auf unserer Website				"<p>
 Hier finden Sie alles, um sich auf unserer Webseite zurechtzufinden...
</p>"
LOCK	Konto ist gesperrt!				"<p>Ihr Konto wurde gesperrt<br />
  Bitte setzen Sie Ihr Kennwort auf unserer
  <a href="##APX_APP_PAGE##">Passwort Reset</a> Seite zurück, <br />
 um Ihr Konto zu entsperren.
</p>"
UNLOCK	Konto wurde entsperrt!				"<p>Ihr Konto wurde erfolgreich entsperrt.<br />
  Bitte setzen Sie ein neues Kennwort auf unserer
  <a href="##APX_APP_PAGE##">Passwort Reset</a> Seite.
</p>"
REGISTER	Registrierungsbestätigung				"<p>
  Bitte bestätigen Sie Ihre Registrierung auf unserer <a href="##APX_APP_PAGE##">Registrierungsseite</a> unseres Portals.
</p>"
REREGISTER	Registrierungsbestätigung				"<p>
  Vielen Dank, das sie sich erneut registriert haben.<br />
  Bitte bestätigen Sie Ihre Registrierung auf unserer <a href="##APX_APP_PAGE##">Registrierungsbestätigungs</a> Seite.
</p>"
DEREGISTER	Deregistrierungsbestätigung				"<p>
  Hiermit bestätigen wir Ihre Deregistrierung aus unserem System.
</p>"
RESET_PW	Informationen zu Kennwortrücksetzung				"<p>
 Sie erhalten diese Mail als Antwort auf Ihren Paswort Rücksetzungsanfrage.<br />
  Bitte setzen Sie sich ein neues Passwort auf unserer <a href="##APX_APP_PAGE##">Passwort Reset</a> Seite.
</p>"
RESET_REG_ATTEMPTS	Registrierungsbestätigung				"<p>
  Ihr Konto wurde zur erneuten Registrierung freigegeben.<br />
  Bitte bestätigen Sie Ihre Registrierung auf unserer <a href="##APX_APP_PAGE##">Registrierungsbestätigungs</a> Seite.
</p>"
REG_ATTEMPTS_EXCEEDED	maximale Registrierungsversuche überschritten				"<p>
  Ihre Registrierung wurde gesperrt, da Sie die maximalen Registrierungsversuche überschritten haben.<br />
  Bitte kontaktieren Sie unsere <a href="##APX_APP_PAGE##">Hilfe</a> Seite für mehr Informationen.
</p>"




select "PARSE_DOMAIN_FROM_EMAIL"(:new_apx_user_email) from dual;


select * from  USER_ROLE_PRIVS;

create table logt (id number, msg varchar2(4000));


create or replace package jobtest as

procedure run_reset_pwd_job (
p_username in varchar2 );

procedure do_reset_pwd (
p_username in varchar2 );

end jobtest;
/
create or replace package body jobtest as

procedure run_reset_pwd_job (
p_username in varchar2 )
is
begin
dbms_scheduler.set_job_argument_value (
job_name => 'RESET_PWD_JOB',
argument_position => 1,
argument_value => p_username );
dbms_scheduler.run_job (
job_name => 'RESET_PWD_JOB',
use_current_session => false );
end run_reset_pwd_job;

procedure do_reset_pwd (
p_username in varchar2 )
is
begin
apex_util.set_security_group_id(apex_util.find_security_group_id('APEX_TEST'));
apex_util.reset_pw (
p_user => p_username,
p_msg => p_username||', your password in workspace APEX_TEST has been reset.' );
       insert into LOGT values (1, 'Before Creating Apex User');
       commit;
end do_reset_pwd;

end jobtest;
/




begin
dbms_scheduler.create_job (
job_name => 'RESET_PWD_JOB',
job_type => 'STORED_PROCEDURE',
job_action => 'JOBTEST.DO_RESET_PWD',
number_of_arguments => 1,
enabled => false );
end;
/

begin
dbms_scheduler.drop_job (
job_name => 'RESET_PWD_JOB' );
end;
/


--------------------------------------------------------------------------------

create or replace package "APEX_CREATE_USER_PKG" 
authid current_user
as

-- create and set job
  procedure "CREATE_USER_JOB" (
      p_result           number
    , p_username         varchar2
    , p_first_name       varchar2
    , p_last_name        varchar2
    , p_web_password     varchar2
    , p_email_address    varchar2
    , p_token            varchar2
    , p_app_id           number
    , p_default_schema   varchar2
  );

procedure "DO_CREATE_USER" (
      p_result           number
    , p_username         varchar2
    , p_first_name       varchar2
    , p_last_name        varchar2
    , p_web_password     varchar2
    , p_email_address    varchar2
    , p_token            varchar2
    , p_app_id           number
    , p_default_schema   varchar2
    );

end "APEX_CREATE_USER_PKG";
/

create or replace package body "APEX_CREATE_USER_PKG" 
as

-- create and set job
procedure "CREATE_USER_JOB" (
    p_result           number
  , p_username         varchar2
  , p_first_name       varchar2
  , p_last_name        varchar2
  , p_web_password     varchar2
  , p_email_address    varchar2
  , p_token            varchar2
  , p_app_id           number
  , p_default_schema   varchar2
)
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

end "CREATE_USER_JOB";

-- create apex user
procedure "DO_CREATE_USER" (
      p_result           number
    , p_username         varchar2
    , p_first_name       varchar2
    , p_last_name        varchar2
    , p_web_password     varchar2
    , p_email_address    varchar2
    , p_token            varchar2
    , p_app_id           number
    , p_default_schema   varchar2
    )
is
    -- Local Variables
    l_username           varchar2(128);
    l_result             varchar2(4000);
    l_result_code        pls_integer;
    l_email_address      varchar2(128);
    l_first_name         varchar2(128);
    l_last_name          varchar2(128);
    l_token              varchar2(4000);
    l_web_password       varchar2(1000);
    l_default_schema     varchar2(1000);
    l_app_id             number;
begin

  -- Setting Locals Defaults
    l_email_address                 := p_email_address;
    l_username                      := nvl(p_username, p_email_address);
    l_first_name                    := p_first_name;
    l_last_name                     := p_last_name;
    l_token                         := p_token;
    l_web_password                  := p_web_password;
    l_default_schema                := nvl(p_default_schema   , 'RAS_INTERN');
    l_app_id                        := nvl(p_app_id           , v('APP_ID'));
    l_result                        := nvl(p_result           , 0);

    -- set Apex Environment
    for c1 in (
        select workspace_id
        from apex_applications
        where application_id = l_app_id 
        ) loop
        apex_util.set_security_group_id(
            p_security_group_id => c1.workspace_id
            );
    end loop;
    

    "APX_CREATE_USER" (  p_result           => l_result
                       , p_username         => l_username
                       , p_first_name       => l_first_name
                       , p_last_name        => l_first_name
                       , p_web_password     => l_web_password
                       , p_email_address    => l_email_address
                       , p_token            => l_token
                       , p_app_id           => l_app_id
                       , p_default_schema   => l_default_schema);

end "DO_CREATE_USER";

end "APEX_CREATE_USER_PKG";
/


--- DBMS_SCHEDULER Job to create Users
begin
    dbms_scheduler.create_job (
    job_name => 'CREATE_APEX_USER_JOB',
    job_type => 'STORED_PROCEDURE',
    job_action => 'APEX_CREATE_USER_PKG."DO_CREATE_USER"',
    number_of_arguments => 9,
    enabled => false );
end;
/


--------------------------------------------------------------------------------------
create or replace package body "APEX_CREATE_USER_PKG" 
as

-- create and set job
procedure "CREATE_USER_JOB" (
    p_result           number
  , p_username         varchar2
  , p_first_name       varchar2
  , p_last_name        varchar2
  , p_web_password     varchar2
  , p_email_address    varchar2
  , p_token            varchar2
  , p_app_id           number
  , p_default_schema   varchar2
)
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

end "CREATE_USER_JOB";

-- create apex user
procedure "DO_CREATE_USER" (
      p_result           number
    , p_username         varchar2
    , p_first_name       varchar2
    , p_last_name        varchar2
    , p_web_password     varchar2
    , p_email_address    varchar2
    , p_token            varchar2
    , p_app_id           number
    , p_default_schema   varchar2
    )
is
    -- Local Variables
    l_username           varchar2(128);
    l_result             varchar2(4000);
    l_result_code        pls_integer;
    l_email_address      varchar2(128);
    l_first_name         varchar2(128);
    l_last_name          varchar2(128);
    l_token              varchar2(4000);
    l_web_password       varchar2(1000);
    l_default_schema     varchar2(1000);
    l_app_id             number;
begin

  -- Setting Locals Defaults
    l_email_address                 := p_email_address;
    l_username                      := nvl(p_username, p_email_address);
    l_first_name                    := p_first_name;
    l_last_name                     := p_last_name;
    l_token                         := p_token;
    l_web_password                  := p_web_password;
    l_default_schema                := nvl(p_default_schema   , 'RAS_INTERN');
    l_app_id                        := nvl(p_app_id           , 100002);
    l_result                        := nvl(p_result           , 0);

    -- set Apex Environment
    for c1 in (
        select workspace_id
        from apex_applications
        where application_id = l_app_id 
        ) loop
        apex_util.set_security_group_id(
            p_security_group_id => c1.workspace_id
            );
    end loop;
    

    "APX_CREATE_USER" (  p_result           => l_result
                       , p_username         => l_username
                       , p_first_name       => l_first_name
                       , p_last_name        => l_first_name
                       , p_web_password     => l_web_password
                       , p_email_address    => l_email_address
                       , p_token            => l_token
                       , p_app_id           => l_app_id
                       , p_default_schema   => l_default_schema);

end "DO_CREATE_USER";

end "APEX_CREATE_USER_PKG";


    if (l_topic = 'REGISTER') then
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
    elsif (l_topic = 'REREGISTER') then
        update "APEX_USER_REGISTRATION"
        set   APX_USER_TOKEN = APX_GET_TOKEN(l_username||l_app_id)
              , APX_USER_TOKEN_CREATED =sysdate
        where upper(trim(apx_username)) = upper(trim(l_username))      
        returning apx_user_id, apx_username, apx_user_token
        into l_userid, l_username, l_token;    
    else
       l_result := 1;
    end if;   




create or replace force view "RAS_INTERN"."RAS_AMIS_MAH" ("ZNR", "ENR", "AM", "MAH", "PNR", "ISO", "REGBEZ", "PNRAEANZ", "PNRSTM", "FSTR", "FPORT", "FPLZO", "ZUBPNR") 
as 
select znr, enr, am, mah, pnr, iso, regbez, pnraeanz, pnrstm, fstr, fport, fplzo, zubpnr
from rasdata.ras_amis_mah_mv ;


create or replace force view "RAS_INTERN"."RAS_WIRKSTOFFE" ("ZNR", "ENR", "AM", "WIRKSTOFF", "MAH", "PNR", "ISO", "REGBEZ", "PNRAEANZ", "PNRSTM", "FSTR", "FPORT", "FPLZO", "ZUBPNR") AS 
with wrkst
as (
select q.enr, listagg(bez1,', ') within group(order by bez1) as bez1
from (
select enr, bez1 from rasdata.ras_amis_wrkst_mv
) q
group by q.enr
)
select /*+  h.znr, h.enr, h.AM, w.bez1 as WIRKSTOFF, h.mah, h.PNR as PNR, h.ISO,
           h.REGBEZ, h.PNRAEANZ, h.PNRSTM, h.FSTR, h.FPORT, h.FPLZO, h.ZUBPNR
from rasdata.ras_amis_mah_mv h , wrkst w
where h.PNR != 0000000
and h.enr = w.enr
;
*/    

exception when others then
raise_application_error(-20001, 'User '|| v('RUSER') || ' Token: '|| v('RTOKEN') || 
                        ' 3 ResetStatus: '|| apex_util.get_session_state('P0_USER_RST_STATUS') ||' AppId: '||:APP_ID);

l_result := 'RESET_ERROR';
apex_util.set_session_state('P0_USER_RST_STATUS', l_result);    


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
               from "RAS_INTERN"."APEX_APP_USER"
               where upper(trim(app_username)) = l_username
                 and app_user_token = l_token
                 and app_user_token_last_update +1 >= sysdate) loop
        l_return := case c1.token_valid when 1 then true end;
    end loop;
    return l_return;
exception when others then
raise;
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
               from "RAS_INTERN"."APEX_APP_USER"
               where upper(trim(app_username)) = l_username
                 and app_user_token = l_token
                 and app_user_token_last_update +1 >= sysdate) loop
        l_return := case c1.token_valid when 1 then true end;
    end loop;
    return l_return;
exception when others then
raise;
end;
/

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

--- APEX User Management Validate (SQL Exists returning no rows) Stefan Obermeyer 06.2017 ---
select 1 from user_objects
where object_name in (
'APEX_ACCOUNT_STATUS',
'APEX_ALL_APPLICATIONS',
'APEX_ALL_ROLES',
'APEX_ALL_USERS',
'APEX_APPLICATION',
'APEX_APPLICATIONS',
'APEX_APPLICATION_ROLES',
'APEX_APPLICATION_STATUS',
'APEX_APPUSRDEFROL_TRG',
'APEX_APP_ROLE',
'APEX_APP_ROLE_BIU_TRG',
'APEX_APP_ROLE_ID_SEQ',
'APEX_APP_STATUS',
'APEX_APP_STATUS_BIU_TRG',
'APEX_APP_STATUS_ID_SEQ',
'APEX_APP_SYS_BUILTINS',
'APEX_APP_SYS_ROLES',
'APEX_APP_SYS_USERS',
'APEX_APP_USER',
'APEX_APP_USERROLE_SEQ',
'APEX_APP_USER_BIU_TRG',
'APEX_APP_USER_ID_SEQ',
'APEX_APP_USER_ROLE_MAP',
'APEX_APP_USRROL_BIU_TRG',
'APEX_DEFAULT_ROLE',
'APEX_INTERN_APPLICATIONS',
'APEX_ROLES',
'APEX_STATUS',
'APEX_SYS_BUILTINS',
'APEX_USERS',
'APEX_USER_APPLICATIONS',
'APEX_USER_ROLE',
'APEX_USER_ROLES',
'APEX_WORKSPACE',
'APEX_WORKSPACE_USERS',
'APPLICATION_ADMINS',
'WORKSPACE_ADMINS',
'GET_CODE_SECURITY_LEVEL',
'GET_ROLE_CODE_SECURITY_LEVEL',
'GET_ROLE_SECURITY_LEVEL',
'GET_SECURITY_LEVEL',
'GET_USER_SECURITY_LEVEL',
'HAS_ROLE',
'IS_SYS_CODE',
'IS_SYS_ROLE',
'IS_SYS_USER',
'IS_USER'
);


 drop table "DOMAINEN" ;

--- rename VALID_DOMAINS to DOMAINEN;
 create table "DOMAINEN" (
  "DOMAIN_ID" number not null, 
	"DOMAIN" varchar2(128), 
  "DOMAIN_OWNER" varchar2(512),
	"DOMAIN_CODE" varchar2(32),
  "DNS_NOT_RESOLVED" NUMBER,
	"MODIFIED" date, 
	"MODIFIED_BY" varchar2(30 byte), 
	"CREATED" date, 
	"CREATED_BY" varchar2(30 byte), 
	"GRUPPEN_ID" number,
  "DELETED" date,
  "DELETED_BY" varchar2(30 byte), 
  constraint "VALID_DOMAINS_PK" primary key ("DOMAIN_ID"),
  constraint "GRP_FK" foreign key ("GRUPPEN_ID") references "GRUPPEN" ("GRUPPEN_ID") on delete set null
);

drop sequence "VALID_DOMAINS_ID_SEQ";
create sequence "VALID_DOMAINS_ID_SEQ"  increment by 1 start with 69 nocache noorder nocycle;

-- regular before Update Insert Trigger
create or replace trigger "VALID_DOMAINS_BIU_TRG" 
before insert or update on "DOMAINEN"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.domain_id is null) then
        select valid_domains_id_seq.nextval
        into :new.domain_id
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

drop trigger "VALID_DOMAINS_BD_TRG" ;

create or replace trigger "VALID_DOMAINS_BD_TRG" 
before delete on "DOMAINEN"
referencing old as old new as new
for each row
  declare
  pragma autonomous_transaction;
  begin
    UPDATE  "APEX_APP_USER"
    SET APP_USER_STATUS_ID = (select app_status_id 
                                                  from "APEX_APP_STATUS" 
                                                  where app_status = 'LOCKED' )
    WHERE domain_id = :old.domain_id;
    UPDATE  "DOMAINEN"
    SET DELETED = sysdate,
           DELETED_BY = nvl(v('APP_USER'), user)
    where DOMAIN_ID = :old.domain_id;
    commit;
    RAISE_APPLICATION_ERROR (-20002, 'Domainen Daten koennen nicht gel�scht werden!', TRUE); 
  end;
/

create or replace view "DOMAINS"
as 
  select 
  domain_id,
  domain,
  domain_owner,
  domain_code,
  dns_not_resolved,
  modified,
  modified_by,
  created,
  created_by,
  deleted,
  deleted_by
from "DOMAINEN"
order by 1;

--INSERT INTO "DOMAINEN" (
--    DOMAIN_ID,
--    DOMAIN,
--    DOMAIN_OWNER,
--    DOMAIN_CODE,
--    DNS_NOT_RESOLVED,
--    MODIFIED,
--    MODIFIED_BY,
--    CREATED,
--    CREATED_BY)
--  (select  DOMAIN_ID,
--    DOMAIN,
--    DOMAIN_OWNER,
--    DOMAIN_CODE,
--    DNS_NOT_RESOLVED,
--    MODIFIED,
--    MODIFIED_BY,
--    CREATED,
--    CREATED_BY
--    from "BUNDESDOMAINEN");
--
--commit;

DROP SEQUENCE "DOMAINS_ID_SEQ";

CREATE SEQUENCE  "DOMAINS_ID_SEQ"  INCREMENT BY 1 START WITH 70 NOCACHE  NOORDER  NOCYCLE ;

CREATE SEQUENCE  "INTERN"."APX$APP_USERS_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;

CREATE OR REPLACE TRIGGER "VALID_DOMAINS_BIU_TRG" 
before insert or update on "DOMAINEN"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.domain_id is null) then
        select domains_id_seq.nextval
        into :new.domain_id
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


create or replace view "DOMAIN_GRUPPEN"
as 
  select 
  r.DOMAIN_ID,
  r.DOMAIN,
  r.DOMAIN_CODE,
  r.DOMAIN_OWNER,
  r.DOMAIN_GROUP_ID as GRUPPEN_ID,
  g.INFO_GRUPPE as GRUPPE,
  g.INFO_GRUPPE_CODE as GRUPPEN_CODE
from "DOMAINEN" r left outer join "GRUPPEN" g
on (r.DOMAIN_GROUP_ID = g.GRUPPEN_ID);



alter table AMF_VORGANG modify AMF_MELDUNG_STATUS default 1;
alter table APEX_APP_USER add APP_USER_DOMAIN_ID number;
alter table APEX_APP_USER add constraint "APP_USER_DOMAIN_FK" foreign key (APP_USER_DOMAIN_ID) references  "DOMAINEN"(domain_id);



create or replace trigger "AMF_VORGANG_BIU_TRG"
before insert or update on "AMF_VORGANG"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.ID_VORGANG is null) then
        select AMF_VORGANG_SEQ.nextval
        into :new.ID_VORGANG
        from dual;
        :new.AMF_MELDUNG_STATUS := 1;
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

alter table AMF_VORGANG add ART_DER_ZUSTAENDIGKEIT varchar2(200);
alter table AMF_VORGANG add ART_DER_ZUSTAENDIGKEIT_SONST varchar2(1000);


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
    if (:new.app_user_domain_id is null or :new.app_user_group_id is null) then
        select d.domain_id, d.domain_group_id
        into :new.app_user_domain_id, :new.app_user_group_id
        from "DOMAINEN" d
        where lower(trim(d.domain)) = lower(substr(:new.app_user_email, instr(:new.app_user_email, '@') +1));
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


update "APEX_APP_USER" u set u.app_user_domain_id = 
(select d.domain_id 
from "DOMAINEN" d 
where lower(d.domain) = lower(substr(u.app_user_email, instr(u.app_user_email, '@') +1))
);

commit;

--- Status View New
create or replace view "APEX_STATUS"
as 
  select 
  app_id,
  app_status_id as status_id,
  app_status as status,
  app_status_code as status_code,
  app_status_scope as status_scope,
  is_default,
  created,
  created_by,
  modified,
  modified_by
from "APEX_APP_STATUS"
where app_id = nvl(v('APP_ID'), app_id)
order by 1, 3;


create or replace view "APEX_STATUS_DEFAULT"
as 
  select 
  app_id,
  app_status_id as status_id,
  app_status as status,
  app_status_code as status_code,
  app_status_scope as status_scope,
  is_default,
  created,
  created_by,
  modified,
  modified_by
from "APEX_APP_STATUS"
where app_id = nvl(v('APP_ID'), app_id)
and is_default = 1
order by 1, 3;


CREATE OR REPLACE VIEW "APEX_ALL_USERS"
  AS 
  select distinct
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
  u.MODIFIED_BY,
  u.DELETED,
  u.DELETED_BY
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


GRANT SELECT ON "INTERN"."APEX_ALL_USERS" TO "APEX_ADMIN";


CREATE OR REPLACE VIEW "APEX_APPLICATION_USERS"
AS 
  select APP_ID,
  APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_ACCOUNT_STATUS,
  APP_USER_AD_LOGIN as AD_LOGIN,
  APP_USER_NOVELL_LOGIN as NOVELL_LOGIN,
  APP_USER_DEFAULT_ROLE_ID,
  DEFAULT_ROLE,
  APP_USER_PARENT_USER_ID,
  PARENT_USERNAME,
  APP_USER_DEFAULT_ROLE_ID as USER_DEFAULT_SECURITY_LEVEL,
  MAX_SECURITY_LEVEL as USER_MAX_SECURITY_LEVEL,
  MIN_SECURITY_LEVEL as USER_MIN_SECURITY_LEVEL,  
  CREATED,
  CREATED_BY,
  MODIFIED,
  MODIFIED_BY,
  DELETED,
  DELETED_BY
from "APEX_ALL_USERS"
where APP_ID = nvl(v('APP_ID'), app_id)
order by 2 desc
;


GRANT SELECT ON "INTERN"."APEX_APPLICATION_USERS" TO "APEX_ADMIN";


alter table DOKUMENTE add DELETED date;
alter table DOKUMENTE add DELETED_BY varchar2(30);

alter table BOB_LAENDER_ROW_ERGAENZUNGEN add DELETED date;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN add DELETED_BY varchar2(30);


create or replace procedure "SOFT_DELETE" (
p_table in varchar2,
p_id number,
p_msg in varchar2 :=' k�nnen nicht gel�scht werden!',
p_new_status varchar2 := 'LOCKED'
) is
pragma autonomous_transaction;
l_status_id pls_integer;
l_msg varchar2(1000);
begin
    select app_status_id into l_status_id
    from "APEX_APP_STATUS"
    where app_status = upper(nvl(p_new_status, 'LOCKED'));
    if (upper(p_table) = 'APEX_APP_USER') then
        l_msg := 'Benutzer'||p_msg;
        commit;
        update  "APEX_APP_USER"
        set deleted  = sysdate,
              deleted_by  = nvl(v('APP_USER'), user),
              app_user_status_id = l_status_id
        where APP_USER_ID = p_id;
    elsif  (upper(p_table) = 'DOMAINEN') then
        l_msg := 'Domainen'||p_msg;
        commit;
        update  "APEX_APP_USER"
        set deleted  = sysdate,
              deleted_by  = nvl(v('APP_USER'), user),
              app_user_status_id = l_status_id
        where app_user_domain_id  = p_id;
        update "DOMAINEN"
        set deleted = sysdate,
              deleted_by     = nvl(v('APP_USER'), user)
        where domain_id = p_id;
    elsif (upper(p_table) = 'AMF_VORGANG') then
        l_msg := 'RAS Vorg�nge'||p_msg;
        commit;
        UPDATE "AMF_VORGANG"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user),
              AMF_MELDUNG_STATUS = l_status_id
        where ID_VORGANG = p_id;    
    elsif (upper(p_table) = 'DOKUMENTE') then
        l_msg := 'RAS Vorgangsdokumente'||p_msg;
        commit;
        UPDATE "DOKUMENTE"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user)
        where ID_VORGANG = p_id;    
    elsif (upper(p_table) = 'BOB_LAENDER_ROW_DOKUMENTE') then
        l_msg := 'RAS Vorgangsdokumente'||p_msg;
        commit;
        UPDATE "BOB_LAENDER_ROW_DOKUMENTE"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user)
        where ID_VORGANG = p_id;   
    elsif (upper(p_table) = 'BOB_LAENDER_ROW_ERGAENZUNGEN') then
        l_msg := 'RAS VorgangsERGAENZUNGEN'||p_msg;
        commit;
        UPDATE "BOB_LAENDER_ROW_ERGAENZUNGEN"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user)
        where ID_VORGANG = p_id;    
    end if;        
    commit;
    RAISE_APPLICATION_ERROR (-20002, l_msg, TRUE);
end;
/

/*

begin "SOFT_DELETE" ('APEX_APP_USER', 4); end;
/

begin "SOFT_DELETE" ('DOMAINEN', 70); end;
/

begin "SOFT_DELETE" ('AMF_VORGANG', 73); end;
/

delete from apex_app_user where app_user_id = 4; -- testuser
delete from DOMAINEN where domain_id = 70; -- testuser

*/


-- Dokumente Soft Delete Trigger
--drop  trigger "DOKUMENTE_BD_TRG";

create or replace trigger "DOKUMENTE_BD_TRG" 
before delete on "DOKUMENTE"
referencing old as old new as new
for each row
  declare
  pragma autonomous_transaction;
  begin
      "SOFT_DELETE" ('DOKUMENTE', :old.id_vorgang);
  end;
/


-- Dokumente Soft Delete Trigger
--drop  trigger "BOBLR_DOKUMENTE_BD_TRG";

create or replace trigger "BOBLR_DOKUMENTE_BD_TRG" 
before delete on "BOB_LAENDER_ROW_DOKUMENTE"
referencing old as old new as new
for each row
  declare
  pragma autonomous_transaction;
  begin
      "SOFT_DELETE" ('BOB_LAENDER_ROW_DOKUMENTE', :old.id_vorgang);
  end;
/

-- Dokumente Soft Delete Trigger
--drop  trigger "BOBLR_DOKUMENTE_BD_TRG";

create or replace trigger "BOBLR_ERGAENZ_BD_TRG" 
before delete on "BOB_LAENDER_ROW_ERGAENZUNGEN"
referencing old as old new as new
for each row
  declare
  pragma autonomous_transaction;
  begin
      "SOFT_DELETE" ('BOB_LAENDER_ROW_ERGAENZUNGEN', :old.id_vorgang);
  end;
/

-- Domain Soft Delete Trigger
--drop  trigger "VALID_DOMAINS_BD_TRG";

create or replace trigger "VALID_DOMAINS_BD_TRG" 
before delete on "DOMAINEN"
referencing old as old new as new
for each row
  declare
  pragma autonomous_transaction;
  begin
      "SOFT_DELETE" ('DOMAINEN', :old.domain_id);
  end;
/


-- User Soft Delete Trigger
--drop trigger "USER_BD_TRG" ;

create or replace trigger "USER_BD_TRG" 
before delete on "APEX_APP_USER"
referencing old as old new as new
for each row
declare
  pragma autonomous_transaction;
begin
  "SOFT_DELETE" ('APEX_APP_USER', :old.app_user_id);
end;
/


-- RAS Meldung Soft Delete Trigger
--drop  trigger "AMF_MELDUNG_BD_TRG";

create or replace trigger "AMF_MELDUNG_BD_TRG" 
before delete on "AMF_VORGANG"
referencing old as old new as new
for each row
declare
  pragma autonomous_transaction;
begin
      "SOFT_DELETE" ('AMF_VORGANG', :old.id_vorgang);
end;
/


-- User Soft Delete Trigger
drop trigger "AMF_STATUS_TRG" ;

create or replace trigger "AMF_STATUS_TRG" 
before update of AMF_MELDUNG_STATUS on "AMF_VORGANG"
referencing old as old new as new
for each row
begin
    if (:new.AMF_MELDUNG_STATUS = 2) then -- locked
      :new.DELETED := sysdate;
      :new.DELETED_BY := nvl(v('APP_USER'), user);
    elsif (:new.AMF_MELDUNG_STATUS = 1) then -- opened
      :new.DELETED := null;
      :new.DELETED_BY := null;
    end if;
end;
/


drop trigger "AMF_DEL_TRG" ;

create or replace trigger "AMF_DEL_TRG" 
before update of DELETED, DELETED_BY on "AMF_VORGANG"
referencing old as old new as new
for each row
begin
    if (:new.DELETED is not null) then -- locked
      :new.AMF_MELDUNG_STATUS := 2;
    end if;
end;
/


alter table amf_vorgang modify deleted_by varchar2(30) default user;
update amf_vorgang set DELETED_BY = user where DELETED is not null;
commit;

alter table amf_vorgang add amf_meldung_status number default null;
alter table amf_vorgang drop column amf_meldung_status;

update amf_vorgang set amf_meldung_status = 2 where DELETED is not null;
update amf_vorgang set amf_meldung_status = 1 where DELETED is null;

commit;


alter table dokumente add user_id number;  
alter table dokumente add domain_id number;  
  
alter table dokumente add constraint "DOK_USER_ID_FK" foreign key(user_id) references APEX_APP_USER(app_user_id);  
alter table dokumente add constraint "DOK_DOMAIN_ID_FK" foreign key(domain_id) references DOMAINEN(domain_id);

drop view "ALLE_DOKUMENTE";

create view "ALLE_DOKUMENTE"
as
SELECT 
  ID,
  ID_VORGANG,
  '' as MELDENDE_BEHOERDE,
  DATEINAME,
  DOKUMENTEN_INHALT,
  DATEIINHALT,
  MIMETYPE,
  MODIFIED,
  MODIFIED_BY,
  CREATED,
  CREATED_BY,
  DELETED,
  DELETED_BY,
  USER_ID,
  MELDER_ID
FROM DOKUMENTE
union all
SELECT 
  ID,
  ID_VORGANG,
  MELDENDE_BEHOERDE,
  DATEINAME,
  DOKUMENTEN_INHALT,
  DATEIINHALT,
  MIMETYPE,
  MODIFIED,
  MODIFIED_BY,
  CREATED,
  CREATED_BY,
  DELETED,
  DELETED_BY,
  USER_ID,
  MELDER_ID
FROM BOB_LAENDER_ROW_DOKUMENTE ;

select * from alle_dokumente
where ID_VORGANG=87 and ID = 10;



SELECT 
  ID,
  ID_VORGANG,
  MELDENDE_BEHOERDE,
  DATEINAME,
  DOKUMENTEN_INHALT,
  MIMETYPE,
  count(1) over (partition by id_vorgang) as anzahl_fall_dokumente,
  MODIFIED,
  MODIFIED_BY,
  CREATED,
  CREATED_BY,
  DELETED,
  DELETED_BY,
  USER_ID,
  DOMAIN_ID
FROM "ALLE_DOKUMENTE";

SELECT 
  ID_VORGANG,
  VORGANGSNUMMER,
  BEZEICHNUNG,
  MELDENDE_STELLE,
  EINGANGSDATUM,
  ERSTELLUNGSDATUM,
  STAAT_ID,
  BUNDESLAND_ID,
  BUNDESOBERBEHOERDE,
  BEMERKUNG
FROM "AMF_VORGANG" ;

create or replace view "MIME_TYPE_ICONS"
as 
select 
  b.mime_name,
  b.mime_template as mime_type,
  b.mime_group,
  a.icon_id,
  a.icon,
  a.icon_mime_type,
  a.icon_file_name,
  a.icon_charset,
  a.created,
  a.created_by,
  a.modified,
  a.modified_by
from "MIME_TYPES" b join "MIME_ICONS" a
on (a.icon_id = b.icon_id);


  GRANT SELECT ON "APEX_ADMIN"."MIME_TYPE_ICONS" TO PUBLIC;

with 
"VORGANG" as (
SELECT ID_VORGANG, BEZEICHNUNG,VORGANGSNUMMER
FROM "AMF_VORGANG"
    WHERE ID_VORGANG = nvl(:P40_ID_VORGANG, ID_VORGANG)
),
"ERGAENZ" as (
SELECT 
 BEMERKUNG, MELDENDE_BEHOERDE, ID_VORGANG, CREATED, MODIFIED
 FROM "BOB_LAENDER_ROW_ERGAENZUNGEN"
),
"MASSN" as (
SELECT 
  m.ID_VORGANG,
  m.MELDENDE_BEHOERDE,
  m.MASSNAHME_ID,
  amm.MASSNAHME,
  m.MASSNAHME_UMGESETZT,
  m.MASSNAHME_UMGESETZT_AM,
  m.MASSNAHME_SONSTIGE,
  m.MASSNAHME_BEMERKUNG
FROM "BOB_LAENDER_ROW_MASSNAHMEN" m LEFT JOIN "AMF_MASSNAHMEN" amm
ON (m.MASSNAHME_ID = amm.ID)
)
SELECT
  v.ID_VORGANG,
  v.VORGANGSNUMMER,
  v.BEZEICHNUNG as VORGANG,
  m.CODE,
  m.BEHOERDE
--  e.BEMERKUNG,
--  ms.MASSNAHME,
--  ms.MASSNAHME_UMGESETZT,
--  ms.  MASSNAHME_UMGESETZT_AM,
--  e.CREATED as erstellt,
--  e.MODIFIED as zuletzt_geaendert
FROM "MELDESTELLEN" m LEFT OUTER JOIN "VORGANG" v
ON (1 = 1)
LEFT OUTER JOIN "MASSN" ma
ON ( );


create or replace view "APEX_ALL_USERS"
as 
  select distinct
  u.APP_ID as APP_ID, 
  u.APP_USER_ID, 
  u.APP_USER_EMAIL, 
  u.APP_USERNAME, 
  a.STATUS as APP_USER_ACCOUNT_STATUS, 
  u.APP_USER_AD_LOGIN, 
  u.APP_USER_NOVELL_LOGIN, 
  u.APP_USER_DEFAULT_ROLE_ID, 
  ar.APP_ROLENAME as DEFAULT_ROLE,
  vd.DOMAIN_CODE,
  vd.DOMAIN,
  rg.INFO_GRUPPE_CODE as GRUPPEN_CODE,
  rg.INFO_GRUPPE as GRUPPE,
  u.APP_USER_PARENT_USER_ID, 
  (select au.app_username  
  from "APEX_APP_USER" au 
  where au.app_user_id = u.app_user_parent_user_id) as parent_username, 
  max(rm.app_role_id) over (partition by rm.app_user_id) as max_security_level,  
  min(rm.app_role_id) over (partition by rm.app_user_id) as min_security_level, 
  u.APP_USER_CODE, 
  vd.DOMAIN_ID,
  rg.GRUPPEN_ID,
  u.CREATED, 
  u.CREATED_BY, 
  u.MODIFIED, 
  u.MODIFIED_BY,
  u.DELETED,
  u.DELETED_BY
from "APEX_APP_USER" u  
left outer join  "APEX_ACCOUNT_STATUS" a 
on (u.APP_USER_STATUS_ID = a.status_id 
   and u.APP_ID = a.APP_ID) 
left outer join  "APEX_ROLES" ar 
on (ar.APP_ROLE_ID = u.APP_USER_DEFAULT_ROLE_ID 
    and ar.APP_ID = u.APP_ID) 
left outer join  "DOMAINEN" vd 
on (vd.DOMAIN_ID = u.APP_USER_DOMAIN_ID)
left outer join  "GRUPPEN" rg 
on (rg.GRUPPEN_ID = u.APP_USER_GROUP_ID)
left outer join "APEX_APP_USER_ROLE_MAP" rm 
on (u.APP_USER_ID = rm.APP_USER_ID 
    and u.APP_ID = rm.APP_ID);


GRANT SELECT ON "INTERN"."APEX_ALL_USERS" TO "APEX_ADMIN";


CREATE OR REPLACE FORCE VIEW "INTERN"."APEX_APP_SYS_BUILTINS"
AS 
  select  
  b.APP_ID, 
  b.APP_BUILTIN_ID, 
  b.APP_BUILTIN_PARENT_ID, 
  b.APP_USER_ID as APP_USER_ID, 
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
  b.APP_ROLE_ID as APP_USER_ID, 
  r.APP_ROLENAME as APP_BUILTIN_NAME, 
  r.APP_ROLE_CODE as APP_BUILTIN_CODE, 
  b.IS_ADMIN, 
  b.IS_PUBLIC, 
  b.IS_DEFAULT, 
  'ROLE' as APP_BUILTIN_TYPE 
FROM "APEX_SYS_BUILTINS" b join "APEX_ROLES" r 
on (b.APP_ROLE_ID = r.APP_ROLE_ID) 
where b.APP_ROLE_ID is not null 
  and b.APP_ID = v('APP_ID')
;


CREATE OR REPLACE VIEW "APEX_USERS"
AS 
  select 
  APP_ID,
  APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_ACCOUNT_STATUS as USER_ACCOUNT_STATUS,
  AD_LOGIN,
  NOVELL_LOGIN,
  DEFAULT_ROLE,
  PARENT_USERNAME,
  USER_DEFAULT_SECURITY_LEVEL as DEFAULT_SECURITY_LEVEL,
  USER_MAX_SECURITY_LEVEL as MAX_SECURITY_LEVEL,
  USER_MIN_SECURITY_LEVEL as MIN_SECURITY_LEVEL
from "APEX_APPLICATION_USERS"
order by 1, 2
;


GRANT SELECT ON "INTERN"."APEX_USERS" TO "APEX_ADMIN";



CREATE OR REPLACE VIEW "APEX_APPLICATION_USERS"
AS 
  select APP_ID,
  APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_ACCOUNT_STATUS,
  APP_USER_AD_LOGIN as AD_LOGIN,
  APP_USER_NOVELL_LOGIN as NOVELL_LOGIN,
  APP_USER_DEFAULT_ROLE_ID,
  DEFAULT_ROLE,
  DOMAIN_CODE, 
  DOMAIN, 
  GRUPPEN_CODE, 
  GRUPPE  
  APP_USER_PARENT_USER_ID,
  PARENT_USERNAME,
  APP_USER_DEFAULT_ROLE_ID as USER_DEFAULT_SECURITY_LEVEL,
  MAX_SECURITY_LEVEL as USER_MAX_SECURITY_LEVEL,
  MIN_SECURITY_LEVEL as USER_MIN_SECURITY_LEVEL,  
  CREATED,
  CREATED_BY,
  MODIFIED,
  MODIFIED_BY,
  DELETED,
  DELETED_BY
from "APEX_ALL_USERS"
where APP_ID = nvl(v('APP_ID'), app_id)
order by 2 desc;

GRANT SELECT ON "INTERN"."APEX_APPLICATION_USERS" TO "APEX_ADMIN";


CREATE OR REPLACE VIEW "APP_BUILTIN_ADMINS" ("APP_USERNAME", "APPLICATION_ROLE") AS 
select app_builtin_name as "APP_USERNAME", 'APPLICATION_BUILTIN_ADMIN_USER' as "APPLICATION_ROLE" 
from "APEX_APP_SYS_BUILTINS" 
where   app_builtin_type = 'USER' 
and is_admin = 1;

CREATE OR REPLACE VIEW "APEX_APP_BUILTIN_ADMINS" ("APP_USERNAME", "APPLICATION_ROLE") AS 
select app_builtin_name as "APP_USERNAME", 'APPLICATION_BUILTIN_ADMIN_USER' as "APPLICATION_ROLE" 
from "APEX_APP_SYS_BUILTINS" 
where   app_builtin_type = 'USER' 
and is_admin = 1;


create or replace view "APEX_APP_SYS_ROLES"
as 
  select
  APP_BUILTIN_ID,
  APP_BUILTIN_PARENT_ID,
  APP_ID,
  APP_USER_ID,
  APP_BUILTIN_NAME as APP_ROLENAME,
  APP_BUILTIN_CODE as APP_ROLE_CODE
from "APEX_APP_SYS_BUILTINS"
where APP_BUILTIN_TYPE = 'ROLE';

GRANT SELECT ON "APEX_APP_SYS_ROLES" TO "APEX_ADMIN";

create or replace view "APEX_APP_SYS_USERS"
as 
  select
  APP_BUILTIN_ID,
  APP_BUILTIN_PARENT_ID,
  APP_ID,
  APP_USER_ID,
  APP_BUILTIN_NAME as APP_USERNAME,
  APP_BUILTIN_CODE as APP_USER_CODE
from "APEX_APP_SYS_BUILTINS"
where APP_BUILTIN_TYPE = 'USER';

GRANT SELECT ON "INTERN"."APEX_APP_SYS_USERS" TO "APEX_ADMIN";


CREATE OR REPLACE VIEW "APEX_ALL_USERS"
AS 
  select distinct
  u.APP_ID as APP_ID, 
  u.APP_USER_ID, 
  u.APP_USER_EMAIL, 
  u.APP_USERNAME, 
  a.STATUS as APP_USER_ACCOUNT_STATUS, 
  u.APP_USER_AD_LOGIN, 
  u.APP_USER_NOVELL_LOGIN, 
  u.APP_USER_DEFAULT_ROLE_ID, 
  ar.APP_ROLENAME as DEFAULT_ROLE,
  vd.DOMAIN_CODE,
  vd.DOMAIN,
  rg.INFO_GRUPPE_CODE as GRUPPEN_CODE,
  rg.INFO_GRUPPE as GRUPPE,
  u.APP_USER_PARENT_USER_ID, 
  (select au.app_username  
  from "APEX_APP_USER" au 
  where au.app_user_id = u.app_user_parent_user_id) as parent_username, 
  max(rm.app_role_id) over (partition by rm.app_user_id) as max_security_level,  
  min(rm.app_role_id) over (partition by rm.app_user_id) as min_security_level, 
  u.APP_USER_CODE, 
  vd.DOMAIN_ID,
  rg.GRUPPEN_ID,
  u.CREATED, 
  u.CREATED_BY, 
  u.MODIFIED, 
  u.MODIFIED_BY,
  u.DELETED,
  u.DELETED_BY
from "APEX_APP_USER" u  
left outer join  "APEX_ACCOUNT_STATUS" a 
on (u.APP_USER_STATUS_ID = a.status_id 
   and u.APP_ID = a.APP_ID) 
left outer join  "APEX_ROLES" ar 
on (ar.APP_ROLE_ID = u.APP_USER_DEFAULT_ROLE_ID 
    and ar.APP_ID = u.APP_ID) 
left outer join  "DOMAINEN" vd 
on (vd.DOMAIN_ID = u.APP_USER_DOMAIN_ID)
left outer join  "GRUPPEN" rg 
on (rg.GRUPPEN_ID = u.APP_USER_GROUP_ID)
left outer join "APEX_APP_USER_ROLE_MAP" rm 
on (u.APP_USER_ID = rm.APP_USER_ID 
    and u.APP_ID = rm.APP_ID);

GRANT SELECT ON "INTERN"."APEX_ALL_USERS" TO "APEX_ADMIN";


CREATE OR REPLACE FORCE VIEW "APEX_APPLICATION_USERS"
AS 
  select APP_ID,
  APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_AD_LOGIN as AD_LOGIN,
  APP_USER_NOVELL_LOGIN as NOVELL_LOGIN,
  APP_USER_DEFAULT_ROLE_ID,
  DEFAULT_ROLE,
  DOMAIN_CODE, 
  DOMAIN, 
  GRUPPEN_CODE, 
  GRUPPE,
  APP_USER_ACCOUNT_STATUS,
  APP_USER_PARENT_USER_ID,
  PARENT_USERNAME,
  APP_USER_DEFAULT_ROLE_ID as USER_DEFAULT_SECURITY_LEVEL,
  MAX_SECURITY_LEVEL as USER_MAX_SECURITY_LEVEL,
  MIN_SECURITY_LEVEL as USER_MIN_SECURITY_LEVEL,  
  CREATED,
  CREATED_BY,
  MODIFIED,
  MODIFIED_BY,
  DELETED,
  DELETED_BY
from "APEX_ALL_USERS"
where APP_ID = nvl(v('APP_ID'), app_id)
order by 1, 2;


GRANT SELECT ON "INTERN"."APEX_APPLICATION_USERS" TO "APEX_ADMIN";


CREATE OR REPLACE VIEW "DOMAIN_GRUPPEN"
AS 
SELECT 
  r.DOMAIN_ID,
  r.DOMAIN,
  r.DOMAIN_CODE,
  r.DOMAIN_OWNER,
  r.DOMAIN_GROUP_ID as GRUPPEN_ID,
  g.INFO_GRUPPE as GRUPPE,
  g.INFO_GRUPPE_CODE as GRUPPEN_CODE
FROM "DOMAINEN" r LEFT OUTER JOIN "GRUPPEN" g
ON (r.DOMAIN_GROUP_ID = g.GRUPPEN_ID)
ORDER BY 1;


create or replace view "DOMAINS"
as 
  select 
  rd.domain_id,
  rd.domain,
  rd.domain_owner,
  rd.domain_code,
  case rd.dns_not_resolved when 1 then 'Ja' else 'Nein' end as dns_gueltig,
  s.status,
  rd.modified,
  rd.modified_by,
  rd.created,
  rd.created_by,
  rd.deleted,
  rd.deleted_by
from "DOMAINEN" rd LEFT OUTER JOIN "APEX_STATUS" s
on (rd.status_id = s.status_id)
order by 1;

create or replace view "VALID_DOMAINS"
as 
select DOMAIN_ID,
  DOMAIN,
  DOMAIN_OWNER,
  DOMAIN_CODE,
  DNS_GUELTIG,
  CASE STATUS WHEN 'VALID' Then 'Gueltig' else 'Ungueltig' end as DOMAINEN_STATUS,
  MODIFIED,
  MODIFIED_BY,
  CREATED,
  CREATED_BY,
  DELETED,
  DELETED_BY
FROM "DOMAINS" 
WHERE STATUS = 'VALID';


create or replace view "APEX_ADMINS" ("APP_USERNAME", "APPLICATION_ROLE") 
as 
select app_username, application_role from "APPLICATION_ADMINS"
union
select user_name, application_role from "WORKSPACE_ADMINS";


GRANT SELECT ON "INTERN"."APEX_ADMINS" TO "APEX_ADMIN";


SELECT BEZEICHNUNG as d,
             ID_VORGANG as r
FROM "AMF_VORGANG" ;


alter table "APEX_APP_USER" drop column DOMAIN_ID;

alter table "APEX_APP_USER" add APP_USER_DOMAIN_ID number;
alter table "APEX_APP_USER" add APP_USER_GROUP_ID number;

alter table "APEX_APP_USER" add constraint "APP_USER_DOMAIN_FK" foreign key (APP_USER_DOMAIN_ID) references DOMAINEN (domain_id);
alter table "APEX_APP_USER" add constraint "APP_USER_GROUP_FK" foreign key (APP_USER_GROUP_ID) references GRUPPEN (gruppen_id);


update APEX_APP_USER u
set u.app_user_domain_id = (
select d.domain_id
from DOMAINEN d
where d.domain = substr(u.app_user_email, instr(u.app_user_email, '@')+1)
);

update APEX_APP_USER u
set u.app_user_group_id = (
select d.domain_group_id
from DOMAINEN d
where d.domain = substr(u.app_user_email, instr(u.app_user_email, '@')+1)
);

commit;


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
    if (:new.app_user_domain_id is null or :new.app_user_group_id is null) then
        select d.domain_id, d.domain_group_id into :new.app_user_domain_id, :new.app_user_group_id
        from "DOMAINEN" d
        where lower(trim(d.domain)) =lower(substr(:new.app_user_email, instr(:new.app_user_email, '@') +1));
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

alter table DOMAINEN add domain_group_id number;
alter table DOMAINEN add domain_bundesland_id number;
alter table DOMAINEN add constraint  "DOMAIN_GRP_FK" foreign key(domain_group_id) references "GRUPPEN"(gruppen_id) on delete set null;
alter table DOMAINEN add constraint  "DOMAIN_BL_FK" foreign key(domain_bundesland_id) references "BUNDESLAENDER"(bundesland_id) on delete set null;





create or replace view "USERS"
as
select 
  usr.app_user_id,
  usr.app_user_email,
  usr.app_username,
  usr.app_user_code,
  usr.app_user_account_status,
  usr.domain_code,
  usr.gruppen_code
from "APEX_APPLICATION_USERS" usr
where usr.app_user_email = (select u.APP_USER_EMAIL 
                                            from "APEX_APPLICATION_USERS" u
                                            where upper(trim(u.app_username)) = 
                                                       upper(trim(nvl(v('APP_USER'), usr.app_username))))
and usr.app_user_account_status = 'OPEN'
;


create or replace view "INTERN"."APEX_ALL_USERS" 
as 
  select distinct
  u.APP_ID as APP_ID, 
  u.APP_USER_ID, 
  u.APP_USER_EMAIL, 
  u.APP_USERNAME, 
  a.STATUS as APP_USER_ACCOUNT_STATUS, 
  u.APP_USER_AD_LOGIN, 
  u.APP_USER_NOVELL_LOGIN, 
  u.APP_USER_DEFAULT_ROLE_ID, 
  ar.APP_ROLENAME as DEFAULT_ROLE,
  vd.DOMAIN_CODE,
  vd.DOMAIN,
  rg.INFO_GRUPPE_CODE as GRUPPEN_CODE,
  rg.INFO_GRUPPE as GRUPPE,
  u.APP_USER_PARENT_USER_ID, 
  (select au.app_username  
  from "APEX_APP_USER" au 
  where au.app_user_id = u.app_user_parent_user_id) as parent_username, 
  max(rm.app_role_id) over (partition by rm.app_user_id) as max_security_level,  
  min(rm.app_role_id) over (partition by rm.app_user_id) as min_security_level, 
  u.APP_USER_CODE, 
  vd.DOMAIN_ID,
  rg.GRUPPEN_ID,
  u.CREATED, 
  u.CREATED_BY, 
  u.MODIFIED, 
  u.MODIFIED_BY,
  u.DELETED,
  u.DELETED_BY
from "APEX_APP_USER" u  
left outer join  "APEX_ACCOUNT_STATUS" a 
on (u.APP_USER_STATUS_ID = a.status_id 
   and u.APP_ID = a.APP_ID) 
left outer join  "APEX_ROLES" ar 
on (ar.APP_ROLE_ID = u.APP_USER_DEFAULT_ROLE_ID 
    and ar.APP_ID = u.APP_ID) 
left outer join  "DOMAINS" vd 
on (vd.DOMAIN_ID = u.APP_USER_DOMAIN_ID)
left outer join  "GRUPPEN" rg 
on (rg.GRUPPEN_ID = u.APP_USER_GROUP_ID)
left outer join "APEX_APP_USER_ROLE_MAP" rm 
on (u.APP_USER_ID = rm.APP_USER_ID 
    and u.APP_ID = rm.APP_ID);


GRANT SELECT ON "INTERN"."APEX_ALL_USERS" TO "APEX_ADMIN";




CREATE OR REPLACE FORCE VIEW "INTERN"."APEX_APP_SYS_BUILTINS"
AS 
  select  
  b.APP_ID, 
  b.APP_BUILTIN_ID, 
  b.APP_BUILTIN_PARENT_ID, 
  b.APP_USER_ID as APP_USER_ID, 
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
  b.APP_ROLE_ID as APP_USER_ID, 
  r.APP_ROLENAME as APP_BUILTIN_NAME, 
  r.APP_ROLE_CODE as APP_BUILTIN_CODE, 
  b.IS_ADMIN, 
  b.IS_PUBLIC, 
  b.IS_DEFAULT, 
  'ROLE' as APP_BUILTIN_TYPE 
FROM "APEX_SYS_BUILTINS" b join "APEX_ROLES" r 
on (b.APP_ROLE_ID = r.APP_ROLE_ID) 
where b.APP_ROLE_ID is not null 
  and b.APP_ID = v('APP_ID')
;


CREATE OR REPLACE VIEW "APEX_USERS"
AS 
  select 
  APP_ID,
  APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_ACCOUNT_STATUS as USER_ACCOUNT_STATUS,
  AD_LOGIN,
  NOVELL_LOGIN,
  DEFAULT_ROLE,
  PARENT_USERNAME,
  USER_DEFAULT_SECURITY_LEVEL as DEFAULT_SECURITY_LEVEL,
  USER_MAX_SECURITY_LEVEL as MAX_SECURITY_LEVEL,
  USER_MIN_SECURITY_LEVEL as MIN_SECURITY_LEVEL
from "APEX_APPLICATION_USERS"
order by 1, 2
;


GRANT SELECT ON "INTERN"."APEX_USERS" TO "APEX_ADMIN";



CREATE OR REPLACE VIEW "APEX_APPLICATION_USERS"
AS 
  select APP_ID,
  APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_ACCOUNT_STATUS,
  APP_USER_AD_LOGIN as AD_LOGIN,
  APP_USER_NOVELL_LOGIN as NOVELL_LOGIN,
  APP_USER_DEFAULT_ROLE_ID,
  DEFAULT_ROLE,
  DOMAIN_CODE, 
  DOMAIN, 
  GRUPPEN_CODE, 
  GRUPPE  
  APP_USER_PARENT_USER_ID,
  PARENT_USERNAME,
  APP_USER_DEFAULT_ROLE_ID as USER_DEFAULT_SECURITY_LEVEL,
  MAX_SECURITY_LEVEL as USER_MAX_SECURITY_LEVEL,
  MIN_SECURITY_LEVEL as USER_MIN_SECURITY_LEVEL,  
  CREATED,
  CREATED_BY,
  MODIFIED,
  MODIFIED_BY,
  DELETED,
  DELETED_BY
from "APEX_ALL_USERS"
where APP_ID = nvl(v('APP_ID'), app_id)
order by 2 desc;


GRANT SELECT ON "INTERN"."APEX_APPLICATION_USERS" TO "APEX_ADMIN";

CREATE OR REPLACE FORCE VIEW "INTERN"."APP_BUILTIN_ADMINS" ("APP_USERNAME", "APPLICATION_ROLE") AS 
select app_builtin_name as "APP_USERNAME", 'APPLICATION_BUILTIN_ADMIN_USER' as "APPLICATION_ROLE" 
from "APEX_APP_SYS_BUILTINS" 
where   app_builtin_type = 'USER' 
and is_admin = 1
;

CREATE OR REPLACE FORCE VIEW "INTERN"."APEX_APP_BUILTIN_ADMINS" ("APP_USERNAME", "APPLICATION_ROLE") AS 
select app_builtin_name as "APP_USERNAME", 'APPLICATION_BUILTIN_ADMIN_USER' as "APPLICATION_ROLE" 
from "APEX_APP_SYS_BUILTINS" 
where   app_builtin_type = 'USER' 
and is_admin = 1
;

  CREATE OR REPLACE FORCE VIEW "INTERN"."APEX_APP_SYS_ROLES" ("APP_BUILTIN_ID", "APP_BUILTIN_PARENT_ID", "APP_ID", "APP_USER_ID", "APP_ROLENAME", "APP_ROLE_CODE") AS 
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

GRANT SELECT ON "INTERN"."APEX_APP_SYS_ROLES" TO "APEX_ADMIN";

CREATE OR REPLACE FORCE VIEW "INTERN"."APEX_APP_SYS_USERS" ("APP_BUILTIN_ID", "APP_BUILTIN_PARENT_ID", "APP_ID", "APP_USER_ID", "APP_USERNAME", "APP_USER_CODE") AS 
  select
  APP_BUILTIN_ID,
  APP_BUILTIN_PARENT_ID,
  APP_ID,
  APP_USER_ID,
  APP_BUILTIN_NAME as APP_USERNAME,
  APP_BUILTIN_CODE as APP_USER_CODE
from "APEX_APP_SYS_BUILTINS"
where APP_BUILTIN_TYPE = 'USER';

GRANT SELECT ON "INTERN"."APEX_APP_SYS_USERS" TO "APEX_ADMIN";


CREATE OR REPLACE FORCE VIEW "INTERN"."APEX_ADMINS" ("APP_USERNAME", "APPLICATION_ROLE") 
AS 
select app_username, application_role from "APPLICATION_ADMINS"
union
select user_name, application_role from "WORKSPACE_ADMINS";

GRANT SELECT ON "INTERN"."APEX_ADMINS" TO "APEX_ADMIN";


SELECT ID_VORGANG,
             BEZEICHNUNG
FROM AMF_VORGANG ;

SELECT MELDENDE_BEHOERDE FROM BOB_LAENDER_ROW_MASSNAHMEN;

SELECT DOMAIN_ID,
            DOMAIN
FROM DOMAINEN ;


CREATE OR REPLACE VIEW "BUNDESLAENDER"
AS 
  select 
  bundesland_id,
  bundesland,
  bundesland_code,
  bundesland_wappen,
  modified,
  modified_by,
  created,
  created_by
from "BUNDESLAENDER";

alter table BOB_LAENDER_ROW_DOKUMENTE add domain_id number;
alter table BOB_LAENDER_ROW_DOKUMENTE add constraint "DOKU_ERGAENZ_DOMAIN_ID_FK" foreign key (domain_id)
references "DOMAINEN" (domain_id);

alter table BOB_LAENDER_ROW_MASSNAHMEN add domain_id number;
alter table BOB_LAENDER_ROW_MASSNAHMEN add constraint "DOKU_MASSN_DOMAIN_ID_FK" foreign key (domain_id)
references "DOMAINEN" (domain_id);

alter table BOB_LAENDER_ROW_ERGAENZUNGEN add domain_id number;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN add constraint "DOKU_ERGAENZN_DOMAIN_ID_FK" foreign key (domain_id)
references "DOMAINEN" (domain_id);


drop index BLR_ERGAENZ_DOMAIN_ID_ID;
drop index BLR_MASSN_DOMAIN_ID_ID;
drop index BLR_DOKU_DOMAIN_ID_ID;

create index BLR_ERGAENZ_DOMAIN_ID_IDX on BOB_LAENDER_ROW_ERGAENZUNGEN (domain_id);
create index BLR_MASSN_DOMAIN_ID_IDX on BOB_LAENDER_ROW_MASSNAHMEN (domain_id);
create index BLR_DOKU_DOMAIN_ID_IDX on BOB_LAENDER_ROW_DOKUMENTE (domain_id);

create index BLR_ERGAENZ_USER_ID_IDX on BOB_LAENDER_ROW_ERGAENZUNGEN (user_id);
create index BLR_MASSN_USER_ID_IDX on BOB_LAENDER_ROW_MASSNAHMEN (user_id);
create index BLR_DOKU_USER_ID_IDX on BOB_LAENDER_ROW_DOKUMENTE (user_id);

alter table BOB_LAENDER_ROW_MASSNAHMEN modify user_id number;
alter table BOB_LAENDER_ROW_MASSNAHMEN drop constraint "BOB_MASSN_MELDER_ID_FK";
alter table BOB_LAENDER_ROW_MASSNAHMEN add constraint "BLR_MASSNAHME_USER_ID_FK" foreign key (user_id)
references "APEX_APP_USER" (app_user_id);

alter table BOB_LAENDER_ROW_ERGAENZUNGEN modify user_id number;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN drop constraint BOB_ERGAENZ_USER_ID_FK;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN add constraint "ERGAENZ_BOB_LNDR_ROW_USER_ID" foreign key (user_id)
references "APEX_APP_USER" (app_user_id);

alter table BOB_LAENDER_ROW_DOKUMENTE add domain_id number;
alter table BOB_LAENDER_ROW_DOKUMENTE add constraint "DOKU_ERGAENZ_DOMAIN_ID_FK" foreign key (domain_id)
references "DOMAINEN" (domain_id);

update BOB_LAENDER_ROW_DOKUMENTE set domain_id = 1;

commit;


alter table BOB_LAENDER_ROW_MASSNAHMEN add domain_id number;
alter table BOB_LAENDER_ROW_MASSNAHMEN add constraint "DOKU_MASSN_DOMAIN_ID_FK" foreign key (domain_id)
references "DOMAINEN" (domain_id);

alter table BOB_LAENDER_ROW_ERGAENZUNGEN add domain_id number;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN add constraint "DOKU_ERGAENZN_DOMAIN_ID_FK" foreign key (domain_id)
references "DOMAINEN" (domain_id);


drop index BLR_ERGAENZ_DOMAIN_ID_ID;
drop index BLR_MASSN_DOMAIN_ID_ID;
drop index BLR_DOKU_DOMAIN_ID_ID;

create index BLR_ERGAENZ_DOMAIN_ID_IDX on BOB_LAENDER_ROW_ERGAENZUNGEN (domain_id);
create index BLR_MASSN_DOMAIN_ID_IDX on BOB_LAENDER_ROW_MASSNAHMEN (domain_id);
create index BLR_DOKU_DOMAIN_ID_IDX on BOB_LAENDER_ROW_DOKUMENTE (domain_id);

create index BLR_ERGAENZ_USER_ID_IDX on BOB_LAENDER_ROW_ERGAENZUNGEN (user_id);
create index BLR_MASSN_USER_ID_IDX on BOB_LAENDER_ROW_MASSNAHMEN (user_id);
create index BLR_DOKU_USER_ID_IDX on BOB_LAENDER_ROW_DOKUMENTE (user_id);

alter table BOB_LAENDER_ROW_MASSNAHMEN modify user_id number;
alter table BOB_LAENDER_ROW_MASSNAHMEN drop constraint "BOB_MASSN_MELDER_ID_FK";
alter table BOB_LAENDER_ROW_MASSNAHMEN add constraint "BLR_MASSNAHME_USER_ID_FK" foreign key (user_id)
references "APEX_APP_USER" (app_user_id);

alter table BOB_LAENDER_ROW_ERGAENZUNGEN modify user_id number;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN drop constraint BOB_ERGAENZ_USER_ID_FK;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN add constraint "ERGAENZ_BOB_LNDR_ROW_USER_ID" foreign key (user_id)
references "APEX_APP_USER" (app_user_id);


SELECT ID,
  ID_VORGANG,
  MELDENDE_BEHOERDE,
  KOMMENTAR,
  USER_ID
FROM "BOB_LAENDER_ROW_ERGAENZUNGEN";

 select BLR_ERGAENZUNGEN_SEQ.nextval from dual;



SELECT ID,
  ID_VORGANG,
  MELDENDE_BEHOERDE,
  KOMMENTAR,
  USER_ID
FROM "BOB_LAENDER_ROW_ERGAENZUNGEN";

 select BLR_ERGAENZUNGEN_SEQ.nextval from dual;

--CREATE OR REPLACE FORCE VIEW "INTERN"."MELDESTELLEN" ("GRP", "BEHOERDEN_ID", "BEHOERDE", "CODE", "DISPLAY_NAME", "GRUPPEN_ID", "GRUPPE", "GRUPPEN_CODE", "DOMAIN") AS 
with "RASGRP" as (
SELECT DOMAIN_ID,
  DOMAIN,
  DOMAIN_CODE,
  DOMAIN_OWNER,
  GRUPPEN_ID,
  GRUPPE,
  GRUPPEN_CODE
FROM "DOMAIN_GRUPPEN" 
)
  SELECT 1 as GRP, 
  b.BEHOERDEN_ID, 
  b.BUNDESBEHOERDE as BEHOERDE,
  b.BUNDESBEHOERDE_CODE as CODE,
  b.BUNDESBEHOERDE_CODE as DISPLAY_NAME,
  g.GRUPPEN_ID,
  g.GRUPPE,
  g.GRUPPEN_CODE,
  g.DOMAIN
FROM"RASGRP" g LEFT JOIN  "BUNDESOBERBEHOERDEN" b 
ON (b.BUNDESBEHOERDE_CODE = G.DOMAIN_CODE)
UNION
SELECT 2 as GRP, 
  b.BEHOERDEN_ID, 
  b.BUNDESBEHOERDE as BEHOERDE,
  b.BUNDESBEHOERDE_CODE as CODE,
  b.BUNDESBEHOERDE_CODE||' - '||b.BUNDESBEHOERDE as DISPLAY_NAME,
  g.GRUPPEN_ID,
  g.GRUPPE,
  g.GRUPPEN_CODE,
  g.DOMAIN  
FROM "RASGRP" g LEFT JOIN  "BUNDESBEHOERDEN" b 
ON (b.BUNDESBEHOERDE_CODE = G.DOMAIN_CODE)
UNION
SELECT 3 as GRP,
  b.BUNDESLAND_ID,
  b.BUNDESLAND,
  b.BUNDESLAND_CODE as CODE,
  b.BUNDESLAND_CODE ||' - ' ||b.BUNDESLAND as DISPLAY_NAME,
  min(g.GRUPPEN_ID) over(),
  min(g.GRUPPE) over(),
  'BL',
  null  
FROM "RASGRP" g LEFT JOIN  "BUNDESLAENDER" b
ON ('BL' = G.GRUPPEN_CODE);



create or replace view "DOMAIN_GRUPPEN"
as 
  select 
  r.domain_id,
  r.domain,
  r.domain_code,
  r.domain_owner,
  r.domain_group_id as GRUPPEN_ID,
  nvl(r.domain_bundesland_id, 0) as BL_ID,
  nvl(bl.bundesland, g.info_gruppe) as BUNDESLAND,
  nvl(bl.bundesland_code,  r.domain_code) as BL_CODE,
  g.info_gruppe  as GRUPPE,
  g.info_gruppe_code as GRUPPEN_CODE
from "DOMAINEN" r left outer join "GRUPPEN" g
on (r.domain_group_id = g.gruppen_id)
left outer join "BUNDESLAENDER" bl
on (r.domain_bundesland_id = bl.bundesland_id)
order by 1;



#P40_ID_VORGANG_CONTAINER > div.t-Form-inputContainer.col.col-9 {
    margin-left: 0px;
    margin-top: 0px;
    width: 64%;
    left: 3px;
}



declare
l_id number;
begin
  select 1 into l_id
  from BOB_LAENDER_ROW_MASSNAHMEN
  where id = :P38_ID
  and DELETED is null;
if l_id = 1 then
return false;
end if;
exception when no_data_found then
return true;
end;
/

--style="background-color: #890d49; color: #ffffff;"

alter table BOB_LAENDER_ROW_MASSNAHMEN add MELDENDE_STELLE_CODE varchar2(200);
alter table BOB_LAENDER_ROW_DOKUMENTE add MELDENDE_STELLE_CODE varchar2(200);
alter table BOB_LAENDER_ROW_ERGAENZUNGEN add MELDENDE_STELLE_CODE varchar2(200);


--CREATE OR REPLACE FORCE VIEW "INTERN"."USERS"
--AS 
  select 
  usr.app_user_id,
  usr.app_user_email,
  usr.app_username,
  usr.app_user_code,
  usr.app_user_account_status,
  usr.domain_code,
  usr.gruppen_code,
 (select nvl(DOMAIN_BUNDESLAND_ID, 0) from DOMAINEN where domain_code = usr.domain_code)
from "APEX_APPLICATION_USERS" usr
where usr.app_user_email = (select u.APP_USER_EMAIL 
                                            from "APEX_APPLICATION_USERS" u
                                            where upper(trim(u.app_username)) = 
                                                       upper(trim(nvl(v('APP_USER'), usr.app_username))))
and usr.app_user_account_status = 'OPEN';


select bl_code 
from DOMAIN_GRUPPEN
where domain_code = (select domain_code
from USERS
where upper(trim(app_username)) = upper(trim(:APP_USER)));

alter table BOB_LAENDER_ROW_DOKUMENTE modify melder_id number;
alter table BOB_LAENDER_ROW_DOKUMENTE add constraint "BOB_MELDER_ID_FK" foreign key (melder_id)
references "MELDER" (melder_id);

alter table BOB_LAENDER_ROW_MASSNAHMEN modify melder_id number;
alter table BOB_LAENDER_ROW_MASSNAHMEN add constraint "BOB_MASSN_MELDER_ID_FK" foreign key (melder_id)
references "MELDER" (melder_id);

alter table BOB_LAENDER_ROW_ERGAENZUNGEN modify melder_id number;
alter table BOB_LAENDER_ROW_ERGAENZUNGEN add constraint "BOB_ERGAENZ_MELDER_ID_FK" foreign key (melder_id)
references "MELDER" (melder_id);


update BOB_LAENDER_ROW_ERGAENZUNGEN set melder_id = 1;
update BOB_LAENDER_ROW_MASSNAHMEN set melder_id = 1;
update BOB_LAENDER_ROW_DOKUMENTE set melder_id = 1;

commit;

alter table APEX_APP_USER drop constraint APP_USER_MELDER_ID;
alter table APEX_APP_USER add constraint "APEXAPPUSER_MELDER_ID" foreign key (app_user_melder_id) references MELDER(melder_id);


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- RAS Malder (alle Beteiligten)
drop table "MELDER" purge;

create table "MELDER"
as
select rownum as MELDER_ID, BEHOERDEN_ID as MELDEBEHORDE_ID, BEHOERDE as MELDER, CODE as MELDER_CODE, 
           DISPLAY_NAME as DISPLAY_NAME, BEHOERDEN_GRUPPEN_ID as GRUPPEN_ID, GRP as SORT_SEQ
from (
 SELECT case when BUNDESBEHOERDE_CODE 
  in ('' , 'PEI', 'BVL', 'BMEL') 
  then 1
  else 2
  end as GRP, BEHOERDEN_ID, 
  BUNDESBEHOERDE as BEHOERDE,
  BUNDESBEHOERDE_CODE as CODE,
  BUNDESBEHOERDE_CODE as DISPLAY_NAME,
  case when BUNDESBEHOERDE_CODE 
  in ('' , 'PEI', 'BVL', 'BMEL') 
  then 1
  else 5
  end as BEHOERDEN_GRUPPEN_ID
FROM "BUNDESOBERBEHOERDEN"
UNION
SELECT 3 as GRP,
  BUNDESLAND_ID,
  BUNDESLAND,
  BUNDESLAND_CODE as CODE,
  BUNDESLAND_CODE ||' - ' ||BUNDESLAND as DISPLAY_NAME,
  2 as BEHOERDEN_GRUPPEN_ID
FROM "BUNDESLAENDER"
) 
order by grp, behoerden_id;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Views auf MELDER
create or replace view "DOMAIN_GRUPPEN"
as 
  select 
  d.domain_id as domain_id,
  d.domain as domain,
  d.domain_code as domain_code,
  d.domain_owner as domain_owner,
  g.gruppe_code,  
  g.gruppe as gruppe,
  m.melder  as melder,
  d.domain_melder_id as melder_id,
  m.gruppen_id as melder_gruppen_id
from "DOMAINEN" d left outer join "MELDER" m
on (d.domain_melder_id = m.melder_id)
left outer join "GRUPPEN" g
on (m.gruppen_id = g.gruppen_id)
order by 1;


create or replace view "DOMAINS"
as 
  select 
  rd.domain_id,
  rd.domain,
  rd.domain_owner,
  rd.domain_code,
  case rd.dns_not_resolved when 0 then 'Ja' else 'Nein' end as dns_gueltig,
  s.status,
  m.melder  as behoerde,
  m.gruppen_id as melder_gruppen_id,
  rd.modified,
  rd.modified_by,
  rd.created,
  rd.created_by,
  rd.deleted,
  rd.deleted_by
from "DOMAINEN" rd LEFT OUTER JOIN "APEX_STATUS" s
on (rd.status_id = s.status_id)
 left outer join "MELDER" m
on (rd.domain_melder_id = m.melder_id)
order by 1;


create or replace view "MELDEGRUPPEN"
as 
select
  m.melder_id,
  m.meldebehorde_id,
  m.melder,
  m.melder_code,
  m.display_name,
  m.gruppen_id,
  g.gruppe,
  g.gruppe_code,
  m.sort_seq,
  m.app_id
from "MELDER" m left outer join "GRUPPEN" g
on (m.gruppen_id = g.gruppen_id);

 
 CREATE OR REPLACE VIEW "MELDEDOMAINEN"
 as
select
  m.melder_id,
  m.melder,
  m.melder_code,
  m.display_name,
  g.gruppe,
  g.gruppe_code,
  d.domain,
  d.domain_code,
  m.app_id,
  m.meldebehorde_id,
  m.gruppen_id,
  g.gruppen_id,
  m.sort_seq,
  m.created,
  m.created_by,
  m.modified,
  m.modified_by
FROM   "MELDER" m left outer join "GRUPPEN" g
on (m.gruppen_id   = g.gruppen_id)
right outer join "DOMAINEN" d
on (d.domain_melder_id = m.melder_id)
order by m.sort_seq, m.app_id, m.melder_id;



create or replace view "APEX_ALL_USERS"
as 
  select distinct
  u.app_id as app_id, 
  u.app_user_id, 
  u.app_user_email, 
  u.app_username, 
  a.status as app_user_account_status, 
  u.app_user_ad_login, 
  u.app_user_novell_login, 
  u.app_user_default_role_id, 
  ar.app_rolename as default_role,
  vd.domain_code,
  vd.domain,
  m.melder_code as meldegruppen_code,
  m.melder as meldegruppe,
  g.gruppe as gruppe,
  g.gruppe_code as gruppe_code,
  u.app_user_parent_user_id, 
  (select au.app_username  
  from "APEX_APP_USER" au 
  where au.app_user_id = u.app_user_parent_user_id) as parent_username, 
  max(rm.app_role_id) over (partition by rm.app_user_id) as max_security_level,  
  min(rm.app_role_id) over (partition by rm.app_user_id) as min_security_level, 
  u.app_user_code, 
  vd.domain_id,
  m.melder_id,
  g.gruppen_id as gruppe_id,
  u.created, 
  u.created_by, 
  u.modified, 
  u.modified_by,
  u.deleted,
  u.deleted_by
from "APEX_APP_USER" u  
left outer join  "APEX_ACCOUNT_STATUS" a 
on (u.app_user_status_id = a.status_id 
   and u.app_id = a.app_id) 
left outer join  "APEX_ROLES" ar 
on (ar.app_role_id = u.app_user_default_role_id 
    and ar.app_id = u.app_id) 
left outer join  "DOMAINEN" vd 
on (vd.domain_id = u.app_user_domain_id)
left outer join  "MELDER" m 
on (m.melder_id = u.app_user_melder_id)
left outer join "GRUPPEN" g
on (m.gruppen_id = g.gruppen_id)
left outer join "APEX_APP_USER_ROLE_MAP" rm 
on (u.app_user_id = rm.app_user_id 
      and u.app_id = rm.app_id)
order by 1, 2;


create or replace view "APEX_APPLICATION_USERS"
as 
  select APP_ID,
  APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_AD_LOGIN as AD_LOGIN,
  APP_USER_NOVELL_LOGIN as NOVELL_LOGIN,
  APP_USER_DEFAULT_ROLE_ID,
  DEFAULT_ROLE,
  DOMAIN_CODE, 
  DOMAIN,
  MELDEGRUPPE,
  MELDEGRUPPEN_CODE,
  GRUPPE_CODE, 
  GRUPPE,
  APP_USER_ACCOUNT_STATUS,
  APP_USER_PARENT_USER_ID,
  PARENT_USERNAME,
  APP_USER_DEFAULT_ROLE_ID as USER_DEFAULT_SECURITY_LEVEL,
  MAX_SECURITY_LEVEL as USER_MAX_SECURITY_LEVEL,
  MIN_SECURITY_LEVEL as USER_MIN_SECURITY_LEVEL,  
  DOMAIN_ID,
  MELDER_ID,
  GRUPPE_ID,
  CREATED,
  CREATED_BY,
  MODIFIED,
  MODIFIED_BY,
  DELETED,
  DELETED_BY
from "APEX_ALL_USERS"
where APP_ID = nvl(v('APP_ID'), app_id)
order by 1, 2;



create or replace view "USERS"
as 
  select 
  usr.app_user_id,
  usr.app_user_email,
  usr.app_username,
  usr.app_user_code,
  usr.app_user_account_status,
  usr.domain_code, 
  usr.domain,
  usr.meldegruppen_code,
  usr.meldegruppe,
  usr.gruppe_code, 
  usr.gruppe,
  usr.domain_id,
  usr.melder_id,
  usr.gruppe_id
from "APEX_APPLICATION_USERS" usr
where usr.app_user_account_status = 'OPEN';


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Vorgangs�bersicht
with 
"VORGANG" as (
SELECT ID_VORGANG, BEZEICHNUNG,VORGANGSNUMMER
FROM "AMF_VORGANG"
    WHERE ID_VORGANG = nvl(:P40_ID_VORGANG, ID_VORGANG)
),
"ERGAENZ" as (
SELECT 
 BEMERKUNG, MELDENDE_BEHOERDE, ID_VORGANG, CREATED, MODIFIED
 FROM "BOB_LAENDER_ROW_ERGAENZUNGEN"
),
"MASSN" as (
SELECT 
  m.ID_VORGANG,
  m.MELDENDE_BEHOERDE,
  m.MASSNAHME_ID,
  amm.MASSNAHME,
  m.MASSNAHME_UMGESETZT,
  m.MASSNAHME_UMGESETZT_AM,
  m.MASSNAHME_SONSTIGE,
  m.MASSNAHME_BEMERKUNG
FROM "BOB_LAENDER_ROW_MASSNAHMEN" m LEFT JOIN "AMF_MASSNAHMEN" amm
ON (m.MASSNAHME_ID = amm.ID)
)
SELECT
  v.ID_VORGANG,
  v.VORGANGSNUMMER,
  v.BEZEICHNUNG as VORGANG,
  m.CODE ,
  m.BEHOERDE,
  (select count(*) from BOB_LAENDER_ROW_DOKUMENTE where 
FROM "MELDESTELLEN" m LEFT OUTER JOIN "VORGANG" v
ON (1 = 1)
LEFT OUTER JOIN "MASSN" ma
ON ( )
;


create or replace view "RUECKMELDUNG_STATS"
as
-- docs
select 'DOKUMENTE' as note_type, count(1) as num_notes, d.id_vorgang, g.melder_id
from BOB_LAENDER_ROW_DOKUMENTE d JOIN DOMAIN_GRUPPEN g
on (d.domain_id = g.domain_id)
where d.deleted is null
group by d.id_vorgang, g.melder_id
union --notes
select 'ANMERKUNGEN' as mtype, count(1) as num_notes, d.id_vorgang, g.melder_id
from BOB_LAENDER_ROW_ERGAENZUNGEN d JOIN DOMAIN_GRUPPEN g
on (d.domain_id = g.domain_id)
where d.deleted is null
group by d.id_vorgang, g.melder_id
union --notes
select 'MASSNAHMEN' as mtype, count(1) as num_notes, d.id_vorgang, g.melder_id
from BOB_LAENDER_ROW_MASSNAHMEN d JOIN DOMAIN_GRUPPEN g
on (d.domain_id = g.domain_id)
where d.deleted is null
group by d.id_vorgang, g.melder_id;



create or replace view "RUECKMELDUNG_STATISTIK"
as
with
rueckmeldungen
as (
select 
  note_type,
  num_notes,
  id_vorgang,
  melder_id
from "RUECKMELDUNG_STATS"
)
select 
  m.melder_id,
  m.meldebehorde_id,
  v.id_vorgang,
  m.display_name,
  (select r.num_notes from "RUECKMELDUNGEN" r
   where r.melder_id = m.melder_id
       and r.id_vorgang     = v.id_vorgang
       and r.note_type = 'MASSNAHMEN') as anzahl_massnahmen,
  (select r.num_notes from "RUECKMELDUNGEN" r
   where r.melder_id = m.melder_id
       and r.id_vorgang     = v.id_vorgang
       and r.note_type = 'ANMERKUNGEN') as anzahl_anmerkungen,
  (select r.num_notes from "RUECKMELDUNGEN" r
   where r.melder_id = m.melder_id
       and r.id_vorgang     = v.id_vorgang
       and r.note_type = 'DOKUMENTE') as anzahl_dokumente,       
  m.gruppen_id,
  g.gruppe,
  g.gruppe_code,
  m.melder,
  m.melder_code,
  m.sort_seq,
  m.app_id,
  m.created,
  m.created_by,
  m.modified,
  m.modified_by
from "MELDER" m left outer join "AMF_VORGANG" v
on (1 = 1)
left outer join "GRUPPEN" g
on (m.GRUPPEN_ID = g.GRUPPEN_ID)
order by 3;



SELECT MELDER_ID,
  MELDEBEHORDE_ID,
  ID_VORGANG,
  DISPLAY_NAME,
  ANZAHL_MASSNAHMEN,
  ANZAHL_ANMERKUNGEN,
  ANZAHL_DOKUMENTE,
  GRUPPEN_ID,
  GRUPPE,
  GRUPPE_CODE,
  MELDER,
  MELDER_CODE,
  SORT_SEQ,
  APP_ID,
  CREATED,
  CREATED_BY,
  MODIFIED,
  MODIFIED_BY
FROM RUECKMELDUNG_STATISTIK ;

SELECT ID,
  ID_VORGANG,
  DATEINAME,
  MIMETYPE,
  DATEIINHALT
FROM DOKUMENTE ;

SELECT ID,
  ID_VORGANG,
  MELDENDE_BEHOERDE,
  DATEINAME,
  MIMETYPE,
  DATEIINHALT,
  USER_ID,
  DOMAIN_ID
FROM BOB_LAENDER_ROW_DOKUMENTE ;




begin begin  select "MASSNAHME_ID",to_char("MASSNAHME_UMGESETZT_AM", :p$_format_mask1),"MASSNAHME_BEMERKUNG","ID_VORGANG","ID","MASSNAHME_UMGESETZT","MELDENDE_BEHOERDE","USER_ID","DOMAIN_ID" into wwv_flow.g_column_values(1),wwv_flow.g_column_values(2),wwv_flow.g_column_values(3),wwv_flow.g_column_values(4),wwv_flow.g_column_values(5),wwv_flow.g_column_values(6),wwv_flow.g_column_values(7),wwv_flow.g_column_values(8),wwv_flow.g_column_values(9) 
from "INTERN"."BOB_LAENDER_ROW_MASSNAHMEN" 
where "ID" = :p_rowid and DOMAIN_ID = :LOGIN_DOMAIN_ID; end;
end;


http://testapex..de:8080/apex/f?p=100002:38:12259384022904::NO:RP,38:P38_ID,P0_P38_ID_VORGANG,P38_ART_DER_FAELSCHUNG,P38_EINGANGSDATUM,P38_MELDENDE_STELLE,P38_ARZNEIMITTELBEZEICHNUNG,P38_HALTBARKEITSDATUM_FAELSCHUNG,P38_HALTBARKEITSDATUM_ORIGINAL,P38_PHARM_UNTERNEHMEN,P38_WIRKSTOFF,P38_CHARGENBEZEICHNUNG_FAELSCHUNG,P38_CHARGENBEZEICHNUNG_ORIGINAL,P38_LAND,P0_P38_FROM_PAGE:38,94,Wirkstoff-F%C3%A4lschung,05.12.2017,,CALCIDURAN%20100,01.01.2017,01.01.2017,ASTA%20Medica%20GmbH,Calciumhydrogenphosphat,%20Colecalciferol-Cholesterol,CALCID-B001,CALCIDU-01B,Deutschland,19



#P120_ID_VORGANG { width: 400px; }
#P120_DOKUMENTEN_INHALT { width: 400px; }
#B28234277840768129 { margin-left: 38px; }
#P120_DATEIINHALT_DISPLAY_CONTAINER > div.t-Form-inputContainer.col.col-9 { width: 75%; }


trigger "APEX_APP_USER_BIU_TRG"
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
    if (:new.app_user_domain_id is null or :new.app_user_melder_id is null) then
        select d.domain_id, d.domain_melder_id 
        into :new.app_user_domain_id, :new.app_user_melder_id
        from "DOMAINEN" d
        where lower(trim(d.domain)) =lower(substr(:new.app_user_email, instr(:new.app_user_email, '@') +1));
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


select d.domain_id, d.domain_melder_id 
        --into :new.app_user_domain_id, :new.app_user_melder_id
        from "DOMAINEN" d
        where lower(trim(d.domain)) =lower(substr(:app_user_email, instr(:app_user_email, '@') +1));
        
         select apex_app_user_id_seq.nextval from dual;
         
drop sequence apex_app_user_id_seq;         

create sequence apex_app_user_id_seq start with 100 increment by 1 nocache noorder nocycle;         


create index BLR_DOKU_MELDER_ID_IDX on BOB_LAENDER_ROW_DOKUMENTE(melder_id);
create index BLR_DOKU_DEL_IDX on BOB_LAENDER_ROW_DOKUMENTE(deleted);

drop index BLR_ERGAENZ_DOMAIN_ID_IDX;
create index BLR_ERGAENZ_MELDER_ID_IDX on BOB_LAENDER_ROW_ERGAENZUNGEN(melder_id);
create index BLR_ERGAENZ_DEL_IDX on BOB_LAENDER_ROW_ERGAENZUNGEN(deleted);

drop index BLR_MASSN_DOMAIN_ID_IDX;
create index BLR_MASSN_MELDER_ID_IDX on  BOB_LAENDER_ROW_MASSNAHMEN(melder_id);
create index BLR_MASSN_DEL_IDX on  BOB_LAENDER_ROW_MASSNAHMEN(deleted);

create index APEX_USER_DOMAIN_ID_IDX on APEX_APP_USER(APP_USER_DOMAIN_ID);
create index APEX_USER_MELDER_ID_IDX on APEX_APP_USER(APP_USER_MELDER_ID);

create index AMF_VORGANG_DEL_IDX on AMF_VORGANG(deleted);

create index DOK_DEL_IDX on DOKUMENTE(deleted);
create index DOM_DEL_IDX on DOMAINEN (deleted);



begin
  dbms_stats.gather_schema_stats(user);
end;
/


.a-IRR-table { white-space: nowrap; }

.a-GV-floatingItem {
    max-width: 100%;
}

#DOK {  
  border: 1px solid #f4f4f4;
  padding: 12px;
}


td > p { font-size: 13px; line-height: 0.2 };

select gruppe_code
from USERS
where upper(trim(app_username)) = upper(trim(:APP_USER));


SELECT APP_USER_ID,
  APP_USER_EMAIL,
  APP_USERNAME,
  APP_USER_CODE,
  APP_USER_ACCOUNT_STATUS,
  DOMAIN_CODE,
  DOMAIN,
  MELDEGRUPPEN_CODE,
  MELDEGRUPPE,
  GRUPPE_CODE,
  GRUPPE,
  DOMAIN_ID,
  MELDER_ID,
  GRUPPE_ID
FROM USERS ;

SELECT MELDER_ID,
  MELDER,
  MELDER_CODE,
  DISPLAY_NAME,
  GRUPPE,
  GRUPPE_CODE,
  DOMAIN,
  DOMAIN_CODE,
  APP_ID,
  MELDEBEHORDE_ID,
  GRUPPEN_ID,
  GRUPPEN_ID,
  SORT_SEQ,
  CREATED,
  CREATED_BY,
  MODIFIED,
  MODIFIED_BY
FROM MELDEDOMAINEN ;


SELECT 
  e.ID,
  e.ID_VORGANG,
  nvl(e.MELDENDE_BEHOERDE, :LOGIN_DOMAIN) as MELDENDE_BEHOERDE,
  dbms_lob.getlength(e.DATEIINHALT)||' Bytes' as DATEIGROESSE,
  e.DATEINAME,
  e.DOKUMENTEN_INHALT,
  e.MIMETYPE,
 '<img src="'||apex_util.get_blob_file_src('P125_ICON', i.icon_id)||'" style="width:32px; height:32px;" alt="'||i.ICON_FILE_NAME||'"/>' as ICON_DISPLAY,
 I.ICON_ID,
 e.USER_ID
FROM "BOB_LAENDER_ROW_DOKUMENTE" e left outer join "MIME_TYPE_ICONS" i
ON (e.MIMETYPE = I.MIME_TYPE)
WHERE e.ID_VORGANG = :P125_ID_VORGANG
AND e.MELDER_ID = :P125_MELDER_ID
AND e.DELETED is null;

select * from BOB_LAENDER_ROW_DOKUMENTE where id_vorgang = 94;
select * from MIME_TYPE_ICONS;-- where mime_type = 'image/jpeg';




select * from (
SELECT 
  ID_VORGANG,
  VORGANGSNUMMER,
  BEZEICHNUNG,
  MELDENDE_STELLE,
  EINGANGSDATUM,
  FALL,
  AM_NAME,
  AM_PU,
  AM_CHRG_ORIG,
  AM_CHRG_FAELSCH,
  AM_CHRG_HLTB,
  AM_CHRG_F_HLTB,
  ART_DER_FAELSCHUNG,
  FAELSCHUNGSART_SONSTIGE,
  AM_CHRG_STATUS,
  AM_WIRKSTOFF,
  DELETED_BY,
  DELETED,
  ZUST_LANDESBEHOERDE,
  AM_ENR,
  AM_PNR,
  AMF_MELDUNG_STATUS,
  ART_DER_ZUSTAENDIGKEIT,
  ART_DER_ZUSTAENDIGKEIT_SONST,
  ERSTELLUNGSDATUM,
  STAAT_ID,
  BUNDESLAND_ID,
  BUNDESOBERBEHOERDE
FROM AMF_VORGANG
ORDER BY EINGANGSDATUM desc
) where rownum < 8;



select d.domain_id
from "DOMAINEN" d
where lower(trim(d.domain)) = lower(substr(:new.app_user_email, instr(:new.app_user_email, '@') +1));

select * from USER_ROLE_PRIVS;

select count(*) from user_objects where status != 'VALID';

-- old
CREATE OR REPLACE FORCE VIEW "INTERN"."APEX_APP_USERNAME_FORMAT" ("USERNAME_FORMAT") AS 
  select app_setting_value as username_format
from "APEX_APP_SETTINGS"
where app_id = v('APP_ID') 
and app_setting_category = 'AUTHENTICATION'
and app_setting_name = 'USERNAME_FORMAT'
;

--- new
CREATE OR REPLACE FORCE VIEW "APEX_USERNAME_FORMAT" ("USERNAME_FORMAT") AS 
  select apex_config_item_value as username_format
from "APEX_CONFIGURATION"
where apex_config_item = 'USERNAME_FORMAT';

create or replace view "APEX_APP_USERNAME_FORMAT" ("USERNAME_FORMAT") 
as 
select USERNAME_FORMAT
from "APEX_USERNAME_FORMAT";

-- old
  CREATE OR REPLACE FORCE VIEW "INTERN"."APEX_APPLICATION" ("WORKSPACE_ID", "WORKSPACE", "APPLICATION_ID", "OWNER", "APPLICATION_NAME", "COMPATIBILITY_MODE", "HOME_LINK", "HOME_LINK_APEX", "LOGIN_URL", "THEME_NUMBER", "ALIAS", "PAGES", "APPLICATION_ITEMS", "LAST_UPDATED_BY", "LAST_UPDATED_ON", "AUTHENTICATION_SCHEMES", "AUTHENTICATION_SCHEME_TYPE", "AUTHORIZATION_SCHEMES", "AUTHORIZATION_SCHEME") AS 
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

-- new
create or replace view "APEX_APPLICATION" 
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
where application_id = nvl(v('APP_ID'), application_id);

  select workspace_id,
  workspace,
  application_id,
  owner,
  application_name
  from "APEX_APPLICATION" ;


declare
l_auth_type varchar2(100);
l_text varchar2(1000);
begin
  select
    case AUTHENTICATION_SCHEME_TYPE
    when 'Application Express Accounts'
    then 'APEX Application Express'
    when 'LDAP Directory'
    then 'Windows'
    when 'Database Accounts'
    then 'Oracle Datenbank'    
    end
--  into l_auth_type
FROM "APEX_APPLICATION" 
where AUTHENTICATION_SCHEME_TYPE in ('Application Express Accounts', 'LDAP Directory', 'Database Accounts');
--return l_auth_type;
exception when no_data_found then
 null;
end;
/

select application_name
from "APEX_APPLICATION";

select * from  "APEX_APPLICATION" ;


select * from "APEX_APPLICATION" ;

select owner, object_type from all_objects where object_name = 'APEX_APP_USERNAME_FORMAT';

select username_format
from "APEX_APP_USERNAME_FORMAT";

select upper(username_format)
from "APEX_APP_USERNAME_FORMAT";


select user_status + valid_domain as user_status
from (
    select case when user_exists =  0
                      then 0
                      else user_status
               end as user_status,
               case when user_exists = 0
               -- without any more args to is_valid_domain, the offset is determined by then system setting ENFORCE_VALID_DOMAIN in apx$cfg
               then "IS_VALID_DOMAIN"(upper(trim(:USERNAME)), p_return_as_offset => 'TRUE', p_return_offset => -1)
               else 0
               end as valid_domain
    from
    (select count(1)             as user_exists,
               max(user_status) as user_status
     from "APEX_USER_REG_STATUS"
     where upper(trim(username)) = upper(trim(:USERNAME))
    )
 );


grant select on "APX$USER_REG"                to "PUBLIC";
grant select on "APX$STATUS"                  to "PUBLIC";
grant select on "APEX_USER_REG_STATUS"        to "PUBLIC";
grant select on "APEX_USER_REGISTRATIONS"     to "PUBLIC";


select "IS_VALID_DOMAIN"(upper(trim(:USERNAME)), p_return_as_offset => 'FALSE') from dual;

DROP TABLE "AMF_VORGANG" cascade constraints;
--DROP TABLE "BUNDESSTAATEN" cascade constraints;
--------------------------------------------------------
--  DDL for Table AMF_VORGANG
--------------------------------------------------------

  CREATE TABLE "AMF_VORGANG" 
   (	"ID_VORGANG" NUMBER, 
	"VORGANGSNUMMER" VARCHAR2(128 BYTE), 
	"BEZEICHNUNG" VARCHAR2(512 BYTE), 
	"MELDENDE_STELLE" VARCHAR2(512 BYTE), 
	"EINGANGSDATUM" DATE DEFAULT sysdate, 
	"ERSTELLUNGSDATUM" DATE, 
	"STAAT_ID" NUMBER, 
	"BUNDESLAND_ID" NUMBER, 
	"BUNDESOBERBEHOERDE" VARCHAR2(128 BYTE), 
	"BEMERKUNG" VARCHAR2(1000 BYTE), 
	"MODIFIED" DATE, 
	"MODIFIED_BY" VARCHAR2(30 BYTE), 
	"CREATED" DATE, 
	"CREATED_BY" VARCHAR2(30 BYTE), 
	"BEARB_INSPEKTOR" VARCHAR2(200 BYTE), 
	"BETEIL_INSPEKTOR" VARCHAR2(200 BYTE), 
	"STELLUNGNAHME_ANGEFORDERT" DATE, 
	"STUFENPLANBEAUFTRAG" VARCHAR2(200 BYTE), 
	"RISIKO_STELLUNGNAHME" DATE, 
	"CHARGEN_MAENGEL" NUMBER, 
	"FALL" NUMBER, 
	"AM_NAME" VARCHAR2(200 BYTE), 
	"AM_ZNR" VARCHAR2(200 BYTE), 
	"AM_PU" VARCHAR2(200 BYTE), 
	"AM_CHRG_ORIG" VARCHAR2(200 BYTE), 
	"AM_CHRG_FAELSCH" VARCHAR2(200 BYTE), 
	"AM_CHRG_HLTB" DATE, 
	"AM_CHRG_F_HLTB" DATE, 
	"ART_DER_FAELSCHUNG" NUMBER, 
	"FAELSCHUNGSART_SONSTIGE" VARCHAR2(400 BYTE), 
	"AM_CHRG_STATUS" VARCHAR2(50 BYTE), 
	"AM_WIRKSTOFF" VARCHAR2(1000 BYTE), 
	"DELETED_BY" VARCHAR2(30 BYTE) DEFAULT user, 
	"DELETED" DATE, 
	"ZUST_LANDESBEHOERDE" VARCHAR2(400 BYTE), 
	"AM_ENR" VARCHAR2(200 BYTE), 
	"AM_PNR" VARCHAR2(200 BYTE), 
	"AMF_MELDUNG_STATUS" NUMBER DEFAULT 1, 
	"ART_DER_ZUSTAENDIGKEIT" VARCHAR2(200 BYTE), 
	"ART_DER_ZUSTAENDIGKEIT_SONST" VARCHAR2(1000 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table BUNDESSTAATEN
--------------------------------------------------------

--  CREATE TABLE "BUNDESSTAATEN" 
--   (	"STAAT_ID" NUMBER, 
--	"STAAT" VARCHAR2(128 BYTE), 
--	"AMTLICHE_VOLLFORM" VARCHAR2(512 BYTE), 
--	"ISO_2" VARCHAR2(10 BYTE), 
--	"ISO_3" VARCHAR2(30 BYTE), 
--	"ISO_NUM" VARCHAR2(30 BYTE), 
--	"MODIFIED" DATE, 
--	"MODIFIED_BY" VARCHAR2(30 BYTE), 
--	"CREATED" DATE, 
--	"CREATED_BY" VARCHAR2(30 BYTE)
--   ) ;
--------------------------------------------------------
--  DDL for Sequence AMF_VORGANG_SEQ
--------------------------------------------------------

CREATE SEQUENCE  "AMF_VORGANG_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 101 NOCACHE  NOORDER  NOCYCLE ;

-- INSERTING into AMF_VORGANG
SET DEFINE OFF;
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('93','DE345675423','Testfall1','',to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','7',null,'<p>viel zu sagen gibt es hier nicht</p>
',to_date('21.12.2017 11:50:46','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('04.12.2017 15:31:15','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'ASTAPECT-KODEIN',null,'ASTA Medica GmbH','Blo2','Bla1',to_date('01.12.2022 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.08.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),'6','Verpackung',null,'Codeinphosphat-Hemihydrat, Ephedrinhydrochlorid, Sulfogaiacol',null,null,'Hessen','0000371','3000621','1','�rtlicher Vertreter',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('59','DE2345678','Test','',to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('25.07.2017 10:35:20','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('60','DE1324','NENEEN','',to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('25.07.2017 10:47:48','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('61','fzfhzj','cgh','',to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('25.07.2017 14:40:01','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('62','DE879','TestBez','BW - Baden-Wuerttemberg',to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 11:51:07','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA',null,null,null,null,null,null,null,'Avamigran N',null,'AWD.pharma GmbH',null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('63','DE12345','Fall 3','',to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 14:03:52','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('64','xxy','Xeplion','',to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 14:07:30','DD.MM.YYYY HH24:MI:SS'),'MWITTSTOCK',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('87','DE00007','Test','',to_date('02.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('02.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','10',null,'<p>Bemerk</p>
',to_date('05.12.2017 15:31:39','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('02.11.2017 11:16:28','DD.MM.YYYY HH24:MI:SS'),'ADMIN','hshshs','hshshs',null,'hshshsh',null,'1','1','Aspirin Nasenspray',null,'Bayer Vital GmbH','Aspirin Nasenspray 400ml','Aspirin N�senspray 400ml',to_date('01.09.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.09.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'2','Oxymetazolinhydrochlorid','APEX_PUBLIC_USER',to_date('05.12.2017 15:31:39','DD.MM.YYYY HH24:MI:SS'),null,'2137607','8011204','2',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('47','DE12345','Harvoni 3','',to_date('19.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('19.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,'<p>die Inspektoren sind nicht miteinander verwandt, sondern kommen aus demselben Dorf!</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('19.07.2017 18:33:08','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Unterm�ller-Krainersohn','Unterkrainer-M�llersohn',null,'Neo Goodheart',to_date('10.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','1','Harvoni 90 mg/400 mg','EU/1/14/958/002','Gilead Sciences International Limited',null,'GHERT32DE',null,to_date('01.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'6','alles total falsch!','3',null,null,null,'Landeskriminalamt Oberbayern',null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('48','DE3456','TAPESTRY','',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('19.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,'<p>so was hat die Welt noch nicht gesehen.</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('19.07.2017 18:50:54','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Unterm�ller','Huber',null,'Sr. Rodrig�z',to_date('10.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','0','Harvoni 90 mg/400 mg','EU/1/14/958/002','Gilead Sciences International Limited','HSFRDE34','HGDSER34',to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'2','Ledipasvir, Sofosbuvir',null,null,'Landeskriminalamt Niedersachsen','2711769','8030549','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('88','5665475','657457','543245',to_date('07.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('07.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('07.11.2017 20:19:49','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('89','DE1239780','Norditalien','',to_date('08.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('08.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,null,to_date('11.12.2017 17:34:02','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('08.11.2017 14:59:43','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'Harvoni','EU/1/14/958/002','Gilead Sciences International Limited',null,null,to_date('01.12.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,null,'Ledipasvir, Sofosbuvir',null,null,null,'2711769','8030549','1','Zulassungsinhaber',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('14','DE123456','Harvoni',' - Bundesinstitut f�r Arzneimittel und Medizinprodukte ()',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:22:36','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('15','DE34567','Cement','BVL - Bundesamt f�r Verbraucherschutz und Lebensmittelsicherheit (BVL)',to_date('15.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 15:28:33','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:25:38','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('16','DE3455677','Chaos in Hamburg','BKA - Bundeskriminalamt',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','2','17','<p>Voll die <strong><u>Bemerkung!!!</u></strong></p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:27:25','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Oberm�ller','Unterkrainer',null,'Mr. Smith',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','1','Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Milinda GmbH',null,'DETRAE123',null,to_date('31.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'3',null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('17','DE2345','Aspirin',' - Bundesinstitut f�r Arzneimittel und Medizinprodukte ()',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,'17','<p>Bemrk</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:31:52','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Oberm�ller','Unterkrainer',null,'Mr. Smith',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','1','Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Gilead Sciences International Limited',null,'SEFER3453',null,to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'1',null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('18','DE234556','Harvoni',' - Bundesinstitut f�r Arzneimittel und Medizinprodukte ()',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','3','18','<p>Bemrrk</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:36:05','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Oberm�ller','UNterkrainer',null,'Mr. Smith',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','1','Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Milinda GmbH',null,'BFER23',null,to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,'3',null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('19','DE23456','NHEHEHE',' - Bundesinstitut f�r Arzneimittel und Medizinprodukte ()',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','2','17',null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:40:03','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Oberm�ller','UNterkrainer',null,'Smith',null,'1','1','Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Milinda GmbH','JDJDJDJ','GSGSSG',to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'1',null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('20','DE12345','BAGAGA','',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,'3','<p>Bemerkl</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:44:42','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Oberm�ller','Unterbayer',null,'M�ller',to_date('10.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','1','Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Gilead Sciences International Limited','HFHFH','BGGER45',to_date('01.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'3',null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('50','454634356','Test','Test',to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('20.07.2017 09:05:31','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'Aspirin Nasenspray',null,'Bayer Vital GmbH',null,null,null,null,null,null,null,'Oxymetazolinhydrochlorid',null,null,null,'2137607','8011204','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('51','DE222','Test','',to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('20.07.2017 09:32:30','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('49','DE1239','Test','',to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,'<p>Status der Verifizierung angelegt</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('20.07.2017 08:51:18','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA','Lisa M�ller','Max Mustermensch',null,null,null,'1','0','CODEINE UND ASPIRIN UND PHENACETIN TABLETTEN',null,'Holsten Pharma GmbH',null,null,null,null,'6','Testf�lschung','2','Acetylsalicyls�ure (Ph.Eur.), Codeinphosphat-Hemihydrat, Phenacetin',null,null,null,'0912712','3001738','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('53','1234','Test Fall','BKA - Bundeskriminalamt',to_date('21.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('21.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('21.07.2017 11:06:20','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('54','DE12345','Neuer Fall','',to_date('30.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('21.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('24.07.2017 10:43:36','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('55','DE3425','Ganz Neuer Fall','',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('24.07.2017 13:38:20','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('56','DE12233','Ganz Neuer Fall','',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 15:15:23','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('24.07.2017 14:49:50','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('57','DE2343343','Ganz Ganz Neuer Fall','',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('24.07.2017 15:15:29','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('58','GERER','HDHDH','',to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('24.07.2017 17:29:30','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('83','123','TestKlose','',to_date('19.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('19.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','12',null,'<p>ecdfsd</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('19.09.2017 14:56:39','DD.MM.YYYY HH24:MI:SS'),'TKLOSE','frgase','sefg',null,'esggvdfs',null,null,'1','Aspirine Direkt','vdsfbv','cvsef','sergxcvyed','fresfagfe',null,null,null,null,'2','Acetylsalicyls�ure (Ph.Eur.)',null,null,'Bayern','2140249','3216120','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('67','DE1','Diebstahl IT','BB - Brandenburg',to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,'<p>fhhfsdhdsflsdlhdfsljhsjlh&ouml;.</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 15:12:10','DD.MM.YYYY HH24:MI:SS'),'TKLOSE','Dr. mmm','dddd',null,'ddd; jujj; zhhh',null,null,'1','diverse','EU/1/11/672/002','diverse','xx5','xx5',to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'6','unbekannt','2','diverse',null,null,'Bezirksregierung D�sseldorf','2750363','8090132','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('75','0815','Testf�lschung','Apotheke zur F�lschung',to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('31.07.2017 15:56:36','DD.MM.YYYY HH24:MI:SS'),'NPAESCHKE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('85','5',null,null,to_date('27.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('27.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('27.09.2017 13:10:33','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('86','DE2017-001','QD2017-149/H/Sprycel/ falsification','EMA',to_date('28.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('29.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'36',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('29.09.2017 17:02:57','DD.MM.YYYY HH24:MI:SS'),'GOMLOR',null,null,null,null,null,null,'1','Sprycel','EU/1/06/363/003','Abacus',null,'AAK7575',to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.10.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),'4',null,'3',null,null,null,'Bayern',null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('90','DE000999','Testfaelschung','',to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('04.12.2017 10:46:57','DD.MM.YYYY HH24:MI:SS'),'ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('91','DE0123454','Testfall','',to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','9',null,'<p>Bemerk</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('04.12.2017 10:54:37','DD.MM.YYYY HH24:MI:SS'),'ADMIN',null,null,null,null,null,null,null,'ASPIRIN-PHENACETIN-CODEIN',null,'Delta Distribution GmbH',null,null,to_date('01.12.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.12.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1',null,null,'Acetylsalicyls�ure (Ph.Eur.), Codeinphosphat-Hemihydrat, Phenacetin',null,null,null,'0612513','3000288','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('92','DE12345678','Test','',to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','12',null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('04.12.2017 11:23:04','DD.MM.YYYY HH24:MI:SS'),'ADMIN',null,null,null,null,null,null,null,'Aspirine Direkt',null,'kohlpharma GmbH',null,null,null,null,'6',null,null,'Acetylsalicyls�ure (Ph.Eur.)',null,null,null,'2140249','3216120','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('11','Harvoni','Harvoni','Regierungspr�sidium Oberbayern',to_date('07.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('07.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','2','1','m�glicherweise gef�lschte Tabletten in Apotheke entdeckt anhand von Farbabweichung entdeckt(wei� statt ockerfarben)',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('07.07.2017 13:16:04','DD.MM.YYYY HH24:MI:SS'),'NPAESCHKE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('1','NEU12345DEF','Harvoni�','',to_date('12.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('12.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','8','3','Die gef�lschten Tabletten sind nicht wie �blich orange, sondern wei� und sollten keinesfalls eingenommen werden.',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('28.06.2017 19:06:16','DD.MM.YYYY HH24:MI:SS'),'INTERN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('2','NEU12341DE','Lore Ipsum (c)','LKA',to_date('07.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'68',null,'1','Where does it come from?
Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.
And everything else is FAKE NEWS!',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('28.06.2017 19:06:16','DD.MM.YYYY HH24:MI:SS'),'INTERN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('84','2',null,null,to_date('27.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('27.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('27.09.2017 09:17:57','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'dewdf',null,null,null,null,to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('21','1','Test von Herrn Klose','Italien',to_date('19.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('19.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('19.07.2017 08:53:29','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('94','DE1234567','Testfall','',to_date('05.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('05.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','7',null,null,to_date('15.12.2017 14:33:35','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('05.12.2017 18:05:36','DD.MM.YYYY HH24:MI:SS'),'ADMIN',null,null,null,null,null,null,null,'CALCIDURAN 100',null,'ASTA Medica GmbH','CALCIDU-01B','CALCID-B001',to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,null,'Calciumhydrogenphosphat, Colecalciferol-Cholesterol',null,null,null,'0000342','3000621','1','Freitext','Unbekannte Zust�ndigkeit');
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('9','NEUNEU1234','Neu','BVL',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,'1','<p>alles neu war gestern</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('03.07.2017 15:17:25','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Harvoni 90 mg/400 mg Filmtabletten - OP(3x28)','EU/1/14/958/002','Gilead Sciences International Limited',null,null,null,null,null,null,null,'Ledipasvir, Sofosbuvir',null,null,null,'2711769','8030549','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('95','QD2017-0001','AVACAN BW','BW - Baden-Wuerttemberg',to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','7',null,null,to_date('15.12.2017 17:19:22','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('11.12.2017 11:25:31','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'AVACAN',null,'ASTA Medica GmbH',null,null,to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'3',null,null,'Camylofindihydrochlorid',null,null,null,'0000299','3000621','1','Zulassungsinhaber',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('96','RAS2017-007','TEST01','BE - Berlin',to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,'<p>Bemerkungen zu dem Fall</p>
',to_date('11.12.2017 16:28:23','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('11.12.2017 12:27:36','DD.MM.YYYY HH24:MI:SS'),'JDUSSA',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('99','QD2017-183','Arzneimittel Xermelo 250 mg Filmtabletten der Firma Ipsen Innovation in FR - (expiry date and lot number inversion) - StN AT','EMA',to_date('08.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('12.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,'<p>Wird bearbeitet!</p>
',to_date('14.12.2017 10:52:54','DD.MM.YYYY HH24:MI:SS'),'JDUSSA',to_date('12.12.2017 08:19:33','DD.MM.YYYY HH24:MI:SS'),'JDUSSA',null,null,null,null,null,null,null,'EMEND 80 mg Hartkapseln - OP(5x1)','EU/1/03/262/003','Merck Sharp','XY-21555','XY-20147',to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1',null,null,'Aprepitant',null,null,null,'2702452','3316407','1','Zulassungsinhaber',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('100','DE000100','Testfall34','BMEL',to_date('22.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('22.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','9',null,null,to_date('22.12.2017 09:38:56','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('22.12.2017 09:35:30','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Echter Warthaer Balsam',null,'Berg-Apotheke Othfresen','NRTAE2','NRET45',to_date('01.06.2020 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.02.2021 00:00:00','DD.MM.YYYY HH24:MI:SS'),'3',null,null,'Alantwurzelstock, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Aloe, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Benzoe, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Bitterkleebl�tter, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Campher, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Enzianwurzel, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Galgantwurzelstock, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Johanniskraut, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Kalmuswurzelstock, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Meisterwurzwurzelstock, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Myrrhe, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Rhabarberwurzel, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Sassafraswurzelholz, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Schwertlilienwurzelstock, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Tausendg�ldenkraut, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Weihrauch, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Zaunr�be, FE mit Ethanol/Ethanol-Wasser (%-Angaben)',null,null,'Landeskriminalamt Niedersachsen','0000738','0091824','1','Zulassungsinhaber',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('8','CGN4711','K�lle','erwr',to_date('29.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('29.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','4','1','jhsdjfhsdjkfhsdjfh',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('29.06.2017 13:19:44','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('76','DE12345','Neu','',to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','12',null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('31.07.2017 17:55:24','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Milinda GmbH','GE4321','gr34215',to_date('01.06.2025 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.05.2022 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,null,'Ledipasvir, Sofosbuvir',null,null,'Bezirksregierung D�sseldorf','2750150','3078936','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('80','DE111','fdfd','BVL',to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 15:13:42','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('02.08.2017 08:54:12','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('70','DE2453','Neuer Fall','',to_date('05.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 17:58:10','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Harvoni 90 mg/400 mg Filmtabletten - OP(3x28)','EU/1/14/958/002','Gilead Sciences International Limited',null,null,null,to_date('01.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,'Ledipasvir, Sofosbuvir',null,null,null,'2711769','8030549','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('71','DE23456','Harvoni2','',to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,'<p>bpuibdcpIUB&Uuml;OKINc</p>
',to_date('05.12.2017 14:20:16','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 18:57:52','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Gilead Sciences International Limited',null,null,to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,'Ledipasvir, Sofosbuvir',null,null,null,'2711768','8030549','2',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('72','DE1234','Beizeichnung','',to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('31.07.2017 11:40:48','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('73','DE','Beu','',to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 16:29:30','DD.MM.YYYY HH24:MI:SS'),'INTERN',to_date('31.07.2017 11:42:15','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'INTERN',to_date('05.12.2017 16:29:30','DD.MM.YYYY HH24:MI:SS'),null,null,null,'2',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('74','DE1234','Son Ding','',to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 16:53:22','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('31.07.2017 11:58:48','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Aspirinuom',null,'Bayer',null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('81','DE000081','Arzneimitteldiebstahl in K�ln','NW - Nordrhein-Westfalen',to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,'<p>Alle betroffenen AM sind als F&auml;lschung von Markt zu nehmen.</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('02.08.2017 09:22:18','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'mehrere','mehrere','mehrere','mehrere','mehrere',null,null,'1',null,null,'mehrere',null,null,'mehrere',null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('82','ghjkfkzzf',null,null,to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','10',null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('02.08.2017 09:34:33','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'Aspirin Nasenspray',null,null,null,null,to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,'Oxymetazolinhydrochlorid',null,null,null,'2137607','8011204','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('97','DE1234','Shanghai Fall','',to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','2',null,null,to_date('15.12.2017 17:05:13','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('11.12.2017 17:33:17','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'CiNU I',null,'Bristol Arzneimittel GmbH   [HIST]','YIAN01','YOIAN00',to_date('01.01.2020 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.02.2021 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,null,'Lomustin',null,null,null,'0027878','3336692','1','�rtlicher Vertreter',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('98','DE1223454','Schleswig Container','',to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('14.12.2017 15:40:41','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('11.12.2017 17:54:05','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
--------------------------------------------------------
--  DDL for Index AMF_VORGANG_DEL_IDX
--------------------------------------------------------

  CREATE INDEX "AMF_VORGANG_DEL_IDX" ON "AMF_VORGANG" ("DELETED") 
  ;
--------------------------------------------------------
--  DDL for Index AMF_VORGANG_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "AMF_VORGANG_PK" ON "AMF_VORGANG" ("ID_VORGANG") 
  ;
  
  commit;
--------------------------------------------------------
--  DDL for Trigger AMF_VORGANG_STAAT_AU_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMF_VORGANG_STAAT_AU_TRG" 
before update of STAAT_ID on "AMF_VORGANG"
referencing old as old new as new
for each row
declare
l_de_id number;
begin
    select staat_id into l_de_id
    from bundesstaaten
    where iso_2 = 'DE';
    if :new.staat_id != l_de_id then
      :new.bundesland_id := null;
    end if;  
end;
/
ALTER TRIGGER "AMF_VORGANG_STAAT_AU_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger AMF_VORGANG_BIU_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMF_VORGANG_BIU_TRG" 
before insert or update on "AMF_VORGANG"
referencing old as old new as new
for each row
begin
  if inserting then
    if (:new.ID_VORGANG is null) then
        select AMF_VORGANG_SEQ.nextval
        into :new.ID_VORGANG
        from dual;
        :new.AMF_MELDUNG_STATUS := 1;
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
ALTER TRIGGER "AMF_VORGANG_BIU_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger AMF_MELDUNG_BD_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMF_MELDUNG_BD_TRG" 
before delete on "AMF_VORGANG"
referencing old as old new as new
for each row
declare
  pragma autonomous_transaction;
begin
      "SOFT_DELETE" ('AMF_VORGANG', :old.id_vorgang);
end;
/
ALTER TRIGGER "AMF_MELDUNG_BD_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger AMF_STATUS_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMF_STATUS_TRG" 
before update of AMF_MELDUNG_STATUS on "AMF_VORGANG"
referencing old as old new as new
for each row
begin
    if (:new.AMF_MELDUNG_STATUS = 2) then -- locked
      :new.DELETED := sysdate;
      :new.DELETED_BY := nvl(v('APP_USER'), user);
    elsif (:new.AMF_MELDUNG_STATUS = 1) then -- opened
      :new.DELETED := null;
      :new.DELETED_BY := null;
    end if;
end;
/
ALTER TRIGGER "AMF_STATUS_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger AMF_DEL_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "AMF_DEL_TRG" 
before update of DELETED, DELETED_BY on "AMF_VORGANG"
referencing old as old new as new
for each row
begin
    if (:new.DELETED is not null) then -- locked
      :new.AMF_MELDUNG_STATUS := 2;
    end if;
end;
/
ALTER TRIGGER "AMF_DEL_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Procedure SOFT_DELETE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SOFT_DELETE" (
p_table in varchar2,
p_id number,
p_msg in varchar2 :=' k�nnen nicht gel�scht werden!',
p_new_status varchar2 := 'LOCKED'
) is
pragma autonomous_transaction;
l_status_id pls_integer;
l_msg varchar2(1000);
begin
    select app_status_id into l_status_id
    from "APEX_APP_STATUS"
    where app_status = upper(nvl(p_new_status, 'LOCKED'));
    if (upper(p_table) = 'APEX_APP_USER') then
        l_msg := 'Benutzer'||p_msg;
        commit;
        update  "APEX_APP_USER"
        set deleted  = sysdate,
              deleted_by  = nvl(v('APP_USER'), user),
              app_user_status_id = l_status_id
        where APP_USER_ID = p_id;
    elsif  (upper(p_table) = 'DOMAINEN') then
        l_msg := 'Domainen'||p_msg;
        commit;
        update  "APEX_APP_USER"
        set deleted  = sysdate,
              deleted_by  = nvl(v('APP_USER'), user),
              app_user_status_id = l_status_id
        where app_user_domain_id  = p_id;
        update "DOMAINEN"
        set deleted = sysdate,
              deleted_by     = nvl(v('APP_USER'), user)
        where domain_id = p_id;
    elsif (upper(p_table) = 'AMF_VORGANG') then
        l_msg := 'RAS Vorg�nge'||p_msg;
        commit;
        UPDATE "AMF_VORGANG"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user),
              AMF_MELDUNG_STATUS = l_status_id
        where ID_VORGANG = p_id;    
    elsif (upper(p_table) = 'DOKUMENTE') then
        l_msg := 'RAS Vorgangsdokumente'||p_msg;
        commit;
        UPDATE "DOKUMENTE"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user)
        where ID_VORGANG = p_id;    
    elsif (upper(p_table) = 'BOB_LAENDER_ROW_DOKUMENTE') then
        l_msg := 'RAS Vorgangsdokumente'||p_msg;
        commit;
        UPDATE "BOB_LAENDER_ROW_DOKUMENTE"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user)
        where ID_VORGANG = p_id;   
    elsif (upper(p_table) = 'BOB_LAENDER_ROW_ERGAENZUNGEN') then
        l_msg := 'RAS Vorgangserg�nzungen'||p_msg;
        commit;
        UPDATE "BOB_LAENDER_ROW_ERGAENZUNGEN"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user)
        where ID_VORGANG = p_id;    
    end if;        
    commit;
    RAISE_APPLICATION_ERROR (-20002, l_msg, TRUE);
end;

/


 declare
 l_result pls_integer;
 begin
     send_mail(  p_mailto => 'Trivadis@.de'
               , p_result => l_result
               , p_topic  => 'REGISTER'
               , p_app_id => 100000   -- needed for Topic to work :-)
               , p_debug_only => false);
     dbms_output.put_line('*** Send Mail returned: ' || l_result);
 end;
 /
 

declare
l_result pls_integer;
l_userid pls_integer;
 begin
    insert into "APEX_USER_REGISTRATION" (apx_username, apx_user_email)
    values (nvl(:P102_USERNAME, :P102_USER_EMAIL), :P102_USER_EMAIL)
    returning apx_user_id into l_userid;
 
     send_mail(  p_mailto => :P102_USER_EMAIL
               , p_result => l_result
               , p_topic  => 'REGISTER'
               , p_app_id => v('APP_ID')
               , p_debug_only => false);
               
    if (l_result = 0) then
        update "APEX_USER_REGISTRATION"
        set apx_user_status_id = (select apx_status_id
                                    from "APX$STATUS"
                                    where apx_status = 'REGISTERED'
                                    and apx_status_ctx_id = (select apx_context_id
                                                             from "APX$CTX"
                                                             where apx_context = 'USER'))
       where apx_user_id = l_userid;
   end if;
    commit;
exception when others then
    apex_util.set_session_state('P0_USER_REG_STATUS', '-1');
end;

 


-- https://mathijsbruggink.com/2013/10/24/sending-mail-from-an-11g-oracle-database-utl_smtp/
-- If you set it up not for public but for dedicated users.
-- M Bruggink
-- Enabling  Mail functionality in Oracle
-- 20131024

connect / as sysdba;

-- @?/rdbms/admin/utlmail.sql
-- @?/rdbms/admin/prvtmail.plb


grant execute on utl_mail to public;

alter system set smtp_out_server = 'mail..de:25' scope=both;

BEGIN
   DBMS_NETWORK_ACL_ADMIN.DROP_ACL(
      acl => 'smtp_access.xml');
END;
/

--Create an access control list:
BEGIN
   DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (
    acl          => 'smtp_access.xml',
    description  => 'Permissions to access e-mail server.',
    principal    => 'SYS',
    is_grant     => TRUE,
    privilege    => 'connect');
   COMMIT;
 END;
/

-- Assign the list to the smtp ( mail server ):
-- Note Default port is 25!

BEGIN
   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'smtp_access.xml',
    host         => 'mail..de',
    lower_port   => 25,
    upper_port   => 25
    );
   COMMIT;
 END;
/
BEGIN
   DBMS_NETWORK_ACL_ADMIN.add_privilege (
    acl          => 'smtp_access.xml',
    principal    => 'SYSTEM',
    is_grant     => TRUE,
    privilege    => 'connect');
   COMMIT;
 END;
/

BEGIN
   DBMS_NETWORK_ACL_ADMIN.add_privilege (
    acl          => 'smtp_access.xml',
    principal    => 'INTERN',
    is_grant     => TRUE,
    privilege    => 'connect');
   COMMIT;
 END;
/

BEGIN
   DBMS_NETWORK_ACL_ADMIN.add_privilege (
    acl          => 'smtp_access.xml',
    principal    => 'RAS',
    is_grant     => TRUE,
    privilege    => 'connect');
   COMMIT;
 END;
/
-- check the setup
COLUMN host FORMAT A30
COLUMN acl FORMAT A30

SELECT host, lower_port, upper_port, acl
FROM   dba_network_acls;

COLUMN acl FORMAT A30
COLUMN principal FORMAT A30
set lines 200

SELECT acl,
       principal,
       privilege,
       is_grant,
       TO_CHAR(start_date, 'DD-MON-YYYY') AS start_date,
       TO_CHAR(end_date, 'DD-MON-YYYY') AS end_date
FROM   dba_network_acl_privileges;
spool off


SELECT acl,
       principal,
       privilege,
       is_grant,
       TO_CHAR(start_date, 'DD-MON-YYYY') AS start_date,
       TO_CHAR(end_date, 'DD-MON-YYYY') AS end_date
FROM   dba_network_acl_privileges;


fa-cog


style="display:none;"

fa-check-circle


t-success  = #USREG_CONFIRM > div.t-Login-header > span { color: green; font-size: 72px; }

P112_USERNAME
P112_USER_EMAIL


declare
    l_protocol varchar2(2000);
    l_host varchar2(4000);
    l_script varchar2(4000);
    
    l_instance_url varchar2(4000);
begin


   l_protocol      := owa_util.get_cgi_env('REQUEST_PROTOCOL');
--   l_host          := owa_util.get_cgi_env('HTTP_HOST');
--    l_script        := owa_util.get_cgi_env('SCRIPT_NAME');
    
--    l_instance_url := l_protocol;
--    l_instance_url := l_instance_url || '://';
--    l_instance_url := l_instance_url || l_host;
--    l_instance_url := l_instance_url || l_script;
--    l_instance_url := l_instance_url || '/';
    
    dbms_output.put_line(l_protocol);
  end;  
/

select  owa_util.get_cgi_env('HTTP_HOST') from dual;



       select apx_domain_id, apx_domain
      --  into :new_apx_user_domain_id, l_domain
        from "APX$DOMAIN"
        where upper(trim(apx_domain)) =
        upper(trim("PARSE_DOMAIN_FROM_EMAIL"(:new_apx_user_email)))
        and apx_domain_status_id = (select apx_status_id
                                    from "APX$STATUS"
                                    where apx_status = 'VALID'
                                    and apx_status_ctx_id = (select apx_context_id
                                                             from "APX$CTX"
                                                             where apx_context = 'DOMAIN'));


alter table APX$DOMAIN modify apx_domain_code varchar2(64);
alter table APX$DOMAIN modify apx_domain_name varchar2(512);

drop index "APX$DOMAIN_UNQ1";
drop index "APX$DOMAIN_UNQ3";

create unique index "APX$DOMAIN_UNQ1"   on "APX$DOMAIN"(upper(trim(apx_domain_name)), app_id);
--create unique index "APX$DOMAIN_UNQ2"   on "APX$DOMAIN"(upper(trim(apx_domain)), app_id);
create unique index "APX$DOMAIN_UNQ3"   on "APX$DOMAIN"(upper(trim(apx_domain_name)), upper(trim(apx_domain)), app_id);

grant insert, update, delete on "APX$DOMAIN" to intern;


insert into "RAS"."APX$DOMAIN" (apx_domain_id, apx_domain, apx_domain_name, apx_domain_code, apx_domain_description)
SELECT DOMAIN_ID,  DOMAIN, DOMAIN_OWNER||' ' ||DOMAIN_CODE, DOMAIN_CODE, DOMAIN_OWNER
FROM "INTERN"."DOMAINEN"
;

commit;

SELECT count(*), upper(trim(DOMAIN_OWNER))
FROM INTERN.DOMAINEN
group by upper(trim(DOMAIN_OWNER))
having count (*) > 1;

drop sequence "APX$DOMAIN_ID_SEQ";
create sequence "APX$DOMAIN_ID_SEQ" start with 80 nocache nocycle;




alter table "DOMAINEN" modify STATUS_ID number default 15;


grant select on domainen to ras;

commit;

create or replace trigger "DOMAINEN_BIUD_TRG" 
before insert or update or delete on "DOMAINEN"
referencing new as new old as old
for each row
begin
  if inserting then
    insert into "RAS"."APX$DOMAIN" (apx_domain_id, apx_domain, apx_domain_name, apx_domain_code, apx_domain_description)
    values (:new.DOMAIN_ID,  :new.DOMAIN, :new.DOMAIN_OWNER||' ' ||:new.DOMAIN_CODE, :new.DOMAIN_CODE, :new.DOMAIN_OWNER);
  elsif updating then
    update "RAS"."APX$DOMAIN"
    set   apx_domain                   =  :new.DOMAIN
          , apx_domain_name         =  :new.DOMAIN_OWNER||' ' ||:new.DOMAIN_CODE
          , apx_domain_code          = :new.DOMAIN_CODE
          , apx_domain_description = :new.DOMAIN_OWNER
    where apx_domain_id = :new.DOMAIN_ID;
  elsif deleting then
        update "RAS"."APX$DOMAIN"
    set   apx_domain_status_id =  5
    where apx_domain_id = :old.DOMAIN_ID;
  end if;
end;
/

select domains_id_seq.nextval from dual;

create or replace trigger "DOMAINEN_BD_TRG" 
before delete on "DOMAINEN"
referencing old as old new as new
for each row
  declare
  pragma autonomous_transaction;
  begin
    -- now soft delete
      "SOFT_DELETE" ('DOMAINEN', :old.domain_id);
  end;
/

create or replace trigger "DOMAINEN_BU_DEL_TRG" 
before update of DELETED on "DOMAINEN"
referencing new as new
for each row
begin
    if (:new.deleted is not null) then
       update "RAS"."APX$DOMAIN"
       set   apx_domain_status_id =  5
       where upper(trim(apx_domain)) = upper(trim(:new.DOMAIN));
  end if;  
end;
/


alter table APX$USER add apx_user_last_login date;
alter table APX$USER add apx_user_token_created date;
alter table APX$USER add apx_user_token_valid_until date;
alter table APX$USER add apx_user_token_ts timestamp(6) with time zone;
alter table APX$USER add apx_user_token varchar2(4000);
alter table APX$USER add apx_app_user_id number;
alter table APX$USER add apex_user_id number;



create or replace procedure "APX_CREATE_USER" (
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
            if (l_userid is null) then -- get a fresh ID from sequence
                select intern.apex_app_user_id_seq.nextval
                into l_userid
                from dual;
            end if;    
            begin
            /* -- double bookkeeping not needed for 
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
   */
            insert into "INTERN"."APEX_APP_USER"  (
                APP_USER_ID,
                APP_USERNAME,
                APP_USER_EMAIL,
                APP_USER_DEFAULT_ROLE_ID,
                APP_USER_CODE,
                APP_USER_AD_LOGIN,
                APP_USER_NOVELL_LOGIN,
                APP_USER_FIRST_NAME,
                APP_USER_LAST_NAME,
                APP_USER_ADRESS,
                APP_USER_PHONE1,
                APP_USER_PHONE2,
                APP_USER_DESCRIPTION,
                APP_USER_STATUS_ID,
                APP_USER_PARENT_USER_ID,
                APP_ID,
                APP_USER_TOKEN,
                APP_USER_TOKEN_LAST_UPDATE,
                APP_USER_DOMAIN_ID,
                APP_USER_MELDER_ID) 
            (select 
              APX_USER_ID,
              APX_USERNAME,
              APX_USER_EMAIL,
              APX_USER_DEFAULT_ROLE_ID,
              APX_USER_CODE,
              APX_USER_AD_LOGIN,
              APX_USER_HOST_LOGIN,
              APX_USER_FIRST_NAME,
              APX_USER_LAST_NAME,
              APX_USER_ADRESS,
              APX_USER_PHONE1,
              APX_USER_PHONE2,
              APX_USER_DESCRIPTION,
              (select  STATUS_ID
               from "INTERN"."APEX_STATUS"
               where status = 'OPEN' 
               and status_scope = 'ACCOUNT'),
              APX_USER_PARENT_USER_ID,
              APP_ID,
              APX_USER_TOKEN,
              APX_USER_TOKEN_CREATED,
              APX_USER_DOMAIN_ID,
             (select melder_id 
              from  "INTERN"."DOMAIN_GRUPPEN" 
              where domain_id = APX_USER_DOMAIN_ID)
            from APEX_USER_REGISTRATION
            where apx_user_token = l_token
            );

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


---------------------------------------------------------------------------------------------------
--1. create package+body in sqlplus (connected as workspace schema)

--------------------------------------------------------------------------------

create or replace package "APEX_CREATE_USER_PKG" 
authid current_user
as

-- create and set job
  procedure "CREATE_USER_JOB" (
      p_result           number
    , p_username         varchar2
    , p_first_name       varchar2
    , p_last_name        varchar2
    , p_web_password     varchar2
    , p_email_address    varchar2
    , p_token            varchar2
    , p_app_id           number
    , p_default_schema   varchar2
  );

procedure "DO_CREATE_USER" (
      p_result           number
    , p_username         varchar2
    , p_first_name       varchar2
    , p_last_name        varchar2
    , p_web_password     varchar2
    , p_email_address    varchar2
    , p_token            varchar2
    , p_app_id           number
    , p_default_schema   varchar2
    );

end "APEX_CREATE_USER_PKG";
/

create or replace package body "APEX_CREATE_USER_PKG" 
as

-- create and set job
procedure "CREATE_USER_JOB" (
    p_result           number
  , p_username         varchar2
  , p_first_name       varchar2
  , p_last_name        varchar2
  , p_web_password     varchar2
  , p_email_address    varchar2
  , p_token            varchar2
  , p_app_id           number
  , p_default_schema   varchar2
)
is
begin
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 1,
        argument_value => p_result 
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 2,
        argument_value => p_username 
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 3,
        argument_value => p_first_name 
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 4,
        argument_value =>  p_last_name
        );        
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 5,
        argument_value => p_web_password 
        );        
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 6,
        argument_value => p_email_address 
        );                        
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 7,
        argument_value => p_token 
        ); 
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 8,
        argument_value => p_app_id 
        ); 
    dbms_scheduler.set_job_argument_value (
        job_name => 'CREATE_USER_JOB',
        argument_position => 9,
        argument_value => p_default_schema 
        ); 

    dbms_scheduler.run_job (
        job_name => 'CREATE_USER_JOB',
        use_current_session => false );

end "CREATE_USER_JOB";

-- create apex user
procedure "DO_CREATE_USER" (
      p_result           number
    , p_username         varchar2
    , p_first_name       varchar2
    , p_last_name        varchar2
    , p_web_password     varchar2
    , p_email_address    varchar2
    , p_token            varchar2
    , p_app_id           number
    , p_default_schema   varchar2
    )
is
    -- Local Variables
    l_username           varchar2(128);
    l_result             varchar2(4000);
    l_result_code        pls_integer;
    l_email_address      varchar2(128);
    l_first_name         varchar2(128);
    l_last_name          varchar2(128);
    l_token              varchar2(4000);
    l_web_password       varchar2(1000);
    l_default_schema     varchar2(1000);
    l_app_id             number;
begin

  -- Setting Locals Defaults
    l_email_address                 := p_email_address;
    l_username                      := nvl(p_username, p_email_address);
    l_first_name                    := p_first_name;
    l_last_name                     := p_last_name;
    l_token                         := p_token;
    l_web_password                  := p_web_password;
    l_default_schema                := nvl(p_default_schema   , 'INTERN');
    l_app_id                        := nvl(p_app_id           , v('APP_ID'));
    l_result                        := nvl(p_result           , 0);

    -- set Apex Environment
    for c1 in (
        select workspace_id
        from apex_applications
        where application_id = l_app_id 
        ) loop
        apex_util.set_security_group_id(
            p_security_group_id => c1.workspace_id
            );
    end loop;
    

    "APX_CREATE_USER" (  p_result           => l_result
                       , p_username         => l_username
                       , p_first_name       => l_first_name
                       , p_last_name        => l_first_name
                       , p_web_password     => l_web_password
                       , p_email_address    => l_email_address
                       , p_token            => l_token
                       , p_app_id           => l_app_id
                       , p_default_schema   => l_default_schema);

end "DO_CREATE_USER";

end "APEX_CREATE_USER_PKG";
/


--- DBMS_SCHEDULER Job to create Users
begin
    dbms_scheduler.create_job (
    job_name => 'CREATE_APEX_USER_JOB',
    job_type => 'STORED_PROCEDURE',
    job_action => 'APEX_CREATE_USER_PKG."DO_CREATE_USER"',
    number_of_arguments => 9,
    enabled => false );
end;
/


/*
3. create application with item P1_USERNAME and button
4. create submit process that calls
jobtest.run_reset_pwd_job(:P1_USERNAME);
*/





HOME	Willkommen auf unserer Website				"<p>
 Hier finden Sie alles, um sich auf unserer Webseite zurechtzufinden...
</p>"
LOCK	Konto ist gesperrt!				"<p>Ihr Konto wurde gesperrt<br />
  Bitte setzen Sie Ihr Kennwort auf unserer
  <a href="##APX_APP_PAGE##">Passwort Reset</a> Seite zurück, <br />
 um Ihr Konto zu entsperren.
</p>"
UNLOCK	Konto wurde entsperrt!				"<p>Ihr Konto wurde erfolgreich entsperrt.<br />
  Bitte setzen Sie ein neues Kennwort auf unserer
  <a href="##APX_APP_PAGE##">Passwort Reset</a> Seite.
</p>"
REGISTER	Registrierungsbestätigung				"<p>
  Bitte bestätigen Sie Ihre Registrierung auf unserer <a href="##APX_APP_PAGE##">Registrierungsseite</a> unseres Portals.
</p>"
REREGISTER	Registrierungsbestätigung				"<p>
  Vielen Dank, das sie sich erneut registriert haben.<br />
  Bitte bestätigen Sie Ihre Registrierung auf unserer <a href="##APX_APP_PAGE##">Registrierungsbestätigungs</a> Seite.
</p>"
DEREGISTER	Deregistrierungsbestätigung				"<p>
  Hiermit bestätigen wir Ihre Deregistrierung aus unserem System.
</p>"
RESET_PW	Informationen zu Kennwortrücksetzung				"<p>
 Sie erhalten diese Mail als Antwort auf Ihren Paswort Rücksetzungsanfrage.<br />
  Bitte setzen Sie sich ein neues Passwort auf unserer <a href="##APX_APP_PAGE##">Passwort Reset</a> Seite.
</p>"
RESET_REG_ATTEMPTS	Registrierungsbestätigung				"<p>
  Ihr Konto wurde zur erneuten Registrierung freigegeben.<br />
  Bitte bestätigen Sie Ihre Registrierung auf unserer <a href="##APX_APP_PAGE##">Registrierungsbestätigungs</a> Seite.
</p>"
REG_ATTEMPTS_EXCEEDED	maximale Registrierungsversuche überschritten				"<p>
  Ihre Registrierung wurde gesperrt, da Sie die maximalen Registrierungsversuche überschritten haben.<br />
  Bitte kontaktieren Sie unsere <a href="##APX_APP_PAGE##">Hilfe</a> Seite für mehr Informationen.
</p>"




select "PARSE_DOMAIN_FROM_EMAIL"(:new_apx_user_email) from dual;


select * from  USER_ROLE_PRIVS;

create table logt (id number, msg varchar2(4000));


create or replace package jobtest as

procedure run_reset_pwd_job (
p_username in varchar2 );

procedure do_reset_pwd (
p_username in varchar2 );

end jobtest;
/
create or replace package body jobtest as

procedure run_reset_pwd_job (
p_username in varchar2 )
is
begin
dbms_scheduler.set_job_argument_value (
job_name => 'RESET_PWD_JOB',
argument_position => 1,
argument_value => p_username );
dbms_scheduler.run_job (
job_name => 'RESET_PWD_JOB',
use_current_session => false );
end run_reset_pwd_job;

procedure do_reset_pwd (
p_username in varchar2 )
is
begin
apex_util.set_security_group_id(apex_util.find_security_group_id('APEX_TEST'));
apex_util.reset_pw (
p_user => p_username,
p_msg => p_username||', your password in workspace APEX_TEST has been reset.' );
       insert into LOGT values (1, 'Before Creating Apex User');
       commit;
end do_reset_pwd;

end jobtest;
/




begin
dbms_scheduler.create_job (
job_name => 'RESET_PWD_JOB',
job_type => 'STORED_PROCEDURE',
job_action => 'JOBTEST.DO_RESET_PWD',
number_of_arguments => 1,
enabled => false );
end;
/

begin
dbms_scheduler.drop_job (
job_name => 'RESET_PWD_JOB' );
end;
/


--------------------------------------------------------------------------------
--- DBMS_SCHEDULER Job to create Users
begin
    dbms_scheduler.create_job (
    job_name => 'CREATE_APEX_USER_JOB',
    job_type => 'STORED_PROCEDURE',
    job_action => 'APEX_CREATE_USER_PKG."DO_CREATE_USER"',
    number_of_arguments => 9,
    enabled => false );
end;
/

create or replace package "APEX_CREATE_USER_PKG" 
authid current_user
as

-- create and set job
  procedure "CREATE_USER_JOB" (
      p_result           number
    , p_username         varchar2
    , p_first_name       varchar2
    , p_last_name        varchar2
    , p_web_password     varchar2
    , p_email_address    varchar2
    , p_token            varchar2
    , p_app_id           number
    , p_default_schema   varchar2
  );

procedure "DO_CREATE_USER" (
      p_result           number
    , p_username         varchar2
    , p_first_name       varchar2
    , p_last_name        varchar2
    , p_web_password     varchar2
    , p_email_address    varchar2
    , p_token            varchar2
    , p_app_id           number
    , p_default_schema   varchar2
    );

end "APEX_CREATE_USER_PKG";
/

create or replace package body "APEX_CREATE_USER_PKG" 
as

-- create and set job
procedure "CREATE_USER_JOB" (
    p_result           number
  , p_username         varchar2
  , p_first_name       varchar2
  , p_last_name        varchar2
  , p_web_password     varchar2
  , p_email_address    varchar2
  , p_token            varchar2
  , p_app_id           number
  , p_default_schema   varchar2
)
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

end "CREATE_USER_JOB";

-- create apex user
procedure "DO_CREATE_USER" (
      p_result           number
    , p_username         varchar2
    , p_first_name       varchar2
    , p_last_name        varchar2
    , p_web_password     varchar2
    , p_email_address    varchar2
    , p_token            varchar2
    , p_app_id           number
    , p_default_schema   varchar2
    )
is
    -- Local Variables
    l_username           varchar2(128);
    l_result             varchar2(4000);
    l_result_code        pls_integer;
    l_email_address      varchar2(128);
    l_first_name         varchar2(128);
    l_last_name          varchar2(128);
    l_token              varchar2(4000);
    l_web_password       varchar2(1000);
    l_default_schema     varchar2(1000);
    l_app_id             number;
begin

  -- Setting Locals Defaults
    l_email_address                 := p_email_address;
    l_username                      := nvl(p_username, p_email_address);
    l_first_name                    := p_first_name;
    l_last_name                     := p_last_name;
    l_token                         := p_token;
    l_web_password                  := p_web_password;
    l_default_schema                := nvl(p_default_schema   , 'INTERN');
    l_app_id                        := nvl(p_app_id           , v('APP_ID'));
    l_result                        := nvl(p_result           , 0);

    -- set Apex Environment
    for c1 in (
        select workspace_id
        from apex_applications
        where application_id = l_app_id 
        ) loop
        apex_util.set_security_group_id(
            p_security_group_id => c1.workspace_id
            );
    end loop;
    

    "APX_CREATE_USER" (  p_result           => l_result
                       , p_username         => l_username
                       , p_first_name       => l_first_name
                       , p_last_name        => l_first_name
                       , p_web_password     => l_web_password
                       , p_email_address    => l_email_address
                       , p_token            => l_token
                       , p_app_id           => l_app_id
                       , p_default_schema   => l_default_schema);

end "DO_CREATE_USER";

end "APEX_CREATE_USER_PKG";
/


--- DBMS_SCHEDULER Job to create Users
begin
    dbms_scheduler.create_job (
    job_name => 'CREATE_APEX_USER_JOB',
    job_type => 'STORED_PROCEDURE',
    job_action => 'APEX_CREATE_USER_PKG."DO_CREATE_USER"',
    number_of_arguments => 9,
    enabled => false );
end;
/


--------------------------------------------------------------------------------------
create or replace package body "APEX_CREATE_USER_PKG" 
as

-- create and set job
procedure "CREATE_USER_JOB" (
    p_result           number
  , p_username         varchar2
  , p_first_name       varchar2
  , p_last_name        varchar2
  , p_web_password     varchar2
  , p_email_address    varchar2
  , p_token            varchar2
  , p_app_id           number
  , p_default_schema   varchar2
)
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

end "CREATE_USER_JOB";

-- create apex user
procedure "DO_CREATE_USER" (
      p_result           number
    , p_username         varchar2
    , p_first_name       varchar2
    , p_last_name        varchar2
    , p_web_password     varchar2
    , p_email_address    varchar2
    , p_token            varchar2
    , p_app_id           number
    , p_default_schema   varchar2
    )
is
    -- Local Variables
    l_username           varchar2(128);
    l_result             varchar2(4000);
    l_result_code        pls_integer;
    l_email_address      varchar2(128);
    l_first_name         varchar2(128);
    l_last_name          varchar2(128);
    l_token              varchar2(4000);
    l_web_password       varchar2(1000);
    l_default_schema     varchar2(1000);
    l_app_id             number;
begin

  -- Setting Locals Defaults
    l_email_address                 := p_email_address;
    l_username                      := nvl(p_username, p_email_address);
    l_first_name                    := p_first_name;
    l_last_name                     := p_last_name;
    l_token                         := p_token;
    l_web_password                  := p_web_password;
    l_default_schema                := nvl(p_default_schema   , 'RAS_INTERN');
    l_app_id                        := nvl(p_app_id           , 100002);
    l_result                        := nvl(p_result           , 0);

    -- set Apex Environment
    for c1 in (
        select workspace_id
        from apex_applications
        where application_id = l_app_id 
        ) loop
        apex_util.set_security_group_id(
            p_security_group_id => c1.workspace_id
            );
    end loop;
    

    "APX_CREATE_USER" (  p_result           => l_result
                       , p_username         => l_username
                       , p_first_name       => l_first_name
                       , p_last_name        => l_first_name
                       , p_web_password     => l_web_password
                       , p_email_address    => l_email_address
                       , p_token            => l_token
                       , p_app_id           => l_app_id
                       , p_default_schema   => l_default_schema);

end "DO_CREATE_USER";

end "APEX_CREATE_USER_PKG";


--------------------------------------------------------------------------------------------------------
--- DBMS_SCHEDULER Job to create Users
begin
    dbms_scheduler.create_job (
    job_name => 'EDIT_APEX_USER_JOB',
    job_type => 'STORED_PROCEDURE',
    job_action => '"APEX_EDIT_USER_PKG"."DO_DROP_USER"',
    number_of_arguments => 4,
    enabled => false );
end;
/

create or replace package "APEX_EDIT_USER_PKG" 
authid current_user
as

-- create and set job
procedure "DROP_USER_JOB" (
    p_result           number
  , p_username         varchar2
  , p_user_id          number
  , p_app_id           number
);

procedure "DO_DROP_USER" (
      p_result           number
    , p_username         varchar2
    , p_user_id          number    
    , p_app_id           number
);

end "APEX_EDIT_USER_PKG";
/



create or replace package body "APEX_EDIT_USER_PKG" 
as
-- create and set job
procedure "DROP_USER_JOB" (
    p_result           number
  , p_username         varchar2
  , p_user_id          number
  , p_app_id           number
)
is
begin
    dbms_scheduler.set_job_argument_value (
        job_name => 'EDIT_APEX_USER_JOB',
        argument_position => 1,
        argument_value => p_result 
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'EDIT_APEX_USER_JOB',
        argument_position => 2,
        argument_value => p_username 
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'EDIT_APEX_USER_JOB',
        argument_position => 3,
        argument_value => p_user_id 
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'EDIT_APEX_USER_JOB',
        argument_position => 4,
        argument_value =>  p_app_id
        );        
    -- now run the job
    dbms_scheduler.run_job (
        job_name => 'EDIT_APEX_USER_JOB',
        use_current_session => false );

end "DROP_USER_JOB";

-- create apex user
procedure "DO_DROP_USER" (
      p_result           number
    , p_username         varchar2
    , p_user_id          number    
    , p_app_id           number
    )
is
    -- Local Variables
    l_result             varchar2(4000);
    l_result_code        pls_integer;
    l_username           varchar2(128);
    l_user_id            number;
    l_app_id             number;
begin

  -- Setting Locals Defaults
    l_username           := p_username;
    l_user_id            := p_user_id;
    l_app_id             := nvl(p_app_id, 100002);
    l_result             := nvl(p_result, 0);

    -- set Apex Environment
    for c1 in (
        select workspace_id
        from apex_applications
        where application_id = l_app_id 
        ) loop
        apex_util.set_security_group_id(
            p_security_group_id => c1.workspace_id
            );
    end loop;
    
    begin
      if (l_user_id is not null) then
          "APEX_UTIL"."REMOVE_USER"(p_user_id => l_user_id);
      elsif (l_username is not null) then
          "APEX_UTIL"."REMOVE_USER"(p_user_name => l_username);
      end if;    
    end;


end "DO_DROP_USER";

end "APEX_EDIT_USER_PKG";
/

-- create job in primary parsing schema
begin
    dbms_scheduler.create_job (
    job_name => 'EDIT_APEX_USER_JOB',
    job_type => 'STORED_PROCEDURE',
    job_action => '"RAS"."APEX_EDIT_USER_PKG"."DO_DROP_USER"',
    number_of_arguments => 4,
    enabled => false );
end;
/



---------------------------------------------------------------------------------------

    if (l_topic = 'REGISTER') then
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
    elsif (l_topic = 'REREGISTER') then
        update "APEX_USER_REGISTRATION"
        set   APX_USER_TOKEN = APX_GET_TOKEN(l_username||l_app_id)
              , APX_USER_TOKEN_CREATED =sysdate
        where upper(trim(apx_username)) = upper(trim(l_username))      
        returning apx_user_id, apx_username, apx_user_token
        into l_userid, l_username, l_token;    
    else
       l_result := 1;
    end if; 
	
	

#WORKSPACE_IMAGES#js/_FOOTER.min.js?v=20180118.#APEX_VERSION#
#WORKSPACE_IMAGES#js/validate/jquery.validate.min.js?v=20180129.#APEX_VERSION#
#WORKSPACE_IMAGES#js/validate/messages_de.min.js?v=20180129.#APEX_VERSION#

#WORKSPACE_IMAGES#css/validate/screen.min.css?v=20180129.#APEX_VERSION#
#WORKSPACE_IMAGES#css/validateForm.min.css?v=20180129.#APEX_VERSION#


ALTER TABLE "RAS"."APX$USER_REG" DROP CONSTRAINT "APX$USREG_APP_USER_ID_FK";
ALTER TABLE "RAS"."APX$USER_REG" ADD CONSTRAINT "APX$USREG_APP_USER_ID_FK" FOREIGN KEY ("APX_APP_USER_ID")
REFERENCES "RAS_INTERN"."_APEX_APP_USER" ("APP_USER_ID") ON DELETE CASCADE ENABLE;



create or replace procedure "RAS_SOFT_DELETE" (
p_table in varchar2,
p_id number,
p_msg in varchar2 :=' können nicht gelöscht werden!',
p_new_status varchar2 := 'LOCKED'
) is
pragma autonomous_transaction;
l_status_id pls_integer;
l_msg varchar2(1000);
l_result number;
l_username varchar2(128);
begin
    select app_status_id into l_status_id
    from "APEX_APP_STATUS"
    where app_status = upper(nvl(p_new_status, 'LOCKED'));
    if (upper(p_table) = 'APEX_APP_USER') then
        l_msg := 'Benutzer'||p_msg;
        commit;
        update  "APEX_APP_USER"
        set deleted  = sysdate,
              deleted_by  = nvl(v('APP_USER'), user),
              app_user_status_id = l_status_id
        where APP_USER_ID = p_id;
        -- get the username
        for u in (select upper(trim(app_username)) username
                     from  "APEX_APP_USER"
                    where  APP_USER_ID = p_id) loop
            l_username := u.username;
        end loop;    
        -- remove user from registration table
        delete from "RAS"."APX$USER_REG"
        where upper(trim(apx_username)) =  nvl(l_username, '');
        -- remove user from apex
         "RAS"."APEX_EDIT_USER_PKG"."DROP_USER_JOB"(  
             p_result           => l_result
           , p_username     => l_username
           , p_user_id        => null
           , p_app_id         => 100002
        );
    elsif  (upper(p_table) = 'RAS_DOMAINEN') then
        l_msg := 'Domainen'||p_msg;
        commit;
        update  "APEX_APP_USER"
        set deleted  = sysdate,
              deleted_by  = nvl(v('APP_USER'), user),
              app_user_status_id = l_status_id
        where app_user_domain_id  = p_id;
        update "RAS_DOMAINEN"
        set deleted = sysdate,
              deleted_by     = nvl(v('APP_USER'), user)
        where domain_id = p_id;
    elsif (upper(p_table) = 'AMF_VORGANG') then
        l_msg := 'RAS Vorgänge'||p_msg;
        commit;
        UPDATE "AMF_VORGANG"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user),
              AMF_MELDUNG_STATUS = l_status_id
        where ID_VORGANG = p_id;    
    elsif (upper(p_table) = 'DOKUMENTE') then
        l_msg := 'RAS Vorgangsdokumente'||p_msg;
        commit;
        UPDATE "DOKUMENTE"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user)
        where ID_VORGANG = p_id;    
    elsif (upper(p_table) = 'BOB_LAENDER_ROW_DOKUMENTE') then
        l_msg := 'RAS Vorgangsdokumente'||p_msg;
        commit;
        UPDATE "BOB_LAENDER_ROW_DOKUMENTE"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user)
        where ID_VORGANG = p_id;   
    elsif (upper(p_table) = 'BOB_LAENDER_ROW_ERGAENZUNGEN') then
        l_msg := 'RAS Vorgangsergänzungen'||p_msg;
        commit;
        UPDATE "BOB_LAENDER_ROW_ERGAENZUNGEN"
        set DELETED = sysdate,
              DELETED_BY = nvl(v('APP_USER'), user)
        where ID_VORGANG = p_id;    
    end if;        
    commit;
    RAISE_APPLICATION_ERROR (-20002, l_msg, TRUE);
end;

declare
l_result      varchar2(4000);
l_first_name  varchar2(1000);
l_last_name   varchar2(1000);
begin

apex_util.set_session_state('P0_USER_REG_STATUS', null);

    for u in (select apx_user_first_name, apx_user_last_name
              from "APEX_USER_REGISTRATION"
              where apx_user_token = v('P112_TOKEN')) loop
              l_first_name := u.apx_user_first_name;
              l_last_name  := u.apx_user_last_name;
    end loop;
/*    
raise_application_error(-20001, 'Email '|| v('P112_EMAIL') || ' First Name: '||
                        l_first_name || ' Last Name '||l_last_name|| ' Password: ' ||
                        :P112_PASSWORD_NEW_VERIFY|| 'Token: '||v('P112_TOKEN')||' appId '||:APP_ID);
*/

  "APEX_CREATE_USER_PKG"."CREATE_USER_JOB"(  
                      p_result           => l_result
                    , p_username         => v('P112_EMAIL')
                    , p_first_name       => l_first_name
                    , p_last_name        => l_last_name
                    , p_web_password     => v('P112_PASSWORD_NEW_VERIFY')
                    , p_email_address    => v('P112_EMAIL')
                    , p_token            => v('P112_TOKEN')
                    , p_app_id           => 100002
                    , p_default_schema   => 'RAS_INTERN'
  );
 
  
/*
    APX_CREATE_USER(  p_result           => l_result
                    , p_username         => v('P112_EMAIL')
                    , p_first_name       => l_first_name
                    , p_last_name        => l_last_name
                    , p_web_password     => v('P112_PASSWORD_NEW_VERIFY')
                    , p_email_address    => v('P112_EMAIL')
                    , p_token            => v('P112_TOKEN')
                    , p_app_id           => v('APP_ID')
                    , p_default_schema   => 'RAS_INTERN');
*/


apex_util.set_session_state('P0_USER_REG_STATUS', l_result);

end;
/


create or replace procedure "APX_CREATE_USER" (
      p_username                    in       varchar2
    , p_result                      in out   varchar2
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
authid current_user
is
    -- Local Variables
    l_username                      varchar2(128);
    l_result                        varchar2(4000);
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
    l_user_count                  pls_integer := 0;

    CREATE_USER_ERROR               exception;

    -- Constants
    C_TOPIC                         constant          varchar2(1000)  := 'CREATE';
    C_PASSWORD_FORMAT               constant          varchar2(1000)  := 'CLEAR_TEXT';
    C_ACCOUNT_LOCKED                constant          varchar2(10)    := 'N';
    C_ACCOUNT_EXPIRED               constant          date    := TRUNC(SYSDATE);
    C_CHANGE_PASSWORD_ON_FIRST_USE  constant          varchar2(10)    := 'N';
    C_APP_ID                        constant          pls_integer     := 100000;
    C_TARGET_APP                constant          pls_integer     := 100002;
    C_RESULT                        constant          pls_integer     := null;
    C_DEBUG                         constant          boolean         := false;
    C_SEND_MAIL                     constant          boolean         := false;
    C_CREATE_APEX_USER              constant          boolean         := true;
    C_DEVELOPER_PRIVS               constant          varchar2(1000)  := null;
    C_ALLOW_ACCESS_TO_SCHEMAS       constant          varchar2(1000)  := null;

begin

   -- Setting Locals Defaults
    l_email_address                 := p_email_address;
    l_username                      := nvl(p_username, p_email_address);
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

  
    -- check if a token was passed in
    if (l_token is not null) then
        
        if ("IS_VALID_USER_TOKEN"(l_username, l_token)) then
            
                -- see if user exists
            for u in (select 1 as cnt, app_user_id, upper(trim(app_username)) as username
                          from "RAS_INTERN"."_APEX_APP_USER"
                           where upper(trim(app_username)) = upper(trim(l_username))) loop
                            l_user_count := u.cnt;
                            l_userid := u.app_user_id;
                            l_username := u.username;
            end loop;      
                
      --raise_application_error(-20001, 'User Count: ' ||l_user_count || ' updating: '|| l_username);
    
            if (l_user_count = 0) then -- no user yet, so...
                
                begin                
                    -- get a fresh ID from sequence
                    if (l_userid is null) then 
                        select "RAS_INTERN"."_APEX_APP_USER_ID_SEQ".nextval
                        into l_userid
                        from dual;
                    end if;      
                    
                      -- create local app user first
                      insert into "RAS_INTERN"."_APEX_APP_USER"  (
                          APP_USER_ID,
                          APP_USERNAME,
                          APP_USER_EMAIL,
                          APP_USER_DEFAULT_ROLE_ID,
                          APP_USER_CODE,
                          APP_USER_AD_LOGIN,
                          APP_USER_NOVELL_LOGIN,
                          APP_USER_FIRST_NAME,
                          APP_USER_LAST_NAME,
                          APP_USER_ADRESS,
                          APP_USER_PHONE1,
                          APP_USER_PHONE2,
                          APP_USER_DESCRIPTION,
                          APP_USER_STATUS_ID,
                          APP_USER_PARENT_USER_ID,
                          APP_ID,
                          APP_USER_TOKEN,
                          APP_USER_TOKEN_LAST_UPDATE,
                          APP_USER_DOMAIN_ID,
                          APP_USER_MELDER_ID) 
                      (select 
                        l_userid,
                        APX_USERNAME,
                        APX_USER_EMAIL,
                        APX_USER_DEFAULT_ROLE_ID,
                        APX_USER_CODE,
                        APX_USER_AD_LOGIN,
                        APX_USER_HOST_LOGIN,
                        APX_USER_FIRST_NAME,
                        APX_USER_LAST_NAME,
                        APX_USER_ADRESS,
                        APX_USER_PHONE1,
                        APX_USER_PHONE2,
                        APX_USER_DESCRIPTION,
                        (select  STATUS_ID
                         from "RAS_INTERN"."_APEX_STATUS"
                         where status = 'OPEN' 
                         and status_scope = 'ACCOUNT'),
                        APX_USER_PARENT_USER_ID,
                        C_TARGET_APP,
                        APX_USER_TOKEN,
                        APX_USER_TOKEN_CREATED,
                        APX_USER_DOMAIN_ID,
                       (select ras_melder_id 
                        from  "RAS_INTERN"."RAS_DOMAIN_GRUPPEN" 
                        where ras_domain_id = APX_USER_DOMAIN_ID)
                      from APEX_USER_REGISTRATION
                      where apx_user_token = l_token
                      );
                      
                      commit;
                      l_result_code := 0;
                      
                  exception when no_data_found then
                      l_result_code := 2;
                      l_result      := 'No User Data for Token found.';
                      raise create_user_error;
                 end;
               
               elsif (l_user_count = 1) then   -- user exists
                           -- update existing user
                          update "RAS_INTERN"."_APEX_APP_USER"
                          set (app_user_status_id, app_user_token, app_user_token_last_update, deleted, deleted_by, app_user_domain_id, app_user_melder_id) =
                           (select
                                (select STATUS_ID
                                 from "RAS_INTERN"."_APEX_STATUS"
                                 where status = 'OPEN' 
                                 and status_scope = 'ACCOUNT'),
                                 apx_user_token,
                                 apx_user_token_created,
                                 null, null,
                                 apx_user_domain_id,
                                 (select ras_melder_id 
                                  from  "RAS_INTERN"."RAS_DOMAIN_GRUPPEN" 
                                  where ras_domain_id = APX_USER_DOMAIN_ID)
                            from APEX_USER_REGISTRATION
                            where apx_user_token = l_token)
                          where upper(trim(app_username)) = upper(trim(l_username));
                          
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
                          
                          commit;
                          l_result_code := 0;
                          l_result          := 'Updated User '||l_username;
                          
                else
                    l_result_code := l_user_count;
                    l_result          := 'User Create Error';
                    raise  create_user_error;                
               end if;
    
        end if;
            
          if l_create_apex_user then
      
              -- set Apex Environment
              for c1 in (
                  select workspace_id
                  from apex_applications
                  where application_id = l_app_id 
                  ) loop
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
      
          l_result_code := 0;
      
          end if;
      
          commit;
          p_result  := l_result || ' User Created successfully';
      
    else -- token empty
        l_result_code := 3;
        l_result := 'No Token provided';
        raise create_user_error;
    end if;

    -- assemble output
    l_result  := l_result_code ||' '||l_result;
    p_result  := l_result;


exception when create_user_error then
    l_result  := l_result_code ||' '||l_result;
    p_result  := l_result;
when others then
rollback;
raise;
end "APX_CREATE_USER";
/


begin
   if is_valid_apex_user_token('MTE2OTk0OTI0MWJmYXJtLmRlNjk5NzA3MDYz', 'TRIVADIS@.DE') then
      dbms_output.put_line('Valid');
   else  
      dbms_output.put_line('Invalid');
   end if;
 end;
 /
 
 
 
 begin
 if (is_valid_user_token( 'TRIVADIS@.DE', 'MTE2OTk0OTI0MWJmYXJtLmRlNjk5NzA3MDYz')) then
      dbms_output.put_line('Valid');
   else  
      dbms_output.put_line('Invalid');
   end if;
 end;
 /
 
 begin
    l_usr := 'TRIVADIS@.DE';
    l_token := 'MTE2OTk0OTI0MWJmYXJtLmRlNjk5NzA3MDYz';
        --raise_application_error(-20001, 'In Proc: '||l_usr||','||l_token);
 if (is_valid_user_token(l_usr, l_tkn) then
       dbms_output.put_line('Valid');
--        htp.init;
--        owa_util.redirect_url('f?p=&APP_ID.:USRREG_CONFIRM:0:'||v('REQUEST')||':::NEWUSER,TOKEN:'||l_usr||','||l_token);
--        apex_application.stop_apex_engine;
    else
--        htp.init;
--        owa_util.redirect_url('f?p=&APP_ID.:ERRPAGE:0:TOKEN_INVALID:::P501_USR:'||l_usr);
--        apex_application.stop_apex_engine;
      dbms_output.put_line('Invalid');
    end if;
end;    
 


  ALTER TABLE "RAS"."APX$USER_REG" DROP CONSTRAINT "APX$USREG_APP_USER_ID_FK";
  ALTER TABLE "RAS"."APX$USER_REG" ADD CONSTRAINT "APX$USREG_APP_USER_ID_FK" FOREIGN KEY ("APX_APP_USER_ID")
	  REFERENCES "RAS_INTERN"."APEX_APP_USER" ("APP_USER_ID") ON DELETE CASCADE ENABLE;
    
    
create synonym RAS_INTERN.APEX_USER_REGISTRATION for  "RAS"."APX$USER_REG";    
grant select, update, delete on "RAS"."APX$USER_REG" to RAS_INTERN;


select * from wwv_flow_users;

--- DBMS_SCHEDULER Job to create Users
begin
    dbms_scheduler.create_job (
    job_name => 'EDIT_APEX_USER_JOB',
    job_type => 'STORED_PROCEDURE',
    job_action => '"APEX_EDIT_USER_PKG"."DO_DROP_USER"',
    number_of_arguments => 4,
    enabled => false );
end;
/


create or replace package "APEX_EDIT_USER_PKG" 
authid current_user
as

-- create and set job
procedure "DROP_USER_JOB" (
    p_result           number
  , p_username         varchar2
  , p_user_id          number
  , p_app_id           number
);

procedure "DO_DROP_USER" (
      p_result           number
    , p_username         varchar2
    , p_user_id          number    
    , p_app_id           number
);

end "APEX_EDIT_USER_PKG";
/


create or replace package body "APEX_EDIT_USER_PKG" 
as
-- create and set job
procedure "DROP_USER_JOB" (
    p_result             number
  , p_username       varchar2
  , p_user_id          number
  , p_app_id           number
)
is
begin
    dbms_scheduler.set_job_argument_value (
        job_name => 'EDIT_APEX_USER_JOB',
        argument_position => 1,
        argument_value => p_result 
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'EDIT_APEX_USER_JOB',
        argument_position => 2,
        argument_value => p_username 
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'EDIT_APEX_USER_JOB',
        argument_position => 3,
        argument_value => p_user_id 
        );
    dbms_scheduler.set_job_argument_value (
        job_name => 'EDIT_APEX_USER_JOB',
        argument_position => 4,
        argument_value =>  p_app_id
        );        
    -- now run the job
    dbms_scheduler.run_job (
        job_name => 'EDIT_APEX_USER_JOB',
        use_current_session => false );

end "DROP_USER_JOB";

-- create apex user
procedure "DO_DROP_USER" (
      p_result           number
    , p_username         varchar2
    , p_user_id          number    
    , p_app_id           number
    )
is
    -- Local Variables
    l_result             varchar2(4000);
    l_result_code        pls_integer;
    l_username           varchar2(128);
    l_user_id            number;
    l_app_id             number;
begin

  -- Setting Locals Defaults
    l_username           := p_username;
    l_user_id            := p_user_id;
    l_app_id             := nvl(p_app_id, 100002);
    l_result             := nvl(p_result, 0);

    -- set Apex Environment
    for c1 in (
        select workspace_id
        from apex_applications
        where application_id = l_app_id 
        ) loop
        apex_util.set_security_group_id(
            p_security_group_id => c1.workspace_id
            );
    end loop;
    
    begin
      if (l_user_id is not null) then
          "APEX_UTIL"."REMOVE_USER"(p_user_id => l_user_id);
      elsif (l_username is not null) then
          "APEX_UTIL"."REMOVE_USER"(p_user_name => l_username);
      end if;    
    end;


end "DO_DROP_USER";

end "APEX_EDIT_USER_PKG";
/


grant execute on APEX_EDIT_USER_PKG to ras_intern;
--grant execute on EDIT_APEX_USER_JOB to ras_intern;

declare
l_user_id number := null;
l_app_id number := 100002;
l_username varchar2(128) := 'TRIVADIS@BFARM.DE';
begin
    for c1 in (
        select workspace_id
        from apex_applications
        where application_id = l_app_id 
        ) loop
        apex_util.set_security_group_id(
            p_security_group_id => c1.workspace_id
            );
    end loop;
    
    begin
        if (l_user_id is not null) then
            "APEX_UTIL"."REMOVE_USER"(p_user_id => l_user_id);
        elsif (l_username is not null) then
            "APEX_UTIL"."REMOVE_USER"(p_user_name => l_username);
        end if;
    end;
end;
/

        select workspace_id
        from apex_applications
        where application_id = 100002; 


declare
l_result number;
l_user_id number := null;
l_app_id number := 100002;
l_username varchar2(128) := 'TRIVADIS@BFARM.DE';
begin
         "APEX_EDIT_USER_PKG"."DROP_USER_JOB"(  
             p_result           => l_result
           , p_username     => l_username
           , p_user_id        => l_user_id
           , p_app_id         => 100002
        );
end;
/

insert into APX$MAIL_CONTENT 
(  APX_MAIL_TOPIC,
  APX_MAIL_SUBJECT,
  APX_MAIL_BODY,
  APX_MAIL_BODY_HTML,
  APX_MAIL_HEAD,
  APX_MAIL_BODY_CONTENT,
  APX_MAIL_TAIL,
  APX_MAIL_TO,
  APX_MAIL_TO_USER,
  APX_MAIL_GREETING,
  APX_IMG_URL1,
  APX_IMG_URL1_ALT,
  APX_TEXT1,
  APX_TEXT2,
  APX_URL_PARAMS,
  APX_URL_VALUES,
  APX_URL_QUERY,
  APX_PARENT_MAIL_ID,
  APX_APP_PAGE,
  APX_APP_REQUEST,
  APX_MAIL_SEC_LEVEL,
  APX_MAIL_STATUS_ID,
  APP_ID)
(SELECT 
  APX_MAIL_TOPIC,
  APX_MAIL_SUBJECT,
  APX_MAIL_BODY,
  APX_MAIL_BODY_HTML,
  APX_MAIL_HEAD,
  APX_MAIL_BODY_CONTENT,
  APX_MAIL_TAIL,
  APX_MAIL_TO,
  APX_MAIL_TO_USER,
  APX_MAIL_GREETING,
  APX_IMG_URL1,
  APX_IMG_URL1_ALT,
  APX_TEXT1,
  APX_TEXT2,
  APX_URL_PARAMS,
  APX_URL_VALUES,
  APX_URL_QUERY,
  APX_PARENT_MAIL_ID,
  APX_APP_PAGE,
  APX_APP_REQUEST,
  APX_MAIL_SEC_LEVEL,
  APX_MAIL_STATUS_ID,
  100002
FROM APX$MAIL_CONTENT
WHERE app_id != 0);


select "APX$MAIL_CONTENT_ID_SEQ".NEXTVAL from dual;


select 1 as cnt, app_user_id, upper(trim(app_username)) as username
                         from "RAS_INTERN"."APEX_APP_USER"
                         where upper(trim(app_username)) = :l_username;


select *  from user_objects where status != 'VALID';

select 'alter synonym RAS.' || object_name || ' compile ;'  from user_objects where status != 'VALID';

alter synonym RAS.APEX_USER_ALL_REG compile ;
alter synonym RAS.APEX_APP_USERS compile ;
alter synonym RAS.APEX_APP_ROLES compile ;
alter synonym RAS.APEX_USER_PRIVILEGES compile ;
alter synonym RAS.APEX_USER_DOMAINS compile ;


  declare
l_result number;
l_user_id number := null;
l_app_id number := 100002;
l_username varchar2(128) := 'TRIVADIS@BFARM.DE';
begin
         "RAS"."APEX_EDIT_USER_PKG"."DROP_USER_JOB"(  
             p_result           => l_result
           , p_username     => l_username
           , p_user_id        => l_user_id
           , p_app_id         => 100002
        );
end;
/

begin
    dbms_scheduler.create_job (
    job_name => 'EDIT_APEX_USER_JOB',
    job_type => 'STORED_PROCEDURE',
    job_action => '"RAS"."APEX_EDIT_USER_PKG"."DO_DROP_USER"',
    number_of_arguments => 4,
    enabled => false );
end;
/


create or replace procedure "APX_CREATE_USER" (
      p_username                    in       varchar2
    , p_result                      in out   varchar2
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
authid current_user
is
    -- Local Variables
    l_username                      varchar2(128);
    l_result                        varchar2(4000);
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
    C_ACCOUNT_EXPIRED               constant          date    := TRUNC(SYSDATE);
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
        
            if (l_userid is null) then -- get a fresh ID from sequence
                select "RAS_INTERN"."APEX_APP_USER_ID_SEQ".nextval
                into l_userid
                from dual;
            end if;    
        
            begin
            /* -- double bookkeeping not needed for BFARM
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
   */
            insert into "RAS_INTERN"."APEX_APP_USER"  (
                APP_USER_ID,
                APP_USERNAME,
                APP_USER_EMAIL,
                APP_USER_DEFAULT_ROLE_ID,
                APP_USER_CODE,
                APP_USER_AD_LOGIN,
                APP_USER_NOVELL_LOGIN,
                APP_USER_FIRST_NAME,
                APP_USER_LAST_NAME,
                APP_USER_ADRESS,
                APP_USER_PHONE1,
                APP_USER_PHONE2,
                APP_USER_DESCRIPTION,
                APP_USER_STATUS_ID,
                APP_USER_PARENT_USER_ID,
                APP_ID,
                APP_USER_TOKEN,
                APP_USER_TOKEN_LAST_UPDATE,
                APP_USER_DOMAIN_ID,
                APP_USER_MELDER_ID) 
            (select 
              l_userid,
              APX_USERNAME,
              APX_USER_EMAIL,
              APX_USER_DEFAULT_ROLE_ID,
              APX_USER_CODE,
              APX_USER_AD_LOGIN,
              APX_USER_HOST_LOGIN,
              APX_USER_FIRST_NAME,
              APX_USER_LAST_NAME,
              APX_USER_ADRESS,
              APX_USER_PHONE1,
              APX_USER_PHONE2,
              APX_USER_DESCRIPTION,
              (select  STATUS_ID
               from "RAS_INTERN"."APEX_STATUS"
               where status = 'OPEN' 
               and status_scope = 'ACCOUNT'),
              APX_USER_PARENT_USER_ID,
              APP_ID,
              APX_USER_TOKEN,
              APX_USER_TOKEN_CREATED,
              APX_USER_DOMAIN_ID,
             (select ras_melder_id 
              from  "RAS_INTERN"."RAS_DOMAIN_GRUPPEN" 
              where ras_domain_id = APX_USER_DOMAIN_ID)
            from APEX_USER_REGISTRATION
            where apx_user_token = l_token
            );

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
            where application_id = l_app_id 
            ) loop
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

    l_result_code := 0;

    end if;

    commit;
    p_result  := l_result || ' User Created successfully';
 
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


create or replace procedure "SET_EMAIL_CONTENT" (
      p_topic           in varchar2        := null
    , p_mailto          in varchar2        := null
    , p_username     in varchar2        := null
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
    l_username            varchar2(128);
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
    C_APP_ID        constant    pls_integer     := 0;
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
    l_username   := p_username;
    
    dbms_output.put_line('APP ID: ' || l_app_id);

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
                            '##MAIL_TO##', nvl(l_username, l_mailto)
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

create or replace procedure "SET_EMAIL_CONTENT" (
      p_topic           in varchar2        := null
    , p_mailto          in varchar2        := null
    , p_username     in varchar2        := null
    , p_subject         in out clob
    , p_body            in out clob
    , p_body_html       in out clob
    , p_params          in varchar2        := null
    , p_values          in varchar2        := null
    , p_query           in varchar2        := null
    , p_app_id          in pls_integer     := null
    , p_for_app_id    in pls_integer     := null
    , p_mail_id         in pls_integer     := null
    , p_debug           in boolean         := false
 )
is
    l_topic                     varchar2(64);
    l_mailto                    varchar2(128);
    l_username            varchar2(128);
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
    l_for_app_id              pls_integer;    
    l_mail_id                   pls_integer;
    l_rowcnt                    pls_integer := 0;
    l_debug                     boolean;

    -- Constants and Defaults
    LF              constant    varchar2(2)     := utl_tcp.crlf;
    QP              constant    varchar2(4)     := chr(38)||'c='; -- url query prefix for app alias urls &c=WORKSPACE_NAME
    C_APP_ID        constant    pls_integer     := 100000;
    C_FOR_APP_ID  constant   pls_integer     := 0;
    C_MAIL_ID       constant    pls_integer     := null;
    C_DEBUG         constant    boolean         := false;

    -- Mail Topic Defaults
    C_TOPIC         constant    clob := 'WELCOME';
    C_SUBJECT       constant    clob := 'BFARM Apex Testmail'; -- Default Subject
    C_MAIL_TO       constant    clob := 'Dear User'; -- Default Mail To
    C_MAIL_HEAD     constant    clob := '<h2>Sehr geehrte/r ##MAIL_TO##</h2>';  -- Headline
    C_MAIL_TAIL     constant    clob := '<p>Mit freundlichen Grüßen,<br />' || LF ||'Ihr Bundesinstitut für Arzneimittel und Medizinprodukte<br />' ||
                                                                                                                          'Abteilung Arzneimittelfälschungen RAS<br /><br />'; -- Greeting and Signature
 
    C_MAIL_IMG1     constant    clob := ''; -- Image 1
    C_MAIL_IMG2     constant    clob := ''; -- Image 2
    C_MAIL_IMG3     constant    clob := '  <img src="https://www.bfarm.de/SiteGlobals/StyleBundles/Bilder/Farbschema/logo-bfarm.svg?__blob=normal&v=8" alt="Bundesinstitut für Arzneimittel und Medizinprodukte">'|| LF ||'</p>' || LF; -- Image 3 (included in MAIL_TAIL, so closing p tag needed)

    -- Default Mail Body HTML Text (Head and Tail will be pre- and appended)
    C_MAIL_BODY     constant    clob :=  LF ||
        C_MAIL_IMG1|| LF || C_MAIL_HEAD || LF || C_MAIL_IMG2 || LF ||
        '<p>This is a Testmail from our System.<br />'|| LF ||
        'You can safely ignore this message.</p>'||
        LF || C_MAIL_TAIL || LF || C_MAIL_IMG3;
    C_BODY          constant    clob := 'Um den Inhalt dieser Nachricht zu lesen, benutzen Sie bitte einen HTML-fähiges Email Programm oder aktivieren Sie HTML als Nachrichtenformat in Ihrem derzeitigen Email-Programm.';
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
    l_app_id        :=  nvl(p_app_id    , C_APP_ID);
    l_for_app_id  :=  nvl(p_for_app_id, nvl("GET_TARGET_APP_ID",  C_FOR_APP_ID));
    l_debug         :=  nvl(p_debug     , C_DEBUG);
    l_mail_id       :=  nvl(p_mail_id   , C_MAIL_ID);
    l_params        :=  nvl(p_params    , C_PARAMS);
    l_values        :=  nvl(p_values    , C_VALUES);
    l_username   := p_username;
    
    dbms_output.put_line('APP ID: ' || l_app_id);

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
                            '##MAIL_TO##', nvl(l_username, l_mailto)
                        ) as mail_body_html_escaped,
                        apex_app_id
                from   "APEX_MAIL_TOPIC_CONTENTS"
               where    apex_mail_id = nvl(p_mail_id   , apex_mail_id)
                 and    apex_app_id  = nvl(l_for_app_id, l_app_id)
                 and    upper(trim(apex_mail_topic))   = l_topic
                )
    loop
        l_app_id    := nvl(t.apex_app_id        ,  nvl(l_for_app_id,  l_app_id) );
        l_mail_id   := nvl(t.apex_mail_id       , C_MAIL_ID   );
        l_body      := nvl(t.mail_body           , C_BODY      );
        l_subject   := nvl(t.mail_subject        , C_SUBJECT   );
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


#WORKSPACE_IMAGES#js/FOOTER.min.js?v=20180205.#APEX_VERSION#
#WORKSPACE_IMAGES#js/validate/jquery.validate.min.js?v=20180205.#APEX_VERSION#
#WORKSPACE_IMAGES#js/validate/messages_de.min.js?v=20180205.#APEX_VERSION#
#WORKSPACE_IMAGES#js/validateFormGlobals.min.js?v=20180205.#APEX_VERSION#


// set BFARM Footer
setFooter();

#WORKSPACE_IMAGES#css/Theme101.min.css?v=20180118.#APEX_VERSION#
#WORKSPACE_IMAGES#css/validate/screen.min.css?v=20180129.#APEX_VERSION#
#WORKSPACE_IMAGES#css/validateForm.min.css?v=20180129.#APEX_VERSION#

create or replace function "GET_TARGET_APP_ID" (
p_app_name varchar2 := 'RAS AMF'
)
return number
is
l_app_name  varchar2(128);
l_return   number;
begin
    l_app_name := p_app_name;
    for i in (select  apex_config_item_value
                 from "APEX_CONFIGURATION"
                 where substr(apex_config_comment, 1, 13) = 'TARGET_APP_ID'
                 and apex_config_item = trim(l_app_name)) loop
             l_return := i.apex_config_item_value;
    end loop;
return l_return;    
end;
/


select GET_TARGET_APP_ID from dual;

--select substr(apex_config_comment, 1, 15) from APEX_CONFIGURATION
--where apex_config_item = 'RAS_USRREG';

create or replace function "GET_SOURCE_APP_ID" (
p_app_name varchar2 := 'RAS_USRREG'
)
return number
is
l_app_name  varchar2(128);
l_return   number;
begin
    l_app_name := p_app_name;
    for i in (select  apex_config_item_value
                 from "APEX_CONFIGURATION"
                 where substr(apex_config_comment, 1, 15) = 'REGISTER_APP_ID'
                 and apex_config_item = trim(l_app_name)) loop
             l_return := i.apex_config_item_value;
    end loop;
return l_return;    
end;
/

--select GET_SOURCE_APP_ID from dual;

insert into APX$MAIL_CONTENT 
(  APX_MAIL_TOPIC,
  APX_MAIL_SUBJECT,
  APX_MAIL_BODY,
  APX_MAIL_BODY_HTML,
  APX_MAIL_HEAD,
  APX_MAIL_BODY_CONTENT,
  APX_MAIL_TAIL,
  APX_MAIL_TO,
  APX_MAIL_TO_USER,
  APX_MAIL_GREETING,
  APX_IMG_URL1,
  APX_IMG_URL1_ALT,
  APX_TEXT1,
  APX_TEXT2,
  APX_URL_PARAMS,
  APX_URL_VALUES,
  APX_URL_QUERY,
  APX_PARENT_MAIL_ID,
  APX_APP_PAGE,
  APX_APP_REQUEST,
  APX_MAIL_SEC_LEVEL,
  APX_MAIL_STATUS_ID,
  APP_ID)
(SELECT 
  APX_MAIL_TOPIC,
  APX_MAIL_SUBJECT,
  APX_MAIL_BODY,
  APX_MAIL_BODY_HTML,
  APX_MAIL_HEAD,
  APX_MAIL_BODY_CONTENT,
  APX_MAIL_TAIL,
  APX_MAIL_TO,
  APX_MAIL_TO_USER,
  APX_MAIL_GREETING,
  APX_IMG_URL1,
  APX_IMG_URL1_ALT,
  APX_TEXT1,
  APX_TEXT2,
  APX_URL_PARAMS,
  APX_URL_VALUES,
  APX_URL_QUERY,
  APX_PARENT_MAIL_ID,
  APX_APP_PAGE,
  APX_APP_REQUEST,
  APX_MAIL_SEC_LEVEL,
  APX_MAIL_STATUS_ID,
  100002
FROM APX$MAIL_CONTENT
WHERE app_id != 0);

commit;


select substr(apex_config_comment, 1, 13) from 
 "APEX_CONFIGURATION"
                 where apex_config_item = 'RAS AMF';

create or replace function "GET_TARGET_APP_ID" (
p_app_name varchar2 := 'RAS AMF'
)
return number
is
l_app_name  varchar2(128);
l_return   number;
begin
    l_app_name := p_app_name;
    for i in (select  apex_config_item_value
                 from "APEX_CONFIGURATION"
                 where substr(apex_config_comment, 1, 13) = 'TARGET_APP_ID'
                 and apex_config_item = trim(l_app_name)) loop
             l_return := i.apex_config_item_value;
    end loop;
return l_return;    
end;
/


--CREATE OR REPLACE FORCE VIEW "RAS_INTERN"."RAS_AMIS_MAH" ("ZNR", "ENR", "AM", "MAH", "PNR", "ISO", "REGBEZ", "PNRAEANZ", "PNRSTM", "FSTR", "FPORT", "FPLZO", "ZUBPNR") AS 

create materialized view "RAS_AMIS_MAH_MV"
as
  select /*+ INDEX(k XPKKATPNR) */ h.znr, h.enr, H.AM, K.PNAME as MAH, K.PNR as PNR, k.FISONR as ISO, 
           k.REGBEZ, K.PNRAEANZ, K.PNRSTM, k.FSTR, k.FPORT, k.FPLZO, k.ZUBPNR
from data.HITS h, data.TANTR t, data.KATPNR k
where k.PNR != 0000000 
and h.enr = t.enr
and T.PNRANT = k.PNR;


create or replace force view "MIME_TYPE_ICONS"
as 
  SELECT B.MIME_NAME,
  B.MIME_TEMPLATE AS MIME_TYPE,
  B.MIME_GROUP,
  A.ICON_ID,
  A.ICON,
  A.ICON_MIME_TYPE,
  A.ICON_FILE_NAME,
  A.ICON_CHARSET,
  A.CREATED,
  A.CREATED_BY,
  A.MODIFIED,
  A.MODIFIED_BY
FROM "MIME_TYPES" B JOIN "MIME_ICONS" A
ON (A.ICON_ID = B.ICON_ID);


  GRANT SELECT ON "APEX_ADMIN"."MIME_TYPE_ICONS" TO PUBLIC;

CREATE OR REPLACE FORCE VIEW "APEX_ADMIN"."APEX_ADMINS" ("APP_USERNAME", "APPLICATION_ROLE") AS 
  select app_username, application_role from "APPLICATION_ADMINS" 
union 
select user_name, application_role from "WORKSPACE_ADMINS"
;


CREATE OR REPLACE FORCE VIEW "APEX_ADMIN"."WORKSPACE_ADMINS" ("USER_NAME", "APPLICATION_ROLE") AS 
  select user_name, 'WORKSPACE_ADMIN_USER' as "APPLICATION_ROLE" 
from "APEX_WORKSPACE_USERS" 
where IS_ADMIN = 'Yes' 
union 
select owner, 'APPLICATION_OWNER'  as "APPLICATION_ROLE" 
from "APEX_WORKSPACE"
;

select * from user_objects where status != 'VALID';


create or replace function "GET_TARGET_APP_ID" (
p_app_name varchar2 := 'RAS AMF'
)
return number
is
l_app_name  varchar2(128);
l_return   number;
begin
    l_app_name := p_app_name;
    for i in (select  apex_config_item_value
                 from "APEX_CONFIGURATION"
                 where substr(apex_config_comment, 1, 13) = 'TARGET_APP_ID'
                 and apex_config_item = trim(l_app_name)) loop
             l_return := i.apex_config_item_value;
    end loop;
return l_return;    
end;
/


select GET_TARGET_APP_ID from dual;

--select substr(apex_config_comment, 1, 15) from APEX_CONFIGURATION
--where apex_config_item = 'RAS_USRREG';

create or replace function "GET_SOURCE_APP_ID" (
p_app_name varchar2 := 'RAS_USRREG'
)
return number
is
l_app_name  varchar2(128);
l_return   number;
begin
    l_app_name := p_app_name;
    for i in (select  apex_config_item_value
                 from "APEX_CONFIGURATION"
                 where substr(apex_config_comment, 1, 15) = 'REGISTER_APP_ID'
                 and apex_config_item = trim(l_app_name)) loop
             l_return := i.apex_config_item_value;
    end loop;
return l_return;    
end;
/

--select GET_SOURCE_APP_ID from dual;

create or replace force view "MIME_TYPE_ICONS"
as 
  SELECT B.MIME_NAME,
  B.MIME_TEMPLATE AS MIME_TYPE,
  B.MIME_GROUP,
  A.ICON_ID,
  A.ICON,
  A.ICON_MIME_TYPE,
  A.ICON_FILE_NAME,
  A.ICON_CHARSET,
  A.CREATED,
  A.CREATED_BY,
  A.MODIFIED,
  A.MODIFIED_BY
FROM "MIME_TYPES" B JOIN "MIME_ICONS" A
ON (A.ICON_ID = B.ICON_ID);



       update  "APEX_APP_USER"
        set deleted  = sysdate,
              deleted_by  = nvl(v('APP_USER'), user),
              app_user_status_id = 1  --need to unlock to delete
        where APP_USER_ID = p_id; 
        -- get the username
        for u in (select upper(trim(app_username)) username
                     from  "APEX_APP_USER"
                    where  APP_USER_ID = p_id) loop
            l_username := u.username;
        end loop;    
       -- get APEX User Id by Name
       l_userid := apex_util.get_user_id(l_username);
       if (l_userid is not null) then
            -- remove user from apex
            begin
                   "RAS"."APX_APEX_USER_EDIT"(
                           p_result => l_result
                         , p_edit_action => 'DROP'
                         , p_user_id    => l_userid
                         , p_app_id => 100002
                         , p_user_name => null
                       );
            exception when others then
                null;
            end;    
       end if;    
        -- remove user from registration table
       delete from "RAS"."APX$USER_REG"
       where upper(trim(apx_username)) =  nvl(l_username, '');


.t-Form-inputContainer input #P35_VORGANGSNUMMER


declare
l_result number;
begin
   "RAS"."APX_APEX_USER_EDIT"(
       p_result => l_result
     , p_edit_action => 'DROP'
     , p_user_name => 'TRIVADIS@BFARM.DE'
   );
   dbms_output.put_line('Result: '||l_result); -- Result: 0
end;
/

 select "RAS_INTERN"."APEX_APP_USER_ID_SEQ".nextval
                --into l_userid
                from dual;

  ALTER TABLE "RAS_INTERN"."DOKUMENTE" drop CONSTRAINT "DOK_USER_ID_FK";                
  ALTER TABLE "RAS_INTERN"."DOKUMENTE" ADD CONSTRAINT "DOK_USER_ID_FK" FOREIGN KEY ("USER_ID")
	  REFERENCES "RAS_INTERN"."APEX_APP_USER" ("APP_USER_ID") ON DELETE SET NULL;                
      
      
      commit;
      
begin
  "RAS_SOFT_DELETE" ('APEX_APP_USER', :P98_APP_USER_ID);
  commit;
end;
/
      
      
create or replace  TRIGGER "RAS_INTERN"."USER_BD_TRG" 
before delete on "APEX_APP_USER"
referencing old as old new as new
for each row
declare
  pragma autonomous_transaction;
begin
  "RAS_SOFT_DELETE" ('APEX_APP_USER', :old.app_user_id);
  commit;
end;
/


DELETE FROM "RAS_INTERN"."APEX_APP_USER" WHERE ROWID = 'AAAGhBAAJAAAAFjAAK';




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
FROM "APEX_ALL_APPLICATIONS";


select apex_util.get_user_id(:l_username) from dual;

declare
l_result number;
        begin
               "RAS"."APX_APEX_USER_EDIT"(
                       p_result => l_result
                     , p_edit_action => 'DROP'
                     , p_user_id    => :p_id
                     , p_app_id => 100000
                     , p_user_name => null
                   );
                    dbms_output.put_line('Result: '||l_result); -- Result: 0
        exception when others then
            null;
        end;    
        /



      select  STATUS_ID
                        from "RAS_INTERN"."APEX_STATUS"
                        where status = 'OPEN' 
                        and status_scope = 'ACCOUNT';


  ALTER TABLE "RAS"."APX$USER_REG" ADD CONSTRAINT "APX_APEX_USER_ID_FK" FOREIGN KEY ("APEX_USER_ID")
	  REFERENCES "APEX_050100"."WWV_FLOW_FND_USER" ("USER_ID") ON DELETE SET NULL;                
      
      
      commit;
      
      
      
declare
l_result number;
        begin
               "RAS"."APX_APEX_USER_EDIT"(
                       p_result => l_result
                     , p_edit_action => 'DROP'
                     , p_user_id    => null
                     , p_app_id => 100000
                     , p_user_name => 'TRIVADIS@BFARM.DE'
                   );
                    dbms_output.put_line('Result: '||l_result); -- Result: 0
        exception when others then
            null;
        end;    
        /      

create or replace procedure "RAS_SOFT_DELETE" (
p_table in varchar2,
p_id number,
p_msg in varchar2 :=' können nicht gelöscht werden!',
p_new_status varchar2 := 'LOCKED'
) is
pragma autonomous_transaction;
l_status_id pls_integer;
l_msg varchar2(1000);
l_result number;
l_username varchar2(128);
l_userid  number;
begin
    select app_status_id into l_status_id
    from "APEX_APP_STATUS"
    where app_status = upper(nvl(p_new_status, 'LOCKED'));
    if (upper(p_table) = 'APEX_APP_USER') then
        l_msg := 'Benutzer'||p_msg;
       commit;
       update  "APEX_APP_USER"
        set deleted  = sysdate,
              deleted_by  = nvl(v('APP_USER'), user),
              app_user_status_id = 1  --need to unlock to delete
        where APP_USER_ID = p_id; 
        -- get the username
        for u in (select upper(trim(app_username)) username
                     from  "APEX_APP_USER"
                    where  APP_USER_ID = p_id) loop
            l_username := u.username;
        end loop;    
       -- get APEX User Id by Name
       l_userid := apex_util.get_user_id(l_username);        
        -- remove user from apex
        begin
               "RAS"."APX_APEX_USER_EDIT"(
                       p_result => l_result
                     , p_edit_action => 'DROP'
                     , p_user_id    => null
                     , p_app_id => 100002
                     , p_user_name => l_username
                   );
        exception when others then
            null;
        end;    
        -- remove user from registration table
        delete from "RAS"."APX$USER_REG"
        where upper(trim(apx_username)) =  nvl(l_username, '');   
        -- now set deleted status
        update  "APEX_APP_USER"
        set deleted  = sysdate,
              deleted_by  = nvl(v('APP_USER'), user),
              app_user_status_id = l_status_id
        where APP_USER_ID = p_id;
    elsif  (upper(p_table) = 'RAS_DOMAINEN') then
        l_msg := 'Domainen'||p_msg;
        commit;
        update  "APEX_APP_USER"
        set deleted  = sysdate,
              deleted_by  = nvl(v('APP_USER'), user),
              app_user_status_id = l_status_id
        where app_user_domain_id  = p_id;
        update "RAS_DOMAINEN"
        set deleted = sysdate,
              deleted_by     = nvl(v('APP_USER'), user)
        where domain_id = p_id;
    end if;
    commit;
    RAISE_APPLICATION_ERROR (-20002, l_msg, TRUE);
end;

create or replace force view "RAS_RUECKMELDUNG_STATS" ("NOTE_TYPE", "NUM_NOTES", "ID_VORGANG", "RAS_MELDER_ID") 
as 
with dg
as (
    select distinct ras_melder_id from RAS_DOMAIN_GRUPPEN
)
select 'DOKUMENTE' as note_type, count(1) as num_notes, d.id_vorgang, g.ras_melder_id
from BOB_LAENDER_ROW_DOKUMENTE d JOIN DG g
on (d.ras_melder_id = g.ras_melder_id)
where d.deleted is null
group by d.id_vorgang , g.ras_melder_id
union --notes
select 'ANMERKUNGEN' as mtype, count(1) as num_notes, d.id_vorgang, g.ras_melder_id
from BOB_LAENDER_ROW_ERGAENZUNGEN d JOIN DG g
on (d.ras_melder_id = g.ras_melder_id)
where d.deleted is null
group by d.id_vorgang, g.ras_melder_id
union --notes
select 'MASSNAHMEN' as mtype, count(1) as num_notes, d.id_vorgang, g.ras_melder_id
from BOB_LAENDER_ROW_MASSNAHMEN d JOIN DG g
on (d.ras_melder_id = g.ras_melder_id)
where d.deleted is null
group by d.id_vorgang, g.ras_melder_id;



ORA-00001: unique constraint (RAS.APX$DOMAIN_UNQ2) violated 
ORA-06512: at "RAS_INTERN.RAS_DOMAINEN_BIUD_TRG", line 6 
ORA-04088: error during execution of trigger 'RAS_INTERN.RAS_DOMAINEN_BIUD_TRG'



TRIGGER "RAS_INTERN"."RAS_DOMAINEN_BIUD_TRG" 
before insert or update or delete on "RAS_DOMAINEN"
referencing new as new old as old
for each row
begin
  if inserting then
    insert into "RAS"."APX$DOMAIN" (apx_domain_id, apx_domain, apx_domain_name, apx_domain_code, apx_domain_description)
    values (:new.DOMAIN_ID,  :new.DOMAIN, :new.DOMAIN_OWNER||' ' ||:new.DOMAIN_CODE, :new.DOMAIN_CODE, :new.DOMAIN_OWNER);
  elsif updating then
    update "RAS"."APX$DOMAIN"
    set     apx_domain               =  :new.DOMAIN
          , apx_domain_name          =  :new.DOMAIN_OWNER||' ' ||:new.DOMAIN_CODE
          , apx_domain_code          = :new.DOMAIN_CODE
          , apx_domain_description = :new.DOMAIN_OWNER
    where apx_domain_id = :new.DOMAIN_ID;
  elsif deleting then
        update "RAS"."APX$DOMAIN"
    set   apx_domain_status_id =  5
    where apx_domain_id = :old.DOMAIN_ID;
  end if;
end;

<span class="t-Reset-info">Passwort zurücksetzen</span>

select count(*) , upper(trim(domain_owner))
from ras_domainen
group by upper(trim(domain_owner));


alter table ras_domainen add domain_description varchar2(4000);
alter table ras_domainen modify DNS_NOT_RESOLVED number default 0;

create or replace trigger "RAS_DOMAINEN_BIUD_TRG" 
before insert or update or delete on "RAS_DOMAINEN"
referencing new as new old as old
for each row
begin
  if inserting then
    insert into "RAS"."APX$DOMAIN" (apx_domain_id, apx_domain, apx_domain_name, apx_domain_code, apx_domain_description)
    values (:new.DOMAIN_ID,  :new.DOMAIN, :new.DOMAIN_OWNER||' ' ||:new.DOMAIN_CODE, :new.DOMAIN_CODE, :new.DOMAIN_OWNER);
  elsif updating then
    update "RAS"."APX$DOMAIN"
    set   apx_domain                   =  :new.DOMAIN
          , apx_domain_name         =  nvl(nvl(:new.DOMAIN_OWNER, :new.DOMAIN), 'DOMAIN_'||to_char(:new.DOMAIN_ID))
          , apx_domain_code          = :new.DOMAIN_CODE
          , apx_domain_description = :new.DOMAIN_OWNER|| ' ' ||:new.DOMAIN_CODE
    where upper(trim(apx_domain)) = upper(trim(:new.DOMAIN));
  elsif deleting then
        update "RAS"."APX$DOMAIN"
    set   apx_domain_status_id =  5
    where upper(trim(apx_domain)) = upper(trim(:new.DOMAIN));
  end if;
end;
/

update apx$domain set apx_domain_description = apx_domain_name, apx_domain_name = apx_domain_description;
commit;


select count(*) , upper(trim(apx_domain_code))
from apx$domain
group by upper(trim(apx_domain_code))
having count(*) > 1;

begin 
begin  
select "MASSNAHME_ID",to_char("MASSNAHME_UMGESETZT_AM", :p$_format_mask1),"MASSNAHME_BEMERKUNG","ID_VORGANG","ID",
       "MASSNAHME_UMGESETZT","MELDENDE_BEHOERDE","USER_ID","RAS_MELDER_ID" 
       into wwv_flow.g_column_values(1),wwv_flow.g_column_values(2),wwv_flow.g_column_values(3),wwv_flow.g_column_values(4),wwv_flow.g_column_values(5),wwv_flow.g_column_values(6),wwv_flow.g_column_values(7),wwv_flow.g_column_values(8),wwv_flow.g_column_values(9) 
       from "RAS_INTERN"."BOB_LAENDER_ROW_MASSNAHMEN" 
       where "ID" = :p_rowid and RAS_MELDER_ID = nvl(v('LOGIN_RAS_MELDER_ID'), 1); end;
end;

http://172.16.3.226:8080/apex/f?p=100002:38:5815851041917::NO:RP,38:P38_ID,P0_P38_ID_VORGANG,P0_P38_FROM_PAGE:44,142,19


P35_AM,
P35_STAAT_ID,
P35_BUNDESLAND,
P35_AM_PNR,
P35_AM_ENR,
P35_ZNR,
P35_AM,
P35_MAH
:AVACAN,
37,
10,
3000621,
0000253,
,
AVACAN,
ASTA Medica GmbH   [HIST]

declare
l_bl_id number := null;
l_country_id number := null;
begin
for a in (SELECT znr, enr, am, mah, pnr, iso, regbez, pnraeanz, pnrstm, fstr, fport, fplzo, zubpnr
              from "RAS_AMIS_MAH"
              where PNR = :P35_AM_PNR
              and ENR = :P35_AM_ENR) loop
              
    -- setting country          
    for c in (select STAAT_ID 
              from BUNDESSTAATEN 
              where ISO_2 = replace(a.ISO, 'UK', 'GB')) loop
        l_country_id := c.STAAT_ID;
    end loop;    
    
    -- setting district
    if (a.ISO = 'DE') then 
      for b in (select max(BUNDESLAND_ID) as BL_ID
                from "BUNDESLAENDER_PLZ" 
                 where a.FPLZO between PLZ_FROM and PLZ_TO) loop
            l_bl_id := b.BL_ID;
        end loop;
    end if;    
    
    apex_util.set_session_state('P35_AM', a.am);
    apex_util.set_session_state('P35_STAAT_ID', a.iso);
    apex_util.set_session_state('P35_BUNDESLAND', a.fplzo);
    apex_util.set_session_state('P35_AM_PNR', a.pnr);
    apex_util.set_session_state('P35_AM_ENR', a.enr);
    apex_util.set_session_state('P35_ZNR', a.znr);
    apex_util.set_session_state('P35_AM', a.am);
    apex_util.set_session_state('P35_MAH', a.mah);
end loop;
end;


javascript:apex.navigation.dialog.close(true,'f?p=100002:35:7114475874415::NO::P35_AM_PNR,P35_AM_ENR:3083819,2171717');


BFARM_AMF_MELDUNG_BD_TRG	        AMF_VORGANG
BFARM_USER_BD_TRG	                BFARM_APEX_APP_USER
BFARM_BOBLR_DOKUMENTE_BD_TRG	    BOB_LAENDER_ROW_DOKUMENTE
BOB_LAENDER_ROW_MASSN_BD_TRG	    BOB_LAENDER_ROW_MASSNAHMEN
BFARM_DOKUMENTE_BD_TRG	            DOKUMENTE
RAS_DOMAINEN_BD_TRG	                AS_DOMAINEN



create or replace TRIGGER "RAS"."APX$USRREG_BIU_TRG" 
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
--        select apx_domain_id, apx_domain
--        into :new.apx_user_domain_id, l_domain
--        from "APX$DOMAIN"
--        where upper(trim(apx_domain)) =
--        upper(trim("PARSE_DOMAIN_FROM_EMAIL"(:new.apx_user_email)))
--        and apx_domain_status_id = (select apx_status_id
--                                    from "APX$STATUS"
--                                    where apx_status = 'VALID'
--                                    and apx_status_ctx_id = (select apx_context_id
--                                                             from "APX$CTX"
--                                                             where apx_context = 'DOMAIN'));
         select apex_domain_id, apex_domain
         into :new.apx_user_domain_id, l_domain
         from "BFARM_VALID_DOMAINS"
          where upper(trim(apex_domain)) = upper(trim("PARSE_DOMAIN_FROM_EMAIL"(:new.apx_user_email)));
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
        elsif (:new.apx_user_email is not null) then
            :new.apx_username := :new.apx_user_email;
        end if;
        exception when no_data_found then
          select 'NewAppUser '||
          nvl(:new.apx_user_id, to_number(SYS_GUID(),'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'))
          into :new.apx_username
          from dual;
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
          then RAISE_APPLICATION_ERROR (-20201, 'No valid Domain found!');
when others then
  raise;
end;


    if (nullif(:new.apx_user_domain_id, 0) is null) then
      begin
--        select apx_domain_id, apx_domain
--        into :new.apx_user_domain_id, l_domain
--        from "APX$DOMAIN"
--        where upper(trim(apx_domain)) =
--        upper(trim("PARSE_DOMAIN_FROM_EMAIL"(:new.apx_user_email)))
--        and apx_domain_status_id = (select apx_status_id
--                                    from "APX$STATUS"
--                                    where apx_status = 'VALID'
--                                    and apx_status_ctx_id = (select apx_context_id
--                                                             from "APX$CTX"
--                                                             where apx_context = 'DOMAIN'));
         select apex_domain_id, apex_domain
         into :new.apx_user_domain_id, l_domain
         from "BFARM_VALID_DOMAINS"
          where upper(trim(apex_domain)) = upper(trim("PARSE_DOMAIN_FROM_EMAIL"(:new.apx_user_email)));
          raise_application_error(-20001, 'NO Domain found for '|| upper(trim("PARSE_DOMAIN_FROM_EMAIL"(:new.apx_user_email)))||' '|| :new.apx_user_domain_id||' '|| l_domain);
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

create or replace view "BFARM_VALID_DOMAINS"
as
  select DOMAIN_ID as APEX_DOMAIN_ID,
  DOMAIN as APEX_DOMAIN,
  DOMAIN_OWNER as APEX_DOMAIN_OWNER,
  DOMAIN_CODE as APEX_DOMAIN_CODE,
  DNS_GUELTIG as APEX_DOMAIN_DNS_VALID,
  CASE STATUS WHEN 'VALID' Then 'Gueltig' else 'Ungueltig' end as APEX_DOMAIN_STATUS,
  MODIFIED,
  MODIFIED_BY,
  CREATED,
  CREATED_BY,
  DELETED,
  DELETED_BY
FROM "RAS_INTERN"."RAS_DOMAINS" 
WHERE STATUS = 'VALID';


select * from "BFARM_VALID_DOMAINS";

create or replace function "IS_VALID_BFARM_DOMAIN" (
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
    from "BFARM_VALID_DOMAINS"
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

select * from bfarm_valid_domains
where upper(trim(apex_domain)) = 'REG1-OB.BAYERN.DE';

        select apex_domain_id, apex_domain
         --into :new.apx_user_domain_id, l_domain
         from "BFARM_VALID_DOMAINS"
          where upper(trim(apex_domain)) = upper(trim("PARSE_DOMAIN_FROM_EMAIL"(:new_apx_user_email)));
          
          
          
          
    l_domain :=  upper(trim("PARSE_DOMAIN_FROM_EMAIL"(:new.apx_user_email)));
        select apex_domain_id, apex_domain
         --into :new.apx_user_domain_id, l_domain
         from BFARM_VALID_DOMAINS
          where upper(trim(apex_domain)) = 'REG1-OB.BAYERN.DE';          


grant select, references on "RAS_DOMAINEN" to ras;
grant select on  "BFARM_APEX_STATUS" to ras;
grant select on "RAS_VALID_DOMAINS" to ras;


begin
for a in (SELECT znr, enr, am, mah, pnr, iso, regbez, pnraeanz, pnrstm, fstr, fport, fplzo, zubpnr
              from "RAS_AMIS_MAH"
              where PNR = 3000621
              and ENR = 0000253) loop
    apex_util.set_session_state('P35_AM', a.am);
    apex_util.set_session_state('P35_STAAT_ID', a.iso);
    apex_util.set_session_state('P35_BUNDESLAND', a.fplzo);
    apex_util.set_session_state('P35_AM_PNR', a.pnr);
    apex_util.set_session_state('P35_AM_ENR', a.enr);
    apex_util.set_session_state('P35_ZNR', a.znr);
    apex_util.set_session_state('P35_AM', a.am);
    apex_util.set_session_state('P35_MAH', a.mah);
end loop;
end;
/

SELECT znr, enr, am, mah, pnr, iso, regbez, pnraeanz, pnrstm, fstr, fport, fplzo, zubpnr
              from "RAS_AMIS_MAH"
              where PNR = 3083819
              and ENR = 2171717;
              
SELECT
    am_name,
    am_znr,
    am_pu
FROM
    amf_vorgang;

              declare
l_return number;
begin
    l_return := "RAS"."IS_VALID_DOMAIN"(upper(trim(:USERNAME)), p_return_as_offset => 'TRUE', p_return_offset => -1);
dbms_output.put_line(l_return);
end;
/

begin
  dbms_stats.gather_schema_stats('RAS_INTERN');
end;
/

create or replace TRIGGER "RAS"."APX$USRREG_BIU_TRG" 
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
--        select apx_domain_id, apx_domain
--        into :new.apx_user_domain_id, l_domain
--        from "APX$DOMAIN"
--        where upper(trim(apx_domain)) =
--        upper(trim("PARSE_DOMAIN_FROM_EMAIL"(:new.apx_user_email)))
--        and apx_domain_status_id = (select apx_status_id
--                                    from "APX$STATUS"
--                                    where apx_status = 'VALID'
--                                    and apx_status_ctx_id = (select apx_context_id
--                                                             from "APX$CTX"
--                                                             where apx_context = 'DOMAIN'));
         select apex_domain_id, apex_domain
         into :new.apx_user_domain_id, l_domain
         from "BFARM_VALID_DOMAINS"
          where upper(trim(apex_domain)) = upper(trim("PARSE_DOMAIN_FROM_EMAIL"(:new.apx_user_email)));
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
        elsif (:new.apx_user_email is not null) then
            :new.apx_username := :new.apx_user_email;
        end if;
        exception when no_data_found then
          select 'NewAppUser '||
          nvl(:new.apx_user_id, to_number(SYS_GUID(),'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'))
          into :new.apx_username
          from dual;
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
          then RAISE_APPLICATION_ERROR (-20201, 'No valid Domain found!');
when others then
  raise;
end;
/

select "PARSE_DOMAIN_FROM_EMAIL"(:new_apx_user_email) from dual;

         select apex_domain_id, apex_domain
        -- into :new.apx_user_domain_id, l_domain
         from "BFARM_VALID_DOMAINS"
        where upper(trim(apex_domain)) = upper(trim("PARSE_DOMAIN_FROM_EMAIL"(:new_apx_user_email)));
        
        
        
        
declare
l_domain varchar2(200);
l_domain_id number;
new_apx_user_email varchar2(200) := 'hn@reg1-ob.bayern.de';
begin
  l_domain :=  upper(trim("PARSE_DOMAIN_FROM_EMAIL"(new_apx_user_email)));
    --raise_application_error(-20001, '##'||l_domain||'##');  
    select apex_domain_id, apex_domain
     into l_domain_id, l_domain
     from "RAS"."BFARM_VALID_DOMAINS"
      where upper(trim(apex_domain)) = l_domain;
exception when others then
  raise_application_error(-20001, sqlcode ||' '||sqlerrm);  
end;
/

  select domain_id, domain
     --into l_domain_id, l_domain
     from "RAS_INTERN"."RAS_VALID_DOMAINS"
      where upper(trim(domain)) = 'REG1-OB.BAYERN.DE';

   select apex_domain_id, apex_domain
    -- into l_domain_id, l_domain
     from "RAS"."BFARM_VALID_DOMAINS"
      where replace(upper(trim(apex_domain)), '-','') = :l_domain;
      
      
      
declare
l_domain varchar2(200);
l_domain_id number;
new_apx_user_email varchar2(200) := :P110_EMAIL;
begin
  l_domain :=  upper(trim("PARSE_DOMAIN_FROM_EMAIL"(new_apx_user_email)));
 -- raise_application_error(-20023, '##'||l_domain||'##');  
    select apex_domain_id, apex_domain
     into l_domain_id, l_domain
     from "RAS"."BFARM_VALID_DOMAINS"
     where upper(trim(apex_domain)) = l_domain;
 dbms_output.put_line(l_domain_id||' '||l_domain);
exception when others then
  raise_application_error(-20034, sqlerrm||' ##'||l_domain||'##'); 
end;
/      
      
      
      
      
declare
l_domain VARCHAR2(256);
l_domain_id number;
new_apx_user_email varchar2(200) := :P110_EMAIL;
begin
  l_domain :=  "PARSE_DOMAIN_FROM_EMAIL"(new_apx_user_email);
 -- raise_application_error(-20023, '##'||l_domain||'##');  
    select apex_domain_id, apex_domain
     into l_domain_id, l_domain
     from "RAS"."BFARM_VALID_DOMAINS"
     where apex_domain = l_domain;
 
exception when others then
  raise_application_error(-20034, sqlerrm||' ##'||l_domain||'##'); 
end;
/      


create or replace function get_domain_id (
  p_email in varchar2
) return number 
is
l_domain VARCHAR2(256);
l_domain_id number;
new_apx_user_email varchar2(200) := p_email;
begin
  l_domain :=  "PARSE_DOMAIN_FROM_EMAIL"(p_email);
 -- raise_application_error(-20023, '##'||l_domain||'##');  
    select apex_domain_id, apex_domain
     into l_domain_id, l_domain
     from "RAS"."BFARM_VALID_DOMAINS"
     where apex_domain = l_domain;
     return l_domain_id;
exception when others then
  raise;
end;
/


select get_domain_id('hn@reg1-ob.bayern.de') from dual;


select domain_id, domain 
from RAS_INTERN.RAS_DOMAINEN
where domain =  "PARSE_DOMAIN_FROM_EMAIL"(:p_email);


alter table APX$USER_REG add constraint "APX$USREG_DOMAIN_FK" foreign key (APX_USER_DOMAIN_ID) references "RAS_INTERN"."RAS_DOMAINEN"(domain_id) on delete set null;

select ras_melder_id
from BFARM_RAS_USERS
where upper(trim(app_username)) = upper(trim(:APP_USER));

select ras_melder_id
from BFARM_RAS_USERS
where upper(trim(app_username)) = upper(trim(:APP_USER));

select "MASSNAHME_ID",to_char("MASSNAHME_UMGESETZT_AM", :p$_format_mask1),"MASSNAHME_BEMERKUNG","ID_VORGANG","ID",
       "MASSNAHME_UMGESETZT","MELDENDE_BEHOERDE","USER_ID","RAS_MELDER_ID" 
       --into wwv_flow.g_column_values(1),wwv_flow.g_column_values(2),wwv_flow.g_column_values(3),wwv_flow.g_column_values(4),wwv_flow.g_column_values(5),wwv_flow.g_column_values(6),wwv_flow.g_column_values(7),wwv_flow.g_column_values(8),wwv_flow.g_column_values(9) 
       from "RAS_INTERN"."BOB_LAENDER_ROW_MASSNAHMEN" 
       where "ID" = :p_rowid and RAS_MELDER_ID = 5; end;
end;

create unique index "AMF_VORGANG_UNQ" on AMF_VORGANG (case when deleted is null then 1 else id_vorgang end, vorgangsnummer);


select count(*) , vorgangsnummer
from amf_vorgang
where deleted is null
group by vorgangsnummer
;



declare
l_count number;
begin
  select count(1)
  into l_count
  from AMF_VORGANG
  where upper(trim(vorgangsnummer)) = upper(trim(:P35_VORGANGSNUMMER));
  if (l_count = 0) then
    --return false;
    dbms_output.put_line('DOES NOT EXISTS');
  else
    --return true;
    dbms_output.put_line('EXISTS');
  end if;
end;
/

update amf_vorgang set deleted = sysdate where deleted_by is not null and deleted is null;
commit;



SELECT VORGANGSNUMMER|| ' ' || BEZEICHNUNG as d,
       ID_VORGANG as r
FROM "AMF_VORGANG"
WHERE DELETED is null
order by 1;

 select distinct ras_melder_id from RAS_DOMAIN_GRUPPEN;

/*
 CREATE OR REPLACE FORCE VIEW "RAS_INTERN"."RAS_RUECKMELDUNG_STATS" ("NOTE_TYPE", "NUM_NOTES", "ID_VORGANG", "RAS_MELDER_ID") AS 
  with dg
as (
    select distinct ras_melder_id from RAS_DOMAIN_GRUPPEN
)
select 'DOKUMENTE' as note_type, count(1) as num_notes, d.id_vorgang, g.ras_melder_id
from BOB_LAENDER_ROW_DOKUMENTE d JOIN DG g
on (d.ras_melder_id = g.ras_melder_id)
where d.deleted is null
group by d.id_vorgang , g.ras_melder_id
union --notes
select 'ANMERKUNGEN' as mtype, count(1) as num_notes, d.id_vorgang, g.ras_melder_id
from BOB_LAENDER_ROW_ERGAENZUNGEN d JOIN DG g
on (d.ras_melder_id = g.ras_melder_id)
where d.deleted is null
group by d.id_vorgang, g.ras_melder_id
union --notes
select 'MASSNAHMEN' as mtype, count(1) as num_notes, d.id_vorgang, g.ras_melder_id
from BOB_LAENDER_ROW_MASSNAHMEN d JOIN DG g
on (d.ras_melder_id = g.ras_melder_id)
where d.deleted is null
group by d.id_vorgang, g.ras_melder_id;

*/

  with dg
as (
    select distinct ras_melder_id from RAS_DOMAIN_GRUPPEN
)
--select 'DOKUMENTE' as note_type, count(1) as num_notes, d.id_vorgang, g.ras_melder_id
--from BOB_LAENDER_ROW_DOKUMENTE d JOIN DG g
--on (d.ras_melder_id = g.ras_melder_id)
--where d.deleted is null
--group by d.id_vorgang , g.ras_melder_id
--union --notes
--select 'ANMERKUNGEN' as mtype, count(1) as num_notes, d.id_vorgang, g.ras_melder_id
--from BOB_LAENDER_ROW_ERGAENZUNGEN d JOIN DG g
--on (d.ras_melder_id = g.ras_melder_id)
--where d.deleted is null
--group by d.id_vorgang, g.ras_melder_id
--union --notes
select 'MASSNAHMEN' as mtype, count(1) as num_notes, d.id_vorgang, g.ras_melder_id
from BOB_LAENDER_ROW_MASSNAHMEN d LEFT JOIN DG g
on (d.ras_melder_id = g.ras_melder_id)
where d.deleted is null
group by d.id_vorgang, g.ras_melder_id;


CREATE OR REPLACE FORCE VIEW "RAS_INTERN"."RAS_RUECKMELDUNG_STATS" ("NOTE_TYPE", "NUM_NOTES", "ID_VORGANG", "RAS_MELDER_ID") 
 AS 
select 'DOKUMENTE' as note_type, count(1) as num_notes, d.id_vorgang, d.ras_melder_id
from BOB_LAENDER_ROW_DOKUMENTE d
where d.deleted is null
group by d.id_vorgang , d.ras_melder_id
union --notes
select 'ANMERKUNGEN' as mtype, count(1) as num_notes, d.id_vorgang, d.ras_melder_id
from BOB_LAENDER_ROW_ERGAENZUNGEN d
where d.deleted is null
group by d.id_vorgang, d.ras_melder_id
union --notes
select 'MASSNAHMEN' as mtype, count(1) as num_notes, d.id_vorgang, d.ras_melder_id
from BOB_LAENDER_ROW_MASSNAHMEN d
--where d.deleted is null
group by d.id_vorgang, d.ras_melder_id;

select * from RAS_RUECKMELDUNG_STATS;


select BLR_MASSNAHMEN_SEQ.nextval from dual;


x
    select count(1)
    --into l_exists
    from BOB_LAENDER_ROW_MASSNAHMEN
    where  id_vorgang = nvl(:P0_P38_ID_VORGANG, :P38_ID_VORGANG)
    and ras_melder_id = :LOGIN_RAS_MELDER
    and deleted is null;

TRIGGER "RAS_INTERN"."BFARM_AMF_MELDUNG_BD_TRG" 
before delete on "AMF_VORGANG"
referencing old as old new as new
for each row
declare
  pragma autonomous_transaction;
begin
      "BFARM_RAS_SOFT_DELETE" ('AMF_VORGANG', :old.id_vorgang);
end;

begin begin  
select "MASSNAHME_ID",to_char("MASSNAHME_UMGESETZT_AM", :p$_format_mask1),"MASSNAHME_BEMERKUNG","ID_VORGANG","ID","MASSNAHME_UMGESETZT","MELDENDE_BEHOERDE","USER_ID","RAS_MELDER_ID" into wwv_flow.g_column_values(1),wwv_flow.g_column_values(2),wwv_flow.g_column_values(3),wwv_flow.g_column_values(4),wwv_flow.g_column_values(5),wwv_flow.g_column_values(6),wwv_flow.g_column_values(7),wwv_flow.g_column_values(8),wwv_flow.g_column_values(9) 
from "RAS_INTERN"."BOB_LAENDER_ROW_MASSNAHMEN" where "ID" = :p_rowid; end;
end;


CREATE OR REPLACE TRIGGER "RAS_INTERN"."RAS_DOMAINEN_BD_TRG" 
before delete on "RAS_DOMAINEN"
referencing old as old new as new
for each row
  begin
     INSERT INTO "RAS_DOMAINEN_HIST" (
        domain_id,
        domain,
        domain_owner,
        domain_code,
        dns_not_resolved,
        domain_melder_id,
        status_id,
        modified,
        modified_by,
        created,
        created_by,
        deleted,
        deleted_by
    ) VALUES (
        :old.domain_id,
        :old.domain,
        :old.domain_owner,
        :old.domain_code,
        :old.dns_not_resolved,
        :old.domain_melder_id,
        :old.status_id,
        :old.modified,
        :old.modified_by,
        :old.created,
        :old.created_by,
        sysdate,
        nvl(v('APP_USER'), user)
    );
    
    begin
        for i in (select upper(trim(app_username)) as username
                    from BFARM_APEX_APP_USER
                    where APP_USER_DOMAIN_ID = :old.domain_id) loop
                    DELETE FROM apex_050100.wwv_flow_fnd_user
                    WHERE user_name =  i.username;
        end loop;
    end;    

    
  end;
/

SELECT 
    e.ID,
    e.ID_VORGANG,
    nvl(e.MELDENDE_BEHOERDE, :LOGIN_RAS_DOMAIN) as MELDENDE_BEHOERDE,
    case when instr(mimetype, '/x-bzip') > 0 or  instr(mimetype, '/x-bzip2') > 0 or instr(mimetype, '/zip') > 0 
    then '<i class="fa-file-archive-o" />'
    when instr(mimetype, 'audio/') > 0
    then '<i class="fa-file-audio-o" />'
    when instr(mimetype, '/javascript') > 0 or instr(mimetype, '/json') > 0 or instr(mimetype, '/css') > 0 or instr(mimetype, 'sql') > 0 or instr(mimetype, 'java') > 0
    then '<i class="fa-file-code-o" />'
    when instr(mimetype, '/vnd.ms-excel') > 0 or instr(mimetype, '/vnd.openxmlformats-officedocument.spreadsheetml.sheet') > 0
    then '<i class="fa-file-excel-o" />'
    when instr(mimetype, 'image/') > 0
    then '<span class="fa fa-file-image-o"></span>'
    when instr(mimetype, 'application/pdf') > 0
    then '<i class="fa-file-pdf-o" />'
    when instr(mimetype, 'application/vnd.ms-powerpoint') > 0 or instr(mimetype, 'application/vnd.openxmlformats-officedocument.presentationml.presentation') > 0
    then '<i class="fa-file-powerpoint-o" />'
    when instr(mimetype, '/css') > 0 or  instr(mimetype, '/csv') > 0 or instr(mimetype, '/rtf') > 0  or instr(mimetype, 'text/') > 0
    then '<i class="fa-file-text-o" />'
    when instr(mimetype, 'video/') > 0
    then '<i class="fa-file-video-o" />'
    when instr(mimetype, 'application/x-abiword') > 0 or instr(mimetype, 'application/msword') > 0 or instr(mimetype, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document') > 0 
    then '<i class="fa-file-word-o" />'
    else '<i class="fa-file-o" />'
    end as mime_icon,
    dbms_lob.getlength(e.DATEIINHALT)||' Bytes' as DATEIGROESSE,
    e.DATEINAME,
    e.DOKUMENTEN_INHALT,
    e.MIMETYPE,
    e.CREATED,
    e.CREATED_BY,
    nvl(e.MODIFIED, e.CREATED) as MODIFIED,
    e.MODIFIED_BY
FROM "BOB_LAENDER_ROW_DOKUMENTE" e
WHERE e.ID_VORGANG = :P125_ID_VORGANG
AND e.RAS_MELDER_ID = :P125_RAS_MELDER_ID
AND e.DELETED is null;



SELECT 
  e.ID,
  e.ID_VORGANG,
  nvl(e.MELDENDE_BEHOERDE, :LOGIN_RAS_DOMAIN) as MELDENDE_BEHOERDE,
  dbms_lob.getlength(e.DATEIINHALT)||' Bytes' as DATEIGROESSE,
  e.DATEINAME,
  e.DOKUMENTEN_INHALT,
  e.MIMETYPE,
 '<img src="'||apex_util.get_blob_file_src('P132_ICON', i.icon_id)||'" style="width:32px; height:32px;" alt="'||i.ICON_FILE_NAME||'"/>' as ICON_DISPLAY,
 I.ICON_ID,
 e.USER_ID
FROM "BOB_LAENDER_ROW_DOKUMENTE" e left outer join "MIME_TYPE_ICONS" i
ON (e.MIMETYPE = I.MIME_TYPE)
WHERE e.ID_VORGANG = :P38_ID_VORGANG
AND e.RAS_MELDER_ID = :LOGIN_RAS_MELDER_ID
AND e.DELETED is null;


grant select, delete on apex_050100.wwv_flow_fnd_user to ras_intern;

SELECT 
  e.ID,
  e.ID_VORGANG,
  nvl(e.MELDENDE_BEHOERDE, :LOGIN_RAS_DOMAIN) as MELDENDE_BEHOERDE,
  dbms_lob.getlength(e.DATEIINHALT)||' Bytes' as DATEIGROESSE,
  e.DATEINAME,
  e.DOKUMENTEN_INHALT,
  e.MIMETYPE,
 '<img src="'||apex_util.get_blob_file_src('P132_ICON', i.icon_id)||'" style="width:32px; height:32px;" alt="'||i.ICON_FILE_NAME||'"/>' as ICON_DISPLAY,
 I.ICON_ID,
 e.USER_ID
FROM "BOB_LAENDER_ROW_DOKUMENTE" e left outer join "MIME_TYPE_ICONS" i
ON (e.MIMETYPE = I.MIME_TYPE)
WHERE e.ID_VORGANG = :P38_ID_VORGANG
AND e.RAS_MELDER_ID = :LOGIN_RAS_MELDER_ID
AND e.DELETED is null;



select upper(trim(app_username)) as username
                    from BFARM_APEX_APP_USER
                    where APP_USER_DOMAIN_ID = 241;
                    
select * from RAS.APEX_WORKSPACE_USER;


declare
l_return varchar2(200);
begin
  select upper(:BROWSER_LANG)|| lpad(nvl(max(id_vorgang),0)+1, 6, 0)
  into l_return
  from "AMF_VORGANG";
return l_return;
exception when no_data_found then
return null;
end;



AM_CHRG_PACK_TYPE_EQ_ORIGINAL

margin-bottom: 10px;

<span class="t-Form_Checkbox">Verpackung</span>

#P16_PACKAGING_LABEL
#P16_LABELING_LABEL
#P16_DESCRIPTION_LABEL
#P16_COMPOSITION_LABEL
#P16_REMARKS_ON_ORIGIN_LABEL
#P16_REMARKS_ON_DISTR_LABEL
#P16_ACTIVE_COMPONENT_FRAUD_LABEL
#P16_RAS_ALERT_LABEL

CONTACT_NAME

select * from dba_scheduler_running_jobs;
alter system set shared_servers=20 scope=both;
alter system set processes=500 scope=both;


select * from dba_cpool_info;

exec DBMS_CONNECTION_POOL.START_POOL;


BFARM_RAS_AMF.js

select 1 as cnt from "AMF_CHARGEN_CONTACTS" 
where ID_AM_CHARGE = :P16_ID_AM_CHARGE;


javascript:apex.navigation.dialog('f?p=100002:42:1784927719753::NO:RP,42:P42_ID_AM_CHARGE:47\u0026p_dialog_cs=L6Ei2xPFAbEZg1cUbAV9d6OmZTs',{title:'Chargen%20Ansprechpartner',height:'600',width:'860',maxWidth:'840',modal:true,dialog:null},'t-Dialog--standard',apex.jQuery('#CHRG_INFOS'));


<a href="f?p=123:42:21234::NO:RP,42:P42_ID_AM_CHARGE:39">Ansprechpartner</a>

select * from dba_cpool_info;


apex.event.trigger(sel, "apexrefresh" );

<a href="f?p=&APP_ID.:44:&SESSION.::::P44_ID_VORGANG:&P35_ID_VORGANG."><button class="t-Button t-Button--icon js-ignoreChange t-Button--iconLeft" style="background-color: #890d49;color: #ffffff;margin-left: 12px; height: 22px;margin-bottom: 2px;vertical-align: top;padding-bottom: 4px;line-height: 0.8;padding-top: 2px; width: 180px;" type="button" id="ADD_DISTR">
    <span class="t-Button-label">Parallelvertreiber hinzufügen</span>
</button></a>


Set you button to "Start New Row" = No and "New Column" = No
Set the "Static ID" of your button to <page item name>_BUTTON
In the Page Level attribute "Execute when Page Loads" add

    $( "#P1_DEPTNOS" ).after( $( "#P1_DEPTNOS_BUTTON" ));  


$('#P35_PARVER_DISPLAY').html($('#P35_PARVER_DISPLAY').html().replace(/\:/g,''));


http://10.15.188.113:8080/apex/f?p=100002:38:9922649583367::NO:RP,38:P38_ID,P0_P38_ID_VORGANG,P0_P38_FROM_PAGE:89,190,19

http://10.15.188.113:8080/apex/f?p=100002:38:9922649583367::NO:RP,38:P38_ID,P38_ID_VORGANG:89,190


.a-IG-header {
    display: none;
}

.a-IG-header {
    background-color: white;
}


http://10.15.188.113:8080/apex/f?p=100002:35:9922649583367:EDIT:NO:RP,35:P35_ID_VORGANG:193

select 1 from  DUAL
where :P18_ID_CHARGE_CONTACT_ID is not null 
and v('REQUEST') != 'READONLY'


, function() {
$('#P35_PARVER_1_DISPLAY').html($('#P35_PARVER').text());
}



apex.da.initDaEventList = function(){
apex.da.gEventList = [
{"triggeringElementType":"BUTTON","triggeringButtonId":"B4179989425214835","bindType":"bind","bindEventType":"click","anyActionsFireOnInit":false,actionList:[{"eventResult":true,"executeOnPageInit":false,"stopExecutionOnError":true,javascriptFunction:function (){ apex.navigation.dialog.cancel(true);
},"action":"NATIVE_DIALOG_CANCEL"}]},
{"triggeringElementType":"REGION","triggeringRegionId":"CHRG_CONTACTS","isIGRegion":true,"bindType":"bind","bindEventType":"apexafterclosedialog","anyActionsFireOnInit":false,actionList:[{"eventResult":true,"executeOnPageInit":false,"stopExecutionOnError":true,"affectedElementsType":"REGION","affectedRegionId":"CHRG_CONTACTS",javascriptFunction:apex.da.refresh,"action":"NATIVE_REFRESH"}]},
{"triggeringElementType":"ITEM","triggeringElement":"P16_IDENTITY_REMARKS","bindType":"bind","bindEventType":"click","anyActionsFireOnInit":false,
actionList:[{"eventResult":true,"executeOnPageInit":false,"stopExecutionOnError":true,"affectedElementsType":"JQUERY_SELECTOR","affectedElements":".t-hide-First",javascriptFunction:apex.da.show,"attribute01":"N","action":"NATIVE_SHOW"},{"eventResult":true,"executeOnPageInit":false,"stopExecutionOnError":true,javascriptFunction:function (){ if ($('#P16_IDENTITY_REMARKS').is(':checked')) {
    alert('checked');
}
},"action":"NATIVE_JAVASCRIPT_CODE"}]}];
}


div.row:nth-child(n+5):nth-child(-n+8)
div.row:nth-child(5)
div.row:nth-child(6)
div.row:nth-child(7)
div.row:nth-child(8)


:P16_ID_AM_CHARGE,
:P16_ID_VORGANG,
:P16_AM_CHRG_BEZ_FAELS,
:P16_AM_CHRG_PACK_TYPE_ID,
:P16_AM_CHRG_PACK_TYPE_EQ_ORIGINAL,
:P16_AM_CHRG_HLT_FAELS,
:P16_AM_CHRG_HLT_ORIG,
:P16_AM_CHRG_HLT_MON_FAELS,
:P16_AM_CHRG_HLT_YEAR_FAELS,
:P16_AM_CHRG_HLT_MON_ORIG,
:P16_AM_CHRG_HLT_YEAR_ORIG,
:P16_IDENTITY_REMARKS,
:P16_PACKAGING,
:P16_LABELING,
:P16_DESCRIPTION,
:P16_COMPOSITION,
:P16_REMARKS_ON_ORIGIN,
:P16_REMARKS_ON_DISTR,
:P16_ACTIVE_COMPONENT_FRAUD,
:P16_OTHER_REMARKS,
:P16_VERIFICATION_STATUS_ID,
:P16_SUSPECTED_CHRG_LOQ,
:P16_RAS_ALERT,
:P16_MODIFIED,
:P16_MODIFIED_BY,
:P16_CREATED,
:P16_CREATED_BY

INSERT INTO "AMF_VORGANG" (
    id_vorgang,
    vorgangsnummer,
    bezeichnung,
    meldende_stelle,
    eingangsdatum,
    erstellungsdatum,
    staat_id,
    bundesland_id,
    bundesoberbehoerde,
    bemerkung,
    modified,
    modified_by,
    created,
    created_by,
    bearb_inspektor,
    beteil_inspektor,
    stellungnahme_angefordert,
    stufenplanbeauftrag,
    risiko_stellungnahme,
    chargen_maengel,
    ras_fall,
    am_name,
    am_znr,
    am_pu,
    am_chrg_orig,
    am_chrg_faelsch,
    am_chrg_hltb,
    am_chrg_f_hltb,
    art_der_faelschung,
    faelschungsart_sonstige,
    am_chrg_status,
    am_wirkstoff,
    deleted_by,
    deleted,
    zust_landesbehoerde,
    am_enr,
    am_pnr,
    amf_meldung_status,
    art_der_zustaendigkeit,
    art_der_zustaendigkeit_sonst)(    
    SELECT
        id_vorgang,
        vorgangsnummer,
        bezeichnung,
        meldende_stelle,
        eingangsdatum,
        erstellungsdatum,
        staat_id,
        bundesland_id,
        bundesoberbehoerde,
        bemerkung,
        modified,
        modified_by,
        created,
        created_by,
        bearb_inspektor,
        beteil_inspektor,
        stellungnahme_angefordert,
        stufenplanbeauftrag,
        risiko_stellungnahme,
        chargen_maengel,
        ras_fall,
        am_name,
        am_znr,
        am_pu,
        am_chrg_orig,
        am_chrg_faelsch,
        am_chrg_hltb,
        am_chrg_f_hltb,
        art_der_faelschung,
        faelschungsart_sonstige,
        am_chrg_status,
        am_wirkstoff,
        deleted_by,
        deleted,
        zust_landesbehoerde,
        am_enr,
        am_pnr,
        amf_meldung_status,
        art_der_zustaendigkeit,
        art_der_zustaendigkeit_sonst
    FROM "AMF_VORGANG_HIST"
    WHERE id_vorgang = :P46_ID_VORGANG
);



case when instr(mime_type, '/x-bzip') > 0 or  instr(mime_type, '/x-bzip2') > 0 or instr(mime_type, '/zip') > 0 
then 'fa file-archive-o'
case when instr(mime_type, 'audio/') > 0
then 'fa file-audio-o'
case when instr(mime_type, '/javascript') > 0 or instr(mime_type, '/json') > 0 or instr(mime_type, '/css') > 0 or instr(mime_type, 'sql') > 0 or instr(mime_type, 'java') > 0
then 'fa file-code-o'
case when instr(mime_type, '/vnd.ms-excel') > 0 or instr(mime_type, '/vnd.openxmlformats-officedocument.spreadsheetml.sheet') > 0
then 'fa file-excel-o'
case when instr(mime_type, 'image/') > 0
then 'fa file-image-o'
case when instr(mime_type, 'application/pdf') > 0
then 'fa file-pdf-o'
case when instr(mime_type, 'application/vnd.ms-powerpoint') > 0 or instr(mime_type, 'application/vnd.openxmlformats-officedocument.presentationml.presentation') > 0
then 'fa file-powerpoint-o'
css, csv, text/ .rtf 	Rich Text Format (RTF) 	application/rtf
case when instr(mime_type, '/css') > 0 or case when instr(mime_type, '/csv') > 0 or case when instr(mime_type, '/rtf') > 0 case when instr(mime_type, 'text/') > 0
then 'fa file-text-o'
case when instr(mime_type, 'video/') > 0
then 'fa file-video-o'
case when instr(mime_type, 'application/x-abiword') > 0 or instr(mime_type, 'application/msword') > 0 or instr(mime_type, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document') > 0 
then 'fa file-word-o'
else 'fa file-o'
end as mime_icon



SELECT 
    e.ID,
    e.ID_VORGANG,
    nvl(e.MELDENDE_BEHOERDE, :LOGIN_RAS_DOMAIN) as MELDENDE_BEHOERDE,
    dbms_lob.getlength(e.DATEIINHALT)||' Bytes' as DATEIGROESSE,
    e.DATEINAME,
    e.DOKUMENTEN_INHALT,
    e.MIMETYPE,
    '<img src="'||apex_util.get_blob_file_src('P47_ICON', i.icon_id)||'" style="width:32px; height:32px;" alt="'||i.ICON_FILE_NAME||'"/>' as ICON_DISPLAY,
    I.ICON_ID,
    e.USER_ID,
     case when instr(mimetype, '/x-bzip') > 0 or  instr(mimetype, '/x-bzip2') > 0 or instr(mimetype, '/zip') > 0 
    then 'fa file-archive-o'
    when instr(mimetype, 'audio/') > 0
    then 'fa file-audio-o'
    when instr(mimetype, '/javascript') > 0 or instr(mimetype, '/json') > 0 or instr(mimetype, '/css') > 0 or instr(mimetype, 'sql') > 0 or instr(mimetype, 'java') > 0
    then 'fa file-code-o'
    when instr(mimetype, '/vnd.ms-excel') > 0 or instr(mimetype, '/vnd.openxmlformats-officedocument.spreadsheetml.sheet') > 0
    then 'fa file-excel-o'
    when instr(mimetype, 'image/') > 0
    then 'fa fa-file-image-o'
    when instr(mimetype, 'application/pdf') > 0
    then 'fa file-pdf-o'
    when instr(mimetype, 'application/vnd.ms-powerpoint') > 0 or instr(mimetype, 'application/vnd.openxmlformats-officedocument.presentationml.presentation') > 0
    then 'fa file-powerpoint-o'
    when instr(mimetype, '/css') > 0 or  instr(mimetype, '/csv') > 0 or instr(mimetype, '/rtf') > 0  or instr(mimetype, 'text/') > 0
    then 'fa file-text-o'
    when instr(mimetype, 'video/') > 0
    then 'fa file-video-o'
    when instr(mimetype, 'application/x-abiword') > 0 or instr(mimetype, 'application/msword') > 0 or instr(mimetype, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document') > 0 
    then 'fa file-word-o'
    else 'fa file-o'
    end as mime_icon
FROM "BOB_LAENDER_ROW_DOKUMENTE" e left outer join "MIME_TYPE_ICONS" i
ON (e.MIMETYPE = I.MIME_TYPE)
WHERE e.ID_VORGANG = :P47_ID_VORGANG
AND e.RAS_MELDER_ID = :P47_RAS_MELDER_ID
AND e.DELETED is null;