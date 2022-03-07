-- Lab 6
-- jvondamm
-- Mar 4, 2022

USE `BAKERY`;
-- BAKERY-1
-- Find all customers who did not make a purchase between October 5 and October 11 (inclusive) of 2007. Output first and last name in alphabetical order by last name.
select FirstName,LastName from (
    select distinct Customer from receipts 
    where Customer not in (
        select distinct Customer from receipts
        where (SaleDate >= '2007-10-05' and SaleDate <= '2007-10-11')
        order by Customer
    )
) t1
join customers on CId = Customer
order by LastName
;


USE `BAKERY`;
-- BAKERY-2
-- Find the customer(s) who spent the most money at the bakery during October of 2007. Report first, last name and total amount spent (rounded to two decimal places). Sort by last name.
SELECT Firstname, LastName, ROUND(p, 2) FROM
(SELECT FirstName, LastName, SUM(Price) as p FROM receipts
JOIN items ON Receipt = RNumber
JOIN goods ON GId = Item
JOIN customers ON Customer = CId
WHERE SaleDate >= '2007-10-01' AND SaleDate <= '2007-10-31'
GROUP BY Customer) t
WHERE p = 
(SELECT MAX(p) FROM
(SELECT FirstName, LastName, SUM(Price) as p FROM receipts
JOIN items ON Receipt = RNumber
JOIN goods ON GId = Item
JOIN customers ON Customer = CId
WHERE SaleDate >= '2007-10-01' AND SaleDate <= '2007-10-31'
GROUP BY Customer) t);


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who never purchased a twist ('Twist') during October 2007. Report first and last name in alphabetical order by last name.

SELECT DISTINCT FirstName, LastName FROM
(SELECT * FROM receipts 
JOIN items ON Receipt = RNumber
JOIN goods ON GId = Item
JOIN customers ON Customer = CId
WHERE SaleDate >= '2007-10-01' AND SaleDate <= '2007-10-31'
AND Customer NOT IN 
(SELECT DISTINCT Customer FROM receipts 
JOIN items ON Receipt = RNumber
JOIN goods ON GId = Item
WHERE Food = 'Twist')) t
ORDER BY LastName;


USE `BAKERY`;
-- BAKERY-4
-- Find the baked good(s) (flavor and food type) responsible for the most total revenue.
SELECT Flavor, Food FROM
(SELECT Food, Flavor, SUM(PRICE) AS p FROM receipts 
JOIN items ON Receipt = RNumber
JOIN goods ON GId = Item
GROUP BY Food,Flavor
) t
WHERE p = 
(SELECT MAX(p) FROM 
(SELECT Food, Flavor, SUM(PRICE) AS p FROM receipts 
JOIN items ON Receipt = RNumber
JOIN goods ON GId = Item
GROUP BY Food,Flavor
) t);


USE `BAKERY`;
-- BAKERY-5
-- Find the most popular item, based on number of pastries sold. Report the item (flavor and food) and total quantity sold.
with t AS (
    SELECT Food, Flavor, COUNT(*) as s FROM receipts 
    JOIN items ON Receipt = RNumber
    JOIN goods ON GId = Item
    GROUP BY Food, Flavor
)
SELECT Flavor, Food, s FROM t
WHERE s = 
(SELECT MAX(s) FROM t)
;


USE `BAKERY`;
-- BAKERY-6
-- Find the date(s) of highest revenue during the month of October, 2007. In case of tie, sort chronologically.
WITH t AS 
(SELECT SaleDate, SUM(PRICE) as p FROM receipts
JOIN items ON Receipt = RNumber
JOIN goods ON GId = Item
WHERE SaleDate <= '2007-10-31' 
AND SaleDate >= '2007-10-01'
GROUP BY SaleDate)
SELECT SaleDate FROM t
WHERE p = (SELECT MAX(p) FROM t)
;


USE `BAKERY`;
-- BAKERY-7
-- Find the best-selling item(s) (by number of purchases) on the day(s) of highest revenue in October of 2007.  Report flavor, food, and quantity sold. Sort by flavor and food.
WITH a AS 
(SELECT SaleDate, SUM(PRICE) as p FROM receipts
JOIN items ON Receipt = RNumber
JOIN goods ON GId = Item
WHERE SaleDate <= '2007-10-31' 
AND SaleDate >= '2007-10-01'
GROUP BY SaleDate),

