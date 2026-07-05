drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category varchar(120),
name varchar(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INT,
discountedSellingPrice NUMERIC(8,2),
weightInGram INT,
outOfStock BOOLEAN,
quantity INT
);
--data exploration
--table display
select * from zepto;

--count  of rows
select count (*) from zepto;

--sample data
select * from zepto limit 10;

--null values
select * from zepto 
where name is NUll
OR 
category is NUll
OR 
mrp is NUll
OR
discountPercent is NUll
OR 
discountedSellingPrice is NUll
OR 
weightInGram is NUll
OR 
availableQuantity is NUll
OR 
outOfStock is NUll
OR 
quantity is NUll;

--different product categories
select distinct category from zepto
order by category;

--product in stock and in out of stock
select outOfStock, count(sku_id)
from zepto
group by outOfStock;


--product names present multiple times
select name, count(sku_id) as "Number of SKUs"
from zepto
group by name having count(sku_id)> 1
order by count(sku_id) desc;

--data cleaning

--product with price =0
select * from zepto where mrp=0 or discountedSellingPrice=0;

delete from zepto where mrp=0 or discountedSellingPrice=0;

--convert paise to rupees
update zepto set mrp= mrp/100.0,
discountedSellingPrice= discountedSellingPrice/100.0;

select mrp, discountedSellingPrice from zepto; 

--Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name,mrp,discountPercent from zepto 
order by discountPercent  desc limit 10;


--Q2.What are the Products with High MRP but Out of Stock
select distinct name, mrp from zepto where outOfStock= True and mrp>300
order by mrp desc;

--Q3.Calculate Estimated Revenue for each category
select category,
sum(discountedSellingPrice * availableQuantity) as total_revenue 
from zepto
group by category
order by total_revenue;

--Q4.Find all products where MRP is greater than ₹500 and discount is less than 10%.
select  distinct name, mrp, discountPercent from zepto
where mrp>500 and discountPercent < 10.0
order by mrp desc, discountPercent desc;

--Q5.Identify the top 5 categories offering the highest average discount percentage.
select category,
round(avg(discountPercent),2) as average_discount
from zepto group by category
order by average_discount desc
limit 5;

--Q6.Find the price per gram for products above 100g and sort by best value.
select distinct name, weightInGram, discountedSellingPrice,
round(discountedSellingPrice/weightInGram,2) as price_per_gram
from zepto
where weightInGram >=100
order by price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
select distinct name, weightInGram,
case when weightInGram <1000 Then 'low'
     when weightInGram <5000 Then 'medium'
	 else 'bluk'
	 end as weight_category
from zepto;

--Q8.What is the Total Inventory Weight Per Category
select category,
sum( weightInGram * availableQuantity) as total_weight
from zepto
group by category
order by total_weight;