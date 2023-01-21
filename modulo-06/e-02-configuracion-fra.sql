set verify off

define syslogon='sys/system2 as sysdba'

prompt Conectando como sys
connect &syslogon

prompt 1 Verificando el parametro DB_RECOVERY
show parameter db_recovery;

prompt 2 Verificando modo archive log habilitado 
archive log list;

prompt 3 Especificando tamaño de la fra y ubicacion
alter system set db_recovery_file_dest_size=20G scope=both;
alter system set db_recovery_file_dest='/unam-diplomado-bd/fast-recovery-area' scope=both;

prompt 4 Reiniciando la instancia en modo mount 
shutdown immediate
startup mount 

prompt 5 Configurando el periodo de retencion para flashback 
alter system set db_flashback_retention_target=1440 scope=both;

prompt 6 Habilitando el modo flashback
alter database flashback on;

prompt 7 Abriendo la base de datos
alter database open;

prompt 8. Verificando modo flashback activo
select flashback_on from v$database;

prompt 9 Mostrando el tiempo de retencion de datos undo 
show parameter undo_ret

prompt Modificando el tiempo de retencion de datos undo 
alter system set undo_retention=1800;

