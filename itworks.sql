drop table ITW

select * into ITW
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\BEST BAG 27-03-revisao3.XLSB', 'select * from [Tabela$]')

update ITW set CESTSaida='' where CESTSaida is null
go
update ITW set NatRecPIS='' where NatRecPIS is null
go
update ITW set NatRecCOFINS='' where NatRecCOFINS is null
go

select top 10 * from TBS092 (nolock)

select * from ITW (nolock)
 where not exists(select '' from TBS092 (nolock) where NCMCOD=subString(ProdutoReferencialSPED,1,8) collate database_default)

select * from TBS092 (nolock) where NCMCOD='48022000'

select PROCOD,PROCLAFIS from TBS010 (nolock)
 where PROCLAFIS<>(select Left(ProdutoReferencialSPED,8) collate database_default from ITW (nolock) where Produto=PROCOD collate database_default)

select count(*)
  from TBS010 (nolock)
 where PROCLAFIS<>(select top 1 Left(ProdutoReferencialSPED,8) collate database_default from ITW (nolock) where Produto=PROCOD collate database_default)

select count(*)
  from TBS010 (nolock)
 where PROSTBB<>(select top 1 CSTSaida collate database_default from ITW (nolock) where Produto=PROCOD collate database_default)

select * from ITW (nolock) where subString(ProdutoReferencialSPED,1,8)='48022000'

select PROCOD,PROCLAFIS,PRODES,PROSTATUS from TBS010 (nolock) where PROCLAFIS='48022000'

select PRODES descricao,
       NCMDES ,PROCOD,PROCLAFIS,PROSTATUS,Left(Produto,10),subString(ProdutoReferencialSPED,1,8),Descricao,PROCODBAR1,CB
  from TBS010 (nolock)
       inner join ITW (nolock) on Produto=PROCOD collate database_default
       inner join TBS092 (nolock) on NCMCOD=subString(ProdutoReferencialSPED,1,8) collate database_default

 where PROCLAFIS<>Left(ProdutoReferencialSPED,8) collate database_default

--(select ProdutoReferencialSPED collate database_default from ITW (nolock) where Produto=PROCOD collate database_default)

drop table #tab

select 'itw' site,
       Left(Produto,10) collate database_default codigo,
       Left(Descricao,60) collate database_default descricao,
       Left(ProdutoReferencialSPED,8) collate database_default ncm,
       Left(CB,15) collate database_default barras,
       TBS092.NCMDES detalhes
--  into #tab
  from ITW (nolock)
       inner join TBS092 (nolock) on TBS092.NCMCOD=Left(ProdutoReferencialSPED,8) collate database_default
       inner join TBS010 (nolock) on PROCOD=Produto collate database_default
 where PROCLAFIS <> Left(ProdutoReferencialSPED,8) collate database_default

union
select 'sis',Left(PROCOD,10),PRODES,PROCLAFIS,Left(PROCODBAR1,15),TBS092.NCMDES
  from TBS010 (nolock)
       inner join TBS092 (nolock) on TBS092.NCMCOD=PROCLAFIS
       inner join ITW (nolock) on Produto=PROCOD collate database_default
 where PROCLAFIS <> Left(ProdutoReferencialSPED,8) collate database_default

select PRODES descricao,
       PROCOD codigo,
       PROSTATUS status,

       PROCLAFIS ncmSis,
       isnull((select top 1 categoria from NCM2018 (nolock) where NCM collate database_default=PROCLAFIS),'') catNCMsis,
       isnull((select top 1 descricao from NCM2018 (nolock) where NCM collate database_default=PROCLAFIS),'') desNCMsis,

       Left(ProdutoReferencialSPED,8) ncmItw,
       isnull((select top 1 categoria from NCM2018 (nolock) where NCM=Left(ProdutoReferencialSPED,8)),'') catNCMitw,
       isnull((select top 1 descricao from NCM2018 (nolock) where NCM=Left(ProdutoReferencialSPED,8)),'') desNCMitw,

       PROCODBAR1 barras,
       PROSTBB cstICMSSis,
       CSTSaida cstICMSItw,
       PROSTBPIS cstPISsis,
       CSTPisSaida cstPISItw
