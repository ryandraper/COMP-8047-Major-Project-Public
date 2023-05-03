
DECLARE @randIdentity varchar(100)
DECLARE @randIdentityInt int

DECLARE @randGenderIdentity varchar(100)
DECLARE @randGenderIdentityInt int

DECLARE @randIncome varchar(100)
DECLARE @randHouseholdIncomeInt int

DECLARE @randRole varchar(50)
DECLARE @randRoleInt int

DECLARE @randAge varchar(50)
DECLARE @randAgeInt int

DECLARE @randCity varchar(100)
DECLARE @randCityInt int

DECLARE @randProv varchar(50)
DECLARE @randProvInt int

DECLARE @randIsLawyer int
DECLARE @randIsLandlord int
DECLARE @randIsTenant int


DECLARE @firstname varchar(50)
DECLARE @lastname varchar(50)
DECLARE @email varchar(100)
DECLARE @phone varchar(50)

DECLARE @count int
SET @count = 100001

DECLARE @disputecount int
SET @disputecount = 1

While @count <= 200000

Begin 

	SET @randIdentityInt = ROUND(RAND()*7,0)+1
	SELECT @randIdentity = CHOOSE(@randIdentityInt, 'Indiginous','White','Hispanic or Latin', 'Black or Caribbean', 'Asian', 'Middle Eastern or North African', 'Pacific Islander', 'Other');

	SET @randHouseholdIncomeInt = ROUND(RAND()*4,0)+1
	SELECT @randIncome = CHOOSE(@randHouseholdIncomeInt, 'Under 20,000','20,000 - 39,000','100,000 or more', '40,000 - 79,000', '80,000 - 99,000');

	SET @randAgeInt = ROUND(RAND()*4,0)+1
	SELECT @randAge = CHOOSE(@randAgeInt, '35 - 49','65 and over','50 - 64', '20 - 34', '19 or under');

	--SET @randCityInt = ROUND(RAND()*12,0)+1
	--SELECT @randCity = CHOOSE(@randCityInt, 'maple ridge','port moody','surrey','victoria','port coquitlam','langley','pitt meadows','delta','coquitlam','vancouver','whiterock','burnaby','mission');

    SET @randProvInt = ROUND(RAND()*12,0)+1
	SELECT @randProv = CHOOSE(@randProvInt, 'NL','PE','NS','NB','QC','ON','MB','SK','AB','BC','YT','NT','NU');

	SET @randGenderIdentityInt = ROUND(RAND()*3,0)+1
	SELECT @randGenderIdentity = CHOOSE(@randGenderIdentityInt, 'Male','Female','LGBTQ2S+','Other');

	SET @randIsLawyer = ROUND(RAND(),0)
	SET @randIsLandlord = ROUND(RAND(),0)
	SET @randIsTenant = ROUND(RAND(),0)

	SELECT @firstname = CONVERT(varchar(50),NEWID())
	SELECT @lastname = CONVERT(varchar(50),NEWID())
	SELECT @email = CONVERT(varchar(100),NEWID())
	SELECT @phone = CONVERT(varchar(50),NEWID())

	INSERT INTO [dbo].Party
		(	Id, 
			DisputeID, 
			[First Name],
			[Last Name],
			Email,
			Phone,
			[Identity],
			[Household income],
			[Age Range],
			[Is Lawyer],
			[Is Landlord], 
			[Is Tenant],
			[Role],
			[Province],
			[Gender identity]
		) 
	VALUES(
			@count,
			@disputecount, 
			@firstname, 
			@lastname, 
			@email, 
			@phone, 
			@randIdentity, 
			@randIncome, 
			@randAge, 
			@randIsLawyer, 
			@randIsLandlord, 
			@randIsTenant,
			'applicant',
			@randProv,
			@randGenderIdentity)

   SET @count = @count + 1
   SET @disputecount = @disputecount + 1

End