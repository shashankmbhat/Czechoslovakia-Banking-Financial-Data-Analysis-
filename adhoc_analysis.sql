USE BANK;

SELECT * FROM TRANSACTIONS LIMIT 2;
SELECT * FROM LOAN LIMIT 2;

SELECT *,(SELECT MAX(DATE) FROM TRANSACTIONS ) AS TRANS_DATE FROM CLIENT;

SELECT *,(SELECT MAX(DATE) FROM TRANSACTIONS ) AS TRANS_DATE, DATEDIFF(YEAR,BIRTH_DATE,TRANS_DATE) AS AGE FROM CLIENT;


SELECT YEAR(DATE) AS TXN_YEAR, COUNT(*) AS TOT_TXNS
FROM TRANSACTIONS
WHERE BANK IS NULL
GROUP BY 1
ORDER BY 2 DESC;

--NEXT DATA TRANSFORMATION
/*
 CONVERT 2021 TXN_YEAR TO 2022
 CONVERT 2020 TXN_YEAR TO 2021
 CONVERT 2018 TXN_YEAR TO 2020
 CONVERT 2017 TXN_YEAR TO 2019
 CONVERT 2016 TXN_YEAR TO 2018

*/

UPDATE TRANSACTIONS
SET DATE = DATEADD(YEAR,1,DATE)
WHERE YEAR(DATE) = 2021;

UPDATE TRANSACTIONS
SET DATE = DATEADD(YEAR,1,DATE)
WHERE YEAR(DATE) = 2020;

UPDATE TRANSACTIONS
SET DATE = DATEADD(YEAR,2,DATE)
WHERE YEAR(DATE) = 2018;

UPDATE TRANSACTIONS
SET DATE = DATEADD(YEAR,2,DATE)
WHERE YEAR(DATE) = 2017;

UPDATE TRANSACTIONS
SET DATE = DATEADD(YEAR,2,DATE)
WHERE YEAR(DATE) = 2016;

SELECT MIN(DATE) , MAX(DATE) FROM TRANSACTIONS;

SELECT * FROM TRANSACTIONS  WHERE BANK IS NULL AND YEAR(DATE) = 2020;

SELECT DISTINCT BANK, COUNT(*) FROM TRANSACTIONS  WHERE YEAR(DATE) = 2022 GROUP BY 1 ORDER BY 2 DESC;


SELECT distinct bank FROM TRANSACTIONS  WHERE  YEAR(DATE) = 2017;

SELECT COUNT(*) FROM TRANSACTIONS;


UPDATE TRANSACTIONS SET BANK ='Sky Bank' WHERE BANK IS NULL AND YEAR(DATE) = 2022;

UPDATE TRANSACTIONS SET BANK ='DBS' WHERE BANK IS NULL AND YEAR(DATE) = 2021;

UPDATE TRANSACTIONS SET BANK ='Raiffeisen bank' WHERE BANK IS NULL AND  MONTH(DATE) IN (01,02,03);

UPDATE TRANSACTIONS SET BANK ='Bank Creditas' WHERE BANK IS NULL AND  MONTH(DATE) IN (04,05,06);

UPDATE TRANSACTIONS SET BANK ='Moneta Money Bank' WHERE BANK IS NULL AND  MONTH(DATE) IN (07,08,09);

UPDATE TRANSACTIONS SET BANK ='Czech export bank' WHERE BANK IS NULL AND  MONTH(DATE)=10;

UPDATE TRANSACTIONS SET BANK ='Nothern Bank' WHERE BANK IS NULL AND  MONTH(DATE) IN (11,12);

UPDATE TRANSACTIONS SET BANK ='Nothern Bank' WHERE BANK IS NULL AND YEAR(DATE) = 2019;

UPDATE TRANSACTIONS SET BANK ='Southern Bank' WHERE BANK IS NULL AND YEAR(DATE) = 2018;

UPDATE TRANSACTIONS SET BANK ='ADB Bank' WHERE BANK IS NULL AND YEAR(DATE) = 2017;



