WITH required_skills as
        (
        SELECT
            sjd.job_id,
            jpf.company_id,
            count(DISTINCT sjd.skill_id) as unique_skills
        FROM
            skills_job_dim as sjd
        LEFT JOIN
        job_postings_fact as jpf ON sjd.job_id = jpf.job_id
         GROUP BY
           jpf.company_id, sjd.job_id
        ),
max_salary as (
        SELECT
            job_id, 
            company_id,
            max(salary_year_avg) as max_salary
        FROM
            job_postings_fact as jpf
        WHERE
            job_id in ((SELECT job_id FROM skills_job_dim))
        GROUP BY
            company_id, job_id
                )

SELECT
    cd.name as company,
    rs.unique_skills,
    ms.max_salary
FROM
    company_dim as cd
LEFT JOIN
    max_salary as ms on cd.company_id = ms.company_id
LEFT JOIN
    required_skills as rs on ms.job_id = rs.job_id
ORDER BY
    company
LIMIT 10




WITH required_skills AS (
  SELECT
    companies.company_id,
    COUNT(DISTINCT skills_to_job.skill_id) AS unique_skills_required
  FROM
    company_dim AS companies 
  LEFT JOIN job_postings_fact as job_postings ON companies.company_id = job_postings.company_id
  LEFT JOIN skills_job_dim as skills_to_job ON job_postings.job_id = skills_to_job.job_id
  GROUP BY
    companies.company_id
LIMIT 100
),
-- Gets the highest average yearly salary from the jobs that require at least one skills 
max_salary AS (
  SELECT
    job_postings.company_id,
    MAX(job_postings.salary_year_avg) AS highest_average_salary
  FROM
    job_postings_fact AS job_postings
  WHERE
    job_postings.job_id IN (SELECT job_id FROM skills_job_dim)
  GROUP BY
    job_postings.company_id
)
-- Joins 2 CTEs with table to get the query
SELECT
  companies.name,
  required_skills.unique_skills_required as unique_skills_required, --handle companies w/o any skills required
  max_salary.highest_average_salary
FROM
  company_dim AS companies
LEFT JOIN required_skills ON companies.company_id = required_skills.company_id
LEFT JOIN max_salary ON companies.company_id = max_salary.company_id
ORDER BY
	companies.name
LIMIT 10;