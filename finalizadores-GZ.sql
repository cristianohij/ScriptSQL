-- muito lento

select codigo from [MYSQLGZ].[concentdb]..[clientes]

select tipopagto,modalid.descricao,sum(valortot),count(*)
  from MYSQLGZ...movcaixa
       inner join MYSQLGZ...modalid on movcaixa.tipopagto=modalid.codigo
 where data = '20160517' and status=03 and caixa=1
 group by tipopagto,modalid.descricao

select tipo,moda,valor,conta from openquery(MYSQLGZ,'select mov.tipopagto as tipo,moda.descricao as moda,sum(mov.valortot) as valor,count(*) as conta
  from movcaixa mov
       inner join modalid moda on mov.tipopagto=moda.codigo
 where mov.data = ''20160517'' and mov.status=03 and mov.caixa=1
 group by mov.tipopagto,moda.descricao')

select mov.tipopagto,moda.descricao,sum(mov.valortot),count(*)
  from MYSQLGZ...movcaixa mov
       inner join MYSQLGZ...modalid moda on mov.tipopagto=moda.codigo
 where mov.data = '20160517' and mov.status=03 and mov.caixa=1
 group by mov.tipopagto,moda.descricao
 
-- muito mais rápido

Execute('select mov.ecf,mov.caixa,mov.tipopagto as tipo,moda.descricao as moda,sum(mov.valortot) as valor,count(*) as conta
  from movcaixa mov
       inner join modalid moda on mov.tipopagto=moda.codigo
 where mov.data = "20180625" and mov.status=03 and mov.caixa=1
 group by mov.tipopagto,moda.descricao') at MYSQLGZ
 
 execute('SELECT * FROM clientes') at MYSQLGZ

Execute('select mov.caixa,
                sum(mov.valortot) as total,count(*) as cupons,
                round(sum(mov.valortot)/count(*),2) as medio,
                format((sum(mov.valortot)*100/(select sum(valortot) from movcaixa where data="20180625" and status=03)),4) as "%"
           from movcaixa mov
                inner join modalid moda on mov.tipopagto=moda.codigo
          where mov.data = "20180625" and mov.status=03
          group by mov.caixa') at MYSQLGZ

Execute('select mov.tipopagto as finalizador,
                moda.descricao as pagamento,
                sum(mov.valortot) as total,count(*) as cupons,
                round(sum(mov.valortot)/count(*),2) as medio,
                format((sum(mov.valortot)*100/(select sum(valortot) from movcaixa where data="20160517" and status=03 and caixa=1)),4) as "%"
           from movcaixa mov
                inner join modalid moda on mov.tipopagto=moda.codigo
          where mov.data = "20180625" and mov.status=03 and mov.caixa=1
          group by mov.tipopagto,moda.descricao') at MYSQLGZ


declare @comando varchar(500), @ecf int

set @ecf=18

set @comando = 'execute(''select * from ecf where ecf='+str(@ecf,3)+''') at MYSQLGZ'

select @comando

execute(@comando)

Execute('select ecf,serie,usrnumero into #teste from ecf m order by ecf') at MYSQLGZ 

-- reporting services

-- ="select * FROM OPENQUERY(nome do linked server,'SELECT * FROM TABELA WHERE ID_CAMPO = " & Parameters!ReportParameter1.Value & "')"


--

drop table ##gz

create table ##gz (ano varchar(4), mes varchar(2), valor decimal(10,2))

declare @comando as varchar(1000)

set @comando = 
'execute(
''select cast(year(data) as char(4)) ano,DATE_FORMAT(data,"%m") mes, ifnull(sum(valortot),0) valor
  from movcaixa
 where data between "20140101" and "20181130"
       and status="03" and cancelado<>"S"
 group by DATE_FORMAT(data,"%Y%m")'')
at MYSQLGZ'

insert into ##gz exec(@comando)

delete ##gz

select * from ##gz

select top 10 convert(char(7),NFEDATEFE,120) from TBS059 with (nolock)

NFETOTOPE(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))

drop table ##dev

with tab as
(
select Left(convert(char(6),NFEDATEFE,112),4) ano,right(convert(char(6),NFEDATEFE,112),2) mes,dbo.NFETOTOPE(0,NFETIP,NFENUM,NFECOD,0,SERCOD) valor
  from TBS059 with (nolock)
 where TBS059.NFECAN='N' and TBS059.NFETIP='D' and TBS059.NFEDATEFE between '20140101' and '20181130'
       and (TBS059.NFEOBS Like('%CUPO%')
       or exists(select '' from TBS0596 with (nolock)
                  where TBS0596.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0596.NFETIP=TBS059.NFETIP and TBS0596.NFENUM=TBS059.NFENUM and TBS0596.NFECOD=TBS059.NFECOD and
                        TBS0596.SEREMPCOD=TBS059.SEREMPCOD and TBS0596.SERCOD=TBS059.SERCOD and TBS0596.NFENFRTIP='CUP'))
)

select ano,mes,sum(valor) as valor into ##dev from tab group by ano,mes order by ano,mes

select * from ##dev

select NFETIPENT,*
  from TBS059 with (nolock)
       Left join TBS0596 with (nolock) on TBS0596.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0596.NFETIP=TBS059.NFETIP and TBS0596.NFENUM=TBS059.NFENUM and TBS0596.NFECOD=TBS059.NFECOD and
                                           TBS0596.SEREMPCOD=TBS059.SEREMPCOD and TBS0596.SERCOD=TBS059.SERCOD
 where TBS059.NFECAN='N' and TBS059.NFETIP='D' and TBS059.NFEDATEFE between '20140101' and '20141231'
       and TBS059.NFEOBS Like('%CUPO%')

select NFETIPENT,*
  from TBS059 with (nolock)
--       Left join TBS0596 with (nolock) on TBS0596.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0596.NFETIP=TBS059.NFETIP and TBS0596.NFENUM=TBS059.NFENUM and TBS0596.NFECOD=TBS059.NFECOD and
--                                           TBS0596.SEREMPCOD=TBS059.SEREMPCOD and TBS0596.SERCOD=TBS059.SERCOD
 where TBS059.NFECAN='N' and TBS059.NFETIP='D' and TBS059.NFEDATEFE between '20140101' and '20141231'
       and (TBS059.NFEOBS Like('%CUPO%')
       or exists(select '' from TBS0596 with (nolock)
                  where TBS0596.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0596.NFETIP=TBS059.NFETIP and TBS0596.NFENUM=TBS059.NFENUM and TBS0596.NFECOD=TBS059.NFECOD and
                        TBS0596.SEREMPCOD=TBS059.SEREMPCOD and TBS0596.SERCOD=TBS059.SERCOD and TBS0596.NFENFRTIP='CUP'))

select top 10 * from TBS0596 with (nolock)

select * from ##gz

drop table #relatorio

select ##gz.ano,##gz.mes,##gz.valor-isnull((select valor from ##dev where ##dev.ano=##gz.ano collate database_default and ##dev.mes=##gz.mes collate database_default),0) as valor
  into #relatorio
  from ##gz

select ano,mes,str(valor,10) from #relatorio

select str(ano)+'-'+mes,str(valor,10) from #relatorio