CREATE OR REPLACE VIEW online_retail.rfm_light_v AS
WITH as_of AS (
  SELECT COALESCE(MAX(invoice_date)::date, CURRENT_DATE) AS as_of_date
  FROM online_retail.customer_orders_clean_v
),
base AS (
  SELECT
    cb.customer_id,
    cb.orders_count,
    cb.revenue_total,
    cb.last_purchase_ts,
    (a.as_of_date - cb.last_purchase_ts::date) AS recency_days
  FROM online_retail.customer_base_v cb
  CROSS JOIN as_of a
),
bucketed AS (
  SELECT
    customer_id,
    orders_count,
    revenue_total,
    recency_days,
    CASE
      WHEN recency_days <= 30 THEN 'R1_0-30'::text
      WHEN recency_days <= 90 THEN 'R2_31-90'::text
      ELSE 'R3_90+'::text
    END AS recency_bucket,
    CASE
      WHEN orders_count = 1 THEN 'F1_1'::text
      WHEN orders_count BETWEEN 2 AND 4 THEN 'F2_2-4'::text
      ELSE 'F3_5+'::text
    END AS frequency_bucket,
    CASE
      WHEN revenue_total < 250::numeric THEN 'M1_low'::text
      WHEN revenue_total < 1000::numeric THEN 'M2_mid'::text
      ELSE 'M3_high'::text
    END AS monetary_bucket
  FROM base
)
SELECT
  customer_id,
  recency_days,
  orders_count,
  revenue_total,
  recency_bucket,
  frequency_bucket,
  monetary_bucket,
  ((recency_bucket || ' | '::text) || frequency_bucket || ' | '::text) || monetary_bucket AS rfm_label
FROM bucketed;
