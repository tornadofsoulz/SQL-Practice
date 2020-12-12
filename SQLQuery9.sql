--1.1 Добавьте товар
INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate) VALUES ('LED Lights', 'LT-L123', 2.56, 12.99, 37, GETDATE())
SELECT ProductID FROM SalesLT.Product WHERE ProductID= SCOPE_IDENTITY()
SELECT * FROM SalesLT.Product WHERE ProductID = SCOPE_IDENTITY()

--1.2 Добавьте новую товарную категорию с двумя товарами
INSERT INTO SalesLT.ProductCategory (Name, ParentProductCategoryID) values ('Bells and Horns', 4)
DECLARE @id INT = SCOPE_IDENTITY()
INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate) 
VALUES ('Bicycle Bell', 'BB-RING', 2.47, 4.99, @id, GETDATE()), ('Bicycle Horn', 'BB-PARP', 1.29, 3.75, @id, GETDATE())
-----— 
SELECT p.Name, p.ProductNumber, p.StandardCost, p.ListPrice, p.ProductCategoryID, p.SellStartDate, pc.ProductCategoryID, pc.ParentProductCategoryID
FROM SalesLT.Product AS p join SalesLT.ProductCategory AS pc ON pc.ProductCategoryID = p.ProductCategoryID
WHERE pc.Name = 'Bells and Horns'

--2.1 Обновление цен на товары
UPDATE SalesLT.Product SET ListPrice = 1.1*(ListPrice)
WHERE ProductCategoryID = (SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns')

--2.2 Прекращение продаж товаров
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE() WHERE ((ProductCategoryID = 37) AND (ProductNumber != 'LT-L123'))

--Задача 3: Удаление товаров
--1. Удалить категорию товаров и товары в ней

DELETE FROM SalesLT.Product WHERE ProductCategoryID = (SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns')
DELETE FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns'