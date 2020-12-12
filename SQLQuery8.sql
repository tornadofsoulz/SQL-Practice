--1.1. Получите итоги для страны/региона и штата/провинции
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a INNER JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID INNER JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
GROUP BY GROUPING SETS (a.CountryRegion, a.StateProvince, ())ORDER BY a.CountryRegion, a.StateProvince;

--1.2. Укажите уровни группировки в результатах
SELECT a.CountryRegion, a.StateProvince,
CASE
WHEN CAST(GROUPING_ID(A.CountryRegion, A.StateProvince) AS varchar) = 3 THEN 'Total'
WHEN CAST(GROUPING_ID(A.CountryRegion, A.StateProvince) AS varchar) = 2 THEN a.StateProvince + ' Subtotal'
WHEN CAST(GROUPING_ID(A.CountryRegion, A.StateProvince) AS varchar) = 1 THEN a.CountryRegion + ' Subtotal'
	ELSE CAST(GROUPING_ID(A.CountryRegion, A.StateProvince) AS varchar) END AS Level, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a INNER JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID INNER JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
GROUP BY GROUPING SETS (a.CountryRegion, a.StateProvince, ())ORDER BY a.CountryRegion, a.StateProvince;

--1.3. Добавьте уровень группировки для городов
SELECT Ad.CountryRegion, Ad.StateProvince,City,
CASE
WHEN CAST(GROUPING_ID(Ad.CountryRegion, Ad.StateProvince, City) AS varchar) = 3 THEN Ad.CountryRegion + ' Subtotal'
WHEN CAST(GROUPING_ID(Ad.CountryRegion, Ad.StateProvince, City) AS varchar) = 5 THEN Ad.StateProvince + ' Subtotal'
WHEN CAST(GROUPING_ID(Ad.CountryRegion, Ad.StateProvince, City) AS varchar) = 6 THEN City + ' Subtotal'
WHEN CAST(GROUPING_ID(Ad.CountryRegion, Ad.StateProvince, City) AS varchar) = 7 THEN 'Total'
	ELSE CAST(GROUPING_ID(Ad.CountryRegion, Ad.StateProvince, City) AS varchar) END AS Level, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS Ad INNER JOIN SalesLT.CustomerAddress AS ca ON Ad.AddressID = ca.AddressID INNER JOIN SalesLT.Customer AS cust ON ca.CustomerID = cust.CustomerID
INNER JOIN SalesLT.SalesOrderHeader AS soh ON cust.CustomerID = soh.CustomerID
GROUP BY GROUPING SETS (Ad.CountryRegion, Ad.StateProvince, City, ()) ORDER BY Ad.CountryRegion, Ad.StateProvince, City;

--2.1. Получите доход от продаж для каждой родительской категории |Коля Молодец|
SELECT CompanyName, Bikes, Accessories, Clothing, Components    
FROM (SELECT c.CompanyName AS CompanyName, sod.LineTotal AS S, v.ParentProductCategoryName AS Category
FROM SalesLT.Customer AS c JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID JOIN SalesLT.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN SalesLT.Product AS p ON sod.ProductID = p.ProductID JOIN SalesLT.vGetAllCategories AS v ON p.ProductCategoryID = v.ProductCategoryID) AS sales 
PIVOT (SUM(S) FOR Category IN(Bikes, Accessories, Clothing, Components)) AS pvt ORDER BY CompanyName