DROP DATABASE Bunny_Bothy;
-- This is the booking system for the Bunny Bothy.  It stores customer details, bunnies first of course, they are our
-- primary customer, booking dates and food preferences of our guests.  The system also keeps track of food supplies and 
-- can be automatically reduced daily based on the culinary preferences of our current guests.  
-- Note there is a separate system for payment and for supply ordering.

CREATE DATABASE Bunny_Bothy;

USE Bunny_Bothy;

CREATE TABLE bunny
(id INT PRIMARY KEY AUTO_INCREMENT,
bunny_name VARCHAR(50) NOT NULL,
breed VARCHAR(50),
age INT NOT NULL,
length_of_stay INT NOT NULL,
check_in_day DATE,
favourite_snack VARCHAR(50),
checked_in VARCHAR(3) NOT NULL
);

CREATE TABLE customer
(id INT PRIMARY KEY AUTO_INCREMENT, 
customer_name VARCHAR(50) NOT NULL,
previous_stays INT,
price_per_night FLOAT,
bunny_id INT NOT NULL,  
FOREIGN KEY (bunny_id) REFERENCES bunny(id) ON DELETE CASCADE
);

CREATE TABLE supplies
(id INT PRIMARY KEY AUTO_INCREMENT,
supply_name VARCHAR(50) NOT NULL UNIQUE,
food_type VARCHAR(50) NOT NULL
);

CREATE TABLE remaining_stock
(id INT PRIMARY KEY AUTO_INCREMENT,
stock_name VARCHAR(50) NOT NULL UNIQUE,
item_count int);

INSERT INTO bunny
(bunny_name, breed, age, length_of_stay, check_in_day, favourite_snack, checked_in)
VALUES
('Jinx', 'chonkasaurus', 6, 5, '2025-02-17', 'banana', 'yes'),
('RuPaul', 'chonkasaurus', 6, 5, '2025-02-17', 'apple', 'yes'),
('Storm', 'netherland dwarf', 2, 3, '2025-02-11', 'coriander', 'no'),
('Sebastian', 'continental giant', 4, 4, '2025-03-01', 'marigold', 'no'),
('Romeo', 'netherland dwarf', 3, 3, '2025-02-14', 'dried rose petals', 'no'),
('Bobby', 'english spot', 16, 7, '2025-02-19', 'kale', 'no'),
('Sweep', 'himalayan', 1, 7, '2025-02-19', 'parsley', 'no'),
('Dougall', 'miniature lop', 7, 7, '2025-02-19', 'coriander', 'no');

INSERT INTO customer
(customer_name, previous_stays, price_per_night, bunny_id)
VALUES
('Sophie', 2, 25.50, 1),
('Sophie', 2, 25.50, 2),
('Nathan', 1, 12.25, 3),
('Liam', 5, 12.25, 4),
('Robert', 0, 12.25, 5),
('Patricia', 1, 37.75, 6),
('Patricia', 1, 37.75, 7),
('Patricia', 1, 37.75, 8);

INSERT INTO supplies
(supply_name, food_type)
VALUES
('timothy hay', 'dry'),
('treat pellets', 'dry'),
('dried rose petals', 'dry'),
('dandelion root', 'dry'),
('marigold', 'dry'),
('parsley', 'fresh'),
('coriander', 'fresh'),
('apple', 'fresh'),
('banana', 'fresh'),
('kale', 'fresh');

INSERT INTO remaining_stock
(stock_name, item_count)
VALUES
('timothy hay', 50),
('treat pellets', 50),
('dried rose petals', 50),
('dandelion root', 50),
('marigold', 50),
('parsley', 50),
('coriander', 50),
('apple', 50),
('banana', 50),
('kale', 50);

USE bunny_bothy;

-- Find all netherland dwarf bunnies on the booking system
SELECT * FROM bunny
WHERE breed = 'netherland dwarf'
ORDER BY bunny_name;

-- Find all bunnies booked to stay in February
SELECT * FROM bunny
WHERE MONTH(check_in_day) = 2
ORDER BY check_in_day;

-- Find all bunnies booked to stay for more than 2 days
SELECT * FROM bunny
WHERE length_of_stay > 2
ORDER BY length_of_stay DESC;

-- Find all customers who have booked with the bothy before
SELECT * FROM customer
WHERE previous_stays > 0
ORDER BY previous_stays DESC;

-- Find all bunnies Sophie has booked to stay at the bothy
SELECT * FROM bunny
WHERE id IN (
    SELECT bunny_id FROM customer
    WHERE customer_name = 'Sophie')
    ORDER BY bunny_name;

-- Query deleting a record from the bunny table
DELETE FROM bunny
WHERE bunny_name = 'Sweep';

