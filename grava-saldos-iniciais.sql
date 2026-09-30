-- 1o. a ser executada

-- grava tabela de SALDOINICIAL com base na tabela de SALDODIARIO

if exists(select name from sysobjects where name='SP_GravaSaldoInicial' and type='P')
   drop procedure [dbo].[SP_GravaSaldoInicial]
go

-- recebe m�s inicial e final a ser processado
create procedure [dbo].[SP_GravaSaldoInicial] @datai date, @dataf date as
   begin
      set nocount on

      declare @datas date, @dbusca date

	   declare @msg varchar(1000)

      set @datas='17530101'
	   set @dbusca='17530101'

      while @datas < @dataf
         begin
         
            -- ultimo dia do mes processado
            -- print DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, '20190501') + 1, 0)) -- 31/05/2019
            set @datas=DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, @datai) + 1, 0))

            set @msg = 'Processa data: ' + convert(varchar, @datas)
            raiserror (@msg, 0, 1) with nowait

            -- ultima data do saldo diario gravado no mes processado
            -- select top 1 ESTDATSAL from SALDODIARIO with (nolock) where ESTDATSAL <= '20190531' order by ESTDATSAL desc -- 31/05/2019

            set @datas=(select top 1 ESTDATSAL
                          from SALDODIARIO with (nolock)
                         where ESTDATSAL <= @datas
                   order by ESTDATSAL desc)

			   set @dbusca=convert(date, dateadd(mm, datediff(mm,0,@datas) + 1, 0))

            --set @msg = 'Buscar data: ' + convert(varchar,@dbusca)
            --raiserror (@msg, 0, 1) with nowait

            insert into SALDOINICIAL
            select convert(date, dateadd(mm, datediff(mm,0,colunas.data) + 1, 0)) as data
                   ,convert(char(6), dateadd(mm, datediff(mm,0,colunas.data) + 1, 0), 112) as anomes
                   ,colunas.codigo
                   ,(select PROUM1 from TBS010 with (nolock) where PROEMPCOD=0 and PROCOD=codigo) as unidade
                   ,(select PROUM1QTD from TBS010 with (nolock) where PROEMPCOD=0 and PROCOD=codigo) as embalagem
                   ,0 as qentrada
                   ,0 as ventrada
                   ,0 as custo
                   ,coalesce([1], 0) as E1
                   ,coalesce([2], 0) as E2
                   ,coalesce([3], 0) as E3
                   ,coalesce([4], 0) as E4
                   ,coalesce([5], 0) as E5
                   ,coalesce([6], 0) as E6
                   ,coalesce([7], 0) as E7
                   ,coalesce([8], 0) as E8
                   ,coalesce([9], 0) as E9
				       ,''
               from
               (
                 select SD.ESTDATSAL as data
                        ,SD.ESTLOC as estoque
                        ,SD.PROCOD as codigo
                        ,sum(SD.ESTQTDATU) as quantidade
                   from SALDODIARIO SD with (nolock)
                  where SD.ESTDATSAL=@datas
				            and isnull((select top 1 1
						                    from SALDOINICIAL SI with (nolock)
								             where SI.DATA=@dbusca
									                and SI.CODIGO=SD.PROCOD
								             order by SI.DATA, SI.CODIGO),0) = 0
                  group by SD.ESTDATSAL, SD.ESTLOC, SD.PROCOD
               ) linhas
            pivot (sum(quantidade) for estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9])) colunas

            set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)
         end
   end

-- otimizado com chatGPT

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SP_GravaSaldoInicial' AND type='P')
    DROP PROCEDURE [dbo].[SP_GravaSaldoInicial];
GO

