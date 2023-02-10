SELECT *
FROM app_store_apps;

SELECT *
FROM play_store_apps
ORDER BY price;

SELECT primary_genre, 
		ROUND(AVG(rating),2) AS avg_rating, 
		SUM(review_count) AS total_review_count,
		ROUND((SUM(review_count)/AVG(rating))/1000,2)
FROM app_store_apps
WHERE rating IS NOT NULL
GROUP BY primary_genre
ORDER BY AVG(rating) DESC;

SELECT genres, 
		ROUND(AVG(rating),2) AS avg_rating, 
		SUM(review_count) AS total_review_count,
		ROUND((SUM(review_count)/AVG(rating))/100,2)
FROM play_store_apps
WHERE rating IS NOT NULL
GROUP BY genres
ORDER BY AVG(rating) DESC NULLS LAST;

SELECT content_rating, 
		ROUND(AVG(rating),2),
		SUM(review_count)
FROM app_store_apps
WHERE content_rating IS NOT NULL
GROUP BY content_rating
ORDER BY AVG(rating) DESC;

SELECT content_rating, 
		ROUND(AVG(rating),2),
		SUM(review_count)
FROM play_store_apps
WHERE content_rating IS NOT NULL
GROUP BY content_rating
ORDER BY AVG(rating) DESC;

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


WITH difference AS
	(SELECT content_rating,
	((rating*24)+12)*1500 AS total_revenue,
		CASE WHEN price <=2.50 THEN 25000.00
			 WHEN price >2.50 THEN price * 10000
			 END AS purchase_price
	FROM app_store_apps),
content_count AS
	(SELECT content_rating, COUNT(content_rating)
	FROM app_store_apps
	GROUP BY content_rating)		
SELECT content_rating,
		COUNT(content_rating),
		SUM(total_revenue) AS total_content_revenue,
		SUM(purchase_price) AS total_content_purchase, 
		SUM(total_revenue-purchase_price) AS roi,
		ROUND((SUM(total_revenue-purchase_price))/COUNT(content_rating),2) AS revenue_per_content_game
FROM difference
INNER JOIN content_count
USING(content_rating)
GROUP BY content_rating
ORDER BY revenue_per_content_game DESC;

WITH difference AS
	(SELECT genres,
	((rating*24)+12)*1500 AS total_revenue,
		CASE WHEN price <2.50 THEN 25000.00
			 WHEN price >2.50 THEN price * 10000
			 END AS purchase_price
	FROM play_store_apps),
genre_count AS
	(SELECT genres, COUNT(genres)
	FROM play_store_apps
	GROUP BY genres)		
SELECT genres,
		COUNT(genres),
		SUM(total_revenue) AS total_genre_revenue,
		SUM(purchase_price) AS total_genre_purchase, 
		SUM(total_revenue-purchase_price) AS roi,
		ROUND((SUM(total_revenue-purchase_price))/COUNT(genres),2) AS revenue_per_genre_game
FROM difference
INNER JOIN genre_count
USING(genres)
GROUP BY genres
ORDER BY revenue_per_genre_game DESC NULLS LAST;



SELECT DISTINCT a.name, a.rating, p.rating, a.price, p.price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name=p.name
WHERE a.rating >=4.5
AND a.price BETWEEN 0.00 AND 2.50
ORDER BY a.rating DESC;



SELECT REPLACE(price, '$', '')::numeric
FROM play_store_apps;








