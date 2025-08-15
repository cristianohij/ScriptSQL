-- elimina dados do SPED

delete SPED_ES
go

-- zera id dos registros

DBCC CHECKIDENT ('SPED_ES', RESEED, 0)
go

-- popula tabela SPED

declare @datai date, @dataf date, @sai char(1), @ent char(1)

set @datai='20190301'
set @dataf='20190331'

-- 0 = entrada, 1 = saida
set @sai = 'S'
set @ent = 'S'

drop table #DADOS_SPED

-- saídas: finalidade normal

select '0150' as REG_0150,
       rtrim(ENFCNPJCPF) as COD_PART,
       Ltrim(rtrim(ENFDESREM)) as NOME,
       CLIIES as IE,
       TBS002.MUNCOD as COD_MUN,
       TBS002.CLISUFRAMA as SUFRAMA,
       TBS002.CLIEND as 'ENDDER',
       TBS002.CLINUM as NUM,
       TBS002.CLIBAI as BAIRRO,

       '0190' as REG_0190,
       TBS010.PROUM1 as UNID,
       TBS011.UNIDES as DESCR,

       '0200' as REG_0200,
       TBS0671.PROCOD as COD_ITEM,
       TBS010.PRODES as DESCR_ITEM,
       TBS010.PROCLAFIS as COD_NCM,
       TBS010.PROCEST as CEST,

       '0220' as REG_0220,
       TBS0671.NFSUNI as UNID_CONV,
       TBS0671.NFSQTDEMB as FAT_CONV,
       (select UNIDES from TBS011 (nolock) where UNICOD=TBS0671.NFSUNI) as UNI_DESCR,

       '0400' as REG_0400,
       'S' + subString(TBS0671.NFSCFOP,3,3) as COD_NAT,
       (select COPTXT from TBS041 (nolock) where COPTIP='S' and COPCOD=subString(TBS0671.NFSCFOP,3,3)) as DESCR_NAT,

       'C100' as REG_C100,
       1 as IND_OPER,
       0 as IND_EMIT,
       '00' as COD_SIT,
       TBS080.SNESER as SER,
       TBS080.ENFNUM as NUM_DOC,
       TBS080.ENFCHAACE as CHV_NFE,
       TBS080.ENFDATEMI as DT_DOC,
       TBS080.ENFDATEMI as DT_E_S,

       -- total da nf: - desconto + despesas + st
       dbo.NFSTOTLIQ(TBS080.ENFEMPCOD,TBS080.ENFNUM,TBS080.SNEEMPCOD,TBS080.SNESER) as VL_DOC,
       TBS080.ENFFORPAG as IND_PGTO,

       -- 08/03
       -- dbo.NFSVDDTOT(0,TBS080.ENFNUM,0,TBS080.SNESER) as VL_DESC,
       0 as VL_DESC,

       -- total da nf: - desconto + despesas + st
       dbo.NFSTOTLIQ(TBS080.ENFEMPCOD,TBS080.ENFNUM,TBS080.SNEEMPCOD,TBS080.SNESER) as VL_MERC, -- - dbo.NFSTOTICMSSTRET(0,ENFNUM,0,TBS080.SNESER) as VL_MERC,

       -- 08/03
       --TBS067.NFSTIPFRE as IND_FRT,
       0 as IND_FRT,
       --TBS067.NFSVALFRE as VL_FRT,
       0 as VL_FRT,
       --TBS067.NFSVALSEG as VL_SEG,
       0 as VL_SEG,
       --TBS067.NFSVALDES as VL_OUT_DA,
       0 as VL_OUT_DA,

       case TBS067.NFSDESICMS
          when 'S' then 0
          else dbo.NFSTOTBAS(ENFEMPCOD,ENFNUM,TBS080.SNEEMPCOD,TBS080.SNESER)
          --else dbo.NFSTOTBASSEMST(0,ENFNUM,0,TBS080.SNESER)
       end as VL_BC_ICMS,

       case TBS067.NFSDESICMS
          when 'S' then 0
          else dbo.NFSTOTICMS(ENFEMPCOD,ENFNUM,TBS080.SNEEMPCOD,TBS080.SNESER)
          --else dbo.NFSTOTICMSSEMST(0,ENFNUM,0,TBS080.SNESER)
       end as VL_ICMS,

       -- 08/03
       /*
       case TBS067.NFSDESICMS
          when 'S' then 0
          else dbo.NFSTOTBASICMSST(0,ENFNUM,0,TBS080.SNESER)
       end as VL_BC_ICMS_ST,
       */

       -- base ICMS-ST zerado
       0 as VL_BC_ICMS_ST,

       /*
       case TBS067.NFSDESICMS
          when 'S' then 0
          else dbo.NFSTOTICMSSTRET(0,ENFNUM,0,TBS080.SNESER)
       end as VL_ICMS_ST,
       */

       -- valor do ICMS-ST zerado
       0 as VL_ICMS_ST,

       0 as VL_IPI,
       0 as VL_PIS,
       0 as VL_COFINS,

       -- REGISTRO C113: DOCUMENTO FISCAL REFERENCIADO
       '' as REG_C113, -- C113
       1 as IND_OPER_C113,
       '' as COD_PART_C113,
       '' as COD_MOD,
       '' as SER_C113,
       0 as NUM_DOC_C113,
       '' as CHV_DOCe,

       -- REGISTRO C114: CUPOM FISCAL REFERENCIADO
       '' as REG_C114, -- C114
       '' as COD_MOD_C114,
       0 as ECF_CX,
       0 as NUM_DOC_C114,

       -- REGISTRO C170: ITENS DO DOCUMENTO (CÓDIGO 01, 1B, 04 e 55)
       'C170' as REG_C170, 
       TBS0671.NFSITE as NUM_ITEM,
       TBS0671.NFSINFADIPRO as DESCR_COMPL,
       TBS0671.NFSQTD as QTD,

       --dbo.NFSTOTPRO(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE) as VL_ITEM,

       -- total do item - desconto + frete + seguro + outras
       /*
       case TBS067.NFSDESICMS
          when 'S' then dbo.NFSTOTITE(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE) +
                        dbo.NFSVDDITE(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE)
          else dbo.NFSTOTITE(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE)
       end as VL_ITEM,
       */

       -- 08/03
       -- dbo.NFSTOTITE(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE) as VL_ITEM,
       -- 0 as VL_ITEM,

       -- 09/03
       -- total do item: - desconto + despesas + st
       dbo.NFSTOTITEST(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE) as VL_ITEM,

       -- dbo.NFSVDDITE(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE) as VL_DESC_C170,
       0 as VL_DESC_C170,

       case TBS0671.NFSMOVEST
          when 'S' then 0
          else 1
       end as IND_MOV,

--       case TBS067.NFSDESICMS
--          when 'S' then TBS010.PROSTBA+(select Ltrim(rtrim(PARVAL)) from TBS025 (nolock) where PARCHV=1279)
--          else subString(TBS0671.NFSCST,1,3)
--       end as CST_ICMS,

       case
          when TBS067.NFSDESICMS='S' then TBS010.PROSTBA+(select Ltrim(rtrim(PARVAL)) from TBS025 (nolock) where PARCHV=1279)
          when dbo.NFSBASICMS(TBS067.NFSEMPCOD,TBS080.ENFNUM,TBS067.SNEEMPCOD,TBS080.SNESER,TBS0671.NFSITE)=0 and right(rtrim(TBS0671.NFSCST),2)<>'60' then Left(TBS0671.NFSCST,1)+'41'
          else subString(TBS0671.NFSCST,1,3)
       end as CST_ICMS,

       rtrim(replace(NFSCFOP,'.','')) as CFOP,

       case TBS067.NFSDESICMS
          when 'S' then 0
          else dbo.NFSBASICMS(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE)
       end as VL_BC_ICMS_C170,

       case TBS067.NFSDESICMS
          when 'S' then 0
          else TBS0671.NFSPERICMS
       end as ALIQ_ICMS,

       case TBS067.NFSDESICMS
          when 'S' then 0
          else dbo.NFSVALICMS(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE)
       end as VL_ICMS_C170,

       -- 08/03
       /*
       case TBS067.NFSDESICMS
          when 'S' then 0
          else dbo.NFSBASICMSST(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE)
       end as VL_BC_ICMS_ST_C170,
       */

       -- base ICMS-ST zerado
       0 as VL_BC_ICMS_ST_C170,

       /*
       case TBS067.NFSDESICMS
          when 'S' then 0
          else TBS0671.NFSPERICMSST
       end as ALIQ_ST,
       */

       -- alíquota ICMS-ST zerado
       0 as ALIQ_ST,

       /*
       case TBS067.NFSDESICMS
          when 'S' then 0
          else dbo.NFSVALICMSST(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE)
       end as VL_ICMS_ST_C170,
       */

       -- valor ICMS-ST zerado
       0 as VL_ICMS_ST_C170,

       0 as VL_BC_IPI,
       0 as ALIQ_IPI,
       0 as VL_IPI_C114,

       case
          -- transferência entre matriz/filial
          when TBS080.ENFCNPJCPF in('65069593000350','65069593000198','65069593000279') then '49'

          when TBS010.PROSTBPIS<>'' then Ltrim(rtrim(TBS010.PROSTBPIS))

          else '01'
       end as CST_PIS,

       --case if val(&PISCST) >= 6 and val(&PISCST) <= 9
       0 as VL_BC_PIS,

       /*
       --case TBS067.NFSDESICMS
       case
          --when 'S' then 0
          when TBS067.NFSDESICMS=0 then 0
          when 
          else dbo.NFSTOTPRO(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE) - dbo.NFSVALICMS(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE) - dbo.NFSVALICMSST(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE)
          --else dbo.NFSTOTICMSSEMST(0,ENFNUM,0,TBS080.SNESER)
       end as VL_BC_PIS,
       */

       -- alíquota PIS
       case
          -- transferência entre matriz/filial
          when TBS080.ENFCNPJCPF in('65069593000350','65069593000198','65069593000279') then 0

          when TBS010.PROSTBPIS<>'' then TBS010.PROPIS

          else 1.65
       end as ALIQ_PIS,

       0 as VL_PIS_C170,

       --'' as CST_COFINS,

       -- CST-COFINS
       case
          -- transferência entre matriz/filial
          when TBS080.ENFCNPJCPF in('65069593000350','65069593000198','65069593000279') then '49'

          when TBS010.PROSTBCOFINS<>'' then Ltrim(rtrim(TBS010.PROSTBCOFINS))

          else '01'
       end as CST_COFINS,

       0 as VL_BC_COFINS,

       /*
       case TBS067.NFSDESICMS
          when 'S' then 0
          else dbo.NFSTOTPRO(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE) - dbo.NFSVALICMS(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE) - dbo.NFSVALICMSST(TBS067.NFSEMPCOD, TBS080.ENFNUM, TBS067.SNEEMPCOD, TBS080.SNESER, TBS0671.NFSITE)
          --else dbo.NFSTOTICMSSEMST(0,ENFNUM,0,TBS080.SNESER)
       end as VL_BC_COFINS,
       */

       -- alíquota COFINS
       case
          -- transferência entre matriz/filial
          when TBS080.ENFCNPJCPF in('65069593000350','65069593000198','65069593000279') then 0

          when TBS010.PROSTBCOFINS<>'' then TBS010.PROCOFINS

          else 7.6
       end as ALIQ_COFINS,

       0 as VL_COFINS_C170,

       -- REGISTRO C190: REGISTRO ANALÍTICO DO DOCUMENTO (CÓDIGO 01, 1B, 04, 55 e 65).
       'C190' as REG_C190,
       TBS0671.NFSREDBCICMS as VL_RED_BC,

       /* REGISTRO D100: NOTA FISCAL DE SERVIÇO DE TRANSPORTE (CÓDIGO 07) E CONHECIMENTOS DE TRANSPORTE RODOVIÁRIO DE CARGAS (CÓDIGO 08),
                   CONHECIMENTOS DE TRANSPORTE DE CARGAS AVULSO (CÓDIGO 8B), AQUAVIÁRIO DE CARGAS (CÓDIGO 09), AÉREO (CÓDIGO 10), FERROVIÁRIO DE CARGAS (CÓDIGO 11),
                   MULTIMODAL DE CARGAS (CÓDIGO 26), NOTA FISCAL DE TRANSPORTE FERROVIÁRIO DE CARGA (CÓDIGO 27), CONHECIMENTO DE TRANSPORTE ELETRÔNICO – CT-e (CÓDIGO 57) E
                   CONHECIMENTO DE TRANSPORTE ELETRÔNICO PARA OUTROS SERVIÇOS - CT-e OS (CÓDIGO 67) */
       'D100' as REG_D100,
       '' as CHV_CTE,
       '17530101' as DT_A_P,
       0 as TP_CT_E,
       0 VL_SERV


  into #DADOS_SPED

  from TBS080 (nolock)
          inner join TBS002 (nolock) on TBS080.ENFCODDES=TBS002.CLICOD
          inner join TBS067 (nolock) on TBS067.SNESER=TBS080.SNESER and TBS067.NFSNUM=TBS080.ENFNUM
          inner join TBS0671 (nolock) on TBS0671.SNESER=TBS080.SNESER and TBS0671.NFSNUM=TBS080.ENFNUM
          inner join TBS010 (nolock) on TBS010.PROCOD=TBS0671.PROCOD
          inner join TBS011 (nolock) on TBS011.UNICOD=TBS010.PROUM1
                     
 where TBS080.ENFDATEMI between @datai and @dataf and TBS080.ENFSIT=6 and TBS080.ENFFINEMI=1 and TBS067.NFSTIP<>'L'
       and @sai='S'

-- order by TBS080.SNESER, TBS080.ENFNUM

union

-- saídas: devolução de compras para o fornecedor

