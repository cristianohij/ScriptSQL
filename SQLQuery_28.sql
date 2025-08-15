select *
  from TBS059 c with (nolock)
 inner join TBS0591 d (nolock)
    on c.NFETIP=d.NFETIP and c.NFENUM=d.NFENUM  and c.NFECOD=d.NFECOD and c.SERCOD=d.SERCOD
 where c.NFEDATEFE >= '20240101'
       and c.NFETIP='D'
       and c.NFECAN='N'

-- quantidade de notas fiscais por ano/mês

select YEAR(c.NFEDATEFE) as Ano,
       MONTH(c.NFEDATEFE) as Mes,
       COUNT(*) as QuantidadeNotasFiscais
  from TBS059 c with (nolock)
 where c.NFEDATEFE >= '20240101'
   and c.NFETIP = 'D'
   and c.NFECAN = 'N'
 group by YEAR(c.NFEDATEFE), MONTH(c.NFEDATEFE)
 order by Ano, Mes;

-- quantidade de itens por ano/mês

select YEAR(c.NFEDATEFE) as Ano,
       MONTH(c.NFEDATEFE) as Mes,
       COUNT(d.NFENUM) as NumeroDeItens
  from TBS059 c with (nolock)
 inner join TBS0591 d with (nolock)
    on c.NFETIP = d.NFETIP and 
       c.NFENUM = d.NFENUM and 
       c.NFECOD = d.NFECOD and 
       c.SERCOD = d.SERCOD
 where c.NFEDATEFE >= '20240101'
   and c.NFETIP = 'D'
   and c.NFECAN = 'N'
 group by YEAR(c.NFEDATEFE), MONTH(c.NFEDATEFE)
 order by Ano, Mes;

-- junção

with NotasFiscais as (
    select YEAR(c.NFEDATEFE) as Ano,
           MONTH(c.NFEDATEFE) as Mes,
           COUNT(*) as QuantidadeNotasFiscais
      from TBS059 c with (nolock)
     where c.NFEDATEFE >= '20240101'
       and c.NFETIP = 'D'
       and c.NFECAN = 'N'
     group by YEAR(c.NFEDATEFE), MONTH(c.NFEDATEFE)
),
Itens as (
    select YEAR(c.NFEDATEFE) as Ano,
           MONTH(c.NFEDATEFE) as Mes,
           COUNT(d.NFENUM) as NumeroDeItens
      from TBS059 c with (nolock)
     inner join TBS0591 d with (nolock)
        on c.NFETIP = d.NFETIP and 
           c.NFENUM = d.NFENUM and 
           c.NFECOD = d.NFECOD and 
           c.SERCOD = d.SERCOD
     where c.NFEDATEFE >= '20240101'
       and c.NFETIP = 'D'
       and c.NFECAN = 'N'
     group by YEAR(c.NFEDATEFE), MONTH(c.NFEDATEFE)
)
select n.Ano, 
       n.Mes, 
       n.QuantidadeNotasFiscais, 
       i.NumeroDeItens
  from NotasFiscais n
  left join Itens i 
    on n.Ano = i.Ano 
   and n.Mes = i.Mes
 order by n.Ano, n.Mes;

-- 

