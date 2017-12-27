set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_default_workspace_id=>1831840297345167
);
end;
/
begin
wwv_flow_api.remove_restful_service(
 p_id=>wwv_flow_api.id(6001454321700526)
,p_name=>'apxusr'
);
 
end;
/
prompt --application/restful_services/apxusr
begin
wwv_flow_api.create_restful_module(
 p_id=>wwv_flow_api.id(6001454321700526)
,p_name=>'apxusr'
,p_uri_prefix=>'apxusr/'
,p_parsing_schema=>'APXDBA'
,p_items_per_page=>25
,p_status=>'PUBLISHED'
,p_row_version_number=>35
);
wwv_flow_api.create_restful_template(
 p_id=>wwv_flow_api.id(6001546744700527)
,p_module_id=>wwv_flow_api.id(6001454321700526)
,p_uri_template=>'us/{usrname}'
,p_priority=>0
,p_etag_type=>'HASH'
);
wwv_flow_api.create_restful_handler(
 p_id=>wwv_flow_api.id(6001624143700527)
,p_template_id=>wwv_flow_api.id(6001546744700527)
,p_source_type=>'QUERY_1_ROW'
,p_format=>'DEFAULT'
,p_method=>'GET'
,p_require_https=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select case when user_exists =  0 ',
'                  then 0 ',
'                  else user_status ',
'           end as user_status',
'from           ',
'(select count(1)             as user_exists, ',
'           max(user_status) as user_status',
' from "APXUSR"."APEX_USER_REG_STATUS"',
' where upper(trim(username)) = upper(trim(:USRNAME))',
' )',
''))
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
