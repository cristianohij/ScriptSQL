select convert(char(8),CPADATEMI,3)    as 'emissao',
       convert(char(8),CPADATVENREA,3) as 'vencimento',
       TBS057.FORCOD                   as 'cod.fornecedor',
       TBS006.FORNOM                   as 'nome fornecedor',
       str(CPAVAL,12,2)                as 'valor titulo',
       str(CPAVALABT,12,2)             as 'abatimento',
       str(CPAVALACR,12,2)             as 'acrescimo',
       str(CPAVALPAG,12,2)             as 'valor pago',
       str(CPAVALRES,12,2)             as 'residuo',
       str(CPAVAL-CPAVALABT-CPAVALPAG+CPAVALACR-CPAVALRES,12,2) as 'saldo a pagar'
  from TBS057 join TBS006 on TBS057.FORCOD=TBS006.FORCOD 
 where CPADATEMI between '2008-12-01' and '2008-12-31'
 order by TBS057.CPADATEMI,TBS057.CPADATVENREA

select distinct subString(convert(char(8),CPADATEMI,3),1,7) from TBS057 where CPADATEMI between '2008-12-01' and '2008-12-31'

select distinct subString(convert(char(8),CPADATEMI,1),1,2)
  from TBS057 where CPADATEMI between '2008-12-01' and '2008-12-31'

select * from TBS059

select distinct
       subString(NFEUSUEFE,4,2),
       subString(NFEUSUEFE,1,10),subString(NFEUSUEFE,7,4)+subString(NFEUSUEFE,4,2)+subString(NFEUSUEFE,1,2),*
  from TBS059
 where subString(NFEUSUEFE,7,4)+subString(NFEUSUEFE,4,2)+subString(NFEUSUEFE,1,2) between '20081201' and '20081231'


select 'Dezembro',
       sum((select sum(NFEVALPAR) from TBS0593
            where TBS0593.NFETIP=TBS059.NFETIP and
                  TBS0593.NFENUM=TBS059.NFENUM and
                  TBS0593.NFECOD=TBS059.NFECOD))
  from TBS059
 where subString(NFEUSUEFE,7,4)+subString(NFEUSUEFE,4,2)+subString(NFEUSUEFE,1,2) between '20081201' and '20081231'


declare _cursor cursor for select VENCOD,VENNOM from TBS004 (noLock) order by VENCOD

open _cursor

declare @codigo int ,@nome char(50)

fetch next from _cursor into @codigo ,@nome

select subString(convert(char(8),NFEDATVEN,1),1,2),sum(NFEVALPAR)
  from TBS0593
 where NFEDATVEN between '2008-12-01' and '2008-12-31'
-- group by NFEDATVEN


-- cria tabela para contendo os nomes das tabelas e quantidade
   if not exists(select name from sysobjects where name='CPA' and type='U')
      create table CPA(MESREF char(2),MES01 money,MES02 money)
   else delete CONTAREG

-- insere os dados na tabela criada
   insert into CONTAREG (NOME) select name from sysobjects where xtype='U' and Len(name)=6 order by name

Janeiro
Fevereiro
Marco
Abril
Maio
Junho
Julho
Agosto
Setembro
Outubro
Novembro
Dezembro

select sum(NFEVALPAR) from TBS0593 where NFEDATVEN between '2008-12-01' and '2008-12-31'

select convert(char(12),sum(NFEVALPAR)) from TBS0593
 where cast(subString(convert(char(8),NFEDATVEN,1),1,2) as int)=12

declare @mes int,@entrada char(12),@pagar char(12)
set @mes=1

while @mes<=12
   begin
      --set @entrada=(select convert(char(12),sum(NFEVALPAR))
        --              from TBS0593
          --           where cast(subString(convert(char(8),NFEDATVEN,1),1,2) as int)=@mes)


      set @pagar=(select convert(char(12),sum(CPAVAL-CPAVALABT+CPAVALACR))
                    from TBS057
                   where cast(subString(convert(char(8),CPADATVENREA,3),4,2) as int)=@mes)

      print @pagar

      print convert(char(2),@mes) + ' ' + @entrada + ' ' + @pagar
      set @mes=@mes+1
   end


select * from TBS0593

declare _cursor cursor for select NFETIP,NFENUM,NFECOD
                             from TBS0593 (noLock)
                            where NFETIP='N' and NFEDATVEN between '2009-01-01' and '2009-01-31'

open _cursor

declare @tipo char(1),@numero int,@fornecedor int

fetch next from _cursor into @tipo,@numero,@fornecedor

while @@fetch_status = 0
   begin
      print @tipo+' '+str(@numero,6)+' '+str(@fornecedor,6,0)

      set @pagar=(select convert(char(12),sum(CPAVAL-CPAVALABT+CPAVALACR))
                    from TBS057
                   where exists(select 'ex'
                                  from TBS0593 (noLock)
                                 where TBS0593.NFENUM=TBS057.CPATIT and TBS0593.NFECOD=TBS057.FORCOD and
                                       NFETIP='N' and NFEDATVEN between '2009-01-01' and '2009-01-31')


cast(subString(convert(char(8),CPADATVENREA,3),4,2) as int)=@mes)



      fetch next from _cursor into @tipo,@numero,@fornecedor
   end

close _cursor
deallocate _cursor



declare @i int,@j int,@entrada char(12),@pagar char(12)
set @i=1

