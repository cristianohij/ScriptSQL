declare
                @data datetime
set @data = '20190901'
;with
                dados_nfe as (
                               select
                                               a.NFENUM, --NUMERO NF-E
                                               NFENOM, --NOME FORNECEDOR
                                               NFEESTORI, --UF
                                               replace(replace(replace(FORREGTRI, '1', 'Simples Nacional'), '2', 'Simples Nacional – Excesso de Sublimite da Receita Bruta'), '3', 'Regime Normal') CRTCOD, --CRT
                                               PROCOD, --CODIGO
                                               NFEDES, --DESCRICAO
                                               NFECSTXML, --CST XML
                                               sum(NFEQTD * NFEQTDEMB) QTDEENT, --QTDE ENTRADA
                                               NFEQTDXML, --QTDE XML
                                               NFEPREXML, --PRECO XML
                                               (NFEQTDXML * NFEPREXML) + NFEVALFREITEXML + NFEVALSEGITEXML - NFEVALDESITEXML + NFEVALOUTITEXML NFEPRETOTXML, --PRECO TOTAL XML
                                               NFEVALFREITEXML, --FRETE XML
                                               NFEVALSEGITEXML, --SEGURO XML
                                               NFEVALDESITEXML, --DESCONTO XML
                                               NFEVALOUTITEXML, --OUTRAS DESPESAS ACESSORIAS XML
                                               NFEVALIPIXML, --IPI XML
                                               NFEVALICMSSTXML, --ICMS ST XML
                                               NFEVALFREITECTE, --FRETE CTE
                                               NFEGAREICMSST, --ICMS ST GARE
                                               NFEVALICMSXML, --VALOR ICMS
                                               case when NFEESTORI <> 'SP' then (100/((100-(18-NFEPERICMSXML))/100))-100 else 0 end DIFICMS_INTERESTADUAL, --DIFERENÇA DE ICMS INTERESTADUAL
                                               case when FORREGTRI = '1' and (right(rtrim(NFECSTXML),3) = '101' or right(rtrim(NFECSTXML),3) = '102') then '21.9500' else '0' end DIFICMS_SIMPLESNACIONAL --DIFERENÇA DE ICMS SIMPLES NACIONAL
                               from
                                               TBS059 a join
                                               TBS0591 b on a.NFETIP = b.NFETIP and a.NFENUM = b.NFENUM and a.NFECOD = b.NFECOD and a.SERCOD = b.SERCOD join
                                               TBS006 c on FORCOD = a.NFECOD
                               where
                                               TPTCOD <> 'NFD' and
                                               NFECAN <> 'S' and
                                               FORCGC not like '%05118717%' and
                                               FORCGC not like '%52080207%' and
                                               FORCGC not like '%44125185%' and
                                               FORCGC not like '%65069593%' and
                                               NFEDATEFE > @data
                               group by
                                               a.NFENUM,
                                               NFENOM,
                                               NFEESTORI,
                                               FORREGTRI,
                                               PROCOD,
                                               NFEDES,
                                               NFEQTDXML,
                                               NFEPREXML,
                                               NFEVALFREITEXML,
                                               NFEVALSEGITEXML,
                                               NFEVALDESITEXML,
                                               NFEVALOUTITEXML,
                                               NFEVALIPIXML,
                                               NFEVALICMSSTXML,
                                               NFEVALFREITECTE,
                                               NFEGAREICMSST,
                                               NFEPERICMSXML,
                                               NFEVALICMSXML,
                                               NFECSTXML)
select
                NFENUM,
                NFENOM,
                NFEESTORI,
                CRTCOD,
                PROCOD,
                NFEDES,
                NFECSTXML,
                QTDEENT,
                NFEQTDXML,
                NFEPREXML,
                NFEPRETOTXML,
                NFEVALSEGITEXML,
                NFEVALDESITEXML,
                NFEVALOUTITEXML,
                ' ' '-',
                -- Frete
                convert(money,100*((NFEVALFREITEXML + NFEVALFREITECTE)/NFEPRETOTXML)) Frete_NFe,
                PDPFRE Frete_PDP,
                ' ' '-',
                -- IPI
                convert(money,round(100*NFEVALIPIXML/NFEPRETOTXML,1)) IPI_NFe,
                PDPIPI IPI_PDP,
                ' ' '-',
                NFEVALICMSSTXML, NFEGAREICMSST, PDPPORST,
                ' ' '-',
                -- Diferença de ICMS
                convert(money,round(100*NFEVALICMSXML/NFEPRETOTXML,1)) ICMS,
                convert(money,DIFICMS_INTERESTADUAL + DIFICMS_SIMPLESNACIONAL) Dif_ICMS_NFe,
                PDPDIFICM Dif_ICMS_PDP
from
                dados_nfe a left join
                TBS015 b on a.PROCOD = b.PDPCOD
where
	NFENOM like '%KAZ%'