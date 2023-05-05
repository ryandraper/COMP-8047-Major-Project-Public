USE [digital-justice-2023]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Party](
	[ID] [int] NOT NULL,
	[First Name] [varchar](50) NULL,
	[Last Name] [varchar](50) NULL,
	[Email] [varchar](100) NULL,
	[Phone] [varchar](50) NULL,
	[Role] [varchar](50) NULL,
	[Is Lawyer] [int] NULL,
	[Age Range] [varchar](50) NULL,
	[Is Landlord] [int] NULL,
	[Is Tenant] [int] NULL,
	[City] [varchar](100) NULL,
	[Province] [varchar](50) NULL,
	[Household income] [varchar](100) NULL,
	[Age] [int] NULL,
	[Indiginous identity] [varchar](100) NULL,
	[Identity] [varchar](100) NULL,
	[Gender identity] [varchar](100) NULL,
	[DisputeID] [int] NULL,
 CONSTRAINT [PK_Party] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Party]  WITH CHECK ADD  CONSTRAINT [FK_Party_Dispute] FOREIGN KEY([DisputeID])
REFERENCES [dbo].[Dispute] ([ID])
GO

ALTER TABLE [dbo].[Party] CHECK CONSTRAINT [FK_Party_Dispute]
GO


