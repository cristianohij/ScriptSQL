select * from INV01 with (nolock)
select top 3 * from INV02 with (nolock)
select top 10 * from INV03 with (nolock)


update INV01 set status='F'

--update INV03 set documento=0 
update INV03 set documento=20181116 where localEstoque=1

update INV03 set documento=20181116 where localEstoque=1

select * from TBS032 with (nolock) where ESTLOC=1 and (ESTQTDATU < 0 or ESTQTDRES > 0)

select * from TBS032 with (nolock) where ESTLOC=1 and ESTQTDATU < ESTQTDRES

select * from INV04 with (nolock)

select * from TBS049 with (nolock)
  where MDSTIP='S' and LESCOD=1 and MDSOBS='SALDO ZERADO P/INVENTARIO - RUA 29' and convert(date,MDSLAN,112)='20190401' and MDSUSU='INTEGROS'

insert into INV04 (localEstoque, codigoProduto, quantidade)
select LESCOD, PROCOD, MDSQTD 
  from TBS049 with (nolock)
 where MDSTIP='S' and LESCOD=1 and MDSOBS='SALDO ZERADO PARA INVENTARIO' and convert(date,MDSLAN,112)='20181117' and MDSUSU='INTEGROS'


select * from TBS032 with (nolock) where ESTLOC=1 and ESTQTDRES > ESTQTDATU

begin tran
update TBS032 set ESTQTDATU=ESTQTDRES where ESTLOC=1 and ESTQTDRES > ESTQTDATU
commit tran


----


drop function teste

CREATE FUNCTION teste(@local as smallint) returns table as
begin
--   begin
--      return
         SELECT codigoProduto into #tb 
           from INV03 with (nolock)
          where localEstoque = @local
   end
   return #tb
--end
go

select * from dbo.teste(2)


-- sequência numérica

drop function SequenciaNumerica

create function SequenciaNumerica(@inicio as int, @fim as int ) returns table as
begin

declare @inicio as int
set @inicio =1

select * from INV02 with (nolock)

WITH gerador (id) AS (
     SELECT 1
     UNION ALL
     SELECT id + 1
     FROM gerador
     WHERE id <= 63
  )
  insert into INV02 (endereco,ativado)
  SELECT right('00'+Ltrim(str(id,2)),2),'S' FROM gerador
  OPTION ( MAXRECURSION 0 )
GO


end
go


-- este funciona

drop procedure SequenciaNumerica

create procedure SequenciaNumerica(@inicio as int, @fim as int) as
   begin
      with gerador (id) as
      (
         select right('00'+Ltrim(str(@inicio,2)),2) as sequencia
         union all
         select right('00'+Ltrim(str(id + @inicio,2)),2)
           from gerador
          where id < @fim
      )
      --insert into INV02 (endereco) select right('00'+Ltrim(str(id,2)),2) from gerador;
      --insert into INV02 (endereco)
      --select right('00'+Ltrim(str(id,2)),2) as seq into #tab from gerador;
      select * from gerador;

      --return select * from gerador;
   end
go

drop procedure SequenciaNumerica

create table resultados_procedure (id smallint identity(1,1) primary key, empresa varchar(50), data_execucao datetime2)
go

declare @tab as table (seq varchar(3))

insert into @tab
execute dbo.SequenciaNumerica 1,53

select * from @tab

insert into INV02 (endereco,ativado)
select *,'S'  from @tab

--



/*
2 – Deseja-se uma tabela com os registros de todos os tempos possíveis em intervalos de minutos parametrizáveis entre duas datas quaisquer.

Como o problema requer o retorno de datas em intervalos de minutos, vamos criar uma tabela em nossa função com um campo do tipo DATETIME, utilizando a função built-in (função interna do SQL Server) DATEADD() para incrementar uma data inicial até a data final desejada em intervalos de minutos = MINUTE.
 
A – Tipo de função: Multi-statement table-valued function
*/
 
CREATE FUNCTION DtsMinutos(@min int, @dti datetime, @dtf datetime)
RETURNS @tbl TABLE(dt datetime)
AS
BEGIN
    WHILE @dti <= @dtf
    BEGIN
      INSERT INTO @tbl(dt) VALUES (@dti)
      SET @dti = DATEADD(MINUTE,@min,@dti)
    END      
    RETURN
END
 
-- B – Invocando uma Multi-statement table-valued function:

 
SELECT *
FROM   DtsMinutos(12,'2011-01-01 12:00','2011-01-01 17:00')


/*
3 – Deseja-se uma tabela com os FUNCIONÁRIOS contratados após uma data específica.
Para este problema vamos supor uma tabela povoada com três atributos: A matrícula do tipo int, o nome do tipo varchar(80)  e dataContratacao do tipo dateTime com a data que o funcionário foi contratado.
 
A – Tipo de função: Inline table-valued function
*/
 
CREATE FUNCTION funcionariosApos(@dt datetime)
RETURNS TABLE
AS
RETURN (SELECT *
        FROM  FUNCIONARIO
        WHERE dataContratacao >= @dt)
       

 

--B – Invocando uma Multi-statement table-valued function:
 

SELECT * FROM funcionariosApos('2000-01-01')

-----------

-- grava o saldo do estoque antes da contagem

drop procedure GravaEstoque

create procedure GravaEstoque(@local int, @doc int) as
   begin
      if (select top 1 INV04.documento from INV04 with (nolock) where INV04.documento=@doc and INV04.localEstoque=@local) > 0
         delete INV04 where INV04.documento=@doc and INV04.localEstoque=@local

      insert into INV04 (localEstoque, codigoProduto, quantidade, documento)
      select TBS032.ESTLOC, TBS032.PROCOD, TBS032.ESTQTDATU-TBS032.ESTQTDRES, @doc from TBS032 with (nolock) where ESTLOC=@local and ESTQTDATU != 0

      return @@rowcount
   end
go

exec dbo.GravaEstoque 2, 20181215

-- grava movimento interno

drop procedure SequencialTabela

create procedure SequencialTabela @tabela varchar(10), @sequencia int output as
   begin
      set nocount on;
      begin tran
         update TBS024 set TBSVALSEQ += 1 where TBSNOM=@tabela
         select @sequencia = TBSVALSEQ from TBS024 with (nolock) where TBSNOM=@tabela
      commit tran

      return
   end
go


declare @n int;

exec dbo.SequencialTabela 'TBS037', @sequencia = @n output;

select @n;

go


-- cria o cabeçalho do movimento interno de ENTRADA

declare @MVILOCDES smallint, @MVIOBS varchar(200), @MVIDOC int, @TMVCOD int, @CCSCOD int

exec dbo.SequencialTabela 'TBS037', @sequencia = @MVIDOC output

print 'Documento de entrada: ' + Ltrim(str(@MVIDOC,6))

set @TMVCOD = 3
set @CCSCOD = 41
set @MVILOCDES = 2
set @MVIOBS = 'LANÇAMENTO DO INVENTÁRIO (LOJA)'

insert into TBS037
  ( [MVIEMPCOD]
   ,[MVIDOC]
   ,[MVIDATLAN]
   ,[MVIDATEFE]
   ,[TMVCOD]
   ,[TMVEMPCOD]
   ,[CCSCOD]
   ,[CCSEMPCOD]
   ,[MVICCSCOD]
   ,[MVICCSNOM]
   ,[CLICOD]
   ,[CLIEMPCOD]
   ,[MVIEMPLES]
   ,[MVILOCORI]
   ,[MVILOCDES]
   ,[MVIULTITE]
   ,[MVIOBS])
select 0, -- MVIEMPCOD
       @MVIDOC, -- MVIDOC
       getdate(), -- MVIDATLAN
       '17530101', -- MVIDATEFE
       @TMVCOD, -- TMVCOD
       0, -- TMVEMPCOD
       @CCSCOD, -- CCSCOD
       0, -- CCSEMPCOD
       0, -- MVICCSCOD
       '', -- MVICCSNOM
       0, -- CLICOD
       0, -- CLIEMPCOD
       0, -- MVIEMPLES
       0, -- MVILOCORI
       @MVILOCDES, -- MVILOCDES
       0, -- MVIULTITE
       @MVIOBS -- MVIOBS


-- cria o cabeçalho do movimento interno de SAÍDA

declare @MVILOCORI smallint, @MVIOBS varchar(200), @MVIDOC int, @TMVCOD int, @CCSCOD int

exec dbo.SequencialTabela 'TBS037', @sequencia = @MVIDOC output

print 'Documento de saída: ' + Ltrim(str(@MVIDOC,6))

set @TMVCOD = 503
set @CCSCOD = 41
set @MVILOCORI = 2
set @MVIOBS = 'LANÇAMENTO DO INVENTÁRIO (LOJA)'

insert into TBS037
  ( [MVIEMPCOD]
   ,[MVIDOC]
   ,[MVIDATLAN]
   ,[MVIDATEFE]
   ,[TMVCOD]
   ,[TMVEMPCOD]
   ,[CCSCOD]
   ,[CCSEMPCOD]
   ,[MVICCSCOD]
   ,[MVICCSNOM]
   ,[CLICOD]
   ,[CLIEMPCOD]
   ,[MVIEMPLES]
   ,[MVILOCORI]
   ,[MVILOCDES]
   ,[MVIULTITE]
   ,[MVIOBS])
