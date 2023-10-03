--1
--Задание:
--Модифицировать функцию should_increase_salary разработанную в секции по функциям таким образом, чтобы запретить (выбрасывая исключения) передачу аргументов так, что:
--минимальный уровень з/п превышает максимальный
--ни минимальный, ни максимальный уровень з/п не могут быть меньше нуля
--коэффициент повышения зарплаты не может быть ниже 5%
--Протестировать реализацию, передавая следующие значения аргументов
--(с - уровень "проверяемой" зарплаты, r - коэффициент повышения зарплаты):

--c = 79, max = 10, min = 80, r = 0.2
--c = 79, max = 10, min = -1, r = 0.2
--c = 79, max = 10, min = 10, r = 0.04

--1
create or replace function should_increase_salary(
	cur_salary numeric,
	max_salary numeric DEFAULT 80, 
	min_salary numeric DEFAULT 30,
	increase_rate numeric DEFAULT 0.2
	) returns bool AS $$
declare
	new_salary numeric;
begin

	if min_salary > max_salary THEN
		RAISE EXCEPTION 'Minimum is %, salary is higher than maximum is %', min_salary, max_salary; 
	end if;
	
	if min_salary < 0 or max_salary < 0 THEN
		RAISE EXCEPTION 'Minimum is %, or maximum is %, salary less than 0', min_salary, max_salary;
	end if;
	
	if increase_rate < 0.05 THEN
		RAISE EXCEPTION 'Increase_rate salary less than 5 %', increase_rate;
	end if;

	
	if cur_salary >= max_salary or cur_salary >= min_salary then 		
		return false;
	end if;
	
	if cur_salary < min_salary then
		new_salary = cur_salary + (cur_salary * increase_rate);
	end if;
	
	if new_salary > max_salary then
		return false;
	else
		return true;
	end if;	
end;
$$ language plpgsql;


SELECT should_increase_salary (79, 10, 80, 0.2);
SELECT should_increase_salary (79, 10, -1, 0.2);
SELECT should_increase_salary (79, 10, 10, 0.04);



-- Перехват ошибок 
RAISE EXCEPTION 'Invalid. You passed: %', per USING HINT  = '', ERRCPDE = 12882;  

EXCEPTION WHEN SQLSTATE '12882' THEN
 GET STACKED DIAGNOSTICS
 	err_exc =  PG_EXCEPTION_CONTEXT,
 	err_msg =  MESSAGE_TEXT,
 	err_exd =  PG_EXCEPTION_DETAIL,
 	err_code =  RETURNED_SQLSTATE;

RAISE INFO 'A problem. Nothing special', err_ctx