select 'insert into TBS024 (TBSNOM,TBSDES,TBSSEQ,TBSATRNOM,TBSATRDES,TBSATRTAM,TBSVALSEQ,TBSCTR,TBSZERESC) values('''+rtrim(name)+''','''',''N'','''','''',0,0,'''')' from sysobjects where xtype='U' and Left(name ,2)='TB' and Len(rtrim(name))=6 order by name


select * from TBS024
delete from TBS024
update TBS024 set TBSCTR='' where TBSCTR is null
update TBS024 set TBSZERESC='' where TBSZERESC is null

-- tabelas bloqueadas
   -- 001 estados
   -- 003 outros enderecos
   -- 011 unidades de medidas
   -- 013 paises
   -- 015 politica de precos
   -- 016 usuarios
   -- 018 programas
   -- 019 menus de usuarios
   -- 020 modulos do sistema
   -- 021 niveis
   -- 022 usuarios logados no sistema
   -- 023 cadadastro de empresas (registro software)
   -- 024 tabelas do sistema
   -- 025 parametros do sistema
   -- 027 tipos de fretes
   -- 029 dados do servidor
   -- 031 precos de produtos
   -- 032 saldos de produtos
   -- 033 tipos de movimentacoes
   -- 035 log do sistema

--   update TBS024 set TBSCTR='B'
--    where subString(TBSNOM,4,3) in('001','003','011','013','015','016','018','019','020','021','022','023','024','025',
--                                   '027','029','031','032','033','035')

select 'insert into TBS024 (TBSNOM,TBSDES,TBSSEQ,TBSATRNOM,TBSATRDES,TBSATRTAM,TBSVALSEQ,TBSCTR,TBSZERESC) values(',
       rtrim(''''),TBSNOM,'''',TBSDES,TBSSEQ,TBSATRNOM,TBSATRDES,TBSATRTAM,TBSVALSEQ,TBSCTR,TBSZERESC
  from sysobjects join TABELAS on name=TBSNOM 
 where xtype='U' and Left(name ,2)='TB' and Len(rtrim(name))=6 order by name


-- tabelas unicas (compartilhadas) que nao podem ser diferenciadas por empresa
   -- 001 estados
   -- 013 paises