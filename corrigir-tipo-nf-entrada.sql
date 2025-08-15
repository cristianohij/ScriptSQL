declare @numero smallint,@fornecedor smallint,@tipo char(1)

set @numero=60243
set @fornecedor=1805

-- N = normal
-- D = devolução
-- T = transferência

set @tipo='N'

select * from TBS059 (nolock) where NFENUM=@numero and NFECOD=@fornecedor
select * from TBS0591 (nolock) where NFENUM=@numero and NFECOD=@fornecedor
select * from TBS0592 (nolock) where NFENUM=@numero and NFECOD=@fornecedor
select * from TBS0593 (nolock) where NFENUM=@numero and NFECOD=@fornecedor
select * from TBS0594 (nolock) where NFENUM=@numero and NFECOD=@fornecedor
select * from TBS0595 (nolock) where NFENUM=@numero and NFECOD=@fornecedor
select * from TBS0596 (nolock) where NFENUM=@numero and NFECOD=@fornecedor
select * from TBS0597 (nolock) where NFENUM=@numero and NFECOD=@fornecedor

update TBS059 set NFETIP=@tipo where NFENUM=@numero and NFECOD=@fornecedor
update TBS0591 set NFETIP=@tipo where NFENUM=@numero and NFECOD=@fornecedor
update TBS0592 set NFETIP=@tipo where NFENUM=@numero and NFECOD=@fornecedor
update TBS0593 set NFETIP=@tipo where NFENUM=@numero and NFECOD=@fornecedor
update TBS0594 set NFETIP=@tipo where NFENUM=@numero and NFECOD=@fornecedor
update TBS0595 set NFETIP=@tipo where NFENUM=@numero and NFECOD=@fornecedor
update TBS0596 set NFETIP=@tipo where NFENUM=@numero and NFECOD=@fornecedor
update TBS0597 set NFETIP=@tipo where NFENUM=@numero and NFECOD=@fornecedor
