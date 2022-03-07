-- Lab 4
-- jvondamm
-- Feb 9, 2022

USE `STUDENTS`;
-- STUDENTS-1
-- Find all students who study in classroom 111. For each student list first and last name. Sort the output by the last name of the student.
SELECT FirstName, LastName FROM list WHERE classroom = 111 ORDER BY LastName;


USE `STUDENTS`;
-- STUDENTS-2
-- For each classroom report the grade that is taught in it. Report just the classroom number and the grade number. Sort output by classroom in descending order.
SELECT DISTINCT classroom, grade FROM list ORDER BY classroom DESC;


USE `STUDENTS`;
-- STUDENTS-3
-- Find all teachers who teach fifth grade. Report first and last name of the teachers and the room number. Sort the output by room number.
SELECT DISTINCT teachers.First, teachers.Last, teachers.Classroom FROM teachers 
INNER JOIN list ON teachers.Classroom = list.classroom where grade = 5 ORDER BY classroom;


USE `STUDENTS`;
-- STUDENTS-4
-- Find all students taught by OTHA MOYER. Output first and last names of students sorted in alphabetical order by their last name.
SELECT DISTINCT list.FirstName, list.LastName FROM list
INNER JOIN teachers ON teachers.Classroom = list.classroom where teachers.Last = "MOYER" and teachers.First = "OTHA" ORDER BY LastName;


USE `STUDENTS`;
-- STUDENTS-5
-- For each teacher teaching grades K through 3, report the grade (s)he teaches. Output teacher last name, first name, and grade. Each name has to be reported exactly once. Sort the output by grade and alphabetically by teacher’s last name for each grade.
SELECT DISTINCT teachers.Last, teachers.First, list.grade FROM teachers
INNER JOIN list ON teachers.Classroom = list.classroom where list.grade < 4 ORDER BY list.grade, Last;


USE `BAKERY`;
-- BAKERY-1
-- Find all chocolate-flavored items on the menu whose price is under $5.00. For each item output the flavor, the name (food type) of the item, and the price. Sort your output in descending order by price.
SELECT Flavor, Food, PRICE FROM goods where price < 5.00and Flavor = 'Chocolate' ORDER BY PRICE DESC;


USE `BAKERY`;
-- BAKERY-2
-- Report the prices of the following items (a) any cookie priced above $1.10, (b) any lemon-flavored items, or (c) any apple-flavored item except for the pie. Output the flavor, the name (food type) and the price of each pastry. Sort the output in alphabetical order by the flavor and then pastry name.
SELECT Flavor, Food, PRICE FROM goods WHERE (Food = "Cookie" and PRICE > 1.10) or (Flavor = "Apple" and Food != "Pie") or (Flavor = "Lemon") ORDER BY Flavor, Food;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who made a purchase on October 3, 2007. Report the name of the customer (last, first). Sort the output in alphabetical order by the customer’s last name. Each customer name must appear at most once.
SELECT DISTINCT customers.LastName, customers.FirstName FROM customers INNER JOIN receipts ON receipts.Customer = customers.CId WHERE SaleDate = '2007-10-03' ORDER BY customers.LastName;


USE `BAKERY`;
-- BAKERY-4
-- Find all different cakes purchased on October 4, 2007. Each cake (flavor, food) is to be listed once. Sort output in alphabetical order by the cake flavor.
SELECT DISTINCT goods.Flavor, goods.Food FROM goods INNER JOIN items ON items.Item = goods.GId INNER JOIN receipts ON receipts.RNumber = items.Receipt WHERE receipts.SaleDate = '2007-10-04' and goods.Food = 'Cake' ORDER BY goods.Flavor;


USE `BAKERY`;
-- BAKERY-5
-- List all pastries purchased by ARIANE CRUZEN on October 25, 2007. For each pastry, specify its flavor and type, as well as the price. Output the pastries in the order in which they appear on the receipt (each pastry needs to appear the number of times it was purchased).
SELECT goods.Flavor, goods.Food, goods.PRICE FROM goods INNER JOIN items ON items.Item = goods.GId INNER JOIN receipts ON receipts.RNumber = items.Receipt INNER JOIN customers ON receipts.Customer = customers.CId WHERE receipts.SaleDate = '2007-10-25' and customers.LastName = 'CRUZEN' and customers.FirstName = 'ARIANE';


