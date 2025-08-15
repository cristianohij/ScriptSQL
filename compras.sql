declare @datDe char(8),@datAte char(8)

set @datDe  = '20090701'
set @datAte = '20090731'

--select * from TBS045 (noLock) join TBS0451 (noLock)
--              on TBS045.PDCEMPCOD=TBS0451.PDCEMPCOD and TBS045.PDCNUM=TBS0451.PDCNUM
-- where PDCDATCAD between @datDe and @datAte

select convert(char(8),PDCDATCAD,3),(PDCQTD-PDCQTDENT)*(PDCPRE-PDCPRE*PDCPDDITE/100) from TBS045 (noLock) join TBS0451 (noLock)
              on TBS045.PDCEMPCOD=TBS0451.PDCEMPCOD and TBS045.PDCNUM=TBS0451.PDCNUM
 where PDCDATCAD between @datDe and @datAte
