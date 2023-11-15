-- average steps per user (ID)
SELECT
  DISTINCT Id,
  ROUND(AVG(StepTotal), 2) AS average_steps
FROM
  `belladata.steps_day`
GROUP BY
  Id
ORDER BY
  average_steps DESC;



-- average steps per day (date)
SELECT
  ActivityDay,
  ROUND(AVG(StepTotal), 2) AS steps_avg
FROM
  `belladata.steps_day`
GROUP BY 
  ActivityDay
ORDER BY
  ActivityDay;


-- average steps per weekday
WITH steps_average AS (
  SELECT
    EXTRACT(DAYOFWEEK FROM ActivityDay) AS day_num
    ,FORMAT_DATE('%A', ActivityDay) AS day_of_week
    ,ROUND(AVG(StepTotal), 2) AS step_avg
  FROM
    `belladata.steps_day`
  GROUP BY
    day_of_week
    ,day_num
  ORDER BY 
    step_avg DESC
  )
SELECT
--  day_num
  steps_average.day_of_week
  ,steps_average.step_avg
  ,RANK() OVER(ORDER BY step_avg DESC) AS step_rank
FROM
  steps_average
ORDER BY
  day_num;


-- average steps per hour of the day
SELECT
  ActivityTime
  ,ROUND(AVG(StepTotal), 2) AS steps_avg
FROM
  `belladata.steps_hour`
GROUP BY
  ActivityTime
ORDER BY
  ActivityTime;
