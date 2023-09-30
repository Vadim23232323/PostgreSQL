--1. Создать таблицу exam с полями:
--- идентификатора экзамена - автоинкрементируемый, уникальный, запрещает NULL;
--- наименования экзамена
--- даты экзамена
--2. Удалить ограничение уникальности с поля идентификатора
--3. Добавить ограничение первичного ключа на поле идентификатора
--4. Создать таблицу person с полями
--- идентификатора личности (простой int, первичный ключ)
--- имя
--- фамилия
--5. Создать таблицу паспорта с полями:
--- идентификатора паспорта (простой int, первичный ключ)
--- серийный номер (простой int, запрещает NULL)
--- регистрация
--- ссылка на идентификатор личности (внешний ключ)
--6. Добавить колонку веса в таблицу book (создавали ранее) с ограничением, проверяющим вес (больше 0 но меньше 100)
--7. Убедиться в том, что ограничение на вес работает (попробуйте вставить невалидное значение)
--8. Создать таблицу student с полями:
--- идентификатора (автоинкремент)
--- полное имя
--- курс (по умолчанию 1)
--9. Вставить запись в таблицу студентов и убедиться, что ограничение на вставку значения по умолчанию работает
--10. Удалить ограничение "по умолчанию" из таблицы студентов

--1
CREATE TABLE exam
(
	exam_id int GENERATED ALWAYS AS IDENTITY (START WITH 1) NOT NULL,
	exam_name varchar,
	exam_date date
)

--2
ALTER TABLE exam
DROP COLUMN exam_id

--3
ALTER TABLE exam
ADD COLUMN exam_id int GENERATED ALWAYS AS IDENTITY (START WITH 1) NOT NULL

ALTER TABLE exam
ADD CONSTRAINT pk_exam_id PRIMARY KEY (exam_id);

--4
CREATE TABLE person
(
	person_id int,
	first_name varchar,
	last_name varchar,
	CONSTRAINT pk_person_id PRIMARY KEY (person_id)
)

--5
CREATE TABLE passport
(
	passport_id int,
	serial_number int NOT NULL,
	registration varchar,
	person_id int,
	CONSTRAINT fk_passport_person FOREIGN KEY (person_id) REFERENCES person(person_id)
)

--6
ALTER TABLE person
ADD COLUMN hight int DEFAULT 60 CONSTRAINT CHK_hight_person CHECK ((hight>3) and (hight<100));

--7
INSERT INTO person
VALUES 
('3','Vadim','Dubovskiy','2')
RETURNING *

--8
ALTER TABLE students
ADD COLUMN student_id int GENERATED ALWAYS AS IDENTITY (START WITH 1) NOT NULL

--9
ALTER TABLE students
ADD COLUMN course_number int DEFAULT 1

--10
INSERT INTO students (first_name,brithday)
VALUES 
('Vadim','1993-12-16')
RETURNING *





