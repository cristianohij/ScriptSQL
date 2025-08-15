declare @datai char(8), @dataf char(8)

set @datai = '20130901'
set @dataf = '20130930'

select count(*),
       case ENFSIT
          when  1 then 'Em digitacao'
          when  2 then 'Dados validos'
          when  3 then 'Dados invalidos'
          when  4 then 'XML gerado'
          when  5 then 'Assinada'
          when  6 then 'Autorizada'
          when  7 then 'Cancelada'
          when  8 then 'Denegada'
          when  9 then 'Em processamento na Sefaz'
          when 10 then 'Rejeitada'
          when 11 then 'Inutilizada'
          when 12 then 'Servico paralizado'
          when 13 then 'Contingencia via DPEC'
          when 20 then 'Outras'
       end
  from TBS080 (nolock)
 where ENFDATEMI between @datai and @dataf
 group by ENFSIT

select ENFSIT,
       case ENFSIT
          when  1 then 'Em digitacao'
          when  2 then 'Dados validos'
          when  3 then 'Dados invalidos'
          when  4 then 'XML gerado'
          when  5 then 'Assinada'
          when  6 then 'Autorizada'
          when  7 then 'Cancelada'
          when  8 then 'Denegada'
          when  9 then 'Em processamento na Sefaz'
          when 10 then 'Rejeitada'
          when 11 then 'Inutilizada'
          when 12 then 'Servico paralizado'
          when 13 then 'Contingencia via DPEC'
          when 20 then 'Outras'
       end,
       count(*)
  from TBS080 (nolock)
 where ENFDATEMI between '20130101' and '20130131'
 group by ENFSIT

declare @max int, @curr int ,@cont int, @emp smallint, @datai char(8), @dataf char(8),@serie int

set @emp = 0
set @cont = 0
set @datai = '20170401'
set @dataf = '20170430'
set @serie = 0

select @max = max(ENFNUM) from TBS080 (nolock) where ENFDATEMI between @datai and @dataf and ENFEMPCOD = @emp and SNESER = @serie
select @curr = min(ENFNUM) from TBS080 (nolock) where ENFDATEMI between @datai and @dataf and ENFEMPCOD = @emp and SNESER = @serie

while @curr < @max
   begin
      set @curr = @curr + 1
      if(not exists(select ENFNUM from TBS080 (nolock) where ENFNUM = @curr and ENFDATEMI between @datai and @dataf and ENFEMPCOD = @emp and SNESER = @serie))
         begin
            set @cont = @cont + 1
            print 'numero ' + rtrim(cast(@curr as char(6))) + ' nao encontrado ' + rtrim(cast(@cont as char(6)))
         end
   end

declare @datai char(8), @dataf char(8)

set @datai = '20131226'
set @dataf = '20131231'

select SNESER as 'serie',
       ENFNUM as 'nf',
       case ENFSIT
          when  1 then 'Em digitacao'
          when  2 then 'Dados validos'
          when  3 then 'Dados invalidos'
          when  4 then 'XML gerado'
          when  5 then 'Assinada'
          when  6 then 'Autorizada'
          when  7 then 'Cancelada'
          when  8 then 'Denegada'
          when  9 then 'Em processamento na Sefaz'
          when 10 then 'Rejeitada'
          when 11 then 'Inutilizada'
          when 12 then 'Servico paralizado'
          when 13 then 'Contingencia via DPEC'
          when 20 then 'Outras'
       end as 'situacao'
  from TBS080 (nolock)
 where ENFDATEMI between @datai and @dataf and ENFSIT = 11
 order by SNESER,ENFNUM

-- sequência sem a série
declare @max int, @curr int ,@cont int, @emp smallint, @datai char(8), @dataf char(8)

set @emp = 0
set @cont = 0
set @datai = '20170401'
set @dataf = '20170430'

select @max = max(ENFNUM) from TBS080 (nolock) where ENFDATEMI between @datai and @dataf and ENFEMPCOD = @emp
select @curr = min(ENFNUM) from TBS080 (nolock) where ENFDATEMI between @datai and @dataf and ENFEMPCOD = @emp

