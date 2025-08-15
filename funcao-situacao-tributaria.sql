drop function SituacaoTributaria
go

create function SituacaoTributaria(@cod_tributario varchar(3)) returns char(1) as
   begin
      -- tributada
      if @cod_tributario in('00','20','50','51','90','101','102')
         return 'T'

      -- isenta
      if @cod_tributario in('40','103','203')
         return 'I'

      -- substituição tributária
      if @cod_tributario in('10','30','60','70','201','202','500')
               return 'F'

      -- não tributada
      if @cod_tributario in('41','400')
         return 'N'

      return 'T'
   end
go

select dbo.SituacaoTributaria('203')

