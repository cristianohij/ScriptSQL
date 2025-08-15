-- grava custo na tabela de saldos iniciais

if exists(select name from sysobjects where name='SP_GravaCustoAquisicao' and type='P')
   drop procedure [dbo].[SP_GravaCustoAquisicao]
go

create procedure [dbo].[SP_GravaCustoAquisicao] @dataDe as date, @dataAte as date as
   begin
      declare @emp varchar(2) --, @custo decimal(11,4)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  when '94' then 'BA'                                  
                                  when '56' then 'BB'
                                  when '37' then 'BB'
                                  when '50' then 'CD'
                                  when '17' then 'MI'
                                  when '36' then 'PP'
                                  when '98' then 'TM'
                                  when '79' then 'TT'
                               end
                    from TBS023 (nolock))

      -- best arts e unidades tanby
      if @emp in('BA','CD','TM','TT')
         -- custo da aquisição
         update TBS124 set SINCUSAQU=(
            case
               -- média tanby e best arts
               when (select top 1 1 from CUSTOAQUISICAO (nolock)
                      where empresa='MT' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
                  then (select top 1 custo from CUSTOAQUISICAO (nolock)
                         where empresa='MT' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

               -- média unidades são paulo
               when (select top 1 1 from CUSTOAQUISICAO (nolock)
                      where empresa='MS' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
                  then (select top 1 custo from CUSTOAQUISICAO (nolock)
                         where empresa='MS' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

               else 0
            end)

           from TBS124 (nolock) where SINDAT between @dataDe and @dataAte

      -- unidades são paulo
      if @emp in('BB','MI','PP')
         -- custo da aquisição
         update TBS124 set SINCUSAQU=(
            case
               -- média unidades são paulo
               when (select top 1 1 from CUSTOAQUISICAO (nolock)
                      where empresa='MS' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
                  then (select top 1 custo from CUSTOAQUISICAO (nolock)
                         where empresa='MS' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

               -- média tanby e best arts
               when (select top 1 1 from CUSTOAQUISICAO (nolock)
                      where empresa='MT' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto) > 0
                  then (select top 1 custo from CUSTOAQUISICAO (nolock)
                         where empresa='MT' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by ano desc, mes desc, produto)

               else 0
            end)

           from TBS124 (nolock) where SINDAT between @dataDe and @dataAte

   end
