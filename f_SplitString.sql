CREATE FUNCTION [dbo].[f_SplitString]
	(@pString VARCHAR(8000), @pDelimiter CHAR(1))
--DO NOT USE MAX DATA-TYPES HERE! IT WILL KILL PERFORMANCE!
RETURNS TABLE WITH SCHEMABINDING AS
 RETURN
  WITH E1(N) AS (
                 SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL
                 SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL
                 SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
                ),                         
       E2(N) AS (SELECT 1 FROM E1 a, E1 b),
       E4(N) AS (SELECT 1 FROM E2 a, E2 b), 
cteTally(N) AS (
                 SELECT TOP (ISNULL(DATALENGTH(@pString),0)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM E4
                ),
cteStart(N1) AS (
                 SELECT 1 UNION ALL
                 SELECT t.N+1 FROM cteTally t WHERE SUBSTRING(@pString,t.N,1) = @pDelimiter
                ),
cteLen(N1,L1) AS(
                 SELECT s.N1,
                        ISNULL(NULLIF(CHARINDEX(@pDelimiter,@pString,s.N1),0)-s.N1,8000)
                   FROM cteStart s
                )
--===== Do the actual split. The ISNULL/NULLIF combo handles the length for the final element when no delimiter is found.
SELECT ItemNumber = ROW_NUMBER() OVER(ORDER BY l.N1),
       DataItem = SUBSTRING(@pString, l.N1, l.L1)
FROM cteLen l;

--Source: www.sqlservercentral.com/articles/Tally+Table/72993/
