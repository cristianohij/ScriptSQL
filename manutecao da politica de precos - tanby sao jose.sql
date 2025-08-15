-- lista produtos sem preco do fornecedor na politica de precos
select * from TBS015 (noLock) where PDPPREFOR=0

-- foram encontrados 32613 produtos sem preco

-- lista produtos sem preco do fornecedor na politica de precos, mas com preco na tabela de precos
select * from TBS015 (noLock) join TBS031 (noLock) on PDPCOD=TDPPROCOD
 where PDPPREFOR=0 and TDPPRECOR1>0

-- elimina todos os produtos que estiverem sem o preco do fornecedor na politica de precos
delete TBS015 where PDPPREFOR=0

-- foram eliminados os 32615 produtos sem preco em 5/3/10

-- produtos sem unidade de medida na politica de precos
select * from TBS015 (noLock) where PDPUNI='' and PDPPREFOR > 0

-- lista produtos da tabela de precos que nao existem na politica de precos
select * from TBS031 (noLock) where not exists(select 'ne' from TBS015 (noLock) where PDPCOD=TDPPROCOD)

-- elimina produtos da tabela de precos que nao existem na politica de precos
delete TBS031 where not exists(select 'ne' from TBS015 (noLock) where PDPCOD=TDPPROCOD)