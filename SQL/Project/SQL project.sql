-- How many restaurants are there in the dataset?

SELECT COUNT(*) AS total_restaurants FROM zometo.zometo_data;

-- How many unique restaurants are present in the dataset?

SELECT DISTINCT RestaurantName FROM zometo.zometo_data;

-- Which restaurant has the highest number of votes?

select restaurantname,votes from zometo.zometo_data order by votes desc limit 1;

-- What are the top 10 restaurants with the best average ratings?

SELECT  avg(rating)  as rating FROM zometo.zometo_data GROUP BY CountryCode limit 10;

-- Which city has more restaurent 

SELECT  city , COUNT(*) AS hotel_count  FROM zometo.zometo_data GROUP BY city ORDER BY hotel_count DESC LIMIT 1;

-- How many restaurants offer both delivery and dine-in services?

SELECT restaurantname FROM zometo.zometo_data WHERE Has_Online_delivery = "yes" AND  Has_Table_booking = "yes";

-- How many distinct cuisines are served across all restaurants?

SELECT DISTINCT Cuisines FROM zometo.zometo_data;

-- What is the most popular cuisine based on the number of restaurants offering it?

SELECT Cuisines, COUNT(*)AS count FROM zometo.zometo_data GROUP BY Cuisines ORDER BY count DESC LIMIT 1;

-- How many unique cities are represented in the dataset?

SELECT COUNT(DISTINCT city) AS unique_cities FROM zometo.zometo_data;

-- Which restaurant has the highest rating?

SELECT restaurantname, rating FROM zometo.zometo_data ORDER BY rating DESC LIMIT 1;

-- What is the average cost for two across all restaurants?

SELECT AVG(average_cost_for_two) AS avg_cost FROM zometo.zometo_data;

-- List the top 5 most expensive restaurants based on average cost for two.

SELECT restaurantname, city, average_cost_for_two, currency FROM zometo.zometo_data ORDER BY average_cost_for_two DESC LIMIT 5;

-- What are the top 5 most popular cuisines (based on count)?

SELECT cuisines, COUNT(*) AS count  FROM zometo.zometo_data  GROUP BY cuisines  ORDER BY count DESC LIMIT 5;

-- What is the average rating of restaurants in each city?

SELECT city, AVG(rating) AS avg_rating FROM zometo.zometo_data GROUP BY city  ORDER BY avg_rating DESC;

-- Which restaurant has the highest votes but a low rating (<3)?

SELECT restaurantname, votes, rating  FROM zometo.zometo_data  WHERE rating < 3  ORDER BY votes DESC  LIMIT 1;

-- Which city has the highest average restaurant rating?

SELECT city, AVG(rating) AS avg_rating FROM zometo.zometo_data GROUP BY city ORDER BY avg_rating DESC LIMIT 1;

-- What is the most common currency used in the dataset?

SELECT currency, COUNT(*) AS count FROM zometo.zometo_data GROUP BY currency ORDER BY count DESC LIMIT 1;

-- What is the distribution of restaurants based on their rating?

SELECT rating, COUNT(*) AS count FROM zometo.zometo_data GROUP BY rating ORDER BY rating DESC;

-- Which restaurants have a rating higher than the average rating?

SELECT restaurantname, rating FROM zometo.zometo_data WHERE rating > (SELECT AVG(rating) FROM zometo.zometo_data) ORDER BY rating DESC;

--  Which city has the highest total votes?

SELECT city, SUM(votes) AS total_votes FROM zometo.zometo_data GROUP BY city ORDER BY total_votes DESC LIMIT 1;

-- Which restaurant has the lowest rating but a high number of votes (above the average votes)?

SELECT restaurantname, rating, votes FROM zometo.zometo_data WHERE rating = (SELECT MIN(rating) FROM zometo.zometo_data) AND votes > (SELECT AVG(votes) FROM zometo.zometo_data);

-- What is the most expensive cuisine on average?

SELECT cuisines, AVG(average_cost_for_two) AS avg_cost FROM zometo.zometo_data GROUP BY cuisines ORDER BY avg_cost DESC LIMIT 1;

-- What is the least expensive cuisine on average?

SELECT cuisines, AVG(average_cost_for_two) AS avg_cost FROM zometo.zometo_data GROUP BY cuisines ORDER BY avg_cost ASC LIMIT 1;

-- How many restaurants offer table booking?

SELECT COUNT(*) AS table_booking_count FROM zometo.zometo_data WHERE has_table_booking = 'Yes';

-- How many restaurants offer online delivery?

SELECT COUNT(*) AS online_delivery_count FROM zometo.zometo_data WHERE has_online_delivery = 'Yes';

-- Which city has the highest number of restaurants offering online delivery?

SELECT city, COUNT(*) AS delivery_count FROM zometo.zometo_data WHERE has_online_delivery = 'Yes' GROUP BY city ORDER BY delivery_count DESC LIMIT 1;

-- Rank restaurants by rating within each city

SELECT restaurantname, city, rating, RANK() OVER (PARTITION BY city ORDER BY rating DESC) AS rank_in_city FROM zometo.zometo_data;

-- Find the top-rated restaurant in each city (using DENSE_RANK)

