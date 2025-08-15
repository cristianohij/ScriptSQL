--drop table CUSTOAQUISICAO

-- procedure: grava custo médio mensal

if exists(select name from sysobjects where name='SP_CustoMedioAquisicao' and type='P')
   drop procedure [dbo].[SP_CustoMedioAquisicao]
go

create procedure [dbo].[SP_CustoMedioAquisicao] @dataDe as date, @dataAte as date as
   begin
      declare @emp varchar(2)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  when '56' then 'BB'
                                  when '37' then 'BB'
                                  when '94' then 'BA'
                                  when '50' then 'CD'
                                  when '17' then 'MI'
                                  when '36' then 'PP'
                                  when '98' then 'TM'
                                  when '79' then 'TT'
                               end
                    from TBS023 (nolock))

      -- criação da tabela de custos, senão existir
      if object_id('CUSTOAQUISICAO') is null
         begin
            create table CUSTOAQUISICAO
               (
                   empresa varchar(2) collate database_default default '',
                   ano smallint not null default 0,
                   mes smallint not null default 0,
                   produto varchar(15) collate database_default not null,
                   custo decimal(16,6) default 0,
   
                   valor decimal(16,6) default 0,
                   qtde decimal(16,6) default 0,

                   anomes varchar(6)

                   --constraint PK_CUSTO primary key (empresa,ano,mes,produto)
               )
 
             create index ICUSTOAQUISICAO1 on dbo.CUSTOAQUISICAO (empresa, ano desc, mes desc, produto)
             create index ICUSTOAQUISICAO2 on dbo.CUSTOAQUISICAO (produto, mes)
             create index ICUSTOAQUISICAO3 on dbo.CUSTOAQUISICAO (empresa, anomes desc, produto)
         end

      insert into CUSTOAQUISICAO
         select @emp,
                ano=year(TBS059.NFEDATEFE),
                mes=month(TBS059.NFEDATEFE),
                PROCOD,

                -- qtde compra na menor unidade * preço unitário (sem alguns impostos)
                sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) -- valor total do mês
                /
                case sum(NFEQTD * NFEQTDEMB) when 0 then 1 else sum(NFEQTD * NFEQTDEMB) end as custo, -- qtde total do mês

                sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) as valor,
                sum(NFEQTD * NFEQTDEMB) as qtde, -- qtde total do mês

                str(year(TBS059.NFEDATEFE),4)+right('00'+Ltrim(str(month(TBS059.NFEDATEFE),2)),2)

--                avg(dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) as custo

           from TBS0591 (nolock) inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
                                 inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD

          where not exists(select null from CUSTOAQUISICAO
                            where empresa=@emp and ano=year(TBS059.NFEDATEFE) and mes=month(TBS059.NFEDATEFE) and produto=PROCOD collate database_default)
                and TBS059.NFEDATEFE between @dataDe and @dataAte
                and TBS0591.NFETIP='N'
                and TBS059.NFECAN<>'S'
                --TBS059.NFEDATEFE between @dataDe and @dataAte and --TBS0591.NFETIP<>'D' and
                --and FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350') and
                and right(NFECFOP,3) in('102','403','121','202','411')
--                and right(NFECFOP,3) in('202','411') -- devoluções
--                and TBS059.NFENUM<>263505
          group by year(TBS059.NFEDATEFE),month(TBS059.NFEDATEFE),PROCOD
   end

exec SP_CustoMedioAquisicao '20150101','20190831'

-------------------------------------------------------------

-- mescla custo médio mensal de todas as unidades tanby
-- rodar somente na tanby matriz

if exists(select name from sysobjects where name='SP_MesclaCustoMedioAquisicaoTanby' and type='P')
   drop procedure [dbo].[SP_MesclaCustoMedioAquisicaoTanby]
go

