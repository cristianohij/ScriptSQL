select (select ProdutoPai from DWGradeProdutos where CodigoGrade=PROCODGRA)
       ,PRODESWEB
	   ,GRUDES
	   ,iif(CORNOM='','TAMANHO','COR')
	   ,iif(CORNOM='',TAMDES,CORNOM)
	   ,''
	   ,''
	   ,''
	   ,''
	   ,(select TDPPRELOJ1 from TBS031 with (nolock) where TDPPROCOD=PROCOD)
	   ,0
	   ,PROPESBRU
	   ,PROEMBALT
	   ,PROEMBLAR
	   ,PROEMBPROFUN
	   ,(select ESTQTDATU-ESTQTDRES from TBS032 with (nolock) where ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD)
	   ,PROCOD
	   ,''
	   ,'SIM'
	   ,'N�O'
	   ,PRODESDET
	   ,''
	   ,''
	   ,''
	   ,MARNOM
  from TBS010 with (nolock)
  Left join TBS012 with (nolock)
       on TBS012.GRUCOD=TBS010.GRUCOD
 where PROCOD in('02410011','02410012','00060039','00060040','00060041')

select PROCOD
       ,TAMDES
	   ,CORNOM
  from TBS010 with (nolock)
 where PROCODGRA > 0

 group by PROCODGRA

select min(PROCOD)
       ,PROCODGRA
  from TBS010 with (nolock)
 where PROCODGRA > 0
 group by min(PROCOD), PROCODGRA

drop view DWGradeProdutos

create view DWGradeProdutos as
select PROCODGRA as CodigoGrade
       ,isnull((select top 1 PROCOD from TBS010 with (nolock) where PROCODGRA=tab.PROCODGRA order by PROCOD),'') as ProdutoPai
  from
  (
    select PROCODGRA
      from TBS010 A with (nolock)
     where PROCODGRA > 0
     group by PROCODGRA
  ) tab

select *
  from DWGradeProdutos

select PROCOD as codigo
       ,PRODES as descricao
	   ,PRODESWEB as descricaoWeb
	   ,TAMDES as tamanho
	   ,CORNOM as cor
	   ,PROEMBLAR as largura
	   ,PROEMBALT as altura
	   ,PROEMBPROFUN as profundidade
	   ,PROPESBRU as peso
	   ,GRUDES as grupo
       ,SUBGRUDES as subgrupo
  from TBS010 with (nolock)
  Left join TBS012 with (nolock)
       on TBS012.GRUCOD=TBS010.GRUCOD
  Left join TBS0121 with (nolock)
       on TBS0121.GRUCOD=TBS012.GRUCOD and TBS0121.SUBGRUCOD=TBS010.SUBGRUCOD
 where MARCOD=6
 order by PRODES, PROCOD




select PROCOD,PROCLAFIS,PRODES,PROSTATUS from TBS010 (nolock)
 where PROCLAFIS<>'' and PROSTATUS='A' and
       not exists(select * 
                         from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\temp\produtos-site-acrilex.xlsx', 'select * from [produtos-site-acrilex$]')
                   where codigo=PROCLAFIS collate database_default)

select * 
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')
 order by descricao

insert into TBS105
select 0
       ,Left(cor,20)
	   ,convert(date,getdate())
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')
 where cor <> ''
       and cor collate database_default not in(select CORNOM from TBS105 with (nolock))
 group by cor
 order by cor

select *
  from TBS105 with (nolock)

ALTER TABLE TBS105
ALTER COLUMN CORNOM char(35)

select Left(codigo,15)
       ,Left(descricao,60)
	   ,Left(rtrim(grupo) + ' > ' + rtrim(subgrupo),60)
	   ,iif(cor not in('NULL',''),'COR','')
	   ,Left(cor,30)
	   ,''
	   ,''
	   ,''
	   ,''
	   ,(select TDPPRELOJ1 from TBS031 with (nolock) where TDPPROCOD=codigo collate database_default)
	   ,0
	   ,peso
	   ,altura
	   ,largura
	   ,profundidade
	   ,(select ESTQTDATU-ESTQTDRES from TBS032 with (nolock) where ESTLOC=1 and TBS032.PROCOD=codigo collate database_default)
	   ,sku
	   ,''
	   ,'SIM'
	   ,'N�O'
	   ,descricao_detalhada
	   ,''
	   ,''
	   ,''
	   ,'ACRILEX'
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')

