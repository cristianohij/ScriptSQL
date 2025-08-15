select avg(Len(CLIEND)) from TBS002 with (nolock)

select ORCITEM,PROCOD,ORCDES,ORCQTD,ORCUNI,
       case when dbo.ORCVALICMSST(0,ORCNUM, ORCITEM) > 0 then 'Valor ICMS-ST: '+Ltrim(str(dbo.ORCVALICMSST(0,ORCNUM, ORCITEM),9,2)) else '' end from TBS0431 with (nolock) where ORCNUM=609059

begin tran
update TBS0431 set ORCINFADIPRO='Valor ICMS-ST: '+'Valor ICMS-ST: '+Ltrim(str(dbo.ORCVALICMSST(0,ORCNUM, ORCITEM),9,2))
 where ORCNUM=609059
       and dbo.ORCVALICMSST(0,ORCNUM, ORCITEM) > 0
commit tran

select ORCINFADIPRO,ORCITEM,PROCOD,ORCDES,ORCQTD,ORCUNI from TBS0431 with (nolock) where ORCNUM=609059

