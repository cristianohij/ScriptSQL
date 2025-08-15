select top 1 * from TBS099 (nolock)

select top 1 * from TBS080 (nolock)

select top 1 * from TBS023 (nolock)

-- CD x ND
select TBS099.*
--       into TBS099BKPCD
  from TBS099 (nolock)
       inner join tanbyCD.SIBD.dbo.TBS080 on ENFCHAACE collate database_default=NEECHAACE,
       TBS023 (nolock)
 where ENFCNPJCPF collate database_default <> EMPCGC
 order by NEENSU desc 

begin tran
delete TBS099
  from TBS099 (nolock)
       inner join cd.SIBD.dbo.TBS080 on ENFCHAACE collate database_default=NEECHAACE,
       TBS023 (nolock)
 where ENFCNPJCPF collate database_default <> EMPCGC
rollback tran
commit tran

drop table TBS099BKPCD

select * from TBS099BKPCD (nolock)

-- TTE x ND
select TBS099.*
--       into TBS099BKPCD
  from TBS099 (nolock)
       inner join tanbyTte.SIBD.dbo.TBS080 on ENFCHAACE collate database_default=NEECHAACE,
       TBS023 (nolock)
 where ENFCNPJCPF collate database_default <> EMPCGC
 order by NEENSU desc 

select * from master..sysservers

select * from cd.SIBD.dbo.TBS001 (nolock)

select * from TBS088 (nolock)

select * into TBS0991BKPCD from TBS0991 (nolock) where not exists(select '' from TBS099 (nolock) where TBS099.NEECHAACE=TBS0991.NEECHAACE)

begin tran
delete TBS0991 from TBS0991 (nolock) where not exists(select '' from TBS099 (nolock) where TBS099.NEECHAACE=TBS0991.NEECHAACE)
commit tran

select count(*) from TBS099 (nolock)


if exists(select name from sysobjects where name='SP_ELIMINA_DFE' and type='P')
   drop procedure SP_ELIMINA_DFE
go

create procedure SP_ELIMINA_DFE
as
begin
   -- NF-E emitida pelo CD para tanby Taubaté
   delete TBS099
     from TBS099 (nolock)
          inner join cd.SIBD.dbo.TBS080 on ENFCHAACE collate database_default=NEECHAACE,
          TBS023 (nolock)
    where ENFCNPJCPF collate database_default <> EMPCGC

   -- NF-E emitida pela tanby Taubaté para tanby CD
   delete TBS099
     from TBS099 (nolock)
          inner join tt.SIBD.dbo.TBS080 on ENFCHAACE collate database_default=NEECHAACE,
          TBS023 (nolock)
    where ENFCNPJCPF collate database_default <> EMPCGC

   -- elimina os registros da tabela TBS0991 que não existem mais na TBS099
   delete SIBD.dbo.TBS0991 from TBS0991 (nolock) where not exists(select '' from SIBD.dbo.TBS099 (nolock) where TBS099.NEECHAACE=TBS0991.NEECHAACE)
end

declare @data datetime

exec SP_DATAATUAL @data output

select @data

select * from TBS011 (nolock)

begin tran
delete TBS011 where UNICOD='SX'
rollback tran

