/*
  SCRIPT: 03_reporting_automation.sql
  AUTHOR: Akshit Verma
  PURPOSE: Automating temporal data generation and cross-tabulation for dashboards.
  TECHNIQUES: Recursive CTEs for timeline generation; PIVOT tables for year-over-year comparison.
*/

-- MODULE 1: Automated Reporting Timeline Generator (Recursive CTE)
-- Generates a dynamic 12-month reporting period without needing a physical calendar table.
WITH MonthsOfYear(Month_Number, Month_Name) AS (
    SELECT 
        1 AS Month_Number, 
        DATENAME(MONTH, DATEFROMPARTS(2025, 1, 1)) AS Month_Name
    UNION ALL
    SELECT 
        Month_Number + 1 AS Month_Number, 
        DATENAME(MONTH, DATEFROMPARTS(2025, Month_Number + 1, 1)) AS Month_Name
    FROM MonthsOfYear
    WHERE Month_Number < 12
) 
SELECT * FROM MonthsOfYear;


-- MODULE 2: Historical Performance Pivot (Cross-Tabulation)
-- Transposes row-based stats into a column-based matrix for Executive Dashboards.
SELECT 
    teamID,
    [1995], [1996], [1997], [1998], [1999], 
    [2018], [2019], [2020], [2021], [2022]
FROM 
    (SELECT teamID, yearID, hr
     FROM batting
     WHERE yearID IN (1995, 1996, 1997, 1998, 1999, 
                      2018, 2019, 2020, 2021, 2022) 
    ) AS SourceTable
PIVOT
    (SUM(hr) FOR yearID IN ([1995], [1996], [1997], [1998], [1999], 
                            [2018], [2019], [2020], [2021], [2022])) AS PivotedTable;