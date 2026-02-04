-- 							  E-COMMERCE SALES ANALYSIS

CREATE DATABASE ecommerce_sales;
USE ecommerce_sales;

RENAME TABLE `list of orders` TO list_of_orders;
RENAME TABLE `order details` TO order_details;
RENAME TABLE `sales target` TO sales_target;


-- Successful import of data
SELECT * FROM ecommerce_sales.list_of_orders LIMIT 10;

SELECT * FROM ecommerce_sales.order_details LIMIT 10;

SELECT * FROM ecommerce_sales.sales_target LIMIT 10;

-- to check table schema
-- List of Orders Table

DESCRIBE ecommerce_sales.list_of_orders;

ALTER TABLE ecommerce_sales.list_of_orders
RENAME COLUMN `Order ID` to Order_ID;

ALTER TABLE ecommerce_sales.list_of_orders
RENAME COLUMN `Order Date` to Order_Date;

-- Update the column with the correct date format

UPDATE ecommerce_sales.list_of_orders
SET Order_Date = STR_TO_DATE(Order_Date, '%d-%m-%Y')
WHERE Order_Date IS NOT NULL AND Order_Date != '';

UPDATE ecommerce_sales.list_of_orders
SET Order_Date = NULL
WHERE Order_Date IS NULL OR Order_Date = '';

SELECT DISTINCT Order_Date FROM ecommerce_sales.list_of_orders;

ALTER TABLE ecommerce_sales.list_of_orders
MODIFY COLUMN Order_Date DATE;

ALTER TABLE ecommerce_sales.list_of_orders
MODIFY COLUMN Order_ID VARCHAR(255) NOT NULL,
MODIFY COLUMN Order_Date DATE,
MODIFY COLUMN CustomerName VARCHAR(255),
MODIFY COLUMN State VARCHAR(255),
MODIFY COLUMN City VARCHAR(255);

-- Order Details Table
DESCRIBE ecommerce_sales.order_details;

ALTER TABLE ecommerce_sales.order_details
rename COLUMN `Order ID` to Order_ID;

ALTER TABLE ecommerce_sales.order_details
rename COLUMN `Sub-Category`  to sub_category;

-- Change data types of columns

ALTER TABLE ecommerce_sales.order_details
MODIFY COLUMN Order_ID VARCHAR(255),       
MODIFY COLUMN Amount INT,                   
MODIFY COLUMN Profit DOUBLE,               
MODIFY COLUMN Quantity INT,                 
MODIFY COLUMN Category VARCHAR(255),        
MODIFY COLUMN sub_category VARCHAR(255);    

SELECT Amount FROM ecommerce_sales.order_details WHERE Amount NOT LIKE '%[0-9]%';

UPDATE ecommerce_sales.order_details
SET Amount = ROUND(Amount);


-- Sales Target Table
DESCRIBE ecommerce_sales.sales_target;

ALTER TABLE ecommerce_sales.sales_target
rename COLUMN `Month of Order Date`  to Month_of_Order_Date;

SELECT DISTINCT Month_of_Order_Date 
FROM ecommerce_sales.sales_target;

UPDATE ecommerce_sales.sales_target
SET Month_of_Order_Date = NULL
WHERE Month_of_Order_Date IS NULL OR Month_of_Order_Date = '';

UPDATE ecommerce_sales.sales_target
SET Month_of_Order_Date = TRIM(Month_of_Order_Date);

SELECT DISTINCT Month_of_Order_Date 
FROM ecommerce_sales.sales_target;

SELECT Month_of_Order_Date 
FROM ecommerce_sales.sales_target
WHERE STR_TO_DATE(Month_of_Order_Date, '%b-%y') IS NULL;


ALTER TABLE ecommerce_sales.sales_target
MODIFY COLUMN Month_of_Order_Date VARCHAR(15),  
MODIFY COLUMN Category VARCHAR(255),      
MODIFY COLUMN Target INT; 

-- Cleaning the data
SELECT * FROM ecommerce_sales.list_of_orders WHERE CustomerName IS NULL OR State IS NULL;

-- Counting Rows with NULLs
SELECT COUNT(*) AS Null_CustomerName
FROM ecommerce_sales.list_of_orders
WHERE CustomerName IS NULL;

SELECT COUNT(*) AS Null_State
FROM ecommerce_sales.list_of_orders
WHERE State IS NULL;

DELETE FROM list_of_orders
WHERE Order_date IS NULL
  AND Customername IS NULL
  AND state is NULL
  AND city is NULL;


-- Checking for Empty Strings
SELECT *
FROM ecommerce_sales.list_of_orders
WHERE CustomerName = '' OR State = '';

SELECT *
FROM ecommerce_sales.list_of_orders
WHERE order_id = '' OR city = '';