select -- REG_0150
       '0150',
       -- COD_PART
       rtrim(ENFCNPJCPF),
       -- NOME
       Ltrim(rtrim(ENFDESREM)),
       -- IE
       TBS006.FORIES,
       -- COD_MUN
       TBS006.MUNCOD,
       -- SUFRAMA
       0,
       -- ENDER
       TBS006.FOREND,
       -- NUM
       TBS006.FORNUM,
       -- BAIRRO
       TBS006.FORBAI,

       -- REG_0190
       '0190',
       -- UNID
       TBS010.PROUM1,
       -- DESCR
       TBS011.UNIDES,

       -- REG_0200
       '0200',
       -- COD_ITEM
       TBS1172.PROCOD,
       -- DESCR_ITEM
       TBS010.PRODES,
       -- COD_NCM
       TBS010.PROCLAFIS,
       -- CEST
       TBS010.PROCEST,

       -- REG_0220
       '0220',
       -- UNID_CONV
       TBS1172.NFDUNI,
       -- FAT_CONV
       TBS1172.NFDQTDEMB,
       -- UNID_DESCR
       (select UNIDES from TBS011 (nolock) where UNICOD=TBS1172.NFDUNI),

       -- REG_0400
       '0400',
       -- COD_NAT
       'S' + subString(TBS1172.NFDCFOP,3,3),
       -- DESCR_NAT
       (select COPTXT from TBS041 (nolock) where COPTIP='S' and COPCOD=subString(TBS1172.NFDCFOP,3,3)),


       -- REGISTRO C100: NOTA FISCAL (CÓDIGO 01), NOTA FISCAL AVULSA (CÓDIGO 1B), NOTA FISCAL DE PRODUTOR (CÓDIGO 04), NF-e (CÓDIGO 55) e NFC-e (CÓDIGO 65)

       -- REG_C100
       'C100',
       -- IND_OPER
       1,
       -- IND_EMIT
       0,
       -- COD_SIT
       '00',
       -- SER
       TBS080.SNESER,
       -- NUM_DOC
       TBS080.ENFNUM,
       -- CHV_NFE
       TBS080.ENFCHAACE,
       -- DT_DOC
       TBS080.ENFDATEMI,
       -- DT_E_S
       TBS080.ENFDATEMI,
       -- VL_DOC
       dbo.NFDTOTNOTA(TBS117.NFDEMPCOD, TBS117.SNEEMPCOD, TBS117.SNESER, TBS117.NFDNUM),
       -- IND_PGTO
       2,
       
       -- VL_DESC
       -- 08/03
       --dbo.NFDTOTDES(0, 0, TBS117.SNESER, TBS117.NFDNUM), --TBS1171.NFDNFEEMP, TBS1171.NFDNFETIP, TBS1171.NFDNFENUM, TBS1171.NFDSEREMP, TBS1171.NFDSERCOD),
       0,

       -- VL_MERC
       --dbo.NFDTOTPRO(0, 0, TBS117.SNESER, TBS117.NFDNUM),
       dbo.NFDTOTNOTA(TBS117.NFDEMPCOD, TBS117.SNEEMPCOD, TBS117.SNESER, TBS117.NFDNUM),

       -- IND_FRT
       1,

       -- VL_FRT
       -- 08/03
       -- dbo.NFDTOTFRE(0, 0, TBS117.SNESER, TBS117.NFDNUM), -- TBS1171.NFDNFEEMP, TBS1171.NFDNFETIP, TBS1171.NFDNFENUM, TBS1171.NFDSEREMP, TBS1171.NFDSERCOD),
       0,
       
       -- VL_SEG
       --dbo.NFDTOTSEG(0, 0, TBS117.SNESER, TBS117.NFDNUM), --TBS1171.NFDNFEEMP, TBS1171.NFDNFETIP, TBS1171.NFDNFENUM, TBS1171.NFDSEREMP, TBS1171.NFDSERCOD),
       0,

       -- VL_OUT_DA
       --dbo.NFDTOTOUTDES(0, 0, TBS117.SNESER, TBS117.NFDNUM) + dbo.NFDTOTICMSST(0, 0, TBS117.SNESER, TBS117.NFDNUM),
       0,

       -- VL_BC_ICMS
       dbo.NFDTOTBASICMS(TBS117.NFDEMPCOD, TBS117.SNEEMPCOD, TBS117.SNESER, TBS117.NFDNUM),
       --dbo.NFDTOTBASICMSSEMST(0, 0, TBS117.SNESER, TBS117.NFDNUM),

       -- VL_ICMS
       dbo.NFDTOTICMS(TBS117.NFDEMPCOD, TBS117.SNEEMPCOD, TBS117.SNESER, TBS117.NFDNUM),
       --dbo.NFDTOTICMSSEMST(0, 0, TBS117.SNESER, TBS117.NFDNUM),

       -- VL_BC_ICMS_ST
       0,
       -- VL_ICMS_ST
       0,
       -- VL_IPI
       0,
       -- VL_PIS
       0, --dbo.NFDTOTPIS(0, 0, TBS117.SNESER, TBS117.NFDNUM),
       -- VL_COFINS
       0, --dbo.NFDTOTCOFINS(0, 0, TBS117.SNESER, TBS117.NFDNUM),


       -- REGISTRO C113: DOCUMENTO FISCAL REFERENCIADO

       -- C113
       '',
       -- IND_OPER_C113
       0,
       -- COD_PART_C113
       '',
       -- COD_MOD
       '',
       -- SER_C113
       '',
       -- NUM_DOC_C113
       0,
       -- CHV_DOCe
       '',

       -- REGISTRO C113: DOCUMENTO FISCAL REFERENCIADO

       -- C114
       '',
       -- COD_MOD_C114
       '',
       -- ECF_CX
       0,
       -- NUM_DOC_C114
       0,

       -- REGISTRO C170: ITENS DO DOCUMENTO (CÓDIGO 01, 1B, 04 e 55)

       -- REG_C170
       'C170',
       -- NUM_ITEM
       TBS1172.NFDITE,
       -- DESCR_COMPL
       '',
       -- QTD
       TBS1172.NFDQTD,

       -- VL_ITEM
       -- valor: - desconto + despesas + st + ipi
       dbo.NFDTOTLIQITE(TBS117.NFDEMPCOD, TBS117.SNEEMPCOD, TBS117.SNESER, TBS117.NFDNUM, TBS1172.NFDITE) + NFDVALICMSST + NFDVALIPI,

       -- VL_DESC_C170
       -- 08/03
       --TBS1172.NFDVALDES,
       0,

       -- IND_MOV
       case TBS1172.NFDMOVEST
          when 'S' then 0
          else 1
       end,

       -- CST_ICMS
       case
          -- se redução da BC ICMS
          when TBS1172.NFDREDPBI > 0 then subString(TBS1172.NFDCSTCSOSN,1,1)+'20'
          else subString(TBS1172.NFDCSTCSOSN,1,3)
       end,

       -- CFOP
       rtrim(replace(NFDCFOP,'.','')), -- 9,11

       -- VL_BC_ICMS_C170
       TBS1172.NFDBASICMS,
       -- ALIQ_ICMS
       TBS1172.NFDPERICMS,
       -- VL_ICMS_C170
       TBS1172.NFDVALICMS,

       -- VL_BC_ICMS_ST_C170
       0, -- NFDBASICMSST,
       -- ALIQ_ST
       0, -- NFDPERICMSST,
       -- VL_ICMS_ST_C170
       0, -- NFDVALICMSST,

       -- 09/03
       /*
       NFDBASIPI, --0, -- 22
       NFDPERIPI, --0, -- 23
       NFDVALIPI, --0, -- 24
       */

       -- VL_BC_IPI
       0,
       -- ALIQ_IPI
       0,
       -- VL_IPI_C170
       0,

       -- CST-PIS
       case
          when TBS010.PROSTBPIS<>'' then Ltrim(rtrim(TBS010.PROSTBPIS))
          else '01'
       end,

       -- VL_BC_PIS
       0,

       -- ALIQ_PIS
       case
          when TBS010.PROSTBPIS<>'' then TBS010.PROPIS
          else 1.65
       end,

       -- VL_PIS_C170
       0,

       -- CST-COFINS
       case
          when TBS010.PROSTBCOFINS<>'' then Ltrim(rtrim(TBS010.PROSTBCOFINS))
          else '01'
       end,

       -- VL_BC_COFINS
       0,

       -- ALIQ_COFINS
       case
          when TBS010.PROSTBCOFINS<>'' then TBS010.PROCOFINS

          else 7.6
       end,

       -- VL_COFINS_C170
       0,


       -- REGISTRO C190: REGISTRO ANALÍTICO DO DOCUMENTO (CÓDIGO 01, 1B, 04, 55 e 65).

       -- REG_C190
       'C190',
       -- VL_RED_BC
       TBS1172.NFDREDPBI,


       /* REGISTRO D100: NOTA FISCAL DE SERVIÇO DE TRANSPORTE (CÓDIGO 07) E CONHECIMENTOS DE TRANSPORTE RODOVIÁRIO DE CARGAS (CÓDIGO 08),
                   CONHECIMENTOS DE TRANSPORTE DE CARGAS AVULSO (CÓDIGO 8B), AQUAVIÁRIO DE CARGAS (CÓDIGO 09), AÉREO (CÓDIGO 10), FERROVIÁRIO DE CARGAS (CÓDIGO 11),
                   MULTIMODAL DE CARGAS (CÓDIGO 26), NOTA FISCAL DE TRANSPORTE FERROVIÁRIO DE CARGA (CÓDIGO 27), CONHECIMENTO DE TRANSPORTE ELETRÔNICO – CT-e (CÓDIGO 57) E
                   CONHECIMENTO DE TRANSPORTE ELETRÔNICO PARA OUTROS SERVIÇOS - CT-e OS (CÓDIGO 67) */
       -- REG_D100
       'D100',
       -- CHV_CTE
       '',
       -- DT_A_P
       '17530101',
       -- TP_CT_E
       0,
       -- VL_SERV
       0


  from TBS080 (nolock)
          inner join TBS006 (nolock) on TBS006.FORCOD=TBS080.ENFCODDES
          inner join TBS117 (nolock) on TBS117.SNESER=TBS080.SNESER and TBS117.NFDNUM=TBS080.ENFNUM
          inner join TBS1171 (nolock) on TBS1171.SNESER=TBS080.SNESER and TBS1171.NFDNUM=TBS080.ENFNUM
          inner join TBS1172 (nolock) on TBS1172.SNESER=TBS080.SNESER and TBS1172.NFDNUM=TBS080.ENFNUM
          inner join TBS010 (nolock) on TBS010.PROCOD=TBS1172.PROCOD
          inner join TBS011 (nolock) on TBS011.UNICOD=TBS010.PROUM1
                     
 where TBS080.ENFDATEMI between @datai and @dataf and TBS080.ENFSIT=6 and TBS080.ENFFINEMI=4
       and @sai='S'

-- order by TBS080.SNESER, TBS080.ENFNUM


union

-- saídas: canceladas, denegadas e/ou inutilizadas

select -- REG_0150
       '',
       -- COD_PART
       '',
       -- NOME
       '',
       -- IE
       '',
       -- COD_MUN
       0,
       -- SUFRAMA
       0,
       -- ENDER
       '',
       -- NUM
       '',
       -- BAIRRO
       '',

       -- REG_0190
       '',
       -- UNID
       '',
       -- DESCR
       '',

       -- REG_0200
       '',
       -- COD_ITEM
       '',
       -- DESCR_ITEM
       '',
       -- COD_NCM
       '',
       -- CEST
       '',

       -- REG_0220
       '',
       -- UNID_CONV
       '',
       -- FAT_CONV
       0,
       -- UNI_DESCR
       '',

       -- REG_0400
       '',
       -- COD_NAT
       '',
       -- DESCR_NAT
       '',

       -- REG_C100
       'C100',
       -- IND_OPER
       1,
       -- IND_EMIT
       0,
       -- COD_SIT
       case TBS080.ENFSIT
          when 7 then '02'
          when 8 then '04'
          else '05'
       end,
 
       -- SER
       TBS080.SNESER,
       -- NUM_DOC
       TBS080.ENFNUM,
       -- CHV_NFE
       case ENFSIT
          when 11 then ''
          else TBS080.ENFCHAACE
       end,
       -- DT_DOC
       '17530101',
       -- DT_E_S
       '17530101',
       -- VL_DOC
       0,
       -- IND_PAGTO
       9,
       -- VL_DESC
       0,
       -- VL_MERC
       0,
       -- IND_FRT
       0,
       -- VL_FRT
       0,
       -- VL_SEG
       0,
       -- VL_OUT_DA
       0,
       -- VL_BC_ICMS
       0,
       -- VL_ICMS
       0,
       -- VL_BC_ICMS_ST
       0,
       -- VL_ICMS_ST
       0,
       -- VL_IPI
       0,
       -- VL_PIS
       0,
       -- VL_COFINS
       0,


       -- REGISTRO C113: DOCUMENTO FISCAL REFERENCIADO

       -- REG_C113
       '',
       -- IND_OPER_C113
       0,
       -- COD_PART_C113
       '',
       -- COD_MOD
       '',
       -- SER_C113
       '',
       -- NUM_DOC_C113
       0,
       -- CHV_DOCe
       '',


       -- REGISTRO C113: DOCUMENTO FISCAL REFERENCIADO

       -- REG_C114
       '',
       -- COD_MOD_C114
       '',
       -- ECF_CX
       0,
       -- NUM_DOC_C114
       0,


       -- REGISTRO C170: ITENS DO DOCUMENTO (CÓDIGO 01, 1B, 04 e 55)

       -- REG_C170
       '',
       -- NUM_ITEM
       0,
       -- DESCR_COMPL
       '',
       -- QTD
       0,
       -- VL_ITEM
       0,
       -- VL_DESCR_C170
       0,
       -- IND_MOV
       0,
       -- CST_ICMS
       '',
       -- CFOP
       '',
       -- VL_BC_ICMS_C170
       0,
       -- ALIQ_ICMS
       0,
       -- VL_ICMS_C170
       0,
       -- VL_BC_ICMS_ST_C170
       0,
       -- ALIQ_ST
       0,
       -- VL_ICMS_ST_C170
       0,
       -- VL_BC_IPI
       0,
       -- ALIQ_IPI
       0,
       -- VL_IPI_C170
       0,

       -- CST_PIS
       '',
       -- VL_BC_PIS
       0,
       -- ALIQ_PIS
       0,
       -- VL_PIS_C170 
       0,

       -- CST_COFINS
       '',
       -- VL_BC_COFINS
       0,
       -- ALIQ_COFINS
       0,
       -- VL_COFINS_C170
       0,

       -- REGISTRO C190: REGISTRO ANALÍTICO DO DOCUMENTO (CÓDIGO 01, 1B, 04, 55 e 65).
   
       -- REG_C190
       '',
       -- VL_BC_RED
       0,


       /* REGISTRO D100: NOTA FISCAL DE SERVIÇO DE TRANSPORTE (CÓDIGO 07) E CONHECIMENTOS DE TRANSPORTE RODOVIÁRIO DE CARGAS (CÓDIGO 08),
                   CONHECIMENTOS DE TRANSPORTE DE CARGAS AVULSO (CÓDIGO 8B), AQUAVIÁRIO DE CARGAS (CÓDIGO 09), AÉREO (CÓDIGO 10), FERROVIÁRIO DE CARGAS (CÓDIGO 11),
                   MULTIMODAL DE CARGAS (CÓDIGO 26), NOTA FISCAL DE TRANSPORTE FERROVIÁRIO DE CARGA (CÓDIGO 27), CONHECIMENTO DE TRANSPORTE ELETRÔNICO – CT-e (CÓDIGO 57) E
                   CONHECIMENTO DE TRANSPORTE ELETRÔNICO PARA OUTROS SERVIÇOS - CT-e OS (CÓDIGO 67) */

       -- REG_D100
       'D100',
       -- CHV_CTE
       '',
       -- DT_A_P
       '17530101',
       -- TP_CT_E
       0,
       -- VL_SERV
       0


  from TBS080 (nolock)
          inner join TBS002 (nolock) on TBS080.ENFCODDES=TBS002.CLICOD
          inner join TBS067 (nolock) on TBS067.SNESER=TBS080.SNESER and TBS067.NFSNUM=TBS080.ENFNUM
          inner join TBS0671 (nolock) on TBS0671.SNESER=TBS080.SNESER and TBS0671.NFSNUM=TBS080.ENFNUM
          inner join TBS010 (nolock) on TBS010.PROCOD=TBS0671.PROCOD
          inner join TBS011 (nolock) on TBS011.UNICOD=TBS010.PROUM1
                     
 where TBS080.ENFDATEMI between @datai and @dataf and TBS080.ENFSIT in(7,8,11) and TBS067.NFSTIP<>'L'
       and @sai='S'

-- order by TBS080.SNESER, TBS080.ENFNUM


union



-- entradas: devoluções de clientes - emissão própria

