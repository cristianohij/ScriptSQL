-- registra saldo atual antes de zerar

select * into TBS032_06052017_EST1 from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU <> 0   -- estoque retaguarda

select * into TBS032_06052017_EST2 from TBS032 (nolock) where ESTLOC=2 and ESTQTDATU <> 0   -- estoque loja

select * from TBS032_06052017_EST2 where ESTQTDATU <> 0

-- confere se existe reserva/pendência

select * from TBS032 (nolock) where ESTLOC in(1,2) and ESTQTDRES <> 0 or ESTQTDPEN <> 0

-- zera estoque

declare @seq int, @data as char(18), @estoque as smallint

set @seq = (select max(LMEREG) from TBS051 (nolock))

set @data = convert(char(8),getdate(),112)

set @estoque = 2

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

    LMEQTDSAL, -- saldo atual - após movimentação
    LMEQTDMOV, -- quantidade movimentada

    LMEQTDATU, -- quantidade atual - antes da movimentação

    LMEQTDRES,
    LMEQTDPEN,
    LMEQTDCMP,

    LMEUNI, -- unidade de medida

    LMEQTDDIS, -- quantidade disponível - antes da movimentação

    LMELOCEST)
(select 0,
        row_number() over(order by PROCOD)+@seq,
        0,
        'SQL',
        'ZERAR ESTOQUE',

        'S', -- entrada/saída

        @data,
        'DESENV',
        'NENHUM',

        'E', -- informação alterada

        PROCOD,
        0,

        0,         -- saldo atual - após movimentação
        ESTQTDATU, -- quantidade movimentada - entrada/saída

        ESTQTDATU, -- quantidade atual - antes da movimentação

        ESTQTDRES,
        ESTQTDPEN,
        ESTQTDCMP,

        (select PROUM1 from TBS010 (nolock) where PROCOD=TBS032.PROCOD), -- unidade de medida

        0, -- quantidade disponível

        @estoque
   from TBS032 (nolock) where ESTLOC=@estoque and ESTQTDATU <> 0)

select * from TBS051 (nolock) where LMEDATHOR='20170507'

rollback tran
commit tran

-- atualiza sequêncial dos registros criados

update TBS024 set TBSVALSEQ=(select max(LMEREG) from TBS051 (nolock)) where TBSNOM='TBS051'

-- retaguarda

select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU <> 0

begin tran
update TBS032 set ESTQTDATU=0 where ESTLOC=1 and ESTQTDATU <> 0
commit tran

select * from TBS032 (nolock) where ESTLOC=1 and (ESTQTDRES > 0 or ESTQTDPEN > 0)

-- loja

select * from TBS032 (nolock) where ESTLOC=2 and ESTQTDATU <> 0

begin tran
update TBS032 set ESTQTDATU=0 where ESTLOC=2 and ESTQTDATU <> 0
commit tran

select * from TBS032 (nolock) where ESTLOC=2 and (ESTQTDRES > 0 or ESTQTDPEN > 0 or ESTQTDCMP > 0)


-- atualiza estoque com os dados do coletor - lê tabela produto 

select count(*) from produto

select count(*) from produto group by produtoCodigo

select produtoQtde,floor(produtoQtde),round(produtoQtde-floor(produtoQtde),3),* from produto where produtoQtde-floor(produtoQtde) > 0

declare @estoque as smallint

set @estoque=1

-- não funcionou para produtos coletados mais de uma vez

begin tran
update TBS032 set ESTQTDATU=ESTQTDATU+produtoQtde 
--select PROCOD,produtoCodigo,ESTQTDATU,produtoQtde
  from TBS032 (nolock) inner join produto on PROCOD=produtoCodigo collate database_default
 where ESTLOC=@estoque

rollback tran
commit tran

select produtoQtde from produto where produtoCodigo='1640054'

select ESTQTDATU from TBS032 (nolock) where ESTLOC=1 and PROCOD='1640054'

select * from TBS032 (nolock) where ESTQTDATU < 0

-- best bag

delete produto

select * into produto1 from produto

select * into produto2 from produto

select * from produto1

select * from produto2

select produtoLote,count(*) from produto2 group by produtoLote

select produtoQtde,floor(produtoQtde),round(produtoQtde-floor(produtoQtde),3),* from produto2 where produtoQtde-floor(produtoQtde) > 0

select count(*) from produto2 group by produtoCodigo

declare @estoque as smallint

set @estoque=2

-- não funcionou para produtos coletados mais de uma vez