USE `BAKERY`;
-- BAKERY-6
-- Find all types of cookies purchased by KIP ARNN during the month of October of 2007. Report each cookie type (flavor, food type) exactly once in alphabetical order by flavor.

SELECT DISTINCT goods.Flavor, goods.Food FROM goods INNER JOIN items ON items.Item = goods.GId INNER JOIN receipts ON receipts.RNumber = items.Receipt INNER JOIN customers ON receipts.Customer = customers.CId WHERE receipts.SaleDate like '%2007-10%' and customers.LastName = 'ARNN' and customers.FirstName = 'KIP' and goods.Food = 'Cookie' ORDER BY goods.Flavor;


USE `CSU`;
-- CSU-1
-- Report all campuses from Los Angeles county. Output the full name of campus in alphabetical order.
SELECT Campus FROM campuses WHERE County = 'Los Angeles' ORDER BY Campus;


USE `CSU`;
-- CSU-2
-- For each year between 1994 and 2000 (inclusive) report the number of students who graduated from California Maritime Academy Output the year and the number of degrees granted. Sort output by year.
SELECT year, degrees FROM degrees WHERE CampusID = 11 and year >= 1994 and year <= 2000 ORDER BY year;


USE `CSU`;
-- CSU-3
-- Report undergraduate and graduate enrollments (as two numbers) in ’Mathematics’, ’Engineering’ and ’Computer and Info. Sciences’ disciplines for both Polytechnic universities of the CSU system in 2004. Output the name of the campus, the discipline and the number of graduate and the number of undergraduate students enrolled. Sort output by campus name, and by discipline for each campus.
SELECT campuses.Campus, disciplines.Name, discEnr.Gr, discEnr.Ug FROM discEnr INNER JOIN campuses ON campuses.ID = discEnr.CampusID INNER JOIN disciplines ON disciplines.Id = discEnr.Discipline WHERE (campuses.Id = 14 or campuses.Id = 20) and (disciplines.Name ='Computer and Info. Sciences' or disciplines.Name = 'Mathematics' or disciplines.Name = 'Engineering') ORDER BY campuses.Campus, disciplines.Name;


USE `CSU`;
-- CSU-4
-- Report graduate enrollments in 2004 in ’Agriculture’ and ’Biological Sciences’ for any university that offers graduate studies in both disciplines. Report one line per university (with the two grad. enrollment numbers in separate columns), sort universities in descending order by the number of ’Agriculture’ graduate students.
SELECT DISTINCT campuses.Campus, discEnr.Gr, discEnr2.Gr FROM campuses INNER JOIN discEnr ON campuses.Id = discEnr.CampusId CROSS JOIN discEnr as discEnr2 WHERE discEnr.Discipline = 1 and discEnr2.Discipline = 4 and discEnr.CampusId = discEnr2.CampusId and discEnr.Year = discEnr2.Year and discEnr.Gr > 0 ORDER BY discEnr.Gr DESC;


USE `CSU`;
-- CSU-5
-- Find all disciplines and campuses where graduate enrollment in 2004 was at least three times higher than undergraduate enrollment. Report campus names, discipline names, and both enrollment counts. Sort output by campus name, then by discipline name in alphabetical order.
SELECT campuses.Campus, disciplines.Name, discEnr.Ug, discEnr.Gr FROM disciplines JOIN discEnr
ON disciplines.Id = discEnr.Discipline JOIN campuses ON campuses.Id = discEnr.CampusId WHERE discEnr.Gr / 3 > discEnr.Ug AND discEnr.Year = 2004 ORDER BY campuses.Campus, disciplines.Name;


