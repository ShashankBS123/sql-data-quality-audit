WITH distinct_rows AS(
	SELECT DISTINCT *
	FROM retail_transactions_raw
),
conflicting_ids AS(
SELECT transaction_id
FROM distinct_rows
WHERE transaction_id IS NOT NULL 
	AND TRIM(transaction_id) <> ''
GROUP BY transaction_id
HAVING COUNT(*) >1
)

INSERT INTO retail_transactions_exceptions
(   
	transaction_id,
    transaction_date,
    customer_id,
    product_category,
    quantity,
    unit_price,
    region,
    payment_method,
	issue_reason
)

SELECT 
	d.transaction_id,
    d.transaction_date,
    d.customer_id,
    d.product_category,
    d.quantity,
    d.unit_price,
    d.region,
    d.payment_method,
	'Conflicting transaction ID: multiple distinct records'
	
FROM retail_transactions_raw d
WHERE EXISTS(
				SELECT 1 
				FROM conflicting_ids C
				WHERE c.transaction_id = d.transaction_id
);