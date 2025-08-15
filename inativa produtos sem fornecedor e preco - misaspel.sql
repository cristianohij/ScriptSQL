-- inativa produtos sem preco
select * from TBS010 where PROSTATUS = 'A' and not exists(select 'ne' from TBS031 where TDPPROCOD=PROCOD)

update TBS010 set PROSTATUS='I'
 where PROSTATUS = 'A' and not exists(select 'ne' from TBS031 where TDPPROCOD=PROCOD)


-- inativa produtos sem fornecedor
select * from TBS010 where PROSTATUS = 'A' and FORCOD = 0

update TBS010 set PROSTATUS='I' where PROSTATUS = 'A' and FORCOD = 0