select -- REG_0150
       '0150',
       -- COD_PART
       case TBS002.CLITIPPES
          when 'J' then Ltrim(rtrim(TBS002.CLICGC))
          else Ltrim(rtrim(TBS002.CLICPF))
       end,
       -- NOME
       Ltrim(rtrim(NFENOM)),
       -- IE
       case TBS002.CLITIPPES
          when 'J' then Ltrim(rtrim(TBS002.CLIIES))
          else ''
       end,

       -- COD_MUN
       TBS002.MUNCOD,
       -- SUFRAMA
       TBS002.CLISUFRAMA,
       -- ENDER
       TBS002.CLIEND,
       -- NUM
       TBS002.CLINUM,
       -- BAIRRO
       TBS002.CLIBAI,

       -- REG_0190
       '0190',
       -- UNID
       TBS010.PROUM1,
       -- DESCR
       TBS011.UNIDES,

       -- REG_0200
       '0200',
       -- COD_ITEM
       TBS0591.PROCOD,
       -- DESCR_ITEM
       TBS010.PRODES,
       -- COD_NCM
       TBS010.PROCLAFIS,
       -- CEST
       TBS010.PROCEST,

       -- REG_0220
       '0220',
       -- UNID_CONV
       TBS0591.NFEUNI,
       -- FAT_CONV
       TBS0591.NFEFATOR,
       -- UNI_DESCR
       (select UNIDES from TBS011 (nolock) where UNICOD=TBS0591.NFEUNI),

       -- REG_0400
       '0400',
       -- COD_NAT
       'E' + subString(TBS0591.NFECFOP,3,3),
       -- DESCR_NAT
       (select COPTXT from TBS041 (nolock) where COPTIP='E' and COPCOD=subString(TBS0591.NFECFOP,3,3)),

       -- REG_C100
       'C100',
       -- IND_OPER
       0,
       -- IND_EMIT
       case NFENOSFOR when 'S' then 0 else 1 end,
       -- COD_SIT
       '00',
       -- SER
       TBS059.NFESERDOC,
       -- NUM_DOC
       TBS059.NFENUM,
       -- CHV_NFE
       TBS059.NFECHAACE,
       -- DT_DOC
       TBS059.NFEDATEMI,
       -- DT_E_S
       TBS059.NFEDATEFE,

       -- VL_DOC
       -- total da nf: - desconto + despesas  + st + ipi
       dbo.NFETOTOPE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),

       -- IND_PAGTO
       2,
       -- VL_DESC
       0, -- dbo.NFETOTDES(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       
       -- 13 / 16
       -- valor total dos produtos com com desconto, frete, seguro e outras despesas... sem ST e IPI
       /*
       dbo.NFETOTOPE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
       - dbo.NFETOTVICMSST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
       - dbo.NFETOTVIPI(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       */

       -- 09/03
       -- total produtos: - desconto + despesas + st - ipi
       dbo.NFETOTOPE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
       - dbo.NFETOTVIPI(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),

       -- IND_FRT
       case
          when dbo.NFETOTFRE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD) > 0 then 2
          else 1
       end,

       -- VL_FRT
       0, -- dbo.NFETOTFRE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       -- VL_SEG
       0, -- dbo.NFETOTSEG(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       -- VL_OUT_DA
       0, -- dbo.NFETOTOUT(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),

       -- VL_BC_ICMS
       case NFEEMIRET
          -- simples nacional
          when 1 then
              dbo.NFETOTBCICMSSNSEMST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
          else
              dbo.NFETOTBICMSSEMST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
       end,

       -- VL_ICMS
       case NFEEMIRET
          -- simples nacional
          when 1 then
              dbo.NFETOTVICMSSNSEMST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)

          else
              dbo.NFETOTVICMSSEMST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
       end,

       -- 08/03
       /*
       dbo.NFETOTBICMSST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       dbo.NFETOTVICMSST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       dbo.NFETOTVIPI(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       */
       -- VL_BC_ICMS_ST
       0,
       -- VL_ICMS_ST
       0,
       -- VL_IPI
       0,

       -- VL_PIS
       0, --dbo.NFETOTVPIS(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       -- VL_COFINS
       0, --dbo.NFETOTVCOFINS(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),

       -- REGISTRO C113: DOCUMENTO FISCAL REFERENCIADO

       -- REG_C113
       '',
       -- IND_OPER_C113
       0,
       -- COD_PART_C113
       '', --isnull(subString(TBS0596.NFENFRCHA,7,14),''),
       -- COD_MOD
       '', --case when TBS0596.NFENFRCHA<>'' then '55' else '' end,
       -- SER_C113
       '', --isnull(subString(TBS0596.NFENFRCHA,23,3),''),
       -- NUM_DOC_C113
       0, --isnull(convert(int, subString(TBS0596.NFENFRCHA,26,9)),0),
       -- CHV_DOCe
       '', --isnull(TBS0596.NFENFRCHA,''),

       -- REGISTRO C114: CUPOM FISCAL REFERENCIADO
 
       -- REG_C114
       '',
       -- COD_MOD_C114
       '', --case when NFENFRCOO > 0 then '2D' else '' end,
       -- ECF_CX
       0, --NFENFRECF,
       -- NUM_DOC_C114
       0, --isnull(NFENFRCOO,0),

       -- REGISTRO C170: ITENS DO DOCUMENTO (CÓDIGO 01, 1B, 04 e 55)

       -- REG_C170
       'C170',
       -- NUM_ITEM
       TBS0591.NFEITE,
       -- DESCR_COMPL
       '',
       -- QTD
       TBS0591.NFEQTD,

       -- VL_ITEM
       -- valor total do item já com desconto, frete, seguro e outras despesas.. sem ST e IPI
       -- 08/03
       --TBS0591.NFETOTOPEITE - TBS0591.NFEVALICMSST - TBS0591.NFEVALIPI , -- 5
       TBS0591.NFETOTOPEITE - TBS0591.NFEVALIPI,

       -- VL_DESC_C170
       0, -- TBS0591.NFEVALDESITE,

       -- IND_MOV
       case TBS0591.NFEMOVEST
          when 'S' then 0
          else 1
       end,

       -- CST_ICMS
       case
          -- 3 = regime normal; 2 = simples nacional – excesso de sublimite da receita bruta
          when TBS059.NFEEMIRET in(2,3) then
             case
                -- nf c/ST
                when NFEBASICMSST > 0 and right(rtrim(TBS0591.NFECST),2) not in('10','30','70') and TBS0591.NFEBASICMS > 0 and TBS0591.NFEREDBASICMS = 0 then Left(TBS0591.NFECST,1)+'10'
                when NFEBASICMSST > 0 and right(rtrim(TBS0591.NFECST),2) not in('10','30','70') and TBS0591.NFEBASICMS = 0 then Left(TBS0591.NFECST,1)+'30'
                when NFEBASICMSST > 0 and right(rtrim(TBS0591.NFECST),2) not in('10','30','70') and TBS0591.NFEREDBASICMS > 0 then Left(TBS0591.NFECST,1)+'70'
                else
                   case
                      -- sem base de ICMS
                      when TBS0591.NFEBASICMS=0 and right(rtrim(TBS0591.NFECST),2) not in('40','60','90') then Left(TBS0591.NFECST,1)+'41'
                      else TBS0591.NFECST
                   end
             end
          else
             -- simples nacional
             case TBS0591.NFEPCRESN
                -- sem permissão de crédido
                when 0 then Left(TBS0591.NFECSTXML,1)+'41'
                else
                   case TBS0591.NFEBASICMSST
                      when 0 then Left(TBS0591.NFECSTXML,1)+'00'
                      else Left(TBS0591.NFECSTXML,1)+'10'
                   end
             end
       end,

       -- CFOP
       rtrim(replace(NFECFOP,'.','')),

       --TBS0591.NFEBASICMS,
       --TBS0591.NFEPERICMS,
       --TBS0591.NFEVALICMS,

       /*
       case 
          when NFEBASICMSST > 0 then 0
          else TBS0591.NFEBASICMS
       end, -- 10

       case
          when NFEBASICMSST > 0 then 0
          else TBS0591.NFEPERICMS
       end, -- 11

       case
          when NFEBASICMSST > 0 then 0
          else TBS0591.NFEVALICMS
       end, -- 12
       */

       -- VL_BC_ICMS_C170
       case
          -- 3 = regime normal; 2 = simples nacional – excesso de sublimite da receita bruta
          when TBS059.NFEEMIRET in(2,3) then
             case
                -- nf c/ST
                when TBS0591.NFEBASICMSST > 0 then 0   -- zera a BC do ICMS
                -- BC do ICMS da nf
                else TBS0591.NFEBASICMS                -- valor da BC do ICMS
             end
          else
             -- 1 = simples nacional
             case
                -- nf c/ST
                when TBS0591.NFEBASICMSST > 0 then 0   -- zera a BC do ICMS
                else
                   case TBS0591.NFEPCRESN
                      -- sem permissão de crédito
                      when 0 then 0
                      else TBS0591.NFETOTOPEITE        -- utiliza o total do produto
                   end
             end
       end,

       -- ALIQ_ICMS
       case
          -- 3 = regime normal; 2 = simples nacional – excesso de sublimite da receita bruta
          when TBS059.NFEEMIRET in(2,3) then
             case
                -- nf c/ST
                when TBS0591.NFEBASICMSST > 0 then 0   -- zera a aliquota do ICMS
                -- BC do ICMS da nf
                else TBS0591.NFEPERICMS                -- alíquota do ICMS
             end
          else
             -- 1 = simples nacional
             case
                -- nf c/ST
                when TBS0591.NFEBASICMSST > 0 then 0   -- zera a aliquota do ICMS
                else
                   case TBS0591.NFEPCRESN
                      -- sem permissão de crédito
                      when 0 then 0
                      else TBS0591.NFEPCRESN           -- alíquota de crédito da SN
                   end
             end
       end,

       -- VL_ICMS_C170
       case
          -- 3 = regime normal; 2 = simples nacional – excesso de sublimite da receita bruta
          when TBS059.NFEEMIRET in(2,3) then
             case
                -- nf c/ST
                when TBS0591.NFEBASICMSST > 0 then 0   -- zera o valor do ICMS
                -- BC do ICMS da nf
                else TBS0591.NFEVALICMS                -- valor do ICMS
             end
          else
             -- 1 = simples nacional
             case
                -- nf c/ST
                when TBS0591.NFEBASICMSST > 0 then 0   -- zera o valor do ICMS
                else
                   case TBS0591.NFEPCRESN
                      -- sem permissão de crédito
                      when 0 then 0
                      else TBS0591.NFEVCRESN           -- valor do crédito da SN
                   end
             end
       end,

       -- 08/03
       /*
       TBS0591.NFEBASICMSST,
       TBS0591.NFEPERICMSST,
       TBS0591.NFEVALICMSST,
       */
       -- VL_BC_ICMS_ST_C170
       0,
       -- ALIQ_ST
       0,
       -- VL_ICMS_ST_C170
       0,

       -- VL_BC_IPI
       0, -- TBS0591.NFEBASIPI,
       -- ALIQ_IPI
       0, -- TBS0591.NFEPERIPI,
       -- VL_IPI_C170
       0, -- TBS0591.NFEVALIPI,

       -- CST-PIS
       /*
       '08', --TBS0591.NFECSTPIS,
       0, --TBS0591.NFEBASPIS,
       0, --TBS0591.NFEPERPIS,
       0, --TBS0591.NFEVALPIS,
       */
       case
          when TBS010.PROSTBPIS<>'' then Ltrim(rtrim(TBS010.PROSTBPIS))

          else '50'
       end,

       -- VL_BC_PIS
       TBS0591.NFETOTOPEITE, -- - TBS0591.NFEVALICMS,

       -- ALIQ_PIS
       case
          when TBS010.PROSTBPIS<>'' then TBS010.PROPIS

          else 1.65
       end,

       -- VL_PIS
       0,

       -- CST-COFINS
       /*
       '08', --TBS0591.NFECSTCOFINS,
       0, --TBS0591.NFEBASCOFINS,
       0, --TBS0591.NFEPERCOFINS,
       0, --TBS0591.NFEVALCOFINS,
       */
       case
          when TBS010.PROSTBCOFINS<>'' then Ltrim(rtrim(TBS010.PROSTBCOFINS))

          else '50'
       end,

       -- VL_BC_COFINS
       TBS0591.NFETOTOPEITE, -- - TBS0591.NFEVALICMS,

       -- ALIQ_COFINS
       case
          when TBS010.PROSTBCOFINS<>'' then TBS010.PROCOFINS

          else 7.6
       end,

       -- VL_COFINS_C170
       0,

       -- REGISTRO C190: REGISTRO ANALÍTICO DO DOCUMENTO (CÓDIGO 01, 1B, 04, 55 e 65).
      
       -- REG_C190
       'C190',
       -- VL_RED_BC
       TBS0591.NFEREDBASICMS,

       /* REGISTRO D100: NOTA FISCAL DE SERVIÇO DE TRANSPORTE (CÓDIGO 07) E CONHECIMENTOS DE TRANSPORTE RODOVIÁRIO DE CARGAS (CÓDIGO 08),
                   CONHECIMENTOS DE TRANSPORTE DE CARGAS AVULSO (CÓDIGO 8B), AQUAVIÁRIO DE CARGAS (CÓDIGO 09), AÉREO (CÓDIGO 10), FERROVIÁRIO DE CARGAS (CÓDIGO 11),
                   MULTIMODAL DE CARGAS (CÓDIGO 26), NOTA FISCAL DE TRANSPORTE FERROVIÁRIO DE CARGA (CÓDIGO 27), CONHECIMENTO DE TRANSPORTE ELETRÔNICO – CT-e (CÓDIGO 57) E
                   CONHECIMENTO DE TRANSPORTE ELETRÔNICO PARA OUTROS SERVIÇOS - CT-e OS (CÓDIGO 67) */

       -- REG_D100
       'D100',
       -- CHV_CTE
       '',
       -- DT_A_P
       '17530101',
       -- TP_CT_E
       0,
       -- VL_SERV
       0

  from TBS059 (nolock)
          inner join TBS0591 (nolock) on TBS0591.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0591.SEREMPCOD=TBS059.SEREMPCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
          --Left join TBS0596 (nolock)  on TBS0596.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0596.SEREMPCOD=TBS059.SEREMPCOD and TBS0596.NFETIP=TBS059.NFETIP and TBS0596.SERCOD=TBS059.SERCOD and TBS0596.NFECOD=TBS059.NFECOD and TBS0596.NFENUM=TBS059.NFENUM --and TBS0596.NFENFRTIP='NFE'
          inner join TBS002 (nolock)  on TBS002.CLICOD=TBS059.NFECOD
          inner join TBS010 (nolock)  on TBS010.PROCOD=TBS0591.PROCOD
          inner join TBS011 (nolock)  on TBS011.UNICOD=TBS010.PROUM1
                     
 where TBS059.NFETIP='D' and TBS059.NFEDATEFE between @datai and @dataf and TBS059.NFECAN='N' and TBS059.NFENOSFOR='N'
       and @ent='S'

-- order by TBS080.SNESER, TBS080.ENFNUM


union

-- entradas: devoluções de clientes - emissão própria - documento fiscal referenciado

select -- REG_0150
       '',
       -- COD_PART
       '',
       -- NOME
       '',
       -- IE
       '',
       -- COD_MUN
       0,
       -- SUFRAMA
       0,
       -- ENDER
       '',
       -- NUM
       '',
       -- BAIRRO
       '',

       -- REG_0190
       '',
       -- UNID
       '',
       -- DESCR
       '',

       -- REG_0200
       '',
       -- COD_ITEM
       '',
       -- DESCR_ITEM
       '',
       -- COD_NCM
       '',
       -- CEST
       '',

       -- REG_0220
       '',
       -- UNID_CONV
       '',
       -- FAT_CONV
       0,
       -- UNI_DESCR
       '',

       -- REG_0400
       '',
       -- COD_NAT
       '',
       -- DESCR_NAT
       '',

       -- REG_C100
       'C100',
       -- IND_OPER
       0,
       -- IND_EMIT
       case NFENOSFOR when 'S' then 0 else 1 end,
       -- COD_SIT
       '00',
       -- SER
       TBS059.NFESERDOC,
       -- NUM_DOC
       TBS059.NFENUM,
       -- CHV_NFE
       TBS059.NFECHAACE,
       -- DT_DOC
       '17530101',
       -- DT_E_S
       '17530101',
       -- VL_DOC
       0,
       -- IND_PAGTO
       2,
       -- VL_DESC
       0,
       -- VL_MERC
       0,
       -- IND_FRT
       0,
       -- VL_FRT
       0,
       -- VL_SEG
       0,
       -- VL_OUT_DA
       0,
       -- VL_BC_ICMS
       0,
       -- VL_ICMS
       0,
       -- VL_BC_ICMS_ST
       0,
       -- VL_ICMS_ST
       0,
       -- VL_IPI
       0,
       -- VL_PIS
       0,
       -- VL_COFINS
       0,

       -- REGISTRO C113: DOCUMENTO FISCAL REFERENCIADO
       
       -- REG_C113
       'C113',
       -- IND_OPER_C113
       0,
       -- COD_PART_C113
       isnull(subString(TBS0596.NFENFRCHA,7,14),''),
       -- COD_MOD
       case when TBS0596.NFENFRCHA<>'' then '55' else '' end,
       -- SER_C113
       isnull(subString(TBS0596.NFENFRCHA,23,3),''),
       -- NUM_DOC_C113
       isnull(convert(int, subString(TBS0596.NFENFRCHA,26,9)),0),
       -- CHV_DOCe
       isnull(TBS0596.NFENFRCHA,''),

       -- REGISTRO C114: CUPOM FISCAL REFERENCIADO
       
       -- REG_C114
       '',
       -- COD_MOD
       '',
       -- ECF_CX
       0,
       -- NUM_DOC_C114
       0,

       -- REGISTRO C170: ITENS DO DOCUMENTO (CÓDIGO 01, 1B, 04 e 55)

       -- REG_C170
       '',
       -- NUM_ITEM
       999,
       -- DESCR_COMPL
       '',
       -- QTD
       0,
       -- VL_ITEM
       0,
       -- VL_DESC_C170
       0,
       -- IND_MOV
       0,
       -- CST_ICMS
       '',
       -- CFOP
       '',
       -- VL_BC_ICMS_C170
       0,
       -- ALIQ_ICMS
       0,
       -- VL_ICMS_C170
       0,
       -- VL_BC_ICMS_ST_C170
       0,
       -- ALIQ_ST
       0,
       -- VL_ICMS_ST_C170
       0,
       -- VL_BC_IPI
       0,
       -- ALIQ_IPI
       0,
       -- VL_IPI_C170
       0,

       -- CST_PIS
       '',
       -- VL_BC_PIS
       0,
       -- ALIQ_PIS
       0,
       -- VL_PIS
       0,

       -- CST_COFINS
       '',
       -- VL_BC_COFINS
       0,
       -- ALIQ_COFINS
       0,
       -- VL_COFINS_C170
       0,

       -- REGISTRO C190: REGISTRO ANALÍTICO DO DOCUMENTO (CÓDIGO 01, 1B, 04, 55 e 65).

       -- REG_C190
       '',
       -- VL_RED_BC
       0,

       /* REGISTRO D100: NOTA FISCAL DE SERVIÇO DE TRANSPORTE (CÓDIGO 07) E CONHECIMENTOS DE TRANSPORTE RODOVIÁRIO DE CARGAS (CÓDIGO 08),
                   CONHECIMENTOS DE TRANSPORTE DE CARGAS AVULSO (CÓDIGO 8B), AQUAVIÁRIO DE CARGAS (CÓDIGO 09), AÉREO (CÓDIGO 10), FERROVIÁRIO DE CARGAS (CÓDIGO 11),
                   MULTIMODAL DE CARGAS (CÓDIGO 26), NOTA FISCAL DE TRANSPORTE FERROVIÁRIO DE CARGA (CÓDIGO 27), CONHECIMENTO DE TRANSPORTE ELETRÔNICO – CT-e (CÓDIGO 57) E
                   CONHECIMENTO DE TRANSPORTE ELETRÔNICO PARA OUTROS SERVIÇOS - CT-e OS (CÓDIGO 67) */

       -- REG_D100
       'D100',
       -- CHV_CTE
       '',
       -- DT_A_P
       '17530101',
       -- TP_CT_E
       0,
       -- VL_SERV
       0

  from TBS059 (nolock)
       inner join TBS0596 (nolock) on TBS0596.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0596.SEREMPCOD=TBS059.SEREMPCOD and TBS0596.NFETIP=TBS059.NFETIP and TBS0596.SERCOD=TBS059.SERCOD and TBS0596.NFECOD=TBS059.NFECOD and TBS0596.NFENUM=TBS059.NFENUM --and TBS0596.NFENFRTIP='NFE'
                     
 where TBS059.NFETIP='D' and TBS059.NFEDATEFE between @datai and @dataf and TBS059.NFECAN='N' and TBS059.NFENOSFOR='N'
       and @ent='S'


union


-- entradas: devoluções de clientes - gera NF-E

select -- REG_0150
       '0150',
       -- COD_PART
       case TBS002.CLITIPPES
          when 'J' then Ltrim(rtrim(TBS002.CLICGC))
          else Ltrim(rtrim(TBS002.CLICPF))
       end,
       -- NOME
       Ltrim(rtrim(NFENOM)),
       -- IE
       case TBS002.CLITIPPES
          when 'J' then Ltrim(rtrim(TBS002.CLIIES))
          else ''
       end,
       -- COD_MUN
       TBS002.MUNCOD,
       -- SUFRAMA
       TBS002.CLISUFRAMA,
       -- ENDER
       TBS002.CLIEND,
       -- NUM
       TBS002.CLINUM,
       -- BAIRRO
       TBS002.CLIBAI,

       -- REG_0190
       '0190',
       -- UNID
       TBS010.PROUM1,
       -- DESCR
       TBS011.UNIDES,

       -- REG_0200
       '0200',
       -- COD_ITEM
       TBS0591.PROCOD,
       -- DESCR_ITEM
       TBS010.PRODES,
       -- COD_NCM
       TBS010.PROCLAFIS,
       -- CEST
       TBS010.PROCEST,

       -- REG_0220
       '0220',
       -- UNID_CONV
       TBS0591.NFEUNI,
       -- FAT_CONV
       TBS0591.NFEFATOR,
       -- UNI_DESCR
       (select UNIDES from TBS011 (nolock) where UNICOD=TBS0591.NFEUNI),

       -- REG_0400
       '0400',
       -- COD_NAT
       'E' + subString(TBS0591.NFECFOP,3,3),
       -- DESCR_NAT
       (select COPTXT from TBS041 (nolock) where COPTIP='E' and COPCOD=subString(TBS0591.NFECFOP,3,3)),

       -- REG_C100
       'C100',
       -- IND_OPER
       0,
       -- IND_EMIT
       case NFENOSFOR when 'S' then 0 else 1 end,
       -- COD_SIT 
       '00',
       -- SER 
       TBS059.NFESERDOC,
       -- NUM_DOC
       TBS059.NFENUM,
       -- CHV_NFE
       TBS059.NFECHAACE,
       -- DT_DOC
       TBS059.NFEDATEMI,
       -- DT_E_S
       TBS059.NFEDATEFE,

       -- VL_DOC
       dbo.NFETOTOPE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),

       -- IND_PAGTO
       2,
       -- VL_DESC
       0, -- dbo.NFETOTDES(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD), -- 12 / 14
       
       -- valor total dos produtos com com desconto, frete, seguro e outras despesas... sem ST e IPI
       /*
       dbo.NFETOTOPE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
       - dbo.NFETOTVICMSST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
       - dbo.NFETOTVIPI(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       */

       -- VL_MERC
       -- 08/03
       -- valor total dos produtos com com desconto, frete, seguro, outras despesas e ST
       dbo.NFETOTOPE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
       - dbo.NFETOTVIPI(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),

       -- IND_FRT
       -- 14 / 17
       case
          when dbo.NFETOTFRE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD) > 0 then 2
          else 1
       end,

       -- VL_FRT
       0, -- dbo.NFETOTFRE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       -- VL_SEG
       0, -- dbo.NFETOTSEG(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       -- VL_OUT_DA
       0, -- dbo.NFETOTOUT(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),

       -- VL_BC_ICMS
       case NFEEMIRET
          -- simples nacional
          when 1 then
              dbo.NFETOTBCICMSSNSEMST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
          else
              dbo.NFETOTBICMSSEMST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
       end,

       -- VL_ICMS
       case NFEEMIRET
          -- simples nacional
          when 1 then
              dbo.NFETOTVICMSSNSEMST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)

          else
              dbo.NFETOTVICMSSEMST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
       end,

       -- 10/03
       /*
       -- VL_BC_ICMS
       case NFEBASICMSST
          when 0 then dbo.NFETOTBICMS(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
          else 0
       end,
       -- dbo.NFETOTBICMSSEMST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),

       -- VL_ICMS
       case NFEBASICMSST
          when 0 dbo.NFETOTVICMS(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
          else 0
       end,
       */
       
       -- 08/03
       /*
       dbo.NFETOTBICMSST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       dbo.NFETOTVICMSST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       dbo.NFETOTVIPI(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       */
       -- VL_BC_ICMS_ST
       0,
       -- VL_ICMS_ST
       0,
       -- VL_IPI
       0,
 
       -- VL_PIS
       0, --dbo.NFETOTVPIS(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       -- VL_COFINS
       0, --dbo.NFETOTVCOFINS(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),

       -- REGISTRO C113: DOCUMENTO FISCAL REFERENCIADO

       -- REG_C113
       '',
       -- IND_OPER_C113
       0,
       -- COD_PART_C113
       '',
       -- COD_MOD
       '',
       -- SER_C113
       '',
       -- NUM_DOC_C113
       0,
       -- CHV_DOCe
       '',

       -- REGISTRO C114: CUPOM FISCAL REFERENCIADO

       -- REG_C114
       '',
       -- COD_MOD_C114
       '',
       -- ECF_CX
       0,
       -- NUM_DOC_C114
       0,

       -- REGISTRO C170: ITENS DO DOCUMENTO (CÓDIGO 01, 1B, 04 e 55)

       -- REG_C170
       'C170',
       -- NUM_ITEM
       TBS0591.NFEITE,
       -- DESCR_COMPL
       '',
       -- QTD
       TBS0591.NFEQTD,

       -- NFETOTOPEITE = NFETOTITEBRU - NFEVALDESITE + NFEVALFREITE + NFEVALSEGITE + NFEVALOUTDES + NFEVALICMSST + NFEVALIPI
       --TBS0591.NFETOTOPEITE, -- 7
       -- valor total do item já com desconto, frete, seguro e outras despesas.. sem ST e IPI
       --TBS0591.NFETOTOPEITE - TBS0591.NFEVALICMSST - TBS0591.NFEVALIPI , -- 5

       -- VL_ITEM
       -- valor total do item já com desconto, frete, seguro, outras despesas e ST
       TBS0591.NFETOTOPEITE - TBS0591.NFEVALIPI,

       -- VL_DESC_C170
       0, -- 6 / 8 -- TBS0591.NFEVALDESITE,

       -- IND_MOV
       case TBS0591.NFEMOVEST
          when 'S' then 0
          else 1
       end,

       -- CST_ICMS
       --TBS010.PROSTBA+TBS010.PROSTBB,  -- 8
       case
          -- nf c/ST
          --when NFEBASICMSST > 0 then Left(TBS0591.NFECST,1)+'41'
          when NFEBASICMSST > 0 and right(rtrim(TBS0591.NFECST),2) not in('10','30','70') and TBS0591.NFEBASICMS > 0 and TBS0591.NFEREDBASICMS = 0 then Left(TBS0591.NFECST,1)+'10'
          when NFEBASICMSST > 0 and right(rtrim(TBS0591.NFECST),2) not in('10','30','70') and TBS0591.NFEBASICMS = 0 then Left(TBS0591.NFECST,1)+'30'
          when NFEBASICMSST > 0 and right(rtrim(TBS0591.NFECST),2) not in('10','30','70') and TBS0591.NFEREDBASICMS > 0 then Left(TBS0591.NFECST,1)+'70'
          else
             case
                -- sem base de ICMS
                when TBS0591.NFEBASICMS=0 and right(rtrim(TBS0591.NFECST),2) not in('40','60','90') then Left(TBS0591.NFECST,1)+'41'
                else TBS0591.NFECST
             end
       end,

       -- CFOP
       rtrim(replace(NFECFOP,'.','')), -- 9

       -- VL_BC_ICMS_C170
       case
          -- nf c/ST
          when TBS0591.NFEBASICMSST > 0 then 0   -- zera a BC do ICMS
          -- BC do ICMS da nf
          else TBS0591.NFEBASICMS                -- valor da BC do ICMS
       end,

       -- ALIQ_ICMS
       case
          -- nf c/ST
          when TBS0591.NFEBASICMSST > 0 then 0   -- zera a aliquota do ICMS
          -- BC do ICMS da nf
          else TBS0591.NFEPERICMS                -- alíquota do ICMS
       end,

       -- VL_ICMS_C170
       case
          -- nf c/ST
          when TBS0591.NFEBASICMSST > 0 then 0   -- zera o valor do ICMS
          -- BC do ICMS da nf
          else TBS0591.NFEVALICMS                -- valor do ICMS
       end,

       -- 08/03
       /*
       TBS0591.NFEBASICMSST,
       TBS0591.NFEPERICMSST,
       TBS0591.NFEVALICMSST,
       */
   
       -- VL_BC_ICMS_ST_C170
       0,
       -- ALIQ_ST
       0,
       -- VL_ICMS_ST_C170
       0,

       -- VL_BC_IPI
       0, -- TBS0591.NFEBASIPI,
       -- ALIQ_IPI
       0, -- TBS0591.NFEPERIPI,
       -- VL_IPI_C170
       0, -- TBS0591.NFEVALIPI,

       -- CST_PIS
       case
          when TBS010.PROSTBPIS<>'' then Ltrim(rtrim(TBS010.PROSTBPIS))

          else '50'
       end,

       -- VL_BC_PIS
       TBS0591.NFETOTOPEITE, -- - TBS0591.NFEVALICMS,

       -- ALIQ_PIS
       case
          when TBS010.PROSTBPIS<>'' then TBS010.PROPIS

          else 1.65
       end,

       -- VL_PIS_C170
       0,

       -- CST_COFINS
       case
          when TBS010.PROSTBCOFINS<>'' then Ltrim(rtrim(TBS010.PROSTBCOFINS))

          else '50'
       end,

       -- VL_BC_COFINS
       TBS0591.NFETOTOPEITE, -- - TBS0591.NFEVALICMS,

       -- ALIQ_COFINS
       case
          when TBS010.PROSTBCOFINS<>'' then TBS010.PROCOFINS

          else 7.6
       end,

       -- VL_COFINS_C170
       0,

       -- REGISTRO C190: REGISTRO ANALÍTICO DO DOCUMENTO (CÓDIGO 01, 1B, 04, 55 e 65).

       -- REG_C190
       'C190',
       -- VL_RED_BC
       TBS0591.NFEREDBASICMS,

       /* REGISTRO D100: NOTA FISCAL DE SERVIÇO DE TRANSPORTE (CÓDIGO 07) E CONHECIMENTOS DE TRANSPORTE RODOVIÁRIO DE CARGAS (CÓDIGO 08),
                   CONHECIMENTOS DE TRANSPORTE DE CARGAS AVULSO (CÓDIGO 8B), AQUAVIÁRIO DE CARGAS (CÓDIGO 09), AÉREO (CÓDIGO 10), FERROVIÁRIO DE CARGAS (CÓDIGO 11),
                   MULTIMODAL DE CARGAS (CÓDIGO 26), NOTA FISCAL DE TRANSPORTE FERROVIÁRIO DE CARGA (CÓDIGO 27), CONHECIMENTO DE TRANSPORTE ELETRÔNICO – CT-e (CÓDIGO 57) E
                   CONHECIMENTO DE TRANSPORTE ELETRÔNICO PARA OUTROS SERVIÇOS - CT-e OS (CÓDIGO 67) */

       -- REG_D100
       'D100',
       -- CHV_CTE
       '',
       -- DT_A_P
       '17530101',
       -- TP_CT_E
       0,
       -- VL_SERV
       0

  from TBS059 (nolock)
          inner join TBS0591 (nolock) on TBS0591.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0591.SEREMPCOD=TBS059.SEREMPCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
          --Left join TBS0596 (nolock) on TBS0596.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0596.SEREMPCOD=TBS059.SEREMPCOD and TBS0596.NFETIP=TBS059.NFETIP and TBS0596.SERCOD=TBS059.SERCOD and TBS0596.NFECOD=TBS059.NFECOD and TBS0596.NFENUM=TBS059.NFENUM --and TBS0596.NFENFRTIP='NFE'
          inner join TBS002 (nolock) on TBS002.CLICOD=TBS059.NFECOD
          inner join TBS010 (nolock) on TBS010.PROCOD=TBS0591.PROCOD
          inner join TBS011 (nolock) on TBS011.UNICOD=TBS010.PROUM1
          inner join TBS080 (nolock) on TBS080.SNESER=convert(smallint,TBS059.NFESERDOC) and TBS080.ENFNUM=TBS059.NFENUM
                     
 where TBS059.NFETIP='D' and TBS059.NFEDATEFE between @datai and @dataf and TBS059.NFECAN='N' and TBS059.NFENOSFOR='S'
       and TBS080.ENFSIT=6
       --and TBS080.ENFFINEMI=4
       and @ent='S'

union


-- entradas: devoluções de clientes - gera NF-E - documento fiscal referenciado / cupom fiscal referenciado

select -- REG_0150
       '',
       -- COD_PART
       '',
       -- NOME
       '',
       -- IE
       '',
       -- COD_MUN
       0,
       -- SUFRAMA
       0,
       -- ENDER
       '',
       -- NUM
       '',
       -- BAIRRO
       '',

       -- REG_0190
       '',
       -- UNID
       '',
       -- DESCR
       '',

       -- REG_0200
       '',
       -- COD_ITEM
       '',
       -- DESCR_ITEM
       '',
       -- COD_NCM
       '',
       -- CEST
       '',

       -- REG_0220
       '',
       -- UNID_CONV
       '',
       -- FAT_CONV
       0,
       -- UNI_DESCR
       '',

       -- REG_0400
       '',
       -- COD_NAT
       '',
       -- DESCR_NAT
       '',

       -- REG_C100
       'C100',
       -- IND_OPER
       0,
       -- IND_EMIT
       case NFENOSFOR when 'S' then 0 else 1 end,
       -- COD_SIT
       '00',
       -- SER
       TBS059.NFESERDOC,
       -- NUM_DOC
       TBS059.NFENUM,
       -- CHV_NFE
       TBS059.NFECHAACE,
       -- DT_DOC
       '17530101',
       -- DT_E_S
       '17530101',
       -- VL_DOC
       0,
       -- IND_PAGTO
       2,
       -- VL_DESC
       0,
       -- VL_MERC
       0,
       -- IND_FRT
       0,
       -- VL_FRT
       0,
       -- VL_SEG
       0,
       -- VL_OUT_DA
       0,
       -- VL_BC_ICMS
       0,
       -- VL_ICMS
       0,
       -- VL_BC_ICMS_ST
       0,
       -- VL_ICMS_ST
       0,
       -- VL_IPI
       0,
       -- VL_PIS
       0,
       -- VL_COFINS
       0,

       -- REGISTRO C113: DOCUMENTO FISCAL REFERENCIADO

       -- REG_C113
       'C113',
       -- IND_OPER_C113
       0,
       -- COD_PART_C113
       isnull(subString(TBS0596.NFENFRCHA,7,14),''),
       -- COD_MOD
       case when TBS0596.NFENFRCHA<>'' then '55' else '' end,
       -- SER_C113
       isnull(subString(TBS0596.NFENFRCHA,23,3),''),
       -- NUM_DOC_C113
       isnull(convert(int, subString(TBS0596.NFENFRCHA,26,9)),0),
       -- CHV_DOCe
       isnull(TBS0596.NFENFRCHA,''),

       -- REGISTRO C114: CUPOM FISCAL REFERENCIADO

       -- REG_C114
       'C114',
       -- COD_MOD_C114
       case when TBS0596.NFENFRCOO > 0 then '2D' else '' end,
       -- ECF_CX
       TBS0596.NFENFRECF,
       -- NUM_DOC_C114
       isnull(TBS0596.NFENFRCOO,0),

       -- REGISTRO C170: ITENS DO DOCUMENTO (CÓDIGO 01, 1B, 04 e 55)

       -- REG_C170
       '', -- C170
       -- NUM_ITEM
       999,
       -- DESCR_COMPL
       '',
       -- QTD
       0,
       -- VL_ITEM
       0,
       -- VL_DESC_C170
       0,
       -- IND_MOV
       0,
       -- CST_ICMS
       '',
       -- CFOP
       '',
       -- VL_BC_ICMS_C170
       0,
       -- ALIQ_ICMS
       0,
       -- VL_ICMS_C170
       0,
       -- VL_BC_ICMS_ST_C170
       0,
       -- ALIQ_ST
       0,
       -- VL_ICMS_ST_C170
       0,
       -- VL_BC_IPI
       0,
       -- ALIQ_IPI
       0,
       -- VL_IPI_C170
       0,

        -- CST_PIS
       '',
       -- VL_BC_PIS
       0,
       -- ALIQ_PIS
       0,
       -- VL_PIS_C170
       0,
 
       -- CST_COFINS
       '',
       -- VL_BC_COFINS
       0,
       -- ALIQ_COFINS
       0,
       -- VL_COFINS_C170
       0,

       -- REGISTRO C190: REGISTRO ANALÍTICO DO DOCUMENTO (CÓDIGO 01, 1B, 04, 55 e 65).

       -- REG_C190
       '',
       -- VL_RED_BC
       0,

       /* REGISTRO D100: NOTA FISCAL DE SERVIÇO DE TRANSPORTE (CÓDIGO 07) E CONHECIMENTOS DE TRANSPORTE RODOVIÁRIO DE CARGAS (CÓDIGO 08),
                   CONHECIMENTOS DE TRANSPORTE DE CARGAS AVULSO (CÓDIGO 8B), AQUAVIÁRIO DE CARGAS (CÓDIGO 09), AÉREO (CÓDIGO 10), FERROVIÁRIO DE CARGAS (CÓDIGO 11),
                   MULTIMODAL DE CARGAS (CÓDIGO 26), NOTA FISCAL DE TRANSPORTE FERROVIÁRIO DE CARGA (CÓDIGO 27), CONHECIMENTO DE TRANSPORTE ELETRÔNICO – CT-e (CÓDIGO 57) E
                   CONHECIMENTO DE TRANSPORTE ELETRÔNICO PARA OUTROS SERVIÇOS - CT-e OS (CÓDIGO 67) */

       -- REG_D100
       'D100',
       -- CHV_CTE
       '',
       -- DT_A_P
       '17530101',
       -- TP_CT_E
       0,
       -- VL_SERV
       0

  from TBS059 (nolock)
       inner join TBS0596 (nolock) on TBS0596.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0596.SEREMPCOD=TBS059.SEREMPCOD and TBS0596.NFETIP=TBS059.NFETIP and TBS0596.SERCOD=TBS059.SERCOD and TBS0596.NFECOD=TBS059.NFECOD and TBS0596.NFENUM=TBS059.NFENUM --and TBS0596.NFENFRTIP='NFE'
       inner join TBS080 (nolock) on TBS080.SNESER=convert(smallint,TBS059.NFESERDOC) and TBS080.ENFNUM=TBS059.NFENUM
                     
 where TBS059.NFETIP='D' and TBS059.NFEDATEFE between @datai and @dataf and TBS059.NFECAN='N' and TBS059.NFENOSFOR='S'
       and TBS080.ENFSIT=6 and TBS080.ENFFINEMI=4
       and @ent='S'


union


-- entradas: compras

select -- REG_0150
       '0150',
       -- COD_PART
       case TBS006.FORTIPPES
          when 'J' then Ltrim(rtrim(TBS006.FORCGC))
          else Ltrim(rtrim(TBS006.FORCPF))
       end,

       -- NOME
       Ltrim(rtrim(NFENOM)),
       -- IE
       case TBS006.FORTIPPES
          when 'J' then Ltrim(rtrim(TBS006.FORIES))
          else ''
       end,
       -- COD_MUN
       TBS006.MUNCOD,
       -- SUFRAMA
       0,
       -- ENDER
       TBS006.FOREND,
       -- NUM
       TBS006.FORNUM,
       -- BAIRRO
       TBS006.FORBAI,

       -- REG_0190
       '0190',
       -- UNID
       TBS010.PROUM1,
       -- DESCR
       TBS011.UNIDES,

       -- REG_0200
       '0200',
       -- COD_ITEM
       TBS0591.PROCOD,
       -- DESCR_ITEM
       TBS010.PRODES,
       -- COD_NCM
       TBS010.PROCLAFIS,
       -- CEST
       TBS010.PROCEST,

       -- REG_0220
       '0220',
       -- UNID_CONV
       TBS0591.NFEUNI,
       -- FAT_CONV
       TBS0591.NFEFATOR,
       -- UNI_DESCR
       (select UNIDES from TBS011 (nolock) where UNICOD=TBS0591.NFEUNI),

       -- REG_0400
       '0400',
       -- COD_NAT
       'E' + subString(TBS0591.NFECFOP,3,3),
       -- DESCR_NAT
       (select COPTXT from TBS041 (nolock) where COPTIP='E' and COPCOD=subString(TBS0591.NFECFOP,3,3)),

       -- REG_C100
       'C100',
       -- IND_OPER
       0,
       -- IND_EMIT
       1,
       -- COD_SIT
       '00',
       -- SER
       TBS059.NFESERDOC,
       -- NUM_DOC
       TBS059.NFENUM,
       -- CHV_NFE
       TBS059.NFECHAACE,
       -- DT_DOC
       TBS059.NFEDATEMI,
       -- DT_E_S
       TBS059.NFEDATEFE,
       -- VL_DOC
       dbo.NFETOTOPE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       -- IND_PAGTO
       2,
       -- VL_DESC
       0, -- dbo.NFETOTDES(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD), -- 12 / 14

       -- VL_MERC
       -- valor total dos produtos com com desconto, frete, seguro e outras despesas... sem ST e IPI
       /*
       dbo.NFETOTOPE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
       - dbo.NFETOTVICMSST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
       - dbo.NFETOTVIPI(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       */

       -- 08/03
       -- valor total dos produtos com com desconto, frete, seguro, outras despesas e ST
       dbo.NFETOTOPE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD) --, -- 13
       - dbo.NFETOTVIPI(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),

       -- IND_FRT
       case
          when dbo.NFETOTFRE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD) > 0 then 2
          else 1
       end,

       -- VL_FRT
       0, -- 15 / 18 -- dbo.NFETOTFRE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       -- VL_SEG
       0, -- 16 / 19 -- dbo.NFETOTSEG(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       -- VL_OUT_DA
       0, -- 17 / 20 -- dbo.NFETOTOUT(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),

       -- VL_BC_ICMS
       case NFEEMIRET
          -- simples nacional
          when 1 then
              dbo.NFETOTBCICMSSNSEMST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
          else
              dbo.NFETOTBICMSSEMST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
       end,

       -- VL_ICMS
       case NFEEMIRET
          -- simples nacional
          when 1 then
              dbo.NFETOTVICMSSNSEMST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)

          else
              dbo.NFETOTVICMSSEMST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)
       end,

       -- 08/03
       /*
       dbo.NFETOTBICMSST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD), -- 20 / 23
       dbo.NFETOTVICMSST(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD), -- 21 / 24
       dbo.NFETOTVIPI(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),    -- 22 / 25
       */

       -- VL_BC_ICMS_ST
       0,
       -- VL_ICMS_ST
       0,
       -- VL_IPI
       dbo.NFETOTVIPI(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),

       -- VL_PIS
       0, -- dbo.NFETOTVPIS(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),
       -- VL_COFINS
       0, -- dbo.NFETOTVCOFINS(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD),

       -- REGISTRO C113: DOCUMENTO FISCAL REFERENCIADO

       -- REG_C113
       '',
       -- IND_OPER_C113
       0,
       -- COD_PART_C113
       '',
       -- COD_MOD
       '',
       -- SER_C113
       '',
       -- NUM_DOC_C113
       0,
       -- CHV_DOCe
       '',

       -- REGISTRO C113: DOCUMENTO FISCAL REFERENCIADO

       -- REG_C114
       '',
       -- COD_MOD_C114
       '',
       -- ECF_CX
       0,
       -- NUM_DOC_C114
       0,

       -- REGISTRO C170: ITENS DO DOCUMENTO (CÓDIGO 01, 1B, 04 e 55)

       -- REG_C170
       'C170',
       -- NUM_ITEM
       TBS0591.NFEITE,
       -- DESCR_COMPL
       '',
       -- QTD
       TBS0591.NFEQTD,

       -- NFETOTOPEITE = NFETOTITEBRU - NFEVALDESITE + NFEVALFREITE + NFEVALSEGITE + NFEVALOUTDES + NFEVALICMSST + NFEVALIPI
       --TBS0591.NFETOTOPEITE, -- 7
       -- valor total do item já com desconto, frete, seguro e outras despesas.. sem ST e IPI

       -- VL_ITEM       
       -- 08/03
       -- valor total do item já com desconto, frete, seguro, outras despesas e ST

       TBS0591.NFETOTOPEITE - TBS0591.NFEVALIPI,

       --dbo.NFETOTITEBRU(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD, TBS0591.NFEITE), -- 7
       --dbo.NFETOTITEBRU(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD, TBS0591.NFEITE) + TBS0591.NFEVALIPI + TBS0591.NFEVALICMSST,

       -- VL_DESC_C170
       0,

       -- IND_MOV
       case TBS0591.NFEMOVEST
          when 'S' then 0
          else 1
       end,
       
       -- CST_ICMS
       case
          -- 3 = regime normal; 2 = simples nacional – excesso de sublimite da receita bruta
          when TBS059.NFEEMIRET in(2,3) then
             case
                -- nf c/ST
                --when NFEBASICMSST > 0 then Left(TBS0591.NFECSTXML,1)+'41'
                when NFEBASICMSST > 0 and right(rtrim(TBS0591.NFECST),2) not in('10','30','70') and TBS0591.NFEBASICMS > 0 and TBS0591.NFEREDBASICMS = 0 then Left(TBS0591.NFECST,1)+'10'
                when NFEBASICMSST > 0 and right(rtrim(TBS0591.NFECST),2) not in('10','30','70') and TBS0591.NFEBASICMS = 0 then Left(TBS0591.NFECST,1)+'30'
                when NFEBASICMSST > 0 and right(rtrim(TBS0591.NFECST),2) not in('10','30','70') and TBS0591.NFEREDBASICMS > 0 then Left(TBS0591.NFECST,1)+'70'
                else
                   case
                      -- sem base de ICMS
                      when TBS0591.NFEBASICMS=0 and right(rtrim(TBS0591.NFECSTXML),2) not in('40','60','90') then Left(TBS0591.NFECSTXML,1)+'41'
                      else TBS0591.NFECSTXML
                   end
             end
          else
             -- simples nacional
             case TBS0591.NFEPCRESN
                -- sem permissão de crédido
                when 0 then Left(TBS0591.NFECSTXML,1)+'41'
                else
                   case TBS0591.NFEBASICMSST
                      when 0 then Left(TBS0591.NFECSTXML,1)+'00'
                      else Left(TBS0591.NFECSTXML,1)+'10'
                   end
             end

             /*
             case TBS0591.NFEPCRESN
                -- sem permissão de crédido
                when 0 then Left(TBS0591.NFECSTXML,1)+'41'
                else Left(TBS0591.NFECSTXML,1)+'00'
             end
             */
       end,

       -- CFOP
       rtrim(replace(NFECFOP,'.','')),

       -- VL_BC_ICMS_C170
       case
          -- 3 = regime normal; 2 = simples nacional – excesso de sublimite da receita bruta
          when TBS059.NFEEMIRET in(2,3) then
             case
                -- nf c/ST
                when TBS0591.NFEBASICMSST > 0 then 0   -- zera a BC do ICMS
                -- BC do ICMS da nf
                else TBS0591.NFEBASICMS                -- valor da BC do ICMS
             end
          else
             -- 1 = simples nacional
             case
                -- nf c/ST
                when TBS0591.NFEBASICMSST > 0 then 0   -- zera a BC do ICMS
                else
                   case TBS0591.NFEPCRESN
                      -- sem permissão de crédito
                      when 0 then 0
                      else TBS0591.NFETOTOPEITE        -- utiliza o total do produto
                   end
             end
       end,

       -- ALIQ_ICMS
       case
          -- 3 = regime normal; 2 = simples nacional – excesso de sublimite da receita bruta
          when TBS059.NFEEMIRET in(2,3) then
             case
                -- nf c/ST
                when TBS0591.NFEBASICMSST > 0 then 0   -- zera a aliquota do ICMS
                -- BC do ICMS da nf
                else TBS0591.NFEPERICMS                -- alíquota do ICMS
             end
          else
             -- 1 = simples nacional
             case
                -- nf c/ST
                when TBS0591.NFEBASICMSST > 0 then 0   -- zera a aliquota do ICMS
                else
                   case TBS0591.NFEPCRESN
                      -- sem permissão de crédito
                      when 0 then 0
                      else TBS0591.NFEPCRESN           -- alíquota de crédito da SN
                   end
             end
       end,

       -- VL_ICMS_C170
       case
          -- 3 = regime normal; 2 = simples nacional – excesso de sublimite da receita bruta
          when TBS059.NFEEMIRET in(2,3) then
             case
                -- nf c/ST
                when TBS0591.NFEBASICMSST > 0 then 0   -- zera o valor do ICMS
                -- BC do ICMS da nf
                else TBS0591.NFEVALICMS                -- valor do ICMS
             end
          else
             -- 1 = simples nacional
             case
                -- nf c/ST
                when TBS0591.NFEBASICMSST > 0 then 0   -- zera o valor do ICMS
                else
                   case TBS0591.NFEPCRESN
                      -- sem permissão de crédito
                      when 0 then 0
                      else TBS0591.NFEVCRESN           -- valor do crédito da SN
                   end
             end
       end,
       
       -- 08/03
       /*
       TBS0591.NFEBASICMSST, -- 13
       TBS0591.NFEPERICMSST, -- 14
       TBS0591.NFEVALICMSST, -- 15
       */
       -- VL_BC_ICMS_ST_C170
       0,
       -- ALIQ_ST
       0,
       -- VL_ICMS_ST_C170
       0,

       -- 08/03
       -- VL_BC_IPI
       TBS0591.NFEBASIPI,
       -- ALIQ_IPI
       TBS0591.NFEPERIPI,
       -- VL_IPI_C170
       TBS0591.NFEVALIPI,
       /*
       0, -- 16
       0, -- 17
       0, -- 18
       */

       -- CST_PIS
       case
          -- transferência entre matriz/filial
          when TBS006.FORCGC in('65069593000350','65069593000198','65069593000279') then '49'

          -- por produto
          when TBS010.PROSTBPIS<>'' then Ltrim(rtrim(TBS010.PROSTBPIS))

          -- padrão
          else '50'
       end,

       -- VL_BC_PIS
       TBS0591.NFETOTOPEITE, -- 20 -- TBS0591.NFEVALICMS,

       -- ALIQ_PIS
       case
          -- transferência entre matriz/filial
          when TBS006.FORCGC in('65069593000350','65069593000198','65069593000279') then 0

          -- por produto
          when TBS010.PROSTBPIS<>'' then TBS010.PROPIS

          -- padrão
          else 1.65
       end,

       -- VL_PIS_C170       
       0, -- TBS0591.NFEVALPIS,

       -- CST_COFINS
       case
          -- transferência entre matriz/filial
          when TBS006.FORCGC in('65069593000350','65069593000198','65069593000279') then '49'

          -- por produto
          when TBS010.PROSTBCOFINS<>'' then Ltrim(rtrim(TBS010.PROSTBCOFINS))

          -- padrão
          else '50'
       end,

       -- VL_BC_COFINS
       TBS0591.NFETOTOPEITE, -- 24 - TBS0591.NFEVALICMS,

       -- ALIQ_COFINS
       case
          -- transferência entre matriz/filial
          when TBS006.FORCGC in('65069593000350','65069593000198','65069593000279') then 0

          -- por produto
          when TBS010.PROSTBCOFINS<>'' then TBS010.PROCOFINS

          -- padrão
          else 7.6
       end,

       -- VL_COFINS_C170
       0,

       -- REGISTRO C190: REGISTRO ANALÍTICO DO DOCUMENTO (CÓDIGO 01, 1B, 04, 55 e 65).

       -- REG_C190
       'C190',
       -- VL_RED_BC
       TBS0591.NFEREDBASICMS,

       /* REGISTRO D100: NOTA FISCAL DE SERVIÇO DE TRANSPORTE (CÓDIGO 07) E CONHECIMENTOS DE TRANSPORTE RODOVIÁRIO DE CARGAS (CÓDIGO 08),
                   CONHECIMENTOS DE TRANSPORTE DE CARGAS AVULSO (CÓDIGO 8B), AQUAVIÁRIO DE CARGAS (CÓDIGO 09), AÉREO (CÓDIGO 10), FERROVIÁRIO DE CARGAS (CÓDIGO 11),
                   MULTIMODAL DE CARGAS (CÓDIGO 26), NOTA FISCAL DE TRANSPORTE FERROVIÁRIO DE CARGA (CÓDIGO 27), CONHECIMENTO DE TRANSPORTE ELETRÔNICO – CT-e (CÓDIGO 57) E
                   CONHECIMENTO DE TRANSPORTE ELETRÔNICO PARA OUTROS SERVIÇOS - CT-e OS (CÓDIGO 67) */

       -- REG_D100
       'D100',
       -- CHV_CTE
       '',
       -- DT_A_P
       '17530101',
       -- TP_CT_E
       0,
       -- VL_SERV
       0

  from TBS059 (nolock)
          inner join TBS0591 (nolock) on TBS0591.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0591.SEREMPCOD=TBS059.SEREMPCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
          inner join TBS006 (nolock) on TBS006.FORCOD=TBS059.NFECOD
          inner join TBS010 (nolock) on TBS010.PROCOD=TBS0591.PROCOD
          inner join TBS011 (nolock) on TBS011.UNICOD=TBS010.PROUM1
                     
 where TBS059.NFETIP<>'D' and TBS059.NFEDATEFE between @datai and @dataf and TBS059.NFECAN<>'S'
       and @ent='S'

