--Создание пользователя и бд
CREATE USER director WITH LOGIN NOSUPERUSER CREATEDB NOCREATEROLE NOINHERIT NOREPLICATION;
CREATE DATABASE filmography;

--Создание таблицы фильмов
CREATE TABLE movies (
  movie_name VARCHAR(50) NOT NULL,
  movie_description TEXT NOT NULL,
  movie_year DATE NOT NULL,
  movie_genres VARCHAR(50) NOT NULL,
  movie_country VARCHAR(50) NOT NULL,
  movie_budget MONEY NOT NULL,
  CONSTRAINT PK_movies PRIMARY KEY (movie_name, movie_year),
  CONSTRAINT CK_movies_budget CHECK (CAST(movie_budget AS NUMERIC) > 1000),
  CONSTRAINT CK_movies_year CHECK ((EXTRACT(year FROM movie_year) > 1900) AND (EXTRACT(year FROM movie_year) < (EXTRACT(year FROM current_date)) + 10))
);

--Создание таблицы-предка ддя таблиц актеров и режиссеров
CREATE TABLE person (
  person_surname VARCHAR(20) NOT NULL,
  person_name VARCHAR(20) NOT NULL,
  person_birthday DATE NOT NULL,
  person_motherland VARCHAR(20) NOT NULL
);

--Создание таблицы актеров на основе таблицы-предка
CREATE TABLE actors (
  number_of_movies INTEGER NOT NULL,
  actor_id SERIAL NOT NULL,
  CONSTRAINT PK_actors PRIMARY KEY (person_surname, person_name, person_birthday),
  CONSTRAINT CK_number_of_movies CHECK (number_of_movies > 5)
) INHERITS (person);

--Создание таблицы режиссеров на основе таблицы-предка
CREATE TABLE directors (
  person_motherland VARCHAR(20) NOT NULL DEFAULT 'USA',
  director_id SERIAL PRIMARY KEY
) INHERITS (person);

--Заполнение данными
INSERT INTO movies (movie_name, movie_description, movie_year, movie_genres, movie_country, movie_budget) VALUES ('Movie 1', 'Desc 1', '1.1.2001', 'Genre 1', 'Russia', '5000000');
INSERT INTO movies (movie_name, movie_description, movie_year, movie_genres, movie_country, movie_budget) VALUES ('Movie 2', 'Desc 2', '2.2.2002', 'Genre 2', 'Russia', '5000000');
INSERT INTO movies (movie_name, movie_description, movie_year, movie_genres, movie_country, movie_budget) VALUES ('Movie 3', 'Desc 3', '3.3.2003', 'Genre 3', 'Russia', '5000000');
INSERT INTO movies (movie_name, movie_description, movie_year, movie_genres, movie_country, movie_budget) VALUES ('Movie 4', 'Desc 4', '4.4.2004', 'Genre 4', 'Russia', '5000000');
INSERT INTO movies (movie_name, movie_description, movie_year, movie_genres, movie_country, movie_budget) VALUES ('Movie 5', 'Desc 5', '5.5.2005', 'Genre 5', 'Russia', '5000000');
INSERT INTO movies (movie_name, movie_description, movie_year, movie_genres, movie_country, movie_budget) VALUES ('Movie 6', 'Desc 6', '6.6.2006', 'Genre 6', 'Russia', '5000000');

INSERT INTO directors (person_surname, person_name, person_birthday) VALUES ('Director 1', 'sss', '1.1.2001');
INSERT INTO directors (person_surname, person_name, person_birthday) VALUES ('Director 2', 'sss', '2.2.2002');
INSERT INTO directors (person_surname, person_name, person_birthday, person_motherland) VALUES ('Director 3', 'sss', '3.3.2003', 'Russia');
INSERT INTO directors (person_surname, person_name, person_birthday) VALUES ('Director 4', 'sss', '4.4.2004');
INSERT INTO directors (person_surname, person_name, person_birthday) VALUES ('Director 5', 'sss', '5.5.2005');
INSERT INTO directors (person_surname, person_name, person_birthday) VALUES ('Director 6', 'sss', '6.6.2006');

INSERT INTO actors (person_surname, person_name, person_birthday, person_motherland, number_of_movies) VALUES ('sss', 'sss', '1.1.2001', 'Russia', '6');
INSERT INTO actors (person_surname, person_name, person_birthday, person_motherland, number_of_movies) VALUES ('sss', 'sss', '2.2.2002', 'Russia', '8');
INSERT INTO actors (person_surname, person_name, person_birthday, person_motherland, number_of_movies) VALUES ('sss', 'sss', '3.3.2003', 'Russia', '10');
INSERT INTO actors (person_surname, person_name, person_birthday, person_motherland, number_of_movies) VALUES ('sss', 'sss', '4.4.2004', 'BeloRussia', '12');
INSERT INTO actors (person_surname, person_name, person_birthday, person_motherland, number_of_movies) VALUES ('sss', 'sss', '5.5.2005', 'Russia', '14');
INSERT INTO actors (person_surname, person_name, person_birthday, person_motherland, number_of_movies) VALUES ('qq', 'qq', '6.6.2006', 'Tatarsstan', '8');