with NotasFiscais as (
    select YEAR(c.NFEDATEFE) as Ano,
           MONTH(c.NFEDATEFE) as Mes,
           c.NFETIPENT as OrigemDevolucao,
           COUNT(*) as QuantidadeNotasFiscais
      from TBS059 c with (nolock)
     where c.NFEDATEFE >= '20240101'
       and c.NFETIP = 'D'
       and c.NFECAN = 'N'
     group by YEAR(c.NFEDATEFE), MONTH(c.NFEDATEFE), c.NFETIPENT
),
Itens as (
    select YEAR(c.NFEDATEFE) as Ano,
           MONTH(c.NFEDATEFE) as Mes,
           c.NFETIPENT OrigemDevolucao,
           COUNT(d.NFEITE) as NumeroDeItens
      from TBS059 c with (nolock)
     inner join TBS0591 d with (nolock)
        on c.NFETIP = d.NFETIP and 
           c.NFENUM = d.NFENUM and 
           c.NFECOD = d.NFECOD and 
           c.SERCOD = d.SERCOD
     where c.NFEDATEFE >= '20240101'
       and c.NFETIP = 'D'
       and c.NFECAN = 'N'
     group by YEAR(c.NFEDATEFE), MONTH(c.NFEDATEFE), c.NFETIPENT
)
select n.Ano, 
       n.Mes, 
       n.OrigemDevolucao,
       n.QuantidadeNotasFiscais, 
       i.NumeroDeItens
  from NotasFiscais n
  left join Itens i 
    on n.Ano = i.Ano 
   and n.Mes = i.Mes
   and n.OrigemDevolucao = i.OrigemDevolucao
 order by n.Ano, n.Mes, n.OrigemDevolucao;

with NotasFiscais as (
    select YEAR(c.NFEDATEFE) as Ano,
           MONTH(c.NFEDATEFE) as Mes,
           c.NFETIPENT as OrigemDevolucao,
           COUNT(*) as QuantidadeNotasFiscais
      from TBS059 c with (nolock)
     where c.NFEDATEFE >= '20240101'
       and c.NFETIP = 'D'
       and c.NFECAN = 'N'
     group by YEAR(c.NFEDATEFE), MONTH(c.NFEDATEFE), c.NFETIPENT
),
Itens as (
    select YEAR(c.NFEDATEFE) as Ano,
           MONTH(c.NFEDATEFE) as Mes,
           c.NFETIPENT as OrigemDevolucao,
           COUNT(d.NFEITE) as NumeroDeItens
      from TBS059 c with (nolock)
     inner join TBS0591 d with (nolock)
        on c.NFETIP = d.NFETIP and 
           c.NFENUM = d.NFENUM and 
           c.NFECOD = d.NFECOD and 
           c.SERCOD = d.SERCOD
     where c.NFEDATEFE >= '20240101'
       and c.NFETIP = 'D'
       and c.NFECAN = 'N'
     group by YEAR(c.NFEDATEFE), MONTH(c.NFEDATEFE), c.NFETIPENT
)
select ISNULL(n.Ano, 'Total') as Ano,
       ISNULL(n.Mes, 'Total') as Mes,
       ISNULL(n.OrigemDevolucao, 'Subtotal') as OrigemDevolucao,
       SUM(n.QuantidadeNotasFiscais) as QuantidadeNotasFiscais, 
       SUM(i.NumeroDeItens) as NumeroDeItens
  from NotasFiscais n
  left join Itens i 
    on n.Ano = i.Ano 
   and n.Mes = i.Mes
   and n.OrigemDevolucao = i.OrigemDevolucao
 group by GROUPING SETS (
            (n.Ano, n.Mes, n.OrigemDevolucao),  -- Agrupamento original
            (n.Ano, n.Mes),                     -- Subtotal por Ano e Mês
            (n.Ano),                            -- Subtotal por Ano
            ()                                  -- Total geral
           )
 order by n.Ano, n.Mes, n.OrigemDevolucao;


