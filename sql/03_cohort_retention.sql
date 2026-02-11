CREATE OR REPLACE VIEW online_retail.cohort_retention_v AS
WITH customer_cohort AS (
  SELECT
    customer_id,
    date_trunc('month', first_purchase_ts)::date AS cohort_month
  FROM online_retail.customer_base_v
),
activity AS (
  SELECT
    o.customer_id,
    date_trunc('month', o.invoice_date)::date AS activity_month
  FROM online_retail.customer_orders_clean_v o
),
cohort_activity AS (
  SELECT
    c.cohort_month,
    a.activity_month,
    ((EXTRACT(YEAR FROM a.activity_month) - EXTRACT(YEAR FROM c.cohort_month))::int * 12
     + (EXTRACT(MONTH FROM a.activity_month) - EXTRACT(MONTH FROM c.cohort_month))::int) AS month_index,
    COUNT(DISTINCT a.customer_id) AS active_customers
  FROM customer_cohort c
  JOIN activity a
    ON a.customer_id = c.customer_id
  GROUP BY 1,2,3
),
cohort_size AS (
  SELECT
    cohort_month,
    COUNT(*) AS cohort_customers
  FROM customer_cohort
  GROUP BY 1
)
SELECT
  ca.cohort_month,
  ca.activity_month,
  ca.month_index,
  cs.cohort_customers,
  ca.active_customers,
  (ca.active_customers::numeric / NULLIF(cs.cohort_customers, 0)) AS retenti
