pause Antes de continuar asegurarse que la CDB esta iniciada, asi como ORACLE_SID=rgpdip04 [Enter]
pause [Enter] para continuar 

prompt Conectando a una rgpdip04_s1
connect sys/system04@rgpdip04_s1 as sysdba
pause ¿Qué sucederá al ejectuar shutdown immediate? [Enter]
shutdown immediate 

prompt Pregunta 2 
alter session set container=cdb$root;
select con_id, name, open_mode from v$pdbs;
pause Analizar resultados [Enter] para continuar

prompt Pregunta 3 detener la CDB 
shutdown immediate 

prompt pregunta 4, inciando nuevamente 
connect sys/system04 as sysdba
startup 

prompt Ejecutando nuevamente consulta 2 
alter session set container=cdb$root;
select con_id, name, open_mode from v$pdbs;
pause Analizar resultados [Enter] para continuar