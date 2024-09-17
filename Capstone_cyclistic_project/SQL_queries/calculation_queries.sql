/* 
    Calculate the following for differences between members and casual users:
        --(note that we are running the same queries for each table)
    -avg time per member
    -avg time per month
    -weekday count per member type & rank each day
    -monthly ride count per member
    -station count per member type & identify each station's lat and long values
*/


--average trip for rider_data_q1 duration by member type and in minutes
SELECT 
    user_type,
    avg(rental_end_time-rental_start_time):: TIME AS avg_ride_duration
FROM 
    rider_data_q1
    --adjust table name as needed
WHERE 
    start_station_name != 'HQ QR'
    --do not include HQ station; this will skew ride duration
GROUP BY 
    user_type;

--average by month
SELECT 
    user_type,
    EXTRACT(month FROM from_start_time) AS month, 
    avg(end_time - start_time):: TIME AS avg_ride_duration
FROM 
    rider_data_q1
    --adjust table name as needed
WHERE 
    to_station_name != 'HUBBARD ST BIKE CHECKING (LBS-WH-TEST)'
    --do not include HQ station; this will skew ride duration
GROUP BY 
    user_type,
    month
ORDER BY
    month;

--finding the day count based on member type for rider_data_q1 table
--rank each day
WITH weekdays AS 
    (
    SELECT 
    user_type,
    to_char(start_time, 'FMDAY') AS day_of_week
    FROM 
    rider_data_q1
    --adjust table name as needed
    )
SELECT
    user_type,
    day_of_week,
    Count(day_of_week) AS day_count,
    Rank()Over(PARTITION BY user_type ORDER BY COUNT(day_of_week) DESC ) AS day_rank
FROM 
    weekdays
WHERE 
    user_type = 'Customer'
    --adjust member type here
GROUP BY     
    day_of_week,
    user_type
ORDER BY
    day_rank;


--extract the month & find time diff between member type
--finding the average time by member type for rider_data_q1 table
WITH month_table AS
    (
    SELECT
    EXTRACT(MONTH from end_time) AS end_month_time,
    user_type,
    (end_time-start_time)::time AS full_time_difference
    FROM 
    rider_data_q1
    --adjust table name as needed
    WHERE
    from_station_name != 'HUBBARD ST BIKE CHECKING (LBS-WH-TEST)'
    --do not include HQ station; this will skew ride duration
    )

SELECT 
    end_month_time,
    user_type,
    avg(full_time_difference)::TIME AS avg_ride_duration
FROM
    month_table
GROUP BY
    end_month_time,
    user_type
ORDER BY 
    end_month_time;

--calculating top 20 stations by member type
SELECT
    from_station_name AS station, 
    user_type AS member_type,
    Count(user_type) AS member_count, 
    RANK()Over(PARTITION BY user_type ORDER BY COUNT(user_type) DESC) AS station_rank
FROM 
    rider_data_q1
WHERE 
    from_station_name != 'HUBBARD ST BIKE CHECKING (LBS-WH-TEST)' 
    --do not include HQ station; this will skew ride duration
    AND user_type = 'Customer'
    --adjust the member type here
GROUP BY
    from_station_name,
    user_type
LIMIT 20;

--getting lat and long values for starting and end stations
--this will help creating a heat map showing for better visualization or our data
WITH top_stations AS 
    (SELECT
    from_station_name AS station, 
    user_type AS member_type,
    Count(user_type) AS member_count, 
    RANK()Over(PARTITION BY user_type ORDER BY COUNT(user_type) DESC) AS station_rank
    FROM rider_data_q1
    from_station_name != 'HUBBARD ST BIKE CHECKING (LBS-WH-TEST)' 
    --do not include HQ station; this will skew ride duration
    AND user_type = 'Customer'
    --adjust the member type here
    GROUP BY
    from_station_name,
    user_type
    LIMIT 20;)

SELECT
    DISTINCT start_station_name,
    start_lat,
    end_station_name,
    end_lng
FROM   
    rider_data_q1
INNER JOIN 
    top_stations ON rider_data_q1.start_station_name = top_stations.start_station_name