--1.1 Получите список городов
SELECT DISTINCT City, StateProvince 
FROM SalesLT.Address --distinct Возвращает все возможные состояния выбранного столбца модели

--1.2 Получите самые тяжелые товары
SELECT TOP 10 percent Name FROM SalesLT.Product ORDER BY Weight DESC --Значение DESC сортирует от высоких значений к низким

--1.3. Извлеките самые тяжелые 100 товаров, не включая десять самых тяжелых
SELECT Name 
FROM SalesLT.Product ORDER BY Weight DESC offset 10 ROWS FETCH NEXT 100 ROWS only

--2.1. Получите информацию о товаре для модели 1
SELECT Name, Color, Size 
FROM SalesLT.Product WHERE ProductModelID = 1

--2.2. Отфильтруйте товары по цвету и размеру
SELECT ProductNumber, Name 
FROM SalesLT.Product WHERE color IN (' black' ,'red' , 'white') AND size IN ('S' , 'M')

--2.3. Отфильтруйте товары по номерам товаров
SELECT ProductNumber, Name, ListPrice 
FROM SalesLT.Product WHERE ProductNumber LIKE 'BK-%'

--2.4. Получите определенные товары по товарному номеру
select ProductNumber, Name, ListPrice 
FROM SalesLT.Product WHERE ProductNumber LIKE 'BK-[^R]%-[0-9][0-9]'
-- -Любой одиночный символ.
--% Любая строка, содержащая ноль или более символов 
--[ ] Любой одиночный символ, содержащийся в диапазоне ([a-f]) или наборе ([abcdef])
--[^] Любой одиночный символ, не содержащийся в диапазоне ([^a-f]) или наборе ([^abcdef]).