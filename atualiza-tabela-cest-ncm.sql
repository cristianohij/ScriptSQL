-- atualizações de tabels

/* TBS154	CEST (...1541/2)
	 1541	CEST X NCM
	 1542	descrição da NCM */

-- TBS154

select *
  from TBS154 with (nolock)

delete TBS154

insert into TBS154
select *
  from nd.SIBD.dbo.TBS154 with (nolock)

-- TBS1541

select *
  from TBS1541 with (nolock)

delete TBS1541

insert into TBS1541
select *
  from nd.SIBD.dbo.TBS1541 with (nolock)

-- TBS1542

select *
  from TBS1542 with (nolock)

delete TBS1542

insert into TBS1542
select *
  from nd.SIBD.dbo.TBS1542 with (nolock)
