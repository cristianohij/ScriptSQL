-- CNpj ou CPF, Codigo, nome, nota fiscal ou numero documento, data emissão, data vencimento, valor. 

-- contas a receber

select case TBS002.CLITIPPES when 'J' then CLICGC else CLICPF end CNPJ_CPF,
       TBS056.CLICOD codigo,
       TBS002.CLINOM nome,
       TBS056.CRETIT titulo,
       TBS056.CREDATEMI emissao,
       TBS056.CREDATVENREA vencimento,
       TBS056.CREVAL valor
  from TBS056 (nolock)
       inner join TBS002 (nolock) on TBS002.CLICOD=TBS056.CLICOD

-- contas a pagar
select case TBS006.FORTIPPES when 'J' then FORCGC else FORCPF end CNPJ_CPF,
       TBS057.FORCOD codigo,
       TBS006.FORNOM nome,
       TBS057.CPATIT titulo,
       TBS057.CPADATEMI emissao,
       dbo.CPADATVENREA(0,0,0,TBS057.PFXCOD,TBS057.CPATIT,TBS057.CPAPAR,TBS057.FORCOD),
--       TBS057.CREDATVENREA vencimento,
       TBS057.CPAVAL valor
  from TBS057 (nolock)
       inner join TBS006 (nolock) on TBS006.FORCOD=TBS057.FORCOD
