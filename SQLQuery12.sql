SELECT * FROM SalesLT.Product 
--1.1 �������� ��� ��� ��������� ���� ��������� �������� � ������� �������
DECLARE @COLUMN AS NVARCHAR(20) = 'Product'
DECLARE @SHEMA AS NVARCHAR(20) = 'SalesLT'
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS		--��������� �����������
WHERE (DATA_TYPE = 'char' OR DATA_TYPE ='nchar' OR DATA_TYPE ='varchar' OR DATA_TYPE ='nvarchar' 
		OR DATA_TYPE ='text' OR DATA_TYPE = 'ntext') AND TABLE_NAME = @COLUMN AND TABLE_SCHEMA = @SHEMA

--1.2 �������� ���, ��� ������ �������� � ��������� �������� �������
DECLARE @COLUMN as nvarchar(20) = 'Product'
DECLARE @SHEMA as nvarchar(20) = 'SalesLT'
DECLARE @STOLB as nvarchar(2000)
DECLARE @ZAPROS as nvarchar(2000)
DECLARE @STROKA as nvarchar(2000) = 'Bike'
DECLARE cur CURSOR LOCAL FAST_FORWARD
FOR
	SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
	WHERE (DATA_TYPE = 'char' OR DATA_TYPE ='nchar' OR DATA_TYPE ='varchar' OR DATA_TYPE ='nvarchar' 
		OR DATA_TYPE ='text' OR DATA_TYPE = 'ntext') AND TABLE_NAME = @COLUMN AND TABLE_SCHEMA = @SHEMA
OPEN cur		--OPEN ��� ������� ������.
	WHILE (1=1)
		BEGIN
			FETCH cur INTO @STOLB	--FETCH ��������� ������� �� ������� ��� ���������� ���������.
		IF @@fetch_status <> 0 BREAK --(1-��� ������, 2������� ������� 0 - ���������� ��������� �������, 9 - ������ �� ��������� �������� �������.).
			SET @ZAPROS = 'select ['+ @STOLB + '] from ['+@SHEMA+'].['+ @COLUMN+ '] where ['+@STOLB+'] like '+ '''%' + @STROKA+ '%'''
			PRINT 'select '+ @STOLB + ' from '+@SHEMA+'.'+ @COLUMN+ ' where '+@STOLB+' like '+ '%' + @STROKA+ '%'
			EXEC (@ZAPROS)	--������
		END
CLOSE cur	
DEALLOCATE cur	

--2.1 �������� �������� ���������
--DROP PROCEDURE SalesLT.uspFindStringInTable
CREATE PROCEDURE SalesLT.uspFindStringInTable
@schema sysname, @table sysname, @stringToFind nvarchar(2000)
AS
DECLARE @COUNTER int = 0
DECLARE @STOLB as nvarchar(2000)
DECLARE @ZAPROS as nvarchar(2000)
DECLARE cur cursor LOCAL FAST_FORWARD
FOR
	SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
	WHERE (DATA_TYPE = 'char' OR DATA_TYPE ='nchar' OR DATA_TYPE ='varchar' OR DATA_TYPE ='nvarchar'
		OR DATA_TYPE ='text' OR DATA_TYPE = 'ntext') AND TABLE_NAME = @table AND table_schema = @Schema
OPEN cur

	WHILE (1=1)
		BEGIN
			FETCH cur INTO @STOLB
			IF @@fetch_status <> 0 BREAK
			SET @ZAPROS = 'select ['+ @STOLB + '] from ['+@Schema+'].['+ @table+ '] where ['+@STOLB+'] like '+ '''%' + @stringToFind + '%'''
			EXEC (@ZAPROS)
			SET @COUNTER = @COUNTER + @@rowcount 
		END
CLOSE cur
DEALLOCATE cur
RETURN @COUNTER
DECLARE @CounterForIncludings AS int
EXEC @CounterForIncludings = SalesLT.uspFindStringInTablee 'SalesLT', 'Product', 'Bike'
PRINT @CounterForIncludings


--2.2 �������� ������ �� ������ �������� � ��
set noCount on --��������� ����� ���������� �����, �� ������� ������ ���������� 
DECLARE @schema nvarchar(2000)
DECLARE @tablename nvarchar(2000)
DECLARE @search nvarchar(2000) = 'Bike'
DECLARE @rowscount int
DECLARE cur cursor LOCAL FAST_FORWARD
FOR
	SELECT DISTINCT TABLE_SCHEMA, TABLE_NAME from INFORMATION_SCHEMA.COLUMNS
OPEN cur
	WHILE (1=1)
	BEGIN
		FETCH cur into @schema, @tablename
		IF @@fetch_status <> 0 break
		BEGIN TRY
			EXEC @rowscount = SalesLT.uspFindStringInTable @schema, @tablename, @search
		END TRY
		BEGIN CATCH
			PRINT '������ �������';
		PRINT ERROR_MESSAGE();
	END CATCH;
	IF @rowscount <> 0
		PRINT 'IN SCHEMA '+@schema+'.'+@tablename+' ROWS FINDED: '+Cast(@rowscount as nvarchar(2000))
	IF @rowscount = 0
		PRINT 'IN SCHEMA '+@schema+'.'+@tablename+' ROWS WAS NOT FINDED'
	END
CLOSE cur
DEALLOCATE cur
--SELECT * FROM dbo.BuildVersion

