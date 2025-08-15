declare @usu char(25)
set @usu = 'ALE'

delete TBS016 where USUCOD = @usu
delete TBS0161 where USUCOD = @usu
delete TBS0162 where USUCOD = @usu
delete TBS0163 where USUCOD = @usu
delete TBS0164 where USUCOD = @usu
delete TBS0165 where USUCOD = @usu

delete TBS017 where USULISTCOD = @usu