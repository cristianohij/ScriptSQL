select convert(char(10),PDCDATCAD,103) as 'emissao',TBS045.PDCNUM as 'pedido',FORCOD as 'cod-fornecedor',
       (select FORNOM from TBS006 (nolock) where FORCOD = TBS045.FORCOD) as 'nome-fornecedor',
       str(isnull(round(sum(dbo.PDCTOTITE(TBS045.PDCEMPCOD,TBS045.PDCNUM,PDCITE)),2),0),11,2) as 'valor'
  from TBS045 (nolock) join TBS0451 on TBS0451.PDCEMPCOD = TBS045.PDCEMPCOD and TBS0451.PDCNUM = TBS045.PDCNUM
 where PDCDATCAD >= '20121001'
 group by PDCDATCAD,TBS045.PDCNUM,FORCOD
 order by PDCDATCAD

select convert(char(10),PDCDATCAD,103) as 'emissao',
       sum(dbo.PDCTOTLIQ(TBS045.PDCEMPCOD,TBS045.PDCNUM)) as 'total-pedido',
       sum(dbo.PDCTOTENT(TBS045.PDCEMPCOD,TBS045.PDCNUM)) as 'total-entregue',
       sum(dbo.PDCTOTRES(TBS045.PDCEMPCOD,TBS045.PDCNUM)) as 'total-cancelado'
  from TBS045 (nolock)
 where PDCDATCAD >= '20120701'
 group by PDCDATCAD
 order by PDCDATCAD

select convert(char(10),PDCDATCAD,103) as 'emissao',
       FORCOD as 'cod-fornecedor',
       (select FORNOM from TBS006 (nolock) where FORCOD = TBS045.FORCOD) as 'nome-fornecedor',
       sum(dbo.PDCTOTLIQ(TBS045.PDCEMPCOD,TBS045.PDCNUM)) as 'total-pedido',
       sum(dbo.PDCTOTENT(TBS045.PDCEMPCOD,TBS045.PDCNUM)) as 'total-entregue',
       sum(dbo.PDCTOTRES(TBS045.PDCEMPCOD,TBS045.PDCNUM)) as 'total-cancelado'
  from TBS045 (nolock)
 where PDCDATCAD >= '20120701'
 group by PDCDATCAD,FORCOD
 order by PDCDATCAD,'nome-fornecedor'

select subString(NFEUSUEFE,1,10) as 'emissao',
       sum(dbo.NFETOTBRU(NFEEMPCOD,NFETIP,NFENUM,NFECOD,SEREMPCOD,SERCOD)) as 'valor'
  from TBS059 (nolock)
 where subString(NFEUSUEFE,1,10) >= '20120701' and NFETIP = 'N' and NFECAN <> 'S'
 group by subString(NFEUSUEFE,1,10)
 order by subString(NFEUSUEFE,1,10)

select subString(NFEUSUEFE,1,10) as 'emissao',
       NFECOD as 'cod-fornecedor',
       NFENOM as 'nome-fornecedor',
       sum(dbo.NFETOTBRU(NFEEMPCOD,NFETIP,NFENUM,NFECOD,SEREMPCOD,SERCOD)) as 'valor'
  from TBS059 (nolock)
 where subString(NFEUSUEFE,1,10) >= '20120701' and NFETIP = 'N' and NFECAN <> 'S'
 group by subString(NFEUSUEFE,1,10),NFECOD,NFENOM

select * from TBS059 (nolock)