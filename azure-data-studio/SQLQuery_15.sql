
if exists(select name from sysobjects where name='GZ_VENDAS_DIA' and type='P')
   drop procedure [dbo].[GZ_VENDAS_DIA]
go

create procedure GZ_VENDAS_DIA (@ret varchar(200) out) as
   begin
      set nocount on

      set @ret = (
                   select '{"dia":' + right('00'+str(dia,2),2)
                          + ',"valor":' + Ltrim(str(valor,12,2))
                          + ',"clientes":' + Ltrim(str(clientes,5))
                          + ',"ticket_medio":' + Ltrim(str(valor/clientes,12,2)) + '}'
                     from (
                            select day([data]) as 'dia'
                                   ,sum(valortot) - sum(case when cancelado='S' then valortot else 0 end) as 'valor'
                                   ,count(distinct cupom) as 'clientes'
                              from movcaixagz with (nolock)
                             where [data] = convert(date,getdate(),112)
                                   and [status]='03'
                                   and cancelado=''
                             group by day([data])
                          ) as tab)
      return
   end

declare @json varchar(max)

exec dbo.GZ_VENDAS_DIA @ret=@json output

select @json

if exists(select name from sysobjects where name='BuscaProduto' and type='P')
   drop procedure [dbo].[BuscaProduto]
go

create procedure BuscaProduto (@empresa as smallint, @codigo as varchar(15), @ret as varchar(max) out) as
   begin
      declare @buscaCodigo as varchar(15), @dt_atual as date, @preco as money, @preco2 as money, @qtdeEstoque as decimal(9,3), @qtdeLoja as decimal(9,3), @qloc as smallint

      set @dt_atual = (select convert(date, getdate()))
      set @qloc = 0
      
      -- busca no cadastro principal do produto
      set @buscaCodigo = isnull((select PROCOD from TBS010 with (nolock) where PROEMPCOD=@empresa and PROCOD=@codigo),'')

      -- busca no cadastro de códigos de barras do produto
      if @buscaCodigo = ''
         set @buscaCodigo = isnull((select CBPPROCOD from TBS0103 with (nolock) where CBPEMP=@empresa and CBPCODBAR=@codigo),'')

      -- busca através da localização física do produto
      if @buscaCodigo = ''
         begin
            set @buscaCodigo = isnull((select top(1) PROCOD from TBS010 with (nolock) where PROEMPCOD=@empresa and PROLOCFIS=@codigo),'')

            /*if @buscaCodigo != ''
               set @qloc = isnull((select count(PROCOD) from TBS010 with (nolock) where PROEMPCOD=@empresa and PROLOCFIS=@codigo),0)*/
         end

      -- não encontrado em nenhuma tabela acima
      if @buscaCodigo = ''
         begin
            set @ret = '{"ERRO": "Nao encontrado"}'
            return 
         end

      -- preços do produto
      select @preco=isnull(preco1,0) from PrecoLoja(0,@buscaCodigo)
      select @preco2=isnull(preco2,0) from PrecoLoja(0,@buscaCodigo)
      
      select @qtdeEstoque = sum(case when ESTLOC=1 then ESTQTDATU - ESTQTDRES else 0 end)
             ,@qtdeLoja = sum(case when ESTLOC=2 then ESTQTDATU - ESTQTDRES else 0 end)
        from TBS032 e with (nolock)
       where e.PROEMPCOD = @empresa
             and e.ESTLOC in (1,2)
             and e.PROCOD = @buscaCodigo

      --set @ret = @buscaCodigo
      
      set @ret = (
                    select '{"PROCOD": "' + rtrim(p.PROCOD) +'"'
                           + ',"PRODES": "' + rtrim(p.PRODES) +'"'
                           + ',"MARNOM": "' + (select rtrim(m.MARNOM) from TBS014 m with (nolock) where m.MARCOD=p.MARCOD) +'"'
                           + ',"PROLOCFIS": "' + rtrim(p.PROLOCFIS) + '"'
                           + ',"preco": ' + Ltrim(str(@preco,12,2))
                           + ',"qtdeEstoque": ' + Ltrim(str(@qtdeEstoque,9,3))
                           + ',"qtdeLoja": ' + Ltrim(str(@qtdeLoja,9,3))
                           + ',"PROUM1": "' + p.PROUM1 + '"'
                           + ',"embala": "' + case when p.PROUM1QTD > 1 then '(' + Ltrim(str(p.PROUM1QTD,6)) + p.PROUMV + ')' else '' end + '"'
                           + ',"qloc": ' + Ltrim(str(@qloc,4))
                           + ',"PROUM2": "' + p.PROUM2 + '"'
                           + ',"embala2": "' + case when p.PROUM2QTD > 1 then '(' + Ltrim(str(p.PROUM2QTD,6)) + p.PROUM1 + ' ' + Ltrim(str(p.PROUM1QTD,6)) + p.PROUMV + ')' else '' end + '"'
                           + ',"preco2": ' + Ltrim(str(@preco2 * p.PROUM2QTD ,12 ,2))
                           + ',"PROUM2QTD": ' + Ltrim(str(p.PROUM2QTD,9)) 
                           + ',"PROPESAVEL": "' + p.PROPESAVEL + '"'
                           + ',"PROSTATUS": "' + p.PROSTATUS + '"}'
                      from TBS010 p with (nolock)
                     where p.PROEMPCOD = @empresa
                           and p.PROCOD = @buscaCodigo
                 )
       
       --if @ret is null
          --set @ret = 'Não encontrado'

   end

declare @json varchar(max)

exec BuscaProduto 0, '1640054', @ret=@json output
--exec BuscaProduto 0, '7891191003733', @ret=@json output
--exec BuscaProduto 0, '42J01A', @ret=@json output
--exec BuscaProduto 0, 'X', @ret=@json output

select @json

select rtrim(PRODES)
       ,PROUM1 + case when PROUM1QTD > 1 then ' (' + Ltrim(str(TBS010.PROUM1QTD,6)) + TBS010.PROUMV + ')' else '' end as produtoEmbalagem
       ,PROUM2 + case when PROUM2QTD > 1 then ' (' + Ltrim(str(TBS010.PROUM2QTD,6)) + PROUM1 + ' ' + Ltrim(str(TBS010.PROUM1QTD,6)) + TBS010.PROUMV + ')' else '' end as produtoEmbalagem
  from TBS010 with (nolock)
 where PROCOD='1640054'

X

select convert(date, getdate())

select count(PROCOD) from TBS010 with (nolock) where PROEMPCOD=0 and PROLOCFIS='42J01A'

