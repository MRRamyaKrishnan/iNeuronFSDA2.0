USE  WAREHOUSE DEMO;
USE DATABASE DEMO_DATABASE;

 CREATE OR REPLACE TABLE SALES
 (
 ORDER_ID VARCHAR(50),
 ORDER_DATE DATE,
 SHIP_DATE DATE,
 SHIP_MODE STRING,
 CUSTOMER_NAME STRING,
 SEGMENT STRING,
 STATE STRING,
 COUNTRY STRING,
 MARKET STRING,
 REGION STRING,
 PRODUCT_ID VARCHAR(500) NOT NULL PRIMARY KEY,
 CATEGORY STRING,
 SUB_CATEGORY STRING,
 PRODUCT_NAME STRING,
 SALES NUMBER,
 QUANTITY NUMBER,
 DISCOUNT FLOAT,
 PROFIT FLOAT,
 SHIPPING_COST FLOAT,
 ORDER_PRIORITY STRING,
 YEAR INT);
 select * from SALES;
 describe table rk_sales;
 
 
 
 
 create or replace table rk_sales
 as select * from SALES;
 
 -- SET A PRIMARY KEY--
 
 ALTER TABLE rk_sales
add primary key(ORDER_ID); 

SELECT * FROM rk_sales;

---how much days taken---
alter table rk_sales
add column days_taken integer;

update rk_sales
set days_taken=datediff('day',order_date,ship_date);

--DISCOUNT--- 
SELECT *,
       CASE WHEN DISCOUNT > '0'  THEN 'YES'
       ELSE 'FALSE'
       END AS IF_DISCOUNTED
       FROM rk_sales;
       
 ----PROCESS DAYS--
 
 ALTER TABLE rk_sales
 add column flag_process_days integer;
 
 update  rk_sales
 set flag_process_days = (
                               case
                                     when days_taken <= '3' then'5'
                                     when days_taken <= '6' and days_taken > '3' then '4'
                                     when days_taken<='10'  and days_taken > '6'  then '3'
                                      ELSE '2'
                                 END);
                                 
----ORDER EXTRACT----

ALTER TABLE rk_sales
add column order_extract integer;

update rk_sales
set order_extract=  (SUBSTR(ORDER_ID,9));
---RIGHT(ORDER_ID,charindex('-',(reverse(ORDER_ID)))-1);--

SELECT * FROM rk_sales;
