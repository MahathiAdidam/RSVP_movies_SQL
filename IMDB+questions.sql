-- Segment 1:
-- Q1. Find the total number of rows in each table of the schema?
-- Number of rows = 3867
SELECT COUNT(*) FROM DIRECTOR_MAPPING;

-- Number of rows = 14662
SELECT COUNT(*) FROM GENRE ;

-- Number of rows = 7997
SELECT COUNT(*) FROM  MOVIE;

-- Number of rows = 25735
SELECT COUNT(*) FROM  NAMES;

-- Number of rows = 7997
SELECT COUNT(*) FROM  RATINGS;

-- Number of rows = 15615
SELECT COUNT(*) FROM  ROLE_MAPPING;

-- Q2. Which columns in the movie table have null values?
SELECT
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_null_count,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null_count,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null_count,
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null_count,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null_count,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null_count,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_null_count,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null_count,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null_count
FROM movie;


-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
SELECT Year, count(id) as number_of_movies
FROM movie
GROUP BY year
ORDER BY year;

-- for the monthly count
SELECT Month(date_published) as month_num, count(id) as num_of_movies
FROM movie
GROUP BY month_num
ORDER BY num_of_movies;

-- Q4. How many movies were produced in the USA or India in the year 2019??

SELECT
    COUNT(id) AS movie_count
FROM
    movie
WHERE
    (country LIKE '%INDIA%' OR country LIKE '%USA%')
    AND year = 2019;
    
-- Q5. Find the unique list of the genres present in the data set?
SELECT DISTINCT genre
FROM genre;

-- Q6.Which genre had the highest number of movies produced overall?

SELECT
    GENRE,
    COUNT(ID) AS TOTAL_MOVIES
FROM
    MOVIE M
INNER JOIN
    GENRE G
ON
    M.ID = G.MOVIE_ID
GROUP BY
    GENRE
ORDER BY
    TOTAL_MOVIES DESC
LIMIT 3;


-- Q7. How many movies belong to only one genre?

WITH unique_movie AS (
    SELECT
        movie_id,
        COUNT(genre) AS Total_genre
    FROM
        genre
    GROUP BY
        movie_id
)
SELECT
    COUNT(*) as movie_with_one_genre
FROM
    unique_movie
WHERE
    Total_genre = 1;
    
-- Q8.What is the average duration of movies in each genre?

SELECT
    genre,
    ROUND(AVG(duration), 2) as avg_duration
FROM
    movie m
INNER JOIN
    genre g
ON
    m.id = g.movie_id
GROUP BY
    genre;

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced?

WITH genre_rank AS (
    SELECT
        genre,
        COUNT(ID) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY COUNT(ID) DESC) AS genre_rank
    FROM
        MOVIE M
    INNER JOIN
        GENRE G
    ON
        M.ID = G.MOVIE_ID
    GROUP BY
        GENRE
)
SELECT * 
FROM genre_rank
WHERE genre = 'Thriller';

-- segment 2

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
SELECT 
    MIN(avg_rating) AS min_avg_rating, MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes, MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating, MAX(median_rating) AS max_median_rating
FROM ratings;

-- Q11. Which are the top 10 movies based on average rating?
SELECT
    m.title,
    r.avg_rating,
    ROW_NUMBER() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM
    ratings r
INNER JOIN
    movie m
ON
    r.movie_id = m.id
LIMIT 10;

-- Q12. Summarise the ratings table based on the movie counts by median ratings.

SELECT
    median_rating,
    COUNT(m.id) AS movie_count
FROM
    ratings r
INNER JOIN
    movie m
ON
    r.movie_id = m.id
GROUP BY
    median_rating
ORDER BY
    movie_count DESC;
    
-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??

