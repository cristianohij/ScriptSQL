select * from TBS049 (nolock) where LESCOD=1 order by MDSLAN desc

select * from TBS049 (nolock) order by MDSREG desc

delete TBS049 

select * from TBS024 (nolock) where TBSNOM='TBS049'

begin tran
update TBS024 set TBSVALSEQ=isnull((select max(MDSREG) from TBS049 (nolock)),0) where TBSNOM='TBS049'
rollback tran
commit 


select top 1 * from TBS049 (nolock) --where MDSQTDEMB > 0

select top 1 * from TBS032 (nolock) where ESTLOC=1

select * from TBS024 (nolock) where TBSNOM='TBS049'

-- zera os saldos em estoque

select * from TBS032 (nolock) where ESTLOC=9 and ESTQTDRES+ESTQTDPEN <> 0

select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDRES+ESTQTDPEN <> 0

select * from TBS032 (nolock) where ESTLOC=2 and ESTQTDPEN <> 0

select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU-ESTQTDRES <> 0

select * from TBS032 (nolock) where ESTLOC=2 and ESTQTDRES <> 0

select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDPEN <> 0

select * from TBS032 (nolock) where ESTLOC=2 and ESTQTDATU <> 0


select * from TBS024 with (nolock) where TBSNOM='' from TBS051 (nolock)

---

select max(LMEREG) from TBS051 (nolock)

select max(LMEREG),max(LMEREG)+101 from TBS051 (nolock)

update TBS024 set TBSVALSEQ=(select max(LMEREG)+101 from TBS051 (nolock)) where TBSNOM='TBS051'

declare @tipoMov char(1), @obs varchar(254), @estoque smallint, @usuario varchar(25),@seq int, @seqLog int

set @tipoMov='S'
set @obs='SALDO ZERADO P/INVENTARIO - RUA 16'
--set @obs='SALDO ZERADO - JULIANA'
set @estoque=1
set @usuario='INTEGROS'

select @seq = TBSVALSEQ from TBS024 (nolock) where TBSNOM='TBS049'
set @seqLog = 5610480

insert into TBS049 (MDSREG,MDSTIP,MDSLAN,PROCOD,MDSPRODES,MDSUNI,MDSQTDEMB,MDSQTD,MDSOBS,LESCOD,MDSUSU,LOG51)

select @seq + row_number() over (order by TBS032.PROCOD) MDSREG,
       @tipoMov MDSTIP,
       getdate() MDSLAN,
       TBS032.PROCOD PROCOD,
       TBS010.PRODES MDSPRODES,
       TBS010.PROUM1 MDSUNI,
       1 MDSQTDEMB,
       TBS032.ESTQTDATU-TBS032.ESTQTDRES MDSQTD,
       @obs MDSOBS,
       @estoque LESCOD,
       @usuario MDSUSU,
       @seqLog + row_number() over (order by TBS032.PROCOD) LOG51
  from TBS032 (nolock)
       inner join TBS010 (nolock) on TBS010.PROEMPCOD=TBS032.PROEMPCOD and TBS010.PROCOD=TBS032.PROCOD
 where ESTLOC=@estoque
       and ESTQTDATU-ESTQTDRES > 0
       and Left(PROLOCFIS,2) in('16')
--       and TBS010.MARCOD in(1796,153,1797,1114,1883,366,2222)
--       and TBS010.MARCOD in(1116,174,832,376,1857,926,528,681,1709,11,394)
--       and TBS010.MARCOD in(1314,405)
--         and TBS010.MARCOD in(648,1707,1655,1892,1813,2226,2221,2223,2228,2227,1117,1390,1357,1698,1143)
--       and TBS010.MARCOD in(1301,788,730,2225,2220,357,1536,1893,1120,1891,1648,690,452,172,2440)
--       and TBS010.MARCOD in(6,482,21,1582,1535,1605)
--       and TBS010.MARCOD in(880)
--       and TBS010.MARCOD in(849,1384,1133,45,1653,642)
--       and PROSETLOJ1='A01'
--       and TBS010.MARCOD in(26)

update TBS024 set TBSVALSEQ=(select max(MDSREG) from TBS049 (nolock)) where TBSNOM='TBS049'

select * from TBS049 with (nolock)
 where MDSTIP='S' and MDSOBS='SALDO ZERADO P/INVENTARIO - RUA 28' and MDSUSU='INTEGROS' and convert(date,MDSLAN,112)='20190403' --and LOG51 >= 1290489
order by LOG51

begin tran
delete TBS049 where MDSTIP='S' and MDSOBS='SALDO ZERADO PARA CONTAGEM' and MDSUSU='INTEGROS' and convert(date,MDSLAN,112)='20180521'

rollback tran
commit tran


where MDSTIP='S' and MDSOBS='SALDO ZERADO PARA CONTAGEM - RUA 03' and MDSUSU='INTEGROS' and convert(date,MDSLAN,112)='20180430'

---


-- saldos negativos de loja

select max(LMEREG) from TBS051 (nolock)

select max(LMEREG),max(LMEREG)+86 from TBS051 (nolock)

update TBS024 set TBSVALSEQ=(select max(LMEREG)+86 from TBS051 (nolock)) where TBSNOM='TBS051'


declare @tipoMov char(1), @obs varchar(254), @estoque smallint, @usuario varchar(25),@seq int, @seqLog int

set @tipOMov='E'
set @obs='SALDO ZERADO PARA INVENTARIO'
--set @obs='SALDO ZERADO - JULIANA'
set @estoque=2
set @usuario='INTEGROS'

select @seq = TBSVALSEQ from TBS024 (nolock) where TBSNOM='TBS049'
set @seqLog = 5416596

insert into TBS049 (MDSREG,MDSTIP,MDSLAN,PROCOD,MDSPRODES,MDSUNI,MDSQTDEMB,MDSQTD,MDSOBS,LESCOD,MDSUSU,LOG51)