while @curr < @max
   begin
      set @curr = @curr + 1
      if(not exists(select ENFNUM from TBS080 (nolock) where ENFNUM = @curr and ENFDATEMI between @datai and @dataf and ENFEMPCOD = @emp))
         begin
            set @cont = @cont + 1
            print 'numero ' + rtrim(cast(@curr as char(6))) + ' nao encontrado ' + rtrim(cast(@cont as char(6)))
         end
   end


-- refeito

declare @max int, @curr int ,@cont int, @emp smallint, @datai char(8), @dataf char(8),@serie int, @aux int

set @emp = 0
set @cont = 0
set @datai = '20170101'
set @dataf = '20171015'
set @serie = 0
set @aux = 0

select @max = max(ENFNUM) from TBS080 (nolock) where ENFDATEMI between @datai and @dataf and ENFEMPCOD = @emp and SNESER = @serie
select @curr = min(ENFNUM) from TBS080 (nolock) where ENFDATEMI between @datai and @dataf and ENFEMPCOD = @emp and SNESER = @serie

--set @curr = 200000

while @curr < @max
   begin
      set @curr = @curr + 1

      if not exists(select ENFNUM from TBS080 (nolock) where ENFNUM = @curr and ENFDATEMI between @datai and @dataf and ENFEMPCOD = @emp and SNESER = @serie)
         begin
            set @cont = @cont + 1

            if @aux = 0
               set @aux = @curr

            --print 'numero ' + rtrim(cast(@curr as char(6))) + ' nao encontrado ' + rtrim(cast(@cont as char(6)))
            --print 'numero ' + rtrim(cast(@curr as char(6))) + ' ... ' + rtrim(cast(@aux as char(6)))
            --set @aux = 0

         end
      else
         begin
            if @aux > 0
               begin
                  print '-> ' + rtrim(cast(@aux as char(6))) + ' ... ' + rtrim(cast(@curr-1 as char(6)))
                  set @aux = 0
               end

            --set @aux = @curr

         end

      --if @curr = 3251
         --break
  
   end


-- autorizadas

set nocount on

declare @max int, @curr int ,@cont int, @emp smallint, @datai char(8), @dataf char(8),@serie int, @aux int

set @emp = 0
set @cont = 0
set @datai = '20130101'
set @dataf = '20141231'
set @serie = 4
set @aux = 0

select @max = max(ENFNUM) from TBS080 (nolock) where ENFSIT=6 and ENFDATEMI between @datai and @dataf and ENFEMPCOD = @emp and SNESER = @serie
select @curr = min(ENFNUM) from TBS080 (nolock) where ENFSIT=6 and ENFDATEMI between @datai and @dataf and ENFEMPCOD = @emp and SNESER = @serie

if @max is null set @max = 0
if @curr is null set @curr = 0

print convert(date, @datai, 103)
print convert(date, @dataf, 103)
print 'série: ' + rtrim(cast(@serie as char(6)))
select EMPNOMFAN empresa,EMPCGC  CNPJ from TBS023 (nolock) where EMPCOD=@emp

--print @max
--print @curr

--select ENFNUM from TBS080 (nolock) where ENFEMPCOD=@emp and SNESER=@serie and ENFSIT in(6,7,8,11) and ENFNUM between @curr+1 and @max-1

