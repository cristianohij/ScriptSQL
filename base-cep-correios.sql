--select *
--  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Text;Database=c:\integros\temp;HDR=No;/r','select * from [LOG_LOCALIDADE.txt]')

-- insert localidade
bulk insert LOG_LOCALIDADE from 'C:\integros\temp\LOG_LOCALIDADE.txt' with (fieldterminator = '@', rowterminator = '\n', firstrow = 1, codepage = 'acp')

select *
  from LOG_LOCALIDADE with (nolock)


update LOG_LOCALIDADE
   set LOC_NU_SUB=0
 where LOC_NU_SUB is null

update LOG_LOCALIDADE
   set LOC_NO=upper(LOC_NO), LOC_NO_ABREV=upper(LOC_NO_ABREV)

-- insert logradouro
bulk insert LOG_LOGRADOURO from 'C:\integros\temp\LOG_LOGRADOURO_TO.txt' with (fieldterminator = '@', rowterminator = '\n', firstrow = 1, codepage = 'acp')


select top 1000 *
  from LOG_LOGRADOURO with (nolock)
 where CEP='12233490'

update LOG_LOGRADOURO
   set BAI_NU_FIM=0
 where BAI_NU_FIM is null

update LOG_LOGRADOURO
   set BAI_NU_INI=0
where BAI_NU_INI is null


update LOG_LOGRADOURO
   set LOG_COMPLEMENTO=''
where LOG_COMPLEMENTO is null

update LOG_LOGRADOURO
   set LOG_NO=upper(LOG_NO), LOG_COMPLEMENTO=upper(LOG_COMPLEMENTO), TLO_TX=upper(TLO_TX), LOG_NO_ABREV=upper(LOG_NO_ABREV)

-- insert bairro
bulk insert LOG_BAIRRO from 'C:\integros\temp\LOG_BAIRRO.txt' with (fieldterminator = '@', rowterminator = '\n', firstrow = 1, codepage = 'acp')

select  *
  from LOG_BAIRRO with (nolock)
 where BAI_NU=24939

update LOG_BAIRRO
   set BAI_NO=upper(BAI_NO), BAI_NO_ABREV=upper(BAI_NO_ABREV)

-- insert grande usuário
bulk insert LOG_GRANDE_USUARIO from 'C:\integros\temp\LOG_GRANDE_USUARIO.txt' with (fieldterminator = '@', rowterminator = '\n', firstrow = 1, codepage = 'acp')

select *
  from LOG_GRANDE_USUARIO with (nolock)

update LOG_GRANDE_USUARIO
   set GRU_NO=upper(GRU_NO), GRU_ENDERECO=upper(GRU_ENDERECO), GRU_NO_ABREV=upper(GRU_NO_ABREV)

-- insert faixa localidade
bulk insert LOG_FAIXA_LOCALIDADE from 'C:\integros\temp\LOG_FAIXA_LOCALIDADE.txt' with (fieldterminator = '@', rowterminator = '\n', firstrow = 1, codepage = 'acp')

select *
  from LOG_FAIXA_LOCALIDADE with (nolock)


-- insert outras denominações da localidade
bulk insert LOG_VAR_LOC from 'C:\integros\temp\LOG_VAR_LOC.txt' with (fieldterminator = '@', rowterminator = '\n', firstrow = 1, codepage = 'acp')

select *
  from LOG_VAR_LOC with (nolock)

update LOG_VAR_LOC
   set VAL_TX=upper(VAL_TX)

-- insert faixa numérica do seccionamento
bulk insert LOG_NUM_SEC from 'C:\integros\temp\LOG_NUM_SEC.txt' with (fieldterminator = '@', rowterminator = '\n', firstrow = 1, codepage = 'acp')

select *
  from LOG_NUM_SEC with (nolock)

-- insert faixa de CEP de UF
bulk insert LOG_FAIXA_UF from 'C:\integros\temp\LOG_FAIXA_UF.txt' with (fieldterminator = '@', rowterminator = '\n', firstrow = 1, codepage = 'acp')

select *
  from LOG_FAIXA_UF with (nolock)

-- insert outras denominações do logradouro
bulk insert LOG_VAR_LOG from 'C:\integros\temp\LOG_VAR_LOG.txt' with (fieldterminator = '@', rowterminator = '\n', firstrow = 1, codepage = 'acp')

select top 1000 *
  from LOG_VAR_LOG with (nolock)

update LOG_VAR_LOG
   set VLO_TX=upper(VLO_TX)

-- insert caixa postal comunitária
bulk insert LOG_CPC from 'C:\integros\temp\LOG_CPC.txt' with (fieldterminator = '@', rowterminator = '\n', firstrow = 1, codepage = 'acp')

