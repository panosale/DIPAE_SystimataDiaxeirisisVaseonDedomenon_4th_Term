-- ΜΕΡΟΣ Α --
-- Ερώτημα 1 --
INSERT INTO reservation(sid,bid,mid,r_date) VALUES(13,88,5,'2013-10-19');
	-- ΕΛΕΓΧΟΣ --
	select * from reservation where sid = 13; -> Επιστρέφει τη νέα εγγραφή.

-- Ερώτημα 2 --
INSERT INTO reservation(sid,bid,mid,r_date) VALUES(15,32,33,'2013-10-21');
	-- ΣΦΑΛΜΑ --
	ERROR:  Key (bid)=(32) is not present in table "boat".insert or update on table "reservation" violates foreign key constraint "f_key2" 
	ERROR:  insert or update on table "reservation" violates foreign key constraint "f_key2"
	SQL state: 23503
	Detail: Key (bid)=(32) is not present in table "boat".
		-- ΕΠΕΙΔΗ --
		Δεν υπάρχει boat με id 32 στον πίνακα boats. Παραβιάζει κανόνα συσχέτισης.
	-- ΕΛΕΓΧΟΣ --
	selsect * from boat where bid = 32; -> Δεν επιστρέφει τίποτα

-- Ερώτημα 3 --
INSERT INTO boat(bid,bname,color) VALUES(32,'Γαλανούλα','Blue');
	-- ΕΛΕΓΧΟΣ --
	selsect * from boat where bid = 32; -> Επιστρέφει τη νέα εγγραφή.

-- Ερώτημα 4 --
INSERT INTO reservation(sid,bid,mid,r_date) VALUES(15,32,33,'2013-10-21');
	-- ΣΧΟΛΙΑ --
	Έγινε κανονικά η εισαγωγή αφού πλέον υπάρχει boat με id 32. 
	-- ΕΛΕΓΧΟΣ --
	select * from reservation where sid = 15; -> Επιστρέφει τη νέα εγγραφή.

-- Ερώτημα 5 --
INSERT INTO sailor(sid,sname,rating,age) VALUES (3, 'Φανούρης', 7, 19);
	-- ΣΦΑΛΜΑ --
	ERROR:  Failing row contains (3, Φανούρης, 7, 19).new row for relation "sailor" violates check constraint "c_age" 
	ERROR:  new row for relation "sailor" violates check constraint "c_age"
	SQL state: 23514
	Detail: Failing row contains (3, Φανούρης, 7, 19).
		-- ΕΠΕΙΔΗ -- 
		Παραβιάζει τον κανόνα της ηλικίας <= 18 ετών.
		-- ΔΙΟΡΘΩΣΗ --
		INSERT INTO sailor(sid,sname,rating,age) VALUES (3, 'Φανούρης', 7, 18);
		-- ΕΛΕΓΧΟΣ --
		select * from sailor where sid = 3;

-- Ερώτημα 6 --
UPDATE sailor SET sid = 111 WHERE sid = 1;
	-- ΕΛΕΓΧΟΣ --
	select * from sailor where sname = 'Χριστίνα';
	-- ΣΧΟΛΙΑ --
	Γίνονται update όλες οι εγγραφές στον πίνακα reservation επειδή η σχέση f_key1 των πεδίων sid έχει δημιουργηθεί με "on update cascade" ???
	-- ΕΛΕΓΧΟΣ --
	select * from reservation where sid = 1; -> Δεν φέρνει πλέον αποτελέσματα
	select * from reservation where sid = 111; -> Φέρνει τις ενημερωμένες εγγραφές
	
-- Ερώτημα 7 --
DELETE FROM sailor WHERE sid = 111;
	-- ΕΛΕΓΧΟΣ --
	select * from sailor where sid = 111;
	-- ΣΧΟΛΙΑ --
	Διαγράφει και όλες τις εγγραφές (7) από τον πίνακα reservation επειδή η σχέση f_key1 των πεδίων sid έχει δημιουργηθεί με "on delete cascade" ???
	-- ΕΛΕΓΧΟΣ --
	select * from reservation where sid = 111; -> Δεν φέρνει πλέον κανένα αποτέλεσμα

-- Ερώτημα 8 --
DELETE FROM reservation WHERE sid = 19;
	-- ΕΛΕΓΧΟΣ --
	select * from reservation where sid = 19; -> Δεν επιστρέφει τίποτα
	-- ΣΧΟΛΙΑ --
	Δεν γίνεται καμία αλλαγή στους υπόλοιπους πίνακες της ΒΔ. ???
	select * from sailor where sid = 19;

