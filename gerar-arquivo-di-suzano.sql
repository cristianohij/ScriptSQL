-- registro 01 - cabeçalho

if object_id('SIBD..CABECALHO') is not null
   begin
      drop table CABECALHO
   end

select '01' as 'TipoDeRegistro',
       T1.EMPCGC as 'CNPJDoDistribuidor',
       subString(convert(char(8),getDate(),112)+replace(convert(char(5),getDate(),108),':',''),1,12) as 'DataEHoraDaGeracaoDoDocumento',
       '03' as 'VersaoDoLayout',
       '430' as 'CodigoDaIndustria',
       subString(T1.EMPNOM,1,50) as 'RazaoSocialDoDistribuidor',
       space(217) as 'Filler'
       into CABECALHO
  from TBS023 as T1 (nolock)

-- saida para arquivos

select T1.TipoDeRegistro+T1.CNPJDoDistribuidor+T1.DataEHoraDaGeracaoDoDocumento+T1.VersaoDoLayout+T1.CodigoDaIndustria+T1.RazaoSocialDoDistribuidor+T1.Filler from SIBD..CABECALHO as T1 (nolock)

-- nome do arquivo

select 'DISuzano'+T1.CNPJDoDistribuidor+convert(char(8),getDate(),112)+replace(convert(char(8),getDate(),108),':','') from SIBD..CABECALHO as T1 (nolock)


--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- registro 04 - vendas

-- vendas corporativo

-- tabela física

if object_id('SIBD..VENDAS') is not null
   begin
      drop table VENDAS
   end

declare @datai char(8),@dataf char(8)

set @datai = '20140901'
set @dataf = '20140930'

select '04' as 'TipoDeRegistro',
       left(Ltrim(str(T1.NFSNUM,20))+replicate(' ',20),20) as 'NumeroDaNotaFiscal',
       right(replicate('0',3)+rtrim(convert(char(3),T2.SNESER)),3) as 'SerieDaNotaFiscal',
       left(rtrim(T1.PROCOD)+replicate(' ',20),20) as 'CodigoDoProduto',
       '04' as 'TipoDeCodigoDeProduto',
       T4.DISUNIMED as 'CodigoDaUnidadeDeMedida',
       T1.NFSQTD * T1.NFSQTDEMB as 'QuantidadeVendida',
       'N' as 'Bonificacao',
       dbo.NFSPRELIQ(T1.NFSEMPCOD,T1.NFSNUM,T1.SNEEMPCOD,T1.SNESER,T1.NFSITE)/T1.NFSQTDEMB as 'ValorUnitario',
       dbo.NFSTOTPRO(T1.NFSEMPCOD,T1.NFSNUM,T1.SNEEMPCOD,T1.SNESER,T1.NFSITE) as 'ValorTotalBruto',
       dbo.NFSTOTITEST(T1.NFSEMPCOD,T1.NFSNUM,T1.SNEEMPCOD,T1.SNESER,T1.NFSITE) as 'ValorTotalLiquido',
       space(24) as 'Filler',
       'COM' as 'CategoriaDaVenda',
       case when T2.NFSCAN = 'S' then '03' else '01' end as 'TipoDaNotaFiscal',
       space(162) as 'Filler2',
       space(8) as 'DataDaEmissao',
       space(2) as 'CupomCancelado'
       into VENDAS
  from TBS0671 as T1 (nolock)
          right join TBS067 as T2 (nolock)
             on T2.NFSEMPCOD=T1.NFSEMPCOD and T2.SNEEMPCOD=T1.SNEEMPCOD and T2.SNESER=T1.SNESER and T2.NFSNUM=T1.NFSNUM
          Left join TBS042 as T3 (noLock) on T3.TESCOD=T1.TESCOD
          right join MSL005 as T4 (nolock) on T4.PROCOD=T1.PROCOD
 where T2.NFSDATEMI between @datai and @dataf and
       T2.NFSTIP='N' and
       T3.TESCNTVEN='S' and
       T2.NFSCLINOM not Like('BEST BAG%') and
       T2.NFSCLINOM not Like('BEST OFFICE%') and
       T2.NFSCLINOM not Like('MISASPEL%') and
       T2.NFSCLINOM not Like('%PAPELYNA%') and
       T2.NFSCLINOM not Like('TANBY%')

 order by T1.NFSNUM

-- vendas loja

-- lista de cupons cancelados

if object_id('SIBD..CUPOMCANCELADO') is not null
   begin
      drop table CUPOMCANCELADO
   end

declare @datai char(8),@dataf char(8)

set @datai = '20140901'
set @dataf = '20140930'

