drop table TBS092_BKP

select * into TBS092_BKP from TBS092 (nolock)

select * from TBS092_BKP (nolock)

drop table TBS0921_BKP

select * into TBS0921_BKP from TBS0921 (nolock)

select count(*) from TBS092 (nolock)

select * from TBS092 (nolock)

select count(*) from TBS092_BKP (nolock)

select PROCOD,PROCLAFIS,PRODES,PROSTATUS from TBS010 (nolock)
 where PROCLAFIS<>'' and PROSTATUS='A' and
       not exists(select * 
                         from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\TabelaIBPTaxSP18.2.B.xlsx', 'select * from [TabelaIBPTaxSP18.2.B$]')
                   where codigo=PROCLAFIS collate database_default)

select * from TBS092 (nolock)
 where not exists(select * 
                    from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\TabelaIBPTaxSP18.2.B.xlsx', 'select * from [TabelaIBPTaxSP18.2.B$]')
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
          isnull(subString(ex,1,2),''),
          subString(chave,1,10),
          subString(fonte,1,10),
          subString(versao,1,10),
          vigenciafim,
          vigenciainicio
     from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\TabelaIBPTaxSP18.2.C.xlsx', 'select * from [TabelaIBPTaxSP18.2.C$]')
    where tipo=0

update TBS092 set NCMDES=upper(NCMDES)

select top 1 * from TBS092 (nolock)

update TBS092 set NCMALIPIS=0,NCMALICOF=0,NCMIVA=0,NCMALIIPI=0

update TBS092 set NCMDES=upper(NCMDES)


-- NCM em NF para fora do estado via software SEFAZ

select NCMCOD from TBS092 (nolock)
 where NCMCOD in('96082000',
'84716053',
'42021210',
'84439923',
'96092000',
'96081000',
'82119400',
'48209000',
'48025610',
'82119390',
'85171100',
'96039000',
'48182000',
'68053090',
'63071000',
'38085010',
'34013000',
'38089410',
'39261000',
'82141000',
'96100000',
'39241000',
'39232190',
'22072010',
'48171000',
'48204000',
'48201000',
'38249029',
'85061030',
'40169200',
'40162000',
'40151900',
'96091000',
'44219000',
'35061090',
'48023000')


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
     from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\TabelaIBPTaxSP18.1.B.xlsx', 'select * from [TabelaIBPTaxSP18.1.B$]')
    where tipo=0

select NCMCOD from TBS0921 (nolock) where not exists(select '' from TBS092 (nolock) where TBS092.NCMCOD=TBS0921.NCMCOD)

select * from TBS092 (nolock) where NCMALIIPI > 0

select NCMCOD from TBS0921 (nolock) where not exists(select '' from TBS092 (nolock) where TBS0921.NCMCOD=TBS092.NCMCOD)

begin tran
delete TBS0921 where not exists(select '' from TBS092 (nolock) where TBS092.NCMCOD=TBS0921.NCMCOD)
commit tran
rollback tran


-- inserção manual

/*
select * from TBS092 (nolock) where NCMCOD='85365010'
select * from TBS092 (nolock) where NCMCOD='85363090'

select getdate()

insert into TBS092
select '85363090','','OUTROS',0,0,0,getdate(),0,
*/