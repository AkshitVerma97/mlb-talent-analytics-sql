/*
  SCRIPT: 02_valuation_modeling.sql
  AUTHOR: Akshit Verma
  PURPOSE: Identifying consistent performers using Rolling Moving Averages.
  BUSINESS LOGIC: 
    Raw salary data is volatile. We use a 3-Year Rolling Window to identify 
    long-term valuation trends, filtering out "one-hit wonders."
*/

SELECT 
    teamID,
    yearID,
    FORMAT(Avg_Salaries.Avg_Salary, 'C') AS Average_Salary,
    
    -- THE CORE LOGIC: 3-Year Moving Average Calculation
    FORMAT(AVG(Avg_Salaries.Avg_Salary) 
           OVER(PARTITION BY teamid 
                ORDER BY yearID 
                ROWS BETWEEN 3 PRECEDING AND 1 FOLLOWING), 'C'
          ) AS Rolling_3yr_Moving_Avg
FROM     
    (
     -- Subquery to aggregate raw salary data first
     SELECT 
        teamID, 
        yearID, 
        AVG(salary) AS Avg_Salary
     FROM Salaries
     GROUP BY teamID, yearID
    ) AS Avg_Salaries;