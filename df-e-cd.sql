select * from TBS099 (nolock) where NEENSU in(46973)

select * from TBS099 (nolock) where NEECHAACE='35161065069593000350550020000256501946232710'

select * from TBS0991 (nolock) where NEECHAACE='35161065069593000350550020000256501946232710'

select * from TBS0991 (nolock) where NEETIPEVE='610600' order by NEEEVENSU desc

select * from TBS025 (nolock) where PARCHV=1281

begin tran
update TBS025 set PARVAL='0' where PARCHV=1281
commit tran

select top 500 * from TBS099 (nolock) order by NEENSU desc

select * from TBS0991 (nolock) where NEETIPEVE='210200' order by NEEEVENSU desc

select * from TBS0991 (nolock) where NEENSU in(46209)

select * from TBS080 (nolock) where ENFNUM=25765
select * from TBS0802 (nolock) where ENFNUM=25765

begin tran
delete TBS0802 where ENFNUM=25765
commit tran

select * from TBS080 (nolock) where ENFCHAACE='35161065069593000350550020000257651383802840'

select * from TBS0991 (nolock) where NEEEVESEQ>1

select * from TBS0991 (nolock) where NEEEVENSU=41623

select * from TBS0991 (nolock) order by NEEEVENSU desc


select count(*) from TBS0991 (nolock)

select * into TBS0991BKP from TBS0991 (nolock)

select * from TBS0991 (nolock)

drop table TBS0991BKP

begin tran
delete TBS0991 
commit tran

select min(NEEEVENSU) from TBS0991 (nolock)

select * from TBS0991BKP (nolock) where NEEEVENSU < (select min(NEEEVENSU) from TBS0991 (nolock))

insert into TBS0991 select * from TBS0991BKP (nolock) where NEEEVENSU < (select min(NEEEVENSU) from TBS0991 (nolock))



