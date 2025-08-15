create view VWConsultaProdutos
as
select TBS010.PROCOD as CodigoDoProduto,
       TBS010.PRODES as DescricaoDoProduto,
       TBS010.PROUM1 as UM1,
       TBS010.PROUM1QTD as Emabalagem1,
       isnull(case when getdate() between TBS031.TDPVALPROI and TBS031.TDPVALPROF and TBS031.TDPPROLOJ='S' then TBS031.TDPPREPRO1
            else TBS031.TDPPRELOJ1
       end,0) as Preco1Loja,
       TBS010.PROUM2 as UM2,
       TBS010.PROUM2QTD as Emabalagem2,
       isnull(case when getdate() between TBS031.TDPVALPROI and TBS031.TDPVALPROF and TBS031.TDPPROLOJ='S' then TBS031.TDPPREPRO2*TBS010.PROUM2QTD
            else TBS031.TDPPRELOJ2*TBS010.PROUM2QTD
       end,0) as Preco2Loja,
       --isnull((select TBS014.MARNOM from TBS014 (nolock) where TBS014.MARCOD=TBS010.MARCOD),'') as NomeDaMarca,
       isnull(TBS014.MARNOM,'') as NomeDaMarca,
       --isnull((select ESTQTDATU-ESTQTDRES from TBS032 (nolock) where TBS032.ESTLOC=2 and TBS032.PROCOD=TBS010.PROCOD),0) as EstoqueLoja
       isnull(T322.ESTQTDATU-T322.ESTQTDRES,0) as EstoqueLoja,
       isnull(T321.ESTQTDATU-T321.ESTQTDRES,0) as Estoque,
       isnull(T321.ESTQTDCMP,0) as Compras
  from TBS010 (nolock)
       Left join TBS014 (nolock) on TBS014.MARCOD=TBS010.MARCOD
       Left join TBS032 as T321 (nolock) on T321.ESTLOC=1 and T321.PROCOD=TBS010.PROCOD
       Left join TBS032 as T322 (nolock) on T322.ESTLOC=2 and T322.PROCOD=TBS010.PROCOD
       Left join TBS031 (nolock) on TBS031.TDPPROCOD=TBS010.PROCOD
 where TBS010.MARCOD in(108,117,164,847)

--select execute RetornaPrecos '1640054','L'

select * from VWConsultaProdutos