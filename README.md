# Customer Retention & Segmentation

![Dashboard preview](images/customer_retention_preview.png)

## Background

An online retailer wants to know how many of its customers come back after the first order, and which valuable customers have stopped buying. This project answers those two questions with SQL and a two-page Power BI dashboard.

## Questions

1. How many customers order more than once?
2. Of the customers who start in a given month, how many come back in the following months?
3. How are customers split by spend and by how recently they ordered?
4. Which countries bring the most customers and revenue?

## Data

- **Source:** [Online Retail II](https://archive.ics.uci.edu/dataset/502/online+retail+ii), UCI Machine Learning Repository
- **Period:** 1 December 2009 to 9 December 2011
- **Size:** about 1.07 million rows, one row per product on an invoice
- **Fields:** invoice, product, quantity, price, date, customer ID, country

The raw file is not in this repository because it is too large.

**Rows removed during cleaning:** cancelled invoices, rows with zero or negative quantity or price, and rows with no customer ID. Because of the last rule, all figures cover orders from identified customers only.

## What I did

The data is prepared in PostgreSQL with five scripts, to be run in this order:

| File | What it does |
|---|---|
| `00_schema.sql` | Creates the schema and the empty raw table |
| `01_data_cleaning.sql` | Cleaned order lines with revenue per line |
| `02_customer_base.sql` | One row per customer: first and last order, number of orders, total revenue |
| `03_cohort_retention.sql` | Retention by first-order month and months since the first order |
| `04_rfm_light.sql` | Groups customers by recency, number of orders and spend |

The groups in `04_rfm_light.sql` are:

- **Last order:** 0–30 days, 31–90 days, 90+ days before the last date in the data
- **Number of orders:** 1, 2–4, 5+
- **Total spend:** under £250, £250–£1,000, over £1,000

Power BI reads three of the views: `customer_orders_clean_v`, `cohort_retention_v` and `rfm_light_v`.

## The dashboard

The report has two pages. A PDF copy is in the `powerbi/` folder.

**Overview**
- Four numbers at the top: total revenue, customers, share of customers who ordered more than once, and high-value customers with no order in 90+ days
- Revenue by month
- A cohort table. Each row is the group of customers who made their first purchase in that month. Each column shows the share of that group who ordered again that many months later (0 is the first month, so it is always 100%).

**Customers & markets**
- Customers by spend and last order
- Customers by number of orders
- Top 5 countries by revenue
- A short list of key points

## Main findings

- Total revenue is £17.4M from 5,878 customers.
- 72.4% of customers ordered more than once, and 2,161 customers (37%) placed 5 or more orders.
- 842 customers who spent over £1,000 have not ordered in the last 90 days. Together they spent £2.58M.
- In the cohort table, retention drops after the first month in every cohort. After that it moves between roughly 10% and 40%.
- The UK brings 83% of revenue (£14.4M). EIRE and the Netherlands have very few customers (5 and 22) but rank second and third by revenue.

## Suggested next steps

1. Contact the 842 high-value customers who stopped ordering (for example with an offer or a reminder email).
2. Look at what the repeat customers have in common and try to get more first-time customers to order a second time.
3. Look at why EIRE and the Netherlands bring so much revenue from so few customers (for example very large orders).

## Limits

- The data ends on 9 December 2011, so December 2011 is only a partial month.
- Customers without an ID are not included.
- "Inactive" is counted from the last order date in the data, not from today.

## Repository

- `sql/`: the five SQL scripts
- `powerbi/`: the Power BI file and a PDF copy of the dashboard
- `images/`: the preview image used above

## How to rebuild

1. Create a database and run `00_schema.sql`.
2. Load the data into `online_retail.raw_online_retail`.
3. Run `01` to `04` in order.
4. Open the Power BI file and refresh.

## Tools

PostgreSQL, Power BI Desktop

## Note

This is a portfolio project. The client scenario is made up, and the data is a public dataset.
