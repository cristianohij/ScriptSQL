-- funciona
select *
--A.F1 as texto
  into #pro
  from
     openrowset(
	    'Microsoft.ACE.OLEDB.12.0'
		,'Text;Database=c:\integros\temp;HDR=No;/r'
		,'select * from [estoque.txt]'
	 ) as linhas
 where DATALENGTH(linhas.F1) != 740
--

select Len(convert(varchar,F1))
       ,*
  from #pro 
 where Len(convert(varchar,F1)) != 741

select --*
--       left(replace(rtrim(isnull(F1,''))+rtrim(isnull(F2,''))+rtrim(isnull(F3,'')),'|1800|','|18,00|'),charindex('#',replace(rtrim(isnull(F1,''))+rtrim(isnull(F2,''))+rtrim(isnull(F3,'')),'|1800|','|18,00|'))-1)
--       +
--       left(replace(rtrim(isnull(F1,''))+rtrim(isnull(F2,''))+rtrim(isnull(F3,'')),'|1800|','|18,00|'),charindex('#',replace(rtrim(isnull(F1,''))+rtrim(isnull(F2,''))+rtrim(isnull(F3,'')),'|1800|','|18,00|'))-1)

       replace(
          replace( rtrim(isnull(F1,''))+rtrim(isnull(F2,''))+rtrim(isnull(F3,'')) , '|1800|' , '|18,00|' ) ,
             subString( replace(rtrim(isnull(F1,''))+rtrim(isnull(F2,''))+rtrim(isnull(F3,'')) , '|1800|' , '|18,00|') ,
                charindex( '#', replace(rtrim(isnull(F1,''))+rtrim(isnull(F2,''))+rtrim(isnull(F3,'')) , '|1800|' , '|18,00|')) ,
                   18 ) , '' )  --,charindex('#',replace(rtrim(isnull(F1,''))+rtrim(isnull(F2,''))+rtrim(isnull(F3,'')),'|1800|','|18,00|'))-1)
--select top 10 *
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Text;Database=c:\temp;HDR=No;/r','select * from [sped.txt]')
 where subString(F1,1,6)='|0200|'



select replace(replace(rtrim(isnull(F1,'')),subString(rtrim(isnull(F1,'')),charindex('#',rtrim(isnull(F1,''))),18),''),'|1800|','|18,00|')
--select *
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Text;Database=c:\integros\temp;HDR=No;/r','select * from [script2.sql]')
 where subString(F1,1,6)='|0200|'



--TRUNCATE TABLE TMP_SPED
--GO
 
--BULK INSERT TMP_SPED
--FROM 'C:\TEMP\SPED.TXT'
--WITH
--(
--     FIELDTERMINATOR = ';',
--     ROWTERMINATOR = '\r'
--)
--GO
