-- backup FCNDIASUTEIS winpack

USE [SIBD4]
GO
/****** Object:  UserDefinedFunction [dbo].[FCNDIASUTEIS]    Script Date: 25/04/2022 11:24:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[FCNDIASUTEIS] (@DATAINICIAL DATETIME, @DATAFINAL DATETIME)

returns int
as 

begin

declare @siglaCidade char(2), @contador int, @diasUteis int, @totalDias int, @qtdFeriados int

set @siglaCidade = 'SP' 
set @totalDias = (select datediff(DD, @DATAINICIAL, @DATAFINAL))
set @contador = 0 

declare @Tabela as Table (semana int, data datetime)

while @contador <= @totalDias

begin 
	insert into @Tabela
	select 
	datepart(DW, (dateadd(DD, @contador, @DATAINICIAL))), dateadd(DD, @contador, @DATAINICIAL)
	
	set @contador = @contador + 1
end


set @diasUteis = (select count(semana) from @Tabela where semana not in (1,7) )


--select @diasUteis
--
--
--select * from #Tabela


-- É preciso criar uma tabela de feriado, e para cada ano entre as datas acrescentar os feriados fixos (Nr_Ano = 0)

declare @anoDe int, @anoAte int

set @anoDe = year(@DATAINICIAL)
set @anoAte = year(@DATAFINAL)

declare @Feriados as Table (semana int, data datetime)

while @anoDe <= @anoAte

begin 
	
	insert into @Feriados
	select 
	datepart(DW, convert(datetime, ltrim(str(@anoDe)) +  right('0' + ltrim(str(Nr_Mes)), 2) +  right('0' + ltrim(str(Nr_Dia)), 2) ) ), 
	convert(datetime, ltrim(str(@anoDe)) +  right('0' + ltrim(str(Nr_Mes)), 2) +  right('0' + ltrim(str(Nr_Dia)), 2) )
	
	from FERIADO (nolock)
	
	where 
	(Sg_UF = @siglaCidade or Tp_Feriado = 1) and 
	Nr_Ano = 0 and 
	convert(datetime, ltrim(str(@anoDe)) +  right('0' + ltrim(str(Nr_Mes)), 2) +  right('0' + ltrim(str(Nr_Dia)), 2) ) between @DATAINICIAL and @DATAFINAL


set @anoDe = @anoDe + 1

end 


insert into @Feriados
select 
datepart(DW, convert(datetime, ltrim(str(@anoDe)) +  right('0' + ltrim(str(Nr_Mes)), 2) +  right('0' + ltrim(str(Nr_Dia)), 2) ) ), 
convert(datetime, ltrim(str(@anoDe)) +  right('0' + ltrim(str(Nr_Mes)), 2) +  right('0' + ltrim(str(Nr_Dia)), 2) )

from FERIADO (nolock)

where 
(Sg_UF = @siglaCidade or Tp_Feriado = 1) and 
Nr_Ano <> 0 and 
convert(datetime, ltrim(str(@anoDe)) +  right('0' + ltrim(str(Nr_Mes)), 2) +  right('0' + ltrim(str(Nr_Dia)), 2) ) between @DATAINICIAL and @DATAFINAL


-- Verificar se esses feriados não caem em um sabado ou domingo ( de acordo com os dias que não são contabilizados )

set @qtdFeriados = (select count(semana) from @Feriados where semana not in (1,7) )


set @diasUteis = @diasUteis - @qtdFeriados


-- select @diasUteis

return @diasUteis

end