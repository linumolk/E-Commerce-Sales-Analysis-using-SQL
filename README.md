# E-Commerce-Sales-Analysis-using-SQL

This repository contains an end-to-end **SQL-based data cleaning, transformation, and analysis project** using MySQL Workbench. The project focuses on analyzing ecommerce sales data to extract meaningful business insights related to sales performance, profitability, customer behavior, and targets.

---

## 📌 Project Overview

The goal of this project is to:

* Clean and standardize raw ecommerce data
* Establish proper relationships between tables
* Perform exploratory and advanced SQL analysis
* Answer real-world business questions using SQL


## 🗂️ Dataset Description

The project uses **three tables**:

### 1. `list_of_orders`

Contains order-level customer and location details.

* Order_ID
* Order_Date
* CustomerName
* State
* City

### 2. `order_details`

Contains product-level transaction details.

* Order_ID
* Category
* Sub_Category
* Amount
* Quantity
* Profit

### 3. `sales_target`

Contains monthly sales targets by category.

* Month_of_Order_Date
* Category
* Target

---

## 🧹 Data Cleaning & Preparation

Key data cleaning steps performed:

* Renamed tables and columns for consistency
* Converted date columns into proper `DATE` format
* Handled NULL values and empty strings
* Standardized data types (INT, DOUBLE, VARCHAR)
* Removed invalid or duplicate records
* Validated negative and zero profit entries

---

## 🔗 Database Relationships

Relationships were created to maintain data integrity:

* **Primary Key**: `list_of_orders.Order_ID`
* **Foreign Key**: `order_details.Order_ID → list_of_orders.Order_ID`
* Unique constraint on `(Category, Month_of_Order_Date)` in `sales_target`

---

## 📊 Key SQL Analysis Performed

### 1️⃣ Threshold-Based Analysis

* Orders with profit exceeding ₹10,000
* Transactions with total value above ₹20,000

### 2️⃣ Temporal Analysis

* Monthly order trends
* Busiest sales months by category

### 3️⃣ Category & Subcategory Insights

* Highest revenue-generating categories
* Lowest performing subcategories

### 4️⃣ Customer Analysis

* High-frequency customers
* Customers spending over ₹1,00,000 annually
* Repeat customer behavior

### 5️⃣ Profitability Analysis

* Most profitable categories and subcategories
* Low profit-margin orders (<5%)

### 6️⃣ Trend Analysis

* Monthly sales and profit trends for top categories
* Last 6 months sales trend by subcategory

### 7️⃣ Anomaly Detection

* Orders with unusually high quantities
* Duplicate order detection

### 8️⃣ Sales Target vs Actual Performance

* Comparison of actual sales against targets
* Monthly profitability patterns

### 9️⃣ Market Basket Analysis

* Frequently purchased subcategory combinations

### 🔟 Location-Based Insights

* Top 10 profitable states and cities
* Customer concentration and product volume by region

---

## 🔍 Key Insights and Recommendations

* All types of clothing made a profit, with the top 3 best-selling sub-categories being sarees, handkerchiefs, and stoles. 
*	Sellers can boost sales by offering complementary products to these items, as customers often buy clothing in pairs. 
*	They should avoid selling electronic games, which resulted in losses, and focus more on printers and accessories, which perform better despite lower quantities.



