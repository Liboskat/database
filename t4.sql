--3. Поменять для таблицы фильмы первичный ключ: добавить новое поле(movie_id) и 
--   соответстувенно новую последовательность для этого поля.
ALTER TABLE movies DROP CONSTRAINT movies_pkey;
ALTER TABLE movies ADD movie_id SERIAL PRIMARY KEY;
--4. Изменить значение по умолчанию для поля Страна на "UK".
ALTER TABLE directors ALTER person_motherland SET DEFAULT 'UK';

--1. Организовать связи между таблицами, добавив недостающие поля в таблицы 
--  (на один фильм может приходится множество актеров и режиссеров).
CREATE TABLE movie_actor (
  actor_id INTEGER REFERENCES actors (actor_id),
  movie_id INTEGER REFERENCES movies (movie_id)
);

ALTER TABLE movies ADD movie_director INTEGER REFERENCES directors (director_id);

--2. Добавить в таблицу режиссёров связь с их лучшим фильмом в таблице фильмы. 
ALTER TABLE directors ADD director_best_movie INTEGER REFERENCES movies(movie_id);

--5. Удалить ограничение на число фильмо для актеров.
ALTER TABLE actors DROP CONSTRAINT ck_number_of_movies;

--6. Поменять ограничение на бюджет фильма: поле бюджет не должен быть < 1000.
ALTER TABLE movies DROP CONSTRAINT ck_movies_budget;
ALTER TABLE movies ADD CONSTRAINT ck_movies_budget CHECK (CAST(movie_budget AS NUMERIC) > 1000);

--7. Выделить жанры в отдельную таблицу, организовать межтабличную связь.
CREATE TABLE genres (
  genre_name VARCHAR(30),
  genre_id SERIAL PRIMARY KEY
);

ALTER TABLE movies DROP movie_genres;

CREATE TABLE movie_genre (
  genre_id INTEGER REFERENCES genres (genre_id),
  movie_id INTEGER REFERENCES movies (movie_id)
);

--8. Изменить тип для поля страна рождения. 
--   Сделать его перечислением из следующих вариантов ("USA", "UK", "Russia", "France", "Germany")

CREATE TYPE motherland AS ENUM ('USA', 'UK', 'Russia', 'France', 'Germany');
ALTER TABLE directors ALTER person_motherland DROP DEFAULT;
ALTER TABLE person ALTER person_motherland TYPE motherland USING 'UK';
ALTER TABLE directors ALTER person_motherland SET DEFAULT 'UK';

--9. Добавить проверку на поле дата рождения: она не должна превышать текущую дату.
ALTER TABLE person ADD CONSTRAINT ck_person_birthday CHECK (EXTRACT(year FROM person_birthday) <= (EXTRACT(year FROM current_date)));

--10. Создать индекс по фамилии и имени Актеров.
CREATE INDEX actor_index ON actors (person_name, person_surname);

--11.Обновить таблицу фильмов. Добавить в название в скобках год издания фильма.
UPDATE movies SET movie_name = concat(movie_name, ' (', extract(YEAR FROM movie_year), ')');




