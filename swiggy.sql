-- 1. FIND CUSTOMERS WHO HAVE NEVER ORDERED
SELECT name 
FROM users 
WHERE user_id NOT IN (SELECT user_id FROM orders);

-- 2. AVERAGE PRICE PER DISH
SELECT f.f_name, AVG(price) 
FROM menu m 
JOIN food f ON f.f_id = m.f_id 
GROUP BY m.f_id;

-- 3. FIND TOP RESTAURANT IN TERMS OF NUMBER OF ORDERS FOR A GIVEN MONTH
SELECT *, MONTHNAME(date) FROM orders;







select * from food;
select * from menu;
select * from orders;
select * from restaurants;
select * from order_details;