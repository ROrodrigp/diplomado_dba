spool m07-e03-03.txt
prompt Creando clon de una PDB, hacer plug en otra CDB - Manual 
--Hacer unplug de rgpdip03_s1, copiarla a la cdb rgpdip04 y hacer plug 

prompt Iniciar rgpdip03
!sh s-030-start-cdb.sh rgpdip03 system3

prompt Conectar a rgpdip03 (root)
connect sys/system3@rgpdip03 as sysdba

prompt Cerrar la pdb
alter pluggable database rgpdip03_s1 close;

prompt Hacer unplug de rgpdip03_s1
alter pluggable database rgpdip03_s1 unplug into '/home/oracle/backups/rgpdip03_s1.xml'

prompt Mostrando datos de las pdbs 
show pdbs 

prompt Mostrando datos de las PDBs (dba_pdbs)
col pdb_name format a30
select pdb_id, pdb_name, status from dba_pdbs;
pause Analizar [enter] para continuar 

prompt Eliminar la PDB 
drop pluggable database rgpdip03_s1 keep datafiles;

prompt  Mover la PDB (datafiles y XML) a /home/oracle/backups/rgpdip03_s1
prompt No olvidar actualizar las rutas en el XML 
pause [Enter] para continuar 
--Los datafiles podrán ser ubicados en cualquier carpeta 
--se moveran a /home/oracle/backups/rgpdip03_s1, incluyendo los metadatos

prompt El siguiente paso es hacer plug en rgpdip04

prompt Detener rgpdip03
!sh s-030-stop-cdb.sh rgpdip03 system3 

prompt Iniciar rgpdip04
!sh s-030-start-cdb.sh rgpdip04 system04

prompt Validar compatibilidad conectando a rgpdip04
connect sys/system04@rgpdip04 as sysdba

show con_id
show con_name 

set serveroutput on
declare
  v_compatible boolean;
begin
  v_compatible := dbms_pdb.check_compatibility(
    pdb_descr_file => '/home/oracle/backups/rgpdip03_s1/rgpdip03_s1.xml',
    pdb_name => 'rgpdip03_s1'
  );
  if v_compatible then 
    dbms_output.put_line('COMPATIBLE');
  else
    raise_application_error(-20001, 'PDB rgpdip03_s1 no es compatible con rgpdip04');
  end if;
end;
/

pause Validar resultados

prompt Agregar la nueva PDB 
create pluggable database rgpdip04_m3 using 
  '/home/oracle/backups/rgpdip03_s1/rgpdip03_s1.xml'
  file_name_convert=(
    '/home/oracle/backups/rgpdip03_s1',
    '/u01/app/oracle/oradata/RGPDIP04/rgpdip04_m3'
);


prompt Mostrando datos de las PDBs
show pdbs 

select pdb_id, pdb_name, status from dba_pdbs;
pause Analizar [enter] para continuar 

prompt Abriendo rgpdip04_m3
alter pluggable database rgpdip04_m3 open read write;

prompt Conectar a rgpdip04_m3
alter session set container=rgpdip04_m3;

prompt Mostrando datos de la nueva PDB
show con_id
show con_name 

pause Analizar resultado[Enter] para comenzar con limpieza 

prompt conectando a rgpdip04 (root)
alter session set container=cdb$root;

prompt Cerrando a rgpdip04_m3
alter pluggable database rgpdip04_m3 close;

prompt unplug para rgpdip04_m3
alter pluggable database rgpdip04_m3 unplug
  into '/home/oracle/backups/rgpdip04_m3.xml';

prompt Eliminando rgpdip04_m3
drop pluggable database rgpdip04_m3 keep datafiles;

prompt Realizar las siguientes acciones de forma manual 
prompt 1. Mover datafiles a carpeta de backups 
prompt 2. Editar xml 
prompt 3. Mover xml a carpeta rgpdip04_m3 

pause Realizar cambios [Enter] para continuar 

prompt Detener rgpdip04
!sh s-030-stop-cdb.sh rgpdip04 system04

prompt Iniciar rgpdip03
!sh s-030-start-cdb.sh rgpdip03 system3

prompt Checar compatibilidad, conectando a rgpdip03
connect sys/system3@rgpdip03 as sysdba

set serveroutput on
declare
  v_compatible boolean;
begin
  v_compatible := dbms_pdb.check_compatibility(
    pdb_descr_file => '/home/oracle/backups/rgpdip04_m3/rgpdip04_m3.xml',
    pdb_name => 'rgpdip04_m3'
  );
  if v_compatible then 
    dbms_output.put_line('COMPATIBLE');
  else
    raise_application_error(-20001, 'PDB rgpdip04_m3 no es compatible con rgpdip03');
  end if;
end;
/

pause Validar resultados [Enter para continuar]

prompt Crear nueva pdb 
create pluggable database rgpdip03_s1
  using '/home/oracle/backups/rgpdip04_m3/rgpdip04_m3.xml'
  file_name_convert=(
    '/home/oracle/backups/rgpdip04_m3',
    '/u01/app/oracle/oradata/RGPDIP03/rgpdip03_s1'
  );

prompt Abriendo rgpdip03_s1
alter pluggable database rgpdip03_s1 open  read write;
show pdbs 

pause Analizar resultado [enter] para borrar backups 
!sudo rm -rf /home/oracle/backups/rgpdip03_s1
!sudo rm -rf /home/oracle/backups/rgpdip04_m3

spool off
exit 