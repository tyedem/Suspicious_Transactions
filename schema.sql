DROP TABLE IF EXISTS cardholder CASCADE;
DROP TABLE IF EXISTS credit_card CASCADE;
DROP TABLE IF EXISTS merchant_category CASCADE;
DROP TABLE IF EXISTS merchant CASCADE;
DROP TABLE IF EXISTS transaction CASCADE;

--Create tables, set data types and constraints, assign PKs and FKs
CREATE TABLE cardholder (
    id SERIAL   NOT NULL,
    name VARCHAR(50)   NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE credit_card (
    card VARCHAR(20)   NOT NULL,
    cardholder_id SERIAL   NOT NULL,
	PRIMARY KEY (card),
	FOREIGN KEY (cardholder_id) REFERENCES cardholder(id)
);

CREATE TABLE "merchant_category" (
    "id" SERIAL   NOT NULL,
    "name" VARCHAR(50)   NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE "merchant" (
    "id" SERIAL   NOT NULL,
    "name" VARCHAR(50)   NOT NULL,
    "id_merchant_category" SERIAL   NOT NULL,
    PRIMARY KEY (id),
	FOREIGN KEY (id_merchant_category) REFERENCES merchant_category(id)
);

CREATE TABLE "transaction" (
    "id" SERIAL   NOT NULL,
    "date" TIMESTAMP   NOT NULL,
    "amount" FLOAT   NOT NULL,
    "card" VARCHAR(20)   NOT NULL,
    "id_merchant" SERIAL   NOT NULL,
	FOREIGN KEY (card) REFERENCES credit_card(card),
	FOREIGN KEY (id_merchant) REFERENCES merchant(id)
);

--Validate CSV data import
SELECT * FROM cardholder;
SELECT * FROM credit_card;
SELECT * FROM merchant;
SELECT * FROM merchant_category;
SELECT * FROM transaction;
