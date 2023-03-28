USE WAREHOUSE DEMO;
USE DATABASE DEMO_DATABASE;

----------------------------------------------------------TASK1---------------------------------------------------------------------

CREATE OR REPLACE TABLE SHOPPING_HISTORY
(PRODUCT VARCHAR(30) NOT NULL,
 QUANTITY INTEGER NOT NULL,
 UNIT_PRICE INTEGER NOT NULL
);
INSERT INTO SHOPPING_HISTORY
VALUES('MILK',3,10),
('BREAD',5,2),
('BREAD',7,3);

SELECT * FROM SHOPPING_HISTORY;

ALTER TABLE SHOPPING_HISTORY
ADD COLUMN TOTAL_PRICE INTEGER ;

UPDATE SHOPPING_HISTORY
SET TOTAL_PRICE= QUANTITY*UNIT_PRICE;

select product,sum(total_price) as total_price

from shopping_history
group by product;


----------------------------------------------------------TASK2------------------------------------------------------------------------------

create or replace table phones(
  name varchar(30) not null unique,
  phone_number integer  not null unique
);


insert into phones
values('John',6356),
('Addison',4315),
('Kate',8003),
('Jinny',9831);

select * from phones;


create or replace table calls(
id integer not null,
  caller integer not null,
  callee integer not null,
  duration integer not null,
  unique(id)
);

insert into calls
values(65,8003,9831,7),
(100,9831,8003,3),
(145,4315,9831,18);

select * from calls;


with call_duration as (select caller as phone_number, sum(duration) as duration from calls group by caller
union
select callee as phone_number, sum(duration) as duration from calls group by callee) 
SELECT name
FROM phones inner join call_duration cd on cd.phone_number = phones.phone_number
GROUP BY name
HAVING SUM(duration) >= 10
ORDER BY name;

---------------------------------------------------------------------------------TASK3-----------------------------------------------------------------------------------


CREATE TABLE TRANSACTIONS(
AMOUNT INTEGER NOT NULL,
DATE DATE NOT NULL);
INSERT INTO TRANSACTIONS (AMOUNT,DATE)
VALUES(1000,'2020-01-06'),
(-10,'2020-01-14'),
(-75,'2020-01-20'),
(-5,'2020-01-25'),
(-4,'2020-01-29'),
(2000,'2020-03-10'),
(-75,'2020-03-12'),
(-20,'2020-03-15'),
(40,'2020-03-15'),
(50,'2020-03-17'),
(-200,'2020-10-10'),
(200,'2020-10-10');

SELECT * FROM TRANSACTIONS;


SELECT SUM(AMOUNT) FROM TRANSACTIONS;


SELECT SUM(amount) + (5 - IFNULL(SUM(CASE WHEN amount < 0 THEN amount END), 0)) AS balance
FROM transactions t
LEFT JOIN 
    (SELECT YEAR(date) as date_year, MONTH(date) as date_month 
    FROM transactions 
    GROUP BY YEAR(date), MONTH(date) 
    HAVING SUM(CASE WHEN amount < 0 THEN amount END) >= 100 
    AND COUNT(CASE WHEN amount < 0 THEN amount END) >= 3) AS fee_paid
ON YEAR(t.date) = fee_paid.date_year 
    AND MONTH(t.date) = fee_paid.date_month;

