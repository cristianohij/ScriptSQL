select PROCOD as 'codigo',
       isnull((select PRODES from TBS010 (nolock) where TBS010.PROCOD=T1.PROCOD),'') as 'descricao',
       isnull((select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=T1.PROCOD),'') as 'unidade',
       ESTQTDATU-ESTQTDRES as 'disponivel',
       ESTQTDPEN as 'pendente',
       ESTQTDCMP as 'compras',
       isnull((select PROSTATUS from TBS010 (nolock) where TBS010.PROCOD=T1.PROCOD),'') as 'status',
       isnull((select ESTQTDATU-ESTQTDRES from SIBD.dbo.TBS032 as T2 (nolock) where T2.PROCOD=T1.PROCOD and ESTLOC=2),0) as 'loja',
       isnull((select ESTQTDATU-ESTQTDRES from TANBYCD.SIBD.dbo.TBS032 as T3 where T3.PROCOD=T1.PROCOD and ESTLOC=1),0) as 'cd',
       isnull((select ESTQTDATU-ESTQTDRES from TANBYTTE.SIBD.dbo.TBS032 as T4 where T4.PROCOD=T1.PROCOD and ESTLOC=1),0) as 'retTaubate',
       isnull((select ESTQTDATU-ESTQTDRES from TANBYTTE.SIBD.dbo.TBS032 as T5 where T5.PROCOD=T1.PROCOD and ESTLOC=2),0) as 'lojTaubate'
  from SIBD.dbo.TBS032 as T1 (nolock)
 where ESTLOC=1


select PROCOD,* from TBS032 (nolock) where Len(PROCOD) < 7

select PROCOD,PRODES,ESTQTDATU from TBS032 (nolock) where not exists(select '' from TBS010 (nolock) where TBS010.PROCOD=TBS032.PROCOD)

begin tran
--delete TBS032 from TBS032 (nolock) where not exists(select '' from TBS010 (nolock) where TBS010.PROCOD=TBS032.PROCOD)
commit tran



select top 500
       PROCOD as 'CodigoDoProduto',
       ESTQTDATU as 'QtdeAtual',
       ESTQTDRES as 'QtdeReservada',
       ESTQTDATU-ESTQTDRES as 'QtdeDisponivel',
       ESTQTDPEN as 'QtdePendente',
       ESTQTDCMP as 'QtdeComprada'
  from TBS032 (nolock)
 where ESTLOC=1

select top 500
       PRODES+' ('+rtrim(PROCOD)+')' as 'Produto',
       -- tanby matriz
       isnull((select ESTQTDATU from TBS032 (nolock) where ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD),0) as 'QtdeAtual',
       isnull((select ESTQTDRES from TBS032 (nolock) where ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD),0) as 'QtdeReservada',
       isnull((select ESTQTDATU-ESTQTDRES from TBS032 (nolock) where ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD),0) as 'QtdeDisponivel',
       isnull((select ESTQTDPEN from TBS032 (nolock) where ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD),0) as 'QtdePendente',
       isnull((select ESTQTDCMP from TBS032 (nolock) where ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD),0) as 'QtdeComprada',
       -- tanby tuabté
       isnull((select ESTQTDATU from TANBYTTE.SIBD.dbo.TBS032 as T32 (nolock) where ESTLOC=1 and T32.PROCOD=TBS010.PROCOD),0) as 'QtdeAtual',
       isnull((select ESTQTDRES from TANBYTTE.SIBD.dbo.TBS032 as T32 (nolock) where ESTLOC=1 and T32.PROCOD=TBS010.PROCOD),0) as 'QtdeReservada',
       isnull((select ESTQTDATU-ESTQTDRES from TANBYTTE.SIBD.dbo.TBS032 as T32 (nolock) where ESTLOC=1 and T32.PROCOD=TBS010.PROCOD),0) as 'QtdeDisponivel',
       isnull((select ESTQTDPEN from TANBYTTE.SIBD.dbo.TBS032 as T32 (nolock) where ESTLOC=1 and T32.PROCOD=TBS010.PROCOD),0) as 'QtdePendente',
       isnull((select ESTQTDCMP from TANBYTTE.SIBD.dbo.TBS032 as T32 (nolock) where ESTLOC=1 and T32.PROCOD=TBS010.PROCOD),0) as 'QtdeComprada'
       -- tanby cd
  from TBS010 (nolock)