SELECT
    production_company,
    COUNT(m.id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM
    movie m
INNER JOIN
    ratings r
ON
    m.id = r.movie_id
WHERE
    avg_rating > 8
    AND production_company IS NOT NULL
GROUP BY
    production_company;
    
-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
SELECT
    genre,
    COUNT(id) AS movie_count
FROM
    genre g
INNER JOIN
    movie m
ON
    m.id = g.movie_id
INNER JOIN
    ratings r
ON
    m.id = r.movie_id
WHERE
    MONTH(date_published) = 3
    AND YEAR(date_published) = 2017
    AND total_votes > 1000
    AND country LIKE '%USA%'
GROUP BY
    genre
ORDER BY
    movie_count DESC;
    
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
SELECT m.title, r.avg_rating, g.genre
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
INNER JOIN genre g ON m.id = g.movie_id
WHERE m.title LIKE 'The%'
  AND r.avg_rating > 8
ORDER BY r.avg_rating DESC;

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
SELECT
    COUNT(id) AS Movie_released_april2018_april2019
FROM
    movie m
INNER JOIN
    ratings r
ON
    m.id = r.movie_id
WHERE
    (date_published BETWEEN '2018-04-01' AND '2019-04-01')
    AND (median_rating = 8);

-- Q17. Do German movies get more votes than Italian movies? 
SELECT
    country,
    SUM(total_votes) AS total_votes
FROM
    movie AS m
INNER JOIN
    ratings AS r
ON
    m.id = r.movie_id
WHERE
    country IN ('Germany', 'Italy')
GROUP BY
    country;
    
-- Segment 3:

-- Q18. Which columns in the names table have null values??
SELECT SUM(CASE WHEN NAME IS NULL THEN 1 ELSE 0 END) as name_nulls,
        SUM(CASE WHEN HEIGHT IS NULL THEN 1 ELSE 0 END) as HEIGHT_nulls,
        SUM(CASE WHEN DATE_OF_BIRTH IS NULL THEN 1 ELSE 0 END) as DATE_OF_BIRTH_nulls,
        SUM(CASE WHEN KNOWN_FOR_MOVIES IS NULL THEN 1 ELSE 0 END) as KNOWN_FOR_MOVIES_nulls
FROM NAMES;

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
WITH Top_Three_Genre AS (
    SELECT
        genre,
        COUNT(m.id) AS Movie_count
    FROM
        movie m
    INNER JOIN
        genre g ON m.id = g.movie_id
    INNER JOIN
        ratings r ON r.movie_id = m.id
    WHERE
        avg_rating > 8
    GROUP BY
        genre
    ORDER BY
        Movie_count DESC
    LIMIT 3
)
SELECT
    n.name AS director_name,
    COUNT(m.id) AS Movie_count
FROM
    movie m
INNER JOIN
    director_mapping d ON m.id = d.movie_id
INNER JOIN
    names n ON n.id = d.name_id
INNER JOIN
    genre g ON g.movie_id = m.id
INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    g.genre IN (SELECT genre FROM Top_Three_Genre)
    AND avg_rating > 8
GROUP BY
    director_name
ORDER BY
    Movie_count DESC
LIMIT 3;


-- Q20. Who are the top two actors whose movies have a median rating >= 8?
SELECT
    n.name AS Actor_name,
    COUNT(m.id) AS Movie_count
FROM
    movie m
INNER JOIN
    ratings r ON m.id = r.movie_id
INNER JOIN
    role_mapping rm ON m.id = rm.movie_id
INNER JOIN
    names n ON n.id = rm.name_id
WHERE
    median_Rating >= 8
GROUP BY
    Actor_name
ORDER BY
    Movie_count DESC
LIMIT 2;

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
SELECT
    production_company,
    SUM(total_votes) AS Vote_count,
    ROW_NUMBER() OVER (ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM
    movie m
INNER JOIN
    ratings r
ON
    m.id = r.movie_id
GROUP BY
    production_company
LIMIT 3;

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
SELECT
    name AS actor_name,
    SUM(total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actor_avg_rating,
    ROW_NUMBER() OVER (ORDER BY  ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC) AS actor_rank
FROM
    names n
INNER JOIN
    role_mapping rm ON n.id = rm.name_id
INNER JOIN
    ratings r ON rm.movie_id = r.movie_id
INNER JOIN
    movie m ON m.id = rm.movie_id
WHERE
    category = "actor"
    AND country LIKE "%india%"
GROUP BY
    actor_name
HAVING
    movie_count >= 5;

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
SELECT
    name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actress_avg_rating,
    ROW_NUMBER() OVER (
        ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC, SUM(total_votes) DESC
    ) AS actress_rank
FROM
    names n
INNER JOIN
    role_mapping rm ON n.id = rm.name_id
INNER JOIN
    ratings r ON rm.movie_id = r.movie_id
INNER JOIN
    movie m ON m.id = rm.movie_id
WHERE
    category = "actress"
    AND country LIKE "%india%"
    AND languages LIKE "%hindi%"
GROUP BY
    actress_name
HAVING
    movie_count >= 3;
    
/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies */
SELECT
    title,
    genre,
    avg_rating,
    CASE
        WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        WHEN avg_rating < 5 THEN 'Flop movies'
    END AS rating_category
FROM
    movie AS m
INNER JOIN
    genre AS g ON m.id = g.movie_id
INNER JOIN
    ratings AS r ON r.movie_id = m.id
WHERE
    genre = 'Thriller';


-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
SELECT
    genre,
    ROUND(AVG(duration), 2) AS avg_duration,
    SUM(ROUND(AVG(duration), 2)) OVER (ORDER BY genre) AS running_total_duration,
    ROUND(AVG(ROUND(AVG(duration), 2)) OVER (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
FROM
    movie AS m
INNER JOIN
    genre AS g ON m.id = g.movie_id
GROUP BY
    genre
ORDER BY
    genre;

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- Select the top three genres with the most number of movies.
WITH top_three_genre AS (
    SELECT
        genre,
        COUNT(m.id) AS movie_count
    FROM
        movie m
    INNER JOIN
        genre g ON g.movie_id = m.id
    GROUP BY
        genre
    ORDER BY
        movie_count DESC
    LIMIT 3
),

-- Select the top five movies from each of the top three genres for each year based on worldwide gross income.
final_tab AS (
    SELECT
        g.genre,
        m.year,
        m.title,
        worlwide_gross_income,
        ROW_NUMBER() OVER (PARTITION BY m.year ORDER BY worlwide_gross_income DESC) AS movie_rank
    FROM
        movie m
    INNER JOIN
        genre g ON g.movie_id = m.id
    WHERE
        g.genre IN (SELECT genre FROM top_three_genre)
)
-- Retrieve the results of the top movies in the top genres.
SELECT
    *
FROM
    final_tab
WHERE
    movie_rank <= 5;

-- Q27. Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
-- Top 2 production houses for high-rated multilingual movies
WITH top_production_houses AS (
    SELECT
        production_company,
        COUNT(*) AS movie_count,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS prod_comp_rank
    FROM
        movie m
    INNER JOIN
        ratings r ON m.id = r.movie_id
    WHERE
        median_rating >= 8
        AND POSITION(',' in languages) > 0 -- Movies with multiple languages
        AND production_company IS NOT NULL
    GROUP BY
        production_company
)
SELECT
    production_company,
    movie_count,
    prod_comp_rank
FROM
    top_production_houses
WHERE
    prod_comp_rank <= 2;
    
    
 -- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
   
-- Top 3 actresses in the drama genre with Super Hit movies
SELECT
    name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    AVG(avg_rating) AS actress_Avg_rating,
    ROW_NUMBER() OVER (ORDER BY count(m.id) DESC) AS actress_rank
FROM
    names n
INNER JOIN
    role_mapping rm ON n.id = rm.name_id
INNER JOIN
    movie m ON m.id = rm.movie_id
INNER JOIN
    ratings r ON r.movie_id = m.id
INNER JOIN
    genre g ON g.movie_id = m.id
WHERE
    avg_rating > 8
    AND category = "actress"
    AND genre = "drama"
GROUP BY
    actress_name
ORDER BY 
 movie_count desc
LIMIT 3;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations */
-- First, create a view to calculate the average difference between two movie dates
CREATE VIEW avg_diff_between_movie_dates AS
WITH movie_dates AS (
    SELECT
        nm.id AS director_id,
        nm.name AS director_name,
        m.id AS movie_id,
        m.date_published AS movie_date,
        LEAD(m.date_published, 1) OVER (PARTITION BY nm.name ORDER BY m.date_published) AS next_movie_date
    FROM
        names nm
    INNER JOIN
        director_mapping dm ON nm.id = dm.name_id
    INNER JOIN
        movie m ON dm.movie_id = m.id
)
SELECT
    director_id,
    director_name,
    AVG(DATEDIFF(next_movie_date, movie_date)) AS avg_inter_movie_days
FROM
    movie_dates
GROUP BY
    director_id, director_name;
-- Top 9 directors based on the number of movies
WITH top_directors AS (
    SELECT
        nm.id AS director_id,
        nm.name AS director_name,
        COUNT(DISTINCT dm.movie_id) AS number_of_movies,
        ROUND(AVG(r.avg_rating), 2) AS avg_rating,
        SUM(r.total_votes) AS total_votes,
        MIN(r.avg_rating) AS min_rating,
        MAX(r.avg_rating) AS max_rating,
        SUM(m.duration) AS total_duration,
        ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT dm.movie_id) DESC) AS director_rank
    FROM
        names nm
    INNER JOIN
        director_mapping dm ON nm.id = dm.name_id
    INNER JOIN
        movie m ON dm.movie_id = m.id
    INNER JOIN
        ratings r ON m.id = r.movie_id
    GROUP BY
        director_id, director_name
)
-- Combine with the average inter-movie days
SELECT
    td.director_id,
    td.director_name,
    td.number_of_movies,
    AVGD.avg_inter_movie_days AS avg_inter_movie_days,
    td.avg_rating,
    td.total_votes,
    td.min_rating,
    td.max_rating,
    td.total_duration
FROM
    top_directors td
LEFT JOIN
    avg_diff_between_movie_dates AVGD ON td.director_id = AVGD.director_id
WHERE
    td.director_rank <= 9;
