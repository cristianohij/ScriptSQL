select * from TBS080 (nolock) where ENFNUM in(160232,160233)
select * from TBS0801 (nolock) where ENFNUM in(160232,160233) order by ENFNUM,ENFDATHOR desc
select * from TBS067 (nolock) where NFSNUM in(160232,160233)
select * from TBS008 (nolock) where CPGCOD in(7,8)

select * from TBS067 (nolock) where NFSNUM=160241

begin tran
update TBS067 set NFSENDCOBCOD=0,NFSENDENTCOD=0 where NFSNUM=160241
commit tran

select *
  from TBS055 (nolock)
 where dbo.PDVTOTLIQ(PDVEMPCOD,PDVNUM) > dbo.PDVTOTFAT(PDVEMPCOD,PDVNUM) and dbo.PDVTOTFAT(PDVEMPCOD,PDVNUM) > 0


select PRPNUM
  from TBS058 (nolock) inner join TBS055 on TBS055.PDVNUM=TBS058.PRPNUM
 group by PRPNUM

-- lista os erros

-- pedidos de vendas

select PDVNUM,PDVENDENTCOD,PDVENDCOBCOD
  from TBS055 (nolock)
 where PDVNUM in(select PRPNUM
                   from TBS058 (nolock) inner join TBS055 on TBS055.PDVNUM=TBS058.PRPNUM
                  group by PRPNUM) and
       (PDVENDENTCOD > 0 or PDVENDCOBCOD > 0) and
       not exists(select '' from TBS0021 (nolock)
                   where CLICOD=PDVCLICOD and ((CLIENDCOD=PDVENDENTCOD and CLIENDTIP='E') or (CLIENDCOD=PDVENDCOBCOD and CLIENDTIP='C')))

-- orçamentos

select ORCNUM,ORCENDENTCOD,ORCENDCOBCOD
  from TBS043 (nolock)
 where (ORCENDENTCOD > 0 or ORCENDCOBCOD > 0) and
       not exists(select '' from TBS0021 (nolock)
                   where CLICOD=ORCCLI and ((CLIENDCOD=ORCENDENTCOD and CLIENDTIP='E') or (CLIENDCOD=ORCENDCOBCOD and CLIENDTIP='C')))

-- corrige endereços de entregas

-- pedidos de vendas

begin tran
update TBS055 set PDVENDENTCOD=0
  from TBS055 (nolock)
 where PDVNUM in(select PRPNUM
                   from TBS058 (nolock) inner join TBS055 on TBS055.PDVNUM=TBS058.PRPNUM
                  group by PRPNUM) and
       PDVENDENTCOD > 0 and
       not exists(select '' from TBS0021 (nolock)
                   where CLICOD=PDVCLICOD and CLIENDCOD=PDVENDENTCOD and CLIENDTIP='E')
commit tran

-- orçamentos

begin tran
update TBS043 set ORCENDENTCOD=0
  from TBS043 (nolock)
 where ORCENDENTCOD > 0 and
       not exists(select '' from TBS0021 (nolock)
                   where CLICOD=ORCCLI and CLIENDCOD=ORCENDENTCOD and CLIENDTIP='E')
commit tran

-- corrige endereços de cobranças

begin tran
update TBS055 set PDVENDCOBCOD=0
--select PDVNUM,PDVENDENTCOD,PDVENDCOBCOD
  from TBS055 (nolock)
 where PDVNUM in(select PRPNUM
                   from TBS058 (nolock) inner join TBS055 on TBS055.PDVNUM=TBS058.PRPNUM
                  group by PRPNUM) and
       PDVENDCOBCOD > 0 and
       not exists(select '' from TBS0021 (nolock)
                   where CLICOD=PDVCLICOD and CLIENDCOD=PDVENDCOBCOD and CLIENDTIP='C')
commit tran

-- orçamentos

begin tran
update TBS043 set ORCENDCOBCOD=0
  from TBS043 (nolock)
 where ORCENDCOBCOD > 0 and
       not exists(select '' from TBS0021 (nolock)
                   where CLICOD=ORCCLI and CLIENDCOD=ORCENDCOBCOD and CLIENDTIP='C')
commit tran