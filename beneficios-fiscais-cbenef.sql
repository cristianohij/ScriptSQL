-- cBenef

select p.PROSTBB
       ,count(*)
  from TBS010 p with (nolock)
 where p.PROSTBB in('20','40','41')
 group by p.PROSTBB

select distinct
       Left(Ltrim(p.PRODES),20)
       ,p.PROSTBB
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PROSTBB in('20','40','41')

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PROSTBB in('20','40','41')

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PROSTBB in('20','40','41')
       and p.PRODES Like '%MILHO%'

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PRODES Like '%COURO%'


