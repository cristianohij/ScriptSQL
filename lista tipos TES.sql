select F4_CODIGO,
       F4_TIPO,
       F4_TEXTO,
       F4_PYTEXTO,
       F4_ICM,		-- calcula ICMS
       F4_IPI,		-- calcula IPI
       F4_CREDICM,
       F4_CREDIPI,
       F4_DUPLIC,
       F4_ESTOQUE,
       F4_CFNOVO,
       F4_BASEICM,	-- reducao ICMS
       F4_BASEIPI,	-- reducao IPI
       F4_PODER3,	-- poder terceiros
       F4_LFICM,	-- livro fiscal ICMS
       F4_LFIPI,	-- livro fiscal IPI
       F4_DESTACA,	-- destaca IPI
       F4_INCIDE,	-- IPI na base
       F4_COMPL,	-- complemento ICMS
       F4_IPIFRET,	-- IPI no frete
       F4_ISS,		-- incide ISS
       F4_LFISS,	-- livro fiscal ISS
       F4_NRLIVRO,	-- numero livro fiscal
       F4_UPRC,		-- atualiza preco compra
       F4_CONSUMO,	-- material consumo
       F4_FORMULA,	-- formula
       F4_AGREG,	-- incorpora
       F4_INCSOL,	-- 
       F4_CIAP,		-- controla CIAP
       F4_DESPIPI,
       F4_LIVRO,
       F4_ATUTEC,
       F4_ATUATF,
       F4_TPIPI
       F4_SITTRIB,
       F4_PYPRCUS,
       F4_PISCOF
 from SF4010 where D_E_L_E_T_=''