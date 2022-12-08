select sosid, pid, pname, username, program, tracefile, background,
    trunc(pga_used_mem/1024/1024,2) pga_mem_mb
from v$process
where sosid in ('8727');