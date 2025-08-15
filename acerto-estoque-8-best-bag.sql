-- conta produtos no estque 8 com quantidade atual igual a 1800
select count(*) from TBS032 (nolock) where ESTLOC=8 and ESTQTDATU=1800

-- zera quantidade atual do etoque 8 dos produtos com quantidade atual igual a 1800
update TBS032 set ESTQTDATU=0 where ESTLOC=8 and ESTQTDATU=1800
