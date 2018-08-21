USE sakila;

#1a
-- DESCRIBE actor;
SELECT first_name, last_name FROM actor;

#1b
SELECT concat(first_name, ' ', last_name) AS 'Actor Name' FROM actor;

#2a
SELECT actor_id AS 'ID',
	first_name AS 'First Name',
    last_name AS 'Last Name'
FROM actor
WHERE first_name LIKE '%Joe%';

#2b
SELECT actor_id AS 'ID',
	first_name AS 'First Name',
    last_name AS 'Last Name'
FROM actor
WHERE last_name LIKE '%Gen%';

#2c
SELECT actor_id AS 'ID',
	first_name AS 'First Name',
    last_name AS 'Last Name'
FROM actor
WHERE last_name LIKE '%Li%'
ORDER BY last_name, first_name;

#2d
-- DESCRIBE country;

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a
ALTER TABLE actor
ADD COLUMN description BLOB;

#3b
ALTER TABLE actor
DROP description;

#4a
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;

#4b
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;

#4c
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO';

#4d
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO';

#5a
SHOW CREATE TABLE address;

#6a
-- DESCRIBE staff;
-- DESCRIBE address;

SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a USING (address_id);

#6b
-- DESCRIBE payment;
SELECT payment_date FROM payment;

SELECT s.staff_id, first_name, last_name, SUM(amount)
FROM staff s
JOIN payment USING (staff_id)
WHERE payment_date>='2005-08-01' AND payment_date<='2005-08-31'
GROUP BY s.staff_id;

#6C
-- DESCRIBE film_actor;
-- DESCRIBE film;

SELECT f.title, COUNT(actor_id) AS '# of actors'
FROM film_actor fa
INNER JOIN film f USING (film_id)
GROUP BY f.title;

#6d
-- DESCRIBE inventory;

SELECT COUNT(i.film_id) AS '# of Copies'
FROM inventory i
JOIN film f USING (film_id)
WHERE f.title = 'Hunchback Impossible';

#6e
-- DESCRIBE customer;
-- DESCRIBE payment;

SELECT c.customer_id, first_name, last_name, SUM(amount) AS 'Total Paid'
FROM customer c
JOIN payment USING (customer_id)
GROUP BY c.customer_id;

#7a
-- DESCRIBE film;
-- DESCRIBE language;

SELECT title
FROM film f
WHERE language_id IN
	(
	SELECT language_id
	FROM language
	WHERE name = 'English'
	)
AND (title LIKE 'k%' OR title LIKE 'q%');


#7b
-- DESCRIBE actor;
-- DESCRIBE film_actor;
-- DESCRIBE film;

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(
    SELECT actor_id
    FROM film_actor
    WHERE film_id in
		(
        SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
        )
	);
    
#7c
-- DESCRIBE customer;
-- DESCRIBE address;
-- DESCRIBE city;
-- DESCRIBE country;

SELECT first_name, last_name, email, country
FROM customer
LEFT JOIN address USING (address_id)
LEFT JOIN city USING (city_id)
LEFT JOIN country USING (country_id)
WHERE country = 'Canada';

#7d
-- DESCRIBE film;
-- DESCRIBE film_category;
-- DESCRIBE category;

SELECT title, name AS 'category'
FROM film
LEFT JOIN film_category USING (film_id)
LEFT JOIN category USING (category_id)
WHERE name LIKE '%family%';

#7e
-- DESCRIBE inventory;

SELECT title, COUNT(r.rental_id) AS '# of times rented'
FROM rental r
LEFT JOIN inventory USING (inventory_id)
LEFT JOIN film f USING (film_id)
GROUP BY f.film_id
ORDER BY COUNT(r.rental_id) DESC;

#7f
-- DESCRIBE store;
-- DESCRIBE payment;
-- DESCRIBE rental;
-- DESCRIBE inventory;

SELECT store_id, SUM(amount) AS 'Business in $'
FROM payment
LEFT JOIN rental USING (rental_id)
LEFT JOIN inventory USING (inventory_id)
GROUP BY store_id;

#7g
-- DESCRIBE store;
-- DESCRIBE address;
-- DESCRIBE city;
-- DESCRIBE country;

SELECT s.store_id, city, country
FROM store s
LEFT JOIN address USING (address_id)
LEFT JOIN city USING (city_id)
LEFT JOIN country using (country_id);

#7h
-- DESCRIBE category;
-- DESCRIBE film_category;
-- DESCRIBE inventory;
-- DESCRIBE payment;
-- DESCRIBE rental;

SELECT name AS 'genre', SUM(amount) AS 'gross revenue'
FROM payment
LEFT JOIN rental USING (rental_id)
LEFT JOIN inventory USING (inventory_id)
LEFT JOIN film_category USING (film_id)
LEFT JOIN category USING (category_id)
GROUP BY category.category_id
ORDER BY SUM(amount) DESC LIMIT 5;

#8a
CREATE VIEW top_five AS
	(
	SELECT name AS 'genre', SUM(amount) AS 'gross revenue'
	FROM payment
	LEFT JOIN rental USING (rental_id)
	LEFT JOIN inventory USING (inventory_id)
	LEFT JOIN film_category USING (film_id)
	LEFT JOIN category USING (category_id)
	GROUP BY category.category_id
	ORDER BY SUM(amount) DESC LIMIT 5
	);

#8b    
SELECT * FROM top_five;

#8c
DROP VIEW top_five;