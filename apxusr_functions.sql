--- APEX User Management Admin Function ---


-----------------------------------------------------------------------------------------------------
--
-- Stefan Obermeyer 05.2017
--
-- 08.05.2017 SOB created
-- 02.06.2017 SOB updated IS_SYS_* functions
-- 04.06.2017 SOB added no_data_found for all select intos
--
-----------------------------------------------------------------------------------------------------

-- Is User a System User
create or replace function "IS_SYS_USER" (
p_username in varchar2
) return boolean
is
l_is_user pls_integer;
begin
  select 1 into l_is_user
  from "APEX_APP_SYS_USERS"
  where app_id = v('APP_ID')
      and upper(trim(app_username)) = upper(trim(p_username));
  if (l_is_user = 1) then
    return true;
  else
    return false;
  end if;
exception when no_data_found then
  return false;
end;
/


-- Is it a System Role
create or replace function "IS_SYS_ROLE" (
p_rolename in varchar2
) return boolean
is
l_is_role pls_integer;
begin
  select 1 into l_is_role
  from "APEX_APP_SYS_ROLES"
   where app_id = v('APP_ID')
      and upper(trim(app_rolename)) = upper(trim(p_rolename));
  if (l_is_role = 1) then
    return true;
  else
    return false;
  end if;
exception when no_data_found then
  return false;
end;
/


-- Is it the Code of a System User
create or replace function "IS_SYS_CODE" (
p_sys_code in varchar2
) return boolean
is
l_is_sys_code pls_integer;
begin
  select 1 into l_is_sys_code
  from "APEX_APP_SYS_BUILTINS"
   where app_id = v('APP_ID')
      and upper(trim(app_builtin_code)) = upper(trim(p_sys_code));
  if (l_is_sys_code = 1) then
    return true;
  else
    return false;
  end if;
exception when no_data_found then
  return false;
end;
/


-- Is it the Code of a System User
create or replace function "GET_SECURITY_LEVEL" (
p_name in varchar2,
p_scope in varchar2 := 'USER' -- or ROLE
) return number
is
l_seclev number := 0;
begin
  if upper(p_scope) = 'USER' then
    select max_security_level
    into l_seclev
    from "APEX_USERS"
    where upper(trim(app_username)) = upper(trim(p_name));
  elsif upper(p_scope) = 'ROLE' then
    select app_role_id
    into l_seclev
    from "APEX_ROLES"
    where upper(trim(app_rolename)) = upper(trim(p_name));
  else
    l_seclev := 0;
  end if;
return l_seclev;
exception when no_data_found then
  return 0;
end;
/


-- Is it the Code of a System User or Role
create or replace function "GET_CODE_SECURITY_LEVEL" (
p_code in varchar2,
p_scope in varchar2 := 'USER' -- or ROLE
) return number
is
l_seclev number := 0;
begin
  if upper(p_scope) = 'USER' then
    select max_security_level
    into l_seclev
    from "APEX_USERS"
    where upper(trim(app_user_code)) = upper(trim(p_code));
  elsif upper(p_scope) = 'ROLE' then
    select app_role_id
    into l_seclev
    from "APEX_ROLES"
    where upper(trim(app_role_code)) = upper(trim(p_code));
  else
    l_seclev := 0;
  end if;
return l_seclev;
exception when no_data_found then
  return 0;
end;
/

-- Wrapper Function for System User
create or replace function "GET_USER_SECURITY_LEVEL" (
p_name in varchar2)
return number
is
begin
  return "GET_SECURITY_LEVEL" (p_name, 'USER');
end;
/

-- Wrapper Function for System Roles
create or replace function "GET_ROLE_SECURITY_LEVEL" (
p_name in varchar2)
return number
is
begin
  return "GET_SECURITY_LEVEL" (p_name, 'ROLE');
end;
/

-- Wrapper Function for System Role Codes
create or replace function "GET_ROLE_CODE_SECURITY_LEVEL" (
p_code in varchar2)
return number
is
begin
  return "GET_CODE_SECURITY_LEVEL" (p_code, 'ROLE');
end;
/


-- User has Role?
create or replace function "HAS_ROLE" (
p_name in varchar2,
p_role in varchar2,
p_strict in boolean default false)
return boolean
is
l_has_role pls_integer := 0;
l_role_sec_level pls_integer;
l_user_sec_level pls_integer;
l_result boolean;
begin
 -- we want to check if the exact role is given
    select 1 into l_has_role
    from "APEX_USER_ROLES"
    where upper(trim(username)) = upper(trim(p_name))
    and upper(trim(role_name)) = upper(trim(p_role));
  if l_has_role = 1 then
    l_result := true;
  else
    l_result := false;
  end if;
return l_result;
end;
/


-- is User
create or replace function "IS_USER" (
p_name in varchar2,
p_role in varchar2)
return boolean
is
begin
  return "HAS_ROLE" (p_name, p_role);
end;
/

