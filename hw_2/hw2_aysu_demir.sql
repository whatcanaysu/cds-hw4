-- Please add the proper SQL query to follow the instructions below  

-- 1) Select ecommerce as your default database 
use ecommerce;

-- 2) Show the PK, name, and quantity per unit from all products

select productId, productname, quantityperunit from products; 



-- 3) Show the number of products ever on sale in our stores

select count(discontinued)
from Products where discontinued is null;


-- 4) Show the number of products in stock (available right now) in our store

select count(UnitsInStock)
from products where UnitsInStock > 0;

--  5) Show the number of products with more orders than stock

select count(ProductId)
from products where UnitsInStock < UnitsOnOrder;


-- 6) List all products available in the store and order them alphabetically from a to z 
-- Show just the first ten products 

select ProductName
from products
where UnitsInStock > 0
order by ProductName asc limit 10;


--  7) Create a new table called scustomers with all the customers from a country that starts with the letter S

create table scustomers LIKE customers;

insert into scustomers(Country) 
select country 
from customers
where country like "s%";

--  8) Delete the previously created table

drop table scustomers;


--  9) Show how many customer the store has from Mexico

select count(CustomerId)
from customers where country="Mexico";


-- 10) Show how many different countries our customers come from

select count(distinct(country)) as DiffrentCountries
from customers;


--  11) Show how many customers are from Mexico, Argentina, or Brazil 
--  whose contact title is  Sales Representative or a Sales Manager

select count(CustomerId) as TotalCount
from customers 
where (ContactTitle ="Sales Representative" or ContactTitle ="Sales Manager") and 
(country ="Mexico" or country ="Argentina" or country ="Brazil");

--  12) Show the number of employees that were 50 years old or more 
--  as at 2014-10-06 (you will probably need to use the DATE_FORMAT function) 

select count(EmployeeID)
from employees
where date_format("2014-10-06","%Y")-date_format(BirthDate, "%Y")>50;


--  13) Show the age of the oldest employee of the company
--  (hint: use the YEAR and DATE_FORMAT functions)

select max(TIMESTAMPDIFF(YEAR, BirthDate, CURDATE())) AS age
from employees;

--  14) Show the number of products whose quantity per unit is measured in bottles

select count(QuantityPerUnit)
from products
where QuantityPerUnit like "%bottles%";

-- 15) Show the number of customers with a Spanish or British common surname
--  (a surname that ends with -on or -ez)

select count(ContactName)
from customers
where ContactName like "%on" or ContactName like "%ez";


--  16) Show how many distinct countries our 
--  customers with a Spanish or British common surname come from
--  (a surname that ends with -on or -ez)

select count(distinct(country))
from customers
where ContactName like "%on" or ContactName like "%ez";

--  17) Show the number of products whose names do not contain the letter 'a'
--  (Note: patterns are not case sensitive)

select count(ProductName)
from products
where ProductName not like "%a%";

--  18) Get the total number of items sold ever.

select sum(Quantity) from order_details;


--  19) Get the id of all products sold at least one time

select distinct(productid) from order_details where quantity > 0;

--  20) Is there any product that was never sold? Which ones?

-- No. There is no product that was never sold. Because in 19th question, we get 77 different product id.
-- If we can check product table like this:
select productid from products;
-- we can see we have 77 products. 
