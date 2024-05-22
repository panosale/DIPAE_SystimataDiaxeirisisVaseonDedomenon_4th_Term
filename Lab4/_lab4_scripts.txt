
-- 1. Να συνταχθεί κώδικας SQL SELECT που υπολογίζει τα στοιχεία του ιδιοκτήτη του οχήματος με κωδικό 'SO 02 PSP'.
SELECT * FROM keeper WHERE id = (SELECT keeper FROM vehicle WHERE id = 'SO 02 PSP')
Ή
SELECT k.id, k.name, k.address FROM keeper AS k 
	JOIN vehicle AS v ON (k.id = v.keeper)
	WHERE v.id = 'SO 02 PSP'

-- 2. Να υπολογιστεί ο αριθμός (πλήθος) των καμερών που καταγράφουν οχήματα που εισέρχονται (ΙΝ) στο δακτύλιο.
SELECT COUNT(c.id) AS "Number of IN cameras" FROM camera AS c WHERE perim = 'IN'

-- 3. Να εμφανιστούν τα στοιχεία των φωτογραφιών που έχει καταγράψει η κάμερα με κωδικό 10 πριν την 28η Φεβρουαρίου 2007.
SELECT * FROM image AS i
	WHERE camera = 10 AND whn < '2007-02-28';

-- 4. Να εμφανιστούν οι αριθμοί κυκλοφορίας των αυτοκινήτων τα οποία φωτογραφήθηκαν και επαναφωτογραφήθηκαν εκ νέου από την ίδια ή από διαφορετικές κάμερα(-ες) μέσα σε διάστημα μικρότερο ή ίσο του ενός λεπτού.

-- 5. Να εμφανιστεί το σύνολο των στοιχείων των ιδιοκτητών οχημάτων των οποίων οι άδειες/πάσσο εκδόθηκαν την 30η Ιανουαρίου 2007, μία μόνον φορά ο κάθε ένας ιδιοκτήτης και ταξινομημένα κατά φθίνουσα τάξη ως προς το όνομα του ιδιοκτήτη.
SELECT DISTINCT k.id, k.name, k.address FROM keeper k
	JOIN vehicle v ON (k.id = v.keeper)
	JOIN permit p ON (v.id = p.reg)
	WHERE p.sdate = '2007-01-30'
	ORDER BY k.name DESC

-- 6. Τα στοιχεία των πολιτών (μία φορά ο κάθε ένας πολίτης στο αποτέλεσμα) οχήματα των οποίων έχουν καταγραφεί και από την κάμερα με κωδικό 2, και από την κάμερα με κωδικό 5. Το αποτέλεσμα να υπολογιστεί με τη χρήση του IN.
SELECT DISTINCT k.id, k.name, k.address FROM keeper k
	JOIN vehicle v ON (k.id = v.keeper)
	JOIN image i ON (v.id = i.reg)
	WHERE i.camera IN (2, 5)
Ή
SELECT DISTINCT k.id, k.name, k.address FROM keeper k
	JOIN vehicle v ON (k.id = v.keeper)
	JOIN image i ON (v.id = i.reg)
	WHERE i.camera = 2 AND k.id IN (SELECT DISTINCT k.id FROM keeper k
			JOIN vehicle v ON (k.id = v.keeper)
			JOIN image i ON (v.id = i.reg)
			WHERE i.camera = 5)

-- 7. Τα στοιχεία των πολιτών (μία φορά ο κάθε ένας πολίτης στο αποτέλεσμα) οχήματα των οποίων έχουν καταγραφεί και από την κάμερα με κωδικό 2, και από την κάμερα με κωδικό 5. Το αποτέλεσμα να υπολογιστεί με τη χρήση του INTERSECT.
SELECT DISTINCT k.id, k.name, k.address FROM keeper k
	JOIN vehicle v ON (k.id = v.keeper)
	JOIN image i ON (v.id = i.reg)
	WHERE i.camera = 2
INTERSECT
SELECT DISTINCT k.id, k.name, k.address FROM keeper k
	JOIN vehicle v ON (k.id = v.keeper)
	JOIN image i ON (v.id = i.reg)
	WHERE i.camera = 5

