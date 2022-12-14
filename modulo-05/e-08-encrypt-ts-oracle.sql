prompt conectando como sys 
spool 'salida-e08.txt' create;
connect sys/system2 as sysdba

prompt Crea y abre el wallet
alter system set encryption key identified by "wallet_password";

prompt Creando un nuevo tablespace

create tablespace m05_encrypted_ts
datafile '/u01/app/oracle/oradata/RGPDIP02/m05_encrypted_ts_01.dbf' size 10M
encryption using 'aes256'
default storage(encrypt);

prompt otorgando cuota 
alter user rodrigo05 quota unlimited on m05_encrypted_ts;

prompt comprobando la configuracion de los ts 
select tablespace_name, encrypted
from dba_tablespaces;

pause [Enter] para continuar

prompt conectando como rodrigo05 para crear objetos cifrados
connect rodrigo05/rodrigo05

create table mensaje_seguro(
  id number,
  mensaje varchar2(20)
) tablespace m05_encrypted_ts;

insert into mensaje_seguro (id, mensaje) values(1,'mensaje 1');
insert into mensaje_seguro (id, mensaje) values(2,'mensaje 2');
commit;

select * from mensaje_seguro;

prompt creando la misma tabla en el tablespace user sin cifrar
create table mensaje_inseguro(
  id number,
  mensaje varchar2(20)
);

insert into mensaje_inseguro (id, mensaje) values(1,'mensaje 1');
insert into mensaje_inseguro (id, mensaje) values(2,'mensaje 2');
commit;

prompt forzando sincronizacion, conectando como sys
connect sys/system2 as sysdba

alter system checkpoint;
Pause [Enter] para realizar la busqueda del texto en el TS cifrado 
!strings /u01/app/oracle/oradata/RGPDIP02/m05_encrypted_ts_01.dbf | grep "mensaje"

--reiniciar y volver a mostrar los datos 
Pause Reiniciando instancia [Enter] para continuar
shutdown immediate
startup 

Prompt Consultando los datos nuevamente
connect rodrigo05/rodrigo05

select * from mensaje_seguro;

Pause [Enter] para continuar y corregir el problema 

connect sys/system2 as sysdba

alter system set encryption wallet open identified by "wallet_password";

Prompt Mostrando datos nuevamente
connect rodrigo05/rodrigo05

select * from mensaje_seguro;

Pause [Enter] para realizar la limpieza

drop table mensaje_seguro;
drop table mensaje_inseguro;

connect sys/system2 as sysdba 
drop tablespace m05_encrypted_ts including contents and datafiles;

Prompt Listo! 
exit 
