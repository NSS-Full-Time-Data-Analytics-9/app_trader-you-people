------------------------------------APP STORE ONLY-----------------------------------------------

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

------------------------------------PLAY STORE ONLY-----------------------------------------------

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

-- b. Develop a Top 10 List of the apps that App Trader should buy based on profitability/return on investment as the sole priority.

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