select --top 500
       PRODES+' ('+rtrim(PROCOD)+')' as 'Produto',
       -- tanby matriz
       isnull((select str(ESTQTDATU,12,4)+' '+str(ESTQTDRES,12,4)+' '+str(ESTQTDATU-ESTQTDRES,12,4)+' '+str(ESTQTDPEN,12,4)+' '+str(ESTQTDCMP,12,4) from TANBYM.SIBD.dbo.TBS032 where PROEMPCOD=0 and ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD),'') as 'TanbyMatriz',
       -- tanby tuabté
       isnull((select str(ESTQTDATU,8,4)+' '+str(ESTQTDRES,8,4)+' '+str(ESTQTDATU-ESTQTDRES,8,4)+' '+str(ESTQTDPEN,8,4)+' '+str(ESTQTDCMP,8,4) from TANBYTTE.SIBD.dbo.TBS032 where PROEMPCOD=0 and ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD),'') as 'TanbyTauabte',
       -- tanby cd
       isnull((select str(ESTQTDATU,8,4)+' '+str(ESTQTDRES,8,4)+' '+str(ESTQTDATU-ESTQTDRES,8,4)+' '+str(ESTQTDPEN,8,4)+' '+str(ESTQTDCMP,8,4) from TANBYCD.SIBD.dbo.TBS032 where PROEMPCOD=0 and ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD),'') as 'TanbyCD',
       -- best bag
       isnull((select str(ESTQTDATU,8,4)+' '+str(ESTQTDRES,8,4)+' '+str(ESTQTDATU-ESTQTDRES,8,4)+' '+str(ESTQTDPEN,8,4)+' '+str(ESTQTDCMP,8,4) from BESTBAG.SIBD.dbo.TBS032 where PROEMPCOD=0 and ESTLOC=1 and TBS032.PROCOD collate database_default=TBS010.PROCOD),'') as 'BestBag',
       -- best office
       isnull((select str(ESTQTDATU,8,4)+' '+str(ESTQTDRES,8,4)+' '+str(ESTQTDATU-ESTQTDRES,8,4)+' '+str(ESTQTDPEN,8,4)+' '+str(ESTQTDCMP,8,4) from BOFFICE.SIBD.dbo.TBS032 where PROEMPCOD=0 and ESTLOC=1 and TBS032.PROCOD collate database_default=TBS010.PROCOD),'') as 'BestOffice',
       -- misaspel
       isnull((select str(ESTQTDATU,8,4)+' '+str(ESTQTDRES,8,4)+' '+str(ESTQTDATU-ESTQTDRES,8,4)+' '+str(ESTQTDPEN,8,4)+' '+str(ESTQTDCMP,8,4) from MISASPEL.SIBD.dbo.TBS032 where PROEMPCOD=0 and ESTLOC=1 and TBS032.PROCOD collate database_default=TBS010.PROCOD),'') as 'Misaspel',
       -- papelyna
       isnull((select str(ESTQTDATU,8,4)+' '+str(ESTQTDRES,8,4)+' '+str(ESTQTDATU-ESTQTDRES,8,4)+' '+str(ESTQTDPEN,8,4)+' '+str(ESTQTDCMP,8,4) from PAPELYNA.SIBD.dbo.TBS032 where PROEMPCOD=0 and ESTLOC=1 and TBS032.PROCOD  collate database_default=TBS010.PROCOD),'') as 'Papelyna'
  from TANBYM.SIBD.dbo.TBS010
 where PROCOD='1640054'



select --top 500
       TM10.PRODES+' ('+rtrim(TM10.PROCOD)+')' as 'Produto',
       -- tanby matriz
       str(TM32.ESTQTDATU,12,4)+' '+str(TM32.ESTQTDRES,12,4)+' '+str(TM32.ESTQTDATU-TM32.ESTQTDRES,12,4)+' '+str(TM32.ESTQTDPEN,12,4)+' '+str(TM32.ESTQTDCMP,12,4) as 'TanbyMatriz',
       -- tanby tuabté