-- CT-E

union

select -- REG_0150
       '0150',
       -- COD_PART
       rtrim(TBS005.TRNCGC),
       -- NOME
       Ltrim(rtrim(TRNNOM)),
       -- IE
       Ltrim(rtrim(TBS005.TRNIES)),
       -- COD_MUN
       TBS005.TRNMUNCOD,
       -- SUFRAMA
       0,
       -- ENDER
       TBS005.TRNEND,
       -- NUM
       TBS005.TRNNUM,
       -- BAIRRO
       TBS005.TRNBAI,

       -- REG_0190
       '0190',
       -- UNID
       '',
       -- DESCR
       '',

       -- REG_0200
       '0200',
       -- COD_ITEM
       '',
       -- DESCR_ITEM
       '',
       -- COD_NCM
       '',
       -- CEST
       '',

       -- REG_0220
       '0220',
       -- UNID_CONV
       '',
       -- FAT_CONV
       0,
       -- UNI_DESCR
       '',

       -- REG_0400
       '0400',
       -- COD_NAT
       '', 
       -- DESCR_NAT
       '',

       -- REG_C100
       'C100',
       -- IND_OPER
       0,
       -- IND_EMIT
       1,
       -- COD_SIT
       '00',
       -- SER
       TBS130.CTEENTSER,
       -- NUM_DOC
       TBS130.CTEENTNUM,
       -- CHV_NFE
       '',
       -- DT_DOC
       TBS130.CTEENTDATEMI,
       -- DT_E_S
       '17530101',
       -- VL_DOC
       dbo.CTEENTTOTFRE(TBS130.CTEENTEMP, TBS130.CTEENTCHA),
       -- IND_PAGTO
       0,
       -- VL_DESC
       0,
       -- VL_MERC
       0,
       -- IND_FRT
       1,
       -- VL_FRT
       0,
       -- VL_SEG
       0,
       -- VL_OUT_DA
       0,
       -- VL_BC_ICMS
       TBS130.CTEENTBASICM,
       -- VL_ICMS
       dbo.CTEENTVALICM(TBS130.CTEENTEMP, TBS130.CTEENTCHA),
       -- VL_BC_ICMS_ST
       0,
       -- VL_ICMS_ST
       0,
       -- VL_IPI
       0,
       -- VL_PIS
       0,
       -- VL_COFINS
       0,

       -- REGISTRO C113: DOCUMENTO FISCAL REFERENCIADO
       -- REG_C113
       '',
       -- IND_OPER_C113
       0,
       -- COD_PART_C113
       '',
       -- COD_MOD
       '',
       -- SER_C113
       '',
       -- NUM_DOC_C113
       0,
       -- CHV_DOCe
       '',

       -- REGISTRO C113: DOCUMENTO FISCAL REFERENCIADO
       -- REG_C114
       '',
       -- COD_MOD_C114
       '',
       -- ECF_CX
       0,
       -- NUM_DOC_C114
       0,

       -- REGISTRO C170: ITENS DO DOCUMENTO (CÓDIGO 01, 1B, 04 e 55)

       -- REG_C170
       'C170',
       -- NUM_ITEM
       0,
       -- DESCR_COMPL
       '',
       -- QTD
       0,
       -- VL_ITEM
       0,
       -- VL_DESC_C170
       0,
       -- IND_MOV
       '',
       -- CST_ICMS
       '000',
       -- CFOP
       '1353',
       -- VL_BC_ICMS_C170
       0,
       -- ALIQ_ICMS
       TBS130.CTEENTPERICM,
       -- VL_ICMS_C170
       0,
       -- VL_BC_ICMS_ST_C170
       0,
       -- ALIQ_ST
       0,
       -- VL_ICMS_ST_C170
       0,
       -- VL_BC_IPI
       0,
       -- ALIQ_IPI
       0,
       -- VL_IPI_C170
       0,
       -- CST_PIS
       '',
       -- VL_BC_PIS
       0,
       -- ALIQ_PIS
       0,
       -- VL_PIS_C170
       0,
       -- CST_COFINS
       '',
       -- VL_BC_COFINS
       0,
       -- ALIQ_COFINS
       0,
       -- VL_COFINS_C170
       0,

       -- REGISTRO C190: REGISTRO ANALÍTICO DO DOCUMENTO (CÓDIGO 01, 1B, 04, 55 e 65).

       -- REG_C190
       'C190',
       -- VL_RED_BC
       TBS130.CTEENTBASRED,

       /* REGISTRO D100: NOTA FISCAL DE SERVIÇO DE TRANSPORTE (CÓDIGO 07) E CONHECIMENTOS DE TRANSPORTE RODOVIÁRIO DE CARGAS (CÓDIGO 08),
                   CONHECIMENTOS DE TRANSPORTE DE CARGAS AVULSO (CÓDIGO 8B), AQUAVIÁRIO DE CARGAS (CÓDIGO 09), AÉREO (CÓDIGO 10), FERROVIÁRIO DE CARGAS (CÓDIGO 11),
                   MULTIMODAL DE CARGAS (CÓDIGO 26), NOTA FISCAL DE TRANSPORTE FERROVIÁRIO DE CARGA (CÓDIGO 27), CONHECIMENTO DE TRANSPORTE ELETRÔNICO – CT-e (CÓDIGO 57) E
                   CONHECIMENTO DE TRANSPORTE ELETRÔNICO PARA OUTROS SERVIÇOS - CT-e OS (CÓDIGO 67) */

       -- REG_D100
       'D100',
       -- CHV_CTE
       TBS130.CTEENTCHA,
       -- DT_A_P
       (select max(CTEENTDEFDOC) from TBS1301 (nolock) where TBS1301.CTEENTEMP=TBS130.CTEENTEMP and TBS1301.CTEENTCHA=TBS130.CTEENTCHA and TBS1301.CTEENTDEFDOC between @datai and @dataf),
       -- TP_CT_E
       0,
       -- VL_SERV
       dbo.CTEENTTOTFRE(TBS130.CTEENTEMP, TBS130.CTEENTCHA)

  from TBS130 (nolock)
       inner join TBS005 (nolock) on TBS005.TRNCOD=TBS130.TRNCOD
                     
 where --dbo.CTEENTVALICM(TBS130.CTEENTEMP, TBS130.CTEENTCHA) > 0 and
       (select top 1 1 from TBS1301 (nolock)
         where TBS1301.CTEENTEMP=TBS130.CTEENTEMP and TBS1301.CTEENTCHA=TBS130.CTEENTCHA and TBS1301.CTEENTDEFDOC between @datai and @dataf) > 0 --TBS1301.CTEENTDEFDOC between @datai and @dataf) > 0
       and @ent='S'
