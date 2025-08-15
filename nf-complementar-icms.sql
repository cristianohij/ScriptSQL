select * from TBS023 (nolock)

select *
  from TBS067 (nolock)
       inner join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM
 where TBS067.NFSEMPCOD=2 and TBS067.NFSDATEMI between '20180101' and '20180131' and TBS080.ENFSIT=6 and TBS0671.NFSPERICMS > 0 and TBS067.UFESIG='SP' and ENFFINEMI=1 and
       right(TBS0671.NFSCST,3)<>'500'

select count(*)
  from TBS067 (nolock)
       inner join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM
 where TBS067.NFSEMPCOD=2 and TBS067.NFSDATEMI between '20180101' and '20180131' and TBS080.ENFSIT=6 and TBS0671.NFSPERICMS > 0 and TBS067.UFESIG='SP' and ENFFINEMI=1 and
       right(TBS0671.NFSCST,3)<>'500'
 group by TBS067.SNESER,TBS067.NFSNUM

select * from TBS110 (nolock)
select * from TBS1101 (nolock)

select * from TBS024 (nolock) where TBSMOD='E'


select * from TBS067 (nolock) where NFSTIP='C' order by NFSDATEMI desc

select * from TBS080 (nolock) where ENFNUM=10198

select ENFSER from TBS080 (nolock) group by ENFSER


-- registro TBS080
insert into TBS080 

--select top 1 * from TBS080 (nolock)
select 2 empresa,
       NF nf,
       1 tipodoc,
       55 modelo,
       1 seriesis,
       convert(date,getdate(),112) emissao,
       1 danfe,
       2 pagto,
       1 formaemi,
       (select case CLITIPPES when 'J' then CLICGC else CLICPF end from TBS002 (nolock) where TBS002.CLICOD=TBS067.NFSCLICOD) documento,
       2 finalidade,
       TBS067.NFSCLINOM razaoSocial,
       0 valor,
       '' chave,
       'N' impresso,
       TBS067.NFSCLICOD cliente,
       1 situacao,
       '' arquivo,
       0 recibo,
       0 protocolo,
       '' digest,
       '' justificativa,
       'N' email,
       '' tipent,
       TBS067.UFESIG estado,
       TBS067.VENCOD vendedor,
       1 ambiente,
       '17530101' processamento,
       0 protcan,
       '17530101' datahoracan,
       0 protinut,
       '' justinut,
       '17530101' datahorainut,
       2 empserie,
       1 serie

  from TBS067 (nolock)
 where TBS067.NFSEMPCOD=2
       --and TBS067.NFSDATEMI between '20180101' and '20180131'
       and TBS067.NFSNUM between 6194 and 6286
       and TBS067.UFESIG='SP'
       and exists(select '' from TBS0671 (nolock)
                   where TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM and TBS0671.NFSPERICMS > 0 and right(TBS0671.NFSCST,3)<>'500')
       and exists(select '' from TBS080 (nolock)
                   where TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM and TBS080.ENFSIT=6 and TBS080.ENFFINEMI=1)


-- registro TBS067 

select getdate()
select convert(date,getdate(),112)
select convert(char(19),getdate(),131)
select convert(char(8),getdate(),114)

select * from TBS067 (nolock) where NFSNUM=10198

-- registra números nf

declare @seq int

select @seq = SNENUM from TBS104 (nolock) where SNEEMPCOD=2 and SNESER=1 and SNETIP='SG'

select NFSEMPCOD,SNEEMPCOD,SNESER,NFSNUM,@seq + row_number() over (order by TBS067.NFSNUM) nf

  into #tab
  from TBS067 (nolock)
 where TBS067.NFSEMPCOD=2
       --and TBS067.NFSDATEMI between '20180101' and '20180131'
       and TBS067.UFESIG='SP'
       and TBS067.NFSNUM between 6194 and 6286
       and exists(select '' from TBS0671 (nolock)
                   where TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM and TBS0671.NFSPERICMS > 0 and right(TBS0671.NFSCST,3)<>'500')
       and exists(select '' from TBS080 (nolock)
                   where TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM and TBS080.ENFSIT=6 and TBS080.ENFFINEMI=1)

select * from #tab

update TBS067 set NF=0 where NF is null

