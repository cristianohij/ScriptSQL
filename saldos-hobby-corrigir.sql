select *
  from TBS032 with (nolock)
 where ESTLOC=1 and ESTQTDATU > 0

select *
  from TBS051 with (nolock)
 where convert(date,LMEDATHOR)='20190910'
       and LMEROT='PEST010'
       and LMEUSU='CELIA'
       and LMEINFALT='E'
       and LMEACA='S'
       and LMEQTDATU<>LMEQTDMOV

---

select Z.LMEDATHOR
       ,Z.PROCOD
	   ,Z.LMEQTDMOV
	   ,L.LMEQTDMOV
	   ,L.LMEREG
	   ,L.LMEQTDATU

  --into TBS051BKP
  from TBS051BKP Z with (nolock)
       inner join TBS051 L with (nolock)
	   on L.PROCOD=Z.PROCOD
	      and L.LMELOCEST=Z.LMELOCEST

 where convert(date,Z.LMEDATHOR)='20190910'
       and Z.LMEROT='PEST010'
       and Z.LMEUSU='CELIA'
       and Z.LMEINFALT='E'
       and Z.LMEACA='S'

	   and L.LMEACA='S'
	   and L.LMEINFALT='E'
	   and L.LMEDATHOR > Z.LMEDATHOR
 order by L.PROCOD

	   and L.LMEROT='PMSL033'

 order by Z.LMEREG

 select *
   from TBS051 with (nolock)
  where convert(date,LMEDATHOR)='20190910'
        and LMECUPDAT='20190910'

select *
  into TBS032BKP
  from TBS032 with (nolock)

select distinct ESTLOC
  from TBS032 with (nolock)

select *
  from TBS032 with (nolock)
where ESTLOC=8
      and ESTQTDATU > 0

select L.*
  --into CUPBAIXA
  from TBS051BKP Z with (nolock)
       inner join TBS051 L with (nolock)
	   on L.PROCOD=Z.PROCOD
	      and L.LMELOCEST=Z.LMELOCEST

 where convert(date,Z.LMEDATHOR)='20190910'
       and Z.LMEROT='PEST010'
       and Z.LMEUSU='CELIA'
       and Z.LMEINFALT='E'
       and Z.LMEACA='S'

	   and L.LMEACA='S'
	   and L.LMEINFALT='E'
	   and L.LMEDATHOR > Z.LMEDATHOR
 order by L.LMEREG


 begin tran
 update TBS051
    set LMEQTDATU=(select top 1 LMEQTDATU
	             from TBS051 X with (nolock)
                    where X.LMEDATHOR < L.LMEDATHOR
                          and X.PROCOD=L.PROCOD
                          and X.LMELOCEST=L.LMELOCEST
                    order by X.LMEDATHOR desc)
        ,LMEQTDDIS=(select top 1 LMEQTDATU
	              from TBS051 X with (nolock)
                     where X.LMEDATHOR < L.LMEDATHOR
                           and X.PROCOD=L.PROCOD
                           and X.LMELOCEST=L.LMELOCEST
                     order by X.LMEDATHOR desc)-L.LMEQTDRES
        ,LMEQTDSAL=(select top 1 LMEQTDATU
	              from TBS051 X with (nolock)
                     where X.LMEDATHOR < L.LMEDATHOR
                           and X.PROCOD=L.PROCOD
                           and X.LMELOCEST=L.LMELOCEST
                     order by X.LMEDATHOR desc)-L.LMEQTDRES-L.LMEQTDMOV

  from TBS051 L with (nolock)
       inner join TBS051BKP Z with (nolock)
	   on Z.PROCOD=L.PROCOD
	      and Z.LMELOCEST=L.LMELOCEST

 where convert(date,Z.LMEDATHOR)='20190910'
       and Z.LMEROT='PEST010'
       and Z.LMEUSU='CELIA'
       and Z.LMEINFALT='E'
       and Z.LMEACA='S'

       and L.LMEACA='S'
       and L.LMEINFALT='E'
       and L.LMEDATHOR > Z.LMEDATHOR

