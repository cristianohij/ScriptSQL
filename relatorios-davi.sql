select NFENUM,NFEDATEMI,NFECOD,NFENOM,NFEVDDTOT,NFEVALFRE,NFEVALSEG,NFEVALDES,NFETOTIPI,NFEVALSUB,
       dbo.NFETOTBRU(NFEEMPCOD,NFETIP,NFENUM,NFECOD,SEREMPCOD,SERCOD),
       dbo.NFETOTLIQ(NFEEMPCOD,NFETIP,NFENUM,NFECOD,SEREMPCOD,SERCOD)
  from TBS059 (nolock) where NFEDATEMI between '20121001' and '20121231' and NFETIP = 'N' and NFECAN <> 'S'


select PROCOD as 'cod-produto',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS032.PROCOD) as 'descricao',
       ESTLOC as 'local-estoque',
       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS032.PROCOD) as 'uni-medida',
       ESTQTDATU as 'qtde-atual',
       ESTQTDRES as 'qtde-reservada',
       ESTQTDATU-ESTQTDRES as 'qtde-disponivel',
       ESTQTDPEN as 'qtde-pendente',
       ESTQTDCMP as 'qtde-comprada',
       (select TDPCUSBAS from TBS031 (nolock) where TBS031.TDPPROCOD=TBS032.PROCOD) as 'pre-custo'
  from TBS032 (nolock)
 order by PROCOD,ESTLOC


select NFSNUM as 'nf',
       NFSDATEMI as 'emissao',
       NFSCLICOD as 'cod-cliente',
       NFSCLINOM as 'nome-cliente',
       UFESIG as 'uf-destino',
       dbo.NFSTOTBRU(NFSEMPCOD,NFSNUM) as 'tot-produtos',
       NFSVALFRE as 'frete',
       NFSVALSEG as 'seguro',
       NFSVALDES as 'outras-despesas',
       dbo.NFSVDDTOT(NFSEMPCOD,NFSNUM) as 'desconto',
       dbo.NFSTOTLIQ(NFSEMPCOD,NFSNUM) as 'tot-nota',
       dbo.NFSTOTICMS(NFSEMPCOD,NFSNUM) as 'tot-icms'
  from TBS067 (nolock)
 where NFSDATEMI between '20121001' and '20121231' and NFSTIP = 'N' and NFSCAN <> 'S'

--delete TBS023 where EMPCOD=2
--update TBS023 set EMPCGC='65069593000198'
--select * from TBS023 (nolock)
select CLICOD,CLICGC into #CODCLI from TBS002 (nolock) right join TBS023 (nolock) on subString(TBS002.CLICGC,1,8)=subString(TBS023.EMPCGC,1,8)

--select CLICOD,CLICGC from TBS002 (nolock) right join TBS023 (nolock) on subString(TBS002.CLICGC,1,8)=subString(TBS023.EMPCGC,1,8)

--select * from #CODCLI

--drop table #CODCLI

select NFSNUM as 'nf',
       NFSDATEMI as 'emissao',
       NFSCLICOD as 'cod-cliente',
       NFSCLINOM as 'nome-cliente',
       UFESIG as 'uf-destino',
       dbo.NFSTOTBRU(NFSEMPCOD,NFSNUM) as 'tot-produtos',
       NFSVALFRE as 'frete',
       NFSVALSEG as 'seguro',
       NFSVALDES as 'outras-despesas',
       dbo.NFSVDDTOT(NFSEMPCOD,NFSNUM) as 'desconto',
       dbo.NFSTOTLIQ(NFSEMPCOD,NFSNUM) as 'tot-nota',
       dbo.NFSTOTICMS(NFSEMPCOD,NFSNUM) as 'tot-icms'
  from TBS067 (nolock) right join #CODCLI (nolock) on TBS067.NFSCLICOD=#CODCLI.CLICOD
 where NFSDATEMI between '20130701' and '20130731' and NFSTIP = 'N' and NFSCAN <> 'S' --and
--       exists(select '' from TBS002 (nolock) join TBS023 (nolock) on subString(TBS002.CLICGC,1,8)=subString(TBS023.EMPCGC,1,8)
  --             where TBS002.CLICOD=TBS067.NFSCLICOD)
