-- ΜΕΡΟΣ Α!
-- Γίνεται χρήση της σχεσιακής βάσης δεδομένων SQLZoo Congestion Charging.
-- 1. Το αυτοκίνητο ή τα αυτοκίνητα που έχουν φωτογραφηθεί ΑΠΟ ΟΛΕΣ τις κάμερες οι οποίες δεν έχουν (ακόμη) χαρακτηριστεί να είναι κάμερες εισόδου (IN) ή κάμερες εξόδου (OUT) στο δακτύλιο.
-- Απαίτηση: να χρησιμοποιηθεί ο τελεστής EXCEPT (διαφορά συνόλων).
-- ΛΥΣΗ:
SELECT v.id FROM vehicle v
	WHERE NOT EXISTS
	(SELECT c.id FROM camera c WHERE perim is NULL
	EXCEPT
	SELECT i.camera FROM image i WHERE i.reg = v.id);
-- ΕΝΑΛΛΑΚΤΙΚΑ:
SELECT DISTINCT(i1.reg) FROM image i1
	WHERE NOT EXISTS 
	(SELECT c.id FROM camera c WHERE perim is NULL
	EXCEPT
	SELECT i2.camera FROM image i2 WHERE i2.reg = i1.reg);
-- ΕΞΗΓΗΣΗ: Το σύνολο των καμερών μείον το σύνολο των καμερών που έχουν φοτωγραφίσει ένα αυτοκίνητο είναι το κενό.

-- 2. Το αυτοκίνητο ή τα αυτοκίνητα που έχουν φωτογραφηθεί ΑΠΟ ΟΛΕΣ τις κάμερες οι οποίες δεν έχουν (ακόμη) χαρακτηριστεί να είναι κάμερες εισόδου (IN) ή κάμερες εξόδου (OUT) στο δακτύλιο.
-- Απαίτηση: να ΜΗΝ χρησιμοποιηθεί ο τελεστής EXCEPT. Να λυθεί με διπλή άρνηση.
-- ΛΥΣΗ:
SELECT v.id FROM vehicle v
	WHERE NOT EXISTS
	(SELECT * FROM camera c
		WHERE perim IS NULL AND NOT EXISTS 
		(SELECT * FROM image i WHERE v.id = i.reg AND c.id = i.camera));
-- ΕΝΑΛΛΑΚΤΙΚΑ:
SELECT DISTINCT(i1.reg) FROM image i1
	WHERE NOT EXISTS 
	(SELECT c.id FROM camera c 
		WHERE c.perim IS NULL AND NOT EXISTS
		(SELECT i2.camera FROM image i2 WHERE i1.reg = i2.reg AND c.id = i2.camera));
-- ΕΞΗΓΗΣΗ: Δεν υπάρχει κάμερα που να μην έχει φωτογραφίσει αυτοκίνητο.

-- 3. Το αυτοκίνητο ή τα αυτοκίνητα που έχουν φωτογραφηθεί ΑΠΟ ΟΛΕΣ τις κάμερες οι οποίες δεν έχουν (ακόμη) χαρακτηριστεί να είναι κάμερες εισόδου (IN) ή κάμερες εξόδου (OUT) στο δακτύλιο.
-- Απαίτηση: να χρησιμοποιηθεί η συνιστώσα σύνταξης GROUP BY … HAVING και να ΜΗΝ χρησιμοποιηθούν οι τελεστές EXCEPT ή/και (NOT) EXISTS
-- ΛΥΣΗ: Με τη χρήση προσωρινού VIEW
WITH tmp AS (SELECT v.id as vehicleid, c.id as cameraid FROM vehicle v 
	JOIN image i ON (i.reg = v.id) 
	JOIN camera c ON (i.camera = c.id) WHERE c.perim IS NULL) 
	SELECT vehicleid FROM tmp
	GROUP BY vehicleid HAVING COUNT(DISTINCT cameraid) = (SELECT COUNT(*) FROM camera c2 WHERE c2.perim IS NULL);
