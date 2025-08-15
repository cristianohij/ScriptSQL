select top 10 *
  from TBS0552 with (nolock)

select 
       PDVLBLDAT,count(*)
  from
  (
     select 
            --PDVLBLDAT,count(*)
            distinct TBS0552.*
       from TBS055 with (nolock)
            inner join TBS0551 with (nolock)
            on TBS0551.PDVNUM=TBS055.PDVNUM
            inner join TBS0552 with (nolock)
            on TBS0552.PDVNUM=TBS055.PDVNUM
      where PDVDATCAD between '20190717' and '20190717'
            and LESCOD=2
            and PDVLBLTIP='C'
            and PDVLBLACA='L'
      order by PDVLBLDAT
) tab
 group by PDVLBLDAT

select *
  from TBS0672 with (nolock)

select
       *
  from TBS067 with (nolock)
       inner join TBS0671 with (nolock)
       on TBS0671.SNESER=TBS067.SNESER
          and TBS0671.NFSNUM=TBS067.NFSNUM
       inner join TBS0672 with (nolock)
       on TBS0672.SNESER=TBS067.SNESER
          and TBS0672.NFSNUM=TBS067.NFSNUM
 where NFSDATEMI between '20190717' and '20190717'
       and TBS0671.LESCOD=2
