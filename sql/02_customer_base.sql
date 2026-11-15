-- 02_customer_base.sql
-- One row per customer: first and last purchase date,
-- number of orders (distinct invoices) and total revenue.

CREATE OR REPLACE VIEW online_retail.customer_base_v AS
SELECT
  customer_id,
  MIN(invoice_date) AS first_purchase_ts,
  MAX(invoice_date) AS last_purchase_ts,
  COUNT(DISTINCT invoice) AS orders_count,
  SUM(line_revenue) AS revenue_total
FROM online_retail.customer_orders_clean_v
GROUP BY customer_id;
