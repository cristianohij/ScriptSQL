-- pedidos de vendas sem a finalidade de emissão

select PDVFINNFE,* from TBS055 (nolock) where PDVFINNFE=0 and exists(select '' from TBS058 (nolock) where PRPNUM=PDVNUM)

begin tran
update TBS055 set PDVFINNFE=1 where PDVFINNFE=0 and exists(select '' from TBS058 (nolock) where PRPNUM=PDVNUM)
commit tran


-- notas fiscais sem a finalidade da emissão

select NFSFINNFE,* from TBS067 (nolock) where NFSDATEMI >= '20150101' and NFSFINNFE=0

begin tran
update TBS067 set NFSFINNFE=1 where NFSDATEMI >= '20141101' and NFSFINNFE=0
commit tran


-- notas fiscais eletronicas sem a finalidade da emissão

select ENFFINEMI,* from TBS080 (nolock) where ENFDATEMI >= '20150101' and ENFFINEMI=0

-- saída

begin tran
update TBS080 set ENFFINEMI=1 where ENFDATEMI >= '20141101' and ENFTIPDOC=1 and ENFFINEMI=0
commit tran

-- entrada

begin tran
update TBS080 set ENFFINEMI=4 where ENFDATEMI >= '20141101' and ENFTIPDOC=0 and ENFFINEMI=0