USE `CSU`;
-- CSU-6
-- Report the amount of money collected from student fees (use the full-time equivalent enrollment for computations) at ’Fresno State University’ for each year between 2002 and 2004 inclusively, and the amount of money (rounded to the nearest penny) collected from student fees per each full-time equivalent faculty. Output the year, the two computed numbers sorted chronologically by year.
SELECT fees.year,enrollments.FTE * fee AS COLLECTED,ROUND((enrollments.FTE * fee) / faculty.FTE, 2)  FROM fees
JOIN campuses ON fees.CampusId = Id
JOIN faculty ON faculty.CampusId = Id AND faculty.year = fees.year
JOIN enrollments ON enrollments.year = fees.year AND enrollments.CampusId = Id
WHERE fees.year <= 2004 AND fees.year >= 2002
AND campus = 'Fresno State University';


USE `CSU`;
-- CSU-7
-- Find all campuses where enrollment in 2003 (use the FTE numbers), was higher than the 2003 enrollment in ’San Jose State University’. Report the name of campus, the 2003 enrollment number, the number of faculty teaching that year, and the student-to-faculty ratio, rounded to one decimal place. Sort output in ascending order by student-to-faculty ratio.
SELECT DISTINCT campuses.Campus, enrollments.FTE, faculty.FTE, ROUND(enrollments.FTE/ faculty.FTE, 1) AS RATIO 
FROM enrollments 
JOIN campuses ON campuses.Id = enrollments.CampusId 
JOIN faculty ON faculty.CampusId = Id 
JOIN enrollments as enrollments2 
JOIN campuses as campuses2 ON campuses2.Id = enrollments2.CampusId 
WHERE enrollments.year = 2003 
AND faculty.Year = 2003
AND enrollments2.year = 2003
AND enrollments.FTE > enrollments2.FTE 
AND campuses2.campus = 'San Jose State University' 
ORDER BY RATIO;


USE `INN`;
-- INN-1
-- Find all modern rooms with a base price below $160 and two beds. Report room code and full room name, in alphabetical order by the code.
SELECT RoomCode,RoomName FROM rooms WHERE basePrice < 160 AND beds = 2 AND decor = 'modern' ORDER BY RoomCode;


USE `INN`;
-- INN-2
-- Find all July 2010 reservations (a.k.a., all reservations that both start AND end during July 2010) for the ’Convoke and sanguine’ room. For each reservation report the last name of the person who reserved it, checkin and checkout dates, the total number of people staying and the daily rate. Output reservations in chronological order.
SELECT reservations.Lastname, reservations.CheckIn, reservations.Checkout, reservations.Adults + reservations.Kids AS Guests, reservations.Rate FROM reservations JOIN rooms on reservations.Room = rooms.RoomCode WHERE reservations.CheckIn >= '2010-07-01' AND reservations.CheckOut <= '2010-07-31' AND rooms.RoomName = 'Convoke and sanguine' ORDER BY reservations.CheckIn;


USE `INN`;
-- INN-3
-- Find all rooms occupied on February 6, 2010. Report full name of the room, the check-in and checkout dates of the reservation. Sort output in alphabetical order by room name.
SELECT RoomName,CheckIn,CheckOut FROM reservations JOIN rooms ON Room = RoomCode WHERE CheckIn <= '2010-02-06' AND CheckOut > '2010-02-06' ORDER BY RoomName;


USE `INN`;
-- INN-4
-- For each stay by GRANT KNERIEN in the hotel, calculate the total amount of money, he paid. Report reservation code, room name (full), checkin and checkout dates, and the total stay cost. Sort output in chronological order by the day of arrival.

SELECT code,RoomName,CheckIn,CheckOut,DATEDIFF(CheckOut, CheckIn) * Rate AS PAID FROM reservations JOIN rooms ON Room = RoomCode WHERE FirstName = 'GRANT' AND LastName = 'KNERIEN' ORDER BY CheckIn;


USE `INN`;
-- INN-5
-- For each reservation that starts on December 31, 2010 report the room name, nightly rate, number of nights spent and the total amount of money paid. Sort output in descending order by the number of nights stayed.
SELECT rooms.RoomName, reservations.Rate, DATEDIFF(reservations.CheckOut, reservations.CheckIn) AS Nights, DATEDIFF(reservations.CheckOut, reservations.CheckIn) * Rate AS Money FROM reservations
JOIN rooms ON reservations.Room = rooms.RoomCode WHERE reservations.CheckIn = '2010-12-31' ORDER BY NIGHTS DESC;


