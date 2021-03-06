--*************************************************************************--
-- Title: Assignment07
-- Author: Danielle Shubat
-- Desc: This file demonstrates how to use Functions
-- Change Log: When,Who,What
-- 2021-02-24,Danielle Shubat,Created File, ran provided code
-- 2021-02-28,Danielle Shubat, questions 1-5
-- 2021-03-01,Danielle Shubat, questions 6-8
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment07DB_DanielleShubat')
	 Begin 
	  Alter Database [Assignment07DB_DanielleShubat] set Single_user With Rollback Immediate;
	  Drop Database Assignment07DB_DanielleShubat;
	 End
	Create Database Assignment07DB_DanielleShubat;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment07DB_DanielleShubat;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL
,[ProductID] [int] NOT NULL
,[ReorderLevel] int NOT NULL -- New Column 
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, ReorderLevel, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, ReorderLevel, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, ReorderLevel, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, ReorderLevel, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Adding Views (Module 06) -- 
Create View vCategories With SchemaBinding
 AS
  Select CategoryID, CategoryName From dbo.Categories;
go
Create View vProducts With SchemaBinding
 AS
  Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go
Create View vEmployees With SchemaBinding
 AS
  Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go
Create View vInventories With SchemaBinding 
 AS
  Select InventoryID, InventoryDate, EmployeeID, ProductID, ReorderLevel, [Count] From dbo.Inventories;
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From vCategories;
go
Select * From vInventories;
go
Select * From vProducts;
go
Select * From vEmployees;
go

/********************************* Questions and Answers *********************************
NOTES------------------------------------------------------------------------------------ 
 1) You must use the BASIC views for each table.
 2) Remember that Inventory Counts are Randomly Generated. So, your counts may not match mine
 3) To make sure the Dates are sorted correctly, you can use Functions in the Order By clause!
------------------------------------------------------------------------------------------*/
-- Question 1 (5% of pts): What built-in SQL Server function can you use to show a list 
-- of Product names, and the price of each product, with the price formatted as US dollars?
-- Order the result by the product!

-- <Put Your Code Here> --
SELECT ProductName
	,FORMAT(UnitPrice, 'c', 'en-us') AS [FormattedUnitPrice]
FROM vProducts
ORDER BY ProductID;
GO

-- Question 2 (10% of pts): What built-in SQL Server function can you use to show a list 
-- of Category and Product names, and the price of each product, 
-- with the price formatted as US dollars?
-- Order the result by the Category and Product!

-- <Put Your Code Here> --
SELECT c.CategoryName
	,p.ProductName
	,FORMAT(p.UnitPrice, 'c', 'en-us') AS [FormattedUnitPrice]
FROM vCategories AS c
	INNER JOIN vProducts AS p --ambiguous use case; used inner join
ON c.categoryID = p.CategoryID
ORDER BY 1,2,3;
GO

-- Question 3 (10% of pts): What built-in SQL Server function can you use to show a list 
-- of Product names, each Inventory Date, and the Inventory Count,
-- with the date formatted like "January, 2017?" 
-- Order the results by the Product, Date, and Count!
/*year, yyyy, yy = Year
quarter, qq, q = Quarter
month, mm, m = month
dayofyear = Day of the year
day, dy, y = Day
week, ww, wk = Week
weekday, dw, w = Weekday
hour, hh = hour
minute, mi, n = Minute
second, ss, s = Second
millisecond, ms = Millisecond*/
-- <Put Your Code Here> --
SELECT p.ProductName
	,DATENAME(m,i.InventoryDate)+', '+ DATENAME(yy,i.InventoryDate) AS [InventoryDate]
	,[Count] AS [InventoryCount]
FROM vProducts AS p
	INNER JOIN vInventories AS i
	ON p.ProductID = i.ProductID
ORDER BY 1,CAST([InventoryDate] AS DATE),3
go

-- Question 4 (10% of pts): How can you CREATE A VIEW called vProductInventories 
-- That shows a list of Product names, each Inventory Date, and the Inventory Count, 
-- with the date FORMATTED like January, 2017? Order the results by the Product, Date,
-- and Count!

-- <Put Your Code Here> --
CREATE -- DROP
VIEW vProductInventories
AS
	SELECT TOP 1000000 p.ProductName
		,DATENAME(mm,i.InventoryDate)+', '+ DATENAME(yy,i.InventoryDate) AS [InventoryDate]
		,i.[Count] AS [InventoryCount]
FROM vProducts AS p
	INNER JOIN vInventories AS i
	ON p.ProductID = i.ProductID
ORDER BY 1,MONTH([InventoryDate]),3;
go

-- Check that it works: Select * From vProductInventories;


-- Question 5 (10% of pts): How can you CREATE A VIEW called vCategoryInventories 
-- that shows a list of Category names, Inventory Dates, 
-- and a TOTAL Inventory Count BY CATEGORY, with the date FORMATTED like January, 2017?

