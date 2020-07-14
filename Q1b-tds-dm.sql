--****PLEASE ENTER YOUR DETAILS BELOW****
--Q1b-tds-dm.sql
--Student ID: 31131867
--Student Name: Angel Das
--Tutorial No: 1 (Tue 12-2 pm)
--Last Modified: 12-Jun-2020

SET SERVEROUTPUT ON;


/* Comments for your marker:
1. New offence inserted using the queries below are considered as one transaction, hence commit is used after insert
*/


/*
1b(i) Create a sequence 
*/
--PLEASE PLACE REQUIRED SQL STATEMENT(S) FOR THIS PART HERE

DROP SEQUENCE OFFENCE_SEQ;

CREATE SEQUENCE OFFENCE_SEQ START WITH 100 INCREMENT BY 1;

/*
1b(ii) Take the necessary steps in the database to record data.
*/
--PLEASE PLACE REQUIRED SQL STATEMENT(S) FOR THIS PART HERE
--
INSERT INTO offence VALUES (OFFENCE_SEQ.NEXTVAL,TO_DATE('10-Aug-2019 08:14 AM','DD-MON-YYYY HH12:MI AM'),
        '3131 Ridgeway Court Richmond 3121',(select dem_code from demerit where dem_description='Blood alcohol charge'),
        10000011,'100389','JYA3HHE05RA070562');
COMMIT;

INSERT INTO offence VALUES (OFFENCE_SEQ.NEXTVAL,TO_DATE('16-Oct-2019 09:00 PM','DD-MON-YYYY HH12:MI PM'),
        '9 Anniversary Place Richmond 3121',(select dem_code from demerit where dem_description='Level crossing offence'),
        10000015,'100389','JYA3HHE05RA070562');
COMMIT;

INSERT INTO offence VALUES (OFFENCE_SEQ.NEXTVAL,TO_DATE('7-Jan-2020 07:07 AM','DD-MON-YYYY HH12:MI AM'),
        '3131 Ridgeway Court Richmond 3121',(select dem_code from demerit where dem_description='Exceeding the speed limit by 25 km/h or more'),
         10000015,'100389','JYA3HHE05RA070562');

INSERT INTO suspension VALUES ('100389',TO_DATE('7-Jan-2020','DD-MON-YYYY'),
                    TO_DATE(add_months(TO_DATE('7-Jan-2020','DD-MON-YYYY'), 6), 'DD-MON-YYYY'));
        
COMMIT;
/*
1b(iii) Take the necessary steps in the database to record changes. 
*/
--PLEASE PLACE REQUIRED SQL STATEMENT(S) FOR THIS PART HERE

UPDATE offence
SET
    dem_code = (
        SELECT
            dem_code
        FROM
            demerit
        WHERE
            dem_description = 'Exceeding the speed limit by 10 km/h or more but less than 25 km/h'
    )
WHERE
    lic_no IN ('100389')
    AND dem_code IN (
        SELECT
            dem_code
        FROM
            demerit
        WHERE
            dem_description = 'Exceeding the speed limit by 25 km/h or more'
    );

--------------------------------------------Removing the suspension for License No 100389 as offence has been  updated and
--------------------------------------------Total offence points now drops to 11------------------------------------------
DELETE FROM suspension WHERE lic_no='100389';
COMMIT;
