-- 1. Clean table row count
SELECT COUNT(*) AS clean_row_count
FROM retail_transactions_clean;
-- Expected: 49,700


-- 2. Duplicate nonblank transaction IDs
SELECT transaction_id, COUNT(*) AS row_count
FROM retail_transactions_clean
WHERE transaction_id IS NOT NULL
  AND TRIM(transaction_id) <> ''
GROUP BY transaction_id
HAVING COUNT(*) > 1;
-- Expected: 0 rows


-- 3. Negative quantities
SELECT transaction_id, quantity
FROM retail_transactions_clean
WHERE quantity < 0;
-- Expected: 0 rows


-- 4. Negative unit prices
SELECT transaction_id, unit_price
FROM retail_transactions_clean
WHERE unit_price < 0;
-- Expected: 0 rows


-- 5. Empty strings remaining in text columns
SELECT *
FROM retail_transactions_clean
WHERE (transaction_id IS NOT NULL AND TRIM(transaction_id) = '')
   OR (customer_id IS NOT NULL AND TRIM(customer_id) = '')
   OR (product_category IS NOT NULL AND TRIM(product_category) = '')
   OR (region IS NOT NULL AND TRIM(region) = '')
   OR (payment_method IS NOT NULL AND TRIM(payment_method) = '');
-- Expected: 0 rows


-- 6. Leading or trailing spaces remaining in text columns
SELECT *
FROM retail_transactions_clean
WHERE (transaction_id IS NOT NULL AND transaction_id <> TRIM(transaction_id))
   OR (customer_id IS NOT NULL AND customer_id <> TRIM(customer_id))
   OR (product_category IS NOT NULL AND product_category <> TRIM(product_category))
   OR (region IS NOT NULL AND region <> TRIM(region))
   OR (payment_method IS NOT NULL AND payment_method <> TRIM(payment_method));
-- Expected: 0 rows


-- 7. Inconsistent capitalization remaining in standardized fields
SELECT *
FROM retail_transactions_clean
WHERE (product_category IS NOT NULL
       AND product_category <> INITCAP(TRIM(product_category)))
   OR (region IS NOT NULL
       AND region <> INITCAP(TRIM(region)))
   OR (payment_method IS NOT NULL
       AND payment_method <> INITCAP(TRIM(payment_method)));
-- Expected: 0 rows


-- 8. Count NULL values retained in the clean table
SELECT
    COUNT(*) FILTER (WHERE transaction_id IS NULL) AS null_transaction_ids,
    COUNT(*) FILTER (WHERE transaction_date IS NULL) AS null_transaction_dates,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_ids,
    COUNT(*) FILTER (WHERE product_category IS NULL) AS null_product_categories,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS null_quantities,
    COUNT(*) FILTER (WHERE unit_price IS NULL) AS null_unit_prices,
    COUNT(*) FILTER (WHERE region IS NULL) AS null_regions,
    COUNT(*) FILTER (WHERE payment_method IS NULL) AS null_payment_methods
FROM retail_transactions_clean;
-- NULL counts are informational; they include missing or invalid source values.


-- 9. Exception table row count
SELECT COUNT(*) AS exception_row_count
FROM retail_transactions_exceptions;
-- Expected: 200