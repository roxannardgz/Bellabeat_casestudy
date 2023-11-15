-- average calories burned and steps per day (weekday) - with ranks
WITH calories_avg AS (
  SELECT
    EXTRACT(DAYOFWEEK FROM ActivityDay) AS day_num
    ,FORMAT_DATE('%A', ActivityDay) AS day_of_week
    ,ROUND(AVG(calories),2) AS calories_avg
  FROM
    `belladata.calories_day`
  GROUP BY
    day_of_week
    ,day_num
    ),
steps_average AS (
  SELECT
    FORMAT_DATE('%A', ActivityDay) AS day_of_week
    ,ROUND(AVG(StepTotal), 2) AS step_avg
  FROM
    `belladata.steps_day`
  GROUP BY
    day_of_week
  )
SELECT
  calories_avg.day_of_week
  ,calories_avg.calories_avg
  ,steps_average.step_avg
  ,RANK() OVER(ORDER BY calories_avg.calories_avg DESC) AS calories_rank
  ,RANK() OVER(ORDER BY step_avg DESC) AS step_rank
FROM
  calories_avg
JOIN
  steps_average
ON calories_avg.day_of_week = steps_average.day_of_week
ORDER BY 
  day_num ASC


-- average calories and steps per date (whole month)
SELECT
  c.ActivityDay
  ,ROUND(AVG(c.Calories), 2) AS calories_avg
  ,ROUND(AVG(s.StepTotal), 2) AS step_avg
FROM
  `belladata.calories_day` c
JOIN
  `belladata.steps_day` s
ON c.ActivityDay = s.ActivityDay
GROUP BY
  ActivityDay
