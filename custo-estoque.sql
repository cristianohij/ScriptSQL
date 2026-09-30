select *
  from TBS034 with (nolock)

select *
  from SALDOINICIAL with (nolock)
 where ANOMES='202012'
       and CUSTO=0

select sum((iif(E1>0,E1,0)+iif(E2>0,E2,0))*CUSTO)
  from SALDOINICIAL with (nolock)
 where ANOMES='202012'

select sum((case when E1>0 then E1 else 0 end + case when E2>0 then E2 else 0 end)*CUSTO)
  from SALDOINICIAL with (nolock)
 where ANOMES='202012'

select '2024' as ANO
       ,'12' as MES
	   ,CODIGO as COD_ITEM
	   ,(select PRODES from TBS010 where TBS010.PROCOD=CODIGO) as DESCR_ITEM
	   ,isnull((select PROCLAFIS from TBS010 where TBS010.PROCOD=CODIGO),'') as COD_NCM
	   ,case when E1 > 0 then E1 else 0 end + case when E2 > 0 then E2 else 0 end as QTDE
	   ,(select PROUM1 from TBS010 where TBS010.PROCOD=CODIGO) as UNID_INV
	   ,round(CUSTO,2) as VL_UNIT
     ,(select PROSTBA+PROSTBB from TBS010 where TBS010.PROCOD=CODIGO) as CST_ICMS
     ,'' as CSOSN_ICMS
     ,0 BC_ICMS
	   --,(select iif(PROICMSINT > 0, PROICMSINT, 18) from TBS010 where TBS010.PROCOD=CODIGO) as ALIQ_ICMS
	   ,(select case when PROICMSINT > 0 then PROICMSINT else 18 end from TBS010 where TBS010.PROCOD=CODIGO) as ALIQ_ICMS
	   ,0 as VL_ICMS
	   --,(select iif(PROPIS='', 1.65,0) from TBS010 where TBS010.PROCOD=CODIGO) as ALIQ_PIS
	   ,(select case when PROPIS='' then 1.65 else 0 end from TBS010 where TBS010.PROCOD=CODIGO) as ALIQ_PIS
	   ,0 as VL_PIS
	   --,(select iif(PROCOFINS='', 1.65,0) from TBS010 where TBS010.PROCOD=CODIGO) as ALIQ_COFINS
	   ,(select case when PROCOFINS='' then 7.60 else 0 end from TBS010 where TBS010.PROCOD=CODIGO) as ALIQ_COFINS
	   ,0 as VL_COFINS
	   ,0 as VL_ITEM_IR
     ,0 as IVA_ST
     ,0 as BC_ICMS_ST
     ,0 as ICMS_ST
     ,0 as ALIQ_FCP
     ,0 as FCP_ST
	   ,1 as IND_PROP
       ,(select 'S'+EMPCGC from TBS023 with (nolock) where EMPCOD=(case when Left(EMPNOM,8)='BEST BAG' then 2 else 1 end)) as CNPJ
       ,'SP' as UF
	   ,'1' as GRUPO
  from SALDOINICIAL with (nolock)
 where ANOMES='202412'
	     and (E1 > 0) -- or E2 > 0)
       and CUSTO > 0
 order by CODIGO

-- custo total

select max([DATA])
  from SALDOINICIAL with (nolock)

select *
  from SALDOINICIAL with (nolock)
 where ANOMES='202510'

select *
  from TBS034 with (nolock)

-- somente estoque

declare @anomes char(6)
set @anomes = '202510'

-- estoque 1

select sum(E1 * CUSTO) as custo_total
  from SALDOINICIAL with (nolock)
 where ANOMES = @anomes
	     and (E1 > 0)
       and CUSTO > 0

-- estoque 2

select sum(E2 * CUSTO) as custo_total
  from SALDOINICIAL with (nolock)
 where ANOMES = @anomes
	     and (E2 > 0)
       and CUSTO > 0


-- somente loja

select sum(E2*CUSTO) as custo_total
  from SALDOINICIAL with (nolock)
 where ANOMES='202303'
	     and (E2 > 0)
       and CUSTO > 0

