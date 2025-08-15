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
         create table CUSTOAQUISICAO
            (
                empresa varchar(2) collate database_default default '',
                ano smallint not null default 0,
                mes smallint not null default 0,
                produto varchar(15) collate database_default not null,
                custo decimal(11,4) default 0,
                constraint PK_CUSTO primary key (empresa,ano,mes,produto)
            )

      insert into CUSTOAQUISICAO
         select @emp,
                ano=year(TBS059.NFEDATEFE),
                mes=month(TBS059.NFEDATEFE),
                PROCOD,
                avg(dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) as custo
           from TBS0591 (nolock) inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
                                 inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
          where not exists(select null from CUSTOAQUISICAO where empresa=@emp and ano=year(TBS059.NFEDATEFE) and mes=month(TBS059.NFEDATEFE) and produto=PROCOD collate database_default) and
                TBS059.NFEDATEFE between @dataDe and @dataAte and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and
                FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350') and
                NFECFOP in('1.102','1.403','1.407','1.556','2.102','2.403','2.407','2.556')
          group by year(TBS059.NFEDATEFE),month(TBS059.NFEDATEFE),PROCOD
   end