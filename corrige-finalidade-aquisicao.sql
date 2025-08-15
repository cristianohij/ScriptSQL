select count(*) from TBS002 (nolock) where CLIINDIE=9 and CLIFINAQU<>'C'

update TBS002 set CLIFINAQU='C' where CLIINDIE=9 and CLIFINAQU<>'C'

select top 1 * from TBS058 (nolock)

select count(*)
--       PDVNUM
  from TBS055 (nolock)
       inner join TBS058 (nolock) on PRPNUM=PDVNUM
       inner join TBS002 (nolock) on CLICOD=PRPCLICOD
 where PDVFINAQU<>'C' and
       CLIINDIE=9

begin tran
update TBS055 set PDVFINAQU='C'
  from TBS058 (nolock)
       inner join TBS055 (nolock) on PRPNUM=PDVNUM
       inner join TBS002 (nolock) on CLICOD=PRPCLICOD
 where PDVFINAQU<>'C' and
       CLIINDIE=9
commit tran
rollback tran

select PDVFINAQU,PDVCLICOD from TBS055 (nolock) where PDVNUM=377573

select CLIINDIE,CLIFINAQU from TBS002 (nolock) where CLICOD=64

select count(*)
--       PDVNUM
  from TBS043 (nolock)
       inner join TBS002 (nolock) on CLICOD=ORCCLI
 where ORCDATCAD >= '20150101' and
       ORCFINAQU<>'C' and
       CLIINDIE=9

begin tran
update TBS043 set ORCFINAQU='C'
  from TBS043 (nolock)
       inner join TBS002 (nolock) on CLICOD=ORCCLI
 where ORCDATCAD >= '20150101' and
       ORCFINAQU<>'C' and
       CLIINDIE=9
commit tran