b AS
(SELECT Flavor, Food, COUNT(Food) as count FROM receipts
JOIN items ON Receipt = RNumber
JOIN goods ON GId = Item
WHERE SaleDate = 
(SELECT SaleDate FROM a
WHERE p = (SELECT MAX(p) FROM a))  
GROUP BY Food, Flavor, SaleDate)

SELECT Flavor, Food, count FROM b
WHERE count = (SELECT MAX(count) FROM b)
GROUP BY Food, Flavor, count
;


USE `BAKERY`;
-- BAKERY-8
-- For every type of Cake report the customer(s) who purchased it the largest number of times during the month of October 2007. Report the name of the pastry (flavor, food type), the name of the customer (first, last), and the quantity purchased. Sort output in descending order on the number of purchases, then in alphabetical order by last name of the customer, then by flavor.
WITH a AS
(SELECT Customer, FirstName, LastName, Flavor, Food, Count(*) as cont FROM receipts
JOIN items ON Receipt = RNumber
JOIN goods ON GId = Item
JOIN customers ON Customer = CId
WHERE Food = 'Cake'
AND SaleDate <= '2007-10-31'
AND SaleDate >= '2007-10-01' 
GROUP BY Customer, Flavor, Food)
SELECT Flavor, Food, FirstName, LastName, cont FROM a as b
WHERE cont = 
(SELECT MAX(cont) FROM a AS c
WHERE b.Flavor = c.Flavor)
ORDER BY cont DESC, LastName, Flavor
;


USE `BAKERY`;
-- BAKERY-9
-- Output the names of all customers who made multiple purchases (more than one receipt) on the latest day in October on which they made a purchase. Report names (last, first) of the customers and the *earliest* day in October on which they made a purchase, sorted in chronological order, then by last name.

WITH a AS 
(SELECT MAX(SaleDate) AS mx, Customer AS c1, FirstName as f1, LastName as l1 FROM receipts 
    JOIN items ON Receipt = RNumber
    JOIN goods ON GId = Item
    JOIN customers ON Customer = CId
    GROUP BY Customer
),

b AS (
    select Min(SaleDate) as mn, Customer AS c2, FirstName as f2, LastName as l2 FROM receipts 
    join items on Receipt = RNumber
    join goods on GId = Item
    join customers on Customer = CId
    group by Customer
)

SELECT l1, f1, mn FROM receipts
JOIN a ON c1 = Customer and mx = SaleDate
JOIN b ON c2 = Customer
GROUP BY Customer
HAVING Count(RNumber) > 1
ORDER BY mn, l1
;


USE `BAKERY`;
-- BAKERY-10
-- Find out if sales (in terms of revenue) of Chocolate-flavored items or sales of Croissants (of all flavors) were higher in October of 2007. Output the word 'Chocolate' if sales of Chocolate-flavored items had higher revenue, or the word 'Croissant' if sales of Croissants brought in more revenue.

WITH a AS (
SELECT SUM(PRICE) AS total1 FROM receipts 
JOIN items ON Receipt = RNumber
JOIN goods ON GId = Item
WHERE Food = 'Croissant'
),

b AS (
SELECT SUM(PRICE) AS total2 FROM receipts 
JOIN items ON Receipt = RNumber
JOIN goods ON GId = Item
where Flavor = 'Chocolate'
)

SELECT
CASE WHEN total1 > total2
THEN 'Croissant' ELSE 'Chocolate' END
FROM a JOIN b
;


USE `INN`;
-- INN-1
-- Find the most popular room(s) (based on the number of reservations) in the hotel  (Note: if there is a tie for the most popular room, report all such rooms). Report the full name of the room, the room code and the number of reservations.

WITH a AS
(SELECT Room, COUNT(CODE) as c FROM reservations
GROUP BY Room)
SELECT RoomName, Room, c from a 
JOIN rooms on Room = RoomCode
WHERE c = (SELECT MAX(c) FROM a)
;