create procedure [dbo].[SP_MesclaCustoMedioAquisicaoTanby] @dataDe as date, @dataAte as date, @atualizar as varchar(1) as
   begin
      declare @emp varchar(2)

      set @emp = (select top 1 case right(EMPCGC,2) when '98' then 'TM' end from TBS023 (nolock))

      if @emp <> 'CD'
         begin
            merge CUSTOAQUISICAO as destino
            using CD.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa <> @emp
               and destino.empresa = origem.empresa collate database_default
               and destino.anomes = origem.anomes collate database_default
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa <> @emp and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa <> @emp then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end

      if @emp <> 'TT'
         begin
            merge CUSTOAQUISICAO as destino
            using TT.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa <> @emp
               and destino.empresa = origem.empresa collate database_default
               and destino.anomes = origem.anomes
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa <> @emp and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa <> @emp then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end

      -- custo médio entre as unidades tanby
      insert into CUSTOAQUISICAO (empresa,ano,mes,produto,custo,anomes)
         select 'MT',ano,mes,produto,avg(custo),anomes from CUSTOAQUISICAO A (nolock)
          where empresa in('TM','CD','TT')
                and not exists(select '' from CUSTOAQUISICAO B with (nolock) where B.empresa='MT' and B.ano=A.ano and B.produto=A.produto)
          group by ano,mes,produto,anomes order by produto,mes
   end

exec SP_MesclaCustoMedioAquisicaoTanby '20100101','20181231','N'

-------------------------------------------------------------

-- mescla custo médio mensal de todas as unidades sp
-- rodar somente na papelyna

if exists(select name from sysobjects where name='SP_MesclaCustoMedioAquisicaoSP' and type='P')
   drop procedure [dbo].[SP_MesclaCustoMedioAquisicaoSP]
go

create procedure [dbo].[SP_MesclaCustoMedioAquisicaoSP] @dataDe as date, @dataAte as date, @atualizar as varchar(1) as
   begin
      declare @emp varchar(2)

      set @emp = (select top 1 case right(EMPCGC,2) when '36' then 'PP' end from TBS023 (nolock))

      if @emp <> 'BB'
         begin
            merge CUSTOAQUISICAO as destino
            using BB.SIBD2.dbo.CUSTOAQUISICAO as origem
            on origem.empresa <> @emp
               and destino.empresa = origem.empresa collate database_default
               --and destino.ano = origem.ano
               --and destino.mes = origem.mes
               and destino.anomes = origem.anomes
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa <> @emp and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa <> @emp then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end

      if @emp <> 'MI'
         begin
            merge CUSTOAQUISICAO as destino
            using MI.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa <> @emp
               and destino.empresa = origem.empresa collate database_default
               --and destino.ano = origem.ano
               --and destino.mes = origem.mes
               and destino.anomes = origem.anomes
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa <> @emp and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa <> @emp then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end

      -- custo médio entre as unidades são paulo
      insert into CUSTOAQUISICAO (empresa,ano,mes,produto,custo,anomes)
         select 'MS',ano,mes,produto,avg(custo),anomes from CUSTOAQUISICAO A (nolock)
          where empresa in('BB','MI','PP')
                and not exists(select '' from CUSTOAQUISICAO B with (nolock) where B.empresa='MS' and B.ano=A.ano and B.produto=A.produto)
          group by ano,mes,produto,anomes order by produto,mes
   end

exec SP_MesclaCustoMedioAquisicaoSP '20150101','20151231','N'

-------------------------------------------------------------


-- ABAIXO NÃO RODAR


-- mescla custo médio mensal de todas as unidades do grupo

if exists(select name from sysobjects where name='SP_MesclaCustoMedioAquisicao' and type='P')
   drop procedure [dbo].[SP_MesclaCustoMedioAquisicao]
go

