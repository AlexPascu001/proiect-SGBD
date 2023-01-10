-- exercitiul 6
-- Afisati toti jucatorii care participa la turneu, apoi doar jucatorii care
-- fac parte din echipa cu un id dat
CREATE OR REPLACE PROCEDURE get_players_from_team(id_echipa IN NUMBER)
IS
    TYPE jucatori is varray(100) of jucator%rowtype;
    v_jucatori jucatori;
    v_jucator jucator%rowtype;
    TYPE toti_jucatorii is table of jucator%rowtype;
    v_toti_jucatorii toti_jucatorii;
    ECHIPA_NEGASITA EXCEPTION;
BEGIN
    SELECT * BULK COLLECT INTO v_toti_jucatorii from JUCATOR;
    DBMS_OUTPUT.PUT_LINE('Toti jucatorii:');
    DBMS_OUTPUT.PUT_LINE('----------------');
    FOR i in 1..v_toti_jucatorii.COUNT loop
        v_jucator := v_toti_jucatorii(i);
        DBMS_OUTPUT.PUT_LINE(v_jucator.NUME_PRENUME);
    end loop;
    SELECT * bulk collect into v_jucatori FROM JUCATOR WHERE TEAM_ID = id_echipa;
    IF v_jucatori.COUNT = 0 THEN
        RAISE ECHIPA_NEGASITA;
    end if;
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE('Jucatorii din echipa cu id-ul ' || id_echipa || ':');
    DBMS_OUTPUT.PUT_LINE('----------------');
    FOR i IN 1 .. v_jucatori.COUNT LOOP
        v_jucator := v_jucatori(i);
        DBMS_OUTPUT.PUT_LINE(v_jucator.NUME_PRENUME);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('----------------');

    EXCEPTION
        WHEN ECHIPA_NEGASITA THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista echipa cu id-ul ' || id_echipa);

END;
-- apelarea procedurii
BEGIN
  get_players_from_team(1);
  get_players_from_team(152);
END;
-- exercitiul 7
-- Afisati echipele dintr-o grupa data, apoi capitanii tuturor echipelor
-- apoi afisati antrenorii echipelor din grupa respectiva cu mai mult/mai putin de 2 ani experienta
CREATE OR REPLACE PROCEDURE get_teams_captains_coaches(p_grupa IN GRUPA.NUME%type, p_cursor IN NUMBER)
AS
  cursor c_teams (p_grupa IN GRUPA.NUME%type) is
    select * from echipa e
    join grupa g on e.GROUP_ID = g.GROUP_ID
    where g.nume = p_grupa;
   cursor c_captains is
    select * from jucator j
    join capitan c on c.PLAYER_ID = j.PLAYER_ID;

    v_echipa c_teams%rowtype;
    v_capitan c_captains%rowtype;
    TYPE tip_cursor IS REF CURSOR RETURN antrenor%ROWTYPE;
    v_coach_cursor tip_cursor;

    v_coach ANTRENOR%rowtype;
    INVALID_INPUT EXCEPTION;
BEGIN
    IF p_cursor > 2 OR p_cursor < 1 THEN
        RAISE INVALID_INPUT;
    end if;
    DBMS_OUTPUT.PUT_LINE('Echipele din grupa ' || p_grupa || ':');
    DBMS_OUTPUT.PUT_LINE('----------------');
    OPEN c_teams(p_grupa);
    LOOP
        FETCH c_teams INTO v_echipa;
        EXIT WHEN c_teams%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_echipa.NUME_ECHIPA);
    END LOOP;
    CLOSE c_teams;
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE('Capitanii tuturor echipelor:');
    DBMS_OUTPUT.PUT_LINE('----------------');
    OPEN c_captains;
    LOOP
        FETCH c_captains INTO v_capitan;
        EXIT WHEN c_captains%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_capitan.nume_prenume);
    END LOOP;
    CLOSE c_captains;

     IF p_cursor = 1 THEN
        OPEN v_coach_cursor FOR
            SELECT * FROM ANTRENOR WHERE EXPERIENTA > 2;
    ELSIF p_cursor = 2 THEN
        OPEN v_coach_cursor FOR
            SELECT * FROM ANTRENOR WHERE EXPERIENTA <= 2;
    END IF;

    DBMS_OUTPUT.PUT_LINE('----------------');
    if p_cursor = 1 then
        DBMS_OUTPUT.PUT_LINE('Antrenorii echipelor cu experienta mai mare de 2 ani:');
    else
        DBMS_OUTPUT.PUT_LINE('Antrenorii echipelor cu experienta mai mica sau egala cu 2 ani:');
    end if;
    DBMS_OUTPUT.PUT_LINE('----------------');
    LOOP
        FETCH v_coach_cursor INTO v_coach;
        EXIT WHEN v_coach_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_coach.nume);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('----------------');

    EXCEPTION
        WHEN INVALID_INPUT THEN
            DBMS_OUTPUT.PUT_LINE('Parametri invalizi!');

