# E-Commerce SQL Data Analysis

**DecodeLabs — Data Analytics Internship | Project 3**

A SQL-driven analysis of 1,200 e-commerce orders (Jan 2023 – Jun 2025), using SQLite to filter, group, and aggregate raw transactional data into business-ready insights — covering `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`, `HAVING`, and percentage-contribution analysis.

## Objective

Use SQL queries to extract insights from a raw orders dataset — moving beyond "viewing spreadsheets" to writing structured queries that filter, group, and aggregate data into actionable business intelligence.

## Dataset

| Field | Description |
|---|---|
| Rows | 1,200 orders |
| Date range | Jan 1, 2023 – Jun 30, 2025 *(2025 is a partial year — figures for that year are read accordingly)* |
| Columns | OrderID, Date, CustomerID, Product, Quantity, UnitPrice, ShippingAddress, PaymentMethod, OrderStatus, TrackingNumber, ItemsInCart, CouponCode, ReferralSource, TotalPrice |
| Products | Chair, Desk, Laptop, Monitor, Phone, Printer, Tablet |

## Tech Stack

- **SQLite** — lightweight relational database for the query engine
- **Python (pandas, sqlite3)** — data loading and query execution
- **Jupyter Notebook** — documented, reproducible analysis
- **Matplotlib** — supporting visualizations

## Project Structure

```
ecommerce-sql-analysis/
├── data/
│   └── ecommerce_orders.xlsx        # Raw dataset
├── database/
│   └── ecommerce.db                 # SQLite database (built from raw data)
├── sql/
│   └── queries.sql                  # All SQL queries, organized by section
├── notebooks/
│   └── SQL_Data_Analysis.ipynb      # Executed notebook with results + insights
├── outputs/
│   ├── revenue_by_product.png
│   └── monthly_revenue_trend.png
└── README.md
```

## Key Requirements Covered

- ✅ `SELECT` queries with column selection and aliasing
- ✅ `WHERE` — equality, comparison, and multi-condition filters, plus NULL handling
- ✅ `ORDER BY` — ascending/descending sorts on raw and computed columns
- ✅ `GROUP BY` with `COUNT()`, `SUM()`, `AVG()` aggregations
- ✅ `HAVING` — filtering aggregated groups (e.g., referral sources beating the overall average order value)
- ✅ Percentage-contribution queries using correlated subqueries
- ✅ A full-pipeline query demonstrating correct logical execution order: `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY`

## Key Insights

- Revenue is spread fairly evenly across the product catalog — **Chair** and **Printer** lead narrowly at **15.47%** each of total revenue, with **Phone** the smallest contributor at **12.00%**.
- **Cancellation rate is 20.83%** — order status is nearly evenly split across all five stages, meaning roughly 1 in 5 orders never completes.
- **74.25% of orders** used a coupon code, indicating promotions are a major purchase driver.
- **Facebook** (₹1,098.29 avg order value) and **Instagram** (₹1,062.88) are the only referral sources beating the overall average of ₹1,053.97 — social referrals bring higher-value baskets, not just more traffic.

## How to Run

```bash
# 1. Clone the repo
git clone <repo-url>
cd ecommerce-sql-analysis

# 2. Install dependencies
pip install pandas jupyter matplotlib openpyxl

# 3. Launch the notebook
jupyter notebook notebooks/SQL_Data_Analysis.ipynb
```

Or run the raw SQL directly against `database/ecommerce.db` using any SQLite client:

```bash
sqlite3 database/ecommerce.db < sql/queries.sql
```

## Author

**Astha Kataria**
B.Tech CSE, AKTU | DecodeLabs Data Analytics Intern, Batch 2026
[GitHub](https://github.com/AsthaKataria) • [LinkedIn](https://www.linkedin.com/in/asthakataria)
