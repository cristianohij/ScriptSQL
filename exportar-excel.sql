EXEC sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE;  
GO  
EXEC sp_configure 'Ad Hoc Distributed Queries', 1;  
GO  
RECONFIGURE;  
GO

/* CRIANDO UM SERVIDOR LINKADO
PARA */
/* ACESSAR OS DADOS DAS PLANILHAS DO ARQUIVO */
EXEC sp_addlinkedserver 'FonteExcel',
'Jet 4.0',
'Microsoft.Jet.OLEDB.4.0',
'c:\temp\DadosExcel.xls',
NULL,
'Excel 5.0'
GO

/* VERIFICANDO O QUE ESTÁ
DISPONÍVEL PARA NÓS */
EXEC sp_tables_ex TEST
GO



sp_configure 'allow updates', '0'
RECONFIGURE WITH OVERRIDE

sp_configure 'show advanced options', 1
RECONFIGURE
go

sp_configure 'Ad Hoc Distributed Queries', 1
RECONFIGURE
GO

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0',
                       'Excel 8.0;Database=C:\temp\dadosexcel.xls;', 
                       'SELECT UFESIG FROM [Plan1$]')
SELECT UFESIG
FROM TBS001



-- teste

EXEC master.dbo.sp_addlinkedserver
@server = N'TEST', 
@srvproduct=N'Excel 12.0', 
@provider=N'Microsoft.ACE.OLEDB.12.0', 
@datasrc=N'c:\temp\dadosexcel.xlsx',
@provstr=N'Excel 12.0;HDR=Yes' 

select * from TEST...[planilha1$]