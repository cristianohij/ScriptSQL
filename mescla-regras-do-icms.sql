-- TBS110: regras do ICMS

begin tran;
   merge TBS110 as destino
   using nd.SIBD.dbo.TBS110 as origem
   on destino.ROPREG = origem.ROPREG
	
   -- se encontrado
   when matched then
      update
         set destino.ROPCTR      =origem.ROPCTR,
             destino.ROPTIPOPE   =origem.ROPTIPOPE,
             destino.ROPNATOPE   =origem.ROPNATOPE,
             destino.ROPCFOP     =origem.ROPCFOP,
             destino.ROPTIPNF    =origem.ROPTIPNF,
             destino.ROPCONICMS  =origem.ROPCONICMS,
             destino.ROPFINAQU   =origem.ROPFINAQU,
             destino.ROPDES      =origem.ROPDES,
             destino.ROPPROCOD   =origem.ROPPROCOD,
             destino.ROPNCM      =origem.ROPNCM,
             destino.ROPICMSORI  =origem.ROPICMSORI,
             destino.ROPICMSPRO  =origem.ROPICMSPRO,
             destino.ROPICMSDES  =origem.ROPICMSDES,
             destino.ROPCSTPIS   =origem.ROPCSTPIS,
             destino.ROPALIPIS   =origem.ROPALIPIS,
             destino.ROPCSTCOFINS=origem.ROPCSTCOFINS,
             destino.ROPALICOFINS=origem.ROPALICOFINS,
             destino.ROPMOVEST   =origem.ROPMOVEST,
             destino.ROPCNTVEN   =origem.ROPCNTVEN,
             destino.ROPGERCRE   =origem.ROPGERCRE,
             destino.ROPGERCOM   =origem.ROPGERCOM,
             destino.ROPULTITE   =origem.ROPULTITE

   -- senão encontrado
   when not matched then 
      insert (
         ROPREG,
         ROPCTR,
         ROPTIPOPE,
         ROPNATOPE,
         ROPCFOP,
         ROPTIPNF,
         ROPCONICMS,
         ROPFINAQU,
         ROPDES,
         ROPPROCOD,
         ROPNCM,
         ROPICMSORI,
         ROPICMSPRO,
         ROPICMSDES,
         ROPCSTPIS,
         ROPALIPIS,
         ROPCSTCOFINS,
         ROPALICOFINS,
         ROPMOVEST,
         ROPCNTVEN,
         ROPGERCRE,
         ROPGERCOM,
         ROPULTITE)  

         values (
            origem.ROPREG,
            origem.ROPCTR,
            origem.ROPTIPOPE,
            origem.ROPNATOPE,
            origem.ROPCFOP,
            origem.ROPTIPNF,
            origem.ROPCONICMS,
            origem.ROPFINAQU,
            origem.ROPDES,
            origem.ROPPROCOD,
            origem.ROPNCM,
            origem.ROPICMSORI,
            origem.ROPICMSPRO,
            origem.ROPICMSDES,
            origem.ROPCSTPIS,
            origem.ROPALIPIS,
            origem.ROPCSTCOFINS,
            origem.ROPALICOFINS,
            origem.ROPMOVEST,
            origem.ROPCNTVEN,
            origem.ROPGERCRE,
            origem.ROPGERCOM,
            origem.ROPULTITE)

output $action, INSERTED.*;

-- rollback tran
-- commit tran


-- TBS1101: itens das regras do ICMS

begin tran;
   merge TBS1101 as destino
   using nd.SIBD.dbo.TBS1101 as origem
   on destino.ROPREG = origem.ROPREG and
      destino.ROPITE = origem.ROPITE
	
   -- se encontrado
   when matched then
      update
         set destino.ROPCST        =origem.ROPCST,
             destino.ROPCSTICMSORI =origem.ROPCSTICMSORI,
             destino.ROPCSTCOMST   =origem.ROPCSTCOMST,
             destino.ROPCSTSEMST   =origem.ROPCSTSEMST,
             destino.ROPCSTCFOP    =origem.ROPCSTCFOP,
             destino.ROPCSTICMSPRO =origem.ROPCSTICMSPRO,
             destino.ROPCSTICMSDES =origem.ROPCSTICMSDES,
             destino.ROPREDBCICMS  =origem.ROPREDBCICMS,
             destino.ROPREDBCICMSST=origem.ROPREDBCICMSST,
             destino.ROPTIPCAL     =origem.ROPTIPCAL,
             destino.ROPCSOSNOPE   =origem.ROPCSOSNOPE,
             destino.ROPCSNSEMST   =origem.ROPCSNSEMST,
             destino.ROPCSNCOMST   =origem.ROPCSNCOMST,
             destino.ROPCSOSN      =origem.ROPCSOSN

   -- senão encontrado
   when not matched then 
      insert (
        ROPREG,
        ROPITE,
        ROPCST,
        ROPCSTICMSORI,
        ROPCSTCOMST,
        ROPCSTSEMST,
        ROPCSTCFOP,
        ROPCSTICMSPRO,
        ROPCSTICMSDES,
        ROPREDBCICMS,
        ROPREDBCICMSST,
        ROPTIPCAL,
        ROPCSOSNOPE,
        ROPCSNSEMST,
        ROPCSNCOMST,
        ROPCSOSN)  

        values (
           origem.ROPREG,
           origem.ROPITE,
           origem.ROPCST,
           origem.ROPCSTICMSORI,
           origem.ROPCSTCOMST,
           origem.ROPCSTSEMST,
           origem.ROPCSTCFOP,
           origem.ROPCSTICMSPRO,
           origem.ROPCSTICMSDES,
           origem.ROPREDBCICMS,
           origem.ROPREDBCICMSST,
           origem.ROPTIPCAL,
           origem.ROPCSOSNOPE,
           origem.ROPCSNSEMST,
           origem.ROPCSNCOMST,
           origem.ROPCSOSN)

output $action, INSERTED.*;

-- rollback tran
-- commit tran



-- TBS024: tabelas do sistema

-- atualiza o sequêncial de registros

begin tran
update TBS024 set TBSVALSEQ=(select max(ROPREG) from TBS110 (nolock)) where TBSNOM='TBS110'

-- rollback tran
-- commit tran
