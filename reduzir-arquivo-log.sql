-- muda opção de recovery
alter database SIBD
set recovery simple;
go

-- redução do arquivo de Log
-- se não for especificado ou se for 0, DBCC SHRINKFILE será reduzido ao tamanho de criação do arquivo
dbcc shrinkfile (TRANSF_Log,0);
go

-- muda opção de recovery
alter database SIBD
set recovery full;
go
