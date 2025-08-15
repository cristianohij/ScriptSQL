select * from TBS128  (nolock) where LAIANO=2017 and LAIMES=3
select * from TBS1281 (nolock) where LAIANO=2017 and LAIMES=3 and LAIVALCON < LAIBASCAL
select * from TBS1282 (nolock) where LAIANO=2017 and LAIMES=3 and LAIVALCONTRI < LAIBASCONTRI
select * from TBS1283 (nolock) where LAIANO=2017 and LAIMES=3

begin tran
update TBS1281 set LAIBASCAL=LAIVALCON where LAIANO=2017 and LAIMES=3 and LAIVALCON < LAIBASCAL
commit tran
