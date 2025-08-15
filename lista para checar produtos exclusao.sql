declare @cod char(15)
set @cod = '1641301'

select * from TBS088  (nolock) where LEPPROCOD = @cod
select * from TBS010  (nolock) where PROCOD = @cod
select * from TBS032  (nolock) where PROCOD = @cod
select * from TBS013  (nolock) where PROCOD = @cod
select * from TBS084  (nolock) where PROCOD = @cod
select * from TBS0261 (nolock) where PROCOD = @cod
select * from TBS030  (nolock) where PROCOD = @cod
select * from TBS0371 (nolock) where PROCOD = @cod
select * from TBS0431 (nolock) where PROCOD = @cod
select * from TBS0451 (nolock) where PROCOD = @cod
select * from TBS049  (nolock) where PROCOD = @cod
select * from TBS0521 (nolock) where PROCOD = @cod
select * from TBS0551 (nolock) where PROCOD = @cod
select * from TBS058  (nolock) where PROCOD = @cod
select * from TBS0671 (nolock) where PROCOD = @cod
select * from TBS069  (nolock) where PROCOD = @cod
select * from TBS0761 (nolock) where PROCOD = @cod
select * from TBS0591 (nolock) where PROCOD = @cod
select * from TBS015  (nolock) where PDPCOD = @cod
select * from TBS031  (nolock) where TDPPROCOD = @cod