create procedure [dbo].[SP_MesclaCustoMedioAquisicao] @dataDe as date, @dataAte as date, @atualizar as varchar(1) as
   begin
      declare @emp varchar(2)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  --when '94' then 'BA'                                  
                                  when '56' then 'BB'
                                  when '37' then 'BB'
                                  when '50' then 'CD'
                                  when '17' then 'MI'
                                  when '36' then 'PP'
                                  when '98' then 'TM'
                                  when '79' then 'TT'
                               end
                    from TBS023 (nolock))

      /*
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
      */

      if @emp <> 'BB'
         begin
            merge CUSTOAQUISICAO as destino
            using BB.SIBD2.dbo.CUSTOAQUISICAO as origem
            on origem.empresa <> @emp
               and destino.empresa = origem.empresa collate database_default
               --and destino.ano = origem.ano
               --and destino.mes = origem.mes
               and destino.anomes = origem.anomes
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa <> @emp and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa <> @emp then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end

      if @emp <> 'CD'
         begin
            merge CUSTOAQUISICAO as destino
            using CD.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa <> @emp
               and destino.empresa = origem.empresa collate database_default
               --and destino.ano = origem.ano
               --and destino.mes = origem.mes
               and destino.anomes = origem.anomes collate database_default
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa <> @emp and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa <> @emp then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end

      if @emp <> 'MI'
         begin
            merge CUSTOAQUISICAO as destino
            using MI.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa <> @emp
               and destino.empresa = origem.empresa collate database_default
               --and destino.ano = origem.ano
               --and destino.mes = origem.mes
               and destino.anomes = origem.anomes
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa <> @emp and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa <> @emp then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end

      if @emp <> 'PP'
         begin
            merge CUSTOAQUISICAO as destino
            using PP.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa <> @emp
               and destino.empresa = origem.empresa collate database_default
               --and destino.ano = origem.ano
               --and destino.mes = origem.mes
               and destino.anomes = origem.anomes
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa <> @emp and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa <> @emp then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end

      if @emp <> 'TM'
         begin
            merge CUSTOAQUISICAO as destino
            using TM.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa <> @emp
               and destino.empresa = origem.empresa collate database_default
               --and destino.ano = origem.ano
               --and destino.mes = origem.mes
               and destino.anomes = origem.anomes
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa <> @emp and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa <> @emp then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end

      if @emp <> 'TT'
         begin
            merge CUSTOAQUISICAO as destino
            using TT.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa <> @emp
               and destino.empresa = origem.empresa collate database_default
               --and destino.ano = origem.ano
               --and destino.mes = origem.mes
               and destino.anomes = origem.anomes
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa <> @emp and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa <> @emp then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end

      -- custo médio entre as unidades tanby
      --insert into CUSTOAQUISICAO (empresa,ano,mes,produto,custo) select 'MT',ano,mes,produto,avg(custo) from CUSTOAQUISICAO (nolock) where empresa in('TM','CD','TT','BA') group by ano,mes,produto order by produto,mes
      insert into CUSTOAQUISICAO (empresa,ano,mes,produto,custo,anomes)
         select 'MT',ano,mes,produto,avg(custo),anomes from CUSTOAQUISICAO A (nolock)
          where empresa in('TM','CD','TT')
                and not exists(select '' from CUSTOAQUISICAO B with (nolock) where B.empresa='MT' and B.ano=A.ano and B.produto=A.produto)
          group by ano,mes,produto,anomes order by produto,mes

      -- custo médio entre as unidades são paulo
      insert into CUSTOAQUISICAO (empresa,ano,mes,produto,custo,anomes)
         select 'MS',ano,mes,produto,avg(custo),anomes from CUSTOAQUISICAO A (nolock)
          where empresa in('BB','MI','PP')
                and not exists(select '' from CUSTOAQUISICAO B with (nolock) where B.empresa='MS' and B.ano=A.ano and B.produto=A.produto)
          group by ano,mes,produto,anomes order by produto,mes

      -- custo médio entre todas as unidades
      insert into CUSTOAQUISICAO (empresa,ano,mes,produto,custo,anomes)
         select 'MG',ano,mes,produto,avg(custo),anomes from CUSTOAQUISICAO A (nolock)
          where empresa not in('MT','MS')
                and not exists(select '' from CUSTOAQUISICAO B with (nolock) where B.empresa='MG' and B.ano=A.ano and B.produto=A.produto)
          group by ano,mes,produto,anomes order by produto,mes
   end

exec SP_MesclaCustoMedioAquisicao '20150101','20151231','N'

-- NÃO RODAR

-------------------------------------------------------------


-- mescla custos médios tanby / sp / geral mensal
-- deve-se escolher a empresa origem que contêm as médias totais gerais

if exists(select name from sysobjects where name='SP_MesclaCustoMedioGeralAquisicao' and type='P')
   drop procedure [dbo].[SP_MesclaCustoMedioGeralAquisicao]
go

