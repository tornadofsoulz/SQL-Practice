--1.1. ��������� �������� ����� ������ �� �������
GO
CREATE FUNCTION dbo.fn_GetOrdersTotalDueForCustomer (@CustomerID int)
RETURNS int
AS
BEGIN
	DECLARE @SUM int
	SELECT @SUM = SUM(TotalDue) from SalesLT.SalesOrderHeader WHERE CustomerID=@CustomerID
	RETURN @SUM
END
GO
select dbo.fn_GetOrdersTotalDueForCustomer(1)
select dbo.fn_GetOrdersTotalDueForCustomer(30113)

--1.2. ��������� ���� ����� ������� ��������
GO
CREATE VIEW dbo.vAllAddresses
WITH SCHEMABINDING --����������� ������������� � ����� ������� ������� ��� ������
AS  
(SELECT ca.CustomerID, ca.AddressType, ca.AddressID, a.AddressLine1, a.AddressLine2, a.City, a.StateProvince, a.CountryRegion, a.PostalCode 
FROM SalesLT.Address as a INNER JOIN SalesLT.CustomerAddress as ca on a.AddressID= ca.AddressID)

GO 
SELECT * FROM dbo.vAllAddresses 
 
 --1.3 ��������� ���� ������� �������
GO
CREATE FUNCTION dbo. fn_GetAddressesForCustomer(@CustomerID INT)
RETURNS TABLE AS RETURN 

( SELECT * FROM dbo.vAllAddresses WHERE CustomerID = @CustomerID )


SELECT * FROM dbo.fn_GetAddressesForCustomer(0)
UNION ALL
SELECT * FROM dbo.fn_GetAddressesForCustomer(29502)
UNION ALL 
SELECT * FROM dbo.fn_GetAddressesForCustomer(29503)

--1.4 ����������� ������������ � ����������� ����� ������� ������
GO
CREATE FUNCTION dbo.fn_GetMinMaxOrderPricesForProduct (@ProductID INT)
RETURNS @A TABLE
(
ProductID int NULL,
MinUnitPrice money NULL,  
MaxUnitPrice money NULL
)
AS
BEGIN
    WITH SMTH AS (SELECT ProductID ,MIN(UnitPrice) as MinUnitPrice ,MAX(UnitPrice) as MaxUnitPrice
	FROM SalesLT.SalesOrderDetail  WHERE ProductID = @ProductID GROUP BY ProductID)
	INSERT INTO @A SELECT * FROM SMTH
	RETURN; 
END 
GO 
SELECT * FROM dbo.fn_GetMinMaxOrderPricesForProduct(711)

--1.5. ��������� ���� �������� ������
GO
CREATE FUNCTION fn_GetAllDescriptionsForProduct(@ProductID int)
RETURNS @A TABLE
(
ProductID nvarchar(50) NULL, 
Name nvarchar(50) NULL, 
MinUnitPrice money NULL,  
MaxUnitPrice money NULL, 
ListPrice money NULL,
ProductModel nvarchar(50) NULL, 
Culture nvarchar(50) NULL, 
Description nvarchar(4000) NULL
)
AS
BEGIN
    WITH SMTH AS (SELECT up.ProductID ,v.Name , up.MinUnitPrice , up.MaxUnitPrice , p.ListPrice, v.ProductModel, v.Culture , v.Description 
	From dbo.fn_GetMinMaxOrderPricesForProduct(@ProductID) AS up 
	INNER JOIN SalesLT.vProductAndDescription AS v ON up.ProductID=v.ProductID 
	INNER JOIN SalesLT.Product AS p ON v.ProductID = p.ProductID
    WHERE up.ProductID = @ProductID )
INSERT INTO @A 
 SELECT * FROM SMTH; 
 RETURN; 
END 
GO 
SELECT * FROM dbo.fn_GetAllDescriptionsForProduct(711)
SELECT * FROM dbo.fn_GetAllDescriptionsForProduct(0)

--2.1 �������������� ������������� vAllAddresses
CREATE UNIQUE CLUSTERED INDEX UIX_vAllAddresses ON dbo.vAllAddresses
( 
 [CustomerID] ASC, 
 [AddressType] ASC, 
 [AddressID] ASC, 
 [AddressLine1] ASC,
 [AddressLine2] ASC, 
 [City] ASC,
 [StateProvince] ASC,
 [CountryRegion] ASC,
 [PostalCode] ASC
) ON [PRIMARY] 
 GO
 SELECT *  FROM [dbo].[vAllAddresses] 
 SELECT *  FROM [dbo].[vAllAddresses] WITH (NOEXPAND) --�� ��������
 GO
-- ������������ ���������� ������ �� ������������� (��� ������� �� �������������) 

