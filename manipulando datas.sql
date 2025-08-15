Select DateAdd(mm, DateDiff(mm,0,GetDate()) - 1, 0) as [Primeiro dia do mês Anterior]

Select DateAdd(mm, DateDiff(mm,0,GetDate()), -1) as [Último dia no mês Anterior]

DECLARE @dataini AS datetime 

DECLARE @datafim AS datetime 

DECLARE @mes AS INT

DECLARE @ano AS INT

DECLARE @dias AS INT

 

SET @dataini = (SELECT DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) --Traz primeiro dia do mes anterior
print @dataini

SET @datafim= (SELECT DATEADD(ms ,-3 ,DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) , 0)))--Traz ultimo dia do mes anterior
print @datafim

SET @mes = (MONTH (GETDATE())) -- Traz o mês atual
print @mes

SET @ano = ( SELECT YEAR(GETDATE()))  -- Traz o ano atual
print @ano

SET @dias = ( SELECT DATEDIFF (DAY ,@dataini,@datafim)) + 1 -- -- Traz o numero de dias do mês anterior se 30 ou 31
print @dias
