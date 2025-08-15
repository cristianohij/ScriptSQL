-- TBS126: categorias de contas

begin tran;
   merge TBS126 as destino
   using nd.SIBD.dbo.TBS126 as origem
   on destino.CTCCOD = origem.CTCCOD
	
   -- se encontrado
   when matched then
      update
         set destino.CTCDES       = origem.CTCDES,
             destino.CTCTIP       = origem.CTCTIP,
             destino.CTFSUBCOD    = origem.CTFSUBCOD,
             destino.CTFCOD       = origem.CTFCOD,
             destino.CTCALICOFINS = origem.CTCALICOFINS,
             destino.CTCALIPIS    = origem.CTCALIPIS,
             destino.CTCALIICMS   = origem.CTCALIICMS,
             destino.CTCCFOPEXT   = origem.CTCCFOPEXT,
             destino.CTCCFOPINT   = origem.CTCCFOPINT

   -- senão encontrado
   when not matched then 
      insert (
         CTCEMPCOD,
         CTCCOD,
         CTCDES,
         CTCTIP,
         CTFSUBCOD,
         CTFCOD,
         CTFEMPCOD,
         CTCALICOFINS,
         CTCALIPIS,
         CTCALIICMS,
         CTCCFOPEXT,
         CTCCFOPINT)

        values (
           origem.CTCEMPCOD,
           origem.CTCCOD,
           origem.CTCDES,
           origem.CTCTIP,
           origem.CTFSUBCOD,
           origem.CTFCOD,
           origem.CTFEMPCOD,
           origem.CTCALICOFINS,
           origem.CTCALIPIS,
           origem.CTCALIICMS,
           origem.CTCCFOPEXT,
           origem.CTCCFOPINT)

output $action, INSERTED.*;

update TBS024 set TBSVALSEQ=(select max(CTCCOD) from TBS126 (nolock)) where TBSNOM='TBS126'

-- rollback tran
-- commit tran
