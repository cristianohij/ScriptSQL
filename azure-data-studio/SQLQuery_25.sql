-- para SQL Server 2016

-- ===================================================================================
-- Author.......: Drausio Henrique Chiarotti
-- Create date..: 03/10/2017
-- Description..: Como Consumir Web Service Api direto no SQL Server e Mapear JSON
-- Canal Youtube: https://www.youtube.com/user/professordrausio
-- Aula.........: https://www.youtube.com/watch?v=yhGcfYbNGP0
-- LinkeIn......: https://www.linkedin.com/in/drausiohenriquechiarotti/
-- ===================================================================================
/*
--Habilitar as Stored Procedures de Ole Automation
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Ole Automation Procedures', 1;
GO
RECONFIGURE;
GO
*/

DECLARE 
	@intToken INT,
	
	@vchEndereco VARCHAR(MAX),
	@vchURL AS VARCHAR(MAX),
	@vchJSON AS VARCHAR(8000),
	@vchStatus AS VARCHAR(MAX),
	@intQtdeResultados AS INT,
	--Mapear JSON
	@vchJSONResults AS VARCHAR(MAX),
	@vchJSONResultsGeometry AS VARCHAR(MAX),
	@vchJSONResultsLocation AS VARCHAR(MAX),
	@fltLatitude FLOAT,
	@fltLongitude FLOAT;
	
	SET @vchEndereco = 'Av. Alan Kardec, 1451 - Centro, Bebedouro - SP';
	SET @vchURL = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + @vchEndereco;

	--OLE Automation é mecanismo para a comunicação entre processos baseado em Component Object Model (COM)
	--Is the returned object token, and must be a local variable of data type int. This object token identifies the created OLE object and is used in calls to the other OLE Automation stored procedures.
	EXEC sp_OACreate 'MSXML2.XMLHTTP', @intToken OUT;
	--Chamada para método OPEN
	EXEC sp_OAMethod @intToken, 'open', NULL, 'get', @vchURL, 'false';
	--Chamada para método SEND
	EXEC sp_OAMethod @intToken, 'send';
	--Chamada para método RESPONSE TEXT
	EXEC sp_OAMethod @intToken, 'responseText', @vchJSON OUTPUT;

	--Site para visualizar JSON http://jsonviewer.stack.hu/
	SELECT @vchJSON;
	
	--Mapear o JSON.

	--Checar se é um JSON válido
	IF (ISJSON(@vchJSON) = 1)
	BEGIN
		--Verificar se o status é OK (sucesso), ou seja, se a chamada foi realizada com sucesso
		SET @vchStatus = (SELECT TOP 1 [value] FROM OPENJSON(@vchJSON) WHERE [key] = 'status');
			
		IF (@vchStatus = 'OK')
		BEGIN
			
			--Verificar a quantidade de resultados dentro do JSON.
			SET @intQtdeResultados = (SELECT COUNT([key]) FROM OPENJSON(@vchJSON, '$.results'));
				
			IF (@intQtdeResultados = 1)
			BEGIN
				
				SET @vchJSONResults = (SELECT TOP 1 [value] FROM OPENJSON(@vchJSON, '$.results'));
					
				SET @vchJSONResultsGeometry = (SELECT TOP 1 [value] FROM OPENJSON(@vchJSONResults) WHERE [key] = 'geometry');
					
				SET @vchJSONResultsLocation = (SELECT TOP 1 [value] FROM OPENJSON(@vchJSONResultsGeometry) WHERE [key] = 'location');
					
				SET @fltLatitude = (SELECT top 1 [value] FROM OPENJSON(@vchJSONResultsLocation) WHERE [key] = 'lat');
					
				SET @fltLongitude = (SELECT top 1 [value] FROM OPENJSON(@vchJSONResultsLocation) WHERE [key] = 'lng');

				SELECT
					@fltLatitude AS Latitude,
					@fltLongitude AS Longitude,
					'https://www.google.com/maps/search/?api=1&query=' + CAST(@fltLatitude AS VARCHAR) + ',' + CAST(@fltLongitude AS VARCHAR);
			END

		END

	END

	EXEC sp_OADestroy @intToken;	
	

