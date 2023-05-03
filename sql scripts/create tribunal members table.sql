USE [digital-justice-2023]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Tribunal Member](
	[ID] [int] NULL,
	[First Name] [varchar](50) NULL,
	[Last Name] [varchar](50) NULL,
	[Is Lawyer] [int] NULL,
	[Is Judge] [int] NULL,
	[Is Retired] [int] NULL,
	[Age range] [varchar](50) NULL,
	[Gender identity] [varchar](50) NULL,
	[DisputeID] [int] NULL,
	[Identity] [varchar](50) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Tribunal Member]  WITH CHECK ADD  CONSTRAINT [FK_Tribunal Member_Dispute] FOREIGN KEY([DisputeID])
REFERENCES [dbo].[Dispute] ([ID])
GO

ALTER TABLE [dbo].[Tribunal Member] CHECK CONSTRAINT [FK_Tribunal Member_Dispute]
GO


