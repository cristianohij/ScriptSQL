select *
  from TBS134 with (nolock)

select MVIID
       ,*
  from TBS037 with (nolock)
 where MVIID in(select LCKID 
                  from TBS134 with (nolock))
