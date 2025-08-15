declare @DataDe char(8), @DataAte char(8), @vendedor smallint, @cliente smallint, @rede smallint, @nomeCliente char(60), @nomeFantasia char(25)

select @DataDe='20160707', @DataAte='20160707', @vendedor=0, @cliente = 0, @rede=0, @nomeCliente='', @nomeFantasia=''

-- somente vendas: TBS110.ROPCNTVEN='S'

select TBS0671.NFSPRODES as DescricaoProduto,
       TBS0671.PROCOD as CodigoProduto,
       TBS0671.NFSUNI as UnidadeMedida,
       TBS0671.NFSNUM as NotaFiscal,
       TBS0672.NFSPDVNUM as Pedido,
       TBS067.NFSDATEMI as EmissaoNF,
       TBS0671.NFSPRE as PrecoUnitario,
       TBS0671.NFSQTDPES as QtdeFracionada,
       TBS0671.NFSQTDAUX as QtdePecas,
       TBS0671.NFSPESLIQITE as PesoLiquido,
       TBS0671.NFSPESBRUITE as PesoBruto,
       TBS0671.NFSPDDITE as Desconto,
       dbo.NFSTOTITEST(0,TBS0671.NFSNUM,0,TBS0671.SNESER,TBS0671.NFSITE) as TotalLiquido,
       TBS067.NFSCLICOD as CodigoCliente,
       TBS067.NFSCLINOM as NomeCliente,
       TBS002.CLINOMFAN as NomeFantasia,
       TBS003.MUNNOM as Municipio,
       TBS067.UFESIG as UF,
       TBS008.CPGDES FormaPagamento,
       case when TBS0671.NFSNUMPEDCOM='' then TBS067.NFSPEDCLI else TBS0671.NFSNUMPEDCOM end as PedidoCliente,
       TBS067.VENCOD as CodigoVendedor,
       TBS004.VENNOM as NomeVendedor
  from TBS0671 (nolock)
       inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       inner join TBS0672 (nolock) on TBS0672.SNESER=TBS067.SNESER and TBS0672.NFSNUM=TBS067.NFSNUM
       inner join TBS008 (nolock) on TBS008.CPGCOD=TBS067.CPGCOD
       inner join TBS002 (nolock) on TBS002.CLICOD=TBS067.NFSCLICOD
       inner join TBS003 (nolock) on TBS003.MUNCOD=TBS002.MUNCOD
       inner join TBS110 (nolock) on TBS110.ROPREG=TBS0671.NFSROPREG
       inner join TBS080 (nolock) on TBS080.SNESER=TBS067.SNESER and TBS080.ENFNUM=TBS067.NFSNUM
       inner join TBS004 (nolock) on TBS004.VENCOD=TBS067.VENCOD
 where TBS080.ENFSIT=6 and
       TBS110.ROPCNTVEN='S' and
       TBS067.NFSFINNFE=1 and
       TBS067.NFSDATEMI between @DataDe and @DataAte and
       TBS067.NFSCLICOD >= case when @cliente > 0 then @cliente else 0 end and
       TBS067.NFSCLICOD <= case when @cliente > 0 then @cliente else 99999 end and
       TBS067.VENCOD >= case when @vendedor > 0 then @vendedor else 0 end and
       TBS067.VENCOD <= case when @vendedor > 0 then @vendedor else 9999 end and
       TBS002.RDLCOD >= case when @rede > 0 then @rede else 0 end and
       TBS002.RDLCOD <= case when @rede > 0 then @rede else 999 end and
       TBS067.NFSCLINOM Like(upper(rtrim(@nomeCliente))+'%') and
       TBS002.CLINOMFAN Like(upper(rtrim(@nomeFantasia))+'%')


declare @DataDe char(8), @DataAte char(8), @vendedor smallint, @cliente smallint, @nomeCliente char(60)

