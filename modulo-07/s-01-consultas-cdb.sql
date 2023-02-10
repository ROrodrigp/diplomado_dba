--consulta 1 
prompt Conectando a root 
connect sys/system3@rgpdip03
select dbid, name, cdb, con_id, con_dbid
from v$database;

