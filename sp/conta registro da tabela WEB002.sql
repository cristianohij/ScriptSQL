if exists(select name from sysobjects where name='SP_CONTWEB002' and type='P')
   drop procedure SP_CONTWEB002
go

create procedure SP_CONTWEB002(@proDe varchar(15) output ,@proAte varchar(15) output ,@negocio smallint output ,
                               @categoria smallint output, @classe smallint output ,@retorno int output) as

   declare @negAte smallint ,@catAte smallint ,@claAte smallint

   if @negocio = 0
      set @negAte = 999 
   else
      set @negAte = @negocio

   if @categoria = 0
      set @catAte = 999 
   else
      set @catAte = @categoria

   if @classe = 0
      set @claAte = 999 
   else
      set @claAte = @classe

   set @retorno = (select isnull(count(*),0) from WEB002 (noLock)
                    where PROCOD between @proDe and @proAte and
                          PRONEGSEQ between @negocio and @negAte and
                          PROCATSEQ between @categoria and @catAte and
                          PROCLASEQ between @classe and @claAte)

go

declare @registros int
exec SP_CONTWEB002 '164' ,'1649999' ,0 ,0 ,0 ,@registros output
select @registros
