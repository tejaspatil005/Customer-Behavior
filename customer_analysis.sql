USE shopping_db;

-- Q1 Total revenue by gender
SELECT Gender,
       SUM(`Purchase Amount (USD)`) AS revenue
FROM customer
GROUP BY Gender;


-- Q2 Customers who used discount and spent above average
SELECT `Customer ID`,
       `Purchase Amount (USD)`
FROM customer
WHERE `Discount Applied` = 'Yes'
  AND `Purchase Amount (USD)` >= (
        SELECT AVG(`Purchase Amount (USD)`)
        FROM customer
      );


-- Q3 Top 5 products by average review rating
SELECT `Item Purchased`,
       ROUND(AVG(`Review Rating`), 2) AS avg_rating
FROM customer
GROUP BY `Item Purchased`
ORDER BY avg_rating DESC
LIMIT 5;


-- Q4 Average spend: Standard vs Express shipping
SELECT `Shipping Type`,
       ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_spend
FROM customer
WHERE `Shipping Type` IN ('Standard','Express')
GROUP BY `Shipping Type`;


-- Q5 Subscription comparison
SELECT `Subscription Status`,
       COUNT(*) AS total_customers,
       ROUND(AVG(`Purchase Amount (USD)`),2) AS avg_spend,
       ROUND(SUM(`Purchase Amount (USD)`),2) AS total_revenue
FROM customer
GROUP BY `Subscription Status`
ORDER BY total_revenue DESC;


-- Q6 Top 5 products by discount rate
SELECT `Item Purchased`,
       ROUND(
           100 * SUM(CASE WHEN `Discount Applied` = 'Yes' THEN 1 ELSE 0 END)
           / COUNT(*),2
       ) AS discount_rate
FROM customer
GROUP BY `Item Purchased`
ORDER BY discount_rate DESC
LIMIT 5;


-- Q7 Customer segmentation
SELECT 
    CASE 
        WHEN `Previous Purchases` = 1 THEN 'New'
        WHEN `Previous Purchases` BETWEEN 2 AND 10 THEN 'Returning'
        ELSE 'Loyal'
    END AS customer_segment,
    COUNT(*) AS total_customers
FROM customer
GROUP BY customer_segment;


-- Q8 Top 3 products per category
WITH item_counts AS (
    SELECT `Category`,
           `Item Purchased`,
           COUNT(*) AS total_orders,
           ROW_NUMBER() OVER (
               PARTITION BY `Category`
               ORDER BY COUNT(*) DESC
           ) AS item_rank
    FROM customer
    GROUP BY `Category`, `Item Purchased`
)
SELECT *
FROM item_counts
WHERE item_rank <= 3;


-- Q9 Repeat buyers subscription pattern
SELECT `Subscription Status`,
       COUNT(*) AS repeat_buyers
FROM customer
WHERE `Previous Purchases` > 5
GROUP BY `Subscription Status`;


-- Q10 Revenue by age group
SELECT 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 40 THEN '25-40'
        WHEN Age BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    SUM(`Purchase Amount (USD)`) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;