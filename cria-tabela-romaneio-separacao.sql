-- sequência numérica de uma tabela

if exists(select name from sysobjects where name='SP_SequenciaTabela' and type='P')
   drop procedure SP_SequenciaTabela
go

create procedure SP_SequenciaTabela @tabela varchar(10), @sequencia int output as
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

exec dbo.SP_SequenciaTabela 'TMP017', @sequencia = @n output;

select @n;

go

update TBS024 set TBSVALSEQ = 0 where TBSNOM='TMP017'


select *
  from TBS024 with (nolock)
 where TBSNOM='TMP017'



select * from TMP017 with (nolock) where T17_REGISTRO=5

select *
  from TBS058 with (nolock)

if exists(select name from sysobjects where name='SP_GRAVAROMANEIO' and type='P')
   drop procedure SP_GRAVAROMANEIO
go

create procedure SP_GRAVAROMANEIO @sequencia int output, @registros int output as
   begin
      insert into TMP017
      select T17_EMPRESA
             ,T17_REGISTRO
             ,T17_PDVNUM
             ,T17_PDVDATCRI
             ,T17_PDVHORCRI
             ,T17_PDVCLICOD
             ,T17_PDVCLINOM
             ,isnull([R],0) T17_QTDITERES
             ,isnull([P],0) T17_QTDITEPEN
             ,T17_VENCOD
             ,isnull(T17_VENNOM,'') T17_VENNOM
        from
        (
           select PRPEMP T17_EMPRESA
                 ,0 T17_REGISTRO --@sequencia T17_REGISTRO
                 ,convert(date,subString(PDVUSUGER,1,10)) T17_PDVDATCRI
                 ,subString(PDVUSUGER,12,8) T17_PDVHORCRI
                 ,PRPNUM T17_PDVNUM
                 ,PDVCLICOD T17_PDVCLICOD
                 ,PDVCLINOM T17_PDVCLINOM
                 ,PRPVENCOD T17_VENCOD
                 ,(select VENNOM from TBS004 with (nolock) where VENEMPCOD=PRPVENEMP and VENCOD=PRPVENCOD) T17_VENNOM
                 ,PRPQTD - PRPQTDCONF QTDE
                 ,PRPSIT STATUS
            from TBS058 with (nolock)
                 inner join TBS055 with (nolock)
                 on PDVEMPCOD=PRPEMP
                    and PDVNUM=PRPNUM
           where convert(date,subString(PDVUSUGER,1,10))=convert(date,getdate(),112)
                 and PRPSIT='R'
                 and PRPQTD - PRPQTDCONF > 0
        ) linhas
      pivot (sum(QTDE) for STATUS in ([R], [P])) colunas

      set @registros = iif(@@rowcount > 0, @@rowcount, 0)
   end

exec dbo.SP_GravaRomaneio 2, @sequencia = @n output;

select convert(datetime,'2019-05-23 07:41:31',121)

declare @n int;

exec SP_GRAVAROMANEIO 4, @registros = @n output;

select @n;

go

select * from TBS058 with (nolock)

select * from TMP017 with (nolock)
select * from TMP0171 with (nolock)
select * from TMP0172 with (nolock)

select PDVNUM
       ,subString(PDVUSUGER,1,10)
       ,subString(PDVUSUGER,12,8)
       ,convert(date,PRPDATREG)
       ,convert(char(8),PRPDATREG,14)
  from TBS058 with (nolock)
       inner join TBS055 with (nolock)
       on PDVEMPCOD=PRPEMP
          and PDVNUM=PRPNUM
 where PRPSIT='R'
       and PRPQTD - PRPQTDCONF > 0

select convert(char(6),getdate(),112)

select PDVNUM
       ,convert(char(6),PRPDATREG,112)
       ,count(*)
  from TBS058 with (nolock)
       inner join TBS055 with (nolock)
       on PDVEMPCOD=PRPEMP
          and PDVNUM=PRPNUM
 where PRPSIT='P'
--       and PRPQTD - PRPQTDCONF > 0
 group by PDVNUM, convert(char(6),PRPDATREG,112)

select convert(char(6),PRPDATREG,112)
       ,count(distinct PDVNUM)
  from TBS058 with (nolock)
       inner join TBS055 with (nolock)
       on PDVEMPCOD=PRPEMP
          and PDVNUM=PRPNUM
 where PRPSIT='P'
 group by rollup (convert(char(6),PRPDATREG,112))