CREATE PROCEDURE [dbo].[SP_GravaSaldoInicial]
    @datai DATE,   -- data inicial (primeiro mês a processar)
    @dataf DATE    -- data final   (último mês a processar)
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH UltimosSaldos AS
    (
        SELECT
            SD.PROCOD AS codigo,
            SD.ESTLOC AS estoque,
            SD.ESTDATSAL AS data_saldo,
            SD.ESTQTDATU AS quantidade,
            ROW_NUMBER() OVER (
                PARTITION BY SD.PROCOD, SD.ESTLOC, DATEADD(MONTH, DATEDIFF(MONTH,0,SD.ESTDATSAL),0)
                ORDER BY SD.ESTDATSAL DESC
            ) AS rn
        FROM SALDODIARIO SD WITH (NOLOCK)
        WHERE SD.ESTDATSAL >= DATEADD(MONTH, DATEDIFF(MONTH,0,@datai),0)  -- do 1º dia do mês inicial
          AND SD.ESTDATSAL <  DATEADD(DAY,1,EOMONTH(@dataf))              -- até o último dia do mês final
    ),
    SaldosMesAnterior AS
    (
        SELECT 
            DATEADD(DAY,1,EOMONTH(u.data_saldo)) AS data_inicial_mes, -- primeiro dia do mês seguinte
            CONVERT(CHAR(6), DATEADD(DAY,1,EOMONTH(u.data_saldo)),112) AS anomes,
            u.codigo,
            u.estoque,
            u.quantidade
        FROM UltimosSaldos u
        WHERE u.rn = 1   -- pega só o último registro de cada mês/produto/estoque
    ),
    SaldoParaInserir AS
    (
        SELECT
            s.data_inicial_mes AS [data],
            s.anomes,
            s.codigo,
            t.PROUM1 AS unidade,
            t.PROUM1QTD AS embalagem,
            0 AS qentrada,
            0 AS ventrada,
            0 AS custo,
            s.estoque,
            s.quantidade
        FROM SaldosMesAnterior s
        JOIN TBS010 t WITH (NOLOCK) ON t.PROEMPCOD = 0 AND t.PROCOD = s.codigo collate database_default
        LEFT JOIN SALDOINICIAL si WITH (NOLOCK) 
               ON si.DATA = s.data_inicial_mes 
              AND si.CODIGO = s.codigo
        WHERE si.DATA IS NULL  -- só insere se ainda não existir
    )
    INSERT INTO SALDOINICIAL 
        ([DATA], ANOMES, CODIGO, UNI, QEMBALAGEM, QTDENTRADA, VALENTRADA, CUSTO,
         E1, E2, E3, E4, E5, E6, E7, E8, E9, EMPRESA)
    SELECT
        [data],
        anomes,
        codigo,
        unidade,
        embalagem,
        qentrada,
        ventrada,
        custo,
        COALESCE([1],0),
        COALESCE([2],0),
        COALESCE([3],0),
        COALESCE([4],0),
        COALESCE([5],0),
        COALESCE([6],0),
        COALESCE([7],0),
        COALESCE([8],0),
        COALESCE([9],0),
        '' AS EMPRESA  -- ajuste aqui se precisar vincular empresa
    FROM
    (
        SELECT [data], anomes, estoque, codigo, quantidade, unidade, embalagem, qentrada, ventrada, custo
        FROM SaldoParaInserir
    ) s
    PIVOT
    (
        SUM(quantidade) FOR estoque IN ([1],[2],[3],[4],[5],[6],[7],[8],[9])
    ) pvt;

END
GO

-- fim otimização do chatGPT


-- nova otimização feita pelo chatGPT

begin tran
update SALDODIARIO
   set ESTDATSAL = '17530101'
 where ESTDATSAL is null

rollback tran
commit tran

begin tran
update SALDODIARIO
   set ESTLOC = 0
 where ESTLOC is null

rollback tran
commit tran

begin tran
update SALDODIARIO
   set PROCOD = ''
 where PROCOD is null

rollback tran
commit tran

begin tran
update SALDODIARIO
   set PRODES = ''
 where PRODES is null

rollback tran
commit tran

begin tran
update SALDODIARIO
   set PROSTATUS = ''
 where PROSTATUS is null

rollback tran
commit tran

