DECLARE @RC int
DECLARE @data_source varchar(15)
DECLARE @retorno int

-- TODO: Set parameter values here.

set @data_source = '192.168.10.7'

EXECUTE @RC = [dbo].[VerificaLink3] 
   @data_source
  ,@retorno OUTPUT

select @retorno
GO

