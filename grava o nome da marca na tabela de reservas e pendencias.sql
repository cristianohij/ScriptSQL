select PRPMARCOD,MARCOD,MARNOM,* from TBS058 (noLock) inner join TBS014 on PRPMARCOD=MARCOD where PRPMARNOM=''

begin tran
update TBS058 set PRPMARNOM=MARNOM from TBS058 inner join TBS014 on PRPMARCOD=MARCOD where PRPMARNOM=''
commit tran

select * from TBS058 (noLock) inner join TBS014 (noLock) on PRPMARCOD=MARCOD where PRPMARNOM<>MARNOM

select * from TBS058 (noLock) inner join TBS014 (noLock) on PRPMARCOD=MARCOD where PRPMARNOM<>MARNOM

update TBS058 set PRPMARNOM=MARNOM from TBS058 inner join TBS014 on PRPMARCOD=MARCOD where PRPMARNOM<>MARNOM


-- fornecedor
select * from TBS058 (noLock) inner join TBS010 (noLock) on TBS058.PROCOD=TBS010.PROCOD where PRPFORCOD<>FORCOD

begin tran
update TBS058 set PRPFORCOD=FORCOD from TBS058 (noLock) inner join TBS010 (noLock) on TBS058.PROCOD=TBS010.PROCOD
 where PRPFORCOD<>FORCOD
commit tran

-- marca
select * from TBS058 (noLock) inner join TBS010 (noLock) on TBS058.PROCOD=TBS010.PROCOD where PRPMARCOD<>MARCOD

begin tran
update TBS058 set PRPMARCOD=MARCOD,PRPMARNOM=MARNOM
  from TBS058 (noLock) inner join TBS010 (noLock) on TBS058.PROCOD=TBS010.PROCOD
 where PRPMARCOD<>MARCOD
commit tran


select MARCOD,MARNOM,FORCOD,FORNOM,* from TBS010 (noLock) where PROCOD='0472507'

select PRPMARCOD,PRPMARNOM,PRPFORCOD,* from TBS058 (noLock) where PROCOD='0472507'

select * from TMP004 (noLock)

select * from TBS058 (noLock) where PRPFORCOD=0 or PRPMARCOD=0

