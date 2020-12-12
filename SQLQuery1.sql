--1.1 Получить сведения о клиентах
SELECT * 
FROM SalesLT.Customer

--1.2 Получить данные по имени клиента
SELECT Title, FirstName, MiddleName, LastName, Suffix 
FROM SalesLT.Customer

--1.3 Получить имена клиентов и номера телефонов
SELECT SalesPerson,ISNULL (Title + ' ', '') + LastName AS CustomerName, Phone
FROM SalesLT.Customer

--2.1 Получить список компаний-клиентов
SELECT STR(CustomerID) + ': ' + ISNULL(CompanyName, '') AS CustomerCompany
FROM SalesLT.Customer

--2.2 Получить список изменений заказа клиента
SELECT SalesOrderNumber + ' (' + CAST(RevisionNumber AS VARCHAR(16)) + ')' AS OrderRevision, CONVERT (VARCHAR(16), OrderDate, 102) AS OrderDate
FROM SalesLT.SalesOrderHeader

--3.1 Получить имена контактов с отчествами, если они известны
SELECT FirstName + ISNULL(' ' + MiddleName, '') + ' ' + LastName as CustomerName
FROM SalesLT.Customer

--3.2 Получить первичные контактные данные
UPDATE SalesLT.Customer SET EmailAddress = NULL WHERE CustomerID % 7 = 1;
SELECT CustomerID, ISNULL(EmailAddress, Phone) AS PrimaryContact
FROM SalesLT.Customer

--3.3 Получить статус доставки
UPDATE SalesLT.SalesOrderHeader 
SET ShipDate = NULL
WHERE SalesOrderID > 71899;
SELECT SalesOrderID, ISNULL(CONVERT(varchar(16), ShipDate, 121),'Awaiting Shipment') AS ShippingStatus
FROM SalesLT.SalesOrderHeader