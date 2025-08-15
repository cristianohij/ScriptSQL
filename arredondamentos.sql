declare @valor decimal(10,2)

set @valor=0.51

select @valor

drop table #valor

select 3.5613 as valor into #valor

select * from #valor

update #valor set valor=3.1699

select round(valor,1) as a,
       round(valor,2) as b,
       abs(round(valor,2)-round(valor,1)) as c,
       abs(round(valor,2)-round(valor,1))*100 as d,
       ((round(valor,1)-round(valor,2))) as e,
       case
          when abs(round(valor,2)-round(valor,1))*100 > 0 and abs(round(valor,2)-round(valor,1))*100 < 5 then round(valor,2)+(.05-abs(round(valor,2)-round(valor,1)))
--          when abs((round(valor,2)-round(valor,1)))*100 > 5 then round(valor,2)+(round(valor,1)-round(valor,2))
--          else round(valor,2,1)
       end as f
  from #valor

select ceiling(5.1)

select .1 - .02

SELECT ROUND(150.75, 0 ,1)

select abs(-3.4)