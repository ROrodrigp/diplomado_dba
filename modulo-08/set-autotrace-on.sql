rodrigo_med@rgpdip03_s1> set autotrace on
rodrigo_med@rgpdip03_s1> select count(*) from medico;

  COUNT(*)
----------
      5000


Execution Plan
----------------------------------------------------------
Plan hash value: 3744333010

---------------------------------------------------------------------------
| Id  | Operation	      | Name	  | Rows  | Cost (%CPU)| Time	  |
---------------------------------------------------------------------------
|   0 | SELECT STATEMENT      | 	  |	1 |	5   (0)| 00:00:01 |
|   1 |  SORT AGGREGATE       | 	  |	1 |	       |	  |
|   2 |   INDEX FAST FULL SCAN| MEDICO_PK |  4967 |	5   (0)| 00:00:01 |
---------------------------------------------------------------------------

Note
-----
   - dynamic statistics used: dynamic sampling (level=2)


Statistics
----------------------------------------------------------
	  0  recursive calls
	  0  db block gets
	 18  consistent gets
	  0  physical reads
	  0  redo size
	550  bytes sent via SQL*Net to client
	389  bytes received via SQL*Net from client
	  2  SQL*Net roundtrips to/from client
	  0  sorts (memory)
	  0  sorts (disk)
	  1  rows processed