SELECT YEAR(DATE) AS TXN_YEAR, MONTH(DATE) AS MONTH_DATE, COUNT(*) AS TOT_TXNS
FROM TRANSACTIONS
WHERE BANK IS NULL AND  YEAR(DATE)=2020 AND MONTH(DATE) IN (10,11,12)
GROUP BY 1,2
ORDER BY 2 DESC;

SELECT * FROM CARD;
SELECT COUNT(*) FROM CARD;

SELECT DISTINCT YEAR(ISSUED), COUNT(*) FROM CARD GROUP BY 1; 

UPDATE CARD
SET ISSUED = DATEADD(YEAR,1 , ISSUED)
WHERE YEAR(ISSUED) = 2016;

SELECT DISTINCT YEAR(DATE), COUNT(*) FROM ACCOUNT GROUP BY 1; 
SELECT * FROM DISTRICT;

SHOW TABLES;
SELECT * FROM CLIENT LIMIT 5;
SELECT DISTINCT DISTRICT_ID,COUNT(*) FROM CLIENT GROUP BY 1;
SELECT * FROM DISTRICT LIMIT 4;

SELECT BALANCE.* FROM TRANSACTIONS;

---------------------kpi'S------------------

-- Q1. What is the demographic profile of the bank's clients and how does it vary across districts?
SELECT 
SUM(CASE WHEN SEX='Male' THEN 1 END) AS MALE_CLIENTS ,
SUM(CASE WHEN SEX='Female' THEN 1 END) AS FEMALE_CLIENTS
FROM CLIENT;

SELECT 
SUM(CASE WHEN SEX='Male' THEN 1 ELSE 0 END)/COUNT(*) * 100 AS PCT_MALE_CLIENTS ,
SUM(CASE WHEN SEX='Female' THEN 1 ELSE 0 END)/COUNT(*) * 100 AS PCT_FEMALE_CLIENTS
FROM CLIENT;

SELECT * FROM CLIENT LIMIT 1;
SELECT * FROM DISTRICT LIMIT 1;

SELECT * FROM CLIENT C INNER JOIN    DISTRICT D ON C.DISTRICT_ID=D.DISTRICT_CODE LIMIT 3;

SELECT *,(SELECT MAX(DATE) FROM TRANSACTIONS ) AS TRANS_DATE, DATEDIFF(YEAR,BIRTH_DATE,TRANS_DATE) AS AGE FROM CLIENT;

ALTER TABLE CLIENT ADD COLUMN AGE INT;

UPDATE  CLIENT SET AGE =  DATEDIFF(YEAR,BIRTH_DATE,(SELECT MAX(DATE) FROM TRANSACTIONS));

SELECT * FROM CLIENT LIMIT 4;

SELECT C.DISTRICT_ID, D.DISTRICT_NAME,D.NO_OF_INHABITANTS AS TOTAL_POPULATION, ROUND(AVG(C.AGE),2) AS AVG_AGE, ROUND(AVG(AVERAGE_SALARY),2) AS AVG_SALARY,
SUM(CASE WHEN SEX='Male' THEN 1 ELSE 0 END) AS MALE_CLIENT,
SUM(CASE WHEN SEX='Female' THEN 1 ELSE 0 END)  AS FEMALE_CLIENT,
ROUND((FEMALE_CLIENT/MALE_CLIENT)*100,2) AS MALE_TO_FEMALE_PCT,
COUNT(*) AS TOTAL_CLIENTS
FROM CLIENT C INNER JOIN    DISTRICT D ON C.DISTRICT_ID=D.DISTRICT_CODE
GROUP BY 1,2,3;

