USE [digital-justice-2023]
GO

Declare @randInFavour int
Declare @count int = 1


Declare @description varchar(50)


While @count <= 100000


Begin 

Set @randInFavour = ROUND(RAND(),0)
Select @description = CONVERT(varchar(50),NEWID())


INSERT INTO [dbo].[Decision]
           ([ID]
           ,[Description]
           ,[In favour of Applicant]    
           ,[DisputeID])
     VALUES
           (@count
           ,@description
           ,@randInFavour
           ,@count)

	Set @count = @count + 1

End

GO



