-- Lab 5
-- jvondamm
-- Feb 16, 2022

USE `AIRLINES`;
-- AIRLINES-1
-- Find all airports with exactly 17 outgoing flights. Report airport code and the full name of the airport sorted in alphabetical order by the code.
SELECT Code, Name FROM airports 
JOIN flights ON Source = Code
GROUP BY Source 
HAVING count(Source) = 17
ORDER BY Code;


USE `AIRLINES`;
-- AIRLINES-2
-- Find the number of airports from which airport ANP can be reached with exactly one transfer. Make sure to exclude ANP itself from the count. Report just the number.
Select count(DISTINCT flights.Source) FROM flights
JOIN flights as f2
WHERE flights.Source != "ANP"
AND f2.Destination = "ANP"
AND flights.Destination = f2.Source
;


USE `AIRLINES`;
-- AIRLINES-3
-- Find the number of airports from which airport ATE can be reached with at most one transfer. Make sure to exclude ATE itself from the count. Report just the number.
SELECT COUNT(DISTINCT flights.Source) FROM flights
JOIN flights as f2
WHERE flights.Source != "ATE"
AND f2.Destination = "ATE"
AND flights.Destination = f2.Source 
OR (flights.Destination = "ATE")
;


USE `AIRLINES`;
-- AIRLINES-4
-- For each airline, report the total number of airports from which it has at least one outgoing flight. Report the full name of the airline and the number of airports computed. Report the results sorted by the number of airports in descending order. In case of tie, sort by airline name A-Z.
SELECT Name, COUNT(DISTINCT Source) FROM airlines 
JOIN flights ON Id = Airline
GROUP BY Name
ORDER BY COUNT(DISTINCT Source) DESC, Name
;


USE `BAKERY`;
-- BAKERY-1
-- For each flavor which is found in more than three types of items offered at the bakery, report the flavor, the average price (rounded to the nearest penny) of an item of this flavor, and the total number of different items of this flavor on the menu. Sort the output in ascending order by the average price.
SELECT Flavor,ROUND(AVG(PRICE),2) as Price,
Count(Flavor) from goods
GROUP BY Flavor
HAVING count(goods.Flavor) > 3
ORDER BY Price
;


USE `BAKERY`;
-- BAKERY-2
-- Find the total amount of money the bakery earned in October 2007 from selling eclairs. Report just the amount.
SELECT SUM(PRICE) FROM receipts
JOIN items ON Receipt = RNumber
JOIN goods ON Item = GId
WHERE SaleDate >= '2007-10-01' 
AND SaleDate <= '2007-10-31'
AND Food = 'Eclair'
;


USE `BAKERY`;
-- BAKERY-3
-- For each visit by NATACHA STENZ output the receipt number, sale date, total number of items purchased, and amount paid, rounded to the nearest penny. Sort by the amount paid, greatest to least.
SELECT RNumber,SaleDate, COUNT(SaleDate), ROUND(SUM(PRICE),2) FROM customers
JOIN receipts ON CId = Customer
JOIN items ON Receipt = RNumber
JOIN goods ON Item = GId
WHERE FirstName = 'NATACHA' 
AND LastName = 'STENZ'
GROUP BY SaleDate,RNumber
ORDER BY SUM(Price) DESC
;


USE `BAKERY`;
-- BAKERY-4
-- For the week starting October 8, report the day of the week (Monday through Sunday), the date, total number of purchases (receipts), the total number of pastries purchased, and the overall daily revenue rounded to the nearest penny. Report results in chronological order.
SELECT DayName(SaleDate), SaleDate, COUNT(Distinct RNumber), Count(Customer)as Items,
ROUND(Sum(PRICE),2) FROM receipts
JOIN items on Receipt = RNumber
JOIN goods on Item = GId
WHERE DayOfMonth(SaleDate) >= 8
AND DayOfMonth(SaleDate) <= 14
AND Month(SaleDate) = 10
GROUP BY SaleDate
ORDER BY SaleDate
;


