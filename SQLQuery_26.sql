-- NFSPERLUC(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint)

select avg(dbo.NFSPERLUC(d.NFSEMPCOD,d.NFSNUM,d.SNEEMPCOD,d.SNESER,d.NFSITE))
  from TBS0671 d with (nolock)
 inner join TBS067 c with (nolock)
    on c.NFSNUM=d.NFSNUM
 where c.NFSDATEMI >= '20240101'

-- mensal 

select convert(char(6),[data],112)
       ,avg(margemLucro)
  from DWVendas with (nolock)
 where cancelado='N'
       and nomeGrupoVendedor='TELEVENDAS'
 group by convert(char(6),[data],112)
 order by convert(char(6),[data],112)

select margemLucro
       ,*
  from DWVendas with (nolock)
 where cancelado='N'
       and numeroDocumento=347424

-- anual

select year([data])
       ,avg(margemLucro)
  from DWVendas with (nolock)
 where cancelado='N'
       and nomeGrupoVendedor='TELEVENDAS'
 group by year([data])
 order by year([data])

select year(c.NFSDATEMI)
       ,avg(dbo.NFSPERLUC(d.NFSEMPCOD,d.NFSNUM,d.SNEEMPCOD,d.SNESER,d.NFSITE))
  from TBS0671 d with (nolock)
 inner join TBS067 c with (nolock)
    on c.NFSNUM=d.NFSNUM
 where c.NFSCAN='N'
       and c.SNESER=1
       and c.NFSDATEMI between '20180101' and '20181231' -->= '20100101'
 group by year(c.NFSDATEMI)

 order by year(c.NFSDATEMI)

drop table #notas

select c.NFSDATEMI
       ,dbo.NFSPERLUC(d.NFSEMPCOD,d.NFSNUM,d.SNEEMPCOD,d.SNESER,d.NFSITE) as lucro
  into #notas
  from TBS0671 d with (nolock)
 inner join TBS067 c with (nolock)
    on c.NFSNUM=d.NFSNUM
 where c.NFSCAN='N'
       and c.SNESER=1
       and c.NFSDATEMI between '20190101' and '20191231' -->= '20100101'

select year(NFSDATEMI)
       ,avg(lucro)
  from #notas
 group by year(NFSDATEMI)

select *
  from #notas


