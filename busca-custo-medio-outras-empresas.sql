if exists(select name from sysobjects where name='SP_BuscaCustoMedio' and type='P')
   drop procedure [dbo].[SP_BuscaCustoMedio]
go

create procedure [dbo].[SP_BuscaCustoMedio] as
begin
	--set nocount on
	
	declare @msg varchar(1000)

	set @msg = 'Elimina tabelas temporárias - ' + convert(NVARCHAR, getdate(), 8)
	raiserror (@msg, 0, 1) with nowait

	--select 'Elimina tabelas temporárias - ' + convert(NVARCHAR, getdate(), 8)

	if object_id('#CODIGOS') is not null
		drop table #CODIGOS

	if object_id('#PRECOS') is not null
		drop table #PRECOS

	set @msg = 'Fim - ' + convert(NVARCHAR, getdate(), 8)
	raiserror (@msg, 0, 1) with nowait

	declare @emp char(2)
			,@registros int
			,@n int
			,@ri int
			,@rf int
			,@codigo varchar(15)
			,@periodo varchar(6)
			,@custo decimal(12,6)
			,@i int
			,@aux int
			,@qent decimal(12,4)
			,@vent decimal(12,6)

	-- verifica qual a empresa processada
	set @emp = (select top 1
					   case right(EMPCGC,2) 
							when '56' then 'BB'
							when '37' then 'BB'
							when '50' then 'TC'
							when '17' then 'MI'
							when '36' then 'PY'
							when '98' then 'TM'
							when '79' then 'TT'
					   end
				  from TBS023 with (nolock))

	set @msg = 'Carrega tabela de códigos - ' + convert(NVARCHAR, getdate(), 8)
	raiserror (@msg, 0, 1) with nowait

	select CODIGO
	  into #CODIGOS
	  from
	  (
		select CODIGO
		  from SALDOINICIAL with (nolock)
		 where QTDENTRADA = 0
	  ) tab
	 group by CODIGO

	set @msg = 'Fim - ' + convert(NVARCHAR, getdate(), 8)
	raiserror (@msg, 0, 1) with nowait

	set @msg = 'Carrega tabela de preços - ' + convert(NVARCHAR, getdate(), 8)
	raiserror (@msg, 0, 1) with nowait

	-- tabela com os precos dos produtos acima, em todas as empresas
	select empresa
			,periodo
			,codigo
			,custo
			,qentrada
			,ventrada
			,unidade
			,embalagem
			,row_number() over(order by empresa, periodo desc, codigo) seq
		into #PRECOS
		from
		(
		select 'BB' empresa
			   ,ANOMES collate database_default periodo
			   ,CODIGO collate database_default codigo
			   ,CUSTO custo
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI collate database_default unidade
			   ,QEMBALAGEM embalagem
		  from bb.SIBD2.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

		union

		select 'MI'
			   ,ANOMES
			   ,CODIGO
			   ,CUSTO
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI unidade
			   ,QEMBALAGEM embalagem
		  from mi.SIBD3.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

		union

		select 'PY'
			   ,ANOMES 
			   ,CODIGO
			   ,CUSTO
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI unidade
			   ,QEMBALAGEM embalagem
		  from py.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

		union

		select 'TC'
			   ,ANOMES
			   ,CODIGO
			   ,CUSTO
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI unidade
			   ,QEMBALAGEM embalagem
		  from cd.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

		union

		select 'TM'
			   ,ANOMES
			   ,CODIGO
			   ,CUSTO
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI unidade
			   ,QEMBALAGEM embalagem
		  from nd.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

		union

		select 'TT'
			   ,ANOMES
			   ,CODIGO
			   ,CUSTO
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI unidade
			   ,QEMBALAGEM embalagem
		  from tt.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

	    ) tab


	set @msg = 'Fim - ' + convert(NVARCHAR, getdate(), 8)
	raiserror (@msg, 0, 1) with nowait

	-- TANBY matriz

	if @emp = 'TM'
	begin
		-- TANBYs

		set @msg = 'Inclui saldos iniciais da Tanby CD - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='TC'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Tanby Taubaté - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='TT'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		-- SP

		set @msg = 'Inclui saldos iniciais da Best Bag - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='BB'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Misaspel - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='MI'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Papelyna - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='PY'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY CD

		set @msg = 'Atualiza custo de acordo com Tanby CD - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TC'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo --collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo --collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='TC'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TC'
				 where ANOMES=@periodo			--collate database_default
					   and CODIGO=@codigo		--collate database_default
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY TAUBATE

		set @msg = 'Atualiza custo de acordo com Tanby Taubaté - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
			   ,@rf = max(seq)
		  from #PRECOS
		 where empresa='TT'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='TT'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TT'
				 where ANOMES=@periodo collate database_default
					   and CODIGO=@codigo collate database_default
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- BEST BAG

		set @msg = 'Atualiza custo de acordo com Best Bag - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='BB'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='BB'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='BB'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

--------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- MISASPEL

		set @msg = 'Atualiza custo de acordo com Misaspel - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='MI'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='MI'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='MI'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

