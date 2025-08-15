select CSTCOD codigo,
       CSTDES descricao,
       CSTICMS calcula_ICMS,
       CSTBASRED tem_reducao_base,
       CSTICMSST com_ICMS_ST
  from TBS039 (nolock)
 where CSTTAB='B'

select RFETIPOPE tipo_operacao, RFESUBTIPOPE subtipo_operacao, RFESUBTRIB subst_tributaria, RFECFOP CFOP from TBS122 (nolock) order by RFETIPOPE, RFESUBTIPOPE
