-- Exploratory Data Analysis --

SELECT *
FROM layoffs_staging2;

-- Selecting MAX value of total_laid_off and percentage_laid_off columns --

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Selecting details of companies having percentage_laid_off = 1 (i.e. 100%), ordering by  highest to lowest funds_raised_millions --
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Grouping SUM(total_laid_off) by comapny and order by SUM(total_laid_off) desc --
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Identifying the date range --
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Grouping SUM(total_laid_off) by industry and order by SUM(total_laid_off) desc --
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Grouping SUM(total_laid_off) by country and order by SUM(total_laid_off) desc --
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Grouping SUM(total_laid_off) by Year --
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Grouping SUM(tota_laid_off) by company stage --
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Grouping SUM(total_laid_off) by date (year and month) and order by date asc --
SELECT SUBSTRING(`date`, 1, 7) AS 'MONTH', SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY 1
ORDER BY 1 ASC;

-- Creating a CTE, to find the rolling_total of total_laid_off by date --
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS 'MONTH', SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY 1
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) 
OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- 
SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE  Ranking <=5;











