USE [digital-justice-2023]
GO

INSERT INTO [dbo].[Tribunal Member DIM](
    [Id],
    [Identity],
    [Age Range],
    [Gender identity],
    [Province] 
    )
     SELECT 
        ID,
        [identity], 
        age_range, 
        gender, 
        province
	 FROM [dbo].[party dims]