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