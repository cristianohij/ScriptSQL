-- verifica quantidade pendentes
select * from TBS032 e (noLock)
 where e.ESTLOC=1 and e.ESTQTDPEN <> (select isNull(sum(PRPQTD*PRPQTDEMB),0)
                                        from TBS058 p with (nolock)
                                       where p.PRPSIT='P'
                                             and p.PRPESTLOC=e.ESTLOC
                                             and p.PRPMOVEST='S'
                                             and p.PROCOD=e.PROCOD)
                                     +
                                     (select isnull(sum(((SDCQTDPED-(SDCQTDATD+SDCQTDRES))*s.SDCQTDEMB)),0)
                                        from TBS0761 s with (nolock)
                                       where s.LESCOD=e.ESTLOC
                                             and s.PROCOD=e.PROCOD
                                             and s.SDCPEN='S')
 order by e.PROCOD

-- otimizado

SELECT e.*
FROM TBS032 e WITH (NOLOCK)
LEFT JOIN (
    SELECT PRPESTLOC, PROCOD, 
           SUM(PRPQTD * PRPQTDEMB) AS TotalSaidas
    FROM TBS058 WITH (NOLOCK)
    WHERE PRPSIT = 'P' AND PRPMOVEST = 'S'
    GROUP BY PRPESTLOC, PROCOD
) p ON e.ESTLOC = p.PRPESTLOC AND e.PROCOD = p.PROCOD
LEFT JOIN (
    SELECT LESCOD, PROCOD, 
           SUM((SDCQTDPED - (SDCQTDATD + SDCQTDRES)) * SDCQTDEMB) AS TotalPedidos
    FROM TBS0761 WITH (NOLOCK)
    WHERE SDCPEN = 'S'
    GROUP BY LESCOD, PROCOD
) s ON e.ESTLOC = s.LESCOD AND e.PROCOD = s.PROCOD
WHERE e.ESTLOC = 1 
AND e.ESTQTDPEN <> COALESCE(p.TotalSaidas, 0) + COALESCE(s.TotalPedidos, 0);

-- update

begin tran
UPDATE e
SET e.ESTQTDPEN = COALESCE(p.TotalSaidas, 0) + COALESCE(s.TotalPedidos, 0)
FROM TBS032 e
LEFT JOIN (
    SELECT PRPESTLOC, PROCOD, 
           SUM(PRPQTD * PRPQTDEMB) AS TotalSaidas
    FROM TBS058 WITH (NOLOCK)
    WHERE PRPSIT = 'P' AND PRPMOVEST = 'S'
    GROUP BY PRPESTLOC, PROCOD
) p ON e.ESTLOC = p.PRPESTLOC AND e.PROCOD = p.PROCOD
LEFT JOIN (
    SELECT LESCOD, PROCOD, 
           SUM((SDCQTDPED - (SDCQTDATD + SDCQTDRES)) * SDCQTDEMB) AS TotalPedidos
    FROM TBS0761 WITH (NOLOCK)
    WHERE SDCPEN = 'S'
    GROUP BY LESCOD, PROCOD
) s ON e.ESTLOC = s.LESCOD AND e.PROCOD = s.PROCOD
WHERE e.ESTLOC = 1
AND e.ESTQTDPEN <> COALESCE(p.TotalSaidas, 0) + COALESCE(s.TotalPedidos, 0);

rollback tran
commit tran

--

begin tran
update TBS032 set ESTQTDPEN = (select isNull(sum(PRPQTD*PRPQTDEMB),0) from TBS058
                                   where PRPSIT='P' and PRPESTLOC=ESTLOC and PRPMOVEST='S' and TBS058.PROCOD=TBS032.PROCOD)
  from TBS032 
 where ESTLOC=1 and ESTQTDPEN <> (select isNull(sum(PRPQTD*PRPQTDEMB),0) from TBS058
                                   where PRPSIT='P' and PRPESTLOC=ESTLOC and PRPMOVEST='S' and TBS058.PROCOD=TBS032.PROCOD)
commit tran
-- fim


-- verifica quantidade reservadas
select * from TBS032 (noLock)
 where ESTLOC=1 and ESTQTDRES <> (select isNull(sum(PRPQTD*PRPQTDEMB),0) from TBS058
                                   where PRPSIT='R' and PRPESTLOC=ESTLOC and PRPMOVEST='S' and TBS058.PROCOD=TBS032.PROCOD)
 order by PROCOD

begin tran
update TBS032 set ESTQTDRES = (select isNull(sum(PRPQTD*PRPQTDEMB),0) from TBS058 (noLock)
                                   where PRPSIT='R' and PRPESTLOC=ESTLOC and PRPMOVEST='S' and TBS058.PROCOD=TBS032.PROCOD)
  from TBS032 
 where ESTLOC=1 and ESTQTDRES <> (select isnull(sum(PRPQTD*PRPQTDEMB),0) from TBS058 (noLock)
                                   where PRPSIT='R' and PRPESTLOC=ESTLOC and PRPMOVEST='S' and TBS058.PROCOD=TBS032.PROCOD)
commit tran
-- fim


-- verifica quantidade comprada
-- elimina tabela temporaria
drop view COMPRAS

-- cria tabela temporaria
create view COMPRAS as
select TBS0451.PROCOD,LESCOD,isNull(sum((PDCQTD-(PDCQTDENT+PDCQTDRES))*PDCQTDEMB),0) as 'PENDENTE',TBS032.ESTQTDCMP
  from TBS0451 (noLock) join TBS032 (noLock) on ESTLOC=LESCOD and TBS0451.PROCOD=TBS032.PROCOD
 group by TBS0451.PROCOD,LESCOD,TBS032.ESTQTDCMP
having isNull(sum((PDCQTD-(PDCQTDENT+PDCQTDRES))*PDCQTDEMB),0) <> ESTQTDCMP
-- order by TBS0451.PROCOD

select * from COMPRAS

-- atualiza quantidade compras
begin tran
update TBS032 set ESTQTDCMP=PENDENTE
  from COMPRAS join TBS032 (noLock) on COMPRAS.PROCOD=TBS032.PROCOD and LESCOD=ESTLOC

-- confirma
commit tran

-- fim


select * from TBS0451 where PDCQTD < PDCQTDENT + PDCQTDRES

select * from TBS0451 where not exists(select 'ne' from TBS032 where 


select sum((PDCQTD-PDCQTDENT)*PDCQTDEMB) from TBS0451 where LESCOD=1 and PROCOD='1440152'

select isNull(sum((PDCQTD-PDCQTDENT)*PDCQTDEMB),0) from TBS0451


select * from TBS032 (noLock) where ESTQTDATU < 0

begin tran
update TBS032 set ESTQTDATU=0 where ESTQTDATU < 0
commit tran
