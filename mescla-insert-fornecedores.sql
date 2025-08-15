-- TBS006: fornecedores

begin tran;
   merge TBS006 as destino
   using nd.SIBD.dbo.TBS006 as origem
   on destino.FORCOD = origem.FORCOD

   -- senão encontrado
   when not matched then 
      insert (
             FORCOD,
             FORNOM,
             FORNOMFAN,
             FOREND,
             FORBAI,
             FORCEP,
             FORCID,
             UFESIG,
             FORCGC,
             FORCPF,
             FORIES,
             FORIMU,
             FORTEL,
             FORFAX,
             FOREMAIL,
             FORURL,
             FORCONTAT,
             FORDATCAD,
             FORLIC,
             FORLICVEN,
             FORTIPPES,
             FORDATFUN,
             FOROBS,
             FORSINHAB,
             FORRECATI,
             FORCONRES,
             MUNCOD,
             FORNUM,
             FORCEL,
             FORDEHCONSIN,
             FORCRENFE,
             FORINIATI,
             FORDATMODSIN,
             FORDATBAISIN,
             FORHABSIN)
      values (
             origem.FORCOD,
             origem.FORNOM,
             origem.FORNOMFAN,
             origem.FOREND,
             origem.FORBAI,
             origem.FORCEP,
             origem.FORCID,
             origem.UFESIG,
             origem.FORCGC,
             origem.FORCPF,
             origem.FORIES,
             origem.FORIMU,
             origem.FORTEL,
             origem.FORFAX,
             origem.FOREMAIL,
             origem.FORURL,
             origem.FORCONTAT,
             origem.FORDATCAD,
             origem.FORLIC,
             origem.FORLICVEN,
             origem.FORTIPPES,
             origem.FORDATFUN,
             origem.FOROBS,
             origem.FORSINHAB,
             origem.FORRECATI,
             origem.FORCONRES,
             origem.MUNCOD,
             origem.FORNUM,
             origem.FORCEL,
             origem.FORDEHCONSIN,
             origem.FORCRENFE,
             origem.FORINIATI,
             origem.FORDATMODSIN,
             origem.FORDATBAISIN,
             origem.FORHABSIN)

output $action, INSERTED.*;

-- rollback tran
-- commit tran
