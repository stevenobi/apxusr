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
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('93','DE345675423','Testfall1','BFARM',to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','7',null,'<p>viel zu sagen gibt es hier nicht</p>
',to_date('21.12.2017 11:50:46','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('04.12.2017 15:31:15','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'ASTAPECT-KODEIN',null,'ASTA Medica GmbH','Blo2','Bla1',to_date('01.12.2022 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.08.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),'6','Verpackung',null,'Codeinphosphat-Hemihydrat, Ephedrinhydrochlorid, Sulfogaiacol',null,null,'Hessen','0000371','3000621','1','�rtlicher Vertreter',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('59','DE2345678','Test','BFARM',to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('25.07.2017 10:35:20','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('60','DE1324','NENEEN','BFARM',to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('25.07.2017 10:47:48','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('61','fzfhzj','cgh','BFARM',to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('25.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('25.07.2017 14:40:01','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('62','DE879','TestBez','BW - Baden-Wuerttemberg',to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 11:51:07','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA',null,null,null,null,null,null,null,'Avamigran N',null,'AWD.pharma GmbH',null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('63','DE12345','Fall 3','BFARM',to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 14:03:52','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('64','xxy','Xeplion','BFARM',to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 14:07:30','DD.MM.YYYY HH24:MI:SS'),'MWITTSTOCK',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('87','DE00007','Test','BFARM',to_date('02.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('02.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','10',null,'<p>Bemerk</p>
',to_date('05.12.2017 15:31:39','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('02.11.2017 11:16:28','DD.MM.YYYY HH24:MI:SS'),'ADMIN','hshshs','hshshs',null,'hshshsh',null,'1','1','Aspirin Nasenspray',null,'Bayer Vital GmbH','Aspirin Nasenspray 400ml','Aspirin N�senspray 400ml',to_date('01.09.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.09.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'2','Oxymetazolinhydrochlorid','APEX_PUBLIC_USER',to_date('05.12.2017 15:31:39','DD.MM.YYYY HH24:MI:SS'),null,'2137607','8011204','2',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('47','DE12345','Harvoni 3','BFARM',to_date('19.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('19.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,'<p>die Inspektoren sind nicht miteinander verwandt, sondern kommen aus demselben Dorf!</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('19.07.2017 18:33:08','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Unterm�ller-Krainersohn','Unterkrainer-M�llersohn',null,'Neo Goodheart',to_date('10.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','1','Harvoni 90 mg/400 mg','EU/1/14/958/002','Gilead Sciences International Limited',null,'GHERT32DE',null,to_date('01.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'6','alles total falsch!','3',null,null,null,'Landeskriminalamt Oberbayern',null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('48','DE3456','TAPESTRY','BFARM',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('19.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,'<p>so was hat die Welt noch nicht gesehen.</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('19.07.2017 18:50:54','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Unterm�ller','Huber',null,'Sr. Rodrig�z',to_date('10.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','0','Harvoni 90 mg/400 mg','EU/1/14/958/002','Gilead Sciences International Limited','HSFRDE34','HGDSER34',to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'2','Ledipasvir, Sofosbuvir',null,null,'Landeskriminalamt Niedersachsen','2711769','8030549','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('88','5665475','657457','543245',to_date('07.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('07.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('07.11.2017 20:19:49','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('89','DE1239780','Norditalien','BFARM',to_date('08.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('08.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,null,to_date('11.12.2017 17:34:02','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('08.11.2017 14:59:43','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'Harvoni','EU/1/14/958/002','Gilead Sciences International Limited',null,null,to_date('01.12.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.11.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,null,'Ledipasvir, Sofosbuvir',null,null,null,'2711769','8030549','1','Zulassungsinhaber',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('14','DE123456','Harvoni','BFARM - Bundesinstitut f�r Arzneimittel und Medizinprodukte (BfArM)',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:22:36','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('15','DE34567','Cement','BVL - Bundesamt f�r Verbraucherschutz und Lebensmittelsicherheit (BVL)',to_date('15.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 15:28:33','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:25:38','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('16','DE3455677','Chaos in Hamburg','BKA - Bundeskriminalamt',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','2','17','<p>Voll die <strong><u>Bemerkung!!!</u></strong></p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:27:25','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Oberm�ller','Unterkrainer',null,'Mr. Smith',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','1','Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Milinda GmbH',null,'DETRAE123',null,to_date('31.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'3',null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('17','DE2345','Aspirin','BFARM - Bundesinstitut f�r Arzneimittel und Medizinprodukte (BfArM)',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,'17','<p>Bemrk</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:31:52','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Oberm�ller','Unterkrainer',null,'Mr. Smith',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','1','Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Gilead Sciences International Limited',null,'SEFER3453',null,to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'1',null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('18','DE234556','Harvoni','BFARM - Bundesinstitut f�r Arzneimittel und Medizinprodukte (BfArM)',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','3','18','<p>Bemrrk</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:36:05','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Oberm�ller','UNterkrainer',null,'Mr. Smith',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','1','Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Milinda GmbH',null,'BFER23',null,to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,'3',null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('19','DE23456','NHEHEHE','BFARM - Bundesinstitut f�r Arzneimittel und Medizinprodukte (BfArM)',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','2','17',null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:40:03','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Oberm�ller','UNterkrainer',null,'Smith',null,'1','1','Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Milinda GmbH','JDJDJDJ','GSGSSG',to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'1',null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('20','DE12345','BAGAGA','BFARM',to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('18.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,'3','<p>Bemerkl</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('18.07.2017 19:44:42','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN','Oberm�ller','Unterbayer',null,'M�ller',to_date('10.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1','1','Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Gilead Sciences International Limited','HFHFH','BGGER45',to_date('01.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,'3',null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('50','454634356','Test','Test',to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('20.07.2017 09:05:31','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'Aspirin Nasenspray',null,'Bayer Vital GmbH',null,null,null,null,null,null,null,'Oxymetazolinhydrochlorid',null,null,null,'2137607','8011204','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('51','DE222','Test','BFARM',to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('20.07.2017 09:32:30','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('49','DE1239','Test','BFARM',to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('20.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,'<p>Status der Verifizierung angelegt</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('20.07.2017 08:51:18','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA','Lisa M�ller','Max Mustermensch',null,null,null,'1','0','CODEINE UND ASPIRIN UND PHENACETIN TABLETTEN',null,'Holsten Pharma GmbH',null,null,null,null,'6','Testf�lschung','2','Acetylsalicyls�ure (Ph.Eur.), Codeinphosphat-Hemihydrat, Phenacetin',null,null,null,'0912712','3001738','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('53','1234','Test Fall','BKA - Bundeskriminalamt',to_date('21.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('21.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('21.07.2017 11:06:20','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('54','DE12345','Neuer Fall','BFARM',to_date('30.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('21.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('24.07.2017 10:43:36','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('55','DE3425','Ganz Neuer Fall','BFARM',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('24.07.2017 13:38:20','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('56','DE12233','Ganz Neuer Fall','BFARM',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 15:15:23','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('24.07.2017 14:49:50','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('57','DE2343343','Ganz Ganz Neuer Fall','BFARM',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('24.07.2017 15:15:29','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('58','GERER','HDHDH','BFARM',to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('24.07.2017 17:29:30','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('83','123','TestKlose','BFARM',to_date('19.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('19.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','12',null,'<p>ecdfsd</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('19.09.2017 14:56:39','DD.MM.YYYY HH24:MI:SS'),'TKLOSE','frgase','sefg',null,'esggvdfs',null,null,'1','Aspirine Direkt','vdsfbv','cvsef','sergxcvyed','fresfagfe',null,null,null,null,'2','Acetylsalicyls�ure (Ph.Eur.)',null,null,'Bayern','2140249','3216120','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('67','DE1','Diebstahl IT','BB - Brandenburg',to_date('24.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,'<p>fhhfsdhdsflsdlhdfsljhsjlh&ouml;.</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 15:12:10','DD.MM.YYYY HH24:MI:SS'),'TKLOSE','Dr. mmm','dddd',null,'ddd; jujj; zhhh',null,null,'1','diverse','EU/1/11/672/002','diverse','xx5','xx5',to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'6','unbekannt','2','diverse',null,null,'Bezirksregierung D�sseldorf','2750363','8090132','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('75','0815','Testf�lschung','Apotheke zur F�lschung',to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('31.07.2017 15:56:36','DD.MM.YYYY HH24:MI:SS'),'NPAESCHKE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('85','5',null,null,to_date('27.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('27.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('27.09.2017 13:10:33','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('86','DE2017-001','QD2017-149/H/Sprycel/ falsification','EMA',to_date('28.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('29.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'36',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('29.09.2017 17:02:57','DD.MM.YYYY HH24:MI:SS'),'GOMLOR',null,null,null,null,null,null,'1','Sprycel','EU/1/06/363/003','Abacus',null,'AAK7575',to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.10.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),'4',null,'3',null,null,null,'Bayern',null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('90','DE000999','Testfaelschung','BFARM',to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('04.12.2017 10:46:57','DD.MM.YYYY HH24:MI:SS'),'ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('91','DE0123454','Testfall','BFARM',to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','9',null,'<p>Bemerk</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('04.12.2017 10:54:37','DD.MM.YYYY HH24:MI:SS'),'ADMIN',null,null,null,null,null,null,null,'ASPIRIN-PHENACETIN-CODEIN',null,'Delta Distribution GmbH',null,null,to_date('01.12.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.12.2018 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1',null,null,'Acetylsalicyls�ure (Ph.Eur.), Codeinphosphat-Hemihydrat, Phenacetin',null,null,null,'0612513','3000288','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('92','DE12345678','Test','BFARM',to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('04.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','12',null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('04.12.2017 11:23:04','DD.MM.YYYY HH24:MI:SS'),'ADMIN',null,null,null,null,null,null,null,'Aspirine Direkt',null,'kohlpharma GmbH',null,null,null,null,'6',null,null,'Acetylsalicyls�ure (Ph.Eur.)',null,null,null,'2140249','3216120','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('11','Harvoni','Harvoni','Regierungspr�sidium Oberbayern',to_date('07.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('07.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','2','1','m�glicherweise gef�lschte Tabletten in Apotheke entdeckt anhand von Farbabweichung entdeckt(wei� statt ockerfarben)',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('07.07.2017 13:16:04','DD.MM.YYYY HH24:MI:SS'),'NPAESCHKE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('1','NEU12345DEF','Harvoni�','BfArM',to_date('12.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('12.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','8','3','Die gef�lschten Tabletten sind nicht wie �blich orange, sondern wei� und sollten keinesfalls eingenommen werden.',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('28.06.2017 19:06:16','DD.MM.YYYY HH24:MI:SS'),'INTERN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('2','NEU12341DE','Lore Ipsum (c)','LKA',to_date('07.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'68',null,'1','Where does it come from?
Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.
And everything else is FAKE NEWS!',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('28.06.2017 19:06:16','DD.MM.YYYY HH24:MI:SS'),'INTERN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('84','2',null,null,to_date('27.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('27.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('27.09.2017 09:17:57','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'dewdf',null,null,null,null,to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('21','1','Test von Herrn Klose','Italien',to_date('19.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('19.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('19.07.2017 08:53:29','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('94','DE1234567','Testfall','BFARM',to_date('05.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('05.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','7',null,null,to_date('15.12.2017 14:33:35','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('05.12.2017 18:05:36','DD.MM.YYYY HH24:MI:SS'),'ADMIN',null,null,null,null,null,null,null,'CALCIDURAN 100',null,'ASTA Medica GmbH','CALCIDU-01B','CALCID-B001',to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,null,'Calciumhydrogenphosphat, Colecalciferol-Cholesterol',null,null,null,'0000342','3000621','1','Freitext','Unbekannte Zust�ndigkeit');
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('9','NEUNEU1234','Neu','BVL',to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('03.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,'1','<p>alles neu war gestern</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('03.07.2017 15:17:25','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Harvoni 90 mg/400 mg Filmtabletten - OP(3x28)','EU/1/14/958/002','Gilead Sciences International Limited',null,null,null,null,null,null,null,'Ledipasvir, Sofosbuvir',null,null,null,'2711769','8030549','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('95','QD2017-0001','AVACAN BW','BW - Baden-Wuerttemberg',to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','7',null,null,to_date('15.12.2017 17:19:22','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('11.12.2017 11:25:31','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'AVACAN',null,'ASTA Medica GmbH',null,null,to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'3',null,null,'Camylofindihydrochlorid',null,null,null,'0000299','3000621','1','Zulassungsinhaber',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('96','RAS2017-007','TEST01','BE - Berlin',to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,'<p>Bemerkungen zu dem Fall</p>
',to_date('11.12.2017 16:28:23','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('11.12.2017 12:27:36','DD.MM.YYYY HH24:MI:SS'),'JDUSSA',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('99','QD2017-183','Arzneimittel Xermelo 250 mg Filmtabletten der Firma Ipsen Innovation in FR - (expiry date and lot number inversion) - StN AT','EMA',to_date('08.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('12.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,'<p>Wird bearbeitet!</p>
',to_date('14.12.2017 10:52:54','DD.MM.YYYY HH24:MI:SS'),'JDUSSA',to_date('12.12.2017 08:19:33','DD.MM.YYYY HH24:MI:SS'),'JDUSSA',null,null,null,null,null,null,null,'EMEND 80 mg Hartkapseln - OP(5x1)','EU/1/03/262/003','Merck Sharp','XY-21555','XY-20147',to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'1',null,null,'Aprepitant',null,null,null,'2702452','3316407','1','Zulassungsinhaber',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('100','DE000100','Testfall34','BMEL',to_date('22.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('22.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','9',null,null,to_date('22.12.2017 09:38:56','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('22.12.2017 09:35:30','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Echter Warthaer Balsam',null,'Berg-Apotheke Othfresen','NRTAE2','NRET45',to_date('01.06.2020 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.02.2021 00:00:00','DD.MM.YYYY HH24:MI:SS'),'3',null,null,'Alantwurzelstock, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Aloe, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Benzoe, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Bitterkleebl�tter, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Campher, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Enzianwurzel, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Galgantwurzelstock, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Johanniskraut, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Kalmuswurzelstock, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Meisterwurzwurzelstock, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Myrrhe, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Rhabarberwurzel, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Sassafraswurzelholz, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Schwertlilienwurzelstock, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Tausendg�ldenkraut, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Weihrauch, FE mit Ethanol/Ethanol-Wasser (%-Angaben), Zaunr�be, FE mit Ethanol/Ethanol-Wasser (%-Angaben)',null,null,'Landeskriminalamt Niedersachsen','0000738','0091824','1','Zulassungsinhaber',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('8','CGN4711','K�lle','erwr',to_date('29.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('29.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','4','1','jhsdjfhsdjkfhsdjfh',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('29.06.2017 13:19:44','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('76','DE12345','Neu','BFARM',to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','12',null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('31.07.2017 17:55:24','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Milinda GmbH','GE4321','gr34215',to_date('01.06.2025 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.05.2022 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,null,'Ledipasvir, Sofosbuvir',null,null,'Bezirksregierung D�sseldorf','2750150','3078936','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('80','DE111','fdfd','BVL',to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 15:13:42','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('02.08.2017 08:54:12','DD.MM.YYYY HH24:MI:SS'),'MMULIKITA',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('70','DE2453','Neuer Fall','BFARM',to_date('05.06.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 17:58:10','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Harvoni 90 mg/400 mg Filmtabletten - OP(3x28)','EU/1/14/958/002','Gilead Sciences International Limited',null,null,null,to_date('01.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,'Ledipasvir, Sofosbuvir',null,null,null,'2711769','8030549','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('71','DE23456','Harvoni2','BFARM',to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('26.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'54',null,null,'<p>bpuibdcpIUB&Uuml;OKINc</p>
',to_date('05.12.2017 14:20:16','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('26.07.2017 18:57:52','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Harvoni 90 mg/400 mg Filmtabletten - OP28','EU/1/14/958/001','Gilead Sciences International Limited',null,null,to_date('01.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.09.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,'Ledipasvir, Sofosbuvir',null,null,null,'2711768','8030549','2',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('72','DE1234','Beizeichnung','BFARM',to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('31.07.2017 11:40:48','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('73','DE','Beu','BFARM',to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 16:29:30','DD.MM.YYYY HH24:MI:SS'),'INTERN',to_date('31.07.2017 11:42:15','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'INTERN',to_date('05.12.2017 16:29:30','DD.MM.YYYY HH24:MI:SS'),null,null,null,'2',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('74','DE1234','Son Ding','BFARM',to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('31.07.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('05.12.2017 16:53:22','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('31.07.2017 11:58:48','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'Aspirinuom',null,'Bayer',null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('81','DE000081','Arzneimitteldiebstahl in K�ln','NW - Nordrhein-Westfalen',to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,'<p>Alle betroffenen AM sind als F&auml;lschung von Markt zu nehmen.</p>
',to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('02.08.2017 09:22:18','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'mehrere','mehrere','mehrere','mehrere','mehrere',null,null,'1',null,null,'mehrere',null,null,'mehrere',null,null,'1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('82','ghjkfkzzf',null,null,to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('02.08.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','10',null,null,to_date('05.12.2017 14:08:29','DD.MM.YYYY HH24:MI:SS'),'ADMIN',to_date('02.08.2017 09:34:33','DD.MM.YYYY HH24:MI:SS'),'TKLOSE',null,null,null,null,null,null,null,'Aspirin Nasenspray',null,null,null,null,to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.01.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),null,null,null,'Oxymetazolinhydrochlorid',null,null,null,'2137607','8011204','1',null,null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('97','DE1234','Shanghai Fall','BFARM',to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37','2',null,null,to_date('15.12.2017 17:05:13','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('11.12.2017 17:33:17','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,'CiNU I',null,'Bristol Arzneimittel GmbH   [HIST]','YIAN01','YOIAN00',to_date('01.01.2020 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('01.02.2021 00:00:00','DD.MM.YYYY HH24:MI:SS'),'5',null,null,'Lomustin',null,null,null,'0027878','3336692','1','�rtlicher Vertreter',null);
Insert into AMF_VORGANG (ID_VORGANG,VORGANGSNUMMER,BEZEICHNUNG,MELDENDE_STELLE,EINGANGSDATUM,ERSTELLUNGSDATUM,STAAT_ID,BUNDESLAND_ID,BUNDESOBERBEHOERDE,BEMERKUNG,MODIFIED,MODIFIED_BY,CREATED,CREATED_BY,BEARB_INSPEKTOR,BETEIL_INSPEKTOR,STELLUNGNAHME_ANGEFORDERT,STUFENPLANBEAUFTRAG,RISIKO_STELLUNGNAHME,CHARGEN_MAENGEL,FALL,AM_NAME,AM_ZNR,AM_PU,AM_CHRG_ORIG,AM_CHRG_FAELSCH,AM_CHRG_HLTB,AM_CHRG_F_HLTB,ART_DER_FAELSCHUNG,FAELSCHUNGSART_SONSTIGE,AM_CHRG_STATUS,AM_WIRKSTOFF,DELETED_BY,DELETED,ZUST_LANDESBEHOERDE,AM_ENR,AM_PNR,AMF_MELDUNG_STATUS,ART_DER_ZUSTAENDIGKEIT,ART_DER_ZUSTAENDIGKEIT_SONST) values ('98','DE1223454','Schleswig Container','BFARM',to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),to_date('11.12.2017 00:00:00','DD.MM.YYYY HH24:MI:SS'),'37',null,null,null,to_date('14.12.2017 15:40:41','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',to_date('11.12.2017 17:54:05','DD.MM.YYYY HH24:MI:SS'),'TRIVADIS_ADMIN',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
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



------------------------------------------------------------------------------------
---

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
	
	

#WORKSPACE_IMAGES#js/BFARM_FOOTER.min.js?v=20180118.#APEX_VERSION#
#WORKSPACE_IMAGES#js/validate/jquery.validate.min.js?v=20180129.#APEX_VERSION#
#WORKSPACE_IMAGES#js/validate/messages_de.min.js?v=20180129.#APEX_VERSION#

#WORKSPACE_IMAGES#css/validate/screen.min.css?v=20180129.#APEX_VERSION#
#WORKSPACE_IMAGES#css/validateForm.min.css?v=20180129.#APEX_VERSION#


ALTER TABLE "RAS"."APX$USER_REG" DROP CONSTRAINT "APX$USREG_APP_USER_ID_FK";
ALTER TABLE "RAS"."APX$USER_REG" ADD CONSTRAINT "APX$USREG_APP_USER_ID_FK" FOREIGN KEY ("APX_APP_USER_ID")
REFERENCES "RAS_INTERN"."BFARM_APEX_APP_USER" ("APP_USER_ID") ON DELETE CASCADE ENABLE;



create or replace procedure "BFARM_RAS_SOFT_DELETE" (
p_table in varchar2,
p_id number,
p_msg in varchar2 :=' können nicht gelöscht werden!',
p_new_status varchar2 := 'LOCKED'
) is
pragma autonomous_transaction;
l_status_id pls_integer;
l_msg varchar2(1000);
begin
    select app_status_id into l_status_id
    from "BFARM_APEX_APP_STATUS"
    where app_status = upper(nvl(p_new_status, 'LOCKED'));
    if (upper(p_table) = 'BFARM_APEX_APP_USER') then
        l_msg := 'Benutzer'||p_msg;
        commit;
        update  "BFARM_APEX_APP_USER"
        set deleted  = sysdate,
              deleted_by  = nvl(v('APP_USER'), user),
              app_user_status_id = l_status_id
        where APP_USER_ID = p_id;
        delete from "RAS"."APX$USER_REG"
        where apx_app_user_id =  p_id;
        commit;
    elsif  (upper(p_table) = 'RAS_DOMAINEN') then
        l_msg := 'Domainen'||p_msg;
        commit;
        update  "BFARM_APEX_APP_USER"
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
/


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
