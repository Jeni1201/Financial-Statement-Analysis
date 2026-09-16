/*=====================================================
    DATABASE SETUP
=====================================================*/

--Create DATABASE FinancialAnalysis;
use FinancialAnalysis;


/*=====================================================
    DATA VALIDATION
=====================================================*/

-- Total Rows loaded
SELECT COUNT(*) FROM Financials;   

-- All Company records loaded
SELECT 
	Company,
	COUNT(*) AS Records
FROM Financials
GROUP BY Company;

-- Year Coverage
SELECT 
	Company,
	MIN(Year) as StartYear,
	MAX(Year) as EndYear
FROM Financials
GROUP BY Company; 

-- Duplicate check
SELECT Company, Year, COUNT(*)
FROM Financials
GROUP BY Company,Year HAVING COUNT(*) > 1;

-- check for accidental zeros/ negative values/ import corruption
SELECT 
	MIN(Revenue) as MinRevenue,
	MAX(Revenue) as MaxRevenue
FROM Financials;

SELECT 
	MIN(Assets) as MinAssets,
	MAX(Assets) as MaxAssets
FROM Financials;


/*=====================================================
    ACCOUNTING VALIDATION
=====================================================*/

SELECT
    Company,
    Year,

    Assets,

    EquityCapital + Reserves +
    Borrowings + OtherLiabilities + ISNULL(Deposits,0)  
    AS TotalLiabilities_And_Equity,
	
	Assets - (
	EquityCapital + Reserves +
    Borrowings + OtherLiabilities + ISNULL(Deposits,0)  
	) as Balance_Variance

FROM Financials;


/*=====================================================
    FINANCIAL ANALYSIS
=====================================================*/

-- Revenue Trend
SELECT Company, Year, Revenue
FROM Financials 
ORDER BY Company, Year;

-- Profit Trend
SELECT Company, Year, NetProfit
FROM Financials;

-- Asset Growth
SELECT Company, Year, Assets
FROM Financials;

-- Cash Flow Components
SELECT Company, Year, CFO, CFI, CFF
FROM Financials
ORDER BY Company, Year;

-- Cash flow Quality
-- Are profits backed by cash generation ?
SELECT 
	Company, Year, CFO, NetProfit,
	(CFO * 1.0)/NetProfit as Cash_to_Profit
FROM Financials
ORDER BY Company, Year;


/*=====================================================
    GROWTH ANALYSIS
=====================================================*/

-- Revenue Growth %  (YoY Growth)
SELECT 
	Company, Year, 
	Revenue,
	LAG(Revenue) OVER( PARTITION BY Company ORDER BY Year) as PreviousRevenue,
	ROUND(
		(
		 Revenue 
		- LAG(Revenue) OVER( PARTITION BY Company ORDER BY Year)
		) *100.0
		/ LAG(Revenue) OVER( PARTITION BY Company ORDER BY Year)
	,2)
	 as RevenueGrowthPercent
FROM Financials
ORDER BY Company, Year;


-- Profit Growth %   (Profit Trend analysis)
SELECT 
	Company, Year, 
	NetProfit,
	LAG(NetProfit) OVER (PARTITION BY Company ORDER BY Year) as PreviousNetProfit,
	ROUND(
		(
		 NetProfit 
		- LAG(NetProfit) OVER( PARTITION BY Company ORDER BY Year)
		) *100.0
		/ LAG(NetProfit) OVER( PARTITION BY Company ORDER BY Year)
	,2)
	 as ProfitGrowthPercent
FROM Financials
ORDER BY Company, Year;

	
/*=====================================================
    COMPANY RANKING
=====================================================*/

-- Rank by Revenue / NetProfit / Assets

-- Company Ranking in a particular year
SELECT 
	Company, 
	Revenue,
	RANK() OVER (ORDER BY Revenue DESC) as RevenueRank
FROM Financials
WHERE Year = 2026;

-- Overall Company Ranking over 5 years aggreate metrics
SELECT 
	Company,
	SUM(Revenue) as TotalRevenue
FROM Financials
GROUP BY Company
ORDER BY TotalRevenue desc;

/*=====================================================
			OTHER METRICS
=====================================================*/
-- Avg Profit 
SELECT 
	Company, 
	Avg(NetProfit) as AvgProfit
FROM Financials
GROUP BY Company
ORDER BY AvgProfit DESC;

-- Net Profit Margin %
SELECT 
	Company,
	Year,
	NetProfit,
	Revenue,
	(NetProfit *100.0 / Revenue) as NetProfitMargin
FROM Financials;

-- Return on Equity  (ROE)
SELECT 
	Company,
	Year,
	Netprofit,
	(EquityCapital + Reserves) as Equity,
	(NetProfit *100.0) / (EquityCapital + Reserves)  as ROE
FROM Financials ;

-- Return on Assets  (ROA)
SELECT 
	Company,
	Year,
	Netprofit,
	Assets,
	ROUND(  
		(NetProfit *100.0) / Assets 
		, 2)  as ROA
FROM Financials ;

-- Debt to Equity 
SELECT
	Company, 
	Year,
	Borrowings as Debt,
	EquityCapital + Reserves as Equity, 
	ROUND (
		(Borrowings *1.0) / (EquityCapital + Reserves)
		,2) as Debt_to_Equity
FROM Financials;
