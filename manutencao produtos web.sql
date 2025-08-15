-- lista produtos
declare @ativo char(1)

-- S = ativos, N = inativos, '' = todos
set @ativo = 'S'

select * from WEB002
 where PRODESATI between
          case @ativo
             when 'S' then 'S'
             when 'N' then 'N'
             else ''
          end
          and
          case @ativo
             when 'S' then 'S'
             when 'N' then 'N'
             else 'Z'
          end

-- lista produtos ATIVOS SEM saldo disponivel
select * from WEB002 join TBS032 on WEB002.PROCOD = TBS032.PROCOD
 where PRODESATI = 'N' and ESTLOC = 1 and ESTQTDATU - ESTQTDRES <= 0

-- DESATIVA produtos SEM saldo em estoque
update WEB002 set PRODESATI = 'S'
  from WEB002 join TBS032 on WEB002.PROCOD = TBS032.PROCOD
 where ESTLOC = 1 and ESTQTDATU - ESTQTDRES <= 0

-- ELIMINA produtos SEM saldo em estoque
delete WEB002
  from WEB002 join TBS032 on WEB002.PROCOD = TBS032.PROCOD
 where ESTLOC = 1 and ESTQTDATU - ESTQTDRES <= 0

-- lista produtos INATIVOS COM saldo disponivel
select * from WEB002 join TBS032 on WEB002.PROCOD = TBS032.PROCOD
 where PRODESATI = 'S' and ESTLOC = 1 and ESTQTDATU - ESTQTDRES > 0

-- ATIVA produtos COM saldo em estoque
update WEB002 set PRODESATI = 'N'
  from WEB002 join TBS032 on WEB002.PROCOD = TBS032.PROCOD
 where PRODESATI = 'S' and ESTLOC = 1 and ESTQTDATU - ESTQTDRES > 0

-- lista produtos SEM unidade de medida
select * from WEB002 where PROUNI = ''

-- atualiza unidade de medidas
update WEB002 set PROUNI = PROUM1
  from WEB002 join TBS010 on WEB002.PROCOD = TBS010.PROCOD
 where PROUNI <> PROUM1

-- lista tabela de NEGOCIOS
select * from WEB001 where TABCOD = 'NEG' order by TABSEQ

-- grava NEGOCIO em todos os produtos
update WEB002 set PRONEGSEQ = 1 where PRONEGSEQ = 0

-- lista tabela de CATEGORIAS
select * from WEB001 where TABCOD = 'CAT' order by TABSEQ

-- lista tabela de CLASSES
select * from WEB001 where TABCOD = 'CLA' order by TABSEQ

-- lista produtos SEM categoria
select * from WEB002 where PROCATSEQ = 0

-- insere CATEGORIA em grupos de produtos
update WEB002 set PROCATSEQ = TABSEQ ,PROCATDES = TABDES
  from WEB001 ,WEB002
 where TABCOD = 'CAT' and TABSEQ = 3 and PRODES Like('AGENDA%')

-- lista produtos SEM classe
select * from WEB002 where PROCLASEQ = 0

-- insere CLASSE em grupos de produtos
update WEB002 set PROCLASEQ = TABSEQ ,PROCLADES = TABDES
  from WEB001 ,WEB002
 where TABCOD = 'CLA' and TABSEQ = 2 and PRODES Like('AGENDA%')

-- lista produtos SEM preco
select * from WEB002 where PROPRE = 0

-- lista produtos em PROMOCAO
select * from WEB002 where PROPREPRO > 0 and PROVALINI >= getDate() and PROVALFIN <= getDate()


select * from WEB002 ORDER BY PRODES