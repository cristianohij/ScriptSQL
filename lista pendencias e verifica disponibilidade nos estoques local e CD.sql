-- no SQL 2000 nao funciona (noLock) para links remotos

if exists(select name from sysobjects where name='sp_PENLOC' and type='P')
   drop procedure sp_PENLOC
go

create procedure sp_PENLOC with recompile as
   begin 
      if not exists(select name from sysobjects where name='PENLOC' and type='U')
         begin
            create table SIBD.dbo.PENLOC(PROCOD varchar(15),PRODES varchar(50),PROUM1 varchar(2),QTDPEN money,QTDESTLOC money,QTDESTCD money)
         end
      else delete SIBD.dbo.PENLOC

      insert into PENLOC
      select PED.PROCOD,PRO.PRODES,PRO.PROUM1,SUM(PED.PRPQTD*PED.PRPQTDEMB),EST.ESTQTDATU-EST.ESTQTDRES as 'est.local',CD.ESTQTDATU-CD.ESTQTDRES as 'est.CD'
        from SIBD.dbo.TBS058 PED (noLock)
             join SIBD.dbo.TBS010 PRO (noLock) on PRO.PROCOD=PED.PROCOD
             join SIBD.dbo.TBS032 EST (noLock) on EST.PROCOD=PED.PROCOD and EST.ESTLOC=1
             join SRVCD.SIBD.dbo.TBS032 CD on CD.PROCOD=PED.PROCOD and CD.ESTLOC=1
       where PED.PRPSIT='P' and PRPESTLOC=1 and (EST.ESTQTDATU-EST.ESTQTDRES > 0 or CD.ESTQTDATU-CD.ESTQTDRES > 0)
       group by PED.PROCOD,PRO.PROUM1,PRO.PRODES,EST.ESTQTDATU,EST.ESTQTDRES,CD.ESTQTDATU,CD.ESTQTDRES
    end

sp_PENLOC
    
select * from SIBD.dbo.PENLOC

-- versao com cursor
declare @produto varchar(15),@qPendente money,@qEstloc money,@qEstCD money

declare pendencias scroll cursor for select PROCOD,SUM(PRPQTD*PRPQTDEMB) as 'qPendente' from SIBD.dbo.TBS058 (noLock) where PRPSIT='P' and PRPESTLOC=1 group by PROCOD

open pendencias

fetch next from pendencias into @produto,@qPendente

while @@fetch_status=0 begin
   set @qEstloc = (select isnull(ESTQTDATU-ESTQTDRES,0) from SIBD.dbo.TBS032 (noLock) where PROCOD=@produto and ESTLOC=1)
   set @qEstCD = (select isnull(ESTQTDATU-ESTQTDRES,0) from SRVCD.SIBD.dbo.TBS032 where PROCOD=@produto and ESTLOC=1)

   if @qEstloc > 0 or @qEstCD > 0
      print @produto + ' ' + str(@qPendente,9,3) + ' ' + str(@qEstloc,9,3) + ' ' + str(@qEstCD,9,3)
      
   fetch next from pendencias into @produto,@qPendente
end

close pendencias
deallocate pendencias


-- executa a stored procedure e lista os dados

-- cria a tabela de dados
exec sp_PENLOC

-- lista os dados da tabela criada
select PROCOD as 'produto',PRODES as 'descricao',PROUM1 as 'um',QTDPEN as 'qtde_pendente',QTDESTLOC as 'estoque_local',QTDESTCD as 'estoque_CD' from PENLOC
 order by PRODES