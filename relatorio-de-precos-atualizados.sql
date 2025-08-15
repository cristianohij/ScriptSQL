declare @dataDe char(8),
        @dataAte char(8),
        @produtoDe char(15),
        @produtoAte char(15),
        @codigoDaMarca smallint,
        @nomeDaMarca char(30),
        @somenteComSaldo char(1)

set @dataDe='06/05/15'
set @dataAte='06/05/15'

set @produtoDe=''
set @produtoAte='Z'

set @codigoDaMarca=0
set @nomeDaMarca=''

set @somenteComSaldo='N'

-- se preços da tanby matriz estiver direfente da tanby taubaté

select rtrim(TBS010.MARNOM)+' ('+Ltrim(str(TBS010.MARCOD,4))+')' as 'NomeECodigoDaMarca',
       TBS031.TDPPROCOD as 'CodigoDoProduto',
       TBS010.PRODES as 'DescricaoDoProduto',
       TBS010.PROUM1 as 'UnidadeDeMedida1',
       case when TBS031.TDPVALPROI>=getdate() and getdate()<=TBS031.TDPVALPROF and TBS031.TDPPROLOJ='S' then TBS031.TDPPREPRO1 else TBS031.TDPPRELOJ1 end as 'Preco1',
       TBS010.PROUM2 as 'UnidadeDeMedida2',
       case when TBS031.TDPVALPROI>=getdate() and getdate()<=TBS031.TDPVALPROF and TBS031.TDPPROLOJ='S' then TBS031.TDPPREPRO2*PROUM2QTD else TBS031.TDPPRELOJ2*PROUM2QTD end as 'Preco2',
       TBS031.TDPDATATU as 'DataDaAtualizacao',
       case when getdate()<=TBS031.TDPVALPROF and TBS031.TDPPROLOJ='S' then convert(char(8),TBS031.TDPVALPROF,3) else '' end as 'PromocaoValidaAte',
       T32.ESTQTDATU-T32.ESTQTDRES as 'SaldoDisponivel'
  from TBS031 (nolock) right join TBS010 (nolock) on PROCOD=TDPPROCOD
                             join TANBYT.SIBD.dbo.TBS031 as T31 (nolock) on T31.TDPPROCOD=TBS031.TDPPROCOD
                             join TANBYT.SIBD.dbo.TBS032 as T32 (nolock) on T32.PROCOD=TBS031.TDPPROCOD
 where convert(char(8),TBS031.TDPDATATU,3) between @dataDe and @dataAte and
       TBS031.TDPPROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       TBS010.MARCOD>=@codigoDaMarca and
       TBS010.MARNOM between @nomeDaMarca and case when @nomeDaMarca='' then 'Z' else @nomeDaMarca end and
       ((T31.TDPVALPROI>=getdate() and getdate()<=T31.TDPVALPROF and T31.TDPPROLOJ='S' and (T31.TDPPREPRO1<>TBS031.TDPPREPRO1 or T31.TDPPREPRO2<>TBS031.TDPPREPRO2)) or
        T31.TDPPRELOJ1<>TBS031.TDPPRELOJ1 or T31.TDPPRELOJ2<>TBS031.TDPPRELOJ2) and
       T32.ESTLOC=2 and
       T32.ESTQTDATU-T32.ESTQTDRES >= case when @somenteComSaldo='N' then 0 else 0.001 end
 order by TBS010.MARNOM,TBS010.PRODES


-- lista atualizações idenpente de estar igual ou diferente de taubaté

select rtrim(MARNOM)+' ('+Ltrim(str(MARCOD,4))+')' as 'NomeECodigoDaMarca',
       TDPPROCOD as 'CodigoDoProduto',
       PRODES as 'DescricaoDoProduto',
       PROUM1 as 'UnidadeDeMedida1',
       case when TDPVALPROI>=getdate() and getdate()<=TDPVALPROF and TDPPROLOJ='S' then TDPPREPRO1 else TDPPRELOJ1 end as 'Preco1',
       PROUM2 as 'UnidadeDeMedida2',
       case when TDPVALPROI>=getdate() and getdate()<=TDPVALPROF and TDPPROLOJ='S' then TDPPREPRO2*PROUM2QTD else TDPPRELOJ2*PROUM2QTD end as 'Preco2',
       TDPDATATU as 'DataDaAtualizacao',
       case when getdate()<=TDPVALPROF and TDPPROLOJ='S' then convert(char(8),TDPVALPROF,3) else '' end as 'PromocaoValidaAte'
  from TBS031 (nolock) right join TBS010 (nolock) on PROCOD=TDPPROCOD
--                             join TBS014 (nolock) on TBS014.MAREMPCOD=TBS010.MAREMPCOD and TBS014.MARCOD=TBS010.MARCOD
 where TDPDATATU between @dataDe and @dataAte and
       TDPPROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       MARCOD>=@codigoDaMarca and
       --rtrim(MARNOM) Like case when @nomeDaMarca='' then 'ACRI%' else @nomeDaMarca end
       MARNOM between @nomeDaMarca and case when @nomeDaMarca='' then 'Z' else @nomeDaMarca end
 order by MARNOM,PRODES

select TDPPROCOD,TDPDATATU from TBS031 (nolock) where TDPDATATU between '20150501' and '20150505' order by TDPPROCOD

select PROCOD,MARCOD,MARNOM,* from TBS010 (nolock) where MARCOD=6 and MARNOM Like '[0-Z]%'

