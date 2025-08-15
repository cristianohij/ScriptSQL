--512 590 6710 6709

--1/3 a 31/10 2014


select top 500
       NFSCLICOD as 'cliente',
       TBS067.NFSNUM as 'nf',
       PROCOD as 'codigo',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'descricao',
       sum(NFSQTD*NFSQTDEMB) as 'quantidade'
  from TBS0671 (nolock) left join TBS067 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
 where NFSDATEMI between '20140301' and '20141031' and
       NFSCAN='N' and
       NFSDEV='N' and
       NFSCLICOD in(512,590,6710,850,4567,14422) and
       PROCOD='1640054'
 group by NFSCLICOD,TBS067.NFSNUM,PROCOD
-- order by 'quantidade' desc


select NFSCLICOD as 'cliente',
       TBS067.NFSNUM as 'nf',
       PROCOD as 'codigo',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'descricao',
       sum(NFSQTD*NFSQTDEMB) as 'quantidade'
  from TBS0671 (nolock) left join TBS067 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
 where NFSDATEMI between '20140301' and '20141031' and
       NFSCAN='N' and
       NFSDEV='N' and
       NFSCLICOD in(512,590,6710,850,4567,14422) and
       PROCOD='1640054'
 group by NFSCLICOD,TBS067.NFSNUM,PROCOD


select NFSCLICOD as 'cliente',
       TBS067.NFSNUM as 'nf',
       PROCOD as 'codigo',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'descricao',
       sum(NFSQTD*NFSQTDEMB) as 'quantidade'
  from TBS0671 (nolock) join TBS067 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
 where NFSDATEMI between '20140301' and '20141031' and
       NFSCAN='N' and
       NFSDEV='N' and
       NFSCLICOD in(512,590,6710,850,4567,14422) and
       PROCOD='1640054'
 group by NFSCLICOD,TBS067.NFSNUM,PROCOD


select NFSCLICOD as 'cliente',
       TBS067.NFSNUM as 'nf',
       PROCOD as 'codigo',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'descricao',
       sum(NFSQTD*NFSQTDEMB) as 'quantidade'
  from TBS0671 (nolock),TBS067 (nolock)
 where TBS0671.SNESER=TBS067.SNESER and
       TBS0671.NFSNUM=TBS067.NFSNUM and
       NFSDATEMI between '20140301' and '20141031' and
       NFSCAN='N' and
       NFSDEV='N' and
       NFSCLICOD in(512,590,6710,850,4567,14422) and
       PROCOD='1640054'
 group by NFSCLICOD,TBS067.NFSNUM,PROCOD


select NFSCLICOD as 'cliente',
       TBS067.NFSNUM as 'nf',
       PROCOD as 'codigo',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'descricao',
       sum(NFSQTD*NFSQTDEMB) as 'quantidade'
  from TBS0671 (nolock) left join TBS067 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
 where NFSDATEMI between '20140301' and '20141031' and
       NFSCAN='N' and
       NFSDEV='N' and
       NFSCLICOD in(512,590,6710,6709)
 group by NFSCLICOD,TBS067.NFSNUM,PROCOD


select PROCOD as 'codigo',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'descricao',
       sum(NFSQTD*NFSQTDEMB) as 'quantidade'
  from TBS0671 (nolock) left join TBS067 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
 where NFSDATEMI between '20140301' and '20141031' and
       NFSCAN='N' and
       NFSDEV='N' and
       NFSCLICOD in(512,590,6709,6710,7949,14422)
 group by PROCOD


drop table RELATORIO

create table RELATORIO (
   NFSDATEMI datetime default '17530101',
   SNESER int default 0,
   NFSNUM int default 0,
   NFSCLICOD int default 0,
   NFSCAN char(1) default 'N',
   NFSDEV char(1) default 'N',
   PROCOD char(15) default '',
   NFSPRODES char(60) default '',
   NFSQTD money default 0,
   NFSQTDDEV money default 0,
   NFSQTDEMB money default 0
)

delete RELATORIO

insert into RELATORIO
select '17530101',
       SNESER, 
       NFSNUM,
       0,
       'N',
       'N',
       PROCOD,
       NFSPRODES,
       NFSQTD,
       NFSQTDDEV,
       NFSQTDEMB
  from TBS0671 (nolock)
 where PROCOD='1640054'

select * from RELATORIO (nolock)

update RELATORIO set NFSDATEMI=TBS067.NFSDATEMI,NFSCLICOD=TBS067.NFSCLICOD,NFSCAN=TBS067.NFSCAN,NFSDEV=TBS067.NFSDEV
  from TBS067 (nolock)
 where TBS067.SNESER=RELATORIO.SNESER and
       TBS067.NFSNUM=RELATORIO.NFSNUM

select * from RELATORIO (nolock) where NFSCLICOD in(512,850,4567,6710,14422) and NFSDATEMI between '20140301' and '20141031'


