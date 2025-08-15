use BKP2011
use BKP2012

drop table EST2011

select PROCOD as 'produto',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS032.PROCOD) as 'descricao',
       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS032.PROCOD) as 'unidade',
       ESTQTDATU as 'quantidade',
       isnull((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD=PROCOD),0) as 'custo',
       ESTLOC as 'local'
       into EST2011
  from TBS032 (nolock) where ESTLOC in(1,2)

select * from EST2011 (nolock)

select * from EST2011 (nolock) where Len(produto)<7

delete EST2011 where Len(produto)<7

select * from EST2011 (nolock) where descricao is null

delete EST2011 where descricao is null

select * from EST2011 (nolock) where unidade is null

select * from EST2011 (nolock) where quantidade < 0


select produto,
       descricao,
       unidade,
       quantidade,
       custo,
       local
  from EST2011 (nolock)

select sum(quantidade*custo) from EST2012 (nolock)


