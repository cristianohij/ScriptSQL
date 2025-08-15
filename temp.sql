select ANOMES
       ,CODIGO
  from SALDOINICIAL with (nolock)
 where isnull(CUSTO,0)=0
       and (E1 > 0 or E2 > 0 or E3 > 0 or E4 > 0 or E5 > 0 or E6 > 0 or E7 > 0 or E8 > 0 or E9 > 0)
 --group by CODIGO
 group by ANOMES, CODIGO
 
select TBS059.NFEDATEFE
       ,*
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT between '20100101' and '20200131'
       and TBS0591.NFETIP<>'D'
       and TBS059.NFECAN<>'S'
       and TBS0591.PROCOD in('5380879')
--       and NFENCMXML='0018717'
 order by TBS059.NFEDATENT desc
 
select *
  from SALDOINICIAL with (nolock)
 where ANOMES='201912'
       and EMPRESA<>''

order by ANOMES desc, CODIGO


select *
  from SALDOINICIAL with (nolock)
--delete SALDOINICIAL
 where E1=0 and E2=0 and E3=0 and E4=0 and E5=0 and E6=0 and E7=0 and E8=0 and E9=0 and QTDENTRADA=0

select *
  from SALDOINICIAL with (nolock)
 where CUSTO = 0
       and ANOMES='202001'
	   and (E1 > 0 or E2 > 0 or E3 > 0 or E4 > 0 or E7 > 0 or E9 > 0)

select  sum(CUSTO * case when E1 > 0 then E1 else 0 end) S1
       ,sum(CUSTO * case when E2 > 0 then E2 else 0 end) S2
	   ,sum(CUSTO * case when E3 > 0 then E3 else 0 end) S3
	   ,sum(CUSTO * case when E4 > 0 then E4 else 0 end) S4
	   ,sum(CUSTO * case when E7 > 0 then E7 else 0 end) S7
	   ,sum(CUSTO * case when E9 > 0 then E9 else 0 end) S9
  from SALDOINICIAL with (nolock)
 where CUSTO > 0
       and ANOMES='202001'
	   and (E1 > 0 or E2 > 0 or E3 > 0 or E4 > 0 or E7 > 0 or E9 > 0)



select *
  from SALDOINICIAL with (nolock)
 where CODIGO='10360278'
       --and CUSTO > 0
 order by ANOMES
	   	   
select *
  from SALDOINICIAL with (nolock)
 where CUSTO > 0

select *
  from SALDOINICIAL with (nolock)
 --where CUSTO=0
 order by ANOMES

 CREATE NONCLUSTERED INDEX ISALDOINICIAL ON SALDOINICIAL (ANOMES, CODIGO)
CREATE NONCLUSTERED INDEX ISALDOINICIAL2 ON SALDOINICIAL (ANOMES DESC, CODIGO)

select *
  from SALDOINICIAL with (nolock)
--delete SALDOINICIAL
 where ANOMES='201912'
       and (E1=0 or E2=0 or E3=0 or E4=0 or E5=0 or E6=0 or E7=0 or E8=0 or E9=0)
	   and CUSTO=0

select *
  from SALDOINICIAL with (nolock)
 where QTDENTRADA > 0

 select

so.Name As "Nome da Tabela",

sc.Name As "Nome do Campo"

from sys.syscolumns sc inner join sys.sysobjects so

on sc.id = so.id
where

-- sc.Name='CLICOD'
sc.Name like('%ICM%')


 -- SPED inventário

|0000|112|0|31122019|31122019|MISASPEL COMERCIO DE PAPEIS LTDA|52080207000117||SP|110763416118|3550308|||A|1|
|0001|0|
|0005|MISASPEL|05315021|RUA AROABA|427||VILA LEOPOLDINA|(11)32175650||misaspel@misaspel.com.br|
|0100|Nome Contador|00000000000|123456789012345|00077705000107|01223903|Rua Marquês de Itu|70|2º andar - Conjunto 22|Vila Buarque|||marcos@proceres.com.br|3550308|

-- 0190

-- 0200

|0990|10084|
|B001|1|
|C001|1|
|C990|2|
|D001|1|
|D990|2|
|E001|1|
|E990|2|
|G001|1|
|G990|2|
|H001|0|


|H005|31122019|287503,90|01|

-- H010