USE `BAKERY`;
-- BAKERY-5
-- Report all dates on which more than ten tarts were purchased, sorted in chronological order.
SELECT SaleDate FROM receipts
JOIN items on Receipt = RNumber
JOIN goods on Item = GId
WHERE Food = 'Tart'
GROUP BY SaleDate
HAVING COUNT(receipts.SaleDate) > 10
;


USE `CSU`;
-- CSU-1
-- For each campus that averaged more than $2,500 in fees between the years 2000 and 2005 (inclusive), report the campus name and total of fees for this six year period. Sort in ascending order by fee.
SELECT campus, SUM(fee) FROM campuses
JOIN fees ON Id = CampusId
WHERE fees.Year <= 2005
AND fees.Year >= 2000
GROUP BY campus
HAVING SUM(fee) / COUNT(campuses.campus) > 2500.0
ORDER BY SUM(fee);


USE `CSU`;
-- CSU-2
-- For each campus for which data exists for more than 60 years, report the campus name along with the average, minimum and maximum enrollment (over all years). Sort your output by average enrollment.
SELECT Campus, AVG(Enrolled), MIN(Enrolled), MAX(Enrolled) FROM campuses
JOIN enrollments ON CampusId = Id
GROUP BY Campus
HAVING COUNT(enrollments.Year) > 60
ORDER BY AVG(Enrolled)
;


USE `CSU`;
-- CSU-3
-- For each campus in LA and Orange counties report the campus name and total number of degrees granted between 1998 and 2002 (inclusive). Sort the output in descending order by the number of degrees.

SELECT Campus, SUM(degrees) FROM campuses 
JOIN degrees ON CampusId = Id
WHERE degrees.year >= 1998 
AND degrees.year <= 2002
AND (County = 'Los Angeles' OR County = 'Orange')
GROUP BY Campus
ORDER BY SUM(degrees) DESC
;


USE `CSU`;
-- CSU-4
-- For each campus that had more than 20,000 enrolled students in 2004, report the campus name and the number of disciplines for which the campus had non-zero graduate enrollment. Sort the output in alphabetical order by the name of the campus. (Exclude campuses that had no graduate enrollment at all.)
SELECT Campus, COUNT(Discipline) FROM campuses
JOIN discEnr ON discEnr.CampusId = Id
JOIN enrollments ON enrollments.CampusId = Id
WHERE Enrolled > 20000
AND enrollments.year = 2004 
AND Gr > 0
GROUP BY Campus
ORDER BY Campus
;


USE `INN`;
-- INN-1
-- For each room, report the full room name, total revenue (number of nights times per-night rate), and the average revenue per stay. In this summary, include only those stays that began in the months of September, October and November of calendar year 2010. Sort output in descending order by total revenue. Output full room names.
SELECT RoomName,
Round(SUM(Rate * DateDiff(CheckOut,CheckIn)),2),
Round(AVG(Rate * DateDiff(CheckOut,CheckIn)),2)
FROM reservations
JOIN rooms ON RoomCode = Room
WHERE Month(CheckIn) >= 9 
AND Month(CheckIn) <= 11
GROUP BY RoomName
ORDER BY SUM(Rate * DateDiff(CheckOut,CheckIn)) DESC
;


USE `INN`;
-- INN-2
-- Report the total number of reservations that began on Fridays, and the total revenue they brought in.
SELECT COUNT(*), Round(SUM(Rate * DateDiff(CheckOut,CheckIn)),2)
FROM reservations
WHERE DayName(CheckIn) = 'Friday'
GROUP BY DayName(CheckIn)
;


USE `INN`;
-- INN-3
-- List each day of the week. For each day, compute the total number of reservations that began on that day, and the total revenue for these reservations. Report days of week as Monday, Tuesday, etc. Order days from Sunday to Saturday.
SELECT DayName(CheckIn), COUNT(reservations.CODE), SUM(Rate * DateDiff(CheckOut,CheckIn))
FROM reservations
GROUP BY DayOfWeek(CheckIn), DayName(CheckIn)
ORDER BY DayOfWeek(CheckIn)
;


