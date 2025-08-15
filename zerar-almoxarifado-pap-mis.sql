select * from TBS034 (nolock)

-- almoxarifado da papelyna = 4
-- ...misaspel = 5

select * into ALMOXA030217 from TBS032 (nolock) where ESTLOC=4 and ESTQTDATU > 0

select max(LMEREG) from TBS051 (nolock)

select * from ALMOXA030217 (nolock) where ESTQTDCMP+ESTQTDRES+ESTQTDPEN > 0

declare @seq int

set @seq = (select max(LMEREG) from TBS051 (nolock))

begin tran
insert into TBS051
   (LMEEMPCOD,
    LMEREG,
    LMEDOC,
    LMEROT,
    LMEDESROT,
    LMEACA,
    LMEDATHOR,
    LMEUSU,
    LMEMOD,
    LMEINFALT,
    PROCOD,
    PROEMPCOD,
    LMEQTDSAL,
    LMEQTDMOV,
    LMEQTDATU,
    LMEQTDRES,
    LMEQTDPEN,
    LMEQTDCMP,
    LMEUNI,
    LMEQTDDIS,
    LMELOCEST)
(select 0,
        row_number() over(order by PROCOD)+@seq,
        0,
        'SQL',
        'ZERAR ESTOQUE',
        'S',
        getdate(),
        'DESENV',
        'NENHUM',
        'E',
        PROCOD,
        0,
        ESTQTDATU,
        ESTQTDATU,
        0,
        0,
        0,
        0,(select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=ALMOXA030217.PROCOD),
        0,
        ESTLOC
   from ALMOXA030217)
rollback tran
commit tran

select top 50 * from TBS051 (nolock) order by LMEREG desc

update TBS024 set TBSVALSEQ=(select max(LMEREG) from TBS051 (nolock)) where TBSNOM='TBS051'

begin tran
update TBS032 set ESTQTDATU=0 where ESTLOC=4 and ESTQTDATU > 0
commit tran


select * from TBS032 (nolock) where ESTLOC=4 and ESTQTDATU+ESTQTDCMP+ESTQTDRES+ESTQTDPEN > 0