END;
-- apelarea procedurii
BEGIN
    get_teams_captains_coaches('B', 2);
    get_teams_captains_coaches('A', 1);
    get_teams_captains_coaches('A', 3);
    get_teams_captains_coaches('C', -3);
END;
-- exercitiul 8
-- Afisati echipa care primeste cei mai multi bani din sponsorizari
-- avand un sponsor dat
CREATE OR REPLACE FUNCTION get_team_with_most_money(p_sponsor_id IN NUMBER) RETURN VARCHAR2 AS
    v_nume_echipa ECHIPA.nume_echipa%type;
    v_suma NUMBER;
    v_s NUMBER;
    v_cnt NUMBER;
    v_sol ECHIPA.nume_echipa%type;
    v_sponsor_id NUMBER;
    v_cursor SYS_REFCURSOR;
    NUMAR_NEGATIV EXCEPTION;
    FARA_ECHIPE EXCEPTION;
    PREA_MULTE_ECHIPE EXCEPTION;
BEGIN
    IF p_sponsor_id < 0 THEN
        RAISE NUMAR_NEGATIV;
    END IF;
    SELECT SPONSOR_ID
    INTO v_sponsor_id
    FROM SPONSOR
    WHERE SPONSOR_ID = p_sponsor_id;
    OPEN v_cursor FOR
        SELECT e.NUME_ECHIPA
        FROM ECHIPA e
        JOIN SPONSORIZEAZA ON e.TEAM_ID = SPONSORIZEAZA.TEAM_ID
        JOIN SPONSOR s ON SPONSORIZEAZA.SPONSOR_ID = s.SPONSOR_ID
        WHERE s.SPONSOR_ID = p_sponsor_id;
    v_s := 0;
    v_suma := 0;
    v_cnt := 0;
    LOOP
        FETCH v_cursor INTO v_nume_echipa;
        EXIT WHEN v_cursor%NOTFOUND;
        SELECT SUM(SUMA_SPONSORIZATA)
        INTO v_s
        FROM SPONSORIZEAZA
        JOIN SPONSOR s ON SPONSORIZEAZA.SPONSOR_ID = s.SPONSOR_ID
        WHERE TEAM_ID = (SELECT TEAM_ID FROM ECHIPA WHERE NUME_ECHIPA = v_nume_echipa);
        IF v_s > v_suma THEN
            v_suma := v_s;
            v_sol := v_nume_echipa;
            v_cnt := 1;
        ELSIF v_s = v_suma THEN
            v_cnt := v_cnt + 1;
        END IF;
    END LOOP;
    close v_cursor;
    IF v_sol IS NULL THEN
        RAISE FARA_ECHIPE;
    END IF;
    IF v_cnt > 1 THEN
        RAISE PREA_MULTE_ECHIPE;
    end if;
    RETURN v_sol;

    EXCEPTION
        WHEN NUMAR_NEGATIV THEN
            DBMS_OUTPUT.PUT_LINE('ID-ul sponsorului nu poate fi negativ!');
            RETURN NULL;
        WHEN FARA_ECHIPE THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista nicio echipa care sa aiba sponsorul cu ID-ul ' || p_sponsor_id);
            RETURN NULL;
        WHEN PREA_MULTE_ECHIPE THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai multe echipe care au acelasi numar de bani din sponsorizari!');
            RETURN NULL;
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista sponsor cu acest ID!');
            RETURN NULL;