select @seq + row_number() over (order by TBS032.PROCOD) MDSREG,
       @tipoMov MDSTIP,
       getdate() MDSLAN,
       TBS032.PROCOD PROCOD,
       TBS010.PRODES MDSPRODES,
       TBS010.PROUM1 MDSUNI,
       1 MDSQTDEMB,
       (TBS032.ESTQTDATU-TBS032.ESTQTDRES) * -1 MDSQTD,
       @obs MDSOBS,
       @estoque LESCOD,
       @usuario MDSUSU,
       @seqLog + row_number() over (order by TBS032.PROCOD) LOG51
  from TBS032 (nolock)
       inner join TBS010 (nolock) on TBS010.PROEMPCOD=TBS032.PROEMPCOD and TBS010.PROCOD=TBS032.PROCOD
 where ESTLOC=@estoque and ESTQTDATU-ESTQTDRES < 0
--       and TBS010.MARCOD in(1796,153,1797,1114,1883,366,2222)
--       and TBS010.MARCOD in(1116,174,832,376,1857,926,528,681,1709,11,394)
--       and TBS010.MARCOD in(1314,405)
--         and TBS010.MARCOD in(648,1707,1655,1892,1813,2226,2221,2223,2228,2227,1117,1390,1357,1698,1143)
--       and TBS010.MARCOD in(1301,788,730,2225,2220,357,1536,1893,1120,1891,1648,690,452,172,2440)
--       and TBS010.MARCOD in(880)
--       and TBS010.MARCOD in(849,1384,1133,45,1653,642)
--       and TBS010.MARCOD in(26)
       and PROSETLOJ1='A01'

update TBS024 set TBSVALSEQ=(select max(MDSREG) from TBS049 (nolock)) where TBSNOM='TBS049'

select * from TBS049 with (nolock) where MDSTIP='E' and MDSOBS='SALDO ZERADO PARA CONTAGEM' and MDSUSU='INTEGROS' and convert(date,MDSLAN,112)='20180522' and LOG51 >= 1290863

select * from TBS049 (nolock) order by MDSREG desc

select * from TBS049 (nolock) order by PROCOD

-- atualiza a sequência numérica

begin tran
update TBS024 set TBSVALSEQ=(select max(MDSREG) from TBS049 (nolock)) where TBSNOM='TBS049'
rollback
commit

--select count(*) from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU-ESTQTDRES > 0

--select count(*) from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU-ESTQTDRES < 0


-- gera Log da operação

declare @seq int, @usuario varchar(25), @estoque smallint

select @seq = max(LMEREG) from TBS051 (nolock)

set @estoque=1
set @usuario='INTEGROS'

begin tran
insert into TBS051
   (LMEEMPCOD,
    LMEREG,
    LMEDOC,
    LMEROT,
    LMEDESROT,

    LMEACA, -- entrada/saída

    LMEDATHOR,
    LMEUSU,
    LMEMOD,

    LMEINFALT, -- informação alterada

    PROCOD,
    PROEMPCOD,

    LMEQTDSAL,
    LMEQTDMOV,

    LMEQTDATU, -- quantidade atual

    LMEQTDRES,
    LMEQTDPEN,
    LMEQTDCMP,

    LMEUNI, -- unidade de medida

    LMEQTDDIS, -- quantidade disponível

    LMELOCEST)
(select 0,
        --row_number() over(order by TBS049.PROCOD)+@seq,
        LOG51,
        MDSREG,
        'SQL',
        'SALDO ZERADO PARA INVENTARIO RUA 16',
--        'SALDO ZERADO: JULIANA',

        'S', -- entrada/saída

        getdate(),
        @usuario,
        '',

        'E', -- informação alterada

        TBS049.PROCOD,
        0,

        TBS032.ESTQTDATU-TBS049.MDSQTD,         -- saldo atual final
        TBS049.MDSQTD,    -- quantidade movimentada - entrada/saída

        TBS032.ESTQTDATU, -- quantidade atual

        TBS032.ESTQTDRES,
        TBS032.ESTQTDPEN,
        TBS032.ESTQTDCMP,

        TBS049.MDSUNI, -- unidade de medida

        0, -- quantidade disponível

        @estoque -- local estoque
   from TBS049 (nolock) inner join TBS032 (nolock) on ESTLOC=LESCOD and TBS032.PROCOD=TBS049.PROCOD
--  where MDSTIP='S' and MDSUSU=@usuario and LESCOD=@estoque and MDSOBS='SALDO ZERADO PARA CONTAGEM' and convert(date,MDSLAN,112)='20180522' and MDSUSU='INTEGROS' and LOG51 >= 1290489)
--  where MDSTIP='S' and MDSUSU=@usuario and LESCOD=@estoque and MDSOBS='SALDO ZERADO: JULIANA' and convert(date,MDSLAN,112)='20180522' and MDSUSU='INTEGROS')
--  where MDSTIP='S' and MDSUSU=@usuario and LESCOD=@estoque and MDSOBS='SALDO ZERADO PARA CONTAGEM RUA 8' and convert(date,MDSLAN,112)='20180529' and MDSUSU='INTEGROS')
--  where MDSTIP='S' and MDSUSU=@usuario and LESCOD=@estoque and MDSOBS='SALDO ZERADO - JULIANA' and convert(date,MDSLAN,112)='20180530' and MDSUSU='INTEGROS')
  where MDSTIP='S' and MDSUSU=@usuario and LESCOD=@estoque and MDSOBS='SALDO ZERADO P/INVENTARIO - RUA 16' and convert(date,MDSLAN,112)='20190405' and MDSUSU='INTEGROS')

rollback tran
commit tran

select * from TBS051
 where LMELOCEST=1 and LMEACA='S' and LMEUSU='INTEGROS' and LMEDESROT='SALDO ZERADO PARA CONTAGEM - RUA 29' and convert(date,LMEDATHOR)='20180925' --PROCOD='0041238'

begin tran
update TBS051 set LMEQTDSAL=LMEQTDATU-LMEQTDMOV
 where LMELOCEST=1 and LMEACA='S' and LMEUSU='INTEGROS' and LMEDESROT='SALDO ZERADO PARA CONTAGEM - RUA 03' and convert(date,LMEDATHOR)='20180430' --PROCOD='0041238'

