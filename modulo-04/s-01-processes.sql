prompt Mostrando procesos con instancia detenida

--grep -v grep  omite la propia busqueda
!ps -ef | grep -e sqlplus  -e rgpdip02 | grep -v grep 

prompt Autenticando como sys
connect sys/system2 as sysdba

prompt Mostrando nuevamente los procesos
pause Qué se obtendrá? [Enter] para continuar
!ps -ef | grep -e sqlplus  -e rgpdip02 | grep -v grep 

prompt Mostrando proceso del listener 
!ps -ef | grep -e sqlplus  -e rgpdip02 -e listener | grep -v grep 
pause [Enter] para continuar

prompt Iniciando instancia en modo nomount 
startup nomount

prompt Mostrando procesos en modo nomount 
pause Qué se mostrará? [Enter] para continuar
!ps -ef | grep -e sqlplus  -e rgpdip02 -e listener | grep -v grep 

prompt Abriendo BD
alter database mount;
alter database open;

prompt Cerrando sesión de sys 
disconnect

prompt Conectando como sysdba 
connect sys/system2 as sysdba

prompt Mostrando los procesos de esta nueva conexion 
!ps -ef | grep -e sqlplus  -e "local=yes" -e listener | grep -v grep 

prompt Analizar respuestas, anotar los IDs de los procesos y compararlos  con los obtenidos en SQL Developer