END;
-- apelarea functiei
BEGIN
    DBMS_OUTPUT.PUT_LINE(get_team_with_most_money(1));
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE(get_team_with_most_money(2));
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE(get_team_with_most_money(-3));
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE(get_team_with_most_money(123));
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE(get_team_with_most_money(10));
END;
-- exercitiul 9
-- Pentru un jucator al carui prenume este dat, afisati terenul cu cea mai mare capacitate
-- in care a jucat
CREATE OR REPLACE PROCEDURE get_field_with_most_capacity(p_nume_jucator IN VARCHAR2) AS
    v_nume_teren TEREN.NUME%type;
    v_capacitate TEREN.capacitate%type;
    aux_capacitate TEREN.capacitate%type;
    aux_nume_teren TEREN.NUME%type;
    v_playerid JUCATOR.player_id%type;
    v_init NUMBER := -1;
    CURSOR c_teren IS
        SELECT t.CAPACITATE, t.NUME, JUCATOR.PLAYER_ID
        FROM teren t
        JOIN meci m on m.FIELD_ID = t.FIELD_ID
        JOIN joaca on joaca.MATCH_ID = m.MATCH_ID
        JOIN ECHIPA on ECHIPA.TEAM_ID = joaca.TEAM_ID
        join JUCATOR on JUCATOR.TEAM_ID = ECHIPA.TEAM_ID
        WHERE UPPER(JUCATOR.NUME_PRENUME) LIKE '%' || UPPER(p_nume_jucator) || '%';
    INVALID_INPUT EXCEPTION;
    TYPE_MISMATCH EXCEPTION;
BEGIN
    IF p_nume_jucator IS NULL THEN
        RAISE INVALID_INPUT;
    END IF;
    IF regexp_like(p_nume_jucator, '[0-9]') THEN
        RAISE TYPE_MISMATCH;
    END IF;
   OPEN c_teren;
    v_capacitate := -1;
    LOOP
        FETCH c_teren INTO aux_capacitate, aux_nume_teren, v_playerid;
        EXIT WHEN c_teren%NOTFOUND;
        if v_playerid != v_init and v_init != -1 then
            raise too_many_rows;
        end if;
        if aux_capacitate > v_capacitate then
            v_capacitate := aux_capacitate;
            v_nume_teren := aux_nume_teren;
        end if;
        v_init := v_playerid;
    end loop;
    CLOSE c_teren;
    IF v_capacitate = -1 THEN
        raise no_data_found;
    end if;
    DBMS_OUTPUT.PUT_LINE('Terenul cu cea mai mare capacitate in care a jucat ' || p_nume_jucator || ' este ' || v_nume_teren || ' cu o capacitate de ' || v_capacitate);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun jucator cu numele ' || p_nume_jucator);
            RETURN;
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai mult de un jucator cu numele ' || p_nume_jucator);
            RETURN;
        WHEN TYPE_MISMATCH THEN
            DBMS_OUTPUT.PUT_LINE('Numele jucatorului trebuie sa fie un sir de caractere fara cifre!');
            RETURN;
        WHEN INVALID_INPUT THEN
            DBMS_OUTPUT.PUT_LINE('Numele jucatorului nu poate fi NULL!');
            RETURN;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Alta eroare!');

END;
-- apelarea procedurii
BEGIN
    get_field_with_most_capacity('Alex');
    get_field_with_most_capacity('Andrei');
    get_field_with_most_capacity('Obama');
    get_field_with_most_capacity(6);
    get_field_with_most_capacity('ale32');
    get_field_with_most_capacity('');
END;