--------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- PAPELYNA

		set @msg = 'Atualiza custo de acordo com Papelyna - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='PY'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='PY'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='PY'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

	end		-- fim TANBY MATRIZ

	-- MISASPEL

	if @emp = 'MI'
	begin
		-- SP

		set @msg = 'Inclui saldos iniciais da Best Bag - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='BB'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Papelyna - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='PY'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		-- TANBYs

		set @msg = 'Inclui saldos iniciais da Tanby matriz - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='TM'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Tanby CD - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='TC'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Tanby Taubaté - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='TT'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- BEST BAG

		set @msg = 'Atualiza custo de acordo com Best Bag - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='BB'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='BB'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
			--raiserror ('update BB', 0, 1) with nowait
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='BB'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- PAPELYNA
		
		set @msg = 'Atualiza custo de acordo com Papelyna - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='PY'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='PY'
				   and pre.seq=@ri		-- registro atual

			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
			--raiserror ('update PY', 0, 1) with nowait
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='PY'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY matriz

		set @msg = 'Atualiza custo de acordo com Tanby matriz - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TM'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='TM'
				   and pre.seq=@ri
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
			--raiserror ('update TM', 0, 1) with nowait
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TM'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY CD

		set @msg = 'Atualiza custo de acordo com Tanby CD - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TC'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='TC'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
			--raiserror ('update TC', 0, 1) with nowait
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TC'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY taubate

		set @msg = 'Atualiza custo de acordo com Tanby Taubaté - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TT'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='TT'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TT'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

	end		-- fim MISASPEL

	-- BEST BAG

	if @emp = 'BB'
	begin

		-- novo

		-- SP

		set @msg = 'Inclui saldos iniciais da Misaspel - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='MI'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Papelyna - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='PY'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		-- TANBYs

		set @msg = 'Inclui saldos iniciais da Tanby matriz - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='TM'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Tanby CD - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='TC'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Tanby Taubaté - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='TT'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)


		-- fim novo

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- MISASPEL

		set @msg = 'Atualiza custo de acordo com Misaspel - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='MI'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='MI'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='MI'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- PAPELYNA

		set @msg = 'Atualiza custo de acordo com Papelyna - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='PY'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='PY'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='PY'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY matriz

		set @msg = 'Atualiza custo de acordo com Tanby matriz - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TM'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='TM'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
				begin
					update SALDOINICIAL
					   set CUSTO=@custo
						   ,QTDENTRADA=@qent
						   ,VALENTRADA=@vent
						   ,EMPRESA='TM'
					 where ANOMES=@periodo
						   and CODIGO=@codigo
				end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY CD

		set @msg = 'Atualiza custo de acordo com Tanby CD - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TC'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='TC'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TC'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY taubate

		set @msg = 'Atualiza custo de acordo com Tanby Taubaté - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TT'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='TT'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TT'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

	end		-- fim BEST BAG

	-- PAPELYNA

	if @emp = 'PY'
	begin
		-- SP

		set @msg = 'Inclui saldos iniciais da Best Bag - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='BB'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Misaspel - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='MI'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		-- TANBYs

		set @msg = 'Inclui saldos iniciais da Tanby matriz - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='TM'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Tanby CD - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='TC'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)
		set @msg = 'Inclui saldos iniciais da Tanby Taubaté - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='TT'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		-- fim novo

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- BEST BAG

		set @msg = 'Atualiza custo de acordo com Best Bag - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='BB'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='BB'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='BB'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- MISASPEL

		set @msg = 'Atualiza custo de acordo com Misaspel - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='MI'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='MI'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='MI'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY matriz

		set @msg = 'Atualiza custo de acordo com Tanby matriz - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TM'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='TM'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TM'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY CD

		set @msg = 'Atualiza custo de acordo com Tanby CD - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TC'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='TC'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TC'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY taubate

		set @msg = 'Atualiza custo de acordo com Tanby Taubaté - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TT'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='TT'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TT'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

	end		-- fim PAPELYNA

	-- TANBY CD

	if @emp = 'TC'
	begin
		-- TANBYs

		set @msg = 'Inclui saldos iniciais da Tanby matriz - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='TM'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Tanby Taubaté - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='TT'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		-- SP

		set @msg = 'Inclui saldos iniciais da Best Bag - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='BB'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Misaspel - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='MI'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Papelyna - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='PY'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		-- fim novo

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY matriz

		set @msg = 'Atualiza custo de acordo com Tanby matriz - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TM'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='TM'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TM'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY taubate

		set @msg = 'Atualiza custo de acordo com Tanby Taubaté - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TT'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='TT'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TT'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- BEST BAG

		set @msg = 'Atualiza custo de acordo com Best Bag - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='BB'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='BB'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='BB'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- MISASPEL

		set @msg = 'Atualiza custo de acordo com Misaspel - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='MI'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='MI'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='MI'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- PAPELYNA

		set @msg = 'Atualiza custo de acordo com Papelyna - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='PY'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='PY'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='PY'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

	end		-- fim TANBY CD

	-- TANBY taubate

	if @emp = 'TT'
	begin
		-- TANBYs

		set @msg = 'Inclui saldos iniciais da Tanby matriz - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='TM'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Tanby CD - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='TC'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		-- SP

		set @msg = 'Inclui saldos iniciais da Best Bag - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='BB'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Misaspel - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='MI'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		set @msg = 'Inclui saldos iniciais da Papelyna - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		insert into SALDOINICIAL (DATA, ANOMES, CODIGO, UNI, QEMBALAGEM ,QTDENTRADA, VALENTRADA, CUSTO, EMPRESA)
		select rtrim(periodo)+'01'
		       ,periodo
			   ,codigo
			   ,unidade
			   ,embalagem
			   ,qentrada
			   ,ventrada
			   ,custo
			   ,empresa
		  from #PRECOS
		 where empresa='PY'
			   and not exists(select ''
							 from SALDOINICIAL busca with (nolock)
							where busca.ANOMES=#PRECOS.periodo
								  and busca.CODIGO=#PRECOS.codigo)

		-- fim novo

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY matriz

		set @msg = 'Atualiza custo de acordo com Tanby matriz - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TM'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='TM'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TM'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY CD

		set @msg = 'Atualiza custo de acordo com Tanby CD - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TC'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='TC'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TC'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- BEST BAG

		set @msg = 'Atualiza custo de acordo com Best Bag - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='BB'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='BB'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='BB'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- MISASPEL

		set @msg = 'Atualiza custo de acordo com Misaspel - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='MI'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='MI'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='MI'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- PAPELYNA

		set @msg = 'Atualiza custo de acordo com Papelyna - ' + convert(NVARCHAR, getdate(), 8)
		raiserror (@msg, 0, 1) with nowait

		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='PY'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate database_default
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.empresa='PY'
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='PY'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

	end		-- fim TANBY taubate

end
go

exec SP_BuscaCustoMedio -- última misaspel

select *
  from #CODIGOS
 where CODIGO='20150003'

	-- tabela com os precos dos produtos acima, em todas as empresas
	select empresa
			,periodo
			,codigo
			,custo
			,qentrada
			,ventrada
			,unidade
			,embalagem
			,row_number() over(order by empresa, periodo desc, codigo) seq
		into #PRECOS
		from
		(
		select 'BB' empresa
			   ,ANOMES collate database_default periodo
			   ,CODIGO collate database_default codigo
			   ,CUSTO custo
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI collate database_default unidade
			   ,QEMBALAGEM embalagem
		  from bb.SIBD2.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

		union

		/*
		select 'MI'
			   ,ANOMES
			   ,CODIGO
			   ,CUSTO
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI unidade
			   ,QEMBALAGEM embalagem
		  from mi.SIBD3.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

			union
		*/

		select 'PY'
			   ,ANOMES 
			   ,CODIGO
			   ,CUSTO
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI unidade
			   ,QEMBALAGEM embalagem
		  from py.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

			union

		select 'TC'
			   ,ANOMES
			   ,CODIGO
			   ,CUSTO
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI unidade
			   ,QEMBALAGEM embalagem
		  from cd.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

			union

		select 'TM'
			   ,ANOMES
			   ,CODIGO
			   ,CUSTO
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI unidade
			   ,QEMBALAGEM embalagem
		  from nd.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

			union

		select 'TT'
			   ,ANOMES
			   ,CODIGO
			   ,CUSTO
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI unidade
			   ,QEMBALAGEM embalagem
		  from tt.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

	    ) tab

select *
  from #PRECOS
 where codigo='20150003'
 order by seq

select min(seq)
	   ,max(seq)
  from #PRECOS
 where empresa='BB'

select top 1
	   sal.ANOMES
	   ,pre.codigo
	   ,pre.custo
	   ,pre.qentrada
	   ,pre.ventrada
	   ,sal.*
	   ,pre.*
  from SALDOINICIAL sal with (nolock)
 inner join #PRECOS pre
       on sal.ANOMES >= pre.periodo collate database_default		-- ano/m�s maior/igual per�odo procurado
	      and sal.CODIGO = pre.codigo collate database_default
 where sal.QTDENTRADA=0	-- sem entrada
       and sal.CUSTO=0		-- sem custo
	   and pre.empresa='BB'
	   and pre.seq=15864		-- registro atual
 order by sal.ANOMES, sal.CODIGO

select rtrim(periodo)+'01'
	   ,periodo
	   ,codigo
	   ,unidade
	   ,embalagem
	   ,qentrada
	   ,ventrada
	   ,custo
	   ,empresa
  from #PRECOS
 where empresa in('BB')	--,'PY')
	   and not exists(select ''
					    from SALDOINICIAL busca with (nolock)
				       where busca.ANOMES=#PRECOS.periodo
						     and busca.CODIGO=#PRECOS.codigo)
       and codigo='20150003'

select count(*)
  from SALDOINICIAL with (nolock)
 where CUSTO > 0

select count(*)
  from SALDOINICIAL with (nolock)
 where CUSTO = 0

select *
  from SALDOINICIAL with (nolock)
 where [DATA] >= '20220101'
       and EMPRESA<>'TT'
       and EMPRESA<>''
 order by [DATA] desc


