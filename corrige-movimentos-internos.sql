select MVIDOC from TBS037 (nolock)
 where (select count(*) from TBS0371 (nolock) where TBS0371.MVIDOC=TBS037.MVIDOC)=0
 order by MVIDOC desc

begin tran
delete TBS037
  from TBS037 (nolock)
 where (select count(*) from TBS0371 (nolock) where TBS0371.MVIDOC=TBS037.MVIDOC)=0
commit tran

select * from TBS037 (nolock) where MVIULTITE=0 order by MVIDOC desc

select * from TBS037 (nolock) where MVIULTITE<(select max(MVIITE) from TBS0371 (nolock) where TBS0371.MVIDOC=TBS037.MVIDOC)

begin tran
update TBS037 set MVIULTITE=(select max(MVIITE) from TBS0371 (nolock) where TBS0371.MVIDOC=TBS037.MVIDOC)
  from TBS037 (nolock)
 where MVIULTITE<(select max(MVIITE) from TBS0371 (nolock) where TBS0371.MVIDOC=TBS037.MVIDOC)
commit tran

select MVIDATLAN from TBS037 (nolock) where MVIDATEFE='17530101'

begin tran
update TBS037 set MVIDATEFE=MVIDATLAN where MVIDATEFE='17530101'
commit tran

