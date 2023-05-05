DECLARE @start DATE = '2000-01-01'
DECLARE @end DATE = '2021-12-31'
DECLARE @final DATE;

Declare @count int
Set @count = 101

Declare @randStatus varchar(100)
Declare @randStatusInt int

Declare @randStage varchar(100)
Declare @randStageInt int

Declare @randType varchar(100)
Declare @randTypeInt int

Declare @randFeeInt int
Declare @randFee int

While @count <= 100000
Begin 

	SELECT @final = DATEADD(DAY,ABS(CHECKSUM(NEWID())) % ( 1 + DATEDIFF(DAY,@start,@end)),@start)
		
	set @randFeeInt = ROUND(RAND()*9,0)+1
	Select @randFee = CHOOSE(@randFeeInt, 100,200,300,400,500,600,700,800,900,1000);

	set @randStatusInt = ROUND(RAND()*2,0)+1
	Select @randStatus = CHOOSE(@randStatusInt, 'open','closed','on-hold');

	set @randStageInt = ROUND(RAND()*5,0)+1
	Select @randStage = CHOOSE(@randStageInt, 'application','screening','dn issued', 'negotiation', 'facilitation', 'adjudication');

	set @randTypeInt = ROUND(RAND()*9,0)+1
	Select @randType = CHOOSE(@randTypeInt, 'vehicle injury','employment','general small claim', 'goods or services', 'housing', 'loans and debts', 'personal injury', 'property dispute', 'residential contruction', 'strata');

	INSERT INTO [dbo].Dispute(ID, [Type], [Status], [Stage], CloseDate, [Fees Collected]) 
	VALUES(@count, @randType, @randStatus, @randStage, @final, @randFee)

   Set @count = @count + 1
End

