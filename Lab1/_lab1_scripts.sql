/* Ερώτημα 9 */
select distinct titlos_tainias from symmetoxi
where (eponimo_ithopoiou = 'Redford' and onoma_ithopoiou = 'Robert')
or (eponimo_ithopoiou = 'Dillman' and onoma_ithopoiou = 'Bradford');

/* Ερώτημα 10 */
select distinct titlos_tainias from kinimatografos
where evdomades > 15;

/* Ερώτημα 11 */
select distinct aithousa from kinimatografos
where titlos_tainias = 'Pretty woman';

/* Ερώτημα 12 - Καρτεσιανό γινόμενο */
select * from symmetoxi, kinimatografos;

/* Ερώτημα 13 */
select * from symmetoxi s, kinimatografos k where s.titlos_tainias = k.titlos_tainias;

/* Ερώτημα 14 */
select * from symmetoxi s join kinimatografos k on s.titlos_tainias = k.titlos_tainias;

/* Ερώτημα 15 */
select * from symmetoxi natural join kinimatografos;

/* Ερώτημα 16 */
select distinct titlos_tainias from kinimatografos where aithousa = 'TITANIA' or aithousa = 'VILLAGE';
/* Ή */
select distinct t.titlos from tainia t join kinimatografos k 
on (k.titlos_tainias = t.titlos) and (k.aithousa = 'TITANIA' or k.aithousa = 'VILLAGE');
/* Ή */
select distinct t.titlos from tainia t natural join kinimatografos k 
where (k.titlos_tainias = t.titlos) and (k.aithousa = 'TITANIA' or k.aithousa = 'VILLAGE');

/* Ερώτημα 17 */
select distinct titlos_tainias from kinimatografos where aithousa = 'VILLAGE' and evdomades > 8;
/* Ή */
select distinct t.titlos from tainia t join kinimatografos k
on (k.titlos_tainias = t.titlos) and (k.aithousa = 'VILLAGE' and evdomades > 8);
/* Ή */
select distinct t.titlos from tainia t natural join kinimatografos k
where (k.titlos_tainias = t.titlos) and (k.aithousa = 'VILLAGE' and evdomades > 8);

/* Ερώτημα 18 */
select distinct titlos_tainias from kinimatografos where aithousa = 'TITANIA' or evdomades > 30;
/* Ή */
select distinct t.titlos from tainia t join kinimatografos k
on (k.titlos_tainias = t.titlos) and (k.aithousa = 'TITANIA' or evdomades > 30);
/* Ή */
select distinct t.titlos from tainia t natural join kinimatografos k
where (k.titlos_tainias = t.titlos) and (k.aithousa = 'TITANIA' or evdomades > 30);