-- Cleaning Empty Strings
-- To replace empty strings with NULL values

UPDATE ecommerce_sales.list_of_orders
SET CustomerName = NULL
WHERE CustomerName = '';

UPDATE ecommerce_sales.list_of_orders
SET State = NULL
WHERE State = '';

UPDATE ecommerce_sales.list_of_orders
SET city = NULL
WHERE city = '';

UPDATE ecommerce_sales.list_of_orders
SET State = NULL
WHERE State = '';

UPDATE ecommerce_sales.list_of_orders
SET Order_ID = 'Unknown'
WHERE Order_ID = '';


-- Verfying
SELECT * FROM ecommerce_sales.list_of_orders
WHERE CustomerName = '' OR State = '' or city = '';

SELECT * FROM ecommerce_sales.list_of_orders
WHERE order_id = 'Unknown';


-- Checking for null values
SELECT * FROM ecommerce_sales.list_of_orders
WHERE CustomerName IS NULL OR State IS NULL;

SELECT * FROM ecommerce_sales.list_of_orders;

SELECT * FROM ecommerce_sales.order_details WHERE Profit < 0; -- Negative profits might be incorrect

SELECT * FROM ecommerce_sales.sales_target WHERE Target IS NULL OR Target < 0;

-- order details
SELECT * FROM ecommerce_sales.order_details WHERE order_id IS NULL OR amount IS NULL
OR profit IS NULL OR quantity IS NULL OR category IS NULL OR sub_category IS NULL;

   
   -- Checking for empty strings in order_id
SELECT * 
FROM ecommerce_sales.order_details
WHERE order_id = '';

-- Checking for empty strings in amount
SELECT * 
FROM ecommerce_sales.order_details
WHERE amount = '';

-- Checking for empty strings in profit
SELECT * 
FROM ecommerce_sales.order_details -- empty string
WHERE profit = '';

-- Checking for empty strings in quantity
SELECT * 
FROM ecommerce_sales.order_details
WHERE quantity = '';

-- Checking for empty strings in category
SELECT * 
FROM ecommerce_sales.order_details
WHERE category = '';

-- Checking for empty strings in sub_category
SELECT * 
FROM ecommerce_sales.order_details
WHERE sub_category = '';

   
SELECT * FROM ecommerce_sales.order_details
WHERE profit = 0; -- amount = 0 or quantity = 0;
   
DELETE FROM ecommerce_sales.order_details
WHERE Profit = '';

DELETE FROM ecommerce_sales.order_details
WHERE Profit = 0; 

SELECT * FROM ecommerce_sales.order_details
WHERE category = 'N/A' OR sub_category = 'N/A';
   
SELECT * FROM ecommerce_sales.order_details
WHERE category = '' OR sub_category = '';

SELECT * FROM ecommerce_sales.order_details; 

--  Sales Target
select * from sales_target;

SELECT * FROM sales_target
WHERE month_of_order_date IS NULL OR ''; 

SELECT * FROM sales_target
WHERE category IS NULL OR ''; 

SELECT * FROM sales_target
WHERE target IS NULL OR ''; 


-- HANDLED THE REALTIONSHIP BETWEEN TABLES

-- list_of_orders <-> Order_details

ALTER TABLE list_of_orders
ADD UNIQUE (Order_ID);

ALTER TABLE order_details
ADD CONSTRAINT FK_OrderDetails_Orders
FOREIGN KEY (Order_ID) REFERENCES list_of_Orders(Order_ID);


 -- Order_details <-> sales_target
 
ALTER TABLE sales_target
ADD CONSTRAINT unique_category_month UNIQUE (Category, Month_Of_Order_Date);

ALTER TABLE order_details
ADD CONSTRAINT FK_Order_Details_sales_target
FOREIGN KEY (Category) REFERENCES sales_target(Category);


-- ANALYSIS

-- 1. Threshold-Based Analysis
-- Orders with Total Profit Exceeding ₹10,000
SELECT Order_ID, SUM(Profit) AS Total_Profit
FROM ecommerce_sales.order_details
GROUP BY Order_ID
HAVING Total_Profit > 10000;

-- Identify transactions where the total price (price × quantity) exceeds ₹20,000.
-- Transactions Where Total Price Exceeds ₹20,000
SELECT Order_ID, (Amount * Quantity) AS Total_Price
FROM ecommerce_sales.order_details
WHERE (Amount * Quantity) > 20000;

-- 2. Temporal Patterns
-- Which Months See the Highest Number of Orders?
SELECT MONTH(Order_Date) AS Order_Month, COUNT(Order_ID) AS Total_Orders
FROM ecommerce_sales.list_of_orders
GROUP BY Order_Month
ORDER BY Total_Orders DESC;

