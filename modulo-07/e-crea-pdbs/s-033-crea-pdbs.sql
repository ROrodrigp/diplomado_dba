spool m07-e03-03.txt
prompt Creando clon de una PDB, hacer plug en otra CDB - Manual 
--Hacer unplug de rgpdip03_s1, copiarla a la cdb rgpdip04 y hacer plug 

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
    pdb_descr_file='/home/oracle/backups/rgpdip03_s1/rgpdip03_s1.xml',
    pdb_name='jrcdip03_s1'
  );
  if v_compatible then 
    dbms_output.put_line('COMPATIBLE');
  else
    raise_application_error(-20001, 'PDB rgpdip03_s1 no es compatible con rgpdip04')
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

prompt Hacer limpieza ... 

spool off
exit 