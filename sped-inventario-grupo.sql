select * from master..sysservers

select Ant.PROCOD,Ant.PROSTBB,Ant.PROCLAFIS,Nov.PROCOD,Nov.PROSTBB,Nov.PROCLAFIS
  from TBS010 as Ant (nolock)
       join TANBYM.SIBD.dbo.TBS010 as Nov (nolock) on Ant.PROCOD=Nov.PROCOD
 where Ant.PROSTBB='60' and Ant.PROSTBB <> Nov.PROSTBB
 
 
select top 1 NFSDATEMI from TBS067 (nolock) order by NFSDATEMI desc 

drop table #produtos

select codigo,descricao,valor as custo,saldo as qtde
  into #produtos
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\grupo.xlsx', 'select * from [ND$]') 

select * from #produtos

alter table #produtos add ICMS smallint, CST char(4)

update #produtos set ICMS=0,CST=''

-- produtos que sairam da st

drop table #spedsemst

select Ant.PROCOD as codigo,
       Nov.PROSTBA+'/'+Ant.PROSTBB as CST,
       Nov.PRODES,
       case when Nov.PROICMSINT = 0 then 18 else Nov.PROICMSINT end as ICMS,
       isnull(Est.qtde,0) as qtde,
       isnull(Est.custo,0) as custo
  into #spedsemst
  from SIBDEST.dbo.TBS010 as Ant (nolock)
       join TBS010 as Nov (nolock) on Nov.PROCOD=Ant.PROCOD
       join #produtos as Est on Est.codigo collate database_default=Ant.PROCOD
 where Ant.PROSTBB='60' and Ant.PROSTBB <> Nov.PROSTBB
 
 
 -- produtos que entraram na st

drop table #spedcomst

select Ant.PROCOD as codigo,
       Nov.PROSTBA+'/'+Nov.PROSTBB as CST,
       Nov.PRODES,
       case when Nov.PROICMSINT = 0 then 18 else Nov.PROICMSINT end as ICMS,
       isnull(Est.qtde,0) as qtde,
       isnull(Est.custo,0) as custo
  into #spedcomst
  from SIBDEST.dbo.TBS010 as Ant (nolock)
       join TBS010 as Nov (nolock) on Nov.PROCOD=Ant.PROCOD
       join #produtos as Est on Est.codigo collate database_default=Ant.PROCOD
 where Nov.PROSTBB='60' and Ant.PROSTBB <> Nov.PROSTBB
 
 
 select '"'+rtrim(codigo)+'",' + -- código do produto
       '12/2015,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),qtde)))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),custo)))) + ',' + -- valor unitário
       rtrim(convert(char(12),(convert(decimal(12,4),qtde*custo*ICMS/100)))) + ',' + -- valor do ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),qtde*custo)))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"65069593000198",' + -- CNPJ
       '"01.1.2.10.001",' + -- conta sped
       '"'+'",' + -- observação (vazia)
       rtrim(convert(char(12),(convert(decimal(12,4),qtde*custo)))) + ',' + -- base do ICMS
       '"'+Ltrim(rtrim(CST))+'",' +  -- CST-ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- valor IR
  from #spedsemst
  



---



select * from SPEDCOMST where codigo is null

select SPEDCOMST.codigo,sum(isnull(dbo.NFSBASICMS(0, TBS0671.NFSNUM, 0, TBS0671.SNESER, TBS0671.NFSITE),0))
  from SPEDCOMST (nolock)
       inner join TBS0671 (nolock) on TBS0671.PROCOD=SPEDCOMST.codigo
       inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS067.SNESER and TBS080.ENFNUM=TBS067.NFSNUM
 where TBS067.NFSDATEMI between '20150101' and '20151231' and
       TBS067.NFSCAN='N' and
       TBS080.ENFSIT=6
 group by SPEDCOMST.codigo

drop table #notas

select TBS0671.SNESER as serie,
       TBS0671.NFSNUM as numero,
       TBS0671.PROCOD as produto,
       TBS067.NFSDATEMI as emissao,
       sum(isnull(dbo.NFSBASICMS(0,TBS0671.NFSNUM,0,TBS0671.SNESER,TBS0671.NFSITE),0)) as bcicms,
       sum(isnull(dbo.NFSVALICMS(0,TBS0671.NFSNUM,0,TBS0671.SNESER,TBS0671.NFSITE),0)) as valicms,
       sum(isnull(dbo.NFSBASICMSST(0,TBS0671.NFSNUM,0,TBS0671.SNESER,TBS0671.NFSITE),0)) as bcicmsst,
       sum(isnull(dbo.NFSVALICMSST(0,TBS0671.NFSNUM,0,TBS0671.SNESER,TBS0671.NFSITE),0)) as valicmsst
  into #notas
  from TBS0671 (nolock)
       inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS067.SNESER and TBS080.ENFNUM=TBS067.NFSNUM
 where TBS067.NFSDATEMI between '20150101' and '20151231' and
       TBS067.NFSCAN='N' and
       TBS080.ENFSIT=6
 group by TBS0671.SNESER,TBS0671.NFSNUM,TBS0671.PROCOD,TBS067.NFSDATEMI

select * from #notas where produto in('10300125','10300127','3251281','103000126','10300124') order by produto

select * from #notas order by produto

drop table #estoque

--select codigo,descricao,'   ' as CST,valor as custo,saldo as qtde,0 as bcicms,0 as valicms,0 as bcicmsst,0 as valicmsst
--  into #estoque
--  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\grupo.xlsx', 'select * from [ND$]') 

select codigo,descricao,valor as custo,saldo as qtde
  into #estoque
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\grupo.xlsx', 'select * from [ND$]') 

select * from #estoque

drop table #spedcomst

select Ant.PROCOD as codigo,
       Nov.PROSTBA+'/'+Nov.PROSTBB as CST,
       Nov.PRODES,
       isnull(Est.qtde,0) as qtde,
       isnull(Est.custo,0) as custo,
       isnull((select sum(bcicms) from #notas where #notas.produto=Ant.PROCOD),0) as bcicms,
       isnull((select sum(valicms) from #notas where #notas.produto=Ant.PROCOD),0) as valicms,
       isnull((select sum(bcicmsst) from #notas where #notas.produto=Ant.PROCOD),0) as bcicmsst,
       isnull((select sum(valicmsst) from #notas where #notas.produto=Ant.PROCOD),0) valicmsst
  into #spedcomst
  from SIBDEST.dbo.TBS010 as Ant (nolock)
       inner join TBS010 as Nov (nolock) on Nov.PROCOD=Ant.PROCOD
       inner join #estoque as Est on Est.codigo collate database_default=Ant.PROCOD
 where Nov.PROSTBB in('10','30','60','70') and Ant.PROSTBB <> Nov.PROSTBB

select * from #spedcomst

drop table #spedsemst

select Ant.PROCOD as codigo,
       Nov.PROSTBA+'/'+Ant.PROSTBB as CST,
       Nov.PRODES,
       isnull(Est.qtde,0) as qtde,
       isnull(Est.custo,0) as custo,
       isnull((select sum(bcicms) from #notas where #notas.produto=Ant.PROCOD),0) as bcicms,
       isnull((select sum(valicms) from #notas where #notas.produto=Ant.PROCOD),0) as valicms,
       isnull((select sum(bcicmsst) from #notas where #notas.produto=Ant.PROCOD),0) as bcicmsst,
       isnull((select sum(valicmsst) from #notas where #notas.produto=Ant.PROCOD),0) valicmsst
  into #spedsemst
  from SIBDEST.dbo.TBS010 as Ant (nolock)
       join TBS010 as Nov (nolock) on Nov.PROCOD=Ant.PROCOD
       join #estoque as Est on Est.codigo collate database_default=Ant.PROCOD
 where Ant.PROSTBB in('10','30','60','70') and Ant.PROSTBB <> Nov.PROSTBB

 select '"'+rtrim(codigo)+'",' + -- código do produto
       '12/2015,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),qtde)))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),custo)))) + ',' + -- valor unitário
       rtrim(convert(char(12),(convert(decimal(12,4),valicms)))) + ',' + -- valor do ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),qtde*custo)))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"65069593000198",' + -- CNPJ
       '"01.1.2.10.001",' + -- conta sped
       '"'+'",' + -- observação (vazia)
       rtrim(convert(char(12),(convert(decimal(12,4),bcicms)))) + ',' + -- base do ICMS
       '"'+Ltrim(rtrim(CST))+'",' +  -- CST-ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),valicmsst)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- valor IR
--  from #spedcomst
  from #spedsemst



--

select * from INVND (nolock)

select INVND.codigo,INVND.descricao,INVND.unidade,INVND.valor,INVND.saldo,INVND.total,TBS010.PROCLAFIS,TBS010.PROSTBA+TBS010.PROSTBB
  from INVND (nolock)
       inner join TBS010 on TBS010.PROCOD=INVND.codigo collate database_default
       
-- 30/03/16

drop table #produtos

select codigo,descricao,unidade,custo,saldo,cst,situacao
  into #produtos
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\grupogelder.xlsx', 'select * from [ND$]') 

select * from #produtos

update #produtos set situacao='' where situacao is null

alter table #produtos add ICMS smallint

update #produtos set ICMS=0

select PROICMSINT from SIBD.dbo.TBS010 (nolock) where PROICMSINT > 0

update #produtos set ICMS=isnull((select PROICMSINT from SIBD.dbo.TBS010 (nolock) where PROICMSINT > 0 and PROCOD=#produtos.codigo collate database_default),0)

select * from #produtos where ICMS > 0

update #produtos set ICMS=18 where ICMS = 0 or ICMS is null

select ICMS,count(*) from #produtos group by ICMS

alter table #produtos add redbc decimal(7,4)

update #produtos set redbc=0 where redbc is null

select PROREDBASICMS from SIBD.dbo.TBS010 (nolock) where PROREDBASICMS > 0

update #produtos set redbc=isnull((select PROREDBASICMS from SIBD.dbo.TBS010 (nolock) where PROREDBASICMS > 0 and PROCOD=#produtos.codigo collate database_default),0)

select * from #produtos where redbc > 0

select rtrim(codigo),REPLICATE('0',7-LEN(codigo)) + codigo from #produtos where LEN(codigo) < 7

--update #produtos set codigo=REPLICATE('0',7-LEN(codigo)) + codigo where LEN(codigo) < 7

select saldo,custo,redbc,ICMS,saldo*custo as total,
       round(redbc,2) as reducao,
       --round((100-redbc)/100,4) as reduzir,
       CONVERT(decimal(5,2),ICMS)/100 as aliqicms,
       (saldo*custo)*(round(100-redbc,4)/100) as baseicms,
       (saldo*custo)*(round((100-redbc),4)/100)*(convert(decimal(5,2),ICMS)/100) as valicms
  from #produtos
 where redbc > 0

-- com ICMS

 select '"'+rtrim(codigo)+'",' + -- código do produto
       '12/2015,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),saldo)))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),custo)))) + ',' + -- valor unitário
       rtrim(convert(char(12),(convert(decimal(12,4),(saldo*custo)*(round((100-redbc),4)/100)*(convert(decimal(5,2),ICMS)/100))))) + ',' + -- valor do ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),saldo*custo)))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"65069593000198",' + -- CNPJ
       '"01.1.2.10.001",' + -- conta sped
       '"'+'",' + -- observação (vazia)
       rtrim(convert(char(12),(convert(decimal(12,4),(saldo*custo)*(round(100-redbc,4)/100))))) + ',' + -- base do ICMS
       '"'+subString(rtrim(CST),1,1)+'/'+subString(rtrim(CST),2,2)+'",' +  -- CST-ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- valor IR
  from #produtos
 where situacao='removido'

-- sem ICMS

select '"'+rtrim(codigo)+'",' + -- código do produto
       '12/2015,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),saldo)))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),custo)))) + ',' + -- valor unitário
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),saldo*custo)))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"65069593000198",' + -- CNPJ
       '"01.1.2.10.001",' + -- conta sped
       '"'+'",' + -- observação (vazia)
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- base do ICMS
       '"'+subString(rtrim(cst),1,1)+'/'+subString(rtrim(cst),2,2)+'",' +  -- CST-ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- valor IR
  from #produtos
 where situacao='removido'


-- MRE

select * --codigo,descricao,unidade,custo,saldo,cst,situacao
  into #mre
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\estoque-12-2015.xlsx', 'select * from [planilha1$]') 

select * from #mre

select '"'+rtrim(codigo)+'",' + -- código do produto
       '12/2015,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),qtde)))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),custo)))) + ',' + -- valor unitário
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),qtde*custo)))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"09336957000188",' + -- CNPJ
       '"01.1.2.10.001",' + -- conta sped
       '"'+'",' + -- observação (vazia)
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- base do ICMS
       '"'+Ltrim(rtrim(CST))+'",' +  -- CST-ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- valor IR
  from #mre


