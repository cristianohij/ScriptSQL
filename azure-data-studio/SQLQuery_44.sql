declare @link int
select @link = dbo.fncMaquina_Ligada('192.168.7.2')

select @link

ALTER DATABASE [SIBD] SET TRUSTWORTHY ON

EXEC SP_ChangeDBOwner 'sa'

SELECT is_trustworthy_on
       ,recovery_model
       ,recovery_model_desc
       ,*
FROM sys.databases