
--1.1. Выбросите ошибку для несуществующих заказов

BEGIN TRAN

DECLARE @SalesOrderID INT = 7193
IF EXISTS (SELECT SalesOrderID FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID)
BEGIN
	DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
	DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
SELECT SalesOrderID FROM SalesLT.SalesOrderDetail
END
ELSE
BEGIN
	DECLARE @ToString varchar(24) = 'Order ' + CAST(@SalesOrderID AS varchar) + ' does not exist' RAISERROR (@ToString, 16, 0);
END

ROLLBACK TRAN

--1.2. Обработка ошибок
BEGIN TRAN
SELECT SalesOrderID FROM SalesLT.SalesOrderDetail
DECLARE @SalesOrderID INT = 71784

BEGIN TRY
IF EXISTS (SELECT SalesOrderID FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID)
BEGIN
	DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
	DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
END
ELSE
BEGIN
	DECLARE @TEXT varchar(24); SET @TEXT = 'Order ' + CAST(@SalesOrderID AS varchar) + ' Not exist'; 
	THROW 50001, @TEXT, 0;
END
END TRY

BEGIN CATCH
PRINT ERROR_MESSAGE();
THROW 50001, 'An error occurred', 0;
END CATCH;

ROLLBACK TRAN

--2.1. Внедрение транзакций
BEGIN TRAN-----------------

DECLARE @SalesOrderID INT = 71782
BEGIN TRY
IF (EXISTS (SELECT SalesOrderID FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID))
BEGIN
	BEGIN TRAN ---------------

	DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
	THROW 50001, 'An error occurred', 0;
	DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;

	COMMIT TRAN
END
ELSE
BEGIN
	DECLARE @TEXT varchar(24); SET @TEXT = 'Order ' + CAST(@SalesOrderID AS varchar) + ' does not exist'; 
	THROW 50001, @TEXT, 0;
END;
END TRY

BEGIN CATCH

if @@TRANCOUNT > 0
BEGIN
ROLLBACK TRAN
END
PRINT ERROR_MESSAGE();
THROW 50001, 'An error occurred', 0

END CATCH;

ROLLBACK TRAN