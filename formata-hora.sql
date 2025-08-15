SET NOCOUNT ON

DECLARE @ARRAY VARCHAR(8000), @DELIMITADOR VARCHAR(100), @S VARCHAR(8000)

-- VALORES PASSADOS PARA A VARIAVEL @ARRAY
SELECT @ARRAY = '17:9:59'
-- SETANDO O DELIMITADOR
SELECT @DELIMITADOR = ':'

IF LEN(@ARRAY) > 0 SET @ARRAY = @ARRAY + @DELIMITADOR 
CREATE TABLE #ARRAY(ITEM_ARRAY VARCHAR(8000))

WHILE LEN(@ARRAY) > 0
BEGIN
   SELECT @S = LTRIM(SUBSTRING(@ARRAY, 1, CHARINDEX(@DELIMITADOR, @ARRAY) - 1))
   INSERT INTO #ARRAY (ITEM_ARRAY) VALUES (@S)
   SELECT @ARRAY = SUBSTRING(@ARRAY, CHARINDEX(@DELIMITADOR, @ARRAY) + 1, LEN(@ARRAY))
END

-- MOSTRANDO O RESULTADO JÁ POPULADO NA TABELA TEMPORÁRIA
SELECT * FROM #ARRAY
--DROP TABLE #ARRAY

SET NOCOUNT OFF

select * from #ARRAY

update #ARRAY set ITEM_ARRAY=right('00'+rtrim(ITEM_ARRAY),2)

create table hora (item_array varchar(8), info char(1))

drop function hora
go

create function hora(@hora varchar(8)) returns varchar(8) as
   begin
      declare @retorno varchar(8), @h char(2), @m char(2), @s char(2)

      declare @array varchar(8), @delimitador char(1), @str varchar(8), @i smallint

      -- VALORES PASSADOS PARA A VARIAVEL @ARRAY
      select @array = @hora
      -- SETANDO O DELIMITADOR
      select @delimitador = ':'

      if Len(@array) > 0 set @array = @array + @delimitador 

      --if (select count(*) from hora) > 0 delete hora
      
      --create table hora (item_array varchar(8), info char(1))

      set @i = 1

      while Len (@array) > 0
         begin
            select @str = Ltrim(subString(@array, 1, charindex(@delimitador, @array) - 1))
            insert into hora (item_array, info) values (@str, case @i when 1 then 'h' when 2 then 'm' else 's' end)
            select @array = subString(@array, charindex(@delimitador, @array) + 1, Len(@array))
      end

-- MOSTRANDO O RESULTADO JÁ POPULADO NA TABELA TEMPORÁRIA
--SELECT * FROM #ARRAY
--DROP TABLE #ARRAY

      update hora set item_array = right('00'+rtrim(item_array),2)

      set @h = (select item_array from hora where info='h')
      set @m = (select item_array from hora where info='m')
      set @s = (select item_array from hora where info='s')

      set @retorno = @h + ':' + @m + ':' + @s
      return @retorno
   end
go



declare @t varchar(8)

set @t = '091743'

select Left(@t,2)
select subString(@t,3,2)
select right(@t,2)


create table #array ( item_array varchar(8))


SET NOCOUNT ON

DECLARE @ARRAY VARCHAR(8000), @DELIMITADOR VARCHAR(100), @S VARCHAR(8000), @i smallint

-- VALORES PASSADOS PARA A VARIAVEL @ARRAY
SELECT @ARRAY = '17:9:59'
-- SETANDO O DELIMITADOR
SELECT @DELIMITADOR = ':'

IF LEN(@ARRAY) > 0 SET @ARRAY = @ARRAY + @DELIMITADOR 
CREATE TABLE #ARRAY(ITEM_ARRAY VARCHAR(8000), info char(1))

set @i = 1

WHILE LEN(@ARRAY) > 0
BEGIN
   SELECT @S = LTRIM(SUBSTRING(@ARRAY, 1, CHARINDEX(@DELIMITADOR, @ARRAY) - 1))
   INSERT INTO #ARRAY (ITEM_ARRAY, info) VALUES (@S, case @i when 1 then 'h' when 2 then 'm' else 's' end)
   SELECT @ARRAY = SUBSTRING(@ARRAY, CHARINDEX(@DELIMITADOR, @ARRAY) + 1, LEN(@ARRAY))
   set @i = @i +1
END

-- MOSTRANDO O RESULTADO JÁ POPULADO NA TABELA TEMPORÁRIA
SELECT * FROM #ARRAY
DROP TABLE #ARRAY

SET NOCOUNT OFF

declare @t varchar(50), @r varchar(50)

set @t = 'xyz'

set @r = (select @t + '-' + select @t)

select @r




drop function dbo.splitstring
go

CREATE FUNCTION dbo.splitstring ( @stringToSplit VARCHAR(MAX) )
RETURNS
 @returnList TABLE ([Name] [nvarchar] (500), [info] [char] (1))
AS
BEGIN

 DECLARE @name NVARCHAR(255), @h char(2), @m char(2), @s char(2), @i smallint, @info char(1), @hora varchar(8)
 DECLARE @pos INT

      set @i = 1

 WHILE CHARINDEX(':', @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX(':', @stringToSplit)  
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)
      select @info = case @i when 1 then 'h' when 2 then 'm' else 's' end

  INSERT INTO @returnList 
  SELECT @name, @info

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)

      set @i = @i + 1
 END

 INSERT INTO @returnList
 SELECT @stringToSplit, 's'

--right('00'+rtrim(ITEM_ARRAY),2)

      set @h = (select right('00'+rtrim([Name]),2) from @returnList where info='h')
      set @m = (select right('00'+rtrim([Name]),2) from @returnList where info='m')
      set @s = (select right('00'+rtrim([Name]),2) from @returnList where info='s')

      select @hora = @h + ':' + @m + ':' + @s

      insert into @returnList ([Name],info) select @hora, ''


 RETURN
END

SELECT * FROM dbo.splitstring('10:8:4')

select horaContagem,(select [Name] from dbo.splitstring(horaContagem) where info=''),* from INV03 with (nolock) where Len(horaContagem) < 8

update INV03 set horaContagem=(select [Name] from dbo.splitstring(horaContagem) where info='') from INV03 with (nolock) where Len(horaContagem) < 8

select * into INV03BKP from INV03 with (nolock) where numeroContagem=1