-- What Are the Busiest Sales Months for Each Product Category?
SELECT MONTH(lo.Order_Date) AS Order_Month, od.Category, COUNT(od.Order_ID) AS Total_Orders
FROM ecommerce_sales.list_of_orders lo
JOIN ecommerce_sales.order_details od ON lo.Order_ID = od.Order_ID
GROUP BY Order_Month, od.Category
ORDER BY od.Category, Total_Orders DESC;

-- 3. Category and Subcategory Insights
-- Which Product Categories Generate the Highest Revenue?
-- calculating total revenue for each category to identify the top-performing categories.
SELECT od.Category, 
       SUM(od.Amount * od.Quantity) AS Total_Revenue
FROM ecommerce_sales.order_details od
GROUP BY od.Category
ORDER BY Total_Revenue DESC;

-- Which Subcategories Have the Lowest Total Revenue?
-- calculating total revenue for each subcategory to identify underperforming subcategories.
SELECT od.Category, 
       od.Sub_Category, 
       SUM(od.Amount * od.Quantity) AS Total_Revenue
FROM ecommerce_sales.order_details od
GROUP BY od.Category, od.Sub_Category
ORDER BY Total_Revenue ASC
LIMIT 5;

-- 4. High-Volume Customers
-- Customers Who Placed More Than 20 Orders in a Single Month.
SELECT lo.CustomerName, 
       MONTH(lo.Order_Date) AS Order_Month, 
       COUNT(lo.Order_ID) AS Total_Orders
FROM ecommerce_sales.list_of_orders lo
GROUP BY lo.CustomerName, MONTH(lo.Order_Date)
HAVING Total_Orders > 20
ORDER BY Total_Orders DESC;

-- Customers Whose Total Spending Exceeds ₹1,00,000 in a Year.
SELECT lo.CustomerName, 
       YEAR(lo.Order_Date) AS Order_Year, 
       SUM(od.Amount * od.Quantity) AS Total_Spending
FROM ecommerce_sales.list_of_orders lo
JOIN ecommerce_sales.order_details od 
  ON lo.Order_ID = od.Order_ID
GROUP BY lo.CustomerName, YEAR(lo.Order_Date)
HAVING Total_Spending > 100000
ORDER BY Total_Spending DESC;

-- 5. Profitability Analysis
-- Which subcategories contribute to the highest profits?
SELECT od.Category, 
       od.Sub_Category, 
       SUM(od.Profit) AS Total_Profit
FROM ecommerce_sales.order_details od
GROUP BY od.Category, od.Sub_Category
ORDER BY Total_Profit DESC;


-- List all orders where the profit margin (profit ÷ price) is less than 5%.
-- calculating the profit margin for each order and filters those with a margin below 5%.
SELECT od.Order_ID, 
       od.Category, 
       od.Sub_Category, 
       od.Profit, 
       od.Amount AS Price, 
       (od.Profit / od.Amount) * 100 AS Profit_Margin_Percentage
FROM ecommerce_sales.order_details od
WHERE (od.Profit / od.Amount) < 0.05
ORDER BY Profit_Margin_Percentage ASC;

-- 6. Trend Analysis
-- Analyze monthly trends in sales and profit for the top 3 categories.
-- Step 1: Identify the top 3 categories based on total sales.
SELECT Category, 
       SUM(Amount * Quantity) AS Total_Sales
FROM ecommerce_sales.order_details
GROUP BY Category
ORDER BY Total_Sales DESC
LIMIT 3;

-- Step 2: Analyze monthly sales and profit trends for these categories.
SELECT od.Category, 
       MONTH(lo.Order_Date) AS Month, 
       SUM(od.Amount * od.Quantity) AS Total_Sales, 
       SUM(od.Profit) AS Total_Profit
FROM ecommerce_sales.order_details od
JOIN ecommerce_sales.list_of_orders lo ON od.Order_ID = lo.Order_ID
WHERE od.Category IN ('Electronics', 'Furniture', 'Clothing')
GROUP BY od.Category, MONTH(lo.Order_Date)
ORDER BY od.Category, MONTH;


-- What are the monthly sales trends for each subcategory over the last 6 months in the dataset?
SELECT od.Sub_Category, 
       YEAR(lo.Order_Date) AS Year, 
       MONTH(lo.Order_Date) AS Month, 
       SUM(od.Amount * od.Quantity) AS Monthly_Sales
FROM ecommerce_sales.order_details od
JOIN ecommerce_sales.list_of_orders lo ON od.Order_ID = lo.Order_ID
WHERE lo.Order_Date >= (
    SELECT MAX(Order_Date) - INTERVAL 6 MONTH FROM ecommerce_sales.list_of_orders
)
GROUP BY od.Sub_Category, YEAR(lo.Order_Date), MONTH(lo.Order_Date)
ORDER BY  od.Sub_Category, YEAR, MONTH desc;

