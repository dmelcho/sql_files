/* What are the most in-dmeand skills for data analyst?
- identify the top 5 in-demand skills for data analyst by:
- joining job postings fact table with our skill dim and skill job dim tables
- why? we want to retreive the most valuable skills for job seekers
*/

SELECT
    skills_dim.skills as skills,
    COUNT(job_postings_fact.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;


