USE [digital-justice-2023]
GO

INSERT INTO [dbo].[Respondent DIM](
    [Id],
    [Identity],
    [Age Range],
    [Gender identity],
    [Household income],
    [Province],
    [Is Lawyer] 
    )
     SELECT 
        ID,
        [identity], 
        age_range, 
        gender, 
        household_income, 
        province, 
        is_lawyer
	 FROM [dbo].[party dims]