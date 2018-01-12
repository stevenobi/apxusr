select * from dba_profiles;
select * from dba_roles;
select * from dba_tablespaces;

drop user apxusr cascade;

create user apxusr
identified by "???"
profile APEXORDS
default tablespace sysaux
account unlock;

alter user apxusr quota unlimited on SYSAUX;

grant "APEX_GRANTS_FOR_NEW_USERS_ROLE" to apxusr;

begin
dbms_network_acl_admin.create_acl (
acl => 'http_permissions.xml', -- or any other name
description => 'HTTP Access',
principal => 'APXDBA', -- the user name trying to access the network resource
is_grant => TRUE,
privilege => 'connect',
start_date => null,
end_date => null
);
end;
/

begin
DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl => 'http_permissions.xml',
principal => 'APXDBA',
is_grant => true,
privilege => 'connect');
end;
/


begin
DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl => 'http_permissions.xml',
principal => 'APXDBA',
is_grant => true,
privilege => 'resolve');
end;
/

BEGIN
dbms_network_acl_admin.assign_acl (
acl => 'http_permissions.xml',
host => 'localhost', /*can be computer name or IP , wildcards are accepted as well for example - '*.us.oracle.com'*/
lower_port => null,
upper_port => null
);
END;
/

commit;

Begin
  dbms_network_acl_admin.create_acl (
    acl         => 'utl_mail.xml',
    description => 'Allow mail to be send',
    principal   => 'APXDBA',
    is_grant    => TRUE,
    privilege   => 'connect'
    );
    commit;
end;
/

begin
  dbms_network_acl_admin.add_privilege (
  acl       => 'utl_mail.xml',
  principal => 'APXDBA',
  is_grant  => TRUE,
  privilege => 'resolve'
  );
  commit;
end;
/

begin
  dbms_network_acl_admin.assign_acl(
  acl  => 'utl_mail.xml',
  host => 'securesmtp.t-online.de'
  );
  commit;
end;
/

grant execute on sys.utl_mail to apxdba;


SELECT DECODE(
DBMS_NETWORK_ACL_ADMIN.check_privilege('utl_mail.xml', 'APXDBA', 'connect'),
1, 'GRANTED', 0, 'DENIED', NULL) as "Connect",
DECODE(
DBMS_NETWORK_ACL_ADMIN.check_privilege('utl_mail.xml', 'APXDBA', 'resolve'),
1, 'GRANTED', 0, 'DENIED', NULL) as "Resolve"
FROM dual;



begin
  utl_mail.send(
  sender     => 'scott@ocorp.com',
  recipients => 'vjotimeframes.de',
  message    => 'Hello World'
  );
  commit;
end;
/


DECLARE
  c utl_smtp.connection;
BEGIN
  c := utl_smtp.open_connection(
     host => 'securesmtp.t-online.de',
     port => 25,
     secure_connection_before_smtp => FALSE);
  utl_smtp.starttls(c);
END;
/


declare
   l_body      clob;
    l_body_html clob;
begin
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
                   '<p>Please confirm your order on the <a href="' ||
                   apex_mail.get_instance_url || 'f?p=100:10">Order Confirmation</a> page.</p>' || utl_tcp.crlf ||
                   '<p>Sincerely,<br />' || utl_tcp.crlf ||
                   'The Application Express Dev Team<br />' || utl_tcp.crlf ||
                   '<img src="' || apex_mail.get_images_url || 'oracle.gif" alt="Oracle Logo"></p>' || utl_tcp.crlf ||
                   '</body></html>'; 
    apex_mail.send (
        p_to        => 's.obermeyer@t-online.de',   -- change to your email address
        p_from      => 's.obermeyer@t-onlne.de', -- change to a real senders email address
        p_body      => l_body,
        p_body_html => l_body_html,
        p_subj      => 'Reg Confirmation' );

end;
/

insert into apx$app_user_reg (app_user_email, app_id)
values(:P102_EMAIL, 100);
commit;

grant insert, select on apx$app_user_reg to apxdba;




