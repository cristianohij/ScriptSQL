if exists(select name from sysobjects where name='SP_SaldoInicialMensal' and type='P')
   drop procedure [dbo].[SP_SaldoInicialMensal]
go

create procedure [dbo].[SP_SaldoInicialMensal] @dataSaldoBase as date as
   begin

      declare @ultimoDiaMes as date, @dataProximoSaldoInicial as date, @movimentoDe as date, @movimentoAte as date

      -- último dia do mês
      set @ultimoDiaMes = convert(date,DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, @dataSaldoBase) + 1, 0)))

      -- data do próximo saldo inicial = 
      set @dataProximoSaldoInicial = DATEADD(day, 1, @ultimoDiaMes)

      -- período das movimentações
      set @movimentoDe  = @dataSaldoBase
      set @movimentoAte = @ultimoDiaMes

      insert into TBS124
      select 0,                          -- empresa da tabela de saldos iniciais
             @dataProximoSaldoInicial,   -- data do saldo inicial
             0,                          -- empresa do local de estoque
             LESCOD,                     -- local de estoque
             0,                          -- empresa do produto
             KESPROCOD,                  -- código do produto
             (select PROUM1 from TBS010 (nolock) where PROCOD = KESPROCOD collate database_default),    -- menor unidade de medida
             (select PROUM1QTD from TBS010 (nolock) where PROCOD = KESPROCOD collate database_default), -- quantidade da embalagem da menor unidade de medida

             -- cálculo do saldo = saldo inicial + entradas - saídas

             case when isnull((select 1 from TBS124 (nolock) where TBS124.SINDAT=@dataSaldoBase and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD),0) > 0
                  -- se saldo inicial encontrado
                  then isnull((select SINQTD from TBS124 (nolock) where TBS124.SINDAT=@dataSaldoBase and TBS124.LESCOD=TBS125.LESCOD and TBS124.SINPROCOD=TBS125.KESPROCOD),0)
                  -- senão
                  else 0
             end -- saldo inicial

             + sum((KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV + KESMOVENT + KESSALENT + KESOUT)                                              -- entradas
             -     (KESNFSAI + KESCUPFIS + KESNFDEVSAI + KESMOVSAI + KESSALSAI)),                                                                                  -- saídas
             0 -- custo da aquisição da mercadoria
        from TBS125 (nolock)
       where KESDAT between @movimentoDe and @movimentoAte and
             isnull((select 1 from TBS124 (nolock)
                      where SINEMPCOD=0 and SINDAT=@dataProximoSaldoInicial and LESEMPCOD=0 and TBS124.LESCOD=TBS125.LESCOD and SINEMPPRO=0 and SINPROCOD=KESPROCOD),0) = 0
       group by LESCOD,KESPROCOD

      -- elimina registro com valor zero
      delete TBS124 where SINQTD=0

   end