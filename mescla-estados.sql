-- TBS001: estados

begin tran;
   merge TBS001 as destino
   using nd.SIBD.dbo.TBS001 as origem
   on destino.UFESIG collate database_default = origem.UFESIG
	
   -- se encontrado
   when matched then
      update
         set destino.UFENOM     = origem.UFENOM,
             destino.UFEICM     = origem.UFEICM,
             destino.UFECODIBGE = origem.UFECODIBGE,
             destino.UFEICMPRO  = origem.UFEICMPRO,
             destino.UFEICMSST  = origem.UFEICMSST,
             destino.UFEFCEP    = origem.UFEFCEP,
             destino.UFEFCEPLEI = origem.UFEFCEPLEI,
             destino.UFECODGIA  = origem.UFECODGIA

   -- senão encontrado
   when not matched then 
      insert (
         UFESIG,
         UFENOM,
         UFEICM,
         UFECODIBGE,
         UFEICMPRO,
         UFEICMSST,
         UFEFCEP,
         UFEFCEPLEI,
         UFECODGIA)

        values (
           origem.UFESIG,
           origem.UFENOM,
           origem.UFEICM,
           origem.UFECODIBGE,
           origem.UFEICMPRO,
           origem.UFEICMSST,
           origem.UFEFCEP,
           origem.UFEFCEPLEI,
           origem.UFECODGIA)

output $action, INSERTED.*;

-- rollback tran
-- commit tran
