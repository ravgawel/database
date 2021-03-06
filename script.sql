USE [master]
GO
/****** Object:  Database [makson_a]    Script Date: 25/01/2019 12:19:41 ******/
CREATE DATABASE [makson_a]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'makson_a', FILENAME = N'/var/opt/mssql/data/makson_a.mdf' , SIZE = 10240KB , MAXSIZE = 30720KB , FILEGROWTH = 2048KB )
 LOG ON 
( NAME = N'makson_a_log', FILENAME = N'/var/opt/mssql/data/makson_a.ldf' , SIZE = 12288KB , MAXSIZE = 30720KB , FILEGROWTH = 2048KB )
GO
ALTER DATABASE [makson_a] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [makson_a].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [makson_a] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [makson_a] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [makson_a] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [makson_a] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [makson_a] SET ARITHABORT OFF 
GO
ALTER DATABASE [makson_a] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [makson_a] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [makson_a] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [makson_a] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [makson_a] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [makson_a] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [makson_a] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [makson_a] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [makson_a] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [makson_a] SET  ENABLE_BROKER 
GO
ALTER DATABASE [makson_a] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [makson_a] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [makson_a] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [makson_a] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [makson_a] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [makson_a] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [makson_a] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [makson_a] SET RECOVERY FULL 
GO
ALTER DATABASE [makson_a] SET  MULTI_USER 
GO
ALTER DATABASE [makson_a] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [makson_a] SET DB_CHAINING OFF 
GO
ALTER DATABASE [makson_a] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [makson_a] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [makson_a] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'makson_a', N'ON'
GO
ALTER DATABASE [makson_a] SET QUERY_STORE = OFF
GO
USE [makson_a]
GO
/****** Object:  Schema [LabyZeSchematu]    Script Date: 25/01/2019 12:19:42 ******/
CREATE SCHEMA [LabyZeSchematu]
GO
/****** Object:  UserDefinedFunction [dbo].[F_ConfMaxParticipants]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_ConfMaxParticipants]
(
@conferenceID int
)
RETURNS int
AS
	BEGIN
	RETURN(ISNULL(0,(SELECT MaxParticipants FROM Conferences WHERE ConferenceID = @conferenceID)))
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_CountTakenPlacesInReservartionDay]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_CountTakenPlacesInReservartionDay]
(
@ReservationDayID int
)
RETURNS int
AS
BEGIN
RETURN ISNULL((SELECT SUM(NumberOfParticipants)
FROM ReservationDay
Where ReservationDayID = @ReservationDayID), 0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[F_CountTakenPlacesInWokrshop]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[F_CountTakenPlacesInWokrshop]
(
@WorkshopReservationsID int
)
RETURNS int
AS
BEGIN
RETURN ISNULL((SELECT SUM(NumberOfParticipants)
FROM WorkshopReservations
Where WorkshopReservations.WorkshopReservationID = @WorkshopReservationsID), 0)
END

GO
/****** Object:  UserDefinedFunction [dbo].[F_GetConfDayFreeSlots]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_GetConfDayFreeSlots]
(
@conferenceDayID int
)
RETURNS int
AS
BEGIN
RETURN ((SELECT Conferences.MaxParticipants FROM Conferences
INNER JOIN ConferenceDay on Conferences.ConferenceID = ConferenceDay.ConferenceDayID)
-(SELECT SUM(ReservationDay.NumberOfParticipants) FROM ReservationDay INNER JOIN ConferenceDay ON ReservationDay.ConferenceDayID = ConferenceDay.ConferenceDayID))
END
GO
/****** Object:  UserDefinedFunction [dbo].[F_GetConferenceEndDate]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_GetConferenceEndDate]
(
@ConferenceID int
)
RETURNS date
AS
BEGIN
RETURN(SELECT Conferences.EndDate
FROM Conferences
WHERE Conferences.ConferenceID = @ConferenceID)
END


GO
/****** Object:  UserDefinedFunction [dbo].[F_GetConferenceID]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_GetConferenceID]
(
@ConferenceDayID int
)
RETURNS int
AS
BEGIN
RETURN(SELECT ConferenceID
FROM ConferenceDay
WHERE ConferenceDayID = @ConferenceDayID)
END
GO
/****** Object:  UserDefinedFunction [dbo].[F_GetConferenceStartDate]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_GetConferenceStartDate]
(
@ConferenceID int
)
RETURNS date
AS
BEGIN
RETURN(SELECT Conferences.StartDate
FROM Conferences
WHERE Conferences.ConferenceID = @ConferenceID)
END


GO
/****** Object:  UserDefinedFunction [dbo].[F_GetDayID]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_GetDayID]
(
@conferenceID int,
@date date
)
RETURNS int
AS
BEGIN
RETURN (Select ConferenceDayID
From ConferenceDay
WHERE ConferenceID = @conferenceID AND Date = @date)
END
GO
/****** Object:  UserDefinedFunction [dbo].[F_GetDiscount]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_GetDiscount]
(
@ConferenceID int,
@ReservationDate date
)
RETURNS real
AS
BEGIN
	RETURN(
	SELECT ISNULL(MAX(Discount), 0) FROM Discount as d inner join Conferences as c on c.conferenceid = d.conferenceid
	WHERE c.startdate >= DATEADD(Day, d.daysbeforestart, @reservationdate))
END
GO
/****** Object:  UserDefinedFunction [dbo].[F_GetReservationCost]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_GetReservationCost]
(
@ReservationID int
)
returns money
AS
BEGIN


DECLARE @cenanormalna MONEY = dbo.F_GetReservDayNormalTicketPrice(@ReservationID)


DECLARE @znizkastudencka real =
(SELECT C.DiscountForStudents
FROM Reservations as R
JOIN ReservationDay as Rday ON R.reservationID = Rday.reservationid
JOIN ConferenceDay as Cday ON Cday.conferenceDayID = Rday.conferenceDayID
JOIN Conferences as C ON C.ConferenceID = Cday.ConferenceID
WHERE R.ReservationID = @ReservationID)



DECLARE @kosztrezerwacji MONEY =
(Select 
sum(ReservationDay.NumberOfParticipants  * @cenanormalna) +
Sum(ReservationDay.NumberOfStudents) * @cenanormalna * (1 - @znizkastudencka)
From ReservationDay WHERE ReservationDay.ReservationID = @ReservationID)

DECLARE @kosztwarsztatu MONEY =
(Select SUM(val)
From (Select (Select SUM(WorkshopReservations.NumberOfParticipants * Workshop.Price) +
SUM(WorkshopReservations.NumberOfStudents * (1 - @znizkastudencka) * Workshop.Price)
FROM WorkshopReservations
INNER JOIN Workshop
ON Workshop.WorkSHOPID = WorkshopReservations.WorkshopID
WHERE WorkshopReservations.ReservationDayID = ReservationDay.ReservationDayID) as val
FROM ReservationDay WHERE ReservationDay.ReservationID = @ReservationID) src)

RETURN (ISNULL(@kosztrezerwacji, 0) + ISNULL(@kosztwarsztatu, 0))
END
GO
/****** Object:  UserDefinedFunction [dbo].[F_NumberOfStudentsForEachDay]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_NumberOfStudentsForEachDay]
(
@ReservationDayID int
)
RETURNS smallint
AS
BEGIN
	RETURN(
	SELECT COUNT(*) FROM Students as s inner join Participants as p on p.ParticipantID = s.ParticipantID
	WHERE p.DayReservationID = @ReservationDayID)
END
GO
/****** Object:  UserDefinedFunction [dbo].[F_ReservDayNormal]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_ReservDayNormal]
(
@DayReservationID int
)
RETURNS int
AS
	BEGIN
	RETURN ISNULL(
	(SELECT NumberOfParticipants
	FROM ReservationDay
		WHERE ReservationDayID = @DayReservationID)
	- (SELECT NumberOfStudents
	FROM ReservationDay
		WHERE ReservationDayID = @DayReservationID), 0)
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_ReservDayNormalTicketPrice]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_ReservDayNormalTicketPrice]
(
@ReservationID int
)
RETURNS MONEY
AS
BEGIN
	DECLARE @cena MONEY = 
(SELECT C.DayPrice * (1 - dbo.F_GetDiscount(C.ConferenceID, R.ReservationDate))
FROM Reservations as R
JOIN ReservationDay as Rday ON R.reservationID = Rday.reservationid
JOIN ConferenceDay as Cday ON Cday.conferenceDayID = Rday.conferenceDayID
JOIN Conferences as C ON C.ConferenceID = Cday.ConferenceID
WHERE R.ReservationID = @ReservationID)

RETURN isnull (@cena,0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[F_ReservDayParticipants]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_ReservDayParticipants]
(
@DayReservationID int
)
RETURNS int
AS
	BEGIN
	RETURN ISNULL((SELECT NumberOfParticipants
	FROM ReservationDay
		WHERE ReservationDayID = @DayReservationID), 0)
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_ReservDayStudent]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_ReservDayStudent]
(
@DayReservationID int
)
RETURNS int
AS
	BEGIN
	RETURN ISNULL((SELECT NumberOfStudents
	FROM ReservationDay
		WHERE ReservationDayID = @DayReservationID), 0)
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_WorkshopSlots]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_WorkshopSlots]
(
@WorkshopID int
)
RETURNS int
AS
	BEGIN
	RETURN ISNULL((SELECT LimitOfParticipants FROM Workshop WHERE WorkshopID = @WorkshopID),0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[F_WorkshopSlotsTaken]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_WorkshopSlotsTaken]
(
@WorkshopID int
)
RETURNS int
AS
	BEGIN
	RETURN ISNULL((SELECT NumberOfParticipants FROM WorkshopReservations WHERE WorkshopID = @WorkshopID),0)
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_WorkshopSlotsTakenByNotStudents]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_WorkshopSlotsTakenByNotStudents]
(
@WorkshopID int
)
RETURNS int
AS
	BEGIN
	RETURN ISNULL((SELECT NumberOfParticipants - NumberOfStudents FROM WorkshopReservations WHERE WorkshopID = @WorkshopID),0)
	END
GO
/****** Object:  UserDefinedFunction [dbo].[F_WorkshopSlotsTakenByStudents]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_WorkshopSlotsTakenByStudents]
(
@WorkshopID int
)
RETURNS int
AS
	BEGIN
	RETURN ISNULL((SELECT NumberOfStudents FROM WorkshopReservations WHERE WorkshopID = @WorkshopID),0)
	END
GO
/****** Object:  Table [dbo].[Conferences]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Conferences](
	[ConferenceID] [int] IDENTITY(1,1) NOT NULL,
	[ConferenceName] [varchar](50) NOT NULL,
	[DiscountForStudents] [real] NOT NULL,
	[DayPrice] [money] NOT NULL,
	[MaxParticipants] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
 CONSTRAINT [PK_Conferences] PRIMARY KEY CLUSTERED 
(
	[ConferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConferenceDay]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConferenceDay](
	[ConferenceDayID] [int] IDENTITY(1,1) NOT NULL,
	[ConferenceID] [int] NOT NULL,
	[Date] [date] NOT NULL,
 CONSTRAINT [PK_ConferenceDay] PRIMARY KEY CLUSTERED 
(
	[ConferenceDayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReservationDay]    Script Date: 25/01/2019 12:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReservationDay](
	[ReservationDayID] [int] IDENTITY(1,1) NOT NULL,
	[ConferenceDayID] [int] NOT NULL,
	[ReservationID] [int] NOT NULL,
	[NumberOfParticipants] [smallint] NOT NULL,
	[NumberOfStudents] [smallint] NOT NULL,
 CONSTRAINT [PK_ReservationDay] PRIMARY KEY CLUSTERED 
(
	[ReservationDayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Participants]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Participants](
	[ParticipantID] [int] IDENTITY(1,1) NOT NULL,
	[ReservationDayID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
 CONSTRAINT [PK_Participantss] PRIMARY KEY CLUSTERED 
(
	[ParticipantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[PersonID] [int] IDENTITY(10000,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewListOfParticipants]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[viewListOfParticipants]
AS
	SELECT DISTINCT ConferenceDay.ConferenceDayID, Conferences.ConferenceName, ConferenceDay.Date, 
	Person.FirstName + ' ' + Person.LastName AS 'Name'
	FROM ConferenceDay
	JOIN Conferences ON Conferences.ConferenceID=ConferenceDay.ConferenceID
	JOIN ReservationDay ON ReservationDay.ConferenceDayID=ConferenceDay.ConferenceDayID
	JOIN Participants ON Participants.ReservationDayID=ReservationDay.ReservationDayID
	JOIN Person ON Person.PersonID=Participants.PersonID
GO
/****** Object:  Table [dbo].[Reservations]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservations](
	[ReservationID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[ReservationDate] [date] NOT NULL,
	[PaymentDate] [date] NULL,
	[isCancelled] [bit] NOT NULL,
 CONSTRAINT [PK_Reservations] PRIMARY KEY CLUSTERED 
(
	[ReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewCancelledConferences]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[viewCancelledConferences]
as
SELECT Conferences.ConferenceID, Conferences.ConferenceName, Conferences.StartDate, Conferences.EndDate
FROM Conferences
inner join ConferenceDay ON ConferenceDay.ConferenceID=Conferences.ConferenceID
inner join ReservationDay ON ConferenceDay.ConferenceDayID=ReservationDay.ConferenceDayID
inner join Reservations ON Reservations.ReservationID=ReservationDay.ReservationID
where Reservations.isCancelled=1;
GO
/****** Object:  Table [dbo].[Students]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students](
	[ParticipantID] [int] NOT NULL,
	[ReservationDayID] [int] NOT NULL,
	[StudentCard] [nchar](10) NOT NULL,
 CONSTRAINT [PK_Students] PRIMARY KEY CLUSTERED 
(
	[ParticipantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewListOfStudentCards]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewListOfStudentCards]
AS
select distinct ConferenceDay.ConferenceDayID, Conferences.ConferenceName, ConferenceDay.Date, Students.StudentCard
from ConferenceDay
inner join Conferences on Conferences.ConferenceID=ConferenceDay.ConferenceID
inner join ReservationDay on ReservationDay.ConferenceDayID=ConferenceDay.ConferenceDayID
inner join Participants on Participants.ReservationDayID=ReservationDay.ReservationDayID
inner join Students on Participants.ParticipantID=Students.ParticipantID
GO
/****** Object:  Table [dbo].[WorkshopReservations]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkshopReservations](
	[WorkshopReservationID] [int] IDENTITY(1,1) NOT NULL,
	[WorkshopID] [int] NOT NULL,
	[ReservationDayID] [int] NOT NULL,
	[NumberOfParticipants] [smallint] NOT NULL,
	[NumberOfStudents] [smallint] NULL,
 CONSTRAINT [PK_WorkshopReservations] PRIMARY KEY CLUSTERED 
(
	[WorkshopReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkshopsDictionary]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkshopsDictionary](
	[WorkshopID] [int] NOT NULL,
	[WorkshopName] [varchar](100) NOT NULL,
	[Description] [varchar](1000) NULL,
 CONSTRAINT [PK_WorkshopsDictionary] PRIMARY KEY CLUSTERED 
(
	[WorkshopID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Workshop]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Workshop](
	[WorkshopID] [int] IDENTITY(1,1) NOT NULL,
	[ConferenceDayID] [int] NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[Price] [money] NULL,
	[LimitOfParticipants] [smallint] NOT NULL,
 CONSTRAINT [PK_Workshop] PRIMARY KEY CLUSTERED 
(
	[WorkshopID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewFreeAndBookedPlacesAtWorkshops]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewFreeAndBookedPlacesAtWorkshops]
AS
SELECT Workshop.WorkshopID, Workshop.ConferenceDayID, WorkshopsDictionary.WorkshopName, Workshop.LimitOfParticipants,
ISNULL(sum(WorkshopReservations.NumberOfParticipants),0) AS 'BOOKED PLACES',
Workshop.LimitOfParticipants-ISNULL(sum(WorkshopReservations.NumberOfParticipants),0) AS 'FREE PLACES'
FROM Workshop
inner join WorkshopsDictionary on Workshop.WorkshopID=WorkshopsDictionary.WorkshopID
inner join WorkshopReservations on WorkshopReservations.WorkshopID=Workshop.WorkshopID
GROUP BY Workshop.WorkshopID, Workshop.ConferenceDayID, WorkshopsDictionary.WorkshopName, Workshop.LimitOfParticipants
GO
/****** Object:  Table [dbo].[Clients]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients](
	[ClientID] [int] IDENTITY(1000,1) NOT NULL,
	[PhoneNumber] [varchar](50) NOT NULL,
	[Mail] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Companies]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Companies](
	[ClientID] [int] NOT NULL,
	[CompanyID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [varchar](50) NOT NULL,
	[NIP] [int] NOT NULL,
	[Country] [varchar](50) NOT NULL,
	[City] [varchar](50) NOT NULL,
	[PostalCode] [varchar](50) NOT NULL,
	[Address] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Companies] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewAllCompanies]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewAllCompanies]
AS
	SELECT 
		Clients.ClientID,
		Companies.CompanyName,
		Companies.Address,
		Companies.Country,
		Companies.City,
		Companies.PostalCode,
		Clients.Mail,
		Clients.PhoneNumber,
		Companies.NIP
	FROM Clients
	JOIN Companies ON Clients.ClientID = Companies.ClientID
GO
/****** Object:  Table [dbo].[PrivateClients]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrivateClients](
	[ClientID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
 CONSTRAINT [PK_PrivateClients_1] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewAllPrivateClients]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewAllPrivateClients]
AS
	SELECT Clients.ClientID, Person.FirstName, Person.LastName, Clients.Mail, Clients.PhoneNumber
	FROM Clients
	JOIN PrivateClients ON Clients.ClientID = PrivateClients.ClientID
	JOIN Person ON PrivateClients.PersonID = Person.PersonID
GO
/****** Object:  View [dbo].[viewAllClients]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewAllClients]
AS
	SELECT Clients.ClientID, Person.FirstName + Person.LastName as "Name", Clients.Mail, Clients.PhoneNumber, 'Private Client' as 'Status'
	FROM Clients
	JOIN PrivateClients ON Clients.ClientID = PrivateClients.ClientID
	JOIN Person ON PrivateClients.PersonID = Person.PersonID
	UNION
	SELECT Clients.ClientID, Companies.CompanyName as "Name", Clients.Mail, Clients.PhoneNumber, 'Company' as 'Status'
	FROM Clients
	JOIN Companies ON Clients.ClientID = Companies.ClientID
GO
/****** Object:  View [dbo].[viewFreeAndBookedPlaces]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[viewFreeAndBookedPlaces]
AS
	SELECT ConferenceDay.ConferenceDayID, Conferences.ConferenceID, Conferences.MaxParticipants,
	ISNULL(SUM(ReservationDay.NumberOfParticipants), 0) as 'BOOKED',
	Conferences.MaxParticipants - ISNULL(SUM(ReservationDay.NumberOfParticipants), 0) AS 'FREE'
	FROM 
	ConferenceDay
	JOIN Conferences ON ConferenceDay.ConferenceID=Conferences.ConferenceID
	LEFT JOIN ReservationDay ON ReservationDay.ConferenceDayID=ReservationDay.ConferenceDayID
	JOIN Reservations on Reservations.ReservationID=ReservationDay.ReservationID and Reservations.isCancelled=0
	GROUP BY ConferenceDay.ConferenceDayID, Conferences.ConferenceID, Conferences.MaxParticipants
GO
/****** Object:  Table [dbo].[Discount]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discount](
	[DiscountID] [int] IDENTITY(1,1) NOT NULL,
	[ConferenceID] [int] NOT NULL,
	[DaysBeforeStart] [int] NOT NULL,
	[Discount] [real] NOT NULL,
 CONSTRAINT [PK_Discount] PRIMARY KEY CLUSTERED 
(
	[DiscountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewConferencesPrices]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create view [dbo].[viewConferencesPrices]
as
select top (100) PERCENT Conferences.ConferenceID, Conferences.ConferenceName, Discount.DaysBeforeStart, Conferences.DayPrice as 'Price without discount', Discount.DiscountID, Discount.Discount, Conferences.DayPrice * (1 - Discount) as 'Price'
from Discount 
JOIN Conferences ON Discount.ConferenceID = Conferences.ConferenceID
order by Conferences.ConferenceID, Discount.Discount
GO
/****** Object:  Table [dbo].[WorkshopParticipants]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkshopParticipants](
	[WorkshopID] [int] NOT NULL,
	[ParticipantID] [int] NOT NULL,
 CONSTRAINT [PK_WorkshopParticipants] PRIMARY KEY CLUSTERED 
(
	[WorkshopID] ASC,
	[ParticipantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewListParticipants_Workshop]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewListParticipants_Workshop]
AS
	SELECT DISTINCT Workshop.WorkshopID, WorkshopsDictionary.WorkshopName, 
	Person.FirstName + ' ' + Person.LastName as 'Name'
	FROM Workshop
	JOIN WorkshopsDictionary ON Workshop.WorkshopID=Workshop.WorkshopID
	JOIN WorkshopParticipants ON Workshop.WorkshopID=WorkshopParticipants.WorkshopID
	JOIN Participants ON Participants.ParticipantID=WorkshopParticipants.ParticipantID
	JOIN Person ON Person.PersonID=Participants.PersonID
GO
/****** Object:  View [dbo].[viewListOfStudentCards_Workshop]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewListOfStudentCards_Workshop]
AS
	SELECT Workshop.WorkshopID, WorkshopsDictionary.WorkshopName, Students.StudentCard
	FROM Workshop
	JOIN WorkshopsDictionary ON Workshop.WorkshopID=Workshop.WorkshopID
	JOIN WorkshopParticipants ON Workshop.WorkshopID=WorkshopParticipants.WorkshopID
	JOIN Participants ON Participants.ParticipantID=WorkshopParticipants.ParticipantID
	JOIN Students ON Students.ParticipantID=Participants.ParticipantID
GO
/****** Object:  View [dbo].[viewClientswithNumberofReservations]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[viewClientswithNumberofReservations]
AS
SELECT Clients.ClientID, Companies.CompanyName AS 'Name',
(SELECT count(*) FROM Reservations
WHERE (Clients.ClientID = Reservations.ClientID AND Reservations.isCancelled = 0)) AS 'Number of reservations'
FROM Clients INNER JOIN
Companies ON Clients.ClientID = Companies.ClientID
UNION
SELECT Clients.ClientID, FirstName + ' ' + LastName AS 'Name',
(SELECT count(*) FROM Reservations
WHERE (Clients.ClientID = Reservations.ClientID AND Reservations.isCancelled = 0)) AS 'Number of reservations'
FROM Clients INNER JOIN
PrivateClients ON PrivateClients.ClientID = Clients.ClientID INNER JOIN
Person ON PrivateClients.PersonID = Person.PersonID
GO
/****** Object:  View [dbo].[viewTopClients]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewTopClients]
AS
SELECT TOP 10 *
FROM viewClientswithNumberofReservations
ORDER BY 'Number of reservations' DESC
GO
/****** Object:  UserDefinedFunction [dbo].[FUN_getWorkshopsByReservation]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FUN_getWorkshopsByReservation](
	@ConferenceDayID int
	)
	RETURNS TABLE
AS
	RETURN
	(
		SELECT *
		FROM Workshop
		WHERE ConferenceDayID = @ConferenceDayID

	);
GO
/****** Object:  View [dbo].[viewConferencesPopularity]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[viewConferencesPopularity]
as
select Conferences.ConferenceID, Conferences.ConferenceName, sum(dbo.F_CountTakenPlacesInReservartionDay(ReservationDayID)) as 'Ilość zajętych miejsc'
from ConferenceDay
JOIN Conferences on ConferenceDay.ConferenceID = Conferences.ConferenceID
JOIN ReservationDay on ReservationDay.ConferenceDayID = ConferenceDay.ConferenceDayID
group by Conferences.ConferenceID, Conferences.ConferenceName

GO
/****** Object:  View [dbo].[viewTopConferences]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[viewTopConferences]
as
select top 10 *
from viewConferencesPopularity
order by 3 desc

GO
/****** Object:  View [dbo].[viewWorkshopsPopularity]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[viewWorkshopsPopularity]
as
select Workshop.WorkshopID, WorkshopsDictionary.WorkshopName, sum(dbo.F_CountTakenPlacesInWokrshop(WorkshopReservationID)) as 'Ilość zajętych miejsc'
from Workshop
join WorkshopsDictionary on Workshop.WorkshopID = WorkshopsDictionary.WorkshopID
join WorkshopReservations on WorkshopReservations.WorkshopID = Workshop.WorkshopID
group by Workshop.WorkshopID, WorkshopsDictionary.WorkshopName

GO
/****** Object:  View [dbo].[viewTopWorkshop]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[viewTopWorkshop]
as
select top 10 *
from viewWorkshopsPopularity
order by 3 DESC

GO
/****** Object:  View [dbo].[viewUnpaidReservations]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewUnpaidReservations]
AS
SELECT Reservations.ReservationID, Person.FirstName + Person.LastName AS Name, 'Private Client' AS ClientType, Clients.PhoneNumber, Clients.Mail
FROM PrivateClients 
JOIN Clients ON Clients.ClientID = PrivateClients.ClientID
JOIN Reservations ON Reservations.ClientID = Clients.ClientID
JOIN Person ON PrivateClients.PersonID = Person.PersonID
WHERE Reservations.PaymentDate is NULL
UNION
SELECT Reservations.ReservationID, Companies.CompanyName AS Name, 'Company' AS ClientType, Clients.PhoneNumber, Clients.Mail
FROM Companies
JOIN Clients ON Clients.ClientID = Companies.ClientID
JOIN Reservations ON Reservations.ClientID = Clients.ClientID
WHERE Reservations.PaymentDate is NULL
GO
/****** Object:  View [dbo].[viewUpcomingConferences]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[viewUpcomingConferences]
AS
SELECT TOP 10 *
FROM Conferences
WHERE (StartDate > GETDATE())
ORDER BY StartDate
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[PersonID] [int] NOT NULL,
	[CompanyID] [int] NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewInformationForIdentifiers]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[viewInformationForIdentifiers]
AS
	SELECT Conferences.ConferenceID, Conferences.ConferenceName, ParticipantID, FirstName, LastName, '' AS Company
	FROM Participants
	JOIN Person ON Participants.PersonID=Person.PersonID
	JOIN ReservationDay ON Participants.ReservationDayID=ReservationDay.ReservationDayID
	JOIN Reservations ON ReservationDay.ReservationID=Reservations.ReservationID and isCancelled=0
	JOIN ConferenceDay ON ReservationDay.ConferenceDayID=ConferenceDay.ConferenceDayID
	JOIN Conferences ON Conferences.ConferenceID=ConferenceDay.ConferenceID
	UNION
	SELECT Conferences.ConferenceID, Conferences.ConferenceName, ParticipantID, FirstName, LastName, CompanyName AS Company
	FROM Participants
	JOIN Person ON Participants.PersonID=Person.PersonID
	JOIN Employees ON Person.PersonID=Employees.PersonID
	JOIN Companies ON Companies.CompanyID=Employees.CompanyID
	JOIN ReservationDay ON Participants.ReservationDayID=ReservationDay.ReservationDayID
	JOIN Reservations ON ReservationDay.ReservationID=Reservations.ReservationID and isCancelled=0
	JOIN ConferenceDay on ReservationDay.ConferenceDayID=ConferenceDay.ConferenceDayID
	JOIN Conferences ON Conferences.ConferenceID=ConferenceDay.ConferenceID
GO
/****** Object:  View [dbo].[viewIdentifiers]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewIdentifiers]
AS
	SELECT ConferenceID, ConferenceName, ParticipantID , FirstName + ' ' + LastName + ' ' + Company as Identifier
	FROM viewInformationForIdentifiers
GO
/****** Object:  View [dbo].[viewClientsWhoNotFulfilledDataReservations]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[viewClientsWhoNotFulfilledDataReservations]
as
select Reservations.ReservationID, Clients.ClientID, Companies.CompanyName, Clients.Mail, Clients.PhoneNumber
from Reservations
join Clients on Clients.ClientID=Reservations.ClientID
join Companies on Clients.ClientID = Companies.CompanyID
join ReservationDay on ReservationDay.ReservationID=Reservations.ReservationID
join Participants on Participants.ReservationDayID=ReservationDay.ReservationDayID
join Person on Person.PersonID = Participants.PersonID
where (Person.FirstName IS NULL and Person.LastName IS NULL)
GO
/****** Object:  Index [IX_Companies]    Script Date: 25/01/2019 12:19:43 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Companies] ON [dbo].[Companies]
(
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Companies_1]    Script Date: 25/01/2019 12:19:43 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Companies_1] ON [dbo].[Companies]
(
	[CompanyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Participants]    Script Date: 25/01/2019 12:19:43 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Participants] ON [dbo].[Participants]
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PrivateClients]    Script Date: 25/01/2019 12:19:43 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_PrivateClients] ON [dbo].[PrivateClients]
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_WorkshopParticipants]    Script Date: 25/01/2019 12:19:43 ******/
CREATE NONCLUSTERED INDEX [IX_WorkshopParticipants] ON [dbo].[WorkshopParticipants]
(
	[ParticipantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Conferences] ADD  CONSTRAINT [df_Discount1]  DEFAULT ((0)) FOR [DiscountForStudents]
GO
ALTER TABLE [dbo].[Discount] ADD  CONSTRAINT [df_DiscountDisc]  DEFAULT ((0)) FOR [Discount]
GO
ALTER TABLE [dbo].[ReservationDay] ADD  CONSTRAINT [df_reservDayStud]  DEFAULT ((0)) FOR [NumberOfStudents]
GO
ALTER TABLE [dbo].[Workshop] ADD  CONSTRAINT [df_Price1]  DEFAULT ((0)) FOR [Price]
GO
ALTER TABLE [dbo].[WorkshopReservations] ADD  CONSTRAINT [df_WsRes]  DEFAULT ((0)) FOR [NumberOfStudents]
GO
ALTER TABLE [dbo].[Companies]  WITH CHECK ADD  CONSTRAINT [FK_Companies_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[Companies] CHECK CONSTRAINT [FK_Companies_Clients]
GO
ALTER TABLE [dbo].[ConferenceDay]  WITH CHECK ADD  CONSTRAINT [FK_ConferenceDay_Conferences] FOREIGN KEY([ConferenceID])
REFERENCES [dbo].[Conferences] ([ConferenceID])
GO
ALTER TABLE [dbo].[ConferenceDay] CHECK CONSTRAINT [FK_ConferenceDay_Conferences]
GO
ALTER TABLE [dbo].[Discount]  WITH CHECK ADD  CONSTRAINT [FK_Discount_Conferences] FOREIGN KEY([ConferenceID])
REFERENCES [dbo].[Conferences] ([ConferenceID])
GO
ALTER TABLE [dbo].[Discount] CHECK CONSTRAINT [FK_Discount_Conferences]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_Companies] FOREIGN KEY([CompanyID])
REFERENCES [dbo].[Companies] ([CompanyID])
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_Employees_Companies]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_Employees_Person]
GO
ALTER TABLE [dbo].[Participants]  WITH CHECK ADD  CONSTRAINT [FK_Participants_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Participants] CHECK CONSTRAINT [FK_Participants_Person]
GO
ALTER TABLE [dbo].[Participants]  WITH CHECK ADD  CONSTRAINT [FK_Participants_ReservationDay] FOREIGN KEY([ReservationDayID])
REFERENCES [dbo].[ReservationDay] ([ReservationDayID])
GO
ALTER TABLE [dbo].[Participants] CHECK CONSTRAINT [FK_Participants_ReservationDay]
GO
ALTER TABLE [dbo].[PrivateClients]  WITH CHECK ADD  CONSTRAINT [FK_PrivateClients_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[PrivateClients] CHECK CONSTRAINT [FK_PrivateClients_Clients]
GO
ALTER TABLE [dbo].[PrivateClients]  WITH CHECK ADD  CONSTRAINT [FK_PrivateClients_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PrivateClients] CHECK CONSTRAINT [FK_PrivateClients_Person]
GO
ALTER TABLE [dbo].[ReservationDay]  WITH CHECK ADD  CONSTRAINT [FK_ReservationDay_ConferenceDay] FOREIGN KEY([ConferenceDayID])
REFERENCES [dbo].[ConferenceDay] ([ConferenceDayID])
GO
ALTER TABLE [dbo].[ReservationDay] CHECK CONSTRAINT [FK_ReservationDay_ConferenceDay]
GO
ALTER TABLE [dbo].[ReservationDay]  WITH CHECK ADD  CONSTRAINT [FK_ReservationDay_Reservations] FOREIGN KEY([ReservationID])
REFERENCES [dbo].[Reservations] ([ReservationID])
GO
ALTER TABLE [dbo].[ReservationDay] CHECK CONSTRAINT [FK_ReservationDay_Reservations]
GO
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_Clients]
GO
ALTER TABLE [dbo].[Students]  WITH CHECK ADD  CONSTRAINT [FK_Students_Participants] FOREIGN KEY([ParticipantID])
REFERENCES [dbo].[Participants] ([ParticipantID])
GO
ALTER TABLE [dbo].[Students] CHECK CONSTRAINT [FK_Students_Participants]
GO
ALTER TABLE [dbo].[WorkshopParticipants]  WITH CHECK ADD  CONSTRAINT [FK_WorkshopParticipants_Participants] FOREIGN KEY([ParticipantID])
REFERENCES [dbo].[Participants] ([ParticipantID])
GO
ALTER TABLE [dbo].[WorkshopParticipants] CHECK CONSTRAINT [FK_WorkshopParticipants_Participants]
GO
ALTER TABLE [dbo].[WorkshopParticipants]  WITH CHECK ADD  CONSTRAINT [FK_WorkshopParticipants_Workshop] FOREIGN KEY([WorkshopID])
REFERENCES [dbo].[Workshop] ([WorkshopID])
GO
ALTER TABLE [dbo].[WorkshopParticipants] CHECK CONSTRAINT [FK_WorkshopParticipants_Workshop]
GO
ALTER TABLE [dbo].[WorkshopReservations]  WITH CHECK ADD  CONSTRAINT [FK_WorkshopReservations_ReservationDay] FOREIGN KEY([ReservationDayID])
REFERENCES [dbo].[ReservationDay] ([ReservationDayID])
GO
ALTER TABLE [dbo].[WorkshopReservations] CHECK CONSTRAINT [FK_WorkshopReservations_ReservationDay]
GO
ALTER TABLE [dbo].[WorkshopReservations]  WITH CHECK ADD  CONSTRAINT [FK_WorkshopReservations_Workshop] FOREIGN KEY([WorkshopID])
REFERENCES [dbo].[Workshop] ([WorkshopID])
GO
ALTER TABLE [dbo].[WorkshopReservations] CHECK CONSTRAINT [FK_WorkshopReservations_Workshop]
GO
ALTER TABLE [dbo].[WorkshopsDictionary]  WITH CHECK ADD  CONSTRAINT [FK_WorkshopsDictionary_Workshop] FOREIGN KEY([WorkshopID])
REFERENCES [dbo].[Workshop] ([WorkshopID])
GO
ALTER TABLE [dbo].[WorkshopsDictionary] CHECK CONSTRAINT [FK_WorkshopsDictionary_Workshop]
GO
ALTER TABLE [dbo].[Clients]  WITH NOCHECK ADD  CONSTRAINT [CK_Clients] CHECK  (([Mail] like '%@_%.%'))
GO
ALTER TABLE [dbo].[Clients] CHECK CONSTRAINT [CK_Clients]
GO
ALTER TABLE [dbo].[Clients]  WITH NOCHECK ADD  CONSTRAINT [CK_Phone] CHECK  (([PhoneNumber] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Clients] CHECK CONSTRAINT [CK_Phone]
GO
ALTER TABLE [dbo].[Companies]  WITH NOCHECK ADD  CONSTRAINT [CK_Companies] CHECK  (([NIP] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Companies] CHECK CONSTRAINT [CK_Companies]
GO
ALTER TABLE [dbo].[Conferences]  WITH NOCHECK ADD  CONSTRAINT [CK_Conferences] CHECK  (([StartDate]<=[EndDate]))
GO
ALTER TABLE [dbo].[Conferences] CHECK CONSTRAINT [CK_Conferences]
GO
ALTER TABLE [dbo].[Conferences]  WITH CHECK ADD  CONSTRAINT [CK_Conferences_1] CHECK  (([DayPrice]>=(0)))
GO
ALTER TABLE [dbo].[Conferences] CHECK CONSTRAINT [CK_Conferences_1]
GO
ALTER TABLE [dbo].[Conferences]  WITH CHECK ADD  CONSTRAINT [CK_Conferences_2] CHECK  (([MaxParticipants]>(0)))
GO
ALTER TABLE [dbo].[Conferences] CHECK CONSTRAINT [CK_Conferences_2]
GO
ALTER TABLE [dbo].[Conferences]  WITH NOCHECK ADD  CONSTRAINT [CK_Conferences_3] CHECK  (([DiscountForStudents]<(1) AND [DiscountForStudents]>=(0)))
GO
ALTER TABLE [dbo].[Conferences] CHECK CONSTRAINT [CK_Conferences_3]
GO
ALTER TABLE [dbo].[Discount]  WITH CHECK ADD  CONSTRAINT [CK_Discount] CHECK  (([DaysBeforeStart]>(0)))
GO
ALTER TABLE [dbo].[Discount] CHECK CONSTRAINT [CK_Discount]
GO
ALTER TABLE [dbo].[Discount]  WITH CHECK ADD  CONSTRAINT [CK_Discount_1] CHECK  (([Discount]<(1) AND [Discount]>=(0)))
GO
ALTER TABLE [dbo].[Discount] CHECK CONSTRAINT [CK_Discount_1]
GO
ALTER TABLE [dbo].[ReservationDay]  WITH CHECK ADD  CONSTRAINT [CK_ReservationDay] CHECK  (([NumberOfParticipants]>(0)))
GO
ALTER TABLE [dbo].[ReservationDay] CHECK CONSTRAINT [CK_ReservationDay]
GO
ALTER TABLE [dbo].[Workshop]  WITH CHECK ADD  CONSTRAINT [CK_Workshop] CHECK  (([LimitOfParticipants]>(0)))
GO
ALTER TABLE [dbo].[Workshop] CHECK CONSTRAINT [CK_Workshop]
GO
ALTER TABLE [dbo].[Workshop]  WITH CHECK ADD  CONSTRAINT [CK_Workshop_1] CHECK  (([StartTime]<[EndTime]))
GO
ALTER TABLE [dbo].[Workshop] CHECK CONSTRAINT [CK_Workshop_1]
GO
ALTER TABLE [dbo].[Workshop]  WITH CHECK ADD  CONSTRAINT [CK_Workshop_2] CHECK  (([Price]>=(0)))
GO
ALTER TABLE [dbo].[Workshop] CHECK CONSTRAINT [CK_Workshop_2]
GO
ALTER TABLE [dbo].[WorkshopReservations]  WITH CHECK ADD  CONSTRAINT [CK_WorkshopReservations] CHECK  (([NumberOfParticipants]>(0)))
GO
ALTER TABLE [dbo].[WorkshopReservations] CHECK CONSTRAINT [CK_WorkshopReservations]
GO
/****** Object:  StoredProcedure [dbo].[P_Add_Client]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Add_Client]
@PhoneNumber varchar(50),
@Mail varchar(50),
@ClientID int OUTPUT

AS
BEGIN 
	SET NOCOUNT ON

		INSERT INTO Clients(
		PhoneNumber,
		Mail
		)
		VALUES(
		@PhoneNumber,
		@Mail
		)
		SET @ClientID = @@IDENTITY
END 
GO
/****** Object:  StoredProcedure [dbo].[P_Add_CompanyClient]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Add_CompanyClient]
@CompanyName varchar(50),
@NIP int,
@Country varchar(50),
@City varchar(50),
@PostalCode varchar(50),
@Address varchar(50),
@PhoneNumber varchar(50),
@Mail varchar(50),
@ClientID int OUT

AS
BEGIN 
	SET NOCOUNT ON

	
				--DECLARE @ClientID int
				EXECUTE  P_Add_Client @PhoneNumber, @Mail, @ClientID = @ClientID OUT
			INSERT INTO Companies(
			ClientID,
			CompanyName,
			Address,
			City,
			NIP,
			Country,
			PostalCode
			)
			VALUES(
			@ClientID,
			@CompanyName,
			@Address,
			@City,
			@NIP,
			@Country,
			@PostalCode
			)
END 
GO
/****** Object:  StoredProcedure [dbo].[P_Add_Conference]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Add_Conference]
@ConferenceName varchar(50),
@DiscountForStudents real,
@DayPrice money,
@MaxParticipants int,
@StartDate date,
@EndDate date,
@ConferenceID int OUTPUT
AS
BEGIN 

	SET NOCOUNT ON

		INSERT INTO Conferences(
			ConferenceName,
			DiscountForStudents,
			DayPrice,
			MaxParticipants,
			StartDate,
			EndDate
			)
			VALUES(
			@ConferenceName,
			@DiscountForStudents,
			@DayPrice,
			@MaxParticipants,
			@StartDate,
			@EndDate

			)
			SET @ConferenceID = @@IDENTITY

			DECLARE @i date = @StartDate

			WHILE @i <= @EndDate
			BEGIN 
				EXECUTE P_add_ConferenceDay @i,  @ConferenceID
				SET @i = DATEADD(Day, 1, @i);
			END
END
GO
/****** Object:  StoredProcedure [dbo].[P_Add_ConferenceDay]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Add_ConferenceDay]
@Date date,
@ConferenceID int

AS
BEGIN 

	SET NOCOUNT ON
		IF NOT EXISTS(
		SELECT * FROM Conferences
		WHERE Conferences.ConferenceID = @ConferenceID
		)
		BEGIN;
		THROW 50004, 'Nie ma konferencji o tym ID',1
		END
		IF EXISTS(
		SELECT * FROM ConferenceDay
		WHERE ConferenceDay.ConferenceID = @ConferenceID AND ConferenceDay.Date = @Date)
		BEGIN;
		THROW 50004, 'Jest juz zarejestrowany dzien tej konferencji na ta date', 1
		END
		INSERT INTO ConferenceDay(
			Date,
			ConferenceID
			)
			VALUES(
			@Date,
			@ConferenceID
			)

END
GO
/****** Object:  StoredProcedure [dbo].[P_Add_Discount]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Add_Discount]
@ConferenceID int,
@Discount real,
@DaysBeforeStart smallint
AS
BEGIN 
	SET NOCOUNT ON
	BEGIN TRY
	IF NOT EXISTS(
		SELECT * FROM Conferences
		WHERE ConferenceID = @ConferenceID
		)
		BEGIN;
		THROW 50004, 'Nie ma konferencji o podanym ID', 1
		END
	IF EXISTS(
		SELECT * FROM Discount
			WHERE ConferenceID = @ConferenceID
			AND DaysBeforeStart = @DaysBeforeStart
		)
		BEGIN;
		THROW 50004, 'Termin znizki dla tej konferencji zostal juz zajety', 1
		END
		INSERT INTO Discount(
			ConferenceID,
			Discount,
			DaysBeforeStart
			)
			VALUES(
			@ConferenceID,
			@Discount,
			@DaysBeforeStart
			)
	END TRY
	BEGIN CATCH 
		DECLARE @ERROR varchar(50) = 'Nie udalo sie dodac znizki';
		THROW 50004, @ERROR, 1
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[P_Add_Participant]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Add_Participant](
@FirstName varchar(50),
@LastName varchar(50),
@ReservationDayID int,
@ParticipantID int OUTPUT
)
AS
BEGIN 
	SET NOCOUNT ON

		DECLARE @PersonID int

		EXECUTE P_Add_Person @FirstName, @LastName, @PersonID = @PersonID OUT

		INSERT INTO Participants(
		ReservationDayID,
		PersonID
		)
		VALUES(
		@ReservationDayID,
		@PersonID
		)
		SET @ParticipantID = @@IDENTITY
END 
GO
/****** Object:  StoredProcedure [dbo].[P_Add_Person]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Add_Person]
@FirstName varchar(50),
@LastName varchar(50),
@PersonID int OUTPUT

AS
BEGIN 
	SET NOCOUNT ON

		INSERT INTO Person(
		FirstName,
		LastName
		)
		VALUES(
		@FirstName,
		@LastName
		)
		SET @PersonID = @@IDENTITY


END 
GO
/****** Object:  StoredProcedure [dbo].[P_Add_PrivateClient]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Add_PrivateClient]
@PhoneNumber varchar(50),
@Mail varchar(50),
@FirstName varchar(50),
@LastName varchar(50),
@ClientID int OUT,
@PersonID int OUT

AS
BEGIN 
	SET NOCOUNT ON
		
			EXECUTE P_Add_Client @PhoneNumber, @Mail, @ClientID = @ClientID OUT
			EXECUTE P_Add_Person @FirstName, @LastName, @PersonID = @PersonID OUT
		--Przypisanie wartości odpowiednim kolumnom w PrivateClients
		INSERT INTO PrivateClients(
		ClientID,
		PersonID
		)
		VALUES(
		@ClientID,
		@PersonID
		)

END 
GO
/****** Object:  StoredProcedure [dbo].[P_Add_Reservation]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Add_Reservation]
@ClientID int,
@ReservationID int OUTPUT
AS
BEGIN 
	SET NOCOUNT ON
	DECLARE @ReservationDate date
	SET @ReservationDate = GETDATE();
	IF NOT EXISTS(
		SELECT * FROM Clients
		WHERE @ClientID = ClientID
		)
		BEGIN;
		THROW 50004, 'Nie ma takiego klienta',1;
		END
		INSERT INTO Reservations(
		ClientID,
		isCancelled,
		ReservationDate
			)
			VALUES(
		@ClientID,
		0,
		@ReservationDate
			)
		SET @ReservationID = @@IDENTITY
END
GO
/****** Object:  StoredProcedure [dbo].[P_Add_ReservationDay]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Add_ReservationDay]
@ReservationID int,
@ConferenceDayID int,
@NumberOfParticipants int,
@NumberOfStudents int,
@ReservationDayID int OUTPUT
AS
BEGIN 
	SET NOCOUNT ON
	IF NOT EXISTS(
		SELECT * FROM ConferenceDay
		WHERE @ConferenceDayID = ConferenceDayID
		)
		BEGIN;
		DECLARE @ERROR1 varchar(50) = 'Nie ma dnia konferencji z tym ID';
		THROW 50001, @ERROR1, 1
		END
	IF NOT EXISTS(
		SELECT * FROM Reservations
		WHERE @ReservationID = ReservationID
		)
		BEGIN;
		DECLARE @ERROR2 varchar(50) = 'Nie ma rezerwacji z tym ID';
		THROW 50002, @ERROR2, 1
		END

		INSERT INTO ReservationDay(
		ReservationID,
		ConferenceDayID,
		NumberOfParticipants,
		NumberOfStudents
			)
			VALUES(
		@ReservationID,
		@ConferenceDayID,
		@NumberOfParticipants,
		@NumberOfStudents
			)
		SET @ReservationDayID = @@IDENTITY

END
GO
/****** Object:  StoredProcedure [dbo].[P_Add_StudentParticipant]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Add_StudentParticipant]
@FirstName varchar(50),
@LastName varchar(50),
@DayReservationID int,
@StudentCard varchar(50),
@ParticipantID int OUT
AS
BEGIN 
	SET NOCOUNT ON
			EXECUTE P_Add_Participant  @FirstName, @LastName, @DayReservationID, @ParticipantID = @ParticipantID OUT

		--Przypisanie wartości odpowiednim kolumnom w Participants
		INSERT INTO Students(
		StudentCard,
		ReservationDayID,
		ParticipantID
		)
		VALUES(
		@StudentCard,
		@DayReservationID,
		@ParticipantID
		)

END
GO
/****** Object:  StoredProcedure [dbo].[P_Add_Workshop]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Add_Workshop]
@ConferenceDayID int,
@StartTime time,
@EndTime time,
@Price money,
@LimitOfParticipants smallint,
@WorkshopName nvarchar(50),
@Description nvarchar(50),
@WorkshopID int OUTPUT
AS
BEGIN 
	SET NOCOUNT ON
		INSERT INTO Workshop(
			ConferenceDayID,
			StartTime,
			EndTime,
			Price,
			LimitOfParticipants
			)
			VALUES(
			@ConferenceDayID,
			@StartTime,
			@EndTime,
			@Price,
			@LimitOfParticipants
			)
			SET @WorkshopID = @@IDENTITY
			EXECUTE P_Add_WorkshopInfo @WorkshopName, @Description, @WorkshopID

END
GO
/****** Object:  StoredProcedure [dbo].[P_Add_WorkshopInfo]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Add_WorkshopInfo]
@WorkshopName varchar(50),
@Description varchar(50),
@WorkshopID int
AS
BEGIN 
	SET NOCOUNT ON
		INSERT INTO WorkshopsDictionary(
			WorkshopName,
			Description,
			WorkshopID
			)
			VALUES(
			@WorkshopName,
			@Description,
			@WorkshopID
			)
END
GO
/****** Object:  StoredProcedure [dbo].[P_Add_WorkshopParticipant]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Add_WorkshopParticipant]
@WorkshopID int,
@ParticipantID int
AS
BEGIN 
	SET NOCOUNT ON


		INSERT INTO WorkshopParticipants(
		WorkshopID,
		ParticipantID
		)
		VALUES(
		@WorkshopID,
		@ParticipantID
		)

END
GO
/****** Object:  StoredProcedure [dbo].[P_Add_WorkshopReservation]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Add_WorkshopReservation]
@WorkshopID int,
@DayReservationID int,
@NumberOfParticipants int,
@NumberOfStudents int
AS
BEGIN 
	SET NOCOUNT ON
	IF NOT EXISTS(
		SELECT * FROM Workshop
		WHERE @WorkshopID = WorkshopID
		)
		BEGIN;
		THROW 50004, 'Nie istnieje warsztat o tym ID', 1
		END
	IF NOT EXISTS(
		SELECT * FROM ReservationDay
		WHERE @DayReservationID = ReservationDayID
		)
		BEGIN;
		THROW 50004, 'Nie istnieje taki dzien rezerwacji', 1
		END

		INSERT INTO WorkshopReservations(
			WorkshopID,
			ReservationDayID,
			NumberOfParticipants,
			NumberOfStudents
			)
			VALUES(
			@WorkshopID,
			@DayReservationID,
			@NumberOfParticipants,
			@NumberOfStudents 
			)

END
GO
/****** Object:  StoredProcedure [dbo].[P_Cancel_Reservation]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Cancel_Reservation]
@ReservationID int
AS
BEGIN 

	SET NOCOUNT ON

	IF NOT EXISTS(
		SELECT * FROM Reservations
		WHERE @ReservationID = Reservations.ReservationID
		)
		BEGIN;
		THROW 50004, 'Nie ma takiej rezerwacji',1;
		END

		UPDATE Reservations
		SET isCancelled = 0
END
GO
/****** Object:  StoredProcedure [dbo].[P_Change_Workshop_Description]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Change_Workshop_Description]
@WorkshopID int,
@NewDescription nvarchar(50)
AS
BEGIN 
	SET NOCOUNT ON
		IF NOT EXISTS(
		SELECT * FROM WorkshopsDictionary
		WHERE WorkshopsDictionary.WorkshopID = @WorkshopID
		)
		BEGIN;
		THROW 50004, 'Nie ma Workshopu o tym ID', 1
		END

		UPDATE WorkshopsDictionary
		SET Description = @NewDescription
		WHERE WorkshopsDictionary.WorkshopID = @WorkshopID

END
GO
/****** Object:  StoredProcedure [dbo].[P_Change_Workshop_Limit]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Change_Workshop_Limit]
@WorkshopID int,
@NewLimit smallint
AS
BEGIN 
	SET NOCOUNT ON
		IF NOT EXISTS(
		SELECT * FROM Workshop 
		WHERE Workshop.WorkshopID = @WorkshopID
		)
		BEGIN;
		THROW 50004, 'Nie ma Workshopu o tym ID', 1
		END
		IF @NewLimit <= 0
		BEGIN;
		THROW 50004, 'Ujemna ilosc miejsc', 1
		END

		DECLARE @Taken int
		SET @Taken = dbo.F_WorkshopSlotsTaken(@WorkshopID)
		IF @Taken > @NewLimit
		BEGIN;
		THROW 50004, 'Zajeto wiecej miejsc niz nowy limit', 1
		END

		UPDATE Workshop 
		SET LimitOfParticipants = @NewLimit
		WHERE Workshop.WorkshopID = @WorkshopID

END
GO
/****** Object:  StoredProcedure [dbo].[P_Delete_ConferenceDay]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Delete_ConferenceDay]
@ConferenceDayID int

AS
BEGIN 

	SET NOCOUNT ON
		IF NOT EXISTS(
		SELECT * FROM ConferenceDay
		WHERE ConferenceDay.ConferenceDayID = @ConferenceDayID
		)
		BEGIN;
		THROW 50004, 'Nie ma dnia konferencji o tym ID',1
		END
		IF EXISTS(
		SELECT * From ReservationDay
		WHERE ReservationDay.ConferenceDayID = @ConferenceDayID
		)
		BEGIN;
		THROW 50004, 'Jest rezerwacja na ten dzien, wiec nie mozna usunac',1
		END

		DELETE FROM ConferenceDay
		WHERE ConferenceDay.ConferenceDayID = @ConferenceDayID
END
GO
/****** Object:  StoredProcedure [dbo].[P_Delete_Discount]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Delete_Discount]
@DiscountID int
AS
BEGIN 
	SET NOCOUNT ON

	IF NOT EXISTS(
		SELECT * FROM Discount
		WHERE DiscountID = @DiscountID
		)
		BEGIN;
		THROW 50004, 'Nie ma znizki o podanym ID', 1
		END

		DELETE FROM Discount
		WHERE Discount.DiscountID = @DiscountID

END
GO
/****** Object:  StoredProcedure [dbo].[P_Delete_ReservationDay]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Delete_ReservationDay]
@ReservationDayID int
AS
BEGIN 
	SET NOCOUNT ON

	IF NOT EXISTS(
		SELECT * FROM ReservationDay
		WHERE @ReservationDayID = ReservationDayID
		)
		BEGIN;
		DECLARE @ERROR2 varchar(50) = 'Nie ma rezerwacji na dzien z tym ID';
		THROW 50002, @ERROR2, 1
		END

		DELETE FROM ReservationDay
		Where ReservationDayID = @ReservationDayID

END
GO
/****** Object:  StoredProcedure [dbo].[P_DeleteCancelled_Reservations]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_DeleteCancelled_Reservations]

AS
BEGIN 
	SET NOCOUNT ON

	DELETE FROM Reservations 
	WHERE Reservations.isCancelled = 1
END
GO
/****** Object:  StoredProcedure [dbo].[P_Update_Client_MailAndPhone]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Update_Client_MailAndPhone]
@PhoneNumber varchar(50),
@Mail varchar(50),
@ClientID int
AS
BEGIN 
	SET NOCOUNT ON

		IF NOT EXISTS(
		SELECT * From Clients
		WHERE Clients.ClientID = @ClientID
		)
		BEGIN;
		THROW 50001, 'Nie ma klienta o tym ID',1
		END

		UPDATE Clients
		SET Mail = @Mail,
		PhoneNumber = @PhoneNumber
		WHERE Clients.ClientID = @ClientID
END 
GO
/****** Object:  StoredProcedure [dbo].[P_Update_Conference_Data]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Update_Conference_Data]
@ConferenceName varchar(50),
@DiscountForStudents real,
@DayPrice money,
@MaxParticipants int,
@StartDate date,
@EndDate date,
@ConferenceID int
AS
BEGIN 

	SET NOCOUNT ON

		IF NOT EXISTS(
		SELECT * from Conferences
		where Conferences.ConferenceID = @ConferenceID
		)
		BEGIN;
		THROW 50005, 'Nie ma konferencji o tym ID', 1
		END
		INSERT INTO Conferences(
			ConferenceName,
			DiscountForStudents,
			DayPrice,
			MaxParticipants,
			StartDate,
			EndDate
			)
			VALUES(
			@ConferenceName,
			@DiscountForStudents,
			@DayPrice,
			@MaxParticipants,
			@StartDate,
			@EndDate
			)

END
GO
/****** Object:  StoredProcedure [dbo].[P_Update_Discount]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Update_Discount]
@ConferenceID int,
@Discount real,
@DaysBeforeStart smallint,
@DiscountID int
AS
BEGIN 
	SET NOCOUNT ON
	BEGIN TRY
	IF NOT EXISTS(
		SELECT * FROM Conferences
		WHERE ConferenceID = @ConferenceID
		)
		BEGIN;
		THROW 50004, 'Nie ma konferencji o podanym ID', 1
		END
	IF NOT EXISTS(
		SELECT * FROM Discount
		WHERE DiscountID = @DiscountID
		)
		BEGIN;
		THROW 50004, 'Nie ma znizki o podanym ID', 1
		END

		UPDATE Discount
		SET Discount = @Discount,
		DaysBeforeStart = @DaysBeforeStart
		WHERE Discount.DiscountID = @DiscountID
	END TRY
	BEGIN CATCH 
		DECLARE @ERROR varchar(50) = 'Nie udalo sie zmienic znizki';
		THROW 50004, @ERROR, 1
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[P_Update_Participant_Data]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Update_Participant_Data](
@FirstName varchar(50),
@LastName varchar(50),
@ReservationDayID int,
@ParticipantID int
)
AS
BEGIN 
	SET NOCOUNT ON

		IF NOT EXISTS(
		SELECT * FROM Participants
		WHERE Participants.ParticipantID = @ParticipantID
		)
		BEGIN;
		THROW 50004, 'Nie ma takiego participanta',1
		END


		DECLARE @ThisPersonID int =
		(SELECT  PersonID FROM Participants
		WHERE Participants.ParticipantID = @ParticipantID
		)

		UPDATE Person
		SET FirstName = @FirstName, 
		LastName = @LastName
		WHERE Person.PersonID = @ThisPersonID

		UPDATE Participants
		SET ReservationDayID = @ReservationDayID
		WHERE Participants.ParticipantID = @ParticipantID
END 
GO
/****** Object:  StoredProcedure [dbo].[P_Update_Person_Data]    Script Date: 25/01/2019 12:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Update_Person_Data]
@FirstName varchar(50),
@LastName varchar(50),
@PersonID int

AS
BEGIN 
	SET NOCOUNT ON
	
	IF NOT EXISTS(
	SELECT * FROM Person
	Where Person.PersonID = @PersonID)
	BEGIN;
	THROW 50004, 'Nie ma osoby o tym ID',1
	END
	Update Person
	SET FirstName = @FirstName,
	LastName = @LastName
	Where Person.PersonID = @PersonID

END 
GO
USE [master]
GO
ALTER DATABASE [makson_a] SET  READ_WRITE 
GO
