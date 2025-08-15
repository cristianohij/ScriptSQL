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


-- vendas corporativo, exceto do grupo
-- nf-e
-- série 1

if object_id('tempdb..##vendas_corporativo') is not null
   drop table ##vendas_corporativo

declare @datade date, @dataate date

select @datade='20230601', @dataate='20230626'

select tab2.dia
       ,tab2.cod_grupo
       ,tab2.nome_grupo
       ,tab2.total_bruto
       ,tab2.total_custo
       ,tab2.q_notas_total
       ,tab2.cancelamento
       ,tab2.custo_cancelamento
       ,tab2.q_notas_canceladas
       ,tab2.total_liquido
       ,tab2.custo_liquido
       ,tab2.q_notas_total - tab2.q_notas_canceladas as 'qtde_notas'
  into ##vendas_corporativo
  from (
         select tab.dia
                ,tab.codigoGrupoVendedor as 'cod_grupo'
                ,isnull((select GVEDES
                           from TBS091 with (nolock)
                          where GVECOD=tab.codigoGrupoVendedor),'SEM GRUPO') as 'nome_grupo'
                ,tab.total_bruto
                ,tab.total_custo
                ,(select count(distinct numeroDocumento)
                    from DWVendas with (nolock)
                   where [data]=tab.dia  -- between @datade and @dataate
                         and caixa=0
                         and numeroSerieDocumento=1
                         and codigoCliente not in (select codigo from ##CodigosClienteGrupo)
                         and cancelado='N'
                         and codigoGrupoVendedor=tab.codigoGrupoVendedor) as 'q_notas_total'
                ,tab.cancelamento
                ,tab.custo_cancelamento
                ,(select count(distinct numeroDocumento)
                    from DWVendas with (nolock)
                   where [data]=tab.dia  -- between @datade and @dataate
                         and caixa=0
                         and numeroSerieDocumento=1
                         and codigoCliente not in (select codigo from ##CodigosClienteGrupo)
                         and cancelado='S'
                         and codigoGrupoVendedor=tab.codigoGrupoVendedor) as 'q_notas_canceladas'
                ,tab.total_bruto - tab.cancelamento as 'total_liquido'
                ,tab.total_custo - tab.custo_cancelamento as 'custo_liquido'
           from (
                  select [data] as 'dia'
                         ,codigoGrupoVendedor
                         ,sum(case when  cancelado='N' then valorTotal else 0 end) as 'total_bruto'
                         ,sum(case when  cancelado='N' then custoTotal else 0 end) as 'total_custo'
                         ,sum(case when  cancelado='S' then valorTotal else 0 end) as 'cancelamento'
                         ,sum(case when  cancelado='S' then custoTotal else 0 end) as 'custo_cancelamento'
                    from DWVendas with (nolock)
                   where [data] between @datade and @dataate
                         and caixa=0
                         and numeroSerieDocumento=1
                         and codigoCliente not in (select codigo from ##CodigosClienteGrupo)
                   group by [data], codigoGrupoVendedor
                ) as tab
       ) as tab2
 order by tab2.dia, tab2.cod_grupo

 -- 00:00:00

select dia
       ,cod_grupo
       ,nome_grupo
       ,total_bruto
       ,total_custo
       ,q_notas_total
       ,cancelamento
       ,custo_cancelamento
       ,q_notas_canceladas
       ,total_liquido
       ,custo_liquido
       ,qtde_notas
  from ##vendas_corporativo
 order by dia, cod_grupo

select *
  from TBS080 with (nolock)
 where ENFDATEMI between '20230501' and '20230531'
       and ENFSIT=7
       and ENFDESREM not Like('%BEST BAG%')
	and ENFDESREM not Like('%MISASPEL%')
	and ENFDESREM not Like('%PAPELYNA%')
	and ENFDESREM not Like('%TANBY%')
	and ENFDESREM not Like('%WINPACK%')
       and ENFTIPDOC=1
       and ENFFINEMI=1
       and ENFFOREMI=1
       and SNESER=1

-- dia 11 41,90 nf 328955 e 328980

select top(100) *
  from DWVendas with (nolock)

select numeroDocumento
       ,sum(valorTotal)
  from DWVendas with (nolock)
 where [data] between '20230511' and '20230511'
       and numeroSerieDocumento=1
       and cancelado='N'
       and nomeCliente not Like('%BEST BAG%')
	and nomeCliente not Like('%MISASPEL%')
	and nomeCliente not Like('%PAPELYNA%')
	and nomeCliente not Like('%TANBY%')
	and nomeCliente not Like('%WINPACK%')       
 group by numeroDocumento

select *
  from DWVendas with (nolock)
 where numeroDocumento=329371
       and numeroSerieDocumento=1

select *
  from TBS080 with (nolock)
 where ENFNUM=329371

-- devolução de nf-e, exceto entre o grupo

if object_id('tempdb..##devolucao_corporativo') is not null
   drop table ##devolucao_corporativo

-- agrupada conforme o grupo

declare @datade date, @dataate date

select @datade='20230601', @dataate='20230626'

select convert(date,tab2.dia) as 'dia'
       ,tab2.cod_grupo
       ,sum(tab2.total_devolvido) as 'total_devolvido'
       ,sum(tab2.custo_devolucao) as 'custo_devolucao'
       ,tab2.q_devolucoes
  into ##devolucao_corporativo
  from (
         select *
         ,(select count(distinct c.NFEID)
           from TBS059 c with (nolock)
                inner join TBS0591 i with (nolock)
                   on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
                Left join TBS0596 r with (nolock)
                   on r.NFEEMPCOD=c.NFEEMPCOD and r.NFETIP=c.NFETIP and r.NFENUM=c.NFENUM and r.NFECOD=c.NFECOD and r.SEREMPCOD=c.SEREMPCOD and r.SERCOD=c.SERCOD  
         where c.NFEDATEFE between @datade and @dataate
               and c.NFETIP='D'
               and c.NFECAN='N'
               and r.NFENFRTIP <> 'CFE'
               and c.[NFEDATEFE]=tab.dia) as 'q_devolucoes'
           from (
                  select c.[NFEDATEFE] as 'dia' -- day(c.[NFEDATEFE])
                         ,isnull((select g.GVECOD
                                    from TBS080 n with (nolock)
                                         Left join TBS004 v with (nolock)
                                           on v.VENCOD=n.ENFVENCOD
                                         Left join TBS091 g with (nolock)
                                           on g.GVECOD=v.GVECOD
                                   where n.ENFCHAACE=r.NFENFRCHA),0) as 'cod_grupo'
                         ,sum(i.NFETOTOPEITE) as 'total_devolvido'
                         ,sum(i.NFEQTD * i.NFENFSPRECUS) as 'custo_devolucao'
                    from TBS059 c with (nolock)
                         inner join TBS0591 i with (nolock)
                            on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
                          Left join TBS0596 r with (nolock)
                            on r.NFEEMPCOD=c.NFEEMPCOD and r.NFETIP=c.NFETIP and r.NFENUM=c.NFENUM and r.NFECOD=c.NFECOD and r.SEREMPCOD=c.SEREMPCOD and r.SERCOD=c.SERCOD  
                   where c.NFEDATEFE between @datade and @dataate
                         and c.NFETIP='D'
                         and c.NFECAN='N'
                         and r.NFENFRTIP <> 'CFE'
                         and c.NFECOD not in (select codigo from ##CodigosClienteGrupo)
                   group by c.NFEDATEFE, r.NFENFRCHA
                ) as tab
       ) as tab2
 group by convert(date,tab2.dia), tab2.cod_grupo, tab2.q_devolucoes

-- 00:00:02

select dia
       ,cod_grupo
       ,total_devolvido
       ,custo_devolucao
       ,q_devolucoes
  from ##devolucao_corporativo

if isnull((select top(1) 1 from ##vendas_corporativo),0) > 0 or isnull((select top(1) 1 from ##devolucao_corporativo),0) > 0
   begin
      if object_id('tempdb..##vendas_corporativo_detalhada') is not null
         drop table ##vendas_corporativo_detalhada

         select tab.data
                ,tab.cod_grupo
                ,tab.nome_grupo
                ,tab.total_bruto
                ,tab.total_custo
                ,tab.q_notas_total
                ,tab.cancelamento
                ,tab.custo_cancelamento
                ,tab.q_notas_canceladas
                ,tab.total_devolvido
                ,tab.custo_devolucao
                ,tab.q_devolucoes
                ,tab.total_liquido
                ,tab.custo_liquido
                ,tab.qtde_notas - tab.q_devolucoes as 'qtde_notas'
                
                ,(1- tab.total_custo / tab.total_bruto) * 100 as 'margem_lucro_bruto'
                ,(1- tab.custo_liquido / tab.total_liquido) * 100 as 'margem_lucro_liquido'
                ,iif(tab.cancelamento > 0, tab.cancelamento / tab.total_bruto * 100, 0) as 'porc_cancelamento'
                ,iif(tab.total_devolvido > 0, tab.total_devolvido / tab.total_bruto * 100, 0) as 'porc_devolucao'
           into ##vendas_corporativo_detalhada       
           from (
                  select v.dia as 'data'
                         ,v.cod_grupo
                         ,v.nome_grupo
                         ,v.total_bruto
                         ,v.total_custo
                         ,v.q_notas_total
                         ,v.cancelamento
                         ,v.custo_cancelamento
                         ,v.q_notas_canceladas
                         ,isnull(d.total_devolvido,0) as 'total_devolvido'
                         ,isnull(d.custo_devolucao,0) as 'custo_devolucao'
                         ,isnull(d.q_devolucoes,0) as 'q_devolucoes'
                         ,v.total_liquido - isnull(d.total_devolvido,0) as 'total_liquido'
                         ,v.custo_liquido - isnull(d.custo_devolucao,0) as 'custo_liquido'
                         ,v.qtde_notas
                    from ##vendas_corporativo v
                         Left join ##devolucao_corporativo d
                                on d.dia=v.dia
                                   and d.cod_grupo=v.cod_grupo
                ) as tab

         select [data]
                ,cod_grupo
                ,nome_grupo
                ,total_bruto
                ,total_custo
                ,q_notas_total
                ,cancelamento
                ,custo_cancelamento
                ,q_notas_canceladas
                ,total_devolvido
                ,custo_devolucao
                ,q_devolucoes
                ,total_liquido
                ,custo_liquido
                ,margem_lucro_bruto
                ,margem_lucro_liquido
                ,porc_cancelamento
                ,porc_devolucao
                ,qtde_notas
           from ##vendas_corporativo_detalhada
         order by [data]
   end

if isnull((select top(1) 1 from ##vendas_corporativo),0) > 0 or isnull((select top(1) 1 from ##devolucao_corporativo),0) > 0
   begin

         -- resumo

         select tab.cod_grupo
                ,tab.nome_grupo
                ,tab.total_bruto
                ,tab.total_custo
                ,tab.q_notas_total
                ,tab.cancelamento
                ,tab.custo_cancelamento
                ,tab.q_notas_canceladas
                ,tab.total_devolvido
                ,tab.custo_devolucao
                ,tab.q_devolucoes
                ,tab.total_liquido
                ,tab.custo_liquido
                ,tab.qtde_notas

                ,(1- tab.total_custo / tab.total_bruto) * 100 as 'margem_lucro_bruto'
                ,(1- tab.custo_liquido / tab.total_liquido) * 100 as 'margem_lucro_liquido'
                ,iif(tab.cancelamento > 0, tab.cancelamento / tab.total_bruto * 100, 0) as 'porc_cancelamento'
                ,iif(tab.total_devolvido > 0, tab.total_devolvido / tab.total_bruto * 100, 0) as 'porc_devolucao'
           from (
                  select cod_grupo
                         ,nome_grupo
                         ,sum(total_bruto) as 'total_bruto'
                         ,sum(total_custo) as 'total_custo'
                         ,sum(q_notas_total) as 'q_notas_total'
                         ,sum(cancelamento) as 'cancelamento'
                         ,sum(custo_cancelamento) as 'custo_cancelamento'
                         ,sum(q_notas_canceladas) as 'q_notas_canceladas'
                         ,sum(total_devolvido) as 'total_devolvido'
                         ,sum(custo_devolucao) as 'custo_devolucao'
                         ,sum(q_devolucoes) as 'q_devolucoes'
                         ,sum(total_liquido) as 'total_liquido'
                         ,sum(custo_liquido) as 'custo_liquido'
                         ,sum(qtde_notas) as 'qtde_notas'
                    from ##vendas_corporativo_detalhada
                   group by cod_grupo, nome_grupo
                ) as tab
          order by tab.cod_grupo desc
   end


-- venda cupom fiscal com nf-e, exceto o grupo

if object_id('tempdb..##vendas_cupom_nfe') is not null
   drop table ##vendas_cupom_nfe

declare @datade date, @dataate date

select @datade='20230601', @dataate='20230626'

select tab2.dia
       ,tab2.cod_grupo
       ,isnull(tab2.nome_grupo,'SEM GRUPO') as 'nome_grupo'
       ,tab2.total_bruto
       ,tab2.total_custo
       ,tab2.q_cupons_total
       ,tab2.cancelamento
       ,tab2.custo_cancelamento
       ,tab2.q_cupons_cancelados
       ,tab2.total_liquido
       ,tab2.custo_liquido
       ,tab2.q_cupons_total - tab2.q_cupons_cancelados as 'qtde_cupons'
  into ##vendas_cupom_nfe
  from (
         select tab.dia
                ,tab.codigoGrupoVendedor as 'cod_grupo'
                ,(select GVEDES
                    from TBS091 with (nolock)
                   where GVECOD=tab.codigoGrupoVendedor) as 'nome_grupo'
                ,tab.total_bruto
                ,tab.total_custo
                ,(select count(distinct numeroDocumento)
                   from DWVendas with (nolock)
                  where [data]=tab.dia
                        and caixa=0
                        and numeroSerieDocumento=3
                        and codigoCliente not in (select codigo from ##CodigosClienteGrupo)
                        and cancelado='N'
                        and codigoGrupoVendedor=tab.codigoGrupoVendedor) as 'q_cupons_total'
                ,tab.cancelamento
                ,tab.custo_cancelamento
                ,(select count(distinct numeroDocumento)
                    from DWVendas with (nolock)
                   where [data]=tab.dia
                         and caixa=0
                         and numeroSerieDocumento=3
                         and codigoCliente not in (select codigo from ##CodigosClienteGrupo)
                         and cancelado='S'
                         and codigoGrupoVendedor=tab.codigoGrupoVendedor) as 'q_cupons_cancelados'
                ,tab.total_bruto - tab.cancelamento as 'total_liquido'
                ,tab.total_custo - tab.custo_cancelamento as 'custo_liquido'
           from (
                  select [data] as 'dia'
                         ,codigoGrupoVendedor
                         ,sum(case when  cancelado='N' then valorTotal else 0 end) as 'total_bruto'
                         ,sum(case when  cancelado='N' then custoTotal else 0 end) as 'total_custo'
                         ,sum(case when  cancelado='S' then valorTotal else 0 end) as 'cancelamento'
                         ,sum(case when  cancelado='S' then custoTotal else 0 end) as 'custo_cancelamento'
                    from DWVendas with (nolock)
                   where [data] between @datade and @dataate
                         and caixa=0
                         and numeroSerieDocumento=3
                         and codigoCliente not in (select codigo from ##CodigosClienteGrupo)
                   group by [data], codigoGrupoVendedor
                ) as tab
       ) as tab2
 order by tab2.dia, tab2.cod_grupo

select dia
       ,cod_grupo
       ,nome_grupo
       ,total_bruto
       ,total_custo
       ,q_cupons_total
       ,cancelamento
       ,custo_cancelamento
       ,q_cupons_cancelados
       ,total_liquido
       ,custo_liquido
       ,qtde_cupons
  from ##vendas_cupom_nfe

-- devolução de nf-e de cupom fiscal, exceto entre o grupo

-- agrupada conforme o grupo

if object_id('tempdb..##devolucao_cupom_nfe') is not null
   drop table ##devolucao_cupom_nfe

--declare @datade date, @dataate date

--select @datade='20230501', @dataate='20230511'

select convert(date,tab2.dia) as 'dia'
       ,tab2.cod_grupo
       ,sum(tab2.total_devolvido) as 'total_devolvido'
       ,sum(tab2.custo_devolucao) as 'custo_devolucao'
       ,tab2.q_devolucoes
  into ##devolucao_cupom_nfe
  from (
         select *
                ,(select count(distinct c.NFEID)
                    from TBS059 c with (nolock)
                         inner join TBS0591 i with (nolock)
                            on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
                          Left join TBS0596 r with (nolock)
                            on r.NFEEMPCOD=c.NFEEMPCOD and r.NFETIP=c.NFETIP and r.NFENUM=c.NFENUM and r.NFECOD=c.NFECOD and r.SEREMPCOD=c.SEREMPCOD and r.SERCOD=c.SERCOD
                         inner join TBS0674 d with (nolock)
                            on d.NFSNFRCHA=r.NFENFRCHA                    
                   where c.NFEDATEFE between @datade and @dataate
                         and c.NFETIP='D'
                         and c.NFECAN='N'
                         and r.NFENFRTIP='CFE'
                         and d.NFSNFRTIP='CFE'
                         and c.[NFEDATEFE]=tab.dia
                 ) as 'q_devolucoes'
           from (
                  select c.[NFEDATEFE] as 'dia'
                         ,isnull((select g.GVECOD
                                    from TBS067 n with (nolock)
                                         Left join TBS004 v with (nolock)
                                           on v.VENCOD=n.VENCOD
                                         Left join TBS091 g with (nolock)
                                           on g.GVECOD=v.GVECOD
                                   where n.NFSEMPCOD=d.NFSEMPCOD
                                         and n.SNESER=d.SNESER
                                         and n.NFSNUM=d.NFSNUM),0) as 'cod_grupo'
                         ,sum(i.NFETOTOPEITE) as 'total_devolvido'
                         ,sum(i.NFEQTD * i.NFENFSPRECUS) as 'custo_devolucao'
                    from TBS059 c with (nolock)
                         inner join TBS0591 i with (nolock)
                                 on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
                          Left join TBS0596 r with (nolock)
                                 on r.NFEEMPCOD=c.NFEEMPCOD and r.NFETIP=c.NFETIP and r.NFENUM=c.NFENUM and r.NFECOD=c.NFECOD and r.SEREMPCOD=c.SEREMPCOD and r.SERCOD=c.SERCOD
                         inner join TBS0674 d with (nolock)
                                 on d.NFSNFRCHA=r.NFENFRCHA                            
                   where c.NFEDATEFE between @datade and @dataate
                         and c.NFETIP='D'
                         and c.NFECAN='N'
                         and r.NFENFRTIP='CFE'
                         and d.NFSNFRTIP='CFE'
                         and c.NFECOD not in (select codigo from ##CodigosClienteGrupo)
                   group by c.NFEDATEFE, r.NFENFRCHA,    d.NFSEMPCOD, d.SNESER, d.NFSNUM
                ) as tab
       ) as tab2
 group by convert(date,tab2.dia), tab2.cod_grupo, tab2.q_devolucoes

-- 00:00:11

select dia
       ,cod_grupo
       ,total_devolvido
       ,custo_devolucao
       ,q_devolucoes
  from ##devolucao_cupom_nfe

-- agrupada

--if isnull((select top(1) 1 from ##vendas_cupom_nfe),0) > 0 or isnull((select top(1) 1 from ##devolucao_cupom_nfe),0) > 0
--   begin
      if object_id('tempdb..##vendas_cupom_nfe_detalhada') is not null
         drop table ##vendas_cupom_nfe_detalhada

         select tab.data
                ,tab.cod_grupo
                ,tab.nome_grupo
                ,tab.total_bruto
                ,tab.total_custo
                ,tab.q_cupons_total
                ,tab.cancelamento
                ,tab.custo_cancelamento
                ,tab.q_cupons_cancelados
                ,tab.total_devolvido
                ,tab.custo_devolucao
                ,tab.q_devolucoes
                ,tab.total_liquido
                ,tab.custo_liquido
                ,tab.qtde_cupons - tab.q_devolucoes as 'qtde_cupons'
                
                ,(1- tab.total_custo / tab.total_bruto) * 100 as 'margem_lucro_bruto'
                ,(1- tab.custo_liquido / tab.total_liquido) * 100 as 'margem_lucro_liquido'
                ,iif(tab.cancelamento > 0, tab.cancelamento / tab.total_bruto * 100, 0) as 'porc_cancelamento'
                ,iif(tab.total_devolvido > 0, tab.total_devolvido / tab.total_bruto * 100, 0) as 'porc_devolucao'       
           into ##vendas_cupom_nfe_detalhada
           from (
                  select v.dia as 'data'
                         ,v.cod_grupo
                         ,v.nome_grupo
                         ,v.total_bruto
                         ,v.total_custo
                         ,v.q_cupons_total
                         ,v.cancelamento
                         ,v.custo_cancelamento
                         ,v.q_cupons_cancelados
                         ,isnull(d.total_devolvido,0) as 'total_devolvido'
                         ,isnull(d.custo_devolucao,0) as 'custo_devolucao'
                         ,isnull(d.q_devolucoes,0) as 'q_devolucoes'
                         ,v.total_liquido - isnull(d.total_devolvido,0) as 'total_liquido'
                         ,v.custo_liquido - isnull(d.custo_devolucao,0) as 'custo_liquido'
                         ,v.qtde_cupons
                    from ##vendas_cupom_nfe v
                         Left join ##devolucao_cupom_nfe d
                                on d.dia=v.dia
                                   and d.cod_grupo=v.cod_grupo
                 ) as tab

      select [data]
             ,cod_grupo
             ,nome_grupo
             ,total_bruto
             ,total_custo
             ,q_cupons_total
             ,cancelamento
             ,custo_cancelamento
             ,q_cupons_cancelados
             ,total_devolvido
             ,custo_devolucao
             ,q_devolucoes
             ,total_liquido
             ,custo_liquido
             ,qtde_cupons
             ,margem_lucro_bruto
             ,margem_lucro_liquido
             ,porc_cancelamento
             ,porc_devolucao
        from ##vendas_cupom_nfe_detalhada
       order by [data]
    --end

--if isnull((select top(1) 1 from #vendas_cupom_nfe),0) > 0 or isnull((select top(1) 1 from #devolucao_cupom_nfe),0) > 0
   --begin
      -- resumo

      select tab.cod_grupo
             ,tab.nome_grupo
             ,tab.total_bruto
             ,tab.total_custo
             ,tab.q_cupons_total
             ,tab.cancelamento
             ,tab.custo_cancelamento
             ,tab.q_cupons_cancelados
             ,tab.total_devolvido
             ,tab.custo_devolucao
             ,tab.q_devolucoes
             ,tab.total_liquido
             ,tab.custo_liquido
             ,tab.qtde_cupons
             
             ,(1- tab.total_custo / tab.total_bruto) * 100 as 'margem_lucro_bruto'
             ,(1- tab.custo_liquido / tab.total_liquido) * 100 as 'margem_lucro_liquido'
             ,iif(tab.cancelamento > 0, tab.cancelamento / tab.total_bruto * 100, 0) as 'porc_cancelamento'
             ,iif(tab.total_devolvido > 0, tab.total_devolvido / tab.total_bruto * 100, 0) as 'porc_devolucao'
        from (
               select cod_grupo
                      ,nome_grupo
                      ,sum(total_bruto) as 'total_bruto'
                      ,sum(total_custo) as 'total_custo'
                      ,sum(q_cupons_total) as 'q_cupons_total'
                      ,sum(cancelamento) as 'cancelamento'
                      ,sum(custo_cancelamento) as 'custo_cancelamento'
                      ,sum(q_cupons_cancelados) as 'q_cupons_cancelados'
                      ,sum(total_devolvido) as 'total_devolvido'
                      ,sum(custo_devolucao) as 'custo_devolucao'
                      ,sum(q_devolucoes) as 'q_devolucoes'
                      ,sum(total_liquido) as 'total_liquido'
                      ,sum(custo_liquido) as 'custo_liquido'
                      ,sum(qtde_cupons) as 'qtde_cupons'
                from ##vendas_cupom_nfe_detalhada
               group by cod_grupo, nome_grupo
              ) as tab
       order by tab.cod_grupo desc
   --end


-- vendas somente com cupom fiscal

if object_id('tempdb..##vendas_cupom') is not null
   drop table ##vendas_cupom

declare @datade date, @dataate date

select @datade='20230501', @dataate='20230531'

select tab2.dia
       ,tab2.total_bruto
       ,tab2.total_custo
       ,tab2.q_cupons_total
       ,tab2.cancelamento
       ,tab2.custo_cancelamento
       ,tab2.q_cupons_cancelados
       ,tab2.total_liquido
       ,tab2.custo_liquido
       ,tab2.q_cupons_total - tab2.q_cupons_cancelados as 'qtde_cupons'
  into ##vendas_cupom
  from (
         select tab.dia
                ,tab.total_bruto
                ,tab.total_custo
                ,(select count(distinct numeroDocumento)
                    from DWVendas with (nolock)
                   where [data]=tab.dia
                         and caixa > 0
                         and cancelado='N'
                         and not exists(select 'ne'
                                          from TBS0674 n with (nolock)
                                               inner join TBS080 e with (nolock)
                                                  on e.SNEEMPCOD=n.NFSEMPCOD
                                                     and e.SNESER=n.SNESER
                                                     and e.ENFNUM=n.NFSNUM
                                         where n.NFSNFRTIP='CFE'
                                               and n.NFSNFRCHA=chave
                                               and e.ENFSIT=6)) as 'q_cupons_total'
                ,tab.cancelamento
                ,tab.custo_cancelamento
                ,(select count(distinct numeroDocumento)
                    from DWVendas with (nolock)
                   where [data]=tab.dia
                         and caixa > 0
                         and cancelado='S'
                         and not exists(select 'ne'
                                          from TBS0674 n with (nolock)
                                               inner join TBS080 e with (nolock)
                                                  on e.SNEEMPCOD=n.NFSEMPCOD
                                                     and e.SNESER=n.SNESER
                                                     and e.ENFNUM=n.NFSNUM
                                         where n.NFSNFRTIP='CFE'
                                               and n.NFSNFRCHA=chave
                                               and e.ENFSIT=6)) as 'q_cupons_cancelados' 
                ,tab.total_bruto - tab.cancelamento as 'total_liquido'
                ,tab.total_custo - tab.custo_cancelamento as 'custo_liquido'
           from (
                  select [data] as 'dia'
                         ,sum(case when  cancelado='N' then valorTotal else 0 end) as 'total_bruto'
                         ,sum(case when  cancelado='N' then custoTotal else 0 end) as 'total_custo'
                         ,sum(case when  cancelado='S' then valorTotal else 0 end) as 'cancelamento'
                         ,sum(case when  cancelado='S' then custoTotal else 0 end) as 'custo_cancelamento'
                    from DWVendas with (nolock)
                   where [data] between @datade and @dataate
                         and caixa > 0
                         and not exists(select 'ne'
                                          from TBS0674 n with (nolock)
                                               inner join TBS080 e with (nolock)
                                                  on e.SNEEMPCOD=n.NFSEMPCOD
                                                     and e.SNESER=n.SNESER
                                                     and e.ENFNUM=n.NFSNUM
                                         where n.NFSNFRTIP='CFE'
                                               and n.NFSNFRCHA=chave
                                               and e.ENFSIT=6)
                   group by [data]
                ) as tab
       ) as tab2
 order by tab2.dia

select dia
       ,total_bruto
       ,total_custo
       ,q_cupons_total
       ,cancelamento
       ,custo_cancelamento
       ,q_cupons_cancelados
       ,total_liquido
       ,custo_liquido
       ,qtde_cupons
  from ##vendas_cupom

-- devolução de vendas com somente cupom fiscal

if object_id('tempdb..##devolucao_cupom_fiscal') is not null
   drop table ##devolucao_cupom_fiscal

declare @datade date, @dataate date

select @datade='20230501', @dataate='20230531'

select convert(date,tab2.dia) as 'dia'
       ,sum(tab2.total_devolvido) as 'total_devolvido'
       ,sum(tab2.custo_devolucao) as 'custo_devolucao'
       ,tab2.q_devolucoes
  into ##devolucao_cupom_fiscal
  from (
         select *
                ,(select count(distinct c.NFEID)
                    from TBS059 c with (nolock)
                         inner join TBS0591 i with (nolock)
                                 on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
                          Left join TBS0596 r with (nolock)
                                    on r.NFEEMPCOD=c.NFEEMPCOD and r.NFETIP=c.NFETIP and r.NFENUM=c.NFENUM and r.NFECOD=c.NFECOD and r.SEREMPCOD=c.SEREMPCOD and r.SERCOD=c.SERCOD  
                   where c.NFEDATEFE=tab.dia
                         and c.NFETIP='D'
                         and c.NFECAN='N'
                         --and c.NFETIPENT='CUP'
                         and r.NFENFRTIP in('CUP','CFE')
                         and not exists(select 'ne'
                                          from TBS0674 n with (nolock)
                                               inner join TBS080 e with (nolock)
                                                  on e.SNEEMPCOD=n.NFSEMPCOD
                                                     and e.SNESER=n.SNESER
                                                     and e.ENFNUM=n.NFSNUM
                                         where n.NFSNFRTIP in('CUP','CFE') --='CFE'
                                               and n.NFSNFRCHA=r.NFENFRCHA
                                               and e.ENFSIT=6
                                       )
                 ) as 'q_devolucoes'
           from (
                  select c.[NFEDATEFE] as 'dia'
                         ,sum(i.NFETOTOPEITE) as 'total_devolvido'
                         ,sum(i.NFEQTD * i.NFENFSPRECUS) as 'custo_devolucao'
                    from TBS059 c with (nolock)
                         inner join TBS0591 i with (nolock)
                            on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
                          Left join TBS0596 r with (nolock)
                            on r.NFEEMPCOD=c.NFEEMPCOD and r.NFETIP=c.NFETIP and r.NFENUM=c.NFENUM and r.NFECOD=c.NFECOD and r.SEREMPCOD=c.SEREMPCOD and r.SERCOD=c.SERCOD  
                   where c.NFEDATEFE between @datade and @dataate
                         and c.NFETIP='D'
                         and c.NFECAN='N'
                         --and c.NFETIPENT='CUP'
                         and r.NFENFRTIP in('CUP','CFE')
                         and not exists(select 'ne'
                                          from TBS0674 n with (nolock)
                                               inner join TBS080 e with (nolock)
                                                       on e.SNEEMPCOD=n.NFSEMPCOD
                                                          and e.SNESER=n.SNESER
                                                          and e.ENFNUM=n.NFSNUM
                                         where n.NFSNFRTIP in('CUP','CFE') --='CFE'
                                               and n.NFSNFRCHA=r.NFENFRCHA
                                               and e.ENFSIT=6
                                       )
                   group by c.NFEDATEFE, r.NFENFRCHA
                ) as tab
       ) as tab2
 group by convert(date,tab2.dia), tab2.q_devolucoes

select dia
       ,total_devolvido
       ,custo_devolucao
       ,q_devolucoes
  from ##devolucao_cupom_fiscal

-- agrupada

if isnull((select top(1) 1 from ##vendas_cupom),0) > 0 or isnull((select top(1) 1 from ##devolucao_cupom_fiscal),0) > 0
   begin
      if object_id('tempdb..##vendas_cupom_detalhada') is not null
    	  drop table ##vendas_cupom_detalhada

         select *
                ,(1- tab.total_custo / tab.total_bruto) * 100 as 'margem_lucro_bruto'
                ,(1- tab.custo_liquido / tab.total_liquido) * 100 as 'margem_lucro_liquido'
                ,iif(tab.cancelamento > 0, tab.cancelamento / tab.total_bruto * 100, 0) as 'porc_cancelamento'
                ,iif(tab.total_devolvido > 0, tab.total_devolvido / tab.total_bruto * 100, 0) as 'porc_devolucao'
           into ##vendas_cupom_detalhada
           from (
                  select v.dia as 'data'
                         ,v.total_bruto
                         ,v.total_custo
                         ,v.q_cupons_total
                         ,v.cancelamento
                         ,v.custo_cancelamento
                         ,v.q_cupons_cancelados
                         ,isnull(d.total_devolvido,0) as 'total_devolvido'
                         ,isnull(d.custo_devolucao,0) as 'custo_devolucao'
                         ,isnull(d.q_devolucoes,0) as 'q_devolucoes'
                         ,v.total_liquido - isnull(d.total_devolvido,0) as 'total_liquido'
                         ,v.custo_liquido - isnull(d.custo_devolucao,0) as 'custo_liquido'
                         ,v.qtde_cupons
                    from ##vendas_cupom v
                         Left join ##devolucao_cupom_fiscal d
                                on d.dia=v.dia
                ) as tab

      select [data]
             ,total_bruto
             ,total_custo
             ,q_cupons_total
             ,cancelamento
             ,custo_cancelamento
             ,q_cupons_cancelados
             ,total_devolvido
             ,custo_devolucao
             ,q_devolucoes
             ,total_liquido
             ,custo_liquido
             ,qtde_cupons
                
             ,margem_lucro_bruto
             ,margem_lucro_liquido
             ,porc_cancelamento
             ,porc_devolucao
        from ##vendas_cupom_detalhada
       order by [data]       
    
    end

if isnull((select top(1) 1 from ##vendas_cupom),0) > 0 or isnull((select top(1) 1 from ##devolucao_cupom_fiscal),0) > 0
   begin
      -- resumo

      select tab.total_bruto
             ,tab.total_custo
             ,tab.q_notas_total
             ,tab.cancelamento
             ,tab.custo_cancelamento
             ,tab.q_notas_canceladas
             ,tab.total_devolvido
             ,tab.custo_devolucao
             ,tab.q_devolucoes
             ,tab.total_liquido
             ,tab.custo_liquido
             ,tab.qtde_cupons
             
             ,(1- tab.total_custo / tab.total_bruto) * 100 as 'margem_lucro_bruto'
             ,(1- tab.custo_liquido / tab.total_liquido) * 100 as 'margem_lucro_liquido'
             ,iif(tab.cancelamento > 0, tab.cancelamento / tab.total_bruto * 100, 0) as 'porc_cancelamento'
             ,iif(tab.total_devolvido > 0, tab.total_devolvido / tab.total_bruto * 100, 0) as 'porc_devolucao'
        from (
               select sum(total_bruto) as 'total_bruto'
                      ,sum(total_custo) as 'total_custo'
                      ,sum(q_cupons_total) as 'q_notas_total'
                      ,sum(cancelamento) as 'cancelamento'
                      ,sum(custo_cancelamento) as 'custo_cancelamento'
                      ,sum(q_cupons_cancelados) as 'q_notas_canceladas'
                      ,sum(total_devolvido) as 'total_devolvido'
                      ,sum(custo_devolucao) as 'custo_devolucao'
                      ,sum(q_devolucoes) as 'q_devolucoes'
                      ,sum(total_liquido) as 'total_liquido'
                      ,sum(custo_liquido) as 'custo_liquido'
                      ,sum(qtde_cupons) as 'qtde_cupons'
                 from ##vendas_cupom_detalhada
             ) as tab
   end


-- vendas para outras unidades do grupo

if object_id('tempdb..##transf_grupo') is not null
   drop table ##transf_grupo

declare @datade date, @dataate date

select @datade='20230401', @dataate='20230430'

select tab2.dia
       ,tab2.nome
       ,tab2.total_bruto
       ,tab2.total_custo
       ,tab2.q_notas_total
       ,tab2.cancelamento
       ,tab2.custo_cancelamento
       ,tab2.q_notas_canceladas
       ,tab2.total_liquido
       ,tab2.custo_liquido
       ,tab2.q_notas_total - tab2.q_notas_canceladas as 'qtde_notas'
  into ##transf_grupo
  from (
         select tab.dia
                ,tab.nome
                ,tab.total_bruto
                ,tab.total_custo
                ,(select count(distinct numeroDocumento)
                    from DWVendas with (nolock)
                   where [data]=tab.dia
                         and caixa=0
                         and codigoCliente=tab.codigo_destinatario
                         and cancelado='N') as 'q_notas_total'
                ,tab.cancelamento
                ,tab.custo_cancelamento
                ,(select count(distinct numeroDocumento)
                    from DWVendas with (nolock)
                   where [data]= tab.dia
                         and caixa=0
                         and codigoCliente=tab.codigo_destinatario
                         and cancelado='S') as 'q_notas_canceladas'
                ,tab.total_bruto - tab.cancelamento as 'total_liquido'
                ,tab.total_custo - tab.custo_cancelamento as 'custo_liquido'
           from (
                  select [data] as 'dia'
                         ,codigoCliente as 'codigo_destinatario'
                         ,(select nomeFantasia from ##CodigosClienteGrupo where codigo=codigoCliente) as 'nome'
                         ,sum(case when cancelado='N' then valorTotal else 0 end) as 'total_bruto'
                         ,sum(case when cancelado='N' then custoTotal else 0 end) as 'total_custo'
                         ,sum(case when cancelado='S' then valorTotal else 0 end) as 'cancelamento'
                         ,sum(case when cancelado='S' then custoTotal else 0 end) as 'custo_cancelamento'
                    from DWVendas with (nolock)
                   where [data] between @datade and @dataate
                         and caixa=0
                         and codigoCliente in (select codigo from ##CodigosClienteGrupo)
                   group by [data], codigoCliente
                ) as tab
       ) as tab2
 order by tab2.dia

-- transferencias para outras unidades do grupo

declare @datade date, @dataate date

select @datade='20230401', @dataate='20230430'

insert into ##transf_grupo
select tab2.dia
       ,tab2.nome
       ,tab2.total_bruto
       ,tab2.total_custo
       ,tab2.q_notas_total
       ,tab2.cancelamento
       ,tab2.custo_cancelamento
       ,tab2.q_notas_canceladas
       ,tab2.total_liquido
       ,tab2.custo_liquido
       ,tab2.q_notas_total - tab2.q_notas_canceladas as 'qtde_notas'
  from (
         select tab.dia
                ,tab.nome
                ,tab.total_bruto
                ,tab.total_custo
                ,(select count(distinct ENFNUM)
                    from TBS080 with (nolock)
                   where ENFEMPCOD=ENFEMPCOD
                         and ENFTIPDOC=1
                         and ENFFINEMI=1
                         and ENFSIT in(6,7)
                         and SNESER=2
                         and ENFDATEMI=tab.dia
                         and ENFCODDES=tab.codigo_destinatario) as 'q_notas_total'
                ,tab.cancelamento
                ,tab.custo_cancelamento
                ,(select count(distinct ENFNUM)
                    from TBS080 with (nolock)
                   where ENFEMPCOD=ENFEMPCOD
                         and ENFTIPDOC=1
                         and ENFFINEMI=1
                         and ENFSIT=7
                         and SNESER=2
                         and ENFDATEMI=tab.dia
                         and ENFCODDES=tab.codigo_destinatario) as 'q_notas_canceladas'
                ,tab.total_bruto - tab.cancelamento as 'total_liquido'
                ,tab.total_custo - tab.custo_cancelamento as 'custo_liquido'
           from (
                  select convert(date, e.ENFDATEMI,112) as 'dia'
                         ,e.ENFCODDES as 'codigo_destinatario'
                         ,(select nomeFantasia from ##CodigosClienteGrupo where codigo=e.ENFCODDES) as 'nome'
                         ,sum(case when e.ENFSIT=6 then dbo.NFSTOTITEST(e.ENFEMPCOD, e.ENFNUM, e.SNEEMPCOD, e.SNESER, d.NFSITE) else 0 end) as 'total_bruto'
                         ,sum(case when e.ENFSIT=6 then round(d.NFSQTD * d.NFSPRECUS ,2) else 0 end) as 'total_custo'
                         ,sum(case when e.ENFSIT=7 then dbo.NFSTOTITEST(e.ENFEMPCOD, e.ENFNUM, e.SNEEMPCOD, e.SNESER, d.NFSITE) else 0 end) as 'cancelamento'
                         ,sum(case when e.ENFSIT=7 then round(d.NFSQTD * d.NFSPRECUS ,2) else 0 end) as 'custo_cancelamento'
                    from TBS080 e with (nolock)
                   inner join TBS067 n with (nolock)
                      on n.NFSEMPCOD=0
                         and n.SNEEMPCOD=0
                         and n.SNESER=e.SNESER 
                         and n.NFSNUM=e.ENFNUM
                   inner join TBS0671 d with (nolock)
                      on d.NFSEMPCOD=n.NFSEMPCOD
                         and d.SNEEMPCOD=n.SNEEMPCOD
                         and d.SNESER=n.SNESER
                         and d.NFSNUM=n.NFSNUM
                   where e.ENFEMPCOD=0
                         and e.ENFTIPDOC=1
                         and e.ENFFINEMI=1
                         and e.ENFSIT in(6,7)
                         and e.SNESER=2
                         and e.ENFDATEMI between @datade and @dataate
                         and e.ENFCODDES in (select codigo from ##CodigosClienteGrupo)
                   group by convert(date, e.ENFDATEMI, 112), e.ENFCODDES
                ) as tab
       ) as tab2
 order by tab2.dia

select *
  from ##transf_grupo
 order by dia 


-- devolução de nf-e entre o grupo

if object_id('tempdb..##devolucao_grupo') is not null
   drop table ##devolucao_grupo

-- agrupada conforme o grupo

declare @datade date, @dataate date

select @datade='20230401', @dataate='20230430'

select convert(date,tab2.dia) as 'dia'
       ,tab2.nome
       ,sum(tab2.total_devolvido) as 'total_devolvido'
       ,sum(tab2.custo_devolucao) as 'custo_devolucao'
       ,tab2.q_devolucoes
  into ##devolucao_grupo
  from (
         select *
                ,(
                   select count(distinct c.NFEID)
                     from TBS059 c with (nolock)
                          inner join TBS0591 i with (nolock)
                             on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
                           Left join TBS0596 r with (nolock)
                             on r.NFEEMPCOD=c.NFEEMPCOD and r.NFETIP=c.NFETIP and r.NFENUM=c.NFENUM and r.NFECOD=c.NFECOD and r.SEREMPCOD=c.SEREMPCOD and r.SERCOD=c.SERCOD  
                    where c.NFECOD=tab.codigo_destinatario
                          and c.NFETIP='D'
                          and c.NFECAN='N'
                          and c.[NFEDATEFE]=tab.dia) as 'q_devolucoes'
           from (
                   select convert(date,c.[NFEDATEFE],112) as 'dia'
                          ,c.NFECOD as 'codigo_destinatario'
                          ,(select nomeFantasia from ##CodigosClienteGrupo where codigo=c.NFECOD) as 'nome'
                          ,sum(i.NFETOTOPEITE) as 'total_devolvido'
                          ,sum(i.NFEQTD * i.NFENFSPRECUS) as 'custo_devolucao'
                     from TBS059 c with (nolock)
                          inner join TBS0591 i with (nolock)
                             on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
                           Left join TBS0596 r with (nolock)
                             on r.NFEEMPCOD=c.NFEEMPCOD and r.NFETIP=c.NFETIP and r.NFENUM=c.NFENUM and r.NFECOD=c.NFECOD and r.SEREMPCOD=c.SEREMPCOD and r.SERCOD=c.SERCOD  
                    where c.NFEDATEFE between @datade and @dataate
                          and c.NFETIP='D'
                          and c.NFECAN='N'
                          and c.NFECOD in (select codigo from ##CodigosClienteGrupo)
                    group by convert(date,c.[NFEDATEFE],112), c.NFECOD
                ) as tab
       ) as tab2
 group by convert(date,tab2.dia), tab2.nome, tab2.q_devolucoes

select *
  from ##devolucao_grupo

if isnull((select top(1) 1 from #transf_grupo),0) > 0 or isnull((select top(1) 1 from #devolucao_grupo),0) > 0
   begin

      if object_id('tempdb..##transf_grupo_detalhada') is not null
    	  drop table ##transf_grupo_detalhada

      select tab.[data]
             ,tab.nome
             ,tab.total_bruto
             ,tab.total_custo
             ,tab.q_notas_total
             ,tab.cancelamento
             ,tab.custo_cancelamento
             ,tab.q_notas_canceladas
             ,tab.total_devolvido
             ,tab.custo_devolucao
             ,tab.q_devolucoes
             ,tab.total_liquido
             ,tab.custo_liquido
             ,tab.qtde_notas - tab.q_devolucoes as 'qtde_notas'

             ,(1- tab.total_custo / tab.total_bruto) * 100 as 'margem_lucro_bruto'
             ,(1- tab.custo_liquido / tab.total_liquido) * 100 as 'margem_lucro_liquido'
             ,iif(tab.cancelamento > 0, tab.cancelamento / tab.total_bruto * 100, 0) as 'porc_cancelamento'
             ,iif(tab.total_devolvido > 0, tab.total_devolvido / tab.total_bruto * 100, 0) as 'porc_devolucao'
        into ##transf_grupo_detalhada
        from (
               select t.dia as 'data'
                      ,t.nome
                      ,t.total_bruto
                      ,t.total_custo
                      ,t.q_notas_total
                      ,t.cancelamento
                      ,t.custo_cancelamento
                      ,t.q_notas_canceladas
                      ,isnull(d.total_devolvido,0) as 'total_devolvido'
                      ,isnull(d.custo_devolucao,0) as 'custo_devolucao'
                      ,isnull(d.q_devolucoes,0) as 'q_devolucoes'
                      ,t.total_liquido - isnull(d.total_devolvido,0) as 'total_liquido'
                      ,t.custo_liquido - isnull(d.custo_devolucao,0) as 'custo_liquido'
                      ,t.qtde_notas
                 from ##transf_grupo t
                      Left join ##devolucao_grupo d
                        on d.dia=t.dia
                           and d.nome=t.nome
             ) as tab

      select [data]
             ,nome
             ,total_bruto
             ,total_custo
             ,q_notas_total
             ,cancelamento
             ,custo_cancelamento
             ,q_notas_canceladas
             ,total_devolvido
             ,custo_devolucao
             ,q_devolucoes
             ,total_liquido
             ,custo_liquido
             ,qtde_notas
             ,margem_lucro_bruto
             ,margem_lucro_liquido
             ,porc_cancelamento
             ,porc_devolucao
        from ##transf_grupo_detalhada
       order by [data]

         -- resumo

      select *
             ,(1- tab.total_custo / tab.total_bruto) * 100 as 'margem_lucro_bruto'
             ,(1- tab.custo_liquido / tab.total_liquido) * 100 as 'margem_lucro_liquido'
             ,iif(tab.cancelamento > 0, tab.cancelamento / tab.total_bruto * 100, 0) as 'porc_cancelamento'
             ,iif(tab.total_devolvido > 0, tab.total_devolvido / tab.total_bruto * 100, 0) as 'porc_devolucao'
        from (
               select nome
                      ,sum(total_bruto) as 'total_bruto'
                      ,sum(total_custo) as 'total_custo'
                      ,sum(q_notas_total) as 'q_notas_total'
                      ,sum(cancelamento) as 'cancelamento'
                      ,sum(custo_cancelamento) as 'custo_cancelamento'
                      ,sum(q_notas_canceladas) as 'q_notas_canceladas'
                      ,sum(total_devolvido) as 'total_devolvido'
                      ,sum(custo_devolucao) as 'custo_devolucao'
                      ,sum(q_devolucoes) as 'q_devolucoes'
                      ,sum(total_liquido) as 'total_liquido'
                      ,sum(custo_liquido) as 'custo_liquido'
                 from ##transf_grupo_detalhada
                group by nome
             ) as tab
       order by tab.nome
   end






-- juntar com relatório de faturamento de NFS (Rui)

-- códigos dos clientes do grupo

if object_id('tempdb..##CodigosClienteGrupo') is not null
   drop table ##CodigosClienteGrupo

create table ##CodigosClienteGrupo (codigo int)

insert into ##CodigosClienteGrupo
exec sp_ClientesGrupo

alter table ##CodigosClienteGrupo add nomeFantasia varchar(25)

update ##CodigosClienteGrupo
   set nomeFantasia=(select CLINOMFAN from TBS002 with (nolock) where CLICOD=codigo)


-- vendas corporativo, exceto do grupo
-- nf-e
-- série 1

if object_id('tempdb..##vendas_corporativo') is not null
   drop table ##vendas_corporativo

declare @datade date, @dataate date

select @datade='20230501', @dataate='20230531'

select tab2.total_bruto
       ,tab2.total_custo
       ,tab2.q_notas_total
       ,tab2.cancelamento
       ,tab2.custo_cancelamento
       ,tab2.q_notas_canceladas
       ,tab2.total_liquido
       ,tab2.custo_liquido
       ,tab2.q_notas_total - tab2.q_notas_canceladas as 'qtde_notas'
  into ##vendas_corporativo
  from (
         select tab.total_bruto
                ,tab.total_custo
                ,(select count(distinct numeroDocumento)
                    from DWVendas with (nolock)
                   where [data] between @datade and @dataate
                         and caixa=0
                         and numeroSerieDocumento=1
                         and codigoCliente not in (select codigo from ##CodigosClienteGrupo)
                         and cancelado='N') as 'q_notas_total'
                ,tab.cancelamento
                ,tab.custo_cancelamento
                ,(select count(distinct numeroDocumento)
                    from DWVendas with (nolock)
                   where [data] between @datade and @dataate
                         and caixa=0
                         and numeroSerieDocumento=1
                         and codigoCliente not in (select codigo from ##CodigosClienteGrupo)
                         and cancelado='S') as 'q_notas_canceladas'
                ,tab.total_bruto - tab.cancelamento as 'total_liquido'
                ,tab.total_custo - tab.custo_cancelamento as 'custo_liquido'
           from (
                  select sum(case when  cancelado='N' then valorTotal else 0 end) as 'total_bruto'
                         ,sum(case when  cancelado='N' then custoTotal else 0 end) as 'total_custo'
                         ,sum(case when  cancelado='S' then valorTotal else 0 end) as 'cancelamento'
                         ,sum(case when  cancelado='S' then custoTotal else 0 end) as 'custo_cancelamento'
                    from DWVendas with (nolock)
                   where [data] between @datade and @dataate
                         and caixa=0
                         and numeroSerieDocumento=1
                         and codigoCliente not in (select codigo from ##CodigosClienteGrupo)) as tab
       ) as tab2
 
select total_bruto
       ,total_custo
       ,q_notas_total
       ,cancelamento
       ,custo_cancelamento
       ,q_notas_canceladas
       ,total_liquido
       ,custo_liquido
       ,qtde_notas
  from ##vendas_corporativo


-- devolução de nf-e, exceto entre o grupo

if object_id('tempdb..##devolucao_corporativo') is not null
   drop table ##devolucao_corporativo

-- agrupada conforme o grupo

declare @datade date, @dataate date

select @datade='20230501', @dataate='20230531'

select sum(tab2.total_devolvido) as 'total_devolvido'
       ,sum(tab2.custo_devolucao) as 'custo_devolucao'
       ,tab2.q_devolucoes
  into ##devolucao_corporativo
  from (
         select *
                ,( select count(distinct c.NFEID)
                     from TBS059 c with (nolock)
                          inner join TBS0591 i with (nolock)
                                on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
                           Left join TBS0596 r with (nolock)
                                on r.NFEEMPCOD=c.NFEEMPCOD and r.NFETIP=c.NFETIP and r.NFENUM=c.NFENUM and r.NFECOD=c.NFECOD and r.SEREMPCOD=c.SEREMPCOD and r.SERCOD=c.SERCOD  
                    where c.NFEDATEFE between @datade and @dataate
                          and c.NFETIP='D'
                          and c.NFETIPENT <> 'CUP'
                          and c.NFECAN='N'
                          --and r.NFENFRTIP in('CUP','CFE')
                          --and c.[NFEDATEFE] between @datade and @dataate
                          and c.NFECOD not in (select codigo from ##CodigosClienteGrupo)
                 ) as 'q_devolucoes'
           from (
                  select sum(i.NFETOTOPEITE) as 'total_devolvido'
                         ,sum(i.NFEQTD * i.NFENFSPRECUS) as 'custo_devolucao'
                    from TBS059 c with (nolock)
                         inner join TBS0591 i with (nolock)
                            on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
                          Left join TBS0596 r with (nolock)
                            on r.NFEEMPCOD=c.NFEEMPCOD and r.NFETIP=c.NFETIP and r.NFENUM=c.NFENUM and r.NFECOD=c.NFECOD and r.SEREMPCOD=c.SEREMPCOD and r.SERCOD=c.SERCOD  
                   where c.NFEDATEFE between @datade and @dataate
                         and c.NFETIP='D'
                         and c.NFETIPENT <> 'CUP'
                         and c.NFECAN='N'
                         --and r.NFENFRTIP in('CUP','CFE')
                         and c.NFECOD not in (select codigo from ##CodigosClienteGrupo)
                   group by c.NFEDATEFE, r.NFENFRCHA
                ) as tab
       ) as tab2
 group by tab2.q_devolucoes

select total_devolvido
       ,custo_devolucao
       ,q_devolucoes
  from ##devolucao_corporativo


if object_id('tempdb..##vendas_corporativo_detalhada') is not null
   drop table ##vendas_corporativo_detalhada

select tab.total_bruto
       ,tab.total_custo
       ,tab.q_notas_total
       ,tab.cancelamento
       ,tab.custo_cancelamento
       ,tab.q_notas_canceladas
       ,tab.total_devolvido
       ,tab.custo_devolucao
       ,tab.q_devolucoes
       ,tab.total_liquido
       ,tab.custo_liquido
       ,tab.qtde_notas - tab.q_devolucoes as 'qtde_notas'
       
       ,(1- tab.total_custo / tab.total_bruto) * 100 as 'margem_lucro_bruto'
       ,(1- tab.custo_liquido / tab.total_liquido) * 100 as 'margem_lucro_liquido'
       ,iif(tab.cancelamento > 0, tab.cancelamento / tab.total_bruto * 100, 0) as 'porc_cancelamento'
       ,iif(tab.total_devolvido > 0, tab.total_devolvido / tab.total_bruto * 100, 0) as 'porc_devolucao'
  into ##vendas_corporativo_detalhada       
  from (
         select v.total_bruto
                ,v.total_custo
                ,v.q_notas_total
                ,v.cancelamento
                ,v.custo_cancelamento
                ,v.q_notas_canceladas
                ,isnull(d.total_devolvido,0) as 'total_devolvido'
                ,isnull(d.custo_devolucao,0) as 'custo_devolucao'
                ,isnull(d.q_devolucoes,0) as 'q_devolucoes'
                ,v.total_liquido - isnull(d.total_devolvido,0) as 'total_liquido'
                ,v.custo_liquido - isnull(d.custo_devolucao,0) as 'custo_liquido'
                ,v.qtde_notas
           from ##vendas_corporativo v, ##devolucao_corporativo d
       ) as tab

select total_bruto
       ,total_custo
       ,q_notas_total
       ,cancelamento
       ,custo_cancelamento
       ,q_notas_canceladas
       ,total_devolvido
       ,custo_devolucao
       ,q_devolucoes
       ,total_liquido
       ,custo_liquido
       ,margem_lucro_bruto
       ,margem_lucro_liquido
       ,porc_cancelamento
       ,porc_devolucao
       ,qtde_notas
  from ##vendas_corporativo_detalhada


select NFEDATEFE
       ,sum(dbo.NFETOTOPE(NFEEMPCOD, NFETIP, NFENUM, NFECOD, SEREMPCOD, SERCOD))
  from TBS059 with (nolock)
 where NFETIP='D'
       and NFEDATEFE between '20230501' and '20230531'
	   and NFETIPENT <> 'CUP'
          and NFECAN='N'
	   and NFENOM not Like('%BEST BAG%')
	   and NFENOM not Like('%MISASPEL%')
	   and NFENOM not Like('%PAPELYNA%')
	   and NFENOM not Like('%TANBY%')
	   and NFENOM not Like('%WINPACK%')       
 group by NFEDATEFE


-- vendas com cupom fiscal

if object_id('tempdb..##vendas_cupom') is not null
   drop table ##vendas_cupom

declare @datade date, @dataate date

select @datade='20230501', @dataate='20230531'

select tab2.total_bruto,
       tab2.total_custo
       ,tab2.q_cupons_total
       ,tab2.cancelamento
       ,tab2.custo_cancelamento
       ,tab2.q_cupons_cancelados
       ,tab2.total_liquido
       ,tab2.custo_liquido
       ,tab2.q_cupons_total - tab2.q_cupons_cancelados as 'qtde_cupons'
  into ##vendas_cupom
  from (
         select tab.total_bruto
                ,tab.total_custo
                ,(select count(distinct numeroDocumento)
                    from DWVendas with (nolock)
                   where [data] between @datade and @dataate
                         and caixa > 0
                         and cancelado='N'
                         /*and not exists(select 'ne'
                                          from TBS0674 n with (nolock)
                                               inner join TBS080 e with (nolock)
                                                  on e.SNEEMPCOD=n.NFSEMPCOD
                                                     and e.SNESER=n.SNESER
                                                     and e.ENFNUM=n.NFSNUM
                                         where n.NFSNFRTIP='CFE'
                                               and n.NFSNFRCHA=chave
                                               and e.ENFSIT=6)*/
                 ) as 'q_cupons_total'
                ,tab.cancelamento
                ,tab.custo_cancelamento
                ,(select count(distinct numeroDocumento)
                    from DWVendas with (nolock)
                   where [data] between @datade and @dataate
                         and caixa > 0
                         and cancelado='S'
                         /*and not exists(select 'ne'
                                          from TBS0674 n with (nolock)
                                               inner join TBS080 e with (nolock)
                                                  on e.SNEEMPCOD=n.NFSEMPCOD
                                                     and e.SNESER=n.SNESER
                                                     and e.ENFNUM=n.NFSNUM
                                         where n.NFSNFRTIP='CFE'
                                               and n.NFSNFRCHA=chave
                                               and e.ENFSIT=6)*/
                 ) as 'q_cupons_cancelados'
                ,tab.total_bruto - tab.cancelamento as 'total_liquido'
                ,tab.total_custo - tab.custo_cancelamento as 'custo_liquido'
           from (
                  select sum(case when  cancelado='N' then valorTotal else 0 end) as 'total_bruto'
                         ,sum(case when  cancelado='N' then custoTotal else 0 end) as 'total_custo'
                         ,sum(case when  cancelado='S' then valorTotal else 0 end) as 'cancelamento'
                         ,sum(case when  cancelado='S' then custoTotal else 0 end) as 'custo_cancelamento'
                    from DWVendas with (nolock)
                   where [data] between @datade and @dataate
                         and caixa > 0
                         /*and not exists(select 'ne'
                                          from TBS0674 n with (nolock)
                                               inner join TBS080 e with (nolock)
                                                  on e.SNEEMPCOD=n.NFSEMPCOD
                                                     and e.SNESER=n.SNESER
                                                     and e.ENFNUM=n.NFSNUM
                                         where n.NFSNFRTIP='CFE'
                                               and n.NFSNFRCHA=chave
                                               and e.ENFSIT=6)*/
                ) as tab
       ) as tab2
 
select total_bruto
       ,total_custo
       ,q_cupons_total
       ,cancelamento
       ,custo_cancelamento
       ,q_cupons_cancelados
       ,total_liquido
       ,custo_liquido
       ,qtde_cupons
  from ##vendas_cupom

-- devolução de vendas com cupom fiscal

if object_id('tempdb..##devolucao_cupom_fiscal') is not null
   drop table ##devolucao_cupom_fiscal

declare @datade date, @dataate date

select @datade='20230501', @dataate='20230531'

select sum(tab2.total_devolvido) as 'total_devolvido'
       ,sum(tab2.custo_devolucao) as 'custo_devolucao'
       ,tab2.q_devolucoes
  into ##devolucao_cupom_fiscal
  from (
         select *
                ,(select count(distinct c.NFEID)
                    from TBS059 c with (nolock)
                         inner join TBS0591 i with (nolock)
                                 on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
                          Left join TBS0596 r with (nolock)
                                    on r.NFEEMPCOD=c.NFEEMPCOD and r.NFETIP=c.NFETIP and r.NFENUM=c.NFENUM and r.NFECOD=c.NFECOD and r.SEREMPCOD=c.SEREMPCOD and r.SERCOD=c.SERCOD  
                   where c.NFEDATEFE between @datade and @dataate
                         and c.NFETIP='D'
                         and c.NFETIPENT='CUP'
                         and c.NFECAN='N'
                         and r.NFENFRTIP in('CUP','CFE')
                         /*and not exists(select 'ne'
                                          from TBS0674 n with (nolock)
                                               inner join TBS080 e with (nolock)
                                                  on e.SNEEMPCOD=n.NFSEMPCOD
                                                     and e.SNESER=n.SNESER
                                                     and e.ENFNUM=n.NFSNUM
                                         where n.NFSNFRTIP='CFE'
                                               and n.NFSNFRCHA=r.NFENFRCHA
                                               and e.ENFSIT=6
                                       )*/
                 ) as 'q_devolucoes'
           from (
                  select sum(i.NFETOTOPEITE) as 'total_devolvido'
                         ,sum(i.NFEQTD * i.NFENFSPRECUS) as 'custo_devolucao'
                    from TBS059 c with (nolock)
                         inner join TBS0591 i with (nolock)
                            on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
                          Left join TBS0596 r with (nolock)
                            on r.NFEEMPCOD=c.NFEEMPCOD and r.NFETIP=c.NFETIP and r.NFENUM=c.NFENUM and r.NFECOD=c.NFECOD and r.SEREMPCOD=c.SEREMPCOD and r.SERCOD=c.SERCOD  
                   where c.NFEDATEFE between @datade and @dataate
                         and c.NFETIP='D'
                         and c.NFETIPENT='CUP'
                         and c.NFECAN='N'
                         and r.NFENFRTIP in('CUP','CFE')
                         /*and not exists(select 'ne'
                                          from TBS0674 n with (nolock)
                                               inner join TBS080 e with (nolock)
                                                       on e.SNEEMPCOD=n.NFSEMPCOD
                                                          and e.SNESER=n.SNESER
                                                          and e.ENFNUM=n.NFSNUM
                                         where n.NFSNFRTIP='CFE'
                                               and n.NFSNFRCHA=r.NFENFRCHA
                                               and e.ENFSIT=6
                                       )*/
                   group by c.NFEDATEFE, r.NFENFRCHA
                ) as tab
       ) as tab2
 group by tab2.q_devolucoes

select total_devolvido
       ,custo_devolucao
       ,q_devolucoes
  from ##devolucao_cupom_fiscal

-- agrupada

if object_id('tempdb..##vendas_cupom_detalhada') is not null
   drop table ##vendas_cupom_detalhada

select *
       ,(1- tab.total_custo / tab.total_bruto) * 100 as 'margem_lucro_bruto'
       ,(1- tab.custo_liquido / tab.total_liquido) * 100 as 'margem_lucro_liquido'
       ,iif(tab.cancelamento > 0, tab.cancelamento / tab.total_bruto * 100, 0) as 'porc_cancelamento'
       ,iif(tab.total_devolvido > 0, tab.total_devolvido / tab.total_bruto * 100, 0) as 'porc_devolucao'
  into ##vendas_cupom_detalhada
  from (
         select v.total_bruto
                ,v.total_custo
                ,v.q_cupons_total
                ,v.cancelamento
                ,v.custo_cancelamento
                ,v.q_cupons_cancelados
                ,isnull(d.total_devolvido,0) as 'total_devolvido'
                ,isnull(d.custo_devolucao,0) as 'custo_devolucao'
                ,isnull(d.q_devolucoes,0) as 'q_devolucoes'
                ,v.total_liquido - isnull(d.total_devolvido,0) as 'total_liquido'
                ,v.custo_liquido - isnull(d.custo_devolucao,0) as 'custo_liquido'
                ,v.qtde_cupons
           from ##vendas_cupom v, ##devolucao_cupom_fiscal d
       ) as tab

select total_bruto
       ,total_custo
       ,q_cupons_total
       ,cancelamento
       ,custo_cancelamento
       ,q_cupons_cancelados
       ,total_devolvido
       ,custo_devolucao
       ,q_devolucoes
       ,total_liquido
       ,custo_liquido
       ,qtde_cupons
              
       ,margem_lucro_bruto
       ,margem_lucro_liquido
       ,porc_cancelamento
       ,porc_devolucao
  from ##vendas_cupom_detalhada
   
    