USE `INN`;
-- INN-6
-- Report all reservations in rooms with double beds that contained four adults. For each reservation report its code, the room abbreviation, full name of the room, check-in and check out dates. Report reservations in chronological order, then sorted by the three-letter room code (in alphabetical order) for any reservations that began on the same day.
SELECT reservations.CODE, reservations.Room, rooms.RoomName, reservations.CheckIn, reservations.CheckOut FROM reservations JOIN rooms ON reservations.Room = rooms.RoomCode WHERE rooms.bedType = 'Double' AND reservations.Adults = 4 ORDER BY reservations.CheckIn, rooms.RoomCode;


USE `MARATHON`;
-- MARATHON-1
-- Report the overall place, running time, and pace of TEDDY BRASEL.
SELECT Place, RunTime, Pace FROM marathon WHERE FirstName = 'TEDDY' AND LastName = 'BRASEL';


USE `MARATHON`;
-- MARATHON-2
-- Report names (first, last), overall place, running time, as well as place within gender-age group for all female runners from QUNICY, MA. Sort output by overall place in the race.
SELECT FirstName, LastName,Place,RunTime,GroupPlace FROM marathon WHERE Town = 'QUNICY' AND State = 'MA' AND Sex = 'F' ORDER BY Place;


USE `MARATHON`;
-- MARATHON-3
-- Find the results for all 34-year old female runners from Connecticut (CT). For each runner, output name (first, last), town and the running time. Sort by time.
SELECT FirstName, LastName, Town, RunTime FROM marathon WHERE Age = 34 AND State = 'CT' AND Sex = 'F';


USE `MARATHON`;
-- MARATHON-4
-- Find all duplicate bibs in the race. Report just the bib numbers. Sort in ascending order of the bib number. Each duplicate bib number must be reported exactly once.
SELECT DISTINCT marathon.BibNumber FROM marathon CROSS JOIN marathon as marathon2 WHERE marathon.BibNumber = marathon2.BibNumber and marathon.FirstName != marathon2.FirstName and marathon.LastName != marathon2.LastName ORDER BY BibNumber;


USE `MARATHON`;
-- MARATHON-5
-- List all runners who took first place and second place in their respective age/gender groups. List gender, age group, name (first, last) and age for both the winner and the runner up (in a single row). Order the output by gender, then by age group.
SELECT marathon.sex, marathon.agegroup, marathon.firstname, marathon.lastname, marathon.age, marathon2.firstname, marathon2.lastname, marathon2.age 
FROM marathon 
JOIN marathon as marathon2 
ON marathon.GroupPlace = 1 
AND marathon2.GroupPlace = 2 
WHERE
marathon.agegroup = marathon2.agegroup
AND marathon.Sex = marathon2.Sex
AND marathon.firstname != marathon2.firstname
AND marathon.lastname != marathon2.lastname
ORDER BY marathon.sex, marathon.AgeGroup;


USE `AIRLINES`;
-- AIRLINES-1
-- Find all airlines that have at least one flight out of AXX airport. Report the full name and the abbreviation of each airline. Report each name only once. Sort the airlines in alphabetical order.
select DISTINCT Name,Abbr from flights JOIN airlines ON Airline = ID WHERE Source = 'AXX' ORDER BY Name;


USE `AIRLINES`;
-- AIRLINES-2
-- Find all destinations served from the AXX airport by Northwest. Re- port flight number, airport code and the full name of the airport. Sort in ascending order by flight number.

SELECT flights.flightno, flights.Destination, airports.Name FROM flights JOIN airlines ON flights.Airline = airlines.Id JOIN airports ON airports.Code = flights.Destination WHERE flights.Source = 'AXX' AND airlines.Name = 'Northwest Airlines' ORDER BY flightno;


