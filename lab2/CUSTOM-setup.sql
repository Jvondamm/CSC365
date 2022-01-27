DROP TABLE IF EXISTS bond;
DROP TABLE IF EXISTS molecule;
DROP TABLE IF EXISTS atom;

CREATE TABLE atom (
atom_id char(2) primary key,
molecule_id char(4) unique,
element char(1),
type char(2),
charge char(7)
);

CREATE TABLE bond (
atom1_id char(2),
atom2_id char(2),
type char(1),
foreign key (atom1_id) references atom(atom_id),
foreign key (atom2_id) references atom(atom_id)
);

CREATE TABLE molecule (
molecule_id char(4),
ind1 char(1),
inda char(1),
logp char(4),
lumo char(6),
mutagenic char(3),
foreign key (molecule_id) references atom(molecule_id)
);