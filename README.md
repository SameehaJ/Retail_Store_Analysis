# Online Retail Store Analysis using SQL and Power BI

## 📌 Introduction
This report aims to deliver meaningful insights into customer behavior, sales performance, and regional trends using the Online Retail II dataset from UCI. The analysis involves structured data extraction, transformation, and visualization to highlight key patterns and opportunities for business improvement. An interactive Power BI dashboard presents the results in a clear and accessible way, helping stakeholders make informed decisions. Each step of the process — from preparing the data to building the dashboard — is carefully documented to ensure transparency and consistency in the insights provided.

## 🗃️ Dataset Overview
Source: Online Retail II Dataset — UCI Machine Learning Repository (https://archive.ics.uci.edu/dataset/502/online+retail+ii)
This dataset captures e-commerce transactions from 2009 to 2011, including customer purchases, order details, sales values, and geographic information across 43 countries.
Note: While this project uses the Online Retail II dataset from the UCI Machine Learning Repository, it is based on a modified version of the original dataset. As a result, some insights, transformations, or figures may vary from those presented in other publicly available analyses of the dataset.

## 🛠️ Tools Used
SQL Server Management Studio (SSMS) — for data import, cleaning, deduplication, and calculated fields.
Power BI — for data transformation, relationship modeling, and interactive dashboard creation.
Power Query Editor — for advanced column-level cleaning and normalization within Power BI.
Note: Data cleaning for this project was strategically split between SQL and Power BI to demonstrate skill across both tools. In SQL, I focused on table-level cleaning such as handling duplicates, removing nulls, and creating calculated fields to extract key customer and sales insights. In Power BI, I performed column-level transformations, including rounding decimals, trimming text fields, splitting mixed-format columns, and normalizing tables to build a relational model.

## ❓ Business Questions Addressed
This analysis addresses key business questions to support data-driven decision-making:
- What are the key sales trends and patterns over time?
Identifying seasonal spikes, sales consistency, and transaction volumes.
- Which products and regions are top performers?
Highlighting high-revenue items and the most active customer regions.
- What improvements can help increase sales?
Recommending product, pricing, or regional strategies based on insights.
- Where are the opportunities for business growth?
Exploring customer behavior and identifying underserved markets.

## 🧹 Phase 1: Data Cleaning (SQL)
This phase involved preparing the raw dataset for analysis by importing it into SQL Server Management Studio, cleaning inconsistencies, and creating calculated fields for further insights.

### ✔️ Data Import
· A database named OnlineRetail was created in SQL Server.
· The original CSV file was imported using the Import Flat File Wizard in SQL Server Management Studio (SSMS).
· During the import process, a table named Sales was automatically created to store the data.
· After import, column data types were modified as needed, and Null Values were allowed to ensure compatibility for analysis.

### ✔️ Cleaning Steps
Performed in SQL Server using custom scripts:
Handled missing values: First, the number of Null Values were checked.
Next, a cleaned version of the table is created, and non-null data is inserted to preserve the original Sales table.
Removed duplicates: The duplicate data was reviewed before deleting.
Next, the duplicates were removed.
Create calculated fields: Total Sale Amount (quantity * price)
Date Conversion: Converted datetime values to DATE format, assuming only date-level granularity was required based on stakeholder input.

## 📊 Phase 2: SQL Query Development
In this phase, key metrics were extracted to uncover meaningful patterns in sales performance and customer behavior. The analysis focused on regional sales distribution, monthly and quarterly sales trends, top-performing products by revenue, and customer segmentation based on purchasing frequency.
### Key Metrics:
Regional Sales: Total sales by country/region.
Time-Based Trends: Monthly sales trends.
Time-Based Trends: Quarterly sales trends.
Product Performance: Top-selling products based on revenue.
Customer Behavior Analysis: For a scalable approach, a separate customer segment table was created and then joined with the Sales table to classify customer purchase frequency.


## 📈 Phase 3: Power BI Dashboard Creation
In this phase, Power BI was used to transform the cleaned SQL data into an interactive and insightful dashboard. The tool was connected directly to the SQL Server database, enabling real-time access to the latest data. A variety of visual elements were designed to highlight key insights, including bar charts, line charts and tables. Interactive slicers and a map were also added to allow users to explore the data by date and region.
### ✔️ Data Transformation Steps
While working with the Online Retail II dataset, I observed several data quality issues that needed to be addressed before building a reliable dashboard. These included:
Alphanumeric values in the StockCode column that hindered analysis,
Decimal precision inconsistencies in Price and TotalSaleAmount
Leading/trailing spaces in the Description field, and
The need to normalize flat transactional data into dimension tables for better performance and data integrity.

Data Cleaning & Transformation Steps

1. Connected to SQL Server
Used Power BI’s built-in SQL Server connector:
· Entered Server Name and selected the OnlineRetail dataset.
· Loaded data into Power BI for transformation in Power Query Editor.

2. Split StockCode Column
· The StockCode column had alphanumeric values.
· Used Split Column by Character Transition → From Digit to Non-Digit to separate numeric and non-numeric portions.

3. Rounded Numeric Fields
· Rounded the Price and TotalSaleAmount columns to 2 decimal places using the Rounding transformation.

4. Trimmed Description Column
· Removed leading spaces from Descriptions using the Trim option.

5. Data Normalization
· To reduce redundancy, improve relational structure, and optimize performance in Power BI. Normalization makes it easier to manage dimension tables like Stock, Customer, and Country separately.

· Stock Table
  — Duplicated Sales_Cleaned Query→ Kept only StockCode and Description and removed other columns.
  — Added index column StockID: Table.AddIndexColumn(Custom1, “StockID”, 1, 1, Int64.Type)

· Customer Table
  — Duplicated Sales_Cleaned → Retained only Customer_ID and removed other columns.
  — Added index column CustomerID: Table.AddIndexColumn(#”Changed Type3", “CustomerID”, 1, 1, Int64.Type)

· Country Table
  — Duplicated Sales_Cleaned → Kept only Country and removed other columns.
  — Added index column CountryID: Table.AddIndexColumn(#”Removed Duplicates”, “Country_ID”, 1, 1, Int64.Type)

6. Merging Dimension Tables
Used Merge Queries (Left Join) in Power Query:
Merged Sales_Cleaned with:
— Stock_Code on StockCode
— Customer_ID on Customer_ID
— Country on Country
Expanded only the index columns (StockID, CustomerID, Country_ID) after merge.
Removed redundant columns: StockCode, Description, Customer_ID, Country

### ✔️ Final Visualizations
Key Metrics:
Card Visual — Total Sales, Number of Orders, Number of Customers (with slicers by Year)
Charts & Maps:
Line Chart: Revenue Over Time (Year & Month)
Table: Highest Volume Products (Top 10 Products by Quantity Sold)
Bar Chart: Sales Volume & Revenue by Country. The United Kingdom (UK) was intentionally filtered out from this visual, as its sales volume significantly exceeded other countries. Including it caused distortion in the scale, making it difficult to compare values across the remaining countries.
· Map: Geographic Customer Distribution: Used Conditional Formatting for fill colors to represent customer volume by country:
Green for countries with few customers
Yellow for countries with 15 or more customers
Red for countries with the highest customer counts
All dashboard elements — including slicers, cards, table, map and charts were fully interactive, allowing users to filter data dynamically by date, product category, and region to gain deeper insights.

## 📋 Phase 4: Business Insights & Recommendations
This phase compiles key insights and data-driven recommendations from the Power BI dashboard built on the Online Retail II dataset. It focuses on identifying sales trends, top-performing products and regions, strategic opportunities, and actionable steps to drive business growth.
### 🔹 Sales Trends
. 2010 was the highest-performing year, in the range 2009- 2011, generating over £ 13.5 million in total sales.
. On a monthly basis, sales begin to pick up steadily from September onward, peaking in November and December.
. This consistent spike in Q4 (especially November and December) suggests strong seasonal demand, likely linked to the holiday season or end-of-year promotions. Conversely, February and April tend to show the lowest performance in terms of both revenue and quantity, indicating natural off-peak periods.
. The trend is consistent across both revenue and transaction volume, confirming that sales growth is driven by both increased order size and frequency.

### 🔹 Regional & Product Performance
· The United Kingdom dominates sales, contributing over £2.2 million. As a result, it was excluded from some visuals for clarity.
· Other high-performing regions include Netherlands, Ireland, and Germany. France, Australia, and Austria follow with moderate revenue.
· The Geographic Customer Distribution map confirms customer concentration in Europe and North America, with limited penetration in Asia, Africa, and South America.
· Top Products by Quantity — The JUMBO BAG series leads, each variant selling over 156K units, followed by CREAM HANGING HEART T-LIGHT HOLDER and RETROSPOT CAKE CASES which also show strong sales volumes.
· Top Products by Revenue — JUMBO BAG variants top the list, followed by REGENCY CAKESTAND 3 TIER, HANGING HEART T-LIGHT HOLDERS, and Polkadot Cutlery Sets.

### 🔹 Recommendations
· Promote Best-Sellers — Focus marketing and inventory on top products like JUMBO BAGS, T-LIGHT HOLDERS, and CAKE CASES, which drive both volume and revenue.
· Phase Out Low Performers — Remove or reassess underperforming items like FEATHER HEART LIGHTS and FRIDGE MAGNETS.
· Expand in High-Potential Regions — Invest in marketing and logistics in Ireland, Netherlands, and Germany, which show strong sales beyond the UK.
· Boost Off-Season Sales — Launch targeted promotions in low-revenue months like February and April to balance seasonal dips.
· Clean Product Data — Improve product labeling and filter out internal adjustments to enhance reporting and decision-making.
· Timing Campaigns — Align marketing efforts with the revenue peaks identified in the line chart, especially during Q4 when demand rises sharply.