USE `INN`;
-- INN-4
-- For each room list full room name and report the highest markup against the base price and the largest markdown (discount). Report markups and markdowns as the signed difference between the base price and the rate. Sort output in descending order beginning with the largest markup. In case of identical markup/down sort by room name A-Z. Report full room names.
SELECT roomname, MAX(Rate - BasePrice), MIN(Rate - BasePrice)
FROM reservations
JOIN rooms ON Room = RoomCode
GROUP BY roomname
ORDER BY MAX(Rate - BasePrice) DESC, roomname
;


USE `INN`;
-- INN-5
-- For each room report how many nights in calendar year 2010 the room was occupied. Report the room code, the full name of the room, and the number of occupied nights. Sort in descending order by occupied nights. (Note: this should be number of nights during 2010. Some reservations extend beyond December 31, 2010. The ”extra” nights in 2011 must be deducted).
SELECT rooms.RoomCode, rooms.RoomName, SUM(DATEDIFF(LEAST(Checkout, "2010-12-31"), GREATEST(CheckIn, "2009-12-31"))) AS DaysOccupied FROM reservations
JOIN rooms ON rooms.RoomCode = reservations.Room
WHERE CheckIn < "2010-12-31" AND CHeckout > "2010-01-01"
GROUP BY RoomCode, RoomName
ORDER BY DaysOccupied DESC
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- For each performer, report first name and how many times she sang lead vocals on a song. Sort output in descending order by the number of leads. In case of tie, sort by performer first name (A-Z.)
SELECT Firstname, Count(Vocals.Song) FROM Vocals
JOIN Band ON Bandmate = Id
WHERE VocalType = 'lead'
GROUP BY Bandmate
ORDER BY Count(*) DESC
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report how many different instruments each performer plays on songs from the album 'Le Pop'. Include performer's first name and the count of different instruments. Sort the output by the first name of the performers.
SELECT Firstname, Count(DISTINCT Instrument) FROM Albums
JOIN Tracklists ON Album = AId
JOIN Songs ON SongId = Tracklists.Song
JOIN Instruments ON SongId = Instruments.Song
JOIN Band ON Bandmate = Band.Id
WHERE Albums.Title = 'Le Pop'
GROUP BY Bandmate
ORDER BY Firstname
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List each stage position along with the number of times Turid stood at each stage position when performing live. Sort output in ascending order of the number of times she performed in each position.

SELECT StagePosition, Count(Performance.Song) FROM Performance 
JOIN Band ON Id = Bandmate 
WHERE Firstname = 'Turid'
GROUP BY StagePosition
ORDER BY Count(Performance.Song)
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Report how many times each performer (other than Anne-Marit) played bass balalaika on the songs where Anne-Marit was positioned on the left side of the stage. List performer first name and a number for each performer. Sort output alphabetically by the name of the performer.

SELECT B2.Firstname, COUNT(Instruments.Instrument) FROM Performance AS P1
JOIN Band AS B1 ON B1.Id = P1.Bandmate
JOIN Performance AS P2
JOIN Band AS B2 ON B2.Id = P2.Bandmate
JOIN Instruments 
ON Instruments.Bandmate = B2.Id 
AND Instruments.Song = P2.Song
WHERE P1.StagePosition = "left" 
AND B1.Firstname = "Anne-Marit"
AND B2.Firstname != "Anne-Marit"
AND P1.Song = P2.Song
AND Instruments.Instrument = "bass balalaika"
GROUP BY B2.Firstname, Instruments.Instrument
ORDER BY B2.Firstname
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Report all instruments (in alphabetical order) that were played by three or more people.
SELECT DISTINCT Instrument FROM Instruments
GROUP BY Instrument
HAVING Count(distinct Bandmate) > 2
ORDER BY Instrument
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- For each performer, list first name and report the number of songs on which they played more than one instrument. Sort output in alphabetical order by first name of the performer
SELECT B.Firstname, COUNT(DISTINCT(I.Song)) FROM Performance 
JOIN Instruments AS I ON I.Song = Performance.Song and I.Bandmate = Performance.Bandmate
JOIN Instruments AS I2 ON I2.Song = Performance.Song and I2.Bandmate = Performance.Bandmate
JOIN Band AS B ON B.Id = I.Bandmate
WHERE I.Instrument != I2.Instrument
GROUP BY B.Firstname;


