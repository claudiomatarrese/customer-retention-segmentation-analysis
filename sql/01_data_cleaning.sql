-- 01_data_cleaning.sql
-- Cleaned transaction lines (one row per product line on an invoice).
--
-- Rows removed:
--   * missing invoice number
--   * cancelled invoices (invoice number starts with 'C')
--   * zero or negative quantity or price
--   * rows without a customer ID
--
-- line_revenue = quantity * price

CREATE OR REPLACE VIEW online_retail.customer_orders_clean_v AS
SELECT
  invoice,
  stock_code,
  description,
  quantity,
  invoice_date,
  price,
  customer_id::integer AS customer_id,
  country,
  quantity::numeric * price AS line_revenue
FROM online_retail.raw_online_retail
WHERE invoice IS NOT NULL
  AND invoice NOT LIKE 'C%'
  AND quantity > 0
  AND price > 0
  AND customer_id IS NOT NULL;
