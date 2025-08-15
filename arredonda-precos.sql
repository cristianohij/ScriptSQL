declare @decValor decimal(18,4) ,@strValor char(18) ,@strDecimais char(4)

set @decValor=1.8950

set @strValor=convert(char(18),@decValor)

set @strDecimais=left(convert(char(18),(@decValor-convert(int,@decValor))*10000),4)

select @strDecimais

select @decValor
select @strValor

if subString(@strDecimais,3,1) < '5'
   begin
   select 'menor do que 5'
   set @strDecimais=left(@strDecimais,2)
   end

if subString(@strDecimais,3,1) >= '5'
   begin
      select 'maior ou igual a 5'
      if right(@strDecimais,1) > '0'
         begin
         select 'proximo maior do que zero'
         set @strDecimais=left(@strDecimais,2)+1
         end
      else
         begin
            select 'proximo igual a zero'
            if convert(int,subString(@strDecimais,2,1)) % 2 = 0
               begin
               select 'numero par'
               set @strDecimais=left(@strDecimais,2)
               end
            else
               begin
               select 'numero impar'
               set @strDecimais=left(@strDecimais,2)+1         
               end
         end
   end

select @strDecimais

select '4'+'1'

select 6 % 2

drop function ArredECFDaruma
go

create function ArredECFDaruma(@decValor decimal(18,4)) returns decimal(18,2) as
   begin
      declare @strValor char(18) ,@strDecimais char(4) ,@intValor int ,@retorno decimal(18,2)

      set @intValor=convert(int,@decValor)
      set @strValor=convert(char(18),@decValor)
      set @strDecimais=left(convert(char(18),(@decValor-convert(int,@decValor))*10000),4)

      if subString(@strDecimais,3,1) < '5'
         set @strDecimais=left(@strDecimais,2)

      if subString(@strDecimais,3,1) >= '5'
         if right(@strDecimais,1) > '0'
            set @strDecimais=left(@strDecimais,2)+1
         else
            if convert(int,subString(@strDecimais,2,1)) % 2 = 0
               set @strDecimais=left(@strDecimais,2)
            else
               set @strDecimais=left(@strDecimais,2)+1         


      set @retorno=convert(decimal(18,2),rtrim(convert(char(18),@intValor))+'.'+@strDecimais)
      return @retorno
   end
go

select dbo.ArredECFDaruma(4.8950)

declare @decimal decimal(18,4) ,@inteiro int

set @decimal=13.4568
set @inteiro=convert(int,@decimal)

select @inteiro

select rtrim(convert(char(18),@inteiro))+'.'+'4568'

