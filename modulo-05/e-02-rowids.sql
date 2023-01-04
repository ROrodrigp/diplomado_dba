spool 'salida-e02.txt' create;
connect rodrigo05/rodrigo05
whenever sqlerror exit rollback

prompt Mostrando los primeros 10 registros y sus rowids 

select row_id, id
from(
  select rowid as row_id, id
  from t01_id
  order by id 
) where rownum <=10;

prompt Mostrando segmentos generados 
select substr(rowid, 1, 6) segmento,
  count(*) as total_registros
from t01_id
group by substr(rowid, 1, 6);

pause [Enter] para continuar 

prompt Mostrando data files y registros asignados 
select substr(rowid, 7, 3) data_file,
  count(*) as total_registros
from t01_id
group by substr(rowid, 7, 3);

pause [Enter] para continuar 


prompt Mostrando bloque de datos y registros incluidos en el 
select substr(rowid, 10, 6) bloque,
  count(*) as total_registros
from t01_id
group by substr(rowid, 10, 6);

spool off;
exit
