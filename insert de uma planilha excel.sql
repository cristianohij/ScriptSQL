sp_addlinkedserver 'OperacoesSaidas',
   'Jet 4.0',
   'Microsoft.Jet.OLEDB.4.0',
   'C:\temp\importar.xls',
   null,
   'Excel 8.0'

sp_addlinkedsrvlogin OperacoesSaidas,false,sa,null

select top 1 * from TBS096
select * from openquery(OperacoesSaidas, 'select * from [Plan1$]') 

insert into TBS096 (OPSREG,OPSTIPNF,OPSTIPOPE,OPSNATOPE,OPSDES,OPSFOREST,OPSCFOPINT,OPSCFOPEXT,OPSTIPPES,OPSFIN,OPSCSTICMSA,OPSCSTICMSB,OPSCONICMS,OPSDESICMSORI,OPSMODBASICMS,OPSDESICMSST,OPSTIPCAL,OPSMODBASICMSST,OPSCSTPIS,OPSCSTCOFINS,OPSMOVEST,OPSCNTVEN,OPSGERCRE,OPSGERCOM)
select * from openquery(OperacoesSaidas, 'select * from [Plan1$]') 

select * from TBS096
delete TBS096

update TBS096 set OPSTIPOPE = upper(OPSTIPOPE)