select 0, -- MVIEMPCOD
       @MVIDOC, -- MVIDOC
       getdate(), -- MVIDATLAN
       '17530101', -- MVIDATEFE
       @TMVCOD, -- TMVCOD
       0, -- TMVEMPCOD
       @CCSCOD, -- CCSCOD
       0, -- CCSEMPCOD
       0, -- MVICCSCOD
       '', -- MVICCSNOM
       0, -- CLICOD
       0, -- CLIEMPCOD
       0, -- MVIEMPLES
       @MVILOCORI, -- MVILOCORI
       0, -- MVILOCDES
       0, -- MVIULTITE
       @MVIOBS -- MVIOBS


-- tipo de movimentação para os lançamentos

--TMVEMPCOD TMVCOD TMVDES                         TMVTIP TMVDATCAD                                              TMVMOVAUT TMVINFCLI TMVINFTRA 

-- entrada
insert into TBS033 
select 0, 3, 'INVENTARIO ESTOQUE', 'E', '20181203', 'N', 'N', 'N'

-- saída

insert into TBS033 
select 0, 503, 'INVENTARIO ESTOQUE', 'S', '20181203', 'N', 'N', 'N'

drop procedure GravaCabecalhoMI
go

--create procedure GravaCabecalhoMI (@TMVTIP char(1), @MVIDOC int, @LOCAL smallint, @TMVCOD int, @CCSCOD int, @MVIOBS varchar(200)) as
create procedure GravaCabecalhoMI (@MVIDOC int, @LOCAL smallint, @TMVCOD int, @CCSCOD int, @MVIOBS varchar(200)) as
   begin
      set nocount on;

      declare @MVILOCDES smallint, @MVILOCORI smallint, @TMVTIP char(1)

      set @TMVTIP=(select TBS033.TMVTIP from TBS037 with (nolock) inner join TBS033 with (nolock) on TBS033.TMVCOD=TBS037.TMVCOD where TBS037.MVIDOC=@MVIDOC)


      if @TMVTIP = 'S'
         begin
            set @MVILOCORI = @LOCAL
            set @MVILOCDES = 0
         end
      else
         begin
            set @MVILOCDES = @LOCAL
            set @MVILOCORI = 0
         end

      insert into TBS037
         ( [MVIEMPCOD]
          ,[MVIDOC]
          ,[MVIDATLAN]
          ,[MVIDATEFE]
          ,[TMVCOD]
          ,[TMVEMPCOD]
          ,[CCSCOD]
          ,[CCSEMPCOD]
          ,[MVICCSCOD]
          ,[MVICCSNOM]
          ,[CLICOD]
          ,[CLIEMPCOD]
          ,[MVIEMPLES]
          ,[MVILOCORI]
          ,[MVILOCDES]
          ,[MVIULTITE]
		  ,[MVITRM]
          ,[MVIOBS])
      select 0 -- MVIEMPCOD
             ,@MVIDOC -- MVIDOC
             ,getdate() -- MVIDATLAN
             ,'17530101' -- MVIDATEFE
             ,@TMVCOD -- TMVCOD
             ,0 -- TMVEMPCOD
             ,@CCSCOD -- CCSCOD
             ,0 -- CCSEMPCOD
             ,0 -- MVICCSCOD
             ,'' -- MVICCSNOM
             ,0 -- CLICOD
             ,0 -- CLIEMPCOD
             ,0 -- MVIEMPLES
             ,@MVILOCORI -- MVILOCORI
             ,@MVILOCDES -- MVILOCDES
             ,0 -- MVIULTITE
			 ,0
             ,@MVIOBS -- MVIOBS
   end
go

declare @MVIDOC int

exec dbo.SequencialTabela 'TBS037', @sequencia = @MVIDOC output

-- assinatura: GravaCabecalhoMI (@MVIDOC int, @LOCAL smallint, @TMVCOD int, @CCSCOD int, @MVIOBS varchar(200))

-- movimento de entrada
exec dbo.GravaCabecalhoMI @MVIDOC, 1, 5, 47, 'INVENTÁRIO'

-- movimento de saída
--exec dbo.GravaCabecalhoMI @MVIDOC, 1, 503, 47, 'INVENTÁRIO'

-- assinatura: GravaItemMI (@MVIDOC int, @LOCAL smallint, @doc int)

exec dbo.GravaItemMI @MVIDOC, 1, 20200413

print 'Documento: ' + Ltrim(str(@MVIDOC,6))

commit tran
rollback tran

select * from TBS037 with (nolock) where MVIDOC in(26370,26371)

update TBS037 set MVILOCORI=1, MVILOCDES=0 where MVIDOC=48260

delete TBS0371 where MVIDOC=139986
delete TBS037 where MVIDOC=139986

select count(*) from TBS0371 with (nolock) where MVIDOC=139986

-- zerar não encontrados

declare @MVIDOC int

exec dbo.SequencialTabela 'TBS037', @sequencia = @MVIDOC output

-- assinatura: GravaCabecalhoMI (@MVIDOC int, @LOCAL smallint, @TMVCOD int, @CCSCOD int, @MVIOBS varchar(200))

-- movimento de entrada
--exec dbo.GravaCabecalhoMI @MVIDOC, 1, 5, 47, 'PRODUTOS NÃO ENCONTRADOS NO INVENTÁRIO'

-- movimento de saída
exec dbo.GravaCabecalhoMI @MVIDOC, 1, 503, 47, 'PRODUTOS NÃO ENCONTRADOS NO INVENTÁRIO'

-- assinatura: ZerarNaoEncontrados (@MVIDOC int, @LOCAL smallint, @doc int)

exec dbo.ZerarNaoEncontrados @MVIDOC, 1, 20200413

print 'Documento: ' + Ltrim(str(@MVIDOC,6))

update TBS037 set MVILOCORI=1, MVILOCDES=0 where MVIDOC=48264

-- zerar itens divergentes se não forem corrigidos no mesmo dia

declare @MVIDOC int

exec dbo.SequencialTabela 'TBS037', @sequencia = @MVIDOC output

-- movimento de entrada
--exec dbo.GravaCabecalhoMI @MVIDOC, 1, 4, 24, 'PRODUTOS DIVERGENTES NO INVENTÁRIO CONTAGEM 1 E 2'

-- movimento de saída
exec dbo.GravaCabecalhoMI @MVIDOC, 1, 503, 24, 'PRODUTOS DIVERGENTES NO INVENTÁRIO CONTAGEM 1 E 2'

exec dbo.ZerarDivergentes @MVIDOC, 1, 20181226

print 'Documento: ' + Ltrim(str(@MVIDOC,6))


-- grava tabela para lançamento do estoque

select distinct documento from INV05 with (nolock)

drop procedure dbo.LancarInventario
go

select top 1 * from INV03 with (nolock)
select top 1 * from INV05 with (nolock)
go

create procedure LancarInventario (@doc int, @contagem smallint, @local smallint, @rua char(2)) as
   begin
      -- insere produtos coletados
      insert into INV05 (codigoProduto, documento, localEstoque)
         select codigoProduto, @doc, @local
           from INV03 with (nolock)
          where documento=@doc
                and numeroContagem=@contagem
                and localEstoque=@local
                and not exists(select ''
                                 from INV05 with (nolock)
                                where INV05.documento=@doc
                                      and INV05.localEstoque=@local
                                      and INV05.codigoProduto=INV03.codigoProduto)
				and endereco=@rua
          group by codigoProduto;

      -- atualiza quantidade coletada
      if @contagem=1
         update INV05
            set c1=isnull((select sum(quantidade)
                             from INV03 with (nolock)
                            where documento=@doc
                                  and numeroContagem=@contagem
                                  and localEstoque=@local
                                  and INV03.codigoProduto=INV05.codigoProduto),0)
          where INV05.documento=@doc
                and INV05.localEstoque=@local;

      if @contagem=2
         update INV05
            set c2=isnull((select sum(quantidade)
                             from INV03 with (nolock)
                            where documento=@doc
                                  and numeroContagem=@contagem
                                  and localEstoque=@local
                                  and INV03.codigoProduto=INV05.codigoProduto),0)
          where INV05.documento=@doc
                and INV05.localEstoque=@local;

      if @contagem=3
         update INV05
            set c3=isnull((select sum(quantidade)
                             from INV03 with (nolock)
                            where documento=@doc
                                  and numeroContagem=@contagem
                                  and localEstoque=@local
                                  and INV03.codigoProduto=INV05.codigoProduto),0)
          where INV05.documento=@doc
                and INV05.localEstoque=@local;

      if @contagem=4
         update INV05
            set c4=isnull((select sum(quantidade)
                             from INV03 with (nolock)
                            where documento=@doc
                                  and numeroContagem=@contagem
                                  and localEstoque=@local
                                  and INV03.codigoProduto=INV05.codigoProduto),0)
          where INV05.documento=@doc
                and INV05.localEstoque=@local;

      if @contagem=5
         update INV05
            set c5=isnull((select sum(quantidade)
                             from INV03 with (nolock)
                            where documento=@doc
                                  and numeroContagem=@contagem
                                  and localEstoque=@local
                                  and INV03.codigoProduto=INV05.codigoProduto),0)
          where INV05.documento=@doc
                and INV05.localEstoque=@local;

      if @contagem=6
         update INV05
            set c6=isnull((select sum(quantidade)
                             from INV03 with (nolock)
                            where documento=@doc
                                  and numeroContagem=@contagem
                                  and localEstoque=@local
                                  and INV03.codigoProduto=INV05.codigoProduto),0)
          where INV05.documento=@doc
                and INV05.localEstoque=@local;
   end
