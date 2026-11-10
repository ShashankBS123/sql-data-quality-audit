--Total Row Count
SELECT COUNT(*) AS total_row_count
FROM retail_transactions_raw;


--Duplicate Transaction IDs
SELECT transaction_id,
		COUNT(*) AS row_count
FROM retail_transactions_raw
WHERE transaction_id IS NOT NULL
  AND TRIM(transaction_id) <> ''
GROUP BY transaction_id
HAVING COUNT(*) >1;


--Blank/NULL value in transaction_id column 
SELECT *
FROM retail_transactions_raw
WHERE transaction_id IS NULL OR TRIM(transaction_id) ='';

--Blank/Null values in transaction_date column
SELECT * 
FROM retail_transactions_raw
WHERE transaction_date IS NULL OR TRIM(transaction_date) = '';

--Blank/Null values in customer_id column
SELECT * 
FROM retail_transactions_raw
WHERE customer_id IS NULL OR TRIM(customer_id) = '';

--Blank/Null values in product_category column
SELECT * 
FROM retail_transactions_raw
WHERE product_category IS NULL OR TRIM(product_category) = '';

--Blank/Null values in quantity column
SELECT * 
FROM retail_transactions_raw
WHERE quantity IS NULL OR TRIM(quantity) = '';

--Blank/Null values in unit_price column
SELECT * 
FROM retail_transactions_raw
WHERE unit_price IS NULL OR TRIM(unit_price) = '';

--Blank/Null values in region column
SELECT * 
FROM retail_transactions_raw
WHERE region IS NULL OR TRIM(region) = '';

--Blank/Null values in payment_method column
SELECT * 
FROM retail_transactions_raw
WHERE payment_method IS NULL OR TRIM(payment_method) = '';


--Nonblank dates that aren’t valid dates
SELECT transaction_id, transaction_date
FROM retail_transactions_raw
WHERE NULLIF(TRIM(transaction_date), '') IS NOT NULL
  AND NOT pg_input_is_valid(TRIM(transaction_date), 'date');


--Nonblank quantities that aren’t valid integers
SELECT transaction_id, quantity
FROM retail_transactions_raw
WHERE NULLIF(TRIM(quantity),'') IS NOT NULL 
	AND NOT pg_input_is_valid(TRIM(quantity),'int');

--Nonblank prices that aren’t valid numbers
SELECT transaction_id, unit_price
FROM retail_transactions_raw
WHERE NULLIF(TRIM(unit_price),'') IS NOT NULL
	AND NOT pg_input_is_valid(TRIM(unit_price),'numeric');

--Negative quantities
SELECT transaction_id, quantity
FROM retail_transactions_raw
WHERE CASE
	WHEN pg_input_is_valid(TRIM(quantity),'int')
		THEN TRIM(quantity)::int <0
	ELSE FALSE
END;

--Negative unit price 
SELECT transaction_id, unit_price
FROM retail_transactions_raw
WHERE CASE
	WHEN pg_input_is_valid(TRIM(unit_price),'numeric')
		THEN TRIM(unit_price)::numeric <0
	ELSE FALSE
END;
	