--  into #tab
  from TBS010 (nolock)
       inner join ITW (nolock) on Produto=PROCOD collate database_default
--       full join NCMFOR (nolock) on NCMFOR.produto=PROCOD collate database_default
 where PROCLAFIS<>Left(ProdutoReferencialSPED,8) collate database_default
--       or PROSTBB<>CSTSaida collate database_default
--       or CSTSaida<>PROSTBPIS collate database_default

select PROCLAFIS
  from TBS010 (nolock)
       inner join ITW (nolock) on Produto=PROCOD collate database_default
--       full join NCMFOR (nolock) on NCMFOR.produto=PROCOD collate database_default
 where PROCLAFIS<>Left(ProdutoReferencialSPED,8) collate database_default


-- em linhas

select 'AGrupo' origem,
       PROCOD codigo,
       PRODES descricao,
       PROSTATUS status,

       PROCLAFIS NCM,
       isnull((select top 1 categoria from NCM2018 (nolock) where NCM collate database_default=PROCLAFIS),'') categoria,
       isnull((select top 1 descricao from NCM2018 (nolock) where NCM collate database_default=PROCLAFIS),'') subcategoria,

       PROSTBB CSTICMS,

       TBS010.MARNOM marca

  into #tab
  from TBS010 (nolock)
       full join ITW (nolock) on Produto=PROCOD collate database_default
       full join NCMFOR (nolock) on NCMFOR.produto=PROCOD collate database_default
 where PROCLAFIS<>Left(ProdutoReferencialSPED,8) collate database_default
       and exists(select '' from STATUSPRO (nolock) where codigo=PROCOD and status='A')

union

select 'fornecedor' origem,
       PROCOD codigo,
       PRODES descricao,
       PROSTATUS status,

       isnull(NCMFOR.ncm,'') collate database_default,

       isnull((select top 1 categoria from NCM2018 (nolock) where NCM2018.NCM=NCMFOR.ncm),''),
       isnull((select top 1 descricao from NCM2018 (nolock) where NCM2018.NCM=NCMFOR.ncm),''),

       isnull(case Len(cst) when 3 then right(rtrim(cst),2) else right(rtrim(cst),3) end,'') collate database_default,

       ''

  from TBS010 (nolock)
       full join ITW (nolock) on Produto=PROCOD collate database_default
       full join NCMFOR (nolock) on NCMFOR.produto=PROCOD collate database_default
 where PROCLAFIS<>Left(ProdutoReferencialSPED,8) collate database_default
       and exists(select '' from STATUSPRO (nolock) where codigo=PROCOD and status='A')

union

select 'ITW' origem,
       PROCOD codigo,
       PRODES descricao,
       PROSTATUS status,

       isnull(Left(ITW.ProdutoReferencialSPED,8),'') collate database_default,

       isnull((select top 1 categoria from NCM2018 (nolock) where NCM=Left(ProdutoReferencialSPED,8)),''),
       isnull((select top 1 descricao from NCM2018 (nolock) where NCM=Left(ProdutoReferencialSPED,8)),''),

       isnull(ITW.CSTSaida,'') collate database_default,

       ''

  from TBS010 (nolock)
       full join ITW (nolock) on Produto=PROCOD collate database_default
       full join NCMFOR (nolock) on NCMFOR.produto=PROCOD collate database_default
 where PROCLAFIS<>Left(ProdutoReferencialSPED,8) collate database_default
       and exists(select '' from STATUSPRO (nolock) where codigo=PROCOD and status='A')

union

