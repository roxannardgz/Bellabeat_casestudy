-- average calories burned per user
SELECT
  DISTINCT Id
  ,ROUND(AVG(calories),2) AS calories_avg
  ,COUNT(Id) as freq
FROM
  `belladata.calories_day`
GROUP BY
  Id
ORDER BY
  calories_avg DESC;


-- average calories burned per day (weekday)
WITH calories_avg AS (
  SELECT
  EXTRACT(DAYOFWEEK FROM ActivityDay) AS day_num
  ,CASE EXTRACT(DAYOFWEEK FROM ActivityDay) 
    WHEN 1 THEN 'Sunday'
    WHEN 2 THEN 'Monday'
    WHEN 3 THEN 'Tuesday'
    WHEN 4 THEN 'Wednesday'
    WHEN 5 THEN 'Thursday'
    WHEN 6 THEN 'Friday'
    WHEN 7 THEN 'Saturday'
  END AS day_of_week
  ,ROUND(AVG(calories),2) AS calories_avg
FROM
  `belladata.calories_day`
GROUP BY
  day_num
  ,day_of_week
ORDER BY
  day_num
  )
SELECT
  calories_avg.day_of_week
  ,calories_avg.calories_avg
  ,RANK() OVER(ORDER BY calories_avg.calories_avg DESC) AS calories_rank
FROM
  calories_avg
ORDER BY
  day_num;

  
-- average calories burned throughout the month
SELECT
  ActivityDay,
  ROUND(AVG(calories),2) AS calories_avg
FROM
  `belladata.calories_day`
GROUP BY
  ActivityDay
ORDER BY
  ActivityDay;


-- average calories burned per hour
SELECT
  ActivityTime
  ,ROUND(AVG(calories), 2) AS calories_avg
FROM
  `belladata.calories_hour`
GROUP BY
  ActivityTime
ORDER BY
  ActivityTime;