-- API ViaCEP

--Proposta: 
--Executar uma chamada "HTTP GET" em uma "URL", recuperar o resultado em formato JSON e armazenar em uma vari�vel do SQL Server.

DECLARE @Obj Int, @Url Varchar(50), @RetornoAPI Varchar(2000), @Cep Varchar(10) = '12233490'

Set @Url = Concat('https://viacep.com.br/ws/', @Cep, '/json/')

--Cria um objeto "COM MSXML2.XMLHTTP" que � usado para realizar a chamada HTTP. O resultado � armazenado na vari�vel de sa�da "@Obj".
EXEC sp_OACreate 'MSXML2.XMLHTTP', @Obj OUTPUT

--Configura o objeto "MSXML2.XMLHTTP" rec�m-criado para realizar uma solicita��o "HTTP GET" para a "URL" especificada na vari�vel "@Url".
EXEC sp_OAMethod @Obj, 'open', NULL, 'GET', @Url, 'false'

--Envia a solicita��o "HTTP" para o servidor.
EXEC sp_OAMethod @Obj, 'send'

--Recupera o resultado da chamada "HTTP" em formato de texto e o armazena na vari�vel de sa�da "@RetornoAPI".
EXEC sp_OAMethod @Obj, 'responseText', @RetornoAPI OUTPUT

--Destroi o objeto "MSXML2.XMLHTTP" para liberar recursos do sistema. 
EXEC sp_OADestroy @Obj

Select @RetornoAPI

-- até funciona

-- abixo requer sql server 2016 (OpenJson)

Declare @Bairro Varchar(200), @Rua Varchar(200), @UF Char(2), @Localidade Varchar(100), @IBGE Varchar(10)

Select @Rua = [value]
From OpenJson(@RetornoAPI)
Where [key] = 'logradouro'

Select @Bairro = [value]
From OpenJson(@RetornoAPI)
Where [key] = 'bairro'

Select @UF = [value]
From OpenJson(@RetornoAPI)
Where [key] = 'uf'

Select @Localidade = [value]
From OpenJson(@RetornoAPI)
Where [key] = 'localidade'

Select @IBGE = [value]
From OpenJson(@RetornoAPI)
Where [key] = 'ibge'

Insert Cep (Cep, Bairro, Rua, Localidade, UF, IBGE)
Select @Cep, @Bairro, @Rua, @Localidade, @UF, @IBGE

Select * 
From Cep


-- testes

-- token tributei: YDfefnHgFJ7XA-YD8dLoAY2E1fM-YDEKcGyrNulbU

DECLARE @authHeader VARCHAR(8000);
DECLARE @contentType VARCHAR(8000);
DECLARE @postData VARCHAR(8000);
DECLARE @responseText VARCHAR(8000);
DECLARE @responseXML VARCHAR(8000);
DECLARE @ret INT;
DECLARE @status VARCHAR(8000);
DECLARE @statusText VARCHAR(8000);
DECLARE @token INT;
DECLARE @url VARCHAR(8000);
DECLARE @JSON VARCHAR(8000);

SET @authHeader = 'Bearer YDfefnHgFJ7XA-YD8dLoAY2E1fM-YDEKcGyrNulbU';
SET @contentType = 'application/json';
SET @url = 'https://api.tributei.net/api/65069593000198/2023/sp/consulta/difal/ncm'

-- Open the connection.
EXEC @ret = sp_OACreate 'MSXML2.ServerXMLHTTP', @token OUT;
IF @ret <> 0 RAISERROR('Unable to open HTTP connection.', 10, 1);

--select @token

-- Send the request.

