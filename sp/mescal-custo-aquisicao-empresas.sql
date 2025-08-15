-- mescla custo médio mensal de todas as unidades do grupo

if exists(select name from sysobjects where name='SP_MesclaCustoMedioAquisicao' and type='P')
   drop procedure [dbo].[SP_MesclaCustoMedioAquisicao]
go

create procedure [dbo].[SP_MesclaCustoMedioAquisicao] @dataDe as date, @dataAte as date, @atualizar as varchar(1) as
   begin
      declare @emp varchar(2)

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

      if @emp <> 'BA'
         begin
            merge CUSTOAQUISICAO as destino
            using BA.SIBD.dbo.CUSTOAQUISICAO as origem
            on destino.empresa = origem.empresa collate database_default and destino.ano = origem.ano and destino.mes = origem.mes and destino.produto = origem.produto collate database_default

            -- se já existir o registro

            when matched and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched then 
               insert (empresa,ano,mes,produto,custo) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo);
         end

      if @emp <> 'BB'
         begin
            merge CUSTOAQUISICAO as destino
            using BB.SIBD2.dbo.CUSTOAQUISICAO as origem
            on destino.empresa = origem.empresa collate database_default and destino.ano = origem.ano and destino.mes = origem.mes and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched then 
               insert (empresa,ano,mes,produto,custo) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo);
         end

      if @emp <> 'CD'
         begin
            merge CUSTOAQUISICAO as destino
            using CD.SIBD.dbo.CUSTOAQUISICAO as origem
            on destino.empresa = origem.empresa collate database_default and destino.ano = origem.ano and destino.mes = origem.mes and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched then 
               insert (empresa,ano,mes,produto,custo) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo);
         end

      if @emp <> 'MI'
         begin
            merge CUSTOAQUISICAO as destino
            using MI.SIBD.dbo.CUSTOAQUISICAO as origem
            on destino.empresa = origem.empresa collate database_default and destino.ano = origem.ano and destino.mes = origem.mes and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched then 
               insert (empresa,ano,mes,produto,custo) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo);
         end

      if @emp <> 'PP'
         begin
            merge CUSTOAQUISICAO as destino
            using PP.SIBD.dbo.CUSTOAQUISICAO as origem
            on destino.empresa = origem.empresa collate database_default and destino.ano = origem.ano and destino.mes = origem.mes and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched then 
               insert (empresa,ano,mes,produto,custo) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo);
         end

      if @emp <> 'TM'
         begin
            merge CUSTOAQUISICAO as destino
            using TM.SIBD.dbo.CUSTOAQUISICAO as origem
            on destino.empresa = origem.empresa collate database_default and destino.ano = origem.ano and destino.mes = origem.mes and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched then 
               insert (empresa,ano,mes,produto,custo) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo);
         end

      if @emp <> 'TT'
         begin
            merge CUSTOAQUISICAO as destino
            using TT.SIBD.dbo.CUSTOAQUISICAO as origem
            on destino.empresa = origem.empresa collate database_default and destino.ano = origem.ano and destino.mes = origem.mes and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched then 
               insert (empresa,ano,mes,produto,custo) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo);
         end

      -- custo médio entre as unidades tanby e best arts
      insert into CUSTOAQUISICAO select 'MT',ano,mes,produto,avg(custo) from CUSTOAQUISICAO (nolock) where empresa in('TM','CD','TT','BA') group by ano,mes,produto order by produto,mes

      -- custo médio entre as unidades são paulo
      insert into CUSTOAQUISICAO select 'MS',ano,mes,produto,avg(custo) from CUSTOAQUISICAO (nolock) where empresa in('BB','MI','PP') group by ano,mes,produto order by produto,mes

      -- custo médio entre todas as unidades
      insert into CUSTOAQUISICAO select 'MG',ano,mes,produto,avg(custo) from CUSTOAQUISICAO (nolock) group by ano,mes,produto order by produto,mes
   end