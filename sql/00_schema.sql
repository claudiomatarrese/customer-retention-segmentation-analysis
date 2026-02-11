CREATE SCHEMA IF NOT EXISTS online_retail;

DROP TABLE IF EXISTS online_retail.raw_online_retail;

CREATE TABLE online_retail.raw_online_retail (
  invoice       TEXT,
  stock_code    TEXT,
  description   TEXT,
  quantity      INTEGER,
  invoice_date  TIMESTAMP,
  price         NUMERIC(12,4),
  customer_id   NUMERIC(12,2),
  country       TEXT
);
