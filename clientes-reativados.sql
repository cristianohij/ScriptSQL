-- códigos dos clientes do grupo

if object_id('tempdb.dbo.#CodigosClienteGrupo') is not null
    begin
    	drop table #CodigosClienteGrupo
    end

create table #CodigosClienteGrupo (codigo int)

insert into #CodigosClienteGrupo
exec sp_ClientesGrupo

alter table #CodigosClienteGrupo add nomeFantasia varchar(25)

update #CodigosClienteGrupo
   set nomeFantasia=(select CLINOMFAN from TBS002 with (nolock) where CLICOD=codigo)

select codigoCliente
       ,nomeCliente
       ,[data]
       ,uf
       ,codigoVendedor
       ,nomeVendedor
       ,(select CLIPRICOM from TBS002 c with (nolock) where c.CLICOD=v.codigoCliente)
  from DWVendas v with (nolock)
 where [data] between '20230101' and '20230317'
       and caixa=0
       and numeroSerieDocumento=1
       and codigoCliente not in (select codigo from #CodigosClienteGrupo)
       and cancelado='N'
       and not exists(select ''
                        from DWVendas v2 with (nolock)
                       where v2.codigoCliente=v.codigoCliente
                             and v2.[data] between '20221001' and '20221231'
                             and caixa=0
                             and numeroSerieDocumento=1
                             and codigoCliente not in (select codigo from #CodigosClienteGrupo)
                             and cancelado='N')
 group by codigoCliente
          ,nomeCliente
          ,[data]
          ,uf
          ,codigoVendedor
          ,nomeVendedor

-- compraram anteriormente a 30/09/22

if object_id('tempdb.dbo.#ate_092022') is not null
    begin
    	drop table #ate_092022
    end

select codigoCliente as 'codigo'
       ,max([data]) as 'dia'
  into #ate_092022
  from DWVendas v with (nolock)
 where [data] <= '20220930'
       and caixa=0
       and numeroSerieDocumento=1
       and codigoCliente not in (select codigo from #CodigosClienteGrupo)
       and cancelado='N'
 group by codigoCliente

select *
  from #ate_092022

select codigo
  from #ate_092022
 group by codigo
having count(*) > 1

-- clientes que não compraram entre 01/10/22 e 31/12/22

if object_id('tempdb.dbo.#nao_compraram_inter') is not null
    begin
    	drop table #nao_compraram_inter
    end

select *
  into #nao_compraram_inter
  from #ate_092022
 where not exists(select 'ne'
  from DWVendas v with (nolock)
 where [data] between '20221001' and '20221231'
       and caixa=0
       and numeroSerieDocumento=1
       and codigoCliente not in (select codigo from #CodigosClienteGrupo)
       and cancelado='N'
       and codigoCliente=codigo)

select codigoCliente
       ,max([data])
--  into #nao_intervalo
  from DWVendas with (nolock)
 where [data] between '20221001' and '20221231'
       and caixa=0
       and numeroSerieDocumento=1
       and codigoCliente not in (select codigo from #CodigosClienteGrupo)
       and cancelado='N'
       and exists(select 'e'
                    from #ate_092022
                   where #ate_092022.codigo=DWVendas.codigoCliente)
 group by DWVendas.codigoCliente

select *
  from #nao_compraram_inter

-- resultado final

if object_id('tempdb.dbo.#res_final') is not null
    begin
    	drop table #res_final
    end

select *
  into #res_final
  from #nao_compraram_inter
 where exists(select 'e'
  from DWVendas v with (nolock)
 where [data] between '20230101' and '20230317'
       and caixa=0
       and numeroSerieDocumento=1
       and codigoCliente not in (select codigo from #CodigosClienteGrupo)
       and cancelado='N'
       and codigoCliente=codigo)

select *
  into #res_final
  from #nao_intervalo
 where exists(
 select codigoCliente
        
  from DWVendas v with (nolock)
 where [data] between '20230101' and '20230317'
       and caixa=0
       and numeroSerieDocumento=1
       and codigoCliente not in (select codigo from #CodigosClienteGrupo)
       and cancelado='N'
       and codigoCliente=codigo)

select *
  from #res_final

-- lista de cliente/vendedor

if object_id('tempdb.dbo.#cliente_vendedor') is not null
    begin
    	drop table #cliente_vendedor
    end

select CLICOD
       ,CLINOM
       ,VENCOD
       ,(select VENNOM
           from TBS004 v with (nolock)
          where v.VENEMPCOD=c.CLIEMPCOD
                and v.VENCOD=c.VENCOD) as 'VENNOM'
  into #cliente_vendedor
  from TBS002 c with (nolock)
 where CLICOD in(select codigo
                   from #res_final)

select codigo
       ,(select CLINOM from #cliente_vendedor where #cliente_vendedor.CLICOD=codigo) as 'vendedor'
       ,dia as 'compra_anterior'
       --,(select dia from #ate_092022 where #ate_092022.codigo=#res_final.codigo) as 'compra_anterior'
       ,(select top(1) [data]
           from DWVendas with (nolock)
          where [data] between '20230101' and '20230317'
                and caixa=0
                and numeroSerieDocumento=1
                and codigoCliente not in (select codigo from #CodigosClienteGrupo)
                and cancelado='N' and DWVendas.codigoCliente=#res_final.codigo order by [data] desc) as 'compra_atual'
       ,(select sum(valorTotal)
           from DWVendas with (nolock)
          where [data] between '20230101' and '20230317'
                and caixa=0
                and numeroSerieDocumento=1
                and codigoCliente not in (select codigo from #CodigosClienteGrupo)
                and cancelado='N' and DWVendas.codigoCliente=#res_final.codigo) as 'valor'
       ,(select VENCOD from #cliente_vendedor where #cliente_vendedor.CLICOD=codigo) as 'cod_vendedor'
       ,(select VENNOM from #cliente_vendedor where #cliente_vendedor.CLICOD=codigo) as 'vendedor'
  from #res_final

opo