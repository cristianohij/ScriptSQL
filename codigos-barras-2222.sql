select * from TBS0103 with (nolock) where Len(CBPCODBAR) > 8 and CBPCODBAR Like('%4444')

select * from TBS0103 with (nolock) where CBPPROCOD='3070018' and rtrim(right(CBPCODBAR,4))='2222'

--update 

drop table TBS0103_1111_2222_3333_4444

select *
  --into TBS0103_1111_2222_3333_4444
  from TBS0103 with (nolock)
 where CBPCODBAR = rtrim(CBPPROCOD)+'1111' or CBPCODBAR = rtrim(CBPPROCOD)+'2222' or CBPCODBAR = rtrim(CBPPROCOD)+'3333' or CBPCODBAR = rtrim(CBPPROCOD)+'4444'

begin tran
delete TBS0103
 where CBPCODBAR = rtrim(CBPPROCOD)+'1111' or CBPCODBAR = rtrim(CBPPROCOD)+'2222' or CBPCODBAR = rtrim(CBPPROCOD)+'3333' or CBPCODBAR = rtrim(CBPPROCOD)+'4444'
commit tran

CBPPROCOD='3070018' and rtrim(right(CBPCODBAR,4))='2222'

drop table TBS010_2222

select *
  from TBS010 with (nolock)
 where PROCOD = rtrim(PROCOD)+'2222'

select *
  from TBS010 with (nolock)
 where PROCOD = '2130033'

select --PROCODBAR1
       --,PROCODBAR2
       --,PROCODBAR3
       --,PROCODBAR4
       --,
       *
  into TBS010_1111_2222_3333_4444
  from TBS010 with (nolock)
 where PROCODBAR1=rtrim(PROCOD)+'1111'
       or PROCODBAR2=rtrim(PROCOD)+'2222'
       or PROCODBAR3=rtrim(PROCOD)+'3333'
       or PROCODBAR4=rtrim(PROCOD)+'4444'

begin tran
update TBS010 set PROCODBAR1='' where PROCODBAR1=rtrim(PROCOD)+'1111'
rollback tran

begin tran
update TBS010 set PROCODBAR2='' where PROCODBAR2=rtrim(PROCOD)+'2222'
rollback tran
commit tran

begin tran
update TBS010 set PROCODBAR3='' where PROCODBAR3=rtrim(PROCOD)+'3333'
rollback tran
commit tran

begin tran
update TBS010 set PROCODBAR4='' where PROCODBAR4=rtrim(PROCOD)+'4444'
rollback tran
commit tran

select * from TBS010_1111_2222_3333_4444 with (nolock)

select * from TBS0103_1111_2222_3333_4444 with (nolock)

--

select PROCOD
       ,PRODES
       ,PROSTATUS
  from TBS010 with (nolock)
 where PROCOD in(select rtrim(PROCOD)+'2'
                   from TBS010 with (nolock))


select PROCOD
       ,PRODES
  from TBS010 with (nolock)
 where PROCOD in('1540007','15400072')

select *
--  into TBS0103_2222
  from TBS0103 with (nolock)
 where CBPCODBAR = rtrim(CBPPROCOD)+'1111'

select *
  from TBS0103 with (nolock)
 where isnumeric(CBPCODBAR)=0

---

select PROCOD
       ,PRODES
       ,PROSTATUS
  from TBS010 with (nolock)
 where PROCOD in(select rtrim(PROCOD)+'222'
                   from TBS010 with (nolock))

select * from TBS010 with (nolock) where PROUM2<>''

select PROCOD
       ,PROUM1
       ,PROUM1QTD
       ,PROUM2
       ,PROUM2QTD
       ,PROCODBAR1
       ,PROCODBAR2
       ,PROCODBAR3
       ,PROCODBAR4
       ,PROUMV
  from TBS010 with (nolock)
 where PROCOD='2130033'

select *
  from TBS0103 with (nolock)
 where CBPPROCOD='2130033'

delete TBS0103 where CBPPROCOD='2130033' and CBPQTDEMB=10

update TBS0103 set CBPQTDEMB=1 where CBPPROCOD='1640054' and CBPCODBAR='7891191003733'

insert TBS0103
(CBPEMP, CBPPROCOD, CBPCODBAR, CBPQTDEMB, CBPDATCAD, CBPUSUALT, CBPHORALT, CBPDATALT, CBPUSUCAD, CBPHORCAD)
select 0
       ,'0050441'
       ,'123456'
       ,10
       ,convert(date,getdate())
       ,'DESENV'
       ,'11:48'
       ,convert(date,getdate())
       ,'DESENV'
       ,'11:48'

select *
  from TBS0103 with (nolock)
 where CBPUSUCAD<>'DESENV'

select *
  from TBS0103 with (nolock)
 where isnumeric(CBPCODBAR)=0


---

select * from TBS010 with (nolock) where PROCOD='12470003'

select * from TBS0103 with (nolock) where CBPPROCOD='7897659614831'

select * from TBS0103 with (nolock) where CBPPROCOD='7898555807990'

select * from TBS010 with (nolock) where PROCODBAR1='7898555807990' or PROCODBAR2='7898555807990' or PROCODBAR3='7898555807990' or PROCODBAR4='7898555807990'

select * from TBS0103 with (nolock) where CBPCODBAR='7898941898403'

select * from TBS0103 with (nolock) where CBPPROCOD='0041106'

select * from TBS0103 with (nolock) where CBPUSUCAD<>'DESENV'

select * from TBS010 with (nolock) where PROSTATUS='A' and PROUM2<>'' and PROCODBAR2=''