-- <Put Your Code Here> --
CREATE -- drop
VIEW vCategoryInventories
AS
	SELECT TOP 100000 c.CategoryName
	,DATENAME(mm,i.InventoryDate)+', '+ DATENAME(yy,i.InventoryDate) AS [InventoryDate]
	,SUM(i.[Count]) AS [InventoryCountByCategory]
FROM vCategories AS c
	INNER JOIN vProducts AS p
	ON c.CategoryID = p.CategoryID
	INNER JOIN vInventories AS i
	ON p.ProductID = i.ProductID
GROUP BY c.CategoryName, InventoryDate
ORDER BY CategoryName,MONTH(InventoryDate),InventoryCountByCategory;
go
-- Check that it works: Select * From vCategoryInventories;


-- Question 6 (10% of pts): How can you CREATE ANOTHER VIEW called 
-- vProductInventoriesWithPreviouMonthCounts to show 
-- a list of Product names, Inventory Dates, Inventory Count, AND the Previous Month
-- Count? Use a functions to set any null counts or 1996 counts to zero. Order the
-- results by the Product, Date, and Count. This new view must use your
-- vProductInventories view!

-- <Put Your Code Here> --
CREATE -- drop
VIEW  vProductInventoriesWithPreviousMonthCounts
AS
	SELECT TOP 1000000 ProductName
	,InventoryDate
	,InventoryCount
	,IIF(InventoryDate like ('January%'), 0, IsNull(LAG(InventoryCount) OVER (ORDER BY ProductName, YEAR(InventoryDate)), 0)) AS [PreviousMonthCount]
FROM vProductInventories
ORDER BY 1,DatePart(dayofyear,InventoryDate),3,4;
go

-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCounts;


-- Question 7 (20% of pts): How can you CREATE one more VIEW 
-- called vProductInventoriesWithPreviousMonthCountsWithKPIs
-- to show a list of Product names, Inventory Dates, Inventory Count, the Previous Month 
-- Count and a KPI that displays an increased count as 1, 
-- the same count as 0, and a decreased count as -1? Order the results by the 
-- Product, Date, and Count!

-- <Put Your Code Here> --

CREATE  -- drop
VIEW vProductInventoriesWithPreviousMonthCountsWithKPIs
AS
	SELECT TOP 1000000 ProductName
	,InventoryDate
	,InventoryCount
	,[PreviousMonthCount]
	,IsNull(CASE
		WHEN PreviousMonthCount < InventoryCount THEN 1
		WHEN PreviousMonthCount = InventoryCount THEN 0
		WHEN PreviousMonthCount > InventoryCount THEN -1
		END, 0)
		AS [QtyChangeKPI]
FROM vProductInventoriesWithPreviousMonthCounts
ORDER BY 1,MONTH(InventoryDate),3;
GO

-- Important: This new view must use your vProductInventoriesWithPreviousMonthCounts view!
-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;


-- Question 8 (25% of pts): How can you CREATE a User Defined Function (UDF) 
-- called fProductInventoriesWithPreviousMonthCountsWithKPIs
-- to show a list of Product names, Inventory Dates, Inventory Count, the Previous Month
-- Count and a KPI that displays an increased count as 1, the same count as 0, and a
-- decreased count as -1 AND the result can show only KPIs with a value of either 1, 0,
-- or -1? This new function must use your
-- vProductInventoriesWithPreviousMonthCountsWithKPIs view!
-- Include an Order By clause in the function using this code: 
-- Year(Cast(v1.InventoryDate as Date))
-- and note what effect it has on the results.

-- <Put Your Code Here> --

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE --drop 
FUNCTION dbo.fProductInventoriesWithPreviousMonthCountsWithKPIs (@QtyChangeKPI INT)
RETURNS TABLE
	AS
		RETURN
			SELECT Top 100000 ProductName
			,InventoryDate
			,InventoryCount
			,[PreviousMonthCount]
			,[QtyChangeKPI]
		FROM vProductInventoriesWithPreviousMonthCountsWithKPIs
		WHERE [QtyChangeKPI] = @QtyChangeKPI
		ORDER BY 1,Month(InventoryDate),2,3,4,5;
go


--Check that it works:


-- View all views and functions created
Select * From vProductInventories;
go
Select * From vCategoryInventories;
go
Select * From vProductInventoriesWithPreviousMonthCounts;
go
Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;
go
Select * From dbo.fProductInventoriesWithPreviousMonthCountsWithKPIs(1);
Select * From dbo.fProductInventoriesWithPreviousMonthCountsWithKPIs(0);
Select * From dbo.fProductInventoriesWithPreviousMonthCountsWithKPIs(-1);
go
/***************************************************************************************/