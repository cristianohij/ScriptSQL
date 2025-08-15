declare @periodoDe datetime, @periodoAte datetime

set @periodoDe = '20150113'
set @periodoAte= '20150113'

select M2_NUMDOC,M2_COO,
       M2_TIPREG,
       M2_REGCAN,
       M2_VALTOT,
       M2_ABT, 
       round(M2_VALTOT * ((select sum(cast(M2_VALTOT as decimal(20,8)))
                             from MSL002 B (nolock)
                            where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '02' and
                                  M2_DAT between @periodoDe and @periodoAte)
                          /
                          (select sum(cast(M2_VALTOT as decimal(20,8)))
                             from MSL002 B (nolock)
                            where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '01' and
                                  M2_DAT between @periodoDe and @periodoAte) ),3),
       ((select sum(cast(M2_VALTOT as decimal(20,8)))
           from MSL002 B (nolock)
          where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '02' and M2_DAT between @periodoDe and @periodoAte)
        /
        (select sum(cast(M2_VALTOT as decimal(20,8)))
           from MSL002 B(nolock)
          where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '01' and M2_DAT between @periodoDe and @periodoAte) )
  from MSL002 A (nolock)
 where M2_DAT between @periodoDe and @periodoAte and M2_TIPREG = '01' and M2_NUMECF=18 and
       M2_ABT != case
                    when (select sum(M2_VALTOT)
                            from MSL002 B(nolock)
                           where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '02' and
                                 M2_DAT between @periodoDe and @periodoAte) > 0
                    then round(M2_VALTOT * ((select sum(cast(M2_VALTOT as decimal(20,8)))
                                               from MSL002 B (nolock)
                                              where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '02' and
                                                    M2_DAT between @periodoDe and @periodoAte) 
                                            /
                                            (select sum(cast(M2_VALTOT as decimal(20,8)))
                                               from MSL002 B (nolock)
                                              where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '01' and
                                                    M2_DAT between @periodoDe and @periodoAte) ),3)
                    else M2_ABT
                 end
 order by M2_COO

declare @periodoDe datetime, @periodoAte datetime

set @periodoDe = '20131101'
set @periodoAte= '20131130'

--begin tran
update MSL002 set M2_ABT = round(M2_VALTOT * ((select sum(cast(M2_VALTOT as decimal(20,8))) from MSL002 B(nolock) where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '02' and M2_DAT between @periodoDe and @periodoAte)/
					                          (select sum(cast(M2_VALTOT as decimal(20,8))) from MSL002 B(nolock) where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '01' and M2_DAT between @periodoDe and @periodoAte)),3)
from MSL002 A(nolock)
where M2_DAT between @periodoDe and @periodoAte and M2_TIPREG = '01' and
		M2_ABT != case when (select sum(M2_VALTOT) from MSL002 B(nolock) where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '02' and M2_DAT between @periodoDe and @periodoAte) > 0 then
					round(M2_VALTOT * ((select sum(cast(M2_VALTOT as decimal(20,8))) from MSL002 B(nolock) where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '02' and M2_DAT between @periodoDe and @periodoAte)/
									   (select sum(cast(M2_VALTOT as decimal(20,8))) from MSL002 B(nolock) where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '01' and M2_DAT between @periodoDe and @periodoAte)),3)
				  else M2_ABT
				  end
				  
--commit tran
--rollback tran
				  
