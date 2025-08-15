set nocount on

declare @dataini char(10) ,@datafin char(10)

-- parametros
set @dataini = '2010-01-01'		-- data inicial
set @datafin = '2011-05-13'		-- data final

declare c cursor for
 select TBS0671.PROCOD,TBS0671.NFSPRODES,TBS010.PROUM1
   from TBS0671 (nolock) right join TBS067 (nolock) on TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM
                         right join TBS010 (nolock) on TBS0671.PROCOD=TBS010.PROCOD
  where TBS067.NFSDATEMI between @dataini and @datafin and
        exists(select 'ex' from TBS0673 (nolock) 
                where TBS0671.NFSEMPCOD=TBS0673.NFSEMPCOD and TBS0671.NFSNUM=TBS0673.NFSNUM and TBS0671.NFSITE=TBS0673.NFSITE)
  group by TBS0671.PROCOD,TBS0671.NFSPRODES,TBS010.PROUM1
  order by TBS0671.NFSPRODES

open c

declare @codigo char(15) ,@descri char(60) ,@um char(2)

fetch next from c into @codigo ,@descri ,@um

print ''
print 'Relatório de Saídas por Lotes'
print '-----------------------------'
print ''

while @@fetch_status = 0
   begin
      print rtrim(@codigo) + ' - ' + @descri + ' ' + @um
      print ''

      -- relatorio de saidas
      select TBS067.NFSNUM as 'nf',
             convert(char(8),TBS067.NFSDATEMI,3) as 'emissao',
             TBS067.NFSCLINOM as 'cliente',
             TBS067.NFSCAN as 'can',
             TBS067.NFSDEV as 'dev',
             TBS0673.NFSLOTNUM as 'lote',
             convert(char(8),TBS0673.NFSDATFAB,3) as 'fabricacao',
             convert(char(8),TBS0673.NFSDATVAL,3) as 'validade',
             TBS0673.NFSQTDLOT * TBS0671.NFSQTDEMB
        from TBS0671 (nolock) right join TBS0673 (nolock) on TBS0671.NFSEMPCOD=TBS0673.NFSEMPCOD and TBS0671.NFSNUM=TBS0673.NFSNUM and
                                                             TBS0671.NFSITE=TBS0673.NFSITE
                              right join TBS067 (nolock) on TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.NFSNUM=TBS0671.NFSNUM
       where TBS067.NFSDATEMI between @dataini and @datafin and TBS0671.PROCOD=@codigo
       order by TBS067.NFSDATEMI
       compute sum(TBS0673.NFSQTDLOT * TBS0671.NFSQTDEMB)

      fetch next from c into @codigo ,@descri ,@um
   end

close c
deallocate c

declare c cursor for
 select TBS0591.PROCOD,TBS0591.NFEDES,TBS010.PROUM1
   from TBS0591 (nolock) right join TBS059 (nolock) on TBS0591.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0591.NFENUM=TBS059.NFENUM
                         right join TBS010 (nolock) on TBS0591.PROCOD=TBS010.PROCOD
                         left join TBS0594 (nolock) on TBS0591.NFEEMPCOD=TBS0594.NFEEMPCOD and TBS0591.NFENUM=TBS0594.NFENUM and
                                                       TBS0591.NFEITE=TBS0594.NFEITE
  where TBS059.NFEDATEMI between @dataini and @datafin and
        exists(select 'ex' from TBS0594 (nolock)
                where TBS0591.NFEEMPCOD=TBS0594.NFEEMPCOD and TBS0591.NFENUM=TBS0594.NFENUM and TBS0591.NFEITE=TBS0594.NFEITE)
  group by TBS0591.PROCOD,TBS0591.NFEDES,TBS010.PROUM1
  order by TBS0591.NFEDES

open c

fetch next from c into @codigo ,@descri ,@um

print ''
print 'Relatório de Entradas por Lotes'
print '-----------------------------'
print ''

while @@fetch_status = 0
   begin
      print rtrim(@codigo) + ' - ' + @descri + ' ' + @um
      print ''

      -- relatorio de enttadas
      select TBS059.NFENUM as 'nf',
             convert(char(8),TBS059.NFEDATEMI,3) as 'emissao',
             TBS059.NFENOM as 'fornecedor',
             TBS059.NFECAN as 'can',
             TBS0594.NFELOTNUM as 'lote',
             convert(char(8),TBS0594.NFEDATFAB,3) as 'fabricacao',
             convert(char(8),TBS0594.NFEDATVAL,3) as 'validade',
             TBS0594.NFEQTDLOT * TBS0591.NFEQTDEMB as 'qtde'
        from TBS0591 (nolock) right join TBS0594 (nolock) on TBS0591.NFEEMPCOD=TBS0594.NFEEMPCOD and TBS0591.NFETIP=TBS0594.NFETIP and
                                                             TBS0591.NFENUM=TBS0594.NFENUM and TBS0591.SERCOD=TBS0594.SERCOD and TBS0591.NFEITE=TBS0594.NFEITE
                              right join TBS059 (nolock) on TBS059.NFEEMPCOD=TBS0591.NFEEMPCOD and TBS059.NFETIP=TBS0591.NFETIP and
                                                            TBS059.NFENUM=TBS0591.NFENUM and TBS059.SERCOD=TBS0591.SERCOD
       where TBS059.NFEDATEMI between @dataini and @datafin and TBS0591.PROCOD=@codigo
       order by TBS059.NFEDATEMI
       compute sum(TBS0594.NFEQTDLOT * TBS0591.NFEQTDEMB)

      fetch next from c into @codigo ,@descri ,@um
   end