-- exercitiile 10 si 11 combinat
CREATE OR REPLACE TRIGGER trigger_jucator
    FOR INSERT OR UPDATE OR DELETE ON JUCATOR
    COMPOUND TRIGGER
    BEFORE STATEMENT IS
    BEGIN
        IF TO_CHAR(SYSDATE, 'HH24') < '08' OR TO_CHAR(SYSDATE, 'HH24') > '20' THEN
           RAISE_APPLICATION_ERROR(-20002, 'Nu se poate face operatia in afara intervalului orar 08:00 - 20:00');
       END IF;
    END BEFORE STATEMENT;
    BEFORE EACH ROW IS
    BEGIN
        IF UPDATING THEN
            IF :OLD.NUME_PRENUME != :NEW.NUME_PRENUME THEN
                RAISE_APPLICATION_ERROR(-20003, 'Nu se poate modifica numele jucatorului!');
            END IF;
        END IF;
    END BEFORE EACH ROW;
END;
-- apelarea triggerului
BEGIN
    INSERT INTO JUCATOR VALUES(50, 'John Cena', 2, 1, '1990-01-01', 1);
    UPDATE JUCATOR SET NUME_PRENUME = 'John Cena' WHERE PLAYER_ID = 3;
END;

-- exercitiul 10
-- Creati un trigger care sa nu permita sa fie mai mult de 16 echipe in turneu
-- intrucat organizarea nu permite mai multe echipe
CREATE OR REPLACE TRIGGER trigger_echipa
    AFTER INSERT ON ECHIPA
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM ECHIPA;
    IF v_count > 16 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Nu se poate insera o noua echipa!');
    END IF;
END;
-- declansarea triggerului
BEGIN
    FOR i in 1..10 LOOP
        INSERT INTO ECHIPA(team_id, nume_echipa, group_id) VALUES(30+i, 'test ' || i, 1);
    end loop;
    delete from ECHIPA where DATA_INFIINTARE = '01-01-2022';
END;

-- exercitiul 11
-- Creati un trigger care sa nu permita modificarea datei de infiintare a unei echipe
-- (acesta este un camp ce nu trebuie modificat)
CREATE OR REPLACE TRIGGER trigger_data_infiintare
    BEFORE UPDATE OF DATA_INFIINTARE ON ECHIPA
    FOR EACH ROW
    WHEN (NEW.DATA_INFIINTARE != OLD.DATA_INFIINTARE)
BEGIN
    RAISE_APPLICATION_ERROR(-20005, 'Nu se poate modifica data infiintarii!');
END;
-- declansarea triggerului
BEGIN
    UPDATE ECHIPA SET DATA_INFIINTARE = '01-01-1990' WHERE ECHIPA.TEAM_ID < 3;
END;

-- exercitiul 12
-- Creati un trigger care sa permita modificarea schemei doar de utilizatorul alex
-- si salvati modificarile facute asupra schemei intr-un tabel
CREATE TABLE log_history
(
    username VARCHAR2(20),
    log_date DATE,
    db_name VARCHAR2(20),
    event VARCHAR2(100),
    obj_name VARCHAR2(100)
);

CREATE OR REPLACE TRIGGER trigger_schema
    AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
   IF USER != 'ALEX' THEN
       RAISE_APPLICATION_ERROR(-20910, 'Numai administratorul bazei de date poate realiza operatia!');
   END IF;
    INSERT INTO log_history VALUES(SYS.LOGIN_USER, SYSDATE, SYS.DATABASE_NAME, SYS.SYSEVENT, SYS.DICTIONARY_OBJ_NAME);
END;

-- declansarea triggerului
CREATE TABLE test (id NUMBER);
DROP TABLE test;
ALTER TABLE JUCATOR ADD (test VARCHAR2(20));
ALTER TABLE JUCATOR DROP COLUMN test;
-- vizualizarea modificarilor
SELECT * FROM log_history;
ROLLBACK;

-- exercitiul 13
-- Definiti un pachet care sa contina toate obiectele definite in cadrul proiectului
CREATE OR REPLACE PACKAGE proiect_AXP AS
    PROCEDURE get_players_from_team(id_echipa IN NUMBER);
    PROCEDURE get_teams_captains_coaches(p_grupa IN GRUPA.NUME%type, p_cursor IN NUMBER);
    FUNCTION get_team_with_most_money(p_sponsor_id IN NUMBER) RETURN VARCHAR2;
    PROCEDURE get_field_with_most_capacity(p_nume_jucator IN VARCHAR2);