create procedure [dbo].[SP_MesclaCustoMedioGeralAquisicao] @ori as varchar(2), @dataDe as date, @dataAte as date, @atualizar as varchar(1) as
   begin
      declare @emp varchar(2)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  --when '94' then 'BA'                                  
                                  when '56' then 'BB'
                                  when '37' then 'BB'
                                  when '50' then 'CD'
                                  when '17' then 'MI'
                                  when '36' then 'PP'
                                  when '98' then 'TM'
                                  when '79' then 'TT'
                               end
                    from TBS023 (nolock))

      if @ori = 'BB' and @ori <> @emp
         begin
            merge CUSTOAQUISICAO as destino
            using BB.SIBD2.dbo.CUSTOAQUISICAO as origem
            on origem.empresa in('MG','MS','MT')
               and destino.empresa = origem.empresa collate database_default
               --and destino.ano = origem.ano
               --and destino.mes = origem.mes
               and destino.anomes = origem.anomes
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa in('MG','MS','MT') and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa in('MG','MS','MT') then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end

      if @ori = 'CD' and @ori <> @emp
         begin
            merge CUSTOAQUISICAO as destino
            using CD.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa in('MG','MS','MT')
               and destino.empresa = origem.empresa collate database_default
               --and destino.ano = origem.ano
               --and destino.mes = origem.mes
               and destino.anomes = origem.anomes collate database_default
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa in('MG','MS','MT') and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa in('MG','MS','MT') then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end

      if @ori = 'MI' and @ori <> @emp
         begin
            merge CUSTOAQUISICAO as destino
            using MI.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa in('MG','MS','MT')
               and destino.empresa = origem.empresa collate database_default
               --and destino.ano = origem.ano
               --and destino.mes = origem.mes
               and destino.anomes = origem.anomes
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa in('MG','MS','MT') and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa in('MG','MS','MT') then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end

      if @ori = 'PP' and @ori <> @emp
         begin
            merge CUSTOAQUISICAO as destino
            using PP.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa in('MG','MS','MT')
               and destino.empresa = origem.empresa collate database_default
               --and destino.ano = origem.ano
               --and destino.mes = origem.mes
               and destino.anomes = origem.anomes
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa in('MG','MS','MT') and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa in('MG','MS','MT') then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end

      if @ori = 'TM' and @ori <> @emp
         begin
            merge CUSTOAQUISICAO as destino
            using TM.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa in('MG','MS','MT')
               and destino.empresa = origem.empresa collate database_default
               --and destino.ano = origem.ano
               --and destino.mes = origem.mes
               and destino.anomes = origem.anomes
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa in('MG','MS','MT') and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa in('MG','MS','MT') then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end

      if @ori = 'TT' and @ori <> @emp
         begin
            merge CUSTOAQUISICAO as destino
            using TT.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa in('MG','MS','MT')
               and destino.empresa = origem.empresa collate database_default
               --and destino.ano = origem.ano
               --and destino.mes = origem.mes
               and destino.anomes = origem.anomes
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa in('MG','MS','MT') and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa in('MG','MS','MT') then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end
   end

exec SP_MesclaCustoMedioGeralAquisicao 'TM', '20150101', '20151231', 'S'

-------------------------------------------------------------


-- mescla custos médios tanby
-- a empresa origem deve ser a tanby matriz

if exists(select name from sysobjects where name='SP_MesclaCustoMedioGeralAquisicaoTanby' and type='P')
   drop procedure [dbo].[SP_MesclaCustoMedioGeralAquisicaoTanby]
go

create procedure [dbo].[SP_MesclaCustoMedioGeralAquisicaoTanby] @dataDe as date, @dataAte as date, @atualizar as varchar(1) as
   begin
      declare @emp varchar(2)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  when '50' then 'CD'
                                  when '79' then 'TT'
                               end
                    from TBS023 (nolock))

      if @emp <> 'TM'
         begin
            merge CUSTOAQUISICAO as destino
            using TM.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa='MT'
               and destino.empresa = origem.empresa collate database_default
               and destino.anomes = origem.anomes collate database_default
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa='MT' and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa='MT' then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end
   end

exec SP_MesclaCustoMedioGeralAquisicaoTanby '20150101', '20181231', 'S'

-------------------------------------------------------------


-- mescla custos médios sp com tanby
-- a empresa origem deve ser a papelyna
-- rodas somente nas tanby

if exists(select name from sysobjects where name='SP_MesclaCustoMedioGeralAquisicaoSPnaTanby' and type='P')
   drop procedure [dbo].[SP_MesclaCustoMedioGeralAquisicaoSPnaTanby]
go

