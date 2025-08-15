-- 2a. a ser executada

if exists(select name from sysobjects where name='SP_CustoMensal' and type='P')
   drop procedure [dbo].[SP_CustoMensal]
go

create procedure [dbo].[SP_CustoMensal] @anomes char(6) as -- @dataDe as date, @dataAte as date as
   begin
      set nocount on

	   declare @msg varchar(1000)

      set @msg = 'Processa ano/mes: ' + @anomes
      raiserror (@msg, 0, 1) with nowait

      set @msg = 'Tabela temporário de entradas - ' + convert(NVARCHAR, getdate(), 8)
      raiserror (@msg, 0, 1) with nowait

      select str(year(TBS059.NFEDATEFE),4)+right('00'+Ltrim(str(month(TBS059.NFEDATEFE),2)),2) anomes
             ,PROCOD codigo

             -- qtde compra na menor unidade * pre�o unit�rio (sem alguns impostos)
             ,sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) -- valor total do m�s
             /
             case sum(NFEQTD * NFEQTDEMB) when 0 then 1 else sum(NFEQTD * NFEQTDEMB) end as custo -- qtde total do m�s

             ,isnull(sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)),0) as valor
             ,isnull(sum(NFEQTD * NFEQTDEMB),0) as qtde -- qtde total do m�s
             ,str(year(TBS059.NFEDATEFE),4)+right('00'+Ltrim(str(month(TBS059.NFEDATEFE),2)),2)+'01' data
             ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROEMPCOD=0 and TBS010.PROCOD=TBS0591.PROCOD) uni
             ,(select PROUM1QTD from TBS010 with (nolock) where TBS010.PROEMPCOD=0 and TBS010.PROCOD=TBS0591.PROCOD) qemb

        into #TMP
        from TBS0591 (nolock)
			 inner join TBS059 (nolock) on TBS059.NFEEMPCOD=TBS0591.NFEEMPCOD and TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
			 inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD

       where --TBS059.NFEDATEFE between @dataDe and @dataAte
	         TBS0591.NFEEMPCOD=0
             and convert(char(6),TBS059.NFEDATEFE,112) = @anomes
             and TBS0591.NFETIP='N'
             and TBS059.NFECAN<>'S'
             and FORCGC not in('05118717000156','05118717000237','52080207000117','44125185000136','41952080000162','65069593000198','65069593000279','65069593000350')
             and right(NFECFOP,3) in('102','403','121','202','411')
       group by year(TBS059.NFEDATEFE),month(TBS059.NFEDATEFE),PROCOD

      set @msg = 'Update em SALDOINICIAL - ' + convert(NVARCHAR, getdate(), 8)
      raiserror (@msg, 0, 1) with nowait

      update SALDOINICIAL
	     set SALDOINICIAL.QTDENTRADA=#TMP.qtde
		     ,SALDOINICIAL.VALENTRADA=#TMP.valor
			 ,SALDOINICIAL.CUSTO=#TMP.custo
        from SALDOINICIAL with (nolock)
             inner join #TMP
             on SALDOINICIAL.ANOMES=#TMP.anomes and SALDOINICIAL.CODIGO=#TMP.codigo

      set @msg = 'Insert em SALDOINICIAL - ' + convert(NVARCHAR, getdate(), 8)
      raiserror (@msg, 0, 1) with nowait

      insert into SALDOINICIAL 
      select #TMP.data
             ,#TMP.anomes
             ,#TMP.codigo
             ,#TMP.uni
             ,#TMP.qemb
             ,#TMP.qtde
             ,#TMP.valor
             ,#TMP.custo
             ,0 E1
             ,0 E2
             ,0 E3
             ,0 E4
             ,0 E5
             ,0 E6
             ,0 E7
             ,0 E8
             ,0 E9
			 ,'' EMPRESA
        from #TMP
       where not exists(select ''
                          from SALDOINICIAL with (nolock) 
                         where SALDOINICIAL.ANOMES=#TMP.anomes and SALDOINICIAL.CODIGO=#TMP.codigo)

--      select * from #TMP
   end

exec SP_CustoMensal '202104'

-- mes fechado

declare @datai date, @dataf date, @comando varchar(50)

select @datai='20220501', @dataf='20250201'

while @datai <= @dataf
   begin
      -- n�o foi poss�vel rodar passando a vari�vel @datai diretamente como par�metro

      set @comando='exec SP_CustoMensal ''' + convert(char(6),@datai,112) + ''''
      execute(@comando)
--print @datai
      set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)
   end

select count(*)
  from SALDOINICIAL with (nolock)
 where ANOMES = '202410'
       and CUSTO > 0

select min([DATA])
  from SALDOINICIAL with (nolock)

select ANOMES
       ,count(*)
  from SALDOINICIAL with (nolock)
 where ANOMES >= '202401'
       and CUSTO > 0
 group by ANOMES