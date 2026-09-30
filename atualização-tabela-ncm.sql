drop table TBS092_BKP

select * into TBS092_BKP from TBS092 (nolock)

select * from TBS092_BKP (nolock)

drop table TBS0921_BKP

select * into TBS0921_BKP from TBS0921 (nolock)

select count(*) from TBS092 (nolock)

select * from TBS092 (nolock)

select * from TBS0921 (nolock)

select count(*) from TBS092_BKP (nolock)

-- tabela antiga

select cast(ex as char(2)), isnull(Ltrim(str(convert(int,ex))),''),* 
  --into #ncm_antiga
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\TabelaIBPTaxSP26.2.A.xlsx', 'select * from [TabelaIBPTaxSP26.2.A$]')
 where codigo = '02109100'

select tipo
       ,codigo
       ,count(*)
  from #ncm_antiga
 where tipo=0
 group by tipo, codigo
having count(*) > 1

select ex
       ,codigo
       ,count(*)
  from #ncm_antiga
 where tipo=0
 group by ex, codigo
having count(*) > 1

select *
  from #ncm_antiga

-- nova tabela

select * 
  into #ncm
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\TabelaIBPTaxSP26.2.A.xlsx', 'select * from [TabelaIBPTaxSP26.2.A$]')

select ex
       ,codigo
       ,count(*)
  from #ncm
 where tipo=0
 group by ex, codigo
having count(*) > 1

select *
  from #ncm
 where codigo='84198991'

select PROCOD,PROCLAFIS,PRODES,PROSTATUS from TBS010 (nolock)
 where PROCLAFIS<>'' and PROSTATUS='A' and
       not exists(select * 
                         from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\TabelaIBPTaxSP26.2.A.xlsx', 'select * from [TabelaIBPTaxSP26.2.A$]')
                   where codigo=PROCLAFIS collate database_default)

select PROCLAFIS
       ,count(*)
  from TBS010 (nolock)
 where PROCLAFIS<>'' and
       not exists(select * 
                         from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\TabelaIBPTaxSP26.2.A.xlsx', 'select * from [TabelaIBPTaxSP26.2.A$]')
                   where codigo=PROCLAFIS collate database_default)
	   and PROSTATUS='A'
 group by PROCLAFIS
 order by PROCLAFIS

select * from TBS092 (nolock)
 where not exists(select * 
                    from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\TabelaIBPTaxSP26.2.A.xlsx', 'select * from [TabelaIBPTaxSP26.2.A$]')
                   where codigo=NCMCOD collate database_default)

select PROCLAFIS,PROIPI from TBS010 (nolock) where PROCOD='1640054'

delete TBS092
delete TBS0921

select * from TBS092 (nolock)

insert into TBS092 select * from TBS092_BKP


DROP INDEX [TBS092].[ITTBS0921]
 
ALTER TABLE [TBS092]
ALTER COLUMN [NCMDES] CHAR(255) NULL

CREATE NONCLUSTERED INDEX [ITTBS0921] ON [TBS092] (
      [NCMDES])
go
 

begin tran
delete TBS092
commit tran

insert into TBS092 (
   NCMCOD,
   NCMDES,
   NCMDATCAD,
   NCMALIIMP,
   NCMALINAC,
   NCMEX,
   NCMCHV,
   NCMFONTAB,
   NCMVER,
   NCMVIGFIN,
   NCMVIGINI)
   select right('00000000' + Ltrim(str(codigo,8)),8),
          subString(descricao,1,255),
          getdate(),
          convert(decimal(10,4),importadosfederal),
          convert(decimal(10,4),nacionalfederal),
          --isnull(subString(ex,1,2),''),
		  --isnull(right('00' + Ltrim(str(ex)),2),'00'),
		  isnull(Ltrim(str(convert(int,ex))),''),
		  --Ltrim(str(ex,1)),
		  --case when ex=0
          --subString(chave,1,10),
		  chave,
          subString(fonte,1,10),
		  --fonte,
          --subString(versao,1,10),
		  versao,
          vigenciafim,
          vigenciainicio
     from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\TabelaIBPTaxSP26.2.A.xlsx', 'select * from [TabelaIBPTaxSP26.2.A$]')
    where tipo=0

commit tran

update TBS092 set NCMDES=upper(NCMDES)

select top 1 * from TBS092 (nolock)
select * from TBS092 (nolock)

--update TBS092 set NCMALIPIS=0,NCMALICOF=0,NCMIVA=0,NCMALIIPI=0

select * into TBS092BKP from TBS092 (nolock)

select codigo,
          subString(descricao,1,255),
          getdate(),
          convert(decimal(10,4),importadosfederal),
          convert(decimal(10,4),nacionalfederal),
          isnull(subString(ex,1,2),''),
          subString(chave,1,10),
          subString(fonte,1,10),
          subString(versao,1,10),
          vigenciafim,
          vigenciainicio
     from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\TabelaIBPTaxSP26.2.A.xlsx', 'select * from [TabelaIBPTaxSP26.2.A$]')
    where tipo=0

select NCMCOD from TBS0921 (nolock) where not exists(select '' from TBS092 (nolock) where TBS092.NCMCOD=TBS0921.NCMCOD)

select * from TBS092 (nolock) where NCMALIIPI > 0

select NCMCOD from TBS0921 (nolock) where not exists(select '' from TBS092 (nolock) where TBS0921.NCMCOD=TBS092.NCMCOD)

begin tran
delete TBS0921 where not exists(select '' from TBS092 (nolock) where TBS092.NCMCOD=TBS0921.NCMCOD)
commit tran
rollback tran


-- inser��o manual

/*
select * from TBS092 (nolock) where NCMCOD='85365010'
select * from TBS092 (nolock) where NCMCOD='85363090'

select getdate()

insert into TBS092
select '85363090','','OUTROS',0,0,0,getdate(),0,
*/

select *
  from TBS092 with (nolock)
 where NCMEX=''
