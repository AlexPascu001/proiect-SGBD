INSERT INTO GRUPA VALUES (1, 'A');
INSERT INTO GRUPA VALUES (2, 'B');
INSERT INTO GRUPA VALUES (3, 'C');
INSERT INTO GRUPA VALUES (4, 'D');
INSERT INTO GRUPA VALUES (5, 'E');
-- select * from GRUPA;


CREATE SEQUENCE id_echipa_seq
START WITH 1
INCREMENT BY 1;

INSERT INTO echipa VALUES(id_echipa_seq.nextval, 'FMI United', TO_DATE('06-09-2019'), 1);
INSERT INTO echipa VALUES(id_echipa_seq.nextval, 'Warriors FC', TO_DATE('30-03-2020'), 2);
INSERT INTO echipa VALUES(id_echipa_seq.nextval, 'Winners Club', TO_DATE('04-04-2021'), 1);
INSERT INTO echipa VALUES(id_echipa_seq.nextval, 'FC ASMI', TO_DATE('01-01-2020'), 2);
INSERT INTO echipa VALUES(id_echipa_seq.nextval, 'Real FMI', TO_DATE('24-10-2020'), 1);
INSERT INTO echipa VALUES(id_echipa_seq.nextval, 'Stiinta FMI', TO_DATE('15-09-2018'), 2);
INSERT INTO echipa VALUES(id_echipa_seq.nextval, 'UniBuc FC', TO_DATE('01-10-2017'), 1);
INSERT INTO echipa VALUES(id_echipa_seq.nextval, 'FC FMI', TO_DATE('01-10-2017'), 2);
-- SELECT * FROM echipa ORDER BY GROUP_ID;


INSERT INTO sponsor VALUES(1, 'Red Bull', 1000);
INSERT INTO sponsor VALUES(2, 'PlayStation', 2500);
INSERT INTO sponsor VALUES(3, 'Coca Cola', 1500);
INSERT INTO sponsor VALUES(4, 'Tesla', 1200);
INSERT INTO sponsor VALUES(5, 'Audi', 2000);
INSERT INTO SPONSOR VALUES (10, 'Samsung', 1000);
-- SELECT * FROM sponsor ORDER BY suma_sponsorizata;


INSERT INTO DOMENIU VALUES(1, 'Informatica');
INSERT INTO DOMENIU VALUES(2, 'Matematica');
INSERT INTO DOMENIU VALUES(3, 'Mate-info');
INSERT INTO DOMENIU VALUES(4, 'Fizica');
INSERT INTO DOMENIU VALUES(5, 'Chimie');
-- SELECT * FROM DOMENIU;


