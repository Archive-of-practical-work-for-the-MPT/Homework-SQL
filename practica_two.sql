-- создание таблиц и их заполнение
CREATE TABLE Firms(
	ID_Firm SERIAL PRIMARY KEY,
	Firm VARCHAR(50) NOT NULL
);

INSERT INTO Firms(Firm)
VALUES
('Salomon'),
('Asics'),
('New Balance'),
('Nike');

CREATE TABLE Types(
	ID_Type SERIAL PRIMARY KEY,
	Type VARCHAR(50) NOT NULL
);

INSERT INTO Types(Type)
VALUES
('Туристические'),
('Спортивная'),
('Уличная');

CREATE TABLE Products(
	ID_Product SERIAL PRIMARY KEY,
	Model VARCHAR(100) NOT NULL,
	Firm_ID INT NOT NULL REFERENCES Firms(ID_Firm),
	Type_ID INT NOT NULL REFERENCES Types(ID_Type)
);

INSERT INTO Products(Model, Firm_ID, Type_ID)
VALUES
('XT-6', 1, 1),
('Gel Kayano 14', 2, 2),
('Joe Freshgoods Performance', 3, 3),
('550', 3, 2),
('Air Monarch', 4, 3),
('Air Jordan ', 4, 2);

CREATE TABLE Colors(
	ID_Color SERIAL PRIMARY KEY,
	Color VARCHAR(50) NOT NULL
);

INSERT INTO Colors(Color)
VALUES
('Белый'),
('Синий'),
('Розовый'),
('Черный'),
('Красный'),
('Фиолетовый');

CREATE TABLE Specifications(
	ID_Specification SERIAL PRIMARY KEY,
	Product_ID INT NOT NULL REFERENCES Products(ID_Product),
	Count INT NOT NULL,
	Size INT NOT NULL,
	Color_ID INT NOT NULL REFERENCES Colors(ID_Color),
	Price DECIMAL(10, 2) NOT NULL
);

INSERT INTO Specifications(Product_ID, Count, Size, Color_ID, Price)
VALUES
(1, 120, 43, 1, 13514.00),
(2, 100, 38, 2, 10690.00),
(2, 50, 43, 1, 8524.31),
(3, 100, 43, 3, 51000.00),
(3, 200, 43, 3, 51000.00),
(4, 400, 43, 1, 11999.00),
(5, 1000, 43, 4, 9399.00),
(6, 4000, 43, 5, 7545.00),
(6, 5000, 43, 6, 9547.00);

CREATE TABLE Plants(
	ID_Plant SERIAL PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	Address VARCHAR(100) NOT NULL
);

INSERT INTO Plants(Name, Address)
VALUES
('Корпус 1', 'ул. Карбышева 23'),
('Корпус 23', 'ул. Заводкая 2'),
('Корпус 2', 'ул. Карбышева 17'),
('Корпус 32', 'ул. Анютина 30');

CREATE TABLE Seasons(
	ID_Season SERIAL PRIMARY KEY,
	Season VARCHAR(5) NOT NULL
);

INSERT INTO Seasons(Season)
VALUES
('Весна'),
('Лето'),
('Зима'),
('Осень');

CREATE TABLE Productions(
	ID_Production SERIAL PRIMARY KEY,
	Product_ID INT NOT NULL REFERENCES Products(ID_Product),
	Plant_ID INT NOT NULL REFERENCES Plants(ID_Plant),
	Season_ID INT NOT NULL REFERENCES Seasons(ID_Season),
	YearOfManufacture INT NOT NULL
);

INSERT INTO Productions(Product_ID, Plant_ID, Season_ID, YearOfManufacture)
VALUES
(1, 1, 4, 2023),
(2, 2, 4, 2023),
(3, 3, 4, 2023),
(4, 4, 3, 2024),
(5, 1, 3, 2024),
(6, 2, 1, 2024),
(1, 3, 1, 2024),
(2, 4, 1, 2024),
(3, 1, 1, 2024);

CREATE TABLE Staff(
	ID_Staff SERIAL PRIMARY KEY,
	Surname VARCHAR(50) NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	Patronymic VARCHAR(50) NOT NULL,
	Gender CHAR(1) NOT NULL,
	Plant_ID INT NOT NULL REFERENCES Plants(ID_Plant),
	CONSTRAINT check_Gender CHECK (Gender IN ('М', 'Ж'))
);

