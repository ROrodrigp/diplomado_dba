set serveroutput on



spool salida-e08-alert-script.txt

-- Creación del usuario
prompt Creando el usuario
CREATE USER m08_user IDENTIFIED BY password DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;
prompt Usuario creado exitosamente.
pause [Enter para continuar]


-- Creación de la tabla en el tablespace "users" asignado al usuario
prompt Creando la tabla en el tablespace "users"
CREATE TABLE m08_user.m08_table (
   id NUMBER(10),
   data VARCHAR2(50)
)
TABLESPACE users;
prompt Tabla creada exitosamente.
pause [Enter para continuar]

-- Configuración de la alerta
prompt Configurando la alerta
BEGIN
   DBMS_SERVER_ALERT.SET_THRESHOLD(
      metrics_id              => DBMS_SERVER_ALERT.TABLE_ROW_COUNT,
      warning_operator        => DBMS_SERVER_ALERT.OPERATOR_LE,
      warning_value           => '100',
      critical_operator       => DBMS_SERVER_ALERT.OPERATOR_LE,
      critical_value          => '200',
      observation_period      => 1,
      consecutive_occurrences => 1,
      instance_name           => NULL,
      object_type             => DBMS_SERVER_ALERT.OBJECT_TYPE_TABLE,
      object_name             => 'm08_user.m08_table'
   );
END;
/
prompt Alerta configurada exitosamente.
pause [Enter para continuar]

-- Inserción de datos en la tabla hasta superar los límites de la alerta
prompt Insertando datos en la tabla
DECLARE
   i NUMBER;
BEGIN
   FOR i IN 1..250 LOOP
      INSERT INTO m08_user.m08_table VALUES (i, 'Data ' || i);
   END LOOP;
   COMMIT;
END;
/

prompt Datos insertados exitosamente.
pause [Enter para continuar]

prompt Mostrando cantidad de datos 
select * from m08_user.m08_table;
pause [Enter para continuar]

-- Consulta de las alertas generadas en dba_outstanding_alerts
prompt Consultando las alertas generadas en dba_outstanding_alerts
SELECT *
FROM dba_outstanding_alerts
WHERE object_name = 'M08_TABLE'
ORDER BY time_stamp DESC;

spool off
exit 