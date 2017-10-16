--Создаем таблицу зданий с полями:
----кадастр, год постройки, площадь, износ, комментарии, этажность, наличие лифта, площадь нежилых помещений
--Первичный ключ - кадастр
--Ограничения CHECK:
----1500<=год постройки<=текущий год
----износ от 0 до 100
----этажей не менее одного
----если всего один этаж, то не может быть лифта
----площадь нежилых не больше всей площади
CREATE TABLE buildings (
  kadastr VARCHAR(20) NOT NULL,
  building_year INTEGER NOT NULL,
  building_land INTEGER NOT NULL,
  building_wear INTEGER NOT NULL,
  building_comments TEXT,
  building_flow INTEGER NOT NULL,
  building_elevator BOOLEAN NOT NULL,
  building_square INTEGER NOT NULL,
  CONSTRAINT PK_buildings PRIMARY KEY (kadastr),
  CONSTRAINT CK_building_year CHECK ((building_year >= 1500) AND (building_year <= EXTRACT(YEAR FROM current_date))),
  CONSTRAINT CK_building_wear CHECK ((building_wear >= 0) AND (building_wear < 100)),
  CONSTRAINT CK_building_flow CHECK (building_flow >= 1),
  CONSTRAINT CK_building_elevator CHECK ((building_flow = 1) AND (building_elevator = FALSE)),
  CONSTRAINT CK_building_square CHECK (building_square <= building_land)
);

--Создаем таблицу 'кадастр к материалу' для соответствия 1 НФ:
----кадастр - внешний ключ, ссылающийся на кадастр в buildings
----материал
CREATE TABLE kadastr_to_material (
  kadastr VARCHAR(20) NOT NULL,
  building_material VARCHAR(15) NOT NULL,
  CONSTRAINT FK_material_kadastr FOREIGN KEY (kadastr) REFERENCES buildings(kadastr)
);

--Создаем таблицу 'кадастр к материалу фундамента' для соответствия 1 НФ:
----кадастр - внешний ключ, ссылающийся на кадастр в buildings
----материал фундамента
CREATE TABLE kadastr_to_base (
  kadastr VARCHAR(20) NOT NULL,
  building_base VARCHAR(15) NOT NULL,
  CONSTRAINT FK_base_kadastr FOREIGN KEY (kadastr) REFERENCES buildings(kadastr)
);

--Создаем таблицу 'кадастр к фотографии' для соответствия 1 НФ:
----кадастр - внешний ключ, ссылающийся на кадастр в buildings
----фотография
CREATE TABLE kadastr_to_picture (
  kadastr VARCHAR(20) NOT NULL,
  building_picture_url VARCHAR(50) NOT NULL,
  CONSTRAINT FK_picture_kadastr FOREIGN KEY (kadastr) REFERENCES buildings(kadastr)
);

--Создаем таблицу 'кадастр к адресу' для соответствия 3 НФ:
----кадастр - первичный и внешний ключ, ссылающийся на кадастр в buildings
----адрес

CREATE TABLE kadastr_to_address (
  kadastr VARCHAR(20) NOT NULL,
  building_address VARCHAR(60) NOT NULL UNIQUE,
  CONSTRAINT PK_address PRIMARY KEY (kadastr),
  CONSTRAINT FK_address_kadastr FOREIGN KEY (kadastr) REFERENCES buildings(kadastr)
);

--Создаем таблицы 'адрес к району' и 'адрес к расстоянию до центра' для соответствия 3 НФ:
----адрес - первичный и внешний ключ, ссылающийся на адрес в kadastr_to_address
----район или расстояние до центра

CREATE TABLE address_to_district (
  building_address VARCHAR(60) NOT NULL,
  building_district VARCHAR(15) NOT NULL,
  CONSTRAINT FK_district_address FOREIGN KEY (building_address) REFERENCES kadastr_to_address(building_address),
  CONSTRAINT PK_district_address PRIMARY KEY (building_address)
);

