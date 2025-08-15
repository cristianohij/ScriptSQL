CREATE TYPE UFType 
   AS TABLE
      ( Ufe CHAR(2)
      , Name varchar(50));
GO

CREATE PROCEDURE spEstados
@tabEstados UFType READONLY
AS
BEGIN
    SELECT * FROM @tabEstados
END

/* Declare a variable that references the type. */
DECLARE @tabEstadosTVP AS UFType;
/* Add data to the table variable. */

INSERT INTO @tabEstadosTVP (Ufe, Name)
   SELECT UFESIG, UFENOM
   FROM TBS001 with (nolock);
  

--SELECT * FROM @tabEstadosTVP;

/* Pass the table variable data to a stored procedure. */
EXEC spEstados @tabEstadosTVP;

/* tabela temporária não funciona

SELECT UFESIG, UFENOM
  into #estados
  FROM TBS001 with (nolock);

EXEC spEstados #estados;

*/