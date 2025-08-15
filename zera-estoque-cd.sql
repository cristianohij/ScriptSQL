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
        row_number() over(order by produtoCodigo)+@seq,
        0,
        'SQL',
        'ZERAR ESTOQUE',
        'E',
        '20170218',
        'DESENV',
        'NENHUM',
        'E',
        produtoCodigo,
        0,

        produtoQtde,
        0,
        0,
        0,
        0,
        0,(select PROUM1 from TBS010 (nolock) where PROCOD=produtoQtde collate database_default),
        0,
        1
   from produto)
rollback tran
commit tran

select top 50 * from TBS051 (nolock) order by LMEREG desc

update TBS024 set TBSVALSEQ=(select max(LMEREG) from TBS051 (nolock)) where TBSNOM='TBS051'

begin tran
update TBS032 set ESTQTDATU=0 where ESTLOC=2 and ESTQTDATU < 0
commit tran
rollback tran


---------

select * from TBS032 (nolock) where ESTLOC=2 and ESTQTDATU < 0

select * from TBS032 (nolock) where ESTLOC=1 and (ESTQTDRES > 0 or ESTQTDPEN > 0)

select * into TBS032_2804217_EST1 from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU <> 0

select * from TBS032_180217_EST1


---------



------


select * from produto

select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU > 0

update TBS032 set ESTQTDATU=produtoQtde 
select PROCOD,produtoCodigo,ESTQTDATU,produtoQtde
  from TBS032 (nolock) inner join produto on PROCOD=produtoCodigo collate database_default
 where ESTLOC=1


----


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
        row_number() over(order by produtoCodigo)+@seq,
        0,
        'SQL',
        'ENTRADA INVENTARIO',
        'E',
        '20170218',
        'DESENV',
        'NENHUM',
        'E',
        produtoCodigo,
        0,
        produtoQtde,
        produtoQtde,
        0,
        0,
        0,
        0,(select PROUM1 from TBS010 (nolock) where PROCOD=produtoCodigo collate database_default),
        0,
        1
   from produto)
rollback tran
commit tran

select top 500 * from TBS051 (nolock) order by LMEREG desc

update TBS024 set TBSVALSEQ=(select max(LMEREG) from TBS051 (nolock)) where TBSNOM='TBS051'

select count(*) from TBS051 (nolock) where LMEROT='SQL' and LMEUSU='DESENV' and LMEDATHOR='20170218'

begin tran
update TBS051 set LMEQTDATU=LMEQTDSAL where LMEROT='SQL' and LMEUSU='DESENV' and LMEDATHOR='20170218'
rollback tran
commit tran

begin tran
update TBS051 set LMEQTDSAL=0 where LMEROT='SQL' and LMEUSU='DESENV' and LMEDATHOR='20170218'
rollback tran
commit tran

select * from TBS051 (nolock) where LMEROT='SQL' and LMEUSU='DESENV' and LMEDATHOR='20170218'



-----------