--       isnull((select str(ESTQTDATU,8,4)+' '+str(ESTQTDRES,8,4)+' '+str(ESTQTDATU-ESTQTDRES,8,4)+' '+str(ESTQTDPEN,8,4)+' '+str(ESTQTDCMP,8,4) from TANBYTTE.SIBD.dbo.TBS032 where PROEMPCOD=0 and ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD),'') as 'TanbyTauabte',
       -- tanby cd
--       isnull((select str(ESTQTDATU,8,4)+' '+str(ESTQTDRES,8,4)+' '+str(ESTQTDATU-ESTQTDRES,8,4)+' '+str(ESTQTDPEN,8,4)+' '+str(ESTQTDCMP,8,4) from TANBYCD.SIBD.dbo.TBS032 where PROEMPCOD=0 and ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD),'') as 'TanbyCD' --,
       -- best bag
--       isnull((select str(ESTQTDATU,8,4)+' '+str(ESTQTDRES,8,4)+' '+str(ESTQTDATU-ESTQTDRES,8,4)+' '+str(ESTQTDPEN,8,4)+' '+str(ESTQTDCMP,8,4) from BESTBAG.SIBD.dbo.TBS032 where PROEMPCOD=0 and ESTLOC=1 and TBS032.PROCOD collate database_default=TBS010.PROCOD),'') as 'BestBag',
       str(BB32.ESTQTDATU,8,4)+' '+str(BB32.ESTQTDRES,8,4)+' '+str(BB32.ESTQTDATU-BB32.ESTQTDRES,8,4)+' '+str(BB32.ESTQTDPEN,8,4)+' '+str(BB32.ESTQTDCMP,8,4) as 'BestBag'
       -- best office
--       isnull((select str(ESTQTDATU,8,4)+' '+str(ESTQTDRES,8,4)+' '+str(ESTQTDATU-ESTQTDRES,8,4)+' '+str(ESTQTDPEN,8,4)+' '+str(ESTQTDCMP,8,4) from BOFFICE.SIBD.dbo.TBS032 where PROEMPCOD=0 and ESTLOC=1 and TBS032.PROCOD collate database_default=TBS010.PROCOD),'') as 'BestOffice',
       -- misaspel
--       isnull((select str(ESTQTDATU,8,4)+' '+str(ESTQTDRES,8,4)+' '+str(ESTQTDATU-ESTQTDRES,8,4)+' '+str(ESTQTDPEN,8,4)+' '+str(ESTQTDCMP,8,4) from MISASPEL.SIBD.dbo.TBS032 where PROEMPCOD=0 and ESTLOC=1 and TBS032.PROCOD collate database_default=TBS010.PROCOD),'') as 'Misaspel',
       -- papelyna
--       isnull((select str(ESTQTDATU,8,4)+' '+str(ESTQTDRES,8,4)+' '+str(ESTQTDATU-ESTQTDRES,8,4)+' '+str(ESTQTDPEN,8,4)+' '+str(ESTQTDCMP,8,4) from PAPELYNA.SIBD.dbo.TBS032 where PROEMPCOD=0 and ESTLOC=1 and TBS032.PROCOD  collate database_default=TBS010.PROCOD),'') as 'Papelyna'
  from TANBYM.SIBD.dbo.TBS010 as TM10 (nolock)
          join TANBYM.SIBD.dbo.TBS032 as TM32 (nolock) on TM32.PROEMPCOD=TM10.PROEMPCOD and TM32.PROCOD collate database_default=TM10.PROCOD
          join BESTBAG.SIBD.dbo.TBS032 as BB32 (nolock) on BB32.PROEMPCOD=TM10.PROEMPCOD and BB32.PROCOD collate database_default=TM10.PROCOD
 where TM10.PROCOD='1640054' and
       TM32.ESTLOC=1 and
       BB32.ESTLOC=1


declare @ProdutoDe char(15),@ProdutoAte char(15),@CodigoDaMarca smallint,@NomeDaMarca char(30),@Status char(1)

set @Status='A'

set @ProdutoDe=''
set @ProdutoAte=''

