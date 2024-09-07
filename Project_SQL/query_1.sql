---delete this later
SELECT *
FROM job_postings_fact
WHERE salary_hour_avg > 700000
LIMIT 1000
--remember that we have to commit our changes and then we have to sync changes 
--this is all done in the 