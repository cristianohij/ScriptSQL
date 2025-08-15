--select * from master..sysservers 

drop table #prefixo

select EMP='TANBYM', PFXCOD, PFXDES, 1 as FLAG into #prefixo from TBS061 (nolock)
union
select EMP='TANBYT', PFXCOD, PFXDES, 1 as FLAG from tt.SIBD.dbo.TBS061
union
select EMP='TANBYD', PFXCOD collate database_default, PFXDES collate database_default, 1 as FLAG from cd.SIBD.dbo.TBS061
union
select EMP='PAPELYNA', PFXCOD, PFXDES, 1 as FLAG from py.SIBD.dbo.TBS061
union
select EMP='MISASPEL', PFXCOD, PFXDES, 1 as FLAG from mi.SIBD.dbo.TBS061
union
select EMP='BESTBAG', PFXCOD, PFXDES, 1 as FLAG from bb.SIBD2.dbo.TBS061

select * from #prefixo order by PFXCOD

-- erro
select PFXCOD,
       PFXDES,
       [TANBYM] as Matriz,
       [TANBYT] as Taubate,
       [TANBYD] as Deposito
 from #prefixo
--(    SELECT DataCotacao, CodMoeda, ValorCotacao
--    FROM dbo.CotacoesPorDataMoeda
--) C
pivot(for EMP in([TANBYM], [TANBYT], [TANBYD]))
-- fim erro


SELECT PFXCOD, PFXDES
FROM #prefixo
PIVOT (
    EMP IN (EMP)  
) AS U


select B.PFXCOD,
       B.[1] as Matriz
  from #prefixo as A
 PIVOT (EMPRESA for EMP in([1])) as B

select PFXCOD,
  PFXDES,
  coalesce(TANBYM, '') matriz,
  coalesce(TANBYT, '') taubate,
  coalesce(TANBYD, '') deposito,
  coalesce(BESTBAG, '') bestbag,
  coalesce(MISASPEL, '') misaspel,
  coalesce(PAPELYNA, '') papelyna
from
(
  select PFXCOD, PFXDES, EMP, FLAG
  from #prefixo
) d
pivot
(
  max(FLAG)
  for EMP in (TANBYM, TANBYT, TANBYD, BESTBAG, MISASPEL, PAPELYNA)

) piv
ORDER BY PFXCOD