begin tran
update SALDODIARIO
   set ESTDATALT = '17530101'
 where ESTDATALT is null

rollback tran
commit tran

begin tran
update SALDODIARIO
   set ESTQTDATU = 0 
 where ESTQTDATU is null

rollback tran
commit tran

begin tran
update SALDODIARIO
   set ESTQTDATU = 0 
 where ESTQTDATU is null

rollback tran
commit tran

begin tran
update SALDODIARIO
   set ESTQTDRES = 0 
 where ESTQTDRES is null

rollback tran
commit tran

begin tran
update SALDODIARIO
   set ESTQTDPEN = 0 
 where ESTQTDPEN is null

rollback tran
commit tran

begin tran
update SALDODIARIO
   set ESTQTDCMP = 0 
 where ESTQTDCMP is null

rollback tran
commit tran

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SP_GravaSaldoInicial' AND type='P')
    DROP PROCEDURE [dbo].[SP_GravaSaldoInicial];
GO

CREATE PROCEDURE [dbo].[SP_GravaSaldoInicial]
    @datai DATE,   -- data inicial (primeiro mês a processar)
    @dataf DATE    -- data final   (último mês a processar)
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH UltimosSaldos AS
    (
        SELECT
            SD.PROCOD AS codigo,
            SD.ESTLOC AS estoque,
            SD.ESTDATSAL AS data_saldo,
            SD.ESTQTDATU AS quantidade,
            ROW_NUMBER() OVER (
                PARTITION BY SD.PROCOD, SD.ESTLOC, DATEADD(MONTH, DATEDIFF(MONTH,0,SD.ESTDATSAL),0)
                ORDER BY SD.ESTDATSAL DESC
            ) AS rn
        FROM SALDODIARIO SD WITH (NOLOCK)
        WHERE SD.ESTDATSAL >= DATEADD(MONTH, DATEDIFF(MONTH,0,@datai),-1)  -- 1 mês antes da data inicial
          AND SD.ESTDATSAL <  DATEADD(DAY,1,EOMONTH(@dataf))               -- até o último dia do mês final
    ),
    -- Últimos saldos por mês
    SaldosMesAnterior AS
    (
        SELECT 
            DATEADD(DAY,1,EOMONTH(u.data_saldo)) AS data_inicial_mes, -- 1º dia do mês seguinte
            CONVERT(CHAR(6), DATEADD(DAY,1,EOMONTH(u.data_saldo)),112) AS anomes,
            u.codigo,
            u.estoque,
            u.quantidade
        FROM UltimosSaldos u
        WHERE u.rn = 1
    ),
    -- Tratamento para o mês inicial (@datai)
    SaldoInicial AS
    (
        SELECT 
            @datai AS data_inicial_mes,
            CONVERT(CHAR(6),@datai,112) AS anomes,
            t.PROCOD AS codigo,
            ISNULL(MAX(us.estoque),1) AS estoque,
            ISNULL(MAX(us.quantidade),0) AS quantidade
        FROM TBS010 t WITH (NOLOCK)
        LEFT JOIN (
            SELECT u.codigo, u.estoque, u.quantidade
            FROM UltimosSaldos u
            WHERE u.rn = 1
              AND u.data_saldo < @datai
        ) us ON us.codigo = t.PROCOD COLLATE database_default
        GROUP BY t.PROCOD
    ),
    -- União do saldo inicial com os demais meses
    SaldoParaInserir AS
    (
        SELECT
            s.data_inicial_mes AS data_ins,
            s.anomes,
            s.codigo,
            t.PROUM1 AS unidade,
            t.PROUM1QTD AS embalagem,
            0 AS qentrada,
            0 AS ventrada,
            0 AS custo,
            s.estoque,
            s.quantidade
        FROM (
            SELECT * FROM SaldosMesAnterior
            UNION ALL
            SELECT * FROM SaldoInicial
        ) s
        JOIN TBS010 t WITH (NOLOCK) 
             ON t.PROEMPCOD = 0 
            AND t.PROCOD = s.codigo COLLATE database_default
        LEFT JOIN dbo.SALDOINICIAL si WITH (nolock)
               ON si.[DATA] = s.data_inicial_mes 
              AND si.CODIGO = s.codigo
        WHERE si.[DATA] IS NULL
    )
    INSERT INTO dbo.SALDOINICIAL 
        ([DATA], ANOMES, CODIGO, UNI, QEMBALAGEM, QTDENTRADA, VALENTRADA, CUSTO,
         E1, E2, E3, E4, E5, E6, E7, E8, E9, EMPRESA)
    SELECT
        data_ins,
        anomes,
        codigo,
        unidade,
        embalagem,
        qentrada,
        ventrada,
        custo,
        COALESCE([1],0),
        COALESCE([2],0),
        COALESCE([3],0),
        COALESCE([4],0),
        COALESCE([5],0),
        COALESCE([6],0),
        COALESCE([7],0),
        COALESCE([8],0),
        COALESCE([9],0),
        '' AS EMPRESA
    FROM
    (
        SELECT data_ins, anomes, estoque, codigo, quantidade, unidade, embalagem, qentrada, ventrada, custo
        FROM SaldoParaInserir
    ) s
    PIVOT
    (
        SUM(quantidade) FOR estoque IN ([1],[2],[3],[4],[5],[6],[7],[8],[9])
    ) pvt;

