--add set echo and spool command here
SET ECHO ON;

SPOOL week11_sql_advanced_output.txt;

/*
Databases Week 11 Tutorial
week11_sql_advanced.sql

student id:  31131867
student name: Angel Das
last modified date: 2-Jun-2020

*/

/* 1. Find the number of scheduled classes assigned to each staff member each year and semester. 
If the number of classes is 2 then this should be labelled as a correct load, 
more than 2 as an overload and less than 2 as an underload. 
Order the list by decreasing order of scheduled class number. */

SELECT
    *
FROM
    uni.schedclass;

SELECT
    sch.yr AS year,
    sch.semester,
    sch.staffid,
    staff.stafffname,
    staff.stafflname,
    sch.numberclasses,
    CASE
        WHEN sch.numberclasses = 2   THEN
            'Correct Load'
        WHEN sch.numberclasses > 2   THEN
            'Overload'
        ELSE
            'Underload'
    END AS load
FROM
    (
        SELECT
            yr,
            semester,
            staffid,
            COUNT(classno) AS numberclasses
        FROM
            (
                SELECT
                    cl.*,
                    to_char(cl.ofyear, 'YYYY') AS yr
                FROM
                    uni.schedclass cl
            )
        GROUP BY
            yr,
            semester,
            staffid
    ) sch
    JOIN uni.staff staff ON sch.staffid = staff.staffid
ORDER BY
    numberclasses DESC;

/* 2. Display unit code and unitname for units that do not have a prerequisite. 
Order the list in increasing order of unit code.

There are many approaches that you can take in writing an SQL statement to answer this query. 
You can use the SET OPERATORS, OUTER JOIN and a SUBQUERY. 
Write SQL statements based on all of these approaches.*/

SELECT
    *
FROM
    uni.unit;

SELECT
    *
FROM
    uni.prereq;

SELECT
    inr.unitcode,
    inr.unitname
FROM
    (
        SELECT
            un.unitcode,
            un.unitname,
            prereq.has_prereq_of
        FROM
            uni.unit     un
            LEFT OUTER JOIN uni.prereq   prereq ON un.unitcode = prereq.unitcode
    ) inr
WHERE
    inr.has_prereq_of IS NULL;

SELECT
    un.unitcode,
    un.unitname
FROM
    uni.unit un
WHERE
    un.unitcode NOT IN (
        SELECT
            unitcode
        FROM
            uni.prereq
        WHERE
            has_prereq_of IS NOT NULL
    );

SELECT
    un.unitcode,
    un.unitname
FROM
    uni.unit un
WHERE
    un.unitcode IN (
        SELECT DISTINCT
            unitcode
        FROM
            uni.unit
        INTERSECT
        ( SELECT DISTINCT
            unitcode
        FROM
            uni.prereq
        WHERE
            has_prereq_of IS NOT NULL
        )
    );

/* 3. List all units offered in 2013 semester 2 which do not have any scheduled class. 
Include unit code, unit name, and chief examiner name in the list. 
Order the list based on the unit code. */

SELECT
    unitcode,
    unitname,
    staff_name AS ce_name
FROM
    (
        SELECT
            ofr.unitcode,
            un.unitname,
            st.stafffname
            || ' '
            || st.stafflname AS staff_name,
            CASE
                WHEN sch.unitcode IS NULL THEN
                    'Y'
                ELSE
                    'N'
            END AS flag
        FROM
            uni.offering                                                 ofr
            LEFT JOIN (
                SELECT DISTINCT
                    unitcode,
                    semester,
                    ofyear
                FROM
                    uni.schedclass
            ) sch ON ofr.unitcode = sch.unitcode
                     AND ofr.semester = sch.semester
                     AND ofr.ofyear = sch.ofyear
            LEFT JOIN uni.staff                                                    st ON ofr.chiefexam = st.staffid
            LEFT JOIN uni.unit                                                     un ON ofr.unitcode = un.unitcode
        WHERE
            ofr.semester = 2
            AND to_char(ofr.ofyear, 'YYYY') = '2013'
    )
WHERE
    flag = 'Y'
