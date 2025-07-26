-- ONLINE BOOK STORE

DROP TABLE IF EXISTS books;
CREATE TABLE books
(
	book_id SERIAL PRIMARY KEY,
	title VARCHAR(100),
	author VARCHAR(100),
	genre VARCHAR(50),
	published_year INT,
	price NUMERIC(10,2),
	stock INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE customers
(
	customer_id SERIAL PRIMARY KEY,
	name VARCHAR(100),
	email VARCHAR(100),
	phone VARCHAR(15),
	city VARCHAR(50),
	country VARCHAR(150)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders
(
	order_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(customer_id),
	book_id INT REFERENCES books(book_id),
	order_date DATE,
	quantity INT,
	total_amount NUMERIC(10,2)
);

SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;

-- BASIC QUERIES:

-- 1: Retrive all books in the "Fiction" genre

SELECT * FROM books
WHERE genre = 'Fiction';

-- 2: Find books published after year 1950

SELECT * FROM books
WHERE published_year > 1950;

-- 3: List all the customers from Canada

SELECT customer_id, name, country FROM customers
WHERE country = 'Canada';

-- 4: Show orders placed in November 2023

SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30'
ORDER BY order_date ASC;

-- 5: Retrive the total stock of books available

SELECT SUM(stock) AS total_stock_books FROM books;

-- 6: Find details of most expensive book

SELECT * FROM books ORDER BY price DESC LIMIT 1;

-- 7: Show all customers who order more than 1 quantity of book

SELECT c.customer_id, c.name, o.quantity
FROM customers c JOIN orders o
ON c.customer_id = o.customer_id 
WHERE o.quantity > 1;

SELECT c.customer_id, c.name, o.quantity  -- using INNER JOIN
FROM customers c INNER JOIN orders o
ON c.customer_id = o.customer_id 
WHERE o.quantity > 1;

SELECT * FROM orders WHERE quantity > 1;

-- 8: Tetrive all orders where total amount exceeds $20

SELECT * FROM orders WHERE total_amount > 20;

-- 9: Retrive all the genres available in book table

SELECT DISTINCT(genre) FROM books;

-- 10: Find the book with lowest stock

SELECT * FROM books ORDER BY stock ASC LIMIT 1;

-- 11: Calculate the total revenue(total_amount) generated from all orders

SELECT SUM(total_amount) AS revenue FROM orders;


-- ADVANCE QUERIES:

-- 1: Retrive the total number of books sold from each genre

SELECT b.genre, SUM(o.quantity) AS total_sold
FROM orders o JOIN books b
ON b.book_id = o.book_id
GROUP BY b.genre;

-- 2: Find the average price of books in the "Fantasy" genre

SELECT genre, AVG(price) AS avg_price FROM books
WHERE genre = 'Fantasy'
GROUP BY genre;
    -- OR
SELECT genre, SUM(stock) AS total_available, AVG(price) AS avg_price FROM books
WHERE genre = 'Fantasy'
GROUP BY genre;

-- 3: List the customers who have placed at least 2 orders

SELECT o.customer_id, c.name, COUNT(o.order_id) AS order_count   -- with customer name
FROM orders o JOIN customers c ON c.customer_id = o.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(o.order_id) >= 2; --to apply condition on aggregate function
   -- OR
SELECT customer_id, COUNT(order_id) AS order_count FROM orders   -- without customer_name
GROUP BY customer_id
HAVING COUNT(order_id) >= 2;

-- 4: Find most frequently ordered book

SELECT o.book_id, b.title, COUNT(o.order_id) AS order_count   -- with book title
FROM orders o JOIN books b ON o.book_id = b.book_id
GROUP BY o.book_id, b.title
ORDER BY order_count DESC;
   -- OR
SELECT book_id, COUNT(order_id) AS order_count FROM orders   -- without book title
GROUP BY book_id
ORDER BY order_count DESC;

-- 5: Show the top 3 most expensive books of 'Fantasy' genre

SELECT * FROM books WHERE genre = 'Fantasy'
ORDER BY price DESC LIMIT 3;

-- 6: Retrive the total quantity of books sold by each author

SELECT b.author, SUM(o.quantity) AS books_sold
FROM books b LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.author;

--SELECT author, COUNT(book_id) AS books_written FROM books GROUP BY author HAVING COUNT(book_id) > 1;

-- 7: List the cities where customers who spent over $30 are located

SELECT c.city, o.total_amount
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
WHERE o.total_amount > 30;

-- 8: Find the customer who spent the most on orders

SELECT c.customer_id, c.name, SUM(o.total_amount) AS spent
FROM orders o JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY SUM(o.total_amount) DESC LIMIT 1;

SELECT c.customer_id, c.name, SUM(o.total_amount) AS spent
FROM orders o JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY spent DESC LIMIT 1;

-- 9: Calculate the stock remaining after fullfilling all orders

SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS total_ordered, 
      (stock - COALESCE(SUM(o.quantity),0)) AS remaining_stock
FROM books b LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id ASC;
   -- OR
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS total_ordered,   -- if use right join
      (b.stock - COALESCE(SUM(o.quantity),0)) AS remaining_stock
FROM orders o RIGHT JOIN books b ON b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id ASC;






