select 'insert into produto select ''' +
       usuarioNome +
       ''',' +
       Ltrim(str(produtoLote,4)) +
       ',''' +
       rtrim(produtoCodigo) +
       ''',''' +
       rtrim(convert(nvarchar(23),produtoDataLote,121)) +
       --'NULL' + 
       ''',''' +
       rtrim(produtoCodigoBarras) +
       ''',''' +
       rtrim(produtoDescricao) +
       ''',' +
       Ltrim(str(produtoQtde,12,4)) +
       ',''' +
       rtrim(produtoMarca) +
       ''',''' +
       rtrim(produtoEmbalagem) +
       ''',''' +
       rtrim(convert(nvarchar(23),produtoDataHora,121)) +
       --'NULL' + 
       ''',' +
       case when produtoZerado is null then 'NULL' else '''' + rtrim(convert(nvarchar(23),produtoZerado,121)) + '''' end +
       --'NULL' +
       ',' +
       Ltrim(str(produtoColetas,9)) +
       ',''' + 
       rtrim(produtoEmbalagem2) + 
       ''',''' +
       rtrim(produtoEmbalagem3) +
       ''',''' +
       rtrim(produtoEmbalagem4) +
       ''',' +
       --Ltrim(str(produtoQtde2,12,4)) +
       '0' +
       ',' +
       --Ltrim(str(produtoQtde3,12,4)) +
       '0' +
       ',' +
       --Ltrim(str(produtoQtde4,12,4)) +
       '0' +
       ',''' + rtrim(produtoCodigoBarras2) + ''',''' + rtrim(produtoCodigoBarras3) + ''',''' + rtrim(produtoCodigoBarras4) + ''',''' + rtrim(produtoContagemUnitaria) + ''';'
  from produto
 where produtoQtde > 0




select * from TBS051 (nolock) where LMEACA='E' and LMEROT='SQL' and LMEUSU='DESENV' and LMEDATHOR='20170218' order by LMEREG desc

begin tran
update TBS051 set LMEQTDSAL=0 where LMEACA='S' and LMEROT='SQL' and LMEUSU='DESENV' and LMEDATHOR='20170218'
commit tran

select * from TBS051 (nolock) where LMEROT='SQL' and LMEUSU='DESENV' and LMEDATHOR='20170218' order by LMEREG desc

select LMEACA,count(*) from TBS051 (nolock) where LMEROT='SQL' and LMEUSU='DESENV' and LMEDATHOR='20170218' group by LMEACA

select top 500 * from TBS051 (nolock) order by LMEREG desc


-- relatório comparativo

select * from TBS051 (nolock) where LMEDOC=883 and LMEROT='PEST005' and LMEACA='E' and LMEUSU='RAQUELFARIA'


select *
  from TBS032_180217_EST1 (nolock)
       full outer join produto (nolock) on TBS032_180217_EST1.PROCOD=produtoCodigo collate database_default
       full join TBS051 (nolock) on TBS051.PROCOD=TBS032_180217_EST1.PROCOD or TBS051.PROCOD=produtoCodigo collate database_default
 where LMEDOC=883 and LMEROT='PEST005' and LMEACA='E' and LMEUSU='RAQUELFARIA'

drop table inventCD

select case when PROCOD is null then produtoCodigo collate database_default else PROCOD end as codigo,
       case when PRODES is null then produtoDescricao collate database_default else PRODES end as descricao,
       isnull(ESTQTDATU,0) as saldoAnterior,
       isnull(produtoQtde,0) as saldoAtual,
       case when PROCOD is null then (select PROUM1 from TBS010 (nolock) where PROCOD=produtoCodigo collate database_default) else (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS032_180217_EST1.PROCOD) end as unidade,
       883 as doc
       into inventCD
  from TBS032_180217_EST1 (nolock)
       full outer join produto (nolock) on TBS032_180217_EST1.PROCOD=produtoCodigo collate database_default

select *
       into #ncoletados
  from TBS051 (nolock)
 where LMEDOC=883 and LMEROT='PEST005' and LMEACA='E' and LMEUSU='RAQUELFARIA'

drop table #inventario

select case when PROCOD is null then codigo collate database_default else PROCOD end as codigo,
       descricao,
       unidade,
       case when saldoAnterior is null then LMEQTDATU else saldoAnterior end as saldoAnterior,
       saldoAtual as coletor,
       isnull(LMEQTDMOV,0) as movInterno,
       0 as marca
       into #inventario
  from inventCD
       full outer join #ncoletados on PROCOD=codigo collate database_default

update #inventario set marca=convert(int,subString(codigo,1,3)) where Len(codigo)=7

update #inventario set marca=convert(int,subString(codigo,1,4)) where Len(codigo)=8

update #inventario set descricao=(select PRODES from TBS010 (nolock) where PROCOD=codigo collate database_default) where descricao is null

update #inventario set unidade=(select PROUM1 from TBS010 (nolock) where PROCOD=codigo collate database_default) where unidade is null

select * from #inventario

update #inventario set coletor=0 where coletor is null

select *,
       (select MARNOM from TBS014 (nolock) where MARCOD=marca)
 from #inventario


select codigo,count(codigo) from #inventario group by codigo having count(codigo) > 1



-- retaguarda

select * from TBS032_040317_EST1

-- loja

select * from TBS032_040317_EST2

select * from TBS032 (nolock) where ESTLOC=1 and (ESTQTDRES > 0 or ESTQTDPEN > 0)

-- zerar o estoque

declare @seq int

set @seq = (select max(LMEREG) from TBS051 (nolock))

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
        row_number() over(order by PROCOD)+@seq,
        0,
        'SQL',
        'ZERAR ESTOQUE',

        'S', -- entrada/saída

        '20170304',
        'DESENV',
        'NENHUM',

        'E', -- informação alterada

        PROCOD,
        0,

        0,         -- saldo atual
        ESTQTDATU, -- quantidade movimentada - entrada/saída

        ESTQTDATU, -- quantidade atual

        ESTQTDRES,
        ESTQTDPEN,
        ESTQTDCMP,

        (select PROUM1 from TBS010 (nolock) where PROCOD=TBS032.PROCOD), -- unidade de medida

        0, -- quantidade disponível

        1
   from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU > 0)
rollback tran
commit tran

update TBS024 set TBSVALSEQ=(select max(LMEREG) from TBS051 (nolock)) where TBSNOM='TBS051'


-- entradas dos produtos inventariados

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
        row_number() over(order by produtoCodigo)+@seq,
        0,
        'SQL',
        'ENTRADA INVENTARIO',

        'E', -- entrada/saída

        '20170304',
        'DESENV',
        'NENHUM',

        'E', -- informação alterada

        produtoCodigo,
        0,

        produtoQtde, -- saldo atual
        produtoQtde, -- quantidade movimentada - entrada/saída

        0,
        0,
        0,
        0,

        (select PROUM1 from TBS010 (nolock) where PROCOD=produtoCodigo collate database_default),

        produtoQtde, -- quantidade disponível

        1
   from produto)
rollback tran
commit tran

select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDCMP > 0
-- atualiza o estoque

select * from produto

select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU > 0

begin tran
update TBS032 set ESTQTDATU=ESTQTDATU+produtoQtde 
--select PROCOD,produtoCodigo,ESTQTDATU,produtoQtde
  from TBS032 (nolock) inner join produto on PROCOD=produtoCodigo collate database_default
 where ESTLOC=1 and produtoLote=5
rollback tran
commit tran


-- zera estoque loja

select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU > 0

select * from TBS032 (nolock) where ESTLOC=1 and (ESTQTDRES > 0 or ESTQTDPEN > 0)

declare @seq int

set @seq = (select max(LMEREG) from TBS051 (nolock))

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
        row_number() over(order by PROCOD)+@seq,
        0,
        'SQL',
        'ZERAR ESTOQUE',

        'S', -- entrada/saída

        '20170325',
        'DESENV',
        'NENHUM',

        'E', -- informação alterada

        PROCOD,
        0,

        0,         -- saldo atual
        ESTQTDATU, -- quantidade movimentada - entrada/saída

        ESTQTDATU, -- quantidade atual

        ESTQTDRES,
        ESTQTDPEN,
        ESTQTDCMP,

        (select PROUM1 from TBS010 (nolock) where PROCOD=TBS032.PROCOD), -- unidade de medida

        0, -- quantidade disponível

        2
   from TBS032 (nolock) where ESTLOC=2 and ESTQTDATU <> 0)
rollback tran
commit tran

select * from TBS032 (nolock) where ESTQTDATU < 0 and ESTLOC=2

select * from TBS051 (nolock) where PROCOD='0051888' and LMEQTDMOV < 0

select * into TBS032_250317_EST1 from TBS051 (nolock) where LMEROT='SQL' and LMEDATHOR='20170325' and LMEUSU='DESENV' and LMEACA='S' and LMELOCEST=2

select top 1 * from SALDODIARIO (nolock)

select max(ESTDATSAL) from SALDODIARIO (nolock)

drop table TBS032_250317_EST1

select * from SALDODIARIO (nolock) where ESTDATSAL='20170325' and ESTLOC=1 and ESTQTDATU > 0

select * into TBS032_250317_EST1 from SALDODIARIO (nolock) where ESTDATSAL='20170325' and ESTLOC=1 and ESTQTDATU > 0

-- acerto de produtos com saídas negativas

begin tran
update TBS051 set LMEQTDMOV=LMEQTDMOV * -1,LMEACA='E' where LMEROT='SQL' and LMEDATHOR='20170325' and LMEUSU='DESENV' and LMEQTDMOV < 0
commit tran

-- zera o estoque

select ESTLOC,count(*) from TBS032 (nolock) where ESTQTDATU <> 0 group by ESTLOC

begin tran
update TBS032 set ESTQTDATU=0 where ESTLOC in(1,2) and ESTQTDATU <> 0
commit tran
rollback tran

select * from TBS032 (nolock) where ESTLOC in(1,2) and ESTQTDATU <> 0 or ESTQTDRES <> 0 or ESTQTDPEN <> 0


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
        row_number() over(order by produtoCodigo)+@seq,
        0,
        'SQL',
        'ENTRADA INVENTARIO',

        'E', -- entrada/saída

        '20170325',
        'DESENV',
        'NENHUM',

        'E', -- informação alterada

        produtoCodigo,
        0,

        produtoQtde, -- saldo atual
        produtoQtde, -- quantidade movimentada - entrada/saída

        0,
        0,
        0,
        0,

        (select PROUM1 from TBS010 (nolock) where PROCOD=produtoCodigo collate database_default),

        produtoQtde, -- quantidade disponível

        2
   from produto)
rollback tran
commit tran


select * from produto

select * from TBS032 (nolock) where ESTLOC=2 and ESTQTDATU > 0

begin tran
update TBS032 set ESTQTDATU=ESTQTDATU+produtoQtde 
--select PROCOD,produtoCodigo,ESTQTDATU,produtoQtde
  from TBS032 (nolock) inner join produto on PROCOD=produtoCodigo collate database_default
 where ESTLOC=2 and produtoLote=5
rollback tran
commit tran


-- analises

select count(*) from proCarLoj

-- rodar no studio, no query exibe uma quantidade grande de decimais desnecessárias

select round(produtoQtde,2),floor(produtoQtde),produtoQtde-floor(produtoQtde),* from proInvRet2 where produtoQtde-floor(produtoQtde) > 0

select produtoQtde,floor(produtoQtde),round(produtoQtde-floor(produtoQtde),3),* from proInvLoj2 where produtoQtde-floor(produtoQtde) > 0

select produtoQtde,floor(produtoQtde),produtoQtde-round(produtoQtde,0),* from proInvLoj2 where produtoCodigo='13270001'

select ESTQTDATU,*
  from TBS032 (nolock)
 where ESTLOC=2 and PROCOD in(select produtoCodigo,produtoQtde,produtoLote from proInvLoj where produtoQtde-round(produtoQtde,0) > 0)

select produtoCodigo,count(*) from proInvLoj group by produtoCodigo having count(*) > 1 order by produtoCodigo

select * from proInvLoj where produtoCodigo in(select produtoCodigo from proInvLoj group by produtoCodigo having count(*) > 1) order by produtoCodigo

select produtoCodigo,sum(produtoQtde)
  from proInvLoj
 where produtoCodigo in(select produtoCodigo from proInvLoj group by produtoCodigo having count(*) > 1)
 group by produtoCodigo
 order by produtoCodigo


select *
  from TBS032 (nolock)
 where ESTLOC=2 and PROCOD in(select produtoCodigo from proInvLoj group by produtoCodigo having count(*) > 1)
 order by PROCOD


-- produtos com dois lançamentos ou mais iguais

-- loja

select produtoCodigo,
       sum(produtoQtde)/2,
       (select PRODES from TBS010 (nolock) where PROCOD=produtoCodigo),
       (select MARNOM from TBS010 (nolock) where PROCOD=produtoCodigo)
  from proInvLoj2
 where produtoCodigo in(select produtoCodigo from proInvLoj2 group by produtoCodigo,produtoQtde having count(*) > 1)
 group by produtoCodigo
 order by produtoCodigo

-- retaguarda

select produtoCodigo,
       sum(produtoQtde)/2,
       (select PRODES from TBS010 (nolock) where PROCOD=produtoCodigo),
       (select MARNOM from TBS010 (nolock) where PROCOD=produtoCodigo)
  from proInvRet2
 where produtoCodigo in(select produtoCodigo from proInvRet2 group by produtoCodigo,produtoQtde having count(*) > 1)
 group by produtoCodigo
 order by produtoCodigo


-- acertar Loj da loja para produtos coletados 2 vezes

select *
  from TBS051 (nolock)
 where LMELOCEST=2 and
       LMEDATHOR>='20170304' and
       PROCOD in(select produtoCodigo from proInvLoj group by produtoCodigo having count(*) > 1) and
       LMEACA='E' and
       LMEROT='SQL'
 order by LMEREG

-- acertar Loj da retaguarda para produtos coletados 2 vezes

select *
  from TBS051 (nolock)
 where LMELOCEST=1 and
       LMEDATHOR>='20170304' and
       PROCOD in(select produtoCodigo from proInvRet group by produtoCodigo having count(*) > 1) and
       LMEACA='E' and
       LMEROT='SQL'
 order by LMEREG


-- relatórios

-- estoque 1

drop table inventND

select case when PROCOD is null then produtoCodigo collate database_default else PROCOD end as codigo,
       case when PRODES is null then produtoDescricao collate database_default else PRODES end as descricao,
       isnull(ESTQTDATU,0) as saldoAnterior,
       isnull(produtoQtde,0) as saldoAtual,
       case when PROCOD is null then (select PROUM1 from TBS010 (nolock) where PROCOD=produtoCodigo collate database_default) else (select PROUM1 from TBS010 (nolock) where PROCOD=EST1.PROCOD) end as unidade,
       0 as doc
       into inventEST1
  from TBS032_29042017_EST1 as EST1 (nolock)
       full outer join produto (nolock) on PROCOD=produtoCodigo collate database_default

select * from inventEST1


select codigo,
       descricao,
       unidade,
       saldoAnterior,
       saldoAtual as coletor,
       0 as marca
       into #inventario
  from inventEST1

update #inventario set marca=convert(int,subString(codigo,1,3)) where Len(codigo)=7

update #inventario set marca=convert(int,subString(codigo,1,4)) where Len(codigo)=8

update #inventario set descricao=(select PRODES from TBS010 (nolock) where PROCOD=codigo collate database_default) where descricao is null

update #inventario set unidade=(select PROUM1 from TBS010 (nolock) where PROCOD=codigo collate database_default) where unidade is null

select codigo,descricao,unidade,saldoAnterior,coletor,(select MARNOM from TBS014 (nolock) where MARCOD=marca) from #inventario


-- compara saldo anterior com estoque atual

select case when T32.PROCOD is null then ANT.PROCOD else T32.PROCOD end as codigo,
       case when T32.PRODES is null then ANT.PRODES else T32.PRODES end as descricao,
       case when T32.PROCOD is null then (select MARNOM from TBS014 (nolock) where MARCOD=ANT.MARCOD) else (select MARNOM from TBS014 (nolock) where MARCOD=T32.MARCOD) end as marca,
       case when T32.PROCOD is null then (select PROUM1 from TBS010 (nolock) where PROCOD=ANT.PROCOD) else (select PROUM1 from TBS010 (nolock) where PROCOD=T32.PROCOD) end as unidade,
       isnull(ANT.ESTQTDATU,0) as saldoAnterior,
       isnull(T32.ESTQTDATU,0) as saldoAtual
  from TBS032 as T32 (nolock) Left join TBS032_29042017_EST1 as ANT (nolock) on T32.PROCOD=ANT.PROCOD
 where T32.ESTLOC=1 and (T32.ESTQTDATU > 0 or ANT.ESTQTDATU > 0)


--

-- estoque 2

drop table inventEST2

select case when PROCOD is null then produtoCodigo collate database_default else PROCOD end as codigo,
       case when PRODES is null then produtoDescricao collate database_default else PRODES end as descricao,
       isnull(ESTQTDATU,0) as saldoAnterior,
       isnull(produtoQtde,0) as saldoAtual,
       case when PROCOD is null then (select PROUM1 from TBS010 (nolock) where PROCOD=produtoCodigo collate database_default) else (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS032_250317_EST2.PROCOD) end as unidade,
       0 as doc
       into inventEST2
  from TBS032_250317_EST2 (nolock)
       full outer join proInvLoj2 (nolock) on TBS032_250317_EST2.PROCOD=produtoCodigo collate database_default

select * from inventEST2

drop table #inventario

select codigo,
       descricao,
       unidade,
       saldoAnterior,
       saldoAtual as coletor,
       0 as marca
       into #inventario
  from inventEST2

update #inventario set marca=convert(int,subString(codigo,1,3)) where Len(codigo)=7

update #inventario set marca=convert(int,subString(codigo,1,4)) where Len(codigo)=8

update #inventario set descricao=(select PRODES from TBS010 (nolock) where PROCOD=codigo collate database_default) where descricao is null

update #inventario set unidade=(select PROUM1 from TBS010 (nolock) where PROCOD=codigo collate database_default) where unidade is null

select codigo,descricao,unidade,saldoAnterior,coletor,(select MARNOM from TBS014 (nolock) where MARCOD=marca) from #inventario



-----

select * into proInvLoj2 from produto

select * into proInvRet2 from produto

delete proInvLoj2
delete proInvRet2

select * from proInvLoj2 where produtoCodigo='13270001'

select * from produto

select * from TBS032 (nolock) where ESTLOC=2 and ESTQTDATU <> 0

begin tran
update TBS032 set ESTQTDATU=ESTQTDATU+produtoQtde 
--select PROCOD,produtoCodigo,ESTQTDATU,produtoQtde
  from TBS032 (nolock) inner join proInvLoj on PROCOD=produtoCodigo collate database_default
 where ESTLOC=2 and produtoLote=5
rollback tran
commit tran


select produtoCodigo,count(*) from proInvLoj group by produtoCodigo having count(*) > 1

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
        'ENTRADA INVENTARIO',

        'E', -- entrada/saída

        '20170325',
        'DESENV',
        'NENHUM',

        'E', -- informação alterada

        PROCOD,
        0,

        ESTQTDATU, -- saldo atual
        ESTQTDATU, -- quantidade movimentada - entrada/saída

        0,
        0,
        0,
        ESTQTDCMP,

        (select PROUM1 from TBS010 (nolock) where PROCOD=TBS032.PROCOD),

        ESTQTDATU, -- quantidade disponível

        2
   from TBS032 (nolock) where ESTLOC=2 and ESTQTDATU > 0)
rollback tran
commit tran

update TBS024 set TBSVALSEQ=(select max(LMEREG) from TBS051 (nolock)) where TBSNOM='TBS051'

begin tran
update TBS051 set LMEQTDSAL=LMEQTDMOV where LMEROT='SQL' and LMEDESROT='ENTRADA INVENTARIO' and LMEACA='E' and LMEDATHOR='20170325' and LMEUSU='DESENV'

select * from proInvRet where produtoQtde > round(produtoQtde,0)

select count(*) from TBS053 (nolock) where BCPTIPTRN='P'

select top 1 * from TBS053 (nolock)


select top 1 * from TBS051 (nolock) 

select * from TBS010 (nolock) 


select count(*) from proInvLoj group by produtoCodigo

select * from TBS032 (nolock) where PROCOD='6521770'

select * from TBS051 (nolock) where LMEDATHOR >= '20170327' and PROCOD='6521770'

select * from TBS051 (nolock) where LMEROT='SQL' and LMEDESROT='ENTRADA INVENTARIO' and LMEACA='E' and LMEDATHOR='20170325' and LMEUSU='DESENV'

select * from proInvLoj (nolock) where produtoDescricao Like('%CONTACT%')

select * from proInvRet (nolock) where produtoDescricao Like('%CONTACT%')

select * from proInvLoj (nolock) where produtoCodigo='11920010'

select * from proInvLoj (nolock) where produtoCodigo='9071293'

select * from proInvLoj (nolock) where produtoCodigo='6521770'

select ESTQTDATU,produtoQtde,*
  from proInvLoj (nolock) inner join TBS032 (nolock) on produtoCodigo=PROCOD
 where produtoLote=4 and ESTLOC=2

select top 1 * from TBS037 (nolock)

select top 1 * from TBS0371 (nolock)

select * from TBS037 (nolock) where MVIDATLAN >= '20170327' and MVIDATLAN<>MVIDATEFE

select *
  from TBS037 (nolock) inner join TBS0371 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
 where MVIDATLAN >= '20170327' and MVIDATLAN<>MVIDATEFE

select PROCOD,MVIQTDATD,MVIQTDEMB,MVIQTDATD*MVIQTDEMB,MVILOCORI,MVILOCDES
  from TBS037 (nolock) inner join TBS0371 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
 where MVIDATLAN >= '20170327' and TBS037.MVILOCDES > 0 and MVILOCORI=0

select * from TBS058 (nolock) where not exists(select '' from TBS0551 (nolock) where PDVNUM=PRPNUM and PDVITEM=PRPITEM and PROCOD=TBS058.PROCOD)

select SINPROCOD,SINQTD from TBS124 (nolock) where SINPROCOD in(select PROCOD
  from TBS037 (nolock) inner join TBS0371 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
 where MVIDATLAN >= '20170327' and TBS037.MVILOCDES > 0 and MVILOCORI=0)

select *
  from TBS037 (nolock) inner join TBS0371 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
 where MVIDATLAN >= '20170327' and PROCOD='5410169'

select * from TBS125 (nolock) where KESPROCOD='5410169'

select * from TBS034 (nolock)


select max(LMEREG) from TBS051 (nolock)

select * from TBS024 (nolock) where TBSNOM='TBS051'

-- banco de dados restaurado do backup do dia 24/03/17
select * into SIBD.dbo.TBS032_250317_EST1 from BSIBD.dbo.TBS032 (nolock) where ESTLOC=1 and ESTQTDATU > 0

select * into SIBD.dbo.TBS032_250317_EST2 from BSIBD.dbo.TBS032 (nolock) where ESTLOC=2 and ESTQTDATU <> 0



-- relatorios contagem Best Bag

-- TBS032_06052017_EST1
-- TBS032_06052017_EST2

select count(*) from produto1 where produtoQtde > 0 group by produtoCodigo -- 1203

select count(*) from produto2 where produtoQtde > 0 group by produtoCodigo -- 4033

select count(*) from Loj090517 where produtoQtde > 0 group by produtoCodigo -- 580

-- estoque papelyna lançado em 01/05/17
select * from TBS051 (nolock)
 where LMEROT='SQL' and LMEDESROT='ENTRADA INVENTARIO' and LMEACA='E' and LMEDATHOR='20170501' and LMEUSU='DESENV' and LMEMOD='NENHUM'

select * from produto

drop table inventLOJ2

select case when PROCOD is null then produtoCodigo collate database_default else PROCOD end as codigo,
       case when PRODES is null then produtoDescricao collate database_default else PRODES end as descricao,
       isnull(ESTQTDATU,0) as saldoAnterior,
       isnull(produtoQtde,0) as saldoAtual,
       case when PROCOD is null then (select PROUM1 from TBS010 (nolock)
                                       where PROCOD=produtoCodigo collate database_default) else (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=ANT.PROCOD) end as unidade,
       0 as doc
       into inventLOJ2
  from TBS032_06052017_EST2 as ANT (nolock)
       --full outer join Loj090517 (nolock) on ANT.PROCOD=produtoCodigo collate database_default
       inner join Loj090517 (nolock) on ANT.PROCOD=produtoCodigo collate database_default

select * from inventEST2

drop table #inventario

select codigo,
       descricao,
       unidade,
       saldoAnterior,
       saldoAtual as coletor,
       0 as marca
       into #inventario
  from inventLOJ2

update #inventario set marca=convert(int,subString(codigo,1,3)) where Len(codigo)=7

update #inventario set marca=convert(int,subString(codigo,1,4)) where Len(codigo)=8

update #inventario set descricao=(select PRODES from TBS010 (nolock) where PROCOD=codigo collate database_default) where descricao is null or descricao=''

update #inventario set unidade=(select PROUM1 from TBS010 (nolock) where PROCOD=codigo collate database_default) where unidade is null or unidade=''

select codigo,descricao,unidade,saldoAnterior,coletor,(select MARNOM from TBS014 (nolock) where MARCOD=marca) from #inventario

select PROCOD,PRODES from TBS010 (nolock) where PROCOD in('8478952','8478956')

select * from produto2 (nolock) where produtoCodigo in('8478952','8478956')

select * from #inventario (nolock) where codigo in('8478952','8478956')
