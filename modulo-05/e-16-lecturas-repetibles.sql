prompt Realizando lecturas repetibles
define test_user='rodrigo05'
define test_user_logon='rodrigo05/rodrigo05'

connect &test_user_logon

prompt Habilitar nivel de aislamiento - lecturas

set transaction isolation level serializable name 'T1-RC';

prompt Realizando consultas 

select count(*) total_registros
from random_str_2;

select count(*) cad_a
from random_str_2
where cadena like 'A%';

select count(*) cad_z
from random_str_2
where cadena like 'Z%';

select count(*) cad_m
from random_str_2
where cadena like 'M%';

pause [Enter] para realizar la consulta nuevamente
prompt Realizando consultas 

select count(*) total_registros
from random_str_2;

select count(*) cad_a
from random_str_2
where cadena like 'A%';

select count(*) cad_z
from random_str_2
where cadena like 'Z%';

select count(*) cad_m
from random_str_2
where cadena like 'M%';

pause [Enter] para realizar la consulta nuevamente
prompt Realizando consultas 

select count(*) total_registros
from random_str_2;

select count(*) cad_a
from random_str_2
where cadena like 'A%';

select count(*) cad_z
from random_str_2
where cadena like 'Z%';

select count(*) cad_m
from random_str_2
where cadena like 'M%';

pause [Enter] para realizar la consulta nuevamente
prompt Realizando consultas 

select count(*) total_registros
from random_str_2;

select count(*) cad_a
from random_str_2
where cadena like 'A%';

select count(*) cad_z
from random_str_2
where cadena like 'Z%';

select count(*) cad_m
from random_str_2
where cadena like 'M%';

pause [Enter] para realizar la consulta nuevamente
prompt Realizando consultas 

select count(*) total_registros
from random_str_2;

select count(*) cad_a
from random_str_2
where cadena like 'A%';

select count(*) cad_z
from random_str_2
where cadena like 'Z%';

select count(*) cad_m
from random_str_2
where cadena like 'M%';

pause [Enter] para realizar la consulta nuevamente
prompt Realizando consultas 

select count(*) total_registros
from random_str_2;

select count(*) cad_a
from random_str_2
where cadena like 'A%';

select count(*) cad_z
from random_str_2
where cadena like 'Z%';

select count(*) cad_m
from random_str_2
where cadena like 'M%';

