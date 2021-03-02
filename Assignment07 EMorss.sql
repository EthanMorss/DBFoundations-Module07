--*************************************************************************--
-- Title: Assignment07
-- Author: Ethan Morss
-- Desc: This file demonstrates how to use Functions
-- Change Log: When,Who,What
-- 2021-03-01, Ethan Morss, Finished 8 plugged in Year(Cast(v1.InventoryDate as Date)), Figured out Probelm 5 - Thanks class for the notes! 
-- 2021-02-28, Ethan Morss, worked on 5 and 8 
-- 2021-02-27, Ethan Morss, Worked on 5 and 8
-- 2021-02-26, Ethan Morss, Fixed and finsihed 3,4, worked on 5, finished 6 and 7
-- 2021-02-25, Ethan Morss, Worked on 3,4,5
-- 2021-02-24, Ethan Morss, Worked on 1,2,
-- 2022-02-24, Ethan Morss, Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment07DB_EMorss')
	 Begin 
	  Alter Database [Assignment07DB_EMorss] set Single_user With Rollback Immediate;
	  Drop Database Assignment07DB_EMorss;
	 End
	Create Database Assignment07DB_EMorss;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment07DB_EMorss;

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
Select * From vProducts;
go
Select * From vEmployees;
go
Select * From vInventories;
go

/********************************* Questions and Answers *********************************/
--'NOTES------------------------------------------------------------------------------------ 
-- 1) You must use the BASIC views for each table.
--  2) Remember that Inventory Counts are Randomly Generated. So, your counts may not match mine
-- 3) To make sure the Dates are sorted correctly, you can use Functions in the Order By clause!
------------------------------------------------------------------------------------------'
-- Question 1 (5% of pts): What built-in SQL Server function can you use to show a list 
-- of Product names, and the price of each product, with the price formatted as US dollars?
-- Order the result by the product!
 

-- <Put Your Code Here> --

-- Format is the function to use
Select ProductName,
	Format(UnitPrice, 'C', 'en-US')	AS UnitPrice
From vProducts
Order By ProductName;
Go


-- Question 2 (10% of pts): What built-in SQL Server function can you use to show a list 
-- of Category and Product names, and the price of each product, 
-- with the price formatted as US dollars?
-- Order the result by the Category and Product!

-- <Put Your Code Here> --

-- Again Format
Select CategoryName, ProductName,
	Format(UnitPrice, 'C', 'en-US')	AS UnitPrice -- Again Format
From vCategories as vC inner join vProducts as vP
on vC.CategoryID = vP.CategoryID
Order By CategoryName, ProductName;
go

-- Question 3 (10% of pts): What built-in SQL Server function can you use to show a list 
-- of Product names, each Inventory Date, and the Inventory Count,
-- with the date formatted like "January, 2017?" 
-- Order the results by the Product, Date, and Count!

-- <Put Your Code Here> --

Select ProductName, [InventoryDate] = DateName(Month, InventoryDate) +', ' + DateName(Year, InventoryDate), Count as InventoryCount
From vProducts as vP inner join vInventories as vI
on vP.ProductID = vI.ProductID
Order By ProductName, Month(InventoryDate), InventoryCount
Go



-- Question 4 (10% of pts): How can you CREATE A VIEW called vProductInventories 
-- That shows a list of Product names, each Inventory Date, and the Inventory Count, 
-- with the date FORMATTED like January, 2017? Order the results by the Product, Date,
-- and Count!

-- <Put Your Code Here> --


Create
View vProductInventories
As
Select Top 10000 ProductName, [InventoryDate] = DateName(Month, InventoryDate) +', ' + DateName(Year, InventoryDate), Count as InventoryCount
From vProducts as vP inner join vInventories as vI
on vP.ProductID = vI.ProductID
Order By ProductName, Month(InventoryDate), InventoryCount;
Go



-- Check that it works: Select * From vProductInventories;


