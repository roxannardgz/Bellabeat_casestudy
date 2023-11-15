-- intensities per day of the week
WITH intensities AS (
  SELECT
    DISTINCT(Id) AS Id
    ,ActivityDay
    ,FORMAT_DATE('%A', ActivityDay) AS day_of_week
    ,EXTRACT(DAYOFWEEK FROM ActivityDay) AS day_num
    ,AVG(sedentary_total) AS sedentary_avg
    ,AVG(light_total) AS light_avg
    ,AVG(active_total) AS active_avg
  FROM
    (
    SELECT
      Id
      ,ActivityDay
      ,SUM(SedentaryMinutes) AS sedentary_total
      ,SUM(LightlyActiveMinutes) AS light_total
      ,SUM(VeryActiveMinutes) AS active_total
    FROM
      `belladata.intensities_day`
    GROUP BY
      ActivityDay
      ,Id
    ORDER BY
      Id,
      ActivityDay
    )
  GROUP BY
    Id
    ,day_num
    ,ActivityDay
  ORDER BY
    activityDay
  )
SELECT
  intensities.day_of_week
  ,ROUND(AVG(intensities.sedentary_avg), 2) AS sedentary
  ,ROUND(AVG(intensities.light_avg), 2) AS light
  ,ROUND(AVG(intensities.active_avg), 2) AS active
FROM
  intensities
GROUP BY
  day_of_week
  ,day_num
ORDER BY
  day_num;


--intensities per day of the week + rank of non sedentary hours. 

SELECT 
  day_of_week
  ,sedentary
  ,light
  ,active
  ,ROUND((light + active) / 60, 1) AS non_sedentary_hours
  ,RANK() OVER(ORDER BY light + active DESC) AS active_rank
FROM
  (
  SELECT
    day_of_week
    ,day_num
    ,ROUND(AVG(sedentary_avg), 2) AS sedentary
    ,ROUND(AVG(light_avg), 2) AS light
    ,ROUND(AVG(active_avg), 2) AS active
  FROM
    `belladata.intensities_user`
  GROUP BY
    day_of_week
    ,day_num
  )
ORDER BY
  day_num;


-- intensities per user
SELECT
  *
  ,ROUND((light + active) / 60, 1) AS non_sedentary_hours
FROM
  (
    SELECT
    DISTINCT Id
    ,ROUND(AVG(sedentary_avg), 2) AS sedentary
    ,ROUND(AVG(light_avg), 2) AS light
    ,ROUND(AVG(active_avg), 2) AS active
  FROM
    `belladata.intensities_user`
  GROUP BY
    Id
  )
ORDER BY
  5 DESC;
