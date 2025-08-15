-- novos atributos

-- TBS010: produtos
alter table [TBS010] add [PROSTBENTA] char(1) default '' with values
alter table [TBS010] add [PROSTBENTB] char(2) default '' with values

-- TBS043: orcamentos
alter table [TBS043] add [ORCVDDTOT] money default 0 with values

-- TBS045: pedidos compras
alter table [TBS045] add [PDCVDDTOT] money default 0 with values

-- TBS045: pedidos compras
alter table [TBS055] add [PDVVDDTOT] money default 0 with values

-- TBS059: notas fiscais entrada
alter table [TBS059] add [NFEVDDTOT] money default 0 with values
alter table [TBS059] add [NFETOTICMS] money default 0 with values
alter table [TBS059] add [NFETOTBAS] money default 0 with values
alter table [TBS059] add [NFETOTIPI] money default 0 with values
alter table [TBS059] add [NFEBASSUB] money default 0 with values
alter table [TBS059] add [NFEVALSUB] money default 0 with values
alter table [TBS059] add [NFEVALSEG] money default 0 with values
alter table [TBS059] add [NFECAN] char(1) default '' with values
alter table [TBS059] add [NFEDATCAN] datetime default '17530101' with values
alter table [TBS059] add [NFEUSUCAN] char(25) default '' with values

-- TBS0591: itens notas fiscais entrada
alter table [TBS0591] add [NFEBASICMS] money default 0 with values

-- TBS067: notas fiscais saida
alter table [TBS067] add [NFSCODFIS] char(5) default '' with values
alter table [TBS067] add [NFSMESAPU] smallint default 0 with values
alter table [TBS067] add [NFSANOAPU] smallint default 0 with values
alter table [TBS067] add [NFSVDDTOT] money default 0 with values


-- deleta atributos

-- TBS043: orcamentos
alter table [TBS043] drop column [ORCPDDTOT]

-- TBS045: pedidos compras
alter table [TBS045] drop column [PDCPDDTOT]

-- TBS055: pedidos vendas
alter table [TBS055] drop column [PDVPDDTOT]

-- TBS059: notas fiscais entrada
alter table [TBS059] drop column [NFEPDDTOT]

-- TBS0591: itens notas fiscais entrada
alter table [TBS0591] drop column [NFETESDPL]

-- TBS067: notas fiscais saida
alter table [TBS067] drop column [NFSPDDTOT]

