select PRPDOCREA,* from TBS058 (noLock) where PRPDOCREA Like('03112008%')

select * from TBS0371 (noLock) where PROCOD='6590357' order by MVIDOC desc

select cast(MVIDATLAN as char),* from TBS037 (noLock) where MVIDOC=13229

select * from TBS037 (noLock)
 where cast(MVIDATLAN as char) Like('Nov%') and cast(MVIDATLAN as char) Like('%2008%') and TMVCOD < 500

select * from TBS0371 (noLock) 
 where exists (select 'ex' from TBS037 (noLock)
 where TBS037.MVIDOC=TBS0371.MVIDOC and cast(MVIDATLAN as char) Like('Nov%') and cast(MVIDATLAN as char) Like('%2008%') and TMVCOD < 500)


select distinct PROCOD,MVIPRODES,MVIPROUNI,sum(MVIQTDPED)
  from TBS0371 (noLock) join TBS037 (noLock) on TBS0371.MVIDOC=TBS037.MVIDOC 
 where cast(MVIDATLAN as char) Like('Nov%') and cast(MVIDATLAN as char) Like('%2008%') and TMVCOD < 500
 group by PROCOD,MVIPRODES,MVIPROUNI
 order by MVIPRODES



select cast(MVIDATLAN as char) from TBS037 (noLock)