-- Ερώτημα 9 --
DELETE FROM boat WHERE color = 'Light Green';
	-- ΣΦΑΛΜΑ --
	ERROR:  Key (bid)=(17) is still referenced from table "reservation".update or delete on table "boat" violates foreign key constraint "f_key2" on table "reservation" 
	ERROR:  update or delete on table "boat" violates foreign key constraint "f_key2" on table "reservation"
	SQL state: 23503
	Detail: Key (bid)=(17) is still referenced from table "reservation".
		-- ΕΠΕΙΔΗ --
		Η σχέση f_key2 των πεδίων bid έχει δημιουργηθεί με "on delete restrict" ???

-- Ερώτημα 10 --
DELETE FROM marina WHERE name = 'Ποσείδι';
	-- ΣΧΟΛΙΑ --
	Διαγράφει την εγγραφή "Ποσείδι" και αλλάζει το πεδίο mid σε όσες εγγραφές του πίνακα reservation είχαν αναφορά σε αυτή την εγγραφή επειδή η σχέση f_key3 έχει δημιουργηθεί με "on delete set null" ???
	-- ΕΛΕΓΧΟΣ --
	select * from reservation; -> Τα πεδία με τιμή [null]
	
-- Ερώτημα 12 --
(α)
	drop table if exists typos;
	CREATE TABLE typos 
		(k_typou integer not null constraint c_k_typou primary key check (k_typou between 1 and 13),
		 perigrafi varchar(40));
(β)
	ALTER TABLE boat
		ADD COLUMN k_typou integer constraint f_key1 references typos(k_typou) on delete set null on update set null;
(γ)
	INSERT INTO typos (k_typou, perigrafi) VALUES (1, 'Μηχανότρατα');
	INSERT INTO typos (k_typou, perigrafi) VALUES (2, 'Σκούνα');
	UPDATE boat SET k_typou = 1 WHERE bid IN (1, 17, 19, 72);
	UPDATE boat SET k_typou = 2 WHERE bid IN (13, 88);

-- Ερώτημα 14 --
SELECT MAX(capacity) FROM marina WHERE name LIKE 'Π%';

-- Ερώτημα 15 --
SELECT MIN(capacity) FROM marina WHERE name LIKE 'Π______';
-- Ή --
SELECT MIN(capacity) FROM marina WHERE name LIKE 'Π%' AND LENGTH(name) = 7;

-- Ερώτημα 16 --
SELECT s.sid, s.sname FROM sailor s
EXCEPT
SELECT s.sid, s.sname FROM sailor s
	JOIN reservation r on (s.sid = r.sid)
	JOIN boat b on (b.bid = r.bid) WHERE b.color <> 'Red';

-- Ερώτημα 17 --
SELECT AVG(rating) FROM sailor;

-- Ερώτημα 18 --
SELECT SUM(rating) / COUNT(rating) FROM sailor;

-- Ερώτημα 19 --
SELECT 1.0 * (SUM(rating) / COUNT(rating)) FROM sailor; -- να ελεγχθεί --

-- Ερώτημα 20 --
α)
SELECT S.sid, S.sname FROM sailor S
	JOIN reservation R ON (R.sid = S.sid)
	JOIN marina M ON (M.mid = R.mid)
	WHERE M.name = 'Πόρτο Καρράς';
β)
SELECT DISTINCT S.sid, S.sname FROM sailor S
	JOIN reservation R ON (R.sid = S.sid)
	JOIN marina M ON (M.mid = R.mid)
	WHERE M.name = 'Ουρανούπολις';
γ)
SELECT S.sid, S.sname FROM sailor S
	JOIN reservation R ON (R.sid = S.sid)
	JOIN marina M ON (M.mid = R.mid)
	WHERE M.name = 'Πόρτο Καρράς'
INTERSECT
SELECT S.sid, S.sname FROM sailor S
	JOIN reservation R ON (R.sid = S.sid)
	JOIN marina M ON (M.mid = R.mid)
	WHERE M.name = 'Ουρανούπολις';

-- Ερώτημα 21 --
SELECT DISTINCT B.bid, B.bname FROM boat B
	JOIN reservation R ON (R.bid = B.bid)
	JOIN sailor S ON (S.sid = R.sid)
	JOIN marina M ON (M.mid = R.mid)
	WHERE S.rating = 8 OR M.name = 'Ουρανούπολις';
-- Ή --
SELECT B.bid, B.bname FROM boat B
	JOIN reservation R ON (R.bid = B.bid)
	JOIN marina M ON (M.mid = R.mid)
	WHERE M.name = 'Ουρανούπολις'
UNION
SELECT B.bid, B.bname FROM boat B
	JOIN reservation R ON (R.bid = B.bid)
	JOIN sailor S ON (S.sid = R.sid)
	WHERE S.rating = 8;

