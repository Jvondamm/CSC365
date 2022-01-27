DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS airlines;

CREATE TABLE airlines (
Id char(3) primary key,
Airline varchar(100) unique,
Abbreviation varchar(100) unique,
Country varchar(100)
);

CREATE TABLE airports (
City varchar(100),
AirportCode varchar(4) unique,
AirportName varchar(100),
Country varchar(100),
CountryAbbrev varchar(3)
);

CREATE TABLE flights (
Airline char(3),
FlightNo varchar(10),
SourceAirport varchar(4) NOT NULL,
DestAirport varchar(4) NOT NULL,
primary key (Airline, FlightNo),
foreign key (SourceAirport) references airports(AirportCode),
foreign key (DestAirport) references airports(AirportCode),
foreign key (Airline) references airlines(Id)
);