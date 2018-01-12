SELECT * FROM dba_network_acls;
--
--begin
--dbms_network_acl_admin.drop_acl (
--acl => '/sys/acls/smtp_permissions.xml' -- or any other name
--);
--end;
--/

-- create ACL
begin
dbms_network_acl_admin.create_acl (
acl => '/sys/acls/smtp_permissions.xml', -- or any other name
description => 'SMTP Access',
principal => 'APXUSR', -- the user name trying to access the network resource
is_grant => TRUE,
privilege => 'connect',
start_date => null,
end_date => null
);
end;
/

commit;

begin
DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl => 'smtp_permissions.xml',
principal => 'APXUSR',
is_grant => true,
privilege => 'connect');
end;
/

commit;

begin
DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl => '/sys/acls/http_permissions.xml',
principal => 'APXUSR',
is_grant => true,
privilege => 'connect');
end;
/

begin
  dbms_network_acl_admin.assign_acl(
  acl  => '/sys/acls/smtp_permissions.xml',
  host => 'localhost'
  );
  commit;
end;
/

begin
  dbms_network_acl_admin.assign_acl(
  acl  => '/sys/acls/smtp_permissions.xml',
  host => 'ol7'
  );
  commit;
end;
/


begin
  dbms_network_acl_admin.assign_acl(
  acl  => '/sys/acls/smtp_permissions.xml',
  host => 'securesmtp.t-online.de'
  );
  commit;
end;
/

commit;


SELECT * FROM dba_network_acl_privileges
where principal ='APXUSR';

grant execute on utl_smtp to apxusr;