ORDER BY
    unitcode;

 
/* 4. List full names of students who are enrolled in both Introduction to Databases and Programming Foundations 
(note: unit names are unique). Order the list by student full name.*/

SELECT
    student_full_name
FROM
    (
        SELECT
            s.studfname
            || ' '
            || s.studlname AS student_full_name,
            COUNT(s.studid) AS r
        FROM
            uni.student     s
            JOIN uni.enrolment   e ON s.studid = e.studid
            JOIN uni.unit        u ON e.unitcode = u.unitcode
        WHERE
            u.unitname IN (
                'Introduction to Databases',
                'Programming Foundations'
            )
        GROUP BY
            s.studfname
            || ' '
            || s.studlname
    )
WHERE
    r = 2
ORDER BY
    student_full_name;

/* 5. Given that payment rate for tutorial is $42.85 per hour and  payemnt rate for lecture is $75.60 per hour, 
calculate weekly payment per type of class for each staff. 
In the display, include staff name, type of class (lecture or tutorial), 
number of classes, number of hours (total duration), and weekly payment (number of hours * payment rate). 
Order the list by increasing order of staff name*/
SELECT
    staffname,
    CASE
        WHEN cltype = 'L' THEN
            'Lecture'
        ELSE
            'Tutorial'
    END AS type,
    number_of_classes AS no_of_classes,
    total_hours,
    CASE
        WHEN cltype = 'L' THEN
            to_char(round(75.60 * total_hours, 2), '$9990.99')
        ELSE
            to_char(round(42.85 * total_hours, 2), '$9990.99')
    END AS weekly_payment
FROM
    (
        SELECT
            s.stafffname
            || ' '
            || s.stafflname AS staffname,
            otr.*
        FROM
            uni.staff s
            JOIN (
                SELECT
                    sch.staffid,
                    sch.cltype,
                    COUNT(sch.classno) AS number_of_classes,
                    SUM(sch.clduration) AS total_hours
                FROM
                    uni.schedclass sch
                GROUP BY
                    sch.staffid,
                    sch.cltype
            ) otr ON s.staffid = otr.staffid
    )
ORDER BY
    staffname;

/* 6. Assume that all units worth 6 credit points each, calculate each student’s Weighted Average Mark (WAM) and GPA. 
Please refer to these Monash websites: https://www.monash.edu/exams/results/wam and https://www.monash.edu/exams/results/gpa 
for more information about WAM and GPA respectively. 


Calculation example for student 111111111:
WAM = (65x3 + 45x3 + 74x3 +74*6)/(3+3+3+6) = 66.4
GPA = (2x6 + 0.3x6 + 3x6 + 3x6)/(6+6+6+6) = 2.08

Include student id, student full name (in a 40 character wide column headed “Student Full Name�?), WAM and GPA in the display. 
Order the list by descending order of WAM then descending order of GPA.
*/
SELECT
    enrl.studid,
    (stu.studfname
    || ' '
    || stu.studlname) as "Student Full Name",
    to_char((SUM(
        CASE
            WHEN substr(enrl.unitcode, 4, 1) = 1 THEN
                nvl(enrl.mark, 0) * 0.5 * 6
            ELSE
                nvl(enrl.mark, 0) * 6
        END
    )) /(SUM(
        CASE
            WHEN substr(enrl.unitcode, 4, 1) = 1 THEN
                6 * 0.5
            ELSE
                6
        END
    )), '990.99') as wam,
    to_char((SUM(
        CASE enrl.grade
    WHEN 'HD' THEN
        4 * 6
    WHEN 'D' THEN
        3 * 6
    WHEN 'C' THEN
        2 * 6
    WHEN 'P' THEN
        1 * 6
    WHEN 'N' THEN
        0.3 * 6
END
    ) ) / ( sum(6) ),
'90.99' ) as gpa
FROM
    uni.enrolment   enrl
    JOIN uni.student     stu ON enrl.studid = stu.studid
GROUP BY
    enrl.studid,
    ( stu.studfname
      || ' '
         || stu.studlname )
ORDER by wam desc,
    gpa desc;
    
spool off;
set echo off;

