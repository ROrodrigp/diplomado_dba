spool m07-e03-01.txt
prompt 1. Creando CDB a partir de SEED (from scratch)

prompt Iniciando CDB rgpdip03
!sh s-030-start-cdb.sh rgpdip03 system3 

prompt Conectando como sys en rgpdip03
connect sys/system3@rgpdip03 as sysdba

prompt Creando pdb rgpdip03_s3 a partir de SEED 
--Este parametro indica la ruta done se guardaran los datafiles de la 
-- nueva PDB 
alter system set db_create_file_dest='/u01/app/oracle/oradata' scope=memory;

--En este ejemplo se utiliza OMF ya que no se especifican las demas rutas 
create pluggable database rgpdip03_s3 admin user admin_s3 identified by admin_s3;


prompt Cambiarse a /u01/app/oracle/oradata  como oracle
pause Analizar datafiles [enter] para continuar 

prompt Mostrando datos de la CDB desde el DD. 
col file_name format a80 
select file_id, file_name from dba_data_files;

prompt Mostrando datos de las pdbs
show pdbs 

prompt Mostrando datos de las PDBs (dba_pdbs)
col pdb_name format a30
select pdb_id, pdb_name, status from dba_pdbs;
pause Analizar [enter] para continuar 

prompt Accediendo a la PDB
alter pluggable database rgpdip03_s3 open read write;
alter session set container=rgpdip03_s3;
show con_id
show con_name 

prompt Mostrando datos de la PDB desde el DD. 
select file_id, file_name from dba_data_files;

pause [Enter] para comenzar con la limpieza
prompt Cambiando a cdb$root 
alter session set container=cdb$root;
--Para eliminar una PDB: 1. Cerrarla, 2. Hacer unplug, 3. Hacer drop
alter pluggable database rgpdip03_s3 close;
--dar permisos de escritura a oracle en la carpeta e-crea-pdbs 
! chmod  777 /unam-diplomado-bd/diplomado_dba/modulo-07/e-crea-pdbs

alter pluggable database rgpdip03_s3 unplug into '/unam-diplomado-bd/diplomado_dba/modulo-07/e-crea-pdbs/metadata-rgpdip03_s3.xml';

pause Mostrando contenido de los metadatos 
!cat /unam-diplomado-bd/diplomado_dba/modulo-07/e-crea-pdbs/metadata-rgpdip03_s3.xml

pause Analizar XML, [enter] para continuar (se eliminaran los archivos)
drop pluggable database  rgpdip03_s3 including datafiles;
!rm /unam-diplomado-bd/diplomado_dba/modulo-07/e-crea-pdbs/metadata-rgpdip03_s3.xml

prompt Apagando spool 
spool off
exit 