/*if not exists(select '' from TBS080 (nolock) where ENFEMPCOD=@emp and SNESER=@serie and ENFSIT in(6,7,8,11) and ENFNUM between @curr + 1 and @max)
   begin
      print '-> ' + rtrim(cast(@curr+1 as char(6))) + ' ... ' + rtrim(cast(@max-1 as char(6))) + ' ... série: ' + rtrim(cast(@serie as char(6)))
      set @max = 0
   end   
*/
while @curr < @max
   begin
      set @curr = @curr + 1

      if @curr > @max
         break

      if not exists(select '' from TBS080 (nolock) where ENFEMPCOD=@emp and SNESER=@serie and ENFSIT in(6,7,8,11) and ENFNUM between @curr and @max-1)
         begin
            if @curr = @max-1
               print '-> ' + rtrim(cast(@curr as char(6))) --+ ' ... ' + rtrim(cast(@max-1 as char(6))) -- + ' ... série: ' + rtrim(cast(@serie as char(6)))
            else
               print '-> ' + rtrim(cast(@curr as char(6))) + ' ... ' + rtrim(cast(@max-1 as char(6))) -- + ' ... série: ' + rtrim(cast(@serie as char(6)))

            set @max = 0
      end   

      -- if exists(select ENFNUM from TBS080 (nolock) where ENFSIT=6 and ENFNUM = @curr and ENFDATEMI between @datai and @dataf and ENFEMPCOD = @emp and SNESER = @serie)
      --select 1 from TBS080 (nolock) where ENFSIT=6 and ENFNUM = @curr and ENFEMPCOD = @emp and SNESER = @serie order by ENFEMPCOD, SNESER, ENFSIT, ENFNUM
      --select 1 from TBS080 (nolock) where ENFSIT in(6,7,8,11) and ENFNUM = @curr and ENFEMPCOD = @emp and SNESER = @serie order by ENFEMPCOD, SNESER, ENFSIT, ENFNUM
      
      --if @@rowcount > 0
      if not exists(select '' from TBS080 (nolock) where ENFEMPCOD=@emp and SNESER=@serie and ENFSIT in(6,7,8,11) and ENFNUM=@curr) --and @aux = 0
          begin
            --set @cont = @cont + 1

            if @aux = 0
               set @aux = @curr

            --print 'numero ' + rtrim(cast(@curr as char(6))) + ' nao encontrado ' + rtrim(cast(@cont as char(6)))
            --print 'numero ' + rtrim(cast(@curr as char(6))) + ' ... ' + rtrim(cast(@aux as char(6)))
            --set @aux = 0


         end

      else
         begin
            if @aux > 0
               begin
                  if @aux = @curr-1
                     print '-> ' + rtrim(cast(@aux as char(6))) --+ ' ... ' + rtrim(cast(@curr-1 as char(6))) --+ ' ... série: ' + rtrim(cast(@serie as char(6)))
                  else
                     print '-> ' + rtrim(cast(@aux as char(6))) + ' ... ' + rtrim(cast(@curr-1 as char(6))) --+ ' ... série: ' + rtrim(cast(@serie as char(6)))

                  set @aux = 0
               end

            --set @aux = @curr

         end

      --if @curr = 3251
         --break
  
   end


select * from master..sysservers

select SNESER,ENFNUM,ENFDATEMI from TBS080 (nolock) where ENFSIT=6 and SNESER=0 and ENFDATEMI between '20080101' and '20171015' order by ENFDATEMI

select SNESER,ENFNUM,ENFDATEMI from tt.SIBD.dbo.TBS080 where ENFSIT=6 and SNESER=0 and ENFDATEMI between '20080101' and '20171015' order by ENFDATEMI

select SNESER,ENFNUM,ENFDATEMI from cd.SIBD.dbo.TBS080 where ENFSIT=6 and SNESER=0 and ENFDATEMI between '20080101' and '20171015' order by ENFDATEMI

select SNESER,ENFNUM,ENFDATEMI from BA.SIBD.dbo.TBS080 where ENFSIT=6 and SNESER=0 and ENFDATEMI between '20080101' and '20171015' order by ENFDATEMI

select SNESER,ENFNUM,ENFDATEMI from BB.SIBD2.dbo.TBS080 where ENFSIT=6 and SNESER=0 and ENFDATEMI between '20080101' and '20171015' order by ENFDATEMI

select SNESER,ENFNUM,ENFDATEMI from PP.SIBD.dbo.TBS080 where ENFSIT=6 and SNESER=0 and ENFDATEMI between '20080101' and '20171015' order by ENFDATEMI


select SNESER,ENFNUM,ENFDATEMI from MI.SIBD.dbo.TBS080 where ENFSIT=6 and SNESER=0 and ENFDATEMI between '20080101' and '20171015' order by ENFDATEMI


select max(ENFNUM) from TBS080 (nolock) where SNESER=0