SELECT *
FROM play_store_apps;
SELECT *
FROM app_store_apps;


--General recommendation on what types of apps to focus our attention on:
--a. Genre
--b. Content Rating
--c. Price Range

--Question 1: use ROI to determine ideal characteristics (genre, content rating, price range, review count/rating, download count in play store, presence in one or both stores)

SELECT name, genres, content_rating, price 
FROM play_store_apps;
---name, genres, content_rating, price on playstore
SELECT name, primary_genre, rating, price
FROM app_store_apps;
-- name, genres, rating, price on appstore
WITH roi_table AS (WITH apps_ AS (WITH both_apps AS (SELECT DISTINCT name, p.genres,
             p.content_rating, a.rating, a.price, a.primary_genre,
			 CASE WHEN a.price <= 2.50 THEN 25000
			      WHEN a.price > 2.50 THEN 10000 * a.price
				  END AS market_price
FROM play_store_apps AS P
INNER JOIN app_store_apps AS a
USING(name)
ORDER BY market_price DESC)
--- found the market_price and created a new table called both_apps
SELECT DISTINCT name, genres, primary_genre,
       content_rating, rating, 
	   price, market_price,
	   (2500 * (12 + 24 * rating)) AS income,
		(12 + 24 * rating) AS longevity
FROM both_apps)
-- found the income and longevity and created a new table called apps_	   
SELECT ROUND(AVG(rating),1) AS avg_rating, 
       genres, market_price, income, primary_genre,
	   (income - (1000 * longevity + market_price)) AS roi
FROM apps_
GROUP BY  genres, market_price, income, longevity, primary_genre
ORDER BY roi DESC)
-- found the return on investment(ROI) and created a table called roi_table
SELECT genres, primary_genre,
       ROUND(MIN(roi),1) AS min_roi, MAX(roi) AS max_roi
FROM roi_table
GROUP BY genres, primary_genre
ORDER BY max_roi DESC;
-- min and max roi 
-- 
--2. Make a recommendation of 10 apps to buy with a sole focus on profitability/return on investment.
WITH apps_ AS (WITH both_apps AS (SELECT DISTINCT name, p.genres,
             p.content_rating, a.rating, a.price, a.primary_genre,
			 CASE WHEN a.price <= 2.50 THEN 25000
			      WHEN a.price > 2.50 THEN 10000 * a.price
				  END AS market_price
FROM play_store_apps AS P
INNER JOIN app_store_apps AS a
USING(name)
ORDER BY market_price DESC)
--- found the market_price and created a new table called both_apps
SELECT DISTINCT name, genres, primary_genre,
       content_rating, rating, 
	   price, market_price,
	   (2500 * (12 + 24 * rating)) AS income,
		(12 + 24 * rating) AS longevity
FROM both_apps)
-- found the income and longevity and created a new table called apps_	   
SELECT DISTINCT name,
      ROUND(AVG(rating),1) AS avg_rating, 
       genres, primary_genre,
	   (income - (1000 * longevity + market_price)) AS roi
	 
FROM apps_
GROUP BY  genres, market_price, income, longevity, primary_genre,name
ORDER BY roi DESC
LIMIT 10;
-- ASOS, Cytus, Domino's Pizza USA, Egg,inc. Geometry Dash Lite, PewDiePie's Tuber Simulator,The Guardian, aa, Adobe Illustrator Draw, Afterlight.
--3. Make a recommendation of 4 apps that are profitable and also align with the upcoming Pi Day themed campaign (think math or pie related apps!
WITH apps_ AS (WITH both_apps AS (SELECT DISTINCT name, p.genres,
             p.content_rating, a.rating, a.price, a.primary_genre,
			 CASE WHEN a.price <= 2.50 THEN 25000
			      WHEN a.price > 2.50 THEN 10000 * a.price
				  END AS market_price
FROM play_store_apps AS P
INNER JOIN app_store_apps AS a
USING(name)
ORDER BY market_price DESC)
--- found the market_price and created a new table called both_apps
SELECT DISTINCT name, genres, primary_genre,
       content_rating, rating, 
	   price, market_price,
	   (2500 * (12 + 24 * rating)) AS income,
		(12 + 24 * rating) AS longevity
FROM both_apps)
-- found the income and longevity and created a new table called apps_	   
SELECT DISTINCT name,
      ROUND(AVG(rating),1) AS avg_rating, 
       genres, primary_genre,
	   (income - (1000 * longevity + market_price)) AS roi
	 
FROM apps_
WHERE name ILIKE '%Pie%'
--OR name ILIKE '%Math%'
--OR genres ILIKE '%food%' 
GROUP BY  genres, market_price, income, longevity, primary_genre,name
ORDER BY roi DESC