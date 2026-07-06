/* ============================================================
   PROJECT 3 : SQL DATA ANALYSIS
   Dataset : E-Commerce Orders (Jan 2023 - Jun 2025, 1200 rows)
   Engine  : SQLite
   Author  : Astha Kataria | DecodeLabs Batch 2026
   ============================================================
   Table: orders
   Columns: OrderID, Date, CustomerID, Product, Quantity,
            UnitPrice, ShippingAddress, PaymentMethod,
            OrderStatus, TrackingNumber, ItemsInCart,
            CouponCode, ReferralSource, TotalPrice
   ============================================================ */


/* ------------------------------------------------------------
   SECTION 1: BASIC SELECT + WHERE
   ------------------------------------------------------------ */

-- 1.1 View a sample of raw orders
SELECT OrderID, Date, Product, Quantity, TotalPrice, OrderStatus
FROM orders
LIMIT 10;

-- 1.2 Find all cancelled orders (row-level filter)
SELECT OrderID, Date, Product, TotalPrice, OrderStatus
FROM orders
WHERE OrderStatus = 'Cancelled';

-- 1.3 High-value orders above a numeric threshold
SELECT OrderID, Product, Quantity, UnitPrice, TotalPrice
FROM orders
WHERE TotalPrice >= 2000;

-- 1.4 Orders placed with a specific coupon AND paid via Credit Card
--     (combining multiple WHERE conditions)
SELECT OrderID, Product, CouponCode, PaymentMethod, TotalPrice
FROM orders
WHERE CouponCode = 'SAVE10'
  AND PaymentMethod = 'Credit Card';

-- 1.5 Orders with no coupon applied (NULL handling)
SELECT OrderID, Product, CouponCode, TotalPrice
FROM orders
WHERE CouponCode IS NULL;


/* ------------------------------------------------------------
   SECTION 2: ORDER BY
   ------------------------------------------------------------ */

-- 2.1 Top 10 highest-value orders
SELECT OrderID, Product, TotalPrice
FROM orders
ORDER BY TotalPrice DESC
LIMIT 10;

-- 2.2 Most recent orders
SELECT OrderID, Date, Product, OrderStatus
FROM orders
ORDER BY Date DESC
LIMIT 10;

-- 2.3 Cheapest returned orders (multi-condition + sort)
SELECT OrderID, Product, TotalPrice
FROM orders
WHERE OrderStatus = 'Returned'
ORDER BY TotalPrice ASC
LIMIT 10;


/* ------------------------------------------------------------
   SECTION 3: GROUP BY + AGGREGATIONS (COUNT, SUM, AVG)
   ------------------------------------------------------------ */

-- 3.1 Total revenue and order count per product
SELECT
    Product,
    COUNT(*)                AS total_orders,
    SUM(TotalPrice)          AS total_revenue,
    ROUND(AVG(TotalPrice),2) AS avg_order_value
FROM orders
GROUP BY Product
ORDER BY total_revenue DESC;

-- 3.2 Order volume by status (COUNT includes every row)
SELECT
    OrderStatus,
    COUNT(*) AS order_count
FROM orders
GROUP BY OrderStatus
ORDER BY order_count DESC;

-- 3.3 Revenue by payment method
SELECT
    PaymentMethod,
    COUNT(*)                 AS total_orders,
    SUM(TotalPrice)           AS total_revenue,
    ROUND(AVG(TotalPrice),2)  AS avg_order_value
FROM orders
GROUP BY PaymentMethod
ORDER BY total_revenue DESC;

-- 3.4 Performance by referral / marketing source
SELECT
    ReferralSource,
    COUNT(*)                AS total_orders,
    SUM(TotalPrice)          AS total_revenue,
    ROUND(AVG(TotalPrice),2) AS avg_order_value
FROM orders
GROUP BY ReferralSource
ORDER BY total_revenue DESC;

-- 3.5 Coupon usage impact (NULLs excluded automatically by GROUP BY key,
--     shown explicitly with COALESCE)
SELECT
    COALESCE(CouponCode, 'No Coupon') AS coupon_used,
    COUNT(*)                          AS total_orders,
    ROUND(AVG(TotalPrice),2)          AS avg_order_value
FROM orders
GROUP BY coupon_used
ORDER BY total_orders DESC;

-- 3.6 Monthly order trend (year-month bucket)
SELECT
    strftime('%Y-%m', Date) AS order_month,
    COUNT(*)                AS total_orders,
    SUM(TotalPrice)          AS monthly_revenue
FROM orders
GROUP BY order_month
ORDER BY order_month;


/* ------------------------------------------------------------
   SECTION 4: HAVING (filtering aggregated buckets)
   ------------------------------------------------------------ */

-- 4.1 Only products that generated more than 100 orders
SELECT
    Product,
    COUNT(*) AS total_orders,
    SUM(TotalPrice) AS total_revenue
FROM orders
GROUP BY Product
HAVING COUNT(*) > 100
ORDER BY total_revenue DESC;

-- 4.2 Referral sources whose average order value exceeds the
--     overall average order value (data-driven threshold, not a magic number)
SELECT
    ReferralSource,
    ROUND(AVG(TotalPrice),2) AS avg_order_value
FROM orders
GROUP BY ReferralSource
HAVING AVG(TotalPrice) > (SELECT AVG(TotalPrice) FROM orders)
ORDER BY avg_order_value DESC;


/* ------------------------------------------------------------
   SECTION 5: PERCENTAGE CONTRIBUTION (business insight layer)
   ------------------------------------------------------------ */

-- 5.1 Each product's % contribution to total revenue
SELECT
    Product,
    SUM(TotalPrice) AS product_revenue,
    ROUND(
        100.0 * SUM(TotalPrice) / (SELECT SUM(TotalPrice) FROM orders), 2
    ) AS pct_of_total_revenue
FROM orders
GROUP BY Product
ORDER BY pct_of_total_revenue DESC;

-- 5.2 Cancellation rate (%) - operational health check
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN OrderStatus = 'Cancelled' THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS cancellation_rate_pct
FROM orders;

-- 5.3 % of orders that used ANY coupon
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN CouponCode IS NOT NULL THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS pct_orders_with_coupon
FROM orders;


/* ------------------------------------------------------------
   SECTION 6: FULL PIPELINE QUERY (all clauses together)
   Demonstrates correct logical execution order:
   FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY
   ------------------------------------------------------------ */

SELECT
    Product,
    COUNT(*)                 AS delivered_orders,
    SUM(TotalPrice)           AS delivered_revenue,
    ROUND(AVG(TotalPrice),2)  AS avg_order_value
FROM orders
WHERE OrderStatus = 'Delivered'
GROUP BY Product
HAVING COUNT(*) >= 20
ORDER BY delivered_revenue DESC;
