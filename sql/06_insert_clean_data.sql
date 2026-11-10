WITH distinct_rows AS (
    SELECT DISTINCT
        transaction_id,
        transaction_date,
        customer_id,
        product_category,
        quantity,
        unit_price,
        region,
        payment_method
    FROM retail_transactions_raw
),
conflicting_ids AS (
    SELECT transaction_id
    FROM distinct_rows
    WHERE transaction_id IS NOT NULL
      AND TRIM(transaction_id) <> ''
    GROUP BY transaction_id
    HAVING COUNT(*) > 1
)
INSERT INTO retail_transactions_clean
(
    transaction_id,
    transaction_date,
    customer_id,
    product_category,
    quantity,
    unit_price,
    region,
    payment_method
)
SELECT
    NULLIF(TRIM(d.transaction_id), ''),
    CASE
        WHEN pg_input_is_valid(TRIM(d.transaction_date), 'date')
            THEN TRIM(d.transaction_date)::date
        ELSE NULL
    END,
    NULLIF(TRIM(d.customer_id), ''),
    NULLIF(INITCAP(TRIM(d.product_category)), ''),
    CASE
        WHEN pg_input_is_valid(TRIM(d.quantity), 'integer')
            THEN CASE
                WHEN TRIM(d.quantity)::integer >= 0
                    THEN TRIM(d.quantity)::integer
                ELSE NULL
            END
        ELSE NULL
    END,
    CASE
        WHEN pg_input_is_valid(TRIM(d.unit_price), 'numeric')
            THEN CASE
                WHEN TRIM(d.unit_price)::numeric >= 0
                    THEN TRIM(d.unit_price)::numeric
                ELSE NULL
            END
        ELSE NULL
    END,
    NULLIF(INITCAP(TRIM(d.region)), ''),
    NULLIF(INITCAP(TRIM(d.payment_method)), '')
FROM distinct_rows AS d
WHERE NOT EXISTS (
    SELECT 1
    FROM conflicting_ids AS c
    WHERE c.transaction_id = d.transaction_id
);


SELECT *
FROM retail_transactions_clean;