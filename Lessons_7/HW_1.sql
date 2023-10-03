--1. Создайте функцию, которая делает бэкап таблицы customers (копирует все данные в другую таблицу), предварительно стирая таблицу для бэкапа, если такая уже существует (чтобы в случае многократного запуска таблица для бэкапа перезатиралась).
--2. Создать функцию, которая возвращает средний фрахт (freight) по всем заказам
--3. Написать функцию, которая принимает два целочисленных параметра, используемых как нижняя и верхняя границы для генерации случайного числа в пределах этой границы (включая сами граничные значения).
--Функция random генерирует вещественное число от 0 до 1.
--Необходимо вычислить разницу между границами и прибавить единицу.
--На полученное число умножить результат функции random() и прибавить к результату значение нижней границы.
--Применить функцию floor() к конечному результату, чтобы не "уехать" за границу и получить целое число.
--4. Создать функцию, которая возвращает самые низкую и высокую зарплаты среди сотрудников заданного города
--5. Создать функцию, которая корректирует зарплату на заданный процент,  но не корректирует зарплату, если её уровень превышает заданный уровень при этом верхний уровень зарплаты по умолчанию равен 70, а процент коррекции равен 15%.
--6. Модифицировать функцию, корректирующую зарплату таким образом, чтобы в результате коррекции, она так же выводила бы изменённые записи.
--7. Модифицировать предыдущую функцию так, чтобы она возвращала только колонки last_name, first_name, title, salary
--8. Написать функцию, которая принимает метод доставки и возвращает записи из таблицы orders в которых freight меньше значения, определяемого по следующему алгоритму:
--- ищем максимум фрахта (freight) среди заказов по заданному методу доставки
--- корректируем найденный максимум на 30% в сторону понижения
--- вычисляем среднее значение фрахта среди заказов по заданному методому доставки
--- вычисляем среднее значение между средним найденным на предыдущем шаге и скорректированным максимумом
--- возвращаем все заказы в которых значение фрахта меньше найденного на предыдущем шаге среднего
--9. Написать функцию, которая принимает:
--уровень зарплаты, максимальную зарплату (по умолчанию 80) минимальную зарплату (по умолчанию 30), коээфициет роста зарплаты (по умолчанию 20%)
--Если зарплата выше минимальной, то возвращает false
--Если зарплата ниже минимальной, то увеличивает зарплату на коэффициент роста и проверяет не станет ли зарплата после повышения превышать максимальную.
--Если превысит - возвращает false, в противном случае true.
--Проверить реализацию, передавая следующие параметры
--(где c - уровень з/п, max - макс. уровень з/п, min - минимальный уровень з/п, r - коэффициент):
--c = 40, max = 80, min = 30, r = 0.2 - должна вернуть false
--c = 79, max = 81, min = 80, r = 0.2 - должна вернуть false
--c = 79, max = 95, min = 80, r = 0.2 - должна вернуть true

--1
CREATE OR REPLACE FUNCTION backup_customers() RETURNS void AS $$
	DROP TABLE IF EXISTS tmp_customers; 
	SELECT *
	INTO tmp_customers
	FROM customers;
$$ language SQL


SELECT *
FROM backup_customers();

SELECT *
FROM tmp_customers


--2
CREATE OR REPLACE FUNCTION avg_freight() RETURNS int AS $$
	SELECT AVG(freight)
	FROM orders;
$$ language SQL

SELECT *
FROM avg_freight();

--3
CREATE OR REPLACE FUNCTION rnd_functions(low_b int DEFAULT 5, high_b int DEFAULT 20) RETURNS int AS $$
BEGIN
	RETURN floor(random() * (high_b - low_b + 1) + low_b);
END
	
$$ language plpgsql;


DROP FUNCTION math_functions();

SELECT rnd_functions(20,100);


--4
CREATE OR REPLACE FUNCTION get_salary_by_city (IN city_name varchar, OUT max_salary real, OUT min_salary real) AS $$
	SELECT MAX(salary), MIN(salary)
	FROM employees
	WHERE city = city_name
$$ LANGUAGE SQL;

SELECT *
FROM employees

SELECT * FROM get_salary_by_city('London')  


--5
CREATE OR REPLACE FUNCTION correct_salary(upper_boundary int DEFAULT 1000, correction_rate int DEFAULT 2) RETURNS void AS $$
	UPDATE employees
	SET salary = salary + (salary * correction_rate)
	WHERE salary <= upper_boundary
$$ LANGUAGE SQL;

 
SELECT correct_salary()  

SELECT *
FROM employees

--6
CREATE OR REPLACE FUNCTION correct_salary_sel(upper_boundary int DEFAULT 1000, correction_rate int DEFAULT 2) RETURNS setof employees AS $$
	UPDATE employees
	SET salary = salary + (salary * correction_rate)
	WHERE salary <= upper_boundary
	RETURNING *;
$$ LANGUAGE SQL;

 
SELECT * FROM correct_salary_sel()  

--7
CREATE OR REPLACE FUNCTION correct_salary_column(upper_boundary int DEFAULT 1000, correction_rate int DEFAULT 2) 
RETURNS TABLE (last_name text, first_name text, title text, salary int) AS $$
	UPDATE employees
	SET salary = salary + (salary * correction_rate)
	WHERE salary <= upper_boundary
	RETURNING last_name, first_name, title, salary;
$$ LANGUAGE SQL;

 
SELECT * FROM correct_salary_column(2000,3) 



--8
SELECT *
FROM orders

CREATE OR REPLACE FUNCTION get_ship_via_orders (ship_method int DEFAULT 1) RETURNS setof orders AS $$
DECLARE 
	maximum numeric;
	average numeric;
	middle numeric;
BEGIN
	SELECT MAX(freight) INTO maximum
	FROM orders
	WHERE ship_via = ship_method;
	
	SELECT AVG(freight) INTO average
	FROM orders
	WHERE ship_via = ship_method;
	
	maximum = maximum - (maximum * 0.3);
	middle = (maximum + average) / 2;

	RETURN QUERY
	SELECT *
	FROM orders
	WHERE freight < middle and ship_via = ship_method;
END
$$ LANGUAGE plpgsql;

SELECT COUNT(*) AS COUNT_ALL FROM get_ship_via_orders()

--9
CREATE OR REPLACE FUNCTION get_salary(salary int, max_salary int DEFAULT 80, min_salary int DEFAULT 30, growth_rate int DEFAULT 20) 
RETURNS bool AS $$
DECLARE 
	correction_salary int;
BEGIN
	IF salary > min_salary THEN
		RETURN false;
	END IF;
	
	IF salary < min_salary THEN
		correction_salary = salary + (salary * growth_rate);
	END IF;
	
	IF correction_salary > max_salary THEN
		RETURN false;
	ELSE 
		RETURN true;
	END IF;
	
END
$$ LANGUAGE plpgsql;

SELECT * FROM get_salary(29,500,400,3)