USE `INN`;
-- INN-2
-- Find the room(s) that have been occupied the largest number of days based on all reservations in the database. Report the room name(s), room code(s) and the number of days occupied. Sort by room name.
WITH a AS
(SELECT Room, RoomName, SUM(DateDiff(Checkout,CheckIn)) AS days FROM reservations
JOIN rooms ON Room = RoomCode
GROUP BY Room)
SELECT RoomName, Room, days FROM a
WHERE days = (SELECT MAX(days) FROM a);


USE `INN`;
-- INN-3
-- For each room, report the most expensive reservation. Report the full room name, dates of stay, last name of the person who made the reservation, daily rate and the total amount paid (rounded to the nearest penny.) Sort the output in descending order by total amount paid.
with a AS
(SELECT CODE, RoomName, Room, CheckIn, CheckOut, LastName, Rate, DateDiff(Checkout,CheckIn) * Rate AS p
FROM reservations
JOIN rooms ON Room = RoomCode
GROUP BY CODE)
SELECT RoomName, CheckIn, CheckOut, LastName, Rate, p FROM a
WHERE p = 
(SELECT MAX(P) FROM a as a2
WHERE a2.Room = a.Room)
ORDER BY p DESC
;


USE `INN`;
-- INN-4
-- For each room, report whether it is occupied or unoccupied on July 4, 2010. Report the full name of the room, the room code, and either 'Occupied' or 'Empty' depending on whether the room is occupied on that day. (the room is occupied if there is someone staying the night of July 4, 2010. It is NOT occupied if there is a checkout on this day, but no checkin). Output in alphabetical order by room code. 
WITH a AS
(SELECT RoomName, Room, 'Occupied' FROM reservations
JOIN rooms ON Room = RoomCode
WHERE CheckIn <= '2010-07-04' 
AND Checkout > '2010-07-04'),

b AS
(SELECT RoomName, Room, 'Empty' FROM reservations
JOIN rooms ON Room = RoomCode
WHERE Room NOT IN (SELECT Room FROM a)
GROUP BY Room)

SELECT * FROM a 
UNION ALL 
SELECT * FROM b
ORDER BY Room
;


USE `INN`;
-- INN-5
-- Find the highest-grossing month (or months, in case of a tie). Report the month name, the total number of reservations and the revenue. For the purposes of the query, count the entire revenue of a stay that commenced in one month and ended in another towards the earlier month. (e.g., a September 29 - October 3 stay is counted as September stay for the purpose of revenue computation). In case of a tie, months should be sorted in chronological order.
WITH a AS
(SELECT MONTHNAME(STR_TO_DATE(Month(CheckIn), '%m')) AS m,
Count(*) AS c,
SUM(DateDiff(CheckOut,Checkin) * Rate) AS s
FROM reservations
GROUP BY m)
SELECT m, c, s FROM a
WHERE s = (SELECT MAX(s) FROM a)
ORDER BY m
;


USE `STUDENTS`;
-- STUDENTS-1
-- Find the teacher(s) with the largest number of students. Report the name of the teacher(s) (last, first) and the number of students in their class.

WITH a AS (
SELECT teachers.Last, teachers.First, Count(*) AS c FROM teachers
JOIN list ON teachers.classroom = list.classroom
GROUP BY teachers.Last, teachers.First
)
SELECT * FROM a
WHERE c = 
(SELECT MAX(c) FROM a)
;


USE `STUDENTS`;
-- STUDENTS-2
-- Find the grade(s) with the largest number of students whose last names start with letters 'A', 'B' or 'C' Report the grade and the number of students. In case of tie, sort by grade number.
WITH a AS (
SELECT grade, Count(*) AS c FROM teachers
JOIN list ON teachers.classroom = list.classroom
WHERE LastName like "A%" 
OR LastName like "B%" 
OR LastName like "C%"
GROUP BY grade
)
SELECT * FROM a
WHERE c = 
(SELECT MAX(c) from a)
;


USE `STUDENTS`;
-- STUDENTS-3
-- Find all classrooms which have fewer students in them than the average number of students in a classroom in the school. Report the classroom numbers and the number of student in each classroom. Sort in ascending order by classroom.
WITH a AS 
(SELECT teachers.classroom, Count(*) AS c FROM teachers
JOIN list ON teachers.classroom = list.classroom
GROUP BY teachers.classroom)
SELECT * FROM a
WHERE c < (SELECT AVG(c) FROM a)
;


