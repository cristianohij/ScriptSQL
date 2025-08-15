-- procedure: coletar movimentações

if exists(select name from sysobjects where name='SP_MovimentacaoDiaria' and type='P')
   drop procedure [dbo].[SP_MovimentacaoDiaria]
go

create procedure [dbo].[SP_MovimentacaoDiaria] @dataDe as date, @dataAte as date as
   begin
      -- empresa em execução
      declare @emp varchar(2)

      set @emp = (select top 1 case right(EMPCGC,2) 
                                  when '56' then 'BB'
                                  when '37' then 'BB'
                                  when '98' then 'TM'
                                  when '79' then 'TT'
                               end
                    from TBS023 (nolock))
      ;

      -- ENTRADAS

      -- NF de entrada

      if object_id('TempDB.dbo.##NFENT') is not null
         begin
            drop table ##NFENT
         end
      ;

      select TBS059.NFEDATEFE as data,
             TBS0591.PROCOD as CodigoProduto,
             TBS0591.LESCOD as LocalEstoque,
             sum(TBS0591.NFEQTD * TBS0591.NFEQTDEMB) as QTDE
        into ##NFENT
        from TBS0591 (nolock)
             inner join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       where TBS059.NFEUSUEFE<>'' and
             TBS059.NFETIP<>'D' and
             TBS059.NFEDATEFE between @dataDe and @dataAte and
             TBS0591.NFEMOVEST='S'
       group by TBS059.NFEDATEFE,TBS0591.LESCOD,TBS0591.PROCOD
      ;

      -- NF de entrada de devolução

      if object_id('TempDB.dbo.##NFENTDEV') is not null
         begin
            drop table ##NFENTDEV
         end
      ;

      select TBS059.NFEDATEFE as data,
             TBS0591.PROCOD as CodigoProduto,
             TBS0591.LESCOD as LocalEstoque,
             sum(TBS0591.NFEQTD * TBS0591.NFEQTDEMB) as QTDE
        into ##NFENTDEV
        from TBS0591 (nolock)
             inner join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       where TBS059.NFEUSUEFE<>'' and
             TBS059.NFETIP='D' and
             TBS059.NFEDATEFE between @dataDe and @dataAte and
             TBS0591.NFEMOVEST='S'
       group by TBS059.NFEDATEFE,TBS0591.LESCOD,TBS0591.PROCOD
      ;

      -- NF de saída canceladas

      if object_id('TempDB.dbo.##NFSAICAN') is not null
         begin
           drop table ##NFSAICAN
         end
      ;

      select TBS067.NFSDATCAN as data,
             TBS0671.PROCOD as CodigoProduto,
             TBS0671.LESCOD as LocalEstoque,
             sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB) as QTDE
        into ##NFSAICAN
        from TBS0671 (nolock)
             inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       where TBS067.NFSTIP='N' and
             TBS067.NFSCAN='S' and
             TBS067.NFSDATCAN between @dataDe and @dataAte and
             TBS0671.NFSMOVEST='S'
       group by TBS067.NFSDATCAN,TBS0671.LESCOD,TBS0671.PROCOD
      ;

      -- ECF cancelados

      if object_id('TempDB.dbo.##ECFCAN') is not null
         begin
            drop table ##ECFCAN
         end
      ;

      create table ##ECFCAN (data datetime,CodigoProduto varchar(20) collate database_default,LocalEstoque smallint,QTDE smallmoney);

      -- se empresa igual a best bag ou tanby matriz ou taubaté
      if @emp = 'BB' or @emp = 'TM' or @emp = 'TT'
         begin
            declare @comando as char(500)

            set @comando = 'execute(''select data,Ltrim(cdprod) as CodigoProduto,2 as LocalEstoque,sum(quant) as QTDE from movcaixa where data between "'+convert(char(8),@dataDe,112)+'" and "'+convert(char(8),@dataAte,112)+'"  and status="01" and cancelado="S" group by data,Ltrim(cdprod)'') at MYSQLGZ'

            insert into ##ECFCAN exec(@comando)

            update ##ECFCAN set CodigoProduto=right('0000000'+Ltrim(CodigoProduto),7) where Len(CodigoProduto) < 7
         end
      ;

      -- NF de devolução para fornecedor cancelada ou em aberto

      if object_id('TempDB.dbo.##NFDEVCAN') is not null
         begin
            drop table ##NFDEVCAN
         end
      ;

      select TBS117.NFDDATEMI as data,
             TBS1172.PROCOD as CodigoProduto,
             TBS1172.LESCOD as LocalEstoque,
             sum(TBS1172.NFDQTD * TBS1172.NFDQTDEMB) as QTDE
        into ##NFDEVCAN
        from TBS1172 (nolock) inner join TBS117 (nolock) on TBS117.SNESER=TBS1172.SNESER and TBS117.NFDNUM=TBS1172.NFDNUM
       where (TBS117.NFDSTATUS='C' or TBS117.NFDSTATUS='O') and
             TBS117.NFDDATEMI between @dataDe and @dataAte and
             TBS1172.NFDMOVEST='S'
       group by TBS117.NFDDATEMI,TBS1172.LESCOD,TBS1172.PROCOD
      ;

      -- movimentos internos

      if object_id('TempDB.dbo.##MOVENT') is not null
         begin
            drop table ##MOVENT
         end
      ;

      select convert(date,TBS037.MVIDATEFE) as data,
             TBS0371.PROCOD as CodigoProduto,
             TBS037.MVILOCDES as LocalEstoque,
             sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB) as QTDE
        into ##MOVENT
        from TBS0371 (nolock)
             inner join TBS037 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
             inner join TBS033 (nolock) on TBS033.TMVCOD=TBS037.TMVCOD
       where convert(date,TBS037.MVIDATEFE) between @dataDe and @dataAte and
             TBS037.MVILOCDES > 0
       group by convert(date,TBS037.MVIDATEFE),TBS037.MVILOCDES,TBS0371.PROCOD
      ;

      -- manutenção dos saldos

      if object_id('TempDB.dbo.##SALENT') is not null
         begin
            drop table ##SALENT
         end
      ;

      select convert(date,TBS049.MDSLAN) as data,
             TBS049.PROCOD as CodigoProduto,
             TBS049.LESCOD as LocalEstoque,
             sum(TBS049.MDSQTD * TBS049.MDSQTDEMB) as QTDE
        into ##SALENT
        from TBS049 (nolock)
       where convert(date,TBS049.MDSLAN) between @dataDe and @dataAte and
             TBS049.MDSTIP='E'
       group by convert(date,TBS049.MDSLAN),TBS049.LESCOD,TBS049.PROCOD
      ;

      -- fim ENTRADAS



      -- SAÍDAS

      -- NF de saída

      if object_id('TempDB.dbo.##NFSAI') is not null
         begin
            drop table ##NFSAI
         end
      ;

      select TBS067.NFSDATEMI as data,
             TBS0671.PROCOD as CodigoProduto,
             TBS0671.LESCOD as LocalEstoque,
             sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB) as QTDE
        into ##NFSAI
        from TBS0671 (nolock)
             inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       where TBS067.NFSTIP='N' and
             TBS067.NFSDATEMI between @dataDe and @dataAte and
             TBS0671.NFSMOVEST='S'
       group by TBS067.NFSDATEMI,TBS0671.LESCOD,TBS0671.PROCOD
      ;

      -- ECF

      if object_id('TempDB.dbo.##ECF') is not null
         begin
            drop table ##ECF
         end
      ;

      create table ##ECF (data datetime,CodigoProduto varchar(20) collate database_default,LocalEstoque smallint,QTDE smallmoney);

      -- se empresa igual a best bag ou tanby matriz ou taubaté
      if @emp = 'BB' or @emp = 'TM' or @emp = 'TT'
         begin
            declare @comando2 as char(500)

            set @comando2 = 'execute(''select data,Ltrim(cdprod) as CodigoProduto,2 as LocalEstoque,sum(quant) as QTDE from movcaixa where data between "'+convert(char(8),@dataDe,112)+'" and "'+convert(char(8),@dataAte,112)+'"  and status="01" group by data,Ltrim(cdprod)'') at MYSQLGZ'

            insert into ##ECF exec(@comando2)

            update ##ECF set CodigoProduto=right('0000000'+Ltrim(CodigoProduto),7) where Len(CodigoProduto) < 7
         end
      ;

      -- NF de devolução para fornecedor

      if object_id('TempDB.dbo.##NFDEV') is not null
         begin
            drop table ##NFDEV
         end
      ;

      select TBS117.NFDDATEMI as data,
             TBS1172.PROCOD as CodigoProduto,
             TBS1172.LESCOD as LocalEstoque,
             sum(TBS1172.NFDQTD * TBS1172.NFDQTDEMB) as QTDE
        into ##NFDEV
        from TBS1172 (nolock) inner join TBS117 (nolock) on TBS117.SNESER=TBS1172.SNESER and TBS117.NFDNUM=TBS1172.NFDNUM
       where TBS117.NFDDATEMI between @dataDe and @dataAte and
             TBS1172.NFDMOVEST='S'
       group by TBS117.NFDDATEMI,TBS1172.LESCOD,TBS1172.PROCOD
      ;

      -- movimentos internos

      if object_id('TempDB.dbo.##MOVSAI') is not null
         begin
            drop table ##MOVSAI
         end
      ;

      select convert(date,TBS037.MVIDATEFE) as data,
             TBS0371.PROCOD as CodigoProduto,
             TBS037.MVILOCORI as LocalEstoque,
             sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB) as QTDE
        into ##MOVSAI
        from TBS0371 (nolock)
             inner join TBS037 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
             inner join TBS033 (nolock) on TBS033.TMVCOD=TBS037.TMVCOD
       where convert(date,TBS037.MVIDATEFE) between @dataDe and @dataAte and
             TBS037.MVILOCORI > 0
       group by convert(date,TBS037.MVIDATEFE),TBS037.MVILOCORI,TBS0371.PROCOD
      ;

      -- manutenção dos saldos

      if object_id('TempDB.dbo.##SALSAI') is not null
         begin
            drop table ##SALSAI
         end
      ;

      select convert(date,TBS049.MDSLAN) as data,
             TBS049.PROCOD as CodigoProduto,
             TBS049.LESCOD as LocalEstoque,
             sum(TBS049.MDSQTD * TBS049.MDSQTDEMB) as QTDE
        into ##SALSAI
        from TBS049 (nolock)
       where convert(date,TBS049.MDSLAN) between @dataDe and @dataAte and
             TBS049.MDSTIP='S'
       group by convert(date,TBS049.MDSLAN),TBS049.LESCOD,TBS049.PROCOD
      ;

      -- fim SAÍDAS

      -- fim da coleta temporária de dados

   end