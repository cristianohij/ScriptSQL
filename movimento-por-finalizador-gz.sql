declare @datade date, @dataate date, @caixa varchar(50)

select @datade='20201007'
       ,@dataate='20201007'
	   ,@caixa='1,2,3,4,5,6'

declare @comando varchar(MAX)
set @comando = 'Execute(
''select 
caixa,
ecf,
mov.tipopagto as finalizador,
ifnull(moda.descricao,"DESCONTO") as pagamento,
status,
sum(mov.valortot) - sum(abatpgto)  as total,
case when status = 3 then sum(mov.valortot) - sum(abatpgto) else 0 end as liquido,
case when status = 12 then sum(mov.valortot) - sum(abatpgto) else 0 end as troco,
case when status = 2 then sum(mov.valortot) - sum(abatpgto) else 0 end as desconto,
case when status = 3 then count(*) else 0 end  as cupons

from 
movcaixa mov
left join modalid moda on mov.tipopagto=moda.codigo

where 
mov.data between "'+convert(char(8),@datade,112)+'" and "'+convert(char(8),@dataate,112)+'" and 
mov.status in (2,3,12) and 
cancelado <>"s" and
mov.caixa in('+@caixa+') 

group by 
mov.tipopagto,moda.descricao,status,caixa,ecf

order by 
caixa,mov.tipopagto,status'') at MYSQLGZ'

if object_id('TempDB.dbo.#MSL002') is not null
   drop table #MSL002
    
create table #MSL002 (M2_CXA INT, M2_ECF INT, M2_TIPPGT CHAR(3), M2_DESPGT VARCHAR(20), M2_STATUS INT, M2_VALTOT DECIMAL(10,4) ,
M2_VALLIQ DECIMAL(10,4),M2_VALTRO DECIMAL(10,4),M2_VALDES DECIMAL(10,4),M2_QTDCUP INT)

INSERT INTO #MSL002
exec(@comando)
SELECT
M2_CXA ,
M2_ECF , 
M2_TIPPGT , 
M2_DESPGT ,
sum(M2_VALTOT) AS VALTOT,
SUM(M2_VALLIQ) AS VALLIQ,
SUM(M2_VALTRO) AS VALTRO,
SUM(M2_VALDES) AS VALDES,
SUM(M2_QTDCUP) AS QTDCUP

FROM #MSL002 

GROUP BY 
M2_CXA ,
M2_ECF , 
M2_TIPPGT , 
M2_DESPGT 

UNION 
SELECT 
M2_CXA ,
M2_ECF , 
'' , 
'TROCO' ,
sum(M2_VALTOT) AS VALTOT,
SUM(M2_VALLIQ) AS VALLIQ,
SUM(M2_VALTRO) AS VALTRO,
SUM(M2_VALDES) AS VALDES,
SUM(M2_QTDCUP) AS QTDCUP

FROM 
#MSL002

WHERE
M2_STATUS = '12'

GROUP BY 
M2_CXA ,
M2_ECF


select *
  from #MSL002