set @CodigoDaMarca=108
set @NomeDaMarca=''

select rtrim(MARNOM)+' ('+ltrim(str(TBS010.MARCOD,4))+')' as 'NomeECodigoDaMarca',
       TBS010.PROCOD as 'CodigoDoProduto',
       TBS010.PRODES as 'DescricaoDoProduto',
       PROUM1 as 'UnidadeDeMedida',
       isnull(TM32E1.ESTQTDATU-TM32E1.ESTQTDRES,0) as 'QtdeDisponivelEstoque1TanbyMatriz',
       isnull(TM32E2.ESTQTDATU-TM32E2.ESTQTDRES,0) as 'QtdeDisponivelEstoque2TanbyMatriz',
       isnull(TM32E1.ESTQTDCMP,0) as 'QtdeCompradaTanbyMatriz',
       isnull(TT32E1.ESTQTDATU-TT32E1.ESTQTDRES,0) as 'QtdeDisponivelEstoque1TanbyTaubate',
       isnull(TT32E2.ESTQTDATU-TT32E2.ESTQTDRES,0) as 'QtdeDisponivelEstoque2TanbyTaubate',
       isnull(TT32E1.ESTQTDCMP,0) as 'QtdeCompradaTanbyTaubate',
       isnull(CD32E1.ESTQTDATU-CD32E1.ESTQTDRES,0) as 'QtdeDisponivelEstoque1TanbyCD',
       isnull(CD32E2.ESTQTDATU-CD32E2.ESTQTDRES,0) as 'QtdeDisponivelEstoque2TanbyCD',
       isnull(CD32E1.ESTQTDCMP,0) as 'QtdeCompradaTanbyCD',
       isnull(BB32E1.ESTQTDATU-BB32E1.ESTQTDRES,0) as 'QtdeDisponivelEstoque1BestBag',
       isnull(BB32E2.ESTQTDATU-BB32E2.ESTQTDRES,0) as 'QtdeDisponivelEstoque2BestBag',
       isnull(BB32E1.ESTQTDCMP,0) as 'QtdeCompradaBestBag',
       isnull(M32E1.ESTQTDATU-M32E1.ESTQTDRES,0) as 'QtdeDisponivelEstoque1Misaspel',
       isnull(M32E2.ESTQTDATU-M32E2.ESTQTDRES,0) as 'QtdeDisponivelEstoque2Misaspel',
       isnull(M32E1.ESTQTDCMP,0) as 'QtdeCompradaMisaspel',
       isnull(P32E1.ESTQTDATU-P32E1.ESTQTDRES,0) as 'QtdeDisponivelEstoque1Papelyna',
       isnull(P32E1.ESTQTDCMP,0) as 'QtdeCompradaPapelyna'
  from TBS010 (nolock)
          left join TBS032 as TM32E1 (nolock) on TM32E1.PROEMPCOD=TBS010.PROEMPCOD and TM32E1.PROCOD=TBS010.PROCOD and TM32E1.ESTLOC=1
          left join TBS032 as TM32E2 (nolock) on TM32E2.PROEMPCOD=TBS010.PROEMPCOD and TM32E2.PROCOD=TBS010.PROCOD and TM32E2.ESTLOC=2
          --left join TANBYM.SIBD.dbo.TBS032 as TM32E1 (nolock) on TM32E1.PROEMPCOD=TBS010.PROEMPCOD and TM32E1.PROCOD=TBS010.PROCOD and TM32E1.ESTLOC=1
          --left join TANBYM.SIBD.dbo.TBS032 as TM32E2 (nolock) on TM32E2.PROEMPCOD=TBS010.PROEMPCOD and TM32E2.PROCOD=TBS010.PROCOD and TM32E2.ESTLOC=2
          left join TANBYT.SIBD.dbo.TBS032 as TT32E1 (nolock) on TT32E1.PROEMPCOD=TBS010.PROEMPCOD and TT32E1.PROCOD=TBS010.PROCOD and TT32E1.ESTLOC=1
          left join TANBYT.SIBD.dbo.TBS032 as TT32E2 (nolock) on TT32E2.PROEMPCOD=TBS010.PROEMPCOD and TT32E2.PROCOD=TBS010.PROCOD and TT32E2.ESTLOC=2
          left join TANBYC.SIBD.dbo.TBS032 as CD32E1 (nolock) on CD32E1.PROEMPCOD=TBS010.PROEMPCOD and CD32E1.PROCOD=TBS010.PROCOD and CD32E1.ESTLOC=1
          left join TANBYC.SIBD.dbo.TBS032 as CD32E2 (nolock) on CD32E2.PROEMPCOD=TBS010.PROEMPCOD and CD32E2.PROCOD=TBS010.PROCOD and CD32E2.ESTLOC=2
          left join BESTBAG.SIBD2.dbo.TBS032 as BB32E1 (nolock) on BB32E1.PROEMPCOD=TBS010.PROEMPCOD and BB32E1.PROCOD collate database_default=TBS010.PROCOD and BB32E1.ESTLOC=1
          left join BESTBAG.SIBD2.dbo.TBS032 as BB32E2 (nolock) on BB32E2.PROEMPCOD=TBS010.PROEMPCOD and BB32E2.PROCOD collate database_default=TBS010.PROCOD and BB32E2.ESTLOC=2
          left join MISASPEL.SIBD.dbo.TBS032 as M32E1 (nolock) on M32E1.PROEMPCOD=TBS010.PROEMPCOD and M32E1.PROCOD collate database_default=TBS010.PROCOD and M32E1.ESTLOC=1
          left join MISASPEL.SIBD.dbo.TBS032 as M32E2 (nolock) on M32E2.PROEMPCOD=TBS010.PROEMPCOD and M32E2.PROCOD collate database_default=TBS010.PROCOD and M32E2.ESTLOC=2
          left join PAPELYNA.SIBD.dbo.TBS032 as P32E1 (nolock) on P32E1.PROEMPCOD=TBS010.PROEMPCOD and P32E1.PROCOD=TBS010.PROCOD and P32E1.ESTLOC=1
 where TBS010.PROSTATUS between @Status and case when @Status='' then 'Z' else @Status end and
       TBS010.PROCOD between @ProdutoDe and case when @ProdutoAte='' then 'Z' else @ProdutoAte end and
       TBS010.MARCOD between @CodigoDaMarca and case when @CodigoDaMarca=0 then 9999 else @CodigoDaMarca end and
       TBS010.MARNOM between @NomeDaMarca and case when @NomeDaMarca='' then 'Z' else @NomeDaMarca end


