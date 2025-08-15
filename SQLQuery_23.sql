/*
select p.PROCOD
       ,p.PRODES
       ,PROUM1
       ,PROUMV
       ,PROUM2
       ,PROUM2QTD
       ,PROUM3
       ,PROUM3QTD
  from TBS010 p with (nolock)
 inner join TBS032 e with (nolock)
         on e.PROCOD=p.PROCOD
 where p.PROCOD in('0410012','0410020','0410039','0410047','0410055','0410063','0410098','0410274','0410276','0411248','0419703','0419935')
       and ESTLOC=1
       and ESTQTDATU > 0
*/

select 'ND' as 'Empresa'
       ,ESTLOC 'Local'
       ,p.PROCOD collate database_default 'Codigo'
       ,p.PRODES collate database_default 'Descricao'
       ,PROUM1 collate database_default 'Um.1'
       ,PROUM1QTD 'Qt.Emb.1'
       ,PROUMV collate database_default 'Um.Venda'
       ,PROUM2 collate database_default 'Um.2'
       ,PROUM2QTD 'Qt.Emb.2'
       ,PROUM3 collate database_default 'Um.3'
       ,PROUM3QTD 'Qt.Ebm.3'
       ,ESTQTDATU 'Qt.Estoque'
       ,ESTQTDCMP 'Qt.Compras'
       ,ESTQTDPEN 'Qt.Pendencia'
       ,ESTQTDRES 'Qt.Reserva'
  from TBS010 p with (nolock)
 inner join TBS032 e with (nolock)
         on e.PROCOD=p.PROCOD
 where p.MARCOD=12
       and ESTLOC in(1,2)
       and (ESTQTDATU > 0 or ESTQTDCMP > 0 or ESTQTDPEN > 0 or ESTQTDRES > 0)
       and PROUM2 != ''

union

select 'CD'
       ,ESTLOC
       ,p.PROCOD
       ,p.PRODES
       ,PROUM1
       ,PROUM1QTD
       ,PROUMV
       ,PROUM2
       ,PROUM2QTD
       ,PROUM3
       ,PROUM3QTD
       ,ESTQTDATU
       ,ESTQTDCMP
       ,ESTQTDPEN
       ,ESTQTDRES
  from cd.SIBD.dbo.TBS010 p with (nolock)
 inner join cd.SIBD.dbo.TBS032 e with (nolock)
         on e.PROCOD=p.PROCOD
 where p.MARCOD=12
       and ESTLOC=1
       and (ESTQTDATU > 0 or ESTQTDCMP > 0 or ESTQTDPEN > 0 or ESTQTDRES > 0)
       and PROUM2 != ''

union

select 'TT'
       ,ESTLOC
       ,p.PROCOD
       ,p.PRODES
       ,PROUM1
       ,PROUM1QTD
       ,PROUMV
       ,PROUM2
       ,PROUM2QTD
       ,PROUM3
       ,PROUM3QTD
       ,ESTQTDATU
       ,ESTQTDCMP
       ,ESTQTDPEN
       ,ESTQTDRES
  from tt.SIBD.dbo.TBS010 p with (nolock)
 inner join tt.SIBD.dbo.TBS032 e with (nolock)
         on e.PROCOD=p.PROCOD
 where p.MARCOD=12
       and ESTLOC in(1,2)
       and (ESTQTDATU > 0 or ESTQTDCMP > 0 or ESTQTDPEN > 0 or ESTQTDRES > 0)
       and PROUM2 != ''

union

select 'BB'
       ,ESTLOC
       ,p.PROCOD
       ,p.PRODES
       ,PROUM1
       ,PROUM1QTD
       ,PROUMV
       ,PROUM2
       ,PROUM2QTD
       ,PROUM3
       ,PROUM3QTD
       ,ESTQTDATU
       ,ESTQTDCMP
       ,ESTQTDPEN
       ,ESTQTDRES
  from bb.SIBD2.dbo.TBS010 p with (nolock)
 inner join bb.SIBD2.dbo.TBS032 e with (nolock)
         on e.PROCOD=p.PROCOD
 where p.MARCOD=12
       and ESTLOC=2
       and (ESTQTDATU > 0 or ESTQTDCMP > 0 or ESTQTDPEN > 0 or ESTQTDRES > 0)
       and PROUM2 != ''

union

select 'MI'
       ,ESTLOC
       ,p.PROCOD
       ,p.PRODES
       ,PROUM1
       ,PROUM1QTD
       ,PROUMV
       ,PROUM2
       ,PROUM2QTD
       ,PROUM3
       ,PROUM3QTD
       ,ESTQTDATU
       ,ESTQTDCMP
       ,ESTQTDPEN
       ,ESTQTDRES
  from mi.SIBD3.dbo.TBS010 p with (nolock)
 inner join mi.SIBD3.dbo.TBS032 e with (nolock)
         on e.PROCOD=p.PROCOD
 where p.MARCOD=12
       and ESTLOC=1
       and (ESTQTDATU > 0 or ESTQTDCMP > 0 or ESTQTDPEN > 0 or ESTQTDRES > 0)
       and PROUM2 != ''

union

select 'PY'
       ,ESTLOC
       ,p.PROCOD
       ,p.PRODES
       ,PROUM1
       ,PROUM1QTD
       ,PROUMV
       ,PROUM2
       ,PROUM2QTD
       ,PROUM3
       ,PROUM3QTD
       ,ESTQTDATU
       ,ESTQTDCMP
       ,ESTQTDPEN
       ,ESTQTDRES
  from pp.SIBD.dbo.TBS010 p with (nolock)
 inner join pp.SIBD.dbo.TBS032 e with (nolock)
         on e.PROCOD=p.PROCOD
 where p.MARCOD=12
       and ESTLOC=1
       and (ESTQTDATU > 0 or ESTQTDCMP > 0 or ESTQTDPEN > 0 or ESTQTDRES > 0)
       and PROUM2 != ''
