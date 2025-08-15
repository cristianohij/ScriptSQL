--select TBS0671.NFSNUM,PROCOD,NFSUNI,NFSQTD --sum(NFSQTD)
--select PROCOD,NFSUNI,sum(NFSQTD)
select PROCOD,NFSUNI,sum(NFSQTD),sum((NFSPRE-(NFSPRE*NFSPDDITE/100))*NFSQTD)
--select TBS0671.NFSNUM,PROCOD,NFSUNI,NFSQTD,(NFSPRE-(NFSPRE*NFSPDDITE/100))*NFSQTD
  from TBS0671 (noLock) join TBS067 (noLock) on TBS0671.NFSNUM=TBS067.NFSNUM
                        join TBS042 (noLock) on TBS0671.TESCOD=TBS042.TESCOD
 where NFSCAN='N' and NFSDATEMI between '20100501' and '20100531' and NFSTIP='N' and TESCNTVEN='S' and
       PROCOD Like('1640054')
 group by PROCOD,NFSUNI
 order by TBS0671.NFSNUM

select PDFNFSNUM,PROCOD,PDFUNI,PDFQTD --sum(PDFQTD)
  from TBS069 (noLock)
 where PDFNFSDAT between '20100501' and '20100531' and PDFNFSCAN='N' and PDFCNTVEN='S' and PROCOD='1640054'
-- group by PROCOD,PDFUNI
 order by PDFNFSNUM


-- registro 04 - vendas

-- analitico

select '04' as 'tipo-registro',
       ltrim(str(TBS0671.NFSNUM,20)) as 'numero-nota-fiscal',
       TBS067.SERCOD as 'serie-nota-fiscal',
       TBS0671.PROCOD as 'codigo-produto',
       '04' as 'tipo-codigo-produto',
       case
          when TBS010.PROUM1 = 'PT' then 'P'
          when TBS010.PROUM1 = 'CX' then 'C'
          when TBS010.PROUM1 = 'KG' then 'K'
          when TBS010.PROUM1 = 'BB' then 'B'
       end as 'codigo-unidade-medida',
       TBS0671.NFSQTD*TBS0671.NFSQTDEMB as 'quantidade-vendida',
       'N' as 'bonificacao',
       dbo.NFSPRELIQ(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)/TBS0671.NFSQTDEMB as 'valor-unitario',
       dbo.NFSTOTITE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE) as 'valor-total-bruto',
       dbo.NFSTOTPRO(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)-dbo.NFSVDDITE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE) as 'valor-total-liquido',
       space(24) as 'filler',
       'COM' as 'categoria-venda',
       case when TBS067.NFSCAN = 'S' then '03' else '01' end as 'tipo-nota-fiscal',
       space(162) as 'filler2'
  from TBS0671 (noLock) join TBS067 (noLock) on TBS0671.NFSNUM=TBS067.NFSNUM
                        join TBS042 (noLock) on TBS0671.TESCOD=TBS042.TESCOD
                        join TBS010 (noLock) on TBS0671.PROCOD=TBS010.PROCOD
 where --NFSCAN='N' and 
       NFSDATEMI between '20121201' and '20121231' and
       NFSTIP='N' and TESCNTVEN='S' and
       TBS0671.PROCOD between '164' and '164Z' and
       TBS010.FORCOD=15
 order by TBS0671.NFSNUM

-- sintetico

