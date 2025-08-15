-- clientes

select CLICOD as codigo,
       CLINOM as nome,
       CLITIPPES as 'tipo de pessoa',
       CLICGC as CNPJ,
       CLICPF as CPF,
       UFESIG as UF,
       CLIIES as 'inscricao estadual',
       CLISUFRAMA as suframa,
       CLICONTAT as contato,
       CLITEL as fone1,
       CLITEL2 as fone2,
       CLITEL3 as fone3,
       CLIFAX as fax,
       CLIEND as endereco,
       CLINUM as numero,
       CLIBAI as bairro,
       isnull((select MUNNOM from TBS003 (nolock) where TBS003.MUNCOD=TBS002.MUNCOD),'') as municipio,
       CLICEP as CEP,
       CLIEMAIL as 'e-mail',
       isnull((select VENNOM from TBS004 (nolock) where TBS004.VENCOD=TBS002.VENCOD),0) as vendedor,
       isnull((select CPGDES from TBS008 (nolock) where TBS008.CPGCOD=TBS002.CPGCOD),'') as 'condicao de pagto'
  from TBS002 (nolock)


-- fornecedores

select FORCOD as codigo,
       FORNOM as nome,
       FORTIPPES as 'tipo de pessoa',
       FORCGC as CNPJ,
       FORCPF as CPF,
       UFESIG as UF,
       FORIES as 'inscricao estadual',
       FORCONTAT as contato,
       FORTEL as fone,
       FORFAX as fax,
       FOREND as endereco,
       FORNUM as numero,
       FORBAI as bairro,
       isnull((select MUNNOM from TBS003 (nolock) where TBS003.MUNCOD=TBS006.MUNCOD),'') as municipio,
       FORCEP as CEP,
       FOREMAIL as 'e-mail'
  from TBS006 (nolock)


-- produtos

select PROCOD as codigo,
       PRODES as descricao,
       PROSTATUS as status,
       isnull((select FORNOM from TBS006 (nolock) where TBS006.FORCOD=TBS010.FORCOD),'') as fornecedor,
       isnull((select MARNOM from TBS014 (nolock) where TBS014.MARCOD=TBS010.MARCOD),'') as marca,
       PROUM1 as unidade,
       PROPESLIQ as 'peso liquido',
       PROPESBRU as 'peso bruto',
       PROCLAFIS as NCM,
       PROSTBA+PROSTBB as 'CST-ICMS',
       case when PROSTBPIS='' then '01' else PROSTBPIS end as 'CST-PIS',
       case when PROSTBCOFINS='' then '01' else PROSTBPIS end as 'CST-COFINS'
  from TBS010 (nolock)

