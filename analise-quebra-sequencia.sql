select min(ENFNUM) from TBS080 (nolock) where SNESER=1 and ENFDATEMI >= '20170401'

select ENFNUM-1 from TBS080 as a (nolock)
 where ENFNUM <> 1 and not exists(select ENFNUM from TBS080 as b (nolock) where b.ENFNUM=(a.ENFNUM-1))

declare @max int, @curr int
select @max = max(ENFNUM) from TBS080 (nolock) where ENFDATEMI<='20170420' and SNESER=4
set @curr = 0

select @curr = min(ENFNUM) from TBS080 (nolock) where ENFDATEMI>='20160101' and SNESER=4

print @max
print @curr

while @curr < @max
begin
set @curr = @curr + 1
if(not EXISTS(select ENFNUM from TBS080 (nolock) where ENFDATEMI between '20170101' and '20170420' and SNESER=4 and ENFNUM = @curr))
begin
	print 'Código ' + cast(@curr as char(10)) + ' não encontrado.'
end
end

select ENFDATEMI,ENFNUM from TBS080 (nolock) where SNESER=0 order by ENFDATEMI --ENFDATEMI >= '20170401'

