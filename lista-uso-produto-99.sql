declare @codigo as char(15)
set @codigo='99'

select top 1 'TBS0101' from TBS0101 (nolock) where PROCOD=@codigo
select top 1 'TBS013'  from TBS013  (nolock) where PROCOD=@codigo
select top 1 'TBS015'  from TBS015  (nolock) where PDPCOD=@codigo
select top 1 'TBS0261' from TBS0261 (nolock) where PROCOD=@codigo
select top 1 'TBS030'  from TBS030  (nolock) where PROCOD=@codigo
select top 1 'TBS031'  from TBS031  (nolock) where TDPPROCOD=@codigo
select top 1 'TBS032'  from TBS032  (nolock) where PROCOD=@codigo and ESTQTDATU > 0
select top 1 'TBS0371' from TBS0371 (nolock) where PROCOD=@codigo
select top 1 'TBS0431' from TBS0431 (nolock) where PROCOD=@codigo
select top 1 'TBS0451' from TBS0451 (nolock) where PROCOD=@codigo
select top 1 'TBS049'  from TBS049  (nolock) where PROCOD=@codigo
select top 1 'TBS051'  from TBS051  (nolock) where PROCOD=@codigo
select top 1 'TBS058'  from TBS058  (nolock) where PROCOD=@codigo
select top 1 'TBS0591' from TBS0591 (nolock) where PROCOD=@codigo
select top 1 'TBS0671' from TBS0671 (nolock) where PROCOD=@codigo
select top 1 'TBS069'  from TBS069  (nolock) where PROCOD=@codigo
select top 1 'TBS0761' from TBS0761 (nolock) where PROCOD=@codigo
select top 1 'TBS084'  from TBS084  (nolock) where PROCOD=@codigo
select top 1 'TBS098'  from TBS098  (nolock) where PROCOD=@codigo and SALQTD > 0
select top 1 'TBS1151' from TBS1151 (nolock) where PROCOD=@codigo
select top 1 'TBS1172' from TBS1172 (nolock) where PROCOD=@codigo
select top 1 'MSL002'  from MSL002  (nolock) where M2_PROCOD=@codigo

