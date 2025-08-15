-- somente módulos padrão do sistema
select 'insert into TBS020 (MODNOM,MODDES,MODDATCAD) select ''' + rtrim(MODNOM) + ''', ''' + rtrim(MODDES) + ''', ''' + convert(char(8),getdate(),112) + '''' +
       ' where not exists(select '''' from TBS020 (nolock) where MODNOM=''' + rtrim(MODNOM) + ''')' + char(13) + 'go'
  from TBS020 (nolock)
 where MODNOM in('COMPRAS','ESTOQUE','FINANCEIRO','FISCAL','LOJA','VENDAS')

-- níveis
select 'insert into TBS021 (NIVNOM,NIVDES,NIVDATCAD,NIVPOS,NIVICO) select ''' + rtrim(NIVNOM) + ''', ''' + rtrim(NIVDES) + ''', ''' + convert(char(8),getdate(),112) + ''', ' +
       ltrim(str(NIVPOS,2)) + ', ''' + rtrim(NIVICO) + '''' +
       ' where not exists(select '''' from TBS021 (nolock) where NIVNOM=''' + rtrim(NIVNOM) + ''')' + char(13) + 'go'
  from TBS021 (nolock)

-- programas
select 'insert into TBS018 (PRGCOD,PRGNOM,PRGDES,NIVNOM,PRGBLOQ,PRGDATCAD,PRGULTITEM,PRGBLOQMNU) select ''' +
       rtrim(PRGCOD) + ''', ''' + rtrim(replace(PRGNOM,'''',' ')) + ''', ''' + rtrim(replace(PRGDES,'''',' ')) + ''', ''' + rtrim(NIVNOM) + ''', ''' + rtrim(PRGBLOQ) + ''', ''' + convert(char(8),getdate(),112) + ''', ' +
       ltrim(str(PRGULTITEM,2)) + ', ''' + rtrim(PRGBLOQMNU) + '''' -- +
--       ' where not exists(select '''' from TBS018 (nolock) where PRGCOD=''' + rtrim(PRGCOD) + ''')' + char(13) + 'go'
  from TBS018 (nolock)

-- opções dos programas
select 'insert into TBS0181 (PRGCOD,PRGEVEITEM,PRGEVENOM) select ''' + rtrim(PRGCOD) + ''', ' + ltrim(str(PRGEVEITEM,2)) + ', ''' + rtrim(replace(PRGEVENOM,'''',' ')) + ''''
  from TBS0181 (nolock)
