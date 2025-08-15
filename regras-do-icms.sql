-- fora do estado

-- cabeçalho

declare @registro int
set @registro=9

select ROPREG as 'registro',
       ROPTIPOPE as 'tipo operação',
       ROPNATOPE as 'natureza operação',
       ROPTIPNF as 'tipo nf',
       ROPDES as 'destino',
       ROPCONICMS as 'contribuinte icms',
       ROPFINAQU as 'finalidade aquisição',
       ROPPROCOD as 'codigo produto',
       ROPNCM as 'ncm',
       ROPCFOP as 'cfop',
       ROPICMSORI as 'icms origem',
       ROPICMSPRO as 'icms próprio',
       ROPICMSDES as 'icms destino',
       ROPCSTPIS as 'cst-pis',
       ROPCSTPISST as 'cst-pis-st',
       ROPCSTCOFINS as 'cst-cofins',
       ROPCSTCOFINSST as 'cst-cofins-st',
       ROPALIPIS as 'alíquota pis',
       ROPALIPISST as 'alíquota pis-st',
       ROPALICOFINS as 'alíquota cofins',
       ROPALICOFINSST as 'alíquota cofins-st',
       ROPMOVEST as 'movimenta estoque',
       ROPCNTVEN as 'contabiliza vendas',
       ROPGERCRE as 'gera crédito',
       ROPGERCOM as 'gera comissão'
  from TBS110 (nolock)
 where ROPCTR='FE' and
       ROPREG=@registro

-- item

select ROPITE as 'item',
       ROPCST as 'cst-icms produto',
       ROPCSTICMSORI as 'icms interno produto',
       ROPCSTCOMST as 'cst com st',
       ROPCSTSEMST as 'cst sem st',
       ROPCSTCFOP as 'cfop',
       ROPCSTICMSPRO as 'icms próprio',
       ROPCSTICMSDES as 'icms destino',
       ROPREDBCICMS as 'redução bc icms',
       ROPREDBCICMSST as 'redução bc icms-st',
       ROPTIPCAL as 'tipo cálculo st'
  from TBS1101 (nolock) join TBS110 (nolock) on TBS1101.ROPREG=TBS110.ROPREG
 where TBS110.ROPCTR='FE' and
       TBS1101.ROPREG=@registro


-- dentro do estado

declare @registro int
set @registro=1

select ROPREG as 'registro',
       ROPTIPOPE as 'tipo operação',
       ROPNATOPE as 'natureza operação',
       ROPTIPNF as 'tipo nf',
       ROPPROCOD as 'codigo produto',
       ROPNCM as 'ncm',
       ROPCFOP as 'cfop',
       ROPICMSPRO as 'icms próprio',
       ROPCSTPIS as 'cst-pis',
       ROPCSTPISST as 'cst-pis-st',
       ROPCSTCOFINS as 'cst-cofins',
       ROPCSTCOFINSST as 'cst-cofins-st',
       ROPALIPIS as 'alíquota pis',
       ROPALIPISST as 'alíquota pis-st',
       ROPALICOFINS as 'alíquota cofins',
       ROPALICOFINSST as 'alíquota cofins-st',
       ROPMOVEST as 'movimenta estoque',
       ROPCNTVEN as 'contabiliza vendas',
       ROPGERCRE as 'gera crédito',
       ROPGERCOM as 'gera comissão'
  from TBS110 (nolock)
 where ROPCTR='DE' and
       ROPREG=@registro

-- item

select ROPITE as 'item',
       ROPCST as 'cst-icms produto',
       ROPCSTICMSORI as 'icms interno produto',
       ROPCSTCFOP as 'cfop',
       ROPCSTICMSPRO as 'icms próprio',
       ROPREDBCICMS as 'redução bc icms'
  from TBS1101 (nolock) join TBS110 (nolock) on TBS1101.ROPREG=TBS110.ROPREG
 where ROPCTR='DE' and
       TBS1101.ROPREG=@registro