go

-- CT-E

insert into SPED_ES
select --#DADOS_SPED.SER, #DADOS_SPED.NUM_DOC, #DADOS_SPED.NUM_ITEM, 
* from #DADOS_SPED order by REG_C100, IND_OPER, IND_EMIT, COD_SIT, #DADOS_SPED.SER, #DADOS_SPED.NUM_DOC, #DADOS_SPED.NUM_ITEM
go


-- [2]

-- ajustes

-- itens

update SPED_ES set VL_PIS_C170=round(VL_BC_PIS * ALIQ_PIS /100 ,2), VL_COFINS_C170=round(VL_BC_COFINS * ALIQ_COFINS /100 ,2) where ALIQ_PIS+ALIQ_COFINS > 0

-- cabeçalho

update SPED_ES set VL_PIS=(select sum(VL_PIS_C170) from SPED_ES B (nolock) where B.CHV_NFE=A.CHV_NFE and VL_PIS_C170 > 0),
                   VL_COFINS=(select sum(VL_COFINS_C170) from SPED_ES B (nolock) where B.CHV_NFE=A.CHV_NFE and VL_COFINS_C170 > 0)

  from SPED_ES A (nolock)
 where (VL_PIS_C170 > 0 or VL_COFINS_C170 > 0)

update SPED_ES set VL_BC_PIS=0, VL_BC_COFINS=0 where REG_C170='C170' and ALIQ_PIS + ALIQ_COFINS = 0 and VL_BC_PIS + VL_BC_COFINS > 0

