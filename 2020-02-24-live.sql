DROP TABLE IF EXISTS person CASCADE;

CREATE TABLE person(
  pname CHAR(25),
  city CHAR(20),
  birthdate DATE PRIMARY KEY) WITH OIDS;

CREATE TABLE professor(
  dept CHAR(20),
  field CHAR(50),
  tenure BOOL) INHERITS (person) WITH OIDS;

CREATE TABLE student(
  studid CHAR(12),
  college CHAR(10),
  major CHAR(10),
  slevel CHAR(20)) INHERITS (person) WITH OIDS;

SELECT OID, * FROM person;
SELECT * FROM person WHERE OID=130019;
SELECT * FROM student WHERE MAJOR='CS';

-- Sichten (Views)

INSERT INTO student VALUES
  ('Tick Duck', 'Entenhausen', '1970-01-01', 'xyz321', 'IT', 'CS', '3'),
  ('Trick Duck', 'Entenhausen', '1970-01-01', 'xyz322', 'IT', 'CS', '3'),
  ('Track Duck', 'Entenhausen', '1970-01-01', 'xyz323', 'IT', 'CS', '3');

CREATE VIEW studentview AS
  SELECT pname, birthdate, college, major, slevel FROM student;

SELECT * FROM studentview;

INSERT INTO studentview VALUES
  ('Max Muster', '1998-03-17', 'IT', 'CS', '4');

SELECT * FROM studentview;

-- ARRAYS
ALTER TABLE student ADD geschwister VARCHAR(25)[];

UPDATE student SET geschwister='{"Trick", "Track"}' WHERE pname='Tick Duck';
UPDATE student SET geschwister='{"Tick Duck", "Track Duck"}' WHERE pname='Trick Duck';
UPDATE student SET geschwister='{"Tick", "Trick Duck"}' WHERE pname='Track Duck';

SELECT * FROM student;

SELECT geschwister FROM student WHERE pname='Tick Duck';
SELECT geschwister[1] FROM student WHERE pname='Tick Duck';
SELECT geschwister[2] FROM student WHERE pname='Tick Duck';

-- Funktionen
-- ##########

-- Mathematische Funktionen
SELECT ABS(-233.93278);
SELECT PI();
SELECT ROUND(7.283, 2);
SELECT RANDOM();
SELECT SQRT(2);
SELECT CEIL(4.1);
SELECT FLOOR(4.1);
SELECT MOD(1928, 10);

-- Zeichenkettenfunktionen
SELECT ASCII('A');
SELECT CHR(97);
SELECT LOWER('Konsequente Kleinschreibung ist nicht unbedingt besser lesbar.');
SELECT UPPER('Alles groß schreiben wird manchmal als brüllen bezeichnet.');
SELECT POSITION('t' IN 'Text');
SELECT POSITION('T' IN 'Text');
SELECT LENGTH('Konsequente Kleinschreibung ist nicht unbedingt besser lesbar.');
SELECT 'Das gehört ' || 'zusammen' || '.';
SELECT SUBSTRING('PostgreSQL', 2, 8);

SELECT TRIM(BOTH '*' FROM '****PostgreSQL***');
SELECT BTRIM('****PostgreSQL***', '*');
SELECT LTRIM('****PostgreSQL***', '*');
SELECT RTRIM('****PostgreSQL***', '*');
SELECT BTRIM('  PostgreSQL ');
SELECT BTRIM('  0341 42743-0  ');

SELECT INITCAP('wir sind schreibfaul und schreiben alles klein.');
SELECT TO_HEX(65);
SELECT REPEAT('Das ist ein Fülltext. ', 10);

-- Text verschleiern
SELECT TRANSLATE('3450', '0123456789', 'abcdefghij');
SELECT TRANSLATE('IBM', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ','ZABCDEFGHIJKLMNOPQRSTUVWXY');
SELECT TRANSLATE('HAL', 'ZABCDEFGHIJKLMNOPQRSTUVWXY','ABCDEFGHIJKLMNOPQRSTUVWXYZ');

-- Datum und Uhrzeit
SELECT CURRENT_DATE;
SELECT CURRENT_TIME;
SELECT CURRENT_TIMESTAMP;
SELECT LOCALTIME;
SELECT LOCALTIMESTAMP;
SELECT NOW();
SELECT TIMEOFDAY();
-- Berechnungen mit Datum/Uhrzeit
SELECT AGE('1998-03-17', '2020-01-01');
SELECT AGE(CURRENT_DATE, '1998-03-17');
SELECT EXTRACT(YEAR FROM  AGE(CURRENT_DATE, '1998-03-17'));
SELECT DATE '2020-02-24' + INTERVAL '30 DAYS' AS "+ 30 Tage";
SELECT CURRENT_DATE + INTERVAL '30 DAYS' AS "+ 30 Tage";

-- SQL Funktionen
CREATE OR REPLACE FUNCTION geschwister(TEXT, INT)
  RETURNS VARCHAR(30) AS
  $$
    SELECT geschwister[$2] FROM student WHERE pname=$1;
    $$ LANGUAGE SQL;

SELECT geschwister('Trick Duck', 1);

-- PL/pgSQL Funktionen
CREATE OR REPLACE FUNCTION Arith_Mittel(INT, INT)
  RETURNS NUMERIC AS
  $$
    SELECT ($1 + $2) / 2.0
    $$ LANGUAGE SQL;
CREATE OR REPLACE FUNCTION Arith_Mittel(INT, INT, INT)
  RETURNS NUMERIC AS
  $$
    SELECT ($1 + $2 + $3) / 3.0
    $$ LANGUAGE SQL;

SELECT Arith_Mittel(2,3);
SELECT Arith_Mittel(2,3,4);

DROP FUNCTION Arith_Mittel(INT, INT);

-- mit Variablendeklaration

CREATE OR REPLACE FUNCTION Arith_Mittel(INT, INT)
  RETURNS NUMERIC AS
  $$
    DECLARE
      zahl1 ALIAS FOR $1;
      zahl2 ALIAS FOR $2;
      ergebnis NUMERIC;
    BEGIN
      ergebnis := (zahl1 + zahl2)/2.0;
      RETURN ergebnis;
    END
    $$ LANGUAGE plpgsql;

SELECT Arith_Mittel(2,3);