begin tran
update TBS032 set ESTQTDATU=ESTQTDATU+produtoQtde 
--select PROCOD,produtoCodigo,ESTQTDATU,produtoQtde
  from TBS032 (nolock) inner join produto2 on PROCOD=produtoCodigo collate database_default
 where ESTLOC=@estoque

rollback tran
commit tran

select * from TBS032 (nolock) where ESTLOC=2 and ESTQTDATU <> 0

--


-- após o estoque lançado

declare @seq int, @data as char(18), @estoque as smallint

set @seq = (select max(LMEREG) from TBS051 (nolock))

set @data = convert(char(8),getdate(),112)

set @estoque = 2

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
        'ENTRADA INVENTARIO',

        'E', -- entrada/saída

        @data,
        'DESENV',
        'NENHUM',

        'E', -- informação alterada

        PROCOD,
        0,

        ESTQTDATU, -- -- saldo atual - após movimentação
        ESTQTDATU, -- quantidade movimentada - entrada/saída

        0, -- quantidade atual - antes da movimentação

        ESTQTDRES,
        ESTQTDPEN,
        ESTQTDCMP,

        (select PROUM1 from TBS010 (nolock) where PROCOD=TBS032.PROCOD),

        ESTQTDATU-ESTQTDRES, -- quantidade disponível

        @estoque
   from TBS032 (nolock)
  where ESTLOC=@estoque and ESTQTDATU > 0)

rollback tran
commit tran

select count(*) from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU > 0

-- atualiza sequêncial dos registros criados

update TBS024 set TBSVALSEQ=(select max(LMEREG) from TBS051 (nolock)) where TBSNOM='TBS051'


-- ajuste do inventário - não foram lançados os produtos contados mais de uma vez

select * from produto2 where produtoCodigo='16280026'

select * from TBS032 (nolock) where PROCOD='16280026'

select * from TBS051 (nolock)
 where LMEROT='SQL' and LMEDESROT='ENTRADA INVENTARIO' and LMEACA='E' and LMEDATHOR='20170507' and LMEUSU='DESENV' and LMEMOD='NENHUM' and LMELOCEST=2 and PROCOD='16280026'

-- loja

drop table #loj

select produtoCodigo as codigo,sum(produtoQtde) as qtde into #loj from produto2 group by produtoCodigo

alter table #loj add dif real

update #loj set dif=0

update #loj set dif=round(qtde,3)-round(LMEQTDSAL,3)
  from TBS051 (nolock) inner join #loj on PROCOD=codigo
 where LMEROT='SQL' and LMEDESROT='ENTRADA INVENTARIO' and LMEACA='E' and LMEDATHOR='20170507' and LMEUSU='DESENV' and LMEMOD='NENHUM' and LMELOCEST=2 and
       round(LMEQTDSAL,3)<>round(qtde,3)

select PROCOD,LMEQTDSAL,round(qtde,3),* from TBS051 (nolock) inner join #loj on PROCOD=codigo
 where LMEROT='SQL' and LMEDESROT='ENTRADA INVENTARIO' and LMEACA='E' and LMEDATHOR='20170507' and LMEUSU='DESENV' and LMEMOD='NENHUM' and LMELOCEST=2 and
       round(LMEQTDSAL,3)<>round(qtde,3)

select * from #loj where dif<0

-- retaguarda

drop table #ret

select produtoCodigo as codigo,sum(produtoQtde) as qtde into #ret from produto1 group by produtoCodigo

alter table #ret add dif real

update #ret set dif=0

update #ret set dif=round(qtde,3)-round(LMEQTDSAL,3)
  from TBS051 (nolock) inner join #ret on PROCOD=codigo
 where LMEROT='SQL' and LMEDESROT='ENTRADA INVENTARIO' and LMEACA='E' and LMEDATHOR='20170507' and LMEUSU='DESENV' and LMEMOD='NENHUM' and LMELOCEST=1 and
       round(LMEQTDSAL,3)<>round(qtde,3)

select PROCOD,LMEQTDSAL,round(qtde,3),* from TBS051 (nolock) inner join #ret on PROCOD=codigo
 where LMEROT='SQL' and LMEDESROT='ENTRADA INVENTARIO' and LMEACA='E' and LMEDATHOR='20170507' and LMEUSU='DESENV' and LMEMOD='NENHUM' and LMELOCEST=1 and
       round(LMEQTDSAL,3)<>round(qtde,3)

select * from #ret where dif > 0

--

declare @seq int, @data as char(18), @estoque as smallint