-- entrada

update SPED_ES 
   set CST_ICMS=Left(CST_ICMS,1)+'41',
       VL_BC_ICMS=0,
       VL_ICMS=0,
       VL_BC_ICMS_C170=0,
       ALIQ_ICMS=0,
       VL_ICMS_C170=0,
       VL_PIS=0,
       VL_COFINS=0,
       VL_BC_PIS=0,
       ALIQ_PIS=0,
       VL_PIS_C170=0,
       VL_BC_COFINS=0,
       ALIQ_COFINS=0,
       VL_COFINS_C170=0
 where IND_OPER=0 and right(CFOP,3) in(556,557)

-- saídas: transferência/devolução

update SPED_ES 
   set CST_ICMS=Left(CST_ICMS,1)+'41',
       VL_BC_ICMS=0,
       VL_ICMS=0,
       VL_BC_ICMS_C170=0,
       ALIQ_ICMS=0,
       VL_ICMS_C170=0,
       VL_PIS=0,
       VL_COFINS=0,
       VL_BC_PIS=0,
       ALIQ_PIS=0,
       VL_PIS_C170=0,
       VL_BC_COFINS=0,
       ALIQ_COFINS=0,
       VL_COFINS_C170=0
 where IND_OPER=1 and right(CFOP,3) in(556,557)

update SPED_ES set CST_ICMS=Left(CST_ICMS,1)+'00' where CFOP='1403' and right(CST_ICMS,2) in('40','41') and VL_BC_ICMS > 0

update SPED_ES set CST_ICMS=Left(CST_ICMS,1)+'41' where right(CFOP,3) in('403','409','411') and right(CST_ICMS,2) in('00') and VL_BC_ICMS > 0

