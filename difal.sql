select * from TBS067 with (nolock) where NFSNUM=227630
select * from TBS0671 with (nolock) where NFSNUM=227630

select dbo.NFSVALICMSSTRET(0,227630,0,1,1)
select dbo.NFSVALICMSSTRET(0,227630,0,1,2)
select dbo.NFSVALICMSSTRET(0,227630,0,1,3)

select ENFESTDES from TBS080 with (nolock) group by ENFESTDES