select @DataDe='20160601', @DataAte='20160615', @vendedor=0, @cliente = 0, @nomeCliente=''

-- devoluções para fornecedores: TBS110.ROPTIPOPE='DEV'

select TBS0671.NFSPRODES as DescricaoProduto,
       TBS0671.PROCOD as CodigoProduto,
       TBS0671.NFSUNI as UnidadeMedida,
       TBS0671.NFSNUM as NotaFiscal,
       TBS0672.NFSPDVNUM as Pedido,
       TBS067.NFSDATEMI as EmissaoNF,
       TBS0671.NFSPRE as PrecoUnitario,
       TBS0671.NFSQTDPES as QtdeFracionada,
       TBS0671.NFSQTDAUX as QtdePecas,
       TBS0671.NFSPESLIQITE as PesoLiquido,
       TBS0671.NFSPESBRUITE as PesoBruto,
       TBS0671.NFSPDDITE as Desconto,
       dbo.NFSTOTITEST(0,TBS0671.NFSNUM,0,TBS0671.SNESER,TBS0671.NFSITE) as TotalLiquido,
       TBS067.NFSCLICOD as CodigoCliente,
       TBS067.NFSCLINOM as NomeCliente,
       TBS003.MUNNOM as Municipio,
       TBS067.UFESIG as UF,
       TBS008.CPGDES FormaPagamento,
       case when TBS0671.NFSNUMPEDCOM='' then TBS067.NFSPEDCLI else TBS0671.NFSNUMPEDCOM end as PedidoCliente,
       TBS067.VENCOD as CodigoVendedor,
       TBS004.VENNOM as NomeVendedor
  from TBS0671 (nolock)
       inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       inner join TBS0672 (nolock) on TBS0672.SNESER=TBS067.SNESER and TBS0672.NFSNUM=TBS067.NFSNUM
       inner join TBS008 (nolock) on TBS008.CPGCOD=TBS067.CPGCOD
       inner join TBS002 (nolock) on TBS002.CLICOD=TBS067.NFSCLICOD
       inner join TBS003 (nolock) on TBS003.MUNCOD=TBS002.MUNCOD
       inner join TBS110 (nolock) on TBS110.ROPREG=TBS0671.NFSROPREG
       inner join TBS080 (nolock) on TBS080.SNESER=TBS067.SNESER and TBS080.ENFNUM=TBS067.NFSNUM
       inner join TBS004 (nolock) on TBS004.VENCOD=TBS067.VENCOD
 where TBS080.ENFSIT=6 and
       TBS110.ROPTIPOPE='DEV' and
       TBS067.NFSFINNFE=4 and
       TBS067.NFSDATEMI between @DataDe and @DataAte and
       TBS067.NFSCLICOD >= case when @cliente > 0 then @cliente else 0 end and
       TBS067.NFSCLICOD <= case when @cliente > 0 then @cliente else 99999 end and
       TBS067.VENCOD >= case when @vendedor > 0 then @vendedor else 0 end and
       TBS067.VENCOD <= case when @vendedor > 0 then @vendedor else 9999 end and
       TBS067.NFSCLINOM Like(upper(rtrim(@nomeCliente))+'%')


declare @DataDe char(8), @DataAte char(8), @cliente smallint, @rede smallint, @nomeCliente char(60)

select @DataDe='20160601', @DataAte='20160615', @cliente = 0, @rede = 0

-- devoluções de clientes