USE `STUDENTS`;
-- STUDENTS-4
-- Find all pairs of classrooms with the same number of students in them. Report each pair only once. Report both classrooms and the number of students. Sort output in ascending order by the number of students in the classroom.
WITH a AS (
SELECT teachers.classroom, Count(*) AS s from teachers
JOIN list ON teachers.classroom = list.classroom
GROUP BY teachers.classroom)

SELECT a1.classroom, a2.classroom, a1.s FROM a as a1
JOIN a AS a2
ON a1.classroom < a2.classroom
AND a1.s = a2.s
ORDER BY a1.s;


USE `STUDENTS`;
-- STUDENTS-5
-- For each grade with more than one classroom, report the grade and the last name of the teacher who teaches the classroom with the largest number of students in the grade. Output results in ascending order by grade.
WITH a AS
(SELECT grade, teachers.last, COUNT(*) as s FROM teachers
JOIN list ON teachers.classroom = list.classroom
GROUP BY teachers.last, grade),

b AS
(SELECT grade, COUNT(DISTINCT teachers.classroom) AS cnt FROM teachers
JOIN list on teachers.classroom = list.classroom
GROUP BY grade),

c AS
(SELECT * FROM a 
WHERE grade in 
(SELECT grade from b WHERE cnt > 1))

SELECT grade, last FROM c AS c1
WHERE s =
(SELECT MAX(s) FROM c AS c2
WHERE c1.grade = c2.grade)
ORDER BY grade
;


USE `CSU`;
-- CSU-1
-- Find the campus(es) with the largest enrollment in 2000. Output the name of the campus and the enrollment. Sort by campus name.

SELECT Campus, Enrolled FROM enrollments
JOIN campuses ON Id = CampusId
WHERE enrollments.year = 2000
AND Enrolled = 
(SELECT MAX(Enrolled) FROM enrollments
WHERE Year = 2000)
;


USE `CSU`;
-- CSU-2
-- Find the university (or universities) that granted the highest average number of degrees per year over its entire recorded history. Report the name of the university, sorted alphabetically.

WITH a as
(SELECT Campus, SUM(degrees) as s FROM degrees
JOIN campuses on CampusId = Id
GROUP BY CampusId)

SELECT Campus FROM a
WHERE s = (SELECT MAX(s) FROM a)
;


USE `CSU`;
-- CSU-3
-- Find the university with the lowest student-to-faculty ratio in 2003. Report the name of the campus and the student-to-faculty ratio, rounded to one decimal place. Use FTE numbers for enrollment. In case of tie, sort by campus name.
WITH a AS
(SELECT Campus, enrollments.FTE / faculty.FTE AS s FROM campuses
JOIN faculty ON Id = faculty.CampusId
JOIN enrollments ON Id = enrollments.CampusId
AND faculty.Year = enrollments.Year
WHERE enrollments.Year = 2003)

SELECT Campus, Round(s,1) FROM a
WHERE s = (SELECT MIN(s) FROM a)
;


USE `CSU`;
-- CSU-4
-- Among undergraduates studying 'Computer and Info. Sciences' in the year 2004, find the university with the highest percentage of these students (base percentages on the total from the enrollments table). Output the name of the campus and the percent of these undergraduate students on campus. In case of tie, sort by campus name.
WITH a AS 
(SELECT Campus,
ROUND(discEnr.Ug / enrollments.Enrolled * 100, 1) AS s
FROM campuses 
JOIN discEnr on campuses.Id = discEnr.CampusId
JOIN enrollments on campuses.Id = enrollments.CampusId
JOIN disciplines on disciplines.Id = Discipline
WHERE Name = 'Computer and Info. Sciences'
AND enrollments.Year = 2004)

SELECT Campus, s FROM a
WHERE s = (SELECT MAX(s) FROM a)
;


USE `CSU`;
-- CSU-5
-- For each year between 1997 and 2003 (inclusive) find the university with the highest ratio of total degrees granted to total enrollment (use enrollment numbers). Report the year, the name of the campuses, and the ratio. List in chronological order.
WITH a AS (
SELECT enrollments.Year, Campus, degrees / Enrolled AS s FROM degrees
JOIN campuses ON ID = degrees.CampusId
JOIN enrollments ON Id = enrollments.CampusId
AND degrees.year = enrollments.year
WHERE degrees.year <= 2003 AND degrees.year >= 1997
AND enrollments.year <= 2003 AND enrollments.year >= 1997)

