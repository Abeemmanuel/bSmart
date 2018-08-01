USE [smartdb]
GO
/****** Object:  Table [dbo].[bg_forecast]    Script Date: 8/1/2018 9:20:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bg_forecast](
	[bg_forecast_pk] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NULL,
	[event_date] [date] NULL,
	[event_time] [datetime] NULL,
	[event_time_mins] [int] NULL,
	[sensor_bg] [int] NULL,
	[bg_delta] [int] NULL,
	[winner] [varchar](50) NULL,
	[trend] [varchar](50) NULL,
	[action_needed] [varchar](50) NULL,
	[carbs] [int] NULL,
	[insulin] [decimal](10, 4) NULL,
	[iob] [decimal](10, 4) NULL,
	[effect01] [int] NULL,
	[effect02] [int] NULL,
	[effect03] [int] NULL,
	[effect04] [int] NULL,
	[effect05] [int] NULL,
	[effect06] [int] NULL,
	[effect07] [int] NULL,
	[effect08] [int] NULL,
	[forecasted_bg] [int] NULL,
	[actual_bg] [int] NULL,
	[forecasting_error] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[factor_model]    Script Date: 8/1/2018 9:20:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[factor_model](
	[factor_model_pk] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NULL,
	[factor_name] [varchar](64) NULL,
	[period_mins] [int] NULL,
	[period_pct] [decimal](10, 4) NULL,
	[cumm_pct] [decimal](10, 4) NULL,
	[period_amt] [int] NULL,
	[cumm_amt] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_factor]    Script Date: 8/1/2018 9:20:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_factor](
	[user_factor_pk] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NULL,
	[factor_name] [varchar](64) NULL,
	[factor_desc] [varchar](255) NULL,
	[factor_value] [varchar](255) NULL,
	[start_time_mins] [int] NULL,
	[end_time_mins] [int] NULL,
	[effective_from_dt] [datetime] NOT NULL,
	[effective_to_dt] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[insulin_model_1_effect]    Script Date: 8/1/2018 9:20:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[insulin_model_1_effect] as
select event_time_mins,cast(sum(down_effect) as int) insulin_eff from (
select event_time_mins+10 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 10
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+10 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 20
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+30 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 30
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+40 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 40
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+50 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 50
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+60 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 60
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+70 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 70
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+80 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 80
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+90 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 90
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+100 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 100
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+110 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 110
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+120 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 120
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+uf.factor_value as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = uf.factor_value
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+140 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 140
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+150 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 150
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+160 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 160
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+170 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 170
and uf.factor_name = 'Insulin Sensitivity Factor'
union
select event_time_mins+180 as event_time_mins,round(insulin*fm.period_pct*uf.factor_value,1)*-1 down_effect
from 
dbo.bg_forecast bgf,
dbo.factor_model fm,
dbo.user_factor uf 
where 
fm.factor_name = '3 Hr Insulin' 
and bgf.insulin>0.01
and fm.period_mins = 180
and uf.factor_name = 'Insulin Sensitivity Factor'
) de
group by event_time_mins
GO
/****** Object:  Table [dbo].[bg_forecast_hist]    Script Date: 8/1/2018 9:20:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bg_forecast_hist](
	[bg_forecast_hist_pk] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NULL,
	[event_date] [date] NULL,
	[event_time_mins] [int] NULL,
	[sensor_bg] [int] NULL,
	[bg_delta] [int] NULL,
	[winner] [varchar](50) NULL,
	[trend] [varchar](50) NULL,
	[action_needed] [varchar](50) NULL,
	[carbs] [int] NULL,
	[insulin] [decimal](10, 4) NULL,
	[effect01] [int] NULL,
	[effect02] [int] NULL,
	[effect03] [int] NULL,
	[effect04] [int] NULL,
	[effect05] [int] NULL,
	[effect06] [int] NULL,
	[effect07] [int] NULL,
	[effect08] [int] NULL,
	[forecasted_bg] [int] NULL,
	[iob] [decimal](10, 2) NULL,
	[event_date_time] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bg_log]    Script Date: 8/1/2018 9:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bg_log](
	[bg_log_pk] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NULL,
	[event_date_id] [bigint] NULL,
	[event_date_time] [datetime] NULL,
	[event_date] [date] NULL,
	[event_time_mins] [int] NULL,
	[event_day] [varchar](50) NULL,
	[event_type] [varchar](50) NULL,
	[sensor_bg] [int] NULL,
	[manual_bg] [int] NULL,
	[carbs] [int] NULL,
	[carb_type] [varchar](50) NULL,
	[pump_reservoir_level] [decimal](10, 4) NULL,
	[insulin] [decimal](10, 4) NULL,
	[other_factors] [varchar](255) NULL,
	[event_notes] [varchar](255) NULL,
	[iob] [decimal](10, 4) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bg_log_bkp]    Script Date: 8/1/2018 9:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bg_log_bkp](
	[bg_log_pk] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NULL,
	[event_date_id] [bigint] NULL,
	[event_date_time] [datetime] NULL,
	[event_date] [date] NULL,
	[event_time_mins] [int] NULL,
	[event_day] [varchar](50) NULL,
	[event_type] [varchar](50) NULL,
	[sensor_bg] [int] NULL,
	[manual_bg] [int] NULL,
	[carbs] [int] NULL,
	[carb_type] [varchar](50) NULL,
	[pump_reservoir_level] [decimal](10, 4) NULL,
	[insulin] [decimal](10, 4) NULL,
	[other_factors] [varchar](255) NULL,
	[event_notes] [varchar](255) NULL,
	[iob] [decimal](10, 4) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bg_patterns]    Script Date: 8/1/2018 9:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bg_patterns](
	[event_date] [date] NULL,
	[event01_time] [int] NULL,
	[bg01] [int] NULL,
	[insulin01] [decimal](10, 4) NULL,
	[delta01] [int] NULL,
	[event02_time] [int] NULL,
	[bg02] [int] NULL,
	[insulin02] [decimal](10, 4) NULL,
	[delta02] [int] NULL,
	[event03_time] [int] NULL,
	[bg03] [int] NULL,
	[insulin03] [decimal](10, 4) NULL,
	[delta03] [int] NULL,
	[event04_time] [int] NULL,
	[bg04] [int] NULL,
	[insulin04] [decimal](10, 4) NULL,
	[delta04] [int] NULL,
	[event05_time] [int] NULL,
	[bg05] [int] NULL,
	[insulin05] [decimal](10, 4) NULL,
	[delta05] [int] NULL,
	[event06_time] [int] NULL,
	[bg06] [int] NULL,
	[insulin06] [decimal](10, 4) NULL,
	[delta06] [int] NULL,
	[event07_time] [int] NULL,
	[bg07] [int] NULL,
	[insulin07] [decimal](10, 4) NULL,
	[delta07] [int] NULL,
	[event08_time] [int] NULL,
	[bg08] [int] NULL,
	[insulin08] [decimal](10, 4) NULL,
	[delta08] [int] NULL,
	[event09_time] [int] NULL,
	[bg09] [int] NULL,
	[insulin09] [decimal](10, 4) NULL,
	[delta09] [int] NULL,
	[event10_time] [int] NULL,
	[bg10] [int] NULL,
	[insulin10] [decimal](10, 4) NULL,
	[delta10] [int] NULL,
	[event11_time] [int] NULL,
	[bg11] [int] NULL,
	[insulin11] [decimal](10, 4) NULL,
	[delta11] [int] NULL,
	[event12_time] [int] NULL,
	[bg12] [int] NULL,
	[insulin12] [decimal](10, 4) NULL,
	[delta12] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user]    Script Date: 8/1/2018 9:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user](
	[userid] [int] IDENTITY(1,1) NOT NULL,
	[user_name] [varchar](50) NULL,
	[user_email] [varchar](255) NULL,
	[user_password] [varchar](255) NULL,
	[user_dob] [date] NULL,
	[user_weight] [varchar](50) NULL,
	[user_relationship] [varchar](50) NULL,
	[user_question] [varchar](255) NULL,
	[user_answer] [varchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bg_log] ADD  DEFAULT ('BASAL') FOR [event_type]
GO
ALTER TABLE [dbo].[bg_log] ADD  DEFAULT ((120)) FOR [sensor_bg]
GO
ALTER TABLE [dbo].[bg_log] ADD  DEFAULT ((120)) FOR [manual_bg]
GO
ALTER TABLE [dbo].[bg_log] ADD  DEFAULT ((0)) FOR [carbs]
GO
ALTER TABLE [dbo].[bg_log] ADD  DEFAULT ('Normal') FOR [carb_type]
GO
ALTER TABLE [dbo].[bg_log] ADD  DEFAULT ((0.00)) FOR [pump_reservoir_level]
GO
ALTER TABLE [dbo].[bg_log] ADD  DEFAULT ((0.00)) FOR [insulin]
GO
ALTER TABLE [dbo].[bg_log] ADD  DEFAULT ((0.00)) FOR [iob]
GO
ALTER TABLE [dbo].[user_factor] ADD  DEFAULT ('2000-01-01') FOR [effective_from_dt]
GO
ALTER TABLE [dbo].[user_factor] ADD  DEFAULT ('2099-12-31') FOR [effective_to_dt]
GO
/****** Object:  StoredProcedure [dbo].[ANALYZE_EVENT_DATA]    Script Date: 8/1/2018 9:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ANALYZE_EVENT_DATA](
@procReturn VARCHAR(500) out)
AS BEGIN TRY
SET @procReturn ='SUCCESS';

DECLARE @ISF int = 130;

/* start with a clean slate */
	update dbo.bg_forecast
	set 
	event_date = DATEADD(Hour,-5,GETDATE()),
	event_time = dateadd(minute,event_time_mins,cast(cast(GETDATE() as date) as datetime)),
	sensor_bg = null,
	insulin = null,
	iob = null,
	bg_delta = null,
	winner = null,
	trend = null,
	action_needed = 'NO ACTION',
	effect01 = null,
	effect02 = null,
	effect03 = null,
	effect04 = 2, -- liver effect
	forecasted_bg = null;



