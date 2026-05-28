--netflix project
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

SELECT * FROM netflix;

--15 Business problems

--1. Count the number of Movies vs TV Shows
SELECT
	type,
	COUNT(*) as total_content
FROM netflix
GROUP BY type;

--2. Find the most common rating for Movies and TV shows
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

--3. list all movies released in a specific year (e.g. 2022)

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020;

--4. Find the top 5 countries with the most content on Netflix
SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--5. Identify the longest movie
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix);

--6. Find content added in the last 5 years
SELECT * FROM netflix
WHERE 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Find all the movies/Tv shows by director 'Rajiv Chilaka'
SELECT * FROM netflix
WHERE 
	director ILIKE '%Rajiv Chilaka%';

--8. List all TV Shows with more than 5 seasons
SELECT * FROM netflix
WHERE 
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::numeric > 5;

--9. Count the number of content items in each genre
SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as totol_content
FROM netflix
GROUP BY 1;

--10. find each year and the average number of contents released by India on Netflix.
--return top 5 year with highest average content released
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

-- 11. List all movies that are documentaries
SELECT 
	*
FROM netflix
WHERE
	type = 'Movie'
	AND
	listed_in ILIKE '%Documentaries%';

-- 12. Find all contents without a director
SELECT * FROM netflix
WHERE director IS NULL;

--13. Find how many movies actor 'Salman Khan' appeared in the last 10 years
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- find the top 10 actors who have the highest number of movies appearance in the Unvted States
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

/* 15. Categorize the contents based on the presence of the keyword 'kill' and 'violence' 
in the description field. Label content containing these keywords as 'bad' and all other 
contents as good. Count how many items fall into each category */
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