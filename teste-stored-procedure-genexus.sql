CREATE PROCEDURE [dbo].[sp_dynQuery]
 @query nvarchar(2048) ,
 @outNvar nvarchar(max) OUT
AS
BEGIN
    DECLARE @parmDef nvarchar(512);
    DECLARE @queryTmp nvarchar(2048)
    DECLARE @outTmp nvarchar(max);
    SET NOCOUNT ON;
    SET @parmDef = '@out nvarchar(max) OUTPUT';
    SET @queryTmp = 'SELECT @out = CAST((' + @query + ') AS NVARCHAR(max))';
    EXECUTE sp_executesql @queryTmp, @parmDef, @out=@outTmp OUTPUT; 
    SELECT @outNvar = @outTmp;
    SET NOCOUNT OFF
    RETURN(0)
END

CREATE TABLE [dbo].[Developer](
 [DeveloperId] [smallint] NOT NULL,
 [DeveloperName] [varchar](64) NOT NULL,
 [DeveloperLastName] [varchar](64) NOT NULL,
 [DeveloperMail] [varchar](128) NOT NULL,
PRIMARY KEY([DeveloperId]))

INSERT INTO [Developer]
([DeveloperId],[DeveloperName],[DeveloperLastName],[DeveloperMail])
VALUES
    (1,'ZERR','Angelo','angelo.zerr@gmail.com')
   ,(2,'Leclercq','Pascal','pascal.leclercq@gmail.com')


SELECT [DeveloperName]     as devname 
      ,[DeveloperLastName] as devlastname
      ,[DeveloperMail]     as devmail
FROM [Developer]
WHERE [DeveloperId] < 3
FOR XML PATH ('developer'), ROOT ('devs')

declare @n int, @res nvarchar(max)
exec sp_dynQuery 'SELECT [DeveloperName]     as devname 
      ,[DeveloperLastName] as devlastname
      ,[DeveloperMail]     as devmail
FROM [Developer]
WHERE [DeveloperId] < 3
FOR XML PATH (''developer''), ROOT (''devs'')', @res output

select @res

