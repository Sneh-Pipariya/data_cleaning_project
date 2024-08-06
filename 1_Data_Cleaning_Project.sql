-- Data Cleaning Project

-- Steps to achieve data cleaning of file
-- 1) Remove duplicates
-- 2) Standardized the data
-- 3) Null values or blank values
-- 4) Remove any columns

-- ********************    START PROJECT    ********************

-- 1) Create table
CREATE TABLE layoffs_staging LIKE layoffs;

-- 2) Copy the row data records into the staging table
INSERT layoffs_staging
SELECT *
FROM layoffs;


-- 3) Remove duplicates
-- 1st way of writing
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off,`date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;

-- using CTE
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, 
total_laid_off,`date`, stage, country, 
funds_raised_millions
) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;

-- 4) Standardizing data -- finding issues and fixing it
UPDATE layoffs_staging
SET company = TRIM(company);


UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- change date column from text format to date format
UPDATE layoffs_staging
SET `date` = str_to_date(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging
MODIFY COLUMN `date` DATE;

-- 5) Working with NULL and BLANK values
SELECT * 
FROM layoffs_staging 
WHERE company='Airbnb';

UPDATE layoffs_staging
SET industry = NULL
WHERE industry = '';

-- remove records which have null values in columns total_laid_off and percentage_laid_off
DELETE
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT * FROM layoffs;
SELECT * FROM layoffs_staging; 