create view SaldosEstoquesTanbyMatrizFiliais as
select TBS010.PROCOD as 'CodigoDoProduto',
       TBS010.PRODES as 'DescricaoDoProduto',
       PROUM1 as 'UnidadeDeMedida',
       isnull(TM32E1.ESTQTDATU-TM32E1.ESTQTDRES,0) as 'QtdeDisponivelEstoque1',
       isnull(TM32E2.ESTQTDATU-TM32E2.ESTQTDRES,0) as 'QtdeDisponivelEstoque2',
       isnull(TM32E1.ESTQTDCMP,0) as 'QtdeCompradaTanbyMatriz',
       isnull(TT32E1.ESTQTDATU-TT32E1.ESTQTDRES,0) as 'QtdeDisponivelEstoque1TanbyTaubate',
       isnull(TT32E2.ESTQTDATU-TT32E2.ESTQTDRES,0) as 'QtdeDisponivelEstoque2TanbyTaubate',
       isnull(TT32E1.ESTQTDCMP,0) as 'QtdeCompradaTanbyTaubate',
       isnull(CD32E1.ESTQTDATU-CD32E1.ESTQTDRES,0) as 'QtdeDisponivelEstoque1TanbyCD',
       isnull(CD32E2.ESTQTDATU-CD32E2.ESTQTDRES,0) as 'QtdeDisponivelEstoque2TanbyCD',
       isnull(CD32E1.ESTQTDCMP,0) as 'QtdeCompradaTanbyCD'
  from TBS010 (nolock)
          left join TBS032 as TM32E1 (nolock) on TM32E1.PROEMPCOD=TBS010.PROEMPCOD and TM32E1.PROCOD=TBS010.PROCOD and TM32E1.ESTLOC=1
          left join TBS032 as TM32E2 (nolock) on TM32E2.PROEMPCOD=TBS010.PROEMPCOD and TM32E2.PROCOD=TBS010.PROCOD and TM32E2.ESTLOC=2
          left join TANBYT.SIBD.dbo.TBS032 as TT32E1 (nolock) on TT32E1.PROEMPCOD=TBS010.PROEMPCOD and TT32E1.PROCOD=TBS010.PROCOD and TT32E1.ESTLOC=1
          left join TANBYT.SIBD.dbo.TBS032 as TT32E2 (nolock) on TT32E2.PROEMPCOD=TBS010.PROEMPCOD and TT32E2.PROCOD=TBS010.PROCOD and TT32E2.ESTLOC=2
          left join TANBYC.SIBD.dbo.TBS032 as CD32E1 (nolock) on CD32E1.PROEMPCOD=TBS010.PROEMPCOD and CD32E1.PROCOD=TBS010.PROCOD and CD32E1.ESTLOC=1
          left join TANBYC.SIBD.dbo.TBS032 as CD32E2 (nolock) on CD32E2.PROEMPCOD=TBS010.PROEMPCOD and CD32E2.PROCOD=TBS010.PROCOD and CD32E2.ESTLOC=2