END proiect_AXP;
CREATE OR REPLACE PACKAGE BODY proiect_AXP AS
    -- exercitiul 6
    -- Afisati toti jucatorii care participa la turneu, apoi doar jucatorii care
    -- fac parte din echipa cu un id dat
    PROCEDURE get_players_from_team(id_echipa IN NUMBER)
IS
    TYPE jucatori is varray(100) of jucator%rowtype;
    v_jucatori jucatori;
    v_jucator jucator%rowtype;
    TYPE toti_jucatorii is table of jucator%rowtype;
    v_toti_jucatorii toti_jucatorii;
    ECHIPA_NEGASITA EXCEPTION;
BEGIN
    SELECT * BULK COLLECT INTO v_toti_jucatorii from JUCATOR;
    DBMS_OUTPUT.PUT_LINE('Toti jucatorii:');
    DBMS_OUTPUT.PUT_LINE('----------------');
    FOR i in 1..v_toti_jucatorii.COUNT loop
        v_jucator := v_toti_jucatorii(i);
        DBMS_OUTPUT.PUT_LINE(v_jucator.NUME_PRENUME);
    end loop;
    SELECT * bulk collect into v_jucatori FROM JUCATOR WHERE TEAM_ID = id_echipa;
    IF v_jucatori.COUNT = 0 THEN
        RAISE ECHIPA_NEGASITA;
    end if;
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE('Jucatorii din echipa cu id-ul ' || id_echipa || ':');
    DBMS_OUTPUT.PUT_LINE('----------------');
    FOR i IN 1 .. v_jucatori.COUNT LOOP
        v_jucator := v_jucatori(i);
        DBMS_OUTPUT.PUT_LINE(v_jucator.NUME_PRENUME);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('----------------');

    EXCEPTION
        WHEN ECHIPA_NEGASITA THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista echipa cu id-ul ' || id_echipa);

END;

    -- exercitiul 7
    -- Afisati echipele dintr-o grupa data, apoi capitanii tuturor echipelor
    -- apoi afisati antrenorii echipelor din grupa respectiva cu mai mult/mai putin de 2 ani experienta
    PROCEDURE get_teams_captains_coaches(p_grupa IN GRUPA.NUME%type, p_cursor IN NUMBER)
AS
  cursor c_teams (p_grupa IN GRUPA.NUME%type) is
    select * from echipa e
    join grupa g on e.GROUP_ID = g.GROUP_ID
    where g.nume = p_grupa;
   cursor c_captains is
    select * from jucator j
    join capitan c on c.PLAYER_ID = j.PLAYER_ID;

    v_echipa c_teams%rowtype;
    v_capitan c_captains%rowtype;
    TYPE tip_cursor IS REF CURSOR RETURN antrenor%ROWTYPE;
    v_coach_cursor tip_cursor;

    v_coach ANTRENOR%rowtype;
    INVALID_INPUT EXCEPTION;
BEGIN
    IF p_cursor > 2 OR p_cursor < 1 THEN
        RAISE INVALID_INPUT;
    end if;
    DBMS_OUTPUT.PUT_LINE('Echipele din grupa ' || p_grupa || ':');
    DBMS_OUTPUT.PUT_LINE('----------------');
    OPEN c_teams(p_grupa);
    LOOP
        FETCH c_teams INTO v_echipa;
        EXIT WHEN c_teams%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_echipa.NUME_ECHIPA);
    END LOOP;
    CLOSE c_teams;
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE('Capitanii tuturor echipelor:');
    DBMS_OUTPUT.PUT_LINE('----------------');
    OPEN c_captains;
    LOOP
        FETCH c_captains INTO v_capitan;
        EXIT WHEN c_captains%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_capitan.nume_prenume);
    END LOOP;
    CLOSE c_captains;

     IF p_cursor = 1 THEN
        OPEN v_coach_cursor FOR
            SELECT * FROM ANTRENOR WHERE EXPERIENTA > 2;
    ELSIF p_cursor = 2 THEN
        OPEN v_coach_cursor FOR
            SELECT * FROM ANTRENOR WHERE EXPERIENTA <= 2;
    END IF;

    DBMS_OUTPUT.PUT_LINE('----------------');
    if p_cursor = 1 then
        DBMS_OUTPUT.PUT_LINE('Antrenorii echipelor cu experienta mai mare de 2 ani:');
    else
        DBMS_OUTPUT.PUT_LINE('Antrenorii echipelor cu experienta mai mica sau egala cu 2 ani:');
    end if;
    DBMS_OUTPUT.PUT_LINE('----------------');
    LOOP
        FETCH v_coach_cursor INTO v_coach;
        EXIT WHEN v_coach_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_coach.nume);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('----------------');

    EXCEPTION
        WHEN INVALID_INPUT THEN
            DBMS_OUTPUT.PUT_LINE('Parametri invalizi!');

