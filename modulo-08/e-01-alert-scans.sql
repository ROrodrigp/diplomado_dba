-- Crear usuario
spool salida-e08-alert-script.txt
prompt Creando usuario...
create user m08_user identified by password default tablespace users  quota unlimited on users;
alter user m08_user quota unlimited on users;

prompt Mostrando numero actual de sesiones
SELECT COUNT(*) AS "Current Number of Logons" FROM V$SESSION;


-- Crear alarma
prompt Configurando alerta...
BEGIN
   DBMS_SERVER_ALERT.SET_THRESHOLD(
      metrics_id              => DBMS_SERVER_ALERT.LOGONS_CURRENT,
      warning_operator        => DBMS_SERVER_ALERT.OPERATOR_EQ,
      warning_value           => '64',
      critical_operator       => DBMS_SERVER_ALERT.OPERATOR_EQ,
      critical_value          => '66',
      observation_period      => 1,
      consecutive_occurrences => 1,
      instance_name           => null,
      object_type             => DBMS_SERVER_ALERT.OBJECT_TYPE_SYSTEM,
      object_name             => null
   );
END;
/

-- Pausa para esperar activación de la alarma
prompt Esperando activación de la alarma... (Presione ENTER para continuar)
pause

prompt Mostrando numero actual de sesiones
SELECT COUNT(*) AS "Current Number of Logons" FROM V$SESSION;
pause

-- Mostrar alertas
prompt Mostrando alertas...
select *
from dba_outstanding_alerts;

spool off
exit 