select * from master..sysservers

-- TBS092: NCM

drop table TBS092_BKP

select * from TBS092_BKP (nolock)

select * into TBS092_BKP from TBS092 (nolock)

drop table TBS0921_BKP

select * from TBS0921_BKP (nolock)

select * into TBS0921_BKP from TBS0921 (nolock)

delete TBS092 

begin tran;
   merge TBS092 as destino
   using nd.SIBD.dbo.TBS092 as origem
   on destino.NCMCOD collate database_default = origem.NCMCOD and destino.NCMEX collate database_default = origem.NCMEX
	
   -- se encontrado
   when matched then
      update
         set destino.NCMDES    = origem.NCMDES,
             destino.NCMALINAC = origem.NCMALINAC,
             destino.NCMALIIMP = origem.NCMALIIMP,
             destino.NCMVIGINI = origem.NCMVIGINI,
             destino.NCMVIGFIN = origem.NCMVIGFIN,
             destino.NCMCHV    = origem.NCMCHV,
             destino.NCMFONTAB = origem.NCMFONTAB,
             destino.NCMVER    = origem.NCMVER

   -- senão encontrado
   when not matched then 
      insert (
         NCMCOD,
         NCMEX,
         NCMDATCAD,
         NCMDES,
         NCMALINAC,
         NCMALIIMP,
         NCMVIGINI,
         NCMVIGFIN,
         NCMCHV,
         NCMFONTAB,
         NCMVER)  

        values (
           origem.NCMCOD,
           origem.NCMEX,
           getdate(),
           origem.NCMDES,
           origem.NCMALINAC,
           origem.NCMALIIMP,
           origem.NCMVIGINI,
           origem.NCMVIGFIN,
           origem.NCMCHV,
           origem.NCMFONTAB,
           origem.NCMVER);

output $action, INSERTED.*;

-- rollback tran
-- commit tran

select count(*) from TBS092 (nolock)

select * from TBS092 (nolock)

update TBS092 set NCMALIPIS=0,NCMALICOF=0,NCMIVA=0,NCMALIIPI=0

update TBS0921 set NCMUFORI='' where NCMUFORI is null

-- TBS0921: NCM/estado

select count(*) from TBS0921 (nolock)

delete TBS0921

begin tran;
   merge TBS0921 as destino
   using nd.SIBD.dbo.TBS0921 as origem
   on destino.NCMCOD collate database_default = origem.NCMCOD and destino.NCMEX collate database_default = origem.NCMEX
	
   -- se encontrado
   when matched then
      update
         set destino.NCMMVA = origem.NCMMVA,
             destino.NCMIPI = origem.NCMIPI

   -- senão encontrado
   when not matched then 
      insert (
         NCMCOD,
         NCMEX,
         UFESIG,
         NCMMVA,
         NCMIPI)  

        values (
           origem.NCMCOD,
           origem.NCMEX,
           origem.UFESIG,
           origem.NCMMVA,
           origem.NCMIPI);

output $action, INSERTED.*;

-- rollback tran
-- commit tran

select * from TBS0921 (nolock)
