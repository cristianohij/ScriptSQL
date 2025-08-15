select top 1 * from TBS0451 (nolock)

update TBS045 set PDCUSURES='' where PDCUSURES is null
go
update TBS045 set PDCHORRES='' where PDCHORRES is null
go
update TBS045 set PDCDATRES='17530101' where PDCDATRES is null
go
update TBS045 set PDCUSUALT='' where PDCUSUALT is null
go
update TBS045 set PDCHORALT='' where PDCHORALT is null
go
update TBS045 set PDCDATALT='17530101' where PDCDATALT is null
go
update TBS045 set PDCHORCAD='' where PDCHORCAD is null
go


update TBS0451 set PDCPOROUTITE=0 where PDCPOROUTITE is null
go
update TBS0451 set PDCPORSEGITE=0 where PDCPORSEGITE is null
go
update TBS0451 set PDCPORFREITE=0 where PDCPORFREITE is null
go
