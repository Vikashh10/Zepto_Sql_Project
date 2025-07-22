create database zepto_sql_project;
use zepto_sql_project;

create table zepto (
  sku_id SERIAL PRIMARY KEY,
  category varchar(120),
  name varchar(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock varchar(120),
  quantity INTEGER
);

-- import data

select * from zepto;

-- data exploration
-- count of rows
select count(*) from zepto;

-- sample data
select * from zepto 
limit 10;

-- differnt product categories
select distinct category from zepto 
order by category;

-- product in stock and out of stock 
select outOfStock, count(sku_id) 
from zepto 
group by outOfStock;

-- product names present multiple times
select name, count(sku_id) as number_of_skus
from zepto 
group by name 
having count(sku_id) > 1
order by count(sku_id) desc;


-- data cleaning
-- products with price = 0
select * from zepto 
where mrp = 0 or discountedsellingprice = 0;
set SQL_SAFE_UPDATES = 0;
delete from zepto 
where mrp = 0;

-- convert paise to rupees
update zepto 
set mrp = mrp/100, discountedSellingPrice = discountedSellingPrice/100;
select mrp, discountedSellingPrice from zepto;

-- business insight queries
-- Q1.Find the top 10 best value products based on the discount percentage. 
select distinct name, mrp, discountPercent
from zepto
order by discountPercent desc
limit 10; 

-- Q2.What are the products with high mrp but out of stock. 
select distinct name, mrp
from zepto 
where outOfStock = "true" and mrp > 300
order by mrp;

-- Q3.Calculate estimated revenue for each category.
select category, sum(discountedSellingPrice * availableQuantity) as total_revenue
from zepto 
group by category
order by total_revenue desc;

-- Q4.Find all products where mrp is greater than 500 and discount is less than 10%. 
select distinct name, mrp, discountPercent
from zepto
where mrp > 500 and discountPercent < 10
order by mrp desc, discountPercent desc; 

-- Q5.Identify the top 5 categories offering the highest average discount percentage. 
select category, 
round(avg(discountPercent),2) as avg_discount
from zepto 
group by category
order by avg_discount desc
limit 5;

-- Q6.Find the price per gram for products above 100g and sort by best value.
select distinct name, weightingms, discountedsellingprice, 
round(discountedsellingprice / weightingms, 2) as price_per_gram
from zepto 
where weightingms >= 100
order by price_per_gram;

-- Q7.Group the products into categories like low, medium and bulk. 
select distinct name, weightingms, 
case when weightingms < 1000 then "low" 
when weightingms < 5000 then "medium" 
else "bulk"
end as weight_category
from zepto;

-- Q8.What is the total inventory weight per category.
select category, sum(weightingms * availablequantity) as total_weight
from zepto 
group by category
order by total_weight;
