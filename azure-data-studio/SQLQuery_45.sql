-- empresas do grupo

if object_id('tempdb.dbo.#cnpj_grupo') is not null
   drop table #cnpj_grupo

select '05118717000237' as 'cnpj'
       ,'BEST BAG FILIAL ' as 'empresa'
  into #cnpj_grupo

insert into #cnpj_grupo
values ('05118717000156', 'BEST BAG MATRIZ'),
       ('52080207000117', 'MISASPEL'),
       ('44125185000136', 'PAPELYNA'),
       ('65069593000350', 'TANBY CD'),
       ('65069593000198', 'TANBY MATRIZ'),
       ('65069593000279', 'TANBY TAUBATE'),
       ('41952080000162', 'WINPACK')

--select *
  --from #cnpj_grupo

-- nf emitidas

if object_id('nf_saida_grupo') is not null
   drop table nf_saida_grupo

select convert(char(8), e.ENFDATEMI, 112) as 'data'
       ,e.ENFCHAACE as 'chave'
       ,e.SNESER as 'serie'
       ,e.ENFNUM as 'numero_nf'
       ,g.cnpj
       ,g.empresa
       ,e.ENFVALTOT as 'valor'
  into nf_saida_grupo
  from TBS080 e with (nolock)
  inner join #cnpj_grupo g
     on g.cnpj=e.ENFCNPJCPF
 where ENFDATEMI between '20230901' and '20230930'
       and ENFSIT=6

select *
  from nf_saida_grupo with (nolock)

-- nf recebidas

if object_id('nf_entrada_grupo') is not null
   drop table nf_entrada_grupo

select convert(char(8), e.NFEDATEFE, 112) as 'data'
       ,e.NFECHAACE as 'chave'
       ,e.NFESERDOC as 'serie'
       ,e.NFENUM as 'numero_nf'
       ,g.cnpj
       ,g.empresa
       ,dbo.NFETOTOPE(e.NFEEMPCOD, e.NFETIP, e.NFENUM, e.NFECOD, e.SEREMPCOD, e.SERCOD) as 'valor'
  into nf_entrada_grupo
  from TBS059 e with (nolock)
  inner join TBS006 f with (nolock)
     on f.FORCOD=e.NFECOD
  inner join #cnpj_grupo g
     on g.cnpj=f.FORCGC
 where e.NFEDATEFE >= '20230901' -- and '20230731'
       and e.NFECAN='N'

-- notas fiscais de devolução

insert into nf_entrada_grupo
select convert(char(8), e.NFEDATEFE, 112) as 'data'
       ,e.NFECHAACE as 'chave'
       ,e.NFESERDOC as 'serie'
       ,e.NFENUM as 'numero_nf'
       ,g.cnpj
       ,g.empresa
       ,dbo.NFETOTOPE(e.NFEEMPCOD, e.NFETIP, e.NFENUM, e.NFECOD, e.SEREMPCOD, e.SERCOD) as 'valor'
  from TBS059 e with (nolock)
  inner join TBS002 c with (nolock)
     on c.CLICOD=e.NFECOD
  inner join #cnpj_grupo g
     on g.cnpj=c.CLICGC
 where e.NFEDATEFE >= '20230901' -- and '20230731'
       and e.NFECAN='N'
       and e.NFETIP='D'


--select *
  --from nf_entrada_grupo with (nolock)



-- relatório

-- cnpj empresa local

if object_id('nf_transito') is not null
   drop table nf_transito

declare @cnpj_local as varchar(14)

select @cnpj_local=EMPCGC
  from TBS023 with (nolock)
 where EMPCOD=1

select *
       ,'BB' as 'emitente'
  into nf_transito
  from bb.SIBD2.dbo.nf_saida_grupo bb with (nolock)
 where bb.cnpj=@cnpj_local
       and @cnpj_local <> (select EMPCGC from bb.SIBD2.dbo.TBS023 with (nolock) where EMPCOD=2)

union

select *
       ,'MI' as 'emitente'
  --into nf_transito       
  from mi.SIBD3.dbo.nf_saida_grupo mi with (nolock)
 where mi.cnpj=@cnpj_local
       and @cnpj_local <> (select EMPCGC from mi.SIBD3.dbo.TBS023 with (nolock) where EMPCOD=1)

union