select T1.M2_EMPCOD as 'Empresa',
       T1.M2_LOJ as 'Loja',
       T1.M2_CXA as 'Caixa',
       T1.M2_DAT as 'DataDaEmissao',
       T1.M2_HOR as 'HoraDaEmissao',
       T1.M2_NUMDOC as 'NumeroDoCupom',
       T1.M2_NUMPED as 'NumeroDoPedido',
       T1.M2_TIPDOC as 'TipoDoDocumento',
       T1.M2_TIPREG as 'TipoDoRegistro',
       T1.M2_PROCOD as 'CodigoDoProduto',
       T1.M2_NUMORDITE as 'NumeroDeOrdemDoItem',
       T1.M2_FINVEN as 'FinalizadorDaVenda',
       T1.M2_CODTIT as 'CodigoDoTitular'
       into CUPOMCANCELADO
  from MSL002 as T1 (nolock)
 where T1.M2_DAT between @datai and @dataf and T1.M2_TIPREG='04'

insert into VENDAS
select '04' as 'TipoDeRegistro',
       left(Ltrim(str(T1.M2_NUMDOC,20))+replicate(' ',20),20) as 'NumeroDaNotaFiscal',
       'CUP' as 'SerieDaNotaFiscal',
       left(rtrim(T1.M2_PROCOD)+replicate(' ',20),20) as 'CodigoDoProduto',
       '04' as 'TipoDeCodigoDeProduto',
       T2.DISUNIMED as 'CodigoDaUnidadeDeMedida',
       T1.M2_QTD as 'QuantidadeVendida',
       'N' as 'Bonificacao',
       T1.M2_VALTOT / T1.M2_QTD as 'ValorUnitario',
       T1.M2_VALTOT as 'ValorTotalBruto',
       T1.M2_VALTOT - T1.M2_DESITE as 'ValorTotalLiquido',
       space(24) as 'Filler',
       'COM' as 'CategoriaDaVenda',
       '01' as 'TipoDaNotaFiscal',
       space(162) as 'Filler2',
       convert(char(8),T1.M2_DAT,112) as 'DataDaEmissao',
       isnull((select '03' from CUPOMCANCELADO as T3
                where T3.Empresa=T1.M2_EMPCOD and T3.Loja=T1.M2_LOJ and T3.Caixa=T1.M2_CXA and T3.DataDaEmissao=T1.M2_DAT and T3.HoraDaEmissao=T1.M2_HOR and
                      T3.NumeroDoCupom=T1.M2_NUMDOC and T3.NumeroDoPedido=T1.M2_NUMPED and T3.TipoDoDocumento=T1.M2_TIPDOC and T3.TipoDoRegistro=T1.M2_TIPREG and 
                      T3.CodigoDoProduto=T1.M2_PROCOD and T3.NumeroDeOrdemDoItem=T1.M2_NUMORDITE and T3.FinalizadorDaVenda=T1.M2_FINVEN and
                      T3.CodigoDoTitular=T1.M2_CODTIT),'01')
          as 'CupomCancelado'
  from MSL002 as T1 (nolock) right join MSL005 as T2 (nolock) on T2.PROCOD=T1.M2_PROCOD 
 where T1.M2_DAT between @datai and @dataf and
       T1.M2_TIPREG='01' and
       T1.M2_REGCAN<>'T'
 order by T1.M2_NUMDOC


-- saida para arquivo texto

select T1.TipoDeRegistro+T1.NumeroDaNotaFiscal+T1.SerieDaNotaFiscal+T1.CodigoDoProduto+T1.TipoDeCodigoDeProduto+T1.CodigoDaUnidadeDeMedida+right(replicate('0',15)+ltrim(str(sum(T1.QuantidadeVendida)*1000,15)),15)+T1.Bonificacao+right(replicate('0',15)+ltrim(str(avg(T1.ValorUnitario)*1000,15)),15)+right(replicate('0',15)+ltrim(str(sum(T1.ValorTotalBruto)*1000,15)),15)+right(replicate('0',15)+ltrim(str(sum(T1.ValorTotalLiquido)*1000,15)),15)+T1.Filler+T1.CategoriaDaVenda+T1.TipoDaNotaFiscal+T1.Filler2 as 'REGISTRO' from SIBD..VENDAS as T1 (nolock) group by T1.TipoDeRegistro,T1.NumeroDaNotaFiscal,T1.SerieDaNotaFiscal,T1.CodigoDoProduto,T1.TipoDeCodigoDeProduto,T1.CodigoDaUnidadeDeMedida,T1.Bonificacao,T1.Filler,T1.CategoriaDaVenda,T1.TipoDaNotaFiscal,T1.Filler2


--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- registro 05 - estoque

if object_id('SIBD..ESTOQUE') is not null
   begin
      drop table ESTOQUE
   end

