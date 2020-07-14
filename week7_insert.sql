#-------------------------------Name: Angel Das-----------------------------------------
#-------------------------------Student ID: 31131867------------------------------------
#-------------------------------Tutorial: Week 7----------------------------------------
#-------------------------------Create Date: 05-05-2020---------------------------------
#-------------------------------Last Modified: 11-05-2020--------------------------------------------
#-------------------------------Description: Insert data into Unit, Student & Enrollment Table-------

/*
TASKS
1. Write SQL INSERT statements within the file to add the following data into the specified tables
2. A file is available on Moodle (studentdata.txt) which has this data as a starting point to build
the required insert statements. Download the file from Moodle and open studentdata.txt in SQL
Developer, then copy and paste the contents to build your insert statements.
3. Ensure you make use of COMMIT to make your changes permanent.
4. Check that your data has inserted correctly by using the SQL command SELECT * FROM
tablename and by using the SQL GUI (select the table in the right-hand list and then select the
Data tab).
*/

set echo on;
spool week7_insert_output.txt;

------------------------------Inserting Data in Student File---------------------------------

INSERT INTO student VALUES (11111111, 'Bloggs','Fred','01-Jan-90');
INSERT INTO student VALUES (11111112, 'Nice','Nick','10-Oct-94');
INSERT INTO student VALUES (11111113, 'Wheat','Wendy','05-May-90');
INSERT INTO student VALUES (11111114, 'Sheen','Cindy','25-Dec-96');

COMMIT WORK;

------------------------------Checking if Student details are inserted correctly---------------------------------

SELECT STUDENT_INFO.*
    FROM student STUDENT_INFO;
    
------------------------------Inserting Data in Unit File---------------------------------

INSERT INTO unit VALUES ('FIT9999','FIT Last Unit');
INSERT INTO unit VALUES ('FIT5132','Introduction to Databases');
INSERT INTO unit VALUES ('FIT5016','Project');
INSERT INTO unit VALUES ('FIT5111','Student''s Life');

COMMIT WORK;

------------------------------Checking if Unit details are inserted correctly---------------------------------

SELECT UNIT_INFO.*
    FROM unit UNIT_INFO; ----ALIAS
    
------------------------------Inserting data into enrollment file---------------------------------------------

INSERT INTO enrollment VALUES (11111111,'FIT5132',2013,'1',35,'N');
INSERT INTO enrollment VALUES (11111111,'FIT5016',2013,'1',61,'C');
INSERT INTO enrollment VALUES (11111111,'FIT5132',2013,'2',42,'N');
INSERT INTO enrollment VALUES (11111111,'FIT5111',2013,'2',76,'D');
INSERT INTO enrollment VALUES (11111111,'FIT5132',2014,'2',NULL,NULL);
INSERT INTO enrollment VALUES (11111112,'FIT5132',2013,'2',83,'HD');
INSERT INTO enrollment VALUES (11111112,'FIT5111',2013,'2',79,'D');
INSERT INTO enrollment VALUES (11111113,'FIT5132',2014,'2',NULL,NULL);
INSERT INTO enrollment VALUES (11111113,'FIT5111',2014,'2',NULL,NULL);
INSERT INTO enrollment VALUES (11111114,'FIT5111',2014,'2',NULL,NULL);

------------------------------Checking if Enrollment details are inserted correctly---------------------------------

SELECT ENROLLMENT_INFO.*
    FROM enrollment ENROLLMENT_INFO; ----ALIAS

COMMIT WORK;

/*
7.3.2 Using SEQUENCEs in an INSERT statement
In the previous exercises, you have entered the primary key value manually in the INSERT
statements. In the situation where a SEQUENCE is available, you should use the sequence
mechanism to generate the value of the primary key.
TASKS
1. Create a sequence for the STUDENT table called STUDENT_SEQ
- Create a sequence for the STUDENT table called STUDENT_SEQ that starts at 11111115
and increases by 1.
-  Check that the sequence exists in two ways (using SQL and browsing your SQL Developer
connection objects).

2. Add a new student (MICKEY MOUSE)
- Use the student sequence - pick any STU_DOB you wish.
- Check that your insert worked.
-  Add an enrollment for this student to the unit FIT5132 in semester 2 2016.
*/

------------------------------------Create a sequence for the STUDENT table called STUDENT_SEQ---------------------
DROP SEQUENCE STUDENT_SEQ;

CREATE SEQUENCE STUDENT_SEQ START WITH 11111115 INCREMENT BY 1;

------------------------------------Checking if Sequence was created successfully----------------------------------
SELECT *
    FROM user_sequences;
    

---------------------------------Inserting Data in STUDENT table using sequence-----------------------------------

INSERT INTO student VALUES (STUDENT_SEQ.NEXTVAL, 'Mouse','Mickey','01-Aug-92');

COMMIT WORK;

SELECT * FROM student;


/*
STUDENT_SEQ.CURRVAL returns the latest value that was obtained from sequence STUDENT_SEQ in our session, 
and hence isn't defined until we have obtained a value using STUDENT_SEQ.NEXTVAL at least once in the session. 
The purpose of CURRVAL is to let us use the sequence value more than once in our code.
*/



/*
TASKS
1. A new student has started a course and needs to enrol into "Introduction to databases". Enter
the new student's details and his/her enrolment to the database using the nextval in
combination with a SELECT statement. You can make up details of the new student and when
they will attempt "Introduction to databases".
- You must not do a manual lookup to find the unit code of the "Introduction to databases".
*/

--Step1: Inserting the new student record in student table using .nextval then using the same sequence number to
--update the enrollment table
INSERT INTO student VALUES (STUDENT_SEQ.NEXTVAL, 'Das','Andy','29-Aug-92');


SELECT * FROM student;

INSERT INTO enrollment values (STUDENT_SEQ.CURRVAL,
    (SELECT UNIT_CODE from unit WHERE UNIT_NAME = 'Introduction to Databases'),2013,'1',56,'P');

SELECT ENROLLMENT_INFO.*
    FROM enrollment ENROLLMENT_INFO; ----ALIAS
    
COMMIT WORK;


--(SELECT UNIT_CODE from unit WHERE UNIT_NAME = 'Introduction to Databases')



/*
7.3.4 Creating a table and inserting data as a single SQL statement.
A table can also be created based on an existing table, and immediately populated with contents
by using a SELECT statement within the CREATE TABLE statement.
For example, to create a table called FIT5132_STUDENT which contains the enrolment details of
all students who have been or are currently enrolled in FIT5132, we would use:
create table FIT5132_STUDENT
as select *
from enrolment
where unit_code = 'FIT5132';
Here, we use the SELECT statement to retrieve all columns (the wildcard "*" represents all
columns) from the table enrolment, but only those rows with a value of the unit_code equal to
FIT5132.
*/

--DROPPING PRE-EXISTING TABLE IF ANY

DROP TABLE FIT5111_STUDENT PURGE;

CREATE TABLE FIT5111_STUDENT AS
    SELECT ENROLL_INFO.*
    FROM enrollment ENROLL_INFO
    WHERE unit_code = 'FIT5111';

SELECT * FROM FIT5111_STUDENT;

spool off;
set echo off;