go

delete INV05

exec dbo.LancarInventario 20200413, 1

-- backup
select * into INV05BKP02122018 from INV05 with (nolock)

update INV05 set saldoEfetivo=0

-- gravar itens no movimento interno para lançamento do estoque

drop procedure GravaItemMI
go

--create procedure GravaItemMI (@TMVTIP char(1), @MVIDOC int, @LOCAL smallint) as
create procedure GravaItemMI (@MVIDOC int, @LOCAL smallint, @doc int) as
   begin
      set nocount on;

      declare @TMVTIP char(1)

      set @TMVTIP=(select TBS033.TMVTIP from TBS037 with (nolock) inner join TBS033 with (nolock) on TBS033.TMVCOD=TBS037.TMVCOD where TBS037.MVIDOC=@MVIDOC);

      if @TMVTIP = 'E'
         begin
            insert into TBS0371
               ( [MVIEMPCOD]
                ,[MVIDOC]
                ,[MVIITE]
                ,[PROCOD]
                ,[PROEMPCOD]
                ,[MVIPROUNI]
                ,[MVIQTDPED]
                ,[MVIQTDATD]
                ,[MVIQTDEMB]
                ,[MVIPRODES]
                ,[MVIPROLOT] )
            select 0, -- MVIEMPCOD
                   @MVIDOC, -- MVIDOC
                   row_number() over(order by INV05.codigoProduto), -- MVIITE
                   codigoProduto, -- PROCOD
                   0, -- PROEMPCOD
                   (select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=INV05.codigoProduto), -- MVIPROUNI
                   saldoEfetivo, -- MVIQTDPED
                   saldoEfetivo, -- MVIQTDATD
                   1, -- MVIQTDEMB
                   (select PRODES from TBS010 with (nolock) where TBS010.PROCOD=INV05.codigoProduto), -- MVIPRODES
                   '' -- MVIPROLOT
              from INV05 with (nolock)
             where documento=@doc and saldoEfetivo > 0;
         end
      else
         begin
            insert into TBS0371
               ( [MVIEMPCOD]
                ,[MVIDOC]
                ,[MVIITE]
                ,[PROCOD]
                ,[PROEMPCOD]
                ,[MVIPROUNI]
                ,[MVIQTDPED]
                ,[MVIQTDATD]
                ,[MVIQTDEMB]
                ,[MVIPRODES]
                ,[MVIPROLOT] )
            select 0, -- MVIEMPCOD
                   @MVIDOC, -- MVIDOC
                   row_number() over(order by INV05.codigoProduto), -- MVIITE
                   codigoProduto, -- PROCOD
                   0, -- PROEMPCOD
                   (select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=INV05.codigoProduto), -- MVIPROUNI
                   saldoEfetivo*(-1), -- MVIQTDPED
                   saldoEfetivo*(-1), -- MVIQTDATD
                   1, -- MVIQTDEMB
                   (select PRODES from TBS010 with (nolock) where TBS010.PROCOD=INV05.codigoProduto), -- MVIPRODES
                   '' -- MVIPROLOT
              from INV05 with (nolock)
             where documento=@doc and saldoEfetivo < 0;
         end

      update TBS037 set MVIULTITE=(select max(TBS0371.MVIITE) from TBS0371 with (nolock) where TBS0371.MVIDOC=TBS037.MVIDOC) where MVIDOC=@MVIDOC;
   end
go

exec dbo.GravaItemMI 56193, 2

-- zerar itens não encontrados no inventário: rodar após os saldos ajustados

drop procedure ZerarNaoEncontrados
go

create procedure ZerarNaoEncontrados (@MVIDOC int, @LOCAL smallint, @doc int) as
   begin
      set nocount on;

      declare @TMVTIP char(1)

      set @TMVTIP=(select TBS033.TMVTIP from TBS037 with (nolock) inner join TBS033 with (nolock) on TBS033.TMVCOD=TBS037.TMVCOD where TBS037.MVIDOC=@MVIDOC);

      if @TMVTIP = 'E'
         begin
            insert into TBS0371
               ( [MVIEMPCOD]
                ,[MVIDOC]
                ,[MVIITE]
                ,[PROCOD]
                ,[PROEMPCOD]
                ,[MVIPROUNI]
                ,[MVIQTDPED]
                ,[MVIQTDATD]
                ,[MVIQTDEMB]
                ,[MVIPRODES]
                ,[MVIPROLOT] )
            select 0,
                   @MVIDOC, -- MVIDOC
                   row_number() over(order by TBS032.PROCOD), -- MVIITE
                   TBS032.PROCOD,  -- PROCOD
                   0, -- PROEMPCOD
                   (select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=TBS032.PROCOD), -- MVIPROUNI
                   TBS032.ESTQTDATU*(-1), -- MVIQTDPED
                   TBS032.ESTQTDATU*(-1), -- MVIQTDATD
                   1, -- MVIQTDEMB
                   (select PRODES from TBS010 with (nolock) where TBS010.PROCOD=TBS032.PROCOD), -- MVIPRODES
                   '' -- MVIPROLOT
              from TBS032 with (nolock)
			       inner join INV04 with (nolock)
				   on localEstoque=@LOCAL and documento=@doc and codigoProduto=TBS032.PROCOD
             where TBS032.ESTLOC=@LOCAL and TBS032.ESTQTDATU < 0
                   and not exists(select '' from INV05 with (nolock) where localEstoque=@LOCAL and documento=@doc and codigoProduto=TBS032.PROCOD);
         end
      else
         begin
            insert into TBS0371
               ( [MVIEMPCOD]
                ,[MVIDOC]
                ,[MVIITE]
                ,[PROCOD]
                ,[PROEMPCOD]
                ,[MVIPROUNI]
                ,[MVIQTDPED]
                ,[MVIQTDATD]
                ,[MVIQTDEMB]
                ,[MVIPRODES]
                ,[MVIPROLOT] )
            select 0,
                   @MVIDOC, -- MVIDOC
                   row_number() over(order by TBS032.PROCOD), -- MVIITE
                   TBS032.PROCOD,  -- PROCOD
                   0, -- PROEMPCOD
                   (select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=TBS032.PROCOD), -- MVIPROUNI
                   TBS032.ESTQTDATU, -- MVIQTDPED
                   TBS032.ESTQTDATU, -- MVIQTDATD
                   1, -- MVIQTDEMB
                   (select PRODES from TBS010 with (nolock) where TBS010.PROCOD=TBS032.PROCOD), -- MVIPRODES
                   '' -- MVIPROLOT
              from TBS032 with (nolock)
			       inner join INV04 with (nolock)
				   on localEstoque=@LOCAL and documento=@doc and codigoProduto=TBS032.PROCOD
             where TBS032.ESTLOC=@LOCAL and TBS032.ESTQTDATU > 0
                   and not exists(select '' from INV05 with (nolock) where localEstoque=@LOCAL and documento=@doc and codigoProduto=TBS032.PROCOD);
         end

      update TBS037 set MVIULTITE=(select max(TBS0371.MVIITE) from TBS0371 with (nolock) where TBS0371.MVIDOC=TBS037.MVIDOC) where MVIDOC=@MVIDOC;
   end
go


-- zerar itens divergentes se não forem corrigidos no mesmo dia

drop procedure ZerarDivergentes

create procedure ZerarDivergentes (@MVIDOC int, @LOCAL smallint, @doc int) as
   begin
      set nocount on;

      declare @TMVTIP char(1)

      set @TMVTIP=(select TBS033.TMVTIP from TBS037 with (nolock) inner join TBS033 with (nolock) on TBS033.TMVCOD=TBS037.TMVCOD where TBS037.MVIDOC=@MVIDOC);

      if @TMVTIP = 'E'
         begin
            insert into TBS0371
               ( [MVIEMPCOD]
                ,[MVIDOC]
                ,[MVIITE]
                ,[PROCOD]
                ,[PROEMPCOD]
                ,[MVIPROUNI]
                ,[MVIQTDPED]
                ,[MVIQTDATD]
                ,[MVIQTDEMB]
                ,[MVIPRODES]
                ,[MVIPROLOT] )
            select 0,
                   @MVIDOC, -- MVIDOC
                   row_number() over(order by TBS032.PROCOD), -- MVIITE
                   TBS032.PROCOD,  -- PROCOD
                   0, -- PROEMPCOD
                   (select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=TBS032.PROCOD), -- MVIPROUNI
                   TBS032.ESTQTDATU*(-1), -- MVIQTDPED
                   TBS032.ESTQTDATU*(-1), -- MVIQTDATD
                   1, -- MVIQTDEMB
                   (select PRODES from TBS010 with (nolock) where TBS010.PROCOD=TBS032.PROCOD), -- MVIPRODES
                   '' -- MVIPROLOT
              from TBS032 with (nolock)
             where TBS032.ESTLOC=@LOCAL and TBS032.ESTQTDATU < 0
                   and exists(select '' from INV05 with (nolock) where documento=@doc and localEstoque=@LOCAL and codigoProduto=PROCOD and c1<>c2);
         end
      else
         begin
            insert into TBS0371
               ( [MVIEMPCOD]
                ,[MVIDOC]
                ,[MVIITE]
                ,[PROCOD]
                ,[PROEMPCOD]
                ,[MVIPROUNI]
                ,[MVIQTDPED]
                ,[MVIQTDATD]
                ,[MVIQTDEMB]
                ,[MVIPRODES]
                ,[MVIPROLOT] )
            select 0,
                   @MVIDOC, -- MVIDOC
                   row_number() over(order by TBS032.PROCOD), -- MVIITE
                   TBS032.PROCOD,  -- PROCOD
                   0, -- PROEMPCOD
                   (select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=TBS032.PROCOD), -- MVIPROUNI
                   TBS032.ESTQTDATU, -- MVIQTDPED
                   TBS032.ESTQTDATU, -- MVIQTDATD
                   1, -- MVIQTDEMB
                   (select PRODES from TBS010 with (nolock) where TBS010.PROCOD=TBS032.PROCOD), -- MVIPRODES
                   '' -- MVIPROLOT
              from TBS032 with (nolock)
             where TBS032.ESTLOC=@LOCAL and TBS032.ESTQTDATU > 0
                   and exists(select '' from INV05 with (nolock) where documento=@doc and localEstoque=@LOCAL and codigoProduto=PROCOD and c1<>c2);
         end

      update TBS037 set MVIULTITE=(select max(TBS0371.MVIITE) from TBS0371 with (nolock) where TBS0371.MVIDOC=TBS037.MVIDOC) where MVIDOC=@MVIDOC;
   end
