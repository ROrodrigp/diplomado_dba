spool s-01-snapshot.txt
prompt Creando snapshot 1 

prompt Conectando como sys 
connect sys/system3@rgpdip03_s1 as sysdba 
begin
  dbms_workload_repository.create_snapshot();
end;
/

prompt Simulando operacion diaria eficiente 
connect rodrigo_med/rodrigo@rgpdip03_s1 

prompt Mostrando los datos de la ultima cita registrada 
create table ultima_cita as
  select * from cita
  where cita_id = (select max(cita_id) from cita);

prompt Generando reporte de las primeras 10 especialidades 
create table reporte_especialidad as 
  select * from especialidad
  where especialidad_id <= 10;


prompt Generando un nuevo snapshot 2
connect sys/system3@rgpdip03_s1  as sysdba
prompt esperando 1 minuto 
execute dbms_session.sleep(60);
begin
  dbms_workload_repository.create_snapshot();
end;
/

prompt Simulando operacion diaria eficiente 
connect rodrigo_med/rodrigo@rgpdip03_s1 

prompt Generando un reporte de las ultimas recetas 
create table ultima_receta as 
  select * from receta where receta_id <= 20;

prompt Creando un indice 
create index medico_cedula_ix on medico(cedula);

prompt consultando cedula de los medicos que comiencen con 5 
create table medicos_reporte as 
  select * from medico where cedula like '5%';


prompt generando un nuevo snapshot 3 
connect sys/system3@rgpdip03_s1  as sysdba
prompt esperando 1 minuto 
execute dbms_session.sleep(60);
begin
  dbms_workload_repository.create_snapshot();
end;
/

prompt Crear un nuevo baseline con los 3 snapshots anteriores
begin 
  dbms_workload_repository.create_baseline(
    start_snap_id   =>    &snapshot_inicial_id,
    end_snap_id     =>    &snapshot_fin_id,
    baseline_name   =>    'rodrigo_bl_normal_&num_baseline',
    expiration      =>    1 
  );
end;
/

prompt Mostrando los baseline creados 
col baseline_name format a20
select baseline_id, baseline_name, start_snap_id, end_snap_id, creation_time 
from dba_hist_baseline;

pause Revisar resultados, [Enter] para hacer limpieza

prompt Hacer limpieza 
connect rodrigo_med/rodrigo@rgpdip03_s1 

drop table ultima_cita;
drop table reporte_especialidad;
drop table ultima_receta;
drop table medicos_reporte;
drop index medico_cedula_ix;

spool off;