-- ===================================================================================================================================================
--                                                                   INSIGHTS
-- ===================================================================================================================================================
# what are the factors contributing to high Revenue 
SELECT `account`,
		SUM(Revenue) 'Total Revenue',
        employees,
        office_location
FROM `account`
GROUP BY `account`, office_location
HAVING SUM(Revenue) >= 4000 
ORDER BY revenue DESC;

# which product have the highest Revenue
SELECT  
    SUM(a.Revenue) AS Total_Revenue,
    p.product
FROM account a
JOIN sales_pipeline s 
	ON a.account = s.account
JOIN product p 
	ON p.product = s.product
GROUP BY p.product;

# which sector have the highest Revenue
SELECT  
    SUM(a.Revenue) AS Total_Revenue,
    sector
FROM account a
GROUP BY sector
ORDER BY Total_Revenue DESC;

#Identify Key Factors Contributing to Successful Deal Closures
SELECT 
    product,
    `account`,
    sales_agent,
    MONTHNAME(close_date_clean) AS close_month,
    COUNT(*) AS total_deals,
    SUM(CASE WHEN Deal_stage = 'Won' THEN 1 ELSE 0 END) AS successful_deals,
    ROUND(SUM(CASE WHEN Deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS success_rate
FROM sales_pipeline
GROUP BY product, `account`, sales_agent, MONTHNAME(close_date_clean) 
ORDER BY success_rate DESC;

# Regional office with the most closed deal
SELECT 		
	COUNT(sp.deal_stage) closed_deal,
    sa.regional_office
FROM sales_pipeline sp
JOIN sales_agent sa
	ON sp.sales_agent = sa.sales_agent
WHERE deal_stage = 'won'
GROUP BY sa.regional_office;

# office Location with the most closed deal
SELECT 		
	COUNT(sp.deal_stage) closed_deal,
    a.office_location
FROM sales_pipeline sp
JOIN `account` a
	ON sp.`account` = a.`account`
WHERE deal_stage = 'won'
GROUP BY a.office_location
ORDER BY closed_deal DESC;

# Determine the relationship between account characteristics (sector, revenue, size) and deal success rate.
SELECT
	sector, 
	year_established, 
	revenue, 
	employees
FROM `account` a
JOIN sales_pipeline sp
WHERE deal_stage = 'won'
GROUP BY sector, year_established, revenue, employees
ORDER BY revenue desc, year_established;

# which regional office made the most deal and what product and sector and month did it occur and how much revenue was incured
SELECT
	a.sector,
	a.revenue, 
	p.Product,
	MONTHNAME(sp.Engage_date_clean),
	MONTHNAME(sp.close_date_clean),
	sa.regional_office,
    ROW_NUMBER() OVER(PARTITION BY a.revenue ORDER BY a.sector) AS REvv
FROM `account` a
JOIN sales_pipeline sp
	ON a.account = sp.account
JOIN product p
	ON p.product = sp.product
JOIN sales_agent sa
	ON sa.sales_agent = sp.sales_agent
WHERE deal_stage = 'won'
GROUP BY  a.sector, a.revenue, p.Product, sp.Engage_date_clean, sp.close_date_clean, sa.regional_office;


# Evaluate Performance of Sales Agents and Regional Offices
SELECT 
    sa.sales_agent,
    sa.regional_office,
    COUNT(*) AS total_opportunities,
    SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_opportunities,
    ROUND(SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS success_rate,
    SUM(sp.close_value_clean) AS total_revenue,
    ROW_NUMBER() OVER(ORDER BY SUM(sp.close_value_clean) DESC) AS `Rank`
FROM sales_agent sa
JOIN sales_pipeline sp
	ON sa.sales_agent = sp.sales_agent
GROUP BY sa.sales_agent, sa.regional_office;

# Most profitable and least product 
SELECT 
    p.product,
    COUNT(*) AS deals,
    SUM(sp.close_value_clean) AS total_revenue,
    AVG(p.sales_price) AS avg_sales_price,
    AVG(sp.close_value_clean) AS avg_deal_value
FROM sales_pipeline sp
JOIN product p 
	ON sp.product = p.product
WHERE sp.deal_stage = 'Won'
GROUP BY p.product
ORDER BY total_revenue DESC;

# Determine Relationship Between Account Characteristics and Deal Success
SELECT 
    a.sector,
    CASE 
        WHEN a.revenue < 2000 THEN 'Low'
        WHEN a.revenue BETWEEN 2100 AND 4900 THEN 'Medium'
        ELSE 'High'
    END AS revenue_segment,
    CASE 
        WHEN a.employees < 50 THEN 'Small'
        WHEN a.employees BETWEEN 50 AND 250 THEN 'Medium'
        ELSE 'Large'
    END AS size_segment,
    COUNT(*) AS total_deals,
    SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) AS successful_deals,
    ROUND(SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS success_rate
FROM sales_pipeline sp
JOIN `account` a 
	ON a.`account` = sp.`account`
GROUP BY a.sector, revenue_segment, size_segment
ORDER BY success_rate DESC;
