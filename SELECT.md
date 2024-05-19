### Με Wildcards
SELECT * FROM sailor WHERE sname LIKE '_α%'; _-> ΕΠΙΣΤΡΕΦΕΙ: Οποιοδήποτε όνομα έχει για 2ο γράμμα το 'α'._

### IN, BETWEEN και εμφωλευμένες (nested) SELECT
SELECT * FROM sailor WHERE rating IN (1, 2, 3, 4, 5, 6, 7);

SELECT * FROM sailor WHERE rating BETWEEN 1 AND 7;

SELECT * FROM sailor WHERE rating IN (SELECT rating FROM sailor WHERE rating <= 7);

SELECT * FROM sailor WHERE rating IN (SELECT MAX(rating) FROM sailor);

SELECT * FROM sailor WHERE rating > ANY (SELECT rating FROM sailor WHERE sname = 'Γιάννης');

SELECT * FROM sailor WHERE rating > ALL (SELECT rating FROM sailor WHERE sname = 'Γιάννης');
