update MSL002 set M2_EMPCOD=1go
update TBS043 set ORCEMPCOD=1go
update TBS0431 set ORCEMPCOD=1go
update TBS053 set BCPNUMEMP=1go
update TBS055 set PDVEMPCOD=1go
update TBS0551 set PDVEMPCOD=1go
update TBS056 set CREEMPCOD=1go
update TBS057 set CPAEMPCOD=1go
update TBS059 set NFEEMPCOD=1go
update TBS0591 set NFEEMPCOD=1go
update TBS0592 set NFEEMPCOD=1go
update TBS0593 set NFEEMPCOD=1go
update TBS0594 set NFEEMPCOD=1go
update TBS0595 set NFEEMPCOD=1go
update TBS0596 set NFEEMPCOD=1go
update TBS0597 set NFEEMPCOD=1go
update TBS067 set NFSEMPCOD=1go
update TBS0671 set NFSEMPCOD=1go
update TBS0672 set NFSEMPCOD=1go
update TBS0673 set NFSEMPCOD=1go
update TBS0674 set NFSEMPCOD=1go
update TBS069 set PDFPDVEMP=1go
update TBS070 set CMSEMPCOD=1go
update TBS0701 set CMSEMPCOD=1go
update TBS073 set CACEMPCOD=1go
update TBS0731 set CACEMPCOD=1go
update TBS0732 set CACEMPCOD=1go
update TBS075 set LOGCNABEMP=1go
update TBS080 set ENFEMPCOD=1go
update TBS0801 set ENFEMPCOD=1go
update TBS0802 set ENFEMPCOD=1go
update TBS110 set ROPEMPCOD=1go
update TBS1101 set ROPEMPCOD=1go
update TMP001 set T1_EMPRESA=1go
update TMP002 set T2_EMPRESA=1go
update TMP0021 set T2_EMPRESA=1go
update TMP005 set T5_EMPRESA=1go
update TMP006 set T6_EMPRESA=1go
update TMP007 set T7_EMPRESA=1go
update TMP008 set T8_EMPRESA=1go
update TMP010 set TA_EMPRESA=1go


-----

select * from TBS104 

update TBS104 set SNEEMPCOD=1 

insert into TBS104 select 2,SNESER,SNETIP,SNENUM,getdate(),SNEUSUCAD,'17530101','' from TBS104 

update TBS104 set SNENUM=0 where SNEEMPCOD=2 and SNETIP='SG'

update TBS067 set SNEEMPCOD=1go
update TBS0671 set SNEEMPCOD=1go
update TBS0672 set SNEEMPCOD=1go
update TBS0673 set SNEEMPCOD=1go
update TBS0674 set SNEEMPCOD=1go
