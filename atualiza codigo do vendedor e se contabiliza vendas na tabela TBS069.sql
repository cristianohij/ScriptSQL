select PDFNFSNUM,NFSNUM,VENCOD,* from TBS069 join TBS067 on PDFNFSNUM=NFSNUM where PDFVENCOD is null

-- atualiza o codigo do vendedor -> busca informacao na tabela de nf de saida
update TBS069 set PDFVENCOD=VENCOD from TBS069 join TBS067 on PDFNFSNUM=NFSNUM where PDFVENCOD is null


select TESCNTVEN,TBS0671.TESCOD,TBS042.TESCOD,PDFNFSNUM,NFSNUM,PDFNFSITE,NFSITE
  from TBS0671 join TBS042 on TBS0671.TESCOD=TBS042.TESCOD
               join TBS069 on PDFNFSNUM=NFSNUM and PDFNFSITE=NFSITE
 where PDFCNTVEN is null

-- atualiza atributo que controla se contabiliza vendas -> busca na tabela de itens da nf de saida
update TBS069 set PDFCNTVEN=TESCNTVEN 
  from TBS0671 join TBS042 on TBS0671.TESCOD=TBS042.TESCOD
               join TBS069 on PDFNFSNUM=NFSNUM and PDFNFSITE=NFSITE
 where PDFCNTVEN is null