-- estoque 5: perdas

select *
  from TBS034 with (nolock)

select convert(int,ANOMES)-1
       ,round(sum(E5 * CUSTO),2) as custo_total
  from SALDOINICIAL with (nolock)
 where ANOMES between '202302' and '202401'
	     and (E5 > 0)
       and CUSTO > 0
 group by ANOMES

-- estoques: 5 perdas; 7 ocorrências

select convert(int,ANOMES)-1
       ,iif(E5 > 0)
       ,round(sum(E5 * CUSTO),2) as custo_total
  from SALDOINICIAL with (nolock)
 where ANOMES = '202409'
	     and (E5 > 0)
       and CUSTO > 0
 group by ANOMES


select *
  from SALDOINICIAL with (nolock)
 where ANOMES='202302'

-- ambos

select sum(QTDE*CUSTO) as custo_total
  from (
         select case when E1 > 0 then E1 else 0 end + case when E2 > 0 then E2 else 0 end as QTDE
	              ,CUSTO as CUSTO
           from SALDOINICIAL with (nolock)
          where ANOMES='202312'
	              and (E1 > 0 or E2 > 0)
                and CUSTO > 0
       ) tab

select sum(QTDE*CUSTO) as custo_total
  from (
         select case when E1 > 0 then E1 else 0 end + case when E2 > 0 then E2 else 0 end as QTDE
	              ,CUSTO as CUSTO
           from SALDOINICIAL with (nolock)
          where ANOMES='202212'
	              and (E1 > 0)
                and CUSTO > 0
       ) tab

-- custo da política de preços

select sum(QTDE*CUSTO)
from (
select case when E1 > 0 then E1 else 0 end + case when E2 > 0 then E2 else 0 end as QTDE
	     ,(select TDPCUSBAS
           from TBS031 with (nolock)
          where TDPPROCOD=CODIGO
        ) as CUSTO
  from SALDOINICIAL with (nolock)
 where ANOMES='202204'
	     and (E1 > 0) -- or E2 > 0)
       and CUSTO > 0
) tab

-- ajuste com cadastro produtos contamatic

select COD_ITEM as codigo
       ,DESCR_ITEM as descricao
	   ,UNID_INV as unidade
  into #tab
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\contmatic-produtos-tanby-taubate.xls', 'select * from [Item$]')

select *
  from #tab

select COD_ITEM as codigo
       ,DESCR_ITEM as descricao
	   ,UNID_INV as unidade
  into #inv
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\teste.xlsx', 'select * from [Planilha1$]')


select i.*
       ,t.*
  from #inv as i
  inner join #tab as t
  on t.codigo=i.codigo
 where i.unidade<>t.unidade

select i.codigo
       ,t.unidade
  from #inv as i
  inner join #tab as t
  on t.codigo=i.codigo
 where i.unidade<>t.unidade

select *
  from SALDOINICIAL with (nolock)
 where ANOMES='202205'
       and E1 > 0
 order by E1 desc

select *
  from SALDODIARIO with (nolock)
 where PROCOD='8478633'

-- SEM loja

select ANOMES as 'ano_mes'
       ,sum(E1 * CUSTO) as custo_total
  from SALDOINICIAL with (nolock)
 where ANOMES >= '202201'
	     and (E1 > 0)
       and CUSTO > 0
 group by ANOMES

select top(10) *
  from TBS031 with (nolock)

if object_id('tempdb.dbo.#custo_estoque') is not null 
   begin 
      drop table #custo_estoque
   end

select tab2.[local]
       ,tab2.marca as 'codigo_marca'
       ,(select MARNOM
           from TBS014 with (nolock)
          where MARCOD=tab2.marca) as 'marca'
       ,tab2.valor
  into #custo_estoque
  from (
         select tab.[local]
                ,tab.marca
                ,sum(tab.qtde*tab.custo) as 'valor'
           from (
                  select e.ESTLOC as 'local'
                         ,e.MARCOD as 'marca'
                         ,ESTQTDATU as 'qtde'
                         ,(select TDPCUSBAS
                             from TBS031 p with (nolock)
                            where p.TDPPROCOD=e.PROCOD) as 'custo'
                    from TBS032 e with (nolock)
                   where e.ESTLOC in(1,2)
                         and e.ESTQTDATU > 0
                ) as tab
          group by tab.[local], tab.marca with rollup
       ) as tab2
 
