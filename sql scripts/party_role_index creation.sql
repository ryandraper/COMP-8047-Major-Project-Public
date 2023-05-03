/*
Missing Index Details from 
The Query Processor estimates that implementing the following index could improve the query cost by 99.9276%.
*/


USE [digital-justice-2023]
GO
CREATE NONCLUSTERED INDEX [Party_Role_Index]
ON [dbo].[Party] ([Role],[DisputeID])

GO