CREATE TABLE address_to_line (
  building_address VARCHAR(60) NOT NULL,
  building_district INTEGER NOT NULL,
  CONSTRAINT FK_line_address FOREIGN KEY (building_address) REFERENCES kadastr_to_address(building_address),
  CONSTRAINT PK_line_address PRIMARY KEY (building_address)
);

--Создаем таблицу помещений с полями:
----номер помещения, кадастр, номер этажа, количество комнат, площадь помешения,
----вспомогательная площадь, площадь балкона, высота помещения
--Первичный ключ - кадастр и номер помещения
--Внешний ключ - кадастр ссылается на кадастр в buildings
--Ограничения CHECK:
----не меньше одной комнаты
----площадь вспомогательных помещений и площадь балкона не больше общей площади

CREATE TABLE halls (
  hall_number INTEGER NOT NULL UNIQUE,
  kadastr VARCHAR(20) NOT NULL UNIQUE,
  hall_storey INTEGER NOT NULL,
  hall_rooms INTEGER NOT NULL,
  hall_level BOOLEAN NOT NULL,
  hall_square INTEGER NOT NULL,
  hall_branch INTEGER NOT NULL,
  hall_balcony INTEGER NOT NULL,
  hall_height INTEGER NOT NULL,
  CONSTRAINT FK_hall_kadastr FOREIGN KEY (kadastr) REFERENCES buildings(kadastr),
  CONSTRAINT PK_hall PRIMARY KEY (kadastr, hall_number),
  CONSTRAINT CK_hall_rooms CHECK (hall_rooms >= 1),
  CONSTRAINT CK_hall_square CHECK (hall_square >= (hall_balcony + hall_branch))
);

--Создаем таблицу комнат с полями:
----номер комнаты, номер помещения, кадастр, площадь, высота комнаты, размеры в плане,
----количество розеток, количество элементов в системе отопления
--Первичный ключ - кадастр, номер помещения и номер комнаты
--Внешние ключи:
----кадастр ссылается на кадастр в buildings
----номер помещения ссылается на номер помещения в halls

CREATE TABLE rooms (
  room_number INTEGER NOT NULL UNIQUE,
  hall_number INTEGER NOT NULL UNIQUE,
  kadastr VARCHAR(20) NOT NULL UNIQUE,
  room_square INTEGER NOT NULL,
  room_height INTEGER NOT NULL,
  room_size VARCHAR(40) NOT NULL,
  room_socket INTEGER NOT NULL,
  room_sections INTEGER NOT NULL,
  CONSTRAINT PK_room PRIMARY KEY (room_number, hall_number, kadastr),
  CONSTRAINT FK_hall_number FOREIGN KEY (hall_number) REFERENCES halls (hall_number),
  CONSTRAINT FK_room_kadastr FOREIGN KEY (kadastr) REFERENCES buildings (kadastr)
);

--Создаем таблицы 'комната к отделке' и 'комната к предназначению' для соответствия 1 НФ:
----(номер комнаты, номер помещения, кадастр) внешний ключ, ссылающийся
------на (номер комнаты, номер помещения, кадастр) в rooms
----отделка или предназначение

CREATE TABLE room_to_decoration (
  room_number INTEGER NOT NULL,
  hall_number INTEGER NOT NULL,
  kadastr VARCHAR(20) NOT NULL,
  decoration VARCHAR(60) NOT NULL,
  CONSTRAINT FK_decoration_room FOREIGN KEY (room_number, hall_number, kadastr) REFERENCES rooms (room_number, hall_number, kadastr)
);

CREATE TABLE room_to_function (
  room_number INTEGER NOT NULL,
  hall_number INTEGER NOT NULL,
  kadastr VARCHAR(20) NOT NULL,
  function VARCHAR(30) NOT NULL,
  CONSTRAINT FK_function_room FOREIGN KEY (room_number, hall_number, kadastr) REFERENCES rooms (room_number, hall_number, kadastr)
);