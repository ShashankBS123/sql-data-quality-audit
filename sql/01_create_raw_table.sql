CREATE TABLE retail_transactions_raw(
transaction_id TEXT ,
transaction_date TEXT ,
customer_id TEXT ,
product_category TEXT ,
quantity TEXT ,
unit_price TEXT ,
region TEXT ,
payment_method TEXT 
);

SELECT COUNT(*) FROM retail_transactions_raw;