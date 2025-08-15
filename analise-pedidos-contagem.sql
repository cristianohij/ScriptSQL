drop table #PROMANUTENCAO

select top(10) PROCOD
       ,PRODES
       --,PROUM1
       --,PROUM1QTD
       --,PROUMV
       ,PROUM1 + ' ' + case when PROUM1QTD > 1 then 'C/' + Ltrim(replace(convert(char(9), PROUM1QTD),'.00','')) + ' ' + PROUMV else '' end
       ,MARNOM
  --into #produtos
  from TBS010 with (nolock)
 where MARCOD=4

select count(distinct i.NFSNUM)
  from TBS0671 i with (nolock)
       inner join TBS067 n with (nolock)
                  on n.NFSNUM=i.NFSNUM
       inner join TBS080 e with (nolock)
                  on e.ENFNUM=i.NFSNUM
       inner join #produtos m
                  on m.codigo=i.PROCOD
 where n.NFSDATEMI between '20230623' and '20230626'
       and n.NFSCAN='N'
       and e.ENFSIT=6
       and e.ENFFINEMI=1
       and e.SNESER <= 3
       and e.ENFNUM in(331713,331741,331750,331753,331763,331766,331777,331789,331784,331788)

select e.*
  from TBS0671 i with (nolock)
       inner join TBS067 n with (nolock)
                  on n.NFSNUM=i.NFSNUM
       inner join TBS080 e with (nolock)
                  on e.ENFNUM=i.NFSNUM
       inner join #produtos m
                  on m.codigo=i.PROCOD
 where n.NFSDATEMI between '20230623' and '20230626'
       and n.NFSCAN='N'
       and e.ENFSIT=6
       and e.ENFFINEMI=1
       and e.SNESER <= 3
       and e.ENFNUM in(331713,331741,331750,331753,331763,331766,331777,331789,331784,331788)

select e.*
  from TBS0671 i with (nolock)
       inner join TBS067 n with (nolock)
                  on n.NFSNUM=i.NFSNUM
       inner join TBS080 e with (nolock)
                  on e.ENFNUM=i.NFSNUM
 where n.NFSDATEMI between '20230623' and '20230626'
       and n.NFSCAN='N'
       and e.ENFSIT=6
       and e.ENFFINEMI=1
       and e.SNESER <= 3
       and e.ENFNUM in(331713,331741,331750,331753,331763,331766,331777,331789,331784,331788)
       and i.PROCOD='1640054'

drop table #produtos

select PROCOD as 'codigo'
       ,PRODES as 'descricao'
       ,PROLOCFIS as 'localizacao'
  into #produtos
  from TBS010 with (nolock)
 where PROCOD in ('1640054','2540001') --'25460001','1080067','28610202','16310034','6522903','16310040','6521894','9650004','28050006')

select PROCOD
       ,Left(PROLOCFIS,2) + '-' + subString(PROLOCFIS,3,1) + '-' + subString(PROLOCFIS,4,2) + '-' + subString(PROLOCFIS,6,1)
       ,PRODES
       ,PROUM1 + ' ' + case when PROUM1QTD > 1 then 'C/' + Ltrim(replace(convert(char(9), PROUM1QTD),'.00','')) + ' ' + PROUMV else '' end
       ,MARNOM
  from TBS010 with (nolock)
 where PROCOD in (select codigo from #produtos)
 order by PROLOCFIS
 
select PROCOD
       ,PRPPRODES
       ,PRPQTD
       ,p.localizacao
  from TBS058 rs with (nolock)
       inner join #produtos p
                  on p.codigo=rs.PROCOD
 where PRPMOVEST='S'
       and PRPQTDCONF > 0

select *
  from TBS058 with (nolock)

drop table #pedidos

-- pedidos conferidos

select PRPNUM
       ,PROCOD
       ,PRPPRODES
       ,PRPQTD
       ,p.localizacao
  into #pedidos
  from TBS058 rs with (nolock)
       inner join #produtos p
                  on p.codigo=rs.PROCOD
 where PRPMOVEST='S'
       and PRPSIT='R'
       and PRPQTDCONF > 0

select *
  from #pedidos

-- pedidos conferidos e ou reservados

select PRPNUM
       ,PROCOD
       ,PRPPRODES
       ,PRPQTD
       ,p.localizacao
  --into #pedidos
  from TBS058 rs with (nolock)
       inner join #produtos p
                  on p.codigo=rs.PROCOD
 where PRPMOVEST='S'
       and PRPSIT='R'
       and PRPQTDCONF > 0

select count(distinct rs.PRPNUM)
  from TBS058 rs with (nolock)
       inner join #produtos p
                  on p.codigo=rs.PROCOD
 where PRPMOVEST='S'
       and PRPSIT='R'
       and PRPQTDCONF > 0

select rs.PROCOD 
       ,count(*)
  from TBS058 rs with (nolock)
       inner join #produtos p
                  on p.codigo=rs.PROCOD
 where PRPMOVEST='S'
       and PRPSIT='R'
       and PRPQTDCONF > 0
 group by rs.PROCOD
 order by rs.PROCOD

select *
  from #produtos

select *
  --into #estoque
  from SALDODIARIO with (nolock)
 where ESTDATSAL='20230721'
       and ESTLOC=1
       and PROCOD in (select codigo from #produtos)

select *
  --into #estoque
  into estoque_atual_24_06
  from TBS032 with (nolock)
 where ESTLOC=1
       and PROCOD in (select codigo from #produtos)

select *
  from estoque_atual_24_06

select *
  into tbs032_24_06
  from TBS032 with (nolock)
 where ESTLOC=1

select ESTQTDATU - ESTQTDRES
       ,*
  from tbs032_24_06 s
 where s.PROCOD in (select codigo from #produtos)

select e.SNESER
       ,e.ENFNUM
       ,e.ENFDATEMI
       ,e.ENFDESREM
       ,v.VENNOM
       ,i.PROCOD
       ,sum(i.NFSQTD * i.NFSQTDEMB) as 'qtde'
  from TBS0671 i with (nolock)
       inner join TBS067 n with (nolock)
                  on n.SNESER=i.SNESER and n.NFSNUM=i.NFSNUM
       inner join TBS080 e with (nolock)
                  on e.SNESER=i.SNESER and e.ENFNUM=i.NFSNUM
        Left join TBS004 v with (nolock)
                  on v.VENCOD=n.VENCOD         
 where n.NFSDATEMI between '20230724' and '20230724'
       and n.NFSCAN='N'
       and e.ENFSIT=6
       and e.ENFFINEMI=1
       and e.SNESER <= 3
       and i.PROCOD in (select codigo from #produtos)
 group by e.SNESER
          ,e.ENFNUM
          ,e.ENFDATEMI
          ,e.ENFDESREM
          ,v.VENNOM
          ,i.PROCOD

-- cris