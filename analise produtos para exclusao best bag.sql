select PROCOD,PROSTATUS from TBS010 (nolock)
 where not exists(select 'ne' from TBS051 (nolock)
                      where LMEDATHOR >= '20110201' and
                            LMEROT in('PCOM009','PCOM023','PEST005','PEST022','PEST029','PEST030','PVEN004','PVEN016',
                            'PVEN044') and TBS051.PROCOD=TBS010.PROCOD)


transacoes que movimentam saldos dos produtos


tbs045/451	compras
tbs076/761	solicitacoes de compras
tbs013 		inventario do estoque
tbs037/371	movimentos internos
tbs049		manutencao dos saldos
tbs059/591	notas fiscais de entradas
tbs058		mercadorias pendentes/reservadas
tbs067/671	notas fiscais de saidas

declare @database char(8)
set @database = '20110201'

select PROCOD,PRODES from TBS010 (nolock)
 where PROSTATUS <> 'A'
       not exists(select 'ne'
                    from TBS0451 (nolock) join TBS045 (nolock)
                                          on TBS0451.PDCEMPCOD=TBS045.PDCEMPCOD and TBS0451.PDCNUM=TBS045.PDCNUM
                   where TBS045.PDCDATCAD >= @database and PDCQTD > PDCQTDENT + PDCQTDRES and TBS0451.PROCOD=TBS010.PROCOD)
       and
       not exists(select 'ne'
                    from TBS0761 (nolock) join TBS076 (nolock)
                                          on TBS0761.SDCEMPCOD=TBS076.SDCEMPCOD and TBS0761.SDCNUM=TBS076.SDCNUM
                   where TBS076.SDCDATCAD >= @database and SDCQTDPED > SDCQTDATD + SDCQTDRES and TBS0761.PROCOD=TBS010.PROCOD)
       and
       not exists(select 'ne'
                    from TBS013 (nolock)
                   where TBS013.INVDATEFE >= @database and TBS013.PROCOD=TBS010.PROCOD)
       and
       not exists(select 'ne'
                    from TBS0371 (nolock) join TBS037 (nolock)
                                          on TBS0371.MVIEMPCOD=TBS037.MVIEMPCOD and TBS0371.MVIDOC=TBS037.MVIDOC
                   where TBS037.MVIDATEFE >= @database and MVIQTDATD > 0 and TBS0371.PROCOD=TBS010.PROCOD)
       and
       not exists(select 'ne'
                    from TBS049 (nolock)
                   where TBS049.MDSLAN >= @database and TBS049.PROCOD=TBS010.PROCOD)
       and
       not exists(select 'ne'
                    from TBS0591 (nolock) join TBS059 (nolock)
                                          on TBS0591.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFENUM=TBS059.NFENUM and
                                             TBS0591.NFECOD=TBS059.NFECOD and TBS0591.SEREMPCOD=TBS059.SEREMPCOD and TBS0591.SERCOD=TBS059.SERCOD
                   where subString(TBS059.NFEUSUEFE,7,4) + subString(TBS059.NFEUSUEFE,4,2) + subString(TBS059.NFEUSUEFE,1,2) >= @database and
                         TBS0591.PROCOD=TBS010.PROCOD)
       and
       not exists(select 'ne'
                    from TBS058 (nolock) join TBS055 (nolock)
                                         on TBS058.PRPEMP=TBS055.PDVEMPCOD and TBS058.PRPNUM=TBS055.PDVNUM
                   where TBS055.PDVDATCAD >= @database and TBS058.PROCOD=TBS010.PROCOD)
       and
       not exists(select 'ne'
                    from TBS0671 (nolock) join TBS067 (nolock)
                                          on TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM
                   where NFSDATEMI >= @database and
                         NFSCAN <> 'S' and
                         NFSMOVEST = 'S' and
                         NFSQTD > NFSQTDDEV and
                         TBS0671.PROCOD=TBS010.PROCOD)
       and
       not exists(select 'ne'
                    from MSL002 (nolock)
                   where MSL002.M2_DAT >= @database and MSL002.M2_TIPREG='01' and MSL002.M2_PROCOD=TBS010.PROCOD)
