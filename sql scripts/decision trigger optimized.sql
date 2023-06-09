USE [digital-justice-2023]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[decision_trigger]
   ON  [dbo].[Decision]
   AFTER INSERT

AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Declare @disputeID int
    Declare @decisionID int
    Declare @disputeType varchar(200)

    Declare @applicantID int
    Declare @respondentID int

	Declare @applicantDimID int
    Declare @respondentDimID int
    Declare @disputeDimID int
    Declare @tribunalMemberDimID int
    
	-- decision info
	Declare @inFavourOfApplicant int


    Declare @respondentAge varchar(50)
    Declare @respondentIncome varchar(50)
    Declare @respondentIdentity varchar(50)
    Declare @respondentGenderIdentity varchar(50)
    Declare @respondentProvince varchar(50)


	Declare @applicantAge varchar(50)
    Declare @applicantIncome varchar(50)
    Declare @applicantIdentity varchar(50)
    Declare @applicantGenderIdentity varchar(50)
    Declare @applicantProvince varchar(50)

	-- Tribunal member info
	Declare @tribunalMemberID int
	Declare @tmAge varchar(50)
	Declare @tmAgeRange varchar(50)
	Declare @tmIdentity varchar(50)
	Declare @tmGenderIdentity varchar(50)
	Declare @tmProvince varchar(50)    

    
	-- Dispute DIM
	SELECT @disputeID = INSERTED.DisputeID FROM INSERTED
	SELECT @disputeType = [Type] FROM [Dispute] WHERE ID = @disputeID
	SELECT @disputeDimID = [Id] FROM [Dispute DIM] WHERE [Dispute Type] = @disputeType
	SELECT @inFavourOfApplicant = INSERTED.[In favour of applicant] FROM INSERTED

	-- Applicant DIM info
    SELECT 
        @applicantID = Id,
        @applicantAge = [Age Range],
        @applicantIncome = [Household income],
        @applicantIdentity = [Identity],
        @applicantGenderIdentity = [Gender identity],
        @applicantProvince = [Province]
    FROM Party
    WHERE DisputeID = @disputeID AND [Role] = 'applicant'

	-- select the applicant dim
	SELECT @applicantDimID = Id 
	FROM [Applicant DIM] 
	WHERE [Age Range] = @applicantAge 
		AND Province = @applicantProvince 
		AND [Identity] = @applicantIdentity 
		AND [Gender Identity] = @applicantGenderIdentity 
		AND [Household income] = @applicantIncome

	-- Respondent DIM info
    SELECT 
        @respondentID = Id,
        @respondentAge = [Age Range],
        @respondentIncome = [Household income],
        @respondentIdentity = [Identity],
        @respondentGenderIdentity = [Gender identity],
        @respondentProvince = [Province]
    FROM Party
    WHERE DisputeID = @disputeID AND [Role] = 'respondent'

	-- select the respondent dim
	SELECT @respondentDimID = Id 
	FROM [Respondent DIM] 
	WHERE [Age Range] = @respondentAge 
		AND Province = @respondentProvince 
		AND [Identity] = @respondentIdentity 
		AND [Gender identity] = @respondentGenderIdentity 
		AND [Household income] = @respondentIncome

	-- Tribunal Member info
    SELECT
        @tribunalMemberID = Id,
        @tmAgeRange = [Age range],
        @tmIdentity = [Identity],
        @tmGenderIdentity = [Gender identity],
        @tmProvince = [Province]
    FROM [Tribunal Member] 
    WHERE DisputeID = @disputeID
	
	-- TM DIM info
	SELECT @tribunalMemberDimID = ID 
	FROM [Tribunal Member DIM] 
	WHERE [Identity] = @tmIdentity 
		AND [Age Range] = @tmAgeRange 
		AND [Gender identity] = @tmGenderIdentity 
		AND [Province] = @tmProvince

	

	-- insert disputefacts
	INSERT INTO [dbo].[Decision Fact]
           ([Applicant DIM]
           ,[Respondent DIM]
           ,[Dispute DIM]
           ,[Tribunal Member DIM],
		   [In favour of Applicant])
     VALUES
           (@applicantDimID
           ,@respondentDimID
           ,@disputeDimID
           ,@tribunalMemberDimID
		   ,@inFavourOfApplicant)
    

END
