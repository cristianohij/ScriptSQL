declare @uf char(2)

set @uf=''

select * from TBS001 with (nolock)
 where UFESIG Like(case when @uf<>'' then @uf else '%' end)


declare @fcep smallint

set @fcep=0

select * from TBS001 with (nolock)
 where UFEFCEP between @fcep and case @fcep when 0 then 0 else @fcep end
