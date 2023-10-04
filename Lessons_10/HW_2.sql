--Написать функцию, которая фильтрует телефонные номера по коду оператора.
--Принимает 3-х значный код мобильного оператора и список телефонных номеров в формате +1(234)5678901 (variadic)
--Функция возвращает только те номера, код оператора которых соответствует значению соответствующего аргумента.
--Проверить функцию передав следующие аргументы:
--903, +7(903)1901235, +7(926)8567589, +7(903)1532476
--Попробовать передать аргументы с созданием массива и без.
--Подсказка: чтобы передать массив в VARIADIC-аргумент, надо перед массивом прописать, собственно, ключевое слово variadic.


--1

CREATE FUNCTION phone_number_filter (code_operator int,VARIADIC phone_numbers text[]) RETURNS setof text AS $$
DECLARE
	numbers text;
BEGIN
	
	FOREACH numbers IN ARRAY phone_numbers
	LOOP
		RAISE NOTICE 'number is %', numbers;
		CONTINUE WHEN numbers NOT LIKE CONCAT('__(', code_operator, ')%');
		RETURN NEXT numbers;
	END LOOP;

END

$$ LANGUAGE plpgsql;



SELECT * FROM phone_number_filter(903, '+7(903)1901235', '+7(926)8567589', '+7(903)1532476')
