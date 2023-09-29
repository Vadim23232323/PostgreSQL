--1. Найти заказчиков и обслуживающих их заказы сотрудников таких, что и заказчики и сотрудники из города London, а доставка идёт компанией Speedy Express. Вывести компанию заказчика и ФИО сотрудника.
--2. Найти активные (см. поле discontinued) продукты из категории Beverages и Seafood, которых в продаже менее 20 единиц. Вывести наименование продуктов, кол-во единиц в продаже, имя контакта поставщика и его телефонный номер.
--3. Найти заказчиков, не сделавших ни одного заказа. Вывести имя заказчика и order_id.
--4. Переписать предыдущий запрос, использовав симметричный вид джойна (подсказка: речь о LEFT и RIGHT).

--1
--SELECT customers.company_name, last_name || ' ' || first_name AS FIO 
--FROM orders
--JOIN customers USING (customer_id)
--JOIN employees USING (employee_id)
--JOIN shippers ON orders.ship_via = shippers.shipper_id
--WHERE shippers.company_name = 'Speedy Express' and customers.city='London' and employees.city='London'
--ORDER BY company_name ASC

--2
--SELECT product_name, units_in_stock, contact_name, phone
--FROM products
--JOIN categories USING (category_id)
--JOIN suppliers USING (supplier_id)
--WHERE discontinued <> 1 and category_name IN ('Beverages', 'Seafood') and units_in_stock < 20

--3
--SELECT contact_name, order_id
--FROM customers
--LEFT JOIN orders USING(customer_id)
--WHERE order_id IS NULL
--ORDER BY contact_name;

-4
--SELECT contact_name, order_id
--FROM orders
--RIGHT JOIN customers USING(customer_id)
--WHERE order_id IS NULL
--ORDER BY contact_name;