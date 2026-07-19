-- 1. Total trips and revenue overview
SELECT COUNT(*) AS total_trips, ROUND(SUM(fare),2) AS total_revenue, ROUND(AVG(fare),2) AS avg_fare
FROM trips;

-- 2. Trips by status (completed vs cancelled)
SELECT status, COUNT(*) AS trip_count
FROM trips
GROUP BY status;

-- 3. Top 10 busiest pickup areas
SELECT pickup_area, COUNT(*) AS trip_count
FROM trips
GROUP BY pickup_area
ORDER BY trip_count DESC
LIMIT 10;

-- 4. Average fare by pickup area (top 10 highest)
SELECT pickup_area, ROUND(AVG(fare),2) AS avg_fare
FROM trips
GROUP BY pickup_area
ORDER BY avg_fare DESC
LIMIT 10;

-- 5. Driver status breakdown
SELECT status, COUNT(*) AS driver_count
FROM drivers
GROUP BY status;

-- 6. Payment mode distribution
SELECT payment_mode, COUNT(*) AS count, ROUND(AVG(amount),2) AS avg_amount
FROM payments
GROUP BY payment_mode
ORDER BY count DESC;