rollback tran
commit tran


-- saldos negativos de loja

declare @seq int, @usuario varchar(25), @estoque smallint

select @seq = max(LMEREG) from TBS051 (nolock)

set @estoque=2
set @usuario='INTEGROS'

begin tran
insert into TBS051
   (LMEEMPCOD,
    LMEREG,
    LMEDOC,
    LMEROT,
    LMEDESROT,

    LMEACA, -- entrada/saída

    LMEDATHOR,
    LMEUSU,
    LMEMOD,

    LMEINFALT, -- informação alterada

    PROCOD,
    PROEMPCOD,

    LMEQTDSAL,
    LMEQTDMOV,

    LMEQTDATU, -- quantidade atual

    LMEQTDRES,
    LMEQTDPEN,
    LMEQTDCMP,

    LMEUNI, -- unidade de medida

    LMEQTDDIS, -- quantidade disponível

    LMELOCEST)
(select 0,
        row_number() over(order by TBS049.PROCOD)+@seq,
        MDSREG,
        'SQL',
        'SALDO ZERADO PARA INVENTARIO',

        'E', -- entrada/saída

        getdate(),
        @usuario,
        '',

        'E', -- informação alterada

        TBS049.PROCOD,
        0,

        0,         -- saldo atual final
        TBS049.MDSQTD,    -- quantidade movimentada - entrada/saída

        TBS032.ESTQTDATU, -- quantidade atual

        TBS032.ESTQTDRES,
        TBS032.ESTQTDPEN,
        TBS032.ESTQTDCMP,

        TBS049.MDSUNI, -- unidade de medida

        0, -- quantidade disponível

        @estoque -- local estoque
   from TBS049 (nolock) inner join TBS032 (nolock) on ESTLOC=LESCOD and TBS032.PROCOD=TBS049.PROCOD
--  where MDSTIP='E' and MDSUSU=@usuario and LESCOD=@estoque and MDSOBS='SALDO ZERADO PARA CONTAGEM' and convert(date,MDSLAN,112)='20180523' and MDSUSU='INTEGROS' and LOG51 >= 1290863)
--  where MDSTIP='E' and MDSUSU=@usuario and LESCOD=@estoque and MDSOBS='SALDO ZERADO PARA CONTAGEM' and convert(date,MDSLAN,112)='20180525' and MDSUSU='INTEGROS')
  where MDSTIP='E' and MDSUSU=@usuario and LESCOD=@estoque and MDSOBS='SALDO ZERADO PARA INVENTARIO' and convert(date,MDSLAN,112)='20181117' and MDSUSU='INTEGROS')

rollback tran
commit tran

select * from TBS049 with (nolock) where MDSTIP='E' and MDSOBS='SALDO ZERADO PARA CONTAGEM' and MDSUSU='INTEGROS' and convert(date,MDSLAN,112)='20180521'

select * from TBS051
 where LMELOCEST=1 and LMEACA='E' and LMEUSU='INTEGROS' and LMEDESROT='SALDO ZERADO PARA CONTAGEM' and convert(date,LMEDATHOR)='20180521'



select * from TBS051 (nolock) where LMELOCEST=2 and LMEUSU='INTEGROS' order by LMEDOC desc

-- atualiza a sequência numérica

begin tran
update TBS024 set TBSVALSEQ=(select max(LMEREG) from TBS051 (nolock)) where TBSNOM='TBS051'
rollback

-- zera os saldo da tabela

select *
  from TBS032 (nolock)
       inner join TBS010 with (nolock) on TBS010.PROCOD=TBS032.PROCOD
 where ESTLOC=1 and ESTQTDATU <> 0
--       and PROSETLOJ1='A01'
       and Left(PROLOCFIS,2) in('28')
