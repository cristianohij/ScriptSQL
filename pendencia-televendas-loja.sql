select top 1
       convert(date,MVIDATLAN)
  from TBS037 with (nolock)

select convert(date,MVIDATLAN)
       ,count(*)
  from TBS037 with (nolock)
 where MVIDATLAN >= '20190301'
       and MVIPDVNUM > 0
 group by convert(date,MVIDATLAN),MVIPDVNUM

select count(*)
  from TBS037 with (nolock)
 where MVIDATLAN = '20190729'
       and MVIPDVNUM > 0
 group by MVIPDVNUM

select top 1
       *
  from TBS037 with (nolock)
 where TMVCOD=3
 order by MVIDATLAN desc

select data
       ,count(*)
  from
  (
select convert(date,MVIDATLAN) as data
       ,MVIPDVNUM as pedido
       ,count(*) as conta
  from TBS037 with (nolock)
 where MVIDATLAN >= '20190301'
       and MVIPDVNUM > 0
       and TMVCOD=505
       and MVILOCORI=2
 group by convert(date,MVIDATLAN),MVIPDVNUM
  ) tab
group by convert(date,data)

select *
  from TBS025 with (nolock)
 where PARCHV in(1310,1311)