/* get BG and Insulin data */
	update bgf
	set 
	bgf.sensor_bg = bgl1.sensor_bg,
	bgf.insulin = bgl2.insulin_dose,
	bgf.iob = bgl2.iob
	from dbo.bg_forecast bgf
	left outer join 
	/* Query to summarize BG at 10 min interval levels */
	(select round(event_time_mins,-1) event_mins,avg(sensor_bg) sensor_bg from dbo.bg_log
	where event_type = 'BG' and sensor_bg <>0 and event_date =  convert(varchar(10),DATEADD(Hour,-5,GETDATE()),126)
	group by round(event_time_mins,-1)) bgl1 
	on bgf.event_time_mins = bgl1.event_mins
	left outer join 
	/* Query to summarize Insulin Dose and Insulin On Board (IOB) at 10 min interval levels */
	(select bg1.event_time_mins,bg1.iob, bg2.min_pump_reservoir_level-bg1.max_pump_reservoir_level+bg1.insulin as insulin_dose
	from
	(select round(event_time_mins,-1) event_time_mins,max(iob) iob, max(pump_reservoir_level) as max_pump_reservoir_level,min(pump_reservoir_level) as min_pump_reservoir_level,
	max(pump_reservoir_level)-min(pump_reservoir_level)  as insulin from  dbo.bg_log
		where event_type = 'INSULIN' 
		group by round(event_time_mins,-1)) bg1,
	(select round(event_time_mins,-1) event_time_mins,max(iob) iob, max(pump_reservoir_level) as max_pump_reservoir_level,min(pump_reservoir_level) as min_pump_reservoir_level,
	max(pump_reservoir_level)-min(pump_reservoir_level)  as insulin from  dbo.bg_log
		where event_type = 'INSULIN' 
		group by round(event_time_mins,-1)) bg2
	where bg1.event_time_mins = bg2.event_time_mins+10) bgl2
	on bgf.event_time_mins = bgl2.event_time_mins;



