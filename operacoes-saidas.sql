declare @tiponf char(1) ,@operacao char(30) ,@destino char(2) ,@pessoa char(1) ,@finaqui char(1) ,@csta char(1) ,@cstb char(2) ,@produto char(15) ,@ncm char(8) ,
        @cliente int ,@contrib char(1)

select * from TBS096 (nolock)
 where OPSTIPNF = @tiponf and
       OPSTIPOPE = @operacao and
       (OPSDES = @destino or OPSDES = '') and
       (OPSTIPPES = @pessoa or OPSTIPPES = '') and
       (OPSFIN = @finaqui or OPSFIN = '') and
       (OPSCSTICMSA = @csta or OPSCSTICMSA = '') and
       (OPSCSTICMSB = @cstb or OPSCSTICMSB = '') and
   

tipo-NF	exato
operacao	exato
destino	exato ou vazios
tipo-pessoa	exato ou vazios
finalidade-aquisicao	exato ou vazios
CST-A	exato ou vazios
CST-B	exato ou vazios
produto	exato, vazios ou coringa
NCM	exato, vazios ou coringa
cliente	exato
contribuinte-ICMS	exato ou vazios