update SPED_ES set CST_ICMS=Left(CST_ICMS,1)+'41', VL_BC_ICMS=0, VL_ICMS=0, VL_BC_ICMS_C170=0, ALIQ_ICMS=0, VL_ICMS_C170=0
 where right(CFOP,3) in('403','409','411') and VL_BC_ICMS > 0

-- [3]
-- gera linhas para o arquivo texto

set nocount on

declare @n0990 int, @nC990 int, @n int, @regis int, @chave varchar(44), @nf int, @n0150 int, @n0190 int, @n0220 int, @n0200 int, @n0400 int, @nC100 int, @nC170 int, @nC190 int, @n9900 int,
        @nC113 int, @nC114 int, @operDe smallint, @operAte smallint, @nD100 int, @nD190 int, @nD990 int, @linha varchar(600), @pos smallint, @mes char(2), @ano char(4), @razao varchar(60),
        @cnpj varchar(14), @ie varchar(18), @municipio varchar(7), @cep varchar(8), @ender varchar(60), @numero varchar(60), @bairro varchar(30), @fone varchar(10), @emp smallint

set @mes='03'
set @ano='2019'

-- 0 = entrada, 1 = saida
set @operDe  = 0
set @operAte = 1

set @n0990=4
set @nC990=0
set @nD990=0

set @regis=(select count(*) from SPED_ES (nolock))

set @n=0
set @chave=''
set @nf=0

set @n0150=0
set @n0190=0
set @n0200=0
set @n0400=0
set @nC100=0
set @nC113=0
set @nC114=0
set @nC170=0
set @nC190=0
set @nD100=0
set @nD190=0
set @n9900=0

set @linha=''
set @pos=0

set @emp = 1

select @razao     = rtrim(EMPNOM),
       @cnpj      = rtrim(EMPCGC),
       @ie        = rtrim(EMPIES),
       @municipio = Ltrim(str(EMPMUNCOD,7)),
       @cep       = rtrim(replace(EMPCEP, '-', '')),
       @ender     = rtrim(EMPEND),
       @numero    = rtrim(EMPNUM),
       @bairro    = rtrim(EMPBAI),
       @fone      = rtrim(replace(replace(replace(EMPTEL, '(', ''), ')', '') ,'-' ,''))
  from TBS023 (nolock)
 where EMPCOD = @emp

--select str(day(convert(date,DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, '20171101') + 1, 0)))),2)

drop table #SPED
create table #SPED (registro int, linha varchar(800))

--insert into #SPED select 1,'|0000|011|0|01112017|30112017|TANBY COMERCIO DE PAPEIS LTDA|65069593000198||SP|645160518117|3549904|||A|1|'
--insert into #SPED select 1,'|0000|011|0|01' + @mes + @ano + '|' + (select str(day(convert(date,DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, @ano + @mes + '01') + 1, 0)))),2)) + @mes + @ano + '|TANBY COMERCIO DE PAPEIS LTDA|65069593000198||SP|645160518117|3549904|||A|1|'
insert into #SPED select 1,'|0000|012|0|01' + @mes + @ano + '|' + (select str(day(convert(date,DATEADD(ms, -3, DATEADD(mm, DATEDIFF(mm, 0, @ano + @mes + '01') + 1, 0)))),2)) + @mes + @ano + '|' + @razao + '|' + @cnpj + '||SP|' + @ie + '|' + @municipio + '|||A|1|'

insert into #SPED select 2,'|0001|0|'

-- insert into #SPED select 3,'|0005|TANBY COMERCIO DE PAPEIS LTDA|12245031|AV DR NELSON DAVILA|1202||JD.VALPARAISO|1238787444||mgare@grmcontabil.com.br|'
insert into #SPED select 3,'|0005|' + @razao + '|' + @cep + '|' + @ender + '|' + @numero + '||' + @bairro + '|' + @fone + '||mgare@grmcontabil.com.br|'
insert into #SPED select 4,'|0100|MARGARETE DOS ANJOS CRUZ GARE|10725383852|142509/O-3||02127001|AV ALBERTO BYINGTON|1582||VILA MARIA|1124766208||mgare@grmcontabil.com.br|3550308|'


-- REGISTRO 0150: TABELA DE CADASTRO DO PARTICIPANTE

insert into #SPED
select distinct
       5,
       '|0150|'+ -- 1
       COD_PART+'|'+ -- 2
       Ltrim(rtrim(NOME))+'|'+ -- 3
       '1058|'+ -- 4
       case Len(COD_PART)
          when 14 then COD_PART
          else ''
       end+'|'+ -- 5
       case Len(COD_PART)
          when 11 then COD_PART
          else ''
       end+'|'+ -- 6
       Ltrim(rtrim(IE))+'|'+ -- 7
       Ltrim(str(COD_MUN,7))+'|'+ -- 8
       case SUFRAMA when 0 then '' else Ltrim(str(SUFRAMA,9)) end +'|'+ -- 9
       Ltrim(rtrim(ENDER))+'|'+ -- 10
       case
          when isnumeric(Ltrim(rtrim(NUM)))=1 then Ltrim(rtrim(NUM))
          when isnumeric(subString(Ltrim(replace(replace(replace(replace(replace(replace(replace(NUM,'S/',''),'S/N',''),'KM',''),'N.',''),'Nº',''),'N',''),'-','')),1,charindex(' ',Ltrim(replace(replace(replace(replace(replace(replace(NUM,'S/',''),'S/N',''),'KM',''),'N.',''),'Nº',''),'N','')))))=1
          then Ltrim(rtrim(subString(Ltrim(rtrim(replace(replace(replace(replace(replace(replace(replace(NUM,'S/',''),'S/N',''),'KM',''),'N.',''),'Nº',''),'N',''),'-',''))),1,charindex(' ',Ltrim(rtrim(replace(replace(replace(replace(replace(NUM,'S/',''),'S/N',''),'KM',''),'N',''),'º','')))))))
          else ''
       end+'|'+ -- 11
       case isnumeric(NUM)
          when 0 then Ltrim(rtrim(NUM))
          else ''
       end+'|'+ -- 12
       Ltrim(rtrim(BAIRRO))+'|' -- 13
  from SPED_ES (nolock)
 where REG_0150='0150'
       and IND_OPER between @operDe and @operAte
       and NOME<>''

set @n0150=@@rowcount
set @n0990=@n0990 + @@rowcount


-- REGISTRO 0190: IDENTIFICAÇÃO DAS UNIDADES DE MEDIDA

;with unidades as (
select distinct 
       UNID,
       DESCR
  from SPED_ES (nolock)
 where REG_0190='0190'
       and IND_OPER between @operDe and @operAte

union

select distinct 
       UNID_CONV,
       UNI_DESCR
  from SPED_ES (nolock)
 where REG_0190='0220'
       and IND_OPER between @operDe and @operAte
)

insert into #SPED
select distinct
       6,
       '|0190|'+
       Ltrim(rtrim(UNID))+'|'+
       Ltrim(rtrim(DESCR))+'|'
  from unidades
 where UNID+DESCR<>''

set @n0190=@@rowcount
set @n0990=@n0990 + @@rowcount



-- REGISTRO 0200: TABELA DE IDENTIFICAÇÃO DO ITEM (PRODUTO E SERVIÇOS)

insert into #SPED
select distinct
       7,
       '|0200|'+
       Ltrim(rtrim(COD_ITEM))+'|'+
       Ltrim(rtrim(DESCR_ITEM))+'|'+
       '|'+
       '|'+
       Ltrim(rtrim(UNID))+'|'+
       '00|'+
       case
          when isnumeric(COD_NCM)=1 and Len(COD_NCM)=8 then COD_NCM
          else ''
       end+'|'+
       '|'+
       case
          when isnumeric(COD_NCM)=1 and Len(COD_NCM)=8 then Left(COD_NCM,2)
          else ''
       end+'|'+
       '|'+
       '|'+
       case
          when isnumeric(CEST)=1 and Len(CEST)=7 then CEST
          else ''
       end+'|'       

  from SPED_ES (nolock)
 where REG_0200='0200'
       and IND_OPER between @operDe and @operAte
       and COD_ITEM+DESCR_ITEM<>''

set @n0200=@@rowcount
set @n0990=@n0990 + @@rowcount 


-- REGISTRO 0220: FATORES DE CONVERSÃO DE UNIDADES

insert into #SPED
select distinct
       8,
       '|0220|'+
       Ltrim(rtrim(UNID_CONV))+'|'+
       replace(Ltrim(str(FAT_CONV,12,3)),'.',',')+'|'
  from SPED_ES (nolock)
 where REG_0220='0220' and FAT_CONV > 1
       and IND_OPER between @operDe and @operAte
       and UNID_CONV<>'' and FAT_CONV > 0

set @n0220=@@rowcount
set @n0990=@n0990 + @@rowcount 


-- REGISTRO 0400: TABELA DE NATUREZA DA OPERAÇÃO/PRESTAÇÃO

insert into #SPED
select distinct
       9,
       '|0400|'+
       Ltrim(rtrim(COD_NAT))+'|'+
       Ltrim(rtrim(DESCR_NAT))+'|'
  from SPED_ES (nolock)
 where REG_0400='0400'
       and IND_OPER between @operDe and @operAte
       and COD_NAT+DESCR_NAT <> ''


set @n0400=@@rowcount
set @n0990=@n0990 + @@rowcount 

insert into #SPED select 10, '|0990|' + Ltrim(str(isnull((select count(*)+1 from #SPED (nolock)),0),9)) + '|'

/*
select distinct
       --9,
       --'|0400|'+
       --Ltrim(rtrim(COD_NAT))+'|'+
       --Ltrim(rtrim(DESCR_NAT))+'|'
       NUM_DOC,
       CHV_DOCe
  from SPED_ES (nolock)
 where REG_C113='C113'
       --and COD_SIT='00'
       and IND_OPER=0
       and CHV_DOCe<>''

;with dadosAdic as (select distinct NUM_DOC, CHV_DOCe from SPED_ES (nolock) where REG_0190='0190' and IND_OPER=0 and CHV_DOCe<>'')

insert into #SPED
select distinct
       6,
       '|0190|'+
       Ltrim(rtrim(UNID))+'|'+
       Ltrim(rtrim(DESCR))+'|'
  from unidades

set @n0190=@@rowcount
set @n0990=@n0990 + @@rowcount
*/

--insert into #SPED select 10, '|0990|' + Ltrim(str(@n0990,9)) + '|'


--select '|0990|' + Ltrim(str(@n0990,10)) + '|'


-- REGISTRO C001: ABERTURA DO BLOCO C

insert into #SPED select 11, '|C001|0|'
set @nC990=@@rowcount