select grupo
       ,subgrupo
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')
 group by grupo, subgrupo
 order by grupo, subgrupo

drop table #grade

select codigo
       ,altura
	   ,largura
	   ,profundidade
	   ,peso
       --,count(*) conta
  --into grade
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')
 where codigo in
       (
select codigo
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')
 group by codigo
 having count(*) > 1
	   )
-- group by codigo
          --,altura
	      --,largura
	      --,profundidade
	      --,peso
-- having count(*) > 1
  order by codigo


select codigo
       ,altura
	   ,largura
	   ,profundidade
	   ,peso
	   ,row_number() over(order by codigo) as grade
  into #grade
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')
 where codigo in
       (
         select codigo
           from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')
          group by codigo
         having count(*) > 1
	   )
       and peso > 0
  order by codigo

select *
  from #grade

begin tran
update TBS010
  set PROCTRGRA='S'
      ,PROCODGRA=grade
      ,PROEMBALT=altura
	  ,PROEMBLAR=largura
	  ,PROEMBPROFUN=profundidade
	  ,PROPESLIQ=peso/1000
	  ,PROPESBRU=peso/1000
 from TBS010 with (nolock)
      inner join #grade
      on PROCOD=codigo collate database_default
commit tran

select *
 from TBS010 with (nolock)
      inner join openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')
      on PROCOD=sku collate database_default

begin tran
update TBS010
   set CORNOM=Left(cor,20)
  from TBS010 with (nolock)
       inner join openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')
       on PROCOD=sku collate database_default
commit tran

begin tran
update TBS010
  set PRODESWEB=Left(upper(descricaoWeb),60)
 from TBS010 with (nolock)
      inner join openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')
      on PROCOD=codigo collate database_default
where descricaoWeb <> ''
rollback tran
commit tran

select codigo
       ,sku
	   ,*
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')
 where codigo <> sku



  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')
 where codigo <> sku