/*EXEC @ret = sp_OAMethod @token, 'Open', null, 'GET', @Url, 'false'
EXEC @ret = sp_OAMethod @token, 'setRequestHeader', NULL, 'Authorization', @authHeader;
EXEC @ret = sp_OAMethod @token, 'setRequestHeader', NULL, 'Content-type', @contentType;

EXEC sp_OAMethod @token, 'send', null
EXEC sp_OAMethod @token, 'responseText', @ResponseText OUTPUT

SET @JSON = @ResponseText
SELECT @JSON */

--SET @authHeader = 'Bearer keHDkAlaWwlczbqmGuGnqqYm-d3GfAvu_IuaX2l93';
--EXEC @ret = sp_OAMethod @token, 'setRequestHeader', NULL, 'Authorization', @authHeader;

--DECLARE @RequestBody VARCHAR(8000)='[{"query": "4821.90.00"}]'
--EXEC @ret = sp_OAMethod @token, 'send', NULL, @RequestBody;
--EXEC @ret = sp_OAMethod @token, 'send', NULL, 'Authorization', @authHeader, @RequestBody;

--select @ret

EXEC @ret = sp_OAMethod @token, 'Open', null, 'POST', @Url, 'false'
EXEC @ret = sp_OAMethod @token, 'setRequestHeader', NULL, 'Authorization', @authHeader;
EXEC @ret = sp_OAMethod @token, 'setRequestHeader', NULL, 'Content-type', @contentType;

--EXEC sp_OAMethod @token, 'send', null

DECLARE @RequestBody VARCHAR(8000)='{"query": "4821.90.00"}'
EXEC @ret = sp_OAMethod @token, 'send', NULL, @RequestBody;

EXEC sp_OAMethod @token, 'responseText', @ResponseText OUTPUT

SET @JSON = @ResponseText
SELECT @JSON


-- função para leitura de um json

IF (OBJECT_ID (N'dbo.fncJSON_Read') IS NOT NULL) DROP FUNCTION dbo.fncJSON_Read
GO

