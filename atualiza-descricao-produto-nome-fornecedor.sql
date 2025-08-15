-- TBS010: proudtos
-- nome do fornecedor
select count(*)
  from TBS010 (nolock) join
       TBS006 (nolock) on
       TBS006.FORCOD=TBS010.FORCOD
 where TBS006.FORNOM<>TBS010.FORNOM

begin tran
update TBS010 set FORNOM=TBS006.FORNOM
  from TBS010 (nolock) inner join TBS006 (nolock) on TBS006.FORCOD=TBS010.FORCOD
 where TBS006.FORNOM<>TBS010.FORNOM
commit tran

-- nome da marca
select count(*)
  from TBS010 (nolock) inner join TBS014 (nolock) on TBS014.MARCOD=TBS010.MARCOD
 where TBS014.MARNOM<>TBS010.MARNOM

begin tran
update TBS010 set MARNOM=TBS014.MARNOM
  from TBS010 (nolock) inner join TBS014 (nolock) on TBS014.MARCOD=TBS010.MARCOD
 where TBS014.MARNOM<>TBS010.MARNOM
commit tran


-- TBS032: estoque
-- código da marca
select count(*)
  from TBS032 (nolock) inner join TBS010 (nolock) on TBS010.PROCOD=TBS032.PROCOD
 where TBS032.MARCOD<>TBS010.MARCOD

begin tran
update TBS032 set MARCOD=TBS010.MARCOD
  from TBS032 (nolock) inner join TBS010 (nolock) on TBS010.PROCOD=TBS032.PROCOD
 where TBS032.MARCOD<>TBS010.MARCOD
commit tran

-- código do fornecedor
select count(*)
  from TBS032 (nolock) inner join TBS010 (nolock) on TBS010.PROCOD=TBS032.PROCOD
 where TBS032.FORCOD<>TBS010.FORCOD

begin tran
update TBS032 set FORCOD=TBS010.FORCOD
  from TBS032 (nolock) inner join TBS010 (nolock) on TBS010.PROCOD=TBS032.PROCOD
 where TBS032.FORCOD<>TBS010.FORCOD
commit tran

-- descrição do produto
select count(*)
  from TBS032 (nolock) inner join TBS010 (nolock) on TBS010.PROCOD=TBS032.PROCOD
 where TBS032.PRODES<>TBS010.PRODES

begin tran
update TBS032 set PRODES=TBS010.PRODES
  from TBS032 (nolock) inner join TBS010 (nolock) on TBS010.PROCOD=TBS032.PROCOD
 where TBS032.PRODES<>TBS010.PRODES
commit tran


select top 1 * from TBS015 (nolock)

-- TBS015: politica preços

-- descrição do produto
select count(*)
  from TBS015 (nolock)
       inner join TBS010 (nolock) on TBS015.PDPCOD=TBS010.PROCOD
 where TBS015.PRODES<>TBS010.PRODES

begin tran
update TBS015 set PRODES=TBS010.PRODES
  from TBS015 (nolock) inner join TBS010 (nolock) on TBS015.PDPCOD=TBS010.PROCOD
 where TBS015.PRODES<>TBS010.PRODES
commit tran

select top 1 * from TBS058 (nolock)

-- TBS058: pedidos pendentes/reservados
-- código da marca
select count(*)
  from TBS058 (nolock) inner join TBS010 (nolock) on TBS010.PROCOD=TBS058.PROCOD
 where TBS058.PRPMARCOD<>TBS010.MARCOD

begin tran
update TBS058 set PRPMARCOD=TBS010.MARCOD
  from TBS058 (nolock) inner join TBS010 (nolock) on TBS010.PROCOD=TBS058.PROCOD
 where TBS058.PRPMARCOD<>TBS010.MARCOD
commit tran

-- TBS058: pedidos pendentes/reservados
-- código do fornecedor
select count(*)
  from TBS058 (nolock) inner join TBS010 (nolock) on TBS010.PROCOD=TBS058.PROCOD
 where TBS058.PRPFORCOD<>TBS010.FORCOD

begin tran
update TBS058 set PRPFORCOD=TBS010.FORCOD
  from TBS058 (nolock) inner join TBS010 (nolock) on TBS010.PROCOD=TBS058.PROCOD
 where TBS058.PRPFORCOD<>TBS010.FORCOD
commit tran

-- nome da marca
select count(*)
  from TBS058 (nolock) inner join TBS014 (nolock) on TBS014.MARCOD=TBS058.PRPMARCOD
 where TBS058.PRPMARNOM<>TBS014.MARNOM

begin tran
update TBS058 set PRPMARNOM=TBS014.MARNOM
  from TBS058 (nolock) inner join TBS014 (nolock) on TBS014.MARCOD=TBS058.PRPMARCOD
 where TBS058.PRPMARNOM<>TBS014.MARNOM
commit tran