--       and not exists(select ''
       and exists(select ''
                        from TBS049 with (nolock)
                       where MDSTIP='S' and MDSOBS='SALDO ZERADO P/INVENTARIO - RUA 28' and MDSUSU='INTEGROS' and convert(date,MDSLAN,112)='20190403'
                             and TBS049.PROCOD=TBS010.PROCOD)

select PROCOD,count(*)
  from TBS049 with (nolock)
 where MDSTIP='S' and MDSOBS='SALDO ZERADO PARA CONTAGEM - RUA 14' and MDSUSU='INTEGROS' and convert(date,MDSLAN,112)='20180910'
 group by PROCOD
having count(*) > 1

begin tran
update TBS032 set ESTQTDATU=ESTQTDATU-ESTQTDATU+ESTQTDRES
  from TBS032 (nolock)
       inner join TBS010 (nolock) on TBS010.PROEMPCOD=TBS032.PROEMPCOD and TBS010.PROCOD=TBS032.PROCOD
 where ESTLOC=1 and ESTQTDATU-ESTQTDRES <> 0
       and Left(PROLOCFIS,2) in('16')
--       and TBS010.MARCOD in(1796,153,1797,1114,1883,366,2222)
--       and TBS010.MARCOD in(1116,174,832,376,1857,926,528,681,1709,11,394)
--       and TBS010.MARCOD in(1314,405)
--         and TBS010.MARCOD in(648,1707,1655,1892,1813,2226,2221,2223,2228,2227,1117,1390,1357,1698,1143)
--       and TBS010.MARCOD in(1301,788,730,2225,2220,357,1536,1893,1120,1891,1648,690,452,172,2440)
--       and TBS010.MARCOD in(880)
--       and TBS010.MARCOD in(849,1384,1133,45,1653,642)
--       and TBS010.MARCOD in(26)
--       and PROSETLOJ1='A01'

rollback tran
commit tran

-- verifica quantidade reservada

select *
  from TBS032 (nolock)
       inner join TBS010 with (nolock) on TBS010.PROCOD=TBS032.PROCOD
 where ESTLOC=1
       and ESTQTDATU - ESTQTDRES > 0
       --and ESTQTDATU < ESTQTDRES
--       and PROSETLOJ1='A01'
       and Left(PROLOCFIS,2) in('13')
--       and not exists(select ''
       and exists(select ''
                        from TBS049 with (nolock)
                       where MDSTIP='S' and MDSOBS='SALDO ZERADO P/INVENTARIO - RUA 13' and MDSUSU='INTEGROS' and convert(date,MDSLAN,112)='20190329'
                             and TBS049.PROCOD=TBS010.PROCOD)


-- zerar loja

select * from TBS032 with (nolock) where ESTLOC=2 and ESTQTDRES <> 0

select * from TBS032 with (nolock) where ESTLOC=2 and ESTQTDPEN <> 0

begin tran
update TBS032 set ESTQTDATU=ESTQTDATU-ESTQTDATU+ESTQTDRES
  from TBS032 (nolock)
       inner join TBS010 (nolock) on TBS010.PROEMPCOD=TBS032.PROEMPCOD and TBS010.PROCOD=TBS032.PROCOD
 where ESTLOC=2 and ESTQTDATU <> 0
--       and Left(PROLOCFIS,2) in('19')
--       and TBS010.MARCOD in(1796,153,1797,1114,1883,366,2222)
--       and TBS010.MARCOD in(1116,174,832,376,1857,926,528,681,1709,11,394)
--       and TBS010.MARCOD in(1314,405)
--         and TBS010.MARCOD in(648,1707,1655,1892,1813,2226,2221,2223,2228,2227,1117,1390,1357,1698,1143)
--       and TBS010.MARCOD in(1301,788,730,2225,2220,357,1536,1893,1120,1891,1648,690,452,172,2440)
--       and TBS010.MARCOD in(880)
--       and TBS010.MARCOD in(849,1384,1133,45,1653,642)
--       and TBS010.MARCOD in(26)
--       and PROSETLOJ1='A01'

rollback tran
commit tran


select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDRES < 0 and ESTQTDATU-ESTQTDRES < 0

select count(*) from TBS032 (nolock) where ESTLOC=1 and ESTQTDRES > 0

select count(*) from TBS032 (nolock) where ESTLOC=2 and ESTQTDATU > 0

select * from produto where produtoQtde > 0

select *
  from TBS032 (nolock)
       inner join TBS010 (nolock) on TBS010.PROEMPCOD=TBS032.PROEMPCOD and TBS010.PROCOD=TBS032.PROCOD
 where ESTLOC=1 and Left(PROLOCFIS,2)='19'




-- lança os saldos em estoque

select max(LMEREG) from TBS051 (nolock)

select max(LMEREG),max(LMEREG)+65 from TBS051 (nolock)

update TBS024 set TBSVALSEQ=(select max(LMEREG)+65 from TBS051 (nolock)) where TBSNOM='TBS051'


alter table TBS049 add LOG51 int default 0 with values

alter table [TBS049] drop constraint [DF__TBS049__LOG__3DAF28AB]

alter table TBS049 drop column LOG

select * from TBS049 (nolock)

declare @tipoMov char(1), @obs varchar(254), @estoque smallint, @usuario varchar(25),@seq int, @seqLog int

set @tipOMov='E'
set @obs='LANCAMENTO DA CONTAGEM LOJA (3)'
set @estoque=2
set @usuario='INTEGROS'

select @seq = TBSVALSEQ from TBS024 (nolock) where TBSNOM='TBS049'
set @seqLog = 5437358

insert into TBS049 (MDSREG,MDSTIP,MDSLAN,PROCOD,MDSPRODES,MDSUNI,MDSQTDEMB,MDSQTD,MDSOBS,LESCOD,MDSUSU,LOG51)

select @seq + row_number() over (order by produtoCodigo) MDSREG,
       @tipoMov MDSTIP,
       getdate() MDSLAN,
       produtoCodigo PROCOD,
       TBS010.PRODES MDSPRODES,
       TBS010.PROUM1 MDSUNI,
       1 MDSQTDEMB,
       produtoQtde MDSQTD,
       @obs MDSOBS,
       @estoque ESTLOC,
       @usuario MDSUSU,
       @seqLog + row_number() over (order by produtoCodigo) LOG51
  from produto (nolock)
       inner join TBS010 (nolock) on TBS010.PROCOD=produtoCodigo collate database_default
 where produtoQtde > 0

update TBS024 set TBSVALSEQ=(select max(MDSREG) from TBS049 (nolock)) where TBSNOM='TBS049'


select * from TBS049 (nolock) order by MDSREG desc

select * from TBS049 (nolock) where convert(date,MDSLAN,112)='20180508' and LESCOD=1 and MDSUSU='INTEGROS'

begin tran
delete TBS049 where convert(date,MDSLAN,112)='20180508' and LESCOD=1 and MDSUSU='INTEGROS'
commit tran

begin tran
update TBS049 set MDSOBS='AJUSTE DA CONTAGEM' where convert(date,MDSLAN,112)='20171002' and LESCOD=2 and MDSUSU='INTEGROS'
commit tran

select * from produto where produtoCodigo='23530003'

select produtoCodigo,count(*) from produto group by produtoCodigo having count(*) > 1

select * from produto where produtoCodigo in(select produtoCodigo from produto group by produtoCodigo having count(*) > 1) order by produtoCodigo

-- atualiza a sequência numérica

begin tran
update TBS024 set TBSVALSEQ=(select max(MDSREG) from TBS049 (nolock)) where TBSNOM='TBS049'
rollback
commit

--update TBS024 set TBSVALSEQ=(select max(MDSREG) from TBS049 (nolock)) where TBSNOM='TBS049'


-- gera Log da operação

declare @seq int, @usuario varchar(25), @estoque smallint

select @seq = max(LMEREG) from TBS051 (nolock)

set @estoque=2
set @usuario='INTEGROS'

begin tran
insert into TBS051
   (LMEEMPCOD,
    LMEREG,
    LMEDOC,
    LMEROT,
    LMEDESROT,

    LMEACA, -- entrada/saída

    LMEDATHOR,
    LMEUSU,
    LMEMOD,

    LMEINFALT, -- informação alterada

    PROCOD,
    PROEMPCOD,

    LMEQTDSAL,
    LMEQTDMOV,

    LMEQTDATU, -- quantidade atual

    LMEQTDRES,
    LMEQTDPEN,
    LMEQTDCMP,

    LMEUNI, -- unidade de medida

    LMEQTDDIS, -- quantidade disponível

    LMELOCEST)
(select 0,
        --row_number() over(order by TBS049.PROCOD)+@seq,
        LOG51,
        MDSREG,
        'SQL',
        'ENTRADA INVENTARIO LOJA (3)',

        'E', -- entrada/saída

        getdate(),
        @usuario,
        '',

        'E', -- informação alterada

        TBS049.PROCOD,
        0,

        TBS032.ESTQTDATU+TBS049.MDSQTD,    -- saldo atual final
        TBS049.MDSQTD,    -- quantidade movimentada - entrada/saída

        TBS032.ESTQTDATU, -- quantidade atual

        TBS032.ESTQTDRES,
        TBS032.ESTQTDPEN,
        TBS032.ESTQTDCMP,

        TBS049.MDSUNI, -- unidade de medida

        TBS032.ESTQTDATU+TBS049.MDSQTD-TBS032.ESTQTDRES, -- quantidade disponível

        @estoque -- local estoque
   from TBS049 (nolock) inner join TBS032 (nolock) on ESTLOC=LESCOD and TBS032.PROCOD=TBS049.PROCOD
  where MDSTIP='E' and MDSUSU=@usuario and LESCOD=@estoque and MDSOBS='LANCAMENTO DA CONTAGEM LOJA (3)' and convert(date,MDSLAN,112)='20181119' and MDSUSU='INTEGROS') -- and LOG51 >= 1297409)

rollback tran
commit tran

update TBS024 set TBSVALSEQ=(select max(LMEREG) from TBS051 (nolock)) where TBSNOM='TBS051'


select * from TBS051 (nolock) where LMEACA='E' and LMELOCEST=1 and LMEUSU='INTEGROS' and LMEDESROT='ENTRADA INVENTARIO' and convert(date,LMEDATHOR,112)='20180521'

select * from TBS051 (nolock) where LMEACA='E' and LMELOCEST=2 and LMEUSU='INTEGROS' and LMEDESROT='AJUSTE INVENTARIO' and convert(date,LMEDATHOR,112)='20171002'

begin tran
update TBS051 set LMEQTDSAL=(select ESTQTDATU from TBS032 (nolock) where ESTLOC=LMELOCEST and TBS032.PROCOD=TBS051.PROCOD) 
where LMEACA='E' and LMELOCEST=2 and LMEUSU='INTEGROS' and LMEDESROT='AJUSTE INVENTARIO' and convert(date,LMEDATHOR,112)='20171002'
commit tran
rollback tran

begin tran
update TBS051 set LMEQTDATU=LMEQTDSAL-LMEQTDMOV
where LMEACA='E' and LMELOCEST=2 and LMEUSU='INTEGROS' and LMEDESROT='AJUSTE INVENTARIO' and convert(date,LMEDATHOR,112)='20171002'

begin tran
update TBS051 set LMEQTDMOV=(select sum(MDSQTD) from TBS049 (nolock)
         where MDSTIP='E' and MDSUSU='INTEGROS' and LESCOD=LMELOCEST and TBS049.PROCOD=TBS051.PROCOD
               and MDSOBS='AJUSTE DA CONTAGEM' and convert(date,MDSLAN,112)='20171002')
 where LMEACA='E' and LMELOCEST=2 and LMEUSU='INTEGROS' and LMEDESROT='AJUSTE INVENTARIO' and convert(date,LMEDATHOR,112)='20171002'

begin tran
update TBS051 set LMEQTDATU=0 where LMEQTDATU is null
commit tran


select * from TBS051 (nolock) where LMEACA='S' and LMELOCEST=2 and LMEUSU='INTEGROS' order by LMEDOC desc

select * from TBS051 (nolock) where LMEACA='E' and LMELOCEST=2 and LMEUSU='INTEGROS' order by LMEDOC desc

begin tran
delete TBS051 where LMEACA='E' and LMELOCEST=2 and LMEUSU='INTEGROS'

select count(*) from TBS051 (nolock) where LMEACA='S' and LMELOCEST=2 and LMEUSU='INTEGROS'

select count(*) from TBS051 (nolock) where LMEACA='E' and LMELOCEST=2 and LMEUSU='INTEGROS'


-- atualiza a sequência numérica

begin tran
update TBS024 set TBSVALSEQ=(select max(LMEREG) from TBS051 (nolock)) where TBSNOM='TBS051'
rollback

select max(LMEREG) from TBS051 (nolock)

select * from TBS024 (nolock) where TBSNOM='TBS051'


-- atualiza os saldos em estoque

select top 1 * from TBS049 (nolock)
select top 1 * from TBS032 (nolock)

begin tran
update TBS032 set ESTQTDATU=ESTQTDATU+
--select TBS032.PROCOD,ESTQTDATU,ESTQTDATU+
       (select sum(MDSQTD) from TBS049 (nolock)
         where MDSTIP='E' and MDSUSU='INTEGROS' and MDSOBS='LANCAMENTO DA CONTAGEM LOJA (3)' and convert(date,MDSLAN,112)='20181119' and LESCOD=ESTLOC and TBS049.PROCOD=TBS032.PROCOD)
               --and LOG51 >= 1297409)
  from TBS032 (nolock)
 where ESTLOC=2 and exists(select top 1 '' from TBS049 (nolock)
                            where TBS032.ESTLOC=TBS049.LESCOD and TBS032.PROCOD=TBS049.PROCOD and MDSTIP='E' and MDSUSU='INTEGROS' and
                                  MDSOBS='LANCAMENTO DA CONTAGEM LOJA (3)' and convert(date,MDSLAN,112)='20181119')
                                  --and LOG51 >= 1297409)

