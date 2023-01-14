prompt Habilitando el modo archive 
prompt autenticando como sysdba 
connect sys/system2 as sysdba 

prompt 1 Respaldar al spfile 
create pfile from spfile;

prompt 2 Configurando parametros 
--proces ARCn 
alter system set log_archive_max_processes=5 scope spfile;
--formato del archivo 
alter system set log_archive_format='arch_rgpdip02_%t_%s_%r.arc' scoppe spfile;
--configuracion de dos copias 
alter system set log_archive_dest_1='LOCATION=/unam-diplomado-bd/disk-04/RGPDIP02/arclogs MANDATORY' scope spfile;
alter system set log_archive_dest_2='LOCATION=/unam-diplomado-bd/disk-05/RGPDIP02/arclogs' scope spfile;

--copias obligatorias
alter system set log_archive_min_succeed_dest=1 scope spfile;

prompt mostrando cambios 
show spparameter log_archive_max_processes
show spparameter log_archive_format
show spparameter log_archive_dest_1
show spparameter log_archive_dest_2 
show spparameter log_archive_min_succeed_dest

pause Revisar [Enter] para continuar

prompt 3 Reiniciando en modo mount 
--Adicional se deberia hacer un backup completo de la BD

shutdown immediate
startup mount 

pause [Enter] para cambiar a modo archive 
alter database archivelog;

--Aqui se deberia hacer un full backup 

prompt 4 Abriendo BD en modo open 
alter database open;

prompt 5 Comprobando modo archive 
archive log list 

prompt 6 Respaldar al spfile 
create pfile from spfile;

prompt 7 
!ps -ef | grep ora_arc