go

select * from SaldosEstoquesTanbyMatrizFiliais where CodigoDoProduto between '164' and '164Z'

select * from TANBYT.SIBD.dbo.TBS001 (nolock)
select top 1 * from TANBYT.SIBD.dbo.TBS032 (nolock)



print 'select SIBD.dbo.SaldosEmEstoque('''+'1640054'+''',1)'

declare @var char(60)

select top 5
       PRODES+' ('+rtrim(PROCOD)+')' as 'Produto',
       -- tanby matriz
       --(select * from openquery(TANBYM,'select SIBD.dbo.SaldosEmEstoque(''1640054'',1)'))
       --exec('select SIBD.dbo.SaldosEmEstoque('''+'1640054'+''',1)') at TANBYM
       (select * from openquery(TANBYM,'select SIBD.dbo.SaldosEmEstoque('''+1640054+''',1)'))
       -- tanby tuabté
--       exec('select SIBD.dbo.SaldosEmEstoque(''1640054'',1)') at TANBYTTE,
       -- tanby cd
--       exec('select SIBD.dbo.SaldosEmEstoque(''1640054'',1)') at TANBYCD
  from TANBYM.SIBD.dbo.TBS010



drop function SaldosEmEstoque
go

create function SaldosEmEstoque(@CodigoDoProduto as char(15),@LocalDoEstoque char(1)) returns char(60) as
   begin
      declare @resultado char(60)

      set @resultado = isnull((select str(ESTQTDATU,12,4)+str(ESTQTDRES,12,4)+str(ESTQTDATU-ESTQTDRES,12,4)+str(ESTQTDPEN,12,4)+str(ESTQTDCMP,12,4)
                                 from TBS032 (nolock) where ESTLOC=@LocalDoEstoque and TBS032.PROCOD=@CodigoDoProduto),'')
                      
      return @resultado
   end
go


-- teste
select dbo.SaldosEmEstoque('1640054',1)

select TANBYTTE.SIBD.dbo.SaldosEmEstoque('1640054',1)

select * from openquery(TANBYTTE,'select SIBD.dbo.SaldosEmEstoque(''1640054'',1)')

select * from openquery(TANBYM,'select UFESIG from TBS001')

declare @codigo char(7),@resultado char(60)
set @codigo='1640054'
set @resultado=''

exec('select @resultado= SIBD.dbo.SaldosEmEstoque('''+@codigo+''',1)') at TANBYM

declare @var char(60)

set @var = exec('SIBD.dbo.SaldosEmEstoque(1640054,1)') at TANBYM)

select TANBYM.SIBD.dbo.SaldosEmEstoque('1640054',1) at TANBYM


sp_executesql N'select * from TANBYM.SIBD.dbo.TBS001 where UFESIG=@uf',N'@uf char(2)',@uf='SP';

sp_executesql 'select SIBD.dbo.SaldosEmEstoque(@produto,@estoque)','@produto char(15)',@produto='1640054','@estoque smallint',@estoque=1


declare @codigo char(7),@resultado char(60),@query varchar(100)
set @codigo='1640054'
set @resultado=''

set @query = 'select * from openQuery(TANBYTTE,'+'''select SIBD.dbo.SaldosEmEstoque('''''+rtrim(@codigo)+''''',1)'''+')'

exec (@query)

print @query

select * from openquery(TANBYTTE,'select SIBD.dbo.SaldosEmEstoque(''1640054'',1)')


drop function BuscaSaldosEmEstoque
go

create function BuscaSaldosEmEstoque(@CodigoDoProduto as varchar(15),@LocalDoEstoque smallint) returns char(60) as
   begin
      declare @query nvarchar(100),@resultado nvarchar(60) --,@CodigoDoProduto varchar(15),@LocalDoEstoque smallint

      --set @query = 'select * from openQuery(TANBYTTE,'+'''select SIBD.dbo.SaldosEmEstoque('''''+rtrim(@CodigoDoProduto)+''''',1)'''+')'

      --exec sp_executesql @query, N'@resultado varchar(60) output', @resultado output

      -- teste
      set @CodigoDoProduto='1640054'
      set @LocalDoEstoque=1
      --set @query = 'select SIBD.dbo.SaldosEmEstoque('''+@CodigoDoProduto+''','+str(@LocalDoEstoque,1)+')'

      --select @query

      --exec(@query) at TANBYM

      -- teste
      set @query = 'select * from openquery(TANBYM,'''''+'select SIBD.dbo.SaldosEmEstoque('''''+@CodigoDoProduto+''''','+str(@LocalDoEstoque,1)+')'')'

