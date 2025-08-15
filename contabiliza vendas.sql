-- retaguarda

select a.PROCOD as 'cod.produto',
       (select PRODES from TBS010 b (nolock) where b.PROCOD = a.PROCOD) as 'descricao',
       'UN' as 'unidade',
       (select MARNOM from TBS014 c (nolock) where c.MARCOD = e.MARCOD) as 'marca',
       sum(NFSQTD*NFSQTDEMB) as 'quantidade',
       sum(dbo.NFSTOTITEST(a.NFSEMPCOD,a.NFSNUM,a.NFSITE)) as 'valor',
       sum(NFSPRECUS*NFSQTD) as 'custo'
  from TBS0671 a (nolock) join TBS067 d (nolock) on d.NFSEMPCOD = a.NFSEMPCOD and d.NFSNUM = a.NFSNUM
                          join TBS010 e (nolock) on e.PROEMPCOD = a.PROEMPCOD and e.PROCOD = a.PROCOD
                          join TBS042 f (nolock) on f.TESCOD = a.TESCOD
 where NFSDATEMI between '20121001' and '20130331' and NFSTIP = 'N' and NFSCAN = 'N' and TESCNTVEN = 'S' and
       d.NFSCLINOM not Like('%BEST BAG%') and d.NFSCLINOM not Like('%BEST OFFICE%') and d.NFSCLINOM not Like('%MISASPEL%') and
       d.NFSCLINOM not Like('%PAPELYNA%') and d.NFSCLINOM not Like('%TANBY%')
 group by a.PROCOD,e.MARCOD


select a.PROCOD as 'cod.produto',
       (select PRODES from TBS010 b (nolock) where b.PROCOD = a.PROCOD) as 'descricao',
       (select PROUM1 from TBS010 b (nolock) where b.PROCOD = a.PROCOD) as 'unidade',
       (select MARNOM from TBS014 c (nolock) where c.MARCOD = e.MARCOD) as 'marca',
       sum(NFSQTD*NFSQTDEMB) as 'quantidade',
       sum(dbo.NFSTOTITEST(a.NFSEMPCOD,a.NFSNUM,a.NFSITE)) as 'valor',
       sum(NFSPRECUS*NFSQTD) as 'custo',
       (select PROCLAFIS from TBS010 b (nolock) where b.PROCOD = a.PROCOD) as 'NCM'
  from TBS0671 a (nolock) join TBS067 d (nolock) on d.NFSEMPCOD = a.NFSEMPCOD and d.NFSNUM = a.NFSNUM
                          join TBS010 e (nolock) on e.PROEMPCOD = a.PROEMPCOD and e.PROCOD = a.PROCOD
                          join TBS042 f (nolock) on f.TESCOD = a.TESCOD
 where NFSDATEMI between '20121001' and '20130331' and NFSTIP = 'N' and NFSCAN = 'N' and TESCNTVEN = 'S' and
       d.NFSCLINOM not Like('%BEST BAG%') and d.NFSCLINOM not Like('%BEST OFFICE%') and d.NFSCLINOM not Like('%MISASPEL%') and
       d.NFSCLINOM not Like('%PAPELYNA%') and d.NFSCLINOM not Like('%TANBY%')
 group by a.PROCOD,e.MARCOD


select convert(char(7),d.NFSDATEMI,111) as 'mes-ano',
       a.PROCOD as 'cod.produto',
       (select PRODES from TBS010 b (nolock) where b.PROCOD = a.PROCOD) as 'descricao',
       'UN' as 'unidade',
       (select MARNOM from TBS014 c (nolock) where c.MARCOD = e.MARCOD) as 'marca',
       sum(NFSQTD*NFSQTDEMB) as 'quantidade',
       sum(dbo.NFSTOTITEST(a.NFSEMPCOD,a.NFSNUM,a.NFSITE)) as 'valor',
       sum(NFSPRECUS*NFSQTD) as 'custo'
  from TBS0671 a (nolock) join TBS067 d (nolock) on d.NFSEMPCOD = a.NFSEMPCOD and d.NFSNUM = a.NFSNUM
                          join TBS010 e (nolock) on e.PROEMPCOD = a.PROEMPCOD and e.PROCOD = a.PROCOD
                          join TBS042 f (nolock) on f.TESCOD = a.TESCOD
 where NFSDATEMI between '20120701' and '20121231' and NFSTIP = 'N' and NFSCAN = 'N' and TESCNTVEN = 'S' and
       d.NFSCLINOM not Like('%BEST BAG%') and d.NFSCLINOM not Like('%BEST OFFICE%') and d.NFSCLINOM not Like('%MISASPEL%') and
       d.NFSCLINOM not Like('%PAPELYNA%') and d.NFSCLINOM not Like('%TANBY%')
 group by convert(char(7),d.NFSDATEMI,111),a.PROCOD,e.MARCOD

