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
    --Declare @respondentRole varchar
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


	--------------------------------------------
	-- Dispute DIM
	SELECT @disputeID = INSERTED.DisputeID FROM INSERTED
	--SELECT @decisionID = INSERTED.ID FROM INSERTED
	SELECT @disputeType = [Type] FROM dbo.Dispute WHERE ID = @disputeID
	SELECT @disputeDimID = [Id] FROM [Dispute DIM] WHERE [Dispute Type] = @disputeType
	SELECT @inFavourOfApplicant = INSERTED.[In favour of applicant] FROM INSERTED

	-- Decision DIM info
	-- SELECT @inFavourOfApplicant = INSERTED.[In favour of Applicant] FROM INSERTED
	-- SELECT @disputeDimID = Id FROM [Decision DIM] WHERE [In favour of Applicant] = @inFavourOfApplicant
	-- SELECT @decisionDate = DecisionDate FROM Decision WHERE Id = @decisionID

	-- Applicant DIM info
	SELECT @applicantID = Id FROM dbo.Party WHERE DisputeID = @disputeID AND [Role] = 'applicant'
	SELECT @applicantAge = [Age Range] FROM Party WHERE Id = @applicantID
	SELECT @applicantIncome = [Household income] FROM Party WHERE Id = @applicantID
	SELECT @applicantIdentity = [Identity] FROM Party WHERE Id = @applicantID
	SELECT @applicantGenderIdentity = [Gender identity] FROM Party WHERE Id = @applicantID
	SELECT @applicantProvince = [Province] FROM Party WHERE Id = @applicantID
	-- select the applicant dim
	SELECT @applicantDimID = Id 
	FROM [Applicant DIM] 
	WHERE [Age Range] = @applicantAge 
		AND Province = @applicantProvince 
		AND [Identity] = @applicantIdentity 
		AND [Gender Identity] = @applicantGenderIdentity 
		AND [Household income] = @applicantIncome

	-- Respondent DIM info
	SELECT @respondentID = Id FROM dbo.Party WHERE DisputeID = @disputeID AND [Role] = 'respondent'
	SELECT @respondentAge = [Age Range] FROM Party WHERE Id = @respondentID
	SELECT @respondentIncome = [Household income] FROM Party WHERE Id = @respondentID
	SELECT @respondentIdentity = [Identity] FROM Party WHERE Id = @respondentID
	SELECT @respondentGenderIdentity = [Gender identity] FROM Party WHERE Id = @respondentID
	SELECT @respondentProvince = [Province] FROM Party WHERE Id = @respondentID
	-- select the respondent dim
	SELECT @respondentDimID = Id 
	FROM [Respondent DIM] 
	WHERE [Age Range] = @respondentAge 
		AND Province = @respondentProvince 
		AND [Identity] = @respondentIdentity 
		AND [Household income] = @respondentIncome

	-- Tribunal Member info
	SELECT @tribunalMemberID = Id FROM [Tribunal Member] WHERE DisputeID = @disputeID
	SELECT @tmAgeRange = [Age range] FROM [Tribunal Member] WHERE Id = @tribunalMemberID
	SELECT @tmIdentity = [Identity] FROM [Tribunal Member] WHERE Id = @tribunalMemberID
	SELECT @tmGenderIdentity = [Gender identity] FROM [Tribunal Member] WHERE Id = @tribunalMemberID
	
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