-- 08/06/16

select * into #spedsemst
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\credito_icms.xlsx', 'select * from [Plan1$]')

select * from #spedsemst

delete #spedsemst where produto is null

drop table #spedsemst
  
 select '"'+rtrim(produto)+'",' + -- código do produto
       '12/2015,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),sum(qtde))))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),avg(custo))))) + ',' + -- valor unitário
       rtrim(convert(char(12),(convert(decimal(12,4),sum(valoricms))))) + ',' + -- valor do ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),sum(qtde*custo))))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"09336957000188",' + -- CNPJ
       '"01.1.2.10.001",' + -- conta sped
       '"'+'",' + -- observação (vazia)
       rtrim(convert(char(12),(convert(decimal(12,4),sum(bcicms))))) + ',' + -- base do ICMS
       --'"'+Ltrim(rtrim(CST))+'",' +  -- CST-ICMS
       '"0/00"' +
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- valor IR
--  from #spedcomst
  from #spedsemst
 group by produto


-- tella barros

select * into #sped
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\spedinv.xls', 'select * from [dados$]')

select * from #sped

select * into #produtos
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\spedinv.xls', 'select * from [produtos$]')

select * from #sped

select * from #produtos

delete #sped where codigo is null

select '"'+rtrim(#sped.codigo)+'",' + -- código do produto
       '10/2016,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),qtde)))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),preco)))) + ',' + -- valor unitário
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),qtde*preco)))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"57224255000155",' + -- CNPJ
       '"01.1.2.10.001",' + -- conta sped
       '"'+'",' + -- observação (vazia)
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- base do ICMS
--       '"'+Ltrim(rtrim((select cst from #produtos where #produtos.codigo=#sped.codigo)))+'",' +  -- CST-ICMS
       '"'+Ltrim(rtrim(cst))+'",' +  -- CST-ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- valor IR
  from #sped inner join #produtos on #sped.codigo=#produtos.codigo

 where not exists(select '' from #spedsemst where produto=codigo)
  