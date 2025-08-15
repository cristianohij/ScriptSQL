-- pedidos de compras
select count(*) from TBS045 (nolock) where PDCBLQ=''
update TBS045 set PDCBLQ='N' where PDCBLQ=''

-- cadastro de produtos
select count(*) from TBS010 (nolock) where PROPESAVEL=''
update TBS010 set PROPESAVEL='N' where PROPESAVEL=''
update TBS010 set PROPESAVEL='S' where PROUM1='KG'
update TBS010 set PROPESAVEL='S' where PROUM1='LT'
update TBS010 set PROPESAVEL='S' where PROUM1='MT'

update TBS010 set PROPESAVEL='S' where PROPESAVEL='' and PROUM1='KG'
update TBS010 set PROPESAVEL='S' where PROPESAVEL='' and PROUM1='LT'
update TBS010 set PROPESAVEL='S' where PROPESAVEL='' and PROUM1='MT'

-- pedidos de vendas
select count(*) from TBS0551 (nolock) where PDVPROPESAVEL=''
update TBS0551 set PDVPROPESAVEL=(select PROPESAVEL from TBS010 (nolock) where TBS010.PROCOD=TBS0551.PROCOD) where PDVPROPESAVEL=''

select count(*) from TBS0551 (nolock) where PDVQTDAUX=0 and PDVPROPESAVEL='N'
update TBS0551 set PDVQTDAUX=PDVQTD where PDVQTDAUX=0 and PDVPROPESAVEL='N'

select count(*) from TBS0551 (nolock) where PDVQTDPES=0 and PDVPROPESAVEL='S'
update TBS0551 set PDVQTDPES=PDVQTD where PDVQTDPES=0 and PDVPROPESAVEL='S'

-- orçamentos
select count(*) from TBS0431 (nolock) where ORCPROPESAVEL=''
update TBS0431 set ORCPROPESAVEL=(select PROPESAVEL from TBS010 (nolock) where TBS010.PROCOD=TBS0431.PROCOD) where ORCPROPESAVEL=''

select count(*) from TBS0431 (nolock) where ORCQTDAUX=0 and ORCPROPESAVEL='N'
update TBS0431 set ORCQTDAUX=ORCQTD where ORCQTDAUX=0 and ORCPROPESAVEL='N'

select count(*) from TBS0431 (nolock) where ORCQTDPES=0 and ORCPROPESAVEL='S'
update TBS0431 set ORCQTDPES=ORCQTD where ORCQTDPES=0 and ORCPROPESAVEL='S'

select count(*) from TBS043 (nolock) where ORCSHELLBY<>'N'
update TBS043 set ORCSHELLBY='N' where ORCSHELLBY<>'N'

-- pedidos de vendas pendentes/reservados
select count(*) from TBS058 (nolock) where PRPQTDCONF=0 and PRPCNF='S'
update TBS058 set PRPQTDCONF=PRPQTD where PRPQTDCONF=0 and PRPCNF='S'