CREATE FUNCTION dbo.fncJSON_Read ( 
    @JSON NVARCHAR(MAX) 
)
RETURNS @Retorno TABLE (
    Id_Elemento INT NULL,
    Nr_Sequencia [INT] NULL,
    Id_Objeto_Pai INT,
    Id_Objeto INT,
    Ds_Nome NVARCHAR(2000),
    Ds_String NVARCHAR(MAX) NOT NULL,
    Ds_Tipo VARCHAR(10) NOT NULL
)
AS
BEGIN


    DECLARE
        @FirstObject INT,
        @OpenDelimiter INT,
        @NextOpenDelimiter INT,
        @NextCloseDelimiter INT,
        @Type NVARCHAR(10),
        @NextCloseDelimiterChar CHAR(1),
        @Contents NVARCHAR(MAX),
        @Start INT,
        @end INT,
        @param INT,
        @EndOfDs_Nome INT,
        @token NVARCHAR(200),
        @value NVARCHAR(MAX),
        @Nr_Sequencia INT,
        @Ds_Nome NVARCHAR(200),
        @Id_Objeto_Pai INT,
        @lenJSON INT,
        @characters NCHAR(36),
        @result BIGINT,
        @index SMALLINT,
        @Escape INT
   
 
    DECLARE @Strings TABLE (
        String_ID INT IDENTITY(1, 1),
        Ds_String NVARCHAR(MAX)
    )
    
    SELECT
        @characters = '0123456789abcdefghijklmnopqrstuvwxyz',
        @Nr_Sequencia = 0,
        @Id_Objeto_Pai = 0;
        
    WHILE (1 = 1)
    BEGIN
    
        SELECT @Start = PATINDEX('%[^a-zA-Z]["]%', @JSON COLLATE SQL_Latin1_General_CP850_BIN);
        
        IF (@Start = 0)
            BREAK
            
        IF (SUBSTRING(@JSON, @Start + 1, 1) = '"')
        BEGIN
            SET @Start = @Start + 1;
            SET @end = PATINDEX('%[^\]["]%', RIGHT(@JSON, LEN(@JSON + '|') - @Start) COLLATE SQL_Latin1_General_CP850_BIN);
        END
        
        IF (@end = 0)
            BREAK
            
        SELECT
            @token = SUBSTRING(@JSON, @Start + 1, @end - 1)
      
      
        SELECT
            @token = REPLACE(@token, FromString, ToString)
        FROM (
              SELECT '\"' AS FromString, '"' AS ToString
              UNION ALL
              SELECT '\\', '\'
              UNION ALL
              SELECT '\/', '/'
              UNION ALL
              SELECT '\b', CHAR(08)
              UNION ALL
              SELECT '\f', CHAR(12)
              UNION ALL
              SELECT '\n', CHAR(10)
              UNION ALL
              SELECT '\r', CHAR(13)
              UNION ALL
              SELECT '\t', CHAR(09)
        ) substitutions
        
        
        SELECT
            @result = 0,
            @Escape = 1
  
  
        WHILE (@Escape > 0)
        BEGIN
        
            SELECT
                @index = 0,
                @Escape = PATINDEX('%\x[0-9a-f][0-9a-f][0-9a-f][0-9a-f]%', @token COLLATE SQL_Latin1_General_CP850_BIN)
                
                
            IF (@Escape > 0)
            BEGIN
            
                WHILE (@index < 4)
                BEGIN
                
                    SELECT
                        @result = @result + POWER(16, @index) * ( CHARINDEX(SUBSTRING(@token, @Escape + 2 + 3 - @index, 1), @characters) - 1 ),
                        @index = @index + 1;

                END
                      
                SELECT @token = STUFF(@token, @Escape, 6, NCHAR(@result))
                
            END
            
        END
      
      
        INSERT INTO @Strings ( Ds_String )
        SELECT @token
      
        
        SELECT @JSON = STUFF(@JSON, @Start, @end + 1, '@string' + CONVERT(NVARCHAR(5), @@IDENTITY))
        
    END
  
  
    WHILE (1 = 1)
    BEGIN
 
        SELECT @Id_Objeto_Pai = @Id_Objeto_Pai + 1
        SELECT @FirstObject = PATINDEX('%[{[[]%', @JSON COLLATE SQL_Latin1_General_CP850_BIN)
        
        IF (@FirstObject = 0)
            BREAK
            
            
        IF ( SUBSTRING(@JSON, @FirstObject, 1) = '{' )
            SELECT @NextCloseDelimiterChar = '}', @Type = 'object'
        ELSE
            SELECT @NextCloseDelimiterChar = ']', @Type = 'array'
            
             
        SELECT @OpenDelimiter = @FirstObject
 
 
        WHILE (1 = 1)
        BEGIN
        
            SELECT @lenJSON = LEN(@JSON + '|') - 1
            SELECT @NextCloseDelimiter = CHARINDEX(@NextCloseDelimiterChar, @JSON, @OpenDelimiter + 1)
            SELECT @NextOpenDelimiter = PATINDEX('%[{[[]%', RIGHT(@JSON, @lenJSON - @OpenDelimiter) COLLATE SQL_Latin1_General_CP850_BIN)
            
            
            IF (@NextOpenDelimiter = 0)
                BREAK
              
                
            SELECT @NextOpenDelimiter = @NextOpenDelimiter + @OpenDelimiter
            
            
            IF (@NextCloseDelimiter < @NextOpenDelimiter)
                BREAK
                
            
            IF SUBSTRING(@JSON, @NextOpenDelimiter, 1) = '{'
                SELECT @NextCloseDelimiterChar = '}', @Type = 'object'
            ELSE
                SELECT @NextCloseDelimiterChar = ']', @Type = 'array'

            
            SELECT @OpenDelimiter = @NextOpenDelimiter
            
            
        END
        
        
        SELECT @Contents = SUBSTRING(@JSON, @OpenDelimiter + 1, @NextCloseDelimiter - @OpenDelimiter - 1)
        SELECT @JSON = STUFF(@JSON, @OpenDelimiter, @NextCloseDelimiter - @OpenDelimiter + 1, '@' + @Type + CONVERT(NVARCHAR(5), @Id_Objeto_Pai))
        
        
        WHILE (( PATINDEX('%[A-Za-z0-9@+.e]%', @Contents COLLATE SQL_Latin1_General_CP850_BIN) ) <> 0)
        BEGIN
        
            IF (@Type = 'Object')
            BEGIN
                    
                SELECT 
                    @Nr_Sequencia = 0,
                    @end = CHARINDEX(':', ' ' + @Contents)
                    
                    
                SELECT @Start = PATINDEX('%[^A-Za-z@][@]%', ' ' + @Contents COLLATE SQL_Latin1_General_CP850_BIN)--AAAAAAAA
                    
                      
                SELECT
                    @token = SUBSTRING(' ' + @Contents, @Start + 1, @end - @Start - 1),
                    @EndOfDs_Nome = PATINDEX('%[0-9]%', @token COLLATE SQL_Latin1_General_CP850_BIN),
                    @param = RIGHT(@token, LEN(@token) - @EndOfDs_Nome + 1)
                    
                    
                SELECT
                    @token = LEFT(@token, @EndOfDs_Nome - 1),
                    @Contents = RIGHT(' ' + @Contents, LEN(' ' + @Contents + '|') - @end - 1)
                    
                    
                SELECT
                    @Ds_Nome = Ds_String
                FROM
                    @Strings
                WHERE
                    String_ID = @param
                    
                    
            END
            ELSE
                SELECT 
                    @Ds_Nome = NULL, 
                    @Nr_Sequencia = @Nr_Sequencia + 1
                    
                    
            SELECT @end = CHARINDEX(',', @Contents)
            
            
            IF (@end = 0)
                SELECT @end = PATINDEX('%[A-Za-z0-9@+.e][^A-Za-z0-9@+.e]%', @Contents + ' ' COLLATE SQL_Latin1_General_CP850_BIN) + 1
                
                
            SELECT @Start = PATINDEX('%[^A-Za-z0-9@+.e][A-Za-z0-9@+.e]%', ' ' + @Contents COLLATE SQL_Latin1_General_CP850_BIN)
      
      
            SELECT
                @value = RTRIM(SUBSTRING(@Contents, @Start, @end - @Start)),
                @Contents = RIGHT(@Contents + ' ', LEN(@Contents + '|') - @end)
                
                
            IF (SUBSTRING(@value, 1, 7) = '@object')
            BEGIN
            
                INSERT INTO @Retorno ( Ds_Nome, Nr_Sequencia, Id_Objeto_Pai, Ds_String, Id_Objeto, Ds_Tipo )
                SELECT
                    @Ds_Nome,
                    @Nr_Sequencia,
                    @Id_Objeto_Pai,
                    SUBSTRING(@value, 8, 5),
                    SUBSTRING(@value, 8, 5),
                    'object'
                    
            END
            ELSE BEGIN
            
                IF (SUBSTRING(@value, 1, 6) = '@array')
                
                    INSERT INTO @Retorno ( Ds_Nome, Nr_Sequencia, Id_Objeto_Pai, Ds_String, Id_Objeto, Ds_Tipo )
                    SELECT
                        @Ds_Nome,
                        @Nr_Sequencia,
                        @Id_Objeto_Pai,
                        SUBSTRING(@value, 7, 5),
                        SUBSTRING(@value, 7, 5),
                        'array'
                        
                ELSE
                
                    IF (SUBSTRING(@value, 1, 7) = '@string')
                        INSERT INTO @Retorno ( Ds_Nome, Nr_Sequencia, Id_Objeto_Pai, Ds_String, Ds_Tipo )
                        SELECT
                            @Ds_Nome,
                            @Nr_Sequencia,
                            @Id_Objeto_Pai,
                            Ds_String,
                            'string'
                         FROM
                            @Strings
                         WHERE
                            String_ID = SUBSTRING(@value, 8, 5)
                            
                    ELSE
                    
                         IF (@value IN ( 'true', 'false' ))
                            INSERT INTO @Retorno ( Ds_Nome, Nr_Sequencia, Id_Objeto_Pai, Ds_String, Ds_Tipo )
                            SELECT
                                @Ds_Nome,
                                @Nr_Sequencia,
                                @Id_Objeto_Pai,
                                @value,
                                'boolean'
                         ELSE
                         
                            IF (@value = 'null')
                                INSERT INTO @Retorno ( Ds_Nome, Nr_Sequencia, Id_Objeto_Pai, Ds_String, Ds_Tipo )
                                SELECT
                                    @Ds_Nome,
                                    @Nr_Sequencia,
                                    @Id_Objeto_Pai,
                                    @value,
                                    'null'
                                    
                            ELSE
                            
                                IF (PATINDEX('%[^0-9]%', @value COLLATE SQL_Latin1_General_CP850_BIN) > 0)
                                    INSERT INTO @Retorno ( Ds_Nome, Nr_Sequencia, Id_Objeto_Pai, Ds_String, Ds_Tipo )
                                    SELECT
                                        @Ds_Nome,
                                        @Nr_Sequencia,
                                        @Id_Objeto_Pai,
                                        @value,
                                        'real'
                                        
                                ELSE
                                
                                    INSERT INTO @Retorno ( Ds_Nome, Nr_Sequencia, Id_Objeto_Pai, Ds_String, Ds_Tipo )
                                    SELECT
                                        @Ds_Nome,
                                        @Nr_Sequencia,
                                        @Id_Objeto_Pai,
                                        @value,
                                        'int'
                                        
                IF (@Contents = ' ')
                    SELECT @Nr_Sequencia = 0
                    
            END
            
        END
        
    END
        
        
    INSERT INTO @Retorno ( Ds_Nome, Nr_Sequencia, Id_Objeto_Pai, Ds_String, Id_Objeto, Ds_Tipo )
    SELECT
        '-',
        1,
        NULL,
        '',
        @Id_Objeto_Pai - 1,
        @Type
        
        
    
    DECLARE @Tabela_Final TABLE (
        Id_Elemento INT IDENTITY(1, 1) NOT NULL,
        Nr_Sequencia [INT] NULL,
        Id_Objeto_Pai INT,
        Id_Objeto INT,
        Ds_Nome NVARCHAR(2000),
        Ds_String NVARCHAR(MAX) NOT NULL,
        Ds_Tipo VARCHAR(10) NOT NULL
    )
    
    INSERT INTO @Tabela_Final
    SELECT 
        Nr_Sequencia,
        Id_Objeto_Pai,
        Id_Objeto,
        Ds_Nome,
        Ds_String,
        Ds_Tipo 
    FROM
        @Retorno
    ORDER BY 
        ISNULL(Id_Objeto, Id_Objeto_Pai) DESC,
        Id_Objeto_Pai DESC,
        Id_Elemento
        
        
    DELETE FROM @Retorno
    
    
    INSERT INTO @Retorno
    SELECT
        Id_Elemento,
        Nr_Sequencia,
        Id_Objeto_Pai,
        Id_Objeto,
        Ds_Nome,
        Ds_String,
        Ds_Tipo 
    FROM 
        @Tabela_Final
    
        
    RETURN
    
    
