SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS with (nolock)
WHERE TABLE_NAME = 'TBS1091';

select *
  from TBS109 with (nolock)
 where ITIEMPCOD=0
       and ITINUM=3246

select *
  from TBS1091 with (nolock)
 where ITIEMPCOD=0
       and ITINUM=3246

SELECT ITIKMATU, ITIDATEMI, ITIHOREMI, ITIHORSAI
FROM TBS109 WITH (NOLOCK)
WHERE ITIEMPCOD = 0 AND ITINUM = 3246

SELECT ITIKMATU, ITIDATEMI, ITIHOREMI, ITIHORSAI FROM TBS109 WITH (NOLOCK) WHERE ITIEMPCOD = 0 AND ITINUM = 3246

select ITIEMPCOD empresa
       ,ITINUM numero
       ,ITIEMPDOC empresa_doc
       ,ITITIPDOC tipo_doc
       ,ITIDOCNUM documento
       ,ITISERDOC serie
       ,ITINUMECF ecf
       ,ITINUMCXA caixa
       ,convert(date,ITIEMIDOC) emissao
       ,convert(date,ITIDATENT) data_entrega
       ,ITIKMENT km_entrega
       ,ITICANDEV canhoto_devolvido
       ,ITITOTDOC valor
       ,ITIQTDVOL qtde_volumes
       ,ITIPESBRU peso_bruto
       ,ITIPESLIQ peso_liquido
       ,ITINOMDES destinario
       ,ITIORDENT ordem_entrega
       ,ITIUFENT uf
       ,ITIMUNENT Municipio
       ,ITIHORCHEENT hora_cheg_local
       ,ITIHORSAIENT hora_sai_local
       ,ITIOBSDOC obs

  from TBS1091 with (nolock)

select *
  from TBS142 with (nolock)

select *
  from TBS108 with (nolock)

select *
  from TBS1091 with (nolock)

select *
  from TBS1091 with (nolock)
 where ITINUM=323
       and ITIDOCNUM=333635

update TBS1091
   set ITIOBSDOC=''
 where ITINUM=323
       and ITIDOCNUM=333635

ALTER TABLE TBS1091
ADD ITITMS DATETIME NOT NULL DEFAULT ('1753-01-01 00:00:00');

CREATE TRIGGER TRG_TBS1091_UPDATE_ITITMS
ON TBS1091
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Atualiza o campo ITITMS com a data e hora atual
    UPDATE TBS1091
    SET ITITMS = GETDATE()
    FROM TBS1091 t
    INNER JOIN inserted i
    ON t.ITIDOCNUM = i.ITIDOCNUM; -- Substitua 'ITIDOCNUM' pela chave primária da tabela

END;
GO

ALTER TABLE TBS1091
ADD ITIENTEFE CHAR(1) NOT NULL DEFAULT ('N');
