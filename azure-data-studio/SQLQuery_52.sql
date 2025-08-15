select top(10)
       CLISTATUS 
       ,*
  from TBS002 with (nolock)

select distinct CLISIT
  from TBS002 with (nolock)

select Ltrim(rtrim(c.CLIEND)) + ', ' + Ltrim(rtrim(c.CLINUM)) + ' - ' + Ltrim(rtrim(c.CLIBAI)) + ' - ' + Ltrim(rtrim(m.MUNNOM)) + ' - CEP ' + Ltrim(rtrim(c.CLICEP))
  from TBS002 c with (nolock)
 inner join TBS003 m with (nolock)
    on m.MUNCOD=c.MUNCOD

select top(10) *
  from TBS0021 with (nolock)

select c.CLICOD
       ,c.CLINOM
       ,c.CLIEND
       ,e.CLILOG
       ,c.MUNCOD
       ,e.CLIENDMUNCOD
  from TBS002 c with (nolock)
 inner join TBS0021 e with (nolock)
    on e.CLICOD=c.CLICOD
 where e.CLIENDTIP='E'
       and c.CLIEND=e.CLILOG
       --and c.MUNCOD=e.CLIENDMUNCOD

select e.*
  into TBS0021BKP
  from TBS002 c with (nolock)
 inner join TBS0021 e with (nolock)
    on e.CLICOD=c.CLICOD
 where e.CLIENDTIP='E'
       and c.CLIEND=e.CLILOG

drop table TBS0021BKP

select *
  from TBS0021BKP with (nolock)

select c.CLICOD
       ,c.CLINOM
       ,c.RDVCOD
       ,e.CLIRDVCOD
  from TBS002 c with (nolock)
 inner join TBS0021 e with (nolock)
    on e.CLICOD=c.CLICOD
 where e.CLIENDTIP='E'
       and c.CLIEND=e.CLILOG
       and c.RDVCOD=0
       and c.RDVCOD != e.CLIRDVCOD

begin tran
update TBS002
   set RDVCOD=e.CLIRDVCOD
  from TBS002 c with (nolock)
 inner join TBS0021 e with (nolock)
    on e.CLICOD=c.CLICOD
 where e.CLIENDTIP='E'
       and c.CLIEND=e.CLILOG
       and c.RDVCOD=0
       and c.RDVCOD != e.CLIRDVCOD

rollback tran
commit tran

select c.CLICOD as 'codigo'
       ,0 as 'indice'
       ,Ltrim(rtrim(c.CLIEND))
       + ',' + Ltrim(rtrim(c.CLINUM))
       + '-' + Ltrim(rtrim(c.CLIBAI))
       + '-' + Ltrim(rtrim(m.MUNNOM))
       + '-' + c.UFESIG
       + '-CEP ' + c.CLICEP as 'endereco'
  from TBS002 c with (nolock)
 inner join TBS003 m with (nolock)
    on m.MUNCOD=c.MUNCOD
 where c.CLISIT='A'
       and c.CLITIPPES='J'

union

select e.CLICOD
       ,e.CLIENDCOD
       ,Ltrim(rtrim(e.CLILOG))
       + ',' + Ltrim(rtrim(e.CLIENDNUM))
       + '-' + Ltrim(rtrim(e.CLIENDBAI))
       + '-' + Ltrim(rtrim(m.MUNNOM))
       + '-' + e.CLIENDUFE
       + '-CEP ' + e.CLIENDCEP
  from TBS0021 e with (nolock)
 inner join TBS003 m with (nolock)
    on m.MUNCOD=e.CLIENDMUNCOD
 inner join TBS002 c with (nolock)
    on c.CLICOD=e.CLICOD
 where e.CLIENDTIP='E'
       and c.CLISIT='A'
       and c.CLITIPPES='J'




