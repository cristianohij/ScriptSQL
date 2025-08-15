-- pedidos de vendas pendentes
select sum((PRPPRELIQ/PRPQTDEMB)*(PRPQTD*PRPQTDEMB)),count(*) from TBS058 (nolock)
 where PRPSIT='P' and
       PRPMOVEST='S'

-- pedidos de vendas pendentes com compras
select sum((PRPPRELIQ/PRPQTDEMB)*(PRPQTD*PRPQTDEMB)),count(*)
  from TBS058 (nolock) left join TBS032 (nolock) on TBS032.PROCOD=TBS058.PROCOD
 where PRPSIT='P' and
       PRPMOVEST='S' and
       ESTLOC=PRPESTLOC and
       ESTQTDCMP>=PRPQTD*PRPQTDEMB

-- pedidos de vendas pendentes sem compras
select sum((PRPPRELIQ/PRPQTDEMB)*(PRPQTD*PRPQTDEMB)),count(*)
  from TBS058 (nolock) left join TBS032 (nolock) on TBS032.PROCOD=TBS058.PROCOD
 where PRPSIT='P' and
       PRPMOVEST='S' and
       ESTLOC=PRPESTLOC and
       ESTQTDCMP=0

select top 1 * from TBS058 (nolock)

-- período versus número de dias
-- sem compras

-- até 2 dias
select count(*) from TBS058 (nolock) right join TBS055 (nolock) on TBS058.PRPNUM=TBS055.PDVNUM
                                      left join TBS032 (nolock) on TBS058.PROCOD=TBS032.PROCOD
 where PRPSIT='P' and
       PRPMOVEST='S' and
       PDVDATCAD>=convert(char(8),getdate()-2,112) and
       ESTLOC=PRPESTLOC and
       ESTQTDCMP=0

-- de 3 a 7 dias
select count(*) from TBS058 (nolock) right join TBS055 (nolock) on TBS058.PRPNUM=TBS055.PDVNUM
                                      left join TBS032 (nolock) on TBS058.PROCOD=TBS032.PROCOD
 where PRPSIT='P' and
       PRPMOVEST='S' and
       PDVDATCAD<=convert(char(8),getdate()-3,112) and 
       PDVDATCAD>=convert(char(8),getdate()-7,112) and
       ESTLOC=PRPESTLOC and
       ESTQTDCMP=0

-- de 8 a 15 dias
select count(*) from TBS058 (nolock) right join TBS055 (nolock) on TBS058.PRPNUM=TBS055.PDVNUM
                                      left join TBS032 (nolock) on TBS058.PROCOD=TBS032.PROCOD
 where PRPSIT='P' and
       PRPMOVEST='S' and
       PDVDATCAD<=convert(char(8),getdate()-8,112) and 
       PDVDATCAD>=convert(char(8),getdate()-15,112) and
       ESTLOC=PRPESTLOC and
       ESTQTDCMP=0

-- de 16 a 30 dias
select count(*) from TBS058 (nolock) right join TBS055 (nolock) on TBS058.PRPNUM=TBS055.PDVNUM
                                      left join TBS032 (nolock) on TBS058.PROCOD=TBS032.PROCOD
 where PRPSIT='P' and
       PRPMOVEST='S' and
       PDVDATCAD<=convert(char(8),getdate()-16,112) and 
       PDVDATCAD>=convert(char(8),getdate()-30,112) and
       ESTLOC=PRPESTLOC and
       ESTQTDCMP=0

-- acima de 30 dias
select count(*) from TBS058 (nolock) right join TBS055 (nolock) on TBS058.PRPNUM=TBS055.PDVNUM
                                      left join TBS032 (nolock) on TBS058.PROCOD=TBS032.PROCOD
 where PRPSIT='P' and
       PRPMOVEST='S' and
       PDVDATCAD<convert(char(8),getdate()-30,112) and
       ESTLOC=PRPESTLOC and
       ESTQTDCMP=0

