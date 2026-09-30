-- formulas da nota fiscal de sa�da

-- NFSQTD = quantidade do produto
-- NFSPRE = preco do produto

-- NFSPDDITE = percentual do desconto por item
-- NFSTOTPRO = valor total do produto = NFSPRE * NFSQTD

drop function NFSTOTPRO
go

create function NFSTOTPRO(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select NFSPRE * NFSQTD from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- NFSVDDITE = valor do desconto por item = NFSTOTPRO * NFSPDDITE / 100

drop function NFSVDDITE
go

create function NFSVDDITE(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.NFSTOTPRO(@empresa,@nf,@seremp,@serie,@item) * NFSPDDITE / 100 from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- NFSFREITE    = porcentagem do frete por item
-- NFSFREITEVAL = valor do frete por item = NFSTOTPRO * NFSFREITE / 100

drop function NFSFREITEVAL
go

create function NFSFREITEVAL(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.NFSTOTPRO(@empresa,@nf,@seremp,@serie,@item) * NFSFREITE / 100 from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- NFSSEGITE    = porcentagem do seguro por item
-- NFSSEGITEVAL = valor do seguro por item = NFSTOTPRO * NFSSEGITE / 100

drop function NFSSEGITEVAL
go

create function NFSSEGITEVAL(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.NFSTOTPRO(@empresa,@nf,@seremp,@serie,@item) * NFSSEGITE / 100 from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- NFSDESITE    = porcentagem de outras despesas por item
-- NFSDESITEVAL = valor de outras despesas por item = NFSTOTPRO * NFSDESITE / 100

drop function NFSDESITEVAL
go

create function NFSDESITEVAL(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.NFSTOTPRO(@empresa,@nf,@seremp,@serie,@item) * NFSDESITE / 100 from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- NFSTOTITE = valor total do item = NFSTOTPRO - NFSVDDITE + NFSFREITEVAL + NFSSEGITEVAL + NFSDESITEVAL

drop function NFSTOTITE
go

create function NFSTOTITE(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select round(dbo.NFSTOTPRO(@empresa,@nf,@seremp,@serie,@item) - dbo.NFSVDDITE(@empresa,@nf,@seremp,@serie,@item) +
                             dbo.NFSFREITEVAL(@empresa,@nf,@seremp,@serie,@item) + dbo.NFSSEGITEVAL(@empresa,@nf,@seremp,@serie,@item) +
                             dbo.NFSDESITEVAL(@empresa,@nf,@seremp,@serie,@item),2)
                        from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- NFSPRELIQ = preco liquido com desconto = NFSTOTITE / NFSQTD

drop function NFSPRELIQ
go

create function NFSPRELIQ(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.NFSTOTITE(@empresa,@nf,@seremp,@serie,@item) / NFSQTD from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- NFSPERICMS = porcentagem do ICMS
-- NFSBASICMS = valor da base de calculo do ICMS = NFSTOTITE * NFSPBI / 100
-- NFSREDBCICMS = Porcentagem para redu��o da BC do ICMS

drop function NFSBASICMS
go

create function NFSBASICMS(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)

      set @retorno = (select case
                                when NFSPERICMS > 0
                                   then
                                      round(dbo.NFSTOTITE(@empresa,@nf,@seremp,@serie,@item) * (100 - NFSREDBCICMS) / 100 ,2)
                                   else
                                      0
                             end
                        from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- NFSVALICMS = valor do ICMS = NFSBASICMS * NFSPERICMS / 100

drop function NFSVALICMS
go

create function NFSVALICMS(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select round(dbo.NFSBASICMS(@empresa,@nf,@seremp,@serie,@item) * NFSPERICMS / 100 ,2) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- NFSVALICMS    = porcentagem para a base de calculo do ICMS (isento)
-- NFSBASICMSISE = valor da base de calculo do ICMS (isento) = (NFSTOTPRO + NFSFREITEVAL + NFSSEGITEVAL + NFSDESITEVAL) * NFSPBIISE / 100

drop function NFSBASICMSISE
go

create function NFSBASICMSISE(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select (dbo.NFSTOTPRO(@empresa,@nf,@seremp,@serie,@item) + dbo.NFSFREITEVAL(@empresa,@nf,@seremp,@serie,@item) +
                              dbo.NFSSEGITEVAL(@empresa,@nf,@seremp,@serie,@item) + dbo.NFSDESITEVAL(@empresa,@nf,@seremp,@serie,@item)) *
                              NFSPBIISE / 100
                        from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- NFSPERICMSISE = porcentagem do ICMS (isento)
-- NFSVALICMSISE = valor do ICMS (isento) = NFSBASICMSISE * NFSPERICMSISE / 100

drop function NFSVALICMSISE
go

create function NFSVALICMSISE(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.NFSBASICMSISE(@empresa,@nf,@seremp,@serie,@item) * NFSPERICMSISE / 100 from TBS0671 (nolock)
                      where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- NFSMVA          = margem do valor agregado
-- NFSVALAGR       = valor agregado = iif(NFSPBIST > 0, (NFSTOTITE + NFSVDDITE) * NFSPBIST / 100 * NFSMVA / 100, 0)

drop function NFSVALAGR
go

create function NFSVALAGR(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when NFSPERICMSST > 0
                                   then
                                      round(dbo.NFSTOTITE(@empresa,@nf,@seremp,@serie,@item) * (100 - NFSREDBCICMSST) / 100 * NFSMVA / 100 ,2)
                                   else
                                      0
                             end
                        from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- NFSBASICMSST    = valor para a base de calculo do ICMS-ST = iif(NFSPBIST > 0, NFSTOTITE + NFSVDDITE + NFSVALAGR, 0)

drop function NFSBASICMSST
go

create function NFSBASICMSST(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when NFSPERICMSST > 0
                                   then
                                      round(dbo.NFSTOTITE(@empresa,@nf,@seremp,@serie,@item) + dbo.NFSVALAGR(@empresa,@nf,@seremp,@serie,@item) ,2)
                                   else
                                      0
                             end
                        from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- NFSPERICMSST    = porcentagem do ICMS-ST
-- NFSVALICMSST    = valor do ICMS-ST = iif(NFSPBIST > 0, NFSBASICMSST * NFSPERICMSST / 100, 0)

drop function NFSVALICMSST
go

create function NFSVALICMSST(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.NFSBASICMSST(@empresa,@nf,@seremp,@serie,@item) * NFSPERICMSST / 100
                        from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- ICMS ST DIFAL = [(V oper - ICMS origem) / (1 - ALQ interna)] x ALQ interna - (V oper x ALQ interestadual)

-- V oper = NFSTOTITE(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint)
-- ICMS origem = valor do ICMS da opera��o pr�pria = NFSVALICMS(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint)
-- ALQ interna: do estado de destino
-- (V oper x ALQ interestadual) = ICMS origem = valor do ICMS da opera��o pr�pria = NFSVALICMS(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint)

drop function NFSVALICMSST
go

create function NFSVALICMSST(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when NFSMVA > 0 then
                                   dbo.NFSBASICMSST(@empresa,@nf,@seremp,@serie,@item) * NFSPERICMSST / 100
                                else
                                   round((dbo.NFSTOTITE(@empresa,@nf,@seremp,@serie,@item) - dbo.NFSVALICMS(@empresa,@nf,@seremp,@serie,@item)) / (1 - ((NFSPERICMS + NFSPERICMSST)/100)) * ((NFSPERICMS + NFSPERICMSST)/100) - dbo.NFSVALICMS(@empresa,@nf,@seremp,@serie,@item),2)
                             end
                        from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- NFSVALICMSSTRET = valor do ICMS-ST retido = iif(NFSPBIST > 0, NFSVALICMSST - NFSVALICMS, 0)

drop function NFSVALICMSSTRET
go

create function NFSVALICMSSTRET(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when NFSPERICMSST > 0
                                   then
                                      case
                                         when NFSMVA > 0 then dbo.NFSVALICMSST(@empresa,@nf,@seremp,@serie,@item) - dbo.NFSVALICMS(@empresa,@nf,@seremp,@serie,@item)
                                         else dbo.NFSVALICMSST(@empresa,@nf,@seremp,@serie,@item)
                                      end 
                                   else
                                      0
                             end
                        from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go


-- n�o existe a f�rmula no Genexus

drop function NFSTOTICMSSTRET
go

create function NFSTOTICMSSTRET(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFSVALICMSSTRET(@empresa,@nf,@seremp,@serie,NFSITE)),0) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie)
      return @retorno
   end
go


-- NFSTOTITEST = valor total do item + valor do ICMS-ST = iif(NFSPBIST > 0, NFSTOTITE + NFSVALICMSSTRET, NFSTOTITE)

drop function NFSTOTITEST
go

create function NFSTOTITEST(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when NFSPERICMSST > 0
                                   then
                                      dbo.NFSTOTITE(@empresa,@nf,@seremp,@serie,@item) + dbo.NFSVALICMSSTRET(@empresa,@nf,@seremp,@serie,@item)
                                   else
                                      dbo.NFSTOTITE(@empresa,@nf,@seremp,@serie,@item)
                             end
                        from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go


-- NFSVALDPL = valor da duplicata por item

drop function NFSVALDPL
go

create function NFSVALDPL(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when NFSCPGDUP='S' and NFSTESDPL='S'
                                   then
                                      dbo.NFSTOTITEST(@empresa,@nf,@seremp,@serie,@item) -
                                      case NFSDESICMS
                                         when 'S'
                                            then
                                               dbo.NFSVALICMS(@empresa,@nf,@seremp,@serie,@item)
                                            else
                                               0
                                      end
                                   else
                                      0
                             end
                        from TBS0671 (nolock) join TBS067 (nolock) on TBS0671.NFSEMPCOD = TBS067.NFSEMPCOD and TBS0671.SNEEMPCOD = TBS067.SNEEMPCOD and
                                                                      TBS0671.SNESER = TBS067.SNESER and TBS0671.NFSNUM = TBS067.NFSNUM
                       where TBS0671.NFSEMPCOD = @empresa and TBS0671.NFSNUM = @nf and TBS0671.SNEEMPCOD = @seremp and TBS0671.SNESER = @serie and
                             TBS0671.NFSITE = @item)
      return @retorno
   end
go


-- NFSVALCUS
-- round(NFSQTD * NFSPRECUS ,2)

drop function NFSVALCUS
go

create function NFSVALCUS(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,2) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select round(NFSQTD * NFSPRECUS ,2)
                        from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go

-- NFSPERLUC = percentual de lucro sobre a venda
-- iif(NFSPRECUS > 0 .AND. NFSPRELIQ > 0, (1 - (NFSPRECUS / (NFSPRELIQ + iif(NFSDESICMS = 'S', NFSVDDITE, 0)))) * 100, 0)
d( iif(NFSPRECUS > 0 and (NFSTOTITE + iif(NFSDESICMS='S',NFSVDDITE,0)) > 0 , (1-NFSVALCUS/(NFSTOTITE+iif(NFSDESICMS='S',NFSVDDITE,0)))*100 , 0 ) ,4)

-- novo

drop function NFSPERLUC
go

create function NFSPERLUC(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when NFSPRECUS > 0 and dbo.NFSTOTITE(@empresa,@nf,@seremp,@serie,@item) + iif(NFSDESICMS='S',dbo.NFSVDDITE(@empresa,@nf,@seremp,@serie,@item),0) > 0
                                   then
                                      (1 - dbo.NFSVALCUS(@empresa,@nf,@seremp,@serie,@item) / (dbo.NFSTOTITE(@empresa,@nf,@seremp,@serie,@item) + iif(NFSDESICMS='S',dbo.NFSVDDITE(@empresa,@nf,@seremp,@serie,@item),0)))*100
                                   else
                                      0
                             end
                        from TBS0671 (nolock) join TBS067 (nolock) on TBS0671.NFSEMPCOD = TBS067.NFSEMPCOD and TBS0671.SNEEMPCOD = TBS067.SNEEMPCOD and
                                                                      TBS0671.SNESER = TBS067.SNESER and TBS0671.NFSNUM = TBS067.NFSNUM
                       where TBS0671.NFSEMPCOD = @empresa and TBS0671.NFSNUM = @nf and TBS0671.SNEEMPCOD = @seremp and TBS0671.SNESER = @serie and
                             TBS0671.NFSITE = @item)
      return @retorno
   end
go

select dbo.NFSPERLUC(0,347424,0,1,1)

-- antigo

drop function NFSPERLUC
go

create function NFSPERLUC(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when NFSPRECUS > 0 and dbo.NFSPRELIQ(@empresa,@nf,@seremp,@serie,@item) > 0
                                   then
                                      (1 - (NFSPRECUS /
                                      (dbo.NFSPRELIQ(@empresa,@nf,@seremp,@serie,@item) +
                                         case NFSDESICMS
                                            when 'S' then
                                               dbo.NFSVDDITE(@empresa,@nf,@seremp,@serie,@item)
                                            else
                                               0
                                          end) * 100))
                                   else
                                      0
                             end
                        from TBS0671 (nolock) join TBS067 (nolock) on TBS0671.NFSEMPCOD = TBS067.NFSEMPCOD and TBS0671.SNEEMPCOD = TBS067.SNEEMPCOD and
                                                                      TBS0671.SNESER = TBS067.SNESER and TBS0671.NFSNUM = TBS067.NFSNUM
                       where TBS0671.NFSEMPCOD = @empresa and TBS0671.NFSNUM = @nf and TBS0671.SNEEMPCOD = @seremp and TBS0671.SNESER = @serie and
                             TBS0671.NFSITE = @item)
      return @retorno
   end
go


-- NFSVALCOM = valor da comiss�o

drop function NFSVALCOM
go

create function NFSVALCOM(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.NFSTOTITEST(@empresa,@nf,@seremp,@serie,@item) * NFSPERCOM / 100
                        from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go


-- NFSVALDEV = valor da devolu��o

drop function NFSVALDEV
go

create function NFSVALDEV(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select NFSQTDDEV * NFSPREDEV
                        from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSITE = @item)
      return @retorno
   end
go


-- NFSTOTBRU = total dos produtos

drop function NFSTOTBRU
go

create function NFSTOTBRU(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFSTOTPRO(@empresa,@nf,@seremp,@serie,NFSITE)),0) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie)
      return @retorno
   end
go


-- NFSVDDTOT = valor total do desconto = sum(NFSVDDITE)

drop function NFSVDDTOT
go

create function NFSVDDTOT(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFSVDDITE(@empresa,@nf,@seremp,@serie,NFSITE)),0) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie)
      return @retorno
   end
go


-- NFSTOTLIQ = valor total da nota = sum(NFSTOTITEST)

drop function NFSTOTLIQ
go

create function NFSTOTLIQ(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFSTOTITEST(@empresa,@nf,@seremp,@serie,NFSITE)),0) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie)
      return @retorno
   end
go


-- NFSTOTICMS = valor total do ICMS = sum(NFSVALICMS)

drop function NFSTOTICMS
go

create function NFSTOTICMS(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFSVALICMS(@empresa,@nf,@seremp,@serie,NFSITE)),0) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie)
      return @retorno
   end
go

-- NFSTOTICMSSEMST = valor total do ICMS = sum(NFSVALICMS) - ST ... para gerar SPED

drop function NFSTOTICMSSEMST
go

create function NFSTOTICMSSEMST(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFSVALICMS(@empresa,@nf,@seremp,@serie,NFSITE)),0) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSPERICMSST=0)
      return @retorno
   end
go

-- NFSTOTICMSISE = valor total do ICMS isento = sum(NFSVALICMSISE)

drop function NFSTOTICMSISE
go

create function NFSTOTICMSISE(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFSVALICMSISE(@empresa,@nf,@seremp,@serie,NFSITE)),0) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie)
      return @retorno
   end
go


-- NFSTOTBASICMSST = valor base para c�lculo do ICMS-ST = SUM(NFSBASICMSST)

drop function NFSTOTBASICMSST
go

create function NFSTOTBASICMSST(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFSBASICMSST(@empresa,@nf,@seremp,@serie,NFSITE)),0) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie)
      return @retorno
   end
go


-- NFSTOTICMSST = valor total do ICMS-ST = SUM(NFSVALICMSSTRET)

drop function NFSTOTICMSST
go

create function NFSTOTICMSST(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFSVALICMSSTRET(@empresa,@nf,@seremp,@serie,NFSITE)),0) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie)
      return @retorno
   end
