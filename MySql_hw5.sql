CREATE TABLE cars
(
	id INT NOT NULL PRIMARY KEY,
    name VARCHAR(45),
    cost INT
);

INSERT cars
VALUES
	(1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
	(5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
    
SELECT *
FROM cars;

## Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов CREATE VIEW CheapCars AS SELECT Name FROM Cars WHERE Cost<25000;
CREATE VIEW RatedCars AS
SELECT Name
FROM Cars
WHERE Cost < 25000;
SELECT * FROM RatedCars;

## Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW) ALTER VIEW CheapCars AS SELECT Name FROM CarsWHERE Cost<30000;

ALTER VIEW RatedCars AS
SELECT Name
FROM Cars
WHERE Cost < 30000;
SELECT * FROM RatedCars;

/* Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди” (аналогично)
 Вывести название и цену для всех анализов, которые продавались 5 февраля 2020 и всю следующую неделю. 
 Есть таблица анализов Analysis: an_id — ID анализа; an_name — название анализа; an_cost — себестоимость анализа; 
 an_price — розничная цена анализа; an_group — группа анализов. 
 Есть таблица групп анализов Groups: gr_id — ID группы; gr_name — название группы; gr_temp — температурный режим хранения.
 Есть таблица заказов Orders: ord_id — ID заказа; ord_datetime — дата и время заказа; ord_an — ID анализа.
 */
CREATE VIEW SkodaAudiCars AS
SELECT Name, Cost
FROM Cars
WHERE Name IN ('Skoda', 'Audi');

/*Добавьте новый столбец под названием «время до следующей станции». Чтобы получить это
значение, мы вычитаем время станций для пар смежных станций. Мы можем вычислить это
значение без использования оконной функции SQL, но это может быть очень сложно. Проще
это сделать с помощью оконной функции LEAD . Эта функция сравнивает значения из одной
строки со следующей строкой, чтобы получить результат. В этом случае функция сравнивает
значения в столбце «время» для станции со станцией сразу после нее
*/
CREATE TABLE trains (
    train_id integer,
    station character varying(20),
    station_time time
);

INSERT INTO trains (train_id, station, station_time)
VALUES
    (110, 'San Francisco', '10:00:00'),
    (110, 'Redwood City', '10:54:00'),
    (110, 'Palo Alto', '11:02:00'),
    (110, 'San Jose', '12:35:00'),
    (120, 'San Francisco', '11:00:00'),
    (120, 'Palo Alto', '12:49:00'),
    (120, 'San Jose', '13:30:00');
    
ALTER TABLE trains
ADD COLUMN time_to_next_station time;

CREATE TABLE updated_trains AS
SELECT
    train_id,
    station,
    station_time,
    LEAD(station_time) OVER (PARTITION BY train_id ORDER BY station_time) AS next_station_time,
    TIMEDIFF(
        LEAD(station_time) OVER (PARTITION BY train_id ORDER BY station_time),
        station_time
    ) AS time_to_next_station
FROM trains;

DROP TABLE trains;
ALTER TABLE updated_trains RENAME TO trains;
SELECT * FROM trains;









