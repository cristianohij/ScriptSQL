select TBS067.VENCOD,
       CLICOD,
       case CLITIPPES
          when 'J' then CLICGC
          when 'F' then CLICPF
          else 'TND'
       end as 'CNPJ/CPF',
       str(sum((NFSPRE-(NFSPRE*NFSPDDITE/100))*NFSQTD),12,2) as 'total'
  from TBS067 (noLock) join TBS002 on TBS067.NFSCLICOD=TBS002.CLICOD
                       join TBS0671 on TBS0671.NFSNUM=TBS067.NFSNUM
                       join TBS042 on TBS0671.TESCOD=TBS042.TESCOD
                       join TBS010 on TBS010.PROCOD=TBS0671.PROCOD
 where TBS067.NFSDATEMI between '2011-07-01' and '2012-04-30' and
       TBS067.NFSCAN = 'N' and
       TESCNTVEN = 'S' and
       TBS067.VENCOD in(2,3,4,5,8,10,12,18,30,33,35,42,63,65,74,79)
 group by TBS067.VENCOD,CLICOD,CLITIPPES,CLICGC,CLICPF

insert into #bestTemp
select TBS067.VENCOD,
       case CLITIPPES
          when 'J' then CLICGC
          when 'F' then CLICPF
          else 'TND'
       end as 'CNPJ/CPF',
       str(sum((NFSPRE-(NFSPRE*NFSPDDITE/100))*NFSQTD),12,2) as 'total'
  from TBS067 (noLock) join TBS002 on TBS067.NFSCLICOD=TBS002.CLICOD
                       join TBS0671 on TBS0671.NFSNUM=TBS067.NFSNUM
                       join TBS042 on TBS0671.TESCOD=TBS042.TESCOD
                       join TBS010 on TBS010.PROCOD=TBS0671.PROCOD
 where TBS067.NFSDATEMI between '2011-07-01' and '2012-04-30' and
       TBS067.NFSCAN = 'N' and
       TESCNTVEN = 'S' and
       TBS067.VENCOD in(2,3,4,5,8,10,12,18,30,33,35,42,63,65,74,79)
 group by TBS067.VENCOD,CLICOD,CLITIPPES,CLICGC,CLICPF

create table besven(venb smallint,docb char(14),totb money)
create table papven(venp smallint,docp char(14),totp money)

select case when totb > totp then venb else venp end,venp,venb,docp,docb,totp,totb from papven join besven on docp = docb

select case when totb > totp then venb else venp end,case when totb > totp then 'B' else 'P' end,venp,venb,docp,docb,totp,totb
  from papven join besven on docp = docb

create table bespapven(ven smallint,doc char(14),emp char(1))

insert into bespapven
select case when totb > totp then venb else venp end,docp,case when totb > totp then 'B' else 'P' end
  from papven join besven on docp = docb

update bespapven set ven = 33 where ven = 12 and emp = 'B'

select CLICGC,VENCOD,doc,ven from TBS002 join bespapven on CLICGC = doc

update TBS002 set VENCOD = 0 from TBS002 (nolock) join TBS002X (nolock) on TBS002.CLICGC = TBS002X.CLICGC

update TBS002 set VENCOD = ven from TBS002 (nolock) join bespapven on CLICGC = doc and emp = 'B'