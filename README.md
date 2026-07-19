# cab_analytics
SQL | Power BI | analytics project on NYC cab trip data

## Problem Statement

Ride-sharing companies generate massive amounts of operational data every day — 
trips, fares, cancellations, driver activity. This project analyzes that data 
to answer key business questions a decision science team would face: When does 
demand spike? Which drivers earn the most? When do customers cancel, and why? 
Which customer segments drive the most revenue?

The goal is to turn raw trip-level data into decision-ready insights — 
identifying patterns the business can act on, not just reporting numbers.

## Tech Stack

- **Database:** PostgreSQL
- **Data Source:** NYC TLC Yellow Taxi Trip Records (real public dataset)
- **Data Cleaning:** Python (Pandas, NumPy) via Google Colab
- **Visualization:** Power BI Desktop
- **Tools:** pgAdmin 4

## Dataset

- Real NYC TLC Yellow Taxi trip data (~100,000 trips), cleaned and trimmed
- Synthetic driver, rider, payment, and rating data generated to complete 
  the relational schema (since public trip data doesn't include driver/rider 
  identities or ratings)
- Zone names mapped from NYC TLC's official taxi zone lookup table

## Schema

Five relational tables:

- **drivers** — driver_id, name, city, join_date, rating, status
- **riders** — rider_id, name, city, signup_date
- **trips** — trip_id, driver_id, rider_id, pickup_time, drop_time, 
  pickup_area, drop_area, distance_km, fare, status, wait_time_mins
- **payments** — payment_id, trip_id, amount, payment_mode, payment_status
- **ratings** — rating_id, trip_id, rider_rating_for_driver, 
  driver_rating_for_rider

Relationships: `trips` references `drivers` and `riders`; `payments` and 
`ratings` reference `trips`.

## Analysis Approach

Queries are organized into three tiers of increasing complexity:

- **Tier 1 (Basic):** Aggregations and filtering — total trips, revenue, 
  driver/payment breakdowns
- **Tier 2 (Intermediate):** Time-based grouping — surge pricing patterns, 
  cancellation rates by hour, daily revenue trends
- **Tier 3 (Advanced):** Window functions — driver earnings analysis, 
  rolling revenue trend, rider segmentation (RFM-style)

## Key Findings

- **Surge pricing pattern:** Average fares peak during early morning and 
  evening hours, suggesting demand-based pricing opportunities during 
  these windows.
- **Cancellations:** Cancellation rate is highest in early morning hours, 
  indicating potential driver availability gaps during that window.
- **Demand concentration:** A small number of pickup zones (led by JFK 
  Airport) account for a disproportionate share of trips — suggesting 
  targeted driver allocation could reduce wait times.
- **Driver earnings:** Earnings per hour vary across drivers, indicating 
  trip volume alone is not a reliable measure of driver performance.
- **Payment trends:** The majority of payments are card-based (~60%), with 
  cash and wallet usage comprising a smaller share — relevant for 
  evaluating payment processing partnerships.
- **Customer segmentation:** Riders cluster into four distinct segments by 
  trip frequency and total spend, useful for targeted retention or 
  loyalty strategies.

## Dashboard

Built in Power BI, connected directly to the PostgreSQL database, across 
two pages:

**Page 1:**
- Average fare by hour of day (surge pattern)
- Cancellation rate by hour
- Payment mode distribution
- Top 10 busiest pickup areas
- Driver-level fare/distance/trip breakdown

**Page 2:**
- Revenue and rolling average trend
- Driver earnings per hour breakdown
- Rider segmentation by trip count and total spend (4 customer segments)

## How to Run This Project

1. Install PostgreSQL and pgAdmin
2. Run `schema/create_tables.sql` to create the database structure
3. Load the cleaned CSV data into each table (via pgAdmin's Import feature)
4. Run queries from the `queries/` folder to reproduce the analysis
5. Open `dashboard/cab_analytics.pbix` in Power BI Desktop, update the 
   database connection to your local PostgreSQL instance, and refresh

## Author

Built by Devadharshini Senthilkumar and Archana.R as a portfolio project.
