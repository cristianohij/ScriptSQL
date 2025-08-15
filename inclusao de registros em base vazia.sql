ALTER DATABASE SIBD_VAZIO COLLATE Latin1_General_BIN

-- atualiza icones da tabela de niveis
update [SIBD_VAZIO].[dbo].[TBS021] set [NIVICO]=A.[NIVICO]
  from [SIBD].[dbo].[TBS021] A join [SIBD_VAZIO].[dbo].[TBS021] B on A.[NIVNOM] COLLATE DATABASE_DEFAULT=B.[NIVNOM] COLLATE DATABASE_DEFAULT

-- tabela de estados
INSERT INTO [SIBD_VAZIO].[dbo].[TBS001] SELECT * FROM [SIBD].[dbo].[TBS001]

-- tabela de moedas
INSERT INTO [SIBD_VAZIO].[dbo].[TBS044] VALUES (0,1,'REAL','RE',0,getdate(),GETDATE())

-- atualiza o valor sequencial da tabela de moedas
update [SIBD_VAZIO].[dbo].[TBS024] set [TBSSEQ]=1 where [TBS024].[TBSNOM]='TBS044'

-- tabela de ocorrencias
insert into [SIBD_VAZIO].[dbo].[TBS050] values (0,'MDS',1,'ACERTO ESTOQUE',GETDATE())

-- atualiza o valor sequencial da tabela de ocorrencias
update [SIBD_VAZIO].[dbo].[TBS024] set [TBSSEQ]=1 where [TBS024].[TBSNOM]='TBS050'

-- tabela de municipios (IBGE)
INSERT INTO [SIBD_VAZIO].[dbo].[TBS003] SELECT * FROM [SIBD].[dbo].[TBS003]

-- tabela de situacao tributaria
INSERT INTO [SIBD_VAZIO].[dbo].[TBS039] SELECT * FROM [SIBD].[dbo].[TBS039]

-- tabela de grupos de CFOP
INSERT INTO [SIBD_VAZIO].[dbo].[TBS040] SELECT * FROM [SIBD].[dbo].[TBS040]

-- tabela de codigos de CFOP
INSERT INTO [SIBD_VAZIO].[dbo].[TBS041] SELECT * FROM [SIBD].[dbo].[TBS041]

-- tabela de paises (BACEN)
INSERT INTO [SIBD_VAZIO].[dbo].[TBS071] SELECT * FROM [SIBD].[dbo].[TBS071]

-- tabela de irregularidades carta correcao
INSERT INTO [SIBD_VAZIO].[dbo].[TBS072] SELECT * FROM [SIBD].[dbo].[TBS072]
