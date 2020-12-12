--1.1 Получить заказы клиентов
SELECT c.CompanyName, soh.SalesOrderID, soh.TotalDue 
FROM SalesLT.Customer AS c JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID=soh.CustomerID 

--1.2 Получить заказы клиентов с адресами
SELECT c.CompanyName, soh.SalesOrderID, soh.TotalDue, a.AddressLine1, a.AddressLine2, a.City, a.StateProvince, a.PostalCode, a.CountryRegion
FROM SalesLT.Customer AS c JOIN SalesLT.SalesOrderHeader AS soh ON soh.CustomerID = c.CustomerID
JOIN SalesLT.CustomerAddress AS ca ON c.CustomerID = ca.CustomerID AND AddressType = 'Main Office' 
JOIN SalesLT.Address AS a ON ca.AddressID=a.AddressID

--2.1 Получить список всех клиентов и их заказов
SELECT c.CompanyName, c.FirstName, c.LastName, soh.SalesOrderID, soh.TotalDue 
FROM SalesLT.Customer AS c LEFT JOIN SalesLT.SalesOrderHeader AS soh ON soh.CustomerID = c.CustomerID
ORDER BY soh.CustomerID DESC

--2.2 Получить список клиентов без адреса 
SELECT c.CustomerID, c.CompanyName, c.FirstName, c.LastName, c.Phone 
FROM SalesLT.Customer AS c JOIN SalesLT.CustomerAddress AS ca ON c.CustomerID = ca.CustomerID 
WHERE AddressID IS NULL

--2.3 Получить список клиентов и товаров
SELECT c.CustomerID, p.ProductID 
FROM SalesLT.Customer AS c FULL JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID 
FULL JOIN SalesLT.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
FULL JOIN SalesLT.Product AS p ON sod.ProductID = p.ProductID 
WHERE c.CustomerID IS NULL or p.ProductID IS NULL
