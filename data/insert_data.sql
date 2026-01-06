INSERT IGNORE INTO customers (customer_name, email, city, state, signup_date)
SELECT
  CONCAT('Customer_', n),
  CONCAT('customer', n, '@gmail.com'),
  ELT(1 + (n % 5), 'Mumbai', 'Pune', 'Delhi', 'Bangalore', 'Hyderabad'),
  ELT(1 + (n % 5), 'MH', 'MH', 'DL', 'KA', 'TS'),
  DATE_ADD('2023-01-01', INTERVAL n DAY)
FROM (
  SELECT @row := @row + 1 AS n
  FROM information_schema.tables, (SELECT @row := 1) r
  LIMIT 60
) t;


INSERT INTO products (product_name, category, price, cost)
SELECT
  CONCAT('Product_', n),
  ELT(1 + (n % 4), 'Electronics', 'Accessories', 'Furniture', 'Clothing'),
  ROUND(500 + RAND() * 50000, 2),
  ROUND(300 + RAND() * 40000, 2)
FROM (
  SELECT @p := @p + 1 AS n
  FROM information_schema.tables, (SELECT @p := 5) r
  LIMIT 20
) t;



INSERT INTO orders (customer_id, order_date, order_status)
SELECT
  c.customer_id,
  DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 365) DAY),
  ELT(1 + FLOOR(RAND() * 3), 'Completed', 'Cancelled', 'Returned')
FROM customers c
ORDER BY RAND()
LIMIT 200;




INSERT INTO order_items (order_id, product_id, quantity, selling_price)
SELECT
  o.order_id,
  p.product_id,
  FLOOR(1 + RAND() * 4),
  ROUND(500 + RAND() * 50000, 2)
FROM orders o
JOIN products p
ORDER BY RAND()
LIMIT 500;




INSERT INTO payments (order_id, payment_date, payment_method, payment_status)
SELECT
  o.order_id,
  o.order_date,
  ELT(1 + FLOOR(RAND() * 4), 'UPI', 'Credit Card', 'Debit Card', 'Cash'),
  IF(o.order_status = 'Completed', 'Paid', 'Failed')
FROM orders o;
