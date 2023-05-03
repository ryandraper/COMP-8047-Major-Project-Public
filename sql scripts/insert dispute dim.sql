USE [digital-justice-2023]
GO

INSERT INTO [dbo].[Dispute DIM](
    [Dispute Type],
    Id
    )
    SELECT 
        [Type], 
        ROW_NUMBER() OVER (order by [type]) AS RowNum 
    FROM [dbo].[Dispute] 
    GROUP BY [Type]
