select * from master..sysservers

-- tanby matriz
select * from TANBYM.SIBD.dbo.TBS039

-- outra empresa
select * from PAPELYNA.SIBD.dbo.TBS039

-- atualizar outras empresas
update PAPELYNA.SIBD.dbo.TBS039 set CSTICMS=TM.CSTICMS,CSTBASRED=TM.CSTBASRED,CSTICMSST=TM.CSTICMSST,CSTBASREDST=TM.CSTBASREDST
  from PAPELYNA.SIBD.dbo.TBS039 as X join TANBYM.SIBD.dbo.TBS039 as TM on X.CSTTAB=TM.CSTTAB collate database_default and X.CSTCOD=TM.CSTCOD collate database_default 

insert into BB.SIBD2.dbo.TBS039 select 'A','8','NACIONAL, MERC OU BEM COM CONTEÚDO DE IMPORT SUPERIOR A 70%','N','',getdate(),'','','',0



-- tanby matriz
select * from TANBYM.SIBD.dbo.TBS085

update TANBYM.SIBD.dbo.TBS085 set CSNMSG=''

-- operação tributada
update TANBYM.SIBD.dbo.TBS085 set CSNTRIB='S' where CSNCOD in('101','201','201','202','500')

-- operação não tributada
update TANBYM.SIBD.dbo.TBS085 set CSNTRIB='N' where CSNCOD in('400')

-- com permissão de crédito
update TANBYM.SIBD.dbo.TBS085 set CSNPERCRE='S' where CSNCOD in('101','201')

-- sem permissão de crédito
update TANBYM.SIBD.dbo.TBS085 set CSNPERCRE='N' where CSNCOD in('102','202')

-- com conbrança de icms-st
update TANBYM.SIBD.dbo.TBS085 set CSNCOBST='S' where CSNCOD in('202','202','203','500')

-- outra empresa
select * from TANBYT.SIBD.dbo.TBS085

-- atualizar outras empresas
update TANBYT.SIBD.dbo.TBS085 set CSNMSG=TM.CSNMSG,CSNTRIB=TM.CSNTRIB,CSNPERCRE=TM.CSNPERCRE,CSNCOBST=TM.CSNCOBST
  from TANBYT.SIBD.dbo.TBS085 as X join TANBYM.SIBD.dbo.TBS085 as TM on X.CSNCOD=TM.CSNCOD collate database_default


