--1.1 Получите описания модели товара
SELECT p.ProductID, p.Name AS ProductName, descr.Name as ProductModel, descr.Summary 
FROM SalesLT.Product AS p JOIN SalesLT.vProductModelCatalogDescription AS descr ON p.ProductModelID = descr.ProductModelID ORDER BY p.ProductID

--1.2 Создайте таблицу с уникальными цветами
DECLARE @Colors AS TABLE (Color VARCHAR(15))
INSERT INTO @Colors SELECT DISTINCT Color FROM SalesLT.Product
SELECT ProductID, Name, Color FROM SalesLT.Product
WHERE Color IN (SELECT Color FROM @Colors) ORDER BY Color

--1.3 Создайте таблицу с уникальными размерами !!!НЕ РАБОТАЕТ!!!
CREATE TABLE #Sizes (Size VARCHAR(15)) 
INSERT INTO #Sizes SELECT DISTINCT Size FROM SalesLT.Product
SELECT ProductID, Name, Size COLLATE SQL_Latin1_General_CP1_CI_AS FROM SalesLT.Product 
WHERE Size IN (SELECT Size FROM #Sizes) ORDER BY Size DESC 
--SQL_Latin1_General_CP1_CI_AS

--1.4 Получите родительские категории товаров
SELECT p.ProductID, p.Name AS ProductName, f.ParentProductCategoryName AS ParentCategory, f.ProductCategoryName AS Category 
FROM SalesLT.Product AS p JOIN dbo.ufnGetAllCategories() AS f ON p.ProductCategoryID=f.ProductCategoryID
ORDER BY ParentCategory, Category, ProductName

--2.1 Получите доходы от продаж по клиентам и контактные данные
SELECT CompanyContact, SUM(TotalDue) AS Revenue FROM
(SELECT (CompanyName + ' ('+ FirstName + ' ' + LastName + ')') AS CompanyContact, TotalDue 
FROM SalesLT.Customer AS c JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID) AS cn
GROUP BY CompanyContact ORDER BY CompanyContact;


--2.2 Получите доходы от продаж по клиентам и контактные данные  CTE – обобщенные табличные выражения
WITH Client
AS (SELECT (CompanyName + ' ('+ FirstName + ' ' + LastName + ')') AS CompanyContact, soh.TotalDue FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID)
SELECT CompanyContact, SUM(TotalDue) AS Revenue FROM Client
GROUP BY CompanyContact ORDER BY CompanyContact
