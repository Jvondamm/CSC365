DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS receipts;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS goods;

CREATE TABLE customers (
CId char(2) unique,
LastName varchar(100),
FirstName varchar(100)
);

CREATE TABLE goods (
GId varchar(100) unique,
Flavor varchar(100),
Food varchar(100),
Price char(5),
primary key (Flavor, Food)
);

CREATE TABLE receipts (
RNumber char(5) unique,
SaleDate DATE,
Customer char(2),
foreign key (Customer) references customers(CId)
);

CREATE TABLE items (
Receipt char(5) NOT NULL,
Ordinal char(1) NOT NULL,
Item varchar(100) NOT NULL,
primary key (Receipt, Ordinal),
foreign key (Item) references goods(GId),
foreign key (Receipt) references receipts(RNumber)
);