close c
deallocate c

declare c cursor for
 select TBS010.PROCOD,TBS010.PRODES,TBS010.PROUM1 from TBS010 (nolock)
  where exists(select 'ex' from TBS0591 (nolock) inner join TBS0594 (nolock) on TBS0591.NFEEMPCOD=TBS0594.NFEEMPCOD and TBS0591.NFETIP=TBS0594.NFETIP and
                                                                                TBS0591.NFENUM=TBS0594.NFENUM and TBS0591.SERCOD=TBS0594.SERCOD and
                                                                                TBS0591.NFEITE=TBS0594.NFEITE
                                                 inner join TBS059 (nolock) on TBS059.NFEEMPCOD=TBS0591.NFEEMPCOD and TBS059.NFETIP=TBS0591.NFETIP and
                                                                               TBS059.NFENUM=TBS0591.NFENUM and TBS059.SERCOD=TBS0591.SERCOD
                where TBS059.NFEDATEMI between @dataini and @datafin and TBS0591.PROCOD=TBS010.PROCOD)
  order by TBS010.PRODES

open c

fetch next from c into @codigo ,@descri ,@um

print ''
print 'Relatório de Entradas X Saídas por Lotes'
print '----------------------------------------'
print ''

while @@fetch_status = 0
   begin
      print rtrim(@codigo) + ' - ' + @descri + ' ' + @um
      print ''

      -- relatorio de entradas X saidas
      select TBS059.NFENUM as 'nf',
             convert(char(8),TBS059.NFEDATEMI,3) as 'emissao',
             TBS059.NFENOM as 'fornecedor',
             TBS059.NFECAN as 'can',
             TBS0594.NFELOTNUM as 'lote',
             convert(char(8),TBS0594.NFEDATFAB,3) as 'fabricacao',
             convert(char(8),TBS0594.NFEDATVAL,3) as 'validade',
             TBS0594.NFEQTDLOT * TBS0591.NFEQTDEMB as 'qtde',
             TBS067.NFSNUM as 'nf',
             convert(char(8),TBS067.NFSDATEMI,3) as 'emissao',
             TBS067.NFSCLINOM as 'cliente',
             TBS067.NFSCAN as 'can',
             TBS067.NFSDEV as 'dev',
             TBS0673.NFSLOTNUM as 'lote',
             convert(char(8),TBS0673.NFSDATFAB,3) as 'fabricacao',
             convert(char(8),TBS0673.NFSDATVAL,3) as 'validade',
             TBS0673.NFSQTDLOT * TBS0671.NFSQTDEMB as 'qtde'
        from TBS0591 (nolock) join TBS0594 (nolock) on TBS0591.NFEEMPCOD=TBS0594.NFEEMPCOD and TBS0591.NFETIP=TBS0594.NFETIP and
                                                             TBS0591.NFENUM=TBS0594.NFENUM and TBS0591.SERCOD=TBS0594.SERCOD and TBS0591.NFEITE=TBS0594.NFEITE
                              join TBS059 (nolock) on TBS059.NFEEMPCOD=TBS0591.NFEEMPCOD and TBS059.NFETIP=TBS0591.NFETIP and
                                                            TBS059.NFENUM=TBS0591.NFENUM and TBS059.SERCOD=TBS0591.SERCOD
                              join TBS0671 (nolock) on TBS0671.PROCOD=TBS0591.PROCOD
                              join TBS0673 (nolock) on TBS0671.NFSEMPCOD=TBS0673.NFSEMPCOD and TBS0671.NFSNUM=TBS0673.NFSNUM and
                                                             TBS0671.NFSITE=TBS0673.NFSITE and
                                                             TBS0673.NFSLOTNUM=TBS0594.NFELOTNUM and TBS0673.NFSDATVAL=TBS0594.NFEDATVAL
                              join TBS067 (nolock) on TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.NFSNUM=TBS0671.NFSNUM
       where (TBS059.NFEDATEMI between @dataini and @datafin or TBS067.NFSDATEMI between @dataini and @datafin) and
             (TBS0591.PROCOD=@codigo or TBS0671.PROCOD=@codigo)
       order by TBS059.NFEDATEMI
       compute sum(TBS0673.NFSQTDLOT * TBS0671.NFSQTDEMB)

      fetch next from c into @codigo ,@descri ,@um
   end

close c
deallocate c