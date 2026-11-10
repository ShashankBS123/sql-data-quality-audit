# SQL Data Quality Audit 

## Business Question
Is the retail transaction data complete, consistent, and reliable enough to use for analysis?

## Tools 
PostgreSQL and SQL

## Data Overview 
This project uses a simulated retail transactions dataset created for this project. It contains 50,000 rows and 8 columns, with deliberately seeded data quality issues such as duplicate records, conflicting transaction IDs, missing values, inconsistent spacing and capitalization, malformed dates, invalid numeric values, and negative quantities or prices. The original data is preserved in retail_transactions_raw. Conflicting records are stored in retail_transactions_exceptions for review, and cleaned data is stored in retail_transactions_clean.

## Data Quality Rules 
- Duplicate transaction IDs
- Missing or blank required values
- Extra spaces or inconsistent capitalization
- Invalid numeric values, such as negative quantity or price
- Values that cannot be converted to the intended data type

## Data Fields
- **transaction_id** — text identifier; should be unique
- **transaction_date** — date
- **customer_id** — text identifier
- **product_category** — text
- **quantity** — whole number
- **unit_price** — decimal number
- **region** — text
- **payment_method** — text

## Cleaning Decisions: 
- Trim text and turn whitespace-only values into NULL.
- Standardize capitalization in product_category, region, and payment_method.
- Convert valid dates and numbers to their intended types; set unconvertible values to NULL.
- Set negative quantities and prices to NULL because they violate this project’s rules.
- Keep one copy of exact duplicate records.
- Exclude all rows for transaction IDs that have conflicting records, since we can’t tell which record is correct. The raw table preserves them for review.

## Audit Findings and Results 
- **Raw data**: 50,000 rows; 8 columns.
- **Repeated transaction IDs**: 200 IDs appeared twice: 100 exact duplicate pairs and 100 pairs with conflicting records.
- **Missing or blank values**: 72 customer IDs, 63 product categories, 76 quantities, 72 unit prices, 43 regions, and 36 payment methods. There were none in transaction IDs or dates.
- **Invalid values**: 52 dates, 51 quantities, and 41 prices couldn’t be converted to their intended types.
- **Negative values**: 29 quantities and 17 prices.
- **After cleaning**: 49,700 rows in the clean table and 200 conflicting rows in the exceptions table. The exact duplicate copies were collapsed to one record, while the raw table remains unchanged.
- **Final checks**: no repeated IDs, negative values, empty strings, extra spaces, or inconsistent capitalization in the clean table.


## Project Status 
In Progress
