--select * from TBS002

-- estados
insert into PHANTOM.SIBD.dbo.TBS001 select * from TBS001

-- clientes
insert into PHANTOM.SIBD.dbo.TBS002 select *,0,0,0,0,0,0,0,0 from TBS002

-- outros enderecos
insert into PHANTOM.SIBD.dbo.TBS003 select * from TBS003

-- vendedores
insert into PHANTOM.SIBD.dbo.TBS004 select * from TBS004

-- transportadoras
insert into PHANTOM.SIBD.dbo.TBS005 select * from TBS005

-- fornecedores
insert into PHANTOM.SIBD.dbo.TBS006 select * from TBS006

-- condicoes pagto
insert into PHANTOM.SIBD.dbo.TBS008 select * from TBS008

-- produtos
insert into PHANTOM.SIBD.dbo.TBS010 select * from TBS010

-- unidades medidas
insert into PHANTOM.SIBD.dbo.TBS011 select * from TBS011

-- marcas produtos
insert into PHANTOM.SIBD.dbo.TBS014 select * from TBS014

-- centros custos
insert into PHANTOM.SIBD.dbo.TBS036 select * from TBS036

-- moedas
insert into PHANTOM.SIBD.dbo.TBS044 select * from TBS044

-- politicas precos
insert into PHANTOM.SIBD.dbo.TBS015 select * from TBS015

-- precos dos produtos
insert into PHANTOM.SIBD.dbo.TBS031 select * from TBS031

-- compradores
insert into PHANTOM.SIBD.dbo.TBS046 select * from TBS046

-- usuarios
insert into TBS016  select * from PHANTOM.SIBD.dbo.TBS016
insert into TBS0161 select * from PHANTOM.SIBD.dbo.TBS0161
insert into TBS0162 select * from PHANTOM.SIBD.dbo.TBS0162
insert into TBS0163 select * from PHANTOM.SIBD.dbo.TBS0163
insert into TBS0164 select * from PHANTOM.SIBD.dbo.TBS0164

-- programas
insert into PHANTOM.SIBD.dbo.TBS018 select * from TBS018
insert into PHANTOM.SIBD.dbo.TBS0181 select * from TBS0181

-- menus
insert into PHANTOM.SIBD.dbo.TBS019 select * from TBS019
insert into PHANTOM.SIBD.dbo.TBS0191 select * from TBS0191

-- modulos
insert into PHANTOM.SIBD.dbo.TBS020 select * from TBS020

-- niveis
insert into PHANTOM.SIBD.dbo.TBS021 select * from TBS021

-- empresas
insert into TBS023 select * from PHANTOM.SIBD.dbo.TBS023

-- tabelas do sistema
insert into PHANTOM.SIBD.dbo.TBS024 select * from TBS024
insert into PHANTOM.SIBD.dbo.TBS0241 select * from TBS0241

-- parametros
insert into PHANTOM.SIBD.dbo.TBS025 select * from TBS025

-- tipos titulos
insert into PHANTOM.SIBD.dbo.TBS027 select * from TBS027

-- saldos produtos
insert into PHANTOM.SIBD.dbo.TBS032 select * from TBS032

-- tipos movimentacoes
insert into PHANTOM.SIBD.dbo.TBS033 select * from TBS033

-- locais estoques
insert into PHANTOM.SIBD.dbo.TBS034 select * from TBS034

-- codigos situacao tributaria
insert into PHANTOM.SIBD.dbo.TBS039 select * from TBS039

-- grupos CFOP
insert into PHANTOM.SIBD.dbo.TBS040 select * from TBS040

-- codigos CFOP
insert into PHANTOM.SIBD.dbo.TBS041 select * from TBS041

-- tipos E/S
insert into PHANTOM.SIBD.dbo.TBS042 select * from TBS042

-- series NF
insert into PHANTOM.SIBD.dbo.TBS064 select * from TBS064

-- tabela comissoes
insert into TBS068 select * from PHANTOM.SIBD.dbo.TBS068