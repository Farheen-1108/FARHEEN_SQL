-- STEP 1: Create and select the database
CREATE DATABASE IF NOT EXISTS Online_Retail_Sales;
USE Online_Retail_Sales;

-- DROP tables if already exist (order matters due to foreign keys)
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- CUSTOMERS
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE,
  phone_num VARCHAR(20)
);

-- PRODUCTS
CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  product_name VARCHAR(100) NOT NULL,
  description TEXT,
  price NUMERIC(10,2) NOT NULL
);

-- ORDERS
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(customer_id),
  order_date DATE,
  status VARCHAR(50)
);

-- ORDER ITEMS
CREATE TABLE order_items (
  order_item_id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(order_id),
  product_id INT REFERENCES products(product_id),
  quantity INT,
  unit_price NUMERIC(10,2)
);

-- PAYMENTS
CREATE TABLE payments (
  payment_id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(order_id),
  payment_date DATE,
  amount NUMERIC(10,2),
  method VARCHAR(50)
);

-- CUSTOMERS
INSERT INTO customers (name, email, phone_num) VALUES
('Alice', 'alice@example.com', '9876543210'),
('Bob', 'bob@example.com', '9876543211');

-- PRODUCTS
INSERT INTO products (product_name, description, price) VALUES
('Laptop', 'Gaming Laptop', 55000.00),
('Mouse', 'Wireless Mouse', 700.00),
('Keyboard', 'Mechanical Keyboard', 2200.00);

-- ORDERS
INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2025-07-20', 'Shipped'),
(2, '2025-07-21', 'Pending');

-- ORDER ITEMS
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 55000.00),
(1, 2, 1, 700.00),
(2, 3, 2, 2200.00);

-- PAYMENTS
INSERT INTO payments (order_id, payment_date, amount, method) VALUES
(1, '2025-07-20', 55700.00, 'Credit Card'),
(2, '2025-07-21', 4400.00, 'UPI');


-- 1. Detailed Order Report
SELECT 
  o.order_id,
  c.name AS customer_name,
  o.order_date,
  p.product_name,
  oi.quantity,
  oi.unit_price,
  (oi.quantity * oi.unit_price) AS total_price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

-- 2. Total Revenue
SELECT SUM(amount) AS total_revenue FROM payments;

-- 3. Payment Details for Orders
SELECT 
  o.order_id,
  c.name AS customer_name,
  o.status,
  p.method AS payment_method,
  p.amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN payments p ON o.order_id = p.order_id;

-- 4. View: Customer Total Spend
CREATE OR REPLACE VIEW customer_sales_report AS
SELECT 
  c.customer_id,
  c.name,
  SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name;

SELECT 
  c.name AS customer_name,
  p.product_name,
  oi.quantity,
  oi.unit_price,
  (oi.quantity * oi.unit_price) AS total_price,
  o.order_date
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id;

SELECT 
  o.order_id,
  c.name AS customer_name,
  o.order_date,
  o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE p.payment_id IS NULL;

SELECT 
  p.product_name,
  SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name;

SELECT 
  c.customer_id,
  c.name,
  COUNT(o.order_id) AS number_of_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > 1;

SELECT 
  c.customer_id,
  c.name,
  ROUND(AVG(oi.quantity * oi.unit_price), 2) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name;


