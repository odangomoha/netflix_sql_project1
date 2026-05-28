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

5. Identify the longest movie
   -Objective: To find the movie with the longest duration.
```sql
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix);
```

6. Find content added in the last 5 years
   - Objective: Retrieve content added to Netflix in the last 5 years
```sql
SELECT * FROM netflix
WHERE 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

7. Find all the movies/Tv shows by director 'Rajiv Chilaka'
   - Objective: List all content directed by 'Rajiv Chilaka'.
```sql
SELECT * FROM netflix
WHERE 
	director ILIKE '%Rajiv Chilaka%';
```

8. List all TV Shows with more than 5 seasons
   - Objective: Identify TV shows with more than 5 seasons.
```sql
SELECT * FROM netflix
WHERE 
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::numeric > 5;
```

9. Count the number of content items in each genre
    - Objective: Count the number of content items in each genre.
```sql
SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as totol_content
FROM netflix
GROUP BY 1;
```

10. find each year and the average number of contents released by India on Netflix.
	return top 5 year with highest average content released
	- Objective: Calculate and rank years by the average number of content releases by India
```sql
SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*)::numeric as yearly_content,
	ROUND(
	COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country ILIKE '%India%')::numeric * 100
	, 2)
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5;
```

11. List all movies that are documentaries
    - Objective: Retrieve all movies classified as documentaries
```sql
SELECT 
	*
FROM netflix
WHERE
	type = 'Movie'
	AND
	listed_in ILIKE '%Documentaries%';
```

12. Find all contents without a director
    - Objective: List content that does not have a director.
```sql
SELECT * FROM netflix
WHERE director IS NULL;
```

13. Find how many movies actor 'Salman Khan' appeared in the last 10 years
    - Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.
```sql
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

14. find the top 10 actors who have the highest number of movies appearance in the United States.
    - Objective: Identify the top 10 actors with the most appearances in US-produced movies.
```sql
SELECT 	
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
	COUNT(*) as number_of_appearance
FROM netflix
WHERE 
	type = 'Movie'
	AND
	country ILIKE '%United States%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

15. Categorize the contents based on the presence of the keyword 'kill' and 'violence'.
	- Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.
```sql
WITH new_table
AS
(
SELECT 
	*,
	CASE
	WHEN description ILIKE '%kill%' OR
		description ILIKE '%violence%' THEN 'bad'
		ELSE 'Good'
	END category
FROM netflix
)
SELECT 
	category,
	COUNT(*) as totol_content
FROM new_table
GROUP BY 1;
```

## Findings and Conclusion
- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making

## Author
This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
