-- Monthly Revenue Analysis

SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    ROUND(SUM(p.payment_value)::numeric,2) AS revenue
FROM orders o
JOIN payments p
ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

-- =====================================================
-- Top 10 Products by Orders
-- =====================================================

SELECT 
    product_id,
    COUNT(*) AS total_orders
FROM order_items
GROUP BY product_id
ORDER BY total_orders DESC
LIMIT 10;

-- =====================================================
-- Top Customers
-- =====================================================

SELECT 
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 10;

-- =====================================================
-- State-wise Revenue
-- =====================================================

SELECT 
    c.customer_state,
    ROUND(SUM(p.payment_value)::numeric, 2) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN payments p
ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;

-- =====================================================
-- Average Delivery Time
-- =====================================================

SELECT 
AVG(order_delivered_customer_date - order_purchase_timestamp)
AS avg_delivery_time
FROM orders;

-- =====================================================
-- Payment Type Analysis
-- =====================================================

SELECT 
    payment_type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(payment_value)::numeric,2) AS total_revenue
FROM payments
GROUP BY payment_type
ORDER BY total_revenue DESC;

-- =====================================================
-- Order Status Distribution
-- =====================================================

SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- =====================================================
-- Revenue Ranking by State
-- =====================================================

SELECT 
    customer_state,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS state_rank
FROM
(
    SELECT 
        c.customer_state,
        SUM(p.payment_value) AS revenue
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN payments p
    ON o.order_id = p.order_id
    GROUP BY c.customer_state
) t;

-- =====================================================
-- Customers with Above Average Spending
-- =====================================================

WITH customer_spending AS
(
    SELECT 
        o.customer_id,
        SUM(p.payment_value) AS total_spent
    FROM orders o
    JOIN payments p
    ON o.order_id = p.order_id
    GROUP BY o.customer_id
)

SELECT *
FROM customer_spending
WHERE total_spent >
(
    SELECT AVG(total_spent)
    FROM customer_spending
);