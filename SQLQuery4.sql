--1.1 Получите платежные адреса
SELECT c.CompanyName, a.AddressLine1 , a.City AS Address, 'Billing' AS AddressType  
FROM SalesLT.Address AS a JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID 
WHERE ca.AddressType = 'Main Office'

--1.2 Получите адрес доставки
SELECT cu.CompanyName, a.AddressLine1 , a.City AS [Address], 'Shipping' AS AddressType  
FROM SalesLT.Address AS a  JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID JOIN SalesLT.Customer AS cu ON ca.CustomerID = cu.CustomerID 
WHERE ca.AddressType = 'Shipping'

--1.3 Объедините платежный адрес и адрес доставки
SELECT c.CompanyName, a.AddressLine1 , a.City AS Address, 'Billing' AS AddressType
FROM SalesLT.Address AS a JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
WHERE ca.AddressType = 'Main Office'
UNION ALL
SELECT c.CompanyName, a.AddressLine1 , a.City AS Address, 'Shipping' AS AddressType
FROM SalesLT.Address AS a  JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID 
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName, AddressType

--2.1 Получите клиентов, имеющих только адрес главного офиса
SELECT c.CompanyName FROM SalesLT.CustomerAddress AS ca JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
WHERE ca.AddressType = 'Main Office'
EXCEPT
SELECT c.CompanyName FROM SalesLT.CustomerAddress AS ca JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
WHERE ca.AddressType = 'Shipping'

--2.2 Получите клиентов, имеющих оба типа адреса
SELECT c.CompanyName FROM SalesLT.CustomerAddress AS ca JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
WHERE ca.AddressType = 'Main Office'
INTERSECT
SELECT c.CompanyName FROM SalesLT.CustomerAddress AS ca JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
where ca.AddressType = 'Shipping'