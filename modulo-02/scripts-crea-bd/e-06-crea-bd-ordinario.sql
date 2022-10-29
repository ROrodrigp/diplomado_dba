--No olvidar iniciar oracle_sid
prompt Autenticando como sysdba
connect sys/system2 as sysdba

startup nomount

whenever sqlerror exit rollback 

prompt creando una nueva bd

create database rgpdip02
    user sys identified by system2
    user system identified by system2
    logfile group 1 (
        '/unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo01a.log',
        '/unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo01b.log',
        '/unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo01c.log'
      ) size 50m blocksize 512,
    group 2 (
        '/unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo02a.log',
        '/unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo02b.log',
        '/unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo02c.log'
      ) size 50m blocksize 512,
    group 3 (
        '/unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo03a.log',
        '/unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo03b.log',
        '/unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo03c.log'
      ) size 50m blocksize 512
    maxloghistory 1
    maxlogfiles 16
    maxlogmembers 3
    maxdatafiles 1024
    character set AL32UTF8
    national character set AL16UTF16
    extent management local
    datafile '/u01/app/oracle/oradata/RGPDIP02/system01.dbf'
        size 700m reuse autoextend on next 10240k maxsize unlimited
    sysaux datafile '/u01/app/oracle/oradata/RGPDIP02/sysaux01.dbf'
        size 550m reuse autoextend on next 10240k maxsize unlimited
    default tablespace users
        datafile '/u01/app/oracle/oradata/RGPDIP02/users01.dbf'
        size 500m reuse autoextend on maxsize unlimited
    default temporary tablespace tempts1
        tempfile '/u01/app/oracle/oradata/RGPDIP02/temp01.dbf'
        size 20m reuse autoextend on next 640k maxsize unlimited
    undo tablespace undotbs1
        datafile '/u01/app/oracle/oradata/RGPDIP02/undotbs01.dbf'
        size 200m reuse autoextend on next 5120k maxsize unlimited;

Prompt listo! Nueva BD creada
prompt actualizar los passwords en el archivo 

alter user sys identified by system2;
alter user system identified by system2;--No olvidar iniciar oracle_sid
prompt Autenticando como sysdba
connect sys/hola1234* as sysdba

startup nomount

whenever sqlerror exit rollback 

prompt creando una nueva bd

create database rgpdip02
    user sys identified by system2
    user system identified by system2
    logfile group 1 (
        '/unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo01a.log',
        '/unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo01b.log',
        '/unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo01c.log'
      ) size 50m blocksize 512,
    group 2 (
        '/unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo02a.log',
        '/unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo02b.log',
        '/unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo02c.log'
      ) size 50m blocksize 512,
    group 3 (
        '/unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo03a.log',
        '/unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo03b.log',
        '/unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo03c.log'
      ) size 50m blocksize 512
    maxloghistory 1
    maxlogfiles 16
    maxlogmembers 3
    maxdatafiles 1024
    character set AL32UTF8
    national character set AL16UTF16
    extent management local
    datafile '/u01/app/oracle/oradata/RGPDIP02/system01.dbf'
        size 700m reuse autoextend on next 10240k maxsize unlimited
    sysaux datafile '/u01/app/oracle/oradata/RGPDIP02/sysaux01.dbf'
        size 550m reuse autoextend on next 10240k maxsize unlimited
    default tablespace users
        datafile '/u01/app/oracle/oradata/RGPDIP02/users01.dbf'
        size 500m reuse autoextend on maxsize unlimited
    default temporary tablespace tempts1
        tempfile '/u01/app/oracle/oradata/RGPDIP02/temp01.dbf'
        size 20m reuse autoextend on next 640k maxsize unlimited
    undo tablespace undotbs1
        datafile '/u01/app/oracle/oradata/RGPDIP02/undotbs01.dbf'
        size 200m reuse autoextend on next 5120k maxsize unlimited;

Prompt listo! Nueva BD creada
prompt actualizar los passwords en el archivo 

alter user sys identified by system2;
alter user system identified by system2;--No olvidar iniciar oracle_sid
prompt Autenticando como sysdba
connect sys/hola1234* as sysdba

startup nomount

whenever sqlerror exit rollback 

prompt creando una nueva bd

create database rgpdip02
    user sys identified by system2
    user system identified by system2
    logfile group 1 (
        '/unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo01a.log',
        '/unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo01b.log',
        '/unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo01c.log'
      ) size 50m blocksize 512,
    group 2 (
        '/unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo02a.log',
        '/unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo02b.log',
        '/unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo02c.log'
      ) size 50m blocksize 512,
    group 3 (
        '/unam-diplomado-bd/disk-01/app/oracle/oradata/RGPDIP02/redo03a.log',
        '/unam-diplomado-bd/disk-02/app/oracle/oradata/RGPDIP02/redo03b.log',
        '/unam-diplomado-bd/disk-03/app/oracle/oradata/RGPDIP02/redo03c.log'
      ) size 50m blocksize 512
    maxloghistory 1
    maxlogfiles 16
    maxlogmembers 3
    maxdatafiles 1024
    character set AL32UTF8
    national character set AL16UTF16
    extent management local
    datafile '/u01/app/oracle/oradata/RGPDIP02/system01.dbf'
        size 700m reuse autoextend on next 10240k maxsize unlimited
    sysaux datafile '/u01/app/oracle/oradata/RGPDIP02/sysaux01.dbf'
        size 550m reuse autoextend on next 10240k maxsize unlimited
    default tablespace users
        datafile '/u01/app/oracle/oradata/RGPDIP02/users01.dbf'
        size 500m reuse autoextend on maxsize unlimited
    default temporary tablespace tempts1
        tempfile '/u01/app/oracle/oradata/RGPDIP02/temp01.dbf'
        size 20m reuse autoextend on next 640k maxsize unlimited
    undo tablespace undotbs1
        datafile '/u01/app/oracle/oradata/RGPDIP02/undotbs01.dbf'
        size 200m reuse autoextend on next 5120k maxsize unlimited;

Prompt listo! Nueva BD creada
prompt actualizar los passwords en el archivo 

alter user sys identified by system2;
alter user system identified by system2;