select '05' as 'TipoDeRegistro',
       left(rtrim(T1.PROCOD)+replicate(' ',20),20) as 'CodigoDoProduto',
       convert(char(8),getdate(),112) as 'DataDoEstoque',
       (select sum(ESTQTDATU) from TBS032 as T2 (nolock) where T2.ESTLOC in(1,2) and T2.PROCOD=T1.PROCOD) as 'QuantidadeDoEstoque',
       T1.DISUNIMED as 'CodigoDaUnidadeDeMedida',
       '04' as 'TipoDeCodigoDeProduto',
       replicate('0',15) as 'QuantidadeDoEstoqueEmTransito',
       space(237) as 'Filler'
       into ESTOQUE
  from MSL005 as T1 (nolock)

-- saida para arquivo

select T1.TipoDeRegistro+T1.CodigoDoProduto+T1.DataDoEstoque+right(replicate('0',15)+ltrim(str(T1.QuantidadeDoEstoque*1000,15)),15)+T1.CodigoDaUnidadeDeMedida+T1.TipoDeCodigoDeProduto+T1.QuantidadeDoEstoqueEmTransito+T1.Filler from SIBD..ESTOQUE as T1 (nolock)


--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- registro 06 - notas fiscais

if object_id('SIBD..NOTASFISCAIS') is not null
   begin
      drop table NOTASFISCAIS
   end

declare @prefixo char(3)

set @prefixo=(select PARVAL from TBS025 (nolock) where PARCHV=1059)

-- vendas corporativo

select '06' as 'TipoDeRegistro',
       left(Ltrim(str(T1.NumeroDaNotaFiscal,20))+replicate(' ',20),20) as 'NumeroDaNotaFiscal',
       T1.SerieDaNotaFiscal as 'SerieDaNotaFiscal',
       convert(char(8),T2.NFSDATEMI,112) as 'DataDaEmissaoDaNotaFiscal',
       case when T2.NFSCAN = 'S' then '03' else '01' end as 'TipoDaNotaFiscal',
       space(11) as 'Filler',
       left(Ltrim(str(T2.NFSCLICOD,14))+replicate(' ',14),14) as 'CodigoDoCliente',
       '01' as 'TipoDeFaturamento',
       case when T2.NFSTIPFRE = 1 then 'FOB' else 'CIF' end as 'TipoDeFrete',
       right(
          replicate('0',3)
          +
          rtrim(
             convert(
                char(3),
                isnull(
                   datediff(
                      day,
                      (
                         select top 1 T3.CREDATEMI
                           from TBS056 as T3 (nolock)
                          where T3.CRETITORI = 'A' and
                                T3.PFXCOD=@prefixo and
                                T3.CRETIT = T2.NFSNUM and
                                T3.CLICOD = T2.NFSCLICOD
                      )
                      ,
                      (
                         select max(T4.CREDATVENREA)
                           from TBS056 as T4 (nolock)
                          where T4.CRETITORI = 'A' and
                                T4.PFXCOD=@prefixo and
                                T4.CRETIT = T2.NFSNUM and
                                T4.CLICOD = T2.NFSCLICOD
                      )
                   )
                   /
                   (
                      select count(*)
                        from TBS056 as T5 (nolock)
                       where T5.CRETITORI = 'A' and
                             T5.PFXCOD=@prefixo and
                             T5.CRETIT = T2.NFSNUM and
                             T5.CLICOD = T2.NFSCLICOD
                   )
                   ,
                   '0'
                )
             )
          )
          ,
          3
       ) as 'PrazoDePagamento',
       'SP' as 'UFDeOrigemDaMercadoria',
       (select subString(T6.EMPCEP,1,5) + subString(T6.EMPCEP,7,3) from TBS023 as T6 (nolock) where T6.EMPCOD=1) as 'CEPDeOrigem',
       T2.UFESIG as 'UFDeDestinoDaMercadoria',
       (select subString(T7.CLICEP,1,5) from TBS002 as T7 (nolock)
         where T7.CLIEMPCOD = T2.NFSCLIEMP and T7.CLICOD = T2.NFSCLICOD) as 'CEPDeDestino',
       space(212) as 'Filler2'
       into NOTASFISCAIS
  from VENDAS as T1
          Left join TBS067 as T2 (nolock) on T2.SNESER=convert(int,T1.SerieDaNotaFiscal) and T2.NFSNUM=T1.NumeroDaNotaFiscal
 where T1.SerieDaNotaFiscal<>'CUP' and
       T2.NFSCLINOM not Like('BEST BAG%') and
       T2.NFSCLINOM not Like('BEST OFFICE%') and
       T2.NFSCLINOM not Like('MISASPEL%') and
       T2.NFSCLINOM not Like('%PAPELYNA%') and
       T2.NFSCLINOM not Like('TANBY%')
 group by T1.NumeroDaNotaFiscal,
       T1.SerieDaNotaFiscal,
       T2.NFSDATEMI,
       T2.NFSCAN,
       T2.NFSCLIEMP,
       T2.NFSCLICOD,
       T2.NFSTIPFRE,
       T2.NFSNUM,
       T2.UFESIG