-- ΕΝΑΛΛΑΚΤΙΚΑ:
SELECT DISTINCT V.id FROM Vehicle V 
	WHERE V.id IN (SELECT I.reg FROM Image I JOIN Camera C1 ON (C1.id=I.camera) 
		WHERE C1.perim IS NULL
        	GROUP BY I.reg HAVING COUNT(DISTINCT C1.id) = (SELECT COUNT(*) FROM Camera C2 WHERE C2.perim IS NULL));

-- 4. Το αυτοκίνητο ή τα αυτοκίνητα που έχουν φωτογραφηθεί ΑΠΟ ΟΛΕΣ τις κάμερες οι οποίες δεν έχουν (ακόμη) χαρακτηριστεί να είναι κάμερες εισόδου (IN) ή κάμερες εξόδου (OUT) στο δακτύλιο.
-- Απαίτηση: το αποτέλεσμα να υπολογιστεί χωρίς την χρήση των GROUP BY … HAVING ή/και EXCEPT ή/και (NOT) EXISTS

-- *** ΣΗΜΕΙΩΣΗ: Για επιβεβαίωση των παραπάνω λύσεων μπορούμε να προσθέσουμε άλλη μια εγγραφή στον πίνακα image για το όχημα με πινακίδα 'SO 02 ASP' στην κάμερα 19 με την εντολή:
	INSERT INTO image (camera, reg, whn) VALUES (19, 'SO 02 ASP', NOW());
-- 	Οπότε θα έχουμε 2 οχήματα που πληρούν τη συνθήκη.

-- ΜΕΡΟΣ Β!
-- Γίνεται χρήση της σχεσιακής βάσης δεδομένων των ναυτικών/σκαφών/μαρίνων
-- 1. Σκάφη των οποίων έχουν γίνει δύο ή περισσότερες κρατήσεις. Να εμφανιστούν ο κωδικός και ο συνολικός αριθμός των κρατήσεων που έχουν γίνει για το κάθε ένα σκάφος.
-- ΛΥΣΗ:
SELECT r.bid, COUNT(*) FROM reservation r
GROUP BY r.bid
HAVING COUNT(r.bid) > 1;

-- 2. Σκάφη (κωδικός και όνομα) τα οποία νοικιάστηκαν τουλάχιστον δύο φορές το ίδιο έτος.
-- ΛΥΣΗ:
SELECT DISTINCT b.bname, b.bid FROM reservation r
	JOIN boat b ON (r.bid = b.bid)
	GROUP BY b.bid, b.bname, EXTRACT(YEAR FROM r.r_date) 
	HAVING COUNT(*) > 1;

-- 3. Πλήθος ενοικιάσεων μπλε (‘Blue’) σκαφών ανά έτος, με ταξινόμηση ως προς το έτος, κατά φθίνουσα τάξη.
SELECT COUNT(r.sid), EXTRACT(YEAR FROM r.r_date) AS ryear FROM reservation r
	JOIN boat b ON (r.bid = b.bid)  WHERE b.color = 'Blue'
	GROUP BY ryear ORDER BY ryear DESC;
	
-- 4. Μαρίνες (κωδικός και όνομα) από τις οποίες έχουν νοικιαστεί/παραληφθεί όλα ανεξαιρέτως τα σκάφη χρώματος κόκκινου ('Red').
-- ΛΥΣΗ: Με EXCEPT
SELECT m.mid, m.name FROM marina m
	WHERE NOT EXISTS 
	(SELECT b.bid FROM boat b WHERE b.color = 'Red'
	EXCEPT
	SELECT r.bid FROM reservation r WHERE r.mid = m.mid);
-- ΕΝΑΛΛΑΚΤΙΚΑ: Με 2 ΑΡΝΗΣΕΙΣ
SELECT m.mid, m.name FROM marina m
	WHERE NOT EXISTS 
	(SELECT b.bid FROM boat b WHERE b.color = 'Red' AND NOT EXISTS
	(SELECT r.bid FROM reservation r WHERE r.mid = m.mid AND r.bid = b.bid));

-- 5. Οι περισσότερες ενοικιάσεις κόκκινων (‘Red’) σκαφών ανά έτος.
-- Σημείωση: η άσκηση να λυθεί και με τη δημιουργία κατάλληλης όψης (View).
-- ΛΥΣΗ: 
SELECT MAX(w.r_count) FROM
(SELECT COUNT(*) AS r_count, EXTRACT(YEAR FROM r.r_date) AS ryear FROM reservation r
JOIN boat b ON (r.bid = b.bid)
	WHERE b.color = 'Red'
GROUP BY ryear) AS w;
-- ΜΕ ΔΗΜΙΟΥΡΓΙΑ ΤΟΥ VIEW:
CREATE VIEW redcount_per_year AS	
(SELECT COUNT(*) AS r_count, EXTRACT(YEAR FROM r.r_date) AS ryear FROM reservation r
JOIN boat b ON (r.bid = b.bid)
	WHERE b.color = 'Red'
GROUP BY ryear);
-- ΕΚΤΕΛΕΣΗ ΤΟΥ VIEW
SELECT MAX(r_count) FROM redcount_per_year;

-- 6. Αριθμός ενοικιάσεων χρώματος σκάφους ανά έτος, με ταξινόμηση ως προς το χρώμα και για το ίδιο χρώμα ως προς το έτος, κατά φθίνουσα τάξη.
-- ΛΥΣΗ: 
SELECT b.color, EXTRACT(YEAR FROM r.r_date) AS rent_year, COUNT(*) AS rent_count FROM boat b
	JOIN reservation r ON (b.bid = r.bid)
	GROUP BY b.color, rent_year ORDER BY b.color, rent_year DESC;

-- 7. Χρώμα(-τα) στο(-α) οποίo(-α) αντιστοιχεί το μεγαλύτερο πλήθος ενοικιάσεων σκαφών, γενικά.
-- ΛΥΣΗ:
SELECT b.color FROM boat b JOIN reservation r ON (r.bid = b.bid)
GROUP BY b.color
HAVING COUNT(*) = (SELECT MAX(tmp.num) FROM (
	SELECT b.color, COUNT(*) AS num FROM boat b JOIN reservation r ON (r.bid = b.bid)
	GROUP BY b.color) AS tmp);
	
-- Σημείωση: η άσκηση να λυθεί και με τη δημιουργία κατάλληλης όψης (View).
-- ΛΥΣΗ: 
CREATE VIEW count_colors AS 
(SELECT b.color, COUNT(b.color) AS color_count FROM boat b
	JOIN reservation r ON (b.bid = r.bid)
	GROUP BY b.color ORDER BY color_count)
SELECT color FROM count_colors WHERE color_count = (SELECT MAX(COLOR_COUNT) FROM count_colors);

-- ΜΕ ΠΡΟΣΩΡΙΝΉ ΟΨΗ.
WITH tmp AS (
SELECT b.color, COUNT(b.color) AS color_count FROM boat b
	JOIN reservation r ON (b.bid = r.bid)
	GROUP BY b.color)
SELECT t.color FROM tmp t WHERE t.color_count = (SELECT MAX(color_count) FROM tmp);

	
-- 8. Το χρώμα ή τα χρώματα με τις περισσότερες κρατήσεις ανά έτος, σε σχέση με όλα τα υπόλοιπα χρώματα και έτη που καταχωρεί η βάση.
-- Προσοχή: ζητείται το χρώμα “νικητής” για όλα τα έτη που καταχωρεί η βάση, όχι το χρώμα με τις περισσότερες κρατήσεις στο κάθε ένα έτος.
-- Σημείωση: η άσκηση να λυθεί και με τη δημιουργία κατάλληλης όψης (View).

-- 9. Να δημιουργηθεί όψη PC με τα στοιχεία των ναυτικών και των σκαφών που αφορούν σε ενοικιάσεις που έχουν γίνει από την μαρίνα με όνομα ‘Πόρτο Καρράς’
-- ΛΥΣΗ: 
CREATE VIEW PC AS
	(SELECT s.*, b.* FROM reservation r
	JOIN boat b ON (r.bid = b.bid)
	JOIN sailor s ON (r.sid = s.sid)
	JOIN marina m ON (r.mid = m.mid)
	WHERE m.name = 'Πόρτο Καρράς');
	
-- 10. Χρησιμοποιήστε την παραπάνω όψη PC για να υπολογίσετε το πλήθος των (διακριτών) σκαφών που έχουν φιλοξενηθεί στη μαρίνα ‘Πόρτο Καρράς’.
-- ΛΥΣΗ: 
SELECT COUNT(DISTINCT bid) FROM PC;

-- 11. Ομαδοποιήστε το περιεχόμενο της παραπάνω όψης PC ανά ναύτη και δημιουργήστε νέα όψη PCS με το πλήθος των ενοικιάσεων σκαφών που έχει κάνει κάθε ένας ναύτης από την μαρίνα ‘Πόρτο Καρράς’, συμπεριλαμβάνοντας και ναυτικούς οι οποίοι έχουν νοικάσει μηδέν (0) σκάφη από την μαρίνα ‘Πόρτιο Καρράς’.
-- ΛΥΣΗ: 
CREATE VIEW PCS AS 
	(
	SELECT sid, sname, rating, age, COUNT(*) FROM PC
	GROUP BY sid, sname, rating, age
	UNION
	SELECT s1.sid, s1.sname, s1.rating, s1.age, 0 FROM sailor s1
	WHERE s1.sid NOT IN (SELECT PC.sid FROM PC)
	);

-- 12. Χρησιμοποιήστε τα παραπάνω (ίσως: δημιουργώντας ακόμη μία όψη) για να υπολογίσετε τα στοιχεία των ναυτικών των οποίων η ηλικία παρουσιάζει τον μεγαλύτερο μέσο αριθμό ενοικιάσεων σκαφών από τη Μαρίνα ‘Πόρτο Καρράς’ . Έχοντας ολοκληρώσει με τη λύση της άσκησης, αναλογιστείτε το βαθμό δυσκολίας που θα χαρακτήριζε την τελευταία στην περίπτωση που δεν ήταν δυνατή η δημιουργία και η χρήση όψεων.
-- ΛΥΣΗ: ΜΕ ΠΡΟΣΩΡΙΝΟ VIEW
WITH tmp_avg_age AS (
	SELECT age, AVG(COUNT) as avg_age FROM PCS
	GROUP BY age
	)
	SELECT * FROM sailor WHERE age = (SELECT age FROM tmp_avg_age WHERE avg_age = (SELECT MAX(avg_age) FROM tmp_avg_age))

-- 13. Να απαντηθούν τα των παραπάνω ασκήσεων 9,10,11 και 12 χωρίς τη δημιουργία (μόνιμων) όψεων, αλλά με τη χρήση της συνιστώσας σύνταξης WITH…. SELECT… (δηλ. με όψεις βραχείας διάρκειας).
-- ΛΥΣΗ: 
-- η 9 (ΘΕΛΕΙ ΔΙΟΡΘΩΣΗ)
WITH tmp9 AS 
	(
	SELECT s.*, b.* FROM reservation r
	JOIN boat b ON (r.bid = b.bid)
	JOIN sailor s ON (r.sid = s.sid)
	JOIN marina m ON (r.mid = m.mid)
	WHERE m.name = 'Πόρτο Καρράς'
	)
	SELECT * FROM tmp9;

-- η 10
WITH tmp10 AS (SELECT COUNT(DISTINCT bid) FROM PC) SELECT * FROM tmp10;

-- η 11
WITH tmp11 AS 
	(
	SELECT sid, sname, rating, age, COUNT(*) FROM PC
	GROUP BY sid, sname, rating, age
	UNION
	SELECT s1.sid, s1.sname, s1.rating, s1.age, 0 FROM sailor s1
	WHERE s1.sid NOT IN (SELECT PC.sid FROM PC)
	) SELECT * FROM tmp11;