USE `MARATHON`;
-- MARATHON-1
-- List each age group and gender. For each combination, report total number of runners, the overall place of the best runner and the overall place of the slowest runner. Output result sorted by age group and sorted by gender (F followed by M) within each age group.
SELECT AgeGroup, Sex, COUNT(marathon.Sex), MIN(Place), MAX(Place) FROM marathon
GROUP BY AgeGroup,Sex
ORDER BY AgeGroup,Sex
;


USE `MARATHON`;
-- MARATHON-2
-- Report the total number of gender/age groups for which both the first and the second place runners (within the group) are from the same state.
SELECT count(*) from marathon as m1
JOIN marathon as m2
WHERE m1.State = m2.State
AND m1.GroupPlace = 1
AND m2.GroupPlace = 2
AND m1.AgeGroup = m2.AgeGroup
AND m1.Sex = m2.Sex
;


USE `MARATHON`;
-- MARATHON-3
-- For each full minute, report the total number of runners whose pace was between that number of minutes and the next. In other words: how many runners ran the marathon at a pace between 5 and 6 mins, how many at a pace between 6 and 7 mins, and so on.
SELECT Minute(Pace), Count(marathon.Sex) from marathon
GROUP BY Minute(Pace)
;


USE `MARATHON`;
-- MARATHON-4
-- For each state with runners in the marathon, report the number of runners from the state who finished in top 10 in their gender-age group. If a state did not have runners in top 10, do not output information for that state. Report state code and the number of top 10 runners. Sort in descending order by the number of top 10 runners, then by state A-Z.
SELECT State, Count(*) FROM marathon
WHERE GroupPlace <= 10
GROUP BY State
HAVING Count(*) > 0
ORDER BY Count(*) DESC
;


USE `MARATHON`;
-- MARATHON-5
-- For each Connecticut town with 3 or more participants in the race, report the town name and average time of its runners in the race computed in seconds. Output the results sorted by the average time (lowest average time first).
SELECT Town, ROUND(AVG(TIME_TO_SEC(RunTime)), 1) FROM marathon
WHERE State = 'CT'
GROUP BY Town
HAVING count(*) >= 3
ORDER BY ROUND(AVG(TIME_TO_SEC(RunTime)), 1)
;


USE `STUDENTS`;
-- STUDENTS-1
-- Report the last and first names of teachers who have between seven and eight (inclusive) students in their classrooms. Sort output in alphabetical order by the teacher's last name.
SELECT DISTINCT teachers.last, teachers.first FROM teachers 
JOIN list ON teachers.classroom = list.classroom
GROUP BY teachers.last, teachers.first
HAVING count(teachers.last) >= 7 and count(teachers.last) <= 8
ORDER BY teachers.last;


USE `STUDENTS`;
-- STUDENTS-2
-- For each grade, report the grade, the number of classrooms in which it is taught, and the total number of students in the grade. Sort the output by the number of classrooms in descending order, then by grade in ascending order.

SELECT grade, COUNT(DISTINCT classroom), COUNT(FirstName) FROM list
GROUP BY grade
ORDER BY COUNT(DISTINCT classroom) DESC, grade
;


USE `STUDENTS`;
-- STUDENTS-3
-- For each Kindergarten (grade 0) classroom, report classroom number along with the total number of students in the classroom. Sort output in the descending order by the number of students.
SELECT classroom, COUNT(classroom) AS Count from list
where grade = 0
GROUP BY classroom
ORDER BY Count DESC
;


USE `STUDENTS`;
-- STUDENTS-4
-- For each fourth grade classroom, report the classroom number and the last name of the student who appears last (alphabetically) on the class roster. Sort output by classroom.
select classroom, MAX(lastname) from list
where grade = 4
group by classroom
order by classroom
;


