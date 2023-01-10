DROP TABLE echipa;
CREATE TABLE echipa(
    team_id number(5) PRIMARY KEY,
    nume_echipa varchar2(30) NOT NULL,
    data_infiintare date default '01-01-2022',
    group_id number(5) NOT NULL
);

DROP TABLE sponsor;
CREATE TABLE sponsor(
    sponsor_id number(5) PRIMARY KEY,
    nume_sponsor varchar2(30) NOT NULL,
    suma_sponsorizata number(8) NOT NULL
);

DROP TABLE jucator;
CREATE TABLE jucator(
    player_id number(5) PRIMARY KEY,
    nume_prenume varchar2(30) NOT NULL,
    an_studii number(3),
    domeniu_id number(5),
    data_nasterii date NOT NULL,
    team_id number(5) NOT NULL
);

DROP TABLE sponsorizeaza;
CREATE TABLE sponsorizeaza(
    team_id number(5) NOT NULL,
    sponsor_id number(5) NOT NULL,
    CONSTRAINT sponsorizeaza_id PRIMARY KEY(team_id, sponsor_id)
);


DROP TABLE joaca;
CREATE TABLE joaca(
    team_id number(5) NOT NULL,
    match_id number(5) NOT NULL,
    CONSTRAINT joaca_id PRIMARY KEY(team_id, match_id)
);

DROP TABLE antrenor;
CREATE TABLE antrenor(
    coach_id number(5) PRIMARY KEY,
    team_id number(5) NOT NULL,
    experienta number(3) NOT NULL,
    nume varchar2(30) NOT NULL,
    CONSTRAINT team_fk FOREIGN KEY (team_id) REFERENCES echipa(team_id)
);

DROP TABLE meci;
CREATE TABLE meci(
    match_id number(5) PRIMARY KEY,
    ora_incepere varchar(10) NOT NULL,
    spectatori number(10) NOT NULL,
    commentator_id number(5) NOT NULL,
    referee_id number(5) NOT NULL,
    field_id number(5) NOT NULL
);

DROP TABLE arbitru;
CREATE TABLE arbitru(
    referee_id number(5) PRIMARY KEY,
    nume varchar2(30) NOT NULL,
    varsta number(3) NOT NULL
);

DROP TABLE comentator;
CREATE TABLE comentator(
    commentator_id number(5) PRIMARY KEY,
    nume varchar2(30) NOT NULL,
    experienta number(3) NOT NULL
);

DROP TABLE teren;
CREATE TABLE teren(
    field_id number(5) PRIMARY KEY,
    nume varchar2(30) NOT NULL,
    capacitate number(10) NOT NULL
);

DROP TABLE grupa;
CREATE TABLE grupa(
    group_id number(5) PRIMARY KEY,
    nume varchar2(30) NOT NULL
);

DROP TABLE domeniu;
CREATE TABLE domeniu(
    domeniu_id number(5) PRIMARY KEY,
    nume varchar2(30) NOT NULL
);

DROP TABLE capitan;
CREATE TABLE capitan(
    player_id number(5) NOT NULL REFERENCES jucator(player_id),
    team_id number(5) not null
);