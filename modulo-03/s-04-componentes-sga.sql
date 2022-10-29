connect sys/system2 as sysdba

select q1.pool,
    q1.num_componentes, trunc(q1.megas,2) megas_usados,
    trunc(q2.megas_usados,2) megas_libres