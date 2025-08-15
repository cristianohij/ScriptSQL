-- MISASPEL

-- F00.00 = 36.207,90
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT),sum(M2_VALTOT - M2_ABT)
  from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_NUMECF = 2 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='F00.00'
 group by M2_TIPREG,M2_REGCAN

-- I00.00 = 119,87
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT),sum(M2_VALTOT - M2_ABT)
  from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_NUMECF = 2 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='I00.00'
 group by M2_TIPREG,M2_REGCAN

-- T12.00 = 113,81
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT),sum(M2_VALTOT - M2_ABT)
  from MSL002 (nolock)
 where M2_DAT between '20150112' and '20150112' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='T12.00'
 group by M2_TIPREG,M2_REGCAN

-- T18.00 = 29.639,78
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT),sum(M2_VALTOT - M2_ABT)
  from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_NUMECF = 2 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='T18.00'
 group by M2_TIPREG,M2_REGCAN

-- DT (desconto total) = 1.831,39
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT),sum(M2_VALTOT - M2_ABT)
  from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_NUMECF = 2 and M2_TIPREG='02' and M2_REGCAN='F'
 group by M2_TIPREG,M2_REGCAN

-- CT (cancelamento total) = 4.598,94
select M2_REGCAN,sum(M2_VALTOT),sum(M2_VALTOT - M2_ABT)
  from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_NUMECF = 2 and M2_REGCAN='T' and M2_TIPREG in('02','04','10','11')
 group by M2_REGCAN