-- lista produtos com o codigo de barras 1 duplicado
select PROCOD,PRODES,PROCODBAR1 from TBS010 A
 where PROCODBAR1 <> '' and (select count(*) from TBS010 B where B.PROCODBAR1 = A.PROCODBAR1) > 1
 order by PROCODBAR1

-- lista produtos com o codigo de barras 2 duplicado
select PROCOD,PRODES,PROCODBAR2 from TBS010 A
 where PROCODBAR2 <> '' and (select count(*) from TBS010 B where B.PROCODBAR2 = A.PROCODBAR2) > 1
 order by PROCODBAR2

-- lista produtos com o codigo de barras 3 duplicado
select PROCOD,PRODES,PROCODBAR3 from TBS010 A
 where PROCODBAR3 <> '' and (select count(*) from TBS010 B where B.PROCODBAR3 = A.PROCODBAR3) > 1
 order by PROCODBAR3

-- lista produtos com o codigo de barras 4 duplicado
select PROCOD,PRODES,PROCODBAR4 from TBS010 A
 where PROCODBAR4 <> '' and (select count(*) from TBS010 B where B.PROCODBAR4 = A.PROCODBAR4) > 1
 order by PROCODBAR4