create procedure [dbo].[SP_MesclaCustoMedioGeralAquisicaoSPnaTanby] @dataDe as date, @dataAte as date, @atualizar as varchar(1) as
   begin
      declare @emp varchar(2)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  when '50' then 'CD'
                                  when '79' then 'TT'
                                  when '98' then 'TM'
                               end
                    from TBS023 (nolock))

      if @emp in('TM','CD','TT')
         begin
            merge CUSTOAQUISICAO as destino
            using PP.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa='MS'
               and destino.empresa = origem.empresa collate database_default
               and destino.anomes = origem.anomes collate database_default
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa='MS' and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa='MS' then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end
   end

exec SP_MesclaCustoMedioGeralAquisicaoSPnaTanby '20150101', '20181231', 'S'

-------------------------------------------------------------

-- mescla custos médios sp
-- a empresa origem deve ser a papelyna

if exists(select name from sysobjects where name='SP_MesclaCustoMedioGeralAquisicaoSP' and type='P')
   drop procedure [dbo].[SP_MesclaCustoMedioGeralAquisicaoSP]
go

create procedure [dbo].[SP_MesclaCustoMedioGeralAquisicaoSP] @dataDe as date, @dataAte as date, @atualizar as varchar(1) as
   begin
      declare @emp varchar(2)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  when '56' then 'BB'
                                  when '37' then 'BB'
                                  when '17' then 'MI'
                               end
                    from TBS023 (nolock))

      if @emp <> 'PP'
         begin
            merge CUSTOAQUISICAO as destino
            using PP.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa='MS'
               and destino.empresa = origem.empresa collate database_default
               and destino.anomes = origem.anomes collate database_default
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa='MS' and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa='MS' then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end
   end

exec SP_MesclaCustoMedioGeralAquisicaoSP '20150101', '20181231', 'S'

-------------------------------------------------------------


-- mescla custos médios tanby com sp
-- a empresa origem deve ser a tanby matriz
-- rodas somente nas unidades sp

if exists(select name from sysobjects where name='SP_MesclaCustoMedioGeralAquisicaoTanbyEmSP' and type='P')
   drop procedure [dbo].[SP_MesclaCustoMedioGeralAquisicaoTanbyEmSP]
go

create procedure [dbo].[SP_MesclaCustoMedioGeralAquisicaoTanbyEmSP] @dataDe as date, @dataAte as date, @atualizar as varchar(1) as
   begin
      declare @emp varchar(2)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  when '56' then 'BB'
                                  when '37' then 'BB'
                                  when '17' then 'MI'
                                  when '36' then 'PP'
                               end
                    from TBS023 (nolock))

      if @emp in('BB','MI','PP')
         begin
            merge CUSTOAQUISICAO as destino
            using TM.SIBD.dbo.CUSTOAQUISICAO as origem
            on origem.empresa='MT'
               and destino.empresa = origem.empresa collate database_default
               and destino.anomes = origem.anomes collate database_default
               and destino.produto = origem.produto collate database_default

            -- se já existir o registro
            when matched and destino.empresa='MT' and @atualizar='S' then
               -- se for para atualizar
                  update set destino.custo = origem.custo

            -- se registro não encontrado
            when not matched and origem.empresa='MT' then 
               insert (empresa,ano,mes,produto,custo,anomes) values (origem.empresa,origem.ano,origem.mes,origem.produto,origem.custo,origem.anomes);
         end
   end

exec SP_MesclaCustoMedioGeralAquisicaoTanbyEmSP '20150101', '20181231', 'S'

-------------------------------------------------------------



-- zera custos na tabela de saldos iniciais

if exists(select name from sysobjects where name='SP_ZeraCustoAquisicao' and type='P')
   drop procedure [dbo].[SP_ZeraCustoAquisicao]
go

--create procedure [dbo].[SP_GravaCustoAquisicao] @dataDe as date, @dataAte as date as
create procedure [dbo].[SP_ZeraCustoAquisicao] @dataDe as date, @dataAte as date as
   begin
      update TBS124 set SINCUSAQU=0 where SINEMPCOD=0 and SINDAT between @dataDe and @dataAte
   end

-- zera custo da aquisição
exec [dbo].[SP_ZeraCustoAquisicao] '20150101', '20181201'

-------------------------------------------------------------


-- cria tabela auxiliar de custos

if exists(select name from sysobjects where name='SP_CriaTabelaAuxiliarCustoTanby' and type='P')
   drop procedure [dbo].[SP_CriaTabelaAuxiliarCustoTanby]
go