rollback tran
commit tran


-- ajsute

begin tran
update TBS032 set ESTQTDATU=ESTQTDATU+
--select ESTLOC,TBS032.PROCOD,ESTQTDATU,
       (select sum(MDSQTD) from TBS049 (nolock)
         where MDSTIP='E' and MDSUSU='INTEGROS' and LESCOD=ESTLOC and TBS049.PROCOD=TBS032.PROCOD
               and MDSOBS='AJUSTE DA CONTAGEM' and convert(date,MDSLAN,112)='20171002')
  from TBS032 (nolock)
 where ESTLOC=2 and exists(select top 1 '' from TBS049 (nolock)
                            where TBS049.LESCOD=TBS032.ESTLOC and TBS049.PROCOD=TBS032.PROCOD and MDSTIP='E' and MDSUSU='INTEGROS'
                                  and MDSOBS='AJUSTE DA CONTAGEM' and convert(date,MDSLAN,112)='20171002')
-- order by ESTQTDATU

rollback tran 
commit tran




select count(*) from produto where produtoQtde > 0 group by produtoCodigo


-- importa dados dos coletores

select * from produto

delete produto where produtoLote=5

select produtoQtde,floor(produtoQtde),round(produtoQtde-floor(produtoQtde),3),* from produto where produtoQtde-floor(produtoQtde) > 0 order by produtoCodigo

