select * from TBS037

select top 100 * from TBS051 (nolock) order by LMEDATHOR desc

select distinct SALREF from TBS098 (nolock) order by SALREF

select T1.PROCOD as 'codigo',
       T1.PRODES as 'descricao',
       T1.PROUM1 as 'unidade',
       isnull((select T9.TDPCUSBAS from SIBD.dbo.TBS031 as T9 (nolock) where T9.TDPPROCOD=T1.PROCOD),0) as 'custo unitario',
       isnull((select T7.ESTQTDATU from SPED.dbo.TBS032 as T7 (nolock) where T7.PROCOD=T1.PROCOD and T7.ESTLOC=1),0) as 'qtde.retaguarda',
       isnull((select T8.ESTQTDATU from SPED.dbo.TBS032 as T8 (nolock) where T8.PROCOD=T1.PROCOD and T8.ESTLOC=2),0) as 'qtde.loja',
       isnull((select sum(T2.NFEQTD*T2.NFEQTDEMB)
                 from SIBD.dbo.TBS0591 as T2 left join SIBD.dbo.TBS059 as T3
                      on T3.NFETIP=T2.NFETIP and T3.NFENUM=T2.NFENUM and T3.NFECOD=T2.NFECOD and T3.SERCOD=T2.SERCOD
                where T2.PROCOD=T1.PROCOD and
                      T3.NFEDATENT >= '20141007' and
                      T3.NFECAN='N' and T3.NFEUSUEFE<>''),0) as 'entrada',
       isnull((select sum(T4.NFSQTD*T4.NFSQTDEMB)
                 from SIBD.dbo.TBS0671 as T4 left join SIBD.dbo.TBS067 as T5
                      on T5.SNESER=T4.SNESER and T5.NFSNUM=T4.NFSNUM
                where T4.PROCOD=T1.PROCOD and
                      T5.NFSDATEMI >= '20141007' and
                      T5.NFSCAN='N' and
                      T5.NFSDEV='N'),0) as 'saida retaguarda',
       isnull((select sum(T6.M2_QTD)
                 from SIBD.dbo.MSL002 as T6 (nolock)
                where T6.M2_PROCOD=T1.PROCOD and
                      T6.M2_DATMOV >= '20141007' and
                      T6.M2_TIPREG='01' and
                      T6.M2_REGCAN='F'),0) as 'saida loja',
       isnull((select T7.ESTQTDATU from SIBD.dbo.TBS032 as T7 (nolock) where T7.PROCOD=T1.PROCOD and T7.ESTLOC=1),0) as 'qtde.retaguarda atual',
       isnull((select T8.ESTQTDATU from SIBD.dbo.TBS032 as T8 (nolock) where T8.PROCOD=T1.PROCOD and T8.ESTLOC=2),0) as 'qtde.loja atual'
  from SPED.dbo.TBS010 as T1 (nolock)