-- 7. Anomaly Detection
-- Identify Orders with Unusually High Quantities for the Subcategory?
-- calculates the average quantity for each subcategory 
-- and identifies orders with quantities significantly higher than the average.

SELECT od.Order_ID, 
       od.Sub_Category, 
       od.Quantity, 
       AVG(od.Quantity) OVER (PARTITION BY od.Sub_Category) AS Avg_Quantity,
       CASE 
           WHEN od.Quantity > (AVG(od.Quantity) OVER (PARTITION BY od.Sub_Category) * 2) 
           THEN 'Anomaly'
           ELSE 'Normal'
       END AS Quantity_Anomaly
FROM ecommerce_sales.order_details od
ORDER BY od.Sub_Category, od.Quantity DESC;

-- Find Cases Where the Same Order_ID Appears More Than Once in Order Details
-- identifies duplicate entries for Order_ID in the order_details table.
SELECT od.Order_ID, 
       COUNT(*) AS Duplicate_Count
FROM ecommerce_sales.order_details od
GROUP BY od.Order_ID
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;


-- 8. Sales Target and Seasonality
-- Check the monthly profitability and monthly quantity sold to see if there are patterns in the dataset.

SELECT od.category, DATE_FORMAT(order_date, '%m')  AS order_month, sum(quantity) AS quantity_sold,
SUM(profit) AS total_profit 
FROM list_of_orders o JOIN order_details od ON o.order_id = od.order_id 
GROUP BY od.category,DATE_FORMAT(order_date, '%m') ORDER BY sum(profit) DESC;  

-- Compare the sales target and actual sales for each product in each month.

select od.category, sum(st.target) as Sales_target, sum(od.amount) as Actual_Sales from  
Sales_target st join order_details od group by od.category order by sales_target desc;

-- 9. Customer Behaviour
-- Identify repeat customers and their total spending over time.

SELECT od.category, customername,  count(o.order_id) AS Total_Orders , sum(amount) AS Total_Spending
FROM list_of_orders o JOIN order_details od ON o.order_id = od.order_id 
GROUP BY od.category, customername HAVING count(customername) > 1 ORDER BY Total_orders DESC limit 10 ;

 -- Find the top 5 new customers who made purchases in the year 2019 and their cities and states.
    
SELECT customername, city , state FROM list_of_orders WHERE YEAR(order_date) = 2019 LIMIT 5;

    
-- 10. Category and Subcategory performnace
-- Total sales, profit and quantity sold by category and sub_category
SELECT category , SUM(profit) AS total_profit, SUM(amount) AS total_sales
FROM order_details GROUP BY category
ORDER BY sum(profit) DESC;

SELECT  sub_category, category , SUM(profit) AS total_profit, SUM(amount) AS total_sales ,
SUM(quantity)  AS total_quantity 
FROM order_details GROUP BY category, sub_category
ORDER BY SUM(profit) DESC;
    
-- 11.Inventory Insights
-- 	Identify subcategories with frequent high-quantity orders

SELECT od.category, od.sub_category, sum(od.quantity) AS total_quantity, sum(profit) AS Total_profit FROM order_details od WHERE od.quantity > 5
GROUP BY od.category, od.sub_category HAVING sum(quantity) > 5 ORDER BY sum(quantity) DESC limit 10;


-- 12. Cross-Category Insights (Market Basket Analysis)
-- Find frequently purchased subcategory pairs (e.g., Electronics + Accessories).

SELECT od1.`Sub_Category` AS Sub_Category1, od2.`Sub_Category` AS Sub_Category2, COUNT(*) AS PairCount
FROM  `order_details` od1 JOIN `order_details` od2 ON od1.`Order_ID` = od2.`Order_ID`
WHERE 
    od1.`Sub_Category` != od2.`Sub_Category`
GROUP BY 
    od1.`Sub_Category`, od2.`Sub_Category`
ORDER BY 
    PairCount DESC;
    
-- 13. State and City wise profitability
  -- Top 10 profitable states & cities so that the company can expand its business.
  -- number of products sold and the number of customers in these top 10 profitable states & cities.  

SELECT city, state, SUM(od.Profit) AS TotalProfit,
SUM(od.Quantity) AS TotalProductsSold, COUNT(DISTINCT o.CustomerName) AS NumberOfCustomers
FROM list_of_orders o 
JOIN order_details od ON o.order_id = od.order_id GROUP BY o.state, o.city 
ORDER BY  totalprofit DESC limit 10;


