select M2_PROCOD,M2_CODBARDIG,* from MSL002 (noLock)
 where M2_PROCOD Like('164%') or M2_CODBARDIG='7891191000718' or M2_CODBARDIG Like('164%') or
       M2_CODBARDIG='7891191000718'
 order by M2_NUMDOC

select M2_PROCOD,M2_CODBARDIG,* from MSL002 (noLock)
 where M2_PROCOD='1641239'
 order by M2_NUMDOC

select top 1000 M2_PROCOD,M2_CODBARDIG,* from MSL002 (noLock) where M2_TIPDOC in('T','F') order by M2_NUMDOC

select top 1000 M2_PROCOD,M2_CODBARDIG,* from MSL002 (noLock)
 where M2_TIPDOC in('T','F') and M2_TIPREG='10' order by M2_NUMDOC

select M2_PROCOD,M2_CODBARDIG,* from MSL002 (noLock) where M2_NUMDOC in(49098,49201,49233) order by M2_NUMDOC

select top 1000 M2_PROCOD,M2_CODBARDIG,* from MSL002 (noLock)
 where M2_TIPDOC in('T','F') and M2_TIPREG='11' order by M2_NUMDOC

select M2_PROCOD,M2_CODBARDIG,* from MSL002 (noLock)
 where M2_NUMDOC in(select M2_NUMDOC from MSL002 (noLock)
                     where M2_TIPDOC in('T','F') and M2_TIPREG in('10','11'))
 order by M2_NUMDOC

select M2_PROCOD,M2_CODBARDIG,* from MSL002 (noLock)
 where M2_NUMDOC in(select M2_NUMDOC from MSL002 (noLock)
                     where M2_TIPREG='11')
 order by M2_NUMDOC
