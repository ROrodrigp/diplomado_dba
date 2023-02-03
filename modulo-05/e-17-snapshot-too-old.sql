prompt Provocando el error snapshot too old 
define test_user='rodrigo05'
define test_user_logon='rodrigo05/rodrigo05'

connect &test_user_logon

prompt BORRAR 1-5000
delete from &test_user..random_str_2 where id between 1 and 5000;
commit;
pause Revisar resultados [Enter] para continuar 

prompt BORRAR 5001-10000
delete from &test_user..random_str_2 where id between 5001 and 10000;
commit;
pause Revisar resultados [Enter] para continuar

prompt BORRAR 10001-15000
delete from &test_user..random_str_2 where id between 10001 and 15000;
commit;
pause Revisar resultados [Enter] para continuar

prompt BORRAR 15001-20000
delete from &test_user..random_str_2 where id between 15001 and 20000;
commit;
pause Revisar resultados [Enter] para continuar

prompt BORRAR 20001-25000
delete from &test_user..random_str_2 where id between 20001 and 25000;
commit;
pause Revisar resultados [Enter] para continuar

prompt BORRAR 25001-30000
delete from &test_user..random_str_2 where id between 25001 and 30000;
commit;
pause Revisar resultados [Enter] para continuar

prompt BORRAR 30001-35000
delete from &test_user..random_str_2 where id between 30001 and 35000;
commit;
pause Revisar resultados [Enter] para continuar

prompt BORRAR 35001-40000
delete from &test_user..random_str_2 where id between 35001 and 40000;
commit;
pause Revisar resultados [Enter] para continuar