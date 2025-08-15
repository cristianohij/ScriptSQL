select * from master..sysservers (nolock)

select * from TBS019 (nolock) where MNUNOM='NFCOMST'

select * from TBS0191 (nolock) where MNUNOM='NFCOMST'

insert into py.SIBD.dbo.TBS019 select * from TBS019 (nolock) where MNUNOM='NFCOMST'

update py.SIBD.dbo.TBS019 set MNUDATCAD=convert(date,getdate()) where MNUNOM='NFCOMST'

select convert(date,getdate())

insert into py.SIBD.dbo.TBS0191 select * from TBS0191 (nolock) where MNUNOM='NFCOMST'

select count(*) from TBS092 (nolock)

select count(*) from tt.SIBD.dbo.TBS092 (nolock)

select * from TBS0921 (nolock) where NCMMVA > 0

--update mi.SIBD.dbo.TBS0921 set NCMMVA=T.NCMMVA
--  from mi.SIBD.dbo.TBS0921 as M right join  TBS0921 as T on T.NCMCOD=M.NCMCOD
-- where T.NCMMVA > 0

select count(*) from tt.SIBD.dbo.TBS0921 (nolock)

delete tt.SIBD.dbo.TBS0921 

insert into tt.SIBD.dbo.TBS0921 select * from TBS0921 (nolock)


select * from TBS0165 (nolock) where SBDSER='192.168.10.7'


select * from TBS0672 (nolock) where NFSNUM=173940

select * from TBS0671 (nolock) where NFSNUM=173940

select * from TBS0551 (nolock) where PDVNUM=356572

-- regras do icms

select * from TBS110 (nolock)
select * from TBS1101 (nolock)

select * from mi.SIBD.dbo.TBS110 (nolock)
select * from mi.SIBD.dbo.TBS1101 (nolock)

insert into mi.SIBD.dbo.TBS110 select * from TBS110 (nolock)
insert into mi.SIBD.dbo.TBS1101 select * from TBS1101 (nolock)