END

select * from dbo.fncJSON_Read('{"data":[{"id":6314,"ncm":"4821.90.00","aliquota_interna":"18.00","descricao":"- Outras","base_legal":"Art. 52, Inc. I, RICMS\/SP","fcp":"0.00","base_legal_fcp":null,"anexo":0,"duplicado":0,"created_at":"2023-02-07 17:05:00","updated_at":"2023-02-07 17:05:00","validity_at":"2023-01-16","revoked_at":null}]}')

SELECT 
    MAX(CASE WHEN Nr_Sequencia = 1 THEN Id_Elemento END) AS Id_Elemento,
    MAX(CASE WHEN Nr_Sequencia = 1 THEN Id_Objeto_Pai END) AS Id_Objeto_Pai,
    MAX(CASE WHEN Nr_Sequencia = 1 THEN Id_Objeto END) AS Id_Objeto,
    MAX(CASE WHEN Nr_Sequencia = 1 THEN Ds_Nome END) AS Ds_Nome,
    MAX(CASE WHEN Nr_Sequencia = 1 THEN Ds_String END) AS Ds_String,
    MAX(CASE WHEN Nr_Sequencia = 1 THEN Ds_Tipo END) AS Ds_Tipo,
    MAX(CASE WHEN Nr_Sequencia = 2 THEN Ds_Nome END) AS Ds_Nome2,
    MAX(CASE WHEN Nr_Sequencia = 2 THEN Ds_String END) AS Ds_String2,
    MAX(CASE WHEN Nr_Sequencia = 2 THEN Ds_Tipo END) AS Ds_Tipo2
    -- Continue com as outras colunas se necessário
