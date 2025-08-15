--select * from TBS043 where ORCVDDTOT > 0

select TBS043.ORCNUM as 'orcamento',
       ORCPRE as 'preco',
       ORCPDDITE as 'desconto(%)',
       ORCPRE*ORCPDDITE/100 as 'desconto(v)',
       ORCPRE-ORCPRE*ORCPDDITE/100 as 'preco liquido',
       ORCQTD as 'quantidade',
       ORCQTD*(ORCPRE-ORCPRE*ORCPDDITE/100) as 'subtotal'
  from TBS043 join TBS0431 on TBS043.ORCNUM=TBS0431.ORCNUM
 where ORCVDDTOT > 0

select sum(ORCQTD*(ORCPRE-ORCPRE*ORCPDDITE/100))
  from TBS043 join TBS0431 on TBS043.ORCNUM=TBS0431.ORCNUM
 where ORCVDDTOT > 0

-- insere atributos

-- TBS043: orcamentos
alter table [TBS043] add [ORCPDDTOT] decimal default 0 with values

-- TBS045: pedidos compras
alter table [TBS045] add [PDCPDDTOT] decimal default 0 with values

-- TBS055: pedidos vendas
alter table [TBS055] add [PDVPDDTOT] decimal default 0 with values

-- TBS067: notas fiscais saidas
alter table [TBS067] add [NFSPDDTOT] decimal default 0 with values

-- orcamentos
update TBS043
   set ORCPDDTOT=ORCVDDTOT*100/(select sum(ORCQTD*(ORCPRE-ORCPRE*ORCPDDITE/100))
                                  from TBS043 join TBS0431 on TBS043.ORCNUM=TBS0431.ORCNUM
                                 where ORCVDDTOT > 0)
  from TBS043 join TBS0431 on TBS043.ORCNUM=TBS0431.ORCNUM where ORCVDDTOT > 0

-- pedidos vendas
update TBS055
   set PDVPDDTOT=PDVVDDTOT*100/(select sum(PDVQTD*(PDVPRE-PDVPRE*PDVPDDITE/100))
                                  from TBS055 join TBS0551 on TBS055.PDVNUM=TBS0551.PDVNUM
                                 where PDVVDDTOT > 0)
  from TBS055 join TBS0551 on TBS055.PDVNUM=TBS0551.PDVNUM where PDVVDDTOT > 0

-- notas fiscais saida
update TBS067
   set NFSPDDTOT=NFSVDDTOT*100/(select sum(NFSQTD*(NFSPRE-NFSPRE*NFSPDDITE/100))
                                  from TBS067 join TBS0671 on TBS067.NFSNUM=TBS0671.NFSNUM
                                 where NFSVDDTOT > 0)
  from TBS067 join TBS0671 on TBS067.NFSNUM=TBS0671.NFSNUM where NFSVDDTOT > 0

-- pedidos compras
update TBS045
   set PDCPDDTOT=PDCVDDTOT*100/(select sum(PDCQTD*(PDCPRE-PDCPRE*PDCPDDITE/100))
                                  from TBS045 join TBS0451 on TBS045.PDCNUM=TBS0451.PDCNUM
                                 where PDCVDDTOT > 0)
  from TBS045 join TBS0451 on TBS045.PDCNUM=TBS0451.PDCNUM where PDCVDDTOT > 0


