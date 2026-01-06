-- Total Revenue
SELECT 
  SUM(oi.quantity * oi.selling_price) AS total_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed';


-- Total order by status
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;


-- Total customers
SELECT COUNT(*) AS total_customers
FROM customers;


-- Monthly revenue trend
SELECT 
  DATE_FORMAT(o.order_date, '%Y-%m') AS month,
  SUM(oi.quantity * oi.selling_price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY month
ORDER BY month;


-- Top 5 best selling products
SELECT 
  p.product_name,
  SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;


-- Revenue by category
SELECT 
  p.category,
  SUM(oi.quantity * oi.selling_price) AS category_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.category;


-- Top customers by revenue
SELECT 
  c.customer_name,
  SUM(oi.quantity * oi.selling_price) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_name
ORDER BY revenue DESC
LIMIT 5;


-- Profit by product
SELECT 
  p.product_name,
  SUM((oi.selling_price - p.cost) * oi.quantity) AS profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_name
ORDER BY profit DESC;


-- Rank products using window function
SELECT 
  p.product_name,
  SUM(oi.quantity) AS total_sold,
  RANK() OVER (ORDER BY SUM(oi.quantity) DESC) AS sales_rank
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name;


-- Average order value
SELECT 
  SUM(oi.quantity * oi.selling_price) / COUNT(DISTINCT o.order_id) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed';


-- Payment method usage
SELECT 
  payment_method,
  COUNT(*) AS usage_count
FROM payments
GROUP BY payment_method
ORDER BY usage_count DESC;


-- Customers with no orders
SELECT c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Most profitable month
SELECT 
  DATE_FORMAT(o.order_date, '%Y-%m') AS month,
  SUM((oi.selling_price - p.cost) * oi.quantity) AS profit
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY month
ORDER BY profit DESC
LIMIT 1;