FROM (
select * from dbo.fncJSON_Read('{"data":[{"id":6314,"ncm":"4821.90.00","aliquota_interna":"18.00","descricao":"- Outras","base_legal":"Art. 52, Inc. I, RICMS\/SP","fcp":"0.00","base_legal_fcp":null,"anexo":0,"duplicado":0,"created_at":"2023-02-07 17:05:00","updated_at":"2023-02-07 17:05:00","validity_at":"2023-01-16","revoked_at":null}]}')
) as tab
GROUP BY Id_Elemento

SELECT
    MAX(CASE WHEN Ds_Nome = 'id' THEN Ds_String END) AS id,
    MAX(CASE WHEN Ds_Nome = 'ncm' THEN Ds_String END) AS ncm,
    MAX(CASE WHEN Ds_Nome = 'aliquota_interna' THEN Ds_String END) AS 'aliquota_interna',
    MAX(CASE WHEN Ds_Nome = 'descricao' THEN Ds_String END) AS 'descricao',
    MAX(CASE WHEN Ds_Nome = 'base_legal' THEN Ds_String END) AS 'base_legal',
    MAX(CASE WHEN Ds_Nome = 'fcp' THEN Ds_String END) AS 'fcp',
    MAX(CASE WHEN Ds_Nome = 'base_legal_fcp' THEN Ds_String END) AS 'base_legal_fcp',
    MAX(CASE WHEN Ds_Nome = 'anexo' THEN Ds_String END) AS 'anexo',
    MAX(CASE WHEN Ds_Nome = 'duplicado' THEN Ds_String END) AS 'duplicado',
    MAX(CASE WHEN Ds_Nome = 'created_at' THEN Ds_String END) AS 'created_at',
    MAX(CASE WHEN Ds_Nome = 'updated_at' THEN Ds_String END) AS 'updated_at',
    MAX(CASE WHEN Ds_Nome = 'validity_at' THEN Ds_String END) AS 'validity_at',
    MAX(CASE WHEN Ds_Nome = 'revoked_at' THEN Ds_String END) AS 'revoked_at'
FROM (
select * from dbo.fncJSON_Read('{"data":[{"id":6314,"ncm":"4821.90.00","aliquota_interna":"18.00","descricao":"- Outras","base_legal":"Art. 52, Inc. I, RICMS\/SP","fcp":"0.00","base_legal_fcp":null,"anexo":0,"duplicado":0,"created_at":"2023-02-07 17:05:00","updated_at":"2023-02-07 17:05:00","validity_at":"2023-01-16","revoked_at":null}]}')
) as tab

select CLICOD
       ,CLIEND
       ,CLINUM
  from TBS002 with (nolock)
 where isnumeric(CLICGC) = 1
       and patindex('%[^0-9]%', CLICGC) = 0
       and CLITIPPES='J'

select CLICOD
       ,CLICEP
  from TBS002 with (nolock)
 where isnumeric(replace(CLICEP,'-','')) = 1
       and patindex('%[^0-9]%', replace(CLICEP,'-','')) = 0
       