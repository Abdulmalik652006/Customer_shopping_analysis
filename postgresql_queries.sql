--Q1which customers used a discount but still spend more than the average purchase amount?
SELECT "Customer ID",
       "Purchase Amount (USD)"
FROM customer;
--Q2 which are the top 5 products with the highest average review rating?
SELECT
    "Item Purchased",
    ROUND(AVG("Review Rating")::numeric, 2) AS "Average Product Rating"
FROM customer
GROUP BY "Item Purchased"
ORDER BY AVG("Review Rating") DESC
LIMIT 5;
--Q3 Compare the average Purchasse Amounts between standard and Express shippping?
SELECT
    "Shipping Type",
    ROUND(AVG("Purchase Amount (USD)")::numeric, 2) AS avg_purchase_amount
FROM customer
WHERE "Shipping Type" IN ('Standard', 'Express')
GROUP BY "Shipping Type";

--Q4 Do subscribed customers spend more?Compare average spend and total revenue between subscibers and non -subscribers.
SELECT
    "Subscription Status",
    COUNT("Customer ID") AS total_customers,
    ROUND(SUM("Purchase Amount (USD)")::numeric, 2) AS "Total Revenue"
FROM customer
GROUP BY "Subscription Status"
ORDER BY "Total Revenue" DESC;
--Q5 which 5 products have the highest percentage of purchaes with discounts applied?
SELECT
    "Item Purchased",
    ROUND(
        100 * SUM(CASE WHEN "Discount Applied" = 'YES' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS "Discount Rate"
FROM customer
GROUP BY "Item Purchased"
ORDER BY "Discount Rate" DESC
LIMIT 5;
--Q6 Segement Customers into New, Returning ,and  Loyal Based on their total 
--number of previous purchases, and show the count of each sgment.
WITH customer_type AS (
    SELECT
        "Customer ID",
        "Previous Purchases",
        CASE
            WHEN "Previous Purchases" = 1 THEN 'New'
            WHEN "Previous Purchases" BETWEEN 2 AND 10 THEN 'Returning'
            ELSE 'Loyal'
        END AS "Customer Segment"
    FROM customer
)
SELECT *
FROM customer_type;
--Q7 What are the top 3 most purhcased products within each category?
WITH item_counts AS (
    SELECT
        "Category",
        "Item Purchased",
        COUNT("Customer ID") AS "Total Orders",
        ROW_NUMBER() OVER (
            PARTITION BY "Category"
            ORDER BY COUNT("Customer ID") DESC
        ) AS "Item Rank"
    FROM customer
    GROUP BY "Category", "Item Purchased"
)

SELECT
    "Item Rank",
    "Category",
    "Item Purchased",
    "Total Orders"
FROM item_counts
WHERE "Item Rank" <= 3
ORDER BY "Category", "Item Rank";

