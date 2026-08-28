# Medical Parts Data Analysis

A small end-to-end data analysis project built around a synthetic medical-parts order dataset. The goal was to practice a realistic analytics workflow using SQL, Excel, Python, R, and Amazon QuickSight.

The dataset is fictional and contains 150 medical-parts orders across multiple customers, regions, product categories, manufacturers, and shipping outcomes.

## Project Goals

This project was designed to practice:

- Importing and validating raw data
- Querying relational data with SQL
- Performing business-focused analysis
- Creating calculated fields and PivotTables in Excel
- Manipulating and summarizing data with Python and R
- Building an interactive BI dashboard
- Documenting a repeatable analytical workflow

## Technologies Used

- SQL Server 2022 Express
- SQL Server Management Studio (SSMS) 22
- Microsoft Excel
- Python
- pandas
- R
- tidyverse
- Amazon QuickSight
- Git / GitHub

## Dataset

The source dataset is located at:

`data/orders_raw.csv`

It contains 150 synthetic order records with fields such as Order ID, order date, customer, region, product, part category, manufacturer, quantity, unit price, expected shipping days, actual shipping days, rush-order status, and return status.

Additional calculated fields used during analysis include:

- `Revenue`
- `ShippingStatus`

Revenue is calculated as:

`Quantity × UnitPrice`

An order is considered late when:

`ShippingDays > ExpectedShippingDays`

## SQL Analysis

The SQL portion uses a staging-style workflow:

`CSV → dbo.orders_raw → dbo.Orders`

The raw CSV data was first imported into a staging table and then loaded into a controlled table with explicit data types and constraints.

SQL work includes:

- Row-count validation
- Duplicate checks
- Null and invalid-value checks
- Revenue calculations
- Aggregation by category, region, customer, and manufacturer
- Shipping-delay analysis
- `CASE` expressions
- Common Table Expressions (CTEs)
- Window functions
- Primary and foreign keys
- Normalization
- `INNER JOIN` queries

The original denormalized order data was also split into relational customer, product, and order tables.

```text
Customers
---------
CustomerID (PK)
CustomerName
Region

Products
--------
ProductID (PK)
PartName
PartCategory
Manufacturer

OrdersNormalized
----------------
OrderID (PK)
OrderDate
CustomerID (FK)
ProductID (FK)
Quantity
UnitPrice
ExpectedShippingDays
ShippingDays
RushOrder
Returned
```

`UnitPrice` remains on the order record so historical revenue reflects the price paid at the time of the transaction.

## Excel Analysis

The Excel workbook is located at:

`excel/medical-parts-analysis.xlsx`

The workbook includes:

- An Excel Table containing the order data
- A calculated `Revenue` column
- A calculated `ShippingStatus` column
- PivotTable analysis
- Revenue by part category
- Order and shipping summaries
- A bar chart based on PivotTable results

## Python Analysis

The Python portion uses pandas to load, inspect, transform, and summarize the CSV data.

Example:

```python
import pandas as pd

df = pd.read_csv("data/orders_raw.csv")
df["Revenue"] = df["Quantity"] * df["UnitPrice"]
```

The Python analysis demonstrates:

- Loading data
- Inspecting rows and columns
- Creating calculated fields
- Grouping and aggregating data
- Validating data
- Preparing data for additional analysis

## R Analysis

The R portion performs similar analysis using base R and the tidyverse.

Example:

```r
library(tidyverse)

orders <- read_csv("data/orders_raw.csv")

orders <- orders %>%
  mutate(
    Revenue = Quantity * UnitPrice,
    ShippingStatus = if_else(
      ShippingDays > ExpectedShippingDays,
      "Late",
      "On Time"
    )
  )
```

## Amazon QuickSight Dashboard

An interactive dashboard was created in Amazon QuickSight using the project data.

Dashboard visuals include:

- Total Revenue KPI
- Total Orders KPI
- Revenue by Part Category
- Revenue by Month
- Late Order % by Part Category
- Region filter
- Part Category filter

A PDF export of the dashboard is included so the results can be viewed without access to the QuickSight account.

Suggested location:

`quicksight/medical-parts-operations-dashboard.pdf`

## Business Questions Explored

- Which part categories generate the most revenue?
- Which customers generate the most revenue?
- Which regions have the highest order volume?
- Where are shipping delays most common?
- Which categories have the highest late-order rate?
- Do rush orders experience different shipping performance?
- Are delays concentrated among particular manufacturers?

## Validation

Several checks are used before relying on analytical results:

- Confirming the expected number of rows was loaded
- Checking for duplicate order IDs
- Checking for missing required values
- Checking for non-positive quantities
- Checking for invalid prices
- Comparing staging and final-table row counts
- Using primary keys, foreign keys, and check constraints in the normalized schema

## Repository Structure

```text
medical-parts-data-analysis/
├── data/
│   └── orders_raw.csv
├── excel/
│   └── medical-parts-analysis.xlsx
├── python/
│   └── analyze_orders.py
├── r/
│   └── analyze_orders.R
├── sql/
│   ├── 01-create-database.sql
│   ├── 02-create-orders-table.sql
│   ├── 03-load-orders.sql
│   ├── 04-data-validation.sql
│   ├── 05-analysis.sql
│   └── 07-normalized-schema.sql
├── quicksight/
│   └── medical-parts-operations-dashboard.pdf
├── .gitignore
└── README.md
```

## Notes

- All customer, hospital, product, and order data in this repository is synthetic and fictional.
- The project is intended for learning and portfolio demonstration purposes.
- The same dataset is intentionally reused across tools to demonstrate how one business problem can be approached through multiple analytical technologies.