select produtoLote,count(*) from produto group by produtoLote order by produtoLote

select produtoCodigo,count(*) from produto group by produtoCodigo having count(*) > 1


-- relatórios

select * from TBS049 (nolock) where MDSTIP='S' and MDSUSU='INTEGROS'

select * from TBS049 (nolock) where MDSTIP='E' and MDSUSU='INTEGROS'

drop table #contagem

select PROCOD codigo,
       isnull((select sum(MDSQTD)
                 from TBS049 as B (nolock)
                where LESCOD=1 and MDSTIP='S' and convert(date,MDSLAN,112)='20181117' and MDSUSU='INTEGROS' and B.PROCOD=A.PROCOD and MDSOBS='SALDO ZERADO PARA INVENTARIO'),0) anterior,
                --where MDSTIP='S' and convert(date,MDSLAN,112) between '20180524' and '20180527' and MDSUSU='INTEGROS' and B.PROCOD=A.PROCOD and MDSOBS Like('SALDO ZERADO%')),0) anterior,
       isnull((select sum(MDSQTD)
                 from TBS049 as C (nolock)
                where LESCOD=1 and MDSTIP='E' and convert(date,MDSLAN,112) = '20181118' and MDSUSU='INTEGROS' and C.PROCOD=A.PROCOD and MDSOBS='LANCAMENTO DA CONTAGEM'),0) atual
                --where MDSTIP='E' and convert(date,MDSLAN,112) between '20180524' and '20180527' and MDSUSU='INTEGROS' and C.PROCOD=A.PROCOD
                      --and MDSOBS Like('LANCAMENTO DA CONTAGEM%')),0) atual
  into #contagem
  from TBS049 (nolock) as A
 where LESCOD=1 and convert(date,MDSLAN,112) >= '20181118' and MDSUSU='INTEGROS' and MDSTIP='E' and MDSOBS='LANCAMENTO DA CONTAGEM'
-- where convert(date,MDSLAN,112) between '20180524' and '20180527' and MDSUSU='INTEGROS' and MDSTIP='E' and MDSOBS Like('LANCAMENTO DA CONTAGEM%')

 group by PROCOD

-- inventário com duas contagens

select PROCOD codigo,
       isnull((select sum(MDSQTD)
                 from TBS049 as B (nolock)
                where MDSTIP='S' and convert(date,MDSLAN,112)>='20181109' and MDSUSU='INTEGROS' and B.PROCOD=A.PROCOD and MDSOBS='SALDO ZERADO P.CONTAGEM NUMERO 1'),0) anterior,
                --where MDSTIP='S' and convert(date,MDSLAN,112) between '20180524' and '20180527' and MDSUSU='INTEGROS' and B.PROCOD=A.PROCOD and MDSOBS Like('SALDO ZERADO%')),0) anterior,
       isnull((select sum(MDSQTD)
                 from TBS049 as C (nolock)
                where MDSTIP='E' and convert(date,MDSLAN,112) = '20181113' and MDSUSU='INTEGROS' and C.PROCOD=A.PROCOD and MDSOBS Like('LANCAMENTO DA CONTAGEM 10/11/18%')),0) atual
                --where MDSTIP='E' and convert(date,MDSLAN,112) between '20180524' and '20180527' and MDSUSU='INTEGROS' and C.PROCOD=A.PROCOD
                      --and MDSOBS Like('LANCAMENTO DA CONTAGEM%')),0) atual
  into #contagem
  from TBS049 (nolock) as A
 where convert(date,MDSLAN,112) = '20181113' and MDSUSU='INTEGROS' and MDSTIP='E' and MDSOBS Like('LANCAMENTO DA CONTAGEM 10/11/18%')
-- where convert(date,MDSLAN,112) between '20180524' and '20180527' and MDSUSU='INTEGROS' and MDSTIP='E' and MDSOBS Like('LANCAMENTO DA CONTAGEM%')

 group by PROCOD

--

select * from #contagem order by codigo

select codigo,
       (select PRODES from TBS010 (nolock) where PROCOD=codigo),
       (select MARNOM from TBS010 (nolock) where PROCOD=codigo),
--       (select MARNOM from TBS014 (nolock) inner join TBS010 (nolock) on TBS014.MARCOD=TBS010.MARCOD
--         where PROCOD=codigo),
       (select PROUM1 from TBS010 (nolock) where PROCOD=codigo),
       anterior,
       atual --,
--       isnull((select top 1 custo from nd.SIBD.dbo.CUSTOAQUISICAO where empresa='MS' and produto=codigo and ano<=2017 and mes<=7 order by ano desc, mes desc),0) mediaSP,
--       isnull((select top 1 custo from nd.SIBD.dbo.CUSTOAQUISICAO where empresa='MT' and produto=codigo and ano<=2017 and mes<=7 order by ano desc, mes desc),0) mediaTanby
  from #contagem

