-- notas do televendas na loja

select ENFNUM
       ,ENFVALTOT
  from TBS080 with (nolock)
 where ENFDATEMI between '20220501' and '20220531'
       and ENFSIT=6
       and ENFVENCOD not in(select VENCOD
                              from TBS004 with (nolock)
                             where GVECOD=2)
       and SNESER=3

select sum(ENFVALTOT)
  from TBS080 with (nolock)
 where ENFDATEMI between '20220501' and '20220531'
       and ENFSIT=6
       and ENFVENCOD not in(select VENCOD
                              from TBS004 with (nolock)
                             where GVECOD=2)
       and ENFVENCOD <> 101        -- 101 = tanby loja
       and SNESER=3

-- grupo 1 televendas

select sum(ENFVALTOT)
  from TBS080 with (nolock)
 where ENFDATEMI between '20220501' and '20220531'
       and ENFSIT=6
       and ENFVENCOD in(select VENCOD
                          from TBS004 with (nolock)
                         where GVECOD=1)
       and SNESER=3

select NFSNUM
       ,dbo.NFSTOTLIQ(0, NFSNUM, SNEEMPCOD, SNESER)
  from TBS067 with (nolock)
 where NFSDATEMI between '20220501' and '20220531'
       and NFSCAN='N'
       and SNESER=3
       and VENCOD not in (select VENCOD
                            from TBS004 with (nolock)
                           where GVECOD=2)

select *
  from TBS067 with (nolock)
 where NFSDATEMI between '20220501' and '20220531'
       and NFSOBS Like('%CUPOM FISCAL%')

select *
  from TBS067 with (nolock)
 where NFSDATEMI between '20220101' and '20220531'
       and NFSOBS Like('%198447%')

select NFSNUM
       ,dbo.NFSTOTLIQ(0, NFSNUM, SNEEMPCOD, SNESER)
  from TBS067 with (nolock)
 where NFSDATEMI between '20220501' and '20220531'
       and NFSCAN='N'
       and SNESER=3

-- notas delivery sem cupom fiscal

select sum(dbo.NFSTOTLIQ(0, NFSNUM, SNEEMPCOD, SNESER))
  from TBS067 with (nolock)
 where NFSDATEMI between '20220501' and '20220531'
       and NFSCAN='N'
       and SNESER=1
       and VENCOD in (select VENCOD
                        from TBS004 with (nolock)
                       where GVECOD=2)

select ENFVENCOD
       ,sum(ENFVALTOT)
  from TBS080 with (nolock)
 where ENFDATEMI between '20220501' and '20220531'
       and ENFSIT=6
       and SNESER=1
       and ENFVENCOD in (select VENCOD
                           from TBS004 with (nolock)
                          where GVECOD=2)
 group by ENFVENCOD

if object_id('tempdb.dbo.#Cfop') is not null
begin
   drop table #Cfop
end
   
create table #Cfop ( tipo char(1), valor char(3) collate database_default)

-- Saida 

insert into #Cfop values ('S', '102') -- Venda de mercadoria adquirida ou recebida de terceiros
insert into #Cfop values ('S', '108') -- Venda de mercadoria adquirida ou recebida de terceiros, destinada a não contribuinte
insert into #Cfop values ('S', '404') -- Venda de mercadoria sujeita ao regime de substituição tributária, cujo imposto já tenha sido retido anteriormente
insert into #Cfop values ('S', '405') -- Venda de mercadoria, adquirida ou recebida de terceiros, sujeita ao regime de substituição tributária, na condição de *contribuinte-substituído*
insert into #Cfop values ('S', '922') -- Lançamento efetuado a título de simples faturamento decorrente de venda para entrega futura -- acresentado dia 25/01/2018
insert into #Cfop values ('S', '929') -- Lançamento efetuado em decorrência de emissão de documento fiscal (Cupom)

select ENFVENCOD
       ,(select VENNOM from TBS004 with (nolock) where VENCOD=ENFVENCOD)
       --,sum(ENFVALTOT)
       ,sum(dbo.NFSTOTITEST(0, e.ENFNUM, 0, e.SNESER, i.NFSITE))
  from TBS080 e with (nolock)
  inner join TBS0671 i with (nolock)
  on i.SNESER=e.SNESER and i.NFSNUM=e.ENFNUM
 where ENFDATEMI between '20220501' and '20220531'
       and ENFFINEMI=1
       and ENFSIT=6
       and ENFVENCOD NOT in (select VENCOD
                           from TBS004 with (nolock)
                          where GVECOD=2)
       and right(i.NFSCFOP, 3) in (select valor from #Cfop where tipo = 'S')
 group by ENFVENCOD

select *
  from TBS080 with (nolock)
 where ENFDATEMI between '20220501' and '20220531'
       and ENFFINEMI=1
       and ENFSIT=6
       and ENFVENCOD=0

select i.NFSCFOP
  from TBS0671 i with (nolock)
  inner join TBS067 c with (nolock)
  on i.SNESER=c.SNESER and i.NFSNUM=c.NFSNUM
 where c.NFSDATEMI between '20220501' and '20220531'
       and c.NFSCAN='N'
       --and c.VENCOD=101
 group by i.NFSCFOP       

select ENFVENCOD
       ,(select VENNOM from TBS004 with (nolock) where VENCOD=ENFVENCOD)
       ,sum(ENFVALTOT)
       --,sum(dbo.NFSTOTITEST(0, e.ENFNUM, 0, e.SNESER, i.NFSITE))
  from TBS080 e with (nolock)
 where ENFDATEMI between '20220501' and '20220531'
       and ENFFINEMI=1
       and ENFSIT=6
       and ENFVENCOD NOT in (select VENCOD
                           from TBS004 with (nolock)
                          where GVECOD=2)
       and (select count(*)
              from TBS0671 i with (nolock)
             where i.SNESER=e.SNESER
                   and i.NFSNUM=e.ENFNUM
                   and right(i.NFSCFOP, 3) in (select valor from #Cfop where tipo = 'S')
           ) > 0
       
 group by ENFVENCOD

select --e.*
       i.*
       ,isnull((select VENNOM from TBS004 with (nolock) where VENCOD=ENFVENCOD),'') as nome_vendedor
       ,isnull(dbo.NFSTOTITEST(0, e.ENFNUM, 0, e.SNESER, i.NFSITE),0) as valor_item
       ,isnull((select GVECOD
                  from TBS004 with (nolock)
                 where VENCOD=ENFVENCOD),0) as grupo
  into #vendas
  from TBS080 e with (nolock)
  inner join TBS0671 i with (nolock)
  on i.SNESER=e.SNESER and i.NFSNUM=e.ENFNUM  
 where ENFDATEMI between '20220501' and '20220531'
       and ENFFINEMI=1
       and ENFSIT=6
       and right(i.NFSCFOP, 3) in (select valor from #Cfop where tipo = 'S')

select top(1) *
  from #vendas
 where SNESER=3

select SNESER
       ,grupo
       ,nome_vendedor
       ,sum(valor_item)
  from #vendas
 group by rollup (SNESER, grupo, nome_vendedor)
 order by SNESER, grupo, nome_vendedor
