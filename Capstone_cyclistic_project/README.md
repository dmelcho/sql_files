## Introduction
This project culminates all the course work, over 250 hours of learning, in the Google Data Analytics Professional Certificate. With this, we are able to demonstrate and showcase our newly acquired skills. In this self guided project, we have been tasked to analyze data from a bike-share program and deliver impactful insights. 

## Background
As a junior analyst for the Cyclistic bike-share company, based in Chicago, our main goal is to support the needs of the company to meet organizational goals. Our stakeholders suggest that the future of the company depends on the amount of annual subscribers. Therefore a high priority has been placed by upper management to increase this type of subscription. We have been asked to find the main differences between casual riders and annual subscribers. I will establish a set of questions that will guide my analysis and generate insights for a resolute marketing strategy.

Definition of subscribers:
- Casual Riders = single ride or full day pass
- Subscriber Riders = annual members


The data repository for this analysis can be found here [Divvy Trip Data](https://divvy-tripdata.s3.amazonaws.com/index.html). Note the 2019 data was used for this project. The tabular data included fields such as ride date, ride duration, ride ID, station name, station ID, member type, year of birth, and more.

The following prompts will help me find the main difference between the two type of riders in order to draw significant conclusions:

1. What is the difference in ride time duration between rider types?
2. What is the ride count for each rider type?
3. On which days of the week do different rider types use our service?
4. What are the most popular stations used by each rider type?

I will be including some of my SQL queries. But to see all of the queries, like creating my database and tables, [follow this link](/Capstone_cyclistic_project/SQL_queries/). There you will find a more detailed explanation of creating the database, data cleansing, and calculations.

### Tools I used
In this project I used a few tools to help with the analysis process:

- **Postgres SQL:** Given the volume of data, I will be using SQL for ETL 
- **Tableau:** I used the data viz tool to illustrate my findings, helping stakeholders better comprehend my analysis. 
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.
- **Git & GitHub**: For version control and sharing my SQL scripts and analysis. Ensuring collaboration and project tracking.

## Analysis
In order to generate the best possible insights, I used my prompted questions aiming to understand the usage of our different members:

1. **Ride Difference**: We will start with identifying who, on average, has the longer ride. To further understand the over all picture, I decided it would be beneficial to see the difference grouped by month.
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

![ride diff table](/Capstone_cyclistic_project/data_viz/1_ride_duration_diff.png)

Our findings tells us that casual riders ride for longer periods of time. April and May are trending to be the longest ride for them as well.

Further analysis points out the following average differences. Casual riders ride length is consistently 30 minutes more than our subscribers.

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

Subscriber rides are over double the amount of casual rides. Here we see the big opportunity we have as a company to increase our membership enrollment.

3. **Ride Count- Grouped by Day**: Now I want to see if there is a correlation in amount of rides each member takes according to the day of the week. Identifying a pattern here can help us understand usage behavior for both member types.

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
!['weekday count'](/Capstone_cyclistic_project/data_viz/2_weekday_count.png)

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

4. **Top Stations**: This section focuses on the areas where our members tend to ride. Understanding the locations frequented by each type of member provides insights into the reasons customers are using our service.

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
![Subscriber Top Stations](/Capstone_cyclistic_project/data_viz/3_top_stations_subscriber.png)

### Conclusions & Recs

**Final Insights**
1. Most of our casual riders are taking rides that last over 30 minutes. We can show them a calculation of the potential savings they could achieve by switching to an annual membership. Demonstrating this value could serve as an incentive for them to upgrade their membership.
2. Overall, casual users are likely to use our service on the weekends. Here we can promote the advantages of using our service during the week. By demonstrating that our bike service is more than just a weekend activity we will give our riders a reason to sigh up for a membership.
3. By knowing where the most used starting and ending stations are located we can tap into the member’s sense of adventure. How? By establishing key destinations throughout Chicago; we can show our members how fun and easy it can be to explore uncharted territory with our bike service.

**Recommendations**:
1. Implement marketing campaigns highlighting cost savings for riders. Focusing average a ride users with an average ride of over 30 minutes.
2. Promote weekday biking by offering showing the value of a annual membership. This can be through discount or loyalty programs.
3. Develop curated route destinations to inspire exploration of the city with our service.

Leveraging my insights and recommendations we can establish a better customer engagement, increase loyalty, and ultimately drive growth of our annual membership program.

### What I learned
There were some challenges with my data that I had to overcome in order to complete my analysis. Addressing these challenges allowed me to further develop my analytical skills and diversify my data analysis tools.

- Transforming data with SQL. In order to run calculations, such as arithmetic, I used date functions and casting operators that permitted me to do so.
- Advance functions for analysis. By using WINDOW functions and Common Table Expressions (CTEs), I was able to extract meaningful insights from the data.
- Limitations of SQL: While SQL is an exceptional database management system, it does have limitations, such as the inability to provide data visualizations. To address this, I used Tableau to illustrate my findings, which added depth to my analysis. This was particularly beneficial when working with spatial data.