/* Add Insulin Effect */
	update bgf
	set 
	bgf.effect01 = ie.insulin_eff, -- Insulin dose effect for the 10 mins
	bgf.effect02 =  -1*bgf.iob*uf.factor_value        -- IOB effect for the remaining period of the insulin
	from
	dbo.bg_forecast bgf
	inner join dbo.insulin_model_1_effect ie 
	on bgf.event_time_mins = ie.event_time_mins
	inner join dbo.user_factor uf on uf.factor_name = 'Insulin Sensitivity Factor';
	
	update bgf
	set 
	bgf.effect03 = fbg.insulin_eff -- Insulin effect for the next 2 hrs
	from
	dbo.bg_forecast bgf
	inner join (
	select bg1.event_time_mins,sum(bg2.effect01)+sum(bg2.effect04) insulin_eff from 
	dbo.bg_forecast bg1,
	dbo.bg_forecast bg2 
	where bg1.event_time_mins<=bg2.event_time_mins and bg1.event_time_mins+120>bg2.event_time_mins
	and bg2.effect01<=0
	and bg1.sensor_bg is not null
	group by  bg1.event_time_mins,bg1.sensor_bg) fbg 
	on bgf.event_time_mins = fbg.event_time_mins;



/* get bg delta data */
	update bgf1
	set bgf1.bg_delta = bgf1.sensor_bg-bgf2.sensor_bg
	from dbo.bg_forecast bgf1
	inner join dbo.bg_forecast bgf2 on bgf1.event_time_mins = bgf2.event_time_mins+10;