go

-- zerar itens inventariados (somente os itens contados INV05)

drop procedure ZerarProdutosContados

create procedure ZerarProdutosContados (@MVIDOC int, @LOCAL smallint, @doc int) as
   begin
      set nocount on;

      declare @TMVTIP char(1)

      set @TMVTIP=(select TBS033.TMVTIP
                     from TBS037 with (nolock)
                          inner join TBS033 with (nolock)
                          on TBS033.TMVCOD=TBS037.TMVCOD
                    where TBS037.MVIDOC=@MVIDOC);

      if @TMVTIP = 'E'
         begin
            insert into TBS0371
            ( [MVIEMPCOD]
             ,[MVIDOC]
             ,[MVIITE]
             ,[PROCOD]
             ,[PROEMPCOD]
             ,[MVIPROUNI]
             ,[MVIQTDPED]
             ,[MVIQTDATD]
             ,[MVIQTDEMB]
             ,[MVIPRODES]
             ,[MVIPROLOT] )
            select 0
                   ,@MVIDOC -- MVIDOC
                   ,row_number() over(order by INV05.codigoProduto) -- MVIITE
                   ,INV05.codigoProduto -- PROCOD
                   ,0 -- PROEMPCOD
                   ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=INV05.codigoProduto) -- MVIPROUNI
                   ,(TBS032.ESTQTDATU - TBS032.ESTQTDRES) * (-1) -- MVIQTDPED
                   ,(TBS032.ESTQTDATU - TBS032.ESTQTDRES) * (-1) -- MVIQTDATD
                   ,1 -- MVIQTDEMB
                   ,(select PRODES from TBS010 with (nolock) where TBS010.PROCOD=INV05.codigoProduto) -- MVIPRODES
                   ,'' -- MVIPROLOT
              from INV05 with (nolock)
                   inner join TBS032 with (nolock)
                   on TBS032.ESTLOC=INV05.localEstoque
                      and TBS032.PROCOD=INV05.codigoProduto
             where INV05.documento=@doc
                   and INV05.localEstoque=@LOCAL
                   and TBS032.ESTQTDATU - TBS032.ESTQTDRES < 0
         end
      else
         begin
            insert into TBS0371
            ( [MVIEMPCOD]
             ,[MVIDOC]
             ,[MVIITE]
             ,[PROCOD]
             ,[PROEMPCOD]
             ,[MVIPROUNI]
             ,[MVIQTDPED]
             ,[MVIQTDATD]
             ,[MVIQTDEMB]
             ,[MVIPRODES]
             ,[MVIPROLOT] )
            select 0
                   ,@MVIDOC -- MVIDOC
                   ,row_number() over(order by INV05.codigoProduto) -- MVIITE
                   ,INV05.codigoProduto -- PROCOD
                   ,0 -- PROEMPCOD
                   ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=INV05.codigoProduto) -- MVIPROUNI
                   ,TBS032.ESTQTDATU - TBS032.ESTQTDRES -- MVIQTDPED
                   ,TBS032.ESTQTDATU - TBS032.ESTQTDRES -- MVIQTDATD
                   ,1 -- MVIQTDEMB
                   ,(select PRODES from TBS010 with (nolock) where TBS010.PROCOD=INV05.codigoProduto) -- MVIPRODES
                   ,'' -- MVIPROLOT
              from INV05 with (nolock)
                   inner join TBS032 with (nolock)
                   on TBS032.ESTLOC=INV05.localEstoque
                      and TBS032.PROCOD=INV05.codigoProduto
             where INV05.documento=@doc
                   and INV05.localEstoque=@LOCAL
                   and TBS032.ESTQTDATU - TBS032.ESTQTDRES > 0
         end

      update TBS037 set MVIULTITE=(select max(TBS0371.MVIITE) from TBS0371 with (nolock) where TBS0371.MVIDOC=TBS037.MVIDOC) where MVIDOC=@MVIDOC;
   end
go

-- listagem dia 25/11/18

select * from INV05 with (nolock)

select * from INV05 with (nolock) where c1+c2=0

select * from INV05 with (nolock) where c1=c2 and saldoEfetivo > 0

select * from INV05 with (nolock) where c1!=c2 and (c1=saldoAnterior or c2=saldoAnterior)

select * from INV05 with (nolock) where saldoEfetivo > 0

update INV05 set e1='',e2='',e3='',e4='',e5=''

select * from INV03 with (nolock)

update INV05 set documento=20181124, lancar=0

select * from INV05 with (nolock) where c1 != c2 and c2 > 0 and e1='05'

select * from INV05 with (nolock) where c1 != c2 and e1='05'

select * from INV05 with (nolock) where c1 != c2 --and e1='03'
and e1 in('01','02','03','04','05','06','13','14','15','16','21','23','24','25','31')

-- lista endereços

drop table #endereco

SELECT codigoProduto,endereco,
  ROW_NUMBER() OVER(partition by codigoProduto ORDER BY codigoProduto,endereco) AS Row#
  into #endereco
FROM INV03 where localEstoque=2
group by codigoProduto,endereco

select * from #endereco



-- grava endereços

