--add set echo and spool command here
SET ECHO ON;

SPOOL week10_sql_intermediate_output.txt;

/*
Databases Week 10 Tutorial
week10_sql_intermediate.sql

student id: 31131867
student name: Angel Das
last modified date: May 26, 2020

*/

/* 1. Find the average mark of FIT1040 in semester 2, 2013. */

SELECT
    round(AVG(mark), 2) AS avg_mark
FROM
    uni.enrolment
WHERE
    unitcode = 'FIT1040'
    AND to_char(ofyear, 'YYYY') = '2013'
    AND semester = 2;




/* 2. List the average mark for each offering of FIT1040. 
In the listing, you need to include the year and semester number. 
Sort the result according to the year..*/

SELECT DISTINCT
    ofyear
FROM
    uni.enrolment
WHERE
    unitcode = 'FIT1040';

SELECT
    to_char(ofyear, 'YYYY') AS year,
    semester,
    round(AVG(mark), 2) AS avg_mark
FROM
    uni.enrolment
WHERE
    unitcode = 'FIT1040'
GROUP BY
    to_char(ofyear, 'YYYY'),
    semester
ORDER BY
    to_char(ofyear, 'YYYY'),
    semester;


/* 3. Find the number of students enrolled in the unit FIT1040 in the year 2013, under the following conditions:
      a. Repeat students are counted each time
      b. Repeat students are only counted once
*/

SELECT
    studid
FROM
    uni.enrolment
WHERE
    unitcode = 'FIT1040'
    AND to_char(ofyear, 'YYYY') = '2013';

SELECT
    COUNT(studid) AS repeat_stu,
    COUNT(DISTINCT studid) AS stu_cnt
FROM
    uni.enrolment
WHERE
    unitcode = 'FIT1040'
    AND to_char(ofyear, 'YYYY') = '2013';


/* 4. Find the total number of prerequisite units for FIT2077. */

SELECT
    COUNT(DISTINCT has_prereq_of) AS cnt_pre_req
FROM
    uni.prereq
WHERE
    unitcode = 'FIT2077';
  
/* 5. Find the total number of prerequisite units for each unit. 
In the list, include the unitcode for which the count is applicable.*/

SELECT
    unitcode,
    COUNT(DISTINCT has_prereq_of) AS cnt_pre_req
FROM
    uni.prereq
GROUP BY
    unitcode
ORDER BY
    unitcode;


/* 6. For each prerequisite unit, calculate how many times it has been used as prerequisite. 
Include the name of the prerequisite unit in the listing .*/

--CREATE TABLE PREREQ AS SELECT * FROM UNI.PREREQ ORDER BY HAS_PREREQ_OF DESC;
--
--SELECT * FROM PREREQ;

SELECT
    has_prereq_of,
    COUNT(has_prereq_of) AS cnt_pre_req
FROM
    uni.prereq
GROUP BY
    has_prereq_of;

--ORDER BY HAS_PREREQ_OF;


/* 7. Find the unit with the highest number of enrolments in a given offering in the year 2013. */

SELECT
    *
FROM
    (
        SELECT
            unitcode,
            to_char(ofyear, 'YYYY') AS year,
            semester,
            COUNT(studid) AS enrolment_cnt
        FROM
            uni.enrolment
        WHERE
            to_char(ofyear, 'YYYY') = '2013'
        GROUP BY
            unitcode,
            to_char(ofyear, 'YYYY'),
            semester
        ORDER BY
            enrolment_cnt DESC
    )
WHERE
    enrolment_cnt IN (
        SELECT
            MAX(COUNT(studid)) AS enr
        FROM
            uni.enrolment
        WHERE
            to_char(ofyear, 'YYYY') = '2013'
        GROUP BY
            unitcode,
            to_char(ofyear, 'YYYY'),
            semester
    );



/* 8. Find all students enrolled in FIT1004 in semester 1, 2013 
who have scored more than the average mark of FIT1004 in the same offering? 
Display the students' name and the mark. 
Sort the list in the order of the mark from the highest to the lowest.*/

SELECT
    ( stu.studfname
      || ' '
         || stu.studlname ) AS stu_name,
    enrol.mark
FROM
    (
        SELECT
            studid,
            mark
        FROM
            uni.enrolment
        WHERE
            semester = 1
            AND to_char(ofyear, 'YYYY') = '2013'
                AND unitcode = 'FIT1004'
                    AND mark > (
                SELECT
                    AVG(mark) AS mark
                FROM
                    uni.enrolment
                WHERE
                    semester = 1
                    AND to_char(ofyear, 'YYYY') = '2013'
                        AND unitcode = 'FIT1004'
            )
    ) enrol
    JOIN uni.student stu ON enrol.studid = stu.studid
ORDER BY
        enrol.mark
    DESC;
    
    
SPOOL OFF;

SET ECHO OFF;