set verify off
set linesize window
spool salida-e06-flashback-drop.txt

define syslogon='sys/system2 as sysdba' 
define userlogon='user06/user06'


prompt 1. Conectando como usuario sys 
conn &syslogon