-- Ερώτημα 22 --
SELECT DISTINCT M.name FROM marina M
	JOIN reservation R ON (R.mid = M.mid)
	JOIN boat B ON (B.bid = R.bid)
	WHERE B.color = 'Red' AND M.capacity > 200;
	
-- Ερώτημα 23 --
SELECT DISTINCT M.name FROM marina M
	JOIN reservation R ON (R.mid = M.mid)
	JOIN boat B ON (B.bid = R.bid)
	WHERE B.color = 'Red' OR B.color = 'Blue';

-- Ερώτημα 24 --
SELECT DISTINCT B.bname, B.color FROM marina M
	JOIN reservation R ON (R.mid = M.mid)
	JOIN boat B ON (B.bid = R.bid)
	JOIN sailor S ON (S.sid = R.sid)
	WHERE NOT (S.rating < 5);

-- Ερώτημα 25 --
SELECT S.sname AS "Sailor Name", B.bname AS "Boat name" FROM sailor S
	JOIN reservation R ON (R.sid = S.sid)
	JOIN boat B ON (B.bid = R.bid)
	JOIN marina M ON (M.mid = R.mid)
	WHERE M.name = 'Πόρτο Καρράς';

-- Ερώτημα 26 --
SELECT B1.bname, B1.color, B2.bname, B2.color FROM boat B1, boat B2 WHERE B1.color = B2.color AND B1.bid > B2.bid;

-- Ερώτημα 27 --
SELECT DISTINCT M.mid AS "Marina ID", M.name AS "Marina name", B.color AS "Boat color" FROM marina M
	JOIN reservation R ON (R.mid = M.mid)
	JOIN boat B ON (B.bid = R.bid)
	WHERE M.name LIKE 'Π%' OR B.color = 'Red';
-- Ή --
SELECT M.mid AS "Marina ID", M.name AS "Marina name", B.color AS "Boat color" FROM marina M
	JOIN reservation R ON (R.mid = M.mid)
	JOIN boat B ON (B.bid = R.bid)
	WHERE M.name LIKE 'Π%'
UNION
SELECT M.mid AS "Marina ID", M.name AS "Marina name", B.color AS "Boat color" FROM marina M
	JOIN reservation R ON (R.mid = M.mid)
	JOIN boat B ON (B.bid = R.bid)
	WHERE B.color = 'Red';


-- ΜΕΡΟΣ Β --
-- SQL Zoo
-- SELECT from WORLD Tutorial
-- 1.
SELECT name, continent, population FROM world

-- 2.
SELECT name FROM world WHERE population > 200000000

-- 3.
SELECT name, (gdp / population) FROM world WHERE population > 200000000

-- 4.
SELECT name, (population / 1000000) FROM world WHERE continent = 'South America'

-- 5.
SELECT name, population FROM world WHERE name = 'France' OR name = 'Germany' OR name = 'Italy'
-- Ή
SELECT name, population FROM world WHERE name IN ('France', 'Germany', 'Italy')

-- 6.
SELECT name FROM world WHERE name LIKE "%United%"

-- 7.
SELECT name, population, area FROM world WHERE population > 250000000 OR area > 3000000

-- 8.
SELECT name, population, area FROM world WHERE population > 250000000 XOR area > 3000000

-- 9.
SELECT name, ROUND(population / 1000000, 2), ROUND(gdp / 1000000000, 2) FROM world WHERE continent = 'South America'

-- 10.
SELECT name, ROUND(gdp / population, -3) FROM world WHERE gdp > 1000000000000

-- 11.
SELECT name, capital FROM world WHERE LENGTH(name) = LENGTH(capital)

-- 12.
SELECT name, capital FROM world WHERE (LEFT(name,1) = LEFT(capital,1)) AND (name <> capital)

-- 13.
SELECT name FROM world WHERE name NOT LIKE '% %' AND (name LIKE '%a%' AND name LIKE '%e%' AND name LIKE '%i%'  AND name LIKE '%o%'  AND name LIKE '%u%')

-- SUM() και COUNT()
-- 1.
SELECT SUM(population) FROM world

-- 2.
SELECT DISTINCT continent FROM world

-- 3.
SELECT SUM(gdp) FROM world WHERE continent = 'Africa'

-- 4.
SELECT COUNT(name) FROM world WHERE area > 1000000

-- 5.
SELECT SUM(population) FROM world WHERE name IN ('Estonia', 'Latvia', 'Lithuania') 

-- 6.
SELECT continent, COUNT(name) FROM world GROUP BY continent

-- 7.
SELECT continent, COUNT(name) FROM world WHERE population > 10000000 GROUP BY continent

-- 8.
SELECT continent FROM world GROUP BY continent HAVING SUM(population)  > 100000000


