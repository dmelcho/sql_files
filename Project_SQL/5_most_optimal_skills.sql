/* What are the most optimal skills to learn for Data Analyst jobs?
- Identify skills in high demand and associated with high salaires for DA
- Concentrate on remote positions with specified salary
- This will help us target skills that offer job security and financial benefits
    offering strategic benefits for career development in DA
*/

  SELECT 
        skills_dim.skill_id as skill_id,
        skills_dim.skills as skills,
        COUNT(job_postings_fact.job_id) AS demand_count,
        ROUND(AVG(job_postings_fact.salary_year_avg),2) as average_salary
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN 
        skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_postings_fact.job_work_from_home = True
    GROUP BY
        skills_dim.skill_id,
        skills_dim.skills
    HAVING
        COUNT(job_postings_fact.job_id) > 10
    ORDER BY
    average_salary DESC,
    demand_count DESC
    LIMIT 20