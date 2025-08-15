begin tran
update MSL002 set M2_REGCAN='F' where M2_DAT between '20130901' and '20130930'
commit tran

begin tran
update MSL002 set M2_REGCAN='T' where M2_DAT between '20130901' and '20130930' and M2_TIPREG in('04','10','11') and M2_REGCAN<>'T'
commit tran
rollback tran

begin tran
update MSL002 set M2_REGCAN='F' where M2_DAT between '20130901' and '20130930' and M2_TIPREG not in('04','10','11')
commit tran

--drop table #CUPCAN

select M2_EMPCOD,
       M2_LOJ,
       M2_CXA,
       M2_DAT,
       M2_NUMDOC,
       M2_NUMPED,
       M2_TIPDOC
  into #CUPCAN
  from MSL002 (nolock) where M2_DAT between '20130901' and '20130930' and M2_TIPREG = '04'

select * from #CUPCAN

--drop table #VENCAN

select M2_EMPCOD,
       M2_LOJ,
       M2_CXA,
       M2_DAT,
       M2_NUMDOC,
       M2_NUMPED,
       M2_TIPDOC
  into #VENCAN
  from MSL002 (nolock) where M2_DAT between '20130901' and '20130930' and M2_TIPREG = '11'

select * from #VENCAN

begin tran
update MSL002 set M2_REGCAN='T'
 where M2_DAT between '20130901' and '20130930' and M2_TIPREG<>'04' and M2_REGCAN<>'T' and
       exists(select '' from #CUPCAN
               where #CUPCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #CUPCAN.M2_LOJ=MSL002.M2_LOJ and #CUPCAN.M2_CXA=MSL002.M2_CXA and #CUPCAN.M2_DAT=MSL002.M2_DAT and
                     #CUPCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #CUPCAN.M2_NUMPED=MSL002.M2_NUMPED and #CUPCAN.M2_TIPDOC=MSL002.M2_TIPDOC)
commit tran

-- acrescentados os atributos M2_CONCUPFIS (CCF = contador de cupom fiscal) e M2_COO (COO = contador de ordem de operação)

select M2_EMPCOD,
       M2_LOJ,
       M2_CXA,
       M2_DAT,
       M2_NUMDOC,
       M2_NUMPED,
       M2_TIPDOC,
       M2_CONCUPFIS,
       M2_COO
  into #CUPCAN
  from MSL002 (nolock) where M2_DAT between '20130901' and '20130930' and M2_TIPREG = '04'

begin tran
update MSL002 set M2_REGCAN='T'
 where M2_DAT between '20130901' and '20130930' and M2_TIPREG<>'04' and M2_REGCAN<>'T' and
       exists(select '' from #CUPCAN
               where #CUPCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #CUPCAN.M2_LOJ=MSL002.M2_LOJ and #CUPCAN.M2_CXA=MSL002.M2_CXA and #CUPCAN.M2_DAT=MSL002.M2_DAT and
                     #CUPCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #CUPCAN.M2_NUMPED=MSL002.M2_NUMPED and #CUPCAN.M2_TIPDOC=MSL002.M2_TIPDOC and 
                     #CUPCAN.M2_CONCUPFIS=MSL002.M2_CONCUPFIS and #CUPCAN.M2_COO=MSL002.M2_COO)
commit tran

select M2_EMPCOD,
       M2_LOJ,
       M2_CXA,
       M2_DAT,
       M2_NUMDOC,
       M2_NUMPED,
       M2_TIPDOC,
       M2_CONCUPFIS,
       M2_COO
  into #VENCAN
  from MSL002 (nolock) where M2_DAT between '20130901' and '20130930' and M2_TIPREG = '11'

select * from #VENCAN

begin tran
update MSL002 set M2_REGCAN='T'
 where M2_DAT between '20130901' and '20130930' and M2_TIPREG<>'11' and M2_REGCAN<>'T' and
       exists(select '' from #VENCAN
               where #VENCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #VENCAN.M2_LOJ=MSL002.M2_LOJ and #VENCAN.M2_CXA=MSL002.M2_CXA and #VENCAN.M2_DAT=MSL002.M2_DAT and
                     #VENCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #VENCAN.M2_NUMPED=MSL002.M2_NUMPED and #VENCAN.M2_TIPDOC=MSL002.M2_TIPDOC and
                     #VENCAN.M2_CONCUPFIS=MSL002.M2_CONCUPFIS and #VENCAN.M2_COO=MSL002.M2_COO)
commit tran

--

begin tran
update MSL002 set M2_REGCAN='T'
 where M2_DAT between '20130901' and '20130930' and M2_TIPREG<>'11' and M2_REGCAN<>'T' and
       exists(select '' from #VENCAN
               where #VENCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #VENCAN.M2_LOJ=MSL002.M2_LOJ and #VENCAN.M2_CXA=MSL002.M2_CXA and #VENCAN.M2_DAT=MSL002.M2_DAT and
                     #VENCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #VENCAN.M2_NUMPED=MSL002.M2_NUMPED and #VENCAN.M2_TIPDOC=MSL002.M2_TIPDOC)
commit tran


-- sharpel

update MSL002 set M2_REGCAN='F' where M2_DATMOV between '20130918' and '20130918' and M2_NUMECF=3

update MSL002 set M2_REGCAN='T' where M2_DATMOV between '20130918' and '20130918' and M2_TIPREG in('04','10','11') and M2_NUMECF=3

select M2_EMPCOD,
       M2_LOJ,
       M2_NUMECF,
       M2_DATMOV,
       M2_NUMDOC,
       M2_TIPDOC,
       M2_COO
  into #CUPCAN
  from MSL002 (nolock) where M2_DAT between '20130901' and '20130930' and M2_TIPREG = '04' --and M2_NUMECF=3

begin tran
update MSL002 set M2_REGCAN='T'
 where M2_DAT between '20130901' and '20130930' and M2_TIPREG<>'04' and M2_REGCAN<>'T' and --M2_NUMECF=3 and
       exists(select '' from #CUPCAN
               where #CUPCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #CUPCAN.M2_LOJ=MSL002.M2_LOJ and #CUPCAN.M2_NUMECF=MSL002.M2_NUMECF and
                     #CUPCAN.M2_DATMOV=MSL002.M2_DATMOV and #CUPCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #CUPCAN.M2_TIPDOC=MSL002.M2_TIPDOC and 
                     #CUPCAN.M2_COO=MSL002.M2_COO)
commit tran
