-- * 1a. Display the first and last names of all actors from the table `actor`.
SELECT
    `actor`.`first_name`,
    `actor`.`last_name`
FROM `sakila`.`actor`;

-- * 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT concat(CONCAT(UCASE(SUBSTRING(`first_name`, 1, 1)),LOWER(SUBSTRING(`first_name`, 2))),' ',CONCAT(UCASE(SUBSTRING(`last_name`, 1, 1)),LOWER(SUBSTRING(`last_name`, 2)))) `Actor Name`
FROM `sakila`.`actor`;

-- * 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

SELECT `actor`.`actor_id`,
    `actor`.`first_name`,
    `actor`.`last_name`
FROM `sakila`.`actor`
where first_name like 'Joe%';

-- * 2b. Find all actors whose last name contain the letters `GEN`:
SELECT `actor`.`actor_id`,
    `actor`.`first_name`,
    `actor`.`last_name`
FROM `sakila`.`actor`
where first_name like '%GEN%';

-- * 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT `actor`.`actor_id`,
    `actor`.`first_name`,
    `actor`.`last_name`
FROM `sakila`.`actor`
where last_name like '%LI%';

-- * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT `country`.`country_id`,
    `country`.`country`,
    `country`.`last_update`
FROM `sakila`.`country`
where country in ('Afghanistan', 'Bangladesh', 'China');

-- * 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).

ALTER TABLE `sakila`.`actor`
ADD description  BLOB;

-- * 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.

ALTER TABLE `sakila`.`actor`
DROP description;

-- * 4a. List the last names of actors, as well as how many actors have that last name.
SELECT
    `actor`.`last_name`,
    count(*) LastNameCount
FROM `sakila`.`actor`
group by `actor`.`last_name`;

-- * 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
SELECT
    `actor`.`last_name`,
    count(*) LastNameCount
FROM `sakila`.`actor`
group by `actor`.`last_name`
having count(*)>=2;

-- * 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.

UPDATE `sakila`.`actor`
SET `actor`.`first_name` ='HARPO'
WHERE `actor`.`first_name` ='GROUCHO' and `actor`.`last_name` ='WILLIAMS';

-- this is to verify
SELECT `actor`.`actor_id`,
    `actor`.`first_name`,
    `actor`.`last_name`,
    `actor`.`last_update`
FROM `sakila`.`actor` where  `actor`.`last_name` ='WILLIAMS'

-- * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

UPDATE `sakila`.`actor`
SET `actor`.`first_name` ='GROUCHO'
WHERE `actor`.`first_name` ='HARPO' and `actor`.`last_name` ='WILLIAMS';

-- this is to verify
SELECT `actor`.`actor_id`,
    `actor`.`first_name`,
    `actor`.`last_name`,
    `actor`.`last_update`
FROM `sakila`.`actor` where  `actor`.`last_name` ='WILLIAMS'

-- * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
DESC ADDRESS;
SHOW CREATE TABLE address;

-- * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT 
   `staff`.`first_name`,
    `staff`.`last_name`,
     `address`.`address`,
    `address`.`address2`,
    `address`.`district`,
    `address`.`city_id`,
    `address`.`postal_code`
    from `sakila`.`address`
    inner join `sakila`.`staff` 
    on `address`.`address_id`=`staff`.`address_id`

-- * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT `staff`.`staff_id`,
    `staff`.`first_name`,
    `staff`.`last_name`,
   p.*
FROM `sakila`.`staff` 
inner join (
		SELECT `payment`.`staff_id`,
			sum(`payment`.`amount`) 'Amountin2005'
		FROM `sakila`.`payment`
		where year(payment_date)='2005' and month(payment_date)='8'
		group by `payment`.`staff_id`
			) p
on `staff`.`staff_id`=p.`staff_id`

-- * 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT 
    `film`.`title`, COUNT(`actor`.`actor_id`) ActorCount
FROM
    `sakila`.`actor`
        INNER JOIN
    `sakila`.`film_actor` ON `film_actor`.`actor_id` = `actor`.`actor_id`
        INNER JOIN
    `sakila`.`film` ON `film_actor`.`film_id` = `film`.`film_id`
GROUP BY `film`.`title`

-- * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select `film`.`title`, InventoryCount
FROM `sakila`.`film`
inner join (
			select `inventory`.`film_id`, count(*) InventoryCount
			from `sakila`.`inventory`
            group by `inventory`.`film_id`) inv
on `film`.`film_id`=inv.`film_id`
where `film`.`title`='Hunchback Impossible'

-- * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
select `customer`.`customer_id`,
   `customer`.`first_name`,
    `customer`.`last_name`,
    sum(`payment`.`amount`) TotalAmount
FROM `sakila`.`payment`
inner join `sakila`.`customer`
on `payment`.`customer_id`=`customer`.`customer_id`
group by `customer`.`customer_id`
order by `customer`.`last_name` 

-- * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

SELECT `film`.`film_id`,
    `film`.`title`,
    `film`.`description`,
    `film`.`release_year`,
    `film`.`language_id`,
    `film`.`original_language_id`,
    `film`.`rental_duration`,
    `film`.`rental_rate`,
    `film`.`length`,
    `film`.`replacement_cost`,
    `film`.`rating`,
    `film`.`special_features`,
    `film`.`last_update`
FROM `sakila`.`film`
inner join 
	(SELECT `language`.`language_id`,
    `language`.`name`,
    `language`.`last_update`
	FROM `sakila`.`language` where name='English') a
    on a.language_id=`film`.`language_id`
    where `film`.`title` like 'K%' or `film`.`title` like 'Q%' 
    
   
-- * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`. 

SELECT `actor`.`actor_id`,
    `actor`.`first_name`,
    `actor`.`last_name`,
    `actor`.`last_update`
FROM `sakila`.`actor` 
inner join
(SELECT `film_actor`.`actor_id`,
    `film_actor`.`film_id`,
    `film_actor`.`last_update`
FROM `sakila`.`film_actor`) a
on a.actor_id=`actor`.`actor_id`
inner join 
(SELECT `film`.`film_id`,
    `film`.`title`,
    `film`.`description`,
    `film`.`release_year`,
    `film`.`language_id`,
    `film`.`original_language_id`,
    `film`.`rental_duration`,
    `film`.`rental_rate`,
    `film`.`length`,
    `film`.`replacement_cost`,
    `film`.`rating`,
    `film`.`special_features`,
    `film`.`last_update`
FROM `sakila`.`film` where title='Alone Trip') b
on b.film_id=a.film_id

-- * 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT `customer`.`customer_id`,
    `customer`.`store_id`,
    `customer`.`first_name`,
    `customer`.`last_name`,
    `customer`.`email`,
    `customer`.`address_id`,
    `customer`.`active`,
    `customer`.`create_date`,
    `customer`.`last_update`,
     `address`.`location`
FROM `sakila`.`customer` 
inner join (
SELECT `address`.`address_id`,
    `address`.`address`,
    `address`.`address2`,
    `address`.`district`,
    `address`.`city_id`,
    `address`.`postal_code`,
    `address`.`phone`,
    `address`.`location`,
    `address`.`last_update`
FROM `sakila`.`address`) `address`
on  `customer`.`address_id`=`address`.`address_id`
inner join (
SELECT `city`.`city_id`,
    `city`.`city`,
    `city`.`country_id`,
    `city`.`last_update`
FROM `sakila`.`city` ) `city`
on `city`.`city_id`= `address`.`city_id`
inner join (
SELECT `country`.`country_id`,
    `country`.`country`,
    `country`.`last_update`
FROM `sakila`.`country` where  `country`.`country`='Canada') `country`
on `city`.`country_id`=`country`.`country_id`

-- * 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT `film`.`film_id`, `film`.`title`,`category`.`name`
FROM `sakila`.`film`
inner join `sakila`.`film_category`
on `film`.`film_id`=`film_category`.`film_id`
inner join `sakila`.`category`
on `film_category`.`category_id`=`category`.`category_id`
where `category`.`name` like '%family%'

-- * 7e. Display the most frequently rented movies in descending order.

select `film`.`title`, count(*) RentalCount
FROM `sakila`.`film`
inner join `sakila`.`inventory`
on `film`.`film_id`=`inventory`.`film_id`
inner join `sakila`.`rental`
on `rental`.`inventory_id`=`inventory`.`inventory_id`
group by `film`.`title`

-- * 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT 
    `store`.`store_id`,
    `store`.`address_id`,
    `staff`.`staff_id`,
    `staff`.`first_name`,
    `staff`.`last_name`,
    p.*
FROM
    `sakila`.`staff`
        INNER JOIN
    (SELECT 
        `payment`.`staff_id`, SUM(`payment`.`amount`) 'TotalAmount'
    FROM
        `sakila`.`payment`
    GROUP BY `payment`.`staff_id`) p ON `staff`.`staff_id` = p.`staff_id`
        INNER JOIN
    `sakila`.`store` ON `store`.`store_id` = `staff`.`store_id`


-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT `store`.`store_id`,
    `store`.`address_id`,
    `address`.`address_id`,
    `address`.`address`,
    `address`.`address2`,
    `address`.`district`,
    `city`.`city`,
    `address`.`postal_code`,
    `country`.`country`
FROM `sakila`.`store` 
inner join `sakila`.`address`
on `address`.`address_id`=`store`.`address_id`
inner join `sakila`.`city`
on `address`.`city_id`=`city`.`city_id`
inner join `sakila`.`country`
on `city`.`country_id`=`country`.`country_id`

-- * 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT 
    *
FROM
    (SELECT 
        `category`.`name`, SUM(`payment`.`amount`) TotalAmt
    FROM
        `sakila`.`rental`
    INNER JOIN `sakila`.`payment` ON `payment`.`rental_id` = `rental`.`rental_id`
    INNER JOIN `sakila`.`inventory` ON `rental`.`inventory_id` = `inventory`.`inventory_id`
    INNER JOIN `sakila`.`film_category` ON `film_category`.`film_id` = `inventory`.`film_id`
    INNER JOIN `sakila`.`category` ON `category`.`category_id` = `film_category`.`category_id`
    GROUP BY `category`.`name`) q1
ORDER BY TotalAmt DESC

-- * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

create VIEW `sakila`.`TopFiveGenres` AS
SELECT 
    *
FROM
    (SELECT 
        `category`.`name`, SUM(`payment`.`amount`) TotalAmt
    FROM
        `sakila`.`rental`
    INNER JOIN `sakila`.`payment` ON `payment`.`rental_id` = `rental`.`rental_id`
    INNER JOIN `sakila`.`inventory` ON `rental`.`inventory_id` = `inventory`.`inventory_id`
    INNER JOIN `sakila`.`film_category` ON `film_category`.`film_id` = `inventory`.`film_id`
    INNER JOIN `sakila`.`category` ON `category`.`category_id` = `film_category`.`category_id`
    GROUP BY `category`.`name`) q1
ORDER BY TotalAmt DESC
limit 5;

-- * 8b. How would you display the view that you created in 8a?
SELECT `topfivegenres`.`name`,
    `topfivegenres`.`TotalAmt`
FROM `sakila`.`topfivegenres`;

-- * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW `sakila`.`topfivegenres`;


