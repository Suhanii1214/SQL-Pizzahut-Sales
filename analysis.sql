-- Retrieve the total number of orders placed.
SELECT 
    COUNT(*)
FROM
    orders;

-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(o.quantity * p.price), 2) AS total_revenue
FROM
    order_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id
;

-- Identify the highest-priced pizza.
SELECT pt.name, p.size, p.price
FROM pizza_types pt
JOIN pizzas p
ON pt.pizza_type_id = p.pizza_type_id
WHERE p.price = (SELECT MAX(price) FROM pizzas)
;

-- Identify the most common pizza size ordered.
SELECT p.size, COUNT(*) AS pizza_count
FROM pizzas p
JOIN order_details o
ON p.pizza_id = o.pizza_id
GROUP BY size
ORDER BY 2 DESC
;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT pt.pizza_type_id, pt.name, SUM(o.quantity) AS quantity
FROM pizza_types pt
JOIN pizzas p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details o
ON p.pizza_id = o.pizza_id
GROUP BY pt.pizza_type_id, pt.name
ORDER BY quantity DESC
LIMIT 5
;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pt.category, SUM(o.quantity) AS quantity
FROM pizza_types pt
JOIN pizzas p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details o 
ON p.pizza_id = o.pizza_id
GROUP BY pt.category
ORDER BY 2 DESC
;

-- Determine the distribution of orders by hour of the day.
SELECT HOUR(o.order_time) AS hour_of_day, COUNT(o.order_id) AS no_of_orders
FROM orders o
GROUP BY hour_of_day
ORDER BY no_of_orders DESC
;

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT pt.category, COUNT(pt.pizza_type_id)
FROM pizza_types pt
GROUP BY pt.category
;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT ROUND(AVG(quantity),2) AS average_order FROM
(SELECT o.order_date AS date, SUM(od.quantity) AS quantity
FROM order_details od
JOIN orders o
ON od.order_id = o.order_id
GROUP BY date) AS a
;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT pt.name AS pizza, SUM(od.quantity*p.price) AS revenue
FROM pizzas p
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details od
ON od.pizza_id = p.pizza_id
GROUP BY pizza
ORDER BY revenue DESC
LIMIT 3
;

-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT pt.category AS pizza, ROUND((SUM(od.quantity*p.price)/(SELECT SUM(od.quantity*p.price) FROM order_details od JOIN pizzas p ON od.pizza_id=p.pizza_id)*100),2) AS revenue_in_percent
FROM pizzas p
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details od 
ON od.pizza_id = p.pizza_id
GROUP BY pizza
ORDER BY revenue_in_percent DESC
;

-- Analyze the cumulative revenue generated over time.
WITH cum_revenue AS (
	SELECT o.order_date AS `day`,
    SUM(od.quantity*p.price) OVER(ORDER BY o.order_date) AS cumulative_revenue
    FROM pizzas p
	JOIN order_details od
	ON od.pizza_id = p.pizza_id
	JOIN orders o
	ON o.order_id = od.order_id
)
SELECT `day`, MAX(cumulative_revenue) AS cumulative_revenue
FROM cum_revenue
GROUP BY `day`;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT category, name, revenue FROM (
SELECT category, name, revenue,
RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS rn
FROM (
	SELECT pt.name, pt.category,
	SUM(od.quantity*p.price) AS revenue
	FROM pizzas p
	JOIN pizza_types pt
	ON p.pizza_type_id = pt.pizza_type_id
	JOIN order_details od
	ON od.pizza_id = p.pizza_id
	GROUP BY pt.name, pt.category
) as a
) as b WHERE rn <= 3
;

-- Recursive CTEs
WITH RECURSIVE CTE AS (
    SELECT 20 as n
    UNION ALL
    SELECT n-1
    FROM CTE
    WHERE n>1
) 
SELECT Repeat('* ', n) as pattern
FROM CTE;





