-- ===================================================================================================================================================
/* This project is a B2B sales opportunities from a CRM database that sells computer hardware, including information on 
accounts, products, sales teams, and sales opportunities.*/
-- ===================================================================================================================================================

-- ===================================================================================================================================================
--                                                                   Database and Table Creation
-- ===================================================================================================================================================
CREATE DATABASE CRM;
USE CRM;

# check the tables # Account table
CREATE TABLE `Account` (
	account VARCHAR(50) PRIMARY KEY,	
	sector VARCHAR(50) NULL,	
	year_established YEAR NULL,	
	revenue	INT NULL,
	employees INT NULL,	
	office_location VARCHAR(50) NULL,
	subsidiary_of VARCHAR(50) NULL
);

# Sales_Agent table
CREATE TABLE Sales_Agent (
	sales_agent	VARCHAR(50) PRIMARY KEY,
	manager	VARCHAR(50) NULL,
	regional_office VARCHAR(50) NULL
);

# Product table
CREATE TABLE Product (
	product VARCHAR(50) PRIMARY KEY,	
	series VARCHAR(50) NULL,
	sales_price INT
);

# Sales_pipeline table
CREATE TABLE Sales_Pipeline (
	opportunity_id VARCHAR(50) PRIMARY KEY ,
	sales_agent	VARCHAR(50) NULL,
	product	VARCHAR(50) NULL,
	`account` VARCHAR(50) NULL,
	deal_stage	VARCHAR(50) NULL,
	engage_date	VARCHAR(50) NULL,
	close_date	VARCHAR(50) NULL,
	close_value VARCHAR(50) NULL 
);

-- loading the production information table
LOAD DATA INFILE 'C:/ProgramData/MySQL/sales_pipeline.csv'
INTO TABLE sales_pipeline
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@opportunity_id, @sales_agent, @product, @`account`, @deal_stage, @engage_date, @close_date, @close_value)
SET opportunity_id = IF(@opportunity_id = '' OR @opportunity_id IS NULL, 0, @opportunity_id),  
    sales_agent = IF(@sales_agent = '' OR @sales_agent IS NULL, 'No Key', @sales_agent),  
    product = IF(@product = '' OR @product IS NULL, 'Unknown Product Name', @product),  
    `account` = IF(@`account` = '' OR @`account` IS NULL, 0.00, @`account`),  
    deal_stage = IF(@deal_stage = '' OR @deal_stage IS NULL, 'Unknown', @deal_stage),  
    engage_date = IF(@engage_date = '' OR @engage_date IS NULL, 'Not Specified', @engage_date), 
    close_date = IF(@close_date = '' OR @close_date IS NULL, 'Not Specified', @close_date),  
    close_value = IF(@close_value = '' OR @close_value IS NULL, 'Unknown Date', @close_value);
