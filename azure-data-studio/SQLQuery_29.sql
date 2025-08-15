DROP FUNCTION [dbo].[fncMostra_Caracteres_Ocultos]
go

CREATE FUNCTION [dbo].[fncMostra_Caracteres_Ocultos](
    @String VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN

    DECLARE 
        @Result VARCHAR(MAX) = '', 
        @Contador INT = 1,
        @Total INT,
        @AdicionarBarra BIT = 0
    
    
    SET @Total = LEN(@String)

    WHILE(@Contador <= @Total)
    BEGIN
        
        IF (PATINDEX('%[^ !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ\^_`abcdefghijklmnopqrstuvwxyz|{}~€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ[[]%', SUBSTRING(REPLACE(@String, ']', ''), @Contador, 1)) > 0)
        BEGIN
            SET @Result += (CASE WHEN @AdicionarBarra = 1 THEN ' | ' ELSE '' END) + 'Pos ' + CAST(@Contador AS VARCHAR(500)) + ': CHAR(' + CAST(ASCII(SUBSTRING(@String, @Contador, 1)) AS VARCHAR(500)) + ')'
            SET @AdicionarBarra = 1
        END

        SET @Contador += 1

    END
    
    RETURN @Result

END
GO

select top(1) PRODES
  from TBS010 with (nolock)
 where dbo.fncMostra_Caracteres_Ocultos(PRODES) = 1

select CLINOM
  from TBS002 with (nolock)
 where dbo.fncMostra_Caracteres_Ocultos(CLINOM) = 1


SELECT        TOP (200) NEEEMPCOD, '35220865069593000350550020000618331707441304', 0, NEESERDOC, 61833, NEECGCCPF, NEENOM, NEEIE, NEEDATEMI, 274.56, NEETIPOPE, '', NEESITNFE, NEESITMAN, NEEEVEUSU, NEEEVEOBS, 'N', 
                         'N', 'N', NEEDATHORPRO, NEEEVEPRO, NEEDATCON, NEEVALCOFINS, NEEVALDES, NEEVALFRE, NEEVALICMS, NEEVALICMSST, NEEVALII, NEEVALIPI, NEEVALOUTDES, NEEVALPIS, NEEVALSEG, 
                         NEEVBCICMS, NEEVBCICMSST, NEEVALPRO, NEEDATENT, NEENATOPE, NEENFECON, NEEQTDVOL, NEEFINNFE
FROM            TBS099
WHERE        (CONVERT(date, NEEDATEMI) = '20220804') AND (NEENUM = 61804)
--go 5

SELECT        TOP (200) NEEEMPCOD, NEECHAACE, NEENSU, NEESERDOC, NEENUM, NEECGCCPF, NEENOM, NEEIE, NEEDATEMI, NEEVALTOT, NEETIPOPE, NEEDIGVAL, NEESITNFE, NEESITMAN, NEEEVEUSU, NEEEVEOBS, NEENFEENT, 
                         NEENFEEFE, NEEDOWNLOAD, NEEDATHORPRO, NEEEVEPRO, NEEDATCON, NEEVALCOFINS, NEEVALDES, NEEVALFRE, NEEVALICMS, NEEVALICMSST, NEEVALII, NEEVALIPI, NEEVALOUTDES, NEEVALPIS, NEEVALSEG, 
                         NEEVBCICMS, NEEVBCICMSST, NEEVALPRO, NEEDATENT, NEENATOPE, NEENFECON, NEEQTDVOL, NEEFINNFE
FROM            TBS099
WHERE        (CONVERT(date, NEEDATEMI) = '20220804') AND (NEENUM = 61804)

select PROCOD
       ,PRODES 
  from TBS010
 --where PRODES not Like '%[^A-Za-z0-9, ]%'
WHERE PRODES LIKE '%[-!#%&+,./:;<=>@`{|}~"()*éáíóú`âô^\\\_\^\?\[\]\'']%' {ESCAPE '\'}


select PROCOD
       ,PRODES 
  from TBS010 with (nolock)
 where Len(PRODES) <> dataLength(PRODES)

select PROCOD
       ,PRODES
       ,PRODES COLLATE sql_latin1_general_cp1251_ci_as as 'descr'
--  into #produtos
  from TBS010 with (nolock)
 where Len(Ltrim(rtrim(PRODES))) <> dataLength(Ltrim(rtrim(PRODES))) 
       --and PROCOD=

 COLLATE sql_latin1_general_cp1251_ci_as

select *
  from #produtos
 where PRODES <> descr collate database_default

select *
  from TBS010 with (nolock)
 where PRODES Like('LOUSA MAGNETICA%')

select *
  from TBS010 with (nolock)
 where PROCOD is null 

select *
  from TBS010 with (nolock)
 where SUBGRUCOD is null 

select PROCOD
       ,PRODES
       ,Len(PRODES)
       ,dataLength(PRODES)
  from TBS010 with (nolock)
GO

CREATE FUNCTION [dbo].[fncPossui_Caractere_Oculto](
    @String VARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    RETURN (CASE WHEN PATINDEX('%[^ !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ\^_`abcdefghijklmnopqrstuvwxyz|{}~€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ[[]%', REPLACE(@String, ']', '')) > 0 THEN 1 ELSE 0 END)
END
GO

select PROCOD
       ,PRODES
       ,PRODES collate SQL_Latin1_General_CP1251_CS_AS
       --,dbo.fncRemove_Caracteres_Especiais(PRODES) as 'teste'
       ,Len(PRODES)
       ,dataLength(PRODES)
  from TBS010 with (nolock)
 where dbo.fncPossui_Caractere_Oculto(PRODES) = 1

begin tran
update TBS010
   set PRODES=PRODES collate SQL_Latin1_General_CP1251_CI_AS
 where PROCOD in('12570529','26450040')
       
rollback tran
commit tran

GO

CREATE FUNCTION [dbo].[fncRemove_Caracteres_Especiais](
    @String VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN

    
    DECLARE 
        @Result VARCHAR(MAX), 
        @StartingIndex INT = 0
    
    
    WHILE (1 = 1)
    BEGIN 
        
        SET @StartingIndex = PATINDEX('%[^a-Z|0-9|^ ]%',@String) 
        
        IF (@StartingIndex <> 0)
            SET @String = REPLACE(@String,SUBSTRING(@String, @StartingIndex,1),'') 
        ELSE 
            BREAK

    END	
    
    SET @Result = REPLACE(@String,'|','')
    
    RETURN @Result

END
GO

begin tran
update TBS010
   set PRODES='ESCORREDOR DE TALHERES TRANSP 1624-4600'
 where PROCOD='12570529'
       
rollback tran
commit tran

begin tran
update TBS010
   set PRODES='TOALHA BOPP PEROLA XADREZ OURO'
 where PROCOD='26450040'
       
rollback tran
commit tran

SELECT        PROCOD, PRODES
FROM            TBS010 WITH (nolock)
WHERE        (dbo.fncPossui_Caractere_Oculto(PRODES) = 1)
ORDER BY PRODES