go


-- NFSTOTBAS = valor para base de calculo do ICMS = SUM(NFSBASICMS)

drop function NFSTOTBAS
go

create function NFSTOTBAS(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFSBASICMS(@empresa,@nf,@seremp,@serie,NFSITE)),0) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie)
      return @retorno
   end
go

-- NFSTOTBASSEMST = valor para base de calculo do ICMS = SUM(NFSBASICMS) - ST ... para gerar SPED

drop function NFSTOTBASSEMST
go

create function NFSTOTBASSEMST(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFSBASICMS(@empresa,@nf,@seremp,@serie,NFSITE)),0) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie and NFSPERICMSST=0)
      return @retorno
   end
go

-- NFSTOTCOM = valor total da comissao = SUM(NFSVALCOM)

drop function NFSTOTCOM
go

create function NFSTOTCOM(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFSVALCOM(@empresa,@nf,@seremp,@serie,NFSITE)),0) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie)
      return @retorno
   end
go


-- NFSTOTDPL = valor total das duplicatas = SUM(NFSVALDPL)

drop function NFSTOTDPL
go

create function NFSTOTDPL(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFSVALDPL(@empresa,@nf,@seremp,@serie,NFSITE)),0) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie)
      return @retorno
   end
go


-- NFSTOTDEV = valor total das devolucoes = SUM(NFSVALDEV)

drop function NFSTOTDEV
go

create function NFSTOTDEV(@empresa smallint ,@nf int ,@seremp smallint ,@serie smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFSVALDEV(@empresa,@nf,@seremp,@serie,NFSITE)),0) from TBS0671 (nolock)
                       where NFSEMPCOD = @empresa and NFSNUM = @nf and SNEEMPCOD = @seremp and SNESER = @serie)
      return @retorno
   end
go

-- fim: formulas da nota fiscal de sa�da --------------------------------------------------------------------------------------------------------------------------


-- formulas da nota fiscal de sa�da
--select teste=dbo.valorTotProduto(0,2,4)
--select teste=dbo.valorTotProduto(0,2,4)

--drop function dbo.valorTotProduto
--drop function dbo.valorDescPorItem


-- compras

-- PDCTOTPRO = valor do produto = PDCQTD * PDCPRE

drop function PDCTOTPRO
go