select *
  from #custo_estoque
 order by [local], marca

select ANOMES as 'ano_mes'
       ,sum(E5*CUSTO) as 'custo'
  from SALDOINICIAL with (nolock)
 where ANOMES >= '202301'
	     and (E5 > 0)
       and CUSTO > 0
 group by ANOMES

select ANOMES as 'ano_mes'
       ,convert(decimal(9,0), sum(E6 * CUSTO)) as 'custo'
  from SALDOINICIAL with (nolock)
 where ANOMES between '202307' and '202310'
	     and (E6 > 0)
       and CUSTO > 0
 group by ANOMES

select top(1) *
  from SALDOINICIAL with (nolock)

select *
  from TBS034 with (nolock)

select TOP(10) *
  from TBS031 with (nolock)

select PROCOD as 'codigo'
       
       ,(select TDPCUSBAS from TBS031 with (nolock) where TDPPROCOD=PROCOD)
       ,ESTQTDATU * (select TDPCUSBAS from TBS031 with (nolock) where TDPPROCOD=PROCOD)
  from TBS032 with (nolock)
 where ESTLOC=9
       and ESTQTDATU > 0

select *
  from TBS010 with (nolock)
 where PRODES = ''

begin tran 
update TBS032
   set PRODES=(select PRODES from TBS010 p with (nolock) where p.PROCOD=e.PROCOD)
 from TBS032 e with (nolock)

rollback tran 
commit tran 

select PROCOD as 'codigo'
       ,PRODES as 'descricao'
       ,e.ESTQTDATU as 'quantidade'
       ,(select top(1) CUSTO from SALDOINICIAL s with (nolock) where s.CODIGO = e.PROCOD order by ANOMES desc) as 'custo'
  from TBS032 e with (nolock)
 where e.ESTLOC = 9
       and e.ESTQTDATU > 0

select sum((e.ESTQTDATU - e.ESTQTDRES) * p.TDPCUSBAS)
  from TBS032 e with (nolock)
  Left join TBS031 p with (nolock)
         on p.TDPPROCOD = e.PROCOD
 where e.ESTLOC = 1
       and e.ESTQTDATU - e.ESTQTDRES > 0


-- custos com perdas e ocorrências

SELECT 
    ANOMES,
    FORMAT(ROUND(SUM(CASE WHEN E5 > 0 THEN E5 * CUSTO ELSE 0 END), 2), 'N', 'pt-BR') AS custo_perdas,
    FORMAT(ROUND(SUM(CASE WHEN E7 > 0 THEN E7 * CUSTO ELSE 0 END), 2), 'N', 'pt-BR') AS custo_ocorrencias
FROM 
    SALDOINICIAL WITH (NOLOCK)
WHERE 
    ANOMES BETWEEN '202401' AND '202408'
    AND CUSTO > 0
GROUP BY 
    ANOMES;

SELECT 
    ANOMES,
    FORMAT(ROUND(SUM(CASE WHEN E5 > 0 THEN E5 * CUSTO ELSE 0 END), 2), 'N', 'en-US') AS custo_perdas,
    FORMAT(ROUND(SUM(CASE WHEN E7 > 0 THEN E7 * CUSTO ELSE 0 END), 2), 'N', 'en-US') AS custo_ocorrencias,
    FORMAT(ROUND(SUM(CASE WHEN E5 > 0 THEN E5 * CUSTO ELSE 0 END) 
                 + SUM(CASE WHEN E7 > 0 THEN E7 * CUSTO ELSE 0 END), 2), 'N', 'en-US') AS custo_total
FROM 
    SALDOINICIAL WITH (NOLOCK)
WHERE 
    ANOMES BETWEEN '202401' AND '202408'
    AND CUSTO > 0
GROUP BY 
    ANOMES;

select *
  from SALDOINICIAL with (nolock)
 where ANOMES='202404'

 SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'TBS010';
