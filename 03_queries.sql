use mini_project;
select * from customers;
select * from order_items;
select * from orders;
select * from payments;
select * from products;
select * from product_reviews;


                                                   -- Level 1: Basics 

-- 1. Retrieve customer names and emails for email marketing
select name, email from customers;

-- 2. View complete product catalog with all available details 
select * from products;

-- 3. List all unique product categories 
select distinct category from products;

-- 4. Show all products priced above ₹1,000 
select * from products where price>1000;

-- 5. Display products within a mid-range price bracket (₹2,000 to ₹5,000) 
select * from products where price>=2000 and price<=5000;
select * from products where price between 2000 and 5000;

-- 6. Fetch data for specific customer IDs (e.g., from loyalty program list)
select * from customers where customer_id between 5 and 10;
select * from customers where customer_id in (5,6,7,8,9,10);

-- 7. Identify customers whose names start with the letter ‘A’ 
select * from customers where name like "A%";

-- 8. List electronics products priced under ₹3,000
select * from products where category = "Electronics" and price<=3000;

-- 9. Display product names and prices in descending order of price 
select name, price from products order by price desc;

-- 10. Display product names and prices, sorted by price and then by name 
select name, price from products order by price desc, name;


                                      -- Level 2: Filtering and Formatting 
                                      
-- 1. Retrieve orders where customer information is missing (possibly due to data migration or deletion) 
select * from orders where customer_id = "Null";

-- 2. Display customer names and emails using column aliases for frontend readability 
select name as customer_name, email as customer_email from customers;

-- 3. Calculate total value per item ordered by multiplying quantity and item price
select *, quantity * item_price as total_value from order_items;

-- 4. Combine customer name and phone number in a single column
select *, concat(name,"-",phone) as customer_directory from customers;

-- 5. Extract only the date part from order timestamps for date-wise reporting 
select *, date(order_date) as date from orders order by order_date;

-- 6. List products that do not have any stock left
select * from products where stock_quantity = 0;

                    
                                       -- Level 3: Aggregations
                                       
-- 1. Count the total number of orders placed 
select count(order_id) as total_orders from orders;

-- 2. Calculate the total revenue collected from all orders
select sum(total_amount) as total_revenue from orders;

-- 3. Calculate the average order value 
select avg(total_amount) as Avg_order from orders;

-- 4. Count the number of customers who have placed at least one order
select count(distinct customer_id) as no_of_customers from orders;

-- 5. Find the number of orders placed by each customer
select customer_id, count(customer_id) as no_of_orders from orders group by customer_id;

-- 6. Find total sales amount made by each customer 
select customer_id, sum(total_amount) as Total_sales from orders group by customer_id;

-- 7. List the number of products sold per category
select category, count(*) as no_of_products from products group by category;

-- 8. Find the average item price per category
select category, avg(price) as avg_price from products group by category;

-- 9. Show number of orders placed per day 
select date(order_date) as order_date, count(*) as no_of_orders from orders 
group by date(order_date) order by date(order_date);

-- 10. List total payments received per payment method 
select method, sum(amount_paid) as total_payments from payments group by method;


                                           -- Level 4: Multi-Table Queries (JOINS)
                                           
-- 1. Retrieve order details along with the customer name (INNER JOIN) 
select c.name, o.*
from customers c
inner join orders o
on c.customer_id = o.customer_id;

-- 2. Get list of products that have been sold (INNER JOIN with order_items)
select distinct p.name
from products p
inner join order_items i
on p.product_id = i.product_id;

-- 3. List all orders with their payment method (INNER JOIN) 
select o.order_id, p.method
from orders o
inner join payments p
on o.order_id = p.payment_id
order by o.order_id;

-- 4. Get list of customers and their orders (LEFT JOIN) 
select c.name, o.*
from customers c
left join orders o
on c.customer_id = o.customer_id;

-- 5. List all products along with order item quantity (LEFT JOIN)
select p.name, count(i.quantity) as item_quantity
from products p
left join order_items i
on p.product_id = i.product_id
group by p.name;

-- 6. List all payments including those with no matching orders (RIGHT JOIN)
select * 
from payments p
right join orders o
on p.order_id = o.order_id;

-- 7. Combine data from three tables: customer, order, and payment 
select *
from customers c
join orders o
on c.customer_id = o.customer_id
join payments p
on o.order_id = p.order_id;


                                   -- Level 5: Subqueries (Inner Queries)
						
-- 1. List all products priced above the average product price 
select * from products where price > (select avg(price) from products);

-- 2. Find customers who have placed at least one order 
select count(distinct customer_id) as no_of_customers from orders;

-- 3. Show orders whose total amount is above the average for that customer
select * from 
(select *, avg(total_amount) over(partition by customer_id) as avg_amount from orders) t
where total_amount > avg_amount;

-- 4. Display customers who haven’t placed any orders 
select name from customers where customer_id not in (select customer_id from orders); 

-- 5. Show products that were never ordered 
select name from products where product_id not in (select product_id from order_items);

-- 6. Show highest value order per customer 
select customer_id, max(total_amount) as highest_value from orders group by customer_id;

-- 7. Highest Order Per Customer (Including Names) 
select c.customer_id, c.name, max(o.total_amount) as highest_value
from customers c
left join orders o
on c.customer_id = o.customer_id
group by c.customer_id;


                                             -- Level 6: Set Operations 
                                             
-- 1. List all customers who have either placed an order or written a product review 
select customer_id from orders
union
select customer_id from product_reviews;

-- 2. List all customers who have placed an order as well as reviewed a product [intersect not supported] 
select distinct customer_id from orders
where customer_id in
(select customer_id from product_reviews);

