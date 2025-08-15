declare @dataini char(10) ,@datafin char(10)

-- parametros
set @dataini = '2008-10-26'		-- data inicial
set @datafin = '2008-11-25'		-- data final

declare _cursor cursor for select VENCOD,VENNOM from TBS004 (noLock) order by VENCOD

open _cursor

declare @codigo int ,@nome char(50)

fetch next from _cursor into @codigo ,@nome

while @@fetch_status = 0
   begin
      print str(@codigo,4,0) + ' ' + @nome

      select TBS067.VENCOD,VENNOM,str(sum((NFSPRE-(NFSPRE*NFSPDDITE/100))*NFSQTD),10,2) as 'venda',
       str(sum(NFSPRECUS*NFSQTD),10,2) as 'custo',
       str((1-(sum(NFSPRECUS*NFSQTD)/sum((NFSPRE-(NFSPRE*NFSPDDITE/100))*NFSQTD)))*100,6,2) as 'Lucro%'
  from TBS0671 inner join TBS042 on TBS0671.TESCOD=TBS042.TESCOD
               inner join TBS067 on TBS0671.NFSNUM=TBS067.NFSNUM
               inner join TBS004 on TBS067.VENCOD=TBS004.VENCOD
 where TBS042.TESCNTVEN='S' and TBS067.NFSDATEMI between @dataini and @datafin and
       TBS067.NFSCAN='N' and TBS067.VENCOD>0


      fetch next from _cursor into @codigo ,@nome
   end

close _cursor
deallocate _cursor

select TBS067.VENCOD,VENNOM,str(sum((NFSPRE-(NFSPRE*NFSPDDITE/100))*NFSQTD),10,2) as 'venda',
       str(sum(NFSPRECUS*NFSQTD),10,2) as 'custo',
       str((1-(sum(NFSPRECUS*NFSQTD)/sum((NFSPRE-(NFSPRE*NFSPDDITE/100))*NFSQTD)))*100,6,2) as 'Lucro%'
  from TBS0671 inner join TBS042 on TBS0671.TESCOD=TBS042.TESCOD
               inner join TBS067 on TBS0671.NFSNUM=TBS067.NFSNUM
               inner join TBS004 on TBS067.VENCOD=TBS004.VENCOD
 where TBS042.TESCNTVEN='S' and TBS067.NFSDATEMI between @dataini and @datafin and
       TBS067.NFSCAN='N' and TBS067.VENCOD>0
group by TBS067.VENCOD,VENNOM order by TBS067.VENCOD
