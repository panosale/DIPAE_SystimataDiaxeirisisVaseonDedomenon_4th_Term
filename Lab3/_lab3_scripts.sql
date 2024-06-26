/* ΜΕΡΟΣ Α */
/* SQL Zoo - https://sqlzoo.net/wiki/Using_Null */
/* (α) USING NULL (όχι την άσκηση 8) */
/* 1 */
SELECT name FROM teacher WHERE dept IS NULL;

/* 2 */
SELECT teacher.name AS TeacherName, dept.name AS DeptName
 	FROM teacher INNER JOIN dept
        ON (teacher.dept=dept.id)

/* 3 */
SELECT teacher.name AS TeacherName, dept.name AS DeptName
	FROM teacher LEFT JOIN dept
        ON (teacher.dept=dept.id)

/* 4 */
SELECT teacher.name AS TeacherName, dept.name AS DeptName
	FROM teacher RIGHT OUTER JOIN dept
        ON (teacher.dept=dept.id)

/* 5 */
SELECT teacher.name, COALESCE(teacher.mobile, '07986 444 2266')
 	FROM teacher

/* 6 */
SELECT teacher.name, COALESCE(dept.name, 'None')
	FROM teacher
	LEFT OUTER JOIN dept ON (teacher.dept=dept.id)
/* 7 */
SELECT COUNT(T1.name), COUNT(T1.mobile) FROM teacher T1

/* 9 */
SELECT name, 
	CASE 
		WHEN dept IN (1, 2) THEN 'Sci'
		ELSE 'Art'
	END
FROM teacher

/* 10 */
SELECT name, 
	CASE 
		WHEN dept IN (1, 2) THEN 'Sci'
		WHEN dept = 3 THEN 'Art'
		ELSE 'None'
	END
FROM teacher

/* (β) Self JOIN (μόνον τις ασκήσεις 3,6,7,8,9) */
/* 3 */
SELECT s.id, s.name FROM stops s 
	JOIN route r ON (s.id = r.stop)
	WHERE r.num = '4'

/* 6 */
SELECT a.company, a.num, stopa.name, stopb.name FROM route a 
	JOIN route b ON (a.company=b.company AND a.num=b.num)
	JOIN stops stopa ON (a.stop=stopa.id)
	JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name = 'London Road'

/* 7 */ ΝΑ ΕΛΕΓΧΘΕΙ */
SELECT R1.company, R1.num FROM route R1, route R2
  WHERE R1.stop = R2.stop AND(R1.stop IN (115, 137) OR R2.stop IN (115, 137))

/* 8 */

/* 9 */

/* (γ) SELECT within SELECT (world database) */
/* 1 */
SELECT name FROM world WHERE population >
	(SELECT population FROM world WHERE name='Russia')

/* 2 */ ΝΑ ΕΛΕΓΧΘΕΙ */
SELECT name FROM world
  WHERE continent = 'Europe' AND gdp >
     (SELECT grdFROM world
      WHERE name= 'United Kingdom')

/* 3 */
SELECT name, continent FROM world WHERE continent IN 
	(SELECT continent FROM world WHERE name IN ('Argentina', 'Australia'))

/* 4 */
SELECT name, population FROM world WHERE population > 
	(SELECT population FROM world WHERE name = 'United Kingdom')
	AND population < (SELECT population FROM world WHERE name = 'Germany')

/* 7 */
SELECT continent, name, area FROM world x WHERE area >= ALL
	(SELECT area FROM world y WHERE y.continent = x.continent AND area > 0)


/* ΜΕΡΟΣ Β */
/* 2 */
SELECT s.sid, s.sname FROM sailor s
EXCEPT
SELECT s.sid, s.sname FROM sailor s
	JOIN reservation r on (s.sid = r.sid)
	JOIN boat b on (b.bid = r.bid) WHERE b.color <> 'Red';

/* 3 */
SELECT S.sid AS "Sailor ID", S.sname AS "Sailor name" FROM reservation R JOIN boat B ON B.bid = R.bid AND B.color = 'Red'
	RIGHT OUTER JOIN sailor S ON S.sid = R.sid
	WHERE R.r_date IS NULL

/* 4 */
SELECT DISTINCT M.mid AS "Marina ID", M.name AS "Marina name" FROM marina M
	JOIN reservation R ON (R.mid = M.mid)
	JOIN boat B ON (B.bid = R.bid)
	WHERE B.color = 'Red';
/* Ή */
SELECT DISTINCT M.mid AS "Marina ID", M.name AS "Marina name" FROM marina M
	JOIN reservation R ON (R.mid = M.mid)
	JOIN boat B ON (B.bid = R.bid AND B.color = 'Red')

/* 5 */
SELECT S.sid, S.sname FROM sailor S
	LEFT OUTER JOIN reservation R ON S.sid = R.sid
	WHERE R.bid IS NULL
