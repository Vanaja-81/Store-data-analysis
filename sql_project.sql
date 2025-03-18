#1.	Create A table 
CREATE TABLE Store_Data (
    Row_ID INT PRIMARY KEY, 
    Order_ID VARCHAR(50) NOT NULL,
    Order_Date DATE NOT NULL,
    Ship_Date DATE NOT NULL,
    Ship_Mode VARCHAR(50) NOT NULL,
    Customer_ID VARCHAR(50) NOT NULL,
    Customer_Name VARCHAR(100) NOT NULL,
    Segment VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Postal_Code VARCHAR(20),
    Region VARCHAR(50) NOT NULL,
    Product_ID VARCHAR(50) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Sub_Category VARCHAR(50) NOT NULL,
    Product_Name VARCHAR(255) NOT NULL,
    Sales DECIMAL(10,2) NOT NULL CHECK (Sales >= 0),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Discount DECIMAL(5,2) CHECK (Discount BETWEEN 0 AND 1),
    Profit DECIMAL(10,2),
    Discount_Amount DECIMAL(10,2),
    Years INT,
    Customer_Duration INT,
    Returned_Items INT,
    Return_Reason VARCHAR(255)
);
##2.	Check the raw table
describe sales;

##3.	Import the data which was given
LOAD DATA INFILE 'C:\Users\ravid\Downloads\Glucksort'
INTO TABLE Store_Data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
##4.	First dataset look
select * from sales;

##5️ Database Size
SELECT table_schema AS Database_Name, 
       ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS Size_MB 
FROM information_schema.tables 
GROUP BY table_schema;
##6️ Table Size
SELECT table_name AS Table_Name, 
       ROUND((data_length + index_length) / 1024 / 1024, 2) AS Size_MB 
FROM information_schema.tables 
WHERE table_name = 'sales';
##7️ Dataset Information
##The dataset contains store transactions, including:

#Order Details (Order ID, Dates, Shipping Mode)
#Customer Information (Customer ID, Name, Segment, Duration)
#Location Details (Country, City, State, Postal Code, Region)
#Product Information (Product ID, Category, Subcategory, Product Name)
#Sales & Profit (Sales, Quantity, Discount, Profit)
#Returns (Returned Items, Return Reason)

##8  Row Count of Data
SELECT COUNT(*) AS Row_Count FROM sales;

##9 Column Count of Data
SELECT COUNT(*) AS Column_Count 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'sales';

##10 Check Dataset Information
DESCRIBE sales;

## 11.Get column names of data
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'sales';

##12 Get Column Names with Data Types
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'sales';

##13  Check NULL Values
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'sales' 
AND COLUMN_NAME NOT IN (
    SELECT COLUMN_NAME 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'sales' 
    AND IS_NULLABLE = 'YES'
);

##14 Drop Unnecessary Columns
ALTER TABLE sales DROP COLUMN Row_ID;

##15  Count of Orders from the United States
select count(Order_ID) from sales
where Country='United States';

##16 Find the Unique Product Categories
SELECT DISTINCT category 
FROM sales;

##17.	What is the number of products in each category
SELECT category, COUNT(*) AS product_count  
FROM sales  
GROUP BY category  
ORDER BY product_count;  

##18.	Find the number of Subcategories products that are divided
SELECT COUNT(DISTINCT sub_category) AS sub_category_count  
FROM sales;

##19.	Find the number of products in each sub-category
SELECT sub_category, COUNT(*) AS product_count  
FROM sales  
GROUP BY sub_category  
ORDER BY product_count;

##20. Find the number of unique product names
SELECT COUNT(DISTINCT product_name) AS unique_product_count  
FROM sales;

##21.Which are the Top 10 Products that are ordered frequently
SELECT product_name, COUNT(*) AS order_count  
FROM sales  
GROUP BY product_name  
ORDER BY order_count  
LIMIT 10;

##22. Calculate the cost for each Order_ID with the respective Product Name.
SELECT Order_ID, Product_Name, Sales AS total_cost  
FROM sales;
##23. Calculate % profit for each Order_ID with the respective Product Name.
SELECT Order_ID, Product_Name,  
       Round((Profit / Sales) * 100 ,2)AS profit_percentage  
FROM sales  

##24. Calculate the overall profit of the store
SELECT round(SUM(Profit),2) AS total_profit  
FROM sales;
##25. Calculate percentage profit and group by Product Name and Order_ID.
SELECT Order_ID, Product_Name,  
       round((SUM(Profit) / SUM(Sales)) * 100,2) AS profit_percentage  
FROM sales   
GROUP BY Order_ID, Product_Name  
ORDER BY profit_percentage;
##26. Identify products with below-average sales and profit (potential losses).
WITH avg_values AS (  
    SELECT AVG(Sales) AS avg_sales, AVG(Profit) AS avg_profit  
    FROM sales  
)  
SELECT Product_Name, Sales, Profit  
FROM sales, avg_values  
WHERE Sales < avg_sales OR Profit < avg_profit  
ORDER BY Profit ASC, Sales ASC;
##27. Average sales per sub-category.
SELECT Sub_Category, round(AVG(Sales),2)AS avg_sales  
FROM sales  
GROUP BY Sub_Category  
ORDER BY avg_sales DESC;

