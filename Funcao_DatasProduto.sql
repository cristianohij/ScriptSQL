drop function PRODATALTWEB
go

create function PRODATALTWEB(@produto as varchar(60), @estoque int) returns datetime as
   begin
      declare @dataTBS010 as datetime	-- CADASTRO DE PRODUTOS
      declare @dataTBS031 as datetime	-- TABELA DE PRECOS
      --declare @dataTBS032 as datetime	-- SALDOS
      declare @datamaior  as datetime
          
		set @dataTBS010 = (select PRODATALT FROM TBS010 (nolock) WHERE PROCOD = @produto)
		set @dataTBS031 = (select TDPDATATU FROM TBS031 (nolock) WHERE TDPPROCOD = @produto)      
		--set @dataTBS032 = (select ESTDATALT FROM TBS032 (nolock) WHERE PROCOD = @produto AND ESTLOC = @estoque)      		
		
		set @datamaior = @dataTBS010
		
		If @dataTBS031 > @datamaior begin
			set @datamaior = @dataTBS031
		End
		
		--If @dataTBS032 > @datamaior begin
			--set @datamaior = @dataTBS032
		--End
		
                      
      return @datamaior
   end
go