USE `AIRLINES`;
-- AIRLINES-3
-- Find all *other* destinations that are accessible from AXX on only Northwest flights with exactly one change-over. Report pairs of flight numbers, airport codes for the final destinations, and full names of the airports sorted in alphabetical order by the airport code.
SELECT flights.FlightNo, flights2.FlightNo, flights2.Destination, airports.Name 
FROM flights 
JOIN flights as flights2 
JOIN airports ON airports.Code = flights2.Destination 
JOIN airlines ON airlines.Id = flights.Airline and airlines.Id = flights2.Airline
AND airlines.Abbr = 'Northwest'
AND flights.Source = 'AXX'
AND flights.Destination = flights2.Source 
AND flights2.Destination != flights.Source
ORDER BY flights.Destination;


USE `AIRLINES`;
-- AIRLINES-4
-- Report all pairs of airports served by both Frontier and JetBlue. Each airport pair must be reported exactly once (if a pair X,Y is reported, then a pair Y,X is redundant and should not be reported).
SELECT flights.Source, flights.Destination FROM flights
JOIN flights AS flights2
JOIN airlines AS airlines2 ON airlines2.id = flights.Airline
JOIN airlines ON airlines.Id = flights2.Airline
WHERE 
airlines.Abbr = 'Frontier'
AND airlines2.Abbr = 'JetBlue'
AND flights.Source = flights2.Source
AND flights.Destination = flights2.Destination
AND flights.FlightNo != flights2.FlightNo
AND flights.Source < flights2.Destination;


USE `AIRLINES`;
-- AIRLINES-5
-- Find all airports served by ALL five of the airlines listed below: Delta, Frontier, USAir, UAL and Southwest. Report just the airport codes, sorted in alphabetical order.
SELECT DISTINCT flights.Source FROM flights 
JOIN flights as flights2 
JOIN flights as flights3
JOIN flights as flights4
JOIN flights as flights5
JOIN airlines ON airlines.Id = flights.Airline
JOIN airlines as airlines2 ON airlines2.Id = flights2.Airline
JOIN airlines as airlines3 ON airlines3.Id = flights3.Airline
JOIN airlines as airlines4 ON airlines4.Id = flights4.Airline
JOIN airlines as airlines5 ON airlines5.Id = flights5.Airline
WHERE airlines.Abbr = 'Delta'
AND airlines2.Abbr = 'Frontier'
AND airlines3.Abbr = 'USAir'
AND airlines4.Abbr = 'UAL'
AND airlines5.Abbr = 'Southwest'
AND flights.Source = flights2.Source
AND flights2.Source = flights3.Source
AND flights3.Source = flights4.Source
AND flights4.Source = flights5.Source
ORDER BY flights.Source;