-- Inner join showing food items with remaining amount of stock
SELECT rs.id, s.supply_name, rs.item_count
FROM supplies s
INNER JOIN remaining_stock rs ON s.supply_name = rs.stock_name
WHERE s.food_type = 'dry';

-- Left Join showing all bunnies with associated customer
SELECT bunny.bunny_name, bunny.breed, customer.customer_name
FROM bunny
LEFT JOIN customer ON bunny.id = customer.bunny_id;

-- Aggregate function showing the oldest age of bunny that is on the booking system
SELECT MAX(age) AS oldest_bunny_age
FROM bunny;

-- Aggregate function showing how many bunnies are staying at the bothy in February
SELECT COUNT(*) AS bunnies_staying_in_february
FROM bunny
WHERE MONTH(check_in_day) = 2;

-- Showing how many days until each bunny is checked in  
SELECT bunny_name, DATEDIFF(CURDATE(), check_in_day) AS days_since_check_in
FROM bunny;


-- Stored function getting total bunnies staying today, grouped by favourite snack and then reducing stock count for 
-- those snacks

DELIMITER //

CREATE PROCEDURE UpdateStockForBunnies()
BEGIN
    UPDATE remaining_stock rs
    JOIN (
        SELECT favourite_snack, COUNT(*) AS bunnies_staying_today
        FROM bunny
        WHERE checked_in = 'yes'
        GROUP BY favourite_snack
    ) bunnies
    ON rs.stock_name = bunnies.favourite_snack
    SET rs.item_count = rs.item_count - bunnies.bunnies_staying_today;
END //


CALL UpdateStockForBunnies();


-- Today a first time customer Alexander is booking a reservation for his bunny, Sonic, at the bunny bothy.   
-- Sonic is a netherland dwarf breed rabbit, 6 years old. his favourite snack is parsley. He would like to check Sonic 
-- in to stay for 2 nights on 24th February.  when booking sonic in, a mistake is made and there is a spelling error in
-- Sonics name. The agent has to delete the record and rectify the issue.

-- Fast forward to 24th Feb, Alexander arrives at the bothy reception with Sonic, ready for his stay.  The receptionist 
-- checks which bunnies are checking in today to make sure Sonic is on the list.  They check Sonic in.  Later that day, 
-- the caterer checks the system for a list of the favourite snacks of the bunnies staying today to prepare dinner
-- and reduces the stock accordingly using the UpdateStockForBunnies function.  Reception checks how many bunnies are to
-- check in tomorrow and checks the supplies stock to make sure we have enough in stock.

SELECT *
FROM bunny;

USE Bunny_Bothy;

-- Insert Sonic into the bunny table with the wrong name
INSERT INTO bunny (bunny_name, breed, age, length_of_stay, check_in_day, favourite_snack, checked_in)
VALUES ('Sonci', 'netherland dwarf', 6, 2, '2025-02-24', 'parsley', 'no');

-- Insert first-time customer Alexander 
INSERT INTO customer (customer_name, previous_stays, price_per_night, bunny_id)
VALUES ('Alexander', 0, 12.25, 9);
        
-- Delete the incorrect bunny record
DELETE FROM bunny WHERE bunny_name = 'Sonci';  -- Mistaken spelling used during booking

-- Correctly insert the bunny with the correct name (and owenr again)
INSERT INTO bunny (bunny_name, breed, age, length_of_stay, check_in_day, favourite_snack, checked_in)
VALUES ('Sonic', 'netherland dwarf', 6, 2, '2025-02-17', 'parsley', 'no');

INSERT INTO customer (customer_name, previous_stays, price_per_night, bunny_id)
VALUES ('Alexander', 0, 15.00, 
        (SELECT id FROM bunny WHERE bunny_name = 'Sonic' AND breed = 'netherland dwarf' AND age = 6));

-- Check if Sonic is on the check-in list for today
SELECT bunny_name, breed, check_in_day
FROM bunny
WHERE check_in_day = CURRENT_DATE;

-- Changing Sonics check in status
UPDATE bunny 
SET checked_in = 'yes'
WHERE bunny_name = 'Sonic' AND breed = 'netherland dwarf' AND check_in_day = CURRENT_DATE;

-- Checking favourite snacks of todays residents and reduce stock accordingly
SELECT favourite_snack, COUNT(*) AS bunnies_staying_today
FROM bunny
WHERE checked_in = 'yes'
GROUP BY favourite_snack;

CALL UpdateStockForBunnies();

-- Check how many check ins we have tomorrow
SELECT COUNT(*) AS bunnies_checking_in_tomorrow
FROM bunny
WHERE check_in_day = DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY);

-- Check stock levels to make sure we have enough
SELECT rs.stock_name, rs.item_count
FROM remaining_stock rs
WHERE rs.stock_name IN (
    SELECT DISTINCT favourite_snack FROM bunny 
    WHERE checked_in = 'yes'
);