SELECT * FROM a AS a1
WHERE s = 
(SELECT MAX(s) from a AS a2
WHERE a1.Year = a2.Year)
ORDER BY Year
;


USE `CSU`;
-- CSU-6
-- For each campus report the year of the highest student-to-faculty ratio, together with the ratio itself. Sort output in alphabetical order by campus name. Use FTE numbers to compute ratios and round to two decimal places.
WITH a AS
(SELECT Campus, faculty.Year, 
ROUND(MAX(enrollments.FTE / faculty.FTE), 2) as r FROM campuses
JOIN enrollments ON Id = enrollments.CampusId
JOIN faculty ON Id = faculty.CampusId
AND faculty.Year = enrollments.Year
GROUP BY Campus, faculty.Year)
SELECT * FROM a AS a1
WHERE r = (SELECT MAX(r) FROM a AS a2
WHERE a2.Campus = a1.Campus)
ORDER BY a1.Campus
;


USE `CSU`;
-- CSU-7
-- For each year for which the data is available, report the total number of campuses in which student-to-faculty ratio became worse (i.e. more students per faculty) as compared to the previous year. Report in chronological order.

WITH a AS
(SELECT Campus, faculty.Year, 
ROUND(MAX(enrollments.FTE / faculty.FTE), 2) as r FROM campuses
JOIN enrollments ON Id = enrollments.CampusId
JOIN faculty ON Id = faculty.CampusId
AND faculty.Year = enrollments.Year
GROUP BY Campus, faculty.Year)
SELECT Year + 1, COUNT(*) FROM a AS a1
WHERE r < (SELECT MAX(r) FROM a AS a2
WHERE a2.Campus = a1.Campus 
AND a2.Year = a1.Year + 1)
GROUP BY Year
ORDER BY Year
;


USE `MARATHON`;
-- MARATHON-1
-- Find the state(s) with the largest number of participants. List state code(s) sorted alphabetically.

WITH a AS
(SELECT State, Count(*) AS c FROM marathon
GROUP BY State)
SELECT State FROM a
WHERE c = (SELECT MAX(c) FROM a)
ORDER BY State
;


USE `MARATHON`;
-- MARATHON-2
-- Find all towns in Rhode Island (RI) which fielded more female runners than male runners for the race. Include only those towns that fielded at least 1 male runner and at least 1 female runner. Report the names of towns, sorted alphabetically.

WITH a AS
(SELECT Town, COUNT(*) AS c FROM marathon
WHERE Sex = 'F'
AND State = 'RI' 
GROUP BY Town),

b AS
(SELECT Town, COUNT(*) AS c FROM marathon
WHERE Sex = 'M'
AND State = 'RI' 
GROUP BY Town)

SELECT b.Town FROM b
JOIN a ON a.Town = b.Town
WHERE a.c > b.c
ORDER BY b.Town
;


USE `MARATHON`;
-- MARATHON-3
-- For each state, report the gender-age group with the largest number of participants. Output state, age group, gender, and the number of runners in the group. Report only information for the states where the largest number of participants in a gender-age group is greater than one. Sort in ascending order by state code, age group, then gender.
WITH a AS
(SELECT State, AgeGroup, Sex, COUNT(*) AS c FROM marathon
GROUP BY State, AgeGroup, Sex)

SELECT * FROM a AS a1
WHERE c = (SELECT MAX(c) FROM a AS a2 
WHERE a1.State = a2.State)
AND c > 1
ORDER BY State, AgeGroup, Sex
;


USE `MARATHON`;
-- MARATHON-4
-- Find the 30th fastest female runner. Report her overall place in the race, first name, and last name. This must be done using a single SQL query (which may be nested) that DOES NOT use the LIMIT clause. Think carefully about what it means for a row to represent the 30th fastest (female) runner.
SELECT Place, FirstName, LastName FROM marathon marathon1
WHERE sex = 'F'
AND 
(SELECT Count(*) FROM marathon marathon2
WHERE sex = 'F' AND marathon1.Place > marathon2.Place
) = 29
GROUP BY Place
;


