-- ===================================================================================================================================================
--                                                                   Data cleaning
-- ===================================================================================================================================================
-- Check for duplicates
# Account table
SELECT
    `account`, sector, year_established, revenue,
	employees,	office_location, subsidiary_of
FROM `Account`
GROUP BY 
	`account`, sector, year_established, revenue,
	employees,	office_location, subsidiary_of
HAVING COUNT(*) > 1;

# Product table
SELECT
    product,	
	series,
	sales_price 
FROM Product
GROUP BY 
	product,	
	series,
	sales_price
HAVING COUNT(*) > 1;

# Sales agent table
SELECT
    sales_agent,
	manager,
	regional_office
FROM sales_agent
GROUP BY 
	sales_agent,
	manager,
	regional_office
HAVING COUNT(*) > 1;

# Sales agent table
SELECT
    opportunity_id, sales_agent,
	product, `account`,
	deal_stage, engage_date,
	close_date, close_value 
FROM sales_pipeline
GROUP BY 
	opportunity_id, sales_agent,
	product, `account`,
	deal_stage, engage_date,
	close_date, close_value 
HAVING COUNT(*) > 1;


-- Check for null values and blanks
# Account table
SELECT *
FROM `Account`
WHERE `account` IS NULL OR `account` = ' '
	OR sector IS NULL OR sector = ' '
	OR year_established IS NULL OR year_established = ' '
	OR revenue IS NULL OR revenue = ' '
	OR employees IS NULL OR employees = ' '	
	OR office_location IS NULL OR office_location = ' '
	OR subsidiary_of IS NULL OR subsidiary_of = ' ';

# sales table
SELECT *
FROM sales_agent
WHERE sales_agent IS NULL OR sales_agent = ' ' 
	OR manager IS NULL OR manager = ' '
	OR regional_office IS NULL OR regional_office = ' ';

# Product table
SELECT *
FROM Product
WHERE product IS NULL OR product = ' ' 
	OR series IS NULL OR series = ' '
	OR sales_price IS NULL OR sales_price = ' ';

# Sales_pipeline table
SELECT *
FROM Sales_Pipeline 
WHERE opportunity_id IS NULL OR opportunity_id = ' '
	OR sales_agent	IS NULL OR sales_agent	= ' '
	OR product	IS NULL OR product = ' '
	OR `account` IS NULL OR `account` = ' '
	OR deal_stage	IS NULL OR deal_stage = ' '
	OR engage_date	IS NULL OR engage_date = ' '
	OR close_date	IS NULL OR close_date = ' '
	OR close_value IS NULL OR close_value = ' '; 
