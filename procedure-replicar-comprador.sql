--DROP PROCEDURE USP_REPLICAR_COMPRADOR;

create procedure USP_REPLICAR_COMPRADOR (@COMEMPCOD SMALLINT out, @COMCOD SMALLINT out, @COMNOM CHAR(30) out, @COMSTA CHAR(1) out, @COMLIMCOM MONEY out, @COMLIMVEN DATETIME out)
as
begin
    set nocount on

    begin try
        -- bestbag
        if not exists (
            select 1 from bb.SIBD2.dbo.TBS046 with (nolock)
             where COMEMPCOD = @COMEMPCOD and COMCOD = @COMCOD
        )
        begin
            insert into bb.SIBD2.dbo.TBS046 with (nolock)
                (COMEMPCOD, COMCOD, COMNOM, COMSTA, COMLIMCOM, COMLIMVEN, COMDATCAD)
            VALUES
                (@COMEMPCOD, @COMCOD, @COMNOM, @COMSTA, @COMLIMCOM, @COMLIMVEN, convert(date,getdate()));
        END

        -- misaspel
        IF NOT EXISTS (
            SELECT 1 FROM mi.SIBD3.dbo.TBS046
            WHERE COMEMPCOD = @COMEMPCOD AND COMCOD = @COMCOD
        )
        BEGIN
            INSERT INTO mi.SIBD3.dbo.TBS046
                (COMEMPCOD, COMCOD, COMNOM, COMSTA, COMLIMCOM, COMLIMVEN, COMDATCAD)
            VALUES
                (@COMEMPCOD, @COMCOD, @COMNOM, @COMSTA, @COMLIMCOM, @COMLIMVEN, convert(date,getdate()));
        END

        -- papelyna
        IF NOT EXISTS (
            SELECT 1 FROM pp.SIBD.dbo.TBS046
            WHERE COMEMPCOD = @COMEMPCOD AND COMCOD = @COMCOD
        )
        BEGIN
            INSERT INTO pp.SIBD.dbo.TBS046
                (COMEMPCOD, COMCOD, COMNOM, COMSTA, COMLIMCOM, COMLIMVEN, COMDATCAD)
            VALUES
                (@COMEMPCOD, @COMCOD, @COMNOM, @COMSTA, @COMLIMCOM, @COMLIMVEN, convert(date,getdate()));
        END

        -- tanbycd
        IF NOT EXISTS (
            SELECT 1 FROM cd.SIBD.dbo.TBS046
            WHERE COMEMPCOD = @COMEMPCOD AND COMCOD = @COMCOD
        )
        BEGIN
            INSERT INTO cd.SIBD.dbo.TBS046
                (COMEMPCOD, COMCOD, COMNOM, COMSTA, COMLIMCOM, COMLIMVEN, COMDATCAD)
            VALUES
                (@COMEMPCOD, @COMCOD, @COMNOM, @COMSTA, @COMLIMCOM, @COMLIMVEN, convert(date,getdate()));
        END

        -- tanbytte
        IF NOT EXISTS (
            SELECT 1 FROM tt.SIBD.dbo.TBS046
            WHERE COMEMPCOD = @COMEMPCOD AND COMCOD = @COMCOD
        )
        BEGIN
            INSERT INTO tt.SIBD.dbo.TBS046
                (COMEMPCOD, COMCOD, COMNOM, COMSTA, COMLIMCOM, COMLIMVEN, COMDATCAD)
            VALUES
                (@COMEMPCOD, @COMCOD, @COMNOM, @COMSTA, @COMLIMCOM, @COMLIMVEN, convert(date,getdate()));
        END

        -- winpack
        IF NOT EXISTS (
            SELECT 1 FROM wp.SIBD4.dbo.TBS046
            WHERE COMEMPCOD = @COMEMPCOD AND COMCOD = @COMCOD
        )
        BEGIN
            INSERT INTO wp.SIBD4.dbo.TBS046
                (COMEMPCOD, COMCOD, COMNOM, COMSTA, COMLIMCOM, COMLIMVEN, COMDATCAD)
            VALUES
                (@COMEMPCOD, @COMCOD, @COMNOM, @COMSTA, @COMLIMCOM, @COMLIMVEN, convert(date,getdate()));
        END

    END TRY
    BEGIN CATCH
        PRINT 'Erro na replicação: ' + ERROR_MESSAGE();
    END CATCH
END