while @i<=12
   begin
      set @entrada=(select convert(char(12),sum(NFEVALPAR))
                      from TBS0593 (noLock) join TBS059 (noLock) on TBS0593.NFETIP=TBS059.NFETIP and
                                                                    TBS0593.NFENUM=TBS059.NFENUM and
                                                                    TBS0593.NFECOD=TBS059.NFECOD
                     where NFEDATVEN>='2009-01-01' and
                           cast(subString(convert(char(8),NFEDATVEN,1),1,2) as int)=@i and NFEUSUEFE<>'')

      print 'valor total ' + case @i
                                when  1 then 'janeiro'
                                when  2 then 'fevereiro'
                                when  3 then 'marco'
                                when  4 then 'abril'
                                when  5 then 'maio'
                                when  6 then 'junho'
                                when  7 then 'julho'
                                when  8 then 'agosto'
                                when  9 then 'setembro'
                                when 10 then 'outubro'
                                when 11 then 'novembro'
                                when 12 then 'dezembro'
                             end
            +' '+Ltrim(@entrada)

      set @j = 1
      while @j<=12
         begin
            set @pagar=(select convert(char(12),sum(CPAVAL-CPAVALABT+CPAVALACR))
                          from TBS057
                         where exists(select 'ex'
                                        from TBS0593 (noLock) join TBS059 (noLock) on TBS0593.NFETIP=TBS059.NFETIP and
                                                                    TBS0593.NFENUM=TBS059.NFENUM and
                                                                    TBS0593.NFECOD=TBS059.NFECOD
                                       where TBS0593.NFENUM=TBS057.CPATIT and TBS0593.NFECOD=TBS057.FORCOD and
                                             NFEDATVEN>='2009-01-01' and
                                             cast(subString(convert(char(8),NFEDATVEN,1),1,2) as int)=@i
                                             and NFEUSUEFE<>'') and
                               CPADATVENREA>='2009-01-01' and
                               cast(subString(convert(char(8),CPADATVENREA,3),4,2) as int)=@j)

            if cast(@pagar as money) > 0
            print case @j
                     when  1 then 'janeiro'
                     when  2 then 'fevereiro'
                     when  3 then 'marco'
                     when  4 then 'abril'
                     when  5 then 'maio'
                     when  6 then 'junho'
                     when  7 then 'julho'
                     when  8 then 'agosto'
                     when  9 then 'setembro'
                     when 10 then 'outubro'
                     when 11 then 'novembro'
                     when 12 then 'dezembro'
                  end
                  +' '+Ltrim(@pagar)
            
            set @j=@j+1
         end

      set @i=@i+1
   end






declare @i int,@j int,@entrada char(12),@pagar char(12)
set @i=1

while @i<=12
   begin
      set @entrada=(select convert(char(12),sum(NFEVALPAR))
                      from TBS0593 (noLock) join TBS059 (noLock) on TBS0593.NFETIP=TBS059.NFETIP and
                                                                    TBS0593.NFENUM=TBS059.NFENUM and
                                                                    TBS0593.NFECOD=TBS059.NFECOD
                     where NFEDATEMI between '2008-06-01' and '2008-12-31' and
                           cast(subString(convert(char(8),NFEDATEMI,1),1,2) as int)=@i and NFEUSUEFE<>'')

      print 'valor total ' + case @i
                                when  1 then 'janeiro'
                                when  2 then 'fevereiro'
                                when  3 then 'marco'
                                when  4 then 'abril'
                                when  5 then 'maio'
                                when  6 then 'junho'
                                when  7 then 'julho'
                                when  8 then 'agosto'
                                when  9 then 'setembro'
                                when 10 then 'outubro'
                                when 11 then 'novembro'
                                when 12 then 'dezembro'
                             end
            +' '+Ltrim(@entrada)

      set @j = 1
      while @j<=12
         begin
            set @pagar=(select convert(char(12),sum(CPAVAL-CPAVALABT+CPAVALACR))
                          from TBS057
                         where exists(select 'ex'
                                        from TBS0593 (noLock) join TBS059 (noLock) on TBS0593.NFETIP=TBS059.NFETIP and
                                                                   TBS0593.NFENUM=TBS059.NFENUM and
                                                                   TBS0593.NFECOD=TBS059.NFECOD
                                       where TBS0593.NFENUM=TBS057.CPATIT and TBS0593.NFECOD=TBS057.FORCOD and
                                             NFEDATEMI between '2008-06-01' and '2008-12-31' and
                                             cast(subString(convert(char(8),NFEDATEMI,1),1,2) as int)=@i
                                             and NFEUSUEFE<>'') and
                               CPADATVENREA>='2008-06-01' and
                               cast(subString(convert(char(8),CPADATVENREA,3),4,2) as int)=@j)

            if cast(@pagar as money) > 0
            print case @j
                     when  1 then 'janeiro'
                     when  2 then 'fevereiro'
                     when  3 then 'marco'
                     when  4 then 'abril'
                     when  5 then 'maio'
                     when  6 then 'junho'
                     when  7 then 'julho'
                     when  8 then 'agosto'
                     when  9 then 'setembro'
                     when 10 then 'outubro'
                     when 11 then 'novembro'
                     when 12 then 'dezembro'
                  end
                  +' '+Ltrim(@pagar)
            
            set @j=@j+1
         end

      set @i=@i+1
   end
