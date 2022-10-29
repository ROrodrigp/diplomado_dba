connect sys/system2 as sysdba

prompt deteniendo la instancia 
shutdown immediate

define backup_dir='/home/oracle/backup/modulo-03'
prompt moviendo archivos a respaldo seguro
!mkdir -p &backup_dir

prompt moviendo spfile y pfile 
!mv $ORACLE_HOME/dbs/spfilergpdip02.ora &backup_dir
!mv $ORACLE_HOME/dbs/initrgpdip02.ora &backup_dir

prompt Moviendo un solo archivo de control 
!mv /unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/control01.ctl &backup_dir

prompt Moviendo un archivo redo log 
!mv /unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo01a.log &backup_dir
!mv /unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo01b.log &backup_dir
!mv /unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo01c.log &backup_dir
 
prompt Moviendo datafiles 
!mv $ORACLE_BASE/oradata/RGPDIP02/system01.dbf &backup_dir
!mv $ORACLE_BASE/oradata/RGPDIP02/users01.dbf &backup_dir


Prompt mostrando archivos en el directorio de respaldos (verificar 8 archivos)
!ls -lh &backup_dir

Pause [Archivos en directorio de respaldos, enter para continuar]

prompt intentando iniciar instancia modo nomount 
startup nomount 

Pause [Enter para corregir y reintentar]
prompt restaurando archivos de parametros 
!mv &backup_dir/spfilergpdip02.ora $ORACLE_HOME/dbs/
!mv &backup_dir/initrgpdip02.ora $ORACLE_HOME/dbs/

Prompt iniciando instancia 
startup nomount
Pause [Se corrigio el error? Enter para continuar]

Prompt Intentando pasar al modo mount 
alter database mount;

Pause [Enter para corregir y reintentar]
prompt restaurando el archivo de control 
!mv &backup_dir/control01.ctl /unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/

Prompt cambiando al modo mount 
alter database mount;

Pause [Se corrigo el error? Enter para continuar]

prompt intentar pasar al modo open 
alter database open;

pause [Enter para restaurar datafile del tablespace system]
prompt restaurando datafile para el tablespace system
!mv &backup_dir/system01.dbf $ORACLE_BASE/oradata/RGPDIP02/

prompt intentando abrir nuevamente
alter database open;

pause [Se corrigio el error? Enter para restaurar datafile del tablespace user]
!mv &backup_dir/users01.dbf $ORACLE_BASE/oradata/RGPDIP02/

prompt intentando abrir nuevamente
alter database open;

pause [Se corrigio el error? Enter para restaurar Redo Logs]
!mv &backup_dir/redo01a.log /unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/
!mv &backup_dir/redo01b.log /unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/
!mv &backup_dir/redo01c.log /unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/

prompt intentando iniciar nuevamente en modo OPEN, requiere autenticar y volver a iniciar
connect sys/system2 as sysdba
startup open; 

prompt Mostrando status 
select status from v$instance;

Pause [La base ha regresado a la normalidad? Enter para terminar]
exit