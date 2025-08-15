--select top 1 * from TBS015 (nolock)
--select top 1 * from TBS010 (nolock)

select TBS015.PDPCOD as CodigoProduto,
       TBS010.PROSTATUS as status,
       TBS010.PROCLAFIS as NCM,
       TBS010.PRODES as DescricaoProduto,
       Ltrim(str(TBS010.MARCOD,4)) + ' - ' + rTrim(TBS014.MARNOM) as marca,
       TBS010.PROUM1 as embalagem1,
       case when TBS010.PROUM2<>'' then TBS010.PROUM2 + ' - ' + Ltrim(str(TBS010.PROUM2QTD,10)) else '' end as embalagem2,
       case when TBS010.PROUM3<>'' then TBS010.PROUM3 + ' - ' + Ltrim(str(TBS010.PROUM3QTD,10)) else '' end as embalagem3,
       case when TBS010.PROUM4<>'' then TBS010.PROUM4 + ' - ' + Ltrim(str(TBS010.PROUM4QTD,10)) else '' end as embalagem4,

       convert(date,TBS015.PDPDATALT) as DataAlteracao,
       convert(date,TBS015.PDPDATATU) as DataAtualizacao,

       round(TBS015.PDPPREFOR/TBS015.PDPQTDEMB,4) as PrecoUnitario,

       TBS015.PDPIPI as IPI,
       TBS015.PDPPORST as ST,
       TBS015.PDPDIFICM as DiferencaICMS,
       TBS015.PDPPIS as PIS,
       TBS015.PDPCOF as COFINS,
       TBS015.PDPFRE as frete,
       TBS015.PDPCUSADM as CustoAdm,
       TBS015.PDPCMS as comissao,
       TBS015.PDPPDD1 as desconto1,
       TBS015.PDPPDD2 as desconto2,
       TBS015.PDPPDD3 as desconto3,
       TBS015.PDPPDD4 as desconto4,

       dbo.PDPCUSBAS(TBS015.PDPEMPCOD, TBS015.PDPCOD) as CustoUnitario,

       -- promoção
       TBS015.PDPMKPPRO1 as mkpPromocao1,
       TBS015.PDPMKPPRO2 as mkpPromocao2,
       TBS015.PDPREDPRO1 as ReducaoPromocao1,
       TBS015.PDPPREPRO1 as PrecoPromocao1,
       case when TBS010.PROUM2<>'' then TBS015.PDPREDPRO2 else 0 end as ReducaoPromocao2,
       case when TBS010.PROUM2<>'' then TBS015.PDPPREPRO2 else 0 end as PrecoPromocao2,
       case when TBS010.PROUM3<>'' then TBS015.PDPREDPRO3 else 0 end as ReducaoPromocao3,
       case when TBS010.PROUM3<>'' then TBS015.PDPPREPRO3 else 0 end as PrecoPromocao3,
       case when TBS010.PROUM4<>'' then TBS015.PDPREDPRO4 else 0 end as ReducaoPromocao4,
       case when TBS010.PROUM4<>'' then TBS015.PDPPREPRO4 else 0 end as PrecoPromocao4,

       TBS015.PDPVALPROI as ValidadeInicial,
       case TBS015.PDPVALPROI when '17530101' then '' end as ValidadeInicial,
       TBS015.PDPVALPROF as ValidadeFinal,

       -- validade da promoção
       TBS015.PDPPROCOR as ValidoCorp,
       TBS015.PDPPROLOJ as ValidoLoja,
       TBS015.PDPPROREV as ValidoRev,
       TBS015.PDPPROWE1 as ValidoWeb1,
       TBS015.PDPPROWE2 as ValidoWeb2,

       -- corporativo
       TBS015.PDPMKPCOR1 as mkpCorporativo1,
       TBS015.PDPMKPCOR2 as mkpCorporativo2,
       TBS015.PDPREDCOR1 as ReducaoCorporativo1,
       TBS015.PDPPRECOR1 as PrecoCorporativo1,
       case when TBS010.PROUM2<>'' then TBS015.PDPREDCOR2 else 0 end as ReducaoCorporativo2,
       case when TBS010.PROUM2<>'' then TBS015.PDPPRECOR2 else 0 end as PrecoCorporativo2,
       case when TBS010.PROUM3<>'' then TBS015.PDPREDCOR3 else 0 end as ReducaoCorporativo3,
       case when TBS010.PROUM3<>'' then TBS015.PDPPRECOR3 else 0 end as PrecoCorporativo3,
       case when TBS010.PROUM4<>'' then TBS015.PDPREDCOR4 else 0 end as ReducaoCorporativo4,
       case when TBS010.PROUM4<>'' then TBS015.PDPPRECOR4 else 0 end as PrecoCorporativo4,

       -- loja
       TBS015.PDPMKPLOJ1 as mkpLoja1,
       TBS015.PDPMKPLOJ2 as mkpLoja2,
       TBS015.PDPREDLOJ1 as ReducaoLoja1,
       TBS015.PDPPRELOJ1 as PrecoLoja1,
       case when TBS010.PROUM2<>'' then TBS015.PDPREDLOJ2 else 0 end as ReducaoLoja2,
       case when TBS010.PROUM2<>'' then TBS015.PDPPRELOJ2 else 0 end as PrecoLoja2,
       case when TBS010.PROUM3<>'' then TBS015.PDPREDLOJ3 else 0 end as ReducaoLoja3,
       case when TBS010.PROUM3<>'' then TBS015.PDPPRELOJ3 else 0 end as PrecoLoja3,
       case when TBS010.PROUM4<>'' then TBS015.PDPREDLOJ4 else 0 end as ReducaoLoja4,
       case when TBS010.PROUM4<>'' then TBS015.PDPPRELOJ4 else 0 end as PrecoLoja4,

       -- revenda
       TBS015.PDPMKPREV1 as mkpRevenda1,
       TBS015.PDPMKPREV2 as mkpRevenda2,
       TBS015.PDPREDREV1 as ReducaoRevenda1,
       TBS015.PDPPRELOJ1 as PrecoRevenda1,
       case when TBS010.PROUM2<>'' then TBS015.PDPREDREV2 else 0 end as ReducaoRevenda2,
       case when TBS010.PROUM2<>'' then TBS015.PDPPREREV2 else 0 end as PrecoRevenda2,
       case when TBS010.PROUM3<>'' then TBS015.PDPREDREV3 else 0 end as ReducaoRevenda3,
       case when TBS010.PROUM3<>'' then TBS015.PDPPREREV3 else 0 end as PrecoRevenda3,
       case when TBS010.PROUM4<>'' then TBS015.PDPREDREV4 else 0 end as ReducaoRevenda4,
       case when TBS010.PROUM4<>'' then TBS015.PDPPREREV4 else 0 end as PrecoRevenda4,

       -- web1
       TBS015.PDPMKPWE11 as mkpWeb11,
       TBS015.PDPMKPWE12 as mkpWeb12,
       TBS015.PDPREDWE11 as ReducaoWeb11,
       TBS015.PDPPREWE11 as PrecoWeb11,
       case when TBS010.PROUM2<>'' then TBS015.PDPREDWE12 else 0 end as ReducaoWeb12,
       case when TBS010.PROUM2<>'' then TBS015.PDPPREWE12 else 0 end as PrecoWeb12,
       case when TBS010.PROUM3<>'' then TBS015.PDPREDWE13 else 0 end as ReducaoWeb13,
       case when TBS010.PROUM3<>'' then TBS015.PDPPREWE13 else 0 end as PrecoWeb13,
       case when TBS010.PROUM4<>'' then TBS015.PDPREDWE14 else 0 end as ReducaoWeb14,
       case when TBS010.PROUM4<>'' then TBS015.PDPPREWE14 else 0 end as PrecoWeb14,

       -- web2
       TBS015.PDPMKPWE21 as mkpWeb21,
       TBS015.PDPMKPWE22 as mkpWeb22,
       TBS015.PDPREDWE21 as ReducaoWeb21,
       TBS015.PDPPREWE21 as PrecoWeb21,
       case when TBS010.PROUM2<>'' then TBS015.PDPREDWE22 else 0 end as ReducaoWeb22,
       case when TBS010.PROUM2<>'' then TBS015.PDPPREWE22 else 0 end as PrecoWeb22,
       case when TBS010.PROUM3<>'' then TBS015.PDPREDWE23 else 0 end as ReducaoWeb23,
       case when TBS010.PROUM3<>'' then TBS015.PDPPREWE23 else 0 end as PrecoWeb23,
       case when TBS010.PROUM4<>'' then TBS015.PDPREDWE24 else 0 end as ReducaoWeb24,
       case when TBS010.PROUM4<>'' then TBS015.PDPPREWE24 else 0 end as PrecoWeb24

  from TBS015 (nolock)
       inner join TBS010 (nolock) on TBS010.PROCOD=TBS015.PDPCOD
       inner join TBS014 (nolock) on TBS014.MARCOD=TBS010.MARCOD
 where TBS010.MARCOD=164


