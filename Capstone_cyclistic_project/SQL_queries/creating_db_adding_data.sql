--creating database
--using Postgres as my database management system

    CREATE DATABASE cyclistic_data
    OWNER 5432
    TEMPLATE template0
    ENCODING 'UTF8'
    CONNECTION LIMIT = 5;

--copying data into our tables

    COPY rider_data_q1
    FROM 'C:\Program Files\PostgreSQL\16\data\Capstone Project\cyclistic_data.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

    COPY rider_data_q2
    FROM 'C:\Program Files\PostgreSQL\16\data\Capstone Project\q2_saved_data.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

    COPY rider_data_q3
    FROM 'C:\Program Files\PostgreSQL\16\data\Capstone Project\q3_saved_data.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
