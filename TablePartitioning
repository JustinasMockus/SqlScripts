--Table partitioning
--Create partition function
	IF NOT EXISTS (SELECT * FROM sys.partition_functions WHERE name = N'fn_PartitioningFunction')
	CREATE PARTITION FUNCTION [fn_PartitioningFunction] ([datetime2] (6)) 
	AS RANGE RIGHT 
	FOR VALUES (N'2019-01-01 00:00:00.000000', N'2019-01-02 00:00:00.000000', N'2019-01-03 00:00:00.000000')

--Create partition schema	
	IF NOT EXISTS (SELECT * FROM sys.partition_schemes WHERE name = N'PS_PartitonSchema')
	CREATE PARTITION SCHEME [PS_PartitonSchema] 
	AS PARTITION [fn_PartitioningFunction] 
	ALL TO ([DEFAULT])

--Create partitioned table
	DROP TABLE IF EXISTS [dbo].[Table]
	CREATE TABLE [dbo].[Table]
	(
	[Id] [INT] NOT NULL,
	[Column2] [DATE] NOT NULL
	) ON [PS_PartitonSchema] ([Column2])

--Partitioned index
	CREATE CLUSTERED COLUMNSTORE INDEX [CCX_Table_Column2] ON [dbo].[Table] ON [PS_PartitonSchema] ([Column2])

--Sliding window partitioning for new ranges
--How to Implement an Automatic Sliding Window in a Partitioned Table on SQL Server 
--https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2005/administrator/aa964122(v=sql.90)
