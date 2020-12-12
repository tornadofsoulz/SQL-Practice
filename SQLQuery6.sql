--1.1 ѕолучите товары, у которых прейскурантна€ цена выше средней цены за товар
SELECT ProductID, NAME, ListPrice FROM SalesLT.Product
WHERE ListPrice > (SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail) ORDER BY ProductID

--1.2 ѕолучите товары с прейскурантной ценой в 100 долларов или более, которые были проданы менее чем за 100 долларов
SELECT ProductID, NAME, ListPrice FROM SalesLT.Product
WHERE (ListPrice >= 100) AND ProductID IN (SELECT ProductID FROM SalesLT.SalesOrderDetail WHERE UnitPrice < 100) ORDER BY ProductID

--1.3 ѕолучите себестоимость, прейскурантную цену и среднюю цену продажи дл€ каждого товар
SELECT p.ProductID, p.Name, p.StandardCost, p.ListPrice, 
(SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail WHERE p.ProductID=ProductID) AS AvgSellingPrice FROM SalesLT.Product AS p ORDER BY ProductID

--1.4 ѕолучите товары у которых средн€€ цена продажи ниже себестоимости
SELECT p.ProductID, p.Name, p.StandardCost, p.ListPrice, 
(SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail WHERE p.ProductID=ProductID) AS AvgSellingPrice FROM SalesLT.Product AS p
WHERE (p.StandardCost > (SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail))

--2.1 ѕолучите информацию о клиентах дл€ всех заказов
SELECT soh.SalesOrderID, p.CustomerID, p.FirstName, p.LastName, soh.TotalDue FROM SalesLT.SalesOrderHeader AS soh
CROSS APPLY dbo.ufnGetCustomerInformation(soh.CustomerID) AS P ORDER BY SalesOrderID

--2.2 ѕолучите информацию об адресе клиента
SELECT ca.CustomerID, p.FirstName, p.LastName, a.AddressLine1, a.City 
FROM  SalesLT.CustomerAddress AS ca JOIN SalesLT.Address AS a ON ca.AddressID = a.AddressID 
CROSS APPLY dbo.ufnGetCustomerInformation(ca.CustomerID) AS p ORDER BY p.CustomerID