create procedure [dbo].[SP_CriaTabelaAuxiliarCustoTanby] @anomes char(6) as
   begin
      declare @emp varchar(2) --, @custo decimal(11,4)

      set @emp = (select top 1 case right(EMPCGC,2) 
--                                  when '56' then 'BB'
--                                  when '37' then 'BB'
                                  when '50' then 'CD'
--                                  when '17' then 'MI'
--                                  when '36' then 'PP'
                                  when '98' then 'TM'
                                  when '79' then 'TT'
                               end
                    from TBS023 (nolock))

      if object_id('custos') is not null
           drop table custos

      if @emp in('CD','TM','TT')
         begin
            select empresa, ano, mes, produto, custo, str(ano,4)+right('00'+Ltrim(str(mes,2)),2) anomes
              into custos
              from CUSTOAQUISICAO with (nolock)
             where empresa in(@emp,'MT')
                   and anomes <= @anomes
             order by empresa, anomes desc, produto;

            create index icusto1 on dbo.custos (empresa, ano desc, mes desc, produto)
            create index icusto2 on dbo.custos (empresa, anomes desc, produto)
         end
   end


-- cria tabela auxiliar de custos
exec [dbo].[SP_CriaTabelaAuxiliarCustoTanby] '201812'

select count(*) from custos with (nolock)

-------------------------------------------------------------

-------------------------------------------------------------


-- cria tabela auxiliar de custos

if exists(select name from sysobjects where name='SP_CriaTabelaAuxiliarCustoSP' and type='P')
   drop procedure [dbo].[SP_CriaTabelaAuxiliarCustoSP]
go

create procedure [dbo].[SP_CriaTabelaAuxiliarCustoSP] @anomes char(6) as
   begin
      declare @emp varchar(2) --, @custo decimal(11,4)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  when '56' then 'BB'
                                  when '37' then 'BB'
                                  when '17' then 'MI'
                                  when '36' then 'PP'
                               end
                    from TBS023 (nolock))

      if object_id('custos') is not null
           drop table custos

      if @emp in('BB','MI','PP')
         begin
            select empresa, ano, mes, produto, custo, str(ano,4)+right('00'+Ltrim(str(mes,2)),2) anomes
              into custos
              from CUSTOAQUISICAO with (nolock)
             where empresa in(@emp,'MS')
                   and anomes <= @anomes
             order by empresa, anomes desc, produto;

            create index icusto1 on dbo.custos (empresa, ano desc, mes desc, produto)
            create index icusto2 on dbo.custos (empresa, anomes desc, produto)
         end
   end


-- cria tabela auxiliar de custos
exec [dbo].[SP_CriaTabelaAuxiliarCustoSP] '201812'

-------------------------------------------------------------


-- grava custo na tabela de saldos iniciais: busca por dados da própria empresa

if exists(select name from sysobjects where name='SP_GravaCustoAquisicao' and type='P')
   drop procedure [dbo].[SP_GravaCustoAquisicao]
go

--create procedure [dbo].[SP_GravaCustoAquisicao] @dataDe as date, @dataAte as date as
create procedure [dbo].[SP_GravaCustoAquisicao] @data date, @sobrescrever char(1) as
   begin
      declare @emp varchar(2) --, @custo decimal(11,4)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  --when '94' then 'BA'                                  
                                  when '56' then 'BB'
                                  when '37' then 'BB'
                                  when '50' then 'CD'
                                  when '17' then 'MI'
                                  when '36' then 'PP'
                                  when '98' then 'TM'
                                  when '79' then 'TT'
                               end
                    from TBS023 (nolock))

      -- atualiza custos da própria empresa

      if object_id('custos') is not null
         update TBS124 set SINCUSAQU=isnull((select top 1 custo from custos with (nolock)
                                              where empresa=@emp
                                                    and anomes <= SINANOMES
                                                    and produto=SINPROCOD
                                              order by empresa, anomes desc,produto),0)
          where SINEMPCOD=0
                and SINDAT=@data
                and SINCUSAQU between 0 and case @sobrescrever when 'N' then 0 else 999999999 end;
      else
         print 'Tabela custos deve ser criada.'
   end

-- grava custo da aquisição na tabela de saldos iniciais
exec [dbo].[SP_GravaCustoAquisicao] '20170101', 'S'

-------------------------------------------------------------


