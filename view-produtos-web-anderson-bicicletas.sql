drop view dbo.produtosWeb
go

create view dbo.produtosWeb (codigo,descricao,marca,grupo,subgrupo,tamanhoNumero,genero,cor,pesoLiquido,pesoBruto,preco,estoque,grade, dataalt, entrega, largura, altura, profun, volume )
as
select TBS010.PROCOD,
       TBS010.PRODESWEB,
       isnull((select TBS014.MARNOM from dbo.TBS014 (nolock) where TBS014.MAREMPCOD=TBS010.MAREMPCOD and TBS014.MARCOD=TBS010.MARCOD),''),
       isnull((select TBS012.GRUDES from dbo.TBS012 (nolock) where TBS012.GRUEMPCOD=TBS010.GRUEMPCOD and TBS012.GRUCOD=TBS010.GRUCOD),''),
       isnull((select TBS0121.SUBGRUDES from dbo.TBS0121 (nolock)
                where TBS0121.GRUEMPCOD=TBS010.GRUEMPCOD and TBS0121.GRUCOD=TBS010.GRUCOD and TBS0121.SUBGRUCOD=TBS010.SUBGRUCOD),''),
       isnull(TBS010.TAMDES,''),
       isnull(TBS010.GENDES,''),
       isnull(TBS010.CORNOM,''),
       TBS010.PROPESLIQ,
       TBS010.PROPESBRU,
       isnull((select case 
                  when TBS031.TDPPROWE1='S' and TBS031.TDPVALPROI <= getdate() and getdate() <= TBS031.TDPVALPROF then TBS031.TDPPREPRO1 
                  else TBS031.TDPPREWE11
               end
          from dbo.TBS031 (nolock) where TBS031.TDPPROCOD=TBS010.PROCOD),0),
       isnull((select ESTQTDATU from TBS032 (nolock) where TBS032.ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD),0),
       case TBS010.PROCTRGRA when 'S' then PROCODGRA else 0 end,       
       
       dbo.PRODATALTWEB(TBS010.PROCOD, 1),
       
       isnull(TBS010.PROENTWEB, ''),
       isnull(TBS010.PROEMBLAR, 0),
       isnull(TBS010.PROEMBALT, 0),
       isnull(TBS010.PROEMBPROFUN, 0),
       isnull(TBS010.PROEMBVOLUME, 0)
       
  from dbo.TBS010 (nolock)
 where PROWEB='S'
go

select * from dbo.produtosWeb (nolock) 

