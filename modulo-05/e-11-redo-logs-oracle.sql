define syslogon='sys/system2 as sysdba'
define userlogon='rodrigo05/rodrigo05'
connect &syslogon
spool 'salida-e011.txt' replace;
!find /unam-diplomado-bd/disk-0*/app/oracle/oradata/RGPDIP02/redo* -name "*redo*.log" -type f -exec ls -l {} +;

-- Queries independientes del paso 2 al 4, pero completar
prompt Pasos 2 al 4
col member format a50
select * from v$logfile;
select * from v$log;

Pause [Enter] para continuar
prompt 5 Agregar nuevos grupos


prompt Creando group 4 
alter database add logfile group 4(
  '/unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo04a_60.log',
  '/unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo04b_60.log'
) size 60m blocksize 512;

alter database add logfile group 5(
  '/unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo05a_60.log',
  '/unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo05b_60.log'
) size 60m blocksize 512;

alter database add logfile group 6(
  '/unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo06a_60.log',
  '/unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo06b_60.log'
) size 60m blocksize 512;

prompt Agregar miembros
alter database add logfile member 
  '/unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo04c_60.log' to group 4;

alter database add logfile member
  '/unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo05c_60.log' to group 5;

  alter database add logfile member
  '/unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo06c_60.log' to group 6;

prompt 7. Consultar nuevamente los grupos
set linesize window
select * from v$log;

Pause Analizar [Enter] para continuar 

prompt 8. Consultar nuevamente los miembros 
col member format a50
select * from v$logfile;

prompt 9. Forzar log switch  para liberar los grupos 1,2,3
set serveroutput on
declare
  v_group number;
begin
  loop
    select group# into v_group from v$log where status = 'CURRENT';
    dbms_output.put_line('Grupo en uso: '||v_group);
    if v_group in (1,2,3) then
      execute immediate 'alter system switch logfile';
    else
      exit;
    end if;
  end loop;
end;
/

prompt 10. Confirmando el grupo actual 
set linesize window
select * from v$log;
pause Analizar y [Enter] para continuar 

prompt 11. Validando que los grupos 1 a 3 no tengan status ACTIVE 

declare
  v_count number;
begin
  select count(*) into v_count
  from v$log 
  where status = 'ACTIVE';
  if v_count > 0 then 
    dbms_output.put_line('Forzando checkpoint para sincronizar datafiles con db_buffer');
    execute immediate 'alter system checkpoint';
  end if;
end;
/

prompt 12. Confirmando que no existen grupos con status ACTIVE 
select * from v$log;
pause Analizar y [Enter] para continuar 

prompt 13. Eliminar grupos 1,2 y 3

alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;

prompt 14. Confirmando que se han eliminado los grupos 1,2 y 3
select * from v$log;
pause Analizar [Enter] para continuar, validar que todo esta bien 

Prompt 15 y 16 Eliminar los archivos via S.O. 
prompt eliminado redo logs grupo 1 
!rm /unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo01a.log
!rm /unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo01b.log
!rm /unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo01c.log

prompt eliminado redo logs grupo 2
!rm /unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo02a.log
!rm /unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo02b.log
!rm /unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo02c.log

prompt eliminado redo logs grupo 3
!rm /unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo03a.log
!rm /unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo03b.log
!rm /unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo03c.log

prompt 17. Revisar archivos esperados a nivel operativo  del S.O.
!find /unam-diplomado-bd/disk-0*/app/oracle/oradata/RGPDIP02/redo* -name "*redo*.log" -type f -exec ls -l {} +;

spool off;
exit 
