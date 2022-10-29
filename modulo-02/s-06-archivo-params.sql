prompt Creando un PFILE a partir de un SPFILE
connect sys/system1 as sysdba
create pfile='/tmp/pfile-spfile.ora' from spfile;

prompt Creando un PFILE a partir de la instancia (debe estar iniciada)
create pfile='/tmp/pfile-memory.ora' from memory;


Prompt Modificar permisos ya que el archivo le pertenece a oracle
prompt Proporcionar password del usuario 
!sudo chmod 777 /tmp/pfile-memory.ora
Pause Revisar archivos y detectar diferencias 


prompt agregando parametro al pfile /tmp/pfile-memory.ora
!echo "nls_date_format=dd/mm/yyyy hh24:mi:ss" >> /tmp/pfile-memory.ora

Prompt Deteniendo la instancia 
shutdown immediate

prompt iniciando instancia empleando el pfile 
startup pfile='/tmp/pfile-memory.ora'

prompt comprobando el valor del parametro nls_date_format
select sysdate from dual;

prompt Modificar el valor del parametro nls_date_format en el spfile 
Pause ¿Qué pasará?

alter system nls_date_format='dd/mm/yyyy' scope=spfile;
