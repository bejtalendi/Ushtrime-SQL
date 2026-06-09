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