END;

    -- exercitiul 8
    -- Afisati echipa care primeste cei mai multi bani din sponsorizari
    -- avand un sponsor dat
    FUNCTION get_team_with_most_money(p_sponsor_id IN NUMBER) RETURN VARCHAR2 AS
    v_nume_echipa ECHIPA.nume_echipa%type;
    v_suma NUMBER;
    v_s NUMBER;
    v_cnt NUMBER;
    v_sol ECHIPA.nume_echipa%type;
    v_sponsor_id NUMBER;
    v_cursor SYS_REFCURSOR;
    NUMAR_NEGATIV EXCEPTION;
    FARA_ECHIPE EXCEPTION;
    PREA_MULTE_ECHIPE EXCEPTION;
BEGIN
    IF p_sponsor_id < 0 THEN
        RAISE NUMAR_NEGATIV;
    END IF;
    SELECT SPONSOR_ID
    INTO v_sponsor_id
    FROM SPONSOR
    WHERE SPONSOR_ID = p_sponsor_id;
    OPEN v_cursor FOR
        SELECT e.NUME_ECHIPA
        FROM ECHIPA e
        JOIN SPONSORIZEAZA ON e.TEAM_ID = SPONSORIZEAZA.TEAM_ID
        JOIN SPONSOR s ON SPONSORIZEAZA.SPONSOR_ID = s.SPONSOR_ID
        WHERE s.SPONSOR_ID = p_sponsor_id;
    v_s := 0;
    v_suma := 0;
    v_cnt := 0;
    LOOP
        FETCH v_cursor INTO v_nume_echipa;
        EXIT WHEN v_cursor%NOTFOUND;
        SELECT SUM(SUMA_SPONSORIZATA)
        INTO v_s
        FROM SPONSORIZEAZA
        JOIN SPONSOR s ON SPONSORIZEAZA.SPONSOR_ID = s.SPONSOR_ID
        WHERE TEAM_ID = (SELECT TEAM_ID FROM ECHIPA WHERE NUME_ECHIPA = v_nume_echipa);
        IF v_s > v_suma THEN
            v_suma := v_s;
            v_sol := v_nume_echipa;
            v_cnt := 1;
        ELSIF v_s = v_suma THEN
            v_cnt := v_cnt + 1;
        END IF;
    END LOOP;
    close v_cursor;
    IF v_sol IS NULL THEN
        RAISE FARA_ECHIPE;
    END IF;
    IF v_cnt > 1 THEN
        RAISE PREA_MULTE_ECHIPE;
    end if;
    RETURN v_sol;

    EXCEPTION
        WHEN NUMAR_NEGATIV THEN
            DBMS_OUTPUT.PUT_LINE('ID-ul sponsorului nu poate fi negativ!');
            RETURN NULL;
        WHEN FARA_ECHIPE THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista nicio echipa care sa aiba sponsorul cu ID-ul ' || p_sponsor_id);
            RETURN NULL;
        WHEN PREA_MULTE_ECHIPE THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai multe echipe care au acelasi numar de bani din sponsorizari!');
            RETURN NULL;
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista sponsor cu acest ID!');
            RETURN NULL;

