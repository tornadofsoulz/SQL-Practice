
--1.1 Напишите код проверки выполнения правила ограничения цен.
SELECT * FROM SalesLT.Product as p1 WHERE (ListPrice > (SELECT 20*MIN(ListPrice) FROM SalesLT.Product as p2 WHERE p1.ProductCategoryID = p2.ProductCategoryID)) 
OR (ListPrice < (SELECT MAX(ListPrice)/20 FROM SalesLT.Product as p2 WHERE p1.ProductCategoryID = p2.ProductCategoryID))
DECLARE @COUNTER INT = @@ROWCOUNT
IF (@COUNTER > 0)
	PRINT 'The 20-fold price difference rule is violated ' + CAST(@COUNTER AS VARCHAR(20))+ ' times'
ELSE 
	PRINT 'The 20-fold price difference rule is met'

--1.2. Создайте триггер для обеспечения правила 20-кратной разницы в отпускной цене
--DROP TRIGGER SalesLT.TriggerProductListPriceRules
CREATE TRIGGER SalesLT.TriggerProductListPriceRules ON SalesLt.Product
AFTER INSERT, 	--триггер срабатывает после выполнения оператора INSERT
UPDATE AS
BEGIN
	IF EXISTS(SELECT * FROM SalesLT.Product as p WHERE (ListPrice > (SELECT 20*MIN(ListPrice) FROM SalesLT.Product WHERE ProductCategoryID = p.ProductCategoryID)))
	BEGIN
		ROLLBACK;
		THROW 50001, 'Вносимые изменения нарушают правило 20-кратной разницы в цене товаров из одной рубрики (слишком дешево)', 1;
	END
	IF EXISTS(SELECT * FROM SalesLT.Product as p WHERE (ListPrice > (SELECT MAX(ListPrice)/20 FROM SalesLT.Product WHERE ProductCategoryID = p.ProductCategoryID)))
	BEGIN
		ROLLBACK;
		THROW 50001, 'Вносимые изменения нарушают правило 20-кратной разницы в цене товаров из одной рубрики (слишком дорого)', 1;
	END
END

--1.3 тестирование триггеров

INSERT INTO SalesLT.Product ( SellStartDate, Name, ProductNumber,StandardCost,ListPrice, ProductCategoryID) VALUES (SYSDATETIME(),'RRR', 'TTT', 23, 1,5),
																				    								(SYSDATETIME(),'EEE', 'YYY', 23, 9999999,5)
					
DECLARE @MAXPRICE CHAR(20) = (SELECT MAX(ListPrice) FROM SalesLT.Product where ProductCategoryID = 5)
DECLARE @MINPRICE CHAR(20) = (SELECT MIN(ListPrice) FROM SalesLT.Product where ProductCategoryID = 5)
PRINT 'Max price:' + @MAXPRICE
PRINT 'Min price:' + @MINPRICE;



--2.1 Создание триггеров

CREATE TRIGGER TriggerProduct ON SalesLt.Product
AFTER INSERT, 
UPDATE AS
BEGIN
	IF (SELECT ProductCategoryID FROM SalesLt.Product) NOT IN (SELECT ProductCategoryID FROM SalesLT.ProductCategory)
	BEGIN
		ROLLBACK;
		THROW 50002, 'Ошибка: попытка нарушения ссылочной целостности между таблицами Product и ProductCategory, транзакция отменена',0;
	END;
END


CREATE TRIGGER TriggerProductCategory
ON SalesLt.ProductCategory
AFTER INSERT, UPDATE AS
BEGIN
	IF (SELECT ProductCategoryID FROM SalesLt.ProductCategory) NOT IN (SELECT ProductCategoryID FROM SalesLT.Product)
	BEGIN
		ROLLBACK;
		THROW 50002, 'Ошибка: попытка нарушения ссылочной целостности между таблицами Product и ProductCategory, транзакция отменена', 1;
	END;
END

--2.2 Тестирование триггеров
ALTER TABLE SalesLT.Product NOCHECK CONSTRAINT FK_Product_ProductCategory_ProductCategoryID;
UPDATE SalesLT.Product SET ProductCategoryID = -1 WHERE ProductID = 999
BEGIN tran
DELETE FROM SalesLT.ProductCategory WHERE ProductCategoryID = 5
ROLLBACK

--2.3
ALTER TABLE SalesLT.Product CHECK CONSTRAINT FK_Product_ProductCategory_ProductCategoryID;

DISABLE TRIGGER SalesLT.TriggerProduct ON SalesLT.Product;
DISABLE TRIGGER SalesLT.TriggerProductCategory ON SalesLT.ProductCategory;