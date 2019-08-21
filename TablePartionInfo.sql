--Table partitioning info

SELECT 
	SH.name AS [SchemaName],
	T.name AS [TableName],
	S.name AS [PartitionSchema],
	I.name AS [IndexName],
	P.partition_number,
	--P.partition_id,
	--I.data_space_id,
	--F.function_id, 
	f.name [PartitionFunctionName],
	f.type_desc,
	r.boundary_id,
	r.value AS BoundaryValue,
	p.[rows]
FROM sys.tables AS T 
	JOIN sys.schemas AS SH ON T.[schema_id] = SH.[schema_id] 
	JOIN sys.indexes AS I ON T.object_id = I.object_id  
	JOIN sys.partitions AS P ON I.object_id = P.object_id AND I.index_id = P.index_id   
	JOIN  sys.partition_schemes AS S ON I.data_space_id = S.data_space_id  
	JOIN sys.partition_functions AS F ON S.function_id = F.function_id  
	LEFT JOIN sys.partition_range_values AS R ON F.function_id = R.function_id and R.boundary_id = P.partition_number
WHERE t.name = ''
	AND t.type = 'U'
ORDER BY 1, 2, 5