declare @comando varchar(1000)
set @comando = 'bcp "select a.PROCOD,(select PRODES from SIBD.dbo.TBS010 b (nolock) where b.PROCOD = a.PROCOD),''UN'',(select MARNOM from SIBD.dbo.TBS014 c (nolock) where c.MARCOD = e.MARCOD),sum(NFSQTD*NFSQTDEMB),sum(SIBD.dbo.valTotLiquidoProduto(a.NFSEMPCOD,a.NFSNUM,a.NFSITE)),sum(NFSPRECUS*NFSQTD) from SIBD.dbo.TBS0671 a (nolock) join SIBD.dbo.TBS067 d (nolock) on d.NFSEMPCOD = a.NFSEMPCOD and d.NFSNUM = a.NFSNUM join SIBD.dbo.TBS010 e (nolock) on e.PROEMPCOD = a.PROEMPCOD and e.PROCOD = a.PROCOD join SIBD.dbo.TBS042 f (nolock) on f.TESCOD = a.TESCOD where NFSDATEMI between ''20120101'' and ''20120930'' and NFSTIP = ''N'' and NFSCAN = ''N'' and TESCNTVEN = ''S'' and d.NFSCLICOD not in(615,221,6894,11112,512,6710,14422,4567) group by a.PROCOD,e.MARCOD" queryout c:\temp\vendas.txt -c -T -t"|"'

exec master..xp_cmdshell @comando


-- frente de loja

-- somatorios

select 'codigo-produto','descricao-produto','unidade','marca','qtde-vendida','valor-vendido','qtde-cancelada','valor-cancelado','preco-custo-atual'

select M2_PROCOD as 'codigo-produto',
       (select PRODES from TBS010 (nolock) where PROCOD = M2_PROCOD) as 'descricao-produto',
       (select PROUM1 from TBS010 (nolock) where PROCOD = M2_PROCOD) as 'unidade',
       (select TBS014.MARNOM from TBS010 (nolock) join TBS014 (nolock) on TBS010.MAREMPCOD = TBS014.MAREMPCOD and TBS010.MARCOD = TBS014.MARCOD
         where PROCOD = M2_PROCOD) as 'marca',
       sum(M2_QTD) as 'qtde-vendida',
       sum(M2_VALTOT) as 'valor-vendido',
       isnull((select top 1 'S'
                 from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
                                       join TBS010 (nolock) on TBS010.PROEMPCOD = TBS0671.PROEMPCOD and TBS010.PROCOD = TBS0671.PROCOD
                                       join TBS042 (nolock) on TBS042.TESEMPCOD = TBS0671.TESEMPCOD and TBS042.TESCOD = TBS0671.TESCOD
                where TBS067.NFSDATEMI between '20121001' and '20131231' and TBS067.NFSTIP = 'L' and TBS067.NFSCAN = 'S' and
                      TBS0671.PROCOD = MSL002.M2_PROCOD and TBS042.TESCNTVEN = 'S'),0) as 'NF emitida',
       isnull((select sum(TBS0671.NFSQTD*TBS0671.NFSQTDEMB)
                 from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
                                       join TBS010 (nolock) on TBS010.PROEMPCOD = TBS0671.PROEMPCOD and TBS010.PROCOD = TBS0671.PROCOD
                                       join TBS042 (nolock) on TBS042.TESEMPCOD = TBS0671.TESEMPCOD and TBS042.TESCOD = TBS0671.TESCOD
                where TBS067.NFSDATEMI between '20120701' and '20121231' and TBS067.NFSTIP = 'L' and TBS067.NFSCAN = 'S' and
                      TBS0671.PROCOD = MSL002.M2_PROCOD and TBS042.TESCNTVEN = 'S'),0) as 'qtde-cancelada',
       isnull((select sum(dbo.NFSTOTITE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))
                 from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
                                       join TBS010 (nolock) on TBS010.PROEMPCOD = TBS0671.PROEMPCOD and TBS010.PROCOD = TBS0671.PROCOD
                                       join TBS042 (nolock) on TBS042.TESEMPCOD = TBS0671.TESEMPCOD and TBS042.TESCOD = TBS0671.TESCOD
                where TBS067.NFSDATEMI between '20120701' and '20121231' and TBS067.NFSTIP = 'L' and TBS067.NFSCAN = 'S' and
                      TBS0671.PROCOD = MSL002.M2_PROCOD and TBS042.TESCNTVEN = 'S'),0) as 'valor-cancelado',
       case avg(M2_PRECUS)
          when 0 then isnull((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD = M2_PROCOD),0)
          else avg(M2_PRECUS) end  as 'preco-custo-atual'
  from MSL002 (nolock)
 where M2_DAT between '20121001' and '20130131' and
       M2_TIPREG = '01' and M2_REGCAN <> 'T'
 group by M2_PROCOD

declare @comando varchar(1000)
set @comando = 'bcp "select M2_PROCOD,(select PRODES from SIBD.dbo.TBS010 (nolock) where PROCOD = M2_PROCOD),''UN'',(select MARNOM from SIBD.dbo.TBS010 (nolock) where PROCOD = M2_PROCOD),sum(M2_QTD),sum(M2_VALTOT),(select TDPCUSBAS from SIBD.dbo.TBS031 (nolock) where TDPPROCOD = M2_PROCOD) from SIBD.dbo.MSL002 (nolock) where M2_DAT between ''20120101'' and ''20120930'' and M2_TIPREG = ''01'' and M2_REGCAN = ''F'' and M2_NUMNFS = 0 group by M2_PROCOD" queryout c:\temp\vendas-loja.txt -c -T -t"|"'

