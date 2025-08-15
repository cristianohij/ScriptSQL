select *
  from TBS134 with (nolock)
 where LCKUSU='DESENV'
 
select *
  from TBS116 with (nolock)
 where MUSHOST='PPL-CMP07'
       and MUSDATLOGIN='20190919'
	   
select *
  from TBS134DELETADOS with (nolock)
 where convert(date,LCKDATDEL)='20190919'
       and LCKUSU='LIGIA'

select PDCID
       ,PDCHORCAD
	   ,PDCHORALT
       ,*
  from TBS045 with (nolock)
 where PDCID in(select LCKID
                  from TBS134DELETADOS with (nolock)
                 where convert(date,LCKDATDEL)='20190919'
                       and LCKUSU='LIGIA')
