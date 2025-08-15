drop view VWProdutosGZ
go

create view VWProdutosGZ as
select T10.PROCOD as cdprod
--,replace(Left(T10.PRODES,40),'''','') as descricao
,replace(T10.PRODES,'''','') as descricao
,replace(Left(T10.PRODES,24),'''','') as descpdv
,'N' as formula
,T10.PROUM1 as unidade
,isnull((select round(preco1,3) from PrecoLoja(0, T10.PROCOD)),0) as termvenda
,'A' as descpadrao
,T10.PROPESAVEL as variavel
,'N' as alterapre
,'N' as multiplica
,isnull(T10.TGZCOD,0) as tributa
,round(T10.PROUM1QTD,3) as multiplos
,'N' as embfechada
,'N' as complement
,iif(PROPESAVEL = 'S', 'N', 'S') as sointeiro
,T10.PROSTBA+T10.PROSTBB as st
,'A' as situacao
,round(T10.PROUM2QTD,3) as multiatac
,iif(PROPESAVEL = 'S', 'N', 'S') as embfecatac
,iif(Len(T10.PROCLAFIS) = 8, T10.PROCLAFIS, '') as cfiscal
,iif(PROPESAVEL = 'S', 'N', 'S') as embfecesp
,'N' as bloqvenda
,'N' as solsenha
,'T' as ippt
,'A' as iat
,T31.TDPDATATU as ultatu
,isnull((select iif(T10.PROSTBA in ('0', '3', '4', '5'), round(NCMALINAC,2), round(NCMALIIMP,2)) from TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''),0) as cargatrib
,0 as tipoitem
,(select iif(EMPCRT = 1, T10.PROSTBA + T10.PROCSN, '') from TBS023 with (nolock) where EMPCOD = 1) as csosn
,'N' as entregavel
,rtrim(isnull((select NCMCHV from TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''),'')) as chaveibpt
,Ltrim(isnull((select cstpis from PisCofins(T10.PROEMPCOD, T10.PROCOD)), '')) as cstpis
,Ltrim(isnull((select cstcofins from PisCofins(T10.PROEMPCOD, T10.PROCOD)), '')) as cstcofins
,isnull((select round(aliqpis,2) from PisCofins(T10.PROEMPCOD, T10.PROCOD)),0) as aliqpis
,isnull((select round(aliqcofins,2) from PisCofins(T10.PROEMPCOD, T10.PROCOD)),0) as aliqcofins
,iif(Len(T10.PROCEST) = 7, T10.PROCEST, '') as cest
,isnull((select round(custo,3) from PrecoLoja(T10.PROEMPCOD, T10.PROCOD)),0) as precocusto
,T10.MARCOD as marcacodigo
,T10.MARNOM as marcanome
,iif(T31.TDPVALPROI='17530101', '', convert(char(8),T31.TDPVALPROI,3)) as validinicial
,iif(T31.TDPVALPROF='17530101', '', convert(char(8),T31.TDPVALPROF,3)) as validfinal
,3 as tabela

,replicate(' ',200) as falha
,row_number() over(order by T10.PROCOD) as sequencia

from TBS010 T10 with (nolock)
inner join TBS031 T31 with (nolock)
on T31.TDPPROCOD=T10.PROCOD;
go

select *
  from VWProdutosGZ
 where 
       --marcacodigo in(847)
	   descricao Like('%609PP%')

insert into openquery(MYSQLGZTEST, 'select cdprod,descricao from estoque e where e.id=0')
select cdprod
       ,descricao
  from VWProdutosGZ
 where cdprod in('1640054','1640089')

select *
  from estoque

--update openquery(linked1, 'select ssn from testlinked where ssn=2')
--set ssn=ssn + 1

select openquery(MYSQLGZTEST, 'select cdprod,descricao from estoque e where e.id=0')

SELECT id FROM OPENQUERY(MYSQLGZTEST, 'select * from estoque') where cdprod=18717

SELECT * FROM OPENQUERY(MYSQLGZTEST, 'select * from estoque') where id=9985 Ltrim(cdprod)='1640054'

declare @temp table(id int, cdprod varchar(20))

insert into @temp (id,cdprod)
SELECT id,cdprod FROM OPENQUERY(MYSQLGZ, 'select id,cdprod from estoque')

select * from @temp

drop view temp

create view temp as
SELECT id,cdprod FROM OPENQUERY(MYSQLGZ, 'select id,cdprod from estoque')
go

select * from temp

select *
  from VWProdutosGZ
  inner join temp
  on Ltrim(temp.cdprod)=convert(varchar(20),convert(int, VWProdutosGZ.cdprod))
