Select * from Sales

--Phase 1

--Handle Missing Values
--Checking Null Values
SELECT 
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Missing_CustomerID,
    SUM(CASE WHEN Invoice IS NULL THEN 1 ELSE 0 END) AS Missing_InvoiceNo,
    SUM(CASE WHEN StockCode IS NULL THEN 1 ELSE 0 END) AS Missing_StockCode,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
    SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS Missing_UnitPrice,
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS Missing_Description,
    SUM(CASE WHEN InvoiceDate IS NULL THEN 1 ELSE 0 END) AS Missing_InvoiceDate,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Missing_Country
FROM Sales;
--Remove Missing Values by created a new table
SELECT * INTO Sales_Cleaned FROM Sales
WHERE Customer_ID IS NOT NULL
  AND Invoice IS NOT NULL
  AND StockCode IS NOT NULL
  AND Quantity IS NOT NULL
  AND Price IS NOT NULL
  AND Description IS NOT NULL
  AND InvoiceDate IS NOT NULL
  AND Country IS NOT NULL

SELECT * FROM Sales_Cleaned

--Removing Duplicates
--Review duplicate data before deleting
SELECT [Invoice]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[Price]
      ,[Customer_ID]
      ,[Country]
	  , COUNT(*) AS DUPLICATES
	  FROM Sales_Cleaned
	  GROUP BY [Invoice]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[Price]
      ,[Customer_ID]
      ,[Country]
	  HAVING COUNT(*) >1

--Removing Duplicate Data
WITH CTE_Duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Invoice, StockCode, Description, Quantity, Price, InvoiceDate, Customer_ID, Country
               ORDER BY (SELECT NULL)
           ) AS rn
    FROM Sales_Cleaned
)
DELETE FROM CTE_Duplicates
WHERE rn > 1;


--Create Calculated Columns:Total Sale Amount (quantity * unit_price)
Alter Table Sales_Cleaned
Add TotalSaleAmount as (Price*Quantity)

--Date Conversions (Convert datetime to date format)
ALTER TABLE Sales_Cleaned
ALTER COLUMN InvoiceDate DATE

--Phase 2

--Regional Sales: Total sales by country/region
SELECT Country, SUM(TotalSaleAmount) AS TotalSales
FROM Sales_Cleaned
GROUP BY Country

--Monthly Sales
SELECT 
    YEAR(InvoiceDate) AS SalesYear,
    MONTH(InvoiceDate) AS SalesMonth,
    SUM(Quantity * Price) AS MonthlySales
FROM Sales_Cleaned
GROUP BY 
    YEAR(InvoiceDate),
    MONTH(InvoiceDate)
ORDER BY 
    SalesYear desc, 
    SalesMonth desc

--Quarterly Sales
SELECT 
    YEAR(InvoiceDate) AS SalesYear,
    DATEPART(QUARTER, InvoiceDate) AS SalesQuarter,
    SUM(Quantity * Price) AS QuarterlySales
FROM Sales_Cleaned
GROUP BY 
    YEAR(InvoiceDate),
    DATEPART(QUARTER, InvoiceDate)
ORDER BY 
    SalesYear desc, 
    SalesQuarter desc

--Identify top-selling products based on revenue
SELECT Description,Round(Sum(TotalSaleAmount),0) as Revenue from Sales_Cleaned
Group by Description
Order by Round(Sum(TotalSaleAmount),0) Desc

--Rank top-selling products
SELECT 
    RANK() OVER (ORDER BY SUM(TotalSaleAmount) Desc) AS ProductRank,
    Description,
    ROUND(SUM(TotalSaleAmount), 0) AS Revenue
FROM Sales_Cleaned
GROUP BY Description
ORDER BY ProductRank

--Customer Behavior Analysis to analyze purchase frequency
--Calculate Purchase Frequency in the Sales_Cleaned Table
SELECT 
    Customer_ID,
    COUNT(DISTINCT Invoice) AS PurchaseFrequency
FROM Sales_Cleaned
GROUP BY Customer_ID

--Create the Purchase Frequency Segment Table
CREATE TABLE Frequency_Segments ( Segment NVARCHAR(10),Min_Frequency INT,Max_Frequency INT)
INSERT INTO Frequency_Segments (Segment, Min_Frequency, Max_Frequency)
VALUES ('Low', 1, 10),('Medium', 11, 25),('High', 26, 600)

--Map Sales_Cleaned Table to Purchase Frequency Segment Table using nested query and Join
SELECT cf.Customer_ID,cf.PurchaseFrequency,fs.Segment AS FrequencySegment
FROM (
    SELECT Customer_ID,COUNT(DISTINCT Invoice) AS PurchaseFrequency
    FROM Sales_Cleaned
    GROUP BY Customer_ID
) AS cf
JOIN Frequency_Segments fs
    ON cf.PurchaseFrequency BETWEEN fs.Min_Frequency AND fs.Max_Frequency
ORDER BY cf.PurchaseFrequency DESC;

Select * from Sales_Cleaned
