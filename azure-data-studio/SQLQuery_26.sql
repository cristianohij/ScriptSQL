CREATE FUNCTION dbo.ValidarCNPJ (@cnpj VARCHAR(14))
RETURNS BIT
AS
BEGIN
    DECLARE @soma INT, @resto INT;
    DECLARE @digito1 INT, @digito2 INT;
    DECLARE @posicao INT, @contador INT;
    DECLARE @cpfValido BIT = 0;

    -- Remover caracteres não numéricos
    SET @cnpj = REPLACE(@cnpj, '.', '');
    SET @cnpj = REPLACE(@cnpj, '-', '');
    SET @cnpj = REPLACE(@cnpj, '/', '');

    -- Verificar se o CNPJ possui 14 dígitos
    IF LEN(@cnpj) = 14
    BEGIN
        SET @contador = 2;
        SET @soma = 0;

        -- Calcular primeiro dígito verificador
        SET @posicao = 12;
        WHILE @posicao >= 0
        BEGIN
            SET @soma = @soma + CAST(SUBSTRING(@cnpj, @posicao, 1) AS INT) * @contador;
            SET @contador = @contador + 1;
            IF @contador > 9
                SET @contador = 2;
            SET @posicao = @posicao - 1;
        END;

        SET @resto = @soma % 11;
        IF @resto < 2
            SET @digito1 = 0;
        ELSE
            SET @digito1 = 11 - @resto;

        -- Calcular segundo dígito verificador
        SET @posicao = 13;
        SET @contador = 2;
        SET @soma = 0;

        WHILE @posicao >= 0
        BEGIN
            SET @soma = @soma + CAST(SUBSTRING(@cnpj, @posicao, 1) AS INT) * @contador;
            SET @contador = @contador + 1;
            IF @contador > 9
                SET @contador = 2;
            SET @posicao = @posicao - 1;
        END;

        SET @resto = @soma % 11;
        IF @resto < 2
            SET @digito2 = 0;
        ELSE
            SET @digito2 = 11 - @resto;

        -- Verificar se os dígitos calculados correspondem aos dígitos informados
        IF @digito1 = CAST(SUBSTRING(@cnpj, 13, 1) AS INT) AND @digito2 = CAST(SUBSTRING(@cnpj, 14, 1) AS INT)
            SET @cpfValido = 1;
    END;

    RETURN @cpfValido;
END;


select CLICOD
       ,dbo.ValidarCNPJ(CLICGC)
  from TBS002 with (nolock)
 where CLITIPPES='J'
       and CLICGC != ''

-- cnpj com valores não numéricos

select CLICOD
       ,CLICGC
  from TBS002 with (nolock)
 where isnumeric(CLICGC) = 0
       and not patindex('%[^0-9]%', CLICGC) = 0
       and CLITIPPES='J'

-- cnpj com valores numéricos

select CLICOD
       ,CLICGC
  from TBS002 with (nolock)
 where isnumeric(CLICGC) = 1
       and patindex('%[^0-9]%', CLICGC) = 0
       and CLITIPPES='J'

begin tran
update TBS002
   set CLICGC='02795202000100'
 where CLICOD=10498
rollback tran
commit tran

-- cep com valores não numéricos

select CLICOD
       ,CLICEP
  from TBS002 with (nolock)
 where isnumeric(replace(CLICEP,'-','')) = 0
       and not patindex('%[^0-9]%', replace(CLICEP,'-','')) = 0

-- cep com valores numéricos

select CLICOD
       ,CLICEP
  from TBS002 with (nolock)
 where isnumeric(replace(CLICEP,'-','')) = 1
       and patindex('%[^0-9]%', replace(CLICEP,'-','')) = 0