--select @query
      exec(@query)


      return @resultado
   end
go

select dbo.BuscaSaldosEmEstoque('1640054',1)

drop procedure sp_SaldosEmEstoque
go

create procedure sp_SaldosEmEstoque(@CodigoDoProduto char(15),@LocalDoEstoque int,@retorno varchar(60) output) as
   set @retorno = isnull((select str(ESTQTDATU,12,4)+str(ESTQTDRES,12,4)+str(ESTQTDATU-ESTQTDRES,12,4)+str(ESTQTDPEN,12,4)+str(ESTQTDCMP,12,4)
                            from SIBD.dbo.TBS032 (nolock)
                           where ESTLOC=@LocalDoEstoque and TBS032.PROCOD=@CodigoDoProduto),'')
go


select TANBYM.SIBD.dbo.sp_SaldosEmEstoque('1640054',1)

declare @retorno varchar(60)

exec TANBYM.SIBD.dbo.sp_SaldosEmEstoque @CodigoDoProduto=N'1640054',@LocalDoEstoque=1,@retorno=@retorno output

select @retorno



select * from openquery(TANBYM,'select ESTQTDATU from SIBD.dbo.TBS032 (nolock) where ESTLOC=1 and PROCOD=''1640054''') -- 7s

select ESTQTDATU from TANBYM.SIBD.dbo.TBS032 where PROEMPCOD=0 and ESTLOC=1 and PROCOD='1640054' order by PROEMPCOD,ESTLOC,PROCOD -- 4s


select * from openquery(TANBYM,'select SIBD.dbo.SaldosEmEstoque(''1640054'',1)')
select * from openquery(TANBYTTE,'select SIBD.dbo.SaldosEmEstoque(''1640054'',1)')


select * from openrowset ('SQLNCLI','TANBYM';'si';'123','select ESTQTDATU from TBS032 (nolock) where ESTLOC=1 and PROCOD=''1640054''')


declare @teste char(60)

select @teste=(exec('select SIBD.dbo.SaldosEmEstoque('''+'1640054'+''',1)') at TANBYM) from TANBYM.SIBD.dbo.TBS001 (nolock)

declare @codigo char(15)
set @codigo='1640054'

declare @teste char(60),@teste2 char(60)

select @teste2 = exec @teste = TANBYM.SIBD.dbo.SaldosEmEstoque '1640054', 1

print @teste

select 'teste'=UFESIG from TANBYM.SIBD.dbo.TBS001 (nolock)