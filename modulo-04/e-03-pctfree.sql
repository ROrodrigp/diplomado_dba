connect rodrigo05/rodrigo05

whenever sqlerror exit rollback

prompt Creando tabla con pctfee 0 
create table t02_random_str_0(
  str char(18) 
) pctfree 0;


prompt Creando tabla con pctfee 50
create table t02_random_str_50(
  str char(18) 
) pctfree 50;

pause [Enter] para continuar 

declare
  v_srt char(18);
begin 
  v_str := rpad('A',18,'X');
  
end;
/