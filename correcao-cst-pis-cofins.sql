-- tratamento do café
select PRODES,PROCLAFIS,PROSTBPIS,PROPIS,PROSTBCOFINS,PROCOFINS from TBS010 (nolock) where PRODES Like('CAFE %')

-- correções
begin tran
update TBS010 set PRODES=replace(PRODES,',','') from TBS010 (nolock) where PRODES Like('CAFE%') and PRODES Like('%,%')
commit tran

-- atualiza cst-pis/cofins
begin tran
update TBS010 set PROSTBPIS='06',PROPIS=0,PROSTBCOFINS='06',PROCOFINS=0 where PRODES Like('CAFE %')
commit tran


-- tratamento do açucar
select PRODES,PROCLAFIS,PROSTBPIS,PROPIS,PROSTBCOFINS,PROCOFINS from TBS010 (nolock) where PRODES Like('ACUCAR %')

-- atualiza cst-pis/cofins
begin tran
update TBS010 set PROSTBPIS='06',PROPIS=0,PROSTBCOFINS='06',PROCOFINS=0 where PRODES Like('ACUCAR %')
commit tran


-- tratamento do papel higiênico
select PRODES,PROCLAFIS,PROSTBPIS,PROPIS,PROSTBCOFINS,PROCOFINS from TBS010 (nolock) where PRODES Like('PAPEL HIGIENICO%') or PRODES Like('PAP HIGIENICO%')

-- atualiza cst-pis/cofins
begin tran
update TBS010 set PROSTBPIS='06',PROPIS=0,PROSTBCOFINS='06',PROCOFINS=0 where PRODES Like('PAPEL HIGIENICO%') or PRODES Like('PAP HIGIENICO%')
commit tran


-- tratamento do mapas
select PRODES,PROCLAFIS,PROSTBPIS,PROPIS,PROSTBCOFINS,PROCOFINS from TBS010 (nolock) where PRODES Like('MAPA%')

-- atualiza cst-pis/cofins
begin tran
update TBS010 set PROSTBPIS='06',PROPIS=0,PROSTBCOFINS='06',PROCOFINS=0 where PRODES Like('MAPA%')
commit tran
