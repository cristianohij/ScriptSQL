select count(*)
  from TBS010 with (nolock)


select tab.tot_produtos
       ,tab.ativos
       ,tab.fora_linha
       ,tab.inativos
       --,(select count(*) from TBS032 e with (nolock) where e.ESTLOC=1 and e.ESTQTDATU > 0) as 'qt_estoque'
       --,(select count(*) from TBS032 e with (nolock) where e.ESTLOC=2 and e.ESTQTDATU > 0) as 'qt_loja'
  from (
         select (select count(*) from TBS010 with (nolock) )as 'tot_produtos',
                (select count(*) from TBS010 with (nolock) where PROSTATUS='A') as 'ativos',         
                (select count(*) from TBS010 with (nolock) where PROSTATUS='F') as 'fora_linha',
                (select count(*) from TBS010 with (nolock) where PROSTATUS='I') as 'inativos'
        ) tab

999

-- códigos dos clientes do grupo

if object_id('tempdb..##CodigosClienteGrupo') is not null
   drop table ##CodigosClienteGrupo

create table ##CodigosClienteGrupo (codigo int)

insert into ##CodigosClienteGrupo
exec sp_ClientesGrupo

alter table ##CodigosClienteGrupo add nomeFantasia varchar(25)

update ##CodigosClienteGrupo
   set nomeFantasia=(select CLINOMFAN from TBS002 with (nolock) where CLICOD=codigo)

select codigo
       ,nomeFantasia
  from ##CodigosClienteGrupo

select convert(char(6), [data], 112) as 'periodo'
       ,count(distinct codigoProduto) as 'produtos'
  from DWVendas with (nolock)
 where [data] >= '20230101'
       --and caixa=0
       --and numeroSerieDocumento=1
       and codigoCliente not in (select codigo from ##CodigosClienteGrupo)
       and cancelado='N'
 group by convert(char(6), [data], 112)


select tab.periodo
  from (
         select (select convert(char(6), [data], 112) as 'periodo'
       ,count(distinct codigoProduto) as 'produtos'
  from DWVendas with (nolock)
 where [data] >= '20230101'
       --and caixa=0
       --and numeroSerieDocumento=1
       and codigoCliente not in (select codigo from ##CodigosClienteGrupo)
       and cancelado='N'
 group by convert(char(6), [data], 112))
  ) as tab

if object_id('tempdb..#dados') is not null
   drop table #dados

select convert(char(6), [data], 112) as 'periodo'
       ,count(distinct codigoProduto) as 'produtos'
  into #dados
  from DWVendas t0 with (nolock)
 where [data] between '20230101' and '20231031'
       and codigoCliente not in (select codigo from ##CodigosClienteGrupo)
       and cancelado='N'
 group by convert(char(6), [data], 112)
 
select *
  from #dados

select *
       ,(
          select count(distinct codigoProduto)
            from DWVendas with (nolock)
           where convert(char(6), [data], 112) = periodo
                 and caixa=0
                 and numeroSerieDocumento=1
                 and codigoCliente not in (select codigo from ##CodigosClienteGrupo)
                 and cancelado='N'
        ) as 'televendas'
        ,
        (
          select count(distinct codigoProduto)
            from DWVendas with (nolock)
           where convert(char(6), [data], 112) = periodo
                 and caixa > 0
                 and codigoCliente not in (select codigo from ##CodigosClienteGrupo)
                 and cancelado='N'
        ) as 'loja'
        ,
        (
          select count(distinct i.PROCOD)
           from TBS0591 i with (nolock)
                inner join TBS059 c with (nolock)
                   on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
          where convert(char(6), c.NFEDATEFE, 112) = periodo
                and c.NFETIP='N'
                and c.NFECAN='N'
        ) as 'compras'
  from #dados
 order by periodo

select *
  from TBS035 with (nolock)
 where LOGDAT between '20230101' and '20231031'
       and LOGTAB='TBS010'
       and LOGATT='PROSTATUS'

select count(distinct LOGID)
  from TBS035 with (nolock)
 where LOGDAT between '20230101' and '20231031'
       and LOGTAB='TBS010'
       and LOGVALATU='I'