set @seq = (select max(LMEREG) from TBS051 (nolock))

set @data = convert(char(8),getdate(),112)

set @estoque = 1

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
        'ENTRADA INVENTARIO',

        'E', -- entrada/saída

        @data,
        'DESENV',
        'NENHUM',

        'E', -- informação alterada

        PROCOD,
        0,

        dif, -- -- saldo atual - após movimentação
        dif, -- quantidade movimentada - entrada/saída

        0, -- quantidade atual - antes da movimentação

        ESTQTDRES,
        ESTQTDPEN,
        ESTQTDCMP,

        (select PROUM1 from TBS010 (nolock) where PROCOD=TBS032.PROCOD),

        ESTQTDATU-ESTQTDRES, -- quantidade disponível

        @estoque
   from TBS032 (nolock) inner join #ret on PROCOD=codigo
  where ESTLOC=@estoque and dif > 0)

rollback tran
commit tran

-- atualiza sequêncial dos registros criados

update TBS024 set TBSVALSEQ=(select max(LMEREG) from TBS051 (nolock)) where TBSNOM='TBS051'

select PROCOD,LMEQTDSAL,* from TBS051 (nolock)
 where LMEROT='SQL' and LMEDESROT='ENTRADA INVENTARIO' and LMEACA='E' and LMEDATHOR='20170508' and LMEUSU='DESENV' and LMEMOD='NENHUM' and LMELOCEST=1

declare @estoque as smallint

set @estoque=1

begin tran
update TBS032 set ESTQTDATU=ESTQTDATU+dif
--select PROCOD, codigo, ESTQTDATU, dif, ESTQTDATU+dif
  from TBS032 (nolock) inner join #ret on PROCOD=codigo
 where ESTLOC=@estoque and dif > 0

rollback tran
commit tran

select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU < 0 order by PROCOD

select * from #loj where codigo in(select PROCOD from TBS032 (nolock) where ESTLOC=2 and ESTQTDATU < 0)

-- mais lançamentos loja best bag 09/05/17

select count(*) from Loj090517

select produtoCodigo as codigo,sum(produtoQtde) as qtde into #loj from Loj090517 group by produtoCodigo

select max(LMEDATHOR) from TBS051 (nolock)

declare @seq int, @data as char(18), @estoque as smallint

set @seq = (select max(LMEREG) from TBS051 (nolock))

set @data = convert(char(8),getdate(),112)

set @estoque = 2

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
        'ENTRADA INVENTARIO',

        'E', -- entrada/saída

        @data,
        'DESENV',
        'NENHUM',

        'E', -- informação alterada

        PROCOD,
        0,

        qtde, -- -- saldo atual - após movimentação
        qtde, -- quantidade movimentada - entrada/saída

        0, -- quantidade atual - antes da movimentação

        ESTQTDRES,
        ESTQTDPEN,
        ESTQTDCMP,

        (select PROUM1 from TBS010 (nolock) where PROCOD=TBS032.PROCOD),

        ESTQTDATU-ESTQTDRES, -- quantidade disponível

        @estoque
   from TBS032 (nolock) inner join #loj on PROCOD=codigo
  where ESTLOC=@estoque)

rollback tran
commit tran

-- atualiza sequêncial dos registros criados

update TBS024 set TBSVALSEQ=(select max(LMEREG) from TBS051 (nolock)) where TBSNOM='TBS051'

declare @estoque as smallint

set @estoque=2

begin tran
update TBS032 set ESTQTDATU=ESTQTDATU+qtde
--select PROCOD, codigo, ESTQTDATU, qtde, ESTQTDATU+qtde
  from TBS032 (nolock) inner join #loj on PROCOD=codigo
 where ESTLOC=@estoque

rollback tran
commit tran

select count(*) from produto1
select count(*) from produto2

select produtoCodigo as codigo,
       produtoQtde as qtde into #contagem
  from produto2
union
select produtoCodigo as codigo,
       produtoQtde as qtde
  from Loj090517

select codigo,sum(qtde) as qtde into #saldo2 from #contagem group by codigo

select PROCOD as codigo,
       (select PRODES from TBS010 (nolock) where PROCOD=TBS032.PROCOD) as descricao,
       ESTQTDATU as saldoAtual,
       qtde as inventario       
  from TBS032 (nolock) inner join #saldo2 on PROCOD=codigo
 where ESTLOC=2 and (ESTQTDATU=0 or ESTQTDATU<0)

select codigo,qtde from #contagem order by codigo

select * from #saldo2 order by codigo