END
GO

exec sp_help 'SALDOINICIAL'

-- fim da nova otimização

drop table SALDOINICIAL_BKP

select *
  into SALDOINICIAL_BKP
  from SALDOINICIAL with (nolock)

truncate table SALDOINICIAL

select max(ESTDATSAL)
  from SALDODIARIO with (nolock)

select max(DATA)
  from SALDOINICIAL with (nolock)
 where CUSTO > 0

select max(ANOMES)
  from SALDOINICIAL with (nolock)

-- data final deve ser o mes anterior ao mes que se deseja gravar o saldo inicial
begin tran
--exec dbo.SP_GravaSaldoInicial '20200901', '20210201'
exec dbo.SP_GravaSaldoInicial '20251001', '20260201'
commit tran
rollback tran

delete SALDOINICIAL
 where ANOMES='201909'



-- listagem para confer�ncia

declare @datai date, @dataf date, @datas date, @produto varchar(10)

set @datai='20190901'
set @dataf='20190930'
set @datas='17530101'
--set @produto=''

--      print @datai
--      set @datas=dateadd(ms, -3, dateadd(mm, datediff(mm, 0, @datai) + 1, 0))
--      print @datas
--      set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)
--      print @datai

while @datas < @dataf
   begin
      --declare @datas date

      set @datas='17530101'

      while @datas < @dataf
         begin
            -- �ltimo dia do m�s processado
            -- print DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, '20190501') + 1, 0)) -- 31/05/2019
            set @datas=DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, @datai) + 1, 0))

            print @datas

            -- �ltima data do saldo di�rio gravado no m�s processado
            -- select top 1 ESTDATSAL from SALDODIARIO with (nolock) where ESTDATSAL <= '20190531' order by ESTDATSAL desc -- 31/05/2019

            set @datas=(select top 1 ESTDATSAL
                          from SALDODIARIO with (nolock)
                         where ESTDATSAL <= @datas
                   order by ESTDATSAL desc)

            print @datas

            select convert(date, dateadd(mm, datediff(mm,0,data) + 1, 0)) data
                   ,convert(char(6), dateadd(mm, datediff(mm,0,data) + 1, 0), 112) anomes
                   ,codigo
                   ,(select PROUM1 from TBS010 with (nolock) where PROCOD=codigo) unidade
                   ,(select PROUM1QTD from TBS010 with (nolock) where PROCOD=codigo) embalagem
                   ,0 qentrada
                   ,0 ventrada
                   ,0 custo
                   ,coalesce([1], 0) as E1
                   ,coalesce([2], 0) as E2
                   ,coalesce([3], 0) as E3
                   ,coalesce([4], 0) as E4
                   ,coalesce([5], 0) as E5
                   ,coalesce([6], 0) as E6
                   ,coalesce([7], 0) as E7
                   ,coalesce([8], 0) as E8
                   ,coalesce([9], 0) as E9
              from
              (
                 select ESTDATSAL data
                        ,ESTLOC estoque
                        ,PROCOD codigo
                        ,sum(ESTQTDATU) quantidade
                   from SALDODIARIO with (nolock)
                  where ESTDATSAL=@datas
				        and isnull((select top 1 1
						              from SALDOINICIAL with (nolock)
									 where DATA= convert(date, dateadd(mm, datediff(mm,0,@datas) + 1, 0))
									       and CODIGO=PROCOD
								     order by DATA, PROCOD),0) = 0
                  group by ESTDATSAL, ESTLOC, PROCOD
                 having ESTDATSAL=@datas
              ) linhas
            pivot (sum(quantidade) for estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9])) colunas

            set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)
			
			print @datai
         end
   end

