-- notas fiscais emitidas para clientes com inscricao estadual preenchidos como "isento" ou "vazio" e nao estao marcados como orgao publicos
select convert(char(7),NFSDATEMI,111),count(distinct TBS067.NFSNUM)
  from TBS067 (noLock) join TBS0671 (noLock) on TBS067.NFSNUM=TBS0671.NFSNUM
                       join TBS042 (noLock) on TBS0671.TESCOD=TBS042.TESCOD
                       join TBS002 (noLock) on TBS067.NFSCLICOD=TBS002.CLICOD
 where NFSDATEMI between '20100101' and '20101031' and TESCNTVEN='S' and CLIISEICMS<>'S' and (CLIIES='ISENTO' or CLIIES='') and CLITIPPES='J'
 group by convert(char(7),NFSDATEMI,111)
 order by convert(char(7),NFSDATEMI,111)

-- notas fiscais emitidas para clientes marcados como "orgao publico" (campo isencao ICMS)
select convert(char(7),NFSDATEMI,111),count(distinct TBS067.NFSNUM)
  from TBS067 (noLock) join TBS0671 (noLock) on TBS067.NFSNUM=TBS0671.NFSNUM
                       join TBS042 (noLock) on TBS0671.TESCOD=TBS042.TESCOD
                       join TBS002 (noLock) on TBS067.NFSCLICOD=TBS002.CLICOD
 where NFSDATEMI between '20100101' and '20101031' and TESCNTVEN='S' and CLIISEICMS='S'
 group by convert(char(7),NFSDATEMI,111)
 order by convert(char(7),NFSDATEMI,111)

-- notas fiscais para clientes de fora do estado com inscricao estadual e que nao estao marcados como isentos de ICMS
select convert(char(7),NFSDATEMI,111),count(distinct TBS067.NFSNUM)
  from TBS067 (noLock) join TBS0671 (noLock) on TBS067.NFSNUM=TBS0671.NFSNUM
                       join TBS042 (noLock) on TBS0671.TESCOD=TBS042.TESCOD
                       join TBS002 (noLock) on TBS067.NFSCLICOD=TBS002.CLICOD
 where NFSDATEMI between '20100101' and '20101031' and TESCNTVEN='S' and CLIISEICMS<>'S' and CLIIES<>'ISENTO' and CLIIES<>'' and NFSCFOP Like('6%') 
 group by convert(char(7),NFSDATEMI,111)
 order by convert(char(7),NFSDATEMI,111)

-- clientes marcados como isentos de cobraca do icms
select * from TBS002 (noLock) where CLIISEICMS='S'

-- clientes isentos de i.e.
select * from TBS002 (noLock) where CLIIES='ISENTO' or CLIIES=''

select count(distinct TBS067.NFSNUM)
  from TBS067 (noLock) join TBS0671 (noLock) on TBS067.NFSNUM=TBS0671.NFSNUM
                       join TBS042 (noLock) on TBS0671.TESCOD=TBS042.TESCOD
                       join TBS002 (noLock) on TBS067.NFSCLICOD=TBS002.CLICOD
 where NFSDATEMI between '20100901' and '20100930' and TESCNTVEN='S' and (CLIIES='ISENTO' or CLIIES='')


select distinct(TBS067.NFSNUM),TBS002.CLIIES
  from TBS067 (noLock) join TBS0671 (noLock) on TBS067.NFSNUM=TBS0671.NFSNUM
                       join TBS042 (noLock) on TBS0671.TESCOD=TBS042.TESCOD
                       join TBS002 (noLock) on TBS067.NFSCLICOD=TBS002.CLICOD
 where NFSDATEMI between '20100901' and '20100930' and TESCNTVEN='S' and (CLIIES='ISENTO' or CLIIES='')


select distinct(TBS067.NFSNUM),TBS002.CLIIES
  from TBS067 (noLock) join TBS0671 (noLock) on TBS067.NFSNUM=TBS0671.NFSNUM
                       join TBS042 (noLock) on TBS0671.TESCOD=TBS042.TESCOD
                       join TBS002 (noLock) on TBS067.NFSCLICOD=TBS002.CLICOD
 where NFSDATEMI between '20100901' and '20100930' and TESCNTVEN='S' and CLIIES<>'ISENTO' and CLIIES<>'' and NFSCFOP Like('6%')