|H990|10053|
|K001|1|
|K990|2|
|1001|1|
|1990|2|
|9001|0|
|9900|0000|1|
|9900|0001|1|
|9900|0005|1|
|9900|0100|1|
|9900|0190|29|
|9900|0200|10050|
|9900|0990|1|
|9900|1001|1|
|9900|1990|1|
|9900|9001|1|
|9900|9990|1|
|9900|9999|1|
|9900|B001|1|
|9900|C001|1|
|9900|B990|1|
|9900|C990|1|
|9900|D001|1|
|9900|D990|1|
|9900|E001|1|
|9900|E990|1|
|9900|G001|1|
|9900|G990|1|
|9900|H001|1|
|9900|H005|1|
|9900|H010|10050|
|9900|H990|1|
|9900|K001|1|
|9900|K990|1|
|9900|9900|25|
|9990|28|
|9999|20175|


-- unidades de medidas

select '|0190|'
       +PROUM1
       +'|'+(select UNIDES from TBS011 with (nolock) where UNICOD=PROUM1)
	   +'|'
  from
  (
	select PROUM1
	  from TBS010 with (nolock)
	 where PROCOD in(select CODIGO from SALDOINICIAL with (nolock) where ANOMES='202001' and (E1 > 0 or E2 > 0 or E3 > 0 or E4 > 0 or E7 > 0 or E9 > 0) and CUSTO > 0)
	 group by PROUM1
 ) tab

-- produtos

select '|0200'
       +'|'+rtrim(PROCOD)
       +'|'+rtrim(PRODES)
	   +'|'+isnull((select top 1 rtrim(CBPCODBAR) from TBS0103 with (nolock) where CBPPROCOD=PROCOD),'')
	   +'|'+
	   +'|'+PROUM1
	   +'|00'
	   +'|'+rtrim(PROCLAFIS)
	   +'|'+
	   +'|'+
	   +'|'+
	   +'|'+case when PROICMSINT > 0 then Ltrim(str(PROICMSINT,6)) else '' end
	   +'|'+case when Len(PROCEST) >= 7 then rtrim(PROCEST) else '' end
	   +'|'
  from TBS010 with (nolock)
 where PROCOD in(select CODIGO from SALDOINICIAL with (nolock) where ANOMES='202001' and (E1 > 0 or E2 > 0 or E3 > 0 or E4 > 0 or E7 > 0 or E9 > 0) and CUSTO > 0)

 -- saldos dos produtos

select '|H010'
       +'|'+rtrim(CODIGO)
	   +'|'+(select PROUM1 from TBS010 with (nolock) where PROCOD=CODIGO)
	   +'|'+replace(Ltrim(str( case when E1>0 then E1 else 0 end
	                          +case when E2>0 then E2 else 0 end
							  +case when E3>0 then E3 else 0 end
							  +case when E4>0 then E4 else 0 end
							  +case when E7>0 then E7 else 0 end
							  +case when E9>0 then E9 else 0 end,12,3)),'.',',')
	   +'|'+replace(Ltrim(str(CUSTO,12,6)),'.',',')
	   +'|'+replace(Ltrim(str(CUSTO*( case when E1>0 then E1 else 0 end
	                                 +case when E2>0 then E2 else 0 end
									 +case when E3>0 then E3 else 0 end
									 +case when E4>0 then E4 else 0 end
									 +case when E7>0 then E7 else 0 end
									 +case when E9>0 then E9 else 0 end),12,2)),'.',',')
	   +'|0'
	   +'|'
	   +'|'
	   +'|'+
	   +'|'+replace(Ltrim(str(CUSTO*( case when E1>0 then E1 else 0 end
	                                 +case when E2>0 then E2 else 0 end
									 +case when E3>0 then E3 else 0 end
									 +case when E4>0 then E4 else 0 end
									 +case when E7>0 then E7 else 0 end
									 +case when E9>0 then E9 else 0 end),12,2)),'.',',')
	   +'|'
  from SALDOINICIAL with (nolock)
 where ANOMES='202001'
       and (E1 > 0 or E2 > 0 or E3 > 0 or E4 > 0 or E7 > 0 or E9 > 0)
	   and CUSTO > 0

select TDPHISCPO
  from TBS0311 with (nolock)
 group by TDPHISCPO

select PDPHISCPO
  from TBS0151 with (nolock)
 group by PDPHISCPO

select top 1000 *
  from TBS015 with (nolock)
  inner join TBS0151 with (nolock)
  on TBS0151.PDPEMPCOD=TBS015.PDPEMPCOD
	 and TBS0151.PDPCOD=TBS015.PDPCOD

