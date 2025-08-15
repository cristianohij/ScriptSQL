DECLARE @getdate DATETIME;
 
SET @getdate = GETDATE();
 
SELECT CAST('1) Data Processada'         AS VARCHAR(50)), @getdate
 UNION
SELECT CAST('2) Primeiro dia do mês'     AS VARCHAR(50)), DATEADD(mm, DATEDIFF(mm, 0, @getdate), 0)
 UNION
SELECT CAST('3) Primeiro dia da semana'  AS VARCHAR(50)), DATEADD(wk, DATEDIFF(wk, 0, @getdate), 0)
 UNION
SELECT CAST('4) Inicio do dia'           AS VARCHAR(50)), DATEADD(dd, DATEDIFF(dd, 0, @getdate), 0)
 UNION
SELECT CAST('5) Fim do dia'              AS VARCHAR(50)), DATEADD(ms ,-3 ,DATEADD(dd, DATEDIFF(dd, 0, @getdate) + 1, 0))
 UNION
SELECT CAST('6) Último dia da semana'    AS VARCHAR(50)), DATEADD(ms ,-3 ,DATEADD(wk, DATEDIFF(wk, 0, @getdate) + 1, 0))
 UNION
SELECT CAST('7) Último dia do mês'       AS VARCHAR(50)), DATEADD(ms ,-3 ,DATEADD(mm, DATEDIFF(mm, 0, @getdate) + 1, 0))


-- testes

-- último dia do mês
declare @data date

set @data = convert(date,DATEADD(ms ,-3 ,DATEADD(mm, DATEDIFF(mm, 0, getdate()) + 1, 0)))

-- primeiro dia do mês seguinte

select @data

SELECT DATEADD(day, 1, @data)

-- primeiro dia do mês atual

SELECT CONVERT(VARCHAR, GETDATE() - DAY(GETDATE()) + 1, 103) as PrimeiroDiaDoMes

-- primeiro dia do mês anterior

select DateAdd(mm, DateDiff(mm,0,GetDate()) - 1, 0) 

-- último dia do mês anterior

select DateAdd(mm, DateDiff(mm,0,GetDate()), -1)

declare @data date

set @data = getdate()

print @data

select convert(date,@data,110)

select getdate()

select convert(date,getdate(),114)