SELECT *
FROM play_store_apps;
SELECT *
FROM app_store_apps;


--General recommendation on what types of apps to focus our attention on:
--a. Genre
--b. Content Rating
--c. Price Range

--Question 1: use ROI to determine ideal characteristics (genre, content rating, price range, review count/rating, download count in play store, presence in one or both stores)
------------------------------------APP STORE ONLY-----------------------------------------------
​
--average roi, percent profitable, other stats by price range
SELECT 
	price_range,
	COUNT(price_range),
	ROUND(AVG(estimated_revenue),2) AS estimated_revenue,
	MIN(roi),
	MAX(roi),
	ROUND(AVG(roi),2) AS average_roi,
	ROUND(100*COUNT(CASE WHEN roi > 0 THEN 1 END)/(COUNT(roi)),2) AS perc_profitable
FROM(SELECT 
		name, 
		CASE WHEN price = 0 THEN 'Free'
			WHEN price > 0 AND price <= 1 THEN '$0 - $1'
			WHEN price > 1 AND price <= 5 THEN '$1 - $5'
			WHEN price > 5 AND price <= 10 THEN '$5 - $10'
			WHEN price > 10 AND price <= 15 THEN '$10 - $15'
			WHEN price > 15 AND price <= 20 THEN '$15 - $20'
			WHEN price > 20 AND price <= 50 THEN '$20 - $50'
			ELSE '$50+' END AS price_range,
		rating,
	 	2500*(12+(24*rating)) AS estimated_revenue,
		((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
	FROM app_store_apps
	LEFT JOIN (SELECT 
		name,
		CASE WHEN price > 2.5 THEN price*10000
			ELSE 25000 END AS value
	FROM app_store_apps) AS vc
	USING(name)) AS roi_tbl
GROUP BY price_range
ORDER BY average_roi DESC, perc_profitable DESC;
​
--average roi, percent profitable, other stats by review count
SELECT 
	review_range,
	COUNT(review_range),
	ROUND(AVG(estimated_revenue),2) AS estimated_revenue,
	MIN(roi),
	MAX(roi),
	ROUND(AVG(roi),2) AS average_roi,
	ROUND(100*COUNT(CASE WHEN roi > 0 THEN 1 END)/(COUNT(roi)),2) AS perc_profitable
FROM(SELECT 
		name, 
		CASE WHEN review_count::integer = 0 THEN 'No Reviews'
			WHEN review_count::integer > 0 AND review_count::integer <= 100 THEN '0 - 100 Reviews'
			WHEN review_count::integer > 100 AND review_count::integer <= 1000 THEN '100 - 1000 Reviews'
			WHEN review_count::integer > 1000 AND review_count::integer <= 10000 THEN '1000 - 10000 Reviews'
			WHEN review_count::integer > 10000 AND review_count::integer <= 100000 THEN '10000 - 100000 Reviews'
			WHEN review_count::integer > 100000 AND review_count::integer <= 1000000 THEN '100000 - 1000000 Reviews' 
	 		ELSE 'Over 1000000 Reviews' END AS review_range,
		rating,
	 	2500*(12+(24*rating)) AS estimated_revenue,
		((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
	FROM app_store_apps
	LEFT JOIN (SELECT 
		name,
		CASE WHEN price > 2.5 THEN price*10000
			ELSE 25000 END AS value
	FROM app_store_apps) AS vc
	USING(name)) AS roi_tbl
GROUP BY review_range
ORDER BY average_roi DESC, perc_profitable DESC;
​
------------------------------------PLAY STORE ONLY-----------------------------------------------
​
--average roi, percent profitable, other stats by price range
​
SELECT 
	price_range,
	COUNT(price_range),
	ROUND(AVG(estimated_revenue),2) AS estimated_revenue,
	MIN(roi),
	MAX(roi),
	ROUND(AVG(roi),2) AS average_roi,
	ROUND(100*COUNT(CASE WHEN roi > 0 THEN 1 END)/(COUNT(roi)),2) AS perc_profitable
FROM(SELECT 
		name, 
		CASE WHEN REPLACE(price, '$', '')::numeric = 0 THEN 'Free'
			WHEN REPLACE(price, '$', '')::numeric > 0 AND REPLACE(price, '$', '')::numeric <= 1 THEN '$0 - $1'
			WHEN REPLACE(price, '$', '')::numeric > 1 AND REPLACE(price, '$', '')::numeric <= 5 THEN '$1 - $5'
			WHEN REPLACE(price, '$', '')::numeric > 5 AND REPLACE(price, '$', '')::numeric <= 10 THEN '$5 - $10'
			WHEN REPLACE(price, '$', '')::numeric > 10 AND REPLACE(price, '$', '')::numeric <= 15 THEN '$10 - $15'
			WHEN REPLACE(price, '$', '')::numeric > 15 AND REPLACE(price, '$', '')::numeric <= 20 THEN '$15 - $20'
			WHEN REPLACE(price, '$', '')::numeric > 20 AND REPLACE(price, '$', '')::numeric <= 50 THEN '$20 - $50'
			ELSE '$50+' END AS price_range,
		rating,
	 	2500*(12+(24*rating)) AS estimated_revenue,
		((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
	FROM play_store_apps
	LEFT JOIN (SELECT 
		name,
		CASE WHEN REPLACE(price, '$', '')::numeric > 2.5 THEN REPLACE(price, '$', '')::numeric*10000
			ELSE 25000 END AS value
	FROM play_store_apps) AS vc
	USING(name)) AS roi_tbl
GROUP BY price_range
ORDER BY average_roi DESC, perc_profitable DESC;
​
--average roi, percent profitable, other stats by review count
SELECT 
	review_range,
	COUNT(review_range),
	ROUND(AVG(estimated_revenue),2) AS estimated_revenue,
	MIN(roi),
	MAX(roi),
	ROUND(AVG(roi),2) AS average_roi,
	ROUND(100*COUNT(CASE WHEN roi > 0 THEN 1 END)/(COUNT(*)),2) AS perc_profitable
FROM(SELECT 
		name, 
		CASE WHEN review_count = 0 THEN 'No Reviews'
			WHEN review_count > 0 AND review_count <= 100 THEN '0 - 100 Reviews'
			WHEN review_count > 100 AND review_count <= 1000 THEN '100 - 1000 Reviews'
			WHEN review_count > 1000 AND review_count <= 10000 THEN '1000 - 10000 Reviews'
			WHEN review_count > 10000 AND review_count <= 100000 THEN '10000 - 100000 Reviews'
			WHEN review_count > 100000 AND review_count <= 1000000 THEN '100000 - 1000000 Reviews' 
	 		ELSE 'Over 1000000 Reviews' END AS review_range,
		rating,
	 	2500*(12+(24*rating)) AS estimated_revenue,
		((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
	FROM play_store_apps
	LEFT JOIN (SELECT 
		name,
		CASE WHEN REPLACE(price, '$', '')::numeric > 2.5 THEN REPLACE(price, '$', '')::numeric*10000
			ELSE 25000 END AS value
	FROM play_store_apps) AS vc
	USING(name)) AS roi_tbl
GROUP BY review_range
ORDER BY perc_profitable DESC, average_roi DESC;


SELECT primary_genre, 
		ROUND(AVG(rating),2) AS avg_rating, 
		SUM(review_count) AS total_review_count,
		ROUND((SUM(review_count)/AVG(rating))/1000,2)
FROM app_store_apps
WHERE rating IS NOT NULL
GROUP BY primary_genre
ORDER BY AVG(rating) DESC;
​
SELECT genres, 
		ROUND(AVG(rating),2) AS avg_rating, 
		SUM(review_count) AS total_review_count,
		ROUND((SUM(review_count)/AVG(rating))/100,2)
FROM play_store_apps
WHERE rating IS NOT NULL
GROUP BY genres
ORDER BY AVG(rating) DESC NULLS LAST;
​
SELECT content_rating, 
		ROUND(AVG(rating),2),
		SUM(review_count)
FROM app_store_apps
WHERE content_rating IS NOT NULL
GROUP BY content_rating
ORDER BY AVG(rating) DESC;
​
SELECT content_rating, 
		ROUND(AVG(rating),2),
		SUM(review_count)
FROM play_store_apps
WHERE content_rating IS NOT NULL
GROUP BY content_rating
ORDER BY AVG(rating) DESC;
​
WITH difference AS
	(SELECT primary_genre,
	((rating*24)+12)*1500 AS total_revenue,
		CASE WHEN price <=2.50 THEN 25000.00
			 WHEN price >2.50 THEN price * 10000
			 END AS purchase_price
	FROM app_store_apps),
genre_count AS
	(SELECT primary_genre, COUNT(primary_genre)
	FROM app_store_apps
	GROUP BY primary_genre)		
SELECT primary_genre,
		COUNT(primary_genre),
		SUM(total_revenue) AS total_genre_revenue,
		SUM(purchase_price) AS total_genre_purchase, 
		SUM(total_revenue-purchase_price) AS roi,
		ROUND((SUM(total_revenue-purchase_price))/COUNT(primary_genre),2) AS revenue_per_genre_game
FROM difference
INNER JOIN genre_count
USING(primary_genre)
GROUP BY primary_genre
ORDER BY revenue_per_genre_game DESC;



-----BOTH STORES
SELECT name, genres, content_rating, price 
FROM play_store_apps;
---name, genres, content_rating, price on playstore
SELECT name, primary_genre, rating, price
FROM app_store_apps;
-- name, genres, rating, price on appstore
WITH apps_ AS (WITH both_apps AS (SELECT name, a.price AS price_a, REPLACE(p.price, '$', '')::numeric AS price_p, 
													 primary_genre, category, a.content_rating AS content_rating_a,                                                            p.content_rating AS content_rating_p, a.rating AS rating_a,                                                          p.rating AS rating_p,
			 CASE WHEN a.price <= 2.50 THEN 25000
			      WHEN a.price > 2.50 THEN 10000 * a.price
				  END AS market_price_a
								  													 
FROM play_store_apps AS P
INNER JOIN app_store_apps AS a
USING(name))
--ORDER BY market_price DESC)
--- found the market_price for app store and created a new table called both_apps
SELECT name, price_a, price_p, primary_genre, category, content_rating_a, content_rating_p,
													 rating_a, rating_p,
	    market_price_a,
	   (2500 * (12 + 24 * rating_a)) AS income_a, (2500 * (12 + 24 * rating_p)) AS income_p,
		(12 + 24 * rating_a) AS longevity_a, (12 + 24 * rating_p) AS longevity_p,
		  CASE WHEN price_p <= 2.50 THEN 25000
			      WHEN price_p > 2.50 THEN 10000 * price_p
				  END AS market_price_p
								  		
								  			
FROM both_apps)
-- found the income, longevity, market price for play store and created a new table called apps_	  
			           
SELECT  category, primary_genre, AVG(rating_a) AS rating_a, AVG(rating_p) rating_p, AVG(market_price_a) AS market_price_a, AVG(market_price_p) AS market_price_p,AVG(income_a) AS income_a, AVG(income_p) AS income_p,
	   (income_a - (1000 * longevity_a + market_price_a)) AS roi_a,
	   (income_p - (1000 * longevity_p + market_price_p)) AS roi_p,
		(income_a - (1000 * longevity_a + market_price_a)) + (income_p - (1000 * longevity_p + market_price_p)) AS roi		   
FROM apps_
GROUP BY category, primary_genre, income_a, income_p, longevity_a, market_price_a, longevity_p, market_price_p
ORDER BY roi DESC;
-- found the return on investment(ROI) 

-- 
--2. Make a recommendation of 10 apps to buy with a sole focus on profitability/return on investment.

SELECT
	DISTINCT pst.name, 
	((2500*(12+(24*pst.rating)))-((1000*(12+(24*pst.rating)))+vcpst.value))+((2500*(12+(24*ast.rating)))-((1000*(12+(24*ast.rating)))+vcast.value)) AS roi
FROM play_store_apps AS pst
INNER JOIN app_store_apps AS ast
USING (name)
LEFT JOIN (SELECT 
	name,
	CASE WHEN REPLACE(price, '$', '')::numeric > 2.5 THEN REPLACE(price, '$', '')::numeric*10000
		ELSE 25000 END AS value
FROM play_store_apps) AS vcpst --determines play store cost of app for app trader
USING(name)
LEFT JOIN (SELECT 
	name,
	CASE WHEN price > 2.5 THEN price*10000
		ELSE 25000 END AS value
FROM app_store_apps) AS vcast --determines app store cost of app for app trader
USING(name)
ORDER BY roi DESC
LIMIT 10;
--3. Make a recommendation of 4 apps that are profitable and also align with the upcoming Pi Day themed campaign (think math or pie related apps!

SELECT DISTINCT a.name, a.rating, p.rating, a.price, p.price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name=p.name
WHERE a.rating >=4.5
AND a.price BETWEEN 0.00 AND 2.50
ORDER BY a.rating DESC

SELECT REPLACE(price, '$', '')::numeric
FROM play_store_apps;
