/* What skills are required for the top-paying data analysts job?
- Identify the top 10 highest-paying Data Analyst jobs and the specific skills required for these roles.
- Filters for roles with specified salaries that are offered in WA & OR
- Why? Provides a detailed look at which high-paying jobs demand certain skills, helpihng me understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs AS 
(
    SELECT
    job_id,
    job_title,
    name as comapny_name,  
    salary_year_avg   
    FROM company_dimjob_postings_fact
    LEFT JOIN company_dim on job_postings_fact.company_id=company_dim.company_id
    WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_location = 'Anywhere'    
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.job_id,
    job_title,
    salary_year_avg,
    skills_dim.skills as skill_required
FROM
   top_paying_jobs
INNER JOIN
    skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
 ORDER BY
    salary_year_avg DESC;


/* Insights: two programing languages top the list
- SQL is the top skill with 8 count
- Python is a close second with 7
- Tableau is next with 6
- R follows with a count of 4
*/