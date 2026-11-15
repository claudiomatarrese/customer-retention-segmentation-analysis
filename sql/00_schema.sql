-- 00_schema.sql
-- Creates the online_retail schema and the raw transactions table.
--
-- Source: Online Retail II (UCI Machine Learning Repository),
-- transactions from 1 Dec 2009 to 9 Dec 2011.
--
-- WARNING: the DROP TABLE below deletes any data already loaded.
-- Run this script only on a new database. After running it, load the
-- data into online_retail.raw_online_retail, then run scripts 01 to 04.

CREATE SCHEMA IF NOT EXISTS online_retail;

DROP TABLE IF EXISTS online_retail.raw_online_retail;

CREATE TABLE online_retail.raw_online_retail (
  invoice       TEXT,
  stock_code    TEXT,
  description   TEXT,
  quantity      INTEGER,
  invoice_date  TIMESTAMP,
  price         NUMERIC(12,4),
  customer_id   NUMERIC(12,2),   -- NUMERIC because the source file stores IDs like 13085.0
  country       TEXT
);
