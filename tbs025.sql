select *
  into TBS025AUX
  from TBS025 with (nolock)
go

drop table TBS025 
go

CREATE TABLE [dbo].[TBS025](
	[PARCHV] [smallint] NOT NULL default 0,
	[PARDES] [char](80) NULL default '',
	[PARTIP] [char](1) NULL default '',
	[PARVAL] [char](250) NULL default '',
	[PARDATCAD] [datetime] NULL default '17530101',
	[PARVALCRI] [char](1) NULL default '',
	[PARVALCHA] [char](32) NULL default '',
PRIMARY KEY CLUSTERED 
(
	[PARCHV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

insert into TBS025 (PARCHV, PARDES, PARTIP, PARVAL, PARDATCAD, PARVALCRI, PARVALCHA)
select PARCHV, PARDES, PARTIP, PARVAL, PARDATCAD, PARVALCRI, PARVALCHA from TBS025AUX
go

select *
  into TBS02521_08_2020
  from TBS025 with (nolock)