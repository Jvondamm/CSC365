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
CREATE TRIGGER constraint BEFORE INSERT ON goods
FOR EACH ROW BEGIN
        DECLARE tempflavor varchar(100);
        DECLARE tempfood varchar(100);
        DECLARE tempdate DATE;
        
        SELECT Flavor into tempflavor from goods where goods.GId = new.Item;
        SELECT Food into tempfood from goods where goods.GId = new.Item;
        SELECT SaleDate INTO tempdate from receipts where receipts.RNumber = NEW.Receipt;
        
        if (tempflavor = "Almond" and tempfood = "Meringues") and (DAYOFWEEK(tempdate)=1 or DAYOFWEEK(tempdate)=7) then
            SIGNAL SQLSTATE '45000'
            set message_text 'No sale of Meringues of any flavor and all ALmond-falvored items on Saturdays and Sundays'
        end if;
    end;

-- AIRLINES-1
create trigger constraint before insert on flights
for each row 
begin
    if(new.SourceAirport = new.DestAirport) then
        SIGNAL SQLSTATE '45000'
        set message_text 'SourceAirport and DestAirport must not be the same';
    end if;
end;

-- AIRLINES-2
ALTER TABLE airlines
    DROP COLUMN Partner;

ALTER TABLE airlines 
ADD Partner varchar(100) UNIQUE NOT NULL FOREIGN KEY REFERENCES airlines(Abbreviation);

UPDATE airlines
SET Partner = "JetBlue"
WHERE Abbreviation = "SouthWest";

UPDATE airlines
SET Partner = "SouthWest"
WHERE Abbreviation = "JetBlue";

create trigger constraint before insert on airlines
    for each row
    begin
        if (new.Partner = new.Abbreviation) then
            SIGNAL SQLSTATE '45000'
            set message_text 'Partner cannot be yourself';
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