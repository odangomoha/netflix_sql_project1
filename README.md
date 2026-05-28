# Netflix Movies and TV Shows Analysis Using SQL
![Netflix Logo](https://github.com/odangomoha/netflix_sql_project1/blob/main/netflix-logo.jpg)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objective
- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset
The data for this project is sourced from the Kaggle dataset:
- Dataset Link: [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema
```sql
  DROP TABLE IF EXISTS netflix;
  CREATE TABLE netflix (
	show_id VARCHAR(6),	
	type VARCHAR(10),	
	title VARCHAR(150),	
	director VARCHAR(210),	
	casts VARCHAR(1000),	
	country VARCHAR(150), 	
	date_added VARCHAR(50),	
	release_year INT,	
	rating VARCHAR(10),	
	duration VARCHAR(15),	
	listed_in VARCHAR(100),	
	description VARCHAR(250)
);
```
## Business Problems and Solutions
1. Count the Number of Movies vs TV Shows
   - Objective: To determine the distribution of content types on Netflix.
   ```sql
	SELECT 
	    type,
	    COUNT(*)
	FROM netflix
	GROUP BY 1;
   ```
2. Find the Most Common Rating for Movies and TV Shows
   - Objective: To identify the most frequently occurring rating for each type of content
```sql
  SELECT
		type,
		rating
	FROM
	(
	SELECT
		type,
		rating,
		COUNT(*),
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	FROM netflix
	GROUP BY 1,2
	)
	WHERE ranking = 1;
```
3. List All Movies Released in a Specific Year (e.g., 2020)
   - Objective: To retrieve all movies released in a specific year.
```sql
	SELECT * 
	FROM netflix
	WHERE release_year = 2020;

```
4. Find the Top 5 Countries with the Most Content on Netflix
   -  To identify the top 5 countries with the highest number of content items.
```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

```

