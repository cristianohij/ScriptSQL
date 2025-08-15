select UNICOD,UNIDES from TBS011 (nolock)

-- tanby
select PROUM1,count(*) from TBS010 (nolock) where PROUM1 in('DE','DZ','GB','JD','MB','MT','M2','MN','MI','ML','KG') group by PROUM1

select distinct PROPESAVEL from TBS010 (nolock)

update TBS010 set PROPESAVEL = 'N'

update TBS010 set PROPESAVEL = 'S' where PROUM1 in('DE','DZ','GB','JD','MB','MT','M2','MN','MI','ML','KG')