select 'Z',
       PROCOD,
       '',
       '',

       '',
       '',
       '',

       '',

       ''

  from TBS010 (nolock)
       full join ITW (nolock) on Produto=PROCOD collate database_default
       full join NCMFOR (nolock) on NCMFOR.produto=PROCOD collate database_default
 where PROCLAFIS<>Left(ProdutoReferencialSPED,8) collate database_default
       and exists(select '' from STATUSPRO (nolock) where codigo=PROCOD and status='A')

select codigo,descricao,status,origem,NCM,categoria,subcategoria,CSTICMS,marca from #tab

select count(distinct NCM) from #tab where origem='AGrupo'

select count(distinct NCM) from #tab where origem='ITW'



select top 7016
        'Z',
       '',
       '',
       '',
       '',
       '',
       '',
       '',
       ''
  from TBS010 (nolock)




select count(*) from TBS010 (nolock) inner join ITW (nolock) on Produto collate database_default=PROCOD where PROCLAFIS<>Left(ProdutoReferencialSPED,8) collate database_default

select * from #tab

select marca,count(*) from #tab group by marca order by marca

update #tab set cstPISsis='01' where cstPISsis=''

select * from #tab where ncmSis<>ncmItw collate database_default or cstICMSSis<>cstICMSItw collate database_default or cstPISsis<>cstPISItw collate database_default

select * from TBS092 (nolock) where NCMCOD in('42029200','42023200')


-- NCM baixada da internet

drop table NCM2018

select * into NCM2018
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\NCM-2018.xlsx', 'select * from [dados$]')

select * from NCM2018


-- ncm do fornecedor

drop table NCMFOR

select Left(produto,8) produto, Left(ncm,8) ncm, Left(cst,4) cst into NCMFOR
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\ncm-fornecedor.xlsx', 'select * from [ncm$]')

select * from NCMFOR (nolock)

select count(*)
  from TBS010 (nolock)
       inner join NCMFOR (nolock) on NCMFOR.produto=PROCOD collate database_default
 where PROCLAFIS<>ncm collate database_default

select PROCOD,produto,PROCLAFIS,ncm
  from TBS010 (nolock)
       inner join NCMFOR (nolock) on NCMFOR.produto=PROCOD collate database_default
 where PROCLAFIS<>ncm collate database_default

select PROCOD,PRODES,ncm
  from TBS010 (nolock)
       inner join NCMFOR (nolock) on NCMFOR.produto=PROCOD collate database_default
 where PROCLAFIS<>ncm collate database_default

-- itworks

select PROCOD,Produto,PROCLAFIS,Left(ProdutoReferencialSPED,8)
  from TBS010 (nolock)
       inner join ITW (nolock) on Produto=PROCOD collate database_default
 where PROCLAFIS<>Left(ProdutoReferencialSPED,8) collate database_default

select PROCOD,PRODES,Left(ProdutoReferencialSPED,8)
  from TBS010 (nolock)
       inner join ITW (nolock) on Produto=PROCOD collate database_default
 where PROCLAFIS<>Left(ProdutoReferencialSPED,8) collate database_default


-- status produtos

select 'ND' empresa, PROCOD codigo, PROSTATUS status into STATUSPRO from TBS010 (nolock)

union

select 'CD', PROCOD collate database_default, PROSTATUS collate database_default from cd.SIBD.dbo.TBS010

union

select 'TT', PROCOD, PROSTATUS from tt.SIBD.dbo.TBS010

union

select 'BB', PROCOD, PROSTATUS from bb.SIBD2.dbo.TBS010

union

select 'MI', PROCOD, PROSTATUS from mi.SIBD.dbo.TBS010

union

select 'PP', PROCOD, PROSTATUS from py.SIBD.dbo.TBS010

select * from STATUSPRO (nolock)

select codigo from STATUSPRO (nolock) where status='A' group by codigo

select empresa,status,count(*) from STATUSPRO (nolock) group by empresa,status order by empresa,status
