# 🧹 E-commerce Data Cleaning using MySQL

### 📊 Project Overview
This project demonstrates **advanced data cleaning and analysis in MySQL** using a large, real-world e-commerce dataset containing 500+ rows of messy and inconsistent data.

The objective is to transform raw data into a clean, analysis-ready format for insights.

---

### ⚙️ Tools & Technologies
- **MySQL** – Data cleaning and transformation
- **CSV Dataset** – Raw sales data with duplicates, nulls, and inconsistent values

---

### 🧩 Dataset Description
| Column | Description |
|--------|--------------|
| order_id | Unique ID for each order |
| order_date | Original order date (in inconsistent formats) |
| customer_name | Name of the customer |
| city | Customer city |
| product_name | Name of purchased item |
| category | Product category |
| quantity | Quantity ordered |
| price | Unit price |
| discount | Discount percentage |
| order_status | Current status of the order |

---

### 🧼 Data Cleaning Steps
1. Removed duplicate and null records  
2. Fixed inconsistent date formats (`order_date`)  
3. Standardized text case (city, category)  
4. Converted data types (price → DECIMAL, quantity → INT)  
5. Replaced invalid or missing discounts with 0  
6. Calculated derived columns: `total_price = quantity * price * (1 - discount/100)`

---

### 📊 Analysis Queries
- Total revenue by city  
- Top 10 products by sales  
- Monthly sales trends  
- Customer purchase frequency  
- Category-wise revenue  
- Orders by status (Delivered, Pending, Cancelled)

---

### 🚀 How to Run
1. Open MySQL Workbench  
2. Create database:
   ```sql
   CREATE DATABASE ecommerce_project;
   USE ecommerce_project;
