-- funciona no SQL 2000 no 2008 não

sp_addlinkedserver 'Txt',
   'Jet 4.0',
   'Microsoft.Jet.OLEDB.4.0',
   'C:\temp\sintegra.txt',
   null,
   'Excel 8.0'

SELECT * FROM OPENROWSET('MSDASQL','Driver={Microsoft Text Driver (*.txt; *.csv)};DefaultDir=C:\temp','SELECT linha FROM sintegra.txt')
 where Left(linha,3)='60A' and subString(linha,32,4)='DESC'
