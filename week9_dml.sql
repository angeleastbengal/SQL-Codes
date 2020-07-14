#-------------------------------Name: Angel Das-----------------------------------------
 #-------------------------------Student ID: 31131867------------------------------------
 #-------------------------------Tutorial: Week 9----------------------------------------
 #-------------------------------Create Date: 19-05-2020---------------------------------
 #-------------------------------Last Modified: 19-05-2020--------------------------------------------
 #-------------------------------Description: Update and Delete-------
 
 set echo on;
spool week9_dml_output.txt;
 
-- 1. Update the unit name of FIT9999 from 'FIT Last Unit' to 'place holder unit'.
SELECT
    *
FROM
    unit;

UPDATE unit
SET
    unit_name = 'place holder unit'
WHERE
    unit_code = 'FIT9999';

SELECT
    *
FROM
    unit;

--2. Enter the mark and grade for the student with the student number of 11111113 for the unit
--code FIT5132 that the student enrolled in semester 2 of 2014. The mark is 75 and the grade
--is D.

SELECT
    *
FROM
    enrollment;

UPDATE enrollment
SET
    enrol_mark = 75,
    enrol_grade = 'D'
WHERE
    stu_nbr = 11111113
    AND unit_code = 'FIT5132'
        AND enrol_year = '2014'
            AND enrol_semester = 2;

SELECT
    *
FROM
    enrollment;

--3. The university introduced a new grade classification. The new classification are:
--1. 45 - 54 is P1.
--2. 55 - 64 is P2.
--3. 65 - 74 is C.
--4. 75 - 84 is D.
--5. 85 - 100 is HD.
--Change the database to reflect the new grade classification

SELECT
    *
FROM
    enrollment;

UPDATE enrollment
SET
    enrol_grade =
        CASE
            WHEN enrol_mark BETWEEN 45 AND 54 THEN
                'P1'
            WHEN enrol_mark BETWEEN 55 AND 64 THEN
                'P2'
            WHEN enrol_mark BETWEEN 65 AND 74 THEN
                'C'
            WHEN enrol_mark BETWEEN 75 AND 64 THEN
                'D'
            WHEN enrol_mark BETWEEN 85 AND 100 THEN
                'HD'
            ELSE
                enrol_grade
        END;

SELECT
    *
FROM
    enrollment;

COMMIT;

--A student with student number 11111114 has taken intermission in semester 2 2014, hence
--all the enrolment of this student for semester 2 2014 should be removed. Change the
--database to reflect this situation.

ALTER TABLE enrollment DROP CONSTRAINT enrol_sfk;

ALTER TABLE enrollment
    ADD CONSTRAINT enrol_sfk FOREIGN KEY ( stu_nbr )
        REFERENCES student
            ON DELETE CASCADE;

DELETE FROM enrollment
WHERE
    stu_nbr = 11111114
    AND enrol_semester = 2
        AND enrol_year = 2014;

SELECT
    *
FROM
    enrollment;

SELECT
    *
FROM
    student;

COMMIT;

--2. Assume that Wendy Wheat (student number 11111113) has withdrawn from the university.
--Remove her details from the database.

DELETE FROM student
WHERE
    stu_nbr = 11111113;

SELECT
    *
FROM
    student;

SELECT
    *
FROM
    enrollment;

--All records in enrollment pertaining to student 11111113 is removed because of cascade constraint.

--3. Add Wendy Wheat back to the database (use the INSERT statements you have created
--when completing module Tutorial 7 SQL Data Definition Language DDL).

INSERT INTO student VALUES (
    11111113,
    'Wheat',
    'Wendy',
    '05-May-90'
);

INSERT INTO enrollment VALUES (
    11111113,
    'FIT5132',
    2014,
    '2',
    NULL,
    NULL
);

INSERT INTO enrollment VALUES (
    11111113,
    'FIT5111',
    2014,
    '2',
    NULL,
    NULL
);

SELECT
    *
FROM
    student;

SELECT
    *
FROM
    enrollment;

COMMIT;

spool off;
set echo off;