INSERT INTO jucator VALUES(1, 'Alex Pascu', 2, 1, TO_DATE('30-03-2002'), 1);
INSERT INTO jucator VALUES(2, 'Cristiano Ronaldo', 3, 1, TO_DATE('05-02-1985'), 1);
INSERT INTO jucator VALUES(3, 'Lionel Messi', 2, 3, TO_DATE('24-06-1987'), 2);
INSERT INTO jucator VALUES(4, 'Karim Benzema', 2, 1, TO_DATE('19-12-1987'), 3);
INSERT INTO jucator VALUES(5, 'Kylian Mbappe', 2, 1, TO_DATE('20-12-1998'), 4);
INSERT INTO jucator VALUES(6, 'Toni Kroos', 1, 2, TO_DATE('12-03-1994'), 2);
INSERT INTO jucator VALUES(7, 'Neymar Jr', 3, 2, TO_DATE('05-02-1992'), 4);
INSERT INTO jucator VALUES(8, 'Luka Modric', 2, 3, TO_DATE('10-06-2000'), 6);
INSERT INTO jucator VALUES(9, 'Vinicius Jr', 1, 2, TO_DATE('22-11-1999'), 7);
INSERT INTO jucator VALUES(10, 'Andrei Ivan', 3, 2, TO_DATE('08-01-1994'), 5);
INSERT INTO jucator VALUES(11, 'Robert Lewandowski', 2, 2, TO_DATE('21-08-1988'), 8);
INSERT INTO jucator VALUES(12, 'Paul Pogba', 1, 3, TO_DATE('15-03-1993'), 7);
INSERT INTO jucator VALUES(13, 'Sergio Ramos', 1, 1, TO_DATE('30-03-1986'), 5);
INSERT INTO jucator VALUES(14, 'Eden Hazard', 1, 2, TO_DATE('07-01-1991'), 8);
INSERT INTO jucator VALUES(16, 'Luis Suarez', 1, 1, TO_DATE('24-01-1987'), 7);
INSERT INTO jucator VALUES(17, 'Antoine Griezmann', 2, 3, TO_DATE('21-03-1991'), 6);
INSERT INTO jucator VALUES(18, 'Kevin De Bruyne', 1, 3, TO_DATE('28-06-1991'), 2);
INSERT INTO jucator VALUES(19, 'Harry Kane', 2, 2, TO_DATE('28-07-1993'), 4);
INSERT INTO jucator VALUES(20, 'Sadio Mane', 3, 2, TO_DATE('10-04-1992'), 3);
INSERT INTO jucator VALUES(21, 'Robert Trifan', 2, 1, TO_DATE('15-06-1992'), 1);
INSERT INTO jucator VALUES(22, 'Andrei Murica', 2, 1, TO_DATE('08-12-1994'), 1);
-- SELECT * FROM jucator ORDER BY TEAM_ID;


INSERT INTO CAPITAN VALUES(1, 1);
INSERT INTO CAPITAN VALUES(3, 2);
INSERT INTO CAPITAN VALUES(4, 3);
INSERT INTO CAPITAN VALUES(7, 4);
INSERT INTO CAPITAN VALUES(13, 5);
INSERT INTO CAPITAN VALUES(8, 6);
INSERT INTO CAPITAN VALUES(12, 7);
INSERT INTO CAPITAN VALUES(11, 8);
-- SELECT * FROM CAPITAN ORDER BY TEAM_ID;

INSERT INTO sponsorizeaza (team_id, sponsor_id) VALUES(1, 5);
INSERT INTO sponsorizeaza (team_id, sponsor_id) VALUES(1, 2);
INSERT INTO sponsorizeaza (team_id, sponsor_id) VALUES(2, 1);
INSERT INTO sponsorizeaza (team_id, sponsor_id) VALUES(2, 4);
INSERT INTO sponsorizeaza (team_id, sponsor_id) VALUES(3, 5);
INSERT INTO sponsorizeaza (team_id, sponsor_id) VALUES(3, 2);
INSERT INTO sponsorizeaza (team_id, sponsor_id) VALUES(4, 2);
INSERT INTO sponsorizeaza (team_id, sponsor_id) VALUES(4, 1);
INSERT INTO sponsorizeaza (team_id, sponsor_id) VALUES(5, 2);
INSERT INTO sponsorizeaza (team_id, sponsor_id) VALUES(5, 4);
INSERT INTO sponsorizeaza (team_id, sponsor_id) VALUES(6, 1);
INSERT INTO sponsorizeaza (team_id, sponsor_id) VALUES(6, 3);
INSERT INTO sponsorizeaza (team_id, sponsor_id) VALUES(7, 3);
INSERT INTO sponsorizeaza (team_id, sponsor_id) VALUES(7, 4);
-- SELECT * FROM sponsorizeaza;

INSERT INTO COMENTATOR VALUES(1, 'Alexandru Popescu', 1);
INSERT INTO COMENTATOR VALUES(2, 'Mihai Stoica', 2);
INSERT INTO COMENTATOR VALUES(3, 'Andrei Ionescu', 3);
INSERT INTO COMENTATOR VALUES(4, 'Cristian Ionescu', 3);
INSERT INTO COMENTATOR VALUES(5, 'Mihai Popescu', 1);
-- SELECT * FROM comentator;

