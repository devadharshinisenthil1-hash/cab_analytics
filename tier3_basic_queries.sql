-- 1. Driver efficiency ranking (earnings per hour, based on total trip time)
WITH driver_stats AS (
    SELECT driver_id,
           COUNT(*) AS total_trips,
           ROUND(SUM(fare),2) AS total_earnings,
           ROUND(SUM(wait_time_mins)/60.0, 2) AS total_hours,
           ROUND(SUM(fare) / NULLIF(SUM(wait_time_mins)/60.0, 0), 2) AS earnings_per_hour
    FROM trips
    WHERE status = 'completed'
    GROUP BY driver_id
)
SELECT *,
       RANK() OVER (ORDER BY earnings_per_hour DESC) AS efficiency_rank
FROM driver_stats
ORDER BY efficiency_rank
LIMIT 20;

-- 2. Rolling 7-day revenue trend
WITH daily_revenue AS (
    SELECT DATE(pickup_time) AS trip_date, SUM(fare) AS revenue
    FROM trips
    GROUP BY trip_date
)
SELECT trip_date, revenue,
       ROUND(AVG(revenue) OVER (ORDER BY trip_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS rolling_7day_avg
FROM daily_revenue
ORDER BY trip_date;

-- 3. Driver rating vs trip volume (do lower-rated drivers get fewer trips?)
SELECT d.driver_id, d.rating, COUNT(t.trip_id) AS total_trips,
       NTILE(4) OVER (ORDER BY d.rating) AS rating_quartile
FROM drivers d
JOIN trips t ON d.driver_id = t.driver_id
GROUP BY d.driver_id, d.rating
ORDER BY d.rating DESC;

-- 4. Top 3 busiest pickup areas per day (ranking within groups)
WITH daily_area_counts AS (
    SELECT DATE(pickup_time) AS trip_date, pickup_area, COUNT(*) AS trip_count
    FROM trips
    GROUP BY trip_date, pickup_area
)
SELECT trip_date, pickup_area, trip_count, rnk
FROM (
    SELECT *, RANK() OVER (PARTITION BY trip_date ORDER BY trip_count DESC) AS rnk
    FROM daily_area_counts
) ranked
WHERE rnk <= 3
ORDER BY trip_date, rnk;

-- 5. Customer (rider) segmentation by trip frequency (RFM-style)
WITH rider_activity AS (
    SELECT rider_id, COUNT(*) AS trip_count, ROUND(SUM(fare),2) AS total_spent,
           MAX(pickup_time) AS last_trip
    FROM trips
    GROUP BY rider_id
)
SELECT *,
       NTILE(4) OVER (ORDER BY trip_count DESC) AS frequency_quartile,
       NTILE(4) OVER (ORDER BY total_spent DESC) AS spend_quartile
FROM rider_activity
ORDER BY total_spent DESC
LIMIT 20;