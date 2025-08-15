select * from TBS0672 (nolock) where NFSPDVNUM in(158304,159256 )

select * from TBS056 (nolock) where CRENUMBOR=0 and dbo.CREVALSDO(0,0,0,PFXCOD,CRETIT,CREPAR,CLICOD) > 0 and CREIMPBOLRES Like('03/02/17%') and CREIMPBOLRES Like('%DJALMA')

select PFXCOD as prefixo,
       TBS056.CLICOD as codigoCliente,
       TBS056.CLINOM as nomeCliente,
       PORCOD as portadorTitulo,
       CLIPORCOD as portadorCliente,
       BANCOD as banco,
       CREIMPBOLRES as impressaoBoleto
  from TBS056 (nolock) inner join TBS002 (nolock) on TBS056.CLICOD=TBS002.CLICOD
 where CRENUMBOR=0 and dbo.CREVALSDO(0,0,0,PFXCOD,CRETIT,CREPAR,TBS056.CLICOD) > 0 and CREIMPBOLRES Like('03/02/17%') and CREIMPBOLRES Like('%DJALMA') and PORCOD > 0 and CREDATBAI='17530101'