begin tran
update TBS010
  set PROCTRGRA=isnull((select 'S' from #grade where #grade.codigo=t.codigo),'N')
      ,PROCODGRA=isnull((select grade from #grade where #grade.codigo=t.codigo),0)
      ,PROEMBALT=isnull((select altura from #grade where #grade.codigo=t.codigo),0)
	  ,PROEMBLAR=isnull((select largura from #grade where #grade.codigo=t.codigo),0)
	  ,PROEMBPROFUN=isnull((select profundidade from #grade where #grade.codigo=t.codigo),0)
	  ,PROPESLIQ=isnull((select peso/1000 from #grade where #grade.codigo=t.codigo),0)
	  ,PROPESBRU=isnull((select peso/1000 from #grade where #grade.codigo=t.codigo),0)
--select PROCOD,(select grade from #grade where #grade.codigo=t.codigo)
 from TBS010 with (nolock)
      inner join openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]') t
      on PROCOD=sku collate database_default
where codigo <> sku


rollback tran
commit tran

select *
  from #grade
 order by codigo

 where codigo='00060092'

begin tran
update TBS010
   set PROEMBALT=altura
	   ,PROEMBLAR=largura
	   ,PROEMBPROFUN=profundidade
	   ,PROPESLIQ=peso/1000
	   ,PROPESBRU=peso/1000
--select *
  from TBS010 with (nolock)
       inner join openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')
       on PROCOD=codigo collate database_default
 where not PROCOD in(select codigo collate database_default from #grade)
       and peso > 0
rollback tran
commit tran

select PROCODGRA
  from TBS010 with (nolock)
 where PROCODGRA > 0
 group by PROCODGRA

select rtrim(PROCOD)	--rtrim(isnull((select ProdutoPai from DWGradeProdutos where CodigoGrade=PROCODGRA),PROCOD))
       ,iif(PRODESWEB='',PRODES,PRODESWEB)
	   ,(select Left(rtrim(grupo) + ' > ' + rtrim(subgrupo),60) from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]') where sku=PROCOD collate database_default)
	   ,iif(CORNOM='','','COR')		--iif(CORNOM='','TAMANHO','COR')
	   ,iif(CORNOM='','',CORNOM)	--iif(CORNOM='',TAMDES,CORNOM)
	   ,''
	   ,''
	   ,''
	   ,''
	   ,isnull((select TDPPRELOJ1 from TBS031 with (nolock) where TDPPROCOD=PROCOD),0)
	   ,0
	   ,PROPESBRU
	   ,PROEMBALT
	   ,PROEMBLAR
	   ,PROEMBPROFUN
	   ,(select ESTQTDATU-ESTQTDRES from TBS032 with (nolock) where ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD)
	   ,rtrim(PROCOD)
	   ,''
	   ,'SIM'
	   ,'N�O'
	   ,convert(char(800),replace(PRODESDET,char(13)+char(10),'')) --Ltrim(rtrim(PRODESDET))
	   ,''
	   ,''
	   ,''
	   ,MARNOM
	   ,'SIM'
  from TBS010 with (nolock)
 where PROWEB='S'

update TBS010
   set PROWEB='N'

begin tran
update TBS010
   set PROWEB='S'
  from TBS010 with (nolock)
       inner join openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')
       on PROCOD=sku collate database_default
commit tran

select PROWEB
       ,*
 from TBS010 with (nolock)
      inner join openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-acrilex.xlsx', 'select * from [Planilha4$]')
      on PROCOD=sku collate database_default

select *
  from TBS010 with (nolock)
 where CORNOM is null

begin tran
update TBS010
   set CORNOM=''
 where CORNOM is null
commit tran

-- lista para "popular" tabela produtos.csv

select rtrim(PROCOD) as 'Identificador URL'
       ,dbo.CamelCase(rtrim(PRODES)) as 'Nome'
	   ,'Categoria'
	   ,'COR' as 'Nome da variação 1'
	   ,isnull((select top 1 dbo.CamelCase(rtrim(CORNOM)) from TBS105 with (nolock) where PRODES Like('%'+rtrim(CORNOM)+'%')),'') as 'Valor da variação 1'
	   ,'' as 'Nome da variação 2'
	   ,'' as 'Valor da variação 2'
	   ,'' as 'Nome da variação 3'
	   ,'' as 'Valor da variação 3'
	   ,STR(isnull((select TDPPRELOJ1 from TBS031 with (nolock) where TDPPROCOD=PROCOD),0),10,2) as 'Preço'
	   ,0 as 'Preço promocional'
	   ,0 as 'Peso (kg)'
	   ,0 as 'Altura (cm)'
	   ,0 as 'Largura (cm)'
	   ,0 as 'Comprimento (cm)'
	   ,STR((select ESTQTDATU-ESTQTDRES from TBS032 with (nolock) where ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD)) as 'Estoque'
	   ,rtrim(PROCOD) as 'SKU'
	   ,'' as 'Código de barras'
       ,'SIM' as 'Exibir na loja'
	   ,'NÃO' as 'Frete gratis'
	   ,dbo.CamelCase(rtrim(PRODESDET)) as 'Descrição'
       ,'' as 'Tags'
	   ,'' as 'Título para SEO'
	   ,'' as 'Descrição para SEO'
	   ,[dbo].[CamelCase](rtrim(MARNOM)) as 'Marca'
	   ,'SIM' as 'Produto Físico'
	   ,'' as 'MPN (Cód. Exclusivo, Modelo Fabricante)'
	   ,'' as 'Sexo'
       ,'' as 'Faixa etária'
  from TBS010 with (nolock)
 where PROWEB='S'
 order by MARNOM, PRODES


/*********************************************************
CREATED BY   :HARI NARAYAN SHARMA[Software Engineer]
Email        :  hnarayan@techaxes.com
                hari.bagra@gmail.com
CREATION DATE:MAR 30, 2007
PURPOSE     :TO CONVERT INPUT STRING IN CAMEL CASE
HOW TO USE   :SELECT dbo.CamelCase('hARi nARAyan shARMa')
**********************************************************/

CREATE Function [dbo].[CamelCase](@Str varchar(8000))
RETURNS varchar(8000) As
Begin
Declare @Result varchar(2000)
SET @Str = LOWER(@Str) + ' '
SET @Result = ''

While 1=1
Begin
        IF PATINDEX('% %',@Str) = 0 BREAK
SET @Result = @Result+UPPER(Left(@Str,1))+SubString(@Str,2,CharIndex(' ',@Str)-1)
SET @Str = SubString(@Str,CharIndex(' ',@Str)+1,Len(@Str))
End
SET @Result = Left(@Result,Len(@Result))
Return @Result
End

GO

select *
  from TBS105 with (nolock)

select REPLICATE(' ',25) as cor
 into #cores

insert into #cores 
VALUES 
('ACQUA MARINA'),
('ALARANJADO'),
('ALIZARIN CRIMSON'),
('AMARELO BEBÊ'),
('AMARELO BRILHANTE CL'),
('AMARELO CÁDMIO'),
('AMARELO CÁDMIO CLARO'),
('AMARELO CÁDMIO ESCUR'),
('AMARELO CANÁRIO'),
('AMARELO GEMA'),
('AMARELO INDIANO'),
('AMARELO LIMÃO'),
('AMARELO NÁPOLES'),
('AMARELO NÁPOLES CARN'),
('AMARELO NÁPOLES ROSA'),
('AMARELO OCRE'),
('AMARELO OURO'),
('AMARELO PELE'),
('AMARELO PERMANENTE E'),
('AMORA'),
('AREIA'),
('AZUL'),
('AZUL ARDÓSIA'),
('AZUL BEBÊ'),
('AZUL CARIBE'),
('AZUL CELESTE'),
('AZUL CERÚLEO'),
('AZUL COBALTO'),
('AZUL COUNTRY'),
('AZUL FTALOCIANINA'),
('AZUL HORTÊNCIA'),
('AZUL HORTÊNSIA'),
('AZUL INTENSO'),
('AZUL INVERNO'),
('AZUL MAR'),
('AZUL MARINHO'),
('AZUL PETRÓLEO'),
('AZUL PRÚSSIA'),
('AZUL ROYAL'),
('AZUL SOFT'),
('AZUL TURQUESA'),
('AZUL ULTRAMAR'),
('BASE MADREPÈROLA'),
('BERINJELA'),
('BRANCO'),
('BRANCO TITÂNIO'),
('CAMURÇA'),
('CAPUCCINO'),
('CAQUI'),
('CARAMELO'),
('CARMIN'),
('CASTANHO CLARO'),
('CENOURA'),
('CERÂMICA'),
('CHOCOLATE'),
('CINZA'),
('CINZA CHUMBO'),
('CINZA CLARO'),
('CINZA LUNAR'),
('CINZA ÔNIX'),
('CORAL'),
('ERVA DOCE'),
('FLAMINGO'),
('FLOR DE MALVA'),
('FUCHSIA'),
('FUMÊ'),
('GOIABA QUEIMADA'),
('GRIS NEUTRO'),
('INCOLOR'),
('JACARANDÁ'),
('JATOBA'),
('LACA DE GARANZA CLAR'),
('LACA GARANZA'),
('LACA GARANZA ROSA AN'),
('LACA MAGENTA'),
('LACA ORQUÍDEA'),
('LARANJA'),
('LARANJA DE CÁDMIO'),
('LAVANDA'),
('LILÁS'),
('LILÁS BEBÊ'),
('LILÁS SECO'),
('MAGENTA'),
('MARAVILHA'),
('MARFIM'),
('MARROM'),
('MARROM CAFÉ'),
('MARROM ESCURO'),
('MARROM VAN DYCK'),
('MAUVE'),
('MELÃO'),
('MENTA'),
('MOSTARDA'),
('OCRE OURO'),
('OURO'),
('PALHA'),
('PAPAYA'),
('PELE'),
('PÊSSEGO'),
('PINK'),
('PITAYA'),
('PRATA'),
('PRETO'),
('PÚRPURA'),
('ROSA'),
('ROSA ANTIGO'),
('ROSA BEBÊ'),
('ROSA CANDY'),
('ROSA CHÁ'),
('ROSA CICLAME'),
('ROSA ESCURO'),
('ROSA INGLESA'),
('ROSE'),
('ROSE GOLD'),
('ROSTINHO DE BONECA'),
('RÚSTICO'),
('SALMÃO'),
('SALMÃO BEBÊ'),
('SÉPIA'),
('SIENA NATURAL'),
('SOMBRA AZULADA'),
('SOMBRA NATURAL'),
('SOMBRA QUEIMADA'),
('STIL DE GRAIN PARDO'),
('TANGERINA'),
('TELHA'),
('TERRA QUEIMADA'),
('TERRA SIENA NATURAL'),
('TERRA SIENA QUEIMADA'),
('TERRA SOMBRA QUEIMAD'),
('TERRA VERDE'),
('TIJOLO'),
('TURQUESA'),
('TUTTI-FRUTTI'),
('ULTRAMAR CLARO'),
('UVA'),
('VERDE'),
('VERDE ABACATE'),
('VERDE BANDEIRA'),
('VERDE BEBÊ'),
('VERDE COUNTRY'),
('VERDE CÚPRICO CLARO'),
('VERDE DE HOOKER'),
('VERDE FOLHA'),
('VERDE GLACIAL'),
('VERDE GRAMA'),
('VERDE INGLÊS ESCURO'),
('VERDE INGLÊS Nº5'),
('VERDE KIWI'),
('VERDE MAÇÃ'),
('VERDE MAR'),
('VERDE MUSGO'),
('VERDE MUSGO CLARO'),
('VERDE OLIVA'),
('VERDE PÂNTANO'),
('VERDE PAUL VERONESE'),
('VERDE PERMANENTE CLA'),
('VERDE PERMANENTE ESC'),
('VERDE PINHEIRO'),
('VERDE PISTACHE'),
('VERDE SECO'),
('VERDE SOFT'),
('VERDE VERONESE'),
('VERDE VESSIE'),
('VERMELHO'),
('VERMELHO BEBÊ'),
('VERMELHO CÁDMIO'),
('VERMELHO CÁDMIO ALAR'),
('VERMELHO CÁDMIO CLAR'),
('VERMELHO CÁDMIO PÚRP'),
('VERMELHO CARMIM'),
('VERMELHO ESCARLATE'),
('VERMELHO FOGO'),
('VERMELHO FRANCÊS'),
('VERMELHO NATAL'),
('VERMELHO PROFUNDO'),
('VERMELHO QUEIMADO'),
('VERMELHO TOMATE'),
('VERMELHO VIVO'),
('VINHO'),
('VIOLETA'),
('VIOLETA COBALTO'),
('VIOLETA PERMANENTE E')

select *
  from #cores

delete #cores
 where cor=''

insert into TBS105
select 0
       ,cor
	   ,getdate()
  from #cores a
 where not exists(select '' from TBS105 b where a.cor=b.CORNOM)

select dbo.CamelCase(CORNOM)
  from TBS105 with (nolock)

select PROCOD
       ,PRODES
	   ,CORNOM
	   ,(select top 1 CORNOM from TBS105 with (nolock) where PRODES Like('%'+rtrim(CORNOM)+'%'))
  from TBS010 with (nolock)
 where MARCOD=6
       --and PRO(select CORNOM from TBS105 with (nolock) where  )

select PRODES
  from TBS010 with (nolock)
 where PRODES Like('%BRANCO%')


