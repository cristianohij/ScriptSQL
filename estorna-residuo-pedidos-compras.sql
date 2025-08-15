select PDCDATRES,PDCHORRES,PDCUSURES,* from TBS045 (nolock) where PDCNUM in(40026)
select PDCQTDRES,* from TBS0451 (nolock) where PDCNUM in(40026)

begin tran
update TBS045 set PDCDATRES='17530101',PDCHORRES='',PDCUSURES='' where PDCNUM in(40026)
commit tran

begin tran
update TBS0451 set PDCQTDRES=0 where PDCNUM in(40026)
commit tran

begin tran
update TBS0451 set PDCPORST=0 where PDCNUM=39145 and PDCPORST > 0
commit tran