-- Question 5 (10% of pts): How can you CREATE A VIEW called vCategoryInventories 
-- that shows a list of Category names, Inventory Dates, 
-- and a TOTAL Inventory Count BY CATEGORY, with the date FORMATTED like January, 2017?

-- <Put Your Code Here> --

Create
View vCategoryInventories
As
Select Top 100000 CategoryName, [InventoryDate] = DateName(Month, InventoryDate) +', ' + DateName(Year, InventoryDate), [InventoryCountByCategory] = sum(count) 
From vCategories as vC inner Join vProducts as vP
on vC.CategoryID = vP.CategoryID
inner join vInventories as vI
on vI.ProductID = vP.ProductID
Group By CategoryName, InventoryDate
Order By CategoryName, Month(InventoryDate);
Go

-- Some Old Ideas I tried when I thought I needed a partition and a CTE
-- Over(Partition By vC.CategoryName, InventoryDate)
-- ROW_NUMBER() OVER(Partition By vC.CategoryName, vI.InventoryDate ORDER BY Month(InventoryDate)) AS rownum

-- Note to self on making my partition to make rownumbers
-- ROW_NUMBER() OVER(Partition By CategoryName, InventoryDate ORDER BY Month(InventoryDate)) AS rownum

--Old Idea that did not work
--With CTE AS
-- (Select C.CategoryName, I.InventoryDate, I.Count, ROW_NUMBER() OVER(Partition By C.CategoryName, I.InventoryDate ORDER BY Month(I.InventoryDate)) 
-- From Categories as C inner Join Products as P
-- on C.CategoryID = P.CategoryID
-- inner join Inventories as I
-- on P.ProductID = I.ProductID)
-- Go




-- First Draft to get a feel for partitions -- Will revisit do I need distinct?

-- Select Distinct CategoryName, DateName(Month, InventoryDate) +', ' + DateName(Year, InventoryDate) AS InventoryDate, sum(count) Over(Partition By vC.CategoryName, InventoryDate Order By Month(InventoryDate)) AS InventoryCountByCateory
-- From vCategories as vC inner Join vProducts as vP
-- on vC.CategoryID = vP.CategoryID
-- inner join vInventories as vI
-- on vI.ProductID = vP.ProductID
-- Group By CategoryName, Month(InventoryDate), InventoryDate, Count
-- Order By CategoryName, InventoryDate, InventoryDate, Count;
-- Go






-- Check that it works: Select * From vCategoryInventories;





-- Question 6 (10% of pts): How can you CREATE ANOTHER VIEW called 
-- vProductInventoriesWithPreviouMonthCounts to show 
-- a list of Product names, Inventory Dates, Inventory Count, AND the Previous Month
-- Count? Use a functions to set any null counts or 1996 counts to zero. Order the
-- results by the Product, Date, and Count. This new view must use your
-- vProductInventories view!

-- <Put Your Code Here> --
-- Notes From to work from IIF(Month(InventoryDate) = 01, 0, Lag(Sum(Quantity)) Over (Order By ProductName,Year(OrderDate)))

-- Early Draft to understand lag partition 
-- Select ProductName, InventoryDate, Count, [PreviousMonthCount] = Lag(sum(Count), 1, 0) Over(Order By ProductName)
-- From vProducts as vP inner join vInventories as vI
-- on vP.ProductID = vI.ProductID
-- Group By ProductName, InventoryDate, Count;
-- Go


Create
View vProductInventoriesWithPreviousMonthCounts
As
Select Top 1000000 ProductName, [InventoryDate] = DateName(Month, InventoryDate) +', ' + DateName(Year, InventoryDate), InventoryCount, [PreviousMonthCount] = IIF(month(InventoryDate) = 01, 0, Lag(sum(InventoryCount), 1, 0) Over(Order By ProductName))
From vProductInventories
Group By ProductName, Month(InventoryDate), InventoryDate, InventoryCount
Order By ProductName, Month(InventoryDate), InventoryDate;
Go



