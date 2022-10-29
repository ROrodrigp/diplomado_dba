--ojo, antes de ejecutar este script, definir ORACLE_SID

prompt Autenticando como sysdba empleando archivo de passwords
--ojo emplear el password configurado en el archivo de passwords
connect sys/hola1234* as sysdba

prompt Traer al mundo una nueva instancia 
startup nomount

prompt creando un SPFILE a partir de un PFILE 
create spfile from pfile;

prompt Validando su existencia 
!ls -l ${ORACLE_HOME}/dbs/spfilergpdip02.ora