select TBS0591.NFEDES as DescricaoProduto,
       TBS0591.PROCOD as CodigoProduto,
       TBS0591.NFEUNI as UnidadeMedida,
       TBS0591.NFENUM as NotaFiscal,
       TBS059.NFEDATENT as DataEntrada,
       TBS0591.NFEPRE as PrecoUnitario,
       TBS0591.NFEQTD as Quantidade,
       TBS0591.NFEPDDITE as Desconto,
       dbo.NFETOTLIQ(0, TBS0591.NFETIP, TBS0591.NFENUM, TBS0591.NFECOD, 0, TBS0591.SERCOD) as TotalLiquido,
       TBS059.NFECOD as CodigoCliente,
       TBS059.NFENOM as NomeCliente,
       TBS003.MUNNOM as Municipio,
       TBS059.NFEESTORI as UF,
       isnull(TBS067.VENCOD,0) as CodigoVendedor,
       isnull(TBS004.VENNOM,'') as NomeVendedor
  from TBS0591 (nolock)
       inner join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       Left join TBS0596 (nolock) on TBS0596.NFETIP=TBS059.NFETIP and TBS0596.SERCOD=TBS059.SERCOD and TBS0596.NFECOD=TBS059.NFECOD and TBS0596.NFENUM=TBS059.NFENUM
       inner join TBS002 (nolock) on TBS002.CLICOD=TBS059.NFECOD
       inner join TBS003 (nolock) on TBS003.MUNCOD=TBS002.MUNCOD
       Left join TBS080 (nolock) on TBS080.ENFCHAACE=TBS0596.NFENFRCHA
       inner join TBS067 (nolock) on TBS067.SNESER=TBS080.SNESER and TBS067.NFSNUM=TBS080.ENFNUM
       inner join TBS004 (nolock) on TBS004.VENCOD=TBS067.VENCOD
 where TBS059.NFECAN='N' and
       TBS059.NFETIP='D' and
       TBS059.NFEUSUEFE<>'' and
       TBS059.NFEDATENT between @DataDe and @DataAte and
       TBS059.NFECOD >= case when @cliente > 0 then @cliente else 0 end and
       TBS059.NFECOD <= case when @cliente > 0 then @cliente else 99999 end and
       TBS002.RDLCOD >= case when @rede > 0 then @rede else 0 end and
       TBS002.RDLCOD <= case when @rede > 0 then @rede else 999 end and
       TBS059.NFENOM Like(upper(rtrim(@nomeCliente))+'%')


select top 1 * from TBS0591 (nolock)
select top 1 * from TBS059 (nolock)       
select top 1 * from TBS006 (nolock)       

--select top 1 * from TBS0672 (nolock)
--select top 1 * from TBS0671 (nolock)
--select top 1 * from TBS067 (nolock)
--select top 1 * from TBS003 (nolock)
--select top 1 * from TBS002 (nolock)


-- com procedure

drop procedure SP_RelatorioVendas

create procedure [dbo].[SP_RelatorioVendas] 
   @DataDe char(8), @DataAte char(8), @vendedor smallint, @cliente smallint, @rede smallint as
   
   begin
   select TBS0671.NFSPRODES as DescricaoProduto,
          TBS0671.PROCOD as CodigoProduto,
          TBS0671.NFSUNI as UnidadeMedida,
          TBS0671.NFSNUM as NotaFiscal,
          TBS0672.NFSPDVNUM as Pedido,
          TBS067.NFSDATEMI as EmissaoNF,
          TBS0671.NFSPRE as PrecoUnitario,
          TBS0671.NFSQTDPES as QtdeFracionada,
          TBS0671.NFSQTDAUX as QtdePecas,
          TBS0671.NFSPESLIQITE as PesoLiquido,
          TBS0671.NFSPESBRUITE as PesoBruto,
          TBS0671.NFSPDDITE as Desconto,
          dbo.NFSTOTITEST(0,TBS0671.NFSNUM,0,TBS0671.SNESER,TBS0671.NFSITE) as TotalLiquido,
          TBS067.NFSCLICOD as CodigoCliente,
          TBS067.NFSCLINOM as NomeCliente,
          TBS003.MUNNOM as Municipio,
          TBS008.CPGDES FormaPagamento,
          case when TBS0671.NFSNUMPEDCOM='' then TBS067.NFSPEDCLI else TBS0671.NFSNUMPEDCOM end as PedidoCliente
     from TBS0671 (nolock)
          inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
          inner join TBS0672 (nolock) on TBS0672.SNESER=TBS067.SNESER and TBS0672.NFSNUM=TBS067.NFSNUM
          inner join TBS008 (nolock) on TBS008.CPGCOD=TBS067.CPGCOD
          inner join TBS002 (nolock) on TBS002.CLICOD=TBS067.NFSCLICOD
          inner join TBS003 (nolock) on TBS003.MUNCOD=TBS002.MUNCOD
    where TBS067.NFSDATEMI between @DataDe and @DataAte and
          TBS067.NFSFINNFE=1 and
          TBS067.NFSCLICOD >= case when @cliente > 0 then @cliente else 0 end and
          TBS067.NFSCLICOD <= case when @cliente > 0 then @cliente else 99999 end and
          TBS067.VENCOD >= case when @vendedor > 0 then @vendedor else 0 end and
          TBS067.VENCOD <= case when @vendedor > 0 then @vendedor else 9999 end and
          TBS002.RDLCOD >= case when @rede > 0 then @rede else 0 end and
          TBS002.RDLCOD <= case when @rede > 0 then @rede else 999 end
   end

