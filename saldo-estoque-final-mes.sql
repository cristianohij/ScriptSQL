select distinct SALREF from TBS098 (nolock) order by SALREF

select * from TBS098 (nolock) where SALREF='2016/12'

select * from TBS098 (nolock) where SALREF Like('%2016&')

declare @referencia char(7),@produtoDe as char(15),@produtoAte as char(15),@estoque smallint

set @referencia='2016/12'
set @produtoDe=''
set @produtoAte=''
set @estoque=0

select PROCOD as 'CodigoDoProduto',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS098.PROCOD) as 'DescricaoDoProduto',
       (select rtrim(MARNOM)+' ('+ltrim(str(MARCOD,4))+')' from TBS010 (nolock) where TBS010.PROCOD=TBS098.PROCOD) as 'MarcaDoProduto',
       LESCOD as 'LocalDoEstoque',
       SALUNI as 'UnidadeDeMedida',
       SALQTD as 'QuantidadeEmEstoque',
       SALVAL as 'CustoUnitario',
       SALQTD*SALVAL as 'CustoTotal'
  from TBS098 (nolock)
 where SALREF=@referencia and
       LESCOD >= @estoque and
       LESCOD <= case when @estoque = 0 then 2 else @estoque end  and
       PROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end
 order by 'MarcaDoProduto'


declare @referencia char(7)

set @referencia='2016/12'

-- tanby matriz
select sum(SALQTD*SALVAL) from TBS098 (nolock) where SALREF=@referencia and SALQTD>0

-- tanby taubate
select sum(SALQTD*SALVAL) from TANBYTTE.SIBD.dbo.TBS098 (nolock) where SALREF=@referencia and SALQTD>0

-- tanby cd
select sum(SALQTD*SALVAL) from TANBYCD.SIBD.dbo.TBS098 (nolock) where SALREF=@referencia and SALQTD>0


-- sintético

select subString(SALREF,4,4)+subString(SALREF,1,2),sum(SALQTD*SALVAL)
  from TANBYCD.SIBD.dbo.TBS098 (nolock)
 where subString(SALREF,4,4)+subString(SALREF,1,2)>='201412' and SALQTD>0 group by subString(SALREF,4,4)+subString(SALREF,1,2)

begin tran
update MISASPEL.SIBD.dbo.TBS098 set SALREF=subString(SALREF,4,4)+'/'+subString(SALREF,1,2) where SALREF='01/2015'

commit

select * from TBS098 (nolock) where SALREF='2015/01'

select SALREF,sum(SALQTD*SALVAL) from BESTBAG.SIBD2.dbo.TBS098 (nolock) where SALREF>='2014/12' and SALQTD>0 group by SALREF order by SALREF

select SALREF,sum(SALQTD*SALVAL) from TBS098 (nolock) where SALREF between @anoDe+'/'+@mesDe and @anoAte+'/'+mesAte and SALQTD>0 group by SALREF order by SALREF



select subString(SALREF,4,4)+subString(SALREF,1,2),sum(SALQTD*SALVAL)
  from TBS098 (nolock)
 where subString(SALREF,4,4)+subString(SALREF,1,2)>='201412' and SALQTD>0
 group by subString(SALREF,4,4)+subString(SALREF,1,2)


declare @anoDe char(4),@mesDe char(2),@anoAte char(4),@mesAte char(2)

set @anoDe='2015'
set @mesDe='01'

set @anoAte='2015'
set @mesAte='05'

select subString(SALREF,1,4) as 'AnoDeReferencia',
       subString(SALREF,6,2) as 'MesDeReferencia',
       LESCOD as 'LocalDoEstoque',
       (select LESDES from TBS034 (nolock) where TBS034.LESCOD=TBS098.LESCOD) 'DescricaoDoLocalDoEstoque',
       sum(SALQTD*SALVAL) as 'ValorTotal'
  from TBS098 (nolock)
 where SALREF between @anoDe+'/'+@mesDe and @anoAte+'/'+@mesAte and
       SALQTD>0
 group by SALREF,LESCOD
 order by SALREF

select * from TBS034 (nolock)