update INV05 set e1=isnull((select endereco from #endereco where #endereco.codigoProduto=INV05.codigoProduto and Row#=1),'')

update INV05 set e2=isnull((select endereco from #endereco where #endereco.codigoProduto=INV05.codigoProduto and Row#=2),'')

update INV05 set e3=isnull((select endereco from #endereco where #endereco.codigoProduto=INV05.codigoProduto and Row#=3),'')

update INV05 set e3=isnull((select endereco from #endereco where #endereco.codigoProduto=INV05.codigoProduto and Row#=3),'')

update INV05 set e3=isnull((select endereco from #endereco where #endereco.codigoProduto=INV05.codigoProduto and Row#=3),'')


drop procedure EnderecoContagem

create procedure EnderecoContagem(@doc int, @local int) as
   begin
      with tab as
      (
         select documento, localEstoque, endereco, codigoProduto, row_number() over(partition by codigoProduto order by codigoProduto,endereco) as row#
           from INV03 with (nolock) where documento=@doc and localEstoque=@local
          group by documento, localEstoque, codigoProduto,endereco
      )

      update INV05
         set  e1=isnull((select endereco from tab where tab.documento=INV05.documento and tab.localEstoque=INV05.localEstoque and tab.codigoProduto=INV05.codigoProduto and row#=1),'')
             ,e2=isnull((select endereco from tab where tab.documento=INV05.documento and tab.localEstoque=INV05.localEstoque and tab.codigoProduto=INV05.codigoProduto and row#=2),'')
             ,e3=isnull((select endereco from tab where tab.documento=INV05.documento and tab.localEstoque=INV05.localEstoque and tab.codigoProduto=INV05.codigoProduto and row#=3),'')
             ,e4=isnull((select endereco from tab where tab.documento=INV05.documento and tab.localEstoque=INV05.localEstoque and tab.codigoProduto=INV05.codigoProduto and row#=4),'')
             ,e5=isnull((select endereco from tab where tab.documento=INV05.documento and tab.localEstoque=INV05.localEstoque and tab.codigoProduto=INV05.codigoProduto and row#=5),'')
   end
go

exec EnderecoContagem 20181226, 1

update INV05 set e1='', e2='', e3='', e4='', e5=''
 
-- listagem divergente

select codigoProduto from INV03 group by codigoProduto -- 6.459

select * from INV05 with (nolock) 

select codigoProduto,
       (select PRODES from TBS010 with (nolock) where PROCOD=codigoProduto),
       (select top 1 marca from INV03 with (nolock) where INV03.codigoProduto=INV05.codigoProduto),
       (select top 1 embalagem from INV03 with (nolock) where INV03.codigoProduto=INV05.codigoProduto),
       rtrim(e1)+', '+rtrim(e2)+', '+rtrim(e3)+', '+rtrim(e4)+', '+rtrim(e5)
  from INV05 with (nolock) where c1<>c2 -- 878
       --and exists(select '' from TBS032 with (nolock) where ESTLOC=2 and PROCOD=codigoProduto and ESTQTDATU<>0)
       and codigoProduto in
('0063215',
'0065110',
'0071595',
'0072656',
'0074055',
'0090671',
'0090868',
'0090949',
'0110086',
'0123633',
'0123676',
'0123757',
'0410039',
'0630208',
'0630237',
'0630249',
'0631936',
'1080504',
'1330011',
'1533614',
'1672771',
'1744623',
'1744721',
'1864697',
'2170007',
'2600056',
'2814127',
'2860014',
'2860127',
'3263283',
'3790495',
'3794659',
'4230043',
'4230108',
'4230301',
'4480003',
'4520642',
'4911652',
'4911660',
'4911890',
'4950980',
'5300976',
'5620228',
'5630004',
'5630064',
'6130283',
'6480005',
'6480764',
'6482032',
'6520472',
'6523000',
'6523001',
'6533641',
'6533657',
'6590527',
'6590535',
'6590543',
'6590560',
'7300001',
'7300002',
'7300405',
'7300407',
'7300408',
'7300470',
'7301250',
'7305427',
'7344292',
'7346867',
'7600051',
'7600313',
'7600712',
'7600828',
'7600941',
'7886314',
'7886330',
'8412162',
'8412189',
'8412197',
'8420421',
'8490015',
'8490112',
'8490333',
'8770066',
'9840079',
'13710008',
'18990138',
'18990139',
'18990227',
'25470001',
'25470031',
'25580002')

 order by e1,id

select codigoProduto,
       (select PRODES from TBS010 with (nolock) where PROCOD=codigoProduto),
       (select top 1 marca from INV03 with (nolock) where INV03.codigoProduto=INV05.codigoProduto),
       (select top 1 embalagem from INV03 with (nolock) where INV03.codigoProduto=INV05.codigoProduto),
       rtrim(e1)+', '+rtrim(e2)+', '+rtrim(e3)+', '+rtrim(e4)+', '+rtrim(e5)

 from INV05 with (nolock) where c1=c2 -- 5.581


-- backup

select * into TBS032BKP from TBS032 with (nolock)

select * into TBS037BKP from TBS037 with (nolock)

select * into TBS0371BKP from TBS0371 with (nolock)


-- conferências

select * from INV03 with (nolock) where codigoProduto='1741756'

select count(*) from INV03 with (nolock) group by codigoProduto

select * from INV03 with (nolock) where documento=0

update INV03 set documento=20181124 where documento=0


select * from INV05 -- 6.459

select count(*) from INV05 -- 6.459

select codigoProduto from INV03 with (nolock) where localEstoque=2 group by codigoProduto -- 6.459

select codigoProduto from INV05 with (nolock) where documento=20181130 and localEstoque=1 and c1 != c2 -- 878

select * from INV05 with (nolock) where c1 <> c2 -- 878

select * from INV05 with (nolock) where c1=c2 -- 5.581

select * from INV05 with (nolock) where c1=c2 and c1=saldoAnterior -- 2.933

select * from INV05 with (nolock) where c1 is null or c2 is null

select * from INV05 with (nolock) where codigoProduto='0327228'

select * from INV03 with (nolock) where codigoProduto='0327228'

select * from INV04 with (nolock) where codigoProduto='0327228'

select * from TBS032 with (nolock) where ESTLOC=1 and ESTQTDATU < 0

select * from TBS032 with (nolock) where ESTLOC=1 and ESTQTDRES > 0

select * from INV05 with (nolock) where c1=c2 and lancar > 0

and not exists(select '' from INV04 with (nolock) where codigoProduto=PROCOD and quantidade=ESTQTDATU)

---

-- movimentos internos lançados

select * from TBS037 with (nolock) where TMVCOD in(3,503) order by MVIDOC, TMVCOD

select * from TBS033 with (nolock)

select TBS033.TMVTIP
  from TBS037 with (nolock)
       inner join TBS033 with (nolock) on TBS033.TMVCOD=TBS037.TMVCOD
 where MVIDOC=26179

-- entrada
select * from TBS037 with (nolock) where MVIDOC=56199

select * from TBS0371 with (nolock) where MVIDOC=56199 order by MVIITE -- 1.117

-- saída
select * from TBS037 with (nolock) where MVIDOC=56200

select * from TBS0371 with (nolock) where MVIDOC=56200 order by MVIITE -- 1.531

update TBS037 set MVILOCORI=2, MVILOCDES=0 where MVIDOC=56200

-- total 2.648

-- zerar não encontrados

-- entrada
select * from TBS037 with (nolock) where MVIDOC=56201

select * from TBS0371 with (nolock) where MVIDOC=56201 order by MVIITE -- 583

-- saída
select * from TBS037 with (nolock) where MVIDOC=56202


-- zerar divergentes

-- entrada
select * from TBS037 with (nolock) where MVIDOC=56203

select * from TBS0371 with (nolock) where MVIDOC=56203 order by MVIITE -- 50

-- saída
select * from TBS037 with (nolock) where MVIDOC=56204

select * from TBS0371 with (nolock) where MVIDOC=56204 order by MVIITE -- 768



update TBS037 set MVILOCORI=2, MVILOCDES=0 where MVIDOC=56204

select * from TBS0371 with (nolock) where MVIDOC=56200 and MVIQTDPED<=0 order by MVIITE

update TBS037 set MVIULTITE=683 where MVIDOC=56193

delete TBS0371 where MVIDOC=56198
delete TBS037 where MVIDOC=56198

-- grava a descrição do produto na INV05

update INV05 set descricaoProduto=(select PRODES from TBS010 with (nolock) where PROCOD=codigoProduto)

select * from INV05 with (nolock) where descricaoProduto is null

select documento,localEstoque,count(*) from INV03 with (nolock) group by documento,localEstoque

select documento,count(*) from INV03 with (nolock) group by documento

update INV03 set documento=20181130 where documento=0

select idColetor,count(*) qtde_coletas from INV03 with (nolock) where documento=20181130 group by idColetor order by idColetor

select * from INV03 with (nolock) where lancar <> 0

-- orderm rua + sequência da coleta

select (select top 1 id from INV03 with (nolock)
         where INV03.documento=INV05.documento and INV03.localEstoque=INV05.localEstoque and INV03.codigoProduto=INV05.codigoProduto order by endereco,id) as seq
       --,*
  from INV05 with (nolock)
 where documento=20181226 and localEstoque=1 and c1<>c2
 order by e1,seq

update INV05 set sequenciaColeta=0 where sequenciaColeta is null


update INV05
   set sequenciaColeta=(select (select top 1 id from INV03 with (nolock)
                         where INV03.documento=INV05.documento and INV03.localEstoque=INV05.localEstoque and INV03.codigoProduto=INV05.codigoProduto order by endereco,id))
 where documento=20181130 and localEstoque=1 and c1<>c2




-- 01/12/2018

-- grava tabela para lançamento do estoque
/*
drop procedure dbo.LancarInventario

create procedure LancarInventario (@doc int, @local smallint) as	
   begin
      insert into INV05 (codigoProduto, documento, localEstoque)
         select codigoProduto, @doc, @local
           from INV03 with (nolock)
          where documento=@doc and localEstoque=@local
                and not exists(select '' from INV05 with (nolock)
                                where INV05.documento=@doc and INV05.localEstoque=@local and INV05.codigoProduto=INV03.codigoProduto)
          group by codigoProduto;

      if @@rowcount > 0
         begin
            update INV05 set c1=isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=1 and localEstoque=@local and INV03.codigoProduto=INV05.codigoProduto),0)
             where INV05.documento=@doc and INV05.localEstoque=@local;

            update INV05 set c2=isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=2 and localEstoque=@local and INV03.codigoProduto=INV05.codigoProduto),0)
             where INV05.documento=@doc and INV05.localEstoque=@local;

            update INV05 set c3=isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=3 and localEstoque=@local and INV03.codigoProduto=INV05.codigoProduto),0)
             where INV05.documento=@doc and INV05.localEstoque=@local;

            update INV05 set c4=isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=4 and localEstoque=@local and INV03.codigoProduto=INV05.codigoProduto),0)
             where INV05.documento=@doc and INV05.localEstoque=@local;

            update INV05 set c5=isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=5 and localEstoque=@local and INV03.codigoProduto=INV05.codigoProduto),0)
             where INV05.documento=@doc and INV05.localEstoque=@local;

            update INV05 set c6=isnull((select sum(quantidade) from INV03 with (nolock) where numeroContagem=6 and localEstoque=@local and INV03.codigoProduto=INV05.codigoProduto),0)
             where INV05.documento=@doc and INV05.localEstoque=@local;

         end
   end
go

delete INV05

.+96.

,

exec dbo.LancarInventario 20181128, 2
*/

-- consolidar quantidades para lançamento do estoque
declare @n smallint
set @n=6
if @n in(1,2,3,4)
   print 'ohhh'
else
   print 'xiiii'

select top 1 * from INV05 with (nolock)

drop procedure ConsolidarContagem
go

create procedure ConsolidarContagem (@doc int, @contagem smallint, @local smallint, @gravaSaldo char(1), @recalcular char(1)) as
   begin
      if @gravaSaldo='S'
         -- grava saldo anterior
         update INV05
            set saldoAnterior=isnull((select INV04.quantidade
                                        from INV04 with (nolock)
                                       where INV04.documento=INV05.documento
                                             and INV04.localEstoque=INV05.localEstoque
                                             and INV04.codigoProduto=INV05.codigoProduto),0)
          where documento=@doc
                and localEstoque=@local;

	  if @recalcular='S'
	     -- zera a quantidade à lançar
         update INV05
            set lancar=0
          where documento=@doc
                and localEstoque=@local;

      if @contagem = 1
             -- grava quantidade a lançar
            update INV05
               set lancar=c1
             where documento=@doc
                   and localEstoque=@local
                   and c1=saldoAnterior;

      if @contagem = 2
            update INV05
               set lancar=c2
             where documento=@doc
                   and localEstoque=@local
                   and lancar=0
                   and (c2=c1 or c2=saldoAnterior);

      if @contagem=3 
         update INV05
            set lancar=c3
          where documento=@doc
                and localEstoque=@local
                and lancar=0
                and (c3=c1 or c3=c2 or c3=saldoAnterior);

      if @contagem=4
         update INV05
            set lancar=c4
          where documento=@doc
                and localEstoque=@local
                and lancar=0
                and (c4=c1 or c4=c2 or c4=c3 or c4=saldoAnterior);

      if @contagem=5
         update INV05
            set lancar=c5
          where documento=@doc
                and localEstoque=@local
                and lancar=0
                and (c5=c1 or c5=c2 or c5=c3 or c5=c4 or c5=saldoAnterior);

      if @contagem=6
         update INV05
            set lancar=c6
          where documento=@doc
                and localEstoque=@local
                and lancar=0
                and (c6=c1 or c6=c2 or c6=c3 or c6=c4 or c6=c5 or c6=saldoAnterior);

      if @contagem in(1,2,3,4,5,6)
         --update INV05 set saldoEfetivo=lancar-saldoAnterior where documento=@doc and localEstoque=@local and lancar > 0;
         update INV05
            set saldoEfetivo=lancar
          where documento=@doc
                and localEstoque=@local;
                --and lancar > 0;
   end
go

update INV05 set lancar=0, saldoEfetivo=0 where documento=20181226 and localEstoque=1

exec dbo.ConsolidarContagem 2, 20181226, 1

-- no final o que ficou com lancar = 0, saldo efetivo será igual a zero

begin tran
update INV05 set saldoEfetivo=lancar-saldoAnterior where documento=20181208 and localEstoque=1 and lancar = 0;
begin tran

select * from INV05 with (nolock) where documento=20181214 and localEstoque=1 and lancar=0

select * from INV05 with (nolock) where documento=20181130 and localEstoque=1 and saldoEfetivo<>0

select count(*) from INV05 where documento=20181226 -- 2.307

select count(*) from INV05 with (nolock) where documento=20181226 and c1=c2 -- 2.011
select count(*) from INV05 with (nolock) where documento=20181226 and (c3=c1 or c3=c2) -- 110
select count(*) from INV05 with (nolock) where documento=20181208 and lancar=0 and c3 != c1 and c3 != c2 and (c4=c1 or c4=c2 or c4=c3) -- 7
select count(*) from INV05 with (nolock) where documento=20181208 and lancar=0 and c4 != c1 and c4 != c2 and c4 != c3 and (c5=c1 or c5=c2 or c5=c3 or c5=c4) -- 1
select count(*) from INV05 with (nolock) where documento=20181208 and lancar=0 and c5 != c1 and c5 != c2 and c5 != c3 and c5 != c4 and (c6=c1 or c6=c2 or c6=c3 or c6=c4 or c6=c5) -- 1

select count(*) from INV05 with (nolock) where documento=20181226 and c1+c2=0

select * from INV05 with (nolock) where documento=20181226 and c1=c2 -- 2.011
select * from INV05 with (nolock) where documento=20181226 and c3 > 0 and (c3=c1 or c3=c2) -- 85

select * from INV05 with (nolock) where documento=20181130 and saldoAnterior < 0 -- 0

select * from INV05 with (nolock) where documento=20181226 and c1 != c2 and c3=0 -- 171

select * from INV05 with (nolock) where documento=20181130 and lancar=0 and c3 != c1 and c3 != c2 and (c4=c1 or c4=c2 or c4=c3) -- 44

select * from INV05 with (nolock) where documento=20181130 and lancar=0 and c4 != c1 and c4 != c2 and c4 != c3 and (c5=c1 or c5=c2 or c5=c3 or c5=c4) -- 3

select * from INV05 with (nolock) where documento=20181130 and lancar=0 and c5 != c1 and c5 != c2 and c5 != c3 and c5 != c4 and (c6=c1 or c6=c2 or c6=c3 or c6=c4 or c6=c5) -- 3

SELECT * INTO INV05BKP_BEST FROM INV05




-- lista endereços

drop table #endereco

SELECT codigoProduto,endereco,
  ROW_NUMBER() OVER(partition by codigoProduto ORDER BY codigoProduto,endereco) AS Row#
  into #endereco
FROM INV03 where documento=20181130 and localEstoque=1
group by codigoProduto,endereco

select * from #endereco



-- grava endereços

select top 1 * from INV05 with (nolock)

update INV05 set e1='',e2='',e3='',e4='',e5='' where documento=20181130 and localEstoque=1

update INV05 set e1=isnull((select endereco from #endereco where #endereco.codigoProduto=INV05.codigoProduto and Row#=1),'')
 where documento=20181130 and localEstoque=1
       and (c1 > 0 or c2 > 0)

update INV05 set e2=isnull((select endereco from #endereco where #endereco.codigoProduto=INV05.codigoProduto and Row#=2),'') where documento=20181130 and localEstoque=1

update INV05 set e3=isnull((select endereco from #endereco where #endereco.codigoProduto=INV05.codigoProduto and Row#=3),'') where documento=20181130 and localEstoque=1

update INV05 set e4=isnull((select endereco from #endereco where #endereco.codigoProduto=INV05.codigoProduto and Row#=4),'') where documento=20181130 and localEstoque=1

update INV05 set e5=isnull((select endereco from #endereco where #endereco.codigoProduto=INV05.codigoProduto and Row#=5),'') where documento=20181130 and localEstoque=1


begin tran
insert into INV03
   (numeroContagem,idColetor,localEstoque,endereco,dataContagem,horaContagem,codigoProduto,descricaoProduto,codigoBusca,embalagem,marca,quantidade,documento)
select 6,'FOLHA',localEstoque,endereco,'20181201','18:00',codigoProduto,descricaoProduto,'',embalagem,marca,0,documento
  from INV03 as x with (nolock)
 where x.documento=20181130
       and x.codigoProduto in('0413372')
       and id=(select min(id) from INV03 as y with (nolock) where y.documento=x.documento and y.codigoProduto=x.codigoProduto)
 order by codigoProduto
commit tran

select * from INV03 with (nolock) where documento=20181130 and numeroContagem=6


-- conferência lançamentos

drop table #comp

select ESTQTDATU as saldoAtual,saldoAnterior+saldoEfetivo as lancado,*
  into #comp
  from TBS032 with (nolock)
       inner join INV05 with (nolock) on codigoProduto=PROCOD
 where documento=20181208 and ESTLOC=1

select * from TBS032

select * from #comp where saldoAtual = lancado

select * from TBS032 with (nolock) where ESTLOC=1 and ESTQTDATU > 0 and not exists(select '' from INV05 with (nolock) where documento=20181208 and codigoProduto=PROCOD)


-- acuracidade da primeira contagem

select distinct documento,localEstoque from INV05 with (nolock)

-- 7.022
select count(*) from INV05 with (nolock) where documento=20181214

-- 2.053
select count(*) from INV05 with (nolock)
 where documento=20181226
       and c1=c2 and c1=saldoAnterior


select count(*) from INV05 with (nolock)
 where documento=20181214
       and c1=saldoAnterior or c2

select count(*) from INV05 with (nolock)
 where documento=20181214
       and c1<>saldoAnterior


select count(*) from INV05 with (nolock)
 where documento=20181226
       and c3 > 0
       and (c3=c1 or c3=c2) 


select count(*) from INV05 with (nolock)
 where documento=20181214
       and c3 > 0
       and (c3<>saldoAnterior and c3<>c1 and c3<>c2) 

select saldoAnterior,c1,c2,c3,* from INV05 with (nolock)
 where documento=20181214
       and c3 > 0
       and (c3<>saldoAnterior and c3<>c1 and c3<>c2) 

select count(*) from INV05 with (nolock)
 where documento=20181214
       and c1=c2 and c1 > 0

select count(*) from INV05 with (nolock)
 where documento=20181214
       and c1=saldoAnterior

select * from INV05 with (nolock)
 where documento=20181214
       and c2 > 0 and c2<>c1

-- tanby matriz, estoque 1 14/12/2018 14:00

delete INV02
delete INV03
delete INV05


select * from INV03 with (nolock) where codigoProduto='0040150'
select * from INV04 with (nolock) where codigoProduto='0040150'

select * from TBS032 with (nolock) where ESTLOC=1 and PROCOD='0040150'


-- localização física

select e1,isnull((select rtrim(PROLOCFIS)+',' from TBS010 with (nolock) where PROCOD=codigoProduto and PROLOCFIS<>''),''),* from INV05 with (nolock)

begin tran
update INV05 set e1=isnull((select rtrim(PROSETLOJ1)+',' from TBS010 with (nolock) where PROCOD=codigoProduto and PROSETLOJ1<>''),'')+e1
commit tran

select * from INV05 with (nolock) where e1=''


-- itens que após contagem da divergência continuam errados

select row_number() over(order by PROLOCFIS),PROCOD,PRODES,MARNOM,PROUM1,PROLOCFIS from TBS010 with (nolock)
 where PROCOD in
(select codigoProduto from INV05 with (nolock)
 where documento=20181215
       and c2 > 0 and c2<>c1 and c2<>saldoAnterior)


-- produtos por kg

select row_number() over(order by (select PRODES from TBS010 with (nolock) where PROCOD=codigoProduto))
       ,codigoProduto
       ,(select PRODES from TBS010 with (nolock) where PROCOD=codigoProduto)
       ,(select PROUM1 from TBS010 with (nolock) where PROCOD=codigoProduto)
       ,c1
  from INV05 with (nolock)
 where c1 > 0
       and (select PROUM1 from TBS010 with (nolock) where PROCOD=codigoProduto)='KG'

select top 1 * from INV03 with (nolock) order by id

---

declare @codigo varchar(8)

set @codigo='16310030'

select quantidade,* from INV03 with (nolock) where codigoProduto=@codigo

select quantidade,* from INV04 with (nolock) where codigoProduto=@codigo

select ESTQTDATU,* from TBS032 with (nolock) where ESTLOC=1 and PROCOD=@codigo

select PROCOD,PROLOCFIS,PRODES,MARNOM,PROUM1,PROUM1QTD from TBS010 with (nolock) where PROCOD='2860116'

select PROCOD,PROLOCFIS,PRODES,MARNOM,PROUM1,PROUM1QTD from TBS010 with (nolock) where PROLOCFIS='SETOR QUADRO'

begin tran
update TBS010 set PROLOCFIS='QUADROS' where PROLOCFIS='SETOR QUADRO'
commit tran


select count(*) from INV04 with (nolock)

select count(*) from TBS032 with (nolock) where ESTLOC=1 and ESTQTDATU <> 0

select * from INV01 with (nolock)
select * from INV03 with (nolock)

select distinct localEstoque from INV03 with (nolock)


select * from INV05 with (nolock)

---

-- tempo de contagem

select min(horaContagem),max(horaContagem) from INV03 with (nolock) where localEstoque=2

-- itens para contagem 4

select row_number() over(order by PROLOCFIS),PROCOD,PRODES,MARNOM,PROUM1,PROLOCFIS from TBS010 with (nolock)
 where PROCOD in
(select codigoProduto from INV05 with (nolock)
  where documento=20181214
        and c3 > 0
        and (c3<>saldoAnterior and c3<>c1 and c3<>c2))


-- itens divergentes loja

select row_number() over(order by PROLOCFIS),PROCOD,PRODES,MARNOM,PROUM1
       ,isnull((select e1 from INV05 with (nolock) where documento=20181215 and codigoProduto=PROCOD),'')
  from TBS010 with (nolock)
 where PROCOD in
(select codigoProduto from INV05 with (nolock)
  where documento=20181215
        and c1<>saldoAnterior)


-- itens com saldo não contados na loja

select row_number() over(order by PROSETLOJ1),TBS010.PROCOD,TBS010.PRODES,TBS010.MARNOM,TBS010.PROUM1
       ,PROSETLOJ1
  from TBS010 with (nolock)
       inner join TBS032 with (nolock) on TBS032.ESTLOC=2 and TBS032.PROCOD=TBS010.PROCOD
 where TBS032.ESTQTDATU <> 0
       and not exists(select '' from INV05 with (nolock) where documento=20181215 and codigoProduto=TBS010.PROCOD)

 where PROCOD in
(select codigoProduto from INV05 with (nolock)
  where documento=20181215
        and c1<>saldoAnterior)


-- analises pós contagem loja tanby matriz

select count(distinct codigoProduto) from INV03 with (nolock) where documento=20181215 -- 7.454

-- analises pós contagem retaguarda tanby matriz

select count(distinct codigoProduto) from INV03 with (nolock) where documento=20181214 -- 4.515

-- primeira contagem ok com saldo em estoque - loja

select count(distinct codigoProduto) from INV05 with (nolock) where documento=20181215 and c1=saldoAnterior -- 4.175

-- primeira contagem ok com saldo em estoque - retaguarda

select count(distinct codigoProduto) from INV05 with (nolock) where documento=20181214 and c1 > 0 and c1=saldoAnterior -- 2.883

-- itens abertos - loja

select * from INV05 with (nolock)
 where documento=20181215 and c1=saldoAnterior -- 4.175
       -- and lancar=0

-- itens abertos - retaguarda

select * from INV05 with (nolock)
 where documento=20181214 and c1 > 0 and c1=saldoAnterior -- 2.883
       --and lancar=0

update INV05 set lancar=c1 where documento=20181214 and localEstoque=1 and c1 > 0 and c1=saldoAnterior

-- segunda contagem, quantidade lançada igual a quantidade 1 ou saldo em estoque - loja

select count(distinct codigoProduto) from INV05 with (nolock)
 where documento=20181215 and c2 > 0 
       and (c2=c1 or c2=saldoAnterior) -- 1.190

-- segunda contagem, quantidade lançada igual a quantidade 1 ou saldo em estoque - retaguarda

select count(distinct codigoProduto) from INV05 with (nolock)
 where documento=20181214 and c2 > 0 
       and (c2=c1 or c2=saldoAnterior) -- 1.190

-- itens abertos - loja

select * from INV05 with (nolock)
 where documento=20181215 and c2 > 0 
       and (c2=c1 or c2=saldoAnterior) -- 1.190

-- itens abertos - retaguarda

select * from INV05 with (nolock)
 where documento=20181214 and c2 > 0 
       and (c2=c1 or c2=saldoAnterior) -- 1.190

select * from INV05 with (nolock)
 where documento=20181214 and c3 > 0 
       and (c3=c1 or c3=c2 or c3=saldoAnterior) -- 1.190

-- somente c1=c2

select count(distinct codigoProduto) from INV05 with (nolock)
 where documento=20181215 and c2 > 0 
       and c2=c1 -- 1.118

-- somente c2=saldo em estoque

select count(distinct codigoProduto) from INV05 with (nolock)
 where documento=20181215 and c2 > 0 
       and c2=saldoAnterior -- 72

-- lançar a contagem 2 se igual ao saldo em estoque - loja

begin tran
update INV05 set lancar=c2
 where documento=20181215 and c2 > 0 --and (c2=c1 or c2=saldoAnterior) -- 1.190
--       and c2=c1 and lancar=0
       and c2=saldoAnterior

commit tran

-- lançar a contagem 2 se igual ao saldo em estoque - retaguarda

begin tran
update INV05 set lancar=c2
 where documento=20181214 and c2 > 0 --and (c2=c1 or c2=saldoAnterior) -- 1.190
       and c2=saldoAnterior

commit tran

-- lançar a contagem 3 se igual ao saldo em estoque - retaguarda

begin tran
update INV05 set lancar=c3
 where documento=20181214 and c3 > 0 --and (c2=c1 or c2=saldoAnterior) -- 1.190
       and c3=saldoAnterior

commit tran

-- lançar a contagem 4 se igual ao saldo em estoque - retaguarda

begin tran
update INV05 set lancar=c4
 where documento=20181214 and c4 > 0 --and (c2=c1 or c2=saldoAnterior) -- 1.190
       and c4=saldoAnterior

commit tran

-- itens sem quantidade a lançar

select * from INV05 with (nolock)
 where documento=20181214 and lancar=0 -- 104
       --and c1<>saldoAnterior and c1<>c2 and c2<>saldoAnterior
       --and (c1=saldoAnterior or c1=c2 and c2=saldoAnterior)

select row_number() over(order by (isnull((select e1 from INV05 with (nolock) where documento=20181215 and codigoProduto=PROCOD),''))),PROCOD,PRODES,MARNOM,PROUM1
       ,isnull((select e1 from INV05 with (nolock) where documento=20181215 and codigoProduto=PROCOD),'')
  from TBS010 with (nolock)
 where PROCOD in
       (select codigoProduto from INV05 with (nolock) where documento=20181215 and lancar=0 and c1 > 0)

select * from INV05 with (nolock) where documento=20181215 and lancar=0 and c1=saldoAnterior

select * from INV05 with (nolock) where documento=20181215 and c1 > 0 and lancar=0 and c1=saldoAnterior
select * from INV05 with (nolock) where documento=20181215 and c2 > 0 and lancar=0 and c2=saldoAnterior

select * from INV05 with (nolock) where documento=20181215 and c2 > 0 and c1=0 and lancar=0

-- lançar quantidade 1 se não existe quantidade 2 e lançar for igual a 0

select * from INV05 with (nolock) where documento=20181214 and lancar=0 and c1 > 0 and c2+c3+c4=0

begin tran
update INV05 set lancar=c1 where documento=20181214 and lancar=0 and c1 > 0 and c2+c3+c4=0

commit tran

select * from INV05 with (nolock) where documento=20181214 and lancar=0 -- 104

select * from INV05 with (nolock) where documento=20181226 and lancar=0 and (c1=saldoAnterior or c1=c2 or c2=saldoAnterior)

-- itens finais para lançamento no estoque

select count(*) from INV05 with (nolock)
select count(*) from INV05 with (nolock) where lancar > 0
select count(*) from INV05 with (nolock) where lancar = 0

select * from INV05 with (nolock) where saldoAnterior < 0

-- ajustes finais

-- últimos itens divergentes estoque 1

select row_number() over(order by PROLOCFIS),PROCOD,PRODES,MARNOM,PROUM1
       ,isnull((select e1 from INV05 with (nolock) where documento=20181226 and codigoProduto=PROCOD),'')
  from TBS010 with (nolock)
 where PROCOD in
       (select codigoProduto from INV05 with (nolock) where documento=20181226 and lancar=0)

select *
  from INV05 with (nolock)
       inner join TBS010 with (nolock) on PROCOD=codigoProduto
 where lancar=0 and PROUM1='KG'
 
begin tran
update INV05 set lancar=c2
 where codigoProduto in
(select codigoProduto
  from INV05 with (nolock)
       inner join TBS010 with (nolock) on PROCOD=codigoProduto
 where lancar=0 and PROUM1='KG')
commit tran

begin tran
update INV05 set saldoEfetivo=lancar-saldoAnterior
--select * from INV05 with (nolock)
 where documento=20181214 and localEstoque=1 and saldoEfetivo <> lancar-saldoAnterior

commit tran

select * into INV05_FINAL_LOJA from INV05 with (nolock)

select * into INV05_FINAL_RETAGUARDA from INV05 with (nolock)

-- misaspel

select * from INV03 with (nolock) where numeroContagem=3

select * into INV03C3 from INV03 with (nolock) where numeroContagem=3

select * from INV03C3 with (nolock) where numeroContagem=3

begin tran
delete INV03 where numeroContagem=3
commit tran



-- gravar itens da INV03 para a INV05 (análises)
-- documento, número da contagem, local estoque

exec dbo.LancarInventario 20200413, 2, 1

-- grava a descrição do produto na INV05

update INV05 set descricaoProduto=(select PRODES from TBS010 with (nolock) where PROCOD=codigoProduto)

-- grava endereços

-- do coletor

drop procedure EnderecoContagem

create procedure EnderecoContagem(@doc int, @local int) as
   begin
      with tab as
      (
         select documento, localEstoque, endereco, codigoProduto, row_number() over(partition by codigoProduto order by codigoProduto,endereco) as row#
           from INV03 with (nolock) where documento=@doc and localEstoque=@local
          group by documento, localEstoque, codigoProduto,endereco
      )

      update INV05
         set  e1=isnull((select endereco from tab where tab.documento=INV05.documento and tab.localEstoque=INV05.localEstoque and tab.codigoProduto=INV05.codigoProduto and row#=1),'')
             ,e2=isnull((select endereco from tab where tab.documento=INV05.documento and tab.localEstoque=INV05.localEstoque and tab.codigoProduto=INV05.codigoProduto and row#=2),'')
             ,e3=isnull((select endereco from tab where tab.documento=INV05.documento and tab.localEstoque=INV05.localEstoque and tab.codigoProduto=INV05.codigoProduto and row#=3),'')
             ,e4=isnull((select endereco from tab where tab.documento=INV05.documento and tab.localEstoque=INV05.localEstoque and tab.codigoProduto=INV05.codigoProduto and row#=4),'')
             ,e5=isnull((select endereco from tab where tab.documento=INV05.documento and tab.localEstoque=INV05.localEstoque and tab.codigoProduto=INV05.codigoProduto and row#=5),'')
   end
go

-- do produto

drop procedure EnderecoContagem

create procedure EnderecoContagem(@doc int, @local int) as
   begin
      with tab as
      (
         select documento, localEstoque, localizacao, codigoProduto, row_number() over(partition by codigoProduto order by codigoProduto,localizacao) as row#
           from INV03 with (nolock) where documento=@doc and localEstoque=@local
          group by documento, localEstoque, codigoProduto,localizacao
      )

      update INV05
         set  e1=isnull((select localizacao from tab where tab.documento=INV05.documento and tab.localEstoque=INV05.localEstoque and tab.codigoProduto=INV05.codigoProduto and row#=1),'')
             ,e2=isnull((select localizacao from tab where tab.documento=INV05.documento and tab.localEstoque=INV05.localEstoque and tab.codigoProduto=INV05.codigoProduto and row#=2),'')
             ,e3=isnull((select localizacao from tab where tab.documento=INV05.documento and tab.localEstoque=INV05.localEstoque and tab.codigoProduto=INV05.codigoProduto and row#=3),'')
             ,e4=isnull((select localizacao from tab where tab.documento=INV05.documento and tab.localEstoque=INV05.localEstoque and tab.codigoProduto=INV05.codigoProduto and row#=4),'')
             ,e5=isnull((select localizacao from tab where tab.documento=INV05.documento and tab.localEstoque=INV05.localEstoque and tab.codigoProduto=INV05.codigoProduto and row#=5),'')
   end
go

update INV05 set e1='' where documento=20190329

-- documento, local estoque
exec EnderecoContagem 20190401, 1

-- consolidar
-- documento, número da contagem, local de estoque, atualiza com saldo anterior

exec dbo.ConsolidarContagem 20190401, 2, 1, 'S'

drop table INV05BKP

select * into INV05BKP from INV05 with (nolock)

-- registrar saldo efetivo

--update INV05 set saldoEfetivo=e1 where documento=@doc and localEstoque=@local and lancar > 0;



-- grava cabeçalho movimento interno

-- número do documento

declare @MVIDOC int

-- gera documento sequencial

exec dbo.SequencialTabela 'TBS037', @sequencia = @MVIDOC output

-- assinatura: GravaCabecalhoMI (@MVIDOC int, @LOCAL smallint, @TMVCOD int, @CCSCOD int, @MVIOBS varchar(200))

-- tanby matriz
--    4 entrada sem movimentação automática
--  506 saída idem anterior

-- movimento de entrada
exec dbo.GravaCabecalhoMI @MVIDOC, 1, 4, 12, 'INVENTARIO ROTATIVO ESTOQUE RUA 16'

-- movimento de saída
--exec dbo.GravaCabecalhoMI @MVIDOC, 1, 503, 24, 'LANÇAMENTO DO INVENTÁRIO RETAGUARDA'

-- assinatura: GravaItemMI (@MVIDOC int, @LOCAL smallint, @doc int)

exec dbo.GravaItemMI @MVIDOC, 1, 20190405

print 'Documento: ' + Ltrim(str(@MVIDOC,6))





---

select * from SALDODIARIO with (nolock) where ESTDATSAL='20190312'

select * from INV04 where documento in(20190311,20190312,20190313) -- 245

select * from INV04 where documento=20190315

drop table INV04BKP

select * into INV04BKP from INV04 with (nolock)

select *
  from INV04 with (nolock)
--delete INV04
 where (documento=20190315
       and Len(codigoProduto)=8)
--       and Left(codigoProduto,3) not in('873'))
       or
       (documento=20190315
       and Len(codigoProduto)=7
       and Left(codigoProduto,3) not in('838'))
 order by codigoProduto

select * from INV04 with (nolock) order by documento, codigoProduto

insert into INV04 (localEstoque, codigoProduto, quantidade, documento)
select 2, '12950002', 2, 20190313

select top 1 * from INV04 with (nolock)

select * from INV04 with (nolock) where documento=20190405

drop table INV04BKP

select * into INV04BKP from INV04 with (nolock)

select PROLOCFIS
       ,*
--delete INV04
  from INV04 with (nolock)
       inner join TBS010 with (nolock)
       on PROCOD=codigoProduto
 where documento=20190403
       and localEstoque=1
       and Left(PROLOCFIS,2) not in('28')
 order by codigoProduto

select * from INV04 with (nolock) where documento=20190403

begin tran
delete INV04 where documento=20190405 and quantidade=0
commit tran

-- checagens

select *
  from INV03 with (nolock)
 where documento=20190401

select *
  from INV04 with (nolock)
 where documento=20190401

select *
  from INV05 with (nolock)
 where documento=20190401
       and c1<>saldoAnterior

select *
  from INV05 with (nolock)
 where documento=20190405
       and lancar > 0


select *
  from INV05 with (nolock)
 where documento=20190329 --c1=c2 and lancar > 0
       not exists(select '' from INV04 with (nolock) where codigoProduto=PROCOD and quantidade=ESTQTDATU)

select *
  from INV04 with (nolock)
 where documento=20190404
       and not exists(select ''
                        from INV05 with (nolock)
                       where INV05.documento=INV04.documento
                             and INV05.codigoProduto=INV04.codigoProduto)

select * from TBS0371 with (nolock) where MVIDOC=155710 and Left(PROCOD,3)='730' order by PROCOD


select top 1 * from TBS024 with (nolock)
select top 1 * from TBS0241 with (nolock)

drop procedure IdTabela

create procedure IdTabela @tabela varchar(10), @sequencia int output as
   begin
      set nocount on;
      begin tran
	     declare @modo char(1)
		 
		 set @modo = (select TBSMOD from TBS024 where TBSNOM=@tabela)
		 
	     if @modo = 'C'
		    begin
               update TBS024 set TBSID += 1 where TBSNOM=@tabela
               select @sequencia = TBSID from TBS024 with (nolock) where TBSNOM=@tabela
			end
	     else
		    begin
               update TBS0241 set TBSIDEMP += 1 where TBSNOM=@tabela
               select @sequencia = TBSIDEMP from TBS0241 with (nolock) where TBSNOM=@tabela
			end
		    
      commit tran

      return
   end
go


declare @n int;

exec dbo.IdTabela 'TBS037', @sequencia = @n output;

select @n;

select * from TBS024 with (nolock) where TBSNOM='TBS037'