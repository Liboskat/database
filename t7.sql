-- 1. Отобрать всех режиссёров, у которых лучший фильм был снят в 2000 году. 
SELECT director_id, person_name, person_surname, person_birthday, person_motherland, movie_name FROM directors, movies
WHERE (movie_id = director_best_movie) AND (EXTRACT(YEAR FROM movie_year) = 2000);

-- 2. Вывести всех режиссёров, которые сняли более 5 фильмов.
SELECT director_id, person_name, person_surname, person_motherland, person_birthday,
  count(director_id = movies.movie_director) AS films_count
FROM directors
RIGHT JOIN movies ON (director_id = movie_director)
GROUP BY director_id
HAVING count(director_id = movie_director) > 5;

-- 3. Отобрать илентификаторы фильмов, где снималось более 10 актёров
SELECT movies.movie_id FROM movies
RIGHT JOIN movie_actor ON (movies.movie_id = movie_actor.movie_id)
GROUP BY movies.movie_id
HAVING count(movies.movie_id = movie_actor.movie_id) > 10;

-- 4. Добавить поле оценка в таблицу фильмов. Получить топ-10 фильмов с наивысшей оценкой, снятых в США.
SELECT movie_id, movie_name, movie_rate
FROM movies
ORDER BY movie_rate DESC
LIMIT 10;

-- 5. Отобрать все различные фильмы ужасов, в которых снимались актёры родом из Англии
SELECT movies.movie_name, genres.genre_name
FROM movies
LEFT JOIN movie_actor ON movie_actor.movie_id = movies.movie_id
LEFT JOIN actors ON movie_actor.actor_id = actors.actor_id
LEFT JOIN movie_genre ON movies.movie_id = movie_genre.movie_id
LEFT JOIN genres ON movie_genre.genre_id = genres.genre_id
GROUP BY movies.movie_id, genre_name
HAVING (count(person_motherland = 'UK') > 0) AND (genre_name = 'Horror')