USE `AIRLINES`;
-- AIRLINES-6
-- Find all airports that are served by at least three Southwest flights. Report just the three-letter codes of the airports — each code exactly once, in alphabetical order.
SELECT DISTINCT flights.Source FROM flights
JOIN flights AS flights2
JOIN flights AS flights3
JOIN airlines ON airlines.Id = flights.Airline
AND airlines.Id = flights2.Airline 
AND airlines.Id = flights3.Airline
WHERE airlines.Abbr = 'Southwest'
AND flights.Source = flights2.Source
AND flights.Source = flights3.Source
AND flights.FlightNo != flights2.FlightNo
AND flights.FLightNo != flights3.FlightNo
AND flights2.FlightNo != flights3.FlightNo
ORDER BY flights.Source
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report, in order, the tracklist for ’Le Pop’. Output just the names of the songs in the order in which they occur on the album.
SELECT Songs.Title from Albums JOIN Tracklists ON AId = Album JOIN Songs ON Song = SongId WHERE Albums.Title = 'Le Pop';


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- List the instruments each performer plays on ’Mother Superior’. Output the first name of each performer and the instrument, sort alphabetically by the first name.
SELECT Band.Firstname, Instruments.Instrument FROM Songs JOIN Instruments ON Instruments.Song = Songs.SongId JOIN Band ON Instruments.Bandmate = Band.Id WHERE Songs.Title = 'Mother Superior' ORDER BY Band.Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List all instruments played by Anne-Marit at least once during the performances. Report the instruments in alphabetical order (each instrument needs to be reported exactly once).
SELECT DISTINCT Instruments.Instrument from Performance JOIN Songs ON Performance.Song = Songs.SongId JOIN Band ON Performance.Bandmate = Band.Id Join Instruments ON Instruments.Song = Songs.SongId AND Instruments.Bandmate = Band.Id WHERE Band.Firstname = 'Anne-Marit' ORDER BY Instruments.Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find all songs that featured ukalele playing (by any of the performers). Report song titles in alphabetical order.
SELECT Title from Songs JOIN Instruments ON Song = SongId WHERE Instrument = 'ukalele' ORDER BY Title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments Turid ever played on the songs where she sang lead vocals. Report the names of instruments in alphabetical order (each instrument needs to be reported exactly once).
SELECT Distinct Instruments.Instrument from Songs JOIN Instruments ON Instruments.Song = Songs.SongId JOIN Band On Band.Id = Instruments.Bandmate JOIN Vocals ON Band.Id = Vocals.Bandmate AND Vocals.Song = Songs.SongId WHERE Band.Firstname = 'Turid' AND Vocals.VocalType = 'lead' ORDER BY Instruments.Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Find all songs where the lead vocalist is not positioned center stage. For each song, report the name, the name of the lead vocalist (first name) and her position on the stage. Output results in alphabetical order by the song, then name of band member. (Note: if a song had more than one lead vocalist, you may see multiple rows returned for that song. This is the expected behavior).
SELECT Songs.Title, Band.Firstname, Performance.StagePosition
FROM Songs
JOIN Performance 
ON Songs.SongId = Performance.Song
JOIN Band 
ON Band.Id = Performance.Bandmate
JOIN Vocals 
ON Vocals.Bandmate = Band.Id AND Vocals.Song = Songs.SongId
WHERE Vocals.VocalType = 'lead' AND Performance.StagePosition <> 'center'
ORDER BY Songs.Title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Find a song on which Anne-Marit played three different instruments. Report the name of the song. (The name of the song shall be reported exactly once)
SELECT DISTINCT Title FROM Songs 
JOIN Instruments ON Instruments.Song = SongId
JOIN Instruments as Instruments2 ON Instruments2.Song = SongId
JOIN Instruments as Instruments3 ON Instruments3.Song = SongId
JOIN Band On Id = Instruments.Bandmate AND Id = Instruments2.Bandmate AND Id = Instruments3.Bandmate
WHERE Firstname = 'Anne-Marit'
AND Instruments.Instrument != Instruments2.Instrument
AND Instruments.Instrument != Instruments3.Instrument
AND Instruments.Song = Instruments2.Song
AND Instruments.Song = Instruments3.Song
;


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Report the positioning of the band during ’A Bar In Amsterdam’. (just one record needs to be returned with four columns (right, center, back, left) containing the first names of the performers who were staged at the specific positions during the song).
SELECT Band.Firstname, Band2.Firstname, Band3.Firstname, Band4.Firstname FROM Performance
JOIN Performance as Performance2
JOIN Performance as Performance3
JOIN Performance as Performance4
JOIN Songs ON Songs.SongId = Performance.Song
JOIN Songs AS Songs2 ON Songs2.SongId = Performance2.Song
JOIN Songs AS Songs3 ON Songs3.SongId = Performance3.Song
JOIN Songs AS Songs4 ON Songs4.SongId = Performance4.Song
JOIN Band ON Band.Id = Performance.Bandmate
JOIN Band AS Band2 ON Band2.Id = Performance2.Bandmate
JOIN Band AS Band3 ON Band3.Id = Performance3.Bandmate
JOIN Band AS Band4 ON Band4.Id = Performance4.Bandmate
WHERE Songs.Title = 'A Bar In Amsterdam'
AND Songs2.Title = 'A Bar In Amsterdam'
AND Songs3.Title = 'A Bar In Amsterdam'
AND Songs4.Title = 'A Bar In Amsterdam'
AND Performance.StagePosition = 'right'
AND Performance2.StagePosition = 'center'
AND Performance3.StagePosition = 'back'
AND Performance4.StagePosition = 'left';


