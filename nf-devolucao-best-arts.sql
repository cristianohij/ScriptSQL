select NFENUM,
       convert(int,TBS0591.NFEPROFOR),
       NFEDESXML descricao,
       NFEQTDXML qtde,
       NFEPREXML preco,
       NFEVALPROXML total,
       NFEBASICMSXML bcicms,
       NFEPERICMSXML aliqicms,
       NFEVALICMSXML valicms,
       NFEBASICMSSTXML bcicmsst,
       NFEPERICMSSTXML aliqicmsst,
       NFEVALICMSSTXML valicmsst,
       NFEPERMVASTXML mva,
       NFEBASIPIXML bcipi,
       NFEPERIPIXML aliqipi,
       NFEVALIPIXML valipi,
       NFEVALFREITEXML frete,
       NFEREDBASICMS reducao
  from TBS0591 with (nolock)
 where NFENUM in(217580,221063,222180,224716,225108,227476,228236)
       and TBS0591.NFEPROFOR in('6808','5783','5786','6662','19872','9173','7878','9186','17704','10581','7037','19522','9827','5763','19873','19943')
 order by convert(int,TBS0591.NFEPROFOR)