update TBS067 set NF=(select nf from #tab where #tab.NFSEMPCOD=TBS067.NFSEMPCOD and #tab.SNEEMPCOD=TBS067.SNEEMPCOD and #tab.SNESER=TBS067.SNESER and #tab.NFSNUM=TBS067.NFSNUM)

  from TBS067 (nolock)
 where TBS067.NFSEMPCOD=2
       --and TBS067.NFSDATEMI between '20180101' and '20180131'
       and TBS067.UFESIG='SP'
       and TBS067.NFSNUM between 6194 and 6286
       and exists(select '' from TBS0671 (nolock)
                   where TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM and TBS0671.NFSPERICMS > 0 and right(TBS0671.NFSCST,3)<>'500')
       and exists(select '' from TBS080 (nolock)
                   where TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM and TBS080.ENFSIT=6 and TBS080.ENFFINEMI=1)

update TBS104 set SNENUM=(select max(NF) from TBS067 (nolock)) where SNEEMPCOD=2 and SNESER=1 and SNETIP='SG'


insert into TBS067

--select top 1 * from TBS067 (nolock)

select 2 empresa,
       NF nf,
--       1 tipodoc,
--       55 modelo,
--       1 seriesis,
       convert(date,getdate(),112) emissao,
       convert(char(10),getdate(),103)+' '+convert(char(8),getdate(),114)+' PADRAO' usuario,
--       1 danfe,
       '17530101' saida,
       '' hora,
       TBS067.NFSCAN cancelada,
       TBS067.NFSDEV devolvida,
       TBS067.NFSDATCAN datacan,
       TBS067.NFSUSUCAN usucan,
       TBS067.SEREMPCOD empsersis,
       TBS067.SERCOD seriesis,
       TBS067.NFSCLIEMP empcli,
       TBS067.NFSCLICOD cliente,
       TBS067.NFSCLINOM razaosoc,
       NFSREQCOD codiogreq,
       NFSREQNOM nomereq,
       VENEMPCOD empvendedor,
       VENCOD codigoven,
       NFSVENCOM comissao,
       NFSVENPDC percentcom,
       UFESIG uf,
       CPGEMPCOD emppag,
       0 codpag,
       'N' geradup,
       TRNEMPCOD emptransp,
       0 codtransp,
       0 proximanf,
       9 tipofre,
       'N' iseicms,
       NFSREQCDC centrocus,
       NFSPEDCLI pedcliente,
       0 nfanterior,
       0 frete,
       0 seguro,
       0 despesas,
       'REF. A NF ' + Ltrim(str(NFSNUM,6)) + ' SERIE ' + Ltrim(str(SNESER,3)) + ' DE ' + convert(char(10),NFSDATEMI,103),
       'C' tiponf,
       NFSNUM nforigem,
       NFSDATEMI dataorigem,
       0 totcomple,
       0 pesobru,
       0 pesoliq,
       0 volumes,
       '' especie,
       '' marca,
       '' numero,
       '' transfiscal,
       0 mes,
       0 ano,
       0 desconto,
       NFSLOCENT entrega,
       NFSLOCCOB cobranca,
       0 valortransf,
       0 complebcicms,
       0 valorcomple,
       0 valorcomplepro,
       0 valorcompletot,
       NFSFINAQU finaquis,
       NFSTIPOPE tipoope,
       0 desctot,
       NFSTIPENT tipentre,
       NFSCLIENDCOD codendere,
       NFSCOBBAI bairrocob,
       NFSCOBCPL complecob,
       NFSCOBEND endercob,
       NFSCOBMUN municob,
       NFSCOBMUNCOD codmunicob,
       NFSCOBNUM numerocob,
       NFSCOBUFE ufcob,
       NFSENDCOBCOD codendercob,
       NFSENDENTCOD codenderent,
       NFSENTBAI bairroent,
       NFSENTCGC cnpjent,
       NFSENTCPF cpfent,
       NFSENTCPL compleent,
       NFSENTEND enderent,
       NFSENTMUN municient,
       NFSENTMUNCOD codmunicient,
       NFSENTNUM numeroent,
       NFSENTUFE ufent,
       '' usualt,
       NFSCARCODNOM codcarro,
       NFSCAREMP empcarro,
       NFSCARPLA placacar,
       0 descfinan,
       SNEEMPCOD empser,
       SNESER sernfe,
       2 finnfe,
       0 icmsestdes,
       NF novanf

  from TBS067 (nolock)
 where TBS067.NFSEMPCOD=2 --and TBS067.NFSDATEMI between '20180101' and '20180131'
       and TBS067.UFESIG='SP'
       and TBS067.NFSNUM between 6194 and 6286
       and exists(select '' from TBS0671 (nolock)
                   where TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM and TBS0671.NFSPERICMS > 0 and right(TBS0671.NFSCST,3)<>'500')
       and exists(select '' from TBS080 (nolock)
                   where TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM and TBS080.ENFSIT=6 and TBS080.ENFFINEMI=1)

select * from TBS025 (nolock) where PARCHV=1255


-- registro TBS0671

select top 1 * from TBS0671 (nolock) where NFSNUM=10198

begin tran
insert into TBS0671 
select 2 empresa,
       NF nf,
       NFSITE item,
       PROEMPCOD emppro,
       PROCOD produto,
       NFSPRODES descpro,
       NFSQTD qtde,
       NFSUNI unidade,
       0 emb,
       0 preco,
       0 descitem,
       LESEMPCOD empest,
       LESCOD locest,
       0 tesemp,
       0 codtes,
       'N' movest,
       'N' comissao,
       'N' duplicata,
       0 perbcicms,
       NFSPERICMS pericms,
       Left(NFSCST,1)+'00' cst,
       'N' excecao,
       '5.102' cfop, --NFSCFOP cfop,
       0 custo,
       0 comissao,
       0 nfdev,
       0 qtdedev,
       0 precodev,
       0 frete,
       0 seguro,
       0 descitem,
       0 perbcicmsisent,
       0 pericmisent,
       NFSFINAQUITE finaquitem,
       0 mva,
       0 regraicms,
       0 perbcicmsst,
       0 pericmsst,
       NFSTIPOPEITE tipopeitem,
       NFSNUMITECOM itemcompra,
       NFSNUMPEDCOM pedcompra,
       NFSPROCLI procli,
       0 embdev,
       0 pesbruto,
       0 pesliqui,
       NFSPROPESAVEL pesavel,
       0 qtdeaux,
       0 qtdepes,
       NFSREDBCICMS redbcicms,
       0 redbcicmsst,
       'N' contavenda,
       0 empregicms,
       0 regicms,
       '' unidev,
       TBS0671.SNEEMPCOD empser,
       TBS0671.SNESER serie,
       dbo.NFSTOTITE(TBS0671.NFSEMPCOD, TBS0671.NFSNUM, TBS0671.SNEEMPCOD, TBS0671.SNESER, TBS0671.NFSITE) bcicmscomple,
       0 bcicmsstcomple,
       0 totitemcomple,
       0 infadi

  from TBS0671 (nolock)
       inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.NFSNUM=TBS0671.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS0671.SNESER and TBS080.ENFEMPCOD=TBS0671.NFSEMPCOD and TBS080.ENFNUM=TBS0671.NFSNUM
 where TBS0671.NFSEMPCOD=2 --and TBS067.NFSDATEMI between '20180101' and '20180131'
       and TBS067.NFSNUM between 6194 and 6286
       and TBS080.ENFSIT=6 and TBS0671.NFSPERICMS > 0 and TBS067.UFESIG='SP' and ENFFINEMI=1 and
       right(TBS0671.NFSCST,3)<>'500'


-- números nf

select * from TBS104 (nolock) order by SNEDATALT desc


select * from TBS067 (nolock) where NFSTIP='C' and NFSNUM=6291

select * from TBS080 (nolock) where ENFNUM=6291 and ENFFINEMI=2

select * from TBS080 (nolock) where ENFDATEMI='20180227' and ENFFINEMI=2

update TBS080 set SNEEMPCOD=2, SNESER=1 where ENFDATEMI='20180227' and ENFFINEMI=2


select *
  from TBS0671 (nolock)
       inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.NFSNUM=TBS0671.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS0671.SNESER and TBS080.ENFEMPCOD=TBS0671.NFSEMPCOD and TBS080.ENFNUM=TBS0671.NFSNUM
 where TBS0671.NFSEMPCOD=2 and TBS067.NFSDATEMI='20180127' and TBS080.ENFSIT=1 and TBS0671.NFSPERICMS > 0 and TBS067.UFESIG='SP' and ENFFINEMI=2 and
       right(TBS0671.NFSCST,3)='500'

select COUNT(*) from TBS0671 (nolock) where NFSEMPCOD=2 and NFSNUM between 6294 and 6543

begin tran
delete TBS0671 where NFSEMPCOD=2 and NFSNUM between 6322 and 6574
commit tran

select *
  from TBS067 (nolock)
 where TBS067.NFSEMPCOD=2 and TBS067.NFSDATEMI='20180227' and TBS067.NFSTIP='C' and TBS067.NFSFINNFE=2 and
       not exists(select '' from TBS0671 (nolock)
                   where TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.SNEEMPCOD=TBS067.SNEEMPCOD and TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM)

begin tran
delete TBS067
 where TBS067.NFSEMPCOD=2 and TBS067.NFSDATEMI='20180227' and TBS067.NFSTIP='C' and TBS067.NFSFINNFE=2 and
       not exists(select '' from TBS0671 (nolock)
                   where TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.SNEEMPCOD=TBS067.SNEEMPCOD and TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM)

select *
  from TBS080 (nolock)
 where TBS080.ENFEMPCOD=2 and TBS080.ENFDATEMI='20180227' and TBS080.ENFFINEMI=2 and
       not exists(select '' from TBS067 (nolock)
                   where TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.SNESER=TBS067.SNESER and TBS080.SNEEMPCOD=TBS067.SNEEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM)

begin tran
update TBS080 set ENFEMPCOD=9
 where TBS080.ENFEMPCOD=2 and TBS080.ENFDATEMI='20180227' and TBS080.ENFFINEMI=2 and
       not exists(select '' from TBS067 (nolock)
                   where TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.SNESER=TBS067.SNESER and TBS080.SNEEMPCOD=TBS067.SNEEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM)
select *
  from TBS0671 (nolock)
       inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.NFSNUM=TBS0671.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS0671.SNESER and TBS080.ENFEMPCOD=TBS0671.NFSEMPCOD and TBS080.ENFNUM=TBS0671.NFSNUM
 where TBS0671.NFSEMPCOD=2 and TBS067.NFSDATEMI between '20180101' and '20180131' and TBS080.ENFSIT=6 and TBS0671.NFSPERICMS > 0 and TBS067.UFESIG='SP' and ENFFINEMI=1 and
       right(TBS0671.NFSCST,3)<>'500' and NFSREDBCICMS > 0

-- NFSVALICMSCOM = NFSBASICMSCOM * NFSPERICMS / 100

drop function NFSVALICMSCOM
go

create function NFSVALICMSCOM(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select NFSBASICMSCOM * NFSPERICMS /100 from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

select *
  from TBS0671 (nolock)
       inner join TBS067 (nolock) on TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
 where TBS067.NFSEMPCOD=2 and TBS067.NFSDATEMI='20180227' and TBS067.NFSTIP='C' and TBS067.NFSFINNFE=2

select NFSCST,Left(NFSCST,1)+'00'
  from TBS0671 (nolock)
       inner join TBS067 (nolock) on TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
 where TBS067.NFSEMPCOD=2 and TBS067.NFSDATEMI='20180227' and TBS067.NFSTIP='C' and TBS067.NFSFINNFE=2

begin tran
update TBS0671 set NFSCST=Left(NFSCST,1)+'00'
  from TBS0671 (nolock)
       inner join TBS067 (nolock) on TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
 where TBS067.NFSEMPCOD=2 and TBS067.NFSDATEMI='20180227' and TBS067.NFSTIP='C' and TBS067.NFSFINNFE=2


-- fora do estado

-- NFSVALICMSSTCOM = round(NFSBASICMSSTCOM * NFSPERICMSST / 100,2)

drop function NFSVALICMSSTCOM
go

create function NFSVALICMSSTCOM(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select round(NFSBASICMSSTCOM * NFSPERICMSST / 100,2) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go


select *
  from TBS067 (nolock)
 where TBS067.NFSEMPCOD=2 and TBS067.NFSDATEMI between '20180101' and '20180131' and TBS067.UFESIG<>'SP'
       and exists(select '' from TBS0671 (nolock)
                   where TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM and TBS0671.NFSPERICMS > 0)
       and exists(select '' from TBS080 (nolock)
                   where TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM and TBS080.ENFSIT=6 and TBS080.ENFFINEMI=1)


select distinct CLIINDIE from TBS002 (nolock)


-- para fora do estado, para clientes não contribuinte do ICMS
select ENFESTDES,
       TBS067.UFESIG,
       dbo.NFSTOTITE(TBS0671.NFSEMPCOD, TBS0671.NFSNUM, TBS0671.SNEEMPCOD, TBS0671.SNESER, TBS0671.NFSITE) totalitem,
--       dbo.NFSTOTITEST(TBS0671.NFSEMPCOD, TBS0671.NFSNUM, TBS0671.SNEEMPCOD, TBS0671.SNESER, TBS0671.NFSITE) totalitemst,
       NFSPERICMS,
       NFSPERICMSST,
       *
  from TBS0671 (nolock)
       inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.NFSNUM=TBS0671.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS0671.SNESER and TBS080.ENFEMPCOD=TBS0671.NFSEMPCOD and TBS080.ENFNUM=TBS0671.NFSNUM
       inner join TBS010 (nolock) on TBS010.PROCOD=TBS0671.PROCOD
       inner join TBS002 (nolock) on TBS002.CLICOD=TBS067.NFSCLICOD
 where TBS0671.NFSEMPCOD=2 and TBS067.NFSDATEMI between '20180101' and '20180131' and TBS080.ENFSIT=6 and TBS0671.NFSPERICMS > 0 and TBS067.UFESIG<>'SP' and ENFFINEMI=1
       and TBS0671.PROCOD in('21I073','21J665','21N029','198','200','21I011','21N126','FLUKE114','TRE03NB','ET1400','21I013','21I014')
       and CLIINDIE=9

select TBS0671.PROCOD,
       TBS0671.NFSPRODES,
       TBS067.UFESIG,
       TBS010.PROCLAFIS
--  into #tab
  from TBS0671 (nolock)
       inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.NFSNUM=TBS0671.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS0671.SNESER and TBS080.ENFEMPCOD=TBS0671.NFSEMPCOD and TBS080.ENFNUM=TBS0671.NFSNUM
       inner join TBS010 (nolock) on TBS010.PROCOD=TBS0671.PROCOD
 where TBS0671.NFSEMPCOD=2 and TBS067.NFSDATEMI between '20180101' and '20180131' and TBS080.ENFSIT=6 and TBS0671.NFSPERICMS > 0 and TBS067.UFESIG<>'SP' and ENFFINEMI=1
--       and TBS0671.NFSPERICMSST > 0



select TBS067.UFESIG,
       TBS010.PROCLAFIS,
       TBS010.PROCOD,
       TBS010.PRODES
--  into #tab
  from TBS0671 (nolock)
       inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.NFSNUM=TBS0671.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS0671.SNESER and TBS080.ENFEMPCOD=TBS0671.NFSEMPCOD and TBS080.ENFNUM=TBS0671.NFSNUM
       inner join TBS010 (nolock) on TBS010.PROCOD=TBS0671.PROCOD
 where TBS0671.NFSEMPCOD=2 and TBS067.NFSDATEMI between '20180101' and '20180131' and TBS080.ENFSIT=6 and TBS0671.NFSPERICMS > 0 and TBS067.UFESIG<>'SP' and ENFFINEMI=1
--       and TBS0671.NFSPERICMSST > 0
 group by TBS067.UFESIG, TBS010.PROCLAFIS, TBS010.PROCOD, TBS010.PRODES

select * from TBS0921 (nolock)




-- registro TBS067 

select getdate()
select convert(date,getdate(),112)
select convert(char(19),getdate(),131)
select convert(char(8),getdate(),114)

select * from TBS067 (nolock) where NFSNUM=10198

-- registra números nf

declare @seq int

select @seq = SNENUM from TBS104 (nolock) where SNEEMPCOD=2 and SNESER=1 and SNETIP='SG'

select NFSEMPCOD,SNEEMPCOD,SNESER,NFSNUM,@seq + row_number() over (order by TBS067.NFSNUM) nf
  into #tab
  from TBS067 (nolock)
 where TBS067.NFSEMPCOD=2 and
       --TBS067.NFSDATEMI between '20180101' and '20180131' and
       and TBS067.UFESIG<>'SP'
       and TBS067.NFSNUM between 6194 and 6286
       and exists(select '' from TBS0671 (nolock)
                   where TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM and TBS0671.NFSPERICMS > 0)
       and exists(select '' from TBS080 (nolock)
                   where TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM and TBS080.ENFSIT=6 and TBS080.ENFFINEMI=1)

select * from #tab

update TBS067 set NF=0 where NF is null

update TBS067 set NF=(select nf from #tab where #tab.NFSEMPCOD=TBS067.NFSEMPCOD and #tab.SNEEMPCOD=TBS067.SNEEMPCOD and #tab.SNESER=TBS067.SNESER and #tab.NFSNUM=TBS067.NFSNUM)
  from TBS067 (nolock)
 where TBS067.NFSEMPCOD=2 and
       --TBS067.NFSDATEMI between '20180101' and '20180131' and
       and TBS067.UFESIG<>'SP'
       and TBS067.NFSNUM between 6194 and 6286
       and exists(select '' from TBS0671 (nolock)
                   where TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM and TBS0671.NFSPERICMS > 0)
       and exists(select '' from TBS080 (nolock)
                   where TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM and TBS080.ENFSIT=6 and TBS080.ENFFINEMI=1)

update TBS104 set SNENUM=(select max(NFSNUM) from TBS067 (nolock)) where SNEEMPCOD=2 and SNESER=1 and SNETIP='SG'


insert into TBS067

--select top 1 * from TBS067 (nolock)

select 2 empresa,
       NF nf,
--       1 tipodoc,
--       55 modelo,
--       1 seriesis,
       convert(date,getdate(),112) emissao,
       convert(char(10),getdate(),103)+' '+convert(char(8),getdate(),114)+' PADRAO' usuario,
--       1 danfe,
       '17530101' saida,
       '' hora,
       TBS067.NFSCAN cancelada,
       TBS067.NFSDEV devolvida,
       TBS067.NFSDATCAN datacan,
       TBS067.NFSUSUCAN usucan,
       TBS067.SEREMPCOD empsersis,
       TBS067.SERCOD seriesis,
       TBS067.NFSCLIEMP empcli,
       TBS067.NFSCLICOD cliente,
       TBS067.NFSCLINOM razaosoc,
       NFSREQCOD codiogreq,
       NFSREQNOM nomereq,
       VENEMPCOD empvendedor,
       VENCOD codigoven,
       NFSVENCOM comissao,
       NFSVENPDC percentcom,
       UFESIG uf,
       CPGEMPCOD emppag,
       0 codpag,
       'N' geradup,
       TRNEMPCOD emptransp,
       0 codtransp,
       0 proximanf,
       9 tipofre,
       'N' iseicms,
       NFSREQCDC centrocus,
       NFSPEDCLI pedcliente,
       0 nfanterior,
       0 frete,
       0 seguro,
       0 despesas,
       'REF. A NF ' + Ltrim(str(NFSNUM,6)) + ' SERIE ' + Ltrim(str(SNESER,3)) + ' DE ' + convert(char(10),NFSDATEMI,103),
       'C' tiponf,
       NFSNUM nforigem,
       NFSDATEMI dataorigem,
       0 totcomple,
       0 pesobru,
       0 pesoliq,
       0 volumes,
       '' especie,
       '' marca,
       '' numero,
       '' transfiscal,
       0 mes,
       0 ano,
       0 desconto,
       NFSLOCENT entrega,
       NFSLOCCOB cobranca,
       0 valortransf,
       0 complebcicms,
       0 valorcomple,
       0 valorcomplepro,
       0 valorcompletot,
       NFSFINAQU finaquis,
       NFSTIPOPE tipoope,
       0 desctot,
       NFSTIPENT tipentre,
       NFSCLIENDCOD codendere,
       NFSCOBBAI bairrocob,
       NFSCOBCPL complecob,
       NFSCOBEND endercob,
       NFSCOBMUN municob,
       NFSCOBMUNCOD codmunicob,
       NFSCOBNUM numerocob,
       NFSCOBUFE ufcob,
       NFSENDCOBCOD codendercob,
       NFSENDENTCOD codenderent,
       NFSENTBAI bairroent,
       NFSENTCGC cnpjent,
       NFSENTCPF cpfent,
       NFSENTCPL compleent,
       NFSENTEND enderent,
       NFSENTMUN municient,
       NFSENTMUNCOD codmunicient,
       NFSENTNUM numeroent,
       NFSENTUFE ufent,
       '' usualt,
       NFSCARCODNOM codcarro,
       NFSCAREMP empcarro,
       NFSCARPLA placacar,
       0 descfinan,
       SNEEMPCOD empser,
       SNESER sernfe,
       2 finnfe,
       NFSICMSINTDES icmsestdes,
       NF novanf

  from TBS067 (nolock)
 where TBS067.NFSEMPCOD=2
       --and TBS067.NFSDATEMI between '20180101' and '20180131'
       and TBS067.NFSNUM between 6194 and 6286
       and TBS067.UFESIG<>'SP'
       and exists(select '' from TBS0671 (nolock)
                   where TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM and TBS0671.NFSPERICMS > 0)
       and exists(select '' from TBS080 (nolock)
                   where TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM and TBS080.ENFSIT=6 and TBS080.ENFFINEMI=1)
--       and exists(select '' from TBS0671 (nolock)
--                   where TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM and TBS0671.NFSPERICMS > 0
--                         and PROCOD in('21I073','21J665','21N029','198','200','21I011','21N126','FLUKE114','TRE03NB','ET1400','21I013','21I014'))



begin tran
insert into TBS0671 

select 2 empresa,
       NF nf,
       NFSITE item,
       PROEMPCOD emppro,
       PROCOD produto,
       NFSPRODES descpro,
       NFSQTD qtde,
       NFSUNI unidade,
       0 emb,
       0 preco,
       0 descitem,
       LESEMPCOD empest,
       LESCOD locest,
       0 tesemp,
       0 codtes,
       'N' movest,
       'N' comissao,
       'N' duplicata,
       0 perbcicms,
       NFSPERICMS pericms,
       Left(NFSCST,1)+'00' cst,
       'N' excecao,
       NFSCFOP cfop,
--       '6.102' cfop, --NFSCFOP cfop,
       0 custo,
       0 comissao,
       0 nfdev,
       0 qtdedev,
       0 precodev,
       0 frete,
       0 seguro,
       0 descitem,
       0 perbcicmsisent,
       0 pericmisent,
       NFSFINAQUITE finaquitem,
       0 mva,
       0 regraicms,
       0 perbcicmsst,
       case NFSCFOP when '6.108' then 0 else (select UFEICMPRO from TBS001 (nolock) where TBS001.UFESIG=TBS067.UFESIG)-NFSPERICMS end pericmsst,
       NFSTIPOPEITE tipopeitem,
       NFSNUMITECOM itemcompra,
       NFSNUMPEDCOM pedcompra,
       NFSPROCLI procli,
       0 embdev,
       0 pesbruto,
       0 pesliqui,
       NFSPROPESAVEL pesavel,
       0 qtdeaux,
       0 qtdepes,
       NFSREDBCICMS redbcicms,
       NFSREDBCICMSST redbcicmsst,
       'N' contavenda,
       0 empregicms,
       0 regicms,
       '' unidev,
       TBS0671.SNEEMPCOD empser,
       TBS0671.SNESER serie,
       dbo.NFSTOTITE(TBS0671.NFSEMPCOD, TBS0671.NFSNUM, TBS0671.SNEEMPCOD, TBS0671.SNESER, TBS0671.NFSITE) bcicmscomple,
       dbo.NFSTOTITE(TBS0671.NFSEMPCOD, TBS0671.NFSNUM, TBS0671.SNEEMPCOD, TBS0671.SNESER, TBS0671.NFSITE) bcicmsstcomple,
       0 totitemcomple,
       0 infadi

  from TBS0671 (nolock)
       inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.NFSNUM=TBS0671.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS0671.SNESER and TBS080.ENFEMPCOD=TBS0671.NFSEMPCOD and TBS080.ENFNUM=TBS0671.NFSNUM
 where TBS0671.NFSEMPCOD=2 --and TBS067.NFSDATEMI between '20180101' and '20180131'
       and TBS067.NFSNUM between 6194 and 6286
       and TBS080.ENFSIT=6 and TBS0671.NFSPERICMS > 0 and TBS067.UFESIG<>'SP' and ENFFINEMI=1
       -- and right(TBS0671.NFSCST,3)<>'500'


-- registro TBS080
insert into TBS080 

--select top 1 * from TBS080 (nolock)
select 2 empresa,
       NF nf,
       1 tipodoc,
       55 modelo,
       1 seriesis,
       convert(date,getdate(),112) emissao,
       1 danfe,
       2 pagto,
       1 formaemi,
       (select case CLITIPPES when 'J' then CLICGC else CLICPF end from TBS002 (nolock) where TBS002.CLICOD=TBS067.NFSCLICOD) documento,
       2 finalidade,
       TBS067.NFSCLINOM razaoSocial,
       0 valor,
       '' chave,
       'N' impresso,
       TBS067.NFSCLICOD cliente,
       1 situacao,
       '' arquivo,
       0 recibo,
       0 protocolo,
       '' digest,
       '' justificativa,
       'N' email,
       '' tipent,
       TBS067.UFESIG estado,
       TBS067.VENCOD vendedor,
       1 ambiente,
       '17530101' processamento,
       0 protcan,
       '17530101' datahoracan,
       0 protinut,
       '' justinut,
       '17530101' datahorainut,
       2 empserie,
       1 serie

  from TBS067 (nolock)
 where TBS067.NFSEMPCOD=2 --and TBS067.NFSDATEMI between '20180101' and '20180131'
       and TBS067.UFESIG<>'SP'
       and TBS067.NFSNUM between 6194 and 6286
       and exists(select '' from TBS0671 (nolock)
                   where TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM and TBS0671.NFSPERICMS > 0)
       and exists(select '' from TBS080 (nolock)
                   where TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM and TBS080.ENFSIT=6 and TBS080.ENFFINEMI=1)



-- nf com ST

select *
  from TBS067 (nolock)
       inner join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM
 where TBS067.NFSEMPCOD=2 and TBS067.NFSDATEMI between '20180301' and '20180326' and TBS080.ENFSIT=6 and TBS0671.NFSPERICMS > 0 and TBS067.UFESIG<>'SP' and ENFFINEMI=1 and
       TBS0671.NFSPERICMSST > 0

select *
  from TBS067 (nolock)
       inner join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM
 where TBS067.NFSEMPCOD=2 and TBS067.NFSDATEMI between '20180326' and '20180326' and TBS080.ENFSIT=1 and TBS0671.NFSPERICMS > 0 and TBS067.UFESIG<>'SP' and ENFFINEMI=2

begin tran
update TBS0671 set NFSBASICMSSTCOM=0
--select *
  from TBS067 (nolock)
       inner join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM
 where TBS067.NFSEMPCOD=2 --and TBS067.NFSDATEMI between '20180326' and '20180326'
       and TBS080.ENFSIT=1 and TBS0671.NFSPERICMS > 0 and TBS067.UFESIG<>'SP' and ENFFINEMI=2
       and NFSCFOP='6.108' and NFSBASICMSSTCOM > 0



select *
  from TBS067 (nolock)
       inner join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM
 where TBS067.NFSEMPCOD=2 and TBS067.NFSDATEMI between '20180326' and '20180326' and TBS080.ENFSIT=1 and TBS0671.NFSPERICMS > 0 and TBS067.UFESIG<>'SP' and ENFFINEMI=2
       and NFSCFOP='6.108'
       and PROCOD in('21I073','21J665','21N029','198','200','21I011','21N126','FLUKE114','TRE03NB','ET1400','21I013','21I014')


select TBS067.UFESIG,TBS067.NFSNUM,PROCOD
  from TBS067 (nolock)
       inner join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM
       inner join TBS080 (nolock) on TBS080.SNESER=TBS067.SNESER and TBS080.ENFEMPCOD=TBS067.NFSEMPCOD and TBS080.ENFNUM=TBS067.NFSNUM
 where TBS067.NFSEMPCOD=2 --and TBS067.NFSDATEMI between '20180326' and '20180326'
       and TBS080.ENFSIT=1 and TBS0671.NFSPERICMS > 0 and TBS067.UFESIG<>'SP' and ENFFINEMI=2
       --and NFSCFOP='6.108'
       and TBS067.NFSNUM between 7062 and 7073
       and PROCOD in('21I073','21J665','21N029','198','200','21I011','21N126','FLUKE114','TRE03NB','ET1400','21I013','21I014')
GROUP BY TBS067.UFESIG,TBS067.NFSNUM,PROCOD
