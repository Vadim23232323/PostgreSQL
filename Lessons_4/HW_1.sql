--1. Создать таблицу teacher с полями teacher_id serial, first_name varchar, last_name varchar, birthday date, phone varchar, title varchar
--2. Добавить в таблицу после создания колонку middle_name varchar
--3. Удалить колонку middle_name
--4. Переименовать колонку birthday в birth_date
--5. Изменить тип данных колонки phone на varchar(32)
--6. Создать таблицу exam с полями exam_id serial, exam_name varchar(256), exam_date date
--7. Вставить три любых записи с автогенерацией идентификатора
--8. Посредством полной выборки убедиться, что данные были вставлены нормально и идентификаторы были сгенерированы с инкрементом
--9. Удалить все данные из таблицы со сбросом идентификатор в исходное состояние

--1
CREATE TABLE teacher
(
	teacher_id serial,
	first_name varchar,
	last_name varchar,
	birtday date,
	phone varchar,
	title varchar
)

--2
ALTER TABLE teacher
ADD COLUMN middle_name varchar

--3
ALTER TABLE teacher
DROP COLUMN middle_name

--4
ALTER TABLE teacher
RENAME COLUMN birtday to birth_day

--5
ALTER TABLE teacher
ALTER COLUMN phone SET DATA TYPE varchar(32)

--6
CREATE TABLE exam 
(
	exam_id serial,
	exema_name varchar(256),
	exam_date date
)

--7
INSERT INTO exam (exam_name, exam_date)
VALUES
('Vadim','1993-12-16'),
('Tanya','1997-01-25'),
('Maksim','2016-05-12');

--8
TRUNCATE TABLE exam RESTART IDENTITY

SELECT *
FROM exam
