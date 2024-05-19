#
## Η MAX() στην Σχεσιακή Άλγεβρα - MAX() in Relational Algebra
1) Serves ⨯ ρnewServes (Serves)
2) σServes.price < newServes.price (Serves ⨯ ρnewServes Serves)
3) πServes.price (σServes.price < newServes.price (Serves ⨯ ρnewServes Serves))
4) πprice Serves - (πServes.price (σServes.price < newServes.price (Serves ⨯ ρnewServes Serves)))

#

## SQL χωρίς την MAX()
1) SELECT * FROM Serves s1, Serves s2
2) SELECT * FROM Serves s1, Serves s2 WHERE s1.price < s2.price
3) SELECT DISTINCT s1.price FROM Serves s1, Serves s2 WHERE s1.price < s2.price
4) SELECT s.price FROM Serves s     EXCEPT SELECT s1.price FROM Serves s1, Serves s2 WHERE s1.price < s2.price

#

## SQL με την MAX()
1) SELECT MAX(price) FROM Serves
