-- clientes

-- altera o codigo do municipio para 0 (zero) caso o atributo esteja com o valor null
update TBS002 set MUNCOD=0 where MUNCOD is null

-- lista as cidades do cadastro de clientes
select distinct CLICID from TBS002 where MUNCOD = 0 order by CLICID

-- remove espacos em branco do inicio do nome da cidade
update TBS002 set CLICID=Ltrim(CLICID)

-- grava codigo do municipio caso encontre a cidade cadastrada na tabela de municipios
update TBS002 set MUNCOD=TBS003.MUNCOD from TBS002 join TBS003 on CLICID=MUNNOM

-- lista as cidades nao identificadas no cadastro de clientes
select CLICID,MUNCOD,* from TBS002 (noLock) where MUNCOD=0 order by CLICID

-- se houver cliente com o atributo numero igual a null
select * from TBS002 where CLINUM is null
update TBS002 set CLINUM='' where CLINUM is null

-- separacao do numero do logradouro do cliente
-- extrai o numero
select CLIEND,
       charindex(',',CLIEND),
       substring(CLIEND,charindex(',',CLIEND)+1,60)
  from TBS002 (noLock)
 where charindex(',',CLIEND) > 0

update TBS002 set CLINUM=substring(CLIEND,charindex(',',CLIEND)+1,60) where charindex(',',CLIEND) > 0

update TBS002 set CLINUM=Ltrim(CLINUM)

select CLIEND,CLINUM from TBS002 (noLock)

-- se houver cliente com o atributo endereco temporario igual a null
select * from TBS002 where CLIENDTMP is null
update TBS002 set CLIENDTMP='' where CLIENDTMP is null

-- separacao do logradouro do numero do cliente
-- extrai o endereco
select CLIEND,
       charindex(',',CLIEND),
       substring(CLIEND,1,charindex(',',CLIEND)-1)
  from TBS002 (noLock)
 where charindex(',',CLIEND) > 0

   -- extrai o endereco
   select substring(CLIEND,1,charindex(',',CLIEND)-1)
     from TBS002 (noLock)
    where charindex(',',CLIEND) > 0

-- guarda o novo endereco no atributo temporario
update TBS002 set CLIENDTMP=substring(CLIEND,1,charindex(',',CLIEND)-1) where charindex(',',CLIEND) > 0

update TBS002 set CLIENDTMP=Ltrim(CLIENDTMP)

select CLIEND,CLIENDTMP from TBS002 (noLock)

-- lista o que sobrou sem numero e sem endereco
select CLICOD,CLIEND from TBS002 (noLock) where CLINUM=''
select CLICOD,CLIEND from TBS002 (noLock) where CLIENDTMP=''


-- fornecedores

-- altera o codigo do municipio para 0 (zero) caso o atributo esteja com o valor null
update TBS006 set MUNCOD=0 where MUNCOD is null

-- lista as cidades do cadastro de fornecedores
select distinct FORCID from TBS006 where MUNCOD = 0 order by FORCID

-- remove espacos em branco do inicio do nome da cidade
update TBS006 set FORCID=Ltrim(FORCID)

-- grava codigo do municipio caso encontre a cidade cadastrada na tabela de municipios
update TBS006 set MUNCOD=TBS003.MUNCOD from TBS006 join TBS003 on FORCID=MUNNOM

-- lista as cidades nao identificadas no cadastro de fornecedores
select FORCID,MUNCOD,* from TBS006 (noLock) where MUNCOD=0 order by FORCID

-- se houver fornecedor com o atributo numero igual a null
select * from TBS006 where FORNUM is null
update TBS006 set FORNUM='' where FORNUM is null

-- separacao do numero do logradouro do cliente
select FOREND,
       charindex(',',FOREND),
       substring(FOREND,charindex(',',FOREND)+1,60)
  from TBS006 (noLock)
 where charindex(',',FOREND) > 0

update TBS006 set FORNUM=substring(FOREND,charindex(',',FOREND)+1,60) where charindex(',',FOREND) > 0

update TBS006 set FORNUM=Ltrim(FORNUM)

select FOREND,FORNUM from TBS006 (noLock)

-- se houver fornecedor com o atributo endereco temporario igual a null
select * from TBS006 where FORENDTMP is null
update TBS006 set FORENDTMP='' where FORENDTMP is null

-- separacao do logradouro do numero do cliente
select FOREND,
       charindex(',',FOREND),
       substring(FOREND,1,charindex(',',FOREND)-1)
  from TBS006 (noLock)
 where charindex(',',FOREND) > 0

-- guarda o novo endereco no atributo temporario
update TBS006 set FORENDTMP=substring(FOREND,1,charindex(',',FOREND)-1) where charindex(',',FOREND) > 0

update TBS006 set FORENDTMP=Ltrim(FORENDTMP)

select FOREND,FORENDTMP from TBS006 (noLock)

-- lista o que sobrou sem numero e endereco
select FORCOD,FOREND from TBS006 (noLock) where FORNUM=''
select FORCOD,FOREND from TBS006 (noLock) where FORENDTMP=''


-- transportadoras

-- altera o codigo do municipio para 0 (zero) caso o atributo esteja com o valor null
update TBS005 set TRNMUNCOD=0 where TRNMUNCOD is null

-- lista as cidades do cadastro de transportadoras
select distinct TRNCID from TBS005 where TRNMUNCOD = 0 order by TRNCID

-- remove espacos em branco do inicio do nome da cidade
update TBS005 set TRNCID=Ltrim(TRNCID)

-- grava codigo do municipio caso encontre a cidade cadastrada na tabela de municipios
update TBS005 set TRNMUNCOD=MUNCOD,TRNMUNNOM=MUNNOM from TBS005 join TBS003 on TRNCID=MUNNOM

-- lista as cidades nao identificadas no cadastro de fornecedores
select TRNCID,TRNMUNCOD,* from TBS005 (noLock) where TRNMUNCOD=0 order by TRNCID


-- endereco de entrega

select CLILOG,
       charindex(',',CLILOG),
       substring(CLILOG,charindex(',',CLILOG)+1,60)
  from TBS0021 (noLock)
 where charindex(',',CLILOG) > 0

select CLILOG,
       charindex(',',CLILOG),
       substring(CLILOG,1,charindex(',',CLILOG)-1)
  from TBS0021 (noLock)
 where charindex(',',CLILOG) > 0

-- extrai o endereco

--update TBS0021 set CLILOG = substring(CLILOG,1,charindex(',',CLILOG)-1) where charindex(',',CLILOG) > 0
--  from TBS0021 (nolock) join TBS002 (nolock) on TBS0021.CLICOD = TBS002.CLICOD

update TBS0021 set CLIENDNUM = substring(CLILOG,charindex(',',CLILOG)+1,60) from TBS0021 (nolock) where CLIENDNUM = '' and charindex(',',CLILOG) > 0
select substring(CLILOG,charindex(',',CLILOG)+1,60) from TBS0021 (nolock) where CLIENDNUM = '' and charindex(',',CLILOG) > 0

update TBS0021 set CLILOG = substring(CLILOG,1,charindex(',',CLILOG)-1) where charindex(',',CLILOG) > 0

update TBS0021 set CLILOG = ltrim(CLILOG)
update TBS0021 set CLIENDNUM = ltrim(CLIENDNUM)

