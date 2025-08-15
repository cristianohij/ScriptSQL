-- pendências

if not exists(select name from sysobjects where name = 'tmppen' and type='U')
   begin
      create table tmppen
         (empresa tinyint not null default 0, localEstoque tinyint not null default 0, codigoProduto char(15) not null default '', qPendenteAnterior money default 0,
          qPendentePedidos money default 0, qPendenteSolCompras money default 0,
          constraint itmppen primary key(empresa, localEstoque, codigoProduto))
   end
      else delete from tmppen

-- reservas

if not exists(select name from sysobjects where name = 'tmpres' and type='U')
   begin
      create table tmpres
         (empresa tinyint not null default 0, localEstoque tinyint not null default 0, codigoProduto char(15) not null default '',
          qReservaAnterior money default 0, qReservaPedidos money default 0, qReservaSolCompras money default 0, qReservaMovInternos money default 0,
          constraint itmpres primary key(empresa, localEstoque, codigoProduto))
   end
      else delete from tmpres

insert into tmpres
select PROEMPCOD,ESTLOC,PROCOD,ESTQTDRES,
       (select isNull(sum(PRPQTD * PRPQTDEMB),0) from TBS058 (nolock)
         where PRPSIT = 'R' and PRPESTLOC = ESTLOC and PRPMOVEST = 'S' and PRPEMP = TBS032.PROEMPCOD and TBS058.PROCOD = TBS032.PROCOD),
       (select isNull(sum((SDCQTDATD - SDCQTDBAI) * SDCQTDEMB),0) from TBS0761 (nolock)
         where LESCOD = ESTLOC and SDCQTDRES = 0 and TBS0761.PROEMPCOD = TBS032.PROEMPCOD and TBS0761.PROCOD = TBS032.PROCOD),
       (select isnull(sum(TBS0371.MVIQTDATD*TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD=TBS0371.MVIEMPCOD and TBS037.MVIDOC=TBS0371.MVIDOC and TBS037.MVIDATEFE is null and
                                                        TBS037.MVILOCORI=TBS032.ESTLOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD=TBS037.TMVEMPCOD and TBS033.TMVCOD=TBS037.TMVCOD and TBS033.TMVMOVAUT='N' and
                                                        TBS033.TMVTIP='S'
         where TBS0371.PROEMPCOD=TBS032.PROEMPCOD and TBS0371.PROCOD=TBS032.PROCOD)
 from TBS032 (noLock)
 where ESTQTDRES <>
       (select isNull(sum(PRPQTD * PRPQTDEMB),0) from TBS058 (nolock)
         where PRPSIT = 'R' and PRPESTLOC = ESTLOC and PRPMOVEST = 'S' and PRPEMP = TBS032.PROEMPCOD and TBS058.PROCOD=TBS032.PROCOD) +
       (select isNull(sum((SDCQTDATD - SDCQTDBAI) * SDCQTDEMB),0) from TBS0761 (nolock)
         where LESCOD = ESTLOC and SDCQTDRES = 0 and TBS0761.PROEMPCOD = TBS032.PROEMPCOD and TBS0761.PROCOD = TBS032.PROCOD) +
       (select isnull(sum(TBS0371.MVIQTDATD*TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD=TBS0371.MVIEMPCOD and TBS037.MVIDOC=TBS0371.MVIDOC and TBS037.MVIDATEFE is null and
                                                        TBS037.MVILOCORI=TBS032.ESTLOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD=TBS037.TMVEMPCOD and TBS033.TMVCOD=TBS037.TMVCOD and TBS033.TMVMOVAUT='N' and
                                                        TBS033.TMVTIP='S'
         where TBS0371.PROEMPCOD=TBS032.PROEMPCOD and TBS0371.PROCOD=TBS032.PROCOD)
 order by PROCOD

-- atualiza saldo clientes

update TBS002 set CLIPEDLIB = (select sum(dbo.PDVTOTLIB(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = CLICOD),
                  CLIPEDBLQ = (select sum(dbo.PDVTOTBLQ(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = CLICOD)
  from TBS002 (nolock)
 where CLIPEDLIB <> (select sum(dbo.PDVTOTLIB(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = CLICOD) or
       CLIPEDBLQ <> (select sum(dbo.PDVTOTBLQ(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = CLICOD)


-- pedidos liberados

update TBS002 set CLIPEDLIB = (select sum(dbo.PDVTOTLIB(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = CLICOD)
  from TBS002 (nolock)
 where CLIPEDLIB <> (select sum(dbo.PDVTOTLIB(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = CLICOD)

-- pedidos bloqueados

update TBS002 set CLIPEDBLQ = (select sum(dbo.PDVTOTBLQ(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = CLICOD)
  from TBS002 (nolock)
 where CLIPEDBLQ <> (select sum(dbo.PDVTOTBLQ(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = CLICOD)

-- contas a receber

update TBS002 set CLITITABT = (select sum(dbo.CREVALSDO(CREEMPCOD,PFXEMPCOD,TBS056.CLIEMPCOD,PFXCOD,CRETIT,CREPAR,TBS056.CLICOD))
                                 from TBS056 (nolock) where TBS056.CLIEMPCOD = TBS002.CLIEMPCOD and TBS056.CLICOD = TBS002.CLICOD)
  from TBS002 (nolock)
 where CLITITABT <> (select sum(dbo.CREVALSDO(CREEMPCOD,PFXEMPCOD,TBS056.CLIEMPCOD,PFXCOD,CRETIT,CREPAR,TBS056.CLICOD))
                       from TBS056 (nolock) where TBS056.CLIEMPCOD = TBS002.CLIEMPCOD and TBS056.CLICOD = TBS002.CLICOD)