select TBS0671.PROCOD as 'codigo_produto',
       TBS010.PRODES as 'descricao_produto',
       TBS010.PROUM1 as 'unidade_medida',
       sum(TBS0671.NFSQTD*TBS0671.NFSQTDEMB) as 'qtde_total',
       sum((TBS0671.NFSPRE/TBS0671.NFSQTDEMB-(TBS0671.NFSPRE/TBS0671.NFSQTDEMB*TBS0671.NFSPDDITE/100))*TBS0671.NFSQTD*TBS0671.NFSQTDEMB) as 'valor_total',
       TBS010.PROPESBRU as 'peso_bruto_kg',  
       sum(TBS0671.NFSQTD*TBS0671.NFSQTDEMB)*TBS010.PROPESBRU as 'qtde_total_kg',
       sum(TBS0671.NFSQTD*TBS0671.NFSQTDEMB)*TBS010.PROPESBRU/1000 as 'qtde_total_toneladas',
       sum((TBS0671.NFSPRE/TBS0671.NFSQTDEMB-(TBS0671.NFSPRE/TBS0671.NFSQTDEMB*TBS0671.NFSPDDITE/100))*TBS0671.NFSQTD*TBS0671.NFSQTDEMB)*TBS010.PROPESBRU as 'val_total_kg',
       sum((TBS0671.NFSPRE/TBS0671.NFSQTDEMB-(TBS0671.NFSPRE/TBS0671.NFSQTDEMB*TBS0671.NFSPDDITE/100))*TBS0671.NFSQTD*TBS0671.NFSQTDEMB)*TBS010.PROPESBRU/1000 as 'val_total_toneladas'
  from TBS0671 (noLock) join TBS067 (noLock) on TBS0671.NFSNUM=TBS067.NFSNUM
                        join TBS042 (noLock) on TBS0671.TESCOD=TBS042.TESCOD
                        join TBS010 (noLock) on TBS0671.PROCOD=TBS010.PROCOD
 where NFSCAN='N' and 
       NFSDATEMI between '20100802' and '20100807' and
       NFSTIP='N' and TESCNTVEN='S' and
       TBS0671.PROCOD Like('1640054') and
       TBS010.FORCOD=15
 group by TBS0671.PROCOD,PROUM1,PROPESBRU,PRODES


-- registro 03 - cliente

select TBS067.NFSCLICOD as 'numero_NF',
       TBS067.NFSCLINOM as 'nome_cliente',
       case
          when CLICGC <> '' then CLICGC
          else CLICPF
       end as 'CNPJ/CPF',
       subString(TBS002.CLICEP,1,5) as 'CEP',
       TBS002.UFESIG as 'UF',
       TBS002.CLICID as 'cidade'
  from TBS067 (noLock) join TBS002 (noLock) on TBS067.NFSCLICOD=TBS002.CLICOD
                       join TBS0671 (noLock) on TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.NFSNUM=TBS0671.NFSNUM
                       join TBS042 (noLock) on TBS0671.TESCOD=TBS042.TESCOD
                       join TBS010 (noLock) on TBS0671.PROCOD=TBS010.PROCOD
 where TBS067.NFSCAN='N' and
       TBS067.NFSDATEMI between '02/08/10' and '07/08/10' and
       TBS067.NFSTIP='N' and
       TBS0671.PROCOD between '164' and '164Z' and
       TBS010.FORCOD=15 and
       TBS042.TESCNTVEN='S'
 group by TBS067.NFSCLICOD ,TBS067.NFSCLINOM

