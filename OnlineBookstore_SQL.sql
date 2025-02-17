-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
-- \c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- 1. Retrive all books in the "Fiction" Genre

select *
from Books
where Genre= 'Fiction'
 ;

-- 2 Find Book Published after the year 1950
select Title,Published_Year
from Books
where Published_Year> 1950
order by published_year asc
;


-- 3 List of all customer  from canada
select * from customers
where country in ('canada');

select * from customers
where country ='canada';

-- 4) Show orders placed in November 2023:
select * from orders
where Order_Date between '2023-11-01' and '2023-11-30'
order by Order_Date asc;

-- 5) Retrieve the total stock of books available:
select title,sum(stock) as total_stock
from books
group by 1;


-- 6) Find the details of the most expensive book:
select * from Books
order by price desc
limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Books;

select * from orders
where Quantity>1;

select c.Name,c.customer_id,o.quantity,B.Title
From customers c
left join orders o
on c.Customer_ID=o.Customer_ID
left join books B
on b.Book_ID=o.Book_ID
where o.quantity>1;


-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders
where total_amount>20;

-- 9) List all genres available in the Books table:

select distinct(genre) from books
order by genre asc;

-- 10) Find the book with the lowest stock:
select * from books
order by stock 
limit 6;

-- 11) Calculate the total revenue generated from all orders:

select sum(total_amount) as Revenue 
from orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
select distinct (b.genre),sum(O.Quanity) over (partition by b.genre order by b.genre asc)
from books b
left join orders o
on b.Book_id=o.Book_id;
	
-- 1st Method
select distinct(b.Genre),
sum(o.Quantity) over (partition by B.Genre order by b.genre asc) as Qty_Sold
from orders O
Join books B
on O.Book_id=B.Book_id;

-- 2nd Method
select b.Genre,
sum(o.Quantity) as Total_Books_Sold
from orders O
Join books B
on O.Book_id=B.Book_id
group by 1;

select * from orders;
-- 2) Find the average price of books in the "Fantasy" genre:
select * from Books;
select genre, avg(price) as Average_Price
from books
where genre='Fantasy'
group by 1;

-- 3) List customers who have placed at least 2 orders: - Having Clause on group
/*select C.Name,count(O.Order_id) as Order_Count
from Customers C
Join Orders o
ON C.Customer_ID=o.Customer_ID
where o.Quantity>1
group by 1;*/

select o.customer_id,c.name,count(o.order_id) as Order_count
From Orders o
Join customers c
on O.Customer_id= C.Customer_ID
group by o.customer_id,c.name
Having count(order_id)>1;


select * from customers;
-- 4) Find the most frequently ordered book:

select distinct(O.Book_id),B.Title,
count(O.book_id) as COunto
from Orders O
Join books B on o.Book_ID=B.Book_ID
Group by 1,2
order by counto desc
limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

select * from books
where genre='fantasy'
order by price desc
limit 3;


-- 6) Retrieve the total quantity of books sold by each author:
select B.author,sum(O.quantity)  as total_quantity_of_books_sold
from orders O
Join Books B 
ON B.Book_ID=O.Book_Id
Group By 1;

select * from orders;
select * from customers;


-- 7) List the cities where customers who spent over $30 are located:
select distinct (C.City), O.Total_amount
from orders O
JOin Customers C
ON o.Customer_ID=C.Customer_ID
where Total_amount>30
order by Total_Amount ;

select * from customers;
select * from orders;

-- 8) Find the customer who spent the most on orders:

select o.Customer_id,C.Name,
Sum(O.Total_Amount) as Spent
from orders o
JOin Customers C
ON o.Customer_Id= C.Customer_Id
Group by 1,2
order by Spent desc
;

select O.Customer_ID,C.name,
sum(O.total_amount) as Total_spent
from orders O
Join Customers C ON O.customer_ID=C.Customer_ID
group by 1,2
order by Total_spent desc;

-- 9) Calculate the stock remaining after fulfilling all orders:

select B.Book_id,B.Title,B.stock,O.Quantity,
(Sum(B.stock)-sum(O.quantity)) as Remaining_Stock
 from books B
 Join Orders O ON B.Book_ID=O.Book_ID
 Group by 1,2,3,4;
 
 select B.Book_id,
 B.Title,
 B.stock, coalesce(sum(o.quantity),0) as Order_Qty,
 sum(b.stock)-coalesce(sum(o.quantity),0) as Remaining_stock
 from books B
 left join Orders O 
 ON B.Book_ID=O.Book_ID
 Group by 1,2,3;


select * from Orders;
Select * from books;
