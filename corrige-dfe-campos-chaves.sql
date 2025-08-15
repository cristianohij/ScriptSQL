select * from TBS025 (nolock) where PARCHV in(1267,1281,1287,1292)

--begin tran
--update TBS025 set PARVAL='0' where PARCHV=1281
--commit tran

select * from TBS099 (nolock) where NEECHAACE='35150604977099000137550020000105491000105498'

select * from TBS0991 (nolock) where NEECHAACE='35150604977099000137550020000105491000105498'

select count(*) from TBS099 (nolock)
select count(*) from TBS0991 (nolock)

delete TBS099
delete TBS0991

select * from TBS099 (nolock) where NEECHAACE='31150560594538000950550040001635691139131147'

select * from TBS099 (nolock) where NEENUM in(321809)

select * into TBS099BKP2 from TBS099 (nolock)
select * into TBS0991BKP2 from TBS0991 (nolock)


begin tran
insert into TBS099
select * from TBS099BKP2 (nolock)
 where not exists(select '' from TBS099 (nolock) where TBS099.NEECHAACE=TBS099BKP2.NEECHAACE) and
       not exists(select '' from #DFE where chave=NEECHAACE and NSU=NEENSU)
commit tran

select * from TBS099BKP2 (nolock) where NEECHAACE='13150704402277000100550170001093281206894350'

select top 1 * from TBS099 (nolock)
select top 1 * from TBS099BKP2 (nolock)

select NEECHAACE as 'chave',(select min(NEENSU) from TBS099BKP2 as B (nolock) where B.NEECHAACE=A.NEECHAACE) as 'NSU'
  into #DFE
  from TBS099BKP2 as A (nolock) group by NEECHAACE having count(*) > 1

select count(*) from TBS099BKP2 (nolock)

select NEECHAACE,NEEEVENSU from TBS0991BKP2 (nolock) group by NEECHAACE,NEEEVENSU having count(*) > 1  order by NEECHAACE

select NEEEVENSU,count(*) from TBS0991BKP2 (nolock) group by NEEEVENSU having count(*) > 1

select * from TBS0991BKP2 (nolock) where NEEEVENSU in(10694,10725,10727)

drop table #DFE


select NEECHAACE as 'chave',(select min(NEENSU) from TBS0991BKP2 as B (nolock) where B.NEECHAACE=A.NEECHAACE) as 'NSU'
  into #DFE
  from TBS0991BKP2 as A (nolock) group by NEECHAACE having count(*) > 1

begin tran
insert into TBS0991 (NEEEMPCOD,NEECHAACE,NEEEVENSU,NEETIPEVE,NEEEVEDES,NEEEVESEQ,NEEEVEJUS,NEEDESCOR,NEEEVEDATHOR,NEEEVEPROTOC,NEECHACTE,NEETRANSP)
select NEEEMPCOD,NEECHAACE,NEEEVENSU,NEETIPEVE,NEEEVEDES,NEEEVESEQ,NEEEVEJUS,NEEDESCOR,NEEEVEDATHOR,NEEEVEPROTOC,NEECHACTE,NEETRANSP from TBS0991BKP2 (nolock)
 where not exists(select '' from TBS0991 (nolock) where TBS0991.NEECHAACE=TBS0991BKP2.NEECHAACE) and
       not exists(select '' from #DFE where chave=NEECHAACE and NSU=NEENSU)
commit tran

select top 1 * from TBS0991 (nolock)
select top 1 * from TBS0991BKP2 (nolock)
