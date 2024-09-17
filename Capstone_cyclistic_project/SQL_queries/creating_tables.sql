--database schema below
--note the different name in Q3: tripduration, usertype, birthyear
--will need to adjust that for consistency and clarity

-- rider_data_q1 table
CREATE TABLE public.rider_data_q1
(
    trip_id, INT PRIMARY KEY,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    bike_id INT,
    trip_duration FLOAT,
    from_station_id INT,
    from_station_name TEXT,
    to_station_id INT,
    to_station_name TEXT,
    user_type TEXT,
    gender TEXT,
    birthday_year INT
);


-- rider_data_q2 table
CREATE TABLE public.rider_data_q2
(
    rental_id INT PRIMARY KEY,
    rental_start_time TIMESTAMP,
    rental_end_time TIMESTAMP,
    rental_bike_id INT,
    rental_duration_seconds FLOAT,
    start_station_id INT,
    start_station_name TEXT,
    end_station_id INT,
    end_station_name TEXT,
    user_type TEXT,
    gender TEXT,
    member_birthday_year INT
);

--rider_data_q3 table
CREATE TABLE public.rider_data_q3
(
    trip_id INT PRIMARY KEY,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    bike_id INT,
    tripduration VARCHAR,
    from_station_id INT,
    from_station_name TEXT,
    to_station_id INT,
    to_station_name TEXT,
    usertype TEXT,
    gender TEXT,
    birthyear INT,
);