--11. Подключиться к БД northwind и добавить ограничение на поле unit_price таблицы products (цена должна быть больше 0)
--12. "Навесить" автоинкрементируемый счётчик на поле product_id таблицы products (БД northwind). Счётчик должен начинаться с числа следующего за максимальным значением по этому столбцу.

--11
ALTER TABLE products
ADD CONSTRAINT CHK_unit_price CHECK (unit_price >= 0)

--12
SELECT MAX(product_id) FROM products;

CREATE SEQUENCE products_product_id_seq START WITH max_product_id + 1;

ALTER TABLE products
ALTER COLUMN product_id SET DEFAULT nextval('products_product_id_seq');
