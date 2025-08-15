declare @mesAno char(7)

set @mesAno='01/2015'

select subString(convert(char(7),NFSDATEMI,111),6,2)+'/'+subString(convert(char(7),NFSDATEMI,111),1,4) as 'MesAno',
       Rtrim(isnull((select VENNOM from TBS004 (nolock) where TBS004.VENCOD=TBS067.VENCOD),''))+' ('+Ltrim(str(VENCOD,4))+')' as 'NomeECodigoDoVendedor',
       TBS067.NFSNUM as 'NumeroDaNF',
       TBS067.SNESER as 'SerieDaNF',
       rtrim(TBS067.NFSCLINOM)+' ('+ltrim(str(TBS067.NFSCLICOD,5))+')' as 'NomeECodigoDoCliente',
       TBS067.NFSDATEMI as 'DataDaEmissao',
       TBS067.NFSTIP as 'TipoDaNF',
       dbo.NFSTOTLIQ(0,TBS067.NFSNUM,0,TBS067.SNESER) as 'ValorTotal',
       dbo.NFSVDDTOT(0,TBS067.NFSNUM,0,TBS067.SNESER) as 'DescontoTotal'
  from TBS067 (nolock) --join TBS0671 (nolock) on TBS067.NFSSER=TBS0671.NFSSER and TBS067.NFSNUM=TBS0671.NFSNUM
 where TBS067.NFSCAN='N' and TBS067.NFSDEV='N' and
       subString(convert(char(7),NFSDATEMI,111),6,2)+'/'+subString(convert(char(7),NFSDATEMI,111),1,4)=@mesAno and
       TBS067.NFSTIP in('L','N')



