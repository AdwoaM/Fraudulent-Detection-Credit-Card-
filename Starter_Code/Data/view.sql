--Count transcation less than $2 per cardholder
CREATE VIEW num_trans_less_2 as
SELECT ch.name as NAME, count(t.id) as num_transactions
FROM (
	SELECT * FROM transaction WHERE amount < 2 ) as t
LEFT JOIN credit_card as cc on t.card=cc.card
LEFT JOIN card_holder as ch on cc.cardholder_id = ch.id
GROUP BY ch.name;

--Top 100 highest transactions recorded between 07:00am and 9:00am
CREATE VIEW highest_transaction as
SELECT *
FROM transaction
WHERE DATE_PART ('hour', date) between 07 and 09
ORDER BY amount DESC
LIMIT 100;

--Top 100 highest transactions recorded for the rest of the day (9:00am to 7:00am)
CREATE VIEW highest_trans_rest_of_the_day as
SELECT *
FROM
(
	SELECT *
	FROM transaction
	WHERE DATE_PART ('hour', date) between 09 and 23
	UNION ALL
	SELECT *
	FROM transaction
	WHERE DATE_PART ('hour', date) between 00 and 06
) as data
ORDER BY amount DESC
LIMIT 100;

--Top 5 merchants susceptible to be hacked by small amounts
CREATE VIEW top_merchants as
SELECT m.name, count(t.id) as num_transactions
FROM merchant as m
LEFT JOIN (
	SELECT *
	FROM transaction WHERE amount < 2
) as t on m.id=t.id_merchant
GROUP BY m.name
ORDER BY num_transactions DESC
LIMIT 5;