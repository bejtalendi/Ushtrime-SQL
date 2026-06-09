
# 📊 Data Analyst Job Market Analysis (SQL Project)

## 🔍 Project Overview

This project explores the **2023 Data Analyst job market** using SQL, focusing on:

- 💰 **Top-paying remote jobs**
- 🛠️ **Most in-demand skills**
- 📈 **Skills associated with higher salaries**
- 🎯 **Optimal skills** (high demand + high pay)

All queries are written in **PostgreSQL** and executed on a structured job postings database.

---

## 📁 Files & Queries

### 1️⃣ Top Paying Jobs
*Identifies the 10 highest-paying remote Data Analyst positions.*

```sql
SELECT 
    JOB_ID,
    JOB_TITLE,
    JOB_LOCATION,
    JOB_SCHEDULE_TYPE,
    SALARY_YEAR_AVG,
    JOB_POSTED_DATE,
    name AS company_name
FROM 
    JOB_POSTINGS_FACT
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    JOB_TITLE_SHORT = 'Data Analyst' AND
    JOB_LOCATION = 'Anywhere' AND
    SALARY_YEAR_AVG IS NOT NULL    
ORDER BY
    SALARY_YEAR_AVG DESC    
LIMIT 10
2️⃣ Top Paying Job Skills
Shows which skills are required for the highest-paying roles.

sql
WITH top_paying_jobs AS (
    SELECT 
        JOB_ID,
        JOB_TITLE,
        SALARY_YEAR_AVG,
        name AS company_name
    FROM 
        JOB_POSTINGS_FACT
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        JOB_TITLE_SHORT = 'Data Analyst' AND
        JOB_LOCATION = 'Anywhere' AND
        SALARY_YEAR_AVG IS NOT NULL    
    ORDER BY
        SALARY_YEAR_AVG DESC    
    LIMIT 10  
)    
SELECT 
    top_paying_jobs.*,
    skills 
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    SALARY_YEAR_AVG DESC;
3️⃣ Top Demanded Skills
Finds the 5 most frequently requested skills for remote Data Analyst roles.

sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'  AND 
    job_work_from_home = TRUE    
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
4️⃣ Top Paying Skills
Lists the 25 skills with the highest average salary for remote positions.

sql
SELECT
    skills,
    ROUND (AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL 
    AND job_work_from_home = TRUE    
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
5️⃣ Optimal Skills
Identifies skills with both high demand (>10 postings) AND high average salary.

sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'  AND 
        job_work_from_home = TRUE    
         AND salary_year_avg IS NOT NULL 
    GROUP BY
        skills_dim.skill_id
), average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND (AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL 
        AND job_work_from_home = TRUE    
    GROUP BY
        skills_job_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM 
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id 
WHERE 
    demand_count > 10    
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
📈 Key Insights Summary
💰 Top Paying Jobs
Highest paying remote Data Analyst role pays $650,000 (Mantys)

Director of Analytics at Meta: $336,500

Associate Director at AT&T: $255,000

Data Analyst at Pinterest: $232,000

Principal Data Analyst at CVS Health: $216,500

🔥 Most Demanded Skills (Remote)
Rank	Skill	Demand Count
1	SQL	7,291
2	Excel	4,611
3	Python	4,330
4	Tableau	3,745
5	Power BI	2,609
💵 Highest Paying Skills
Rank	Skill	Average Salary
1	PySpark	$208,000
2	Bitbucket	$189,000
3	Couchbase	$160,000
4	Watson	$160,000
5	DataRobot	$155,000
🎯 Optimal Skills (High Demand + High Pay)
Skill	Demand Count	Avg Salary
Go	27	$115,320
Confluence	11	$114,210
Hadoop	22	$113,193
Snowflake	37	$112,948
Azure	34	$111,225
BigQuery	13	$109,654
AWS	32	$108,317
Tableau	230	$99,288
SQL	398	$97,237
Python	236	$97,236
🛠️ Technologies Used
PostgreSQL – Database management & querying

VS Code – SQL script editing

Git & GitHub – Version control & portfolio hosting

📂 Database Schema
The analysis uses 4 main tables:

job_postings_fact – Job listings

company_dim – Company information

skills_dim – Unique skill names

skills_job_dim – Many-to-many bridge between jobs and skills

🚀 How to Run
Clone this repository

Import the provided CSV files into your PostgreSQL database

Run the SQL scripts in order (optional but recommended)

Modify filters (e.g., job_title_short, job_location) to explore other roles or regions

📌 Future Improvements
Add visualization (Power BI / Tableau dashboard)

Compare on-site vs remote salary differences

Expand analysis to Data Scientist or Data Engineer roles

Add time‑trend analysis for skill popularity

👨‍💻 About the Author
Lendi Bejta
Data Analyst passionate about SQL, business intelligence, and job market analytics.




