DECLARE @randIdentity varchar(100)
DECLARE @randIdentityInt int

DECLARE @randGenderIdentity varchar(50)
DECLARE @randGenderIdentityInt int

DECLARE @randIsLawyer int
DECLARE @randIsJudge int
DECLARE @randIsRetired int

DECLARE @randAgeInt int
DECLARE @randAge varchar(50)

DECLARE @randProv varchar(50)
DECLARE @randProvInt int

DECLARE @firstname varchar(50)
DECLARE @lastname varchar(50)


DECLARE @count int
SET @count = 1

WHILE @count <= 100000

BEGIN 

	SET @randIdentityInt = ROUND(RAND()*7,0)+1
	SELECT @randIdentity = CHOOSE(@randIdentityInt, 'Indiginous','White','Hispanic or Latin', 'Black or Caribbean', 'Asian', 'Middle Eastern or North African', 'Pacific Islander', 'Other');

	--SET @randAge = ROUND(RAND()*50,0)+30
	SET @randAgeInt = ROUND(RAND()*4,0)+1
	SELECT @randAge = CHOOSE(@randAgeInt, '35 - 49','65 and over','50 - 64', '20 - 34', '19 or under');

	SET @randGenderIdentityInt = ROUND(RAND()*3,0)+1
	SELECT @randGenderIdentity = CHOOSE(@randGenderIdentityInt, 'Male','Female','LGBTQ2S+','Other');

	SET @randProvInt = ROUND(RAND()*12,0)+1
	SELECT @randProv = CHOOSE(@randProvInt, 'NL','PE','NS','NB','QC','ON','MB','SK','AB','BC','YT','NT','NU');

	SET @randIsLawyer = ROUND(RAND(),0)
	SET @randIsJudge = ROUND(RAND(),0)
	SET @randIsRetired = ROUND(RAND(),0)

	SELECT @firstname = CONVERT(varchar(50),NEWID())
	SELECT @lastname = CONVERT(varchar(50),NEWID())

	INSERT INTO [dbo].[Tribunal Member](
		Id, 
		DisputeID, 
		[First Name],
		[Last Name],
		[Identity],
		[Age range],
		[Is Lawyer],
		[Is Judge], 
		[Is Retired], 
		[Gender identity],
		[Province]
	) 
	VALUES(
		@count,
		@count, 
		@firstname, 
		@lastname, 
		@randIdentity, 
		@randAge, 
		@randIsLawyer, 
		@randIsJudge, 
		@randIsRetired, 
		@randGenderIdentity,
		@randProv 
	)

   SET @count = @count + 1

END