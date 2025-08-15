-- usuarios
select 'usuario','nome-usuario','data-alteracao','bloqueado','preco-corporativo','preco-custo','preco-loja','preco-revenda','preco-web-1','preco-web-2','email','altera-senha'

select USUCOD as 'usuario',
       USUNOM as 'nome-usuario',
       USUDATALTCAD as 'data-alteracao',
       USUBLOQ as 'bloqueado',
       case when subString(USUVISPRE,1,1) = '1' then 'S' else 'N' end as 'preco-corporativo',
       case when subString(USUVISPRE,2,1) = '1' then 'S' else 'N' end as 'preco-custo',
       case when subString(USUVISPRE,3,1) = '1' then 'S' else 'N' end as 'preco-loja',
       case when subString(USUVISPRE,4,1) = '1' then 'S' else 'N' end as 'preco-revenda',
       case when subString(USUVISPRE,5,1) = '1' then 'S' else 'N' end as 'preco-web-1',
       case when subString(USUVISPRE,6,1) = '1' then 'S' else 'N' end as 'preco-web-2',
       USUEMAIL as 'email',
       USUALTSEN as 'altera-senha'
  from TBS016 (nolock)
 order by 'usuario'

-- usuario/empresa
select 'usuario','empresa','nome-empresa'

select TBS0161.USUCOD as 'usuario',
       TBS0161.EMPCOD as 'empresa',
       (select TBS023.EMPNOMFAN from TBS023 (nolock) where TBS023.EMPCOD = TBS0161.EMPCOD) as 'nome-empresa'
  from TBS0161 (nolock)
 order by 'usuario','empresa'

-- usuario/modulo/menu
select 'usuario','modulo','descricao-modulo','menu','descricao-menu'

select TBS0162.USUCOD as 'usuario',
       TBS0162.MODNOM as 'modulo',
       (select TBS020.MODDES from TBS020 (nolock) where TBS020.MODNOM = TBS0162.MODNOM) as 'descricao-modulo',
       TBS0162.MNUNOM as 'menu',
       (select TBS019.MNUDES from TBS019 (nolock) where TBS019.MNUNOM = TBS0162.MNUNOM) as 'descricao-menu'
  from TBS0162 (nolock)
 order by 'usuario','modulo','menu'

-- usuario/menu/programa
select 'usuario','menu','programa','nome-programa','descricao-programa','opcao-sistema','opcao-programa','tem-acesso'

select TBS0162.USUCOD as 'usuario',
       TBS0162.MNUNOM as 'menu',
       TBS0191.PRGCOD as 'programa',
       TBS018.PRGNOM as 'nome-programa',
       TBS018.PRGDES as 'descricao-programa',
       TBS018.NIVNOM as 'menu-sistema',
       TBS0181.PRGEVENOM as 'opcao-programa',
       case when TBS0191.PRGEVE Like('%' + rtrim(convert(char,TBS0181.PRGEVEITEM)) + '%') then 'S' else 'N' end as 'tem-acesso'
  from TBS0162 (nolock) join TBS019  (nolock) on TBS019.MNUNOM  = TBS0162.MNUNOM -- menu do usuários
                        join TBS0191 (nolock) on TBS0191.MNUNOM = TBS019.MNUNOM  -- opções do menu do usuário
                        join TBS018  (nolock) on TBS018.PRGCOD  = TBS0191.PRGCOD -- dados do programa
                        join TBS0181 (nolock) on TBS0181.PRGCOD = TBS018.PRGCOD
-- where TBS0191.PRGEVE Like('%' + rtrim(convert(char,TBS0181.PRGEVEITEM))+'%')
 order by 'usuario','menu','nome-programa','opcao-programa','tem-acesso'


-- usuario/locais de estoque
select 'usuario','empresa','nome-empresa','local-estoque','descricao-local-estoque'

select TBS0163.USUCOD as 'usuario',
       TBS0163.USULESEMP as 'empresa',
       (select TBS023.EMPNOMFAN from TBS023 (nolock) where TBS023.EMPCOD = TBS0163.USULESEMP) as 'nome-empresa',
       TBS0163.LESCOD as 'local-estoque',
       (select TBS034.LESDES from TBS034 (nolock) where TBS034.LESCOD = TBS0163.LESCOD) as 'descricao-local-estoque'
  from TBS0163 (nolock)
 order by 'usuario','empresa','local-estoque','descricao-local-estoque'

-- usuario/tipos de movimentacoes
select 'usuario','empresa','nome-empresa','tipo-movimentacao','descricao-tipo-movimentacao','fluxo','movimentacao-automatica','transferencia'

select TBS0164.USUCOD as 'usuario',
       TBS0164.USUTMVEMP as 'empresa',
       (select TBS023.EMPNOMFAN from TBS023 (nolock) where TBS023.EMPCOD = TBS0164.USUTMVEMP) as 'nome-empresa',
       TBS0164.TMVCOD as 'tipo-movimentacao',
       TBS033.TMVDES as 'descricao-tipo-movimentacao',
       case TBS033.TMVTIP when 'E' then 'entrada' else 'saida' end as 'fluxo',
       TBS033.TMVMOVAUT as 'movimentacao-automatica',
       TBS033.TMVINFTRA as 'transferencia'
  from TBS0164 (nolock) join TBS033 (nolock) on TBS033.TMVCOD = TBS0164.TMVCOD
 order by 'usuario','empresa','tipo-movimentacao','descricao-tipo-movimentacao'

-- usuario/banco de dados
select 'usuario','nome-ou-ip-servidor','banco-de-dados'

select TBS0165.USUCOD as 'usuario',
       TBS0165.SBDSER as 'nome-ou-ip-servidor',
       TBS0165.SBDBANNOM as 'banco-de-dados'
  from TBS0165 (nolock)
 order by 'usuario','nome-ou-ip-servidor','banco-de-dados'

