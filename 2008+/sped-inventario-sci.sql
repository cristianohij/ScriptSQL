select *
  into #sped
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\estoque1217.xls', 'select * from [dados$]') 

drop table #produtos

select *
  into #produtos
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\estoque1217.xls', 'select * from [produtos$]') 

select * from #produtos

select cst from #produtos group by cst

update #produtos set cst='0/60' where cst='fev-60'


select '"'+produto+'",' as 'produto',
       referencia+',' as 'referencia',
	   convert(decimal(16,4),quantidade) as 'quantidade',
	   convert(decimal(16,4),valor) as 'valor',
	   convert(decimal(16,4),0) as 'valorICMS',
	   convert(decimal(16,4),total) as 'total',
	   indicador,
	   '"'+cnpj+'",' as 'cnpj',
	   '"01.1.2.10.001",' as 'contaSPED',
	   '"'+'",' as 'observacao',
	   convert(decimal(16,4),0) as 'baseICMS',
	   ',"'+isnull((select subString(CSTICMS,1,1)+'/'+subString(CSTICMS,2,2) from #produtos where codigo=produto),'0/00')+'",' as 'CST',
	   convert(decimal(16,4),0) as 'valorICMSST',
	   convert(decimal(16,4),0) as 'valorIPI',
	   convert(decimal(16,4),0) as 'valorPIS',
	   convert(decimal(16,4),0) as 'valorCOFINS',
	   convert(decimal(16,4),0) as 'valorIR'
  from #sped

  select sum(total) from #sped

  delete #sped where produto is null

  update #sped set indicador=0



select '"'+rtrim(codigo)+'",' + -- código do produto
       '12/2015,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),saldo)))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),valor)))) + ',' + -- valor unitário
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS (igual a 0)
       rtrim(convert(char(12),(convert(decimal(12,4),total)))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"'+(select rtrim(EMPCGC) collate database_default from TBS023 (nolock) where EMPCOD=1) + '",' + -- CNPJ
       '"01.1.2.10.001",' + -- conta sped
       '"'+'",' + -- observação (vazia)
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- base do ICMS (igual a 0)
       '"'+(select PROSTBA+'/'+PROSTBB from TBS010 (nolock) where PROCOD collate database_default=codigo) + '",' +  -- CST-ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- valor IR
  from INVND
-- where codigo='0040282'
 order by codigo

select sum(valor*saldo) from INVND



-- tella barros

drop table #sped

select *
  into #sped
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\inv062017.xls', 'select * from [dados$]') 

drop table #produtos

select *
  into #produtos
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\inv062017.xls', 'select * from [produtos$]') 

select * from #produtos where isnumeric(codigo)<>0

delete #produtos where codigo='2'

select * from #sped

delete #sped where codigo is null

select '"'+rtrim(#sped.codigo)+'",' + -- código do produto
       '06/2017,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),qtde)))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),preco)))) + ',' + -- valor unitário
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS (igual a 0)
       rtrim(convert(char(12),(convert(decimal(12,4),total)))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"57224255000155",' + -- CNPJ
       '"01.1.2.10.001",' + -- conta sped
       '"'+'",' + -- observação (vazia)
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- base do ICMS (igual a 0)
       '"'+(select CST from #produtos where #produtos.codigo=#sped.codigo) + '",' +  -- CST-ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- valor IR
  from #sped

select SUM(qtde*preco) from #sped

select count(*) from #sped

select #sped.codigo,#produtos.codigo from #sped left join #produtos on #sped.codigo=#produtos.codigo

select #sped.codigo,#produtos.codigo from #sped full outer join #produtos on #sped.codigo=#produtos.codigo

select #sped.codigo from #sped where not exists(select '' from #produtos where #produtos.codigo=#sped.codigo)


--- MRE

select * from TBS034 (nolock)

select ESTLOC,COUNT(*) from TBS032 (nolock) group by ESTLOC

select * from TBS015 (nolock)

select TBS032.PROCOD as codigo,
       TBS010.PRODES as descricao,
       TBS010.PROSTBA+'/'+TBS010.PROSTBB as cst,
       --(select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS032.PROCOD),
       --(select PROSTBA+'/'+PROSTBB from TBS010 (nolock) where TBS010.PROCOD=TBS032.PROCOD),
       TBS010.PROICMSINT as icms,
       TBS010.PROCLAFIS as ncm,
       isnull(dbo.PDPCUSBAS(0,TBS032.PROCOD),0) as custo,
       ESTQTDATU as qtde
  into #ATIVOS
  from TBS032 (nolock) Left join TBS010 (nolock) on TBS010.PROCOD=TBS032.PROCOD
 where ESTLOC=1 and
       ESTQTDATU > 0 and
       TBS010.PROSTATUS='A'

select SUM(custo*qtde) from #ATIVOS

select * from #ATIVOS

drop table #TODOS
       
select TBS032.PROCOD as codigo,
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS032.PROCOD) as descricao,
       (select PROSTBA+'/'+PROSTBB from TBS010 (nolock) where TBS010.PROCOD=TBS032.PROCOD) as cst,
       isnull(dbo.PDPCUSBAS(0,TBS032.PROCOD),0) as custo,
       ESTQTDATU as qtde
  into #TODOS
  from TBS032 (nolock)
 where ESTLOC=1 and
       ESTQTDATU > 0
       

select * from #TODOS where custo is null
       
select SUM(custo*qtde) from #TODOS       



select codigo,descricao,custo,qtde,CST
  into #produtos
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\estoque-12-2015.xlsx', 'select * from [planilha1$]') 

select codigo,descricao,CSTnovo,ICMS
  into #semst
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\mrest.xlsx', 'select * from [planilha1$]') 


select * from #produtos

select * from #semst

select A.codigo,A.descricao,A.CSTnovo as CST,B.custo as preco,B.qtde,case when A.ICMS = 0 then 18 else A.ICMS end as ICMS
  --into #sped
  from #semst as A Left join #produtos as B on B.codigo=A.codigo
 where B.qtde > 0  

select * from #semst

select SUM(preco*qtde) from #sped

select * from #sped


select '"'+rtrim(#sped.codigo)+'",' + -- código do produto
       '12/2015,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),qtde)))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),preco)))) + ',' + -- valor unitário
       rtrim(convert(char(12),(convert(decimal(12,4),qtde*preco*ICMS/100)))) + ',' + -- valor do ICMS (igual a 0)
       rtrim(convert(char(12),(convert(decimal(12,4),qtde*preco)))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"57224255000155",' + -- CNPJ
       '"01.1.2.10.001",' + -- conta sped
       '"'+'",' + -- observação (vazia)
       rtrim(convert(char(12),(convert(decimal(12,4),qtde*preco)))) + ',' + -- base do ICMS
       '"'+(select CST from #produtos where #produtos.codigo=#sped.codigo) + '",' +  -- CST-ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- valor IR
  from #sped
  
  



---  MRE

select *
  into #produtos
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\promre.xlsx', 'select * from [planilha1$]') 
  
  select * from #produtos

select *
  into #sped
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\spedmre.xlsx', 'select * from [dados$]') 

select * from #sped
  
  select '"'+rtrim(#sped.codigo)+'",' + -- código do produto
       '12/2015,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),qtde)))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),custo)))) + ',' + -- valor unitário
       rtrim(convert(char(12),(convert(decimal(12,4),valoricms)))) + ',' + -- valor do ICMS (igual a 0)
       rtrim(convert(char(12),(convert(decimal(12,4),qtde*custo)))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"57224255000155",' + -- CNPJ
       '"01.1.2.10.001",' + -- conta sped
       '"'+'",' + -- observação (vazia)
       rtrim(convert(char(12),(convert(decimal(12,4),bcicms)))) + ',' + -- base do ICMS
       '"'+(select origem+'/'+tributacao from #produtos where #produtos.codigo=#sped.codigo) + '",' +  -- CST-ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- valor IR
  from #sped
  
select '"'+rtrim(#sped.codigo)+'",' + -- código do produto
       '12/2015,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),sum(qtde))))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),avg(custo))))) + ',' + -- valor unitário
       rtrim(convert(char(12),(convert(decimal(12,4),sum(valoricms))))) + ',' + -- valor do ICMS (igual a 0)
       rtrim(convert(char(12),(convert(decimal(12,4),sum(qtde*custo))))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"57224255000155",' + -- CNPJ
       '"01.1.2.10.001",' + -- conta sped
       '"'+'",' + -- observação (vazia)
       rtrim(convert(char(12),(convert(decimal(12,4),sum(bcicms))))) + ',' + -- base do ICMS
       '"'+(select origem+'/'+tributacao from #produtos where #produtos.codigo=#sped.codigo) + '",' +  -- CST-ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- valor IR
  from #sped
 group by #sped.codigo
 

-- MRE 20/03/2017

select PROCOD as codigo,
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS032.PROCOD),
       ESTQTDATU,
       isnull((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD=PROCOD),0),
       floor(ESTQTDATU/2),
       ceiling(ESTQTDATU/2)
  from TBS032 (nolock)
 where ESTLOC=1 and ESTQTDATU > 0

drop table #inventario

select PROCOD as codigo,
       round(floor(ESTQTDATU/2),4) as qtde,
       round(isnull((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD=PROCOD),0),4) as preco
  into #inventario
  from TBS032 (nolock)
 where ESTLOC=1 and ESTQTDATU > 0

select '"'+rtrim(codigo)+'",' + -- código do produto
       '12/2016,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),qtde)))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),preco)))) + ',' + -- valor unitário
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS (igual a 0)
       rtrim(convert(char(12),(convert(decimal(12,4),round(qtde*preco,4))))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"09336957000188",' + -- CNPJ
       '"04.1.1.01.002",' + -- conta sped
       '"'+'",' + -- observação (vazia)
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- base do ICMS (igual a 0)
       '"'+(select PROSTBA+'/'+PROSTBB from TBS010 (nolock) where PROCOD=codigo) + '",' +  -- CST-ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- valor IR
  from #inventario
 where qtde > 0 and preco > 0

select * from TBS023 (nolock)


-- 13/03/2018

-- MRE

select * from TBS023 (nolock)

select top 10 * from TBS051 (nolock)

select distinct LMEEMPCOD,LMELOCEST from TBS051 (nolock)

select * from TBS034 (nolock)

select * from TBS034 (nolock)

drop table #inventario

declare @data date

set @data='20171231'

/*
select PROCOD as codigo,
       isnull((select top 1 round(floor(LMEQTDSAL/case when LMEQTDSAL >= 8 then 8 else 1 end),4) from TBS051 (nolock) where LMEEMPCOD=2 and TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=2 and LMEINFALT='E' order by LMEREG desc),0) as qtde,
       round(isnull((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD=PROCOD),0),4) as preco,
       PROSTBA+'/'+PROSTBB as cst,
       PRODES as descricao
  into #inventario
  from TBS010 (nolock)
*/

select PROCOD as codigo,
       isnull((select top 1 round(ceiling(LMEQTDSAL)/7.5,4) from TBS051 (nolock) where LMEEMPCOD=2 and TBS051.PROCOD=TBS010.PROCOD and convert(date,LMEDATHOR)<=@data and LMELOCEST=2 and LMEINFALT='E' order by LMEREG desc),0) as qtde,
       round(isnull((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD=PROCOD),0),4) as preco,
       PROSTBA+'/'+PROSTBB as cst,
       PRODES as descricao,
       PROREDBASICMS reducao
  into #inventario
  from TBS010 (nolock)
 
 select * from #inventario  where qtde > 0 and preco > 0
 
 select SUM(qtde*preco) from #inventario  where qtde > 0 and preco > 0
 
 
 select '"'+rtrim(codigo)+'",' + -- código do produto
       '12/2017,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),qtde)))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),preco)))) + ',' + -- valor unitário
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS (igual a 0)
       rtrim(convert(char(12),(convert(decimal(12,4),round(qtde*preco,4))))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"26457530000157",' + -- CNPJ
       '"04.1.1.01.002",' + -- conta sped
       '"'+'",' + -- observação (vazia)
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- base do ICMS (igual a 0)
       '"'+cst+ '",' +  -- CST-ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) --+ ',' + -- valor IR
       --'"'+descricao+'"'
  from #inventario
 where qtde > 0 and preco > 0
 
 -- com ICMS
 
 select '"'+rtrim(codigo)+'",' + -- código do produto
       '12/2017,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),qtde)))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),preco)))) + ',' + -- valor unitário

       case
          when right(cst,2) in('00','20') then
             rtrim(convert(char(12),(convert(decimal(12,4),round(qtde*preco*(case reducao when 0 then 1 else (100-reducao)/100 end)*18/100,4))))) -- valor do ICMS
          else
             rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- valor do ICMS (igual a 0)
       end + ',' +

       rtrim(convert(char(12),(convert(decimal(12,4),round(qtde*preco,4))))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"26457530000157",' + -- CNPJ
       '"04.1.1.01.002",' + -- conta sped
       '"'+'",' + -- observação (vazia)

       case
          when right(cst,2) in('00','20') then
             rtrim(convert(char(12),(convert(decimal(12,4),round(qtde*preco*(case reducao when 0 then 1 else (100-reducao)/100 end),4))))) -- base do ICMS (igual a 0)
          else
             rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- base do ICMS (igual a 0)
       end + ',' +

       '"'+cst+ '",' +  -- CST-ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) --+ ',' + -- valor IR
       --'"'+descricao+'"'
  from #inventario
 where qtde > 0 and preco > 0
 
 select sum(round(qtde*preco,4)) from #inventario
 
 select cst from #inventario group by cst
 
 select PROSTBB,COUNT(*) from TBS010 (nolock) group by PROSTBB
 
 begin tran
 update TBS010 set PROSTBB='20' where PROSTBB='2'
 rollback tran
 commit tran


-- tella

select top 10 * from #sped

select '"'+rtrim(codigo)+'",' + -- código do produto
       '12/2017,' + -- referência
       rtrim(convert(char(12),(convert(decimal(12,4),qtde)))) + ',' + -- quantidade
       rtrim(convert(char(12),(convert(decimal(12,4),preco)))) + ',' + -- valor unitário
       case
          when right(cst,2) in('00','20') then
             rtrim(convert(char(12),(convert(decimal(12,4),round(valor*(case reducao when 0 then 1 else reducao/100 end)*18/100,4))))) -- valor do ICMS
          else
             rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- valor do ICMS (igual a 0)
       end + ',' +
       rtrim(convert(char(12),(convert(decimal(12,4),round(valor,4))))) + ',' + -- valor total
       '1,' + -- indicador de propriedade
       '"57224255000155",' + -- CNPJ
       '"01.1.2.10.001",' + -- conta sped
       '"'+'",' + -- observação (vazia)

       case
          when right(cst,2) in('00','20') then
             rtrim(convert(char(12),(convert(decimal(12,4),round(valor*(case reducao when 0 then 1 else reducao/100 end),4))))) -- base do ICMS
          else
             rtrim(convert(char(12),(convert(decimal(12,4),0)))) -- base do ICMS (igual a 0)
       end + ',' +

       '"'+cst+ '",' +  -- CST-ICMS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do ICMS-ST
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do IPI
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor do PIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) + ',' + -- valor CONFIS
       rtrim(convert(char(12),(convert(decimal(12,4),0)))) --+ ',' + -- valor IR
       --'"'+descricao+'"'
  from #sped
       inner join #produtos on produto=codigo
 where qtde > 0 and preco > 0