exec SP_RelatorioVendas '20160620', '20160620', 0, 0, 0



declare @DataDe char(8), @DataAte char(8), @vendedor smallint, @cliente smallint, @rede smallint, @nomeCliente char(60)

select @DataDe='20160707', @DataAte='20160707', @vendedor=0, @cliente = 0, @rede=0, @nomeCliente=''

-- somente vendas x comissções: TBS110.ROPCNTVEN='S'

select TBS067.NFSCLICOD as CodigoCliente,
       sum(dbo.NFSTOTLIQ(0,TBS067.NFSNUM,0,TBS067.SNESER)) as ValorTotal,
       sum(dbo.NFSTOTLIQ(0,TBS067.NFSNUM,0,TBS067.SNESER)*TBS0671.NFSPERCOM/100) as ValorComissao
  into #vendas
  from TBS067 (nolock)
       inner join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
       inner join TBS002 (nolock) on TBS002.CLICOD=TBS067.NFSCLICOD
       inner join TBS003 (nolock) on TBS003.MUNCOD=TBS002.MUNCOD
       inner join TBS110 (nolock) on TBS110.ROPREG=TBS0671.NFSROPREG
       inner join TBS080 (nolock) on TBS080.SNESER=TBS067.SNESER and TBS080.ENFNUM=TBS067.NFSNUM
 where TBS080.ENFSIT=6 and
       TBS110.ROPCNTVEN='S' and
       TBS067.NFSFINNFE=1 and
       TBS067.NFSDATEMI between @DataDe and @DataAte and
       TBS067.NFSCLICOD >= case when @cliente > 0 then @cliente else 0 end and
       TBS067.NFSCLICOD <= case when @cliente > 0 then @cliente else 99999 end and
       TBS067.VENCOD >= case when @vendedor > 0 then @vendedor else 0 end and
       TBS067.VENCOD <= case when @vendedor > 0 then @vendedor else 9999 end and
       TBS002.RDLCOD >= case when @rede > 0 then @rede else 0 end and
       TBS002.RDLCOD <= case when @rede > 0 then @rede else 999 end and
       TBS067.NFSCLINOM Like(upper(rtrim(@nomeCliente))+'%')
 group by TBS067.SNESER,TBS067.NFSCLICOD

select TBS002.CLINOM as NomeCliente,CodigoCliente,ValorTotal,ValorComissao,ValorComissao/ValorTotal*100 as PorcentagemComissao,TBS002.UFESIG as UF,TBS003.MUNNOM as Municipio
  from #vendas
       inner join TBS002 (nolock) on TBS002.CLICOD=CodigoCliente
       inner join TBS003 (nolock) on TBS003.MUNCOD=TBS002.MUNCOD