-- Question 7 (20% of pts): How can you CREATE one more VIEW 
-- called vProductInventoriesWithPreviousMonthCountsWithKPIs
-- to show a list of Product names, Inventory Dates, Inventory Count, the Previous Month 
-- Count and a KPI that displays an increased count as 1, 
-- the same count as 0, and a decreased count as -1? Order the results by the 
-- Product, Date, and Count!

-- <Put Your Code Here> --


Create
View vProductInventoriesWithPreviousMonthCountsWithKPIs
As
Select Top 100000 ProductName, [InventoryDate] = DateName(Month, InventoryDate) +', ' + DateName(Year, InventoryDate), InventoryCount, [PreviousMonthCount] = IIF(month(InventoryDate) = 01, 0, Lag(sum(InventoryCount), 1, 0) Over(Order By ProductName)), [QtyChangeKPI] = Case 
   When InventoryCount > PreviousMonthCount Then 1
   When InventoryCount = PreviousMonthCount Then 0
   When InventoryCount < PreviousMonthCount Then -1
   End
From vProductInventoriesWithPreviousMonthCounts
Group By ProductName, Month(InventoryDate), InventoryDate, InventoryCount, PreviousMonthCount
Order By ProductName, Month(InventoryDate), InventoryDate, InventoryCount;
Go

-- Important: This new view must use your vProductInventoriesWithPreviousMonthCounts view!
-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;


-- Question 8 (25% of pts): How can you CREATE a User Defined Function (UDF) 
-- called fProductInventoriesWithPreviousMonthCountsWithKPIs
-- to show a list of Product names, Inventory Dates, Inventory Count, the Previous Month
-- Count and a KPI that displays an increased count as 1, the same count as 0, and a
-- decreased count as -1 AND the result can show only KPIs with a value of either 1, 0,
-- or -1? This new function must use you
-- ProductInventoriesWithPreviousMonthCountsWithKPIs view!
-- Include an Order By clause in the function using this code: 
-- Year(Cast(v1.InventoryDate as Date))
-- and note what effect it has on the results.


-- <Put Your Code Here> --


Create Function fProductInventoriesWithPreviousMonthCountsWithKPIs(@QtyChangeKPI Int)
	Returns Table
	As
	Return(
	Select Top 100000 ProductName, InventoryDate, InventoryCount, PreviousMonthCount, QtyChangeKPI
	From vProductInventoriesWithPreviousMonthCountsWithKPIs
	Where QtyChangeKPI = @QtyChangeKPI
	Group By ProductName, InventoryDate, InventoryCount, PreviousMonthCount, QtyChangeKPI
	Order By ProductName, Month(InventoryDate), InventoryCount, PreviousMonthCount, QtyChangeKPI);
Go




-- Tried it with Year(Cast(v1.InventoryDate as Date)) in the group by
-- It had made no difference so I'm not sure if I did it correctly

-- Create Function fProductInventoriesWithPreviousMonthCountsWithKPIs(@QtyChangeKPI Int)
--	Returns Table
--	As
--	Return(
--	Select Top 100000 ProductName, v1.InventoryDate, InventoryCount, PreviousMonthCount, QtyChangeKPI
--	From vProductInventoriesWithPreviousMonthCountsWithKPIs as v1
--	Where QtyChangeKPI = @QtyChangeKPI
--	Group By ProductName, InventoryDate, InventoryCount, PreviousMonthCount, QtyChangeKPI
--	Order By ProductName, Year(Cast(v1.InventoryDate as Date)), InventoryCount, PreviousMonthCount, QtyChangeKPI);
-- Go

-- I tried this 


/* Check that it works:
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(1);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(0);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(-1);
*/

-- Problem 4
Select * From vProductInventories;
-- Problem 5
Select * From vCategoryInventories
-- Problem 6
Select * From vProductInventoriesWithPreviousMonthCounts;
-- Problem 7
Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;
-- Problem 8
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(1);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(0);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(-1);
go


/***************************************************************************************/