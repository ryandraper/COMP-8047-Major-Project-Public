USE [digital-justice-2023]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Decision Fact](
	[ID] [int] NULL,
	[In favour of Applicant] [int] NULL,
	[Applicant DIM] [int] NULL,
	[Respondent DIM] [int] NULL,
	[Dispute DIM] [int] NULL,
	[Tribunal Member DIM] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Decision Fact]  WITH CHECK ADD  CONSTRAINT [FK_Decision Fact_Dispute DIM] FOREIGN KEY([Dispute DIM])
REFERENCES [dbo].[Dispute DIM] ([ID])
GO

ALTER TABLE [dbo].[Decision Fact] CHECK CONSTRAINT [FK_Decision Fact_Dispute DIM]
GO

ALTER TABLE [dbo].[Decision Fact]  WITH CHECK ADD  CONSTRAINT [FK_Decision Fact_Applicant DIM] FOREIGN KEY([Applicant DIM])
REFERENCES [dbo].[Applicant DIM] ([ID])
GO

ALTER TABLE [dbo].[Decision Fact] CHECK CONSTRAINT [FK_Decision Fact_Applicant DIM]
GO

ALTER TABLE [dbo].[Decision Fact]  WITH CHECK ADD  CONSTRAINT [FK_Decision Fact_Respondent DIM] FOREIGN KEY([Respondent DIM])
REFERENCES [dbo].[Respondent DIM] ([ID])
GO

ALTER TABLE [dbo].[Decision Fact] CHECK CONSTRAINT [FK_Decision Fact_Respondent DIM]
GO

ALTER TABLE [dbo].[Decision Fact]  WITH CHECK ADD  CONSTRAINT [FK_Decision Fact_Tribunal Member DIM] FOREIGN KEY([Tribunal Member DIM])
REFERENCES [dbo].[Tribunal Member DIM] ([ID])
GO

ALTER TABLE [dbo].[Decision Fact] CHECK CONSTRAINT [FK_Decision Fact_Tribunal Member DIM]
GO


