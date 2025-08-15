select * from TBS100 (nolock)

update TBS100 set SPDDATFIN='20161231' where SPDVERCOD='010'

insert into TBS100 select '011','1.10','20170101','17530101'

select * from TBS023 (nolock)



ALTER TABLE [TBS023]
ALTER COLUMN [EMPCONCEP] CHAR(9) NULL

alter table [TBS023] drop constraint [DF__TBS023__EMPCONCE__11620408]

select * from TBS023 (nolock)

update TBS023 set EMPCONCEP='12245-031' 


select * from TBS001 (nolock)