-- grava custo na tabela de saldos iniciais: busca média de custos da tanby

if exists(select name from sysobjects where name='SP_GravaCustoAquisicaoTanby' and type='P')
   drop procedure [dbo].[SP_GravaCustoAquisicaoTanby]
go

create procedure [dbo].[SP_GravaCustoAquisicaoTanby] @data date as
   begin
      declare @emp varchar(2)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  when '50' then 'CD'
                                  when '98' then 'TM'
                                  when '79' then 'TT'
                               end
                    from TBS023 (nolock))

      -- atualiza custos média tanby

      if object_id('custos') is not null
         if @emp in('CD','TM','TT')
            update TBS124 set SINCUSAQU=isnull((select top 1 custo from custos with (nolock)
                                                 where empresa='MT'
                                                       and anomes <= SINANOMES
                                                       and produto=SINPROCOD
                                                 order by empresa, anomes desc, produto),0)
             where SINEMPCOD=0 and SINDAT=@data
                   and SINCUSAQU=0
      else
         print 'Tabela custos deve ser criada.'
   end

-- grava custo da aquisição na tabela de saldos iniciais
exec [dbo].[SP_GravaCustoAquisicaoTanby] '20170101'

-------------------------------------------------------------


-- grava custo na tabela de saldos iniciais: busca média de custos da SP

if exists(select name from sysobjects where name='SP_GravaCustoAquisicaoSP' and type='P')
   drop procedure [dbo].[SP_GravaCustoAquisicaoSP]
go

--create procedure [dbo].[SP_GravaCustoAquisicao] @dataDe as date, @dataAte as date as
create procedure [dbo].[SP_GravaCustoAquisicaoSP] @data date as
   begin
      declare @emp varchar(2) --, @custo decimal(11,4)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  when '56' then 'BB'
                                  when '37' then 'BB'
                                  when '17' then 'MI'
                                  when '36' then 'PP'
                               end
                    from TBS023 (nolock))

      -- atualiza custos média sp

      if object_id('custos') is not null
         begin
            if @emp in('BB','MI','PP')
               update TBS124 set SINCUSAQU=isnull((select top 1 custo from custos with (nolock)
                                                    --where empresa='MS' and ano <= year(SINDAT) and mes <= month(SINDAT) and produto=SINPROCOD order by empresa, ano desc, mes desc, produto)
                                                    where empresa='MS'
                                                          --and str(ano,4)+right('00'+Ltrim(str(mes,2)),2) < = convert(char(6),SINDAT,112)
                                                          and anomes <= SINANOMES
                                                          and produto=SINPROCOD
                                                    --order by empresa, ano desc, mes desc, produto),0)
                                                    order by empresa, anomes desc, produto),0)
                where SINEMPCOD=0 and SINDAT=@data
                      --and SINQTD > 0
                      --and SINCUSAQU between 0 and case @sobrescrever when 'N' then 0 else 999999999 end;
                      and SINCUSAQU=0
            end
      else
         begin
            print 'Tabela custos deve ser criada.'
         end
   end

-- grava custo da aquisição na tabela de saldos iniciais
exec [dbo].[SP_GravaCustoAquisicaoSP] '20170101'

-------------------------------------------------------------


-- grava custo na tabela de saldos iniciais: busca média de custos da geral

if exists(select name from sysobjects where name='SP_GravaCustoAquisicaoGeral' and type='P')
   drop procedure [dbo].[SP_GravaCustoAquisicaoGeral]
go

create procedure [dbo].[SP_GravaCustoAquisicaoGeral] @data date as
   begin
      if object_id('custos') is not null
         update TBS124 set SINCUSAQU=isnull((select top 1 custo from custos with (nolock)
                                              where empresa='MG'
                                                    and anomes <= SINANOMES
                                                    and produto=SINPROCOD
                                              order by empresa, anomes desc, produto),0)
          where SINEMPCOD=0 and SINDAT=@data
                and SINCUSAQU=0
      else
         print 'Tabela custos deve ser criada.'
   end

-- grava custo da aquisição na tabela de saldos iniciais
exec [dbo].[SP_GravaCustoAquisicaoGeral] '20170101'


-- ---

select top 100 * from TBS124 with (nolock) where SINCUSAQU=0 order by SINANOMES desc

select top 1 * from CUSTOAQUISICAO with (nolock) where produto='20961455'

