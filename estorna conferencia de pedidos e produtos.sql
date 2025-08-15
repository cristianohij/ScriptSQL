-- produtos com codigo de marca com 3 digitos
declare @marca char(3)
set @marca='164'

-- lista pedidos e produtos
select * from TBS058 (noLock) where PRPSIT='R' and PRPCNF='S' and subString(PROCOD,1,3)=@marca

-- estorna a conferencia dos pedidos e produtos listados
update TBS058 set PRPCNF='N' where PRPSIT='R' and PRPCNF='S' and subString(PROCOD,1,3)=@marca


-- produtos com codigo de marca com 4 digitos
declare @marca char(4)
set @marca='1000'

-- lista pedidos e produtos
select * from TBS058 (noLock) where PRPSIT='R' and PRPCNF='S' and subString(PROCOD,1,4)=@marca

-- estorna a conferencia dos pedidos e produtos listados
update TBS058 set PRPCNF='N' where PRPSIT='R' and PRPCNF='S' and subString(PROCOD,1,4)=@marca