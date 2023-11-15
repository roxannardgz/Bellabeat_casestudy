--VERIFY DATES
--separating ActivityHour - shorter version
SELECT
  Id
  ,DATE(PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', ActivityHour)) AS ActivityDate
  ,TIME(PARSE_TIMESTAMP('%m/%d/%Y %I:%M:%S %p', ActivityHour)) AS ActivityTime
  ,calories
FROM
  `fitbit.calories_hour`

  
--Table in which the date and time were separated and parsed
SELECT
  MIN(ActivityDate) AS min_date,
  MAX(ActivityDate) AS max_date
FROM 
  `belladata.calories_hour`;


-------------------------
--USERS
--How many users used the device each day
WITH active_users AS (
  SELECT
    ActivityDate
    ,COUNT(DISTINCT Id) AS active_users
  FROM
    `belladata.activity_day`
  GROUP BY
    ActivityDate
  ORDER BY
    ActivityDate
  ),
total_count AS (
  SELECT
    COUNT(DISTINCT Id) AS total_users
  FROM
    `belladata.activity_day`
  )
SELECT
  users.ActivityDate
  ,users.active_users
  ,ROUND((users.active_users / total.total_users) * 100, 2) AS users_pcnt
FROM
  active_users users
CROSS JOIN
  total_count total
ORDER BY
  users.ActivityDate


--how many times each user used the device
SELECT
  DISTINCT(Id) AS ID
  ,COUNT(Id) as freq
FROM 
 `belladata.activity_day`
GROUP BY  
  1
ORDER BY
  2 DESC