-- modificado para pegar os saldos da TBS032

insert into SALDOINICIAL
            select convert(date, dateadd(mm, datediff(mm,0,data) + 1, 0)) data
                   ,convert(char(6), dateadd(mm, datediff(mm,0,data) + 1, 0), 112) anomes
                   ,codigo
                   ,(select PROUM1 from TBS010 with (nolock) where PROCOD=codigo) unidade
                   ,(select PROUM1QTD from TBS010 with (nolock) where PROCOD=codigo) embalagem
                   ,0 qentrada
                   ,0 ventrada
                   ,0 custo
                   ,coalesce([1], 0) as E1
                   ,coalesce([2], 0) as E2
                   ,coalesce([3], 0) as E3
                   ,coalesce([4], 0) as E4
                   ,coalesce([5], 0) as E5
                   ,coalesce([6], 0) as E6
                   ,coalesce([7], 0) as E7
                   ,coalesce([8], 0) as E8
                   ,coalesce([9], 0) as E9
				   ,''
              from
              (
                 select '20191231' data
                        ,ESTLOC estoque
                        ,PROCOD codigo
                        ,sum(ESTQTDATU) quantidade
                   from TBS032 with (nolock)
                  where --ESTDATSAL=@datas
				        isnull((select top 1 1
						              from SALDOINICIAL with (nolock)
									 where DATA= convert(date, dateadd(mm, datediff(mm,0,'20191201') + 1, 0))
									       and CODIGO=PROCOD
								     order by DATA, PROCOD),0) = 0
                  group by ESTLOC, PROCOD
                 --having ESTDATSAL=@datas
              ) linhas
            pivot (sum(quantidade) for estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9])) colunas

select *
  from SALDOINICIAL with (nolock)
--delete SALDOINICIAL
 where E1=0 and E2=0 and E3=0 and E4=0 and E5=0 and E6=0 and E7=0 and E8=0 and E9=0 and QTDENTRADA=0

 select  sum(CUSTO * case when E1 > 0 then E1 else 0 end) S1
       ,sum(CUSTO * case when E2 > 0 then E2 else 0 end) S2
	   ,sum(CUSTO * case when E3 > 0 then E3 else 0 end) S3
	   ,sum(CUSTO * case when E4 > 0 then E4 else 0 end) S4
	   ,sum(CUSTO * case when E7 > 0 then E7 else 0 end) S7
	   ,sum(CUSTO * case when E9 > 0 then E9 else 0 end) S9
  from SALDOINICIAL with (nolock)
 where CUSTO > 0
       and ANOMES='202001'
	   and (E1 > 0 or E2 > 0 or E3 > 0 or E4 > 0 or E7 > 0 or E9 > 0)

select max(ANOMES)
  from SALDOINICIAL with (nolock)

select ANOMES
       ,count(*)
  from SALDOINICIAL with (nolock)
 where ANOMES >= '202201'
 group by ANOMES
 order by ANOMES

