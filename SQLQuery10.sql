
--1.1 Напишите код для добавления заголовка заказа
GO
CREATE SCHEMA Test;

GO
CREATE SEQUENCE Test.CountBy1
Start WITH 71946
INCREMENT BY 1
GO
DECLARE @OrderDate DATETIME= GETDATE()
DECLARE @DueDate DATETIME = DATEADD (d, 7, GETDATE())
DECLARE @CustomerID INT=1
DECLARE @ID INT = NEXT VALUE FOR Test.CountBy1
PRINT @ID

SET IDENTITY_INSERT SalesLT.SalesOrderHeader ON --Позволяет вставлять явные значения в столбец идентификаторов таблицы
INSERT INTO SalesLT.SalesOrderHeader (SalesOrderID, CustomerID, OrderDate, DueDate, ShipMethod)
VALUES (@ID, @CustomerID, @OrderDate, @DueDate, 'CARGO TRANSPORT 5')
SET IDENTITY_INSERT SalesLT.SalesOrderHeader OFF

SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID=@ID

--1.2 Напишите код, добавляющий товар к заказу
BEGIN TRAN

DECLARE @SalesOrderID INT = 71947
DECLARE @ProductID INT = 760
DECLARE @OrderQty SMALLINT = 1
DECLARE @UnitPrice MONEY = 782.99

IF EXISTS (SELECT SalesOrderID FROM SalesLT.SalesOrderHeader WHERE SalesOrderID=@SalesOrderID)
BEGIN
	INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice) VALUES (@SalesOrderID, @ProductID, @OrderQty, @UnitPrice)
	SELECT * FROM SalesLT.SalesOrderDetail WHERE SalesOrderID=@SalesOrderID
END
ELSE
BEGIN
	PRINT 'ORDER WAS NOT DETECTED'
END

ROLLBACK TRAN

--2.1 Напишите цикл WHILE, чтобы обновить цены на велосипеды
--SELECT * FROM  SalesLT.vGetAllCategories
BEGIN TRAN

DECLARE @MaxPrice money = 5000
DECLARE @AvgPrice money = 2000

WHILE (@AvgPrice > (SELECT AVG(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID IN (SELECT ProductCategoryID
FROM SalesLT.vGetAllCategories WHERE ParentProductCategoryName = 'Bikes')))
AND
(@MaxPrice > (SELECT MAX(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID IN (SELECT ProductCategoryID
FROM SalesLT.vGetAllCategories WHERE ParentProductCategoryName = 'Bikes')))

BEGIN
	UPDATE SalesLT.Product SET ListPrice = 1.1*ListPrice WHERE ProductCategoryID IN (SELECT ProductCategoryID
	FROM SalesLT.vGetAllCategories WHERE ParentProductCategoryName = 'Bikes')
END

DECLARE @x MONEY = (SELECT MAX(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID IN (SELECT ProductCategoryID
FROM SalesLT.vGetAllCategories WHERE ParentProductCategoryName = 'Bikes'))
DECLARE @y MONEY = (SELECT AVG(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID IN (SELECT ProductCategoryID
FROM SalesLT.vGetAllCategories WHERE ParentProductCategoryName = 'Bikes'))

PRINT @x
PRINT @y


ROLLBACK TRAN 

SELECT * FROM SalesLT.SalesOrderHeader -- Костыльность