while @n <= @regis
   begin

      set @n = (select top 1 REG from SPED_ES (nolock)
                 where REG > @n and CHV_NFE<>@chave and CHV_NFE<>'' and
                       REG_C100='C100' --and  -- registro
                       and IND_OPER between @operDe and @operAte
                 order by REG)

      if @@rowcount = 0 break

      set @chave = isnull((select top 1 CHV_NFE from SPED_ES (nolock) where REG = @n),'')

      set @nf = isnull((select top 1 NUM_DOC from SPED_ES (nolock) where REG = @n),0) --and


      -- C100: NOTA FISCAL (CÓDIGO 01), NOTA FISCAL AVULSA (CÓDIGO 1B), NOTA FISCAL DE PRODUTOR (CÓDIGO 04), NF-e (CÓDIGO 55) e NFC-e (CÓDIGO 65).

      insert into #SPED

      select top 1 -- distinct
             isnull((select max(registro) from #SPED (nolock)),0)+1 as REG,
             '|C100|'+ -- 1
             Ltrim(str(IND_OPER,1))+'|'+ -- 2
             Ltrim(str(IND_EMIT,1))+'|'+ -- 3
             COD_PART+'|'+ -- 4
             '55|'+ -- 5
             COD_SIT+'|'+                                          -- 6 
             Ltrim(str(SER,3))+'|'+                                -- 7
             Ltrim(str(NUM_DOC,9))+'|'+                            -- 8
             Ltrim(rtrim(CHV_NFE))+'|'+                            -- 9
             case DT_DOC
                when '17530101' then ''
                else replace(convert(char(10),DT_DOC,103),'/','')
             end+'|'+     -- 10
             case DT_E_S
                when '17530101' then ''
                else replace(convert(char(10),DT_E_S,103),'/','')
             end+'|'+     -- 11
             replace(Ltrim(str(VL_DOC,12,2)),'.',',')+'|'+         -- 12
             Ltrim(str(IND_PGTO,1))+'|'+                           -- 13
             replace(Ltrim(str(VL_DESC,12,2)),'.',',')+'|'+        -- 14
             '0,00|'+                                              -- 15
             replace(Ltrim(str(VL_MERC,12,2)),'.',',')+'|'+        -- 16
             Ltrim(str(IND_FRT,1))+'|'+                            -- 17

             case VL_FRT
                when 0 then '|'
                else replace(Ltrim(str(VL_FRT,12,2)),'.',',')+'|' --+         -- 18
             end +

             case VL_SEG
                when 0 then '|'
                else replace(Ltrim(str(VL_SEG,12,2)),'.',',')+'|' --+         -- 19
             end +

             '|' +
/*
             case VL_OUT_DA
                when 0 then '|'
                else replace(Ltrim(str(VL_OUT_DA,12,2)),'.',',')+'|' --+      -- 20
             end +
*/

             replace(Ltrim(str(VL_BC_ICMS,12,2)),'.',',')+'|'+     -- 21
             replace(Ltrim(str(VL_ICMS,12,2)),'.',',')+'|'+        -- 22

             case IND_OPER
                when 0 then ''
                else
                   case VL_BC_ICMS_ST
                      when 0 then ''
                      else replace(Ltrim(str(VL_BC_ICMS_ST,12,2)),'.',',') --+'|' --+  -- 23
                   end
             end + '|' +

             case IND_OPER
                when 0 then ''
                else
                   case VL_ICMS_ST
                      when 0 then ''
                      else replace(Ltrim(str(VL_ICMS_ST,12,2)),'.',',') --+'|' --+     -- 24
                    end
             end + '|' +

             -- 07/03
             replace(Ltrim(str(VL_IPI,12,2)),'.',',')+'|'+         -- 25
             --'|'+         -- 25
             replace(Ltrim(str(VL_PIS,12,2)),'.',',')+'|'+         -- 26
             replace(Ltrim(str(VL_COFINS,12,2)),'.',',')+'|'+      -- 27
             --'0,00|'+                                              -- 28
             --'0,00|'                                               -- 29
             '|'+                                              -- 28
             '|'                                               -- 29

        from SPED_ES (nolock)

       where REG=@n and CHV_NFE=@chave and NUM_DOC=@nf and
             REG_C100='C100' --and  -- registro
             and IND_OPER between @operDe and @operAte

             --COD_SIT='00'        -- situação regular
             --and COD_SIT='00'
       --and IND_OPER=0

--      commit tran

      set @nC100=@@rowcount
      set @nC990=@nC990 + @@rowcount


       -- REGISTRO C113: DOCUMENTO FISCAL REFERENCIADO
/*
      insert into #SPED

      select isnull((select max(registro) from #SPED (nolock)),0)+1,
             '|C113|' +                                     -- 1
             '0|' + -- 2
             Ltrim(str(IND_EMIT,1))+'|'+  -- 3
             COD_PART+'|'+ -- 4
             '55|'+                   -- 5
             Ltrim(rtrim(SER_C113))+'|'+                -- 6
             '|'+ -- 7
             Ltrim(str(NUM_DOC_C113,9))+'|'+     -- 8
             '|'+  -- 9
             replace(Ltrim(str(VL_DESC_C170,12,2)),'.',',')+'|'+  -- 8
             Ltrim(str(IND_MOV,1))+'|'+                           -- 9
             Ltrim(rtrim(CHV_DOCe))+'|'                           -- 10

        from SPED_ES (nolock)

       where --REG=@n and
             CHV_NFE=@chave and NUM_DOC=@nf and
             REG_C113='C113' --and --and  -- registro
             and IND_OPER=0 -- somente entradas
       order by NUM_ITEM

      set @nC113=@@rowcount
      set @nC990=@nC990 + @@rowcount 


       -- REGISTRO C114: CUPOM FISCAL REFERENCIADO

      insert into #SPED

      select isnull((select max(registro) from #SPED (nolock)),0)+1,
             '|C114|' +                                     -- 1
             Ltrim(rtrim(COD_MOD_C114))+'|' + -- 2
             '|'+  -- 3
             Ltrim(str(ECF_CX,3))+'|'+ -- 4
             Ltrim(str(NUM_DOC_C114,9))+'|'+ -- 5
             '|'                   -- 6

        from SPED_ES (nolock)

       where --REG=@n and
             CHV_NFE=@chave and NUM_DOC=@nf and
             REG_C113='C114' --and --and  -- registro
             and IND_OPER=0 -- somente entradas
       order by NUM_ITEM

      set @nC114=@@rowcount
      set @nC990=@nC990 + @@rowcount 
*/


      -- REGISTRO C170: ITENS DO DOCUMENTO (CÓDIGO 01, 1B, 04 e 55)
   
--      begin tran
      insert into #SPED

      select --distinct
             isnull((select max(registro) from #SPED (nolock)),0)+1,
             --Ltrim(str(REG,7))+'|'+
             --CHV_NFE+'|'+                                          -- 9

             '|C170|'+                                     -- 1
             --right('000' + Ltrim(str(NUM_ITEM,4)),4)+'|'+  -- 2
             Ltrim(str(NUM_ITEM,3))+'|'+  -- 2
             Ltrim(rtrim(COD_ITEM))+'|'+                   -- 3
             Ltrim(rtrim(DESCR_COMPL))+'|'+                -- 4
             replace(Ltrim(str(QTD,10,5)),'.',',')+'|'+    -- 5
             UNID_CONV+'|'+                                -- 6
             --replace(Ltrim(str(VL_ITEM + VL_IPI_C170,12,2)),'.',',')+'|'+  -- 7
             replace(Ltrim(str(VL_ITEM,12,2)),'.',',')+'|'+  -- 7
             replace(Ltrim(str(VL_DESC_C170,12,2)),'.',',')+'|'+  -- 8
             Ltrim(str(IND_MOV,1))+'|'+                           -- 9
             CST_ICMS+'|'+                                        -- 10
             CFOP+'|'+                                            -- 11
             Ltrim(rtrim(COD_NAT))+'|'+                           -- 12
             replace(Ltrim(str(VL_BC_ICMS_C170,12,2)),'.',',')+'|'+  -- 13
             replace(Ltrim(str(ALIQ_ICMS,6,2)),'.',',')+'|'+         -- 14
             replace(Ltrim(str(VL_ICMS_C170,12,2)),'.',',')+'|'+     -- 15

             case IND_OPER
                when 0 then '|'
                else
                   case VL_BC_ICMS_ST_C170
                      when 0 then '|'
                      else replace(Ltrim(str(VL_BC_ICMS_ST_C170,12,2)),'.',',') +'|' --+  -- 16
                   end
             end +

             case IND_OPER
                when 0 then '|'
                else
                   case ALIQ_ST
                      when 0 then '|'
                      else replace(Ltrim(str(ALIQ_ST,6,2)),'.',',') +'|' --+              -- 17
                   end
             end +

             case IND_OPER
                when 0 then '|'
                else
                   case VL_ICMS_ST_C170
                      when 0 then '|'
                      else replace(Ltrim(str(VL_ICMS_ST_C170,12,2)),'.',',') +'|' --+     -- 18
                   end
             end +

             '0|'+                                                      -- 19
             '49|'+                                                     -- 20
             '|'+                                                       -- 21
             -- 07/03
             replace(Ltrim(str(VL_BC_IPI,12,2)),'.',',')+'|'+           -- 22
             --'|'+           -- 22
             replace(Ltrim(str(ALIQ_IPI,6,2)),'.',',')+'|'+             -- 23
             --'|'+             -- 23
             replace(Ltrim(str(VL_IPI_C170,6,2)),'.',',')+'|'+          -- 24
             --'|'+          -- 24
             CST_PIS+'|'+                                               -- 25
             replace(Ltrim(str(VL_BC_PIS,12,2)),'.',',')+'|'+           -- 26
             replace(Ltrim(str(ALIQ_PIS,6,2)),'.',',')+'|'+             -- 27
             '0|'+                                                      -- 28
             '0|'+                                                      -- 29
             replace(Ltrim(str(VL_PIS_C170,12,2)),'.',',')+'|'+                      -- 30
             CST_COFINS+'|'+                                                         -- 31
             replace(Ltrim(str(VL_BC_COFINS,12,2)),'.',',')+'|'+                     -- 32
             replace(Ltrim(str(ALIQ_COFINS,6,2)),'.',',')+'|'+                       -- 33
             '0|'+                                                                   -- 34
             '0|'+                                                                   -- 35
             replace(Ltrim(str(VL_COFINS_C170,12,2)),'.',',')+'|'+                   -- 36
             '|'

        from SPED_ES (nolock)

       where --REG=@n and
             CHV_NFE=@chave and NUM_DOC=@nf and
             REG_C170='C170' --and --and  -- registro
             and IND_OPER between @operDe and @operAte

             --and IND_OPER=0
       order by NUM_ITEM

      set @nC170=@@rowcount
      set @nC990=@nC990 + @@rowcount 

       -- REGISTRO C190: REGISTRO ANALÍTICO DO DOCUMENTO (CÓDIGO 01, 1B, 04, 55 e 65)

      insert into #SPED
      select --distinct
             isnull((select max(registro) from #SPED (nolock)),0)+1,
             '|C190|'+                                                        -- 1
             CST_ICMS+'|'+                                                    -- 2
             CFOP+'|'+                                                        -- 3
             replace(Ltrim(str(ALIQ_ICMS,6,2)),'.',',')+'|'+                  -- 4
             replace(Ltrim(str(sum(VL_ITEM),12,2)),'.',',')+'|'+              -- 5
             replace(Ltrim(str(sum(VL_BC_ICMS_C170),12,2)),'.',',')+'|'+      -- 6
             replace(Ltrim(str(sum(VL_ICMS_C170),12,2)),'.',',')+'|'+         -- 7
             --replace(Ltrim(str(sum(VL_BC_ICMS_ST_C170),12,2)),'.',',')+'|'+   -- 8
             '0|'+                                                               -- 8
             --replace(Ltrim(str(sum(VL_ICMS_ST_C170),12,2)),'.',',')+'|'+      -- 9
             '0|'+                                                             --9
             replace(Ltrim(str(sum(VL_RED_BC),12,2)),'.',',')+'|'+            -- 10
             --replace(Ltrim(str(sum(VL_IPI_C170),12,2)),'.',',')+'|'+          -- 11
             '0|'+          -- 11
             '|'                                                              -- 12

        from SPED_ES (nolock) 
       where CHV_NFE=@chave and NUM_DOC=@nf and
             REG_C170='C170' --and
             and IND_OPER between @operDe and @operAte
 
        --and IND_OPER=0
       group by CST_ICMS, CFOP, ALIQ_ICMS

      set @nC190=@@rowcount
      set @nC990=@nC990 + @@rowcount 

--      commit tran

   end

--insert into #SPED select isnull((select max(registro) from #SPED (nolock)),0)+1, '|C990|0|'
--insert into #SPED select isnull((select max(registro) from #SPED (nolock)),0)+1, '|C990|' + Ltrim(str(@nC990+4,9)) + '|'

insert into #SPED select isnull((select max(registro) from #SPED (nolock)),0)+1, '|C990|' + Ltrim(str(isnull((select count(*)+1 from #SPED (nolock) where subString(linha,1,6) Like('|C%')),0),9)) + '|'

-- REGISTRO D001: ABERTURA DO BLOCO D

-- se houver registro D100
select top 1 * from SPED_ES (nolock) where REG_D100='D100' and CHV_CTE<>''

if @@rowcount > 0
   begin
      insert into #SPED select isnull((select max(registro) from #SPED (nolock)),0)+1, '|D001|0|'
      set @nD990=@@rowcount

      -- novo
      --declare @n int, @regis int

      -- o primeiro e o último registro D100
      select @n=min(REG), @regis=max(REG) from SPED_ES where REG_D100='D100' and CHV_CTE<>''

      --select @n, @regis

      --select * from SPED_ES

      while @n <= @regis
         begin
-- novo

--if @@rowcount > 0
--   begin

            select @linha = 
                   '|D100|'+                                     -- 1
                   Ltrim(str(IND_OPER,1))+'|'+ -- 2
                   Ltrim(str(IND_EMIT,1))+'|'+ -- 3
                   COD_PART+'|'+ -- 4
                   '57|'+ -- 5
                   COD_SIT+'|'+                                          -- 6 
                   Ltrim(str(SER,3))+'|'+                                -- 7
                   '|'+                                                  -- 8
                   Ltrim(str(NUM_DOC,9))+'|'+                            -- 9
                   Ltrim(rtrim(CHV_CTE))+'|'+                            -- 10
                   case DT_DOC
                      when '17530101' then ''
                      else replace(convert(char(10),DT_DOC,103),'/','')
                   end+'|'+     -- 11
                   case DT_A_P
                      when '17530101' then ''
                      else replace(convert(char(10),DT_A_P,103),'/','')
                   end+'|'+     -- 12
                   Ltrim(str(TP_CT_E,1))+'|'+                           -- 13
                  '|'+                                                  -- 14
                  replace(Ltrim(str(VL_DOC,12,2)),'.',',')+'|'+         -- 15
                  replace(Ltrim(str(VL_DESC,12,2)),'.',',')+'|'+        -- 16
                  Ltrim(str(IND_FRT,1))+'|'+                            -- 17
                  replace(Ltrim(str(VL_SERV,12,2)),'.',',')+'|'+        -- 18
                  replace(Ltrim(str(VL_BC_ICMS,12,2)),'.',',')+'|'+     -- 19
                  replace(Ltrim(str(VL_ICMS,12,2)),'.',',')+'|'+        -- 20
                  '|'+                                                  -- 21
                  '|'+                                                  -- 22
                  '|'+                                                  -- 23
 
                  '#'+ -- separador

                  '|D190|'+                                     -- 1
                  CST_ICMS+'|'+                                 -- 2
                  CFOP+'|'+                                                        -- 3
                  replace(Ltrim(str(ALIQ_ICMS,6,2)),'.',',')+'|'+                  -- 4
                  replace(Ltrim(str(VL_BC_ICMS,12,2)),'.',',')+'|'+           -- 5
                  replace(Ltrim(str(VL_BC_ICMS,12,2)),'.',',')+'|'+           -- 6
                  replace(Ltrim(str(VL_ICMS,12,2)),'.',',')+'|'+              -- 7
                  replace(Ltrim(str(VL_RED_BC,12,2)),'.',',')+'|'+            -- 8
                  '|'                                                              -- 9

             from SPED_ES (nolock)

            where REG=@n and
                  REG_D100='D100' and CHV_CTE<>''
                  and IND_OPER between @operDe and @operAte
            order by CHV_CTE

            if @@rowcount > 0
               begin
            set @pos = (select charIndex('#', @linha))

            insert into #SPED select isnull((select max(registro) from #SPED (nolock)),0)+1, subString(@linha, 1, @pos-1)
            insert into #SPED select isnull((select max(registro) from #SPED (nolock)),0)+1, subString(@linha, @pos+1, Len(@linha))

            set @nD100=@@rowcount
            set @nD990=@nD990 + @@rowcount 
               end

           set @n = @n + 1
         end

           insert into #SPED select isnull((select max(registro) from #SPED (nolock)),0)+1, '|D990|' + Ltrim(str(isnull((select count(*)+1 from #SPED (nolock) where subString(linha,1,6) Like('|D%')),0),9)) + '|'

   end

else
   begin
      insert into #SPED select 999999999, '|D001|1|'
      insert into #SPED select 999999999, '|D990|2|'
   end

insert into #SPED select 999999999, '|E001|1|'
insert into #SPED select 999999999, '|E990|2|'
insert into #SPED select 999999999, '|G001|1|'
insert into #SPED select 999999999, '|G990|2|'
insert into #SPED select 999999999, '|H001|1|'
insert into #SPED select 999999999, '|H990|2|'
insert into #SPED select 999999999, '|K001|1|'
insert into #SPED select 999999999, '|K990|2|'
insert into #SPED select 999999999, '|1001|0|'
insert into #SPED select 999999999, '|1010|N|N|N|N|N|N|N|N|N|'
insert into #SPED select 999999999, '|1990|3|'

-- REGISTRO 9001: ABERTURA DO BLOCO 9
insert into #SPED select 999999999, '|9001|0|'
set @n9900=@@rowcount

-- REGISTRO 9900: REGISTROS DO ARQUIVO (contadores indivíduais dos registros do arquivo)
insert into #SPED select 999999999, '|9900|0000|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|0001|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|0005|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|0100|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|0150|' + Ltrim(str(@n0150,9)) + '|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|0190|' + Ltrim(str(@n0190,9)) + '|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|0200|' + Ltrim(str(@n0200,9)) + '|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|0220|' + Ltrim(str(@n0220,9)) + '|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|0400|' + Ltrim(str(@n0400,9)) + '|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|0990|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|1001|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|1010|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|1990|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|C001|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|C100|' + Ltrim(str(isnull((select count(*) from #SPED (nolock) where subString(linha,1,6)='|C100|'),0),9)) + '|'
set @n9900=@n9900 + @@rowcount

-- C101 ???
/*
insert into #SPED select 999999999, '|9900|C113|' + Ltrim(str(isnull((select count(*) from #SPED (nolock) where subString(linha,1,6)='|C113|'),0),9)) + '|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|C114|' + Ltrim(str(isnull((select count(*) from #SPED (nolock) where subString(linha,1,6)='|C114|'),0),9)) + '|'
set @n9900=@n9900 + @@rowcount
*/

insert into #SPED select 999999999, '|9900|C170|' + Ltrim(str(isnull((select count(*) from #SPED (nolock) where subString(linha,1,6)='|C170|'),0),9)) + '|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|C190|' + Ltrim(str(isnull((select count(*) from #SPED (nolock) where subString(linha,1,6)='|C190|'),0),9)) + '|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|C990|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|D001|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|D100|' + Ltrim(str(isnull((select count(*) from #SPED (nolock) where subString(linha,1,6)='|D100|'),0),9)) + '|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|D190|' + Ltrim(str(isnull((select count(*) from #SPED (nolock) where subString(linha,1,6)='|D190|'),0),9)) + '|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|D990|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|E001|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|E990|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|G001|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|G990|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|H001|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|H990|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|K001|1|'
set @n9900=@n9900 + @@rowcount

insert into #SPED select 999999999, '|9900|K990|1|'
set @n9900=@n9900 + @@rowcount

-- BLOCO 9: CONTROLE E ENCERRAMENTO DO ARQUIVO DIGITAL

-- REGISTRO 9001: ABERTURA DO BLOCO 9
insert into #SPED select 999999999, '|9900|9001|1|'
set @n9900=@n9900 + @@rowcount + 2

insert into #SPED select 999999999, '|9900|9900|'  + Ltrim(str(@n9900,9)) + '|'
insert into #SPED select 999999999, '|9900|9990|1|'

-- REGISTRO 9990: ENCERRAMENTO DO BLOCO 9

insert into #SPED select 999999999, '|9900|9999|1|'
set @n9900=@n9900 + @@rowcount + 2

insert into #SPED select 999999999, '|9990|'  + Ltrim(str(@n9900,9)) + '|'

insert into #SPED select 999999999, '|9999|'  + Ltrim(str(isnull((select count(*)+1 from #SPED (nolock)),0),9)) + '|'


select linha from #SPED order by registro --subString(linha,1,4)