-- marcas

select MARCOD as CodigoMarca,
       MARNOM as NomeMarca
  from TBS014 (nolock)
 where MARNOM <> ''
 order by MARNOM

drop procedure SP_PoliticaPrecos

create procedure [dbo].[SP_PoliticaPrecos] 
   @Status char(1),           -- 1
   @NCM varchar(8),           -- 2
   @Descricao varchar(60),    -- 3

   @ProdutoDe varchar(15),    -- 4
   @ProdutoAte varchar(15),   -- 5

   @CadastroDe varChar(8),          -- 6
   @CadastroAte varChar(8),         -- 7

   @AlteradoDe varChar(8),          -- 8
   @AlteradoAte varChar(8),         -- 9

   @AtualizadoDe varChar(8),        -- 10
   @AtualizadoAte varChar(8),       -- 11

   @Fornecedor smallint,      -- 12
   @Marca smallint,           -- 13

   @Ordenar char(1) as        -- 14

   begin
      declare @StringSQL varchar(8000),@Filtros varchar(500),@conta smallint

      set @StringSQL = 'select TBS015.PDPCOD as CodigoProduto,TBS010.PROSTATUS as status,TBS010.PROCLAFIS as NCM,TBS010.PRODES as DescricaoProduto,Ltrim(str(TBS010.MARCOD,4)) + '' - '' + rTrim(TBS014.MARNOM) as marca,TBS010.PROUM1 as embalagem1,case when TBS010.PROUM2<>'''' then TBS010.PROUM2 + '' - '' + Ltrim(str(TBS010.PROUM2QTD,10)) else '''' end as embalagem2,case when TBS010.PROUM3<>'''' then TBS010.PROUM3 + '' - '' + Ltrim(str(TBS010.PROUM3QTD,10)) else '''' end as embalagem3,case when TBS010.PROUM4<>'''' then TBS010.PROUM4 + '' - '' + Ltrim(str(TBS010.PROUM4QTD,10)) else '''' end as embalagem4,convert(date,TBS015.PDPDATALT) as DataAlteracao,convert(date,TBS015.PDPDATATU) as DataAtualizacao,round(TBS015.PDPPREFOR/TBS015.PDPQTDEMB,4) as PrecoUnitario,TBS015.PDPIPI as IPI,TBS015.PDPPORST as ST,TBS015.PDPDIFICM as DiferencaICMS,TBS015.PDPPIS as PIS,TBS015.PDPCOF as COFINS,TBS015.PDPFRE as frete,TBS015.PDPCUSADM as CustoAdm,TBS015.PDPCMS as comissao,TBS015.PDPPDD1 as desconto1,TBS015.PDPPDD2 as desconto2,TBS015.PDPPDD3 as desconto3,TBS015.PDPPDD4 as desconto4,TBS015.PDPPDD5 as desconto5,dbo.PDPCUSBAS(TBS015.PDPEMPCOD, TBS015.PDPCOD) as CustoUnitario,TBS015.PDPMKPPRO1 as mkpPromocao1,TBS015.PDPMKPPRO2 as mkpPromocao2,TBS015.PDPREDPRO1 as ReducaoPromocao1,TBS015.PDPPREPRO1 as PrecoPromocao1,case when TBS010.PROUM2<>'''' then TBS015.PDPREDPRO2 else 0 end as ReducaoPromocao2,case when TBS010.PROUM2<>'''' then TBS015.PDPPREPRO2 else 0 end as PrecoPromocao2,case when TBS010.PROUM3<>'''' then TBS015.PDPREDPRO3 else 0 end as ReducaoPromocao3,case when TBS010.PROUM3<>'''' then TBS015.PDPPREPRO3 else 0 end as PrecoPromocao3,case when TBS010.PROUM4<>'''' then TBS015.PDPREDPRO4 else 0 end as ReducaoPromocao4,case when TBS010.PROUM4<>'''' then TBS015.PDPPREPRO4 else 0 end as PrecoPromocao4,case TBS015.PDPVALPROI when ''17530101'' then '''' end as ValidadeInicial,case TBS015.PDPVALPROF when ''17530101'' then '''' end as ValidadeFinal,TBS015.PDPPROCOR as ValidoCorp,TBS015.PDPPROLOJ as ValidoLoja,TBS015.PDPPROREV as ValidoRev,TBS015.PDPPROWE1 as ValidoWeb1,TBS015.PDPPROWE2 as ValidoWeb2,TBS015.PDPMKPCOR1 as mkpCorporativo1,TBS015.PDPMKPCOR2 as mkpCorporativo2, TBS015.PDPREDCOR1 as ReducaoCorporativo1,TBS015.PDPPRECOR1 as PrecoCorporativo1,case when TBS010.PROUM2<>'''' then TBS015.PDPREDCOR2 else 0 end as ReducaoCorporativo2,case when TBS010.PROUM2<>'''' then TBS015.PDPPRECOR2 else 0 end as PrecoCorporativo2,case when TBS010.PROUM3<>'''' then TBS015.PDPREDCOR3 else 0 end as ReducaoCorporativo3,case when TBS010.PROUM3<>'''' then TBS015.PDPPRECOR3 else 0 end as PrecoCorporativo3,case when TBS010.PROUM4<>'''' then TBS015.PDPREDCOR4 else 0 end as ReducaoCorporativo4,case when TBS010.PROUM4<>'''' then TBS015.PDPPRECOR4 else 0 end as PrecoCorporativo4,TBS015.PDPMKPLOJ1 as mkpLoja1,TBS015.PDPMKPLOJ2 as mkpLoja2,TBS015.PDPREDLOJ1 as ReducaoLoja1,TBS015.PDPPRELOJ1 as PrecoLoja1,case when TBS010.PROUM2<>'''' then TBS015.PDPREDLOJ2 else 0 end as ReducaoLoja2,case when TBS010.PROUM2<>'''' then TBS015.PDPPRELOJ2 else 0 end as PrecoLoja2,case when TBS010.PROUM3<>'''' then TBS015.PDPREDLOJ3 else 0 end as ReducaoLoja3,case when TBS010.PROUM3<>'''' then TBS015.PDPPRELOJ3 else 0 end as PrecoLoja3,case when TBS010.PROUM4<>'''' then TBS015.PDPREDLOJ4 else 0 end as ReducaoLoja4,case when TBS010.PROUM4<>'''' then TBS015.PDPPRELOJ4 else 0 end as PrecoLoja4,TBS015.PDPMKPREV1 as mkpRevenda1,TBS015.PDPMKPREV2 as mkpRevenda2,TBS015.PDPREDREV1 as ReducaoRevenda1,TBS015.PDPPRELOJ1 as PrecoRevenda1,case when TBS010.PROUM2<>'''' then TBS015.PDPREDREV2 else 0 end as ReducaoRevenda2,case when TBS010.PROUM2<>'''' then TBS015.PDPPREREV2 else 0 end as PrecoRevenda2,case when TBS010.PROUM3<>'''' then TBS015.PDPREDREV3 else 0 end as ReducaoRevenda3,case when TBS010.PROUM3<>'''' then TBS015.PDPPREREV3 else 0 end as PrecoRevenda3,case when TBS010.PROUM4<>'''' then TBS015.PDPREDREV4 else 0 end as ReducaoRevenda4,case when TBS010.PROUM4<>'''' then TBS015.PDPPREREV4 else 0 end as PrecoRevenda4,TBS015.PDPMKPWE11 as mkpWeb11,TBS015.PDPMKPWE12 as mkpWeb12,TBS015.PDPREDWE11 as ReducaoWeb11,TBS015.PDPPREWE11 as PrecoWeb11,case when TBS010.PROUM2<>'''' then TBS015.PDPREDWE12 else 0 end as ReducaoWeb12,case when TBS010.PROUM2<>'''' then TBS015.PDPPREWE12 else 0 end as PrecoWeb12,case when TBS010.PROUM3<>'''' then TBS015.PDPREDWE13 else 0 end as ReducaoWeb13,case when TBS010.PROUM3<>'''' then TBS015.PDPPREWE13 else 0 end as PrecoWeb13,case when TBS010.PROUM4<>'''' then TBS015.PDPREDWE14 else 0 end as ReducaoWeb14,case when TBS010.PROUM4<>'''' then TBS015.PDPPREWE14 else 0 end as PrecoWeb14,TBS015.PDPMKPWE21 as mkpWeb21,TBS015.PDPMKPWE22 as mkpWeb22,TBS015.PDPREDWE21 as ReducaoWeb21,TBS015.PDPPREWE21 as PrecoWeb21,case when TBS010.PROUM2<>'''' then TBS015.PDPREDWE22 else 0 end as ReducaoWeb22,case when TBS010.PROUM2<>'''' then TBS015.PDPPREWE22 else 0 end as PrecoWeb22,case when TBS010.PROUM3<>'''' then TBS015.PDPREDWE23 else 0 end as ReducaoWeb23,case when TBS010.PROUM3<>'''' then TBS015.PDPPREWE23 else 0 end as PrecoWeb23,case when TBS010.PROUM4<>'''' then TBS015.PDPREDWE24 else 0 end as ReducaoWeb24,case when TBS010.PROUM4<>'''' then TBS015.PDPPREWE24 else 0 end as PrecoWeb24 from TBS015 (nolock) inner join TBS010 (nolock) on TBS010.PROCOD=TBS015.PDPCOD inner join TBS014 (nolock) on TBS014.MARCOD=TBS010.MARCOD'

      set @conta = 0

      if @Status<>'' or @NCM<>'' or @Descricao<>'' or @ProdutoDe<>'' or @ProdutoAte<>'' or @CadastroDe<>'17530101' or @CadastroAte<>'17530101' or @AlteradoDe<>'17530101' or @AtualizadoDe<>'17530101' or @AtualizadoAte<>'17530101' or @Fornecedor > 0 or @Marca > 0 or @Ordenar<>''
         set @Filtros = ' where'

      -- status
      if @Status<>''
         begin
            set @Filtros = @Filtros + ' TBS010.PROSTATUS=' + Ltrim(str(@Status,4))
            set @conta = 1
         end

      -- NCM
      if @NCM > 0
         begin
            if @conta = 1
               set @Filtros = @Filtros + ' and'
            else
               set @conta = 1

            set @Filtros = @Filtros + ' TBS010.PROCLAFIS=' + Ltrim(str(@NCM,4))
         end

      -- descrição         
      if @Descricao<>''
         begin
            if @conta = 1
               set @Filtros = @Filtros + ' and'
            else
               set @conta = 1

            set @Filtros = @Filtros + ' TBS010.PRODES Like ''' + rtrim(@Descricao) + ''''
         end

      -- produtos de/até
      if @ProdutoDe<>''
         begin
            if @conta = 1
               set @Filtros = @Filtros + ' and'
            else
               set @conta = 1

            set @Filtros = @Filtros + ' TBS015.PDPCOD >= ''' + rtrim(@ProdutoDe) + ''''
         end

      if @ProdutoAte<>''
         begin
            if @conta = 1
               set @Filtros = @Filtros + ' and'
            else
               set @conta = 1

            set @Filtros = @Filtros + ' TBS015.PDPCOD <= ''' + rtrim(@ProdutoAte) + ''''
         end

      -- cadastro de/até
      if @CadastroDe<>'17530101'
         begin
            if @conta = 1
               set @Filtros = @Filtros + ' and'
            else
               set @conta = 1

            set @Filtros = @Filtros + ' TBS015.PDPDATCAD >= ''' + convert(char(10),@CadastroDe,112) + ''''
         end

      if @CadastroAte<>'17530101'
         begin
            if @conta = 1
               set @Filtros = @Filtros + ' and'
            else
               set @conta = 1

            set @Filtros = @Filtros + ' TBS015.PDPDATCAD <= ''' + convert(char(10),@CadastroAte,112) + ''''
         end

      -- alterado de/até
      if @AlteradoDe<>'17530101'
         begin
            if @conta = 1
               set @Filtros = @Filtros + ' and'
            else
               set @conta = 1

            set @Filtros = @Filtros + ' TBS015.PDPDATALT >= ''' + convert(char(10),@AlteradoDe,112) + ''''
         end

      if @AlteradoAte<>'17530101'
         begin
            if @conta = 1
               set @Filtros = @Filtros + ' and'
            else
               set @conta = 1

            set @Filtros = @Filtros + ' TBS015.PDPDATALT <= ''' + convert(char(10),@AlteradoAte,112) + ''''
         end

      -- atualizado de/até
      if @AtualizadoDe<>'17530101'
         begin
            if @conta = 1
               set @Filtros = @Filtros + ' and'
            else
               set @conta = 1

            set @Filtros = @Filtros + ' TBS015.PDPDATATU >= ''' + convert(char(10),@AtualizadoDe,112) + ''''
         end

      if @AtualizadoAte<>'17530101'
         begin
            if @conta = 1
               set @Filtros = @Filtros + ' and'
            else
               set @conta = 1

            set @Filtros = @Filtros + ' TBS015.PDPDATATU <= ''' + convert(char(10),@AtualizadoAte,112) + ''''
         end

      if @Fornecedor > 0
         begin
            if @conta = 1
               set @Filtros = @Filtros + ' and'
            else
               set @conta = 1

            set @Filtros = @Filtros + ' TBS010.FORCOD=' + Ltrim(str(@Fornecedor,4))
         end

      if @Marca > 0
         begin
            if @conta = 1
               set @Filtros = @Filtros + ' and'
            else
               set @conta = 1

            set @Filtros = @Filtros + ' TBS010.MARCOD=' + Ltrim(str(@Marca,4))
         end

      if @Filtros<>''
         set @StringSQL = @StringSQL + @Filtros

      if @Ordenar<>''
         set @StringSQL = @StringSQL + ' order by ' + case @Ordenar when 'C' then 'TBS015.PDPCOD' when 'D' then 'TBS010.PRODES' else 'TBS010.PROCLAFIS' end

--print @StringSQL

      execute (@StringSQL)
   end 

exec [dbo].[SP_PoliticaPrecos]
   '',             -- 1
   '',             -- 2
   '',             -- 3
   '',             -- 4
   '',             -- 5
   '17530101',     -- 6
   '17530101',     -- 7
   '17530101',     -- 8
   '17530101',     -- 9
   '17530101',     -- 10
   '17530101',     -- 11
   0,              -- 12
   164,            -- 13
   'D'              -- 14

EXEC [dbo].[SP_PoliticaPrecos] '','','','','','17530101','17530101','17530101','17530101','17530101','17530101',0,164,'D'

select getdate(),convert(char(10),getdate(),112)


select * from TBS015 (nolock) where PDPCOD Like('164%') order by PDPCOD