-- com compras

-- até 2 dias
select count(*) from TBS058 (nolock) right join TBS055 (nolock) on TBS058.PRPNUM=TBS055.PDVNUM
                                      left join TBS032 (nolock) on TBS058.PROCOD=TBS032.PROCOD
 where PRPSIT='P' and
       PRPMOVEST='S' and
       PDVDATCAD>=convert(char(8),getdate()-2,112) and
       ESTLOC=PRPESTLOC and
       ESTQTDCMP>=PRPQTD*PRPQTDEMB

-- de 3 a 7 dias
select count(*) from TBS058 (nolock) right join TBS055 (nolock) on TBS058.PRPNUM=TBS055.PDVNUM
                                      left join TBS032 (nolock) on TBS058.PROCOD=TBS032.PROCOD
 where PRPSIT='P' and
       PRPMOVEST='S' and
       PDVDATCAD<=convert(char(8),getdate()-3,112) and 
       PDVDATCAD>=convert(char(8),getdate()-7,112) and
       ESTLOC=PRPESTLOC and
       ESTQTDCMP>=PRPQTD*PRPQTDEMB

-- de 8 a 15 dias
select count(*) from TBS058 (nolock) right join TBS055 (nolock) on TBS058.PRPNUM=TBS055.PDVNUM
                                      left join TBS032 (nolock) on TBS058.PROCOD=TBS032.PROCOD
 where PRPSIT='P' and
       PRPMOVEST='S' and
       PDVDATCAD<=convert(char(8),getdate()-8,112) and 
       PDVDATCAD>=convert(char(8),getdate()-15,112) and
       ESTLOC=PRPESTLOC and
       ESTQTDCMP>=PRPQTD*PRPQTDEMB

-- de 16 a 30 dias
select count(*) from TBS058 (nolock) right join TBS055 (nolock) on TBS058.PRPNUM=TBS055.PDVNUM
                                      left join TBS032 (nolock) on TBS058.PROCOD=TBS032.PROCOD
 where PRPSIT='P' and
       PRPMOVEST='S' and
       PDVDATCAD<=convert(char(8),getdate()-16,112) and 
       PDVDATCAD>=convert(char(8),getdate()-30,112) and
       ESTLOC=PRPESTLOC and
       ESTQTDCMP>=PRPQTD*PRPQTDEMB

-- acima de 30 dias
select count(*) from TBS058 (nolock) right join TBS055 (nolock) on TBS058.PRPNUM=TBS055.PDVNUM
                                      left join TBS032 (nolock) on TBS058.PROCOD=TBS032.PROCOD
 where PRPSIT='P' and
       PRPMOVEST='S' and
       PDVDATCAD<convert(char(8),getdate()-30,112) and
       ESTLOC=PRPESTLOC and
       ESTQTDCMP>=PRPQTD*PRPQTDEMB


-----

print 'até 2 dias ' + convert(char(8),getdate()-2,112)
print 'de 3 a 7 dias ' + convert(char(8),getdate()-7,112) + ' ' + convert(char(8),getdate()-3,112)
--print convert(char(8),getdate()-7,112)
print 'de 8 a 15 dias ' + convert(char(8),getdate()-15,112) + ' ' + convert(char(8),getdate()-8,112)
--print convert(char(8),getdate()-15,112)
print 'de 16 a 30 dias ' + convert(char(8),getdate()-30,112) + ' ' + convert(char(8),getdate()-16,112)
print 'acima de 30 dias ' + convert(char(8),getdate()-30,112)


select PDVNUM,PDVDATCAD from TBS055 (nolock) where PDVDATCAD>=convert(char(8),getdate()-2,112)

select PDVNUM,PDVDATCAD from TBS055 (nolock)
 where PDVDATCAD<=convert(char(8),getdate()-3,112) and 
       PDVDATCAD>=convert(char(8),getdate()-7,112)
 order by PDVDATCAD desc