select '03',
       TBS067.NFSCLICOD as 'codigo-cliente',
       (select subString(TBS002.CLICEP,1,5) from TBS002 (nolock) where TBS002.CLIEMPCOD = TBS067.NFSCLIEMP and TBS002.CLICOD = TBS067.NFSCLICOD) as 'CEP',
       TBS067.NFSCLINOM as 'nome_cliente',
       (select case when CLICGC <> '' then CLICGC else CLICPF end from TBS002 (nolock)
         where TBS002.CLIEMPCOD = TBS067.NFSCLIEMP and TBS002.CLICOD = TBS067.NFSCLICOD) as 'CNPJ/CPF',
       (select TBS002.UFESIG from TBS002 (nolock) where TBS002.CLIEMPCOD = TBS067.NFSCLIEMP and TBS002.CLICOD = TBS067.NFSCLICOD) as 'UF',
       (select TBS003.MUNNOM from TBS003 (nolock) join TBS002 (nolock) on TBS003.MUNCOD = TBS002.MUNCOD
         where TBS002.CLIEMPCOD = TBS067.NFSCLIEMP and TBS002.CLICOD = TBS067.NFSCLICOD) as 'cidade',
       (select rtrim(CLIEND) + ',' + rtrim(CLINUM) from TBS002 (nolock) 
         where TBS002.CLIEMPCOD = TBS067.NFSCLIEMP and TBS002.CLICOD = TBS067.NFSCLICOD) as 'endereco'
  from TBS067 (noLock) join TBS0671 (noLock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
                       join TBS042 (noLock) on TBS0671.TESCOD = TBS042.TESCOD
                       join TBS010 (noLock) on TBS0671.PROCOD = TBS010.PROCOD
 where TBS067.NFSCAN='N' and
       TBS067.NFSDATEMI between '02/08/10' and '07/08/10' and
       TBS067.NFSTIP='N' and
       TBS0671.PROCOD between '164' and '164Z' and
       TBS010.FORCOD=15 and
       TBS042.TESCNTVEN='S'
 group by TBS067.NFSCLIEMP ,TBS067.NFSCLICOD ,TBS067.NFSCLINOM


-- registro 05 - estoque

select '05' as 'tipo-registro',
       TBS032.PROCOD as 'codigo-produto',
       convert(char(8),getdate(),112) as 'data-estoque',
       TBS032.ESTQTDATU as 'quantidade-estoque',
       case
          when TBS010.PROUM1 = 'PT' then 'P'
          when TBS010.PROUM1 = 'CX' then 'C'
          when TBS010.PROUM1 = 'KG' then 'K'
          when TBS010.PROUM1 = 'BB' then 'B'
       end as 'codigo-unidade-medida',
       '04' as 'tipo-codigo-produto',
       replicate('0',15) as 'quantidade-estoque-transito',
       space(237) as 'filler'
  from TBS032 (nolock) Left join TBS010 (nolock) on TBS032.PROEMPCOD = TBS010.PROEMPCOD and TBS032.PROCOD = TBS010.PROCOD
 where TBS032.ESTLOC = 1 and
       TBS032.PROCOD between '164' and '164Z' and
       TBS010.FORCOD = 15

select convert(char(8),getdate(),112)


-- registro 06 - notas fiscais

select '06' as 'tipo-registro',
       ltrim(str(TBS067.NFSNUM,20)) as 'numero-nota-fiscal',
       TBS067.SERCOD as 'serie-nota-fiscal',
       convert(char(8),TBS067.NFSDATEMI,112) as 'data-emissao-nota-fiscal',
       case when TBS067.NFSCAN = 'S' then '03' else '01' end as 'tipo-nota-fiscal',
       space(11) as 'filler',
       Ltrim(str(TBS067.NFSCLICOD,14)) as 'codigo-cliente',
       '01' as 'tipo-faturamento',
       case when TBS067.NFSTIPFRE = 1 then 'FOB' else 'CIF' end as 'tipo-frete',
       datediff(day,
          (select TBS056.CREDATEMI from TBS056 (nolock)
            where TBS056.CRETIT = TBS067.NFSNUM and
                  TBS056.CLIEMPCOD = TBS067.NFSCLIEMP and
                  TBS056.CLICOD = TBS067.NFSCLICOD and
                  TBS056.CRETITORI = 'A'),
          (select max(TBS056.CREDATVENREA) from TBS056 (nolock)
            where TBS056.CRETIT = TBS067.NFSNUM and
                  TBS056.CLIEMPCOD = TBS067.NFSCLIEMP and
                  TBS056.CLICOD = TBS067.NFSCLICOD and
                  TBS056.CRETITORI = 'A'))/
          (select count(*) from TBS056 (nolock)
            where TBS056.CRETIT = TBS067.NFSNUM and
                  TBS056.CLIEMPCOD = TBS067.NFSCLIEMP and
                  TBS056.CLICOD = TBS067.NFSCLICOD and
                  TBS056.CRETITORI = 'A') as 'prazo-pagamento',
       dbo.DIsuzanoPrazPagto(TBS067.NFSNUM ,TBS067.NFSCLIEMP ,TBS067.NFSCLICOD) as 'teste',
       (select EMPUFESIG from TBS023 (nolock) where EMPCOD = 1) as 'origem-mercadoria',
       (select subString(EMPCEP,1,5) + subString(EMPCEP,7,3) from TBS023 (nolock) where EMPCOD = 1) as 'cep-mercadoria',
       TBS067.UFESIG as 'destino-mercadoria',
       (select subString(TBS002.CLICEP,1,5) from TBS002 (nolock)
         where TBS002.CLIEMPCOD = TBS067.NFSCLIEMP and TBS002.CLICOD = TBS067.NFSCLICOD) as 'cep-destino',
       space(212) as 'filler'
  from TBS067 (noLock)
 where TBS067.NFSDATEMI between '20121201' and '20121231' and
       TBS067.NFSTIP='N' and
       exists(select 'ex' from TBS0671 (nolock) join TBS010 (nolock) on TBS010.PROEMPCOD = TBS0671.PROEMPCOD and TBS010.PROCOD = TBS0671.PROCOD
                                                          join TBS042 (nolock) on TBS042.TESEMPCOD = TBS0671.TESEMPCOD and TBS042.TESCOD = TBS0671.TESCOD
               where TBS0671.NFSEMPCOD = TBS067.NFSEMPCOD and TBS0671.NFSNUM = TBS067.NFSNUM and TBS010.FORCOD = 15 and TBS042.TESCNTVEN = 'S')


-- 11/09/2014 ------------------------------------------------------------------------------------------------------------------------------------------------------

-- registro 05 - estoque

if object_id('tempdb..#ESTOQUE') is not null
   begin
      drop table #ESTOQUE
   end

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

select * from #ESTOQUE

select * from ESTOQUE

-- saida para arquivo

select T1.TipoDeRegistro+T1.CodigoDoProduto+T1.DataDoEstoque+right(replicate('0',15)+ltrim(str(T1.QuantidadeDoEstoque*1000,15)),15)+T1.CodigoDaUnidadeDeMedida+T1.TipoDeCodigoDeProduto+T1.QuantidadeDoEstoqueEmTransito+T1.Filler from SIBD..ESTOQUE as T1 (nolock)


exec master..xp_cmdshell bcp "select * from SIBD.dbo.ESTOQUE" queryout c:\temp\di.txt

 -U garth -P pw -c - See more at: http://www.sqlteam.com/article/exporting-data-programatically-with-bcp-and-xp_cmdshell#sthash.1pXVbGfp.dpuf

exec master..xp_cmdshell bcp "select * from ESTOQUE" queryout c:\temp\di.txt

-- registro 04 - vendas

-- vendas corporativo

-- tabela temporária

if object_id('tempdb..#VENDAS') is not null
   begin
      drop table #VENDAS
   end

-- tabela física

if object_id('SIBD..VENDAS') is not null
   begin
      drop table VENDAS
   end

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
 where T2.NFSDATEMI between '20140801' and '20140831' and
       T2.NFSTIP='N' and
       T3.TESCNTVEN='S' and
       T2.NFSCLINOM not Like('BEST BAG%') and
       T2.NFSCLINOM not Like('BEST OFFICE%') and
       T2.NFSCLINOM not Like('MISASPEL%') and
       T2.NFSCLINOM not Like('%PAPELYNA%') and
       T2.NFSCLINOM not Like('TANBY%')

 order by T1.NFSNUM

select * from #VENDAS
select * from VENDAS

print right('123456',3)

-- vendas loja

-- lista de cupons cancelados

if object_id('SIBD..CUPOMCANCELADO') is not null
   begin
      drop table CUPOMCANCELADO
   end

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
 where T1.M2_DAT between '20140501' and '20140531' and T1.M2_TIPREG='04'

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
 where T1.M2_DAT between '20140501' and '20140531' and
       T1.M2_TIPREG='01' and
       T1.M2_REGCAN<>'T'
 order by T1.M2_NUMDOC

-- saida para arquivo texto

select T1.TipoDeRegistro+T1.NumeroDaNotaFiscal+T1.SerieDaNotaFiscal+T1.CodigoDoProduto+T1.TipoDeCodigoDeProduto+T1.CodigoDaUnidadeDeMedida+right(replicate('0',15)+ltrim(str(sum(T1.QuantidadeVendida)*1000,15)),15)+T1.Bonificacao+right(replicate('0',15)+ltrim(str(avg(T1.ValorUnitario)*1000,15)),15)+right(replicate('0',15)+ltrim(str(sum(T1.ValorTotalBruto)*1000,15)),15)+right(replicate('0',15)+ltrim(str(sum(T1.ValorTotalLiquido)*1000,15)),15)+T1.Filler+T1.CategoriaDaVenda+T1.TipoDaNotaFiscal+T1.Filler2 as 'REGISTRO' from SIBD..VENDAS as T1 (nolock) group by T1.TipoDeRegistro,T1.NumeroDaNotaFiscal,T1.SerieDaNotaFiscal,T1.CodigoDoProduto,T1.TipoDeCodigoDeProduto,T1.CodigoDaUnidadeDeMedida,T1.Bonificacao,T1.Filler,T1.CategoriaDaVenda,T1.TipoDaNotaFiscal,T1.Filler2

-- valores totais

select sum(ValorTotalBruto),sum(ValorTotalLiquido) from VENDAS (nolock)


-- registro 06 - notas fiscais

if object_id('tempdb..#NOTASFISCAIS') is not null
   begin
      drop table #NOTASFISCAIS
   end

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


select T1.NumeroDaNotaFiscal,T1.SerieDaNotaFiscal,T2.NumeroDaNotaFiscal,T2.SerieDaNotaFiscal
  from NOTASFISCAIS as T1 (nolock) inner join VENDAS as T2 on T1.SerieDaNotaFiscal=T2.SerieDaNotaFiscal and T1.NumeroDaNotaFiscal=T2.NumeroDaNotaFiscal

update NOTASFISCAIS set left(rtrim(T1.PROCOD)+replicate(' ',20),20) as 'CodigoDoProduto',

PrazoDePagamento=replicate('0',len(PrazoDePagamento)+

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

select top 1 * from #NOTASFISCAIS
select top 1 * from #VENDAS where SerieDaNotaFiscal='CUP'

-- contabiliza valores

select sum(ValorTotalBruto),sum(ValorTotalLiquido) from VENDAS (nolock)

select sum(T1.ValorTotalBruto),sum(T1.ValorTotalLiquido)
  from VENDAS as T1 (nolock) join NOTASFISCAIS as T2 (nolock) on T1.SerieDaNotaFiscal=T2.SerieDaNotaFiscal and T1.NumeroDaNotaFiscal=T2.NumeroDaNotaFiscal
 where T2.TipoDaNotaFiscal='01'

-- contabiliza vendas em toneladas

select sum(T1.QuantidadeVendida*T2.DISPESRES)/1000
  from VENDAS as T1 (nolock) left join MSL005 as T2 (nolock) on T1.CodigoDoProduto=T2.PROCOD

-- saida para arquivo

select T1.TipoDeRegistro+T1.NumeroDaNotaFiscal+T1.SerieDaNotaFiscal+T1.DataDaEmissaoDaNotaFiscal+T1.TipoDaNotaFiscal+T1.Filler+T1.CodigoDoCliente+T1.TipoDeFaturamento+T1.TipoDeFrete+T1.PrazoDePagamento+T1.UFDeOrigemDaMercadoria+T1.CEPDeOrigem+T1.UFDeDestinoDaMercadoria+T1.CEPDeDestino+T1.Filler2+space(3) from SIBD..NOTASFISCAIS as T1 (nolock)

-- registro 03 - cliente

if object_id('tempdb..#CLIENTE') is not null
   begin
      drop table #CLIENTE
   end

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
       --(select case when T6.CLITIPPES='J' then T6.CLICGC else T6.CLICPF end from TBS002 as T6 (nolock) where T6.CLICOD=T1.CodigoDoCliente) as 'CNPJDoCliente',
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
       --T1.EMPCGC as 'CNPJDoCliente',
       replicate('0',14) as 'CNPJDoCliente',
       space(82) as 'Filler'
  from TBS023 as T1
 where T1.EMPCOD=1


select T1.CodigoDoCliente,T2.CodigoDoCliente from CLIENTE as T1 (nolock) full join NOTASFISCAIS as T2 (nolock) on T1.CodigoDoCliente=T2.CodigoDoCliente


-- saida para arquivo

select T1.TipoDeRegistro+T1.CodigoDoCliente+T1.CEPDoCliente+space(3)+UFDoCliente+T1.CidadeDoCliente+T1.EnderecoDoCliente+T1.NomeDoCliente+T1.CodigoDoSubsegmentoDoCliente+T1.CNPJDoCliente+T1.Filler from SIBD..CLIENTE as T1 (nolock) 

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


select T1.TipoDeRegistro+T1.CNPJDoDistribuidor+T1.DataEHoraDaGeracaoDoDocumento+T1.VersaoDoLayout+T1.CodigoDaIndustria
--+T1.RazaoSocialDoDistribuidor+T1.Filler
from SIBD..CABECALHO as T1 (nolock)

select * from CABECALHO

set nocount on
select * from #CABECALHO

create view CABECALHO as select * from #CABECALHO

--exec master..xp_cmdshell bcp 'select * from #CABECALHO' queryout c:\temp\di.txt

-- produtos que devem ser enviados para NEOGRID

delete MSL005

insert into MSL005 values(0,0,'1640011','P',2.34)
insert into MSL005 values(0,0,'1640020','P',2.34)
insert into MSL005 values(0,0,'1640038','P',4.68)
insert into MSL005 values(0,0,'1640054','P',2.34)
insert into MSL005 values(0,0,'1640089','P',2.26)
insert into MSL005 values(0,0,'1640178','P',2.54)
insert into MSL005 values(0,0,'1640208','P',2.67)
insert into MSL005 values(0,0,'1640259','P',2.34)
insert into MSL005 values(0,0,'1640275','P',2.34)
insert into MSL005 values(0,0,'1641085','P',0.468)
insert into MSL005 values(0,0,'1641093','P',0.468)
insert into MSL005 values(0,0,'1641107','P',0.468)
insert into MSL005 values(0,0,'1641115','P',0.468)
insert into MSL005 values(0,0,'1641123','P',0.468)
insert into MSL005 values(0,0,'1641166','P',2.808)
insert into MSL005 values(0,0,'1641239','P',2.34)
insert into MSL005 values(0,0,'1641247','P',2.26)
insert into MSL005 values(0,0,'1641509','P',4.68)
insert into MSL005 values(0,0,'17230002','P',4.68)
insert into MSL005 values(0,0,'17230003','P',2.34)
insert into MSL005 values(0,0,'17230004','P',2.54)

select *,(select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=MSL005.PROCOD) from MSL005 (nolock)

update MSL005 set DISUNIMED='P'

select * from MSL005 (nolock)



alter table MSL005 add DISPESRES smallmoney not null default 0 with values

delete MSL005