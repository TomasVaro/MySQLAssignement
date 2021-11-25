drop database if exists GolfCup;
create database GolfCup;
use GolfCup;

create table Spelare(
	PersonNr char(13),
    Namn varchar(20),
    Ålder char(3),
    primary key(PersonNr)
)engine=innodb;

INSERT INTO `Spelare` VALUES (199606017210,'Johan Andersson',25);
INSERT INTO `Spelare` VALUES (196312189436,'Brad Pitt',57);
INSERT INTO `Spelare` VALUES (196409025277,'Keanu Reeves',57);
INSERT INTO `Spelare` VALUES (193704221330,'Jack Nicholson',84);
INSERT INTO `Spelare` VALUES (198907238393,'Daniel Radcliff',32);
INSERT INTO `Spelare` VALUES (199004156060,'Emma Watson',31);
INSERT INTO `Spelare` VALUES (199411071551,'Nicklas Jansson',27);
INSERT INTO `Spelare` VALUES (199510177385,'Annika Persson',26);

create table Tävling(
	Tävlingsnamn varchar(50),
    Datum date not null,
    primary key(Tävlingsnamn)
)engine=innodb;

INSERT INTO `Tävling` VALUES ('Big Golf Cup Skövde', '2021-06-10');
INSERT INTO `Tävling` VALUES ('Seaside Golf Cup Göteborg', '2021-10-02');
INSERT INTO `Tävling` VALUES ('Beginners Golf Cup Kungsbacka', '2021-03-17');

create table Delta(
	Tävlingsnamn varchar(50),
    PersonNr char(13),
    foreign key(Tävlingsnamn) references Tävling(Tävlingsnamn) on delete cascade,
    foreign key(PersonNr) references Spelare(PersonNr) on delete cascade
)engine=innodb;

INSERT INTO `Delta` VALUES ('Big Golf Cup Skövde', '199606017210');
INSERT INTO `Delta` VALUES ('Big Golf Cup Skövde', '199411071551');
INSERT INTO `Delta` VALUES ('Big Golf Cup Skövde', '199510177385');
INSERT INTO `Delta` VALUES ('Seaside Golf Cup Göteborg', '196409025277');
INSERT INTO `Delta` VALUES ('Seaside Golf Cup Göteborg', '199004156060');
INSERT INTO `Delta` VALUES ('Seaside Golf Cup Göteborg', '199411071551');
INSERT INTO `Delta` VALUES ('Beginners Golf Cup Kungsbacka', '199606017210');
INSERT INTO `Delta` VALUES ('Beginners Golf Cup Kungsbacka', '193704221330');
INSERT INTO `Delta` VALUES ('Beginners Golf Cup Kungsbacka', '199510177385');

create table Regn(
	Typ varchar(20),
    Vindstyrka char(3),
    primary key(Typ)
)engine=innodb;

INSERT INTO `Regn` VALUES ('Hagel', '10');
INSERT INTO `Regn` VALUES ('Duggregn', '5');
INSERT INTO `Regn` VALUES ('Ösregn', '15');

create table Har(
	Tävlingsnamn varchar(50),
    Typ varchar(20),
    Tidpunkt time not null,
    foreign key(Tävlingsnamn) references Tävling(Tävlingsnamn) on delete cascade,
    foreign key(Typ) references Regn(Typ) on delete cascade
)engine=innodb;

INSERT INTO `Har` VALUES ('Big Golf Cup Skövde', 'Hagel', '12:31');
INSERT INTO `Har` VALUES ('Seaside Golf Cup Göteborg', 'Duggregn', '15:45');
INSERT INTO `Har` VALUES ('Beginners Golf Cup Kungsbacka', 'Duggregn', '10:00');

create table Jacka(
	Initialer varchar(6),
    Storlek char(3),
    Material varchar(30),
    PersonNr char(13),
    primary key(PersonNr, Initialer),
    foreign key(PersonNr) references Spelare(PersonNr) on delete cascade
)engine=innodb;

INSERT INTO `Jacka` VALUES ('JAF', '52', 'fleece', '199606017210');
INSERT INTO `Jacka` VALUES ('JAG', '51', 'goretex', '199606017210');
INSERT INTO `Jacka` VALUES ('BPG', '51', 'goretex', '196312189436');
INSERT INTO `Jacka` VALUES ('NJF', '52', 'fleece', '199411071551');

create table Konstruktion(
    SerialNr char(15),
    Hårdhet char(3),
    primary key(SerialNr)
)engine=innodb;

INSERT INTO `Konstruktion` VALUES ('1234567', '10');
INSERT INTO `Konstruktion` VALUES ('9876543', '5');
INSERT INTO `Konstruktion` VALUES ('1235987', '7');
INSERT INTO `Konstruktion` VALUES ('9182736', '12');

create table Klubba(
    Nr char(3),
    Material varchar(30),
    PersonNr char(13),
    SerialNr char(15),
    primary key(PersonNr, Nr),
    foreign key(PersonNr) references Spelare(PersonNr) on delete cascade,
    foreign key(SerialNr) references Konstruktion(SerialNr) on delete cascade
)engine=innodb;

INSERT INTO `Klubba` VALUES ('5', 'trä', '199606017210', 1234567);
INSERT INTO `Klubba` VALUES ('4', 'järn', '199606017210', 9182736);
INSERT INTO `Klubba` VALUES ('5', 'trä', '199411071551', 1235987);

#Hämta ålder för spelaren Johan Andersson
select Namn, Ålder from spelare
where Namn="Johan Andersson";

#Hämta datum för tävlingen Big Golf Cup Skövde
select Tävlingsnamn, Datum from tävling
where Tävlingsnamn = "Big Golf Cup Skövde";

#Hämta materialet för Johan Anderssons klubba
select Namn, Material from klubba k, spelare s
where k.PersonNr = s.PersonNr
and s.Namn = "Johan Andersson";

#Hämta alla jackor som tillhör Johan Andersson
select Namn, Material, Storlek, Initialer from jacka j, spelare s
where j.PersonNr = s.PersonNr
and s.Namn = "Johan Andersson";

#Hämta alla spelare som deltog i Big Golf Cup Skövde
select	Namn, Ålder, Tävlingsnamn from delta d, spelare s
where d.PersonNr = s.PersonNr
and d.Tävlingsnamn = "Big Golf Cup Skövde";

#Hämta regnens vindstyrka för Big Golf Cup Skövde
select Tävlingsnamn, Vindstyrka from Har h, regn r
where h.Typ = r.Typ
and Tävlingsnamn = "Big Golf Cup Skövde";

#Hämta alla spelare som är under 30 år
select Namn, Ålder from spelare
where ålder < "30"
order by Ålder asc;

#Ta bort Johan Anderssons jackor
delete from Jacka
where PersonNr in (SELECT PersonNr FROM spelare where Namn = "Johan Andersson");

#Ta bort Nicklas Jansson
delete from spelare
where Namn = "Nicklas Jansson";

#Hämta medelåldern för alla spelare
select avg (Ålder) from spelare;