/* Find winner */
	update bgf1
	set bgf1.winner = case when bgf1.bg_delta-bgf2.bg_delta>0 and bgf1.bg_delta>0 then 'CARBS' else 'INSULIN' end
	from dbo.bg_forecast bgf1
	inner join dbo.bg_forecast bgf2 on bgf1.event_time_mins = bgf2.event_time_mins+10;

/* Find trend */
	update bgf1
	set bgf1.trend = case when bgf1.winner=bgf2.winner then 'MAINTAINING' else 'SHIFT' end
	from dbo.bg_forecast bgf1
	inner join dbo.bg_forecast bgf2 on bgf1.event_time_mins = bgf2.event_time_mins+10;

/* Set forecasted BG */
	update bgf1
	set bgf1.forecasted_bg = case when effect02 = 0 then sensor_bg+effect03 else  sensor_bg+effect02 end
	from dbo.bg_forecast bgf1

/* Set High Alert */
	update bgf1
	set bgf1.action_needed = case when bgf1.winner = 'CARBS' and bgf1.forecasted_bg >180 then 'MORE INSULIN' else  bgf1.action_needed end
	from dbo.bg_forecast bgf1;

/* Set Low Alert */
	update bgf1
	set bgf1.action_needed = case when bgf1.winner = 'INSULIN' and bgf1.trend = 'MAINTAINING' and bgf1.forecasted_bg <80 then 'NEED JUICE' else  bgf1.action_needed end
	from dbo.bg_forecast bgf1;

SET @procReturn =(select action_needed from dbo.bg_forecast where event_time_mins in (
select max(event_time_mins) from dbo.bg_forecast where sensor_bg is not null));

END TRY

BEGIN CATCH
        SET @procReturn = ERROR_MESSAGE();

END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[ANALYZE_EVENT_HISTORY]    Script Date: 8/1/2018 9:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ANALYZE_EVENT_HISTORY](
@procReturn VARCHAR(500) out)
AS BEGIN TRY
SET @procReturn ='SUCCESS';


/* start with a clean slate */
truncate table dbo.bg_forecast_hist;

/* Load all data */
insert into dbo.bg_forecast_hist(event_date,event_time_mins,sensor_bg,insulin)
select event_date,event_mins,max(sensor_bg) as sensor_bg,max(insulin) as insulin from (
select event_date, round(event_time_mins,-1) event_mins,avg(sensor_bg) sensor_bg,0 as insulin from dbo.bg_log
where event_type = 'BG' and sensor_bg <>0
group by event_date,round(event_time_mins,-1)
union
select event_date,round(event_time_mins,-1) event_mins,0 as sensor_bg,max(pump_reservoir_level) -min(pump_reservoir_level) as insulin from dbo.bg_log
where event_type = 'INSULIN' 
group by event_date,round(event_time_mins,-1)) a
group by event_date,event_mins
order by 1,2

/* get bg delta data */
update bgf1
set bgf1.bg_delta = bgf1.sensor_bg-bgf2.sensor_bg
from dbo.bg_forecast_hist bgf1
inner join dbo.bg_forecast_hist bgf2 on bgf1.event_date = bgf2.event_date and bgf1.event_time_mins = bgf2.event_time_mins+10;

truncate table dbo.bg_patterns;