SELECT restaurantname, city, rating FROM (SELECT restaurantname, city, rating, DENSE_RANK() OVER (PARTITION BY city ORDER BY rating DESC) AS rnk FROM zometo.zometo_data) ranked WHERE rnk = 1;

-- Rank restaurants based on votes globally (across all cities)

SELECT restaurantname, city, votes,RANK() OVER (ORDER BY votes DESC) AS vote_rank FROM zometo.zometo_data;

-- Calculate cumulative votes for restaurants within each city

SELECT restaurantname, city, votes, SUM(votes) OVER (PARTITION BY city ORDER BY votes DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_votes FROM zometo.zometo_data;

-- Find the previous restaurant’s rating for each restaurant (by city)

SELECT restaurantname, city, rating, LAG(rating) OVER (PARTITION BY city ORDER BY rating DESC) AS previous_rating FROM zometo.zometo_data;

-- Find the next restaurant’s rating for each restaurant (by city)

SELECT restaurantname, city, rating, LEAD(rating) OVER (PARTITION BY city ORDER BY rating DESC) AS next_rating FROM zometo.zometo_data;

-- Insights from the Zomato Data Analysis


-- 1. General Overview
-- The dataset contains information on restaurants across multiple countries and cities.
-- There are a significant number of unique restaurants, indicating a broad coverage of global food services.
-- The dataset provides details such as restaurant names, locations, cuisines, costs, votes, and ratings, allowing for deep data-driven insights.


-- 2. Restaurant Popularity & Ratings
-- The highest-rated restaurant in the dataset has a rating close to 5.0, whereas some restaurants have ratings below 3.0.
-- The average restaurant rating varies significantly by city and country.
-- Restaurants with higher votes tend to have better ratings, showing a possible correlation between customer engagement and perceived quality.
-- Some restaurants have low ratings but high votes, suggesting they may be well-known but not necessarily the best in quality.
-- City-Level Insights:
-- Certain cities have a higher concentration of top-rated restaurants, indicating regional food preferences and higher culinary standards.
-- The top 5 cities with the most restaurants account for a significant percentage of the dataset, suggesting key markets for Zomato.
-- Restaurant Competition:
-- In major cities, competition is fierce, with multiple restaurants offering similar cuisines.
-- Ranking restaurants within a city using RANK() revealed that even within the same city, restaurants have vastly different reputations and customer engagement.


-- 3. Cost Analysis
-- The average cost for two varies widely across different cities and countries, reflecting economic differences.
-- The most expensive restaurants tend to be located in major metropolitan areas or tourist hubs.
-- Some cities have low-cost restaurants with high ratings, making them attractive destinations for budget-friendly dining.
-- Using NTILE(4) to segment cost quartiles revealed that only a small fraction of restaurants fall into the ultra-expensive category.


-- 4. Cuisines & Trends
-- The most popular cuisines (based on frequency in the dataset) include global favorites such as Italian, Chinese, Indian, and Continental.
-- High-rated cuisines tend to be niche, while mass-market cuisines are rated slightly lower but attract more customers.
-- Some cities specialize in specific cuisines, making them food hubs for those culinary styles.
-- Restaurant Segmentation:
-- The top-rated restaurants serve premium or niche cuisines, whereas fast-food and casual dining restaurants have mixed reviews.
-- A city-wise cuisine breakdown suggests that some cities have a diverse food scene, while others are dominated by one or two cuisine types.


-- 5. Online Delivery & Table Booking Trends
-- Online delivery is highly available in certain cities, showing a demand for food delivery services.
-- Table booking is more common in upscale restaurants, while casual dining and fast-food chains tend to focus on walk-ins.
-- Using percentage calculations on online delivery and table booking revealed that some cities have a high adoption rate for digital ordering.


-- 6. Customer Engagement & Voting Trends
-- The number of votes per restaurant varies widely, with some restaurants having thousands of votes while others have very few.
-- Using SUM() and PERCENTAGE() calculations, we found that a small percentage of restaurants receive the majority of votes.
-- Cities with high customer engagement tend to have higher-rated restaurants.
-- Comparing votes using LAG() and LEAD() functions revealed which restaurants improved or declined in customer engagement.


-- 7. Window Function Insights
-- Using RANK() and DENSE_RANK(), we identified top restaurants by city and cuisine.
-- NTILE(4) allowed segmentation of restaurants into quartiles based on cost, rating, and votes.
-- Cumulative totals using SUM() OVER() showed how votes and costs accumulated across different cities.
-- Using LAG() and LEAD(), we identified fluctuations in restaurant ratings and customer preferences.


-- 8. Key Business Insights & Recommendations
-- For Zomato & Restaurant Owners:
--  Improve Online Presence: High-vote restaurants have better visibility, so investing in online marketing can increase engagement.
--  Target Budget & Luxury Markets Separately: Cost segmentation shows that both budget and premium restaurants have a strong customer base.
--  Focus on High-Engagement Cities: Certain cities have a much larger audience for food delivery and table bookings, making them prime targets for expansion.
--  Encourage Customer Reviews & Votes: Restaurants with high votes attract more customers, indicating the power of social proof.
--  Leverage Data for Strategic Pricing: The cost analysis shows price sensitivity varies by location, allowing restaurants to adjust pricing accordingly. 