INSERT INTO Staff(Surname, FirstName, Patronymic, Gender, Plant_ID)
VALUES
('Ковалев', 'Олег', 'Денисович', 'М', 1),
('Бунина', 'Мася', 'Денисовна', 'Ж', 1),
('Миронова', 'Илина', 'Олеговна', 'Ж', 1),
('Милега', 'Василий', 'Петрович', 'М', 1),
('Артанов', 'Иван', 'Аркадьевич', 'М', 1),
('Круговов', 'Итон', 'Валиниевич', 'М', 2),
('Сурин', 'Дмитрий', 'Васильевич', 'М', 2),
('Саха-Ану-Дин', 'Абдула', 'Акафьевич', 'М', 2),
('Полянкин', 'Александр', 'Александрович', 'М', 2),
('Васнецова', 'Василиса', 'Александровна', 'Ж', 3),
('Синицина', 'Екатерина', 'Евгеньевна', 'Ж', 3),
('Кусанина', 'Евгения', 'Анатольевна', 'Ж', 3),
('Улинин', 'Петр', 'Платонович', 'М', 3),
('Пушкин', 'Сергей', 'Ульянович', 'М', 4),
('Ельцов', 'Иван', 'Денисович', 'М', 4),
('Ховрин', 'Антон', 'Андреевич', 'М', 4),
('Аканов', 'Денис', 'Константинович', 'М', 4);

-- представления
CREATE VIEW StaffDetails AS
SELECT 
    CONCAT(Staff.Surname, ', ', Staff.FirstName, ' ', Staff.Patronymic) AS "Полное имя",
    Staff.Gender AS "Пол",
    Plants.Name AS "Корпус"
FROM Staff
JOIN Plants ON Staff.Plant_ID = Plants.ID_Plant;

SELECT * FROM StaffDetails;

CREATE VIEW ProductionInfo AS
SELECT 
    Products.Model AS "Модель",
    Plants.Name AS "Завод",
    Plants.Address AS "Адрес",
    Seasons.Season AS "Сезон",
    Productions.YearOfManufacture AS "Год"
FROM Products
JOIN Productions ON Products.ID_Product = Productions.Product_ID
JOIN Plants ON Productions.Plant_ID = Plants.ID_Plant
JOIN Seasons ON Productions.Season_ID = Seasons.ID_Season;

SELECT * FROM ProductionInfo;

CREATE VIEW SalesSummary AS
SELECT 
    Types.Type AS "Тип продукта",
    COUNT(DISTINCT Products.ID_Product) AS "Кол-во уникальных продуктов",
    SUM(Specifications.Count) AS "Количество на складе",
    SUM(Specifications.Price) AS "Цена всех кросовок",
    ROUND(AVG(Specifications.Price), 2) AS "Средняя цена всех кросовок"
FROM Products
JOIN Types ON Products.Type_ID = Types.ID_Type
JOIN Specifications ON Products.ID_Product = Specifications.Product_ID
GROUP BY Types.Type;

SELECT * FROM SalesSummary;