create function PDCTOTPRO(@empresa smallint ,@numero int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = round(isnull((select PDCQTD*PDCPRE from TBS0451 (nolock) where PDCEMPCOD=@empresa and PDCNUM=@numero and PDCITE=@item),0),2)
      return @retorno
   end
go

-- PDCVDDITE = valor do desconto do produto = PDCTOTPRO * PDCPDDITE / 100

drop function PDCVDDITE
go

create function PDCVDDITE(@empresa smallint ,@numero int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = isnull((select dbo.PDCTOTPRO(@empresa,@numero,@item)*PDCPDDITE/100 from TBS0451 (nolock) where PDCEMPCOD=@empresa and PDCNUM=@numero and PDCITE=@item),0)
      return @retorno
   end
go

-- PDCVALFRE = valor do frete por item = PDCTOTPRO * PDCPORFREITE / 100

drop function PDCVALFRE
go

create function PDCVALFRE(@empresa smallint ,@numero int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = isnull((select dbo.PDCTOTPRO(@empresa,@numero,@item)*PDCPORFREITE/100 from TBS0451 (nolock) where PDCEMPCOD=@empresa and PDCNUM=@numero and PDCITE=@item),0)
      return @retorno
   end
go


-- PDCVALSEG = valor do seguro por item = PDCTOTPRO * PDCPORSEGITE / 100

drop function PDCVALSEG
go

create function PDCVALSEG(@empresa smallint ,@numero int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = isnull((select dbo.PDCTOTPRO(@empresa,@numero,@item)*PDCPORSEGITE/100 from TBS0451 (nolock) where PDCEMPCOD=@empresa and PDCNUM=@numero and PDCITE=@item),0)
      return @retorno
   end
go

-- PDCVALOUT = valor de outras despesas acess�rias por item = PDCTOTPRO * PDCPOROUTITE / 100

drop function PDCVALOUT
go

create function PDCVALOUT(@empresa smallint ,@numero int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = isnull((select dbo.PDCTOTPRO(@empresa,@numero,@item)*PDCPOROUTITE/100 from TBS0451 (nolock) where PDCEMPCOD=@empresa and PDCNUM=@numero and PDCITE=@item),0)
      return @retorno
   end
go

-- PDCVALIPI = valor do IPI por item = PDCTOTPRO * PDCIPI / 100
-- (PDCTOTPRO - PDCVDDITE) * PDCIPI / 100

drop function PDCVALIPI
go

create function PDCVALIPI(@empresa smallint ,@numero int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      -- set @retorno = isnull((select (dbo.PDCTOTPRO(@empresa,@numero,@item-dbo.PDCVDDITE(@empresa,@numero,@item)))*PDCIPI/100 from TBS0451 (nolock) where PDCEMPCOD=@empresa and PDCNUM=@numero and PDCITE=@item),0)
      set @retorno = isnull((select dbo.PDCTOTPRO(@empresa,@numero,@item)*PDCIPI/100 from TBS0451 (nolock) where PDCEMPCOD=@empresa and PDCNUM=@numero and PDCITE=@item),0)
      return @retorno
   end
go

-- PDCVALST = valor da ST por item = (PDCTOTPRO + PDCVALIPI) * PDCPORST / 100

drop function PDCVALST
go

create function PDCVALST(@empresa smallint ,@numero int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = isnull((select (dbo.PDCTOTPRO(@empresa,@numero,@item)+dbo.PDCVALIPI(@empresa,@numero,@item))*PDCPORST/100 from TBS0451 (nolock)
                              where PDCEMPCOD=@empresa and PDCNUM=@numero and PDCITE=@item),0)
      return @retorno
   end
go

-- PDCTOTITE = valor total do item = PDCTOTPRO - PDCVDDITE + PDCVALFRE + PDCVALSEG + PDCVALOUT + PDCVALIPI + PDCVALST

drop function PDCTOTITE
go

create function PDCTOTITE(@empresa smallint ,@numero int ,@item smallint) returns decimal(11,2) as
   begin
      declare @retorno decimal(11,2)
      set @retorno = round(isnull((select dbo.PDCTOTPRO(@empresa,@numero,@item)-dbo.PDCVDDITE(@empresa,@numero,@item)+dbo.PDCVALFRE(@empresa,@numero,@item)+
                                          dbo.PDCVALSEG(@empresa,@numero,@item)+dbo.PDCVALOUT(@empresa,@numero,@item)+dbo.PDCVALIPI(@empresa,@numero,@item)+
                                          dbo.PDCVALST(@empresa,@numero,@item)
                                     from TBS0451 (nolock) where PDCEMPCOD = @empresa and PDCNUM = @numero and PDCITE = @item),0),2)
      return @retorno
   end
go

-- PDCPRELIQ = preco liquido com desconto = PDCTOTITE / PDCQTD

drop function PDCPRELIQ
go

create function PDCPRELIQ(@empresa smallint ,@numero int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = round(isnull((select dbo.PDCTOTITE(@empresa,@numero,@item)/PDCQTD from TBS0451 (nolock) where PDCEMPCOD=@empresa and PDCNUM=@numero and PDCITE=@item),0),4)
      return @retorno
   end
go

-- PDCVALENT = valor j� entreque do item = PDCQTDENT * PDCPRELIQ

drop function PDCVALENT
go

create function PDCVALENT(@empresa smallint ,@numero int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = isnull((select PDCQTDENT*dbo.PDCPRELIQ(@empresa,@numero,@item) from TBS0451 (nolock)
                              where PDCEMPCOD=@empresa and PDCNUM=@numero and PDCITE=@item),0)
      return @retorno
   end
go

-- PDCVALRES = valor residual do item = PDCQTRES * PDCPRELIQ

drop function PDCVALRES
go

create function PDCVALRES(@empresa smallint ,@numero int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = isnull((select PDCQTDRES*dbo.PDCPRELIQ(@empresa,@numero,@item) from TBS0451 (nolock)
                              where PDCEMPCOD=@empresa and PDCNUM=@numero and PDCITE=@item),0)
      return @retorno
   end
go

-- PDCTOTBRU = valor total dos produtos = SUM(PDCTOTITE)

drop function PDCTOTBRU
go

create function PDCTOTBRU(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = isnull((select sum(dbo.PDCTOTITE(@empresa,@pedido,PDCITE)) from TBS0451 (nolock) where PDCEMPCOD=@empresa and PDCNUM=@pedido),0)
      return @retorno
   end
go

-- PDCVDDTOT = valor do desconto total = SUM(PDCVDDITE)

drop function PDCVDDTOT
go

create function PDCVDDTOT(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = isnull((select sum(dbo.PDCVDDITE(@empresa,@pedido,PDCITE)) from TBS0451 (nolock) where PDCEMPCOD=@empresa and PDCNUM=@pedido),0)
      return @retorno
   end
go

-- PDCTOTLIQ = valot total do produto = SUM(PDCTOTPRO)

drop function PDCTOTLIQ
go

create function PDCTOTLIQ(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = isnull((select sum(dbo.PDCTOTPRO(@empresa,@pedido,PDCITE)) from TBS0451 (nolock) where PDCEMPCOD=@empresa and PDCNUM=@pedido),0)
      return @retorno
   end
go

-- PDCTOTENT = valor total item ja entregue = SUM(PDVALENT)

drop function PDCTOTENT
go

create function PDCTOTENT(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = isnull((select sum(dbo.PDCVALENT(@empresa,@pedido,PDCITE)) from TBS0451 (nolock) where PDCEMPCOD=@empresa and PDCNUM=@pedido),0)
      return @retorno
   end
go

-- PDCTOTRES = valor total residual do pedido = SUM(PDCVALRES)

drop function PDCTOTRES
go

create function PDCTOTRES(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = isnull((select sum(dbo.PDCVALRES(@empresa,@pedido,PDCITE)) from TBS0451 (nolock) where PDCEMPCOD=@empresa and PDCNUM=@pedido),0)
      return @retorno
   end
go

-- PDCTOTENT = valor total ja entregue = SUM(PDCVALENT)

drop function PDCTOTENT
go

create function PDCTOTENT(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDCVALENT(@empresa,@pedido,PDCITE)),0) from TBS0451 (nolock) where PDCEMPCOD = @empresa and PDCNUM = @pedido)
      return @retorno
   end
go

-- PDCTOTRES = valor total residual = SUM(PDCVALRES)

drop function PDCTOTRES
go

create function PDCTOTRES(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDCVALRES(@empresa,@pedido,PDCITE)),0) from TBS0451 (nolock) where PDCEMPCOD = @empresa and PDCNUM = @pedido)
      return @retorno
   end
go

-- PDCTOTIPI = valor total do IPI = SUM(PDCVALIPI)

drop function PDCTOTIPI
go

create function PDCTOTIPI(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDCVALIPI(@empresa,@pedido,PDCITE)),0) from TBS0451 (nolock) where PDCEMPCOD = @empresa and PDCNUM = @pedido)
      return @retorno
   end
go

-- PDCTOTST = valor total do ST = SUM(PDCVALST)

drop function PDCTOTST
go

create function PDCTOTST(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDCVALST(@empresa,@pedido,PDCITE)),0) from TBS0451 (nolock) where PDCEMPCOD = @empresa and PDCNUM = @pedido)
      return @retorno
   end
go


select convert(char(10),PDCDATCAD,103) as 'emissao',TBS045.PDCNUM as 'pedido',FORCOD as 'cod-fornecedor',
       (select FORNOM from TBS006 (nolock) where FORCOD = TBS045.FORCOD) as 'nome-fornecedor',
       str(isnull(round(sum(dbo.PDCTOTITE(TBS045.PDCEMPCOD,TBS045.PDCNUM,PDCITE)),2),0),11,2) as 'valor'
  from TBS045 (nolock) join TBS0451 on TBS0451.PDCEMPCOD = TBS045.PDCEMPCOD and TBS0451.PDCNUM = TBS045.PDCNUM
 where PDCDATCAD >= '20121001'
 group by PDCDATCAD,TBS045.PDCNUM,FORCOD
 order by PDCDATCAD

select convert(char(10),PDVDATCAD,103) as 'emissao',
       str(isnull(round(sum(dbo.PDVTOTLIQ(TBS055.PDVEMPCOD,TBS055.PDVNUM)),2),0),11,2) as 'valor'
  from TBS055 (nolock)
 where PDVDATCAD >= '20120701'
 group by PDVDATCAD
 order by PDVDATCAD

select convert(char(10),PDCDATCAD,103) as 'emissao',
       FORCOD as 'cod-fornecedor',
       (select FORNOM from TBS006 (nolock) where FORCOD = TBS045.FORCOD) as 'nome-fornecedor',
       sum(dbo.PDCTOTLIQ(TBS045.PDCEMPCOD,TBS045.PDCNUM)) as 'total-pedido',
       sum(dbo.PDCTOTENT(TBS045.PDCEMPCOD,TBS045.PDCNUM)) as 'total-entregue',
       sum(dbo.PDCTOTRES(TBS045.PDCEMPCOD,TBS045.PDCNUM)) as 'total-cancelado'
  from TBS045 (nolock)
 where PDCDATCAD >= '20120701'
 group by PDCDATCAD,FORCOD
 order by PDCDATCAD

select convert(char(10),PDCDATCAD,103) as 'emissao',
       FORCOD as 'cod-fornecedor',
       (select FORNOM from TBS006 (nolock) where FORCOD = TBS045.FORCOD) as 'nome-fornecedor',
       sum(dbo.PDCTOTLIQ(TBS045.PDCEMPCOD,TBS045.PDCNUM)) as 'total-pedido',
       sum(dbo.PDCTOTENT(TBS045.PDCEMPCOD,TBS045.PDCNUM)) as 'total-entregue',
       sum(dbo.PDCTOTRES(TBS045.PDCEMPCOD,TBS045.PDCNUM)) as 'total-cancelado'
  from TBS045 (nolock)
 where PDCDATCAD >= '20120701'
 group by PDCDATCAD,FORCOD
 order by PDCDATCAD


-- PEDIDOS DE VENDAS ******

-- PDVQTD = quantidade do produto
-- PDVPRE = preco do produto
-- PDVTOTPRO = valor total do produto = PDVPRE * PDVQTD

drop function PDVTOTPRO
go

create function PDVTOTPRO(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select PDVPRE * PDVQTD from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVPEDITE = percentual do desconto por item
-- PDVVDDITE = valor do desconto por item = PDVTOTPRO * PDVPDDITE / 100

drop function PDVVDDITE
go

create function PDVVDDITE(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.PDVTOTPRO(@empresa,@pedido,@item) * PDVPDDITE / 100 from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVFREITE    = porcentagem do frete por item
-- PDVFREITEVAL = valor do frete por item = PDVTOTPRO * PDVFREITE / 100

drop function PDVFREITEVAL
go

create function PDVFREITEVAL(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.PDVTOTPRO(@empresa,@pedido,@item) * PDVFREITE / 100 from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVSEGITE    = porcentagem do seguro por item
-- PDVSEGITEVAL = valor do seguro por item = PDVTOTPRO * PDVSEGITE / 100

drop function PDVSEGITEVAL
go

create function PDVSEGITEVAL(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.PDVTOTPRO(@empresa,@pedido,@item) * PDVSEGITE / 100 from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVDESITE    = porcentagem de outras despesas por item
-- PDVDESITEVAL = valor de outras despesas por item = PDVTOTPRO * PDVDESITE / 100

drop function PDVDESITEVAL
go

create function PDVDESITEVAL(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.PDVTOTPRO(@empresa,@pedido,@item) * PDVDESITE / 100 from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVTOTITE = valor total do item = PDVTOTPRO - PDVVDDITE + PDVFREITEVAL + PDVSEGITEVAL + PDVDESITEVAL

drop function PDVTOTITE
go

create function PDVTOTITE(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.PDVTOTPRO(@empresa,@pedido,@item) - dbo.PDVVDDITE(@empresa,@pedido,@item) + dbo.PDVFREITEVAL(@empresa,@pedido,@item) +
                             dbo.PDVSEGITEVAL(@empresa,@pedido,@item) + dbo.PDVDESITEVAL(@empresa,@pedido,@item)
                        from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVPRELIQ = preco liquido com desconto = PDVTOTITE / PDVQTD

drop function PDVPRELIQ
go

create function PDVPRELIQ(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.PDVTOTITE(@empresa,@pedido,@item) / case PDVQTD when 0 then 1 else PDVQTD end from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVPBI     = porcentagem para a base de calculo do ICMS
-- PDVBASICMS = valor da base de calculo do ICMS = PDVTOTITE * PDVPBI / 100

drop function PDVBASICMS
go

create function PDVBASICMS(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.PDVTOTITE(@empresa,@pedido,@item) * PDVPBI / 100 from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVPERICMS = porcentagem do ICMS
-- PDVVALICMS = valor do ICMS = PDVBASICMS * PDVPERICMS / 100

drop function PDVVALICMS
go

create function PDVVALICMS(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.PDVBASICMS(@empresa,@pedido,@item) * PDVPERICMS / 100 from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVPBIISE     = porcentagem para a base de calculo do ICMS (isento)
-- PDVBASICMSISE = valor da base de calculo do ICMS (isento) = (PDVTOTPRO + PDVFREITEVAL + PDVSEGITEVAL + PDVDESITEVAL) * PDVPBIISE / 100

drop function PDVBASICMSISE
go

create function PDVBASICMSISE(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select (dbo.PDVTOTPRO(@empresa,@pedido,@item) + dbo.PDVFREITEVAL(@empresa,@pedido,@item) + dbo.PDVSEGITEVAL(@empresa,@pedido,@item) +
                              dbo.PDVDESITEVAL(@empresa,@pedido,@item)) * PDVPBIISE / 100
                        from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVPERICMSISE = porcentagem do ICMS (isento)
-- PDVVALICMSISE = valor do ICMS (isento) = PDVBASICMSISE * PDVPERICMSISE / 100

drop function PDVVALICMSISE
go

create function PDVVALICMSISE(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.PDVBASICMSISE(@empresa,@pedido,@item) * PDVPERICMSISE / 100 from TBS0551 (nolock)
                      where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVMVA    = margem do valor agregado
-- PDVPBIST  = porcentagem para abase de calculo do ICMS-ST
-- PDVVALAGR = valor agregado = iif(PDVPBIST > 0, (PDVTOTITE + PDVVDDITE) * PDVPBIST / 100 * PDVMVA / 100, 0)

drop function PDVVALAGR
go

create function PDVVALAGR(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when PDVPERICMSST > 0
                                   then
                                      (dbo.PDVTOTITE(@empresa,@pedido,@item) + dbo.PDVVDDITE(@empresa,@pedido,@item)) * PDVPBIST / 100 * PDVMVA / 100
                                   else
                                      0
                             end
                        from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVBASICMSST = valor para a base de calculo do ICMS-ST = iif(PDVPBIST > 0, PDVTOTITE + PDVVDDITE + PDVVALAGR, 0)

drop function PDVBASICMSST
go

create function PDVBASICMSST(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when PDVPERICMSST > 0
                                   then
                                      dbo.PDVTOTITE(@empresa,@pedido,@item) + dbo.PDVVDDITE(@empresa,@pedido,@item) +
                                      dbo.PDVVALAGR(@empresa,@pedido,@item)
                                   else
                                      0
                             end
                        from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVPERICMSST = porcentagem do ICMS-ST
-- PDVVALICMSST = valor do ICMS-ST = iif(PDVPBIST > 0, PDVBASICMSST * PDVPERICMSST / 100, 0)

drop function PDVVALICMSST
go

create function PDVVALICMSST(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when PDVPBIST > 0
                                   then
                                      dbo.PDVBASICMSST(@empresa,@pedido,@item) * PDVPERICMSST / 100
                                   else
                                      0
                             end
                        from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVVALICMSSTRET = valor do ICMS-ST retido = iif(PDVPBIST > 0, PDVVALICMSST - PDVVALICMS, 0)

drop function PDVVALICMSSTRET
go

create function PDVVALICMSSTRET(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when PDVPERICMSST > 0
                                   then
                                      dbo.PDVVALICMSST(@empresa,@pedido,@item) - dbo.PDVVALICMS(@empresa,@pedido,@item)
                                   else
                                      0
                             end
                        from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVTOTITEST = valor total do item + valor do ICMS-ST = iif(PDVPBIST > 0, PDVTOTITE + PDVVALICMSSTRET, PDVTOTITE)

drop function PDVTOTITEST
go

create function PDVTOTITEST(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when PDVPERICMSST > 0
                                   then
                                      dbo.PDVTOTITE(@empresa,@pedido,@item) + dbo.PDVVALICMSSTRET(@empresa,@pedido,@item)
                                   else
                                      dbo.PDVTOTITE(@empresa,@pedido,@item)
                             end
                        from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVVALFAT = valor j� faturado do item = iif(PDVQTD > 0, round(PDVQTDFAT * PDVTOTITEST / PDVQTD ,2) ,0)

drop function PDVVALFAT
go

create function PDVVALFAT(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)

      set @retorno = (select case
                                when PDVQTD > 0
                                   then
                                      round(PDVQTDFAT * dbo.PDVTOTITEST(PDVEMPCOD, PDVNUM, PDVITEM) / PDVQTD ,2)
                                   else
                                      0
                             end
                        from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVVALLIB = valor do produto liberado quanto ao pre�o = iif(PDVQTD > 0 and (PDVBLQCRE = 'S' or PDVBLQPRE = 'S'), 0, round((PDVQTD - PDVQTDFAT ) * (PDVTOTITEST / PDVQTD) ,2))

drop function PDVVALLIB
go

create function PDVVALLIB(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)

      set @retorno = (select case
                                when PDVQTD > 0 and (PDVBLQCRE='S' or PDVBLQPRE='S')
                                   then
                                      0
                                   else
                                      round((PDVQTD - PDVQTDFAT ) * (dbo.PDVTOTITEST(TBS0551.PDVEMPCOD, TBS0551.PDVNUM, TBS0551.PDVITEM) / TBS0551.PDVQTD) ,2)
                             end
                        from TBS0551 (nolock)
                             inner join TBS055 (nolock) on TBS055.PDVEMPCOD=TBS0551.PDVEMPCOD and TBS055.PDVNUM=TBS0551.PDVNUM
                       where TBS0551.PDVEMPCOD = @empresa and TBS0551.PDVNUM = @pedido and TBS0551.PDVITEM = @item)
      return @retorno
   end
go

-- PDVVALBLQ = valor do produto bloqueado quanto ao pre�o = iif(PDVQTD > 0 and (PDVBLQCRE = 'S' or PDVBLQPRE = 'S'), round((PDVQTD - PDVQTDFAT ) * (PDVTOTITEST / PDVQTD) ,2) ,0)

drop function PDVVALBLQ
go

create function PDVVALBLQ(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)

      set @retorno = (select case
                                when PDVQTD > 0 and (PDVBLQCRE='S' or PDVBLQPRE='S')
                                   then
                                      round((PDVQTD - PDVQTDFAT ) * (dbo.PDVTOTITEST(TBS0551.PDVEMPCOD, TBS0551.PDVNUM, TBS0551.PDVITEM) / TBS0551.PDVQTD) ,2)
                                   else
                                      0
                             end
                        from TBS0551 (nolock)
                       inner join TBS055 (nolock) on TBS055.PDVEMPCOD=TBS0551.PDVEMPCOD and TBS055.PDVNUM=TBS0551.PDVNUM
                       where TBS0551.PDVEMPCOD = @empresa and TBS0551.PDVNUM = @pedido and TBS0551.PDVITEM = @item)
      return @retorno
   end
go

-- PDVQTDBLQ = quantidade de itens bloqueados = iif(PDVBLQPRE = 'S', PDVQTD - PDVQTDFAT, 0)

drop function PDVQTDBLQ
go

create function PDVQTDBLQ(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when PDVBLQPRE = 'S'
                                   then
                                      PDVQTD - PDVQTDFAT
                                   else
                                      0
                             end
                        from TBS0551 (nolock)
                       where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go

-- PDVPRECUS = preco de custo da mercadoria
-- PDVVALCUS = valor do custo do item = PDVQTD * PDVPRECUS

drop function PDVVALCUS
go

create function PDVVALCUS(@empresa smallint ,@pedido int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select PDVQTD * PDVPRECUS from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido and PDVITEM = @item)
      return @retorno
   end
go



-- PDVPERLUC = percentual de lucro sobre a venda = iif(PDVPRECUS > 0 .AND. PDVPRELIQ > 0, (1 - (PDVPRECUS / (PDVPRELIQ + iif(PDVDESICMS = 'S', PDVVDDITE / PDVQTD, 0)))) * 100, 0)



-- PDVTOTBRU = valor total dos produtos = SUM(PDVTOTPRO)

drop function PDVTOTBRU
go

create function PDVTOTBRU(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDVTOTPRO(@empresa,@pedido,PDVITEM)),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVVDDTOT = valor total do desconto = SUM(PDVVDDITE)

drop function PDVVDDTOT
go

create function PDVVDDTOT(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDVVDDITE(@empresa,@pedido,PDVITEM)),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVTOTLIQ = valor total liquido do pedido = SUM(PDVTOTITEST)

drop function PDVTOTLIQ
go

create function PDVTOTLIQ(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDVTOTITEST(@empresa,@pedido,PDVITEM)),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVTOTBAS = valor total base para calculo do ICMS = SUM(PDVBASICMS)

drop function PDVTOTBAS
go

create function PDVTOTBAS(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDVBASICMS(@empresa,@pedido,PDVITEM)),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVTOTICMS = valor total do ICMS = SUM(PDVVALICMS)

drop function PDVTOTICMS
go

create function PDVTOTICMS(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDVVALICMS(@empresa,@pedido,PDVITEM)),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVTOTICMSISE = valor total do ICMS isento = SUM(PDVVALICMSISE)

drop function PDVTOTICMSISE
go

create function PDVTOTICMSISE(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDVVALICMSISE(@empresa,@pedido,PDVITEM)),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVQTDTOT = quantidade total do pedido = SUM(PDVQTD)

drop function PDVQTDTOT
go

create function PDVQTDTOT(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(PDVQTD),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVQTDTOTF = quantidade total do pedido = SUM(PDVQTDFAT)

drop function PDVQTDTOTF
go

create function PDVQTDTOTF(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(PDVQTDFAT),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVTOTFAT = valor total faturado = PDVTOTLIQ / PDVQTDTOT * PDVQTDTOTF

drop function PDVTOTFAT
go

create function PDVTOTFAT(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when isnull(dbo.PDVTOTLIQ(@empresa,@pedido),0) > 0 and isnull(dbo.PDVQTDTOT(@empresa,@pedido),0) > 0 then
                                   isnull(dbo.PDVTOTLIQ(@empresa,@pedido) / dbo.PDVQTDTOT(@empresa,@pedido) * dbo.PDVQTDTOTF(@empresa,@pedido),0)
                                else
                                   0
                             end
                        from TBS055 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVQTDTOTB = quantidade total de itens bloqueados por preco = SUM(PDVQTDBLQ)

drop function PDVQTDTOTB
go

create function PDVQTDTOTB(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDVQTDBLQ(@empresa,@pedido,PDVITEM)),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVTOTBLQ = valor total bloqueado por preco = sum(PDVVALBLQ)

drop function PDVTOTBLQ
go

create function PDVTOTBLQ(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDVVALBLQ(@empresa,@pedido,PDVITEM)),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVTOTLIB = valor total liberado por preco = sum(PDVVALLIB)

drop function PDVTOTLIB
go

create function PDVTOTLIB(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDVVALLIB(@empresa,@pedido,PDVITEM)),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

select dbo.PDVTOTPRO(0,217174,1)
select dbo.PDVVDDITE(0,217174,1)
select dbo.PDVFREITEVAL(0,217174,1)
select dbo.PDVSEGITEVAL(0,217174,1)
select dbo.PDVDESITEVAL(0,217174,1)
select dbo.PDVTOTITE(0,217174,1)
select dbo.PDVPRELIQ(0,217174,1)
select dbo.PDVBASICMS(0,217174,1)
select dbo.PDVVALICMS(0,217174,1)
select dbo.PDVBASICMSISE(0,217174,1)
select dbo.PDVVALICMSISE(0,217174,1)
select dbo.PDVVALAGR(0,217174,1)
select dbo.PDVBASICMSST(0,217174,1)
select dbo.PDVVALICMSST(0,217174,1)
select dbo.PDVVALICMSSTRET(0,217174,1)
select dbo.PDVTOTITEST(0,217174,1)
select dbo.PDVQTDBLQ(0,217174,1)
select dbo.PDVVALCUS(0,217174,1)
select dbo.PDVTOTBRU(0,217174)
select dbo.PDVVDDTOT(0,217174)
select dbo.PDVTOTLIQ(0,217174)
select dbo.PDVTOTBAS(0,217174)
select dbo.PDVTOTICMS(0,217174)
select dbo.PDVTOTICMSISE(0,217174)
select dbo.PDVQTDTOT(0,217174)
select dbo.PDVQTDTOTF(0,217174)
select dbo.PDVTOTFAT(0,217174)
select dbo.PDVQTDTOTB(0,217174)
select dbo.PDVTOTBLQ(0,217174)
select dbo.PDVTOTLIB(0,217174)

select CLICOD,CLIPEDLIB,CLIPEDBLQ,CLIPEDLIB-CLIPEDBLQ from TBS002 (nolock) where CLICOD = 12026
select PDVCLICOD,sum(dbo.PDVTOTLIQ(PDVEMPCOD,PDVNUM)) - sum(dbo.PDVTOTFAT(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = 12026 group by PDVCLICOD
select PDVCLICOD,sum(dbo.PDVTOTBLQ(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = 12026 group by PDVCLICOD
select PDVCLICOD,sum(dbo.PDVTOTLIB(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = 12026 group by PDVCLICOD

select CLICOD,CLIPEDLIB,CLIPEDBLQ,CLIPEDLIB-CLIPEDBLQ from TBS002 (nolock)
 where CLIPEDLIB <> (select sum(dbo.PDVTOTLIB(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = CLICOD) or
       CLIPEDBLQ <> (select sum(dbo.PDVTOTBLQ(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = CLICOD)

update TBS002 set CLIPEDLIB = (select sum(dbo.PDVTOTLIB(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = CLICOD),
                  CLIPEDBLQ = (select sum(dbo.PDVTOTBLQ(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = CLICOD)
  from TBS002 (nolock)
 where CLIPEDLIB <> (select sum(dbo.PDVTOTLIB(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = CLICOD) or
       CLIPEDBLQ <> (select sum(dbo.PDVTOTBLQ(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVCLICOD = CLICOD)


-- CONTAS A RECEBER

-- CREDATVENREA: data de vencimento real = iif(dow(CREDATVEN) > 1 .AND. dow(CREDATVEN) < 7, CREDATVEN, iif(dow(CREDATVEN) = 1, CREDATVEN + 1, CREDATVEN + 2))

-- ATRIBUTO REDUNDANTE

drop function CREDATVENREA
go 

create function CREDATVENREA(@emptit smallint ,@empprefix smallint ,@empcli smallint ,@prefix char(3) ,@titulo int ,@parcela char(2) ,@cliente int) returns datetime as
   begin
      declare @retorno datetime
      set @retorno = (select case when datepart(DW ,CREDATVEN) > 1 and datepart(DW ,CREDATVEN) < 7 then CREDATVEN
                                  when datepart(DW ,CREDATVEN) = 1 then CREDATVEN + 1
                                  when datepart(DW ,CREDATVEN) = 7 then CREDATVEN + 2
                             end     
                        from TBS056 (nolock)
                       where CREEMPCOD = @emptit and PFXEMPCOD = @empprefix and CLIEMPCOD = @empcli and PFXCOD = @prefix and CRETIT = @titulo and
                             CREPAR = @parcela and CLICOD = @cliente)
      return @retorno
   end
go

-- CREDATBAI: data da baixa
-- CREDATVENREA: data do vencimento real

-- CREDIAATR: dias de atraso = 
iif(CREDATBAI = nullvalue(CREDATBAI), iif(today() - CREDATVENREA < 0, 0, today() - CREDATVENREA), 
iif(CREDATBAI - CREDATVENREA < 0, 0, CREDATBAI - CREDATVENREA) )


-- view criada para retornar data atual, pois getdate usando dentro de outra fun��o n�o funciona

drop view DataAtual
go

create view DataAtual as select getdate() as 'data'
go

drop function CREDIAATR
go 

create function CREDIAATR(@emptit smallint ,@empprefix smallint ,@empcli smallint ,@prefix char(3) ,@titulo int ,@parcela char(2) ,@cliente int) returns int as
   begin
      declare @retorno int ,@datatu datetime
      set @datatu = (select top 1 data from DataAtual)
      set @retorno = (select case
                                when CREDATBAI = '17530101' then
                                   case
                                      when datediff(day,dbo.CREDATVENREA(CREEMPCOD,PFXEMPCOD,CLIEMPCOD,PFXCOD,CRETIT,CREPAR,CLICOD),@datatu) < 0 then
                                         0
                                      else
                                         datediff(day,dbo.CREDATVENREA(CREEMPCOD,PFXEMPCOD,CLIEMPCOD,PFXCOD,CRETIT,CREPAR,CLICOD),@datatu)
                                   end
                                else
                                   case
                                      when datediff(day,dbo.CREDATVENREA(CREEMPCOD,PFXEMPCOD,CLIEMPCOD,PFXCOD,CRETIT,CREPAR,CLICOD),CREDATBAI) < 0 then
                                         0
                                      else
                                         datediff(day,dbo.CREDATVENREA(CREEMPCOD,PFXEMPCOD,CLIEMPCOD,PFXCOD,CRETIT,CREPAR,CLICOD),CREDATBAI)
                                   end
                                end
                        from TBS056 (nolock)
                       where CREEMPCOD = @emptit and PFXEMPCOD = @empprefix and CLIEMPCOD = @empcli and PFXCOD = @prefix and CRETIT = @titulo and CREPAR = @parcela and
                             CLICOD = @cliente)
      return @retorno
   end
go


select * from TBS056 (nolock) where CRETIT=22991
select dbo.CREDIAATR(0,0,0,'NFL',22991,'A0',8374)
select datediff(day,'20151105',getdate())
select datediff(day,'20151001','20151105')

select dbo.CREDIAATR(0,0,0,'NFC',169200,'A0',10519)
select datediff(day,getdate(),'20151012')

select dbo.CREDIAATR(0,0,0,'FAT',100655,'A0',123)

select dbo.CREDIAATR(0,0,0,'BBB',6312,'A0',10102)

-- CRETAXJUR: taxa de juros
-- CREVAL: valor do titulo

-- CREVALJUR: valor do juros = iif(CREDIAATR > 0, CRETAXJUR * CREDIAATR * CREVAL / 100, 0)

drop function CREVALJUR
go 

create function CREVALJUR(@emptit smallint ,@empprefix smallint ,@empcli smallint ,@prefix char(3) ,@titulo int ,@parcela char(2) ,@cliente int)
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when dbo.CREDIAATR(@emptit,@empprefix,@empcli,@prefix,@titulo,@parcela,@cliente) > 0 then
                                   CRETAXJUR * dbo.CREDIAATR(@emptit,@empprefix,@empcli,@prefix,@titulo,@parcela,@cliente) * CREVAL / 100
                                else
                                   0
                             end
                        from TBS056 (nolock)
                       where CREEMPCOD = @emptit and PFXEMPCOD = @empprefix and CLIEMPCOD = @empcli and PFXCOD = @prefix and CRETIT = @titulo and
                             CREPAR = @parcela and CLICOD = @cliente)
      return @retorno
   end
go

-- CREVALABT: valor do abatimento
-- CREVALREC: valor recebido
-- CREVALACR: valor do acrescimento
-- CREVALRES: valor do residuo
-- CREVALJUR: valor do juros
-- CRERESBAN: valor do residuo bancario

-- CREVALSDO: saldo em aberto do titulo = CREVAL - CREVALABT - CREVALREC + CREVALACR - CREVALRES + CREVALJUR + CRERESBAN

drop function CREVALSDO
go

create function CREVALSDO(@emptit smallint ,@empprefix smallint ,@empcli smallint ,@prefix char(3) ,@titulo int ,@parcela char(2) ,@cliente int)
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select CREVAL - CREVALABT - CREVALREC + CREVALACR - CREVALRES + dbo.CREVALJUR(@emptit,@empprefix,@empcli,@prefix,@titulo,@parcela,@cliente) + CRERESBAN
                        from TBS056 (nolock)
                       where CREEMPCOD = @emptit and PFXEMPCOD = @empprefix and CLIEMPCOD = @empcli and PFXCOD = @prefix and CRETIT = @titulo and
                             CREPAR = @parcela and CLICOD = @cliente)
      return @retorno
   end
go

select dbo.CREVALSDO(0,0,0,'NFC',167768,'A0',8756)

update TBS002 set CLITITABT = (select sum(dbo.CREVALSDO(CREEMPCOD,PFXEMPCOD,TBS056.CLIEMPCOD,PFXCOD,CRETIT,CREPAR,TBS056.CLICOD))
                                 from TBS056 (nolock) where TBS056.CLIEMPCOD = TBS002.CLIEMPCOD and TBS056.CLICOD = TBS002.CLICOD)
  from TBS002 (nolock)
 where CLITITABT <> (select sum(dbo.CREVALSDO(CREEMPCOD,PFXEMPCOD,TBS056.CLIEMPCOD,PFXCOD,CRETIT,CREPAR,TBS056.CLICOD))
                       from TBS056 (nolock) where TBS056.CLIEMPCOD = TBS002.CLIEMPCOD and TBS056.CLICOD = TBS002.CLICOD)


-- CONTAS A PAGAR

---
---

drop function CPADIAATR
go 

create function CPADIAATR(@emptit smallint ,@empprefix smallint ,@empcli smallint ,@prefix char(3) ,@titulo int ,@parcela char(2) ,@fornecedor int) returns int as
   begin
      declare @retorno int ,@datatu datetime
      set @datatu = (select top 1 data from DataAtual)
      set @retorno = (select case
                                when CPADATBAI = '17530101' then
                                   case
                                      when datediff(day,dbo.CPADATVENREA(CPAEMPCOD,PFXEMPCOD,FOREMPCOD,PFXCOD,CPATIT,CPAPAR,FORCOD),@datatu) < 0 then
                                         0
                                      else
                                         datediff(day,dbo.CPADATVENREA(CPAEMPCOD,PFXEMPCOD,FOREMPCOD,PFXCOD,CPATIT,CPAPAR,FORCOD),@datatu)
                                   end
                                else
                                   case
                                      when datediff(day,dbo.CPADATVENREA(CPAEMPCOD,PFXEMPCOD,FOREMPCOD,PFXCOD,CPATIT,CPAPAR,FORCOD),CPADATBAI) < 0 then
                                         0
                                      else
                                         datediff(day,dbo.CPADATVENREA(CPAEMPCOD,PFXEMPCOD,FOREMPCOD,PFXCOD,CPATIT,CPAPAR,FORCOD),CPADATBAI)
                                   end
                                end
                        from TBS057 (nolock)
                       where CPAEMPCOD = @emptit and PFXEMPCOD = @empprefix and FOREMPCOD = @empcli and PFXCOD = @prefix and CPATIT = @titulo and CPAPAR = @parcela and
                             FORCOD = @fornecedor)
      return @retorno
   end
go



---
---


-- CPADATVENREA: data de vencimento real = iif(dow(CPADATVEN) > 1 .AND. dow(CPADATVEN) < 7, CPADATVEN, iif(dow(CPADATVEN) = 1, CPADATVEN + 1, CPADATVEN + 2))

-- ATRIBUTO REDUNDANTE

create function CPADATVENREA(@emptit smallint ,@empprefix smallint ,@empfor smallint ,@prefix char(3) ,@titulo int ,@parcela char(2) ,@fornece int) returns datetime as
   begin
      declare @retorno datetime
      set @retorno = (select case when datepart(DW ,CPADATVEN) > 1 and datepart(DW ,CPADATVEN) < 7 then CPADATVEN
                                  when datepart(DW ,CPADATVEN) = 1 then CPADATVEN + 1
                                  when datepart(DW ,CPADATVEN) = 7 then CPADATVEN + 2
                             end     
                        from TBS057 (nolock)
                       where CPAEMPCOD = @emptit and PFXEMPCOD = @empprefix and FOREMPCOD = @empfor and PFXCOD = @prefix and CPATIT = @titulo and
                             CPAPAR = @parcela and FORCOD = @fornece)
      return @retorno
   end
go

-- CPAVAL: valor do titulo
-- CPAVALABT: valor do abatimento
-- CPAVALPAG: valor pago
-- CPAVALACR: valor do acrescimento
-- CPAVALRES: valor do residuo

-- CPAVALSDO: saldo em aberto do titulo = CPAVAL - CPAVALABT - CPAVALPAG + CPAVALACR - CPAVALRES

drop function CPAVALSDO
go

create function CPAVALSDO(@emptit smallint ,@empprefix smallint ,@empfor smallint ,@prefix char(3) ,@titulo decimal(10) ,@parcela char(2) ,@fornece int)
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select CPAVAL - CPAVALABT - CPAVALPAG + CPAVALACR - CPAVALRES
                        from TBS057 (nolock)
                       where CPAEMPCOD = @emptit and PFXEMPCOD = @empprefix and FOREMPCOD = @empfor and PFXCOD = @prefix and CPATIT = @titulo and
                             CPAPAR = @parcela and FORCOD = @fornece)
      return @retorno
   end
go




-- nota fiscal de entrada

-- NFEPRE: preco da mercadoria
-- NFEPDDITE: percentual de desconto

-- NFEVDDITE: valor do desconto por item = NFEPRE * NFEPDDITE / 100

drop function NFEVDDITE
go

create function NFEVDDITE(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3) ,@item smallint)
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select NFEPRE * NFEPDDITE / 100
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEITE = @item)
      return @retorno
   end
go

--drop function NFEVDDITE


-- NFEPRELIQ: preco liquido com desconto = NFEPRE - NFEVDDITE

drop function NFEPRELIQ
go

create function NFEPRELIQ(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3) ,@item smallint)
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select NFEPRE - isnull(dbo.NFEVDDITE(NFEEMPCOD,NFETIP,NFENUM,NFECOD,SEREMPCOD,SERCOD,NFEITE),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEITE = @item)
      return @retorno
   end
go


-- NFETOTITE: valor total do produto = NFEQTD * NFEPRELIQ

drop function NFETOTITE
go

create function NFETOTITE(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3) ,@item smallint)
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select NFEQTD * dbo.NFEPRELIQ(NFEEMPCOD,NFETIP,NFENUM,NFECOD,SEREMPCOD,SERCOD,NFEITE)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEITE = @item)
      return @retorno
   end
go

-- NFETOTITEBRU: valor total bruto do produto = NFEQTD * NFEPRE

drop function NFETOTITEBRU
go

create function NFETOTITEBRU(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3) ,@item smallint)
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select NFEQTD * NFEPRE
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEITE = @item)
      return @retorno
   end
go

-- NFEVALICMS: valor do ICMS = NFEBASICMS * NFEPERICMS / 100

drop function NFEVALICMS
go

create function NFEVALICMS(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3) ,@item smallint)
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select NFEBASICMS * NFEPERICMS / 100
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEITE = @item)
      return @retorno
   end
go

-- NFEPERIPI: percentual do IPI

-- NFEVALIPI: valor do IPI = NFETOTITE * NFEPERIPI / 100

drop function NFEVALIPI
go

create function NFEVALIPI(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3) ,@item smallint)
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.NFETOTITE(NFEEMPCOD,NFETIP,NFENUM,NFECOD,SEREMPCOD,SERCOD,NFEITE) * NFEPERIPI / 100
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEITE = @item)
      return @retorno
   end
go


-- NFEVALPISENT: valor do PIS
-- NFETOTITE * NFEPISENT / 100

drop function NFEVALPISENT
go

create function NFEVALPISENT(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3) ,@item smallint)
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.NFETOTITE(NFEEMPCOD,NFETIP,NFENUM,NFECOD,SEREMPCOD,SERCOD,NFEITE) * NFEPISENT / 100
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEITE = @item)
      return @retorno
   end
go


-- NFEVALCOFINSE: valor do COFINS
-- NFETOTITE * NFECOFINSE / 100

drop function NFEVALCOFINSE
go

create function NFEVALCOFINSE(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3) ,@item smallint)
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.NFETOTITE(NFEEMPCOD,NFETIP,NFENUM,NFECOD,SEREMPCOD,SERCOD,NFEITE) * NFECOFINSE / 100
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEITE = @item)
      return @retorno
   end
go


-- NFETOTPAR: valor total das parcelas
-- SUM(NFEVALPAR)

drop function NFETOTPAR
go

create function NFETOTPAR(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFEVALPAR),0)
                        from TBS0593 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie)
      return @retorno
   end
go


-- NFETOTBRU: valor total dos produtos = SUM(NFETOTITEBRU)

drop function NFETOTBRU
go

create function NFETOTBRU(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFETOTITEBRU(NFEEMPCOD,NFETIP,NFENUM,NFECOD,SEREMPCOD,SERCOD,NFEITE)),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie)
      return @retorno
   end
go


-- NFETOTLIQ: valor total da nota = NFETOTBRU + NFEVALFRE + NFEVALDES + NFETOTIPI + NFEVALSUB + NFEVALSEG - NFEVDDTOT

drop function NFETOTLIQ
go

create function NFETOTLIQ(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.NFETOTBRU(NFEEMPCOD,NFETIP,NFENUM,NFECOD,SEREMPCOD,SERCOD) + NFEVALFRE + NFEVALDES + NFETOTIPI + NFEVALSUB +
                                        NFEVALSEG - NFEVDDTOT),0)
                        from TBS059 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie)
      return @retorno
   end
go


-- NFETOTOPE: valor total da nota

drop function NFETOTOPE
go

create function NFETOTOPE(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFETOTOPEITE),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie)
      return @retorno
   end
go

-- NFETOTDES: valor total do desconto

drop function NFETOTDES
go

create function NFETOTDES(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFEVALDESITE),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie)
      return @retorno
   end
go

-- NFETOTFRE: valor total do frete

drop function NFETOTFRE
go

create function NFETOTFRE(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFEVALFREITE),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie)
      return @retorno
   end
go

-- NFETOTSEG: valor total do seguro

drop function NFETOTSEG
go

create function NFETOTSEG(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFEVALSEGITE),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie)
      return @retorno
   end
go

-- NFETOTOUT: valor total de outras despesas

drop function NFETOTOUT
go

create function NFETOTOUT(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFEVALOUTDES),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie)
      return @retorno
   end
go

-- NFETOTBICMS: valor total da base do ICMS

drop function NFETOTBICMS
go

create function NFETOTBICMS(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFEBASICMS),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie)
      return @retorno
   end
go

-- NFETOTBICMSSEMST: valor total da base do ICMS .. sem ST para gerar SPED

drop function NFETOTBICMSSEMST
go

create function NFETOTBICMSSEMST(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFEBASICMS),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEBASICMSST=0)
      return @retorno
   end
go

-- NFETOTBCICMSSN: valor da base de cr�dito do simples nacional ... sum(NFETOTOPEITE)

drop function NFETOTBCICMSSN
go

create function NFETOTBCICMSSN(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFETOTOPEITE),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEVCRESN > 0)
      return @retorno
   end
go

-- NFETOTBCICMSSNSEMST: valor da base de cr�dito do simples nacional sem ST

drop function NFETOTBCICMSSNSEMST
go

create function NFETOTBCICMSSNSEMST(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFETOTOPEITE),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEVCRESN > 0 and NFEBASICMSST=0)
      return @retorno
   end
go

-- NFETOTVICMS: valor total do ICMS

drop function NFETOTVICMS
go

create function NFETOTVICMS(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFEVALICMS),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie)
      return @retorno
   end
go

-- NFETOTVICMSSEMST: valor total do ICMS .. sem ST para gerar SPED

drop function NFETOTVICMSSEMST
go

create function NFETOTVICMSSEMST(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFEVALICMS),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEBASICMSST=0)
      return @retorno
   end
go

-- NFETOTVICMSSN: valor do ICMS de cr�dito do simples nacional ... sum(NFEVCRESN)

drop function NFETOTVICMSSN
go

create function NFETOTVICMSSN(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFEVCRESN),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEVCRESN > 0)
      return @retorno
   end
go

-- NFETOTVICMSSNSEMST: valor do ICMS de cr�dito do simples nacional sem ST

drop function NFETOTVICMSSNSEMST
go

create function NFETOTVICMSSNSEMST(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFEVCRESN),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEVCRESN > 0 and NFEBASICMSST=0)
      return @retorno
   end
go

-- NFEBASICMSST: valor total da base do ICMS-ST

drop function NFETOTBICMSST
go

create function NFETOTBICMSST(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFEBASICMSST),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie)
      return @retorno
   end
go

-- NFETOTVIPI: valor total do IPI

drop function NFETOTVIPI
go

create function NFETOTVIPI(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFEVALIPI),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie)
      return @retorno
   end
go

-- NFETOTVPIS: valor total do PIS

drop function NFETOTVPIS
go

create function NFETOTVPIS(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFEVALPIS),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie)
      return @retorno
   end
go


-- NFETOTVICMSST: valor total do ICMS-ST

drop function NFETOTVICMSST
go

create function NFETOTVICMSST(@empnota smallint ,@tipo char(1) ,@nota decimal(10) ,@codfornecedor int ,@empserie smallint ,@serie char(3))
        returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(NFEVALICMSST),0)
                        from TBS0591 (nolock)
                       where NFEEMPCOD = @empnota and NFETIP = @tipo and NFENUM = @nota and NFECOD = @codfornecedor and SEREMPCOD = @empserie and
                             SERCOD = @serie)
      return @retorno
   end
go



--------


create function DIsuzanoPrazPagto(@titulo int ,@empcli smallint ,@codcli int)
        returns smallint as
   begin
      declare @retorno smallint
      set @retorno = datediff(day,
                              (select TBS056.CREDATEMI from TBS056 (nolock)
                                where TBS056.CRETIT = @titulo and TBS056.CLIEMPCOD = @empcli and TBS056.CLICOD = @codcli and TBS056.CRETITORI = 'A'),
                              (select max(TBS056.CREDATVENREA) from TBS056 (nolock)
                                where TBS056.CRETIT = @titulo and TBS056.CLIEMPCOD = @empcli and TBS056.CLICOD = @codcli and TBS056.CRETITORI = 'A'))/
                              (select count(*) from TBS056 (nolock)
                                where TBS056.CRETIT = @titulo and TBS056.CLIEMPCOD = @empcli and TBS056.CLICOD = @codcli and TBS056.CRETITORI = 'A')
      return @retorno
   end
go

-- verifica se nota fiscal de saida foi cancelada

drop function NFSCAN
go

create function NFSCAN(@empresa smallint ,@nf int) returns int as
   begin
      declare @retorno int
      set @retorno = (select 1 from TBS067 (nolock) where NFSEMPCOD = @empresa and NFSNUM = @nf and NFSCAN = 'S')
      return @retorno
   end
go


-- retorna preco custo venda gz

drop function M2_PRECUS
go

create function M2_PRECUS(@empresa smallint ,@loja smallint ,@caixa smallint ,@data datetime ,@hora char(5) ,@doc int, @pedido char(8) @tipdoc char(1) ,
                          @tipreg char(2) ,@produto char(15) ,@ordem int ,@finvenda char(3) ,@codtit int) returns int as
   begin
      declare @retorno int
      set @retorno = (select M2_PRECUS from MSL002 (nolock)
                       where M2_EMPCOD = @empresa and M2_LOJ = @loja and M2_CXA = @caixa and M2_DAT = @data and M2_HOR = @hora and M2_NUMDOC = @doc and
                             M2_NUMPED = @pedido and M2_TIPDOC = @tipdoc and M2_TIPREG = @tipreg and M2_PROCOD = @produto and M2_NUMORDITE = @ordem and
                             M2_FINVEN = @finvenda and M2_CODTIT = @codtit)
      return @retorno
   end
go



-- pol�tica de pre�os

drop function PDPCUSBAS
go

create function PDPCUSBAS(@empresa smallint ,@produto char(15)) returns smallmoney as
   begin
      declare @retorno smallmoney
      set @retorno = (select PDPPREUNI * case when PDPPDD1 > 0 then (100-PDPPDD1)/100 else 1 end * case when PDPPDD2 > 0 then (100-PDPPDD2)/100 else 1 end * case when PDPPDD3 > 0 then (100 - PDPPDD3)/100 else 1 end * case when PDPPDD4 > 0 then (100-PDPPDD4)/100 else 1 end * case when PDPPDD5 > 0 then (100-PDPPDD5)/100 else 1 end * case when PDPIPI > 0 then 1+PDPIPI/100 else 1 end * case when PDPDIFICM > 0 then 1+PDPDIFICM/100 else 1 end * case when PDPPIS > 0 then 1+PDPPIS/100 else 1 end * case when PDPCOF > 0 then 1+PDPCOF/100 else 1 end * case when PDPFRE > 0 then 1+PDPFRE/100 else 1 end * case when PDPCUSADM > 0 then 1+PDPCUSADM/100 else 1 end * case when PDPCMS > 0 then 1+PDPCMS/100 else 1 end * case when PDPPORST > 0 then 1+PDPPORST/100 else 1 end
                        from TBS015 (nolock)
                       where PDPEMPCOD=@empresa and PDPCOD=@produto)
                             
      return @retorno
   end
go

PDPPREUNI * iif(PDPPDD1 > 0, ((100 - PDPPDD1) / 100), 1) * iif(PDPPDD2 > 0, ((100 - PDPPDD2) / 100), 1) * iif(PDPPDD3 > 0, ((100 - PDPPDD3) / 100), 1) * iif( PDPPDD4 > 0, ((100 - PDPPDD4) / 100), 1) * iif(PDPPDD5 > 0, ((100 - PDPPDD5) / 100), 1) * iif(PDPIPI > 0, (1 + (PDPIPI / 100)), 1) * iif(PDPDIFICM > 0, ( 1 + (PDPDIFICM / 100)), 1) * iif(PDPPIS > 0, (1 + (PDPPIS / 100)), 1) * iif(PDPCOF > 0, (1 + (PDPCOF / 100)), 1) * iif(PDPFRE > 0, (1 + (PDPFRE / 100)), 1) * iif(PDPCUSADM > 0, (1 + (PDPCUSADM / 100)), 1) * iif(PDPCMS > 0, (1 + (PDPCMS / 100)), 1) * iif(PDPPORST > 0, (1 + (PDPPORST / 100)), 1)

select dbo.PDPCUSBAS(0,'0100030')


drop function PDPCUSAQU
go

create function PDPCUSAQU(@empresa smallint ,@produto char(15)) returns smallmoney as
   begin
      declare @retorno smallmoney
      set @retorno = (select PDPPREUNI
                             * case when PDPPDD1 > 0 then 1-PDPPDD1/100 else 1 end
                             * case when PDPPDD2 > 0 then 1-PDPPDD2/100 else 1 end
                             * case when PDPPDD3 > 0 then 1-PDPPDD3/100 else 1 end
                             * case when PDPPDD4 > 0 then 1-PDPPDD4/100 else 1 end
                             * case when PDPPDD5 > 0 then 1-PDPPDD5/100 else 1 end
                             * case when PDPIPI > 0 then 1+PDPIPI/100 else 1 end
                             --* case when PDPPIS > 0 then 1+PDPPIS/100 else 1 end
                             --* case when PDPCOF > 0 then 1+PDPCOF/100 else 1 end
                             * case when PDPPORST > 0 then 1+PDPPORST/100 else 1 end
							 * case when PDPFRE > 0 then 1+PDPFRE/100 else 1 end
                        from TBS015 (nolock)
                       where PDPEMPCOD=@empresa and PDPCOD=@produto)
                             
      return @retorno
   end
go


-- or�amentos

-- or�ametnos ******

-- ORCQTD = quantidade do produto
-- ORCPRE = preco do produto
-- ORCTOTPRO = valor total do produto = ORCPRE * ORCQTD

drop function ORCTOTPRO
go

create function ORCTOTPRO(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select ORCPRE * ORCQTD from TBS0431 (nolock) where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go

-- ORCPEDITE = percentual do desconto por item
-- ORCVDDITE = valor do desconto por item = ORCTOTPRO * ORCPDDITE / 100

drop function ORCVDDITE
go

create function ORCVDDITE(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.ORCTOTPRO(@empresa,@orcamento,@item) * ORCPDDITE / 100 from TBS0431 (nolock)
                       where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go

-- ORCFREITE    = porcentagem do frete por item
-- ORCFREITEVAL = valor do frete por item = ORCTOTPRO * ORCFREITE / 100

drop function ORCFREITEVAL
go

create function ORCFREITEVAL(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.ORCTOTPRO(@empresa,@orcamento,@item) * ORCFREITE / 100 from TBS0431 (nolock)
                       where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go

-- ORCSEGITE    = porcentagem do seguro por item
-- ORCSEGITEVAL = valor do seguro por item = ORCTOTPRO * ORCSEGITE / 100

drop function ORCSEGITEVAL
go

create function ORCSEGITEVAL(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.ORCTOTPRO(@empresa,@orcamento,@item) * ORCSEGITE / 100 from TBS0431 (nolock)
                       where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go

-- ORCDESITE    = porcentagem de outras despesas por item
-- ORCDESITEVAL = valor de outras despesas por item = ORCTOTPRO * ORCDESITE / 100

drop function ORCDESITEVAL
go

create function ORCDESITEVAL(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.ORCTOTPRO(@empresa,@orcamento,@item) * ORCDESITE / 100 from TBS0431 (nolock)
                       where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go

-- ORCTOTITE = valor total do item = ORCTOTPRO - ORCVDDITE + ORCFREITEVAL + ORCSEGITEVAL + ORCDESITEVAL

drop function ORCTOTITE
go

create function ORCTOTITE(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.ORCTOTPRO(@empresa,@orcamento,@item) - dbo.ORCVDDITE(@empresa,@orcamento,@item) + dbo.ORCFREITEVAL(@empresa,@orcamento,@item) +
                             dbo.ORCSEGITEVAL(@empresa,@orcamento,@item) + dbo.ORCDESITEVAL(@empresa,@orcamento,@item)
                        from TBS0431 (nolock)
                       where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go

-- ORCPRELIQ = preco liquido com desconto = ORCTOTITE / ORCQTD

drop function ORCPRELIQ
go

create function ORCPRELIQ(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.ORCTOTITE(@empresa,@orcamento,@item) / case ORCQTD when 0 then 1 else ORCQTD end from TBS0431 (nolock)
                       where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go

-- ORCPBI     = porcentagem para a base de calculo do ICMS
-- ORCBASICMS = valor da base de calculo do ICMS = iif(ORCPERICMS > 0, (ORCTOTITE+iif(ORCDESICMS='S',ORCVDDITE,0)) * (100 - ORCREDBCICMS) / 100, 0)

drop function ORCBASICMS
go

create function ORCBASICMS(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
/*      set @retorno = (select dbo.ORCTOTITE(@empresa,@pedido,@item) * ORCPBI / 100 from TBS0551 (nolock)
                       where ORCEMPCOD = @empresa and ORCNUM = @pedido and ORCITEM = @item) */

      set @retorno = (select case
                                when ORCPERICMS > 0
                                   then
                                      dbo.ORCTOTITE(@empresa,@orcamento,@item) * (100 - ORCREDBCICMS) / 100
                                   else
                                      0
                             end
                        from TBS0431 (nolock)
                       where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)

      return @retorno
   end
go

-- ORCPERICMS = porcentagem do ICMS
-- ORCVALICMS = valor do ICMS = ORCBASICMS * ORCPERICMS / 100

drop function ORCVALICMS
go

create function ORCVALICMS(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.ORCBASICMS(@empresa,@orcamento,@item) * ORCPERICMS / 100 from TBS0431 (nolock)
                       where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go

-- ORCPBIISE     = porcentagem para a base de calculo do ICMS (isento)
-- ORCBASICMSISE = valor da base de calculo do ICMS (isento) = (ORCTOTPRO + ORCFREITEVAL + ORCSEGITEVAL + ORCDESITEVAL) * ORCPBIISE / 100

drop function ORCBASICMSISE
go

create function ORCBASICMSISE(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select (dbo.ORCTOTPRO(@empresa,@orcamento,@item) + dbo.ORCFREITEVAL(@empresa,@orcamento,@item) + dbo.ORCSEGITEVAL(@empresa,@orcamento,@item) +
                              dbo.ORCDESITEVAL(@empresa,@orcamento,@item)) * ORCPBIISE / 100
                        from TBS0431 (nolock)
                       where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go

-- ORCPERICMSISE = porcentagem do ICMS (isento)
-- ORCVALICMSISE = valor do ICMS (isento) = ORCBASICMSISE * ORCPERICMSISE / 100

drop function ORCVALICMSISE
go

create function ORCVALICMSISE(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.ORCBASICMSISE(@empresa,@orcamento,@item) * ORCPERICMSISE / 100 from TBS0431 (nolock)
                      where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go

-- ORCMVA    = margem do valor agregado
-- ORCPBIST  = porcentagem para abase de calculo do ICMS-ST
-- ORCVALAGR = valor agregado = iif(ORCPERICMSST > 0, ORCTOTITE * (100 - ORCREDBCICMSST) / 100 * ORCMVA / 100, 0)

drop function ORCVALAGR
go

create function ORCVALAGR(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when ORCPERICMSST > 0
                                   then
                                      (dbo.ORCTOTITE(@empresa,@orcamento,@item) + dbo.ORCVDDITE(@empresa,@orcamento,@item)) * ORCPBIST / 100 * ORCMVA / 100
                                   else
                                      0
                             end
                        from TBS0431 (nolock)
                       where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go

-- ORCBASICMSST = valor para a base de calculo do ICMS-ST = iif(ORCPERICMSST > 0, ORCTOTITE + ORCVALAGR, 0)

drop function ORCBASICMSST
go

create function ORCBASICMSST(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when ORCPERICMSST > 0
                                   then
                                      dbo.ORCTOTITE(@empresa,@orcamento,@item) + dbo.ORCVDDITE(@empresa,@orcamento,@item) +
                                      dbo.ORCVALAGR(@empresa,@orcamento,@item)
                                   else
                                      0
                             end
                        from TBS0431 (nolock)
                       where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go

-- ORCPERICMSST = porcentagem do ICMS-ST
-- ORCVALICMSST = valor do ICMS-ST = ORCBASICMSST * ORCPERICMSST / 100

drop function ORCVALICMSST
go

create function ORCVALICMSST(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when ORCPBIST > 0
                                   then
                                      dbo.ORCBASICMSST(@empresa,@orcamento,@item) * ORCPERICMSST / 100
                                   else
                                      0
                             end
                        from TBS0431 (nolock)
                       where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go

-- ORCVALICMSSTRET = valor do ICMS-ST retido = iif(ORCPERICMSST > 0, iif(ORCMVA > 0, ORCVALICMSST - ORCVALICMS, ORCVALICMSST), 0)

drop function ORCVALICMSSTRET
go

create function ORCVALICMSSTRET(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when ORCPERICMSST > 0
                                   then
                                      dbo.ORCVALICMSST(@empresa,@orcamento,@item) - dbo.ORCVALICMS(@empresa,@orcamento,@item)
                                   else
                                      0
                             end
                        from TBS0431 (nolock)
                       where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go

-- ORCTOTITEST = valor total do item + valor do ICMS-ST = iif(ORCPERICMSST > 0, ORCTOTITE + ORCVALICMSSTRET, ORCTOTITE)

drop function ORCTOTITEST
go

create function ORCTOTITEST(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when ORCPERICMSST > 0
                                   then
                                      dbo.ORCTOTITE(@empresa,@orcamento,@item) + dbo.ORCVALICMSSTRET(@empresa,@orcamento,@item)
                                   else
                                      dbo.ORCTOTITE(@empresa,@orcamento,@item)
                             end
                        from TBS0431 (nolock)
                       where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go

-- ORCPRECUS = preco de custo da mercadoria
-- ORCVALCUS = valor do custo do item = ORCQTD * ORCPRECUS

drop function ORCVALCUS
go

create function ORCVALCUS(@empresa smallint ,@orcamento int ,@item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select ORCQTD * ORCPRECUS from TBS0431 (nolock) where ORCEMPCOD = @empresa and ORCNUM = @orcamento and ORCITEM = @item)
      return @retorno
   end
go



-- ORCPERLUC = percentual de lucro sobre a venda = iif(ORCPRECUS > 0 and ORCTOTITE+iif(ORCDESICMS='S',ORCVDDITE,0)>0,(1-ORCVALCUS/(ORCTOTITE+iif(ORCDESICMS='S',ORCVDDITE,0)))*100,0)

-- ORCDIVLUC = iif(ORCPRECUS>0 and ORCTOTITE+iif(ORCDESICMS='S',ORCVDDITE,0)>0,ORCVALCUS/(ORCTOTITE+iif(ORCDESICMS='S',ORCVDDITE,0))*100,0)

-- ORCMACKUP = iif(ORCPRECUS>0 and ORCTOTITE+iif(ORCDESICMS='S',ORCVDDITE,0)>0,(ORCTOTITE+iif(ORCDESICMS='S',ORCVDDITE,0)-ORCVALCUS)/(ORCVALCUS/100),0)

-- ORCVALCOM = (ORCTOTITEST * ORCPERCOM / 100)

-- ORCVALBLQ = iif(ORCBLQPRE = 'S', ORCTOTITEST, 0)

-- ORCQTDBLQ = iif(ORCBLQPRE = 'S', ORCQTD, 0)


-- ORCTOTBRU = valor total dos produtos = SUM(ORCTOTPRO)

drop function ORCTOTBRU
go

create function ORCTOTBRU(@empresa smallint ,@orcamento int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.ORCTOTPRO(@empresa,@orcamento,ORCITEM)),0) from TBS0431 (nolock) where ORCEMPCOD = @empresa and ORCNUM = @orcamento)
      return @retorno
   end
go

-- ORCVDDTOT = valor total do desconto = SUM(ORCVDDITE)

drop function ORCVDDTOT
go

create function ORCVDDTOT(@empresa smallint ,@orcamento int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.ORCVDDITE(@empresa,@orcamento,ORCITEM)),0) from TBS0431 (nolock) where ORCEMPCOD = @empresa and ORCNUM = @orcamento)
      return @retorno
   end
go

-- ORCTOTLIQ = valor total liquido do pedido = SUM(ORCTOTITEST)

drop function ORCTOTLIQ
go

create function ORCTOTLIQ(@empresa smallint ,@orcamento int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.ORCTOTITEST(@empresa,@orcamento,ORCITEM)),0) from TBS0431 (nolock) where ORCEMPCOD = @empresa and ORCNUM = @orcamento)
      return @retorno
   end
go

-- PDVTOTBAS = valor total base para calculo do ICMS = SUM(PDVBASICMS)

drop function PDVTOTBAS
go

create function PDVTOTBAS(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDVBASICMS(@empresa,@pedido,PDVITEM)),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVTOTICMS = valor total do ICMS = SUM(PDVVALICMS)

drop function PDVTOTICMS
go

create function PDVTOTICMS(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDVVALICMS(@empresa,@pedido,PDVITEM)),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVTOTICMSISE = valor total do ICMS isento = SUM(PDVVALICMSISE)

drop function PDVTOTICMSISE
go

create function PDVTOTICMSISE(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDVVALICMSISE(@empresa,@pedido,PDVITEM)),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVQTDTOT = quantidade total do pedido = SUM(PDVQTD)

drop function PDVQTDTOT
go

create function PDVQTDTOT(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(PDVQTD),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVQTDTOTF = quantidade total do pedido = SUM(PDVQTDFAT)

drop function PDVQTDTOTF
go

create function PDVQTDTOTF(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(PDVQTDFAT),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVTOTFAT = valor total faturado = PDVTOTLIQ / PDVQTDTOT * PDVQTDTOTF

drop function PDVTOTFAT
go

create function PDVTOTFAT(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when isnull(dbo.PDVTOTLIQ(@empresa,@pedido),0) > 0 and isnull(dbo.PDVQTDTOT(@empresa,@pedido),0) > 0 then
                                   isnull(dbo.PDVTOTLIQ(@empresa,@pedido) / dbo.PDVQTDTOT(@empresa,@pedido) * dbo.PDVQTDTOTF(@empresa,@pedido),0)
                                else
                                   0
                             end
                        from TBS055 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVQTDTOTB = quantidade total de itens bloqueados por preco = SUM(PDVQTDBLQ)

drop function PDVQTDTOTB
go

create function PDVQTDTOTB(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(sum(dbo.PDVQTDBLQ(@empresa,@pedido,PDVITEM)),0) from TBS0551 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVTOTBLQ = valor total bloqueado por preco = PDVTOTLIQ / PDVQTDTOT * PDVQTDTOTB

drop function PDVTOTBLQ
go

create function PDVTOTBLQ(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when isnull(dbo.PDVTOTLIQ(@empresa,@pedido),0) > 0 and isnull(dbo.PDVQTDTOT(@empresa,@pedido),0) > 0 then
                                   isnull(dbo.PDVTOTLIQ(@empresa,@pedido) / dbo.PDVQTDTOT(@empresa,@pedido) * dbo.PDVQTDTOTB(@empresa,@pedido),0)
                                else
                                   0
                             end
                        from TBS055 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go

-- PDVTOTLIB = valor total liberado por preco = PDVTOTLIQ - PDVTOTFAT - PDVTOTBLQ

drop function PDVTOTLIB
go

create function PDVTOTLIB(@empresa smallint ,@pedido int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select isnull(dbo.PDVTOTLIQ(@empresa,@pedido) - dbo.PDVTOTFAT(@empresa,@pedido) - dbo.PDVTOTBLQ(@empresa,@pedido),0)
                        from TBS055 (nolock) where PDVEMPCOD = @empresa and PDVNUM = @pedido)
      return @retorno
   end
go



-- custo aquisi��o

-- NFEBASICMS : valor da base do icms
-- NFEVALICMS : valor do ICMS
-- NFETOTOPEITE : valor total da opera��o .. c/desconto, c/despesa (frete, seguro, outras), c/valor da ST e IPI


select * from TBS0591 (nolock) where NFENUM=68496 and NFEITE in(5,6) order by NFEITE

select NFEDATEFE,TBS0591.NFENUM,TBS0591.NFECOD,NFEITEXML
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT >= '20170101' and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S'
 group by NFEDATEFE,TBS0591.NFENUM,TBS0591.NFECOD,NFEITEXML having count(*) > 1 order by NFEDATEFE desc

select NFENUM,NFECOD,NFEITEXML from TBS0591 (nolock) group by NFENUM,NFECOD,NFEITEXML having count(*) > 1

select * from tt.SIBD.dbo.TBS0591 (nolock) where NFENUM=403341 and NFEITE in(4,5) order by NFEITE

select * from tt.SIBD.dbo.TBS0591 where NFENUM=403341

select * from TBS122 (nolock)

select * from master..sysservers

drop table #CFOP

declare @data char(8)

set @data='20160101'

-- tanby matriz
select NFECFOP into #CFOP
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT >= @data and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and NFEDATEFE<>'17530101'
union
-- tanby taubate
select NFECFOP collate database_default
  from tt.SIBD.dbo.TBS0591 inner join tt.SIBD.dbo.TBS059 on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT >= @data and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and NFEDATEFE<>'17530101'
union
-- tanby deposito
select NFECFOP collate database_default
  from cd.SIBD.dbo.TBS0591 inner join cd.SIBD.dbo.TBS059 on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT >= @data and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and NFEDATEFE<>'17530101'
union
-- best bag
select NFECFOP collate database_default
  from bb.SIBD2.dbo.TBS0591 inner join bb.SIBD2.dbo.TBS059 on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT >= @data and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and NFEDATEFE<>'17530101'
union
-- misaspel
select NFECFOP collate database_default
  from mi.SIBD.dbo.TBS0591 inner join mi.SIBD.dbo.TBS059 on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT >= @data and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and NFEDATEFE<>'17530101'
union
-- papelyna
select NFECFOP collate database_default
  from py.SIBD.dbo.TBS0591 inner join py.SIBD.dbo.TBS059 on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT >= @data and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and NFEDATEFE<>'17530101'


select * from TBS041 (nolock) where COPTIP='E' order by COPCOD

select * from #CFOP where not exists(select '' from TBS041 (nolock) where COPTIP='E' and subString(#CFOP.NFECFOP,1,2)+COPCOD=#CFOP.NFECFOP)


select NFECFOP,TBS0591.NFENUM
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT >= '20160101' and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and NFEDATEFE<>'17530101' and NFECFOP='1.405'
 group by NFECFOP,TBS0591.NFENUM order by NFECFOP



select TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,PROCOD,max(NFEDATEFE)
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT >= '20161001' and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' 
 group by TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,PROCOD order by PROCOD


-- NFEBASICMS   : valor da base do icms
-- NFEVALICMS   : valor do ICMS
-- NFETOTOPEITE : valor total da opera��o .. c/desconto, c/despesa (frete, seguro, outras), c/valor da ST e IPI
-- NFEVALCOFINS : valor da COFINS
-- NFEVALPIS    : valor do PIS

-- isen��o PIS/COFINS c�digos 6 a 9

-- total item (valor nota) sem ipi/st (A)
-- A - pis - cofins (B)
-- B - icms (se mercadoria sem ST) (B)
-- B + st + ipi



drop function NFECUSAQU
go

create function NFECUSAQU(@empnota smallint, @tipo char(1), @nota decimal(10), @codfornecedor int, @empserie smallint, @serie char(3), @item smallint) returns decimal(16,6) as
   begin
      declare @retorno decimal(16,6)
      set @retorno = (select ( NFETOTOPEITE -
                                  case
                                     -- subtrai ICMS se produto sem ST
                                     when NFEVALICMSST > 0 then 0
                                     else NFEVALICMS
                                  end
                                  -
                                  -- subtrai PIS/COFINS
                                  ( case
                                       when PROSTBPIS between '06' and '09' then 0
                                       --else (NFETOTOPEITE - NFEVALICMSST - NFEVALIPI) * 1.65 /100
                                       else (NFETOTOPEITE - NFEVALICMSST) * 1.65 /100
                                    end +
                                    case
                                       when PROSTBCOFINS between '06' and '09' then 0
                                       else (NFETOTOPEITE - NFEVALICMSST) * 7.6 /100
                                    end
                                  )

                                  -- soma frete pago para transportadora (CT-e)
                                  + NFEVALFREITECTE
                             )

                             /
                             case NFEQTD when 0 then 1 else NFEQTD end
                             /
                             case NFEQTDEMB when 0 then 1 else NFEQTDEMB end -- atualmente a qtde da embalagem � sempre 1... mantido para nf antigas
                        from TBS0591 (nolock) inner join TBS010 (nolock) on TBS010.PROEMPCOD=TBS0591.PROEMPCOD and TBS010.PROCOD=TBS0591.PROCOD
                       where NFEEMPCOD = @empnota and
                             NFETIP = @tipo and
                             NFENUM = @nota and
                             NFECOD = @codfornecedor and
                             SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEITE = @item --and
                             --NFECFOP in('1.102','1.403','1.407','1.556','2.102','2.403','2.407','2.556')
                     )
      return @retorno
   end
go

-- nova versão

drop function NFECUSAQU
go

create function NFECUSAQU(@empnota smallint, @tipo char(1), @nota decimal(10), @codfornecedor int, @empserie smallint, @serie char(3), @item smallint) returns decimal(16,6) as
   begin
      declare @retorno decimal(16,6)
      set @retorno = (select ( NFETOTOPEITE -
                                  case
                                     -- subtrai ICMS se produto sem ST
                                     when NFEVALICMSST > 0 then 0
                                     else NFEVALICMS
                                  end
                                  /*-
                                  -- subtrai PIS/COFINS
                                  ( case
                                       when PROSTBPIS between '06' and '09' then 0
                                       --else (NFETOTOPEITE - NFEVALICMSST - NFEVALIPI) * 1.65 /100
                                       else (NFETOTOPEITE - NFEVALICMSST) * 1.65 /100
                                    end +
                                    case
                                       when PROSTBCOFINS between '06' and '09' then 0
                                       else (NFETOTOPEITE - NFEVALICMSST) * 7.6 /100
                                    end
                                  )*/

                                  - NFEVALPIS
                                  - NFEVALCOFINS

                                  -- soma frete pago para transportadora (CT-e)
                                  + NFEVALFREITECTE
                             )

                             /
                             case NFEQTD when 0 then 1 else NFEQTD end
                             /
                             case NFEQTDEMB when 0 then 1 else NFEQTDEMB end -- atualmente a qtde da embalagem � sempre 1... mantido para nf antigas
                        from TBS0591 (nolock) inner join TBS010 (nolock) on TBS010.PROEMPCOD=TBS0591.PROEMPCOD and TBS010.PROCOD=TBS0591.PROCOD
                       where NFEEMPCOD = @empnota and
                             NFETIP = @tipo and
                             NFENUM = @nota and
                             NFECOD = @codfornecedor and
                             SEREMPCOD = @empserie and
                             SERCOD = @serie and NFEITE = @item --and
                             --NFECFOP in('1.102','1.403','1.407','1.556','2.102','2.403','2.407','2.556')
                     )
      return @retorno
   end
go



select * from TBS0591 (nolock) where NFENUM=331154
--and NFEITE in(4,5)
 order by NFEITE

select NFEITE,NFETOTOPEITE,NFEBASICMS,NFEVALICMS,NFEVALCOFINS,NFEVALPIS,NFEVALICMSST,NFEVALFREITECTE,dbo.NFECUSAQU(0,NFETIP,NFENUM,NFECOD,0,SERCOD,NFEITE)
       ,NFEQTD
       ,NFEQTDEMB
  from TBS0591 (nolock)
 where NFENUM=48429 --15650
       and NFECOD=3512
 order by NFEITE


select *
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT >= '20170101' and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and NFEREDBASICMS > 0
 order by NFEDATEFE desc



select * from TBS010 (nolock) where PROCOD='0090869'

select * from TBS094 (nolock)

select * from TBS095 (nolock)

select * from master..sysservers

with tab as(
--select TBS0591.NFEEMPCOD,
--       TBS0591.NFETIP collate database_default as NFETIP,
--       TBS0591.NFENUM,
--       TBS0591.NFECOD,
--       TBS0591.SEREMPCOD,
--       TBS0591.SERCOD collate database_default as SERCOD,
--       PROCOD collate database_default as PROCOD,
--       NFEDATEFE,
--       sum(dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) as custo,
--       ROW_NUMBER() OVER(ORDER BY PROCOD) AS RANK
--  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
-- where TBS059.NFEDATENT between '20161001' and '20161231' and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and
--       exists(select max(NFEDATEFE)
--                from TBS0591 as T591 (nolock) inner join TBS059 as T59 (nolock) on T591.SERCOD=T59.SERCOD and T591.NFETIP=T59.NFETIP and T591.NFECOD=T59.NFECOD and T591.NFENUM=T59.NFENUM
--               where T591.SERCOD=TBS0591.SERCOD and T591.NFETIP=TBS0591.NFETIP and T591.NFECOD=TBS0591.NFECOD and T591.NFENUM=TBS0591.NFENUM and T591.PROCOD=TBS0591.PROCOD
--               group by NFEDATEFE,PROCOD)
-- group by TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEDATEFE,PROCOD --order by PROCOD
--union
select TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,PROCOD,NFEDATEFE,sum(dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) as custo,
ROW_NUMBER() OVER(ORDER BY PROCOD) AS RANK
  from tt.SIBD.dbo.TBS0591 inner join tt.SIBD.dbo.TBS059 on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT between '20161001' and '20161231' and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and
       exists(select max(NFEDATEFE)
                from tt.SIBD.dbo.TBS0591 as T591 inner join tt.SIBD.dbo.TBS059 as T59 on T591.SERCOD=T59.SERCOD and T591.NFETIP=T59.NFETIP and T591.NFECOD=T59.NFECOD and T591.NFENUM=T59.NFENUM
               where T591.SERCOD=TBS0591.SERCOD and T591.NFETIP=TBS0591.NFETIP and T591.NFECOD=TBS0591.NFECOD and T591.NFENUM=TBS0591.NFENUM and T591.PROCOD=TBS0591.PROCOD
               group by NFEDATEFE,PROCOD)
 group by TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEDATEFE,PROCOD --order by PROCOD
)

--select *,avg(custo) from tab where RANK=(select max(RANK) from tab as b where b.PROCOD=tab.PROCOD group by PROCOD)

select *,(select avg(custo) from tab as b where b.PROCOD=tab.PROCOD group by PROCOD) from tab where RANK=(select max(RANK) from tab as b where b.PROCOD=tab.PROCOD group by PROCOD)

exec tt.SIBD.dbo.NFECUSAQU 0,'N',403341,42,0,'NFE',1


--select * from tab where RANK=(select max(RANK) from tab as b where b.PROCOD=tab.PROCOD group by PROCOD)

--select * from tab where exists(select max(RANK) from tab as b where b.PROCOD=tab.PROCOD group by PROCOD)

--select max(RANK),PROCOD from tab group by PROCOD

--select * from tab where RANK=(select max(RANK) from tab group by PROCOD)

--select max(NFEDATEFE),PROCOD from tab where NFEDATEFE=(select max(NFEDATEFE) from tab group by PROCOD) group by PROCOD
--select * from tab where exists(select max(NFEDATEFE) from tab as b where b.NFEDATEFE=tab.NFEDATEFE and b.PROCOD=tab.PROCOD group by PROCOD)

select max(NFEDATEFE),PROCOD,ROW_NUMBER() OVER(ORDER BY PROCOD) AS RANK --,sum(dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE))
  from TBS0591 (nolock) Left join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATEFE >= '20161001' and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S'
 group by NFEDATEFE,PROCOD
having NFEDATEFE=max(NFEDATEFE)
 order by PROCOD



drop table TABCUSTOS

with 
tab2 as
   (
      select 'tm',EMPCGC collate database_default as EMPCGC from TBS023
      union
      select 'tt',EMPCGC from tt.SIBD.dbo.TBS023
      union
      select 'cd',EMPCGC from cd.SIBD.dbo.TBS023
      union
      select 'bb',EMPCGC from bb.SIBD.dbo.TBS023
      union
      select 'mi',EMPCGC from mi.SIBD.dbo.TBS023
      union
      select 'pp',EMPCGC from py.SIBD.dbo.TBS023
      union
      select 'bo',EMPCGC from bo.SIBD.dbo.TBS023
   )
,
tab as
   (
      select TBS0591.NFEEMPCOD,
             TBS0591.NFETIP,
             TBS0591.NFENUM,
             TBS0591.NFECOD,
             TBS0591.SEREMPCOD,
       TBS0591.SERCOD,
       PROCOD,
       NFEDATEFE,
       sum(dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) as custo,
       ROW_NUMBER() OVER(ORDER BY PROCOD) AS RANK
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
                        inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
 where TBS059.NFEDATEFE between '20160101' and '20161231' and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and
       --FORCGC not in(select * from tab2)
       FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350')


 group by TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEDATEFE,PROCOD --order by NFEDATEFE desc,PROCOD
)

select * into TABCUSTOS
from tab where RANK=(select max(RANK) from tab as b where b.PROCOD=tab.PROCOD group by b.PROCOD)



--exec sp_rename 'TABCUSTOS', 'TABCUSTOS'

drop table TABCUSTOS

with 
   tab as
      (
        select TBS0591.NFEEMPCOD,
               TBS0591.NFETIP,
               TBS0591.NFENUM,
               TBS0591.NFECOD,
               TBS0591.SEREMPCOD,
               TBS0591.SERCOD,
               PROCOD,
               NFEDATEFE,
               dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE) as custo,
               ROW_NUMBER() OVER(ORDER BY PROCOD) AS RANK
          from TBS0591 (nolock) inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
                                inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
         where TBS059.NFEDATEFE between '20160101' and '20161231' and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and
               FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350') and
               NFECFOP in('1.102','1.403','1.407','1.556','2.102','2.403','2.407','2.556')
         group by TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEDATEFE,PROCOD,NFEITE
      )

select NFEEMPCOD,
       NFETIP collate Latin1_General_CI_AS as NFETIP,
       NFENUM,
       NFECOD,
       SEREMPCOD,
       SERCOD collate Latin1_General_CI_AS as SERCOD,
       PROCOD collate database_default as PROCOD,
       NFEDATEFE,
       custo,
       RANK
       into TABCUSTOS
  from tab where RANK=(select max(RANK) from tab as b where b.PROCOD=tab.PROCOD group by b.PROCOD)

select * from TABCUSTOS

drop table CUSTOENT

select * from master..sysservers

with tab as 
   (
      select emp='papelyna',* from TABCUSTOS
--      union
--      select emp='bestbag',* from bb.SIBD2.dbo.TABCUSTOS
--      union
--      select emp='misaspel',* from mi.SIBD.dbo.TABCUSTOS
   )

select * into CUSTOENT from tab where NFEDATEFE=(select max(NFEDATEFE) from tab as b where b.PROCOD=tab.PROCOD group by b.PROCOD)

select * from CUSTOENT2 (nolock) order by PROCOD

select * from #RANK order by RANK,PROCOD





select * from CUSTOENT (nolock)

select PROCOD, count(*) from CUSTOENT group by PROCOD having count(*) > 1

select * from CUSTOENT (nolock) where PROCOD in('8421769','3794521','1160003') order by NFEDATEFE,PROCOD

drop table #INV

select isnull((select top 1 custo from CUSTOENT (nolock) where PROCOD=codigo collate database_default order by NFEDATEFE desc),0) as custoEnt,
       custo,
       media,
       subString(codigo,1,8) as codigo,
       saldo
--       isnull((select custo from CUSTOENT (nolock) where PROCOD=codigo collate database_default),0)*saldo as tot,*
  into #INV
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\tanbym.xlsx', 'select * from [Planilha1$]')


select sum(custoEnt*saldo) from #INV

select * from #INV

select * from CUSTOENT (nolock) where PROCOD='3794728'

select * from CUSTOENT (nolock) where PROCOD='4210271'

select * from CUSTOENT (nolock) where PROCOD in('1640054','1080067')


select NFETOTOPEITE,NFEVALICMSST,NFEVALICMS,NFEQTD,NFEQTDEMB,* from cd.SIBD.dbo.TBS0591 where NFENUM=100832 and PROCOD='3794728' order by NFEITE

select NFETOTOPEITE,NFEVALICMSST,NFEVALICMS,NFEQTD,NFEQTDEMB,* from TBS0591 (nolock) where NFENUM=100832 and PROCOD='3794728' order by NFEITE

select * from TBS0591 (nolock) where NFEQTDEMB=0

update TBS0591 set NFEQTDEMB=1 where NFEQTDEMB=0


--

select top 10 * from TBS031 (nolock)

                                        case
                                           when NFEVALICMSST > 0 then 0
                                           else NFEVALICMS
                                        end -
                                        ( case
                                             when PROSTBPIS between '06' and '09' then 0
                                             else NFETOTOPEITE * 1.65 /100
                                          end +
                                          case
                                             when PROSTBCOFINS between '06' and '09' then 0
                                             else NFETOTOPEITE * 7.6 /100
                                          end
                                        )


select CUSTOENT2.PROCOD as codigo,
       PRODES as descricao,
       custo,
       TDPPRECOR1 as precoVendaCheio,
       TDPPRECOR1 -
       case
          when PROSTBB in('00','20','90') then TDPPRECOR1 * 0.18
          else 0
       end -
       case
          when PROSTBPIS between '06' and '09' then 0
          else TDPPRECOR1 * 0.0925
       end
       as precoVendaSemImpostos
  from CUSTOENT2 inner join TBS031 (nolock) on TDPPROCOD=CUSTOENT2.PROCOD
                 inner join TBS010 (nolock) on TBS010.PROCOD=CUSTOENT2.PROCOD




-- custo m�dio mensal

drop table TABCUSTOSM

with 
   tab as
      (
        select TBS0591.NFEEMPCOD,
               TBS0591.NFETIP,
               TBS0591.NFENUM,
               TBS0591.NFECOD,
               TBS0591.SEREMPCOD,
               TBS0591.SERCOD,
               PROCOD,
               NFEDATEFE,
               dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE) as custo,
               ROW_NUMBER() OVER(ORDER BY PROCOD) AS RANK
          from TBS0591 (nolock) inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
                                inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
         where TBS059.NFEDATEFE between '20160101' and '20161231' and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and
               FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350') and
               NFECFOP in('1.102','1.403','1.407','1.556','2.102','2.403','2.407','2.556')
         group by TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEDATEFE,PROCOD,NFEITE
         order by TBS059.NFEDATEFE
      )

select NFEEMPCOD,
       NFETIP collate database_default as NFETIP,
       NFENUM,
       NFECOD,
       SEREMPCOD,
       SERCOD collate database_default as SERCOD,
       PROCOD collate database_default as PROCOD,
       NFEDATEFE,
       custo,
       RANK
       into TABCUSTOSM
  from tab where RANK=(select max(RANK) from tab as b where b.PROCOD=tab.PROCOD group by b.PROCOD)

select * from TABCUSTOSM

select * from CUSTOENT (nolock) where PROCOD='1080067'

        select ANO=year(TBS059.NFEDATEFE),
               MES=month(TBS059.NFEDATEFE),
               PROCOD,
               avg(dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) as custo
          from TBS0591 (nolock) inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
                                inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
         where TBS059.NFEDATEFE between '20170101' and '20170630' and TBS0591.NFETIP='N' and TBS059.NFECAN<>'S' and
               FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350') and
               NFECFOP in('1.102','1.403','1.407','1.556','2.102','2.403','2.407','2.556')
and PROCOD='1080067'
         group by year(TBS059.NFEDATEFE),month(TBS059.NFEDATEFE),PROCOD

select top 1 * from TBS124 (nolock)



-- devolu��o de compras

-- NFDTOTPROITE: round(NFDQTD * NFDPRE,2)

drop function NFDTOTPROITE
go

create function NFDTOTPROITE(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select round(NFDQTD * NFDPRE, 2) from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and NFDITE=@item)
      return @retorno
   end
go

-- NFDNFRPRO: sum(NFDTOTPROITE)

drop function NFDNFRPRO
go

create function NFDNFRPRO(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDTOTPROITE(0, 0, SNESER, @nf, NFDITE))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD)
      return @retorno
   end
go

-- NFDTOTLIQITE: <NFDTOTPROITE> - NFDVALDES + NFDVALFRE + NFDVALSEG + NFDVALOUTDES

drop function NFDTOTLIQITE
go

create function NFDTOTLIQITE(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.NFDTOTPROITE(@empresa, @seremp, @serie, @nf, @item) - NFDVALDES + NFDVALFRE + NFDVALSEG + NFDVALOUTDES
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and NFDITE=@item)
      return @retorno
   end
go

-- NFDTOTITE: iif(NFDPERICMSST > 0, <NFDTOTLIQITE> + NFDVALICMSST, <NFDTOTLIQITE>)

drop function NFDTOTITE
go

create function NFDTOTITE(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select dbo.NFDTOTPROITE(@empresa, @seremp, @serie, @nf, @item) + case when NFDPERICMSST > 0 then NFDVALICMSST else 0 end
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and NFDITE=@item)
      return @retorno
   end
go

-- NFDNFRLIQ: sum(NFDTOTITE)

drop function NFDNFRLIQ
go

create function NFDNFRLIQ(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDTOTITE(@empresa, @seremp, @serie, @nf, NFDITE)) -- - NFDVALDES + NFDVALFRE + NFDVALSEG + NFDVALOUTDES)
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD)
      return @retorno
   end
go

-- NFDTOTLIQ: sum(NFDNFRLIQ)

drop function NFDTOTLIQ
go

create function NFDTOTLIQ(@empresa smallint, @seremp smallint, @serie smallint, @nf int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDNFRLIQ(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1171 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf)
      return @retorno
   end
go

-- NFDNFRIPI: sum(NFDVALIPI)

drop function NFDNFRIPI
go

create function NFDNFRIPI(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(NFDVALIPI)
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD)
      return @retorno
   end
go

-- NFDTOTIPI: sum(NFDNFRIPI)

drop function NFDTOTIPI
go

create function NFDTOTIPI(@empresa smallint, @seremp smallint, @serie smallint, @nf int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDNFRIPI(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf)
      return @retorno
   end
go


-- NFDTOTNOTA: sum(NDFTOTLIQST + NDFTOTIPI)    sum(NFDTOTLIQ + NFDTOTIPI)

drop function NDFTOTNOT
go

create function NFDTOTNOTA(@empresa smallint, @seremp smallint, @serie smallint, @nf int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDTOTLIQ(@empresa, @seremp, @serie, @nf) + dbo.NFDTOTIPI(@empresa, @seremp, @serie, @nf))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf)
      return @retorno
   end
go

-- NFDNFRDES: sum(NFDVALDES)

drop function NFDNFRDES
go

create function NFDNFRDES(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(NFDVALDES)
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD)
      return @retorno
   end
go

-- NFDTOTDES: sum(NFDNFRDES)

drop function NFDTOTDES
go

create function NFDTOTDES(@empresa smallint, @seremp smallint, @serie smallint, @nf int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDNFRDES(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf)
      return @retorno
   end
go

-- NFDTOTPRO: sum(NFDNFRPRO)

drop function NFDTOTPRO
go

create function NFDTOTPRO(@empresa smallint, @seremp smallint, @serie smallint, @nf int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDNFRPRO(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf)
      return @retorno
   end
go

-- NFDNFRFRE: sum(NFDVALFRE)

drop function NFDNFRFRE
go

create function NFDNFRFRE(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(NFDVALFRE)
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD)
      return @retorno
   end
go

-- NFDTOTDES: sum(NFDNFRDES)

drop function NFDTOTFRE
go

create function NFDTOTFRE(@empresa smallint, @seremp smallint, @serie smallint, @nf int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDNFRFRE(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf)
      return @retorno
   end
go

-- NFDNFRSEG: sum(NFDVALSEG)

drop function NFDNFRSEG
go

create function NFDNFRSEG(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(NFDVALSEG)
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD)
      return @retorno
   end
go

-- NFDTOTDES: sum(NFDNFRDES)

drop function NFDTOTSEG
go

create function NFDTOTSEG(@empresa smallint, @seremp smallint, @serie smallint, @nf int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDNFRSEG(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf)
      return @retorno
   end
go

-- NFDNFROUTDES: sum(NFDVALOUTDES)

drop function NFDNFROUTDES
go

create function NFDNFROUTDES(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(NFDVALOUTDES)
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD)
      return @retorno
   end
go

-- NFDTOTOUTDES: sum(NFDNFROUTDES)

drop function NFDTOTOUTDES
go

create function NFDTOTOUTDES(@empresa smallint, @seremp smallint, @serie smallint, @nf int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDNFROUTDES(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf)
      return @retorno
   end
go

-- NFDNFRICMSST: sum(NFDVALICMSST)

drop function NFDNFRICMSST
go

create function NFDNFRICMSST(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(NFDVALICMSST)
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD)
      return @retorno
   end
go

-- NFDTOTICMSST: sum(NFDNFRICMSST)

drop function NFDTOTICMSST
go

create function NFDTOTICMSST(@empresa smallint, @seremp smallint, @serie smallint, @nf int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDNFRICMSST(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf)
      return @retorno
   end
go

-- NFDNFRBASICMS: sum(NFDBASICMS)

drop function NFDNFRBASICMS
go

create function NFDNFRBASICMS(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(NFDBASICMS)
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD)
      return @retorno
   end
go

-- NFDNFRBASICMSSEMST: sum(NFDBASICMS)

drop function NFDNFRBASICMSSEMST
go

create function NFDNFRBASICMSSEMST(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(NFDBASICMS - NFDVALICMS)
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD and
                             NFDBASICMSST=0)
      return @retorno
   end
go

-- NFDTOTBASICMS: sum(NFDNFRBASICMS)

drop function NFDTOTBASICMS
go

create function NFDTOTBASICMS(@empresa smallint, @seremp smallint, @serie smallint, @nf int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDNFRBASICMS(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf)
      return @retorno
   end
go

-- NFDTOTBASICMSSEMST: sum(NFDNFRBASICMS) ... ICMS sem ST, para gerar SPED

drop function NFDTOTBASICMSSEMST
go

create function NFDTOTBASICMSSEMST(@empresa smallint, @seremp smallint, @serie smallint, @nf int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDNFRBASICMS(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDBASICMSST=0)
      return @retorno
   end
go

-- NFDNFRICMS: sum(NFDVALICMS)

drop function NFDNFRICMS
go

create function NFDNFRICMS(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(NFDVALICMS)
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD)
      return @retorno
   end
go

-- NFDNFRICMSSEMST: sum(NFDVALICMS)

drop function NFDNFRICMSSEMST
go

create function NFDNFRICMSSEMST(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(NFDVALICMS)
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD and
                             NFDBASICMSST=0)
      return @retorno
   end
go

-- NFDTOTICMS: sum(NFDNFRICMS)

drop function NFDTOTICMS
go

create function NFDTOTICMS(@empresa smallint, @seremp smallint, @serie smallint, @nf int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDNFRICMS(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf)
      return @retorno
   end
go

-- NFDTOTICMSSEMST: sum(NFDNFRICMS)

drop function NFDTOTICMSSEMST
go

create function NFDTOTICMSSEMST(@empresa smallint, @seremp smallint, @serie smallint, @nf int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDNFRICMSSEMST(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf)
      return @retorno
   end
go

-- NFDVALPIS: round(NFDTOTLIQITE * NFDPERPIS / 100,2)

drop function NFDVALPIS
go

create function NFDVALPIS(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select round(dbo.NFDTOTLIQITE(@empresa, @seremp, @serie, @nf, NFDITE) * NFDPERPIS /100 ,2)
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD)
      return @retorno
   end
go

-- NFDNFRPIS: sum(NFDVALPIS)

drop function NFDNFRPIS
go

create function NFDNFRPIS(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDVALPIS(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD)
      return @retorno
   end
go

-- NFDTOTPIS: sum(NFDNFRPIS)

drop function NFDTOTPIS
go

create function NFDTOTPIS(@empresa smallint, @seremp smallint, @serie smallint, @nf int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDNFRPIS(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf)
      return @retorno
   end
go

-- NFDVALCOFINS: round(NFDTOTLIQITE * NFDPERCOFINS / 100,2)

drop function NFDVALCOFINS
go

create function NFDVALCOFINS(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select round(dbo.NFDTOTLIQITE(@empresa, @seremp, @serie, @nf, NFDITE) * NFDPERCOFINS /100 ,2)
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD)
      return @retorno
   end
go

-- NFDNFRCOFINS: sum(NFDVALCOFINS)

drop function NFDNFRCOFINS
go

create function NFDNFRCOFINS(@empresa smallint, @seremp smallint, @serie smallint, @nf int, @NFDNFEEMP smallint, @NFDNFETIP char(1), @NFDNFENUM int, @NFDSEREMP smallint,
                          @NFDSERCOD char(3)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDVALCOFINS(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf and
                             NFDNFEEMP=@NFDNFEEMP and NFDNFETIP=@NFDNFETIP and NFDNFENUM=@NFDNFENUM and NFDSEREMP=@NFDSEREMP and NFDSERCOD=@NFDSERCOD)
      return @retorno
   end
go

-- NFDTOTCOFINS: sum(NFDNFRCOFINS)

drop function NFDTOTCOFINS
go

create function NFDTOTCOFINS(@empresa smallint, @seremp smallint, @serie smallint, @nf int) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select sum(dbo.NFDNFRCOFINS(@empresa, @seremp, @serie, @nf, NFDNFEEMP, NFDNFETIP, NFDNFENUM, NFDSEREMP, NFDSERCOD))
                        from TBS1172 (nolock)
                       where NFDEMPCOD=@empresa and SNEEMPCOD=@seremp and SNESER=@serie and NFDNUM=@nf)
      return @retorno
   end
go



-- CT-E

-- CTEENTTOTFRE: CTEENTFREPES + CTEENTFREVAL + CTEENTGRIS + CTEENTPED + CTEENTTRT + CTEENTTDE + CTEENTSECCAT + CTEENTDES + CTEENTSEG + CTEENTTAX + CTEENTOUT

drop function CTEENTTOTFRE
go

create function CTEENTTOTFRE(@empresa smallint, @chave varchar(44)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select CTEENTFREPES + CTEENTFREVAL + CTEENTGRIS + CTEENTPED + CTEENTTRT + CTEENTTDE + CTEENTSECCAT + CTEENTDES + CTEENTSEG + CTEENTTAX + CTEENTOUT
                        from TBS130 (nolock)
                       where CTEENTEMP=@empresa and CTEENTCHA=@chave)
      return @retorno
   end
go

-- CTEENTVALICM: (CTEENTBASICM * ((100 - CTEENTBASRED) / 100)) * CTEENTPERICM / 100

drop function CTEENTVALICM
go

create function CTEENTVALICM(@empresa smallint, @chave varchar(44)) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select (CTEENTBASICM * ((100 - CTEENTBASRED) / 100)) * CTEENTPERICM / 100
                        from TBS130 (nolock)
                       where CTEENTEMP=@empresa and CTEENTCHA=@chave)
      return @retorno
   end
go

-- tabela de preços

-- custo base com frete

drop function TDPCUSBAS
go

create function TDPCUSBAS(@empresa smallint, @codigo varchar(15), @data date) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select top(1)
                             TDPHISVAL
                        from TBS0311 with (nolock)
                       where TDPHISDAT <= @data
                             and TDPPROCOD=@codigo
                             and TDPHISCPO='TDPCUSBAS'
                       order by TDPHISDAT desc)
      return @retorno
   end
go


-- NOVA DEVOLUÇÃO DE COMPRAS ... AQUI ...

-- NDFTOTBRUITE: round(NDFQTD * NDFPRE,2)

drop function NDFTOTBRUITE
go

create function NDFTOTBRUITE(@empresa smallint, @numdoc smallint, @item smallint) returns decimal(11,3) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select round(NDFQTD * NDFPRE, 2) from TBS1431 (nolock)
                       where NDFEMPCOD=@empresa
                             and NDFNUMDOC=@numdoc
                             and NDFITE=@item)
      return @retorno
   end
go

-- NDFTOTLIQITE: round(NDFTOTBRUITE - NDFVALDESITE + NDFVALFREITE + NDFVALSEGITE + NDFVALOUTDESITE, 3)

drop function NDFTOTLIQITE
go

create function NDFTOTLIQITE(@empresa smallint, @numdoc smallint, @item smallint) returns decimal(11,3) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select round(dbo.NDFTOTBRUITE(@empresa, @numdoc, @item) - NDFVALDESITE + NDFVALFREITE + NDFVALSEGITE + NDFVALOUTDESITE, 3)
                        from TBS1431 (nolock)
                       where NDFEMPCOD=@empresa
                             and NDFNUMDOC=@numdoc
                             and NDFITE=@item)
      return @retorno
   end
go

-- NDFVALPIS: round(NDFTOTLIQITE * NDFPERPIS / 100, 3)

drop function NDFVALPIS
go

create function NDFVALPIS(@empresa smallint, @numdoc smallint, @item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select round(dbo.NDFTOTLIQITE(@empresa, @numdoc, @item) * NDFPERPIS /100, 3)
                        from TBS1431 (nolock)
                       where NDFEMPCOD=@empresa
                             and NDFNUMDOC=@numdoc
                             and NDFITE=@item)
      return @retorno
   end
go

-- NDFVALPISST: round(NDFTOTLIQITE * NDFPERPISST / 100, 3)

drop function NDFVALPISST
go

create function NDFVALPISST(@empresa smallint, @numdoc smallint, @item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select round(dbo.NDFTOTLIQITE(@empresa, @numdoc, @item) * NDFPERPISST /100, 3)
                        from TBS1431 (nolock)
                       where NDFEMPCOD=@empresa
                             and NDFNUMDOC=@numdoc
                             and NDFITE=@item)
      return @retorno
   end
go

-- NDFVALCOFINS: round(NDFTOTLIQITE * NDFPERCOFINS / 100, 3)

drop function NDFVALCOFINS
go

create function NDFVALCOFINS(@empresa smallint, @numdoc smallint, @item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select round(dbo.NDFTOTLIQITE(@empresa, @numdoc, @item) * NDFPERCOFINS /100, 3)
                        from TBS1431 (nolock)
                       where NDFEMPCOD=@empresa
                             and NDFNUMDOC=@numdoc
                             and NDFITE=@item)
      return @retorno
   end
go

-- NDFVALCOFINSST: round(NDFTOTLIQITE * NDFPERCOFINSST / 100, 3)

drop function NDFVALCOFINSST
go

create function NDFVALCOFINSST(@empresa smallint, @numdoc smallint, @item smallint) returns decimal(11,4) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select round(dbo.NDFTOTLIQITE(@empresa, @numdoc, @item) * NDFPERCOFINSST /100, 3)
                        from TBS1431 (nolock)
                       where NDFEMPCOD=@empresa
                             and NDFNUMDOC=@numdoc
                             and NDFITE=@item)
      return @retorno
   end
go

-- NDFVALAGR = iif(NDFPERICMSST > 0, round(NDFBASICMSST * NDFPERMVAST / 100 * (NDFPERIPI / 100 + 1), 3), 0)

drop function NDFVALAGR
go

create function NDFVALAGR(@empresa smallint, @numdoc smallint, @item smallint) returns decimal(11,3) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when NDFPERICMSST > 0
                                   then
                                      round(NDFBASICMSST * NDFPERMVAST / 100 * (NDFPERIPI / 100 + 1), 3)
                                   else
                                      0
                             end
                        from TBS1431 (nolock)
                       where NDFEMPCOD=@empresa
                             and NDFNUMDOC=@numdoc
                             and NDFITE=@item)
      return @retorno
   end
go

-- NDFTOTLIQITEST = iif(NDFPERICMSST > 0, NDFTOTLIQITE + NDFVALICMSST, NDFTOTLIQITE)

drop function NDFTOTLIQITEST
go

create function NDFTOTLIQITEST(@empresa smallint, @numdoc smallint, @item smallint) returns decimal(11,3) as
   begin
      declare @retorno decimal(11,4)
      set @retorno = (select case
                                when NDFPERICMSST > 0
                                   then
                                      dbo.NDFTOTLIQITE(@empresa, @numdoc, @item) + NDFVALICMSST
                                   else
                                      dbo.NDFTOTLIQITE(@empresa, @numdoc, @item)
                             end
                        from TBS1431 (nolock)
                       where NDFEMPCOD=@empresa
                             and NDFNUMDOC=@numdoc
                             and NDFITE=@item)
      return @retorno
   end
go