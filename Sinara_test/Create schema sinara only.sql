-- creating a schema SINARA

drop schema if exists sinara cascade;
create schema SINARA;

-- creating a table CONTACT

drop table if exists SINARA.CONTACT;
CREATE TABLE SINARA.CONTACT
(
 CONTACT_ID       SERIAL NOT NULL,
 ROW_ID       VARCHAR(15) NOT NULL,
 FST_NAME       VARCHAR(15) NOT NULL,
 MID_NAME       VARCHAR(15) NOT NULL,
 LAST_NAME       VARCHAR(15) NOT NULL,
 X_GB_STATUS       VARCHAR(15) NOT NULL,
 X_PROMO_DATE       DATE
);

-- creating a table PER_ADDR

drop table if exists SINARA.PER_ADDR;
CREATE TABLE SINARA.PER_ADDR
(
 PER_ADDR_ID       SERIAL NOT NULL,
 ROW_ID       VARCHAR(15) NOT NULL,
 PER_ID       VARCHAR(15) NOT NULL,
 CREATED       TIMESTAMP NOT NULL,
 ADDR       VARCHAR(30) NOT NULL,
 COMM_MEDIUM_CD       VARCHAR(15) NOT NULL,
 NAME       VARCHAR(30) NOT NULL,
 X_PROMO_DATE       DATE
);
set datestyle to 'ISO, DMY';


-- creating a table ACTIVITY

drop table if exists SINARA.ACTIVITY;
CREATE TABLE SINARA.ACTIVITY
(
 ACTIVITY_ID       SERIAL NOT NULL,
 CREATED       TIMESTAMP NOT NULL,
 CON_ID       VARCHAR(15) NOT NULL,
 TODO_CD       VARCHAR(30) NOT NULL,
 STAT       VARCHAR(30),
 COMMENTS_LONG       TEXT
);
set datestyle to 'ISO, DMY';

-- creating a table one

drop table if exists sinara.one_two;
CREATE TABLE sinara.one_two
(
 ones       VARCHAR(15) NOT NULL
);