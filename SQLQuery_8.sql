select top(100) *
  from TBS057 with (nolock)

drop table TBS057_BKP_2

select *
  into TBS057_BKP_2
  from TBS057 with (nolock)
 where CPADATBAI='17530101'
       and CPADATEMI >= '20240101'
       and PORCOD > 0
       --and CPAFORNOM not Like('BEST BAG%')
       --and CPAFORNOM not Like('MISASPEL%')
       --and CPAFORNOM not Like('TANBY%')
       --and CPAFORNOM not Like('WINPACK%')
       -- PORCOD=0

drop table TBS057_BKP

select FORCOD
       ,CPAFORNOM
       ,count(*) as 'registro'
  into TBS057_BKP       
  from TBS057 with (nolock)
 where CPADATBAI='17530101'
       and CPADATEMI >= '20240101'
       and PORCOD > 0
       --and CPAFORNOM not Like('BEST BAG%')
       --and CPAFORNOM not Like('MISASPEL%')
       --and CPAFORNOM not Like('TANBY%')
       --and CPAFORNOM not Like('WINPACK%')
 group by FORCOD, CPAFORNOM
 order by CPAFORNOM

select *
  from TBS057_BKP with (nolock)

SELECT 
    t.*
    ,STUFF((SELECT ', ' + Ltrim(str(p.PORCOD))
           FROM TBS057 p
 where CPADATBAI='17530101'
       and CPADATEMI >= '20240101'
       and CPAFORNOM not Like('BEST BAG%')
       and CPAFORNOM not Like('MISASPEL%')
       and CPAFORNOM not Like('TANBY%')
       and CPAFORNOM not Like('WINPACK%')
       and p.FORCOD=t.FORCOD
           FOR XML PATH('')), 1, 2, '') AS Compradores
FROM 
    TBS057_BKP t with (nolock)

begin tran
update TBS057
   set PORCOD=0
 where CPADATBAI='17530101'
       and CPADATEMI >= '20240101'
       and PORCOD > 0

rollback tran 
commit tran 

select FORPORCOD
       ,*
  from TBS006 with (nolock)
 where FORPORCOD > 0

begin tran
update TBS006
   set FORPORCOD=0
 where FORPORCOD > 0

rollback tran
commit tran






