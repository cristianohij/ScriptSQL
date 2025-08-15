if exists(select name from sysobjects where name='sp_gravaLog' and type='P')
   drop procedure sp_gravaLog
go

create procedure sp_gravaLog(
   @usuario    char(25) output,
   @operacao   char(10) output,
   @rotina     char(10) output,
   @empresa    smallint output,
   @produto    char(15) output,
   @localest   smallint output,
   @qatuala    money    output,
   @qatualp    money    output,
   @qpendentea money    output,
   @qpendentep money    output,
   @qcompraa   money    output,
   @qcomprap   money    output,
   @qreservaa  money    output,
   @qreservap  money    output ) as

   begin 
      if not exists(select name from sysobjects where name='TBS032_LG' and type='U')
         begin
            create table TBS032_LG(
               DATAHORA   datetime  not null default (''),
               USUARIO    char (25) not null default (''),
               OPERACAO   char (10)     null default (''),
               ROTINA     char (10)     null default (''),
               EMPRESA    smallint      null default (0) ,
               PRODUTO    char (15)     null default (''),
               LOCALEST   smallint      null default (0) ,
               QATUALA    money         null default (0) ,
               QATUALP    money         null default (0) ,
               QPENDENTEA money         null default (0) ,
               QPENDENTEP money         null default (0) ,
               QCOMPRAA   money         null default (0) ,
               QCOMPRAP   money         null default (0) ,
               QRESERVAA  money         null default (0) ,
               QRESERVAP  money         null default (0)  )
         end
      else
         insert into TBS032_LG values(
            current_timestamp,
            @usuario,
            @operacao,
            @rotina,
            @empresa,
            @produto,
            @localest,
            @qatuala,
            @qatualp,
            @qpendentea,
            @qpendentep,
            @qcompraa,
            @qcomprap,
            @qreservaa,
            @qreservap)
   end

