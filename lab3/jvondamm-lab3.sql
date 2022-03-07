-- BAKERY-1
UPDATE goods SET price = price - 2 WHERE FOOD = 'Cake' AND FLAVOR = 'Lemon' OR FLAVOR = 'Napoleon';

-- BAKERY-2
UPDATE goods SET price = price + (price * .15) WHERE PRICE < 5.95 AND (FLAVOR = 'Apricot' OR FLAVOR = 'Chocolate');

-- BAKERY-3
DROP TABLE IF EXISTS payments;

CREATE TABLE payments (
Receipt char(5),
Amount DECIMAL(5,2),
PaymentSettled DATETIME,
PaymentType varchar(100),
foreign key (Receipt) references receipts(RNumber),
primary key (Receipt, Amount)
);

-- BAKERY-4
DROP TRIGGER IF EXISTS constraint_weekends;

CREATE TRIGGER constraint_weekends
BEFORE INSERT ON items
FOR EACH ROW BEGIN
    DECLARE tempflavor varchar(100);
    DECLARE tempfood varchar(100);
    DECLARE tempdate DATE;
    SELECT Flavor into tempflavor from goods where GId = new.Item;
    SELECT Food into tempfood from goods where GId = new.Item;
    SELECT SaleDate INTO tempdate from receipts where receipts.RNumber = new.Receipt;
    if ((tempflavor = "Almond" or tempfood = "Meringue") and (DAYOFWEEK(tempdate)=1 or DAYOFWEEK(tempdate)=7)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'No sale of Meringues of any flavor and all ALmond-flavored items on Saturdays and Sundays';
    end if;
END;

-- AIRLINES-1
DROP TRIGGER IF EXISTS constraint_airlines;

CREATE TRIGGER constraint_airlines
BEFORE INSERT ON flights
FOR EACH ROW BEGIN
    if(new.SourceAirport = new.DestAirport) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SourceAirport and DestAirport must not be the same';
    end if;
end;

-- AIRLINES-2
DROP TRIGGER IF EXISTS constraint_airlines2;

ALTER TABLE airlines DROP COLUMN Partner;

ALTER TABLE airlines
ADD Partner varchar(100) UNIQUE;

ALTER TABLE airlines
ADD FOREIGN KEY (Partner) REFERENCES airlines(Abbreviation);

UPDATE airlines
SET Partner = "JetBlue"
WHERE Abbreviation = "SouthWest";

UPDATE airlines
SET Partner = "Southwest"
WHERE Abbreviation = "JetBlue";

CREATE TRIGGER constraint_airlines2
BEFORE INSERT ON airlines
FOR EACH ROW BEGIN
        if (new.Partner = new.Abbreviation) then
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Partner cannot be yourself';
        end if;
end;

-- KATZENJAMMER-1
update Instruments
set Instrumnt
where Instrument = 'bass balalaika'
set Instrument = 'awesome bass balalaika';

update Instruments
set Instrumnt
where Instrument = 'guitar'
set Instrument = 'acoustic guitar';

-- KATZENJAMMER-2
DELETE FROM Vocals
WHERE !((Bandmate = 1) and (Type = 'chorus'));