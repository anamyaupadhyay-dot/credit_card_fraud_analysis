CREATE DATABASE IF NOT EXISTS finance;

USE finance;

-- ======= Create the credit_card_transactions======--

CREATE TABLE credit_card_transactions (
    txn_index              INT           NOT NULL,
    trans_date_trans_time  DATETIME      NOT NULL,
    cc_num                 VARCHAR(25)   NOT NULL,
    merchant               VARCHAR(60)   NOT NULL,
    category               VARCHAR(20)   NOT NULL,
    amt                    DECIMAL(10,2) NOT NULL,
    first_name             VARCHAR(50)   NOT NULL,
    last_name              VARCHAR(50)   NOT NULL,
    gender                 CHAR(1)       NOT NULL,
    street                 VARCHAR(100)  NOT NULL,
    city                   VARCHAR(60)   NOT NULL,
    state                  CHAR(2)       NOT NULL,
    zip                    CHAR(5)       NOT NULL,
    latitude               DECIMAL(9,4)  NOT NULL,
    longitude              DECIMAL(9,4)  NOT NULL,
    city_pop               INT           NOT NULL,
    job                    VARCHAR(100)  NOT NULL,
    dob                    DATE          NOT NULL,
    trans_num              CHAR(32)      NOT NULL,
    is_fraud               TINYINT       NOT NULL
);

SELECT* FROM credit_card_transactions;

-- ---Total number of transactions (42,308)-----
SELECT COUNT(*) AS  total_transactions
FROM credit_card_transactions;

-- -------Top 10 most frequent merchants-------
 SELECT merchant, COUNT(*) AS transaction_count
FROM credit_card_transactions
GROUP BY merchant
ORDER BY transaction_count DESC
LIMIT 10;


-- ----Average transaction amount for each category----
SELECT category, ROUND(AVG(amt), 2) AS avg_amount
FROM credit_card_transactions
GROUP BY category
ORDER BY avg_amount DESC;

-- ------Number of fraudulent transactions and their percentage (180 and 0.43%)----
SELECT SUM(is_fraud) AS fraud_transactions,
       COUNT(*) AS total_transactions,
       ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_percentage
FROM credit_card_transactions;


-- ------- To get lat/long of each transaction------
SELECT trans_num, trans_date_trans_time, cc_num, amt, latitude, `longitude`
FROM credit_card_transactions
LIMIT 10;

-- ---City with the highest population (Houston, TX)----
SELECT city, state, MAX(city_pop) AS population
FROM credit_card_transactions
GROUP BY city, state
ORDER BY population DESC
LIMIT 1;


-- ---Earliest and latest transaction dates---
SELECT MIN(trans_date_trans_time) AS earliest_transaction,
       MAX(trans_date_trans_time) AS latest_transaction
FROM credit_card_transactions;

-- ===================== TASK 6: DATA AGGREGATION =====================

-- ---=== Total amount spent across all transactions (2,966,148.83)========
SELECT ROUND(SUM(amt), 2) AS total_amount_spent
FROM  credit_card_transactions;

-- ========= Number of transactions in each category================
SELECT category, COUNT(*) AS transaction_count
FROM   credit_card_transactions
GROUP BY category
ORDER BY transaction_count DESC;

-- ==========Average transaction amount for each gender=======================
SELECT gender, ROUND(AVG(amt), 2) AS avg_amount
FROM credit_card_transactions
GROUP BY gender;

-- =================Day of the week with the highest average transaction amount (Monday)=========
SELECT DAYNAME(trans_date_trans_time) AS day_of_week,
       ROUND(AVG(amt), 2) AS avg_amount
FROM credit_card_transactions
GROUP BY day_of_week
ORDER BY avg_amount DESC
LIMIT 1;
