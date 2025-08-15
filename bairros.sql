select PROCLAFIS,PROSTBB,* from TBS010 with (nolock) where PROCOD='3263322'

select * from TBS0921 with (nolock) where NCMCOD='48025810'

begin tran
delete TBS0921 where NCMCOD='48025810'
commit tran

select * from TBS080 with (nolock) where ENFNUM=238907

begin tran
update TBS080 set ENFVALTOT=595.16 where ENFNUM=238907
commit tran

select * from TBS002 with (nolock) where RDVCOD > 0

select * from TBS097 with (nolock)

select CLIBAI,count(*)
  from TBS002 with (nolock)
 where MUNCOD=3549904
 group by CLIBAI order by count(*) desc


select * from TBS003 with (nolock) where UFESIG='SP' and MUNNOM='SAO JOSE DOS CAMPOS'

select CLIBAI
  from TBS002 with (nolock)
 where CLIBAI Like('%%PUTIM') and CLIBAI<>'PUTIM'

begin tran
update TBS002 set CLIBAI='PUTIM'
  from TBS002 with (nolock)
 where CLIBAI Like('%%PUTIM') and CLIBAI<>'PUTIM'
commit tran

select CLIBAI
  from TBS002 with (nolock)
 where CLIBAI Like('31%') and CLIBAI<>'31 DE MARÇO'

begin tran
update TBS002 set CLIBAI='31 DE MARÇO'
  from TBS002 with (nolock)
 where CLIBAI Like('31%') and CLIBAI<>'31 DE MARÇO'
commit tran

select CLIBAI
  from TBS002 with (nolock)
 where MUNCOD=3549904 and (CLIBAI Like('%EUCALIPTOS%') or CLIBAI Like('%EUCALÍPTOS%')) and CLIBAI<>'BOSQUE DOS EUCALIPTOS'

select CLIBAI
  from TBS002 with (nolock)
 where CLIBAI='BQ DOS EUCALIPTOS'

begin tran
update TBS002 set CLIBAI='BOSQUE DOS EUCALIPTOS'
  from TBS002 with (nolock)
 where CLIBAI='BQ DOS EUCALIPTOS'
commit tran

select CLIBAI
  from TBS002 with (nolock)
 where MUNCOD=3549904 and CLIBAI='BOAQUE DOS EUCALIPTOS'

begin tran
update TBS002 set CLIBAI='BOSQUE DOS EUCALIPTOS'
  from TBS002 with (nolock)
 where MUNCOD=3549904 and CLIBAI='BOSQUE EUCARIPITO'
commit tran

select CLIBAI
  from TBS002 with (nolock)
 where MUNCOD=3549904 and CLIBAI Like('%CHAC%REUNI%')

begin tran
update TBS002 set CLIBAI='CHÁCARAS REUNIDAS'
  from TBS002 with (nolock)
 where MUNCOD=3549904 and CLIBAI Like('%CHAC%REUNI%')
commit tran

select CLIBAI
  from TBS002 with (nolock)
 where MUNCOD=3549904 and CLIBAI Like('%VIL%EMA%')

begin tran
update TBS002 set CLIBAI='VILA EMA'
  from TBS002 with (nolock)
 where MUNCOD=3549904 and CLIBAI='VILMA EMA'
commit tran

select CLIBAI
  from TBS002 with (nolock)
 where MUNCOD=3549904 and CLIBAI Like('%SATELIT%')

begin tran
update TBS002 set CLIBAI='JARDIM SATÉLITE'
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI Like('%SATELIT%')
       and CLIBAI<>'SATELITE INDUSTRIAL'
commit tran

select CLIBAI
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and (CLIBAI Like('%VIL%ADY%') or CLIBAI Like('%VIL%ADI%'))

begin tran
update TBS002 set CLIBAI='VILA ADYANA'
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and (CLIBAI Like('%VIL%ADY%') or CLIBAI Like('%VIL%ADI%'))
commit tran

select CLIBAI
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI Like('%URBA%NOVA%')

begin tran
update TBS002 set CLIBAI='URBANOVA'
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI='JD.URBANOVA'
commit tran

begin tran
update TBS002 set CLIBAI='URBANOVA'
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI='URBA NOVA'
commit tran

select CLIBAI
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI Like('%DIMAS%')

begin tran
update TBS002 set CLIBAI='JARDIM SÃO DIMAS'
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI Like('%DIMAS%')
commit tran

select CLIBAI
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI Like('PAR% AQUA%')

begin tran
update TBS002 set CLIBAI='PARQUE RESIDENCIAL AQUARIUS'
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI Like('PAR% AQUA%')
commit tran

select CLIBAI
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI Like('J% AQUA%')
       and CLIBAI not in('JARDIM AQUARIUS II',
'JARDIM AQUARIUS III',
'JD. AQUARIUS II',
'JD AQUARIUS 2',
'JD AQUARIUS 4',
'JD AQUARIUS II')

begin tran
update TBS002 set CLIBAI='JARDIM AQUARIUS'
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI Like('J% AQUA%')
       and CLIBAI not in('JARDIM AQUARIUS II',
'JARDIM AQUARIUS III',
'JD. AQUARIUS II',
'JD AQUARIUS 2',
'JD AQUARIUS 4',
'JD AQUARIUS II')
commit tran

select CLIBAI
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI Like('AQUA%')
       and CLIBAI<>'AQUARIUS II'

begin tran
update TBS002 set CLIBAI='JARDIM AQUARIUS'
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI Like('AQUA%')
       and CLIBAI<>'AQUARIUS II'
commit tran

select CLIBAI
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI Like('%ALT%SANTAN%')

begin tran
update TBS002 set CLIBAI='JARDIM ALTOS DE SANTANA'
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI Like('%ALT%SANTAN%')
commit tran

select CLIBAI
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI Like('%SANTAN%')
       and CLIBAI<>'JARDIM ALTOS DE SANTANA'

begin tran
update TBS002 set CLIBAI='JARDIM ALTOS DE SANTANA'
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI in('J A SANTAN',
'JARDIM SANTANA',
'JD SANTANA',
'AUTO SANTANA',
'AUTOS DE SANTANA')
commit tran

select CLIBAI
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI Like('%SANTAN%')
       and CLIBAI<>'JARDIM ALTOS DE SANTANA'
       and CLIBAI<>'SANTANA'

begin tran
update TBS002 set CLIBAI='SANTANA'
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI Like('%SANTAN%')
       and CLIBAI<>'JARDIM ALTOS DE SANTANA'
       and CLIBAI<>'SANTANA'
commit tran

