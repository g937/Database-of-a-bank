USE [master]
GO
CREATE DATABASE [JDB Bank]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Bank', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Bank.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Bank_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Bank_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [JDB Bank] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [JDB Bank].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [JDB Bank] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [JDB Bank] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [JDB Bank] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [JDB Bank] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [JDB Bank] SET ARITHABORT OFF 
GO
ALTER DATABASE [JDB Bank] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [JDB Bank] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [JDB Bank] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [JDB Bank] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [JDB Bank] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [JDB Bank] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [JDB Bank] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [JDB Bank] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [JDB Bank] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [JDB Bank] SET  DISABLE_BROKER 
GO
ALTER DATABASE [JDB Bank] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [JDB Bank] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [JDB Bank] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [JDB Bank] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [JDB Bank] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [JDB Bank] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [JDB Bank] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [JDB Bank] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [JDB Bank] SET  MULTI_USER 
GO
ALTER DATABASE [JDB Bank] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [JDB Bank] SET DB_CHAINING OFF 
GO
ALTER DATABASE [JDB Bank] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [JDB Bank] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [JDB Bank] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [JDB Bank] SET QUERY_STORE = OFF
GO
USE [JDB Bank]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UGYFELEK](
	[ugyfelazonosito] [char](10) NOT NULL,
	[vnev] [nvarchar](50) NOT NULL,
	[knev] [nvarchar](50) NOT NULL,
	[anyja_neve] [nvarchar](80) NOT NULL,
	[szul_hely] [nvarchar](50) NOT NULL,
	[szul_ido] [date] NOT NULL,
	[nem] [nvarchar](5) NOT NULL,
	[telepules] [nvarchar](50) NOT NULL,
	[iranyitoszam] [char](4) NOT NULL,
	[utca + hsz] [nvarchar](50) NOT NULL,
	[mobilsz] [char](12) NOT NULL,
	[email] [varchar](50) NOT NULL,
	[szemigszam] [char](8) NOT NULL,
	[adoszam] [char](10) NOT NULL,
	[allampolgarsag] [nvarchar](30) NOT NULL,
	[munkaviszony_jelleg] [nvarchar](15) NOT NULL,
	[jovedelem_forrasa] [nvarchar](8) NOT NULL,
 CONSTRAINT [PK_UGYFELEK] PRIMARY KEY CLUSTERED 
(
	[ugyfelazonosito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [Ugyfeleink_nevsora] AS
select ugyfelazonosito, vnev+' '+ knev AS 'Névsor'
from ugyfelek
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BETETEK](
	[bankszamlasz] [char](26) NOT NULL,
	[b_fajta] [char](1) NOT NULL,
	[ugyfelazonosito] [char](10) NOT NULL,
	[bankkartya_szam] [char](19) NOT NULL,
	[b_futamido] [nvarchar](15) NOT NULL,
	[b_kamat] [real] NOT NULL,
	[kamatozas_modja] [nvarchar](25) NOT NULL,
	[b_szerzodes_szam] [char](10) NOT NULL,
	[b_szerzodes_kelte] [date] NOT NULL,
	[b_lejarat] [date] NOT NULL,
 CONSTRAINT [PK_BETETEK] PRIMARY KEY CLUSTERED 
(
	[bankszamlasz] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function [Betetinformacio](@b_fajta char(1))
returns table as 
return (select vnev+' '+knev AS 'Név', u.ugyfelazonosito
		from UGYFELEK u inner join BETETEK b
		on u.ugyfelazonosito=b.ugyfelazonosito
		where b_fajta=@b_fajta)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BANKKARTYAK](
	[bankkartya_szam] [char](19) NOT NULL,
	[ugyfelazonosito] [char](10) NOT NULL,
	[fedezet_biztositasa] [nvarchar](15) NOT NULL,
	[fokartya] [bit] NOT NULL,
	[eves_dij] [int] NOT NULL,
	[bk_lejarat] [date] NOT NULL,
	[CVV] [char](3) NOT NULL,
	[bk_tipus] [varchar](20) NOT NULL,
	[biztonsagielem] [nvarchar](25) NOT NULL,
	[technologia] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_BANKKARTYAK] PRIMARY KEY CLUSTERED 
(
	[bankkartya_szam] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BIZTOSITASOK](
	[biz_szerzodes_szam] [char](10) NOT NULL,
	[ugyfelazonosito] [char](10) NOT NULL,
	[dija] [int] NOT NULL,
	[biz_szerzodes_kelte] [date] NOT NULL,
	[biz_lejarat] [date] NOT NULL,
	[eletbiztositas-e] [bit] NOT NULL,
	[biz_targya] [nvarchar](20) NULL,
 CONSTRAINT [PK_BIZTOSITASOK] PRIMARY KEY CLUSTERED 
(
	[biz_szerzodes_szam] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ERTEKPAPIROK](
	[ertekpapirszam] [char](7) NOT NULL,
	[e_fajta] [nvarchar](20) NOT NULL,
	[ugyfelazonosito] [char](10) NOT NULL,
	[nevertek] [int] NOT NULL,
	[e_kibocsatas_napja] [date] NOT NULL,
	[e_hozam] [real] NOT NULL,
	[arfolyamertek] [real] NOT NULL,
	[hozam_gyakorisaga] [nvarchar](10) NOT NULL,
	[e_futamido] [nvarchar](10) NOT NULL,
	[e_lejarat] [date] NULL,
 CONSTRAINT [PK_ERTEKPAPIROK] PRIMARY KEY CLUSTERED 
(
	[ertekpapirszam] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HITELEK](
	[h_szerzodes_szam] [char](10) NOT NULL,
	[h_szerzodes_tipus] [nvarchar](10) NOT NULL,
	[ugyfelazonosito] [char](10) NOT NULL,
	[h_szerzodes_kelte] [date] NOT NULL,
	[h_kamat] [real] NOT NULL,
	[h_futamido] [nvarchar](10) NOT NULL,
	[felhasznalas] [nvarchar](31) NOT NULL,
	[h_osszege] [int] NOT NULL,
	[fedezetese] [bit] NOT NULL,
	[bankkartya_szam] [char](19) NULL,
	[h_lejarat] [date] NOT NULL,
 CONSTRAINT [PK_HITELEK] PRIMARY KEY CLUSTERED 
(
	[h_szerzodes_szam] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LIZINGEK](
	[l_szerzodes_szam] [char](10) NOT NULL,
	[ugyfelazonosito] [char](10) NOT NULL,
	[l_targya] [nvarchar](25) NOT NULL,
	[l_szerzodes_kelte] [date] NOT NULL,
	[torlesztoreszlet] [real] NOT NULL,
	[l_kamat] [real] NOT NULL,
	[l_lejarat] [date] NOT NULL,
 CONSTRAINT [PK_LIZINGEK] PRIMARY KEY CLUSTERED 
(
	[l_szerzodes_szam] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PENZFORGALOM](
	[bankszamlasz] [char](26) NOT NULL,
	[ugyfelazonosito] [char](10) NOT NULL,
	[terheles] [int] NULL,
	[jovairas] [int] NULL,
	[erteknap] [date] NOT NULL,
	[egyenleg] [real] NOT NULL,
	[ellenszamlasz] [char](26) NOT NULL,
	[ellenugyfelazonosito] [char](10) NOT NULL
) ON [PRIMARY]
GO
INSERT [BANKKARTYAK] ([bankkartya_szam], [ugyfelazonosito], [fedezet_biztositasa], [fokartya], [eves_dij], [bk_lejarat], [CVV], [bk_tipus], [biztonsagielem], [technologia]) VALUES (N'1203 5623 1458 0234', N'POZT456JDB', N'betéti kártya', 1, 5600, CAST(N'2023-05-10' AS Date), N'347', N'AMERICAN EXPRESS', N'mágnescsíkos és chipes', N'dombornyomott')
INSERT [BANKKARTYAK] ([bankkartya_szam], [ugyfelazonosito], [fedezet_biztositasa], [fokartya], [eves_dij], [bk_lejarat], [CVV], [bk_tipus], [biztonsagielem], [technologia]) VALUES (N'3467 1824 9455 1346', N'UTNZ472JDB', N'betéti kártya', 1, 4000, CAST(N'2024-01-04' AS Date), N'564', N'MASTERCARD', N'mágnescsíkos', N'lézergravírozott')
INSERT [BANKKARTYAK] ([bankkartya_szam], [ugyfelazonosito], [fedezet_biztositasa], [fokartya], [eves_dij], [bk_lejarat], [CVV], [bk_tipus], [biztonsagielem], [technologia]) VALUES (N'4549 2461 9542 4572', N'ADBN104JDB', N'hitelkártya', 1, 3700, CAST(N'2025-07-29' AS Date), N'454', N'MASTERCARD', N'mágnescsíkos', N'dombornyomott')
INSERT [BANKKARTYAK] ([bankkartya_szam], [ugyfelazonosito], [fedezet_biztositasa], [fokartya], [eves_dij], [bk_lejarat], [CVV], [bk_tipus], [biztonsagielem], [technologia]) VALUES (N'4561 0235 9835 0567', N'TUAN674JDB', N'betéti kártya', 0, 2500, CAST(N'2021-12-12' AS Date), N'768', N'VISA', N'chipes', N'lézergravírozott')
INSERT [BANKKARTYAK] ([bankkartya_szam], [ugyfelazonosito], [fedezet_biztositasa], [fokartya], [eves_dij], [bk_lejarat], [CVV], [bk_tipus], [biztonsagielem], [technologia]) VALUES (N'4567 3120 5634 1289', N'CDNZ856JDB', N'betéti kártya', 1, 5000, CAST(N'2028-04-10' AS Date), N'781', N'AMERICAN EXPRESS', N'mágnescsíkos és chipes', N'lézergravírozott')
INSERT [BANKKARTYAK] ([bankkartya_szam], [ugyfelazonosito], [fedezet_biztositasa], [fokartya], [eves_dij], [bk_lejarat], [CVV], [bk_tipus], [biztonsagielem], [technologia]) VALUES (N'6456 2345 5667 1962', N'XERM018JDB', N'betéti kártya', 0, 3000, CAST(N'2022-12-08' AS Date), N'244', N'VISA', N'chipes', N'vésett')
INSERT [BANKKARTYAK] ([bankkartya_szam], [ugyfelazonosito], [fedezet_biztositasa], [fokartya], [eves_dij], [bk_lejarat], [CVV], [bk_tipus], [biztonsagielem], [technologia]) VALUES (N'6789 1234 5678 1043', N'ASWQ456JDB', N'betéti kártya', 1, 3500, CAST(N'2025-06-21' AS Date), N'897', N'MASTERCARD', N'mágnescsíkos', N'dombornyomott')
INSERT [BANKKARTYAK] ([bankkartya_szam], [ugyfelazonosito], [fedezet_biztositasa], [fokartya], [eves_dij], [bk_lejarat], [CVV], [bk_tipus], [biztonsagielem], [technologia]) VALUES (N'6789 2345 1235 8765', N'ERTZ567JDB', N'betéti kártya', 1, 4000, CAST(N'2030-06-07' AS Date), N'912', N'VISA', N'chipes', N'vésett')
INSERT [BANKKARTYAK] ([bankkartya_szam], [ugyfelazonosito], [fedezet_biztositasa], [fokartya], [eves_dij], [bk_lejarat], [CVV], [bk_tipus], [biztonsagielem], [technologia]) VALUES (N'7544 7543 8652 5561', N'POZT456JDB', N'hitelkártya', 1, 4000, CAST(N'2022-09-10' AS Date), N'354', N'AMERICAN EXPRESS', N'mágnescsíkos és chipes', N'lézergravírozott')
INSERT [BANKKARTYAK] ([bankkartya_szam], [ugyfelazonosito], [fedezet_biztositasa], [fokartya], [eves_dij], [bk_lejarat], [CVV], [bk_tipus], [biztonsagielem], [technologia]) VALUES (N'7641 8642 6389 1034', N'XERM018JDB', N'hitelkártya', 1, 3500, CAST(N'2026-11-02' AS Date), N'752', N'VISA', N'chipes', N'lézergravírozott')
INSERT [BANKKARTYAK] ([bankkartya_szam], [ugyfelazonosito], [fedezet_biztositasa], [fokartya], [eves_dij], [bk_lejarat], [CVV], [bk_tipus], [biztonsagielem], [technologia]) VALUES (N'7891 3456 1278 0134', N'ADBN104JDB', N'betéti kártya', 1, 4000, CAST(N'2021-05-22' AS Date), N'567', N'VISA', N'chipes', N'vésett')
INSERT [BANKKARTYAK] ([bankkartya_szam], [ugyfelazonosito], [fedezet_biztositasa], [fokartya], [eves_dij], [bk_lejarat], [CVV], [bk_tipus], [biztonsagielem], [technologia]) VALUES (N'8548 3446 4758 4685', N'UZTQ334JDB', N'betéti kártya', 1, 5000, CAST(N'2025-05-30' AS Date), N'752', N'AMERICAN EXPRESS', N'mágnescsíkos és chipes', N'dombornyomott')
INSERT [BANKKARTYAK] ([bankkartya_szam], [ugyfelazonosito], [fedezet_biztositasa], [fokartya], [eves_dij], [bk_lejarat], [CVV], [bk_tipus], [biztonsagielem], [technologia]) VALUES (N'8967 1237 4589 0145', N'LERU321JDB', N'betéti kártya', 1, 4200, CAST(N'2022-10-12' AS Date), N'651', N'MASTERCARD', N'mágnescsíkos', N'dombornyomott')
GO
INSERT [BETETEK] ([bankszamlasz], [b_fajta], [ugyfelazonosito], [bankkartya_szam], [b_futamido], [b_kamat], [kamatozas_modja], [b_szerzodes_szam], [b_szerzodes_kelte], [b_lejarat]) VALUES (N'11460057-12045789-00000001', N'1', N'TUAN674JDB', N'4561 0235 9835 0567', N'rövid táv', 0.0034, N'fix kamatozású', N'RTN9543567', CAST(N'2019-01-15' AS Date), CAST(N'2025-01-04' AS Date))
INSERT [BETETEK] ([bankszamlasz], [b_fajta], [ugyfelazonosito], [bankkartya_szam], [b_futamido], [b_kamat], [kamatozas_modja], [b_szerzodes_szam], [b_szerzodes_kelte], [b_lejarat]) VALUES (N'11460057-12045789-00000004', N'4', N'TUAN674JDB', N'4561 0235 9835 0567', N'középtáv', 4.57, N'változó kamatozású', N'EWS1045679', CAST(N'2016-06-08' AS Date), CAST(N'2024-01-01' AS Date))
INSERT [BETETEK] ([bankszamlasz], [b_fajta], [ugyfelazonosito], [bankkartya_szam], [b_futamido], [b_kamat], [kamatozas_modja], [b_szerzodes_szam], [b_szerzodes_kelte], [b_lejarat]) VALUES (N'11460057-13475101-00000001', N'1', N'UZTQ334JDB', N'8548 3446 4758 4685', N'hosszú táv', 0.0005, N'változó kamatozású', N'ZTR1568456', CAST(N'2018-12-09' AS Date), CAST(N'2029-01-02' AS Date))
INSERT [BETETEK] ([bankszamlasz], [b_fajta], [ugyfelazonosito], [bankkartya_szam], [b_futamido], [b_kamat], [kamatozas_modja], [b_szerzodes_szam], [b_szerzodes_kelte], [b_lejarat]) VALUES (N'11460057-35681256-00000001', N'1', N'CDNZ856JDB', N'4567 3120 5634 1289', N'rövid táv', 0.011, N'fix kamatozású', N'SDE1578932', CAST(N'2018-12-12' AS Date), CAST(N'2045-11-04' AS Date))
INSERT [BETETEK] ([bankszamlasz], [b_fajta], [ugyfelazonosito], [bankkartya_szam], [b_futamido], [b_kamat], [kamatozas_modja], [b_szerzodes_szam], [b_szerzodes_kelte], [b_lejarat]) VALUES (N'11460057-35984567-00000001', N'1', N'POZT456JDB', N'7544 7543 8652 5561', N'hosszú táv', 0.023, N'változtatható kamatozású', N'ERT1023678', CAST(N'2019-04-10' AS Date), CAST(N'2029-03-07' AS Date))
INSERT [BETETEK] ([bankszamlasz], [b_fajta], [ugyfelazonosito], [bankkartya_szam], [b_futamido], [b_kamat], [kamatozas_modja], [b_szerzodes_szam], [b_szerzodes_kelte], [b_lejarat]) VALUES (N'11460057-45923401-00000001', N'1', N'UTNZ472JDB', N'3467 1824 9455 1346', N'középtáv', 0.001, N'változó kamatozású', N'DFT3012367', CAST(N'2019-03-05' AS Date), CAST(N'2026-07-08' AS Date))
INSERT [BETETEK] ([bankszamlasz], [b_fajta], [ugyfelazonosito], [bankkartya_szam], [b_futamido], [b_kamat], [kamatozas_modja], [b_szerzodes_szam], [b_szerzodes_kelte], [b_lejarat]) VALUES (N'11460057-47832156-00000001', N'1', N'ADBN104JDB', N'7891 3456 1278 0134', N'középtáv', 0.12, N'változó kamatozású', N'AND1583567', CAST(N'2020-02-28' AS Date), CAST(N'2024-02-28' AS Date))
INSERT [BETETEK] ([bankszamlasz], [b_fajta], [ugyfelazonosito], [bankkartya_szam], [b_futamido], [b_kamat], [kamatozas_modja], [b_szerzodes_szam], [b_szerzodes_kelte], [b_lejarat]) VALUES (N'11460057-47832156-00000002', N'2', N'ADBN104JDB', N'4549 2461 9542 4572', N'hosszú táv', 3.5, N'változtatható kamatozású', N'RTZ3678456', CAST(N'2018-10-30' AS Date), CAST(N'2028-10-06' AS Date))
INSERT [BETETEK] ([bankszamlasz], [b_fajta], [ugyfelazonosito], [bankkartya_szam], [b_futamido], [b_kamat], [kamatozas_modja], [b_szerzodes_szam], [b_szerzodes_kelte], [b_lejarat]) VALUES (N'11460057-55685316-00000001', N'1', N'ASWQ456JDB', N'6789 1234 5678 1043', N'hosszú táv', 0.003, N'változtatható kamatozású', N'ASW1395634', CAST(N'2019-10-10' AS Date), CAST(N'2030-12-10' AS Date))
INSERT [BETETEK] ([bankszamlasz], [b_fajta], [ugyfelazonosito], [bankkartya_szam], [b_futamido], [b_kamat], [kamatozas_modja], [b_szerzodes_szam], [b_szerzodes_kelte], [b_lejarat]) VALUES (N'11460057-55685316-00000002', N'2', N'ASWQ456JDB', N'6789 1234 5678 1043', N'hosszú táv', 2.37, N'változó kamatozású', N'OPR3210567', CAST(N'2019-11-20' AS Date), CAST(N'2029-11-02' AS Date))
INSERT [BETETEK] ([bankszamlasz], [b_fajta], [ugyfelazonosito], [bankkartya_szam], [b_futamido], [b_kamat], [kamatozas_modja], [b_szerzodes_szam], [b_szerzodes_kelte], [b_lejarat]) VALUES (N'11460057-73428102-00000001', N'1', N'LERU321JDB', N'8967 1237 4589 0145', N'középtáv', 0.0004, N'változtatható kamatozású', N'ASC1563478', CAST(N'2017-03-04' AS Date), CAST(N'2030-05-01' AS Date))
INSERT [BETETEK] ([bankszamlasz], [b_fajta], [ugyfelazonosito], [bankkartya_szam], [b_futamido], [b_kamat], [kamatozas_modja], [b_szerzodes_szam], [b_szerzodes_kelte], [b_lejarat]) VALUES (N'11460057-73561091-00000001', N'1', N'XERM018JDB', N'7641 8642 6389 1034', N'középtáv', 0.00035, N'változtatható kamatozású', N'UJF2654378', CAST(N'2017-08-10' AS Date), CAST(N'2027-07-09' AS Date))
INSERT [BETETEK] ([bankszamlasz], [b_fajta], [ugyfelazonosito], [bankkartya_szam], [b_futamido], [b_kamat], [kamatozas_modja], [b_szerzodes_szam], [b_szerzodes_kelte], [b_lejarat]) VALUES (N'11460057-73561091-00000003', N'3', N'XERM018JDB', N'7641 8642 6389 1034', N'középtáv', 2.12, N'változó kamatozású', N'VNB1256789', CAST(N'2018-12-17' AS Date), CAST(N'2026-02-01' AS Date))
INSERT [BETETEK] ([bankszamlasz], [b_fajta], [ugyfelazonosito], [bankkartya_szam], [b_futamido], [b_kamat], [kamatozas_modja], [b_szerzodes_szam], [b_szerzodes_kelte], [b_lejarat]) VALUES (N'11460057-94623764-00000001', N'1', N'ERTZ567JDB', N'6789 2345 1235 8765', N'középtáv', 0.002, N'változó kamatozású', N'QRE1456789', CAST(N'2016-06-12' AS Date), CAST(N'2030-02-01' AS Date))
INSERT [BETETEK] ([bankszamlasz], [b_fajta], [ugyfelazonosito], [bankkartya_szam], [b_futamido], [b_kamat], [kamatozas_modja], [b_szerzodes_szam], [b_szerzodes_kelte], [b_lejarat]) VALUES (N'11460057-94623764-00000003', N'3', N'ERTZ567JDB', N'6789 2345 1235 8765', N'középtáv', 3.1, N'változó kamatozású', N'EYM4892103', CAST(N'2017-08-09' AS Date), CAST(N'2027-08-09' AS Date))
GO
INSERT [BIZTOSITASOK] ([biz_szerzodes_szam], [ugyfelazonosito], [dija], [biz_szerzodes_kelte], [biz_lejarat], [eletbiztositas-e], [biz_targya]) VALUES (N'ACV1678543', N'ADBN104JDB', 19000, CAST(N'2020-10-02' AS Date), CAST(N'2025-10-02' AS Date), 0, N'ingatlan')
INSERT [BIZTOSITASOK] ([biz_szerzodes_szam], [ugyfelazonosito], [dija], [biz_szerzodes_kelte], [biz_lejarat], [eletbiztositas-e], [biz_targya]) VALUES (N'FHT7569871', N'ASWQ456JDB', 20000, CAST(N'2020-12-05' AS Date), CAST(N'2022-12-05' AS Date), 1, NULL)
INSERT [BIZTOSITASOK] ([biz_szerzodes_szam], [ugyfelazonosito], [dija], [biz_szerzodes_kelte], [biz_lejarat], [eletbiztositas-e], [biz_targya]) VALUES (N'KLO1245671', N'UTNZ472JDB', 19000, CAST(N'2020-09-09' AS Date), CAST(N'2023-09-09' AS Date), 0, N'ingatlan')
INSERT [BIZTOSITASOK] ([biz_szerzodes_szam], [ugyfelazonosito], [dija], [biz_szerzodes_kelte], [biz_lejarat], [eletbiztositas-e], [biz_targya]) VALUES (N'PLE3765890', N'UZTQ334JDB', 19600, CAST(N'2019-10-10' AS Date), CAST(N'2023-10-10' AS Date), 0, N'műérték')
INSERT [BIZTOSITASOK] ([biz_szerzodes_szam], [ugyfelazonosito], [dija], [biz_szerzodes_kelte], [biz_lejarat], [eletbiztositas-e], [biz_targya]) VALUES (N'RTZ8567934', N'ASWQ456JDB', 21000, CAST(N'2021-01-10' AS Date), CAST(N'2026-01-10' AS Date), 0, N'ingatlan')
INSERT [BIZTOSITASOK] ([biz_szerzodes_szam], [ugyfelazonosito], [dija], [biz_szerzodes_kelte], [biz_lejarat], [eletbiztositas-e], [biz_targya]) VALUES (N'SFG1034567', N'ADBN104JDB', 20500, CAST(N'2020-11-11' AS Date), CAST(N'2024-11-11' AS Date), 0, N'gépjármű')
INSERT [BIZTOSITASOK] ([biz_szerzodes_szam], [ugyfelazonosito], [dija], [biz_szerzodes_kelte], [biz_lejarat], [eletbiztositas-e], [biz_targya]) VALUES (N'TZU7653987', N'ASWQ456JDB', 21000, CAST(N'2021-02-20' AS Date), CAST(N'2025-02-20' AS Date), 0, N'gépjármű')
INSERT [BIZTOSITASOK] ([biz_szerzodes_szam], [ugyfelazonosito], [dija], [biz_szerzodes_kelte], [biz_lejarat], [eletbiztositas-e], [biz_targya]) VALUES (N'UBK1567834', N'XERM018JDB', 19000, CAST(N'2020-02-28' AS Date), CAST(N'2024-02-28' AS Date), 1, NULL)
INSERT [BIZTOSITASOK] ([biz_szerzodes_szam], [ugyfelazonosito], [dija], [biz_szerzodes_kelte], [biz_lejarat], [eletbiztositas-e], [biz_targya]) VALUES (N'VCF1378943', N'XERM018JDB', 22000, CAST(N'2021-01-30' AS Date), CAST(N'2025-01-30' AS Date), 0, N'gépjármű')
INSERT [BIZTOSITASOK] ([biz_szerzodes_szam], [ugyfelazonosito], [dija], [biz_szerzodes_kelte], [biz_lejarat], [eletbiztositas-e], [biz_targya]) VALUES (N'ZUJ1267892', N'UZTQ334JDB', 20000, CAST(N'2020-02-15' AS Date), CAST(N'2025-02-15' AS Date), 1, NULL)
GO
INSERT [ERTEKPAPIROK] ([ertekpapirszam], [e_fajta], [ugyfelazonosito], [nevertek], [e_kibocsatas_napja], [e_hozam], [arfolyamertek], [hozam_gyakorisaga], [e_futamido], [e_lejarat]) VALUES (N'1457894', N'kötvény', N'ERTZ567JDB', 50000, CAST(N'2020-12-12' AS Date), 2000, 50000, N'havi', N'rövid táv', CAST(N'2021-11-01' AS Date))
INSERT [ERTEKPAPIROK] ([ertekpapirszam], [e_fajta], [ugyfelazonosito], [nevertek], [e_kibocsatas_napja], [e_hozam], [arfolyamertek], [hozam_gyakorisaga], [e_futamido], [e_lejarat]) VALUES (N'3578921', N'részvény', N'POZT456JDB', 7000, CAST(N'2020-05-06' AS Date), 2000, 7000, N'éves', N'hosszú táv', NULL)
INSERT [ERTEKPAPIROK] ([ertekpapirszam], [e_fajta], [ugyfelazonosito], [nevertek], [e_kibocsatas_napja], [e_hozam], [arfolyamertek], [hozam_gyakorisaga], [e_futamido], [e_lejarat]) VALUES (N'4567321', N'kötvény', N'CDNZ856JDB', 70000, CAST(N'2020-09-09' AS Date), 5000, 70000, N'féléves', N'középtáv', CAST(N'2024-09-09' AS Date))
INSERT [ERTEKPAPIROK] ([ertekpapirszam], [e_fajta], [ugyfelazonosito], [nevertek], [e_kibocsatas_napja], [e_hozam], [arfolyamertek], [hozam_gyakorisaga], [e_futamido], [e_lejarat]) VALUES (N'5637321', N'részvény', N'XERM018JDB', 7000, CAST(N'2020-03-30' AS Date), 3500, 7000, N'éves', N'hosszú táv', NULL)
INSERT [ERTEKPAPIROK] ([ertekpapirszam], [e_fajta], [ugyfelazonosito], [nevertek], [e_kibocsatas_napja], [e_hozam], [arfolyamertek], [hozam_gyakorisaga], [e_futamido], [e_lejarat]) VALUES (N'5768123', N'állampapír', N'UZTQ334JDB', 100000, CAST(N'2021-02-10' AS Date), 10000, 100000, N'féléves', N'középtáv', CAST(N'2026-02-10' AS Date))
INSERT [ERTEKPAPIROK] ([ertekpapirszam], [e_fajta], [ugyfelazonosito], [nevertek], [e_kibocsatas_napja], [e_hozam], [arfolyamertek], [hozam_gyakorisaga], [e_futamido], [e_lejarat]) VALUES (N'7569232', N'részvény', N'ASWQ456JDB', 8000, CAST(N'2020-10-10' AS Date), 2500, 8000, N'éves', N'hosszú táv', NULL)
INSERT [ERTEKPAPIROK] ([ertekpapirszam], [e_fajta], [ugyfelazonosito], [nevertek], [e_kibocsatas_napja], [e_hozam], [arfolyamertek], [hozam_gyakorisaga], [e_futamido], [e_lejarat]) VALUES (N'7821456', N'kötvény', N'XERM018JDB', 65000, CAST(N'2021-01-30' AS Date), 6000, 65000, N'havi', N'középtáv', CAST(N'2025-01-30' AS Date))
INSERT [ERTEKPAPIROK] ([ertekpapirszam], [e_fajta], [ugyfelazonosito], [nevertek], [e_kibocsatas_napja], [e_hozam], [arfolyamertek], [hozam_gyakorisaga], [e_futamido], [e_lejarat]) VALUES (N'7891234', N'állampapír', N'LERU321JDB', 80000, CAST(N'2021-08-08' AS Date), 4000, 80000, N'éves', N'középtáv', CAST(N'2025-08-08' AS Date))
INSERT [ERTEKPAPIROK] ([ertekpapirszam], [e_fajta], [ugyfelazonosito], [nevertek], [e_kibocsatas_napja], [e_hozam], [arfolyamertek], [hozam_gyakorisaga], [e_futamido], [e_lejarat]) VALUES (N'8967234', N'állampapír', N'ASWQ456JDB', 200000, CAST(N'2021-07-07' AS Date), 6000, 200000, N'éves', N'hosszú táv', CAST(N'2028-07-07' AS Date))
INSERT [ERTEKPAPIROK] ([ertekpapirszam], [e_fajta], [ugyfelazonosito], [nevertek], [e_kibocsatas_napja], [e_hozam], [arfolyamertek], [hozam_gyakorisaga], [e_futamido], [e_lejarat]) VALUES (N'9745123', N'kötvény', N'ASWQ456JDB', 40000, CAST(N'2021-02-02' AS Date), 4000, 40000, N'havi', N'középtáv', CAST(N'2025-02-02' AS Date))
GO
INSERT [HITELEK] ([h_szerzodes_szam], [h_szerzodes_tipus], [ugyfelazonosito], [h_szerzodes_kelte], [h_kamat], [h_futamido], [felhasznalas], [h_osszege], [fedezetese], [bankkartya_szam], [h_lejarat]) VALUES (N'AZP1765986', N'kölcsön', N'ERTZ567JDB', CAST(N'2021-02-01' AS Date), 3, N'középtáv', N'beruházási és fejlesztési hitel', 5000000, 0, NULL, CAST(N'2024-02-01' AS Date))
INSERT [HITELEK] ([h_szerzodes_szam], [h_szerzodes_tipus], [ugyfelazonosito], [h_szerzodes_kelte], [h_kamat], [h_futamido], [felhasznalas], [h_osszege], [fedezetese], [bankkartya_szam], [h_lejarat]) VALUES (N'JBN8674592', N'hitel', N'TUAN674JDB', CAST(N'2021-03-26' AS Date), 3, N'középtáv', N'beruházási és fejlesztési hitel', 1000000, 0, NULL, CAST(N'2025-03-26' AS Date))
INSERT [HITELEK] ([h_szerzodes_szam], [h_szerzodes_tipus], [ugyfelazonosito], [h_szerzodes_kelte], [h_kamat], [h_futamido], [felhasznalas], [h_osszege], [fedezetese], [bankkartya_szam], [h_lejarat]) VALUES (N'RTL1246954', N'kölcsön', N'ASWQ456JDB', CAST(N'2021-01-02' AS Date), 3, N'rövid táv', N'forgóeszközhitel', 1000000, 0, NULL, CAST(N'2021-12-02' AS Date))
INSERT [HITELEK] ([h_szerzodes_szam], [h_szerzodes_tipus], [ugyfelazonosito], [h_szerzodes_kelte], [h_kamat], [h_futamido], [felhasznalas], [h_osszege], [fedezetese], [bankkartya_szam], [h_lejarat]) VALUES (N'RTZ1568456', N'kölcsön', N'XERM018JDB', CAST(N'2021-02-10' AS Date), 4, N'hosszú táv', N'beruházási és fejlesztési hitel', 8000000, 0, N'7641 8642 6389 1034', CAST(N'2029-02-10' AS Date))
INSERT [HITELEK] ([h_szerzodes_szam], [h_szerzodes_tipus], [ugyfelazonosito], [h_szerzodes_kelte], [h_kamat], [h_futamido], [felhasznalas], [h_osszege], [fedezetese], [bankkartya_szam], [h_lejarat]) VALUES (N'SAL1236875', N'hitel', N'ADBN104JDB', CAST(N'2020-06-07' AS Date), 3, N'középtáv', N'beruházási és fejlesztési hitel', 5500000, 0, N'4549 2461 9542 4572', CAST(N'2025-06-07' AS Date))
INSERT [HITELEK] ([h_szerzodes_szam], [h_szerzodes_tipus], [ugyfelazonosito], [h_szerzodes_kelte], [h_kamat], [h_futamido], [felhasznalas], [h_osszege], [fedezetese], [bankkartya_szam], [h_lejarat]) VALUES (N'SRT1763452', N'hitel', N'LERU321JDB', CAST(N'2020-04-04' AS Date), 4, N'hosszú táv', N'beruházási és fejlesztési hitel', 9000000, 1, NULL, CAST(N'2030-04-04' AS Date))
INSERT [HITELEK] ([h_szerzodes_szam], [h_szerzodes_tipus], [ugyfelazonosito], [h_szerzodes_kelte], [h_kamat], [h_futamido], [felhasznalas], [h_osszege], [fedezetese], [bankkartya_szam], [h_lejarat]) VALUES (N'UZL1357864', N'hitel', N'CDNZ856JDB', CAST(N'2020-10-10' AS Date), 3, N'hosszú táv', N'beruházási és fejlesztési hitel', 7500000, 1, NULL, CAST(N'2028-10-10' AS Date))
INSERT [HITELEK] ([h_szerzodes_szam], [h_szerzodes_tipus], [ugyfelazonosito], [h_szerzodes_kelte], [h_kamat], [h_futamido], [felhasznalas], [h_osszege], [fedezetese], [bankkartya_szam], [h_lejarat]) VALUES (N'ZUL3478934', N'hitel', N'POZT456JDB', CAST(N'2021-07-07' AS Date), 3, N'hosszú táv', N'beruházási és fejlesztési hitel', 11000000, 1, N'7544 7543 8652 5561', CAST(N'2030-07-07' AS Date))
GO
INSERT [LIZINGEK] ([l_szerzodes_szam], [ugyfelazonosito], [l_targya], [l_szerzodes_kelte], [torlesztoreszlet], [l_kamat], [l_lejarat]) VALUES (N'ABD3789432', N'POZT456JDB', N'gépjármű', CAST(N'2018-03-03' AS Date), 16000, 1.4, CAST(N'2021-03-03' AS Date))
INSERT [LIZINGEK] ([l_szerzodes_szam], [ugyfelazonosito], [l_targya], [l_szerzodes_kelte], [torlesztoreszlet], [l_kamat], [l_lejarat]) VALUES (N'CXN2167834', N'LERU321JDB', N'gépjármű', CAST(N'2020-07-07' AS Date), 28000, 1.6, CAST(N'2024-07-07' AS Date))
INSERT [LIZINGEK] ([l_szerzodes_szam], [ugyfelazonosito], [l_targya], [l_szerzodes_kelte], [torlesztoreszlet], [l_kamat], [l_lejarat]) VALUES (N'GHT1678345', N'LERU321JDB', N'egyéb vagyontárgy', CAST(N'2020-01-05' AS Date), 30000, 1.2, CAST(N'2028-01-05' AS Date))
INSERT [LIZINGEK] ([l_szerzodes_szam], [ugyfelazonosito], [l_targya], [l_szerzodes_kelte], [torlesztoreszlet], [l_kamat], [l_lejarat]) VALUES (N'HFE4789103', N'CDNZ856JDB', N'ingatlan', CAST(N'2021-01-04' AS Date), 25000, 1.13, CAST(N'2035-01-05' AS Date))
INSERT [LIZINGEK] ([l_szerzodes_szam], [ugyfelazonosito], [l_targya], [l_szerzodes_kelte], [torlesztoreszlet], [l_kamat], [l_lejarat]) VALUES (N'KBT1654378', N'TUAN674JDB', N'gépjármű', CAST(N'2020-01-30' AS Date), 22000, 1.45, CAST(N'2026-01-30' AS Date))
INSERT [LIZINGEK] ([l_szerzodes_szam], [ugyfelazonosito], [l_targya], [l_szerzodes_kelte], [torlesztoreszlet], [l_kamat], [l_lejarat]) VALUES (N'ORT5783451', N'ASWQ456JDB', N'gépjármű', CAST(N'2020-10-30' AS Date), 27500, 1.89, CAST(N'2027-10-30' AS Date))
INSERT [LIZINGEK] ([l_szerzodes_szam], [ugyfelazonosito], [l_targya], [l_szerzodes_kelte], [torlesztoreszlet], [l_kamat], [l_lejarat]) VALUES (N'POA4789123', N'XERM018JDB', N'gépjármű', CAST(N'2020-08-12' AS Date), 26000, 2.34, CAST(N'2028-08-12' AS Date))
INSERT [LIZINGEK] ([l_szerzodes_szam], [ugyfelazonosito], [l_targya], [l_szerzodes_kelte], [torlesztoreszlet], [l_kamat], [l_lejarat]) VALUES (N'RAS2567812', N'ADBN104JDB', N'egyéb vagyontárgy', CAST(N'2020-01-20' AS Date), 20000, 3.1, CAST(N'2026-01-20' AS Date))
INSERT [LIZINGEK] ([l_szerzodes_szam], [ugyfelazonosito], [l_targya], [l_szerzodes_kelte], [torlesztoreszlet], [l_kamat], [l_lejarat]) VALUES (N'TZL2357892', N'UZTQ334JDB', N'egyéb vagyontárgy', CAST(N'2020-09-09' AS Date), 27000, 1.78, CAST(N'2028-09-09' AS Date))
INSERT [LIZINGEK] ([l_szerzodes_szam], [ugyfelazonosito], [l_targya], [l_szerzodes_kelte], [torlesztoreszlet], [l_kamat], [l_lejarat]) VALUES (N'UIL2456789', N'UTNZ472JDB', N'gépjármű', CAST(N'2020-11-11' AS Date), 31000, 1.65, CAST(N'2025-11-11' AS Date))
INSERT [LIZINGEK] ([l_szerzodes_szam], [ugyfelazonosito], [l_targya], [l_szerzodes_kelte], [torlesztoreszlet], [l_kamat], [l_lejarat]) VALUES (N'ZRT6834569', N'ADBN104JDB', N'gépjármű', CAST(N'2021-02-20' AS Date), 15000, 1.5, CAST(N'2025-02-20' AS Date))
GO
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-12045789-00000001', N'TUAN674JDB', 5650, NULL, CAST(N'2021-02-01' AS Date), 851071, N'11460057-45923401-00000001', N'UTNZ472JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-12045789-00000004', N'TUAN674JDB', NULL, 330000, CAST(N'2020-10-11' AS Date), 330000, N'11460057-12045789-00000001', N'TUAN674JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-13475101-00000001', N'UZTQ334JDB', 356543, NULL, CAST(N'2020-09-10' AS Date), 8839122, N'11460057-73561091-00000001', N'XERM018JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-35681256-00000001', N'CDNZ856JDB', 66000, NULL, CAST(N'2020-12-04' AS Date), 4563456, N'11460057-94623764-00000001', N'ERTZ567JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-35984567-00000001', N'POZT456JDB', 86300, NULL, CAST(N'2020-11-24' AS Date), 67543, N'11460057-12045789-00000001', N'TUAN674JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-45923401-00000001', N'UTNZ472JDB', 356530, NULL, CAST(N'2020-08-09' AS Date), 3779180, N'11460057-13475101-00000001', N'UZTQ334JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-47832156-00000001', N'ADBN104JDB', 80000, NULL, CAST(N'2020-12-06' AS Date), 446567, N'11460057-55685316-00000001', N'ASWQ456JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-47832156-00000002', N'ADBN104JDB', NULL, 100000, CAST(N'2020-12-01' AS Date), 100000, N'11460057-47832156-00000001', N'ADBN104JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-55685316-00000001', N'ASWQ456JDB', 50000, NULL, CAST(N'2021-02-22' AS Date), 108184.352, N'11460057-85259567-00000001', N'CDNZ856JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-55685316-00000002', N'ASWQ456JDB', NULL, 5000000, CAST(N'2021-01-04' AS Date), 5000000, N'11460057-55685316-00000001', N'ASWQ456JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-73428102-00000001', N'LERU321JDB', 5670, NULL, CAST(N'2021-01-10' AS Date), 245321, N'11460057-35984567-00000001', N'POZT456JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-73561091-00000001', N'XERM018JDB', 10110, NULL, CAST(N'2021-01-11' AS Date), 654740, N'11460057-10359867-00000001', N'ADBN104JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-73561091-00000003', N'XERM018JDB', NULL, 150000, CAST(N'2019-01-20' AS Date), 150000, N'11460057-73561091-00000001', N'XERM018JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-94623764-00000001', N'ERTZ567JDB', 2020, NULL, CAST(N'2021-01-28' AS Date), 452804.125, N'11460057-73428102-00000001', N'LERU321JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-94623764-00000003', N'ERTZ567JDB', NULL, 420000, CAST(N'2021-01-10' AS Date), 420000, N'11460057-94623764-00000001', N'ERTZ567JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-45923401-00000001', N'UTNZ472JDB', NULL, 5650, CAST(N'2021-02-01' AS Date), 341681.469, N'11460057-45923401-00000001', N'TUAN674JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-73561091-00000001', N'XERM018JDB', NULL, 356543, CAST(N'2020-09-10' AS Date), 223344, N'11460057-13475101-00000001', N'UZTQ334JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-94623764-00000001', N'ERTZ567JDB', NULL, 66000, CAST(N'2020-12-04' AS Date), 435455, N'11460057-35681256-00000001', N'CDNZ856JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-12045789-00000001', N'TUAN674JDB', NULL, 86300, CAST(N'2020-11-24' AS Date), 3434533, N'11460057-35984567-00000001', N'POZT456JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-13475101-00000001', N'UZTQ334JDB', NULL, 356530, CAST(N'2020-08-09' AS Date), 6532113, N'11460057-45923401-00000001', N'UTNZ472JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-55685316-00000001', N'ASWQ456JDB', NULL, 80000, CAST(N'2020-12-06' AS Date), 365657, N'11460057-47832156-00000001', N'ADBN104JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-47832156-00000001', N'ADBN104JDB', 100000, NULL, CAST(N'2020-12-01' AS Date), 546607, N'11460057-47832156-00000002', N'ADBN104JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-47832156-00000001', N'ADBN104JDB', 5000, NULL, CAST(N'2021-03-03' AS Date), 753323.7, N'15840000-27654965-10246000', N'RTKL302OTP')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-73561091-00000001', N'XERM018JDB', 4000, NULL, CAST(N'2021-03-02' AS Date), 661032.3, N'10800000-87634620-10000000', N'PGBM567CIB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-73561091-00000001', N'XERM018JDB', NULL, 70000, CAST(N'2021-02-03' AS Date), 468876, N'14567321-01234567-98765432', N'IBMA345OTP')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-35681256-00000001', N'CDNZ856JDB', 4000, NULL, CAST(N'2020-03-04' AS Date), 344674, N'16894567-12456782-01234598', N'KLMZ342CIB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-35984567-00000001', N'POZT456JDB', NULL, 5670, CAST(N'2021-01-10' AS Date), 563494.5, N'11460057-73428102-00000001', N'LERU321JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-47832156-00000001', N'ADBN104JDB', NULL, 10110, CAST(N'2021-01-11' AS Date), 46786, N'11460057-73561091-00000001', N'XERM018JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-73561091-00000001', N'XERM018JDB', 150000, NULL, CAST(N'2019-01-20' AS Date), 3246773, N'11460057-73561091-00000003', N'XERM018JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-73428102-00000001', N'LERU321JDB', NULL, 2020, CAST(N'2021-01-28' AS Date), 2452593.75, N'11460057-94623764-00000001', N'ERTZ567JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-94623764-00000001', N'ERTZ567JDB', 420000, NULL, CAST(N'2021-01-10' AS Date), 976543, N'11460057-94623764-00000003', N'ERTZ567JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-35681256-00000001', N'CDNZ856JDB', NULL, 50000, CAST(N'2021-02-22' AS Date), 2351114.25, N'11460057-55685316-00000001', N'ASWQ456JDB')
INSERT [PENZFORGALOM] ([bankszamlasz], [ugyfelazonosito], [terheles], [jovairas], [erteknap], [egyenleg], [ellenszamlasz], [ellenugyfelazonosito]) VALUES (N'11460057-55685316-00000001', N'ASWQ456JDB', 5000000, NULL, CAST(N'2021-01-04' AS Date), 500000, N'11460057-55685316-00000002', N'ASWQ456JDB')
GO
INSERT [UGYFELEK] ([ugyfelazonosito], [vnev], [knev], [anyja_neve], [szul_hely], [szul_ido], [nem], [telepules], [iranyitoszam], [utca + hsz], [mobilsz], [email], [szemigszam], [adoszam], [allampolgarsag], [munkaviszony_jelleg], [jovedelem_forrasa]) VALUES (N'ADBN104JDB', N'Varga', N'József', N'Kiss Mária', N'Pécs', CAST(N'1973-08-16' AS Date), N'férfi', N'Pécs', N'7600', N'Kossuth utca 42.', N'+36204567789', N'jozsef@gmail.com', N'246895BA', N'1235624179', N'magyar', N'vállalkozó', N'egyéb')
INSERT [UGYFELEK] ([ugyfelazonosito], [vnev], [knev], [anyja_neve], [szul_hely], [szul_ido], [nem], [telepules], [iranyitoszam], [utca + hsz], [mobilsz], [email], [szemigszam], [adoszam], [allampolgarsag], [munkaviszony_jelleg], [jovedelem_forrasa]) VALUES (N'ASWQ456JDB', N'Nagy', N'Rebeka', N'Fitos Kitti', N'Tapolca', CAST(N'1978-01-04' AS Date), N'nő', N'Tapolca', N'8300', N'József Attila utca 12.', N'+36708653416', N'nagyr@gmail.com', N'894657OB', N'1468362398', N'magyar', N'munkavállaló', N'munkabér')
INSERT [UGYFELEK] ([ugyfelazonosito], [vnev], [knev], [anyja_neve], [szul_hely], [szul_ido], [nem], [telepules], [iranyitoszam], [utca + hsz], [mobilsz], [email], [szemigszam], [adoszam], [allampolgarsag], [munkaviszony_jelleg], [jovedelem_forrasa]) VALUES (N'CDNZ856JDB', N'Kiss', N'Nikolett', N'Szabó Erzsébet', N'Győr', CAST(N'1990-04-02' AS Date), N'nő', N'Győr', N'9000', N'Baross Gábor utca 6.', N'+36708395512', N'kissniki@gmail.com', N'573491TA', N'2357961728', N'magyar', N'munkavállaló', N'munkabér')
INSERT [UGYFELEK] ([ugyfelazonosito], [vnev], [knev], [anyja_neve], [szul_hely], [szul_ido], [nem], [telepules], [iranyitoszam], [utca + hsz], [mobilsz], [email], [szemigszam], [adoszam], [allampolgarsag], [munkaviszony_jelleg], [jovedelem_forrasa]) VALUES (N'ERTZ567JDB', N'Pozvai', N'Barnabás', N'Ambrus Cintia', N'Székesfehérvár', CAST(N'1977-06-21' AS Date), N'férfi', N'Székesfehérvár', N'8000', N'Budai út 12.', N'+36703215507', N'barnip@gmail.com', N'563190UT', N'9856234510', N'magyar', N'munkavállaló', N'munkabér')
INSERT [UGYFELEK] ([ugyfelazonosito], [vnev], [knev], [anyja_neve], [szul_hely], [szul_ido], [nem], [telepules], [iranyitoszam], [utca + hsz], [mobilsz], [email], [szemigszam], [adoszam], [allampolgarsag], [munkaviszony_jelleg], [jovedelem_forrasa]) VALUES (N'LERU321JDB', N'Dadai', N'Viktória', N'Bicsák Petra', N'Nagykanizsa', CAST(N'1957-04-30' AS Date), N'nő', N'Nagykanizsa', N'8800', N'Vár út 44.', N'+36301235568', N'vikid@gmail.com', N'567890CV', N'1765893452', N'magyar', N'nyugdíjas', N'nyugdíj')
INSERT [UGYFELEK] ([ugyfelazonosito], [vnev], [knev], [anyja_neve], [szul_hely], [szul_ido], [nem], [telepules], [iranyitoszam], [utca + hsz], [mobilsz], [email], [szemigszam], [adoszam], [allampolgarsag], [munkaviszony_jelleg], [jovedelem_forrasa]) VALUES (N'POZT456JDB', N'Tóth', N'Benedek', N'Nagy Anna', N'Sopron', CAST(N'1982-03-05' AS Date), N'férfi', N'Sopron', N'9400', N'Papucsvirág utca 21.', N'+36708453301', N'tothbeni@gmail.com', N'789345CD', N'3791943673', N'magyar', N'munkavállaló', N'munkabér')
INSERT [UGYFELEK] ([ugyfelazonosito], [vnev], [knev], [anyja_neve], [szul_hely], [szul_ido], [nem], [telepules], [iranyitoszam], [utca + hsz], [mobilsz], [email], [szemigszam], [adoszam], [allampolgarsag], [munkaviszony_jelleg], [jovedelem_forrasa]) VALUES (N'TUAN674JDB', N'Németh', N'Zsófia', N'Réti Mariann', N'Zalaegerszeg', CAST(N'2000-12-21' AS Date), N'nő', N'Zalaegerszeg', N'8900', N'Mártírok útja 8.', N'+36305729832', N'nzsofi@gmail.com', N'913476AN', N'6712394758', N'magyar', N'diák', N'szülők')
INSERT [UGYFELEK] ([ugyfelazonosito], [vnev], [knev], [anyja_neve], [szul_hely], [szul_ido], [nem], [telepules], [iranyitoszam], [utca + hsz], [mobilsz], [email], [szemigszam], [adoszam], [allampolgarsag], [munkaviszony_jelleg], [jovedelem_forrasa]) VALUES (N'UTNZ472JDB', N'Baksa', N'Áron', N'Janzsó Daniella', N'Keszthely', CAST(N'1976-12-08' AS Date), N'férfi', N'Keszthely', N'8360', N'Toldi Miklós utca 32.', N'+36205601398', N'baksaaron@gmail.com', N'785460PE', N'5634781977', N'magyar', N'munkavállaló', N'munkabér')
INSERT [UGYFELEK] ([ugyfelazonosito], [vnev], [knev], [anyja_neve], [szul_hely], [szul_ido], [nem], [telepules], [iranyitoszam], [utca + hsz], [mobilsz], [email], [szemigszam], [adoszam], [allampolgarsag], [munkaviszony_jelleg], [jovedelem_forrasa]) VALUES (N'UZTQ334JDB', N'Szabó', N'Róbert', N'Péntek Vivien', N'Tatabánya', CAST(N'1994-05-06' AS Date), N'férfi', N'Tatabánya', N'2800', N'Köztársaság útja 6.', N'+36305738802', N'szrobi@gmail.com', N'856734RA', N'1275981097', N'magyar', N'munkavállaló', N'munkabér')
INSERT [UGYFELEK] ([ugyfelazonosito], [vnev], [knev], [anyja_neve], [szul_hely], [szul_ido], [nem], [telepules], [iranyitoszam], [utca + hsz], [mobilsz], [email], [szemigszam], [adoszam], [allampolgarsag], [munkaviszony_jelleg], [jovedelem_forrasa]) VALUES (N'XERM018JDB', N'Horváth', N'Dániel', N'Széll Dominika', N'Dunaújváros', CAST(N'1986-12-11' AS Date), N'férfi', N'Budapest', N'1014', N'Kálmán Imre utca 80.', N'+36201239845', N'horvdani@gmail.com', N'910235VE', N'4513089352', N'magyar', N'munkavállaló', N'munkabér')
GO
ALTER TABLE [BETETEK]  WITH CHECK ADD  CONSTRAINT [FK_BETETEK_BANKKARTYAK_BANKKARTYA_SZAM] FOREIGN KEY([bankkartya_szam])
REFERENCES [BANKKARTYAK] ([bankkartya_szam])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [BETETEK] CHECK CONSTRAINT [FK_BETETEK_BANKKARTYAK_BANKKARTYA_SZAM]
GO
ALTER TABLE [BETETEK]  WITH CHECK ADD  CONSTRAINT [FK_BETETEK_UGYFELEK_UGYFELAZONOSITO] FOREIGN KEY([ugyfelazonosito])
REFERENCES [UGYFELEK] ([ugyfelazonosito])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [BETETEK] CHECK CONSTRAINT [FK_BETETEK_UGYFELEK_UGYFELAZONOSITO]
GO
ALTER TABLE [BIZTOSITASOK]  WITH CHECK ADD  CONSTRAINT [FK_BIZTOSITASOK_UGYFELEK_UGYFELAZONOSITO] FOREIGN KEY([ugyfelazonosito])
REFERENCES [UGYFELEK] ([ugyfelazonosito])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [BIZTOSITASOK] CHECK CONSTRAINT [FK_BIZTOSITASOK_UGYFELEK_UGYFELAZONOSITO]
GO
ALTER TABLE [ERTEKPAPIROK]  WITH CHECK ADD  CONSTRAINT [FK_ERTEKPAPIROK_UGYFELEK_UGYFELAZONOSITO] FOREIGN KEY([ugyfelazonosito])
REFERENCES [UGYFELEK] ([ugyfelazonosito])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ERTEKPAPIROK] CHECK CONSTRAINT [FK_ERTEKPAPIROK_UGYFELEK_UGYFELAZONOSITO]
GO
ALTER TABLE [HITELEK]  WITH CHECK ADD  CONSTRAINT [FK_HITELEK_UGYFELEK_UGYFELAZONOSITO] FOREIGN KEY([ugyfelazonosito])
REFERENCES [UGYFELEK] ([ugyfelazonosito])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [HITELEK] CHECK CONSTRAINT [FK_HITELEK_UGYFELEK_UGYFELAZONOSITO]
GO
ALTER TABLE [LIZINGEK]  WITH CHECK ADD  CONSTRAINT [FK_LIZINGEK_UGYFELEK_UGYFELAZONOSITO] FOREIGN KEY([ugyfelazonosito])
REFERENCES [UGYFELEK] ([ugyfelazonosito])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [LIZINGEK] CHECK CONSTRAINT [FK_LIZINGEK_UGYFELEK_UGYFELAZONOSITO]
GO
ALTER TABLE [PENZFORGALOM]  WITH CHECK ADD  CONSTRAINT [FK_PENZFORGALOM_BETETEK] FOREIGN KEY([bankszamlasz])
REFERENCES [BETETEK] ([bankszamlasz])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [PENZFORGALOM] CHECK CONSTRAINT [FK_PENZFORGALOM_BETETEK]
GO
ALTER TABLE [BANKKARTYAK]  WITH CHECK ADD  CONSTRAINT [CK_BANKKARTYAK_BANKKARTYA_SZAM] CHECK  (([BANKKARTYA_SZAM] like '[1-9][0-9][0-9][0-9][ ][0-9][0-9][0-9][0-9][ ][0-9][0-9][0-9][0-9][ ][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [BANKKARTYAK] CHECK CONSTRAINT [CK_BANKKARTYAK_BANKKARTYA_SZAM]
GO
ALTER TABLE [BANKKARTYAK]  WITH CHECK ADD  CONSTRAINT [CK_BANKKARTYAK_BIZTONSAGIELEM] CHECK  (([BIZTONSAGIELEM]='mágnescsíkos' OR [BIZTONSAGIELEM]='chipes' OR [BIZTONSAGIELEM]='mágnescsíkos és chipes'))
GO
ALTER TABLE [BANKKARTYAK] CHECK CONSTRAINT [CK_BANKKARTYAK_BIZTONSAGIELEM]
GO
ALTER TABLE [BANKKARTYAK]  WITH CHECK ADD  CONSTRAINT [CK_BANKKARTYAK_BK_TIPUS] CHECK  (([BK_TIPUS]='VISA' OR [BK_TIPUS]='MASTERCARD' OR [BK_TIPUS]='AMERICAN EXPRESS'))
GO
ALTER TABLE [BANKKARTYAK] CHECK CONSTRAINT [CK_BANKKARTYAK_BK_TIPUS]
GO
ALTER TABLE [BANKKARTYAK]  WITH CHECK ADD  CONSTRAINT [CK_BANKKARTYAK_CVV] CHECK  (([CVV] like '[0-9][0-9][0-9]'))
GO
ALTER TABLE [BANKKARTYAK] CHECK CONSTRAINT [CK_BANKKARTYAK_CVV]
GO
ALTER TABLE [BANKKARTYAK]  WITH CHECK ADD  CONSTRAINT [CK_BANKKARTYAK_FEDEZET_BIZTOSITASA] CHECK  (([FEDEZET_BIZTOSITASA]='hitelkártya' OR [FEDEZET_BIZTOSITASA]='betéti kártya'))
GO
ALTER TABLE [BANKKARTYAK] CHECK CONSTRAINT [CK_BANKKARTYAK_FEDEZET_BIZTOSITASA]
GO
ALTER TABLE [BANKKARTYAK]  WITH CHECK ADD  CONSTRAINT [CK_BANKKARTYAK_TECHNOLOGIA] CHECK  (([TECHNOLOGIA]='lézergravírozott' OR [TECHNOLOGIA]='vésett' OR [TECHNOLOGIA]='dombornyomott'))
GO
ALTER TABLE [BANKKARTYAK] CHECK CONSTRAINT [CK_BANKKARTYAK_TECHNOLOGIA]
GO
ALTER TABLE [BETETEK]  WITH CHECK ADD  CONSTRAINT [CK_BETETEK_B_FAJTA] CHECK  (([B_FAJTA]='4' OR [B_FAJTA]='3' OR [B_FAJTA]='2' OR [B_FAJTA]='1'))
GO
ALTER TABLE [BETETEK] CHECK CONSTRAINT [CK_BETETEK_B_FAJTA]
GO
ALTER TABLE [BETETEK]  WITH CHECK ADD  CONSTRAINT [CK_BETETEK_B_FUTAMIDO] CHECK  (([B_FUTAMIDO]='hosszú táv' OR [B_FUTAMIDO]='középtáv' OR [B_FUTAMIDO]='rövid táv'))
GO
ALTER TABLE [BETETEK] CHECK CONSTRAINT [CK_BETETEK_B_FUTAMIDO]
GO
ALTER TABLE [BETETEK]  WITH CHECK ADD  CONSTRAINT [CK_BETETEK_B_LEJARAT] CHECK  (([B_LEJARAT]>[B_SZERZODES_KELTE]))
GO
ALTER TABLE [BETETEK] CHECK CONSTRAINT [CK_BETETEK_B_LEJARAT]
GO
ALTER TABLE [BETETEK]  WITH CHECK ADD  CONSTRAINT [CK_BETETEK_B_SZERZODES_KELTE] CHECK  (([B_SZERZODES_KELTE]<=getdate()))
GO
ALTER TABLE [BETETEK] CHECK CONSTRAINT [CK_BETETEK_B_SZERZODES_KELTE]
GO
ALTER TABLE [BETETEK]  WITH CHECK ADD  CONSTRAINT [CK_BETETEK_B_SZERZODES_SZAM] CHECK  (([B_SZERZODES_SZAM] like '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [BETETEK] CHECK CONSTRAINT [CK_BETETEK_B_SZERZODES_SZAM]
GO
ALTER TABLE [BETETEK]  WITH CHECK ADD  CONSTRAINT [CK_BETETEK_BANKSZAMLASZ] CHECK  (([BANKSZAMLASZ] like '[1][1][4][6][0][0][5][7][-][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][-][0][0][0][0][0][0][0][1234]'))
GO
ALTER TABLE [BETETEK] CHECK CONSTRAINT [CK_BETETEK_BANKSZAMLASZ]
GO
ALTER TABLE [BETETEK]  WITH CHECK ADD  CONSTRAINT [CK_BETETEK_KAMATOZAS_MODJA] CHECK  (([KAMATOZAS_MODJA]='változtatható kamatozású' OR [KAMATOZAS_MODJA]='változó kamatozású' OR [KAMATOZAS_MODJA]='fix kamatozású'))
GO
ALTER TABLE [BETETEK] CHECK CONSTRAINT [CK_BETETEK_KAMATOZAS_MODJA]
GO
ALTER TABLE [BIZTOSITASOK]  WITH CHECK ADD  CONSTRAINT [CK_BIZTOSITASOK_BIZ_LEJARAT] CHECK  (([BIZ_LEJARAT]>[BIZ_SZERZODES_KELTE]))
GO
ALTER TABLE [BIZTOSITASOK] CHECK CONSTRAINT [CK_BIZTOSITASOK_BIZ_LEJARAT]
GO
ALTER TABLE [BIZTOSITASOK]  WITH CHECK ADD  CONSTRAINT [CK_BIZTOSITASOK_BIZ_SZERZODES_KELTE] CHECK  (([BIZ_SZERZODES_KELTE]<=getdate()))
GO
ALTER TABLE [BIZTOSITASOK] CHECK CONSTRAINT [CK_BIZTOSITASOK_BIZ_SZERZODES_KELTE]
GO
ALTER TABLE [BIZTOSITASOK]  WITH CHECK ADD  CONSTRAINT [CK_BIZTOSITASOK_BIZ_SZERZODES_SZAM] CHECK  (([BIZ_SZERZODES_SZAM] like '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [BIZTOSITASOK] CHECK CONSTRAINT [CK_BIZTOSITASOK_BIZ_SZERZODES_SZAM]
GO
ALTER TABLE [BIZTOSITASOK]  WITH CHECK ADD  CONSTRAINT [CK_BIZTOSITASOK_BIZ_TARGYA] CHECK  (([BIZ_TARGYA]='egyéb vagyontárgy' OR [BIZ_TARGYA]='műérték' OR [BIZ_TARGYA]='gépjármű' OR [BIZ_TARGYA]='ingatlan'))
GO
ALTER TABLE [BIZTOSITASOK] CHECK CONSTRAINT [CK_BIZTOSITASOK_BIZ_TARGYA]
GO
ALTER TABLE [ERTEKPAPIROK]  WITH CHECK ADD  CONSTRAINT [CK_ERTEKPAPIROK_E_FAJTA] CHECK  (([E_FAJTA]='kötvény' OR [E_FAJTA]='részvény' OR [E_FAJTA]='állampapír'))
GO
ALTER TABLE [ERTEKPAPIROK] CHECK CONSTRAINT [CK_ERTEKPAPIROK_E_FAJTA]
GO
ALTER TABLE [ERTEKPAPIROK]  WITH CHECK ADD  CONSTRAINT [CK_ERTEKPAPIROK_E_FUTAMIDO] CHECK  (([E_FUTAMIDO]='hosszú táv' OR [E_FUTAMIDO]='középtáv' OR [E_FUTAMIDO]='rövid táv'))
GO
ALTER TABLE [ERTEKPAPIROK] CHECK CONSTRAINT [CK_ERTEKPAPIROK_E_FUTAMIDO]
GO
ALTER TABLE [ERTEKPAPIROK]  WITH CHECK ADD  CONSTRAINT [CK_ERTEKPAPIROK_E_LEJARAT] CHECK  (([E_LEJARAT]>[E_KIBOCSATAS_NAPJA]))
GO
ALTER TABLE [ERTEKPAPIROK] CHECK CONSTRAINT [CK_ERTEKPAPIROK_E_LEJARAT]
GO
ALTER TABLE [ERTEKPAPIROK]  WITH CHECK ADD  CONSTRAINT [CK_ERTEKPAPIROK_ERTEKPAPIRSZAM] CHECK  (([ERTEKPAPIRSZAM] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [ERTEKPAPIROK] CHECK CONSTRAINT [CK_ERTEKPAPIROK_ERTEKPAPIRSZAM]
GO
ALTER TABLE [ERTEKPAPIROK]  WITH CHECK ADD  CONSTRAINT [CK_ERTEKPAPIROK_HOZAM_GYAKORISAGA] CHECK  (([HOZAM_GYAKORISAGA]='havi' OR [HOZAM_GYAKORISAGA]='féléves' OR [HOZAM_GYAKORISAGA]='éves'))
GO
ALTER TABLE [ERTEKPAPIROK] CHECK CONSTRAINT [CK_ERTEKPAPIROK_HOZAM_GYAKORISAGA]
GO
ALTER TABLE [HITELEK]  WITH CHECK ADD  CONSTRAINT [CK_HITELEK_FELHASZNALAS] CHECK  (([FELHASZNALAS]='forgóeszközhitel' OR [FELHASZNALAS]='beruházási és fejlesztési hitel'))
GO
ALTER TABLE [HITELEK] CHECK CONSTRAINT [CK_HITELEK_FELHASZNALAS]
GO
ALTER TABLE [HITELEK]  WITH CHECK ADD  CONSTRAINT [CK_HITELEK_H_FUTAMIDO] CHECK  (([H_FUTAMIDO]='hosszú táv' OR [H_FUTAMIDO]='középtáv' OR [H_FUTAMIDO]='rövid táv'))
GO
ALTER TABLE [HITELEK] CHECK CONSTRAINT [CK_HITELEK_H_FUTAMIDO]
GO
ALTER TABLE [HITELEK]  WITH CHECK ADD  CONSTRAINT [CK_HITELEK_H_LEJARAT] CHECK  (([H_LEJARAT]>[H_SZERZODES_KELTE]))
GO
ALTER TABLE [HITELEK] CHECK CONSTRAINT [CK_HITELEK_H_LEJARAT]
GO
ALTER TABLE [HITELEK]  WITH CHECK ADD  CONSTRAINT [CK_HITELEK_H_SZERZODES_SZAM] CHECK  (([H_SZERZODES_SZAM] like '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [HITELEK] CHECK CONSTRAINT [CK_HITELEK_H_SZERZODES_SZAM]
GO
ALTER TABLE [HITELEK]  WITH CHECK ADD  CONSTRAINT [CK_HITELEK_H_SZERZODES_TIPUS] CHECK  (([H_SZERZODES_TIPUS]='kölcsön' OR [H_SZERZODES_TIPUS]='hitel'))
GO
ALTER TABLE [HITELEK] CHECK CONSTRAINT [CK_HITELEK_H_SZERZODES_TIPUS]
GO
ALTER TABLE [LIZINGEK]  WITH CHECK ADD  CONSTRAINT [CK_LIZINGEK_L_LEJARAT] CHECK  (([L_LEJARAT]>[L_SZERZODES_KELTE]))
GO
ALTER TABLE [LIZINGEK] CHECK CONSTRAINT [CK_LIZINGEK_L_LEJARAT]
GO
ALTER TABLE [LIZINGEK]  WITH CHECK ADD  CONSTRAINT [CK_LIZINGEK_L_SZERZODES_KELTE] CHECK  (([L_SZERZODES_KELTE]<=getdate()))
GO
ALTER TABLE [LIZINGEK] CHECK CONSTRAINT [CK_LIZINGEK_L_SZERZODES_KELTE]
GO
ALTER TABLE [LIZINGEK]  WITH CHECK ADD  CONSTRAINT [CK_LIZINGEK_L_SZERZODES_SZAM] CHECK  (([L_SZERZODES_SZAM] like '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [LIZINGEK] CHECK CONSTRAINT [CK_LIZINGEK_L_SZERZODES_SZAM]
GO
ALTER TABLE [LIZINGEK]  WITH CHECK ADD  CONSTRAINT [CK_LIZINGEK_L_TARGYA] CHECK  (([L_TARGYA]='egyéb vagyontárgy' OR [L_TARGYA]='gépjármű' OR [L_TARGYA]='ingatlan'))
GO
ALTER TABLE [LIZINGEK] CHECK CONSTRAINT [CK_LIZINGEK_L_TARGYA]
GO
ALTER TABLE [PENZFORGALOM]  WITH CHECK ADD  CONSTRAINT [CK_PENZFORGALOM_BANKSZAMLASZ] CHECK  (([BANKSZAMLASZ] like '[1][1][4][6][0][0][5][7][-][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][-][0][0][0][0][0][0][0][1234]'))
GO
ALTER TABLE [PENZFORGALOM] CHECK CONSTRAINT [CK_PENZFORGALOM_BANKSZAMLASZ]
GO
ALTER TABLE [PENZFORGALOM]  WITH CHECK ADD  CONSTRAINT [CK_PENZFORGALOM_ELLENSZAMLASZ] CHECK  (([ELLENSZAMLASZ] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [PENZFORGALOM] CHECK CONSTRAINT [CK_PENZFORGALOM_ELLENSZAMLASZ]
GO
ALTER TABLE [PENZFORGALOM]  WITH CHECK ADD  CONSTRAINT [CK_PENZFORGALOM_ELLENUGYFELAZONOSITO] CHECK  (([ELLENUGYFELAZONOSITO] like '[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][A-Z][A-Z][A-Z]'))
GO
ALTER TABLE [PENZFORGALOM] CHECK CONSTRAINT [CK_PENZFORGALOM_ELLENUGYFELAZONOSITO]
GO
ALTER TABLE [PENZFORGALOM]  WITH CHECK ADD  CONSTRAINT [CK_PENZFORGALOM_UGYFELAZONOSITO] CHECK  (([UGYFELAZONOSITO] like '[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][J][D][B]'))
GO
ALTER TABLE [PENZFORGALOM] CHECK CONSTRAINT [CK_PENZFORGALOM_UGYFELAZONOSITO]
GO
ALTER TABLE [UGYFELEK]  WITH CHECK ADD  CONSTRAINT [CK_UGYFELEK_ADOSZAM] CHECK  (([ADOSZAM] like '[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [UGYFELEK] CHECK CONSTRAINT [CK_UGYFELEK_ADOSZAM]
GO
ALTER TABLE [UGYFELEK]  WITH CHECK ADD  CONSTRAINT [CK_UGYFELEK_IRANYITOSZAM] CHECK  ((CONVERT([smallint],[IRANYITOSZAM])>=(1011)))
GO
ALTER TABLE [UGYFELEK] CHECK CONSTRAINT [CK_UGYFELEK_IRANYITOSZAM]
GO
ALTER TABLE [UGYFELEK]  WITH CHECK ADD  CONSTRAINT [CK_UGYFELEK_JOVEDELEM_FORRASA] CHECK  (([JOVEDELEM_FORRASA]='szülők' OR [JOVEDELEM_FORRASA]='munkabér' OR [JOVEDELEM_FORRASA]='segély' OR [JOVEDELEM_FORRASA]='nyugdíj' OR [JOVEDELEM_FORRASA]='egyéb'))
GO
ALTER TABLE [UGYFELEK] CHECK CONSTRAINT [CK_UGYFELEK_JOVEDELEM_FORRASA]
GO
ALTER TABLE [UGYFELEK]  WITH CHECK ADD  CONSTRAINT [CK_UGYFELEK_MOBILSZ] CHECK  (([MOBILSZ] like '[+][3][6][237][0][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [UGYFELEK] CHECK CONSTRAINT [CK_UGYFELEK_MOBILSZ]
GO
ALTER TABLE [UGYFELEK]  WITH CHECK ADD  CONSTRAINT [CK_UGYFELEK_MUNKAVISZONY_JELLEG] CHECK  (([MUNKAVISZONY_JELLEG]='diák' OR [MUNKAVISZONY_JELLEG]='munkavállaló' OR [MUNKAVISZONY_JELLEG]='vállalkozó' OR [MUNKAVISZONY_JELLEG]='munkanélküli' OR [MUNKAVISZONY_JELLEG]='háztartásbeli' OR [MUNKAVISZONY_JELLEG]='nyugdíjas' OR [MUNKAVISZONY_JELLEG]='egyéb'))
GO
ALTER TABLE [UGYFELEK] CHECK CONSTRAINT [CK_UGYFELEK_MUNKAVISZONY_JELLEG]
GO
ALTER TABLE [UGYFELEK]  WITH CHECK ADD  CONSTRAINT [CK_UGYFELEK_NEM] CHECK  (([NEM]='férfi' OR [NEM]='nő'))
GO
ALTER TABLE [UGYFELEK] CHECK CONSTRAINT [CK_UGYFELEK_NEM]
GO
ALTER TABLE [UGYFELEK]  WITH CHECK ADD  CONSTRAINT [CK_UGYFELEK_SZEMIGSZAM] CHECK  (([SZEMIGSZAM] like '[1-9][0-9][0-9][0-9][0-9][0-9][A-Z][A-Z]'))
GO
ALTER TABLE [UGYFELEK] CHECK CONSTRAINT [CK_UGYFELEK_SZEMIGSZAM]
GO
ALTER TABLE [UGYFELEK]  WITH CHECK ADD  CONSTRAINT [CK_UGYFELEK_SZUL_IDO] CHECK  ((datediff(year,[SZUL_IDO],getdate())>=(14)))
GO
ALTER TABLE [UGYFELEK] CHECK CONSTRAINT [CK_UGYFELEK_SZUL_IDO]
GO
ALTER TABLE [UGYFELEK]  WITH CHECK ADD  CONSTRAINT [CK_UGYFELEK_UGYFELAZONOSITO] CHECK  (([UGYFELAZONOSITO] like '[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][J][D][B]'))
GO
ALTER TABLE [UGYFELEK] CHECK CONSTRAINT [CK_UGYFELEK_UGYFELAZONOSITO]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [Biz_dij_emeles]
AS
while (select AVG(Cast(dija as float)) AS 'Átlagos biztosítási díj'
		from BIZTOSITASOK)<20000
BEGIN 
Update BIZTOSITASOK
set dija=dija+1000
from BIZTOSITASOK
where biz_targya='gépjármű'
END
Print 'Kész'
Exec Biz_dij_emeles
select * from BIZTOSITASOK
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [BK_eves_dij_levonas]
AS
BEGIN 
Update PENZFORGALOM 
set egyenleg=egyenleg-eves_dij
from PENZFORGALOM p, BETETEK b, BANKKARTYAK bk
where p.bankszamlasz=b.bankszamlasz and b.bankkartya_szam=bk.bankkartya_szam and b_fajta='1' 
and erteknap=(Select Max(erteknap) 
from penzforgalom p2
where p2.ugyfelazonosito=p.ugyfelazonosito and p2.bankszamlasz=b.bankszamlasz)
END
Print 'Kész'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [Hitel_insert]
@h_szerzodes_szam char(10), @h_szerzodes_tipus nvarchar(10), @ugyfelazonosito char(10), @h_szerzodes_kelte date, @h_kamat real, 
@h_futamido nvarchar(10), @felhasznalas nvarchar(31), @h_osszege int, @fedezetese bit, @bankkartya_szam char(19), @h_lejarat date,
@visszater int
OUTPUT 
AS
IF EXISTS (Select h_szerzodes_szam from HITELEK where h_szerzodes_szam=@h_szerzodes_szam)
SET @visszater=-1
ELSE
BEGIN
Insert into HITELEK values (@h_szerzodes_szam, @h_szerzodes_tipus, @ugyfelazonosito, 
@h_szerzodes_kelte, @h_kamat, @h_futamido, @felhasznalas, @h_osszege, 
@fedezetese, @bankkartya_szam, @h_lejarat)
SET @visszater=0
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [Kamatjovairas]
AS
BEGIN 
Update PENZFORGALOM 
set egyenleg=egyenleg+(egyenleg*(b_kamat/100))
from PENZFORGALOM p inner join BETETEK b
on p.bankszamlasz=b.bankszamlasz 
where b_fajta='1' and erteknap=(Select Max(erteknap) 
from penzforgalom p2
where p2.ugyfelazonosito=p.ugyfelazonosito and p2.bankszamlasz=b.bankszamlasz)
END
Print 'Kész'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [L_szerzodes_hosszabbit]
AS
BEGIN 
Update lizingek
set l_lejarat=DATEADD(mm,6,l_lejarat)
from LIZINGEK
where l_targya='egyéb vagyontárgy'
END
Print 'Kész'
GO
USE [master]
GO
ALTER DATABASE [JDB Bank] SET  READ_WRITE 
GO
