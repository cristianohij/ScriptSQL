--  best bag ... empresa 2

-- contas a receber

drop function SomatorioTitulosReceber
go

create function SomatorioTitulosReceber(@emptit smallint ,@empprefix smallint ,@empcli smallint ,@prefix char(3) ,@titulo int ,@parcela char(2) ,@cliente int)
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select CREVAL - CREVALABT + CREVALACR
                        from TBS056 (nolock)
                       where CREEMPCOD = @emptit and PFXEMPCOD = @empprefix and CLIEMPCOD = @empcli and PFXCOD = @prefix and CRETIT = @titulo and
                             CREPAR = @parcela and CLICOD = @cliente)
      return @retorno
   end
go

select sum(
       case
          when CREDATBAI='17530101' then dbo.CREVALSDO(0,0,0,PFXCOD,CRETIT,CREPAR,CLICOD)
          when CREDATBAI >= '20151001' then dbo.SomatorioTitulosReceber(0,0,0,PFXCOD,CRETIT,CREPAR,CLICOD)
       end)
  from TBS056 (nolock)
 where CREDATEMI <= '20151031' and
       CLICOD not in(select CLICOD from TBS002 (nolock)
                      where CLINOM Like('BEST BAG%') or
                            CLINOM Like('BEST OFFICE%') or
                            CLINOM Like('MISASPEL%') or
                            CLINOM Like('%PAPELYNA%') or
                            CLINOM Like('TANBY%'))


select CLINOM,
       sum(
       case
          when CREDATBAI='17530101' then dbo.CREVALSDO(0,0,0,PFXCOD,CRETIT,CREPAR,CLICOD)
          when CREDATBAI >= '20151001' then dbo.SomatorioTitulosReceber(0,0,0,PFXCOD,CRETIT,CREPAR,CLICOD)
       end)
  from TBS056 (nolock)
 where CREDATEMI <= '20151031' and
       CLICOD in(select CLICOD from TBS002 (nolock)
                      where CLINOM Like('BEST BAG%') or
                            CLINOM Like('BEST OFFICE%') or
                            CLINOM Like('MISASPEL%') or
                            CLINOM Like('%PAPELYNA%') or
                            CLINOM Like('TANBY%'))
 group by CLINOM



-- contas a pagar

drop function SomatorioTitulosPagar
go

create function SomatorioTitulosPagar(@emptit smallint ,@empprefix smallint ,@empfor smallint ,@prefix char(3) ,@titulo decimal(10) ,@parcela char(2) ,@fornece int)
        returns decimal(11,4)
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select CPAVAL - CPAVALABT + CPAVALACR
                        from TBS057 (nolock)
                       where CPAEMPCOD = @emptit and PFXEMPCOD = @empprefix and FOREMPCOD = @empfor and PFXCOD = @prefix and CPATIT = @titulo and
                             CPAPAR = @parcela and FORCOD = @fornece)
      return @retorno
   end
go

select sum(
          case
             when CPADATBAI='17530101' then dbo.CPAVALSDO(0,0,0,PFXCOD,CPATIT,CPAPAR,FORCOD)
             when CPADATBAI >= '20151001' then dbo.SomatorioTitulosPagar(0,0,0,PFXCOD,CPATIT,CPAPAR,FORCOD)
             else 0
          end)
  from TBS057 (nolock)
 where CPADATEMI <= '20151031' and
       FORCOD not in(select FORCOD from TBS006 (nolock)
                      where FORNOM Like('BEST BAG%') or
                            FORNOM Like('BEST OFFICE%') or
                            FORNOM Like('MISASPEL%') or
                            FORNOM Like('%PAPELYNA%') or
                            FORNOM Like('TANBY%'))

select FORNOM,sum(
          case
             when CPADATBAI='17530101' then dbo.CPAVALSDO(0,0,0,PFXCOD,CPATIT,CPAPAR,FORCOD)
             when CPADATBAI >= '20151001' then dbo.SomatorioTitulosPagar(0,0,0,PFXCOD,CPATIT,CPAPAR,FORCOD)
             else 0
          end)
  from TBS057 (nolock)
 where CPADATEMI <= '20151031' and
       FORCOD in(select FORCOD from TBS006 (nolock)
                  where FORNOM Like('BEST BAG%') or
                        FORNOM Like('BEST OFFICE%') or
                        FORNOM Like('MISASPEL%') or
                        FORNOM Like('%PAPELYNA%') or
                        FORNOM Like('TANBY%'))
 group by FORNOM
