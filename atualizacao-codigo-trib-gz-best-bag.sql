select * from master..sysservers

select a.PROCOD,a.PROSTBB,a.TGZCOD,b.PROCOD,b.PROSTBB,b.TGZCOD
  from TBS010 a (nolock) inner join bb.SIBD2.dbo.TBS010 b (nolock) on a.PROCOD=b.PROCOD
 where a.TGZCOD > 0 and a.TGZCOD<>b.TGZCOD

select a.PROCOD,a.TGZCOD,b.PROCOD,b.TGZCOD
  from TBS010 a (nolock) inner join bb.SIBD2.dbo.TBS010 b (nolock) on a.PROCOD=b.PROCOD
 where a.TGZCOD > 0 and b.TGZCOD=0

-- erro abaixo
begin tran
update bb.SIBD2.dbo.TBS010 set TGZCOD=a.TGZCOD
  from TBS010 a (nolock) inner join bb.SIBD2.dbo.TBS010 b (nolock) on a.PROCOD=b.PROCOD
 where a.TGZCOD > 0 and b.TGZCOD=0

begin tran
update bb.SIBD2.dbo.TBS010 set TGZCOD=5 where PROCOD in('4520480','6500003','7160012') and TGZCOD=0


-- logado na best bag

select a.PROCOD,a.PROSTBB,a.TGZCOD,b.PROCOD,b.PROSTBB,b.TGZCOD
  from TBS010 a (nolock) inner join py.SIBD.dbo.TBS010 b (nolock) on a.PROCOD=b.PROCOD
 where a.TGZCOD > 0 and a.TGZCOD<>b.TGZCOD

select a.PROCOD,a.PROSTBA,a.PROSTBB,a.PRODES,b.PROSTBA,b.PROSTBB,b.PRODES
  from TBS010 a (nolock) inner join py.SIBD.dbo.TBS010 b (nolock) on a.PROCOD=b.PROCOD
 where a.PROSTBA<>b.PROSTBA or a.PROSTBB<>b.PROSTBB

-- papelyna - misaspel
select a.PROCOD,a.PROSTBA,a.PROSTBB,a.PRODES,a.PROSTATUS,b.PROSTBA,b.PROSTBB,b.PRODES,b.PROSTATUS
  from TBS010 a (nolock) inner join mi.SIBD.dbo.TBS010 b (nolock) on a.PROCOD=b.PROCOD
 where (a.PROSTBA<>b.PROSTBA or a.PROSTBB<>b.PROSTBB) and a.PROSTATUS='A' and b.PROSTATUS='A'

-- best bag - papelyna
select a.PROCOD,a.PROSTBA,a.PROSTBB,a.PRODES,a.PROSTATUS,b.PROSTBA,b.PROSTBB,b.PRODES,b.PROSTATUS
  from TBS010 a (nolock) inner join py.SIBD.dbo.TBS010 b (nolock) on a.PROCOD=b.PROCOD
 where (a.PROSTBA<>b.PROSTBA or a.PROSTBB<>b.PROSTBB) and a.PROSTATUS='A' and b.PROSTATUS='A'
