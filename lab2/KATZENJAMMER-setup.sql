DROP TABLE IF EXISTS Vocals;
DROP TABLE IF EXISTS Tracklists;
DROP TABLE IF EXISTS Performance;
DROP TABLE IF EXISTS Instruments;
DROP TABLE IF EXISTS Songs;
DROP TABLE IF EXISTS Albums;
DROP TABLE IF EXISTS Band;

CREATE TABLE Songs (
SongId char(2) unique,
Title varchar(100)
);

CREATE TABLE Band (
Id varchar(1) unique,
Firstname varchar(100),
Lastname varchar(100)
);

CREATE TABLE Albums (
AId char(1) unique,
Title varchar(100),
Year char(4),
Label varchar(100),
Type varchar(100)
);

CREATE TABLE Performance (
SongId char(2),
Bandmate char(1),
StagePosition varchar(100),
primary key (SongId, Bandmate),
foreign key (SongId) references Songs(SongId),
foreign key (Bandmate) references Band(Id)
);

CREATE TABLE Instruments (
SongId char(2),
BandmateId char(1),
Instrument varchar(100),
primary key (SongID, BandmateId, Instrument),
foreign key (SongId) references Songs(SongId),
foreign key (BandmateId) references Band(Id)
);

CREATE TABLE Tracklists (
AlbumId char(1),
Position varchar(100),
SongId char(2),
foreign key (SongId) references Songs(SongId),
foreign key (AlbumId) references Albums(AId)
);

CREATE TABLE Vocals (
SongId char(2),
Bandmate char(1),
Type varchar(100),
foreign key (SongId) references Songs(SongId),
foreign key (Bandmate) references Band(Id)
);