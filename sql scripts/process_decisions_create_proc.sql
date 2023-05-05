SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[process_decisions]
AS
--------------------------------------

DECLARE @decisionID INT, @disputeID INT, @inFavourOfApplicant INT

DECLARE DecisionCursor CURSOR FAST_FORWARD
FOR

SELECT Id, DisputeID, [In favour of Applicant] FROM Decision ORDER BY Id ASC;

OPEN DecisionCursor;
FETCH NEXT FROM DecisionCursor INTO @decisionID, @disputeID, @inFavourOfApplicant;

WHILE @@FETCH_STATUS = 0

BEGIN
--------------------------------------
--               LOGIC              --
	SET NOCOUNT ON;

    Declare 
        @disputeType varchar(200),

        @applicantID int,
        @respondentID int,

	    @applicantDimID int,
        @respondentDimID int,
        @disputeDimID int,
        @tribunalMemberDimID int,
    
	-- decision info
	    --@inFavourOfApplicant int,

        @respondentAge varchar(50),
        @respondentIncome varchar(50),
        @respondentIdentity varchar(50),
        @respondentGenderIdentity varchar(50),
        @respondentProvince varchar(50),
        @respondentIsLawyer int,

	    @applicantAge varchar(50),
        @applicantIncome varchar(50),
        @applicantIdentity varchar(50),
        @applicantGenderIdentity varchar(50),
        @applicantProvince varchar(50),
        @applicantIsLawyer int,

	-- Tribunal member info
	    @tribunalMemberID int,
	    @tmAge varchar(50),
	    @tmAgeRange varchar(50),
	    @tmIdentity varchar(50),
	    @tmGenderIdentity varchar(50),
	    @tmProvince varchar(50)    

    
	-- Dispute DIM
	--SELECT @disputeID = INSERTED.DisputeID FROM INSERTED
	SELECT @disputeType = [Type] FROM [Dispute] WHERE ID = @disputeID
	SELECT @disputeDimID = [Id] FROM [Dispute DIM] WHERE [Dispute Type] = @disputeType
	--SELECT @inFavourOfApplicant = INSERTED.[In favour of applicant] FROM INSERTED

	-- Applicant info
    SELECT 
        @applicantID = Id,
        @applicantAge = [Age Range],
        @applicantIncome = [Household income],
        @applicantIdentity = [Identity],
        @applicantGenderIdentity = [Gender identity],
        @applicantProvince = [Province],
        @applicantIsLawyer = [Is Lawyer]
    FROM Party
    WHERE DisputeID = @disputeID AND [Role] = 'applicant'

	-- select the applicant dim
	SELECT @applicantDimID = Id 
	FROM [Applicant DIM] 
	WHERE Province = @applicantProvince 
		AND [Identity] = @applicantIdentity
        AND [Age Range] = @applicantAge
		AND [Household income] = @applicantIncome
        AND [Gender Identity] = @applicantGenderIdentity 
		AND [Is Lawyer] = @applicantIsLawyer

	-- Respondent info
    SELECT 
        @respondentID = Id,
        @respondentAge = [Age Range],
        @respondentIncome = [Household income],
        @respondentIdentity = [Identity],
        @respondentGenderIdentity = [Gender identity],
        @respondentProvince = [Province],
        @respondentIsLawyer = [Is Lawyer]
    FROM Party
    WHERE DisputeID = @disputeID AND [Role] = 'respondent'

	-- select the respondent dim
	SELECT @respondentDimID = Id 
	FROM [Respondent DIM] 
	WHERE Province = @respondentProvince
        AND [Identity] = @respondentIdentity 
		AND [Age Range] = @respondentAge 
		AND [Household income] = @respondentIncome 
		AND [Gender identity] = @respondentGenderIdentity 
        AND [Is Lawyer] = @respondentIsLawyer

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
	WHERE [Province] = @tmProvince
		AND [Age Range] = @tmAgeRange 
		AND [Gender identity] = @tmGenderIdentity 
		AND [Identity] = @tmIdentity 

	

	-- insert disputefacts
	INSERT INTO [dbo].[Decision Fact] WITH (TABLOCK)
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




--------------------------------------
--PRINT CAST(@decisionID AS VARCHAR(50));

FETCH NEXT FROM DecisionCursor INTO @decisionID, @disputeID, @inFavourOfApplicant;

END;

CLOSE DecisionCursor;

DEALLOCATE DecisionCursor;
--------------------------------------
GO
