-- 1. FIND CUSTOMERS WHO HAVE NEVER ORDERED
SELECT name 
FROM users 
WHERE user_id NOT IN (SELECT user_id FROM orders);


-- 2. AVERAGE PRICE PER DISH
SELECT f.f_name, AVG(price) 
FROM menu m 
JOIN food f ON f.f_id = m.f_id 
GROUP BY m.f_id;


-- 3. FIND TOP RESTAURANT IN TERMS OF NUMBER OF ORDERS FOR A GIVEN MONTH (Lets say July)
SELECT r.r_name, COUNT(*) AS 'number_of_orders'
FROM orders o
JOIN restaurants r
ON o.r_id = r.r_id
WHERE MONTHNAME(date) LIKE 'July'
GROUP BY o.r_id
ORDER BY COUNT(*) DESC
LIMIT 1;


-- 4. RESTAURANTS WITH MONTHLY SALES > x (Lets say 500)
	SELECT r.r_name, SUM(amount) AS 'revenue'
	FROM orders o
	JOIN restaurants r 
	ON o.r_id = r.r_id
	WHERE MONTHNAME(date) LIKE 'JUNE'
	GROUP BY o.r_id
	HAVING revenue>500;


-- 5. SHOW ALL ORDERS WITH ORDER DETAILS FOR A PARTICULAR CUSTOMER IN A PARTICULAR DATE RANGE
SELECT o.order_id, r.r_name, f.f_name
FROM orders o
JOIN restaurants r ON r.r_id = o.r_id
JOIN order_details od ON o.order_id = od.order_id
JOIN food f ON f.f_id = od.f_id
WHERE user_id = (SELECT user_id FROM users WHERE name LIKE 'Neha')
AND (date >= '2022-06-10' AND date <= '2022-07-10');


-- 6. FIND RESTAURANTS WITH MAX REPEATED CUSTOMERS
SELECT r.r_name,COUNT(*) AS 'loyal_customers'
FROM (
	SELECT r_id, user_id, COUNT(*) AS 'visits'
    FROM orders
    GROUP BY r_id, user_id
    HAVING visits>1 
	) t 
JOIN restaurants r
ON r.r_id = t.r_id
GROUP BY t.r_id
ORDER BY loyal_customers DESC LIMIT 1;


-- 7. MONTH OVER MONTH REVENUE GROWTH OF SWIGGY
SELECT month,((revenue-prev)/prev)*100 FROM
	(	
    WITH sales AS
		(
		SELECT MONTHNAME(date) AS 'month', SUM(amount) AS 'revenue'
		FROM orders
		GROUP BY month
		ORDER BY MONTH(date)
        )
	SELECT month, revenue,LAG(revenue,1) OVER(ORDER BY revenue) AS prev FROM sales
    ) t
    
    
-- 8. CUSTOMER --> FAVOURITE FOOD
WITH temp AS 
(
	SELECT o.user_id, od.f_id, COUNT(*) AS 'frequency'
    FROM orders o
    JOIN order_details od
    ON o.order_id = od.order_id
    GROUP BY o.user_id,od.f_id
)
SELECT u.name, f.f_name, t1.frequency
FROM temp t1 
JOIN users u
ON u.user_id = t1.user_id
JOIN food f
ON f.f_id = t1.f_id
WHERE t1.frequency = 
	(SELECT MAX(frequency) 
	FROM temp t2 
	WHERE t2.user_id = t1.user_id
    );

