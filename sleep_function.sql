-- sleep recordings per users throughout the month
SELECT
  id,
  COUNT(DISTINCT ActivityDate) AS use_cnt
FROM
  `belladata.sleep_day`
GROUP BY
  id
ORDER BY
  2 DESC;


-- uses and users per week - totals and percentages 
WITH weekdays AS (
  SELECT
    FORMAT_DATE('%A', ActivityDate) AS day_of_week,
    COUNT(Id) AS times_used,
    COUNT(DISTINCT Id) AS users
  FROM
    `belladata.sleep_day`
  GROUP BY
    day_of_week
  ),
total_cnt AS (
  SELECT 
    COUNT(DISTINCT Id) AS total_users,
    COUNT(Id) AS total_uses
  FROM
    `belladata.sleep_day`
  )
SELECT 
  day.day_of_week,
  day.times_used,
  day.users,
  ROUND(day.times_used / total.total_uses * 100, 2) AS total_used_pcnt,
  ROUND(day.users / total.total_users * 100, 2) AS total_users_pcnt
FROM
  weekdays day
CROSS JOIN
  total_cnt total;

-- count of naps and users that nap (based on total sleep records > 1)
SELECT
  COUNT(DISTINCT Id) AS users_napped
  ,COUNT(TotalSleepRecords) AS times_napped
FROM
  `belladata.sleep_day`
WHERE
  TotalSleepRecords > 1;


-- average hours of sleep (total)
SELECT
  ROUND(AVG(TotalMinutesAsleep)/60, 2) AS sleep_avg
FROM
  `belladata.sleep_day`


-- average sleep time per user (id)
SELECT
  DISTINCT Id
  ,ROUND(AVG(non_sedentary_time), 2) AS active_time_avg
  ,ROUND(AVG(time_asleep), 2) AS sleep_time_avg
FROM
  `belladata.intensities_sleep`
GROUP BY
  1;

-- average sleep time per day of the week
SELECT
  DISTINCT ActivityDay
  ,ROUND(AVG(non_sedentary_time), 2) AS active_time_avg
  ,ROUND(AVG(time_asleep), 2) AS sleep_time_avg
FROM
  `belladata.intensities_sleep`
GROUP BY
  1
