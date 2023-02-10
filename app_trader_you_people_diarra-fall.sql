SELECT *
FROM app_store_apps;

-- a. Develop some general recommendations about the price range, genre, content rating, or any other app characteristics that the company should target.

/* 
ROI = revenue - cost
	= 2500/month -(1000/month + app cost)
App cost = 
If purchase price > $2.50 then value = 10,000*price
If purchase price <= $2.50 then value = $25,000   

No. of months = 12 + 24(rating)
*/

------------------------------------APP STORE ONLY-----------------------------------------------

-- CASE subquery to calculate cost for app trader to purchase app 
SELECT 
	name,
	CASE WHEN price > 2.5 THEN price*10000
		ELSE 25000 END AS value
FROM app_store_apps;

--Add ROI column to table, show primary genre, sorted by roi
SELECT 
	name, 
	primary_genre,
	rating,
	price,
	((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
FROM app_store_apps
LEFT JOIN (SELECT 
	name,
	CASE WHEN price > 2.5 THEN price*10000
		ELSE 25000 END AS value
FROM app_store_apps) AS vc
USING(name)
ORDER BY roi DESC;

--count of attribute in highest roi bracket
SELECT 
	primary_genre,
	COUNT(primary_genre)
FROM(SELECT 
		name, 
		primary_genre,
		rating,
		price,
		((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
	FROM app_store_apps
	LEFT JOIN (SELECT 
		name,
		CASE WHEN price > 2.5 THEN price*10000
			ELSE 25000 END AS value
	FROM app_store_apps) AS vc
	USING(name)) AS roi_tbl
WHERE roi = 173000
GROUP BY primary_genre
ORDER BY COUNT(primary_genre) DESC;


--percentage of apps in the store by genre
SELECT 
	primary_genre,
	COUNT(primary_genre),
	ROUND(100*COUNT(primary_genre)/(SELECT COUNT(primary_genre)
							FROM app_store_apps),2) AS perc_genre
FROM(SELECT 
		name, 
		primary_genre,
		rating,
		price,
		((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
	FROM app_store_apps
	LEFT JOIN (SELECT 
		name,
		CASE WHEN price > 2.5 THEN price*10000
			ELSE 25000 END AS value
	FROM app_store_apps) AS vc
	USING(name)) AS roi_tbl
GROUP BY primary_genre
ORDER BY perc_genre DESC;

--average roi, percent profitable, other stats by genre
SELECT 
	primary_genre,
	COUNT(primary_genre),
	ROUND(AVG(estimated_revenue),2) AS estimated_revenue,
	MIN(roi),
	MAX(roi),
	ROUND(AVG(roi),2) AS average_roi,
	ROUND(100*COUNT(CASE WHEN roi > 0 THEN 1 END)/(COUNT(roi)),2) AS perc_profitable
FROM(SELECT 
		name, 
		primary_genre,
		rating,
		price,
	 	2500*(12+(24*rating)) AS estimated_revenue,
		((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
	FROM app_store_apps
	LEFT JOIN (SELECT 
		name,
		CASE WHEN price > 2.5 THEN price*10000
			ELSE 25000 END AS value
	FROM app_store_apps) AS vc
	USING(name)) AS roi_tbl
GROUP BY primary_genre
ORDER BY perc_profitable DESC, average_roi DESC;


--average roi, percent profitable, other stats by content rating
SELECT 
	content_rating,
	COUNT(content_rating),
	ROUND(AVG(estimated_revenue),2) AS estimated_revenue,
	MIN(roi),
	MAX(roi),
	ROUND(AVG(roi),2) AS average_roi,
	ROUND(100*COUNT(CASE WHEN roi > 0 THEN 1 END)/(COUNT(roi)),2) AS perc_profitable
FROM(SELECT 
		name, 
		content_rating,
		rating,
		price,
	 	2500*(12+(24*rating)) AS estimated_revenue,
		((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
	FROM app_store_apps
	LEFT JOIN (SELECT 
		name,
		CASE WHEN price > 2.5 THEN price*10000
			ELSE 25000 END AS value
	FROM app_store_apps) AS vc
	USING(name)) AS roi_tbl
GROUP BY content_rating
ORDER BY perc_profitable DESC, average_roi DESC;


--average roi, percent profitable, other stats by content rating

--price range sorting
SELECT name,
		CASE WHEN price = 0 THEN 'Free'
			WHEN price > 0 AND price <= 1 THEN '$0 - $1'
			WHEN price > 1 AND price <= 5 THEN '$1 - $5'
			WHEN price > 5 AND price <= 10 THEN '$5 - $10'
			WHEN price > 10 AND price <= 15 THEN '$10 - $15'
			WHEN price > 15 AND price <= 20 THEN '$15 - $20'
			WHEN price > 20 AND price <= 50 THEN '$20 - $50'
			ELSE '$50+' END AS price_range
FROM app_store_apps;


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
ORDER BY perc_profitable DESC, average_roi DESC;



--average roi, percent profitable, other stats by rating
SELECT 
	rating_range,
	COUNT(rating_range),
	ROUND(AVG(estimated_revenue),2) AS estimated_revenue,
	MIN(roi),
	MAX(roi),
	ROUND(AVG(roi),2) AS average_roi,
	ROUND(100*COUNT(CASE WHEN roi > 0 THEN 1 END)/(COUNT(roi)),2) AS perc_profitable
FROM(SELECT 
		name, 
		CASE WHEN rating = 0 THEN 'No Stars'
			WHEN rating > 0 AND rating <= 1 THEN '0 - 1 Stars'
			WHEN rating > 1 AND rating <= 2 THEN '1 - 2 Stars'
			WHEN rating > 2 AND rating <= 3 THEN '2 - 3 Stars'
			WHEN rating > 3 AND rating <= 4 THEN '3 - 4 Stars'
			WHEN rating > 4 AND rating <= 5 THEN '4 - 5 Stars' END AS rating_range,
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
GROUP BY rating_range
ORDER BY perc_profitable DESC, average_roi DESC;


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
ORDER BY perc_profitable DESC, average_roi DESC;


--ratings and reviews by genre
SELECT 
	primary_genre,
	ROUND(AVG(rating),2) AS average_rating,
	SUM(review_count::numeric) AS total_reviews,
	ROUND(AVG(review_count::numeric/NULLIF(rating,0)),2) AS avg_rev_per_star
FROM app_store_apps
GROUP BY primary_genre
ORDER BY average_rating DESC; 

--ratings and reviews by content rating
SELECT 
	content_rating,
	ROUND(AVG(rating),2) AS average_rating,
	SUM(review_count::numeric) AS total_reviews,
	ROUND(AVG(review_count::numeric/NULLIF(rating,0)),2) AS avg_rev_per_star
FROM app_store_apps
GROUP BY content_rating
ORDER BY average_rating DESC; 

--ratings and reviews by price range
SELECT 
	price_range,
	ROUND(AVG(rating),2) AS average_rating,
	SUM(review_count::numeric) AS total_reviews,
	ROUND(AVG(rev_per_rating),2) AS avg_rev_per_star
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
	 review_count,
	 review_count::numeric/NULLIF(rating,0) AS rev_per_rating
	FROM app_store_apps) AS price_range_tbl
GROUP BY price_range
ORDER BY average_rating DESC; 

/*
Genre Recommendation: Photo & Video
Content Rating Rec: 9+
*/


------------------------------------PLAY STORE ONLY-----------------------------------------------

--count of attribute in highest roi bracket
SELECT 
	genres,
	COUNT(genres)
FROM(SELECT 
		name, 
		genres,
		rating,
		price,
		((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
	FROM play_store_apps
	LEFT JOIN (SELECT 
		name,
		CASE WHEN REPLACE(price, '$', '')::numeric > 2.5 THEN REPLACE(price, '$', '')::numeric*10000
			ELSE 25000 END AS value
	FROM play_store_apps) AS vc
	USING(name)) AS roi_tbl
WHERE roi = 173000
GROUP BY genres
ORDER BY COUNT(genres) DESC;


--percentage of apps in the store by genre
SELECT 
	genres,
	COUNT(genres),
	ROUND(100*COUNT(genres)/(SELECT COUNT(genres)
							FROM play_store_apps),2) AS perc_genre
FROM(SELECT 
		name, 
		genres,
		rating,
		REPLACE(price, '$', '')::numeric,
		((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
	FROM play_store_apps
	LEFT JOIN (SELECT 
		name,
		CASE WHEN REPLACE(price, '$', '')::numeric > 2.5 THEN REPLACE(price, '$', '')::numeric*10000
			ELSE 25000 END AS value
	FROM play_store_apps) AS vc
	USING(name)) AS roi_tbl
GROUP BY genres
ORDER BY perc_genre DESC;

--average roi, percent profitable, other stats by genre
SELECT 
	genres,
	COUNT(genres),
	ROUND(AVG(estimated_revenue),2) AS estimated_revenue,
	MIN(roi),
	MAX(roi),
	ROUND(AVG(roi),2) AS average_roi,
	ROUND(100*COUNT(CASE WHEN roi > 0 THEN 1 END)/(COUNT(*)),2) AS perc_profitable
FROM(SELECT 
		name, 
		genres,
		rating,
		REPLACE(price, '$', '')::numeric,
	 	2500*(12+(24*rating)) AS estimated_revenue,
		((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
	FROM play_store_apps
	LEFT JOIN (SELECT 
		name,
		CASE WHEN REPLACE(price, '$', '')::numeric > 2.5 THEN REPLACE(price, '$', '')::numeric*10000
			ELSE 25000 END AS value
	FROM play_store_apps) AS vc
	USING(name)) AS roi_tbl
GROUP BY genres
ORDER BY perc_profitable DESC, average_roi DESC;


--average roi, percent profitable, other stats by content rating
SELECT 
	content_rating,
	COUNT(content_rating),
	ROUND(AVG(estimated_revenue),2) AS estimated_revenue,
	MIN(roi),
	MAX(roi),
	ROUND(AVG(roi),2) AS average_roi,
	ROUND(100*COUNT(CASE WHEN roi > 0 THEN 1 END)/(COUNT(roi)),2) AS perc_profitable
FROM(SELECT 
		name, 
		content_rating,
		rating,
		REPLACE(price, '$', '')::numeric,
	 	2500*(12+(24*rating)) AS estimated_revenue,
		((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
	FROM play_store_apps
	LEFT JOIN (SELECT 
		name,
		CASE WHEN REPLACE(price, '$', '')::numeric > 2.5 THEN REPLACE(price, '$', '')::numeric*10000
			ELSE 25000 END AS value
	FROM play_store_apps) AS vc
	USING(name)) AS roi_tbl
GROUP BY content_rating
ORDER BY perc_profitable DESC, average_roi DESC;


--average roi, percent profitable, other stats by content rating

--price range sorting
SELECT name,
		CASE WHEN price = 0 THEN 'Free'
			WHEN price > 0 AND price <= 1 THEN '$0 - $1'
			WHEN price > 1 AND price <= 5 THEN '$1 - $5'
			WHEN price > 5 AND price <= 10 THEN '$5 - $10'
			WHEN price > 10 AND price <= 15 THEN '$10 - $15'
			WHEN price > 15 AND price <= 20 THEN '$15 - $20'
			WHEN price > 20 AND price <= 50 THEN '$20 - $50'
			ELSE '$50+' END AS price_range
FROM play_store_apps;


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
ORDER BY perc_profitable DESC, average_roi DESC;



--average roi, percent profitable, other stats by rating
SELECT 
	rating_range,
	COUNT(rating_range),
	ROUND(AVG(estimated_revenue),2) AS estimated_revenue,
	MIN(roi),
	MAX(roi),
	ROUND(AVG(roi),2) AS average_roi,
	ROUND(100*COUNT(CASE WHEN roi > 0 THEN 1 END)/(COUNT(*)),2) AS perc_profitable
FROM(SELECT 
		name, 
		CASE WHEN rating = 0 THEN 'No Stars'
			WHEN rating > 0 AND rating <= 1 THEN '0 - 1 Stars'
			WHEN rating > 1 AND rating <= 2 THEN '1 - 2 Stars'
			WHEN rating > 2 AND rating <= 3 THEN '2 - 3 Stars'
			WHEN rating > 3 AND rating <= 4 THEN '3 - 4 Stars'
			WHEN rating > 4 AND rating <= 5 THEN '4 - 5 Stars' END AS rating_range,
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
GROUP BY rating_range
ORDER BY perc_profitable DESC, average_roi DESC;


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


/*--ratings and reviews by genre
SELECT 
	primary_genre,
	ROUND(AVG(rating),2) AS average_rating,
	SUM(review_count::numeric) AS total_reviews,
	ROUND(AVG(review_count::numeric/NULLIF(rating,0)),2) AS avg_rev_per_star
FROM app_store_apps
GROUP BY primary_genre
ORDER BY average_rating DESC; 

--ratings and reviews by content rating
SELECT 
	content_rating,
	ROUND(AVG(rating),2) AS average_rating,
	SUM(review_count::numeric) AS total_reviews,
	ROUND(AVG(review_count::numeric/NULLIF(rating,0)),2) AS avg_rev_per_star
FROM app_store_apps
GROUP BY content_rating
ORDER BY average_rating DESC; 

--ratings and reviews by price range
SELECT 
	price_range,
	ROUND(AVG(rating),2) AS average_rating,
	SUM(review_count::numeric) AS total_reviews,
	ROUND(AVG(rev_per_rating),2) AS avg_rev_per_star
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
	 review_count,
	 review_count::numeric/NULLIF(rating,0) AS rev_per_rating
	FROM app_store_apps) AS price_range_tbl
GROUP BY price_range
ORDER BY average_rating DESC; 
*/
/*
Genre Recommendation: Photo & Video
Content Rating Rec: 9+
*/


---------------------------------------BOTH STORES-----------------------------------------------

SELECT *
FROM app_store_apps
INNER JOIN play_store_apps
Using(name)


--count of attribute in highest roi bracket
SELECT 
	*
FROM(SELECT *
-- 		name, 
-- 		ast.primary_genre,
-- 		ast.rating,
-- 		--pst.price
-- 	 	--ast.price
-- 		((2500*(12+(24*pst.rating)))-((1000*(12+(24*pst.rating)))+vcpst.value))+((2500*(12+(24*ast.rating)))-((1000*(12+(24*ast.rating)))+vcast.value)) AS roi
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
	FROM app_store_apps) AS vcast --determines play store cost of app for app trader
	USING(name)) AS roi_tbl
WHERE roi = 173000
GROUP BY genres
ORDER BY COUNT(genres) DESC;


--percentage of apps in the store by genre
SELECT 
	genres,
	COUNT(genres),
	ROUND(100*COUNT(genres)/(SELECT COUNT(genres)
							FROM play_store_apps),2) AS perc_genre
FROM(SELECT 
		name, 
		genres,
		rating,
		REPLACE(price, '$', '')::numeric,
		((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
	FROM play_store_apps
	LEFT JOIN (SELECT 
		name,
		CASE WHEN REPLACE(price, '$', '')::numeric > 2.5 THEN REPLACE(price, '$', '')::numeric*10000
			ELSE 25000 END AS value
	FROM play_store_apps) AS vc
	USING(name)) AS roi_tbl
GROUP BY genres
ORDER BY perc_genre DESC;

--average roi, percent profitable, other stats by genre
SELECT 
	genres,
	COUNT(genres),
	ROUND(AVG(estimated_revenue),2) AS estimated_revenue,
	MIN(roi),
	MAX(roi),
	ROUND(AVG(roi),2) AS average_roi,
	ROUND(100*COUNT(CASE WHEN roi > 0 THEN 1 END)/(COUNT(*)),2) AS perc_profitable
FROM(SELECT 
		name, 
		genres,
		rating,
		REPLACE(price, '$', '')::numeric,
	 	2500*(12+(24*rating)) AS estimated_revenue,
		((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
	FROM play_store_apps
	LEFT JOIN (SELECT 
		name,
		CASE WHEN REPLACE(price, '$', '')::numeric > 2.5 THEN REPLACE(price, '$', '')::numeric*10000
			ELSE 25000 END AS value
	FROM play_store_apps) AS vc
	USING(name)) AS roi_tbl
GROUP BY genres
ORDER BY perc_profitable DESC, average_roi DESC;


--average roi, percent profitable, other stats by content rating
SELECT 
	content_rating,
	COUNT(content_rating),
	ROUND(AVG(estimated_revenue),2) AS estimated_revenue,
	MIN(roi),
	MAX(roi),
	ROUND(AVG(roi),2) AS average_roi,
	ROUND(100*COUNT(CASE WHEN roi > 0 THEN 1 END)/(COUNT(roi)),2) AS perc_profitable
FROM(SELECT 
		name, 
		content_rating,
		rating,
		REPLACE(price, '$', '')::numeric,
	 	2500*(12+(24*rating)) AS estimated_revenue,
		((2500*(12+(24*rating)))-((1000*(12+(24*rating)))+vc.value)) AS roi
	FROM play_store_apps
	LEFT JOIN (SELECT 
		name,
		CASE WHEN REPLACE(price, '$', '')::numeric > 2.5 THEN REPLACE(price, '$', '')::numeric*10000
			ELSE 25000 END AS value
	FROM play_store_apps) AS vc
	USING(name)) AS roi_tbl
GROUP BY content_rating
ORDER BY perc_profitable DESC, average_roi DESC;


--average roi, percent profitable, other stats by content rating

--price range sorting
SELECT name,
		CASE WHEN price = 0 THEN 'Free'
			WHEN price > 0 AND price <= 1 THEN '$0 - $1'
			WHEN price > 1 AND price <= 5 THEN '$1 - $5'
			WHEN price > 5 AND price <= 10 THEN '$5 - $10'
			WHEN price > 10 AND price <= 15 THEN '$10 - $15'
			WHEN price > 15 AND price <= 20 THEN '$15 - $20'
			WHEN price > 20 AND price <= 50 THEN '$20 - $50'
			ELSE '$50+' END AS price_range
FROM play_store_apps;


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
ORDER BY perc_profitable DESC, average_roi DESC;



--average roi, percent profitable, other stats by rating
SELECT 
	rating_range,
	COUNT(rating_range),
	ROUND(AVG(estimated_revenue),2) AS estimated_revenue,
	MIN(roi),
	MAX(roi),
	ROUND(AVG(roi),2) AS average_roi,
	ROUND(100*COUNT(CASE WHEN roi > 0 THEN 1 END)/(COUNT(*)),2) AS perc_profitable
FROM(SELECT 
		name, 
		CASE WHEN rating = 0 THEN 'No Stars'
			WHEN rating > 0 AND rating <= 1 THEN '0 - 1 Stars'
			WHEN rating > 1 AND rating <= 2 THEN '1 - 2 Stars'
			WHEN rating > 2 AND rating <= 3 THEN '2 - 3 Stars'
			WHEN rating > 3 AND rating <= 4 THEN '3 - 4 Stars'
			WHEN rating > 4 AND rating <= 5 THEN '4 - 5 Stars' END AS rating_range,
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
GROUP BY rating_range
ORDER BY perc_profitable DESC, average_roi DESC;


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






SELECT *
FROM app_store_apps

SELECT *
FROM play_store_apps;

REPLACE(price, '$', '')::numeric

-- b. Develop a Top 10 List of the apps that App Trader should buy based on profitability/return on investment as the sole priority.

/* 
Same as Q1 but sort by roi desc, limit 10 
*/

-- c. Develop a Top 4 list of the apps that App Trader should buy that are profitable but that also are thematically appropriate for next months's Pi Day themed campaign.

-- c. Submit a report based on your findings. The report should include both of your lists of apps along with your analysis of their cost and potential profits. All analysis work must be done using PostgreSQL, however you may export query results to create charts in Excel for your report.