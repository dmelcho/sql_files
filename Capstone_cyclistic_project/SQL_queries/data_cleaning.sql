/* Data cleaning:
--checking to see that our ride durations all make sense
--we need to do this for all tables
--take notes of where we need to adjust our code
--adjusting q3 field names to match other tables: tripduration, usertype, birthyear
*/

--checking for anomalies in ride duration
SELECT
    member_casual,
    start_station_name,
    MAX(ended_at - started_at)::TIME AS max_ride_length,
    MIN(ended_at - started_at)::TIME AS min_ride_length
FROM   
    rider_data_q1
    --adjust table name to find all anomalies
WHERE
    member_casual = 'Customer'
    --make sure to filter by casual riders as well
GROUP BY
    member_casual,
    start_station_name
HAVING 
   MAX(ended_at - started_at)::TIME BETWEEN '12:15:00' AND '14:27:52'
   AND MIN(ended_at - started_at)::TIME < '00:01:00';
   -- looking for big variances


--checking for NULLS
--making sure that this is done for all tables
SELECT
    COUNT(*)
FROM
    rider_data_q1
    -- do this for q1, q2, and q3
WHERE
    ride_id IS NULL OR
    rideable_type IS NULL OR
    started_at IS NULL OR
    ended_at IS NULL OR
    start_station_name IS NULL OR
    start_station_id IS NULL OR
    end_station_name IS NULL OR
    end_station_id IS NULL OR
    member_casual IS NULL;


--formatting tables so that column is easier to read
ALTER TABLE rider_data_q3
RENAME COLUMN tripduration to trip_duration;

ALTER TABLE rider_data_q3
RENAME COLUMN usertype to user_type;

ALTER TABLE rider_data_q3
RENAME COLUMN birthyear to birth_year;