select *
       ,round(
			PRECO
			-- descontos
			* case DESC1
				when 0 then 1
				else (100-DESC1)/100
			  end
			* case DESC2
				when 0 then 1
				else (100-DESC2)/100
			  end
			* case DESC3
				when 0 then 1
				else (100-DESC3)/100	
			  end
			* case DESC4
				when 0 then 1
				else (100-DESC4)/100
			  end
			* case DESC5
				when 0 then 1
				else (100-DESC5)/100
			  end
			
			-- IPI
			* case IPI
				when 0 then 1
				else 1+IPI/100
			  end
			
			-- ST
			* case ST
				when 0 then 1
				else 1+ST/100
			  end

			-- frete
			* case FRETE
				when 0 then 1
				else 1+FRETE/100
			  end
		,6) CUSTO
  from
  (
select PDPDATATU DATA
       ,PDPCOD CODIGO
	   ,(select top 1 PDPPREFOR from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) PRECO
	   ,(select top 1 PDPPDD1 from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) DESC1
	   ,(select top 1 PDPPDD2 from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) DESC2
	   ,(select top 1 PDPPDD3 from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) DESC3
	   ,(select top 1 PDPPDD4 from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) DESC4
	   ,(select top 1 PDPPDD5 from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) DESC5
	   ,(select top 1 PDPIPI from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) IPI
	   ,(select top 1 PDPPORST PDPPREFOR from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) ST
	   ,(select top 1 PDPFRE from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) FRETE
  from TBS015 base with (nolock)
 where PDPDATATU <= '20191231'
       and PDPCOD='0050071'
 group by PDPDATATU, PDPCOD
-- order by PDPDATATU desc, PDPCOD
  ) tab
 order by tab.DATA desc, tab.CODIGO


-- leiaute contmatic
 
-- misapel		52.080.207/0001-17
-- papelyna		44.125.185/0001-36
-- tanby 		65.069.593/...		matriz 0001-98, cd 0003-50, taubaté 0002-79

declare @cnpj char(18)

set @cnpj = '65.069.593/0002-79'

select  sum(CUSTO * case when E1 > 0 then E1 else 0 end) S1
       ,sum(CUSTO * case when E2 > 0 then E2 else 0 end) S2
	   ,sum(CUSTO * case when E3 > 0 then E3 else 0 end) S3
	   ,sum(CUSTO * case when E4 > 0 then E4 else 0 end) S4
	   ,sum(CUSTO * case when E7 > 0 then E7 else 0 end) S7
	   ,sum(CUSTO * case when E9 > 0 then E9 else 0 end) S9
  from SALDOINICIAL with (nolock)
 where CUSTO > 0
       and ANOMES='202001'
	   and (E1 > 0 or E2 > 0 or E3 > 0 or E4 > 0 or E7 > 0 or E9 > 0)

select '2019'
	   ,'12'
	   ,rtrim(CODIGO)
	   ,(select rtrim(PRODES) from TBS010 with (nolock) where PROCOD=CODIGO)
	   ,(select case when Len(PROCLAFIS)=8 then Left(PROCLAFIS,4)+'.'+subString(PROCLAFIS,5,2)+'.'+right(PROCLAFIS,2) else '' end from TBS010 with (nolock) where PROCOD=CODIGO)
	   ,replace(Ltrim(str( case when E1>0 then E1 else 0 end
						  +case when E2>0 then E2 else 0 end
						  +case when E3>0 then E3 else 0 end
						  +case when E4>0 then E4 else 0 end
						  +case when E7>0 then E7 else 0 end
						  +case when E9>0 then E9 else 0 end,12,2)),'.',',')
      ,(select PROUM1 from TBS010 with (nolock) where PROCOD=CODIGO)
      ,replace(Ltrim(str(CUSTO,12,2)),'.',',')
      ,(select case when PROICMSINT > 0 then Ltrim(str(PROICMSINT,2)) else '18' end from TBS010 with (nolock) where PROCOD=CODIGO)
      ,0
      ,(select case when PROSTBPIS between '06' and '09' then '0' else '1,65' end from TBS010 with (nolock) where PROCOD=CODIGO)
      ,0
      ,(select case when PROSTBCOFINS between '06' and '09' then '0' else '7,60' end from TBS010 with (nolock) where PROCOD=CODIGO)
      ,0
      ,0
      ,0
      ,1
      ,@cnpj
	  ,'SP'

 from SALDOINICIAL with (nolock)
where ANOMES='202001'
      and (E1 > 0 or E2 > 0 or E3 > 0 or E4 > 0 or E7 > 0 or E9 > 0)
      and CUSTO > 0
