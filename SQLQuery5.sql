--1.1 Получите наименование и приблизительный вес каждого товара 
SELECT ProductID, UPPER(Name) AS ProductName, ROUND(Weight, 0) AS ApproxWeight FROM SalesLT.Product
--1.2 Получите год и месяц, когда товары были впервые проданы
SELECT ProductID, UPPER(Name) AS ProductName, ROUND(Weight, 0) AS ApproxWeight, YEAR(SellStartDate) AS SellStartYear, DATENAME(mm, SellStartDate) AS SellStartMonth 
FROM SalesLT.Product
--1.3 Получите типы товаров из номеров товаров
SELECT ProductID, UPPER(Name) AS ProductName, ROUND(Weight, 0) AS ApproxWeight, YEAR(SellStartDate) AS SellStartYear, DATENAME(mm, SellStartDate) AS SellStartMonth, LEFT(ProductNumber, 2) as ProductType 
FROM SalesLT.Product
--1.4 Получите только товары, имеющие числовой размер
SELECT ProductID, UPPER(Name) AS ProductName, ROUND(Weight, 0) AS ApproxWeight, YEAR(SellStartDate) AS SellStartYear, DATENAME(mm, SellStartDate) AS SellStartMonth, LEFT(ProductNumber, 2) as ProductType
FROM SalesLT.Product WHERE ISNUMERIC(Size) = 1

--2.1 Получите компании, отранжированные по суммам продаж
SELECT C.CompanyName, SOH.TotalDue AS Revenue, RANK() OVER(ORDER BY SOH.TotalDue DESC) AS RankbyRevenue
FROM SalesLT.Customer AS C JOIN SalesLT.SalesOrderHeader AS SOH ON C.CustomerID = SOH.CustomerID

--3.1 Получите общий объем продаж по товару
SELECT P.Name, SUM(SOD.LineTotal) AS TotalRevenue 
FROM SalesLT.Product AS P JOIN SalesLT.SalesOrderDetail AS SOD ON P.ProductID = SOD.ProductID GROUP BY Name ORDER BY TotalRevenue DESC
--3.2 Отфильтруйте список продаж товаров, включив в него только те товары, стоимость которых превышает $1000
SELECT Pr.Name, SUM(SOD.LineTotal) AS TotalRevenue 
FROM SalesLT.Product AS Pr JOIN SalesLT.SalesOrderDetail AS SOD ON Pr.ProductID = SOD.ProductID WHERE SOD.LineTotal > 1000 GROUP BY Name ORDER BY TotalRevenue DESC
--3.3 Отфильтруйте группы продаж товаров так, чтобы включить только те из них, общий объем продаж которых более $20000
SELECT Pr.Name, SUM(SOD.LineTotal) AS TotalRevenue 
FROM SalesLT.Product AS Pr JOIN SalesLT.SalesOrderDetail AS SOD ON Pr.ProductID = SOD.ProductID WHERE SOD.LineTotal > 1000 GROUP BY Name HAVING SUM(SOD.LineTotal) >20000 ORDER BY TotalRevenue DESC