-- vendas loja

insert into NOTASFISCAIS
select '06' as 'TipoDeRegistro',
       T1.NumeroDaNotaFiscal as 'NumeroDaNotaFiscal',
       T1.SerieDaNotaFiscal as 'SerieDaNotaFiscal',
       T1.DataDaEmissao as 'DataDaEmissaoDaNotaFiscal',
       T1.CupomCancelado as 'TipoDaNotaFiscal',
       space(11) as 'Filler',
       '1' as 'CodigoDoCliente',
       '01' as 'TipoDeFaturamento',
       'CIF' as 'TipoDeFrete',
       '000' as 'PrazoDePagamento',
       'SP' as 'UFDeOrigemDaMercadoria',
       (select subString(T2.EMPCEP,1,5) + subString(T2.EMPCEP,7,3) from TBS023 as T2 (nolock) where T2.EMPCOD=1) as 'CEPDeOrigem',
       'SP' as 'UFDeDestinoDaMercadoria',
       (select subString(T3.EMPCEP,1,5) from TBS023 as T3 (nolock) where T3.EMPCOD=1) as 'CEPDeDestino',
       space(212) as 'Filler2'
  from VENDAS as T1
 where T1.SerieDaNotaFiscal='CUP'
 group by T1.NumeroDaNotaFiscal,T1.SerieDaNotaFiscal,T1.DataDaEmissao,T1.CupomCancelado

-- saida para arquivo

select T1.TipoDeRegistro+T1.NumeroDaNotaFiscal+T1.SerieDaNotaFiscal+T1.DataDaEmissaoDaNotaFiscal+T1.TipoDaNotaFiscal+T1.Filler+T1.CodigoDoCliente+T1.TipoDeFaturamento+T1.TipoDeFrete+T1.PrazoDePagamento+T1.UFDeOrigemDaMercadoria+T1.CEPDeOrigem+T1.UFDeDestinoDaMercadoria+T1.CEPDeDestino+T1.Filler2+space(3) from SIBD..NOTASFISCAIS as T1 (nolock)


--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- registro 03 - cliente

if object_id('SIBD..CLIENTE') is not null
   begin
      drop table CLIENTE
   end

-- clientes corporativo

select '03' as 'TipoDeRegistro',
       T1.CodigoDoCliente as 'CodigoDoCliente',
       (select subString(T2.CLICEP,1,5) from TBS002 as T2 (nolock) where T2.CLICOD=T1.CodigoDoCliente) as 'CEPDoCliente',
       (select T3.UFESIG from TBS002 as T3 (nolock) where T3.CLICOD=T1.CodigoDoCliente) as 'UFDoCliente',
       left(rtrim((select (select T4.MUNNOM from TBS003 as T4 (nolock) where T4.MUNCOD=T5.MUNCOD) from TBS002 as T5 where T5.CLICOD=T1.CodigoDoCliente))+replicate(' ',50),50) as 'CidadeDoCliente',
       space(75) as 'EnderecoDoCliente',
       space(50) as 'NomeDoCliente',
       '020' as 'CodigoDoSubsegmentoDoCliente',
       replicate('0',14) as 'CNPJDoCliente',
       space(82) as 'Filler'
       into CLIENTE
  from NOTASFISCAIS as T1
 where T1.SerieDaNotaFiscal<>'CUP'
 group by T1.CodigoDoCliente

-- clientes loja a própria empresa

insert into #CLIENTE
select '03' as 'TipoDeRegistro',
       Ltrim(str(T1.EMPCOD,14)) as 'CodigoDoCliente',
       subString(T1.EMPCEP,1,5) as 'CEPDoCliente',
       T1.EMPUFESIG as 'UFDoCliente',
       (select T2.MUNNOM from TBS003 as T2 (nolock) where T2.MUNCOD=T1.EMPMUNCOD) as 'CidadeDoCliente',
       space(75) as 'EnderecoDoCliente',
       space(50) as 'NomeDoCliente',
       '020' as 'CodigoDoSubsegmentoDoCliente',
       replicate('0',14) as 'CNPJDoCliente',
       space(82) as 'Filler'
  from TBS023 as T1
 where T1.EMPCOD=1

-- saida para arquivo

select T1.TipoDeRegistro+T1.CodigoDoCliente+T1.CEPDoCliente+space(3)+UFDoCliente+T1.CidadeDoCliente+T1.EnderecoDoCliente+T1.NomeDoCliente+T1.CodigoDoSubsegmentoDoCliente+T1.CNPJDoCliente+T1.Filler from SIBD..CLIENTE as T1 (nolock) 
