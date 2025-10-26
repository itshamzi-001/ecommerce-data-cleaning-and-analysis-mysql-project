create database my_project;
use my_project;
select * from ecommerce;

-- Data Cleaning Queries
UPDATE ecommerce
SET customer_name = TRIM(customer_name),
    city = TRIM(city),
    product_name = TRIM(product_name),
    category = TRIM(category),
    payment_method = TRIM(payment_method),
    order_status = TRIM(order_status);
    
    
update ecommerce
SET city = CASE
    WHEN LOWER(city) IN ('lhr','lahore','lahor','lah') THEN 'Lahore'
    WHEN LOWER(city) LIKE 'karachi%' THEN 'Karachi'
    WHEN LOWER(city) IN ('faislabad','faisalabad') THEN 'Faisalabad'
    WHEN LOWER(city) = 'islamabad' THEN 'Islamabad'
    WHEN LOWER(city) = 'multan' THEN 'Multan'
    ELSE city
END;



ALTER TABLE ecommerce ADD clean_quantity INT;
update ecommerce
set clean_quantity = case
when quantity regexp '^[0-9]+$' then quantity
when lower(quantity) = 'two' then 2
else null
end;



ALTER TABLE ecommerce ADD clean_price INT;
update ecommerce
set clean_price = case
when price regexp '^[0-9]+$' then price
else null
end;


ALTER TABLE ecommerce ADD clean_discount DECIMAL(5,2);
UPDATE ecommerce
SET clean_discount = CASE
    WHEN discount LIKE '%percent%' THEN 10
    WHEN discount LIKE '%5%' THEN 5
    WHEN discount LIKE '%10%' THEN 10
    WHEN discount LIKE '%0%' THEN 0
    ELSE NULL
END;


ALTER TABLE ecommerce ADD clean_total DECIMAL(15,2);
update ecommerce
set clean_total  = case
when clean_quantity is not null and clean_price is not null then clean_quantity * clean_price
else null
end;


update ecommerce
set order_status = lower(order_status);

update ecommerce
set order_status = case
when order_status like 'complited' then 'completed'
when order_status like 'completed' then 'completed'
else order_status
end;


ALTER TABLE ecommerce ADD COLUMN clean_order_date DATE;
UPDATE ecommerce
SET clean_order_date =
    CASE
        WHEN order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' THEN STR_TO_DATE(order_date, '%d/%m/%Y')
        WHEN order_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN STR_TO_DATE(order_date, '%Y-%m-%d')
        WHEN order_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN STR_TO_DATE(order_date, '%d-%m-%Y')
        WHEN order_date REGEXP '^[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}$' THEN STR_TO_DATE(order_date, '%d.%m.%Y')
        WHEN order_date REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$' THEN STR_TO_DATE(order_date, '%Y/%m/%d')
        ELSE NULL
    END;


-- Analysis Queries
-- Monthly Sales Trend
SELECT DATE_FORMAT(clean_order_date, '%Y-%m') AS month,
       ROUND(SUM(clean_total),2) AS total_sales
FROM ecommerce
WHERE order_status = 'complete'
GROUP BY month
ORDER BY month;

-- Top 5 Selling Products
select product_name , 
	sum(clean_quantity) as Total_sold,
    round(sum(clean_total) , 2) as Total_revenue
    from ecommerce
    where order_status = 'complete'
    group by product_name
    order by total_sold desc
    limit 5;
    
--     Sales by City
select city , round(sum(clean_total) , 2) as Total_sales
from ecommerce
group by city
order by Total_sales desc;


-- Category Performance
select category , round(sum(clean_total) , 2) as Total_sales
from ecommerce
WHERE order_status = 'complete'
group by category
order by Total_sales desc;


-- Discount Impact on Revenue
SELECT clean_discount AS discount_percent,
       ROUND(AVG(clean_total),2) AS avg_revenue
FROM ecommerce
WHERE clean_discount IS NOT NULL
GROUP BY clean_discount
ORDER BY discount_percent;


-- Payment Method Usage
SELECT payment_method,
       COUNT(*) AS total_orders,
       ROUND(SUM(clean_total),2) AS total_sales ,
       order_status
FROM ecommerce
WHERE order_status = 'complete'
GROUP BY payment_method
ORDER BY total_sales DESC;


-- Top 10 Customers by Spending
SELECT customer_name,
       ROUND(SUM(clean_total),2) AS total_spent
FROM ecommerce
WHERE order_status = 'complete'
group by customer_name
order by total_spent desc limit 10;