select *
       ,'PP' as 'emitente'
  from pp.SIBD.dbo.nf_saida_grupo pp with (nolock)
 where pp.cnpj=@cnpj_local
       and @cnpj_local <> (select EMPCGC from pp.SIBD.dbo.TBS023 with (nolock) where EMPCOD=1)

union

select [data] collate database_default
       ,chave collate database_default
       ,serie
       ,numero_nf
       ,cnpj collate database_default
       ,empresa collate database_default
       ,valor
       ,'TC' collate database_default as 'emitente'
  from cd.SIBD.dbo.nf_saida_grupo cd with (nolock)
 where cd.cnpj collate database_default=@cnpj_local
       and @cnpj_local <> (select EMPCGC from cd.SIBD.dbo.TBS023 with (nolock) where EMPCOD=1) collate database_default

union

select *
       ,'TM' as 'emitente'
  from nd.SIBD.dbo.nf_saida_grupo nd with (nolock)
 where nd.cnpj=@cnpj_local
       and @cnpj_local <> (select EMPCGC from nd.SIBD.dbo.TBS023 with (nolock) where EMPCOD=1)

union

select *
       ,'TT' as 'emitente'
  from tt.SIBD.dbo.nf_saida_grupo tt with (nolock)
 where tt.cnpj=@cnpj_local
       and @cnpj_local <> (select EMPCGC from tt.SIBD.dbo.TBS023 with (nolock) where EMPCOD=1)

/*union

select *
       ,'WP' as 'emitente'
  from wp.SIBD4.dbo.nf_saida_grupo wp with (nolock)
 where wp.cnpj=@cnpj_local
       and @cnpj_local <> (select EMPCGC from wp.SIBD4.dbo.TBS023 with (nolock) where EMPCOD=1)*/


select top(1) *
  from nf_transito with (nolock)

select top(1) *
  from nf_entrada_grupo with (nolock)

select convert(date, t.[data]) as 'data'
       ,t.chave
       ,t.serie
       ,t.numero_nf
       ,t.valor
       ,t.emitente
  from nf_transito t with (nolock)
  Left join nf_entrada_grupo e with (nolock)
    on t.numero_nf=e.numero_nf
 where e.numero_nf is null
 order by t.[data]

select *
  from nf_entrada_grupo
 where numero_nf=90283

select *
  from cd.SIBD.dbo.TBS001 with (nolock)

-- corrigir CD

-- nf 9050, 9110/11, 9886, 9505, 10062, 11753, 13198, 13310, 13344, 13362, 15463, 15519, 15645, 15657, 15782, 15843, 15964, 16017, 16499, 16880, 16902, 16916, 16933, 16935, 16945, 16949, 16985, 16989, 17526, 17824, 18188,
-- 18481


-- notas cd com entrada errada

select NFECOD
       ,NFENOM
       ,NFEDATEFE
  from TBS059 with (nolock)
 where NFETIP='T'
       and NFECOD=151

select NFECOD
  from TBS0591 with (nolock)
 where NFETIP='T'
       and NFECOD=151

select NFECOD
  from TBS0592 with (nolock)
 where NFETIP='T'
       and NFECOD=151

/*select NFECOD
  from TBS0593 with (nolock)
 where NFETIP='T'
       and NFECOD=151

select NFECOD
  from TBS0594 with (nolock)
 where NFETIP='T'
       and NFECOD=151*/

select NFECOD
  from TBS0595 with (nolock)
 where NFETIP='T'
       and NFECOD=151

/*select NFECOD
  from TBS0596 with (nolock)
 where NFETIP='T'
       and NFECOD=151

select NFECOD
  from TBS0597 with (nolock)
 where NFETIP='T'
       and NFECOD=151*/

begin tran
update TBS059
   set NFECOD=411
       ,NFENOM='TANBY COMERCIO DE PAPEIS LTDA.'
 where NFETIP='T'
       and NFECOD=151

rollback tran
commit tran

begin tran
update TBS0591
   set NFECOD=411
 where NFETIP='T'
       and NFECOD=151

rollback tran
commit tran

begin tran
update TBS0592
   set NFECOD=411
 where NFETIP='T'
       and NFECOD=151

rollback tran
commit tran

begin tran
update TBS0595
   set NFECOD=411
 where NFETIP='T'
       and NFECOD=151

rollback tran
commit tran

begin tran
update TBS0591
   set NFECOD=411
 where NFETIP='T'
       and NFECOD=151

rollback tran
commit tran