##28. Average profit per sub-category.
SELECT Sub_Category, round(AVG(Profit),2)AS avg_profit  
FROM sales  
GROUP BY Sub_Category  
ORDER BY avg_profit DESC;
##29. What is the number of unique customer IDs
SELECT COUNT(DISTINCT Customer_ID) AS unique_customers  
FROM sales;
##30. Find customers who registered during 2014-2016.
SELECT DISTINCT Customer_ID, Customer_Name, Years  
FROM sales  
WHERE Years BETWEEN 2014 AND 2016  
ORDER BY Years;
##31. Calculate the total frequency of each Order_ID by each Customer Name in descending order.
SELECT Order_ID, Customer_Name, COUNT(order_id) AS order_frequency  
FROM sales  
GROUP BY Order_ID, Customer_Name  
ORDER BY order_frequency DESC ;
##32. Calculate the total cost for each Customer Name.
SELECT Customer_Name, round(SUM(Sales),2) AS total_cost  
FROM sales  
GROUP BY Customer_Name  
ORDER BY total_cost;
##33. Display the number of customers in each region in descending order.
SELECT Region, COUNT(DISTINCT Customer_ID) AS customer_count  
FROM sales  
GROUP BY Region  
ORDER BY customer_count;
##34. Find the Top 10 customers who order frequently
SELECT Customer_Name, COUNT(Order_ID) AS total_orders  
FROM sales  
GROUP BY Customer_Name  
ORDER BY total_orders DESC  
LIMIT 10;

##35. Display records for customers who live in California and have postal code 90032.
SELECT * FROM sales  
WHERE States = 'California' AND Postal_Code = 90032;
##36. Find the Top 20 Customers who benefitted the store the most (highest total profit).
SELECT Customer_Name, round(SUM(Profit),2) AS total_profit  
FROM sales  
GROUP BY Customer_Name  
ORDER BY total_profit DESC  
LIMIT 20;
##37. Identify the most and least successful states (Top 10 by total sales).
SELECT States, round(SUM(Sales),2) AS total_sales  
FROM sales  
GROUP BY States  
ORDER BY total_sales DESC  
LIMIT 10;
##38. Number of unique orders
SELECT round(COUNT(DISTINCT Order_ID),2) AS unique_orders  
FROM sales;

##39. Find the total sales of the Superstore
SELECT round(SUM(Sales),2) AS total_sales  
FROM sales;

##40. Calculate the time taken for an order to ship (in integer format) and show 20 records
SELECT Order_ID,  
       DATEDIFF(Ship_Date, Order_Date) AS shipping_days  
FROM sales  
ORDER BY shipping_days DESC  
LIMIT 20;
##41. Extract the year for each Order_ID and Customer_ID along with quantity
SELECT Order_ID, Customer_ID, Quantity, YEAR(Order_Date) AS Order_Year  
FROM sales  
ORDER BY Order_Year DESC;
##42. What is the Sales impact? (Show 20 records)
SELECT Order_ID, Product_Name, Sales, Profit,  
       round((Profit / Sales) * 100,2) AS profit_margin  
FROM sales   
ORDER BY profit_margin  
LIMIT 20;
##43. Find Top 10 Categories (with best Sub-Category within each Category)
SELECT Category,Sub_Category, round(SUM(Sales),2) AS total_sales  
FROM sales  
GROUP BY Sub_Category,Category 
ORDER BY total_sales DESC  
LIMIT 10;
##44. Find Top 10 Sub-Categories
SELECT Sub_Category, round(SUM(Sales),2) AS total_sales  
FROM sales  
GROUP BY Sub_Category  
ORDER BY total_sales DESC  
LIMIT 10;
##45. Find Worst 10 Categories
SELECT Category, round(SUM(Sales),2) AS total_sales  
FROM sales  
GROUP BY Category  
ORDER BY total_sales ASC  
LIMIT 10;
##46. Find Worst 10 Sub-Categories
SELECT Sub_Category, round(SUM(Sales),2) AS total_sales  
FROM sales  
GROUP BY Sub_Category  
ORDER BY total_sales ASC  
LIMIT 10;

##47. Find the number of returned orders
SELECT round(COUNT(*),2) AS returned_orders  
FROM sales  
WHERE Returned_Items = 'Returned';

##48. Find Top 10 Returned Categories
SELECT Category, round(COUNT(*),2) AS return_count  
FROM sales  
WHERE Returned_Items = 'Returned'  
GROUP BY Category  
ORDER BY return_count DESC  
LIMIT 10;

##49. Find Top 10 Returned Sub-Categories
SELECT Sub_Category, round(COUNT(*),2) AS return_count  
FROM sales  
WHERE Returned_Items = 'Returned'  
GROUP BY Sub_Category  
ORDER BY return_count DESC  
LIMIT 10;

##50. Find Top 10 Customers Who Returned Frequently
SELECT Customer_Name, round(COUNT(*),2) AS return_count  
FROM sales  
WHERE Returned_Items = 'Returned'  
GROUP BY Customer_Name  
ORDER BY return_count DESC  
LIMIT 10;

##51. Find Top 20 Cities and States with Higher Returns
SELECT City, States, round(COUNT(*),2) AS return_count  
FROM sales  
WHERE Returned_Items = 'Returned'  
GROUP BY City, States  
ORDER BY return_count DESC  
LIMIT 20;
##52. Check Whether New Customers Are Returning More (Show 20)
SELECT Customer_Duration, round(COUNT(*),2) AS return_count  
FROM sales  
WHERE Returned_Items = 'Returned'  
GROUP BY Customer_Duration 
ORDER BY return_count DESC  
LIMIT 20;
##53. Find Top Reasons for Returns
SELECT Return_Reason, round(COUNT(*),2) AS reason_count  
FROM sales  
WHERE Returned_Items = 'Returned'  
GROUP BY Return_Reason  
ORDER BY reason_count DESC  
LIMIT 10;





































