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
--there is strong likelihood there is some fraud occurring in this set of 350 transactions,
--which represents 10% of the total transactions in this dataset.

--Create view of top 100 highest transactions  between 7:00am and 9:00am
CREATE VIEW top_100_7am_to_9am AS
SELECT *
FROM transaction as a
WHERE date_part ('hour', date) >= 7 and date_part ('hour', date) < 9
ORDER by amount DESC
LIMIT 100;
-- There are 7 transactions over $1000, one at $748 and one at $100. The rest are less than $25.
