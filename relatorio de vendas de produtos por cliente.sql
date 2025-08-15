declare @datini datetime,@datfin datetime
declare @prode char(15),@proate char(15)
declare @vende int,@venate int

-- data de/ate
select @datini='20100801',@datfin='20100831'

-- produto de/ate
select @prode='653',@proate='653Z'		

-- vendedor de/ate
select @vende=0,@venate=9999

declare @codcli int

declare curClientes scroll cursor for
 select distinct NFSCLICOD
   from TBS067 (noLock) join TBS0671 (noLock) on TBS067.NFSNUM=TBS0671.NFSNUM
  where TBS067.NFSDATEMI between @datini and @datfin and
        TBS067.VENCOD between @vende and @venate and
        TBS0671.PROCOD between @prode and @proate and
        TBS0671.LESCOD=1
  order by TBS067.NFSCLICOD

open curClientes

fetch next from curClientes into @codcli

while @@fetch_status=0 begin
   select TBS067.NFSNUM as NF,
          TBS067.NFSTIP as tipo,
          TBS067.NFSDATEMI as emissao,
          TBS067.NFSCAN as cancelada,
          TBS067.NFSDEV as devolvida,
          TBS067.NFSCLICOD as codigo_cliente,
          TBS067.NFSCLINOM as nome_cliente,
          TBS067.VENCOD as codigo_vendedor,
          TBS004.VENNOM as nome_vendedor,
          TBS067.UFESIG as UF,
          TBS0671.NFSITE as item,
          TBS0671.PROCOD as codigo_produto,
          TBS0671.NFSQTD*TBS0671.NFSQTDEMB as quantidade,
          TBS0671.NFSPRE-(TBS0671.NFSPRE*TBS0671.NFSPDDITE/100) as preco,
          (TBS0671.NFSQTD*TBS0671.NFSQTDEMB)*(TBS0671.NFSPRE-(TBS0671.NFSPRE*TBS0671.NFSPDDITE/100)) as total_item,
          TBS0671.TESCOD as tipo_saida,
          TBS042.TESCNTVEN as contabiliza_vendas,
          TBS0671.NFSMOVEST as movimenta_estoque,
          TBS0671.NFSPBI*(TBS0671.NFSQTD*TBS0671.NFSQTDEMB)*(TBS0671.NFSPRE-(TBS0671.NFSPRE*TBS0671.NFSPDDITE/100)) as base_ICMS,
          TBS0671.NFSPERICMS as percentual_ICMS,
          (TBS0671.NFSPBI*(TBS0671.NFSQTD*TBS0671.NFSQTDEMB)*(TBS0671.NFSPRE-(TBS0671.NFSPRE*TBS0671.NFSPDDITE/100)))*TBS0671.NFSPERICMS/100 as valor_ICMS,
          TBS0671.NFSCFOP as CFOP,
          TBS010.MARCOD as codigo_marca,
          TBS010.MARNOM as nome_marca
     from TBS067 (noLock) join TBS0671 (noLock) on TBS067.NFSNUM=TBS0671.NFSNUM
                          join TBS010 (noLock) on TBS0671.PROCOD=TBS010.PROCOD
                          join TBS042 (noLock) on TBS0671.TESCOD=TBS042.TESCOD
                          join TBS004 (noLock) on TBS067.VENCOD=TBS004.VENCOD
    where TBS067.NFSCLICOD=@codcli and
          TBS067.NFSDATEMI between @datini and @datfin and
          TBS067.VENCOD between @vende and @venate and
          TBS0671.PROCOD between @prode and @proate and
          TBS0671.LESCOD=1


   fetch next from curClientes into @codcli
end

close curClientes
deallocate curClientes