with NotasFiscais as (
    select YEAR(c.NFEDATEFE) as Ano,
           MONTH(c.NFEDATEFE) as Mes,
           c.NFETIPENT as OrigemDevolucao,
           COUNT(*) as QuantidadeNotasFiscais
      from TBS059 c with (nolock)
     where c.NFEDATEFE >= '20240101'
       and c.NFETIP = 'D'
       and c.NFECAN = 'N'
     group by YEAR(c.NFEDATEFE), MONTH(c.NFEDATEFE), c.NFETIPENT
),
Itens as (
    select YEAR(c.NFEDATEFE) as Ano,
           MONTH(c.NFEDATEFE) as Mes,
           c.NFETIPENT as OrigemDevolucao,
           COUNT(d.NFEITE) as NumeroDeItens
      from TBS059 c with (nolock)
     inner join TBS0591 d with (nolock)
        on c.NFETIP = d.NFETIP and 
           c.NFENUM = d.NFENUM and 
           c.NFECOD = d.NFECOD and 
           c.SERCOD = d.SERCOD
     where c.NFEDATEFE >= '20240101'
       and c.NFETIP = 'D'
       and c.NFECAN = 'N'
     group by YEAR(c.NFEDATEFE), MONTH(c.NFEDATEFE), c.NFETIPENT
)
select n.Ano, 
       n.Mes, 
       n.OrigemDevolucao,
       SUM(n.QuantidadeNotasFiscais) as QuantidadeNotasFiscais, 
       SUM(i.NumeroDeItens) as NumeroDeItens
  from NotasFiscais n
  left join Itens i 
    on n.Ano = i.Ano 
   and n.Mes = i.Mes
   and n.OrigemDevolucao = i.OrigemDevolucao
 group by 
    GROUPING SETS (
        (n.Ano, n.Mes, n.OrigemDevolucao),  -- Agrupamento original
        (n.Ano, n.Mes),                     -- Subtotal por Ano e Mês
        (n.Ano),                            -- Subtotal por Ano
        ()                                  -- Total geral
    )
 order by 
    GROUPING_ID(n.Ano, n.Mes, n.OrigemDevolucao),
    n.Ano, n.Mes, n.OrigemDevolucao;

-- notas fiscais emitidas pelo cliente

with NotasFiscais as (
    select YEAR(c.NFEDATEFE) as Ano,
           MONTH(c.NFEDATEFE) as Mes,
           c.NFETIPENT as OrigemDevolucao,
           COUNT(*) as QuantidadeNotasFiscais
      from TBS059 c with (nolock)
     where c.NFEDATEFE >= '20240101'
       and c.NFETIP = 'D'
       and c.NFECAN = 'N'
       and c.NFENOSFOR = 'N'
     group by YEAR(c.NFEDATEFE), MONTH(c.NFEDATEFE), c.NFETIPENT
),
Itens as (
    select YEAR(c.NFEDATEFE) as Ano,
           MONTH(c.NFEDATEFE) as Mes,
           c.NFETIPENT as OrigemDevolucao,
           COUNT(d.NFEITE) as NumeroDeItens
      from TBS059 c with (nolock)
     inner join TBS0591 d with (nolock)
        on c.NFETIP = d.NFETIP and 
           c.NFENUM = d.NFENUM and 
           c.NFECOD = d.NFECOD and 
           c.SERCOD = d.SERCOD
     where c.NFEDATEFE >= '20240101'
       and c.NFETIP = 'D'
       and c.NFECAN = 'N'
       and c.NFENOSFOR = 'N'
     group by YEAR(c.NFEDATEFE), MONTH(c.NFEDATEFE), c.NFETIPENT
)
select n.Ano, 
       n.Mes, 
       n.OrigemDevolucao,
       SUM(n.QuantidadeNotasFiscais) as QuantidadeNotasFiscais, 
       SUM(i.NumeroDeItens) as NumeroDeItens
  from NotasFiscais n
  left join Itens i 
    on n.Ano = i.Ano 
   and n.Mes = i.Mes
   and n.OrigemDevolucao = i.OrigemDevolucao
 group by 
    GROUPING SETS (
        (n.Ano, n.Mes, n.OrigemDevolucao),  -- Agrupamento original
        (n.Ano, n.Mes),                     -- Subtotal por Ano e Mês
        (n.Ano),                            -- Subtotal por Ano
        ()                                  -- Total geral
    )
 order by 
    GROUPING_ID(n.Ano, n.Mes, n.OrigemDevolucao),
    n.Ano, n.Mes, n.OrigemDevolucao;