INSERT INTO ARBITRU VALUES(1, 'Mihai Manea', 30);
INSERT INTO ARBITRU VALUES(2, 'Andrei Stamate', 23);
INSERT INTO ARBITRU VALUES(3, 'Cristian Ciobanu', 34);
INSERT INTO ARBITRU VALUES(4, 'Alexandru Gheorghe', 27);
INSERT INTO ARBITRU VALUES(5, 'Iustin Stoica', 20);
-- SELECT * FROM arbitru;

INSERT INTO TEREN VALUES(1, 'Stadionul National', 5000);
INSERT INTO TEREN VALUES(2, 'Stadionul Olimpic', 4000);
INSERT INTO TEREN VALUES(3, 'Arena Leilor', 8000);
INSERT INTO TEREN VALUES(4, 'Herastrau Park', 6400);
INSERT INTO TEREN VALUES(5, 'Cotroceni Stadium', 7500);
-- SELECT * FROM teren ORDER BY capacitate;

INSERT into MECI VALUES(1, '16:00', 7200, 1, 3, 3);
INSERT into MECI VALUES(2, '18:30', 4500, 4, 2, 4);
INSERT into MECI VALUES(3, '15:00', 5700, 5, 3, 5);
INSERT into MECI VALUES(4, '19:00', 5000, 4, 2, 1);
INSERT into MECI VALUES(5, '17:00', 3700, 3, 1, 2);
INSERT into MECI VALUES(6, '20:00', 5000, 2, 4, 1);
INSERT into MECI VALUES(7, '16:30', 3800, 2, 5, 4);
INSERT into MECI VALUES(8, '18:00', 7000, 1, 4, 5);
-- SELECT * FROM meci ORDER BY ora_inceput;

INSERT INTO joaca (match_id, team_id) VALUES(1, 1);
INSERT INTO joaca (match_id, team_id) VALUES(1, 3);
INSERT INTO joaca (match_id, team_id) VALUES(2, 4);
INSERT INTO joaca (match_id, team_id) VALUES(2, 2);
INSERT INTO joaca (match_id, team_id) VALUES(3, 5);
INSERT INTO joaca (match_id, team_id) VALUES(3, 7);
INSERT INTO joaca (match_id, team_id) VALUES(4, 8);
INSERT INTO joaca (match_id, team_id) VALUES(4, 6);
INSERT INTO joaca (match_id, team_id) VALUES(5, 7);
INSERT INTO joaca (match_id, team_id) VALUES(5, 1);
INSERT INTO joaca (match_id, team_id) VALUES(6, 3);
INSERT INTO joaca (match_id, team_id) VALUES(6, 5);
INSERT INTO joaca (match_id, team_id) VALUES(7, 2);
INSERT INTO joaca (match_id, team_id) VALUES(7, 8);
INSERT INTO joaca (match_id, team_id) VALUES(8, 6);
INSERT INTO joaca (match_id, team_id) VALUES(8, 4);
-- SELECT * FROM joaca ORDER BY match_id;

INSERT INTO antrenor VALUES(1, 1, 3, 'Carlo Ancelotti');
INSERT INTO antrenor VALUES(2, 2, 1, 'Pep Guardiola');
INSERT INTO antrenor VALUES(3, 3, 2, 'Dan Petrescu');
INSERT INTO antrenor VALUES(4, 4, 2, 'Zinedine Zidane');
INSERT INTO antrenor VALUES(5, 5, 2, 'Laurentiu Reghecampf');
INSERT INTO antrenor VALUES(6, 6, 3, 'Gigi Becali');
INSERT INTO antrenor VALUES(7, 7, 1, 'Mihai Rotaru');
INSERT INTO antrenor VALUES(8, 8, 2, 'Andrei Pavel');
-- SELECT * FROM antrenor;
COMMIT;
ROLLBACK;