select anomes,count(*) from CUSTOAQUISICAO with (nolock) group by anomes order by anomes desc

select empresa,anomes from CUSTOAQUISICAO with (nolock) where anomes is null group by empresa,anomes order by empresa,anomes desc

select count(*) from CUSTOAQUISICAO with (nolock) where anomes is null

select count(*) from custos with (nolock) where anomes is null

ALTER TABLE [TBS124]
ALTER COLUMN [SINCUSAQU] DECIMAL(15,6) NULL

ALTER TABLE [TBS125]
ALTER COLUMN [KESCUSMED] DECIMAL(15,6) NULL


select NFEITE,NFETOTOPEITE,NFEBASICMS,NFEVALICMS,NFEVALCOFINS,NFEVALPIS,NFEVALICMSST,dbo.NFECUSAQU(0,NFETIP,NFENUM,NFECOD,0,SERCOD,NFEITE),NFEVALIPI
  from TBS0591 (nolock)
 where NFENUM=331154
 order by NFEITE


alter table TBS124 add SINANOMES char(6)

update TBS124 set SINANOMES=str(year(SINDAT),4)+right('00'+Ltrim(str(month(SINDAT),2)),2)

CREATE NONCLUSTERED INDEX [ITBS1242] ON [TBS124] (
      [SINEMPCOD],
      [LESCOD],
      [SINANOMES] DESC,
      [SINPROCOD])

-- ---



select *
  into #custos
  from
(select empresa,anomes,produto,avg(custo) as valor from CUSTOAQUISICAO with (nolock) group by empresa,anomes,produto)
em_linha
pivot (avg(valor) for empresa in ([MT],[TM])) em_colunas
order by 1 desc,2

select * from #custos where produto in('0061443','0062960')

select PROCOD,ESTQTDATU*(select top 1 case when TM > 0 then TM else MT end from #custos where anomes <= '201812' and produto=PROCOD) from SALDODIARIO with (nolock)
 where ESTLOC=1
       and ESTDATSAL='20181227'

select * from SALDODIARIO with (nolock) where ESTLOC=1 and ESTDATSAL='20181227' and PROCOD in('0061443','0062960')

0061443         .000000
0061452         .000000
0061808         20.643900
0061930         15.026028
0062014         9.810120
0062510         72.920664
0062960         NULL

select empresa
       ,anomes
       ,produto
       ,isnull((select custo from CUSTOAQUISICAO b with (nolock)
                 where b.empresa='TM' and b.anomes=a.anomes and b.produto=a.produto),0) as proprio
       ,isnull((select custo from CUSTOAQUISICAO b with (nolock)
                 where b.empresa='MT' and b.anomes=a.anomes and b.produto=a.produto),0) as medio
       --,isnull((select ((PDPPREFOR+PDPPREFOR*PDPIPI/100)+(PDPPREFOR+PDPPREFOR*PDPIPI/100)*PDPPORST/100)/PDPQTDEMB from TBS015 with (nolock) where PDPCOD=produto),0) as politica
 from CUSTOAQUISICAO a with (nolock)
 where a.empresa in('TM','MT')
group by empresa,anomes,produto
order by empresa,anomes desc,produto

select (PDPPREFOR+PDPPREFOR*PDPIPI/100)+(PDPPREFOR+PDPPREFOR*PDPIPI/100)*PDPPORST/100 from TBS015 with (nolock) where PDPCOD='17230003'

select * from TBS031 with (nolock) where TDPPROCOD='17230003'

select dbo.PDPCUSAQU(0,'0040061')

select * from SALDODIARIO SD with (nolock)
 where ESTDATSAL='20181231' 
       and ESTQTDATU <> isnull((select top 1 LMEQTDSAL
                                  from TBS051 LG (nolock)
                                 where LG.PROCOD=SD.PROCOD and LG.LMEDATHOR<=SD.ESTDATSAL and LG.LMELOCEST=SD.ESTLOC and LG.LMEINFALT='E'
                                 order by LMEREG desc),0)

select *
  from 
(select coalesce(cast(ano as varchar(50)),'total mês') as ano
        ,coalesce(cast(mes as varchar(50)),'total ano') as mes
        ,sum(valor) as valor
   from CUSTOAQUISICAO with (nolock)
  where empresa='TM' and ano=2018
  group by grouping sets ((ano),(mes),())) xtab
