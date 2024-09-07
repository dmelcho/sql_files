/*What are the top skillls based on salary?
- Find the average salary associated with each skill for Data Analyst positions
- focus on roles with specified salary, regardless of location
- Why? This will help us identify how different skills impact salary levels
    it helps identify the most financially rewarding skills to aquire and improve
*/

SELECT
    skills_dim.skills as skills,
    ROUND(AVG(job_postings_fact.salary_year_avg))AS avg_salary
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;

/* Insights:
- There are a lot of specialzed skills that require SQL, Python, and R
- Big Data and ML skills have the top salaries. This highlights industries high
  valuation of data processing and predictive modeling capabilites
- there is a growing importance of clous-based analytics enviroments
  suggesting that cloud proficiency significantly boos earning potential
*/