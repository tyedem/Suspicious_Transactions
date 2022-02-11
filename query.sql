SELECT * FROM cardholder;
SELECT * FROM credit_card;
SELECT * FROM merchant;
SELECT * FROM merchant_category;
SELECT * FROM transaction;

-- Perform join on tables cardholder, credit_card, transaction
SELECT *
FROM cardholder as a
INNER JOIN credit_card as b ON a.id = b.cardholder_id
INNER JOIN transaction as c ON b.card = c.card;

--Create view of grouped transactions per cardholder
CREATE VIEW grouped_transactions AS
SELECT name, COUNT(*) as transaction_count
FROM cardholder as a
INNER JOIN credit_card as b ON a.id = b.cardholder_id
INNER JOIN transaction as c ON b.card = c.card
GROUP BY name
ORDER BY name ASC;
--
--View query result
SELECT * FROM grouped_transactions
-- View total transaction count
SELECT COUNT(*) FROM transaction
--

--Create view of transactions which are less than $2.00
--DROP VIEW IF EXISTS less_than_2 CASCADE;
CREATE VIEW less_than_2 AS
Select COUNT(amount)
FROM transaction
WHERE amount < 2;

SELECT * FROM less_than_2;
--Result = 350 transactions
-- Given some fraudsters hack a credit card by making several small $2.00 transactions, 
--there is strong likelihood there is at least some fraud occurring in this set of 350 transactions,
--which represents 10% of the total transactions in this dataset.

--Create view of top 100 highest transactions  between 7:00am and 9:00am
CREATE VIEW top_100_7am_to_9am AS
SELECT *
FROM transaction as a
WHERE date_part ('hour', date) >= 7 and date_part ('hour', date) < 9
ORDER by amount DESC
LIMIT 100;
-- Between 7am and 9am there are 7 transactions over $1000, one at $748 and one at $100. The rest are less than $25.
--High-cost purchases between 7am and 9am are suspicious as they are outlier purchases.
---Smaller suspicious transactions are likely executed throughout the day to test-purchase before making a bigger fraudulent transaction.
--I suspect there are greater number of fraudulent transactions after 9am in order to bury fraudulent transactions
--amongst legitimate transactions in order to obfuscate detection.

SELECT *
FROM transaction as a
WHERE date_part ('hour', date) >= 9
ORDER by amount DESC;
---When analyzing transactions made at or after 9am, most larger purchases are made after 12pm
---with occasional larger purchases before 12pm.

CREATE VIEW top_5_merchants_fraud_risk AS
--Define table columns
SELECT m.name AS merchant, mc.name AS category,
	COUNT(t.amount) AS less_than_2
--Associate keys for table joins
FROM transaction AS t
JOIN merchant as m ON m.id = t.id_merchant
JOIN merchant_category AS mc ON mc.id = m.id_merchant_category
--Assign condition for transactions at less than $2.00
WHERE t.amount < 2
--Group table by name
GROUP BY m.name, mc.name
--Order by decending order with limit of 5
ORDER BY less_than_2 DESC
LIMIT 5;