CREATE OR REPLACE TABLE DEMOGRAPHIC_KPI AS SELECT C.DISTRICT_ID, D.DISTRICT_NAME,D.NO_OF_INHABITANTS AS TOTAL_POPULATION, ROUND(AVG(C.AGE),2) AS AVG_AGE, ROUND(AVG(AVERAGE_SALARY),2) AS AVG_SALARY,
SUM(CASE WHEN SEX='Male' THEN 1 ELSE 0 END) AS MALE_CLIENT,
SUM(CASE WHEN SEX='Female' THEN 1 ELSE 0 END)  AS FEMALE_CLIENT,
ROUND((FEMALE_CLIENT/MALE_CLIENT)*100,2) AS MALE_TO_FEMALE_PCT,
COUNT(*) AS TOTAL_CLIENTS
FROM CLIENT C INNER JOIN    DISTRICT D ON C.DISTRICT_ID=D.DISTRICT_CODE
GROUP BY 1,2,3;

SELECT * FROM DEMOGRAPHIC_KPI;

---------------2. How the banks have performed obver the years.Give their detailed analysis month wise?---------------------------

--EVERY LAST MONTH CUSTOMER ACCOUNT IS GETTING TXNCTED


SELECT ACCOUNT_ID, YEAR(DATE) AS TXN_YEAR, MONTH(DATE) AS TXN_MONTH, MAX(DATE) AS LATEST_TXN_DATE FROM TRANSACTIONS GROUP BY 1,2,3 ORDER BY 1,2,3;

CREATE OR REPLACE TABLE ACC_LATEST_TXNS_WITH_BALANCE AS
SELECT LTD.*, T.BALANCE FROM TRANSACTIONS T 
INNER JOIN (SELECT ACCOUNT_ID, YEAR(DATE) AS TXN_YEAR,
MONTH(DATE) AS TXN_MONTH,MAX(DATE) AS LATEST_TXN_DATE
FROM TRANSACTIONS GROUP BY 1,2,3 ORDER BY 1,2,3) AS LTD
ON T.ACCOUNT_ID = LTD.ACCOUNT_ID
where T.TYPE='Credit' -- EVERY MONTH END CUSTOMER IS CREDITED WITH SALARY
GROUP BY 1,2,3,4,5;

SELECT COUNT(*) FROM ACC_LATEST_TXNS_WITH_BALANCE  ; --TOTAL COUNT 17454283

SELECT * FROM ACCOUNT LIMIT 3;

CREATE OR REPLACE TABLE  BANKING_KPI  AS 
SELECT 
ALTWB.TXN_YEAR,ALTWB.TXN_MONTH, T.BANK, A.ACCOUNT_TYPE,
COUNT (DISTINCT ALTWB.ACCOUNT_ID) AS TOTAL_ACCOUNTS,
COUNT (DISTINCT T.TRANS_ID) AS TOTAL_TXNS,
COUNT (CASE WHEN T.TYPE = 'Credit' THEN 1 END) AS DEPOSIT_COUNT,
COUNT (CASE WHEN T.TYPE= 'Withdrawal' THEN 1 END) AS WITHDRAWAL_COUNT,
SUM(ALTWB.BALANCE) AS TOTAL_BALANCE,
ROUND(DEPOSIT_COUNT/TOTAL_TXNS*100,2) AS DEPOSIT_PCT,
ROUND(WITHDRAWAL_COUNT/TOTAL_TXNS*100,2) AS WITHDRAWAL_PCT,
NVL(TOTAL_BALANCE/TOTAL_ACCOUNTS,0) AS AVG_BALANCE,
ROUND(TOTAL_TXNS/TOTAL_ACCOUNTS,2) AS TPA --TRANASACTIONS PER ACCOUNT
FROM TRANSACTIONS AS T INNER JOIN ACC_LATEST_TXNS_WITH_BALANCE AS ALTWB 
ON T.ACCOUNT_ID=ALTWB.ACCOUNT_ID LEFT OUTER JOIN ACCOUNT AS A 
ON T.ACCOUNT_ID = A.ACCOUNT_ID
GROUP BY 1,2,3,4  ;


