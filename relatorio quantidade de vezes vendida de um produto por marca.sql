select MARCOD as 'COD MARCA', MARNOM as 'NOME MARCA', FORCOD as 'COD FORNECEDOR', FORNOM as 'NOME FORNECEDOR', count(*) as 'TOTAL QTD VENDIDA',     
      (select count(*) from TBS010 B where B.MARCOD = A.MARCOD) as 'QTD PRODUTOS P MARCA'  
from TBS0671(nolock) join TBS010 A(nolock) on TBS0671.PROCOD = A.PROCOD
		     join TBS067 (nolock) on TBS067.NFSNUM = TBS0671.NFSNUM and TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD
where NFSDATEMI >= '2011'
group by MARCOD, MARNOM, FORCOD, FORNOM
order by 'TOTAL QTD VENDIDA' desc

--relaciona as marcas da tabala de produtos com o nome diferente da tabela de marcas
select TBS010.MARNOM as 'TBS010', TBS014.MARNOM as 'TBS014'  
from TBS010(nolock) join TBS014(nolock) on TBS014.MARCOD = TBS010.MARCOD
where TBS014.MARNOM != TBS010.MARNOM
order by TBS010

--corrige o erro acima
begin tran
update TBS010 set TBS010.MARNOM = TBS014.MARNOM 
from TBS010(nolock) join TBS014(nolock) on TBS014.MARCOD = TBS010.MARCOD
where TBS014.MARNOM != TBS010.MARNOM
commit tran

--relaciona os fornecedores da tabala de produtos com o nome diferente da tabela de fornecedores
select TBS010.FORCOD, TBS010.FORNOM as 'TBS010', TBS006.FORCOD, TBS006.FORNOM as 'TBS006'
from TBS010(nolock) join TBS006(nolock) on TBS006.FORCOD = TBS010.FORCOD
where TBS006.FORNOM != TBS010.FORNOM
order by TBS010

--corrige o erro acima
begin tran
update TBS010 set TBS010.FORNOM = TBS006.FORNOM 
from TBS010(nolock) join TBS006(nolock) on TBS006.FORCOD = TBS010.FORCOD
where TBS006.FORNOM != TBS010.FORNOM
commit tran
