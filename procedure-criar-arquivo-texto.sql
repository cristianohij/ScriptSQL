--Exclui procedure
IF OBJECT_ID('dbo.spWriteStringToFile', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[spWriteStringToFile]
GO
 
--Recria a procedure
CREATE PROCEDURE spWriteStringToFile (
    @String Varchar(max),
    @Path VARCHAR(255),
    @FileName VARCHAR(100)
)
AS
 
--Declara as variáveis
DECLARE
    @objFileSystem int,
    @objTextStream int,
    @objErrorObject int,
    @strErrorMessage Varchar(1000),
    @Command varchar(1000),
    @hr int,
    @FileAndPath varchar(80)
SET NOCOUNT ON
 
--Reconfigura opções do SQL Server
EXEC sp_configure 'show advanced options', 1
RECONFIGURE
EXEC sp_configure 'Ole Automation Procedures', 1
RECONFIGURE
 
--Abrindo o Objeto
select @strErrorMessage='Abrindo File System Object'
EXECUTE @hr = sp_OACreate  'Scripting.FileSystemObject' , @objFileSystem OUT
 
--Tratamento para string nula
if @String = NULL
   SET @String = ''
else
   SET @String = @String

--SET @String = Iif(@String = NULL, '', @String)
 
--Define o diretório e a pasta
--Select @FileAndPath = @Path+'\'+@FileName
Select @FileAndPath = @Path+@FileName
 
--Criando o arquivo
if @hr = 0 Select @objErrorObject = @objFileSystem, @strErrorMessage = 'Criando arquivo "'+@FileAndPath+'"'
if @hr=0 execute @hr = sp_OAMethod @objFileSystem, 'CreateTextFile', @objTextStream OUT, @FileAndPath, 2, True
 
--Escrevendo texto no arquivo
if @hr=0 Select @objErrorObject = @objTextStream, @strErrorMessage = 'Escrevendo no arquivo "'+@FileAndPath+'"'
if @hr=0 execute @hr = sp_OAMethod  @objTextStream, 'Write', Null, @String
 
--Fechando o aruqivo
if @hr=0 Select @objErrorObject = @objTextStream, @strErrorMessage = 'Fechando e finalizando o arquivo "'+@FileAndPath+'"'
if @hr=0 execute @hr = sp_OAMethod  @objTextStream, 'Close'
 
--Se o ponteiro for diferente de 0 (houve erros
if @hr<>0
    begin
    Declare
        @Source varchar(255),
        @Description Varchar(255),
        @Helpfile Varchar(255),
        @HelpID int
 
    EXECUTE sp_OAGetErrorInfo  @objErrorObject,
        @Source output,@Description output,@Helpfile output,@HelpID output
    Select @strErrorMessage='Erro '
            +coalesce(@strErrorMessage,'...')
            +', '+coalesce(@Description,'')
    raiserror (@strErrorMessage,16,1)
    end
 
--Finaliza a Procedure
EXECUTE sp_OADestroy @objTextStream
EXECUTE sp_OADestroy @objTextStream



--Declara as variáveis
DECLARE @Texto Varchar(800)
DECLARE @Enter Varchar(2)
 
--Seta os conteúdos
SET @Enter  = Char(13)+Char(10)
SET @Texto  = 'Linha 1, teste de escrita'+@Enter
SET @Texto += 'Linha 2, Daniel Atilio'+@Enter
SET @Texto += 'Linha 3, Terminal de Informação'+@Enter

select @Texto
 
--Cria o arquivo texto
exec spWriteStringToFile @Texto, 'c:\temp\', 'sqlteste.txt'

