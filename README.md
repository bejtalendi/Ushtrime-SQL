# 📊 Data Analyst Job Market Analysis (SQL Project)

## 🔍 Project Overview

This project explores the 2023 Data Analyst job market using SQL, focusing on:

* 💰 Top-paying remote Data Analyst jobs
* 🛠️ Most in-demand skills
* 📈 Skills associated with higher salaries
* 🎯 Optimal skills (high demand + high pay)

All analyses were performed using PostgreSQL on a structured job postings database.

---

## 📁 Project Queries

### 1️⃣ Top Paying Jobs

Identifies the 10 highest-paying remote Data Analyst positions.

```sql
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```

---

### 2️⃣ Top Paying Job Skills

Shows which skills are required for the highest-paying Data Analyst roles.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```

---

### 3️⃣ Top Demanded Skills

Finds the 5 most frequently requested skills for remote Data Analyst roles.

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```

---

### 4️⃣ Top Paying Skills

Lists the 25 skills associated with the highest average salaries.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25;
```

---

### 5️⃣ Optimal Skills

Identifies skills that are both highly demanded and highly paid.

```sql
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
        job_title_short = 'Data Analyst'
        AND job_work_from_home = TRUE
        AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
),
average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM skills_demand
INNER JOIN average_salary
    ON skills_demand.skill_id = average_salary.skill_id
WHERE demand_count > 10
ORDER BY avg_salary DESC, demand_count DESC
LIMIT 25;
```

---

# 📈 Key Insights

## 💰 Top Paying Remote Data Analyst Jobs

| Job Title                        | Company    | Average Salary |
| -------------------------------- | ---------- | -------------- |
| Data Analyst                     | Mantys     | $650,000       |
| Director of Analytics            | Meta       | $336,500       |
| Associate Director, Data Analyst | AT&T       | $255,000       |
| Data Analyst                     | Pinterest  | $232,000       |
| Principal Data Analyst           | CVS Health | $216,500       |

---

## 🔥 Most Demanded Skills

| Rank | Skill    | Demand Count |
| ---- | -------- | ------------ |
| 1    | SQL      | 7,291        |
| 2    | Excel    | 4,611        |
| 3    | Python   | 4,330        |
| 4    | Tableau  | 3,745        |
| 5    | Power BI | 2,609        |

---

## 💵 Highest Paying Skills

| Rank | Skill     | Average Salary |
| ---- | --------- | -------------- |
| 1    | PySpark   | $208,000       |
| 2    | Bitbucket | $189,000       |
| 3    | Couchbase | $160,000       |
| 4    | Watson    | $160,000       |
| 5    | DataRobot | $155,000       |

---

## 🎯 Optimal Skills (High Demand + High Pay)

| Skill      | Demand Count | Avg Salary |
| ---------- | ------------ | ---------- |
| Go         | 27           | $115,320   |
| Confluence | 11           | $114,210   |
| Hadoop     | 22           | $113,193   |
| Snowflake  | 37           | $112,948   |
| Azure      | 34           | $111,225   |
| BigQuery   | 13           | $109,654   |
| AWS        | 32           | $108,317   |
| Tableau    | 230          | $99,288    |
| SQL        | 398          | $97,237    |
| Python     | 236          | $97,236    |

---

# 🛠️ Technologies Used

* PostgreSQL – Database management and querying
* VS Code – SQL script development
* Git & GitHub – Version control and project hosting

---

# 📂 Database Schema

The analysis uses four main tables:

### `job_postings_fact`

Contains job posting information including salaries, job titles, locations, and posting dates.

### `company_dim`

Contains company details.

### `skills_dim`

Contains unique skill names.

### `skills_job_dim`

Bridge table connecting jobs and skills (many-to-many relationship).

---

# 🚀 How to Run

1. Clone this repository.
2. Import the provided CSV files into PostgreSQL.
3. Execute the SQL scripts.
4. Modify filters such as:

   * `job_title_short`
   * `job_location`
   * `job_work_from_home`

to explore other roles, locations, and career paths.

---

# 📌 Future Improvements

* Create an interactive Power BI dashboard
* Compare remote vs on-site salaries
* Expand analysis to:

  * Data Scientist roles
  * Data Engineer roles
* Add time-series analysis for skill demand trends
* Include geographic salary comparisons

---

# 👨‍💻 About the Author

**Lendi Bejta**

Aspiring Data Analyst passionate about:

* SQL
* Business Intelligence
* Data Visualization
* Labor Market Analytics

Feel free to connect, provide feedback, or explore the project.

<a href = " LinkedIn">www.linkedin.com/in/lendi-bejta-7b06253a2<a>