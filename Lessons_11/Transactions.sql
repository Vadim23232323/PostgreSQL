BEGIN;

UPDATE employees
SET salary = salary * 1.5
WHERE salary < 20;

UPDATE employees
SET salary = salary * 0.8
WHERE salary > 80;

COMMIT

SELECT * FROM employees


BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

WITH prod_update AS (
	UPDATE products
	SET discontinued = 1
	WHERE units_in_stock < 10
	RETURNING product_id
)

SELECT * INTO last_orders_on_discontinued
FROM order_details
WHERE product_id IN (SELECT product_id FROM prod_update);

SAVEPOINT backup;

DELETE FROM order_details
WHERE product_id IN (SELECT product_id FROM last_orders_on_discontinued);

ROLLBACK TO backup;

UPDATE order_details
SET quantity =0
WHERE product_id IN (SELECT product_id FROM last_orders_on_discontinued);

COMMIT;

SELECT COUNT(*)
FROM order_details

SELECT *
FROM last_orders_on_discontinued

SELECT * 
FROM order_details
WHERE product_id IN (SELECT product_id FROM last_orders_on_discontinued);

DROP TABLE IF EXISTS last_orders_on_discontinued;