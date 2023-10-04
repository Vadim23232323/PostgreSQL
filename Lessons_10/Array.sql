CREATE TABLE chess_game 
(
	white_player text,
	black_player text,
	moves text[],
	final_state text[][]
);

INSERT INTO chess_game
VALUES('Caruana', 'Makamura','{"d4", "d5","c4","c6"}',
	   '{{"Ra8","Qe8","x","x","x","x","x","x"},
	   {"a7","x","x","x","x","x","x","x"},
	   {"Kb5","Bc5","d5","x","x","x","x","x"}}');
	   
SELECT *
FROM chess_game;


INSERT INTO chess_game
VALUES('Caruana', 'Makamura',
	   ARRAY['d4', 'd5','c4','c6'],
	   ARRAY[
		['Ra8','Qe8','x','x','x','x','x','x'],
	    ['a7','x','x','x','x','x','x','x'],
	    ['Kb5','Bc5','d5','x','x','x','x','x']]);


SELECT moves[1:]
FROM chess_game;

SELECT array_dims(moves), array_length(moves, 1)
FROM chess_game;

UPDATE chess_game
SET moves = ARRAY['d7', 'd1','c2','c4']

UPDATE chess_game
SET moves[4] = 'c2'

SELECT *
FROM chess_game
WHERE 'c2' = ANY(moves);