--print convert(date,getdate(),112)

select Left(PROCLAFIS,2)
       ,PROCLAFIS
       ,PROCOD
       ,PRODES
       ,PROSTATUS
  from TBS010 with (nolock)
 where Left(PROCLAFIS,2) in('01','02','03','04','05','06','07','08','09','10','11','12','13','14')

