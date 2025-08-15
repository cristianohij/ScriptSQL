sp_addlinkedserver 'tanby',
   'Jet 4.0',
   'Microsoft.Jet.OLEDB.4.0',
   'C:\temp\importar.csv',
   null,
   'Excel 8.0'

sp_dropserver TANBY

sp_addlinkedsrvlogin tanby,false,sa,null


select * from openquery(tanby,'select * from [Plan1$]')

SELECT * FROM OPENROWSET('MSDASQL','Driver={Microsoft Text Driver (*.txt; *.csv)};DefaultDir=C:\temp','SELECT * FROM importar.csv')

SELECT 'update TBS010 set PROSTBA='''+subString(campo,9,1)+''',PROSTBB='''+subString(campo,11,2)+''',PROCSN='''+subString(campo,14,3)+
       ''',PROCLAFIS='''+subString(campo,18,8)+''' WHERE PROCOD='''+subString(campo,1,7)+'''' FROM OPENROWSET('MSDASQL','Driver={Microsoft Text Driver (*.txt; *.csv)};DefaultDir=C:\temp','SELECT * FROM importar.csv')

SELECT a.*
FROM OPENROWSET('MSDASQL',
   'DRIVER={SQL Server};SERVER=seattle1;UID=sa;PWD=MyPass',
   pubs.dbo.authors) AS a
ORDER BY a.au_lname, a.au_fname
GO

SELECT * FROM OPENROWSET('MSDASQL','Driver={Microsoft Text Driver (*.txt; *.csv)};DefaultDir=C:\temp','SELECT linha FROM movoutra.txt')

 select subString(linha,1,3) as 'registro',
        subString(linha,47,6) as 'coo',
        subString(linha,53,6) as 'ccf',
        convert(int,subString(linha,59,3)) as 'item',
        subString(linha,62,14) as 'codigo',
        subString(linha,76,100) as 'descricao',
        convert(money,subString(linha,176,7))/1000 as 'qtde',
        subString(linha,183,3) as 'unidade',
        convert(money,subString(linha,186,8))/1000 as 'val.unitario',
        convert(money,subString(linha,194,8))/100 as 'val.desc',
        convert(money,subString(linha,202,8))/100 as 'val.acrescimo',
        convert(money,subString(linha,210,14))/100 as 'total',
        subString(linha,224,7) as 'tributacao',
        subString(linha,231,1) as 'cancelado'
   from openrowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from mre.txt') -- TP00560.txt')
  where subString(linha,1,3) = 'E15' and subString(linha,231,1) <> 'S' 
  order by tributacao,coo,item
compute sum(convert(money,subString(linha,210,14))/100) by subString(linha,224,7)
compute sum(convert(money,subString(linha,210,14))/100)
compute sum(convert(money,subString(linha,194,8))/100)

-- lista parâmetros que não existem na tabela TBS025
select subString(linha,1,4),*
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from parametros.txt')
 where not exists(select '' from TBS025 (nolock)
                   where TBS025.PARCHV=convert(smallint,subString(linha,1,4)))

select 'insert into TBS025 (PARCHV,PARDES,PARVAL,PARTIP,PARDATCAD) select '+subString(linha,1,4)+','''+
                                                                replace(rtrim(subString(linha,5,60)),'*',',')+''','''+
                                                                rtrim(subString(linha,65,150))+''','''+
                                                                rtrim(subString(linha,215,1))+''','''+
                                                                convert(char(8),getdate(),112)+''''
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from parametros.txt')
 where not exists(select '' from TBS025 (nolock)
                   where TBS025.PARCHV=convert(smallint,subString(linha,1,4)))

select * from TBS025 (nolock) where PARCHV=1075
delete TBS025 where PARCHV=1012

print convert(char(8),getdate(),112)

-- lista parâmetros com descrições diferentes na tabela TBS025
select subString(linha,1,4),replace(subString(linha,5,60),'*',','),TBS025.PARDES
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from parametros.txt')
       join TBS025 on TBS025.PARCHV=convert(smallint,subString(linha,1,4))
 where TBS025.PARDES<>replace(subString(linha,5,60),'*',',')

select 'update TBS025 set PARDES='''+rtrim(replace(subString(linha,5,60),'*',','))+''''+' where PARCHV='+subString(linha,1,4)
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from parametros.txt')
       join TBS025 on TBS025.PARCHV=convert(smallint,subString(linha,1,4))
 where TBS025.PARDES<>replace(subString(linha,5,60),'*',',')

select replace(linha,'*',',') from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from parametros.txt')

select * from TBS025 (nolock)

-- lista de programas
select * from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from programas.txt')

-- lista programas que não existem na tabela TBS018
select subString(LINHA,2,10),*
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select LINHA from programas.txt')
 where not exists(select '' from TBS018 (nolock)
                   where TBS018.PRGCOD=subString(LINHA,2,10))

select * from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from mapaecf.txt')
 where subString(linha,1,

--update TBS010 set TGZCOD=

select PROCOD,TGZCOD,subString(linha,1,8),subString(linha,9,2)
  from TBS010 (nolock),openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from tribgz.txt')
 where PROCOD=subString(linha,1,8)

begin tran
update TBS010 set TGZCOD=convert(int,subString(linha,9,1))
  from TBS010 (nolock),openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from tribgz.txt')
 where PROCOD=subString(linha,1,8)




select subString(linha,2,4) as 'registro' from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from SPED_DRM1.txt')
 group by subString(linha,2,4)

select subString(linha,2,4) as 'registro',
       sum(subString(linha,2,4)) as 'total'
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from SPED_DRM1.txt')
 group by subString(linha,2,4)

select linha from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from DR0913BR000000400226.txt')
 where subString(linha,2,4)='C405'

select linha from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from DR0913BR000000400226.txt')
 where subString(linha,2,4)='0200'

-- T18
select * from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from DR0913BR000000372757.txt')
 where subString(linha,1,14)='|C420|03T1800|'

-- F1
select * from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from DR0913BR000000400226.txt')
 where subString(linha,1,9)='|C420|F1|'

-- desconto total
select * from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from DR0913BR000000400226.txt')
 where subString(linha,1,9)='|C420|DT|'

-- cancelamento total
select * from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from DR0913BR000000400226.txt')
 where subString(linha,1,12)='|C420|Can-T|'

select * from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from DR0913BR000000400226.txt')
 where subString(linha,1,6)='|C420|'
