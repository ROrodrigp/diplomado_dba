spool s-02-snapshot.txt
prompt Creando snapshot 1 

prompt Conectando como sys 
connect sys/system3@rgpdip03_s1 as sysdba 
begin
  dbms_workload_repository.create_snapshot();
end;
/

prompt Simulando carga pesada 
connect rodrigo_med/rodrigo@rgpdip03_s1 

prompt Haciendo copia de cita 
create table cita_copia as
  select * from cita;

prompt Generando reporte de las primeras 10 especialidades 
create table especialidad_copia as 
  select * from especialidad;

update especialidad_copia set nombre = upper(nombre);
commit;

prompt Generando un nuevo snapshot 2
connect sys/system3@rgpdip03_s1  as sysdba
prompt esperando 1 minuto 
execute dbms_session.sleep(60);
begin
  dbms_workload_repository.create_snapshot();
end;
/

prompt Simulando carga pesada 
connect rodrigo_med/rodrigo@rgpdip03_s1 

prompt Generando un reporte de las ultimas recetas 
create table receta_copia as 
  select * from receta;

update receta_copia set dias = dias+16;


prompt Creando un indice 
create table medico_copia as
  select * from medico;
create index medico_cedula_ix on medico_copia(cedula);
update medico_copia set trayectoria = upper(trayectoria) || length(trayectoria);


prompt consultando cedula de los medicos que comiencen con 5 
create table medicos_reporte_2 as 
  select * from medico;

prompt Creando tabla grande 
create table medico_especialidad_2
  as select medico_id, m.nombre as m_nombre, ap_paterno, ap_materno, cedula,
    trayectoria, m.especialidad_id as m_especialidad,
    e.nombre as e_nombre, anios, requisito
    from medico m 
    join especialidad e
    on m.especialidad_id = e.especialidad_id;



prompt generando un nuevo snapshot 3 
connect sys/system3@rgpdip03_s1  as sysdba
prompt esperando 1 minuto 
execute dbms_session.sleep(60);
begin
  dbms_workload_repository.create_snapshot();
end;
/


pause Revisar resultados, [Enter] para hacer limpieza

prompt Hacer limpieza 
connect rodrigo_med/rodrigo@rgpdip03_s1 

delete from cita_copia;
delete from especialidad_copia;
delete from receta_copia;
delete from medico_copia;
delete from medicos_reporte_2;
delete from medico_especialidad_2;


drop table cita_copia;
drop table especialidad_copia;
drop table receta_copia;
drop table medico_copia;
drop table medicos_reporte_2;
drop table medico_especialidad_2;

prompt generando un nuevo snapshot 4 
connect sys/system3@rgpdip03_s1  as sysdba
begin
  dbms_workload_repository.create_snapshot();
end;
/

prompt Listo !
spool off;