USE `MARATHON`;
-- MARATHON-5
-- For each town in Connecticut report the total number of male and the total number of female runners. Both numbers shall be reported on the same line. If no runners of a given gender from the town participated in the marathon, report 0. Sort by number of total runners from each town (in descending order) then by town.

WITH a AS
(SELECT Town, COUNT(*) AS c FROM marathon
WHERE Sex = 'F'
AND State = 'CT' 
GROUP BY Town),

b AS
(SELECT Town, COUNT(*) AS c FROM marathon
WHERE Sex = 'M'
AND State = 'CT' 
GROUP BY Town),

c AS
(SELECT Town FROM marathon
WHERE State = 'CT' 
GROUP BY Town)

SELECT c.Town, IFNULL(b.c, 0), IFNULL(a.c, 0) FROM c
LEFT JOIN b ON c.Town = b.Town
LEFT JOIN a ON c.Town = a.Town
ORDER BY (IFNULL(b.c, 0) + IFNULL(a.c, 0)) DESC, Town
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report the first name of the performer who never played accordion.

SELECT Firstname FROM Band 
WHERE Id NOT IN 
(SELECT Bandmate FROM Instruments
WHERE Instrument = 'accordion')
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report, in alphabetical order, the titles of all instrumental compositions performed by Katzenjammer ("instrumental composition" means no vocals).

SELECT Title FROM Songs
WHERE SongId NOT IN 
(SELECT Song FROM Vocals)
ORDER BY Title
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- Report the title(s) of the song(s) that involved the largest number of different instruments played (if multiple songs, report the titles in alphabetical order).
WITH a AS 
(SELECT Title, COUNT(Instrument) AS c, Song FROM Songs
JOIN Instruments ON Song = SongId
GROUP BY Song
)
SELECT Title FROM a
WHERE c = (SELECT MAX(c) FROM a)
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find the favorite instrument of each performer. Report the first name of the performer, the name of the instrument, and the number of songs on which the performer played that instrument. Sort in alphabetical order by the first name, then instrument.

WITH a AS
(SELECT FirstName, Id, Instrument, COUNT(*) AS c FROM Band
JOIN Instruments on Bandmate = Id
GROUP BY Id, Instrument)

SELECT a1.FirstName, a1.Instrument, c FROM a AS a1
WHERE c = (SELECT MAX(c) FROM a AS a2
WHERE a1.Id = a2.Id)
ORDER BY FirstName, Instrument
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments played ONLY by Anne-Marit. Report instrument names in alphabetical order.
WITH a AS
(SELECT Instrument FROM Band
JOIN Instruments ON Bandmate = Id
WHERE Firstname = 'Anne-Marit')

SELECT * FROM a
WHERE Instrument NOT IN 
(SELECT Instrument FROM Band
JOIN Instruments ON Bandmate = Id
WHERE Firstname <> 'Anne-Marit')
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Report, in alphabetical order, the first name(s) of the performer(s) who played the largest number of different instruments.

WITH a AS
(SELECT FirstName, Id, COUNT(DISTINCT Instrument) AS c FROM Band
JOIN Instruments on Bandmate = Id
GROUP BY Id)
SELECT Firstname FROM a
WHERE c = (SELECT MAX(c) FROM a)
ORDER BY Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Which instrument(s) was/were played on the largest number of songs? Report just the names of the instruments, sorted alphabetically (note, you are counting number of songs on which an instrument was played, make sure to not count two different performers playing same instrument on the same song twice).
WITH a AS
(SELECT Instrument, COUNT(Song) as c FROM Instruments
JOIN Songs on SongId = Song
GROUP BY Instrument)
SELECT Instrument FROM a
WHERE c = (SELECT MAX(c) FROM a);


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Who spent the most time performing in the center of the stage (in terms of number of songs on which she was positioned there)? Return just the first name of the performer(s), sorted in alphabetical order.

WITH a AS
(SELECT COUNT(*) AS c, Bandmate, Firstname FROM Performance
JOIN Band ON Id = Bandmate
WHERE StagePosition = 'center'
GROUP BY Bandmate)
SELECT Firstname FROM a 
WHERE c = (SELECT MAX(c) FROM a)
ORDER BY Firstname
;


