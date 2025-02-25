CREATE DATABASE BANK;
USE BANK;
----------------------------------------TABLE CREATION SCRIPT--------------------------------------------
CREATE TABLE DISTRICT(
District_Code INT PRIMARY KEY	,
District_Name VARCHAR(100)	,
Region VARCHAR(100)	,
No_of_inhabitants	INT,
No_of_municipalities_with_inhabitants_less_499 INT,
No_of_municipalities_with_inhabitants_500_btw_1999	INT,
No_of_municipalities_with_inhabitants_2000_btw_9999	INT,
No_of_municipalities_with_inhabitants_greater_10000 INT,	
No_of_cities	INT,
Ratio_of_urban_inhabitants	FLOAT,
Average_salary	INT,
No_of_entrepreneurs_per_1000_inhabitants	INT,
No_committed_crime_2017	INT,
No_committed_crime_2018 INT
) ;

CREATE TABLE ACCOUNT(
account_id INT PRIMARY KEY,
district_id	INT,
frequency	VARCHAR(40),
`Date` DATE ,
Account_type VARCHAR(40),
FOREIGN KEY (district_id) references DISTRICT(District_Code) 
);

CREATE TABLE `ORDER`(
order_id	INT PRIMARY KEY,
account_id	INT,
bank_to	VARCHAR(45),
account_to	INT,
amount FLOAT,
FOREIGN KEY (account_id) references ACCOUNT(account_id)
);

CREATE TABLE LOAN(
loan_id	INT ,
account_id	INT,
amount	INT,
duration	INT,
payments	INT,
`status` VARCHAR(35),
`Date`	DATE,
FOREIGN KEY (account_id) references ACCOUNT(account_id)
);

CREATE TABLE TRANSACTIONS(
trans_id INT,	
account_id	INT,
`Date`	DATE,
`Type`	VARCHAR(30),
operation	VARCHAR(40),
amount	INT,
balance	FLOAT,
Purpose	VARCHAR(40),
bank	VARCHAR(45),
`account` INT,
FOREIGN KEY (account_id) references ACCOUNT(account_id));

CREATE TABLE CLIENT(
client_id	INT PRIMARY KEY,
district_id INT,
Birth_date	DATE,
Sex	CHAR(10),
FOREIGN KEY (district_id) references DISTRICT(District_Code) 
);

CREATE TABLE DISPOSITION(
disp_id	INT PRIMARY KEY,
client_id INT,
account_id	INT,
`type` CHAR(15),
FOREIGN KEY (account_id) references ACCOUNT(account_id),
FOREIGN KEY (client_id) references CLIENT(client_id)
);

CREATE TABLE CARD(
card_id	INT PRIMARY KEY,
disp_id	INT,
`type` CHAR(10)	,
issued DATE,
FOREIGN KEY (disp_id) references DISPOSITION(disp_id)
);

---------------------------------storage integration-----------
CREATE OR REPLACE STORAGE integration s3_int
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN ='arn:aws:iam::696715000900:role/bankingrole'
STORAGE_ALLOWED_LOCATIONS =('s3://transactionsnew1/');

DESC integration s3_int;
drop integration s3_int;

--------------------creating stageing area----------------
CREATE OR REPLACE STAGE BANK
URL ='s3://transactionsnew1'
file_format = CSV
storage_integration = s3_int;

LIST @BANK;
drop stage bank;
SHOW STAGES;

----------------creating pipe--------------------
CREATE OR REPLACE PIPE BANK_SNOWPIPE_TXNS AUTO_INGEST = TRUE AS
COPY INTO "BANK"."PUBLIC"."TRANSACTIONS"
FROM '@BANK/transaction/'
FILE_FORMAT = CSV;

CREATE OR REPLACE PIPE BANK_SNOWPIPE_DISTRICT AUTO_INGEST = TRUE AS
COPY INTO "AUTOMATION_BANK_DATASET"."PUBLIC"."DISTRICT"
FROM '@BANK/District/'
FILE_FORMAT = CSV;

CREATE OR REPLACE PIPE BANK_SNOWPIPE_ACCOUNT AUTO_INGEST = TRUE AS
COPY INTO "AUTOMATION_BANK_DATASET"."PUBLIC"."ACCOUNT"
FROM '@BANK/Account/'
FILE_FORMAT = CSV;

CREATE OR REPLACE PIPE BANK_SNOWPIPE_DISP AUTO_INGEST = TRUE AS
COPY INTO "AUTOMATION_BANK_DATASET"."PUBLIC"."DISPOSITION"
FROM '@BANK/disp/'
FILE_FORMAT = CSV;

CREATE OR REPLACE PIPE BANK_SNOWPIPE_CARD AUTO_INGEST = TRUE AS
COPY INTO "AUTOMATION_BANK_DATASET"."PUBLIC"."CARD"
FROM '@BANK/Card/'
FILE_FORMAT = CSV;

CREATE OR REPLACE PIPE BANK_SNOWPIPE_ORDER AUTO_INGEST = TRUE AS
COPY INTO "AUTOMATION_BANK_DATASET"."PUBLIC"."`ORDER`"
FROM '@BANK/Order/'
FILE_FORMAT = CSV;

CREATE OR REPLACE PIPE BANK_SNOWPIPE_LOAN AUTO_INGEST = TRUE AS
COPY INTO "AUTOMATION_BANK_DATASET"."PUBLIC"."LOAN"
FROM '@BANK/Loan/'
FILE_FORMAT = CSV;

CREATE OR REPLACE PIPE BANK_SNOWPIPE_CLIENT AUTO_INGEST = TRUE AS
COPY INTO "AUTOMATION_BANK_DATASET"."PUBLIC"."CLIENT"
FROM '@BANK/Client/'
FILE_FORMAT = CSV;

SHOW PIPES;

ALTER PIPE BANK_SNOWPIPE_TXNS refresh;

ALTER PIPE BANK_SNOWPIPE_DISTRICT refresh;

ALTER PIPE BANK_SNOWPIPE_ACCOUNT refresh;

ALTER PIPE BANK_SNOWPIPE_DISP refresh;

ALTER PIPE BANK_SNOWPIPE_CARD refresh;

ALTER PIPE BANK_SNOWPIPE_ORDER refresh;

ALTER PIPE BANK_SNOWPIPE_LOAN refresh;

ALTER PIPE BANK_SNOWPIPE_CLIENT refresh;

select count(*) from TRANSACTIONS;
select count(*) from `ORDER`;
select count(*) from LOAN;
select count(*) from ACCOUNT;
select count(*) from DISTRICT;
select count(*) from DISP;
select count(*) from CARD;
select count(*) from CLIENT;

SELECT * FROM DISTRICT;
SELECT * FROM ACCOUNT;
SELECT * FROM TRANSACTIONS;
SELECT * FROM DISPOSITION;
SELECT * FROM CARD;
SELECT * FROM `ORDER`;
SELECT * FROM LOAN;