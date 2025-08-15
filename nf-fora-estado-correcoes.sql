select CLICOD,CLIINDIE,CLIIES from TBS002 (nolock)
 where CLICOD in(select NFSCLICOD from TBS067 (nolock) where NFSNUM in(96955))

select UFESIG,NFSICMSINTDES,NFSFINAQU,* from TBS067 (nolock) where NFSNUM in(96955)

-- se UF igual a RJ
begin tran
update TBS067 set NFSICMSINTDES=18 where NFSNUM in(90362)
commit tran

select NFSCST,NFSCFOP,NFSPERICMS,* from TBS0671 (nolock) where NFSNUM in(96955) order by NFSNUM,NFSITE

-- set CST inicial 1,2,3,8
select NFSCST,NFSCFOP,NFSPERICMS,* from TBS0671 (nolock) where NFSNUM in(90362) and subString(NFSCST,1,1) in('1','2','3','8') and NFSPERICMS > 0 order by NFSNUM,NFSITE

begin tran
update TBS0671 set NFSPERICMS=0 where NFSNUM in(90362) and subString(NFSCST,1,1) in('1','2','3','8') and NFSPERICMS > 0
rollback tran
commit tran

update TBS0671 set NFSPERICMS=4 where NFSNUM in(90362) and subString(NFSCST,1,1) in('1','2','3','8') and NFSPERICMS = 0

update TBS067 set NFSFINAQU='C' where NFSNUM in(90362)

select * from TBS0431 (nolock) where ORCNUM=196297 order by ORCITEM

select PROSTBA+PROSTBB,PROCOD,PROCLAFIS,PRODES from TBS010 (nolock) where PROCOD in('8490015','4340019')