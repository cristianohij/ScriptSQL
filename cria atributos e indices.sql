-- novos atributos
-- TBS010: produtos
alter table [TBS010] add [PROSTBENTB] char(2) default '' with values
alter table [TBS010] add [PROSTBENTA] char(1) default '' with values

-- novos indices
create nonclustered index [ITBS056G] on [TBS056] ([CREEMPCOD] ,[CRENUMBAN])

-- deleta atributos
alter table [TBS056] drop column [CRENUMBAN]




Para utilizar a cláusula drop_existing faça como o exemplo abaixo, onde criamos um índice na tabela authors2 do banco de dados Pubs e depois o recriamos usando a cláusula drop_existing de forma a adicionar uma nova coluna ao índice:

USE pubs
GO
CREATE CLUSTERED INDEX au_id_ind
   ON authors2 (au_id)
WITH FILLFACTOR = 80
GO

sp_helpindex authors2
index_name      index_description                index_keys        
--------------- -------------------------------- ----------------- 
au_id_ind       clustered located on PRIMARY  au_lname
aunmind         nonclustered located on PRIMARY  au_lname, au_fname


-- Recria o índice CLUSTERED utilizando a cláusula DROP_EXISTING
CREATE CLUSTERED INDEX au_id_ind
   ON authors2 (au_id,au_fname)
   WITH DROP_EXISTING


sp_helpindex authors2

index_name     index_description                index_keys        
-------------- -------------------------------- ----------------- 
au_id_ind      clustered located on PRIMARY au_id, au_fname
aunmind        nonclustered located on PRIMARY  au_lname, au_fname

