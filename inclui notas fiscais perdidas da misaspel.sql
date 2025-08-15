-- cabecalho da nota
insert into TBS067 (
       NFSNUM,			-- numero da nota
       NFSDATEMI,		-- data da emissao
       NFSUSUGER,		-- usuario que gerou a nf
       NFSCAN,			-- se nf cancelada
       NFSDEV,			-- se nf devolvida
       SERCOD,			-- serie da nf
       NFSCLICOD,		-- codigo do cliente]
       NFSCLINOM,		-- nome do cliente
       NFSREQCOD,		-- codigo do requisitante
       NFSREQNOM,		-- nome do requisitante
       VENCOD,			-- codigo do vendedor
       NFSVENCOM,		-- se vendedor comissionado
       NFSVENPDC,		-- comissao por vendedor
       UFESIG,			-- estado destino
       CPGCOD,			-- condicao de pagto
       NFSCPGDUP,		-- se TES gera duplicata
       TRNCOD,			-- transportadora
       NFSTIPFRE,		-- tipo de frete
       NFSDESICMS,		-- desconta icms
       NFSREQCDC,		-- centro de custo
       NFSPEDCLI,		-- pedido do cliente
       NFSVALFRE,		-- valor do frete
       NFSVALSEG,		-- valor do seguro
       NFSVALDES,		-- valor de outras despesas
       NFSTIP,			-- tipo da nf
       NFSPESBRU,		-- peso bruto
       NFSPESLIQ,		-- peso liquido
       NFSVOLQTD,		-- quantidade de volumes
       NFSVOLESP,		-- especie volume
       NFSVOLMAR,		-- marca do volume
       NFSVOLNUM,		-- numero volume
       NFSPDDTOT		-- desconto
)
select convert(int ,subString(ORCOBS,1,6)),
--       convert(datetime ,cast(subString(ORCOBS,8,8) as datetime) ,20),
       case subString(ORCOBS,8,8)
          when '02/05/09' then cast('02/05/09' as datetime)
          else cast('03/05/09' as datetime)
       end,
       '03/06/09 00:00:00 VIA SCRIPT SQL',
       'N',
       'N',
       'UNI',
       ORCCLI,
       ORCNOM,
       ORCREQCOD,
       ORCREQNOM,
       VENCOD,
       ORCVENCOM,
       ORCVENPDC,
       ORCESTDES,
       CPGCOD,
       ORCCPGDUP,
       TRNCOD,
       ORCTIPFRE,
       ORCDESICMS,
       ORCREQCDC,
       ORCPEDCLI,
       ORCVALFRE,
       ORCVALSEG,
       ORCVALDES,
       'N',
       ORCPESBRU,
       ORCPESLIQ,
       ORCVOLQTD,
       ORCVOLESP,
       ORCVOLMAR,
       ORCVOLNUM,
       ORCPDDTOT
  from TBS043
 where ORCNUM=35461
(4733,
4738,
4739,
4740,
4741,
4742,
4743,
4744,
4745,
4746,
4747,
4748,
4749,
4750,
4752,
4758,
4760,
4761,
4769,
4770,
4771,
4772,
4773,
4775,
4776,
4778,
4794,
4780,
4781,
4782,
4783,
4784,
4785,
4788,
4789,
4790,
4791,
4792,
4793,
4795,
4796,
4797,
4798,
4800,
4801,
4802,
4803,
4805,
4806,
4807,
4808,
4809,
4810,
4811,
4813,
4814,
4815,
4816,
4817,
4818,
4819,
4820,
4823,
4824,
4825,
4826)

-- itens da nota
insert into TBS0671 (
       NFSNUM,			-- numero da nota
       NFSITE,			-- numero do item
       PROCOD,			-- codigo do produto
       NFSPRODES,		-- descricao do produto
       NFSQTD,			-- quantidade
       NFSUNI,			-- unidade de medida
       NFSQTDEMB,		-- quantidade da embalagem
       NFSPRE,			-- preco
       NFSPDDITE,		-- desconto por item
       LESCOD,			-- local estoque
       TESCOD,			-- TES
       NFSMOVEST,		-- se movimenta o estoque
       NFSTESCOM,		-- se TES comissionado
       NFSTESDPL,		-- se TES gera duplicata
       NFSPBI,			-- percentual base para calculo do ICMS
       NFSPERICMS,		-- percentual do ICMS
       NFSCST,			-- codigo da situacao tributaria
       NFSEFS,			-- excecao fiscal
       NFSCFOP,			-- CFOP
       NFSPRECUS,		-- preco do custo
       NFSPERCOM		-- percentual da comissao
)
select convert(int ,subString(ORCOBS,1,6)),
       ORCITEM,
       PROCOD,
       ORCDES,
       ORCQTD,
       ORCUNI,
       ORCQTDEMB,
       ORCPRE,
       ORCPDDITE,
       LESCOD,
       TESCOD,
       'N',
       ORCTESCOM,
       ORCTESDPL,
       ORCPBI,
       ORCPERICMS,
       ORCCST,
       ORCEFS,
       ORCCFOP,
       ORCPRECUS,
       ORCPERCOM
  from TBS043 join TBS0431 on TBS043.ORCNUM=TBS0431.ORCNUM
 where TBS043.ORCNUM in
(4733,
4738,
4739,
4740,
4741,
4742,
4743,
4744,
4745,
4746,
4747,
4748,
4749,
4750,
4752,
4758,
4760,
4761,
4769,
4770,
4771,
4772,
4773,
4775,
4776,
4778,
4794,
4780,
4781,
4782,
4783,
4784,
4785,
4788,
4789,
4790,
4791,
4792,
4793,
4795,
4796,
4797,
4798,
4800,
4801,
4802,
4803,
4805,
4806,
4807,
4808,
4809,
4810,
4811,
4813,
4814,
4815,
4816,
4817,
4818,
4819,
4820,
4823,
4824,
4825,
4826)



select top 1 * from TBS067 where NFSNUM=123456
select top 1 * from TBS043

select top 1 * from TBS0671

print convert(datetime ,cast('03/06/09' as datetime) ,20)
print cast('03/06/09' as datetime)
print convert(datetime ,getdate() ,20)
print convert(datetime ,'03/06/09' ,20)

update TBS067 set NFSDATEMI=convert(datetime ,getdate() ,20) where NFSNUM=75841