select *
  from LOG_CPC with (nolock)

update LOG_CPC
   set CPC_NO=upper(CPC_NO), CPC_ENDERECO=upper(CPC_ENDERECO)

-- insert caixa postal comunitária
bulk insert LOG_UNID_OPER from 'C:\integros\temp\LOG_UNID_OPER.txt' with (fieldterminator = '@', rowterminator = '\n', firstrow = 1, codepage = 'acp')

select *
  from LOG_UNID_OPER with (nolock)

update LOG_UNID_OPER
   set UOP_NO=upper(UOP_NO), UOP_ENDERECO=upper(UOP_ENDERECO), UOP_NO_ABREV=upper(UOP_NO_ABREV)

-- insert faixa de caixa postal
bulk insert LOG_FAIXA_UOP from 'C:\integros\temp\LOG_FAIXA_UOP.txt' with (fieldterminator = '@', rowterminator = '\n', firstrow = 1, codepage = 'acp')

select *
  from LOG_FAIXA_UOP with (nolock)

-- insert faixa de CEP de Bairro
bulk insert LOG_FAIXA_BAIRRO from 'C:\integros\temp\LOG_FAIXA_BAIRRO.txt' with (fieldterminator = '@', rowterminator = '\n', firstrow = 1, codepage = 'acp')

select *
  from LOG_FAIXA_BAIRRO with (nolock)

-- insert faixa de CEP de Bairro
bulk insert LOG_VAR_BAI from 'C:\integros\temp\LOG_VAR_BAI.txt' with (fieldterminator = '@', rowterminator = '\n', firstrow = 1, codepage = 'acp')

select *
  from LOG_VAR_BAI with (nolock)

update LOG_VAR_BAI
   set VDB_TX=upper(VDB_TX)

-- insert faixa de CEP de Bairro
bulk insert LOG_FAIXA_CPC from 'C:\integros\temp\LOG_FAIXA_CPC.txt' with (fieldterminator = '@', rowterminator = '\n', firstrow = 1, codepage = 'acp')

select *
  from LOG_FAIXA_CPC with (nolock)

-- exemplo dos correios

drop table #cep

