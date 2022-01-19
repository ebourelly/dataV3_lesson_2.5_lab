USE sakila;

-- 1.Select all the actors with the first name ‘Scarlett’.

SELECT * FROM sakila.actor WHERE first_name = 'Scarlett';

-- 2.How many films (movies) are available for rent and how many films have been rented?
-- number of unique movies
SELECT COUNT(film_id) from sakila.film;
-- output : 1 000 movies
-- number of available movies including sometimes various copies of the same movie
SELECT COUNT(inventory_id) FROM sakila.inventory;
-- output : 4 581 DVD's
-- number of movies rented
SELECT COUNT(distinct(inventory_id)) FROM sakila.rental;
-- output : 4 580 unique DVD's have been rented

-- 3. What are the shortest and longest movie duration? Name the values max_duration and min_duration.
SELECT MAX(length) as max_duration, MIN(length) as min_duration FROM sakila.film;
-- output max = 185 / min = 46

-- 4. What's the average movie duration expressed in format (hours, minutes)?
-- we calculate first the average and modify it to express it in hours (=duration modulo 60) and minutes
-- (remaining amount)
SELECT CONCAT(FLOOR(AVG(length)/60),' hour(s) ',(ROUND(AVG(length))-(FLOOR(AVG(length)/60)*60)),' minute(s)') AS average_duration FROM film;
-- output : 1 hour(s) 55 minute(s)

-- 5. How many distinct (different) actors' last names are there?

SELECT COUNT(DISTINCT(last_name)) AS number_last_names FROM sakila.actor;
-- output : 121 distinct last names


-- 6. Since how many days has the company been operating (check DATEDIFF() function)?

-- I'll take the assumption the company started operating on the first day of the first rental
-- and that the period stops with the last date in the rental table
-- what is the last date  in the table ?
SELECT MAX(return_date), MAX(rental_date), MAX(last_update)
FROM sakila.rental;
-- output : Max last_update is the latest date with 2006-02-23

SELECT DATEDIFF(MAX(last_update), MIN(rental_date)) AS operating_days
FROM sakila.rental;
-- output -> 275 days since start of operations

-- 7. Show rental info with additional columns month and weekday. Get 20 results.

SELECT *,
	MONTH(rental_date) AS month,
    WEEKDAY(rental_date) AS weekday
FROM sakila.rental
LIMIT 20;


-- 8. Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.

-- WEEKDAY function returns 0 = Monday, 1 = Tuesday, 2 = Wednesday, 3 = Thursday, 4 = Friday, 5 = Saturday, 6 = Sunday
SELECT *,
	MONTH(rental_date) AS month,
    WEEKDAY(rental_date) AS weekday,
    CASE
    WHEN WEEKDAY(rental_date) < 5 THEN 'workday'
    WHEN WEEKDAY(rental_date) >= 5 THEN 'weekend'
    END AS day_type
FROM sakila.rental
LIMIT 20;


-- 9. Get release years.

SELECT DISTINCT(release_year) AS release_years FROM sakila.film;
-- output -> all movies were released in 2006

-- 10. Get all films with ARMAGEDDON in the title.

SELECT title
FROM sakila.film
WHERE title LIKE '%ARMAGEDDON%';
-- output -> 6 movies

-- 11. Get all films which title ends with APOLLO.

SELECT title
FROM sakila.film
WHERE title LIKE '%APOLLO';
-- output -> 5 movies


-- 12. Get 10 the longest films.

SELECT title, length
FROM sakila.film
ORDER BY length DESC
LIMIT 10;


-- 13. How many films include Behind the Scenes content?

-- Behind the Scenes are probably in the special_features. Let's look first at the unique values in that column
SELECT DISTINCT(special_features) FROM sakila.film;
-- indeed, that is the case.
-- Now let's count the rows with 'Behind the Scenes'in that column
SELECT COUNT(*)
FROM sakila.film
WHERE special_features LIKE '%Behind the Scenes%'
-- ouput -> 538 movies