rollback tran
commit tran

begin tran
 update TBS051
    set LMEQTDATU=L.LMEQTDATU-1
        ,LMEQTDDIS=L.LMEQTDDIS-1
        ,LMEQTDSAL=L.LMEQTDSAL-1

  from TBS051 L with (nolock)
       inner join TBS051BKP Z with (nolock)
	   on Z.PROCOD=L.PROCOD
	      and Z.LMELOCEST=L.LMELOCEST

 where convert(date,Z.LMEDATHOR)='20190910'
       and Z.LMEROT='PEST010'
       and Z.LMEUSU='CELIA'
       and Z.LMEINFALT='E'
       and Z.LMEACA='S'

       and L.LMEACA='S'
       and L.LMEINFALT='E'
       and L.LMEDATHOR > Z.LMEDATHOR
       and L.LMEQTDMOV=1

rollback tran
commit tran

select L.*
       ,(select top 1 LMEQTDATU
	                 from TBS051 X with (nolock)
					where X.LMEDATHOR < L.LMEDATHOR
					      and X.PROCOD=L.PROCOD
						  and X.LMELOCEST=L.LMELOCEST
			        order by X.LMEDATHOR desc)
  from TBS051 L with (nolock)
       inner join TBS051BKP Z with (nolock)
	   on Z.PROCOD=L.PROCOD
	      and Z.LMELOCEST=L.LMELOCEST

 where convert(date,Z.LMEDATHOR)='20190910'
       and Z.LMEROT='PEST010'
       and Z.LMEUSU='CELIA'
       and Z.LMEINFALT='E'
       and Z.LMEACA='S'

	   and L.LMEACA='S'
	   and L.LMEINFALT='E'
	   and L.LMEDATHOR > Z.LMEDATHOR

---

select *
  from TBS051BKP with (nolock)
 where convert(date,LMEDATHOR)='20190910'
       and LMEROT='PEST010'
       and LMEUSU='CELIA'
       and LMEINFALT='E'
       and LMEACA='S'
       and LMELOCEST=1

begin tran
delete TBS051
 where convert(date,LMEDATHOR)='20190910'
       and LMEROT='PEST010'
       and LMEUSU='CELIA'
       and LMEINFALT='E'
       and LMEACA='S'
commit tran

select PROCOD
  from TBS051BKP with (nolock)
 group by PROCOD

select Z.PROCOD,Z.LMEQTDMOV,E.ESTQTDATU
  from TBS051BKP Z with (nolock)
       inner join TBS032 E with (nolock)
	   on E.PROCOD=Z.PROCOD
	      and E.ESTLOC=Z.LMELOCEST
 where E.ESTQTDATU < 0
 
update TBS032 
   set ESTQTDATU=(select LMEQTDMOV
                    from TBS051BKP L with (nolock)
				   where L.PROCOD=E.PROCOD
				         and L.LMELOCEST=E.ESTLOC)
  from TBS032 E with (nolock)

begin tran
update TBS032 
   set ESTQTDATU=L.LMEQTDMOV
  from TBS032 E with (nolock)
       inner join TBS051BKP L with (nolock)
	   on L.PROCOD=E.PROCOD
	      and L.LMELOCEST=E.ESTLOC
commit tran


begin tran
update TBS032 
   set ESTQTDATU=ESTQTDATU-B.LMEQTDMOV
  from TBS032 E with (nolock)
       inner join CUPBAIXA B with (nolock)
	   on B.PROCOD=E.PROCOD
	      and B.LMELOCEST=E.ESTLOC
commit tran

select *
  from CUPBAIXA
 where LMEQTDMOV > 1


---

select *
  from TBS051 with (nolock)
 where LMEREG in(44424,44439)

----

select *
  from TBS051 with (nolock)
 where LMEQTDDIS > 0


---

select *
  from TBS032 with (nolock)
 where ESTLOC=1
       and ESTQTDATU > 0
