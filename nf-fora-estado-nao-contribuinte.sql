select CLIINDIE,* from TBS002 (nolock) where CLICOD=8017

select * from TBS058 (nolock)
 where PRPSIT='R' and
       exists(select '' from TBS002 (nolock) where CLICOD=PRPCLICOD and CLIINDIE=9) and UFESIG<>'SP')

select CLIINDIE,count(*) from TBS002 (nolock) group by CLIINDIE

update TBS002 set CLIINDIE=9 where CLIINDIE=2

select * from TBS001 (nolock) where UFESIG='RJ'

update TBS001 set 

select * from TANBYM.SIBD.dbo.TBS001 (nolock)

select * from master..sysservers 

update TBS001 set UFEFCEP=2 where UFESIG not in('AC','AM','AP','PA','RR','SC')

update TBS001 set UFEFCEPLEI='LEI NO. 6.558/2004' where UFESIG='AL'
update TBS001 set UFEFCEPLEI='LEI NO. 7.988/2001' where UFESIG='BA'
update TBS001 set UFEFCEPLEI='LEI COMPLEMENTAR NO. 37/2003' where UFESIG='CE'
update TBS001 set UFEFCEPLEI='LEI NO. 4220/2008' where UFESIG='DF'
update TBS001 set UFEFCEPLEI='LEI COMPLEMENTAR NO 336/2005' where UFESIG='ES'
update TBS001 set UFEFCEPLEI='LEI NO. 14469/2003' where UFESIG='GO'
update TBS001 set UFEFCEPLEI='LEI NO. 8205/2004' where UFESIG='MA'
update TBS001 set UFEFCEPLEI='LEI COMPLEMENTAR NO. 144/2003' where UFESIG='MT'
update TBS001 set UFEFCEPLEI='LEI NO. 3.337/2006' where UFESIG='MS'
update TBS001 set UFEFCEPLEI='LEI NO. 19.978/2011' where UFESIG='MG'
update TBS001 set UFEFCEPLEI='LEI NO. 7.611/2004' where UFESIG='PB'
update TBS001 set UFEFCEPLEI='LEI NO. 18.573/2015' where UFESIG='PR'
update TBS001 set UFEFCEPLEI='LEI NO. 12523/2003' where UFESIG='PE'
update TBS001 set UFEFCEPLEI='LEI NO. 5.622/2006' where UFESIG='PI'
update TBS001 set UFEFCEPLEI='LEI NO. 4056/2002' where UFESIG='RJ'
update TBS001 set UFEFCEPLEI='LEI COMPLEMENTAR NO. 261/2003' where UFESIG='RN'
update TBS001 set UFEFCEPLEI='LEI NO. 14742/2015' where UFESIG='RS'
update TBS001 set UFEFCEPLEI='LEI COMPLEMENTAR NO. 842/2015' where UFESIG='RO'
update TBS001 set UFEFCEPLEI='LEI NO. 4731/2002' where UFESIG='SE'
update TBS001 set UFEFCEPLEI='LEI NO. 16.006/2015' where UFESIG='SP'
update TBS001 set UFEFCEPLEI='LEI NO. 3.015/2015' where UFESIG='TO'

update TBS001 set UFEFCEP=2 where UFESIG='RJ'

select * from TBS0551 (nolock) where PDVNUM=357198

update TBS0551 set PDVPERICMS=12 where PDVNUM=357198 and PDVPERICMS=18

select NFSICMSINTDES,* from TBS067 (nolock) where NFSNUM=174274

select * from TBS0671 (nolock) where NFSNUM=174274

update TBS0671 set NFSPERICMS=12 where NFSNUM=174274 and NFSPERICMS=18




---


select CLICOD,CLINOM,CLIINDIE into TBS002_IE2 from TBS002 (nolock) where CLIINDIE=2

select * from TBS002_IE2

begin tran
update TBS002 set CLIINDIE=9 where CLIINDIE=2
commit tran

select * from TBS001 (nolock)

update TBS001 set UFEFCEP=2 where UFESIG not in('AC','AM','AP','PA','RR','SC')

update TBS001 set UFEFCEPLEI='Lei no. 6.558/2004' where UFESIG='AL'
update TBS001 set UFEFCEPLEI='Lei no. 7.988/2001' where UFESIG='BA'
update TBS001 set UFEFCEPLEI='Lei complementar no. 37/2003' where UFESIG='CE'
update TBS001 set UFEFCEPLEI='Lei no. 4220/2008' where UFESIG='DF'
update TBS001 set UFEFCEPLEI='Lei complementar no. 336/2005' where UFESIG='ES'
update TBS001 set UFEFCEPLEI='Lei no. 14469/2003' where UFESIG='GO'
update TBS001 set UFEFCEPLEI='Lei no. 8205/2004' where UFESIG='MA'
update TBS001 set UFEFCEPLEI='Lei complementar no. 144/2003' where UFESIG='MT'
update TBS001 set UFEFCEPLEI='Lei no. 3.337/2006' where UFESIG='MS'
update TBS001 set UFEFCEPLEI='Lei no. 19.978/2011' where UFESIG='MG'
update TBS001 set UFEFCEPLEI='Lei no. 7.611/2004' where UFESIG='PB'
update TBS001 set UFEFCEPLEI='Lei no. 18.573/2015' where UFESIG='PR'
update TBS001 set UFEFCEPLEI='Lei no. 12523/2003' where UFESIG='PE'
update TBS001 set UFEFCEPLEI='Lei no. 5.622/2006' where UFESIG='PI'
update TBS001 set UFEFCEPLEI='Lei no. 4056/2002' where UFESIG='RJ'
update TBS001 set UFEFCEPLEI='Lei complementar no. 261/2003' where UFESIG='RN'
update TBS001 set UFEFCEPLEI='Lei no. 14742/2015' where UFESIG='RS'
update TBS001 set UFEFCEPLEI='Lei complementar no. 842/2015' where UFESIG='RO'
update TBS001 set UFEFCEPLEI='Lei no. 4731/2002' where UFESIG='SE'
update TBS001 set UFEFCEPLEI='Lei no. 16.006/2015' where UFESIG='SP'
update TBS001 set UFEFCEPLEI='Lei no. 3.015/2015' where UFESIG='TO'


select * from TBS110 (nolock) where ROPCONICMS='N'

begin tran
update TBS110 set ROPICMSPRO=0 where ROPCONICMS='N'
commit tran


select CLIINDIE,CLIIES,* from TBS002 (nolock) where CLICOD=8659

update TBS002 set CLIINDIE=1 where CLICOD=8659

select CLIINDIE,CLIIES,* from TBS002 (nolock) where CLIINDIE=9 and CLIIES<>''

begin tran
update TBS002 set CLIINDIE=1 where CLIINDIE=9 and CLIIES<>''
commit tran


