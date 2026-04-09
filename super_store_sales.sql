                                          -- Data cleaning

-- created database
create database superstore_sale;

-- created raw table
create table sales_raw
(Order_ID varchar(20),
Order_Date date,
Ship_Date date,
Ship_Mode varchar(20),
Customer_ID	varchar(15),
Customer_Name varchar(50),
Segment	varchar(20),
Country varchar(30),
City varchar(30),
State varchar(30),
Postal_Code	text(5),
Region text(5),
Product_ID varchar(30),
Category varchar(50),
Sub_Category varchar(50),
Product_Name varchar(80),
Sales decimal(10,2),
temp_id int auto_increment primary key);

-- copy of raw table
create table sales
(select * from sales_raw);

-- removing duplicates
with cte as
(select *,row_number() over(partition by order_id,Product_ID,Sales order by order_id) as rn
from sales)

delete a
from sales as a 
join cte as b 
on  a.temp_id = b.temp_id -- deleted using unique_id
where rn>1;

-- handling NULL values
select *
from sales
where Sales is null
or Sales = '';

-- Modified inconsistent date format
update sales
set Order_Date = 
      case when Order_Date regexp '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$' 
                 then date_format(str_to_date(Order_Date, '%d/%m/%Y'), '%Y/%m/%d') 
                    else Order_Date 
	 end;
 
-- checking date consistency
select order_date,ship_date
from sales
where ship_date < order_date;

-- standardize text values
select distinct Ship_Mode
from sales; 

select distinct Category
from sales
order by Category; 

-- checking outliers in sales
with ranking as
(select sales,
    ntile(4) over(order by sales) as quartile
from sales),

quartiles as
(select max(case when quartile =1 then sales end) as Q1,
        max(case when quartile =3 then sales end) as Q3
from ranking)

select *,
      Q1 - 1.5*(Q3-Q1) as lower,
      Q3 + 1.5*(Q3-Q1) as upper
from sales
cross join quartiles
where sales < Q1 - 1.5*(Q3-Q1)
   or sales > Q3 +1.5*(Q3-Q1);     -- no outliers ( Real transactions ) 


-- Dropped unnecessary columns
-- Postal_code & Temp_id
alter table sales
drop column Postal_Code,
 drop column temp_id;
 
                                         -- Data analysis
                                         
--  Validating sales drop                                         
                                         
 with qtr as
 (select 
    year(order_Date) as `Year`,
    quarter(order_date) as `Quarter`,
    sum(sales) as total_sales,
    lag(sum(sales)) over(order by year(order_Date),quarter(order_date)) as last_qtr_sales
 from sales
 group by `Year`,`Quarter`)
 
 select `Year`,`Quarter`,total_Sales,last_qtr_sales,
 round((100*(total_Sales - last_qtr_sales)/last_qtr_sales),2) as growth_percentage
 from qtr;
 

-- category wise drop

with qtr as
(select category,year(order_date) as `Year`,quarter(order_date) as `Quarter`,
 sum(sales) as total_sales,
 dense_rank() over(partition by category order by year(order_date) desc,quarter(order_date) desc) as rnk
from sales
group by category,`Year`,`Quarter`),

latest_qtr_sales as
(select category,max(case when rnk =1 then total_sales end) as latest_sales,
  max(case when rnk =2 then total_sales end) as previous_sales
from qtr
group by category) 

select category,latest_sales,previous_sales,
  round(100*(latest_sales-previous_sales)/previous_Sales,2) as change_pct
from latest_qtr_sales
order by change_pct asc;
  

  -- sub_category drop
  
with cte as
(select sub_category,year(order_date) as year,quarter(order_Date) as quarter,
   sum(sales) as total_Sales,
   dense_rank() over(partition by sub_category order by year(order_date) desc,quarter(order_Date) desc) as rnk
from sales
group by Sub_Category,year,quarter),

qtr as
(select sub_category,max(case when rnk =1 then total_sales end) as total_sales,
           max(case when rnk =2 then total_Sales end) as previous_sales
from cte
group by sub_category)

select sub_category,total_sales,previous_sales,
    round(100*(total_sales-previous_sales)/previous_sales,2) as change_pct
from qtr
order by change_pct;


-- Region wise drop

with cte as
(select region,year(order_date) as year,quarter(order_Date) as quarter,
   sum(sales) as total_Sales,
   dense_rank() over(partition by region order by year(order_date) desc,quarter(order_Date) desc) as rnk
from sales
group by region,year,quarter),

qtr as
(select region,max(case when rnk =1 then total_sales end) as total_sales,
           max(case when rnk =2 then total_Sales end) as previous_sales
from cte
group by region)

select region,total_sales,previous_sales,
    round(100*(total_sales-previous_sales)/previous_sales,2) as change_pct
from qtr
order by change_pct;


-- Customer Behaviour

-- New v/s Returning customers
with first_orders as
(select customer_id,min(order_date) as first_order
from sales
group by customer_id)

select 
 (case when year(first_order) = (select year(max(order_date)) from sales)
  and quarter(first_order) = (select quarter(max(order_date)) from sales) 
      then 'New customer' 
      else 'Returning' end) as Customer_type,
      count(distinct s.customer_id) as Total_customers
from sales as s
join first_orders as f
 on s.customer_id = f.customer_id
group by customer_type;


-- Customer order frequency
select 
    customer_id,
    COUNT(order_id) as total_orders,
    SUM(sales) as total_spent
from sales
where year(order_Date) = (select year(max(Order_Date)) from sales)
group by  customer_id
order by total_orders desc;

-- Average order value
select 
    year(order_Date) as `Year`,
    quarter(order_date) as `Quarter`,
    round(SUM(sales)/ count(distinct order_id),2) as average_order_value
from sales
where year(order_Date) = (select year(max(Order_Date)) from sales)
group by `Year`,`Quarter`;

-- Customers spending less?
select year(order_date) as `Year`, 
    quarter(order_date) as `Quarter`,
    avg(sales) as avg_sales_per_order
from sales
where year(order_Date) = (select year(max(Order_Date)) from sales)
group by `Year`,`Quarter`;



-- Revenue Decomposition

with metrics as (
    select year(order_date) as `Year`, 
    quarter(order_date) as `Quarter`,
        count(distinct customer_id) as customers,
        count(distinct order_id) as orders,
        sum(sales) as total_sales
    from sales
    group by `Year`,`Quarter`
)
select *,
       orders / customers as orders_per_customer,
       total_sales / orders as AOV
from metrics;

