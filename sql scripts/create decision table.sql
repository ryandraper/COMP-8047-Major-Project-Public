USE [digital-justice-2023]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Decision](
	[ID] [int] NOT NULL,
	[Description] [varchar](1000) NULL,
	[In favour of Applicant] [int] NULL,
	[DisputeID] [int] NULL,
	[DecisionDate] [date] NULL,
 CONSTRAINT [PK_Decision] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Decision]  WITH CHECK ADD  CONSTRAINT [FK_Decision_Dispute] FOREIGN KEY([DisputeID])
REFERENCES [dbo].[Dispute] ([ID])
GO

ALTER TABLE [dbo].[Decision] CHECK CONSTRAINT [FK_Decision_Dispute]
GO