-- процедуры
CREATE OR REPLACE PROCEDURE Add_Firm(
    firm_name VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF firm_name IS NULL THEN
        RAISE EXCEPTION 'Фирма не может быть NULL';
    END IF;

    IF EXISTS (SELECT 1 FROM Firms WHERE Firm = firm_name) THEN
        RAISE EXCEPTION 'Фирма с названием % уже существует', firm_name;
    ELSE
        INSERT INTO Firms(Firm) VALUES (firm_name);
    END IF;
END $$; 

CALL Add_Firm(
	'Корпус 1234'
);

SELECT * FROM Firms;

CREATE OR REPLACE PROCEDURE Update_Firm(
    name_firm VARCHAR(50),
	new_name VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF new_name IS NULL THEN
        RAISE EXCEPTION 'Фирма не может быть NULL';
    END IF;

    IF EXISTS (SELECT 1 FROM Firms WHERE Firm = new_name) THEN
        RAISE EXCEPTION 'Фирма с названием % уже существует', new_name;
    ELSE
		UPDATE Firms
		SET Firm = new_name
		WHERE Firm = Update_Firm.name_firm;
    END IF;
END $$; 

CALL Update_Firm(
	'Корпус 1234', 'GUCCI'
);

SELECT * FROM Firms;

CREATE OR REPLACE PROCEDURE Delete_Firm(
    firm_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Firms WHERE ID_Firm = firm_id;
END $$; 

CALL Delete_Firm(5);

SELECT * FROM Firms;

-- функции
CREATE OR REPLACE FUNCTION avg_price_by_type(type_name VARCHAR)
RETURNS DECIMAL
LANGUAGE plpgsql
AS $$
	DECLARE avg_price DECIMAL;
BEGIN
    SELECT AVG(Specifications.Price) INTO avg_price
    FROM Products
    INNER JOIN Specifications ON Products.ID_Product = Specifications.Product_ID
    INNER JOIN Types ON Products.Type_ID = Types.ID_Type
    WHERE Types.Type = type_name;
    
    RETURN avg_price;
END $$; 

SELECT avg_price_by_type('Спортивная');

CREATE OR REPLACE FUNCTION count_products_by_firm_in_plant(
	firm_name VARCHAR,
	plant_name VARCHAR
)
RETURNS INT
LANGUAGE plpgsql
AS $$
	DECLARE product_count INT;
BEGIN
    SELECT COUNT(*) INTO product_count
    FROM Products
    INNER JOIN Productions ON Products.ID_Product = Productions.Product_ID
    INNER JOIN Firms ON Products.Firm_ID = Firms.ID_Firm
    INNER JOIN Plants ON Productions.Plant_ID = Plants.ID_Plant
    WHERE Firms.Firm = firm_name AND Plants.Name = plant_name;
    
    RETURN product_count;
END $$; 

SELECT count_products_by_firm_in_plant('Nike', 'Корпус 23');

CREATE OR REPLACE FUNCTION count_staff_by_gender_in_plant(
	gender_search CHAR,
	plant_name VARCHAR
)
RETURNS INT
LANGUAGE plpgsql
AS $$
	DECLARE staff_count INT;
BEGIN
    SELECT COUNT(*) INTO staff_count
    FROM Staff
    INNER JOIN Plants ON Staff.Plant_ID = Plants.ID_Plant
    WHERE Staff.Gender = gender_search AND Plants.Name = plant_name;
    
    RETURN staff_count;
END $$; 

SELECT count_staff_by_gender_in_plant('Ж', 'Корпус 1');

-- триггеры
CREATE OR REPLACE FUNCTION trigger_avg_price_by_type()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    PERFORM avg_price_by_type(NEW.Type);
    RETURN NEW;
END $$; 

CREATE OR REPLACE FUNCTION trigger_count_products_by_firm_in_plant()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    PERFORM count_products_by_firm_in_plant(NEW.Firm_Name, NEW.Plant_Name);
    RETURN NEW;
END $$; 

CREATE OR REPLACE FUNCTION trigger_count_staff_by_gender_in_plant()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    PERFORM count_staff_by_gender_in_plant(NEW.Gender, NEW.Plant_Name);
    RETURN NEW;
END $$; 

-- роли
CREATE USER Admin_Login WITH PASSWORD '321';
CREATE USER Staff_Login WITH PASSWORD '123';

CREATE ROLE TableManager;
GRANT TableManager TO Admin_Login, Staff_Login;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO TableManager;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO Staff_Login;

/*
SET ROLE artamonova;

RESET ROLE;

GRANT SELECT ON Products TO artamonova;
GRANT SELECT ON ALL TABLES IN SCHEMA PUBLIC TO artamonova;

DO $$
BEGIN
	RAISE NOTICE '%', current_user;
END $$;
*/

-- LIKE
SELECT * FROM Products WHERE Products.Model LIKE '_T%';

-- ИМПОРТ ЭКСПОРТ
COPY (SELECT Model, Firm_ID, Type_ID FROM Products) TO 'C:\Users\Public\ExportProductsPGS.csv' WITH CSV HEADER DELIMITER ','; -- импорт

COPY (SELECT Surname, FirstName, Patronymic, Gender, Plant_ID FROM Staff) TO 'C:\Users\Public\ExportStaffPGS.csv' WITH CSV HEADER DELIMITER ','; -- импорт

COPY Products(Model, Firm_ID, Type_ID) FROM 'C:\Users\Public\ExportProductsPGS.csv' WITH CSV HEADER DELIMITER ','; -- экспорт

COPY Staff(Surname, FirstName, Patronymic, Gender, Plant_ID) FROM 'C:\Users\Public\ExportStaffPGS.csv' WITH CSV HEADER DELIMITER ','; -- экспорт

SELECT * FROM Products;

-- бэкап в консоле
/*
pg_dump -U postgres Factory > C:\Users\Public\Factory.sql

psql -U postgres -d Factory > C:\Users\Public\Factory.sql
*/