select TBS010.MARCOD,TBS010.MARNOM,TBS014.MARCOD,TBS014.MARNOM from TBS010 (nolock) join TBS014 (nolock) on TBS010.MARCOD=TBS014.MARCOD and TBS010.MARNOM<>TBS014.MARNOM

begin tran
update TBS010 set MARNOM=TBS014.MARNOM from TBS010 (nolock) join TBS014 (nolock) on TBS010.MARCOD=TBS014.MARCOD and TBS010.MARNOM<>TBS014.MARNOM

begin tran
update TBS010 set MARNOM='ACRILEX' where MARCOD=6

begin tran
update TBS010 set PRODIAUTI=0 where PRODIAUTI is null
go
update TBS010 set PRODATFIN='17530101' where PRODATFIN is null
go
update TBS010 set PROLOTCMP=0 where PROLOTCMP is null
go
update TBS010 set PRORECACU='' where PRORECACU is null
go
update TBS010 set PROHORALTPOP='' where PROHORALTPOP is null
go
update TBS010 set PRODATALTPOP='17530101' where PRODATALTPOP is null
go
update TBS010 set PROUSUALTPOP='' where PROUSUALTPOP is null
go

commit tran

select rtrim(TBS014.MARNOM)+' ('+Ltrim(str(TBS014.MARCOD,4))+')' as 'NomeECodigoDaMarca',
       TBS031.TDPPROCOD as 'CodigoDoProduto',
       PRODES as 'DescricaoDoProduto',
       PROUM1 as 'UnidadeDeMedida1',
       case when TBS031.TDPVALPROI >= getdate() and getdate() <= TBS031.TDPVALPROF and TBS031.TDPPROLOJ='S' then TBS031.TDPPREPRO1 else TBS031.TDPPRELOJ1 end as 'Preco1',
       PROUM2 as 'UnidadeDeMedida2',
       case when TBS031.TDPVALPROI >= getdate() and getdate() <= TBS031.TDPVALPROF and TBS031.TDPPROLOJ='S' then TBS031.TDPPREPRO2*PROUM2QTD else TBS031.TDPPRELOJ2*PROUM2QTD end as 'Preco2',
       case when getdate() <= TBS031.TDPVALPROF and TBS031.TDPPROLOJ='S' then TBS031.TDPVALPROF else ' ' end as 'PromocaoValidaAte'
  from TBS031 (nolock) right join TBS010 (nolock) on PROCOD=TDPPROCOD
                             join TBS014 (nolock) on TBS014.MAREMPCOD=TBS010.MAREMPCOD and TBS014.MARCOD=TBS010.MARCOD
                             join TANBYTTE.SIBD.dbo.TBS031 as T31 (nolock) on T31.TDPPROCOD=TBS031.TDPPROCOD
 where TBS031.TDPDATATU between @dataDe and @dataAte and
       TBS031.TDPPROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       ((T31.TDPVALPROI>=getdate() and getdate()<=T31.TDPVALPROF and T31.TDPPROLOJ='S' and (T31.TDPPREPRO1<>TBS031.TDPPREPRO1 or T31.TDPPREPRO2<>TBS031.TDPPREPRO2)) or
        T31.TDPPRELOJ1<>TBS031.TDPPRELOJ1 or T31.TDPPRELOJ2<>TBS031.TDPPRELOJ2) and
       TBS014.MARCOD>=@codigoDaMarca and
       TBS014.MARNOM Like case when @nomeDaMarca='' then '[0-Z]%' else @nomeDaMarca end



select rtrim(TBS014.MARNOM)+' ('+Ltrim(str(TBS014.MARCOD,4))+')' as 'NomeECodigoDaMarca',
       TDPPROCOD as 'CodigoDoProduto',
       PRODES as 'DescricaoDoProduto',
       PROUM1 as 'UnidadeDeMedida1',
       case when TDPVALPROI >= getdate() and getdate() <= TDPVALPROF and TDPPROLOJ='S' then TDPPREPRO1 else TDPPRELOJ1 end as 'Preco1',
       PROUM2 as 'UnidadeDeMedida2',
       case when TDPVALPROI >= getdate() and getdate() <= TDPVALPROF and TDPPROLOJ='S' then TDPPREPRO2*PROUM2QTD else TDPPRELOJ2*PROUM2QTD end as 'Preco2',
       case when getdate() <= TDPVALPROF and TDPPROLOJ='S' then TDPVALPROF else ' ' end as 'PromocaoValidaAte'
  from TBS031 (nolock) right join TBS010 (nolock) on PROCOD=TDPPROCOD
                             join TBS014 (nolock) on TBS014.MAREMPCOD=TBS010.MAREMPCOD and TBS014.MARCOD=TBS010.MARCOD
 where TDPPROCOD>='164' and TDPPROCOD<='164Z' and
       exists(select '' from TANBYTTE.SIBD.dbo.TBS031 as T31 (nolock)
               where T31.TDPPROCOD=TBS031.TDPPROCOD and
                     ((T31.TDPVALPROI>=getdate() and getdate()<=T31.TDPVALPROF and T31.TDPPROLOJ='S' and (T31.TDPPREPRO1<>TBS031.TDPPREPRO1 or T31.TDPPREPRO2<>TBS031.TDPPREPRO2)) or
                      T31.TDPPRELOJ1<>TBS031.TDPPRELOJ1 or T31.TDPPRELOJ2<>TBS031.TDPPRELOJ2))





select * from TBS031 (nolock) where TDPPROCOD='1640054'

print getdate()