insert into dbo.bg_patterns
select bgf01.event_date,
bgf01.event_time_mins as event01_time,bgf01.sensor_bg as bg01,bgf01.insulin as insulin01,bgf01.bg_delta as delta01,
bgf02.event_time_mins as event02_time,bgf02.sensor_bg as bg02,bgf02.insulin as insulin02,bgf02.bg_delta as delta02,
bgf03.event_time_mins as event03_time,bgf03.sensor_bg as bg03,bgf03.insulin as insulin03,bgf03.bg_delta as delta03,
bgf04.event_time_mins as event04_time,bgf04.sensor_bg as bg04,bgf04.insulin as insulin04,bgf04.bg_delta as delta04,
bgf05.event_time_mins as event05_time,bgf05.sensor_bg as bg05,bgf05.insulin as insulin05,bgf05.bg_delta as delta05,
bgf06.event_time_mins as event06_time,bgf06.sensor_bg as bg06,bgf06.insulin as insulin06,bgf06.bg_delta as delta06,
bgf07.event_time_mins as event07_time,bgf07.sensor_bg as bg07,bgf07.insulin as insulin07,bgf07.bg_delta as delta07,
bgf08.event_time_mins as event08_time,bgf08.sensor_bg as bg08,bgf08.insulin as insulin08,bgf08.bg_delta as delta08,
bgf09.event_time_mins as event09_time,bgf09.sensor_bg as bg09,bgf09.insulin as insulin09,bgf09.bg_delta as delta09,
bgf10.event_time_mins as event10_time,bgf10.sensor_bg as bg10,bgf10.insulin as insulin10,bgf10.bg_delta as delta10,
bgf11.event_time_mins as event11_time,bgf11.sensor_bg as bg11,bgf11.insulin as insulin11,bgf11.bg_delta as delta11,
bgf12.event_time_mins as event12_time,bgf12.sensor_bg as bg12,bgf12.insulin as insulin12,bgf12.bg_delta as delta12
from 
dbo.bg_forecast_hist bgf01,
dbo.bg_forecast_hist bgf02,
dbo.bg_forecast_hist bgf03,
dbo.bg_forecast_hist bgf04,
dbo.bg_forecast_hist bgf05,
dbo.bg_forecast_hist bgf06,
dbo.bg_forecast_hist bgf07,
dbo.bg_forecast_hist bgf08,
dbo.bg_forecast_hist bgf09,
dbo.bg_forecast_hist bgf10,
dbo.bg_forecast_hist bgf11,
dbo.bg_forecast_hist bgf12
where
bgf01.event_time_mins+10 = bgf02.event_time_mins and bgf01.event_date = bgf02.event_date and
bgf02.event_time_mins+10 = bgf03.event_time_mins and bgf02.event_date = bgf03.event_date and
bgf03.event_time_mins+10 = bgf04.event_time_mins and bgf03.event_date = bgf04.event_date and
bgf04.event_time_mins+10 = bgf05.event_time_mins and bgf04.event_date = bgf05.event_date and
bgf05.event_time_mins+10 = bgf06.event_time_mins and bgf05.event_date = bgf06.event_date and
bgf06.event_time_mins+10 = bgf07.event_time_mins and bgf06.event_date = bgf07.event_date and
bgf07.event_time_mins+10 = bgf08.event_time_mins and bgf07.event_date = bgf08.event_date and
bgf08.event_time_mins+10 = bgf09.event_time_mins and bgf08.event_date = bgf09.event_date and
bgf09.event_time_mins+10 = bgf10.event_time_mins and bgf09.event_date = bgf10.event_date and
bgf10.event_time_mins+10 = bgf11.event_time_mins and bgf10.event_date = bgf11.event_date and
bgf11.event_time_mins+10 = bgf12.event_time_mins and bgf11.event_date = bgf12.event_date;

END TRY

BEGIN CATCH
        SET @procReturn = ERROR_MESSAGE();

END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[INSERT_EVENT_DATA]    Script Date: 8/1/2018 9:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[INSERT_EVENT_DATA](@EventDoc NVARCHAR(MAX),
@procReturn VARCHAR(500) out)
AS BEGIN TRY
SET @procReturn ='SUCCESS';

DECLARE @dateId bigint;


SET @dateId = JSON_VALUE(@EventDoc,'$.date_id')

IF NOT EXISTS (SELECT 1 FROM dbo.bg_log where event_date_id = @dateId)

BEGIN

		  INSERT INTO dbo.bg_log(
		  event_date_id,
		  event_date_time,
		  event_date,
		  event_time_mins,
		  event_type,
		  sensor_bg,
		  pump_reservoir_level,
		  insulin,
		  iob
		  )
		  SELECT 
		  cast(date_id as bigint),
		  dateadd( SECOND, round(cast(date_id as bigint)/1000,0), '1970-1-1' ),
		  cast(date as date),
		  cast(mins as int),
		  event,
		  cast(bg as int),
		  cast(reservoir as decimal(10,4)),
		  cast(insulin as decimal(10,4)),
		  cast(iob as decimal(10,4))
		  FROM OPENJSON(@EventDoc)
			   WITH (
				  date_id varchar(255),
				  date varchar(255),
				  mins varchar(50),
				  event varchar(100),
				  bg varchar(50),
				  reservoir varchar(50),
				  insulin varchar(50),
				  iob varchar(50)
			   );
END


SET @procReturn ='SUCCESS';

END TRY

BEGIN CATCH
        SET @procReturn = ERROR_MESSAGE();

END CATCH;
GO
