declare @nota int

set @nota = 4

begin tran
-- corrige desconto
update TBS0671 set NFSPDDITE = NFSPDDTOT from TBS067 where TBS0671.NFSNUM = @nota and TBS0671.NFSNUM = TBS067.NFSNUM
update TBS067 set NFSPDDTOT = 0 where NFSNUM = @nota

-- corrige base calculo icms
update TBS0671 set NFSPBI = 0 where NFSNUM = @nota and NFSPBI > 0 and NFSPERICMS = 0

-- corrige codigo do produto
update MSL002 set M2_PROCOD = replicate('0',7-Len(M2_PROCOD))+M2_PROCOD where M2_PROCOD <> '' and Len(M2_PROCOD) >= 5 and Len(M2_PROCOD) < 7