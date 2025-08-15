--select PROCOD,PROCODBAR1,PROCODBAR2,PROCODBAR3,PROCODBAR4 from TBS010 (noLock)
-- where PROCODBAR1<>'' or PROCODBAR2<>'' or PROCODBAR3<>'' or PROCODBAR4<>''

-- diferenca entre codigos de barras 1

insert arquivoTexto...dif_barras1#txt (cod_tanby,codigo,bar1_tanby,barras1,descricao)
select Left(isnull(bar.PROCOD,''),8) as cod_tanby,
       Left(isnull(TBS010.PROCOD,''),8) as codigo,
       Left(isnull(bar.PROCODBAR1,''),15) as bar1_tanby,
       Left(isnull(TBS010.PROCODBAR1,''),15) as barras1,
       PRODES as descricao
  from arquivoTexto...barras#txt bar,TBS010 (noLock)
 where bar.PROCOD=TBS010.PROCOD and
       bar.PROCODBAR1<>'' and
       TBS010.PROCODBAR1<>'' and
       bar.PROCODBAR1<>TBS010.PROCODBAR1

-- diferenca entre codigos de barras 2

insert arquivoTexto...dif_barras2#txt (cod_tanby,codigo,bar1_tanby,barras1,descricao)
select Left(isnull(bar.PROCOD,''),8) as cod_tanby,
       Left(isnull(TBS010.PROCOD,''),8) as codigo,
       Left(isnull(bar.PROCODBAR2,''),15) as bar2_tanby,
       Left(isnull(TBS010.PROCODBAR2,''),15) as barras2,
       PRODES as descricao
  from arquivoTexto...barras#txt bar,TBS010 (noLock)
 where bar.PROCOD=TBS010.PROCOD and
       bar.PROCODBAR2<>'' and
       TBS010.PROCODBAR2<>'' and
       bar.PROCODBAR2<>TBS010.PROCODBAR2

-- diferenca entre codigos de barras 3

insert arquivoTexto...dif_barras3#txt (cod_tanby,codigo,bar1_tanby,barras1,descricao)
select Left(isnull(bar.PROCOD,''),8) as cod_tanby,
       Left(isnull(TBS010.PROCOD,''),8) as codigo,
       Left(isnull(bar.PROCODBAR3,''),15) as bar3_tanby,
       Left(isnull(TBS010.PROCODBAR3,''),15) as barras3,
       PRODES as descricao
  from arquivoTexto...barras#txt bar,TBS010 (noLock)
 where bar.PROCOD=TBS010.PROCOD and
       bar.PROCODBAR3<>'' and
       TBS010.PROCODBAR3<>'' and
       bar.PROCODBAR3<>TBS010.PROCODBAR3

-- diferenca entre codigos de barras 4

insert arquivoTexto...dif_barras4#txt (cod_tanby,codigo,bar1_tanby,barras1,descricao)
select Left(isnull(bar.PROCOD,''),8) as cod_tanby,
       Left(isnull(TBS010.PROCOD,''),8) as codigo,
       Left(isnull(bar.PROCODBAR4,''),15) as barr_tanby,
       Left(isnull(TBS010.PROCODBAR4,''),15) as barras4,
       PRODES as descricao
  from arquivoTexto...barras#txt bar,TBS010 (noLock)
 where bar.PROCOD=TBS010.PROCOD and
       bar.PROCODBAR4<>'' and
       TBS010.PROCODBAR4<>'' and
       bar.PROCODBAR4<>TBS010.PROCODBAR4

-- inclui codigos de barras 1

update TBS010 set PROCODBAR1=bar.PROCODBAR1
--select Left(isnull(bar.PROCOD,''),8) as cod_tanby,
--       Left(isnull(TBS010.PROCOD,''),8) as codigo,
--       Left(isnull(bar.PROCODBAR1,''),15) as bar1_tanby,
--       Left(isnull(TBS010.PROCODBAR1,''),15) as barras1,
--       PRODES as descricao
  from arquivoTexto...barras#txt bar,TBS010 (noLock)
 where bar.PROCOD=TBS010.PROCOD and
       bar.PROCODBAR1<>'' and
       TBS010.PROCODBAR1=''

-- inclui codigos de barras 2

update TBS010 set PROCODBAR2=bar.PROCODBAR2
  from arquivoTexto...barras#txt bar,TBS010 (noLock)
 where bar.PROCOD=TBS010.PROCOD and
       bar.PROCODBAR2<>'' and
       TBS010.PROCODBAR2=''

-- inclui codigos de barras 3

update TBS010 set PROCODBAR3=bar.PROCODBAR3
  from arquivoTexto...barras#txt bar,TBS010 (noLock)
 where bar.PROCOD=TBS010.PROCOD and
       bar.PROCODBAR3<>'' and
       TBS010.PROCODBAR3=''

-- inclui codigos de barras 4

update TBS010 set PROCODBAR4=bar.PROCODBAR4
  from arquivoTexto...barras#txt bar,TBS010 (noLock)
 where bar.PROCOD=TBS010.PROCOD and
       bar.PROCODBAR4<>'' and
       TBS010.PROCODBAR4=''

-- produtos ativos sem codigos de barras

insert arquivoTexto...sembarras#txt (codigo,barras1,barras2,barras3,barras4,descricao)
select PROCOD as codigo,
       PROCODBAR1 as barras1,
       PROCODBAR2 as barras2,
       PROCODBAR3 as barras3,
       PROCODBAR4 as barras4,
       PRODES as descricao
  from TBS010 (noLock)
 where PROSTATUS='A' and PROCODBAR1=''


-- papelyna
-- foram incluidos 15716 codigos de barras da tanby
-- foram incluidos 2258 codigos de barras da tanby 