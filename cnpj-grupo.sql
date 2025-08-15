--select * from master..sysservers

select 'Tanby matriz',EMPCGC from TBS023
union
select 'Tanby CD', EMPCGC collate database_default from cd.SIBD.dbo.TBS023
union
select 'Tanby Taubateé', EMPCGC from tt.SIBD.dbo.TBS023
union
select 'Best Arts', EMPCGC from bo.SIBD.dbo.TBS023
union
select 'Best Bag', EMPCGC from bb.SIBD2.dbo.TBS023
union
select 'Misaspel', EMPCGC from mi.SIBD.dbo.TBS023
union
select 'Papelyna', EMPCGC from py.SIBD.dbo.TBS023


