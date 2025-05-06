/*
Pivot and unpivot
 
Prompt for an AI tool:
Act as a Microsoft T-SQL expert. Table Message has column Category (varchar), Region (varchar), Movement (int).
There are four unique values in the Region column: North, South, East and West
Write the SQL to pivot the table.  
The resulting dataset should have columns: Category, North, South, East and West
 
Then write the SQL to unpivot the pivoted table back to the original table.
*/
-- The sample data
SELECT
	m.Category
	,	m.Region
	,	m.Movement
FROM
	Message m;
 
-- Pivot by Region
SELECT
	[Category]
	, [North]
	, [East]
	, [South]
	, [West]
FROM
	(
	SELECT
		m.Category
		, m.Region
		, m.Movement
	FROM
		Message m) temp_table
PIVOT
(
    SUM(Movement)
    FOR Region IN (North, East, South, West)
) AS pivot_table
 
 
-- the long way to pivot
 
SELECT
	m.Category
	, SUM(CASE WHEN m.Region = 'North' THEN m.Movement ELSE NULL END) AS NorthMovement
	, SUM(CASE WHEN m.Region = 'South' THEN m.Movement ELSE NULL END) AS SouthMovement
	, SUM(CASE WHEN m.Region = 'East' THEN m.Movement ELSE NULL END) AS EastMovement
	, SUM(CASE WHEN m.Region = 'West' THEN m.Movement ELSE NULL END) AS WestMovement
FROM
	Message m
GROUP BY
	m.Category;
 
 
-- Create a  pivoted temporary table so can unpivot later
DROP TABLE IF EXISTS #PivotMessageTable;
 
SELECT
	[Category]
	, [North]
	, [East]
	, [South]
	, [West]
INTO
	#PivotMessageTable
FROM
	(
	SELECT
		m.Category
		, m.Region
		, m.Movement
	FROM
		Message m) temp_table
PIVOT
(
    SUM(Movement)
    FOR Region IN (North, East, South, West)
) AS pivot_table;
 
SELECT
	*
FROM
	#PivotMessageTable;
 
-- Unpivot this table to get back to the original table
SELECT
	Category
	, Region
	, Movement
FROM
	#PivotMessageTable
UNPIVOT
(
    Movement FOR Region IN (North, East, South, West)
) AS unpivot_table
 
-- An alternative way to unpivot not using the UNPIVOT keyword
SELECT 	Category, North AS Movement FROM #PivotMessageTable
UNION ALL
SELECT 	Category, South AS Movement FROM #PivotMessageTable
UNION ALL
SELECT 	Category, East AS Movement FROM #PivotMessageTable
UNION ALL
SELECT 	Category, West AS Movement FROM #PivotMessageTable