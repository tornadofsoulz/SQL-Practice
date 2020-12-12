--1.1 �������� ������������ � ��������������� ��� ������� ������ 
SELECT ProductID, UPPER(Name) AS ProductName, ROUND(Weight, 0) AS ApproxWeight FROM SalesLT.Product
--1.2 �������� ��� � �����, ����� ������ ���� ������� �������
SELECT ProductID, UPPER(Name) AS ProductName, ROUND(Weight, 0) AS ApproxWeight, YEAR(SellStartDate) AS SellStartYear, DATENAME(mm, SellStartDate) AS SellStartMonth 
FROM SalesLT.Product
--1.3 �������� ���� ������� �� ������� �������
SELECT ProductID, UPPER(Name) AS ProductName, ROUND(Weight, 0) AS ApproxWeight, YEAR(SellStartDate) AS SellStartYear, DATENAME(mm, SellStartDate) AS SellStartMonth, LEFT(ProductNumber, 2) as ProductType 
FROM SalesLT.Product
--1.4 �������� ������ ������, ������� �������� ������
SELECT ProductID, UPPER(Name) AS ProductName, ROUND(Weight, 0) AS ApproxWeight, YEAR(SellStartDate) AS SellStartYear, DATENAME(mm, SellStartDate) AS SellStartMonth, LEFT(ProductNumber, 2) as ProductType
FROM SalesLT.Product WHERE ISNUMERIC(Size) = 1

--2.1 �������� ��������, ��������������� �� ������ ������
SELECT C.CompanyName, SOH.TotalDue AS Revenue, RANK() OVER(ORDER BY SOH.TotalDue DESC) AS RankbyRevenue
FROM SalesLT.Customer AS C JOIN SalesLT.SalesOrderHeader AS SOH ON C.CustomerID = SOH.CustomerID

--3.1 �������� ����� ����� ������ �� ������
SELECT P.Name, SUM(SOD.LineTotal) AS TotalRevenue 
FROM SalesLT.Product AS P JOIN SalesLT.SalesOrderDetail AS SOD ON P.ProductID = SOD.ProductID GROUP BY Name ORDER BY TotalRevenue DESC
--3.2 ������������ ������ ������ �������, ������� � ���� ������ �� ������, ��������� ������� ��������� $1000
SELECT Pr.Name, SUM(SOD.LineTotal) AS TotalRevenue 
FROM SalesLT.Product AS Pr JOIN SalesLT.SalesOrderDetail AS SOD ON Pr.ProductID = SOD.ProductID WHERE SOD.LineTotal > 1000 GROUP BY Name ORDER BY TotalRevenue DESC
--3.3 ������������ ������ ������ ������� ���, ����� �������� ������ �� �� ���, ����� ����� ������ ������� ����� $20000
SELECT Pr.Name, SUM(SOD.LineTotal) AS TotalRevenue 
FROM SalesLT.Product AS Pr JOIN SalesLT.SalesOrderDetail AS SOD ON Pr.ProductID = SOD.ProductID WHERE SOD.LineTotal > 1000 GROUP BY Name HAVING SUM(SOD.LineTotal) >20000 ORDER BY TotalRevenue DESC
