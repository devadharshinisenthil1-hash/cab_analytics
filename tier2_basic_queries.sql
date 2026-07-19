-- 1. Average fare by hour of day (surge pattern detection)
SELECT EXTRACT(HOUR FROM pickup_time) AS hour_of_day,
       COUNT(*) AS trip_count,
       ROUND(AVG(fare),2) AS avg_fare
FROM trips
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- 2. Cancellation rate by hour of day
SELECT EXTRACT(HOUR FROM pickup_time) AS hour_of_day,
       COUNT(*) AS total_trips,
       SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_trips,
       ROUND(100.0 * SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancellation_rate_pct
FROM trips
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- 3. Average wait time by pickup area (top 10 longest waits)
SELECT pickup_area, ROUND(AVG(wait_time_mins),2) AS avg_wait_time
FROM trips
GROUP BY pickup_area
ORDER BY avg_wait_time DESC
LIMIT 10;

-- 4. Revenue trend by day
SELECT DATE(pickup_time) AS trip_date,
       COUNT(*) AS trip_count,
       ROUND(SUM(fare),2) AS daily_revenue
FROM trips
GROUP BY trip_date
ORDER BY trip_date;

-- 5. Day of week pattern (which days are busiest)
SELECT TO_CHAR(pickup_time, 'Day') AS day_of_week,
       COUNT(*) AS trip_count,
       ROUND(AVG(fare),2) AS avg_fare
FROM trips
GROUP BY day_of_week
ORDER BY trip_count DESC;

-- 6. Payment success rate
SELECT payment_status, COUNT(*) AS count,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM payments
GROUP BY payment_status;