--where anterior=atual

select codigo,
       (select PRODES from TBS010 (nolock) where PROCOD=codigo) descricao,
       (select MARNOM from TBS010 (nolock) where PROCOD=codigo) marca,
       (select PROUM1 from TBS010 (nolock) where PROCOD=codigo) unidade,
       atual saldo,
       isnull((select top 1 custo from nd.SIBD.dbo.CUSTOAQUISICAO where empresa='MS' and produto=codigo and ano<=2017 and mes<=7 order by ano desc, mes desc),0) mediaSP,
       isnull((select top 1 custo from nd.SIBD.dbo.CUSTOAQUISICAO where empresa='MT' and produto=codigo and ano<=2017 and mes<=7 order by ano desc, mes desc),0) mediaTanby
  from #contagem where anterior=atual

select top 1 * from nd.SIBD.dbo.CUSTOAQUISICAO where empresa='MS'

-- compara com um dia específico

drop table #compara

select PROCOD codigo,
       isnull((select sum(MDSQTD) from TBS049 as B (nolock) where MDSTIP='S' and convert(date,MDSLAN,112)='20170826' and MDSUSU='INTEGROS' and B.PROCOD=A.PROCOD),0) anterior,
       isnull((select top 1 LMEQTDSAL from TBS051 as C (nolock) where LMEINFALT='E' and C.PROCOD=A.PROCOD and LMELOCEST=1 and convert(date,LMEDATHOR)<='20170930' order by LMEREG desc),0) atual
--  into #compara
  from TBS049 (nolock) as A
 where convert(date,MDSLAN,112)='20171001' and MDSUSU='INTEGROS'
 group by PROCOD


-- best bag loja, com saldos negativos

select PROCOD codigo,
       isnull((select sum(MDSQTD * case MDSTIP when 'E' then -1 else 1 end)
                 from TBS049 as B (nolock)
                where MDSOBS='SALDO ZERADO PARA CONTAGEM' and convert(date,MDSLAN,112)='20171001' and MDSUSU='INTEGROS' and B.PROCOD=A.PROCOD),0) anterior,
       isnull((select top 1 LMEQTDSAL from TBS051 as C (nolock) where LMEINFALT='E' and C.PROCOD=A.PROCOD and LMELOCEST=2 and convert(date,LMEDATHOR)<='20171001' order by LMEREG desc),0) atual
  into #compara
  from TBS049 (nolock) as A
 where convert(date,MDSLAN,112)='20171001' and MDSUSU='INTEGROS' and MDSTIP='E' and MDSOBS='LANCAMENTO DA CONTAGEM'
 group by PROCOD

select codigo,
       (select PRODES from TBS010 (nolock) where PROCOD=codigo),
       (select MARNOM from TBS010 (nolock) where PROCOD=codigo),
--       (select MARNOM from TBS014 (nolock) inner join TBS010 (nolock) on TBS014.MARCOD=TBS010.MARCOD
--         where PROCOD=codigo),
       (select PROUM1 from TBS010 (nolock) where PROCOD=codigo),
       anterior,
       atual --,
--       isnull((select top 1 custo from nd.SIBD.dbo.CUSTOAQUISICAO where empresa='MS' and produto=codigo and ano<=2017 and mes<=7 order by ano desc, mes desc),0) mediaSP,
--       isnull((select top 1 custo from nd.SIBD.dbo.CUSTOAQUISICAO where empresa='MT' and produto=codigo and ano<=2017 and mes<=7 order by ano desc, mes desc),0) mediaTanby
  from #compara

select PROCOD codigo,
       sum(MDSQTD) anterior,
       isnull((select top 1 LMEQTDSAL from TBS051 as B (nolock) where LMEINFALT='E' and B.PROCOD=A.PROCOD and LMELOCEST=1 and convert(date,LMEDATHOR)<='20170904' order by LMEREG desc),0) atual
  into #compara
  from TBS049 (nolock) as A
 where MDSTIP='S' and convert(date,MDSLAN,112)='20170826' and MDSUSU='INTEGROS'
 group by PROCOD

select * from #compara

select codigo,
       (select PRODES from TBS010 (nolock) where PROCOD=codigo),
       (select MARNOM from TBS010 (nolock) where PROCOD=codigo),
       (select PROUM1 from TBS010 (nolock) where PROCOD=codigo),
       anterior,
       atual 'saldo em 04/09'
  from #compara


--

select *
--begin tran
--update TBS051 set LMEQTDATU=LMEQTDMOV*-1
--update TBS051 set LMEQTDSAL=0
--update TBS051 set LMEDESROT='SALDO ZERADO PARA CONTAGEM'
  from TBS051 (nolock)
 where LMELOCEST=2 and LMEACA='E' and LMEUSU='INTEGROS' and LMEDESROT='ENTRADA INVENTARIO' and
       exists(select '' from TBS049 (nolock) where LESCOD=2 and MDSTIP='E' and MDSOBS='SALDO ZERADO PARA CONTAGEM' and MDSREG=LMEDOC and TBS049.PROCOD=TBS051.PROCOD)
 order by LMEDOC
commit tran

select *
  from TBS051 (nolock)
 where LMELOCEST=2 and LMEACA='E' and LMEUSU='INTEGROS' and LMEDESROT='SALDO ZERADO PARA CONTAGEM' and
       exists(select '' from TBS049 (nolock) where LESCOD=2 and MDSTIP='E' and MDSOBS='SALDO ZERADO PARA CONTAGEM' and MDSREG=LMEDOC and TBS049.PROCOD=TBS051.PROCOD)
 order by LMEDOC

-- saídas

select *
  from TBS051 (nolock)
 where LMELOCEST=1 and LMEACA='S' and LMEUSU='INTEGROS' and LMEDESROT='SALDO ZERADO PARA CONTAGEM'
       and LMEQTDRES > 0
 order by LMEDOC

-- entradas

select *
  from TBS051 (nolock)
 where LMELOCEST=1 and LMEACA='E' and LMEUSU='INTEGROS' and LMEDESROT='ENTRADA INVENTARIO'
