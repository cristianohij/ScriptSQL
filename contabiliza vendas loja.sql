select distinct ZK_COD as 'codigo',B1_DESC as 'descricao',B1_UM as 'UM',ZK_PICM as 'ICMS',sum(ZK_QTDVEN) as 'qtde',
       (sum(ZK_VALOR)/sum(ZK_QTDVEN)) as 'preco',sum(ZK_VALOR) as 'total',(sum(ZK_VALOR*ZK_PICM)/100) as 'valor ICMS'
 where ZK_DATMOV between '20080401' and '20080430' and ZK_PICM > 0 and
       exists(select 'ex' from PHANTOM.SIBD.dbo.TBS010 where PROCOD=ZK_COD and PROSTBB='60')
 group by ZK_COD,B1_DESC,B1_UM,ZK_PICM
 order by ZK_COD


select distinct ZK_COD as 'codigo',PRODES as 'descricao',PROUM1 as 'UM',ZK_PICM as 'ICMS',sum(ZK_QTDVEN) as 'qtde',
       (sum(ZK_VALOR)/sum(ZK_QTDVEN)) as 'preco',sum(ZK_VALOR) as 'total',(sum(ZK_VALOR*ZK_PICM)/100) as 'valor ICMS'
  from SZK010,PHANTOM.SIBD.dbo.TBS010 
 where D_E_L_E_T_='' and ZK_DATMOV between '20080501' and '20080531' and ZK_COD=PROCOD and ZK_PICM > 0 and PROSTBB='60'
 group by ZK_COD,PRODES,PROUM1,ZK_PICM
 order by ZK_COD

