drop function MarkupRevenda
go

create function MarkupRevenda(@markupCorp decimal(10,4), @markupReven decimal(10,4)) returns decimal(10,4) as
   begin
      declare @retorno decimal(10,4), @resultado decimal(10,4)

      set @resultado = case when @markupCorp/.9 > 70 then 70 else @markupCorp/.9 end

      if @resultado > @markupReven and @markupReven > 0
         set @resultado = @markupReven

      set @retorno = @resultado

      return @retorno
   end
go

select dbo.MarkupRevenda(74.52740,75)

select * from TBS015 (nolock) where PDPMKPCOR1 is null



update TBS015 set PDPMKPREV1=dbo.MarkupRevenda(PDPMKPCOR1,PDPMKPREV1),PDPMKPREV2=100,PDPREDREV1=0,PDPREDREV2=0,PDPREDREV3=0,PDPREDREV4=0
--select top 500
--       PDPCOD,
--       PDPMKPCOR1,
--       PDPMKPCOR1/.9,
--       dbo.MarkupRevenda(PDPMKPCOR1,PDPMKPREV1)
  from TBS015 (nolock)
 where PDPMKPCOR1 > 0 and
       exists(select '' from TBS031 (nolock) where TDPPROCOD=PDPCOD)
 order by PDPCOD


--PDPCOD in('10780001','10790012','1080039','1080040')


select 10/'2'

select TOP 100
TDPPROCOD CODIGO,
ltrim(str(
case when
case when 
case when PDPMKPCOR1/('0.9000') > '70.0000' 
            then '70.0000' 
            else PDPMKPCOR1/('0.9000') 
end > PDPMKPREV1
            then PDPMKPREV1
            else 
case when PDPMKPCOR1/('0.9000') > '70.0000' 
            then '70.0000' 
            else PDPMKPCOR1/('0.9000') 
end
end = 0
            then
case when PDPMKPCOR1/('0.9000') > '70.0000' 
            then '70.0000' 
            else PDPMKPCOR1/('0.9000') 
end
            else
case when 
case when PDPMKPCOR1/('0.9000') > '70.0000' 
            then '70.0000' 
            else PDPMKPCOR1/('0.9000') 
end > PDPMKPREV1
            then PDPMKPREV1
            else 
case when PDPMKPCOR1/('0.9000') > '70.0000' 
            then '70.0000' 
            else PDPMKPCOR1/('0.9000') 
end
end
end,10,4)) 'MKP 1 REVENDA'
from TBS031 join TBS015 on TDPPROCOD = PDPCOD
where PDPMKPCOR1 > 0 and PDPMKPCOR1 is not null



select PDPCOD,
ltrim(str(
case
   when case
           when case
                   when PDPMKPCOR1/('0.9000') > '70.0000' then '70.0000' 
                   else PDPMKPCOR1/('0.9000') 
                end > PDPMKPREV1
            then PDPMKPREV1
            else 
case when PDPMKPCOR1/('0.9000') > '70.0000' 
            then '70.0000' 
            else PDPMKPCOR1/('0.9000') 
end
end = 0
            then
case when PDPMKPCOR1/('0.9000') > '70.0000' 
            then '70.0000' 
            else PDPMKPCOR1/('0.9000') 
end
            else
case when 
case when PDPMKPCOR1/('0.9000') > '70.0000' 
            then '70.0000' 
            else PDPMKPCOR1/('0.9000') 
end > PDPMKPREV1
            then PDPMKPREV1
            else 
case when PDPMKPCOR1/('0.9000') > '70.0000' 
            then '70.0000' 
            else PDPMKPCOR1/('0.9000') 
end
end
end,10,4)) 'MKP 1 REVENDA'
from TBS031 join TBS015 on TDPPROCOD = PDPCOD
where PDPMKPCOR1 > 0 and PDPMKPCOR1 is not null