END;

    -- exercitiul 9
    -- Pentru un jucator al carui prenume este dat, afisati terenul cu cea mai mare capacitate
    -- in care a jucat
    PROCEDURE get_field_with_most_capacity(p_nume_jucator IN VARCHAR2) AS
    v_nume_teren TEREN.NUME%type;
    v_capacitate TEREN.capacitate%type;
    aux_capacitate TEREN.capacitate%type;
    aux_nume_teren TEREN.NUME%type;
    v_playerid JUCATOR.player_id%type;
    v_init NUMBER := -1;
    CURSOR c_teren IS
        SELECT t.CAPACITATE, t.NUME, JUCATOR.PLAYER_ID
        FROM teren t
        JOIN meci m on m.FIELD_ID = t.FIELD_ID
        JOIN joaca on joaca.MATCH_ID = m.MATCH_ID
        JOIN ECHIPA on ECHIPA.TEAM_ID = joaca.TEAM_ID
        join JUCATOR on JUCATOR.TEAM_ID = ECHIPA.TEAM_ID
        WHERE UPPER(JUCATOR.NUME_PRENUME) LIKE '%' || UPPER(p_nume_jucator) || '%';
    INVALID_INPUT EXCEPTION;
    TYPE_MISMATCH EXCEPTION;
BEGIN
    IF p_nume_jucator IS NULL THEN
        RAISE INVALID_INPUT;
    END IF;
    IF regexp_like(p_nume_jucator, '[0-9]') THEN
        RAISE TYPE_MISMATCH;
    END IF;
   OPEN c_teren;
    v_capacitate := -1;
    LOOP
        FETCH c_teren INTO aux_capacitate, aux_nume_teren, v_playerid;
        EXIT WHEN c_teren%NOTFOUND;
        if v_playerid != v_init and v_init != -1 then
            raise too_many_rows;
        end if;
        if aux_capacitate > v_capacitate then
            v_capacitate := aux_capacitate;
            v_nume_teren := aux_nume_teren;
        end if;
        v_init := v_playerid;
    end loop;
    CLOSE c_teren;
    IF v_capacitate = -1 THEN
        raise no_data_found;
    end if;
    DBMS_OUTPUT.PUT_LINE('Terenul cu cea mai mare capacitate in care a jucat ' || p_nume_jucator || ' este ' || v_nume_teren || ' cu o capacitate de ' || v_capacitate);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun jucator cu numele ' || p_nume_jucator);
            RETURN;
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai mult de un jucator cu numele ' || p_nume_jucator);
            RETURN;
        WHEN TYPE_MISMATCH THEN
            DBMS_OUTPUT.PUT_LINE('Numele jucatorului trebuie sa fie un sir de caractere fara cifre!');
            RETURN;
        WHEN INVALID_INPUT THEN
            DBMS_OUTPUT.PUT_LINE('Numele jucatorului nu poate fi NULL!');
            RETURN;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Alta eroare!');

END;
END proiect_AXP;

-- testare pachet
BEGIN
    proiect_axp.get_players_from_team(1);
    proiect_axp.get_players_from_team(152);
    DBMS_OUTPUT.PUT_LINE('###############');
    proiect_axp.get_teams_captains_coaches('B', 2);
    proiect_axp.get_teams_captains_coaches('A', 1);
    proiect_axp.get_teams_captains_coaches('A', 3);
    proiect_axp.get_teams_captains_coaches('C', -3);
    DBMS_OUTPUT.PUT_LINE('################');
    DBMS_OUTPUT.PUT_LINE(proiect_axp.get_team_with_most_money(1));
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE(proiect_axp.get_team_with_most_money(2));
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE(proiect_axp.get_team_with_most_money(-3));
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE(proiect_axp.get_team_with_most_money(123));
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE(proiect_axp.get_team_with_most_money(10));
    DBMS_OUTPUT.PUT_LINE('################');
    proiect_axp.get_field_with_most_capacity('Alex');
    proiect_axp.get_field_with_most_capacity('Andrei');
    proiect_axp.get_field_with_most_capacity('Obama');
    proiect_axp.get_field_with_most_capacity(6);
    proiect_axp.get_field_with_most_capacity('ale32');
    proiect_axp.get_field_with_most_capacity('');
end;