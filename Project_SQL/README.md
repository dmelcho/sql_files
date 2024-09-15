# Introduction
Welcome to my SQL Portfolio Project, where I delve into the data job market with a focus on data analyst roles. This project is a personal exploration into identifying the top-paying jobs, in-demand skills, and where high demand skills meet high compensation for data analyst jobs.

Check out my SQL queries here [Project_SQL](/Project_SQL/)

## Background
This projects stems from a better understanding to the ever changing data job market. I want to know what skills are on high demand and have high salaries. This will help my job search be more targeted and effective.

The data for this analysis is from [Barousse’s SQL Course](https://www.lukebarousse.com/sql). This data includes details on job titles, salaries, locations, and required skills. 

The questions I wanted to tackle using my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn for a data analyst looking to maximize job market value?
## Tools I Used
In this project, I utilized a variety of tools to conduct my analysis:

- **SQL** (Structured Query Language): Enabled me to interact with the database, extract insights, and answer my key questions through queries.
- **PostgreSQL**: As the database management system, PostgreSQL allowed me to store, query, and manipulate the job posting data.
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.
- **Git & GitHub**: For version control and sharing my SQL scripts and analysis. Ensuring collaboration and project tracking.
## The Analysis
Each of the following questions aimed to get a better understanding of thee data analysis job market. Questions are all relevant to each other, ultimately finding actionable insights.

### 1. Top Paying Data Analyst Jobs
I filtered data analyst position by average yearly salary and location. Then, I joined the job postings fact and company dim tables. This query highlights high paying jobs in the field.

```sql
SELECT
    job_id,
    name as company_name,
    job_title,    
    job_location,    
    job_schedule_type,
    salary_year_avg
FROM 
    job_postings_fact
LEFT JOIN
    company_dim on job_postings_fact.company_id=company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_location = 'Anywhere'    
ORDER BY 
    salary_year_avg DESC
LIMIT 10;
```
A list of the top jobs:


| Job Title                                     | Company Name                       |  Salary Year Avg |
|-----------------------------------------------|------------------------------------|------------------|
| Data Analyst                                  | Mantys                             |  650,000          |
| Director of Analytics                         | Meta                               |  336,500          |
| Associate Director- Data Insights             | AT&T                               | 255,830         |
| Data Analyst, Marketing                       | Pinterest Job Advertisements       | 232,423           |
| Data Analyst (Hybrid/Remote)                 | Uclahealthcareers                   |  217,000          |
| Principal Data Analyst (Remote)              | SmartAsset                          |  205,000          |
| Director, Data Analyst - HYBRID              | Inclusively                         |  189,309          |
| Principal Data Analyst, AV Performance Analysis| Motional                          | 189,000           |
| Principal Data Analyst                        | SmartAsset                         | 186,000           |
| ERM Data Analyst                             | Get It Recruit - Information Technology | 184,000           |


### 2. Skills for Top Paying Jobs
To understand what skills are needed for high compensated jobs I used my previous query as a CTE and joined it with the skills dim and skill job dim table to identify the skills required for each job. This provided insights into what employers value for high compensation roles.

```sql
WITH top_paying_jobs AS 
    (SELECT
    job_id,
    job_title,
    name as company_name,  
    salary_year_avg   
    FROM job_postings_fact
    LEFT JOIN company_dim on job_postings_fact.company_id=company_dim.company_id
    WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_location = 'Anywhere'    
    ORDER BY salary_year_avg DESC
    LIMIT 10)

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
```
Top Results
|Skill Count | Skill |
|:---:|:---:|
|8	|sql|
|7	|python|
|6	|tableau|
|4	|r|
### 3. In-Demand Skills for Data Analysts
The last two queries helped me identify high paying and in demand roles. Now I want to be more specific and find the top skills for a data analyst. Again, the emphasis is understanding the skills one needs to be competitive.
```sql
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
```
![Top skills](/Project_SQL\SQL_project_data_viz/3_In%20Demand%20Skills.png)
### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying. This can be a guide to my learning path for new skills in data analysis.
```sql
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
```
![Top Paying In Demand Skills](/Project_SQL\SQL_project_data_viz/4_Top%20Paying%20Skill.png)
### 5. Most Optimal Skill to Learn
I combined my previous findings, high paying roles and demand data, to identify what skills are in high demand and have high salaries. As a job seeker this will help me figure out skills that employers place high value in.
```sql
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
    LIMIT 20;
```
![Optimal Skills](/Project_SQL/SQL_project_data_viz/5_Optimal%20Skills.png)

Each of the queries enabled me to understand the competitive Data Analytics job market better and offered a focused path for career advancement. Furthermore, throughout the project I had a chance to sharpen my SQL skills by leveraging its powerful data manipulation capabilities to derive meaningful insights from complex data sets. 
## Insights
From the analysis several general conclusions can be made:
### 1. Top Paying Jobs: 
A wide range of salaries offered for Data Analyst remote jobs, with $650,000 being the highest!
### 2. Skills for Top Paying Jobs: 
SQL was regarded as the top paying skill for a Data Analyst. Highlighting the importance in SQL proficiency.
### 3. Most In-Demand Skills:
Toping the list, again, is SQL. Further identifying it as a critical Data Analyst skill to have.
### 4. Skills with High Salaries:
There are several specialized tools, such as SVN and Solidity. These require proficiency in SQL, Python, and R that equate to high job compensation.
### 5. Optimal Skills for Job Market Value:
Here we see several data base management tools that are both in demand and high compensating. All of these have one thing in common: they can be navigated through the SQL expertise. This further reflects SQL as one of the most optimal skills for Data Analyst to learn and to maximize our market value.
## What I Learned
Through this project, I exercised several key SQL techniques and skills:
- Practice SQL: Enhance my ETL skills by actively practicing SQL, while consistently applying an analytical mindset throughout this analysis. 
- Complex Query Construction/Data Aggregation: Utilizing GROUP BY and aggregate functions like COUNT() and AVG() to summarize data effectively. Further implementing them with more advance queries like JOINS and CTEs for deep dive analysis.
- Analytical Thinking: Understanding my project goal and the data that I was working with enabled me to translate real-world questions into actionable SQL queries giving me insightful answers.
# Conclusions
In this project I discover some of the most important skills needed for Data Analyst jobs. This was accomplish by identify the top skills highly valued by employers. Utilizing SQL to write practical queries I was able to extract valuable insights. As an aspiring Data Analyst, seeing the importance of SQL will help pave the path forward be considered a strong candidate. As I look to continue my learning and adapting to emerging trends in the field of data analytics, I will ensure that database management languages, like SQL and Python, are at the top of my priority list.