exec master..xp_cmdshell @comando


select M2_PROCOD as 'codigo-produto',
       (select PRODES from TBS010 (nolock) where PROCOD = M2_PROCOD) as 'descricao-produto',
       (select PROUM1 from TBS010 (nolock) where PROCOD = M2_PROCOD) as 'unidade',
       (select TBS014.MARNOM from TBS010 (nolock) join TBS014 (nolock) on TBS010.MAREMPCOD = TBS014.MAREMPCOD and TBS010.MARCOD = TBS014.MARCOD
         where PROCOD = M2_PROCOD) as 'marca',
       sum(M2_QTD) as 'qtde-vendida',
       sum(M2_VALTOT) as 'valor-vendido',
       isnull((select top 1 'S'
                 from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
                                       join TBS010 (nolock) on TBS010.PROEMPCOD = TBS0671.PROEMPCOD and TBS010.PROCOD = TBS0671.PROCOD
                                       join TBS042 (nolock) on TBS042.TESEMPCOD = TBS0671.TESEMPCOD and TBS042.TESCOD = TBS0671.TESCOD
                where TBS067.NFSDATEMI between '20121001' and '20130331' and TBS067.NFSTIP = 'L' and TBS067.NFSCAN = 'S' and
                      TBS0671.PROCOD = MSL002.M2_PROCOD and TBS042.TESCNTVEN = 'S'),0) as 'NF emitida',
       isnull((select sum(TBS0671.NFSQTD*TBS0671.NFSQTDEMB)
                 from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
                                       join TBS010 (nolock) on TBS010.PROEMPCOD = TBS0671.PROEMPCOD and TBS010.PROCOD = TBS0671.PROCOD
                                       join TBS042 (nolock) on TBS042.TESEMPCOD = TBS0671.TESEMPCOD and TBS042.TESCOD = TBS0671.TESCOD
                where TBS067.NFSDATEMI between '20121001' and '20130331' and TBS067.NFSTIP = 'L' and TBS067.NFSCAN = 'S' and
                      TBS0671.PROCOD = MSL002.M2_PROCOD and TBS042.TESCNTVEN = 'S'),0) as 'qtde-cancelada',
       isnull((select sum(dbo.NFSTOTITE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))
                 from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
                                       join TBS010 (nolock) on TBS010.PROEMPCOD = TBS0671.PROEMPCOD and TBS010.PROCOD = TBS0671.PROCOD
                                       join TBS042 (nolock) on TBS042.TESEMPCOD = TBS0671.TESEMPCOD and TBS042.TESCOD = TBS0671.TESCOD
                where TBS067.NFSDATEMI between '20121001' and '20130331' and TBS067.NFSTIP = 'L' and TBS067.NFSCAN = 'S' and
                      TBS0671.PROCOD = MSL002.M2_PROCOD and TBS042.TESCNTVEN = 'S'),0) as 'valor-cancelado',
       case avg(M2_PRECUS)
          when 0 then isnull((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD = M2_PROCOD),0)
          else avg(M2_PRECUS) end  as 'preco-custo-atual',
       (select PROCLAFIS from TBS010 (nolock) where PROCOD = M2_PROCOD) as 'NCM'
  from MSL002 (nolock)
 where M2_DAT between '20121001' and '20130331' and
       M2_TIPREG = '01' and M2_REGCAN <> 'T'
 group by M2_PROCOD

-- todos os itens

select M2_CXA,
       M2_NUMDOC,
       M2_PROCOD,
       (select PRODES from TBS010 (nolock) where PROCOD = M2_PROCOD),
       'UN',
       (select MARNOM from TBS010 (nolock) where PROCOD = M2_PROCOD),
       M2_QTD,
       M2_VALUNI,
       M2_VALTOT,
       (select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD = M2_PROCOD)
  from MSL002 (nolock)
 where M2_DAT between '20120101' and '20120930' and
       M2_TIPREG = '01' and
       M2_REGCAN = 'F' and
       M2_NUMNFS = 0

declare @comando varchar(1000)
set @comando = 'bcp "select M2_CXA,M2_NUMDOC,M2_PROCOD,(select PRODES from SIBD.dbo.TBS010 (nolock) where PROCOD = M2_PROCOD),''UN'',(select MARNOM from SIBD.dbo.TBS010 (nolock) where PROCOD = M2_PROCOD),M2_QTD,M2_VALUNI,M2_VALTOT,(select TDPCUSBAS from SIBD.dbo.TBS031 (nolock) where TDPPROCOD = M2_PROCOD) from SIBD.dbo.MSL002 (nolock) where M2_DAT between ''20120101'' and ''20120930'' and M2_TIPREG = ''01'' and M2_REGCAN = ''F'' and M2_NUMNFS = 0" queryout c:\temp\vendas-loja2.txt -c -T -t"|"'

exec master..xp_cmdshell @comando