insert into TBS001 select * from TANBY_ND.dbo.TBS001 (nolock)
select * from TBS001 (nolock)

insert into TBS018 select * from TANBY_ND.dbo.TBS018 (nolock)
select * from TBS018 (nolock)

insert into TBS0181 select * from TANBY_ND.dbo.TBS0181 (nolock)
select * from TBS0181 (nolock)

insert into TBS019 select * from TANBY_ND.dbo.TBS019 (nolock)
select * from TBS019 (nolock)

insert into TBS0191 select * from TANBY_ND.dbo.TBS0191 (nolock)
select * from TBS0191 (nolock)

insert into TBS020 select * from TANBY_ND.dbo.TBS020 (nolock)
select * from TBS020 (nolock)

insert into TBS021 select * from TANBY_ND.dbo.TBS021 (nolock)
select * from TBS021 (nolock)

insert into TBS024 select * from TANBY_ND.dbo.TBS024 (nolock)
select * from TBS024 (nolock)

update TBS024 set TBSVALSEQ = 0

insert into TBS0241 select * from TANBY_ND.dbo.TBS0241 (nolock)
select * from TBS0241 (nolock)

insert into TBS0242 select * from TANBY_ND.dbo.TBS0242 (nolock)
select * from TBS0242 (nolock)

insert into TBS025 select * from TANBY_ND.dbo.TBS025 (nolock)
select * from TBS025 (nolock)

delete TBS025 where PARCHV = 0

insert into TBS003 select * from TANBY_ND.dbo.TBS003 (nolock)
select * from TBS003 (nolock)

insert into TBS039 select *,0 from TANBY_ND.dbo.TBS039 (nolock)
select * from TBS039 (nolock)
select top 1 * from TANBY_ND.dbo.TBS039 (nolock)

insert into TBS040 select * from TANBY_ND.dbo.TBS040 (nolock)
select * from TBS040 (nolock)

insert into TBS041 select * from TANBY_ND.dbo.TBS041 (nolock)
select * from TBS041 (nolock)

insert into TBS071 select * from TANBY_ND.dbo.TBS071 (nolock)
select * from TBS071 (nolock)

delete TBS071 where PAICOD <> 1058

insert into TBS040 select * from TANBY_ND.dbo.TBS040 (nolock)
select * from TBS040 (nolock)

select * from TBS104 (nolock)
