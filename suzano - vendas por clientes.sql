-- lista 1

select case CLITIPPES
          when 'J' then CLICGC
          else CLICPF
       end,
       CLINOM,
       CLICID,
--       convert(char(8),NFSDATEMI,3),
       TBS002.UFESIG,
       TBS010.PROCOD,
       PRODES,
       PROUM1,
       str(sum(NFSQTD*NFSQTDEMB),10) as 'qtde',
       str(avg((NFSPRE-(NFSPRE*NFSPDDITE/100))/NFSQTDEMB),12,2) as 'preco',
       str(sum((NFSPRE-(NFSPRE*NFSPDDITE/100))*NFSQTD),12,2) as 'total'
  from TBS067 (noLock) join TBS002 on TBS067.NFSCLICOD=TBS002.CLICOD
                       join TBS0671 on TBS0671.NFSNUM=TBS067.NFSNUM
                       join TBS042 on TBS0671.TESCOD=TBS042.TESCOD
                       join TBS010 on TBS010.PROCOD=TBS0671.PROCOD
 where TBS067.NFSDATEMI between '2009-01-01' and '2009-12-31' and TBS067.NFSCAN='N' and TBS010.PROCOD Like('164%')
       and TESCNTVEN='S'
 group by CLITIPPES,TBS002.UFESIG,CLICID,TBS010.PROCOD,PRODES,PROUM1,CLICGC,CLICPF,CLINOM
 order by CLINOM

-- lista 2

select case CLITIPPES
          when 'J' then CLICGC
          else CLICPF
       end,
       CLINOM,
       CLICID,
       TBS002.UFESIG,
       str(sum((NFSPRE-(NFSPRE*NFSPDDITE/100))*NFSQTD),12,2) as 'total'
  from TBS067 (noLock) join TBS002 on TBS067.NFSCLICOD=TBS002.CLICOD
                       join TBS0671 on TBS0671.NFSNUM=TBS067.NFSNUM
                       join TBS042 on TBS0671.TESCOD=TBS042.TESCOD
                       join TBS010 on TBS010.PROCOD=TBS0671.PROCOD
 where TBS067.NFSDATEMI between '2009-01-01' and '2009-12-31' and TBS067.NFSCAN='N' and TBS010.PROCOD Like('164%')
       and TESCNTVEN='S'
 group by CLITIPPES,TBS002.UFESIG,CLICID,CLICGC,CLICPF,CLINOM
 order by CLINOM