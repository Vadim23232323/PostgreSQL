--оздать функцию, которая вычисляет средний фрахт по заданным странам (функция принимает список стран).

--1 
CREATE FUNCTION avg_freight_country (VARIADIC list_country text[]) RETURNS real AS $$ 

	SELECT AVG(freight)
	FROM orders
	WHERE ship_country = ANY(list_country)

$$ LANGUAGE SQL;

SELECT avg_freight_country('USA','italy','Mexico')

SELECT *
FROM orders