select convert(char(6),PRPDATREG,112)
       ,count(distinct PDVNUM)
  from TBS058 with (nolock)
       inner join TBS055 with (nolock)
       on PDVEMPCOD=PRPEMP
          and PDVNUM=PRPNUM
 where PRPSIT='P'
 group by convert(char(6),PRPDATREG,112) with rollup

ALTER TABLE [TMP017]
ADD [T17_HORDEV] CHAR(5)     NULL,
    [T17_HORFIM] CHAR(5)     NULL,
    [T17_HORINI] CHAR(5)     NULL,
    [T17_QTDPED] SMALLINT     NULL


-- cria romaneios diários

if exists(select name from sysobjects where name='SP_CRIAROMANEIO' and type='P')
   drop procedure SP_CRIAROMANEIO
go

create procedure SP_CRIAROMANEIO as
   begin
      declare @doc int=0, @i int=0, @comando varchar(1000), @n int=0

      if object_id('tempdb..#periodo') is not null
         drop table #periodo

      select *
        into #periodo
        from fSplit
        (
           (select PARVAL from TBS025 with (nolock) where PARCHV=1379),','
        )

      set @n = @@rowcount

      while @i < @n
         begin
            set @i += 1

            --exec dbo.SP_SequenciaTabela 'TMP017', @sequencia = @doc output
            exec dbo.SP_SequenciaTabela 'TBS139', @sequencia = @doc output

            /*
            set @comando  = 'insert into TMP017 (T17_EMPRESA,T17_REGISTRO,T17_DATCRI,T17_HORCRI,T17_PERIODO,T17_HORINI,T17_HORFIM,T17_HORDEV,T17_QTDPED) '
            set @comando += 'select 0,' + rtrim(convert(char(6),@doc)) + ',''' + convert(char(8),getdate(),112) + ''',''' + convert(char(5),getdate(),14) + ''','''','
            set @comando += '''' + replace((select elemento from #periodo where id=@i),'/',''',''') + ''','
            set @comando += '0 '
            set @comando += 'where not exists(select '''' from TMP017 with (nolock) where T17_DATCRI=convert(char(8),getdate(),112) and T17_HORINI + ''/'' + T17_HORFIM + ''/'' + T17_HORDEV=''' + (select elemento from #periodo where id=@i) + ''')'

            exec dbo.SP_SequenciaTabela 'TMP017', @sequencia = @doc output
            */

            set @comando  = 'insert into TBS139 (RMSEMPCOD,RMSNUM,RMSDATCRI,RMSHORCRI,RMSHORINI,RMSHORFIN,RMSHORDEV) '
            set @comando += 'select 0,' + rtrim(convert(char(6),@doc)) + ',''' + convert(char(8),getdate(),112) + ''',''' + convert(char(5),getdate(),14) + ''','
            set @comando += '''' + replace((select elemento from #periodo where id=@i),'/',''',''') + ''''
            set @comando += ' where not exists(select '''' from TBS139 with (nolock) where RMSDATCRI=convert(char(8),getdate(),112) and RMSHORINI + ''/'' + RMSHORFIN + ''/'' + RMSHORDEV=''' + (select elemento from #periodo where id=@i) + ''')'

            execute(@comando)
            --print @comando
         end
   end

-- resultado

insert into TBS139
   (RMSEMPCOD,RMSNUM,RMSDATCRI,RMSHORCRI,RMSHORINI,RMSHORFIN,RMSHORDEV)
select 0,1,'20190910','12:31','07:00','09:00','11:00'
 where not exists(select ''
                    from TBS139 with (nolock)
                   where RMSDATCRI=convert(char(8),getdate(),112)
                         and RMSHORINI + '/' + RMSHORFIN + '/' + RMSHORDEV='07:00/09:00/11:00')

select *
  from TBS139 with (nolock)

-- convert(char(8),getdate(),112)

exec dbo.SP_CRIAROMANEIO

select * from TMP017 with (nolock)
select * from TMP0171 with (nolock)
select * from TMP0172 with (nolock)

-- testes

insert into TMP017 (T17_EMPRESA,T17_REGISTRO,T17_DATCRI,T17_HORCRI,T17_PERIODO,T17_HORINI,T17_HORFIM,T17_HORDEV,T17_QTDPED) select 0,22,'20190523','15:07','','07:00','09:00','11:00',0
insert into TMP017 (T17_EMPRESA,T17_REGISTRO,T17_DATCRI,T17_HORCRI,T17_PERIODO,T17_HORINI,T17_HORFIM,T17_HORDEV,T17_QTDPED) select 0,23,'20190523','15:07','','09:01','14:00','17:00',0
insert into TMP017 (T17_EMPRESA,T17_REGISTRO,T17_DATCRI,T17_HORCRI,T17_PERIODO,T17_HORINI,T17_HORFIM,T17_HORDEV,T17_QTDPED) select 0,24,'20190523','15:07','','14:01','18:00','09:00',0

insert into TMP017 (T17_EMPRESA,T17_REGISTRO,T17_DATCRI,T17_HORCRI,T17_PERIODO,T17_HORINI,T17_HORFIM,T17_HORDEV,T17_QTDPED) select 0,25,'20190523','15:10','','07:00','09:00','11:00',0 where not exists(select '' from TMP017 with (nolock) where T17_REGISTRO=25)

insert into TMP017 (T17_EMPRESA,T17_REGISTRO,T17_DATCRI,T17_HORCRI,T17_PERIODO,T17_HORINI,T17_HORFIM,T17_HORDEV,T17_QTDPED) select 0,28,'20190523','15:54','','07:00','09:00','11:00',0 where not exists(select '' from TMP017 with (nolock) where T17_REGISTRO=28 or T17_DATCRI=convert(char(8),getdate(),112))
insert into TMP017 (T17_EMPRESA,T17_REGISTRO,T17_DATCRI,T17_HORCRI,T17_PERIODO,T17_HORINI,T17_HORFIM,T17_HORDEV,T17_QTDPED) select 0,29,'20190523','15:54','','09:01','14:00','17:00',0 where not exists(select '' from TMP017 with (nolock) where T17_REGISTRO=29 or T17_DATCRI=convert(char(8),getdate(),112))
insert into TMP017 (T17_EMPRESA,T17_REGISTRO,T17_DATCRI,T17_HORCRI,T17_PERIODO,T17_HORINI,T17_HORFIM,T17_HORDEV,T17_QTDPED) select 0,30,'20190523','15:54','','14:01','18:00','09:00',0 where not exists(select '' from TMP017 with (nolock) where T17_REGISTRO=30 or T17_DATCRI=convert(char(8),getdate(),112))

delete TMP017

insert into TMP017 (T17_EMPRESA,T17_REGISTRO,T17_DATCRI,T17_HORCRI,T17_PERIODO,T17_HORINI,T17_HORFIM,T17_HORDEV,T17_QTDPED) select 0,31,'20190523','16:01','','07:00','09:00','11:00',0 where not exists(select '' from TMP017 with (nolock) where T17_DATCRI=convert(char(8),getdate(),112) and T17_HORINI + '/' + T17_HORFIM + '/' + T17_HORDEV='07:00/09:00/11:00')
insert into TMP017 (T17_EMPRESA,T17_REGISTRO,T17_DATCRI,T17_HORCRI,T17_PERIODO,T17_HORINI,T17_HORFIM,T17_HORDEV,T17_QTDPED) select 0,32,'20190523','16:01','','09:01','14:00','17:00',0 where not exists(select '' from TMP017 with (nolock) where T17_DATCRI=convert(char(8),getdate(),112) and T17_HORINI + '/' + T17_HORFIM + '/' + T17_HORDEV='09:01/14:00/17:00')
insert into TMP017 (T17_EMPRESA,T17_REGISTRO,T17_DATCRI,T17_HORCRI,T17_PERIODO,T17_HORINI,T17_HORFIM,T17_HORDEV,T17_QTDPED) select 0,33,'20190523','16:01','','14:01','18:00','09:00',0 where not exists(select '' from TMP017 with (nolock) where T17_DATCRI=convert(char(8),getdate(),112) and T17_HORINI + '/' + T17_HORFIM + '/' + T17_HORDEV='14:01/18:00/09:00')

insert into TMP017 (T17_EMPRESA,T17_REGISTRO,T17_DATCRI,T17_HORCRI,T17_PERIODO,T17_HORINI,T17_HORFIM,T17_HORDEV,T17_QTDPED) select 0,34,'20190523','16:05','','07:00','09:00','11:00',0 where not exists(select '' from TMP017 with (nolock) where T17_DATCRI=convert(char(8),getdate(),112) and T17_HORINI + '/' + T17_HORFIM + '/' + T17_HORDEV='07:00/09:00/11:00')

exec dbo.SP_GravaRomaneio 2, @sequencia = @n output;

create function fSplit (@string varchar(max), @separador char(1))
returns table as return
    with a as (
        select
            id = 1,
            len_string = len(@string) + 1,
            ini = 1,
            fim = coalesce(nullif(charindex(@separador, @string, 1), 0), len(@string) + 1),
            elemento = ltrim(rtrim(substring(@string, 1, coalesce(nullif(charindex(@separador, @string, 1), 0), len(@string) + 1)-1)))
        union all
        select
            id + 1,
            len(@string) + 1,
            convert(int, fim) + 1,
            coalesce(nullif(charindex(@separador, @string, fim + 1), 0), len_string),
            ltrim(rtrim(substring(@string, fim + 1, coalesce(nullif(charindex(@separador, @string, fim + 1), 0), len_string)-fim-1)))
        from a where fim < len_string)
    select id, elemento from a
    -- incluir with option (maxrecursion 0) na chamada da FC para strings com mais de 100 elementos
go

select * from fSplit('João;Maria;José;Oscar', ';')

select *
  into #periodo
  from fSplit
  (
     (select PARVAL from TBS025 with (nolock) where PARCHV=1379),','
  )

select * from #periodo

if exists(select * from Tempdb..SysObjects Where Xtype='U')

 Print 'Existem tables temporárias'

Else

 Print 'Não existe tables temporárias'

if object_id('tempdb..#periodo') is null
   print 'tabela não existe'
else   
   print 'tabela existe'

CREATE TABLE #tmpPessoa
(
    id INT,
    nome VARCHAR(100)
)
GO

SELECT *, LEN(elemento) - LEN(REPLACE(elemento, '/', '')) AS Qt_Pipes
FROM #periodo
WHERE LEN(elemento) - LEN(REPLACE(elemento, '/', '')) = 2

declare @i int = 0

while @i < (select count(*) from #periodo)
   begin
      set @i = @i + 1

      select i
             ,*
        from
        (
      select @i i
             ,elemento
             --,row_number() over(partition by elemento order by elemento) seq
             ,row_number() over(order by elemento) seq
        from fSplit
        (
           (select elemento from #periodo where id=@i),'/'
        )
        ) linhas
        pivot (count(elemento) for seq in ([1],[2],[3])) colunas
   end

select id from #periodo group by id

select id from #periodo group by id
union
select id from #periodo group by id
union
select id from #periodo group by id

select *
  from fSplit
  (
     (select top 1 elemento from #periodo),'/'
  )


-- exemplo

select
    left(elemento, charindex('|', elemento) - 1) as nome,
    right(elemento, charindex('|', reverse(elemento)) - 1) as idade
from dbo.fSplit((select PARVAL from TBS025 with (nolock) where PARCHV=1379), ';')
go

declare @n int=1000

select @n += 1

select @n


select convert(char(8),@n)

select convert(char(8),getdate(),112)

select convert(char(5),getdate(),14)

select *
  from TBS025 with (nolock)
 where PARCHV=1060

-- trigger

drop trigger romaneio
go

create trigger romaneio on TBS058 after insert, update
as
set nocount on

   begin
      -- cria registro de romaneio
      exec dbo.SP_CRIAROMANEIO

      if (select PRPSIT from inserted) = 'R'
         begin
            declare @datahora char(16), @PRPEMP smallint=0, @PRPNUM int=0, @T17_EMPRESA smallint=0, @T17_REGISTRO int=0

            -- informações do registro inserido
            select @datahora=convert(char(16),PRPDATREG,121)
                   ,@PRPEMP=PRPEMP
                   ,@PRPNUM=PRPNUM
              from inserted

            print @datahora

            -- retorna o período no qual o pedido se enquadra conforme a sua hora
            select top 1
                   @T17_EMPRESA=T17_EMPRESA
                   ,@T17_REGISTRO=T17_REGISTRO
              from TMP017 with (nolock)
             where T17_DATCRI=convert(date,getdate())
                   --and T17_HORFIM >= @datahora
                   and convert(char(8),T17_DATCRI,112) + ' ' + T17_HORFIM >= replace(@datahora,'-','')
             order by T17_DATCRI, T17_REGISTRO

            -- se encontrado um período
            if @@rowcount > 0
               begin
                  -- verifica se o pedido já se encontra gravado no romaneio
                  select T17_EMPRESA
                    from TMP0171 with (nolock)
                   where T17_EMPRESA=@T17_EMPRESA
                         and T17_REGISTRO=@T17_REGISTRO
                         and T17_PDVNUM=@PRPNUM

                  -- se pedido não encontrado no romaneio
                  if @@rowcount = 0
                     begin
                        insert into TMP0171
                           --(T17_EMPRESA,T17_REGISTRO,T17_PDVNUM)
                           select @T17_EMPRESA
                                  ,@T17_REGISTRO
                                  ,@PRPNUM
                                  ,PDVDATCAD
                                  ,subString(PDVUSUGER,12,5)
                                  ,PDVCLICOD
                                  ,PDVCLINOM
                                  ,0
                                  ,0
                                  ,VENCOD
                                  ,isnull((select VENNOM from TBS004 with (nolock) where TBS004.VENCOD=TBS055.VENCOD),'')
                             from TBS055 with (nolock)
                            where PDVEMPCOD=@PRPEMP
                                  and PDVNUM=@PRPNUM
                     end
               end
          
            select @T17_EMPRESA, @T17_REGISTRO
         end
   end

select top 1
       *
  from TBS055 with (nolock)
 where PDVNUM=41672

select *
  from TMP017 with (nolock)
 where T17_DATCRI=convert(date,getdate())
       and T17_HORFIM >= '10:12'
 order by T17_DATCRI, T17_REGISTRO

select *
  from TBS058 with (nolock)
 where PRPSIT='R'

select *
  from TBS058 with (nolock)
 where PRPNUM=41895
       and PRPITEM=10

update TBS058
   set PRPPRE=1
 where PRPNUM=41895
       and PRPITEM=4

update TBS058
   set PRPDATREG=getdate()
 where PRPNUM=41895
       and PRPITEM=10



select convert(char(5),PRPDATREG,108)
       ,convert(char(16),PRPDATREG,121)
       ,*
  from TBS058 with (nolock)
 where PRPNUM=41672
       and PRPSIT='R'
       and PRPITEM=1

select *
  from TMP017 with (nolock)

select convert(datetime,convert(char(8),T17_DATCRI,112)+' '+T17_HORCRI)
  from TMP017 with (nolock)

select convert(datetime,convert(char(8),T17_DATCRI,112)+' '+T17_HORCRI)
       ,convert(char(8),T17_DATCRI,112)+' '+T17_HORCRI
  from TMP017 with (nolock)

select *
  from TMP0171 with (nolock)

delete TMP0171 where T17_REGISTRO=1

select *
  from TMP017 with (nolock)

select *
  from TBS025 with (nolock)

insert into TBS025 
   (PARCHV,PARDES,PARVAL)
   select 1379,'ROMANEIO - PERIODOS DA SEPARACAO/CONFERENCIA DE PEDIDOS','07:00/09:00/11:00,09:01/14:00/17:00,14:01/18:00/09:00'

select *
  from TBS024 with (nolock)
 where TBSNOM='TMP017'

insert into TBS024
   (TBSNOM,TBSDES,TBSSEQ,TBSVALSEQ,TBSCTR,TBSMOD)
   select 'TMP017','TABELA TEMPORARIA DE ROMANEIO DE SEPARACAO','S',0,'N','C'

select *
  from TBS024 with (nolock)
 where TBSNOM='TBS139'

insert into TBS024
   (TBSNOM,TBSDES,TBSSEQ,TBSVALSEQ,TBSCTR,TBSMOD)
   select 'TBS139','ROMANEIO DE SEPARACAO','S',0,'N','C'

select top 1
       T17_EMPRESA
       ,T17_REGISTRO
       ,convert(char(8),T17_DATCRI,112) + ' ' + T17_HORFIM
  from TMP017 with (nolock)
 where T17_DATCRI=convert(date,getdate())
       --and T17_HORFIM >= @datahora
       and convert(char(8),T17_DATCRI,112) + ' ' + T17_HORFIM >= replace('2019-05-30 13:09','-','')
 order by T17_DATCRI, T17_REGISTRO