--create view TMPCEP as
select *
  into #cep
  from (
SELECT LOG_LOGRADOURO.UFE_SG
       ,LOG_LOCALIDADE.MUN_NU
       ,LOG_LOCALIDADE.LOC_NO
       ,LOG_BAIRRO.BAI_NO
       ,LOG_LOGRADOURO.TLO_TX + ' ' + LOG_LOGRADOURO.LOG_NO AS LOG_NO	-- "A"
       ,LOG_LOGRADOURO.CEP
       ,LOG_LOGRADOURO.LOG_COMPLEMENTO
       ,'' AS NOME
  FROM LOG_LOGRADOURO, LOG_LOCALIDADE, LOG_BAIRRO			-- logradrouro + localidade + bairro
 WHERE LOG_LOGRADOURO.LOC_NU=LOG_LOCALIDADE.LOC_NU
       AND LOG_LOGRADOURO.BAI_NU_INI=LOG_BAIRRO.BAI_NU
       AND LOG_LOGRADOURO.LOG_STA_TLO='S'					-- se utiliza o tipo de logradouro: "A"
 UNION
SELECT LOG_LOGRADOURO.UFE_SG
       ,LOG_LOCALIDADE.MUN_NU
       ,LOG_LOCALIDADE.LOC_NO
       ,LOG_BAIRRO.BAI_NO
       ,LOG_LOGRADOURO.LOG_NO AS LOG_NO						-- "B"
       ,LOG_LOGRADOURO.CEP
       ,LOG_LOGRADOURO.LOG_COMPLEMENTO
       ,'' AS NOME
  FROM LOG_LOGRADOURO										-- logradouro
       ,LOG_LOCALIDADE
       ,LOG_BAIRRO
 WHERE LOG_LOGRADOURO.LOC_NU=LOG_LOCALIDADE.LOC_NU
       AND LOG_LOGRADOURO.BAI_NU_INI=LOG_BAIRRO.BAI_NU
       AND LOG_LOGRADOURO.LOG_STA_TLO='N'					-- se utiliza o tipo de logradouro: "B"
 UNION 
SELECT LOC.UFE_SG
       ,LOC.MUN_NU AS MUN_NU
       ,LOC.LOC_NO AS LOC_NO
       ,'' AS BAI_NO
       ,'' AS LOG_NO
       ,LOC.CEP
       ,'' AS LOG_COMPLEMENTO
       ,'' AS NOME
  FROM LOG_LOCALIDADE AS LOC			-- localidade
 WHERE LOC.CEP IS NOT NULL
       AND LOC.LOC_NU_SUB IS NULL
 UNION 
SELECT LOC.UFE_SG
       ,LOCSUB.MUN_NU AS MUN_NU
       ,LOCSUB.LOC_NO AS LOC_NO
       ,LOC.LOC_NO AS BAI_NO
       ,'' AS LOG_NO
       ,LOC.CEP
       ,'' AS LOG_COMPLEMENTO
       ,'' AS NOME
  FROM LOG_LOCALIDADE AS LOC			-- localidade
       ,LOG_LOCALIDADE AS LOCSUB		-- sublocalidade
 WHERE LOC.CEP IS NOT NULL
       AND LOC.LOC_NU_SUB IS NOT NULL
       AND LOC.LOC_NU_SUB= LOCSUB.LOC_NU
 UNION 
SELECT LOG_CPC.UFE_SG
       ,LOG_LOCALIDADE.MUN_NU
       ,LOG_LOCALIDADE.LOC_NO
       ,'' AS  BAI_NO
       ,LOG_CPC.CPC_ENDERECO AS LOG_NO
       ,LOG_CPC.CEP
       ,'' AS LOG_COMPLEMENTO
       ,CPC_NO AS NOME
  FROM LOG_CPC							-- caixa postal comunitária
       ,LOG_LOCALIDADE					-- localidade
 WHERE LOG_CPC.LOC_NU=LOG_LOCALIDADE.LOC_NU
 UNION
SELECT LOG_GRANDE_USUARIO.UFE_SG
       ,LOG_LOCALIDADE.MUN_NU
       ,LOG_LOCALIDADE.LOC_NO
       ,LOG_BAIRRO.BAI_NO AS  BAI_NO
       ,LOG_GRANDE_USUARIO.GRU_ENDERECO AS LOG_NO
       ,LOG_GRANDE_USUARIO.CEP
       ,'' AS LOG_COMPLEMENTO
       ,GRU_NO AS NOME
  FROM LOG_GRANDE_USUARIO
       ,LOG_LOCALIDADE, LOG_BAIRRO
 WHERE LOG_GRANDE_USUARIO.LOC_NU=LOG_LOCALIDADE.LOC_NU
       AND LOG_GRANDE_USUARIO.BAI_NU = LOG_BAIRRO.BAI_NU
 UNION
SELECT LOG_UNID_OPER.UFE_SG
       ,LOG_LOCALIDADE.MUN_NU
       ,LOG_LOCALIDADE.LOC_NO
       ,LOG_BAIRRO.BAI_NO AS BAI_NO
       ,LOG_UNID_OPER.UOP_ENDERECO AS LOG_NO
       ,LOG_UNID_OPER.CEP
       ,'' AS LOG_COMPLEMENTO
       ,UOP_NO AS NOME
  FROM LOG_UNID_OPER
       ,LOG_LOCALIDADE
       ,LOG_BAIRRO
 WHERE LOG_UNID_OPER.LOC_NU=LOG_LOCALIDADE.LOC_NU
       AND LOG_UNID_OPER.BAI_NU = LOG_BAIRRO.BAI_NU
	   ) tab

select top 1 *
  from #cep
where LOC_NO='SÃO JOSÉ DOS CAMPOS'


select *
  from CEP
 where CEP.UFE_SG='SP'
       and NOME<>''

 CEP.CEP='12233490'

 select *
  from CEP
 where CEP_NO='12233490'

 insert into CEP
        (CEP_UFE_SG
		,CEP_MUN_NU
        ,CEP_LOC_NO
		,CEP_BAI_NO
		,CEP_LOG_NO
		,CEP_NO
		,CEP_LOG_COMPLEMENTO
		,NOME)
 select rtrim(UFE_SG)
        ,rtrim(MUN_NU)
        ,rtrim(LOC_NO)
		,rtrim(BAI_NO)
		,rtrim(LOG_NO)
		,rtrim(CEP)
		,rtrim(LOG_COMPLEMENTO)
		,rtrim(NOME)
   from #cep

select *
  from CEP with (nolock)

CREATE NONCLUSTERED INDEX [UCEP] ON [CEP] (
      [CEP_UFE_SG],
      [CEP_NO])

CREATE NONCLUSTERED INDEX [UCEP1] ON [CEP] (
      [CEP_UFE_SG],
      [CEP_LOC_NO])

 
 select *
   from LOG_LOCALIDADE with (nolock)
 where LOC_NO='SÃO JOSÉ DOS CAMPOS'

select *
  from TBS003 with (nolock)
 where MUNNOM='SAO JOSE DOS CAMPOS'

select *
  from CEP with (nolock)
