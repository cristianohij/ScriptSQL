select *
  from AgendaVisita with (nolock)

update AgendaVisita
   set av_observacao=''
 where av_observacao is null

update AgendaVisita
   set av_status=0
 where av_status is null

update AgendaVisita
   set av_dia_semana=''
 where av_dia_semana is null

update AgendaVisita
   set av_veiculo=''
 where av_veiculo is null

select *
  into ag_bkp
  from AgendaVisita with (nolock)

-- visitante

ALTER TABLE AgendaVisita
DROP CONSTRAINT DF_AgendaVisita_av_visitante;

ALTER TABLE AgendaVisita
ALTER COLUMN av_visitante VARCHAR(60);

ALTER TABLE AgendaVisita
ADD CONSTRAINT DF_AgendaVisita_av_visitante DEFAULT '' FOR av_visitante;

-- empresa

ALTER TABLE AgendaVisita
DROP CONSTRAINT DF_AgendaVisita_av_empresa;

ALTER TABLE AgendaVisita
ALTER COLUMN av_empresa VARCHAR(60);

ALTER TABLE AgendaVisita
ADD CONSTRAINT DF_AgendaVisita_av_empresa DEFAULT '' FOR av_empresa;

-- município

ALTER TABLE AgendaVisita
DROP CONSTRAINT DF_AgendaVisita_av_municipio;

ALTER TABLE AgendaVisita
ALTER COLUMN av_municipio VARCHAR(50);

ALTER TABLE AgendaVisita
ADD CONSTRAINT DF_AgendaVisita_av_municipio DEFAULT '' FOR av_municipio;

-- sítio

ALTER TABLE AgendaVisita
DROP CONSTRAINT DF_AgendaVisita_av_sitio_visitante;

ALTER TABLE AgendaVisita
ALTER COLUMN av_sitio_visitante VARCHAR(40);

ALTER TABLE AgendaVisita
ADD CONSTRAINT DF_AgendaVisita_av_sitio_visitante DEFAULT '' FOR av_sitio_visitante;

-- observação

ALTER TABLE AgendaVisita
DROP CONSTRAINT DF_AgendaVisita_av_observacao;

ALTER TABLE AgendaVisita
ALTER COLUMN av_observacao VARCHAR(400);

ALTER TABLE AgendaVisita
ADD CONSTRAINT DF_AgendaVisita_av_observacao DEFAULT '' FOR av_observacao;

-- dia da semana

ALTER TABLE AgendaVisita
ALTER COLUMN av_dia_semana VARCHAR(20);

-- dia da semana

ALTER TABLE AgendaVisita
ALTER COLUMN av_veiculo VARCHAR(20);



CREATE TRIGGER trg_AgendaVisita_Insert
ON AgendaVisita
AFTER INSERT
AS
BEGIN
    -- Atualiza as linhas inseridas se o campo av_status for NULL
    UPDATE A
    SET A.av_status = ISNULL(I.av_status, 0),
        A.av_observacao = ISNULL(I.av_observacao, ''),
		A.av_veiculo = ISNULL(I.av_veiculo, '')
    FROM AgendaVisita A
    INNER JOIN inserted I ON A.av_id = I.av_id
    WHERE I.av_status IS NULL OR I.av_observacao IS NULL OR I.av_veiculo IS NULL;
END;

select replace(datename(weekday, av_data),'-Feira','')
  from AgendaVisita
  
update AgendaVisita
   set av_dia_semana=replace(datename(weekday, av_data),'-Feira','')

update AgendaVisita
   set av_dia_semana=datename(weekday, av_data)


-- Apagar a trigger existente
DROP TRIGGER trg_AgendaVisita_Insert;

-- Recriar a trigger com as alterações necessárias
CREATE TRIGGER trg_AgendaVisita_Insert
ON AgendaVisita
AFTER INSERT
AS
BEGIN
    -- Atualiza as linhas inseridas se o campo av_status, av_observacao ou av_veiculo forem NULL
    UPDATE A
    SET A.av_status = ISNULL(I.av_status, 0),
        A.av_observacao = ISNULL(I.av_observacao, ''),
        A.av_veiculo = ISNULL(I.av_veiculo, '')
    FROM AgendaVisita A
    INNER JOIN inserted I ON A.av_id = I.av_id
    WHERE I.av_status IS NULL OR I.av_observacao IS NULL OR I.av_veiculo IS NULL;
END;

