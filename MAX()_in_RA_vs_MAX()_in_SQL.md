#
## Η MAX() στην Σχεσιακή Άλγεβρα - MAX() in Relational Algebra
#### Serves ⨯ ρnewServes (Serves)
#### σServes.price < newServes.price (Serves ⨯ ρnewServes Serves)
#### πServes.price (σServes.price < newServes.price (Serves ⨯ ρnewServes Serves))
#### πprice Serves - (πServes.price (σServes.price < newServes.price (Serves ⨯ ρnewServes Serves)))

#

## SQL χωρίς την MAX()
#### SELECT * FROM Serves s1, Serves s2
#### SELECT * FROM Serves s1, Serves s2 WHERE s1.price < s2.price
#### SELECT DISTINCT s1.price FROM Serves s1, Serves s2 WHERE s1.price < s2.price
#### SELECT s.price FROM Serves s     EXCEPT SELECT s1.price FROM Serves s1, Serves s2 WHERE s1.price < s2.price

#

## SQL με την MAX()
#### SELECT MAX(price) FROM Serves
