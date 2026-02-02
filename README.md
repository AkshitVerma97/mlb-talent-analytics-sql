# mlb-talent-analytics-sql
Optimizing player recruitment strategies using Advanced SQL (Window Functions) and AWS Cloud Data Management

# MLB Talent Analytics: Identifying Consistent Performers via SQL
![SQL](https://img.shields.io/badge/Skill-Advanced_SQL-orange?style=for-the-badge&logo=mysql&logoColor=white)
![Azure Data Studio](https://img.shields.io/badge/Tool-Azure_Data_Studio-0078D4?style=for-the-badge&logo=azure-data-studio&logoColor=white)

> **Timeline:** Spring 2025
> **Role:** Data Analyst (Data Modeling & Optimization)
> **Tech Stack:** SQL (Window Functions, CTEs), AWS RDS (Hosted Instance), Azure Data Studio

---

## The Business Question
**"How do we distinguish between a 'One-Hit Wonder' and a consistent high-performer when analyzing multi-year player data?"**

Raw season data is volatile. A player might have one breakout year followed by a slump. To build a reliable recruitment strategy, the team needed to smooth out this volatility and identify players with **sustained performance** over a 5-year period.

---

## Key Technical Solutions

### 1. Smoothing Volatility with Window Functions
I avoided simple averages (which hide trends) and instead engineered a **Rolling 3-Year Moving Average** using SQL Window Functions ('OVER', 'PARTITION BY').
* **Impact:** This metric successfully filtered out players with high variance, highlighting only those with stable, appreciating value.

### 2. The "Master Player View" (Data Modeling)
The raw data was fragmented across multiple tables (Salaries, Batting Stats, Biodata).
**Solution:** Constructed a unified 'Player_History' view using **Complex Joins** and **CTEs** to consolidate dimensions.
**Result:** Reduced query time for the analytics team by denormalizing frequently accessed data into a single source of truth.

### 3. Remote Cloud Execution (AWS RDS)
Instead of working on a static local file, I connected to a live **AWS RDS** instance via **Azure Data Studio**. This simulated a real-world production environment where analysts must query a centralized, remote server.

---

## Repository Structure
This project is modularized into three analytical scripts, each addressing a specific aspect of the data pipeline:

* **src/01_master_data_view.sql**: Data Engineering script constructing a unified 'Player_History' view from 5+ raw tables using CTEs.
* **src/02_valuation_modeling.sql**: Financial analysis script calculating **3-Year Rolling Averages** to smooth salary volatility.
* **src/03_reporting_automation.sql**: Utility scripts using **Recursive CTEs** and **PIVOT** tables to automate dashboard reporting.

---

## Analytical Output 
*The query below demonstrates the use of Window Functions to smooth out salary volatility, allowing us to see the true trend (Moving Average) vs. the noise (Raw Average).*

![Moving Average Trend](https://github.com/AkshitVerma97/mlb-talent-analytics-sql/blob/8dcf7c89a6c43c1e63710c6ea54071d500566a10/assets/images/moving%20avg%20output%20(1).JPG)

*(Figure 1: Result set showing how the 3-Year Rolling Average smooths year-over-year variance)*

---

## Automation Logic (Recursive CTEs)
*To support the reporting dashboard, I engineered a Recursive Common Table Expression (CTE) to automatically generate reporting timelines without needing a physical calendar table.*

![Recursive CTE Output](https://github.com/AkshitVerma97/mlb-talent-analytics-sql/blob/8dcf7c89a6c43c1e63710c6ea54071d500566a10/assets/images/recursive%20cte%20output.JPG)

*(Figure 2: Dynamic generation of reporting periods using SQL recursion)*

---

## Technical Appendix: SQL Skills Used
* **Window Functions:** 'AVG(salary) OVER (PARTITION BY player_id ...)'
* **Recursive CTEs:** 'WITH MonthsOfYear AS (...)' to generate temporal data.
* **Joins:** Complex 'LEFT JOIN' logic to merge Batting, Pitching, and Salary tables.
* **Tools:** Executed in Azure Data Studio; Source Control managed via VS Code.
