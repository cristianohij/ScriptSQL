-- apaga dados da tabela atual

delete TBS092 

-- copia dadoas atualizados da tanby matriz

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

-- apaga dados de ncm por estados

delete TBS0921

-- atauliza conforme tabela da tanby matriz

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
