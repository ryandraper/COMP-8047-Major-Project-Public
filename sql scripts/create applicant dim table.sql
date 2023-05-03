USE [digital-justice-2023]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Applicant DIM](
	[ID] [int] NOT NULL,
	[Is Lawyer] [int] NULL,
	[Age Range] [varchar](50) NULL,
	[City] [varchar](100) NULL,
	[Province] [varchar](10) NULL,
	[Identity] [varchar](100) NULL,
	[Gender identity] [varchar](100) NULL,
	[Household income] [varchar](100) NULL,
 CONSTRAINT [PK_Applicant DIM] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