SELECT BANK, TXN_YEAR, ROUND(SUM(AVG_BALANCE),2) AS TOTAL_AVG_BAL FROM BANKING_KPI GROUP BY 1,2;
--HIGHEST AVG BAL BY Moneta Money Bank IN 2022 AMOUNT: 3587979532.79 $

 

SELECT T.BANK,ACC_HAVING_LOAN.LOAN_YEAR,ACC_HAVING_LOAN.LOAN_MONTH,ACC_HAVING_LOAN.STATUS,
       ACC_HAVING_LOAN.ACCOUNT_ID,A.ACCOUNT_TYPE,SUM(ACC_HAVING_LOAN.AMOUNT) AS LOAN_AMOUNT
FROM TRANSACTIONS T INNER JOIN
(SELECT YEAR(DATE) AS LOAN_YEAR, MONTH(DATE) AS LOAN_MONTH,
LOAN.STATUS, ACCOUNT_ID, SUM(AMOUNT) AS AMOUNT 
FROM LOAN GROUP BY 1,2,3,4 ORDER BY 1,2,3,4 ) AS ACC_HAVING_LOAN 
ON T.ACCOUNT_ID = ACC_HAVING_LOAN.ACCOUNT_ID
INNER JOIN ACCOUNT A 
ON ACC_HAVING_LOAN.ACCOUNT_ID = A.ACCOUNT_ID GROUP BY 1,2,3,4,5,6
ORDER BY 1,2,3,4,5,6; --MONTH WISE ANALYSIS OF LOAN AMOUNT FOR ALL BANKS.



CREATE OR REPLACE TABLE LOAN_KPI AS (
SELECT T.BANK,ACC_HAVING_LOAN.LOAN_YEAR,ACC_HAVING_LOAN.LOAN_MONTH,ACC_HAVING_LOAN.STATUS,
       ACC_HAVING_LOAN.ACCOUNT_ID,A.ACCOUNT_TYPE,SUM(ACC_HAVING_LOAN.AMOUNT) AS LOAN_AMOUNT
FROM TRANSACTIONS T INNER JOIN
(SELECT YEAR(DATE) AS LOAN_YEAR, MONTH(DATE) AS LOAN_MONTH,
LOAN.STATUS, ACCOUNT_ID, SUM(AMOUNT) AS AMOUNT 
FROM LOAN GROUP BY 1,2,3,4 ORDER BY 1,2,3,4 ) AS ACC_HAVING_LOAN 
ON T.ACCOUNT_ID = ACC_HAVING_LOAN.ACCOUNT_ID
INNER JOIN ACCOUNT A 
ON ACC_HAVING_LOAN.ACCOUNT_ID = A.ACCOUNT_ID GROUP BY 1,2,3,4,5,6
ORDER BY 1,2,3,4,5,6);

SELECT DISTINCT BANK FROM LOAN_KPI;

SELECT D.ACCOUNT_ID,C.TYPE,C.ISSUED FROM DISPOSITION D INNER JOIN CARD C ON D.DISP_ID= C.DISP_ID;

CREATE TABLE ACC_HAVING_CARD AS (SELECT D.ACCOUNT_ID,C.TYPE,C.ISSUED FROM DISPOSITION D INNER JOIN CARD C ON D.DISP_ID= C.DISP_ID);

WITH CTE(
SELECT * FROM BANKING_KPI;
SELECT * FROM LOAN_KPI;
);

SELECT * FROM LOAN_KPI LIMIT 1;

SELECT DISTINCT AC.TYPE, COUNT(AC.ACCOUNT_ID) AS TOTAL_USERS,SUM(T.balance) AS TOTAL_BALANCE, ROUND(AVG(T.balance),2) AS AVG_BALANCE FROM ACC_HAVING_CARD AC INNER JOIN TRANSACTIONS T ON AC.ACCOUNT_ID=T.ACCOUNT_ID 
GROUP BY 1 ORDER BY 3 DESC;

SELECT TXN_YEAR, COUNT(*) FROM BANKING_KPI GROUP BY 1;

