-- Drivers table
CREATE TABLE drivers (
    driver_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    join_date DATE,
    rating NUMERIC(2,1),
    status VARCHAR(20) CHECK (status IN ('active', 'inactive'))
);

-- Riders table
CREATE TABLE riders (
    rider_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

-- Trips table
CREATE TABLE trips (
    trip_id SERIAL PRIMARY KEY,
    driver_id INT REFERENCES drivers(driver_id),
    rider_id INT REFERENCES riders(rider_id),
    pickup_time TIMESTAMP,
    drop_time TIMESTAMP,
    pickup_area VARCHAR(50),
    drop_area VARCHAR(50),
    distance_km NUMERIC(6,2),
    fare NUMERIC(8,2),
    status VARCHAR(20) CHECK (status IN ('completed', 'cancelled')),
    wait_time_mins INT
);

-- Payments table
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    trip_id INT REFERENCES trips(trip_id),
    amount NUMERIC(8,2),
    payment_mode VARCHAR(20),
    payment_status VARCHAR(20)
);

-- Ratings table
CREATE TABLE ratings (
    rating_id SERIAL PRIMARY KEY,
    trip_id INT REFERENCES trips(trip_id),
    rider_rating_for_driver NUMERIC(2,1),
    driver_rating_for_rider NUMERIC(2,1)
);
