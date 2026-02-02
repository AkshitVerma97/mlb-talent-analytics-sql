/*
  SCRIPT: 01_master_data_view.sql
  AUTHOR: Akshit Verma
  PURPOSE: Constructing a unified 'Master Player View' for the analytics team.
  METHODOLOGY: 
    1. Utilizes Common Table Expressions (CTEs) to pre-aggregate Batting, Pitching, and Salary data.
    2. Implements LEFT JOIN logic to preserve player records even with missing sub-data.
    3. Calculates derived metrics (e.g., Career Batting Average, Total 401K) at the source level.
*/

IF OBJECT_ID('Player_History', 'V') IS NOT NULL
    DROP VIEW Player_History;
GO

CREATE VIEW Player_History AS
WITH pep AS (
    -- Base Player Information
    SELECT playerid, dbo.fullname(playerid) AS full_name, Total_401K
    FROM People
),
Bat AS (
    -- Aggregated Batting Statistics
    SELECT playerid, 
           COUNT(DISTINCT yearid) AS num_years, 
           COUNT(DISTINCT teamID) AS num_teams, 
           SUM(HR) AS runs, 
           SUM(h*1.0)/NULLIF(SUM(ab*1.0),0) AS career_BA, 
           MAX(yearid) AS max_appear, 
           MIN(yearid) AS first_appear
    FROM batting
    WHERE ab > 0 OR ab IS NOT NULL
    GROUP BY playerid
    HAVING (SUM(AB) > 0)
),
Sal AS (
    -- Salary Analysis (Min, Max, Growth)
    SELECT playerid, 
           SUM(salary) AS tot_sal, 
           AVG(salary) AS avg_sal, 
           MIN(salary) AS Min_Salary, 
           MAX(salary) AS Max_salary,
           (MAX(salary)-MIN(salary)*1.0)/NULLIF(MAX(salary),0) AS Perct_Incr
    FROM salaries
    GROUP BY playerid
),
Col AS (
    -- Educational Background
    SELECT playerid, 
           MAX(yearid) AS max_col, 
           COUNT(DISTINCT schoolid) AS num_schools
    FROM collegeplaying
    GROUP BY playerid 
),
Pit_Metrics AS (
    -- Advanced Pitching Metrics (Power Finesse Ratio)
    SELECT playerid, 
           SUM(SO + BB*1.0)/NULLIF(SUM(IPouts/3.0),0) AS car_PFR
    FROM pitching
    WHERE IPOuts > 0
    GROUP BY playerid 
    HAVING SUM(IPouts) > 0
), 
HallOfFame_Status AS (
    -- Hall of Fame Induction Status
    SELECT playerid, 
           COUNT(inducted) AS icount
    FROM HallofFame
    WHERE inducted = 'Y'
    GROUP BY playerid
)

-- Final Consolidation Join
SELECT pep.playerid, full_name, Total_401K, num_years, num_teams, runs, career_ba, tot_sal, avg_sal, min_Salary, max_salary,
    perct_incr, Num_schools, max_col AS last_college_yr, first_appear, max_appear AS last_appear, car_pfr, 
    (CASE WHEN icount = 1 THEN 'Y' ELSE 'N' END) AS inducted
FROM pep 
    LEFT JOIN Bat ON pep.playerid = Bat.playerid
    LEFT JOIN Sal ON pep.playerid = Sal.playerID
    LEFT JOIN Col ON pep.playerid = Col.playerid
    LEFT JOIN Pit_Metrics ON pep.playerid = Pit_Metrics.playerid
    LEFT JOIN HallOfFame_Status ON pep.playerid = HallOfFame_Status.playerid;
GO