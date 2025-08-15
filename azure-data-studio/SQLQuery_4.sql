-- bairro

select count(*)
  from TBS002 with (nolock)
 where RDVCOD > 0

select count(*)
  from TBS002 with (nolock)
 where MUNCOD=3549904

select top(100) MUNCOD
  from TBS002 with (nolock)

select top(100) *
  from TBS003 with (nolock)
 where MUNNOM Like('%DOS CAMPOS')

select CLIBAI
       ,count(*)
  from TBS002 with (nolock)
 where MUNCOD=3549904
 group by CLIBAI
 order by CLIBAI
 
update TBS002
   set CLIBAI=upper(CLIBAI)
   
select CLIBAI
       ,RDVCOD
  from TBS002 with (nolock)
 where MUNCOD=3549904
       and CLIBAI='CENTRO'

select *
  from TBS097 with (nolock)

begin tran
update TBS002
   set RDVCOD=5
 where MUNCOD=3549904
       and CLIBAI='CENTRO'

begin tran
update TBS002
   set CLIBAI='31 DE MARCO'
 where MUNCOD=3549904
       and CLIBAI='31 DE MARÇO'

begin tran
update TBS002
   set CLIBAI='ALTO DA PONTE'
 where MUNCOD=3549904
       and CLIBAI='ALTO DA ´PONTE'

begin tran
update TBS002
   set CLIBAI='BOSQUE DOS EUCALIPTOS'
 where MUNCOD=3549904
       and (CLIBAI='BOASQUE DOS ELCALIPI]TOS'
	        or CLIBAI='BOQUE DOS EUCALIPTOS'
			or CLIBAI='BOSQUE DO EUCALIPTOS'
			or CLIBAI='BOSQUE DOS EUCALIPTO'
			or CLIBAI='BOSQUE DOS EUCALÍPTOS')
	       
begin tran
update TBS002
   set RDVCOD=2
 where MUNCOD=3549904
       and CLIBAI='BOSQUE DOS EUCALIPTOS'

begin tran
update TBS002
   set RDVCOD=2
 where MUNCOD=3549904
       and CLIBAI='31 DE MARCO'
	   	   
rollback tran
commit tran

select NFEESTORI
       ,*
  from TBS059 with (nolock)
 where NFENUM=202348

declare @EMPUFESIG as char(2)
        ,@NCMCOD as char(8)
		,@UForigem as char(2)

select @EMPUFESIG='SP'
       ,@NCMCOD='85061039'
       ,@UForigem='SC'

--print @EMPUFESIG
--print @NCMCOD
--print @UForigem

select *
  from TBS0921 with (nolock)
 where NCMEX=''
       and UFESIG=@EMPUFESIG
	   and NCMCOD=@NCMCOD
       and (NCMUFORI Like @UForigem or NCMUFORI='')

select *
  from TBS0921 with (nolock)
 where NCMEX=''
       and UFESIG='SP'
	   and NCMCOD='85061039'
	   and (NCMUFORI Like '' or NCMUFORI='')

begin tran
update TBS0921
   set NCMUFORI=''
 where NCMUFORI is null
    
rollback tran
commit tran

select NFEGAREICMSST
       ,*
  from TBS0591 with (nolock)
 where NFENUM=202348

select PROCOD
       ,PRODES
  from TBS010 with (nolock)
 where PROCLAFIS='32131000'