--       and LMEQTDMOV=129
 order by LMEREG

select *,
       (select top 1 LMEQTDSAL
               from TBS051 B (nolock)
         where LMELOCEST=1 and LMEACA='E' and LMEUSU='INTEGROS' and LMEDESROT='ENTRADA INVENTARIO' and B.PROCOD=A.PROCOD and B.LMEREG < A.LMEREG
         order by LMEREG)
  from TBS051 A (nolock)
 where LMELOCEST=1 and LMEACA='E' and LMEUSU='INTEGROS' and LMEDESROT='ENTRADA INVENTARIO'
--       and LMEQTDMOV=129
 order by LMEREG

--gin tran
--date TBS051 set
select A.PROCOD,
--     LMEQTDATU=
       (select LMEQTDSAL from #ajuste C where C.PROCOD=A.PROCOD) QTDATU
       ,
--     LMEQTDSAL=
       A.LMEQTDMOV+(select LMEQTDSAL from #ajuste C where C.PROCOD=A.PROCOD) QTDSAL
       ,
--     LMEQTDDIS=
       A.LMEQTDMOV+(select LMEQTDSAL from #ajuste C where C.PROCOD=A.PROCOD)-A.LMEQTDRES
       ,*

  from TBS051 A (nolock)
 where LMELOCEST=1 and LMEACA='E' and LMEUSU='INTEGROS' and LMEDESROT='ENTRADA INVENTARIO'
--       and LMEQTDMOV=129
       and exists(select top 1 LMEQTDSAL
               from TBS051 B (nolock)
         where LMELOCEST=1 and LMEACA='E' and LMEUSU='INTEGROS' and LMEDESROT='ENTRADA INVENTARIO' and B.PROCOD=A.PROCOD and B.LMEREG < A.LMEREG
         order by LMEREG)
 order by LMEREG

drop table #ajuste2

select A.LMEREG,
       A.PROCOD,
       (select LMEQTDSAL from #ajuste C where C.PROCOD=A.PROCOD) LMEQTDATU,
       A.LMEQTDMOV+(select LMEQTDSAL from #ajuste C where C.PROCOD=A.PROCOD) LMEQTDSAL,
       A.LMEQTDMOV+(select LMEQTDSAL from #ajuste C where C.PROCOD=A.PROCOD)-A.LMEQTDRES LMEQTDDIS
  into #ajuste2
  from TBS051 A (nolock)
 where LMELOCEST=1 and LMEACA='E' and LMEUSU='INTEGROS' and LMEDESROT='ENTRADA INVENTARIO'
       and exists(select top 1 LMEQTDSAL
               from TBS051 B (nolock)
         where LMELOCEST=1 and LMEACA='E' and LMEUSU='INTEGROS' and LMEDESROT='ENTRADA INVENTARIO' and B.PROCOD=A.PROCOD and B.LMEREG < A.LMEREG
         order by LMEREG)
 order by A.LMEREG

select * from #ajuste2

begin tran
update TBS051 set LMEQTDATU=B.LMEQTDATU, LMEQTDSAL=B.LMEQTDSAL, LMEQTDDIS=B.LMEQTDDIS
--select *
from TBS051 A (nolock) inner join #ajuste2 B on A.LMEREG=B.LMEREG
commit tran

select LMEREG, PROCOD, LMEQTDSAL
  into #ajuste
  from TBS051 A (nolock)
 where LMELOCEST=1 and LMEACA='E' and LMEUSU='INTEGROS' and LMEDESROT='ENTRADA INVENTARIO'
--       and LMEQTDMOV=129
       and exists(select top 1 LMEQTDSAL
               from TBS051 B (nolock)
         where LMELOCEST=1 and LMEACA='E' and LMEUSU='INTEGROS' and LMEDESROT='ENTRADA INVENTARIO' and B.PROCOD=A.PROCOD and B.LMEREG > A.LMEREG
         order by LMEREG)
 order by LMEREG

select * from #ajuste

select *
  from TBS051 (nolock)
 where LMELOCEST=1 and LMEACA='E' and LMEUSU='INTEGROS' and LMEDESROT='ENTRADA INVENTARIO'
       and PROCOD='0040509'
 order by LMEREG

select top 1 * from TBS051 (nolock)


begin tran
update TBS051 set LMEQTDSAL=LMEQTDATU-LMEQTDMOV, LMEQTDDIS=LMEQTDATU-LMEQTDMOV-LMEQTDRES where LMELOCEST=1 and LMEACA='S' and LMEUSU='INTEGROS' and LMEDESROT='SALDO ZERADO PARA CONTAGEM'
rollback tran
commit tran



--

select *
  from TBS032 with (nolock)
       inner join TBS010 with (nolock)
       on TBS010.PROCOD=TBS032.PROCOD
 where ESTLOC=1
       --and ESTQTDATU-ESTQTDRES > 0
       --and ESTQTDATU <> 0
       and Left(PROLOCFIS,2) in('19') 

select *
  from TBS032 with (nolock)
       inner join TBS010 with (nolock)
       on TBS010.PROCOD=TBS032.PROCOD
 where ESTLOC=1
       and ESTQTDRES > 0
       --and ESTQTDATU <> 0
       and Left(PROLOCFIS,2) in('19') 

-- atualiza setor loja

select * from produto

select PROCOD,PROSETLOJ1
begin tran
update TBS010 set PROSETLOJ1='B01'
  from TBS010 with (nolock)
       inner join produto on produtoCodigo=PROCOD
commit tran

select * from TBS010 with (nolock) where PROSETLOJ1<>''

select PROSETLOJ1,count(*) from TBS010 with (nolock) where PROSETLOJ1<>'' group by PROSETLOJ1




begin tran
update TBS010 set PROSETLOJ1='A01'
--select TBS010.PROCOD,TBS010.PROSETLOJ1
  from produto with (nolock)
       inner join TBS010 with (nolock) on TBS010.PROCOD=produto.produtoCodigo
 where produtoQtde > 0
       and PROSETLOJ1=''       
commit tran

