CREATE TABLE perf_test 
(
	id int,
	reason text COLLATE "C",
	annotation text COLLATE "C"
);

INSERT INTO perf_test(id, reason, annotation)
SELECT s.id, md5(random()::text), null
FROM generate_series(1,10000000) AS s(id)
ORDER BY random();

UPDATE perf_test
SET annotation = UPPER(md5(random()::text));



SELECT * FROM perf_test
WHERE id = 370000

CREATE INDEX idx_perf_test_id ON perf_test(id)


CREATE INDEX idx_perf_test_reason_annotation ON perf_test(reason, annotation)


SELECT * FROM perf_test
WHERE LOWER(annnotation) LIKE('ab%');

CREATE INDEX idx_perf_test_annotation_lower ON perf_test(LOWER(annnotation))