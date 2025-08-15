-- tanby taubaté

-- F00.00 = 15.337,40
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT),sum(M2_VALTOT - M2_ABT)
  from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_NUMECF = 15 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='F00.00'
 group by M2_TIPREG,M2_REGCAN

-- I00.00 = 3,60
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT),sum(M2_VALTOT - M2_ABT)
  from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_NUMECF = 15 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='I00.00'
 group by M2_TIPREG,M2_REGCAN

-- T07.00 = 371,70
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT),sum(M2_VALTOT - M2_ABT)
  from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_NUMECF = 15 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='T07.00'
 group by M2_TIPREG,M2_REGCAN

-- T18.00 = 5.762,41
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT),sum(M2_VALTOT - M2_ABT)
  from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_NUMECF = 15 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='T18.00'
 group by M2_TIPREG,M2_REGCAN

-- DT (desconto total) = 84,29
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT),sum(M2_VALTOT - M2_ABT)
  from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_NUMECF = 15 and M2_TIPREG='02' and M2_REGCAN='F'
 group by M2_TIPREG,M2_REGCAN

-- CT (cancelamento total) = 1.480,58
select M2_REGCAN,sum(M2_VALTOT),sum(M2_VALTOT - M2_ABT)
  from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_NUMECF = 15 and M2_REGCAN='T' and M2_TIPREG in('02','04','10','11')
 group by M2_REGCAN