-- 8. Τα στοιχεία των πολιτών (μία φορά ο κάθε ένας πολίτης στο αποτέλεσμα) οχήματα των οποίων έχουν καταγραφεί και από την κάμερα με κωδικό 2, και από την κάμερα με κωδικό 5. Το αποτέλεσμα να υπολογιστεί με τη χρήση του EXISTS.
SELECT DISTINCT k.id, k.name, k.address FROM keeper k
	JOIN vehicle v ON (k.id = v.keeper)
	JOIN image i ON (v.id = i.reg)
	WHERE i.camera = 2 AND EXISTS (SELECT DISTINCT k.id FROM keeper k
			JOIN vehicle v ON (k.id = v.keeper)
			JOIN image i ON (v.id = i.reg)
			WHERE i.camera = 5 )
Ή
SELECT DISTINCT k.id, k.name, k.address FROM keeper k
	JOIN vehicle v ON (k.id = v.keeper)
	JOIN image i ON (v.id = i.reg)
	WHERE i.camera = 2 AND EXISTS (SELECT DISTINCT k1.id FROM keeper k1
			JOIN vehicle v ON (k1.id = v.keeper)
			JOIN image i ON (v.id = i.reg)
			WHERE i.camera = 5 AND k.id = k1.id)

-- 9.

-- 10.

-- 11. Να δημιουργηθεί όψη Min_Intervals (reg, min_i) κάθε μία γραμμή της οποίας εμφανίζει αριθμό αυτοκινήτου και το χρονικό διάστημα (min_i) που παρήλθε από τη στιγμή της έκδοσης της άδειας εισόδου του οχήματος στο δακτύλιο έως τη στιγμή που φωτογραφήθηκε για πρώτη φορά με τη συγκεκριμένη άδεια από κάμερα του δακτυλίου.

-- 12. Να εμπλουτιστεί η δομή και το περιεχόμενο της όψης Min_Intervals(reg, min_i) που δημιουργήθηκε στην άσκηση 11 με τα στοιχεία του ιδιοκτήτη του αντίστοιχου οχήματος. Τα στοιχεία αυτά να οργανωθούν σε νέα όψη με όνομα και δομή: MIN_Intervals_Owners (Owner_ID, Owner_name, Vehicle, MIN_Interval)

-- 13. Χρησιμοπoιώντας τις όψεις Min_Intervals και MIN_Intervals_Owners των ασκήσεων 11 και 12, να εμφανιστούν το όνομα του ιδιοκτήτη ή των ιδιοκτητών οχήματος(-ων) που φωτογραφήθηκε(-αν) από κάμερα στο ΜΙΚΡΟΤΕΡΟ χρονικό διάστημα min_ που μεσολάβησε από την έκδοση της αντίστοιχης άδειας εισόδου οχήματός τους στο δακτύλιο.

-- 14. Καταργήστε τις όψεις Min_Intervals και MIN_Intervals_Owners που δημιουργήθηκαν στις ασκήσεις 11 και 12 και υπολογίστε το αποτέλεσμα-απάντηση στην άσκηση 13 με τη χρήση όψεων βραχείας διάρκειας (runtime views: σύνταξη WITH …. SELECT…).

-- 15. Βελτιώστε τον κώδικα της άσκησης 14 ώστε να υπολογίζει επιπλέον (ως ακέραιο αριθμούς) τις ημέρες, τις ώρες και τα λεπτά της ώρας που μεσολάβησαν από την έκδοση της άδειας εισόδου στο δακτύλιο έως τη χρονική στιγμή που το όχημα φωτογραφήθηκε για πρώτη φορά από κάμερα του δακτυλίου.

-- 16. Να επιλυθεί η άσκηση με αριθμό 6 της ενότητας SUM and COUNT του SQLZoo (https://sqlzoo.net/wiki/SUM_and_COUNT).

-- 17. Να επιλυθεί η άσκηση με αριθμό 7 της ενότητας SUM and COUNT του SQLZoo (https://sqlzoo.net/wiki/SUM_and_COUNT).

-- 18. Να επιλυθεί η άσκηση με αριθμό 8 της ενότητας SUM and COUNT του SQLZoo (https://sqlzoo.net/wiki/SUM_and_COUNT).
