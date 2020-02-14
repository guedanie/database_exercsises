## Additional exercises

# Employees DATABASE

#How much do the current managers of each department get paid, relative to the average salary for the department? Is there any department where the department manager gets paid less than the average salary? Two departments (production and customer service) managers get payed less than the average.

USE employees;

USE curie_942;
# Create two temporary tables, one to store the average salary of all the departments and a second table to store the salary of the department managers. Then I used a query to call both set of info and display them together. 

CREATE TEMPORARY TABLE avg_dept_salary AS 
	SELECT employees.departments.dept_name, AVG(employees.salaries.salary) avg_dept_salary
	FROM employees.salaries
	JOIN employees.employees USING(emp_no)
	JOIN employees.dept_emp USING (emp_no)
	JOIN employees.departments USING (dept_no)
	WHERE employees.dept_emp.to_date > NOW() AND employees.salaries.to_date > NOW()
	GROUP BY employees.departments.dept_name
;

CREATE TEMPORARY TABLE manager_salary AS
	SELECT employees.departments.dept_name, employees.salaries.salary AS salary_manager
	FROM employees.employees
	JOIN employees.salaries USING (emp_no)
	JOIN employees.dept_manager USING (emp_no)
	JOIN employees.departments USING (dept_no)
	WHERE emp_no IN (
		SELECT emp_no
		FROM employees.dept_manager
		WHERE employees.dept_manager.to_date > NOW()
	) AND employees.salaries.to_date > NOW()
;


SELECT dept_name, avg_dept_salary, salary_manager, (salary_manager - avg_dept_salary)
FROM avg_dept_salary
JOIN manager_salary USING (dept_name)
;

# World Database

USE world;

#What langueages are spoken in Santa Monica

SELECT * FROM city
WHERE NAME = 'Santa Monica'
;

SELECT * FROM countrylanguage
WHERE countrycode = "USA"; 

SELECT countrylanguage.language AS 'language', countrylanguage.percentage AS 'percentage'
FROM countrylanguage
WHERE countrycode IN (
	SELECT countrycode
	FROM city
	WHERE NAME = 'Santa Monica')
ORDER BY percentage ASC
;

# How many different countries are in each region?

SELECT region, count(*) AS n_countries
FROM country 
GROUP BY region
ORDER BY n_countries
;

# What is the population of each region? 

SELECT region, sum(population) AS population
FROM country
GROUP BY region
ORDER BY population DESC
;

#what is the population of each continent

SELECT continent, sum(population) AS population
FROM country
GROUP BY continent
ORDER BY continent ASC
;

# what is the average life expectancy globally 

SELECT AVG(LifeExpectancy)
FROM country
;

#What is the average life expectancy by continet

SELECT continent, AVG(LifeExpectancy) AS avg_life
FROM country
GROUP BY continent
ORDER BY avg_life ASC
;

#What is the average life expectancy by region 

SELECT region, AVG(LifeExpectancy) AS avg_life
FROM country
GROUP BY region
ORDER BY avg_life ASC
;

#Bonus Find all the countries whose local name is different from the official name

SELECT count(*)
FROM country
WHERE NAME != localname
;

SELECT NAME
FROM country 
WHERE NAME != localname
;

# Sakila Database
USE sakila;

# Display the first and last names in all lowercase of all the actor

SELECT lower(first_name), lower(last_name)
FROM actor
;

# You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you could use to obtain this information?

SELECT actor_id, lower(first_name), lower(last_name)
FROM actor
WHERE first_name = 'Joe'
;

#Find all actors whose last name contain the letters "gen"

SELECT first_name, last_name
FROM actor 
WHERE last_name LIKE '%gen%'
;

#Find all actors whose last names contain the letters "li". This time, order the rows by last name and first name, in that order.

SELECT first_name, last_name
FROM actor 
WHERE last_name LIKE '%li%'
ORDER BY last_name, first_name
;

# Using IN, display the country_id and country columns for the following countries: Afghanistan, Bangladesh, and China


SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China')
;

# List the last names of all the actors, as well as how many actors have that last name.

SELECT last_name, count(*)
FROM actor
GROUP BY last_name
;

#List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT last_name, count(*)
FROM actor
GROUP BY last_name
HAVING count(*) > 1
;

#You cannot locate the schema of the address table. Which query would you use to re-create it?

#Use JOIN to display the first and last names, as well as the address, of each staff member.

SELECT first_name, last_name, address
FROM staff
JOIN address USING (address_id)
;

# Use JOIN to display the total amount rung up by each staff member in August of 2005.

SELECT first_name, sum(amount)
FROM staff
JOIN payment USING (staff_id)
GROUP BY first_name
;

# List each film and the number of actors who are listed for that film.

SELECT title, count(*) AS n_actors
FROM film
JOIN film_actor USING (film_id)
GROUP BY title
;

# How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT count(*)
FROM inventory
WHERE film_id IN (
	SELECT film_id
	FROM film
	WHERE title = 'Hunchback Impossible'
)
;