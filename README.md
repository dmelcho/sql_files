## Introduction
This project culminates all the course work, over 250 hours of learning, in the Google Data Analytics Professional Certificate. With this, we are able to demonstrate and showcase our newly aquired skills. In this self guided project, we have been tasked to analyze data from a bike-share program and deliver impactful insights. 

## Background
As a junior analyst for the company Cyclistic bike-share, based in Chicago, our main goal is to support the needs of the company to meet organizational goals. Our stakeholders suggest that the future of the company depends on the amount of annual subscribers. Therefore a high priority has been placed by upper management to increase this type of subscription. We have been asked to find the main differences between casual riders and annual subscribers. I will establish a set of questions that will guide my analysis and generate insights for a resolute marketing strategy.

Definition of subscribers:
- Single ride or full day pass = casual riders
- Annual members = subscriber riders


The data repository for this analysis can be found here [Divvy Trip Data](https://divvy-tripdata.s3.amazonaws.com/index.html). Note the 2019 data was used for this project. The tabular data included fields such as ride date, ride duration, ride ID, station name, station ID, member type, year of birth, and more.

The following prompts will help me find the main difference between the two type of riders in order to draw significant conclusions:

1. What are the ride time duration difference between riders?
1. What is the ride count for each rider type?
2. What days of the week does each rider type use our service?
3. What are the most popular stations used by each rider?

I will be including some of my SQL queries. But to see all of the queries, like creating my database and tables, [follow this link](Google_Capstone_project). There you will find a more detailed explanation and recording of all calculation and data validation.

### Tools I used
In this project I used a few tools to help with the analysis process:

- **Postgres SQL:** Given the volume of data, I will be using SQL for ETL 
- **Tableau:** I used the data viz tool to illustrate my findings, helping stakeholders better comprehend my analysis. 
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.
- **Git & GitHub**: For version control and sharing my SQL scripts and analysis. Ensuring collaboration and project tracking.

## Analysis
In order to generate the best possible insights, I prompted the following questions aiming to understand the usage of our different members:

1. **Ride Difference**: We will start with identifying who, on average, has the longer ride. To understand the over all picture, I decided it would be beneficial to see the numbers grouped by month.
```sql
--this query specific to Q3; to get complete results we have to run it for each quarter table
SELECT 
    user_type,
    EXTRACT(MONTH FROM from_start_time) AS month, 
    AVG(end_time - start_time):: TIMES AS avg_ride_duration
FROM 
    rider_data_q3
WHERE 
    to_station_name != 'HUBBARD ST BIKE CHECKING (LBS-WH-TEST)'
    --station removed as this was a test that included rides = 1 second
GROUP BY 
    user_type,
    month
ORDER BY
    month;
```

![ride diff table](Google_Capstone_project\SQL_data_viz\1_ride_duration_diff.png)

Our findings tells us that casual riders ride for longer periods of time. April and May are trending to be the longest ride for them as well.

Further analysis points out the following average differences:

| Month | AVG Difference in Mins |
| :---: | :---: |
| January |32:37 |
| February | 31:32 |
| March | 30:58 |
| April | 37:26 |
| June | 31:36 |
| July | 26:32 |
| August | 27: 10 |

2. **Total Ride Count**: Next, I want to see the numbers that represent how many total rides each member type has taken in the first three quarters. This will help quantify the amount of people we need to reach out to. 

```sql
SELECT
    user_type,
    COUNT(*) AS total_ride_count,
From
    rider_data_q2
GROUP BY
    user_type;
```
| Member Type | Total Rides |
|:-------------:|:-------------:|
| Subscriber   | 1,904,596     |
| Casual      | 619,441      |

Subscriber rides are over double the amount of casual rides. We can quantify the potential opportunity we have as a company to increase our membership enrollment.

3. **Ride Count- Grouped by Day**: Now I want to see if there is a correlation in amount of rides each member takes according to the day of the week. I want to identify pattern, if any, and see riders are using our service. 

```sql
--this query specific to Q3; to get complete results we have to run it for each quarter table
WITH weekday AS
(
SELECT 
user_type,
to_char(start_time, 'DAY') AS day_of_week
FROM 
rider_data_q3
)
SELECT
    user_type,
    day_of_week,
    Count(day_of_week) AS day_count,
    Rank()Over(PARTITION BY user_type ORDER BY COUNT(day_of_week) DESC ) AS day_rank
FROM 
    weekdays
WHERE --adjust the member type here
    user_type = 'Customer'
GROUP BY     
    day_of_week,
    user_type;
```
!['weekday count'](Google_Capstone_project\SQL_data_viz\2_weekday_count.png)

Here we are abele to find that the subscriber riders are taking a lot more rides per week than causal ones. Casual riders see an increase in ride count on the weekends. When we rank our results, we see a positive correlation in ride count for casual members as the week progresses.

| Day       | Casual Rank | Day       | Subscriber Rank |
|:-----------:|:-------------:|:-----------:|:-----------------:|
| Saturday  | 1           | Tuesday   | 1               |
| Friday    | 2           | Monday    | 2               |
| Sunday    | 3           | Friday    | 3               |
| Thursday  | 4           | Saturday  | 4               |
| Wednesday | 5           | Sunday    | 5               |
| Monday    | 6           | Wednesday | 6               |
| Tuesday   | 7           | Thursday  | 7               |

4. **Top Stations**: This part focuses on the areas our members tend to ride in. Knowing where each type of member can give us insights on the reason as to why customers are using our service.

```sql
--this query specific to Q3; to get complete results we have to run it for each quarter table
SELECT 
    from_station_name AS station, 
    user_type AS member_type,
    Count(user_type) AS member_count, 
    RANK()Over(PARTITION BY user_type ORDER BY COUNT(user_type) DESC) AS station_rank
FROM rider_data_q3
WHERE
    from_station_name != 'HUBBARD ST BIKE CHECKING (LBS-WH-TEST)' AND
    --adjust the member type here
    user_type = 'Customer' 
GROUP BY
    from_station_name,
    user_type
LIMIT 20;
```
![Subscriber Top Stations](Google_Capstone_project\SQL_data_viz\3_top_stations_subscriber.png)
