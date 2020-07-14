set echo on;
spool Week8_SQLBasic_PartB_output.txt;


/*
Databases Week 8 Tutorial Sample Solution
week8_SQLBasic_PartB.sql

student id: 31131867
student name: Angel Das
last modified date: 17-05-2020
*/

/* B1. List all the unit codes, semester and name of the chief examiner for all 
      the units that are offered in 2014.*/

--SELECT 
--    UNITCODE ,
--    UNITNAME ,
--    UNITDESC  
--    FROM UNI.UNIT;

SELECT 
    OFFR.UNITCODE ,
    OFFR.SEMESTER ,
--    OFYEAR ,
    (STF.STAFFFNAME||' '||STF.STAFFLNAME) AS CHIEF_EXAMINER_NAME
FROM UNI.OFFERING OFFR
JOIN UNI.STAFF STF
    ON OFFR.CHIEFEXAM=STF.STAFFID

    WHERE TO_CHAR(OFFR.OFYEAR,'YYYY')=2014;



/* B2. List all the unit codes and the unit names and their year and semester 
      offerings. To display the date correctly in Oracle, you need to use to_char function. 
      For example, to_char(ofyear,'YYYY'). */

SELECT 
    UNIT.UNITCODE ,
    UNIT.UNITNAME,
    TO_CHAR(OFFR.OFYEAR,'YYYY') AS YEAR,
    OFFR.SEMESTER
    
FROM UNI.UNIT UNIT
JOIN UNI.OFFERING OFFR
    ON UNIT.UNITCODE=OFFR.UNITCODE;

/* B3. List the unit code, semester, class type (lecture or tutorial), 
      day and time for all units taught by Albus Dumbledore in 2013. 
      Sort the list according to the unit code.*/

 SELECT 
    OFFR.UNITCODE ,
    OFFR.SEMESTER ,
    SCH.CLTYPE,
    SCH.CLDAY,
    TO_CHAR(SCH.CLTIME,'HH:MM:SS') AS TIME_INFO
    
FROM UNI.OFFERING OFFR
JOIN UNI.SCHEDCLASS SCH
    ON OFFR.UNITCODE=SCH.UNITCODE
JOIN UNI.STAFF STF
    ON SCH.STAFFID=STF.STAFFID
    WHERE (STF.STAFFFNAME||' '||STF.STAFFLNAME)='Albus Dumbledore' AND TO_CHAR(OFFR.OFYEAR,'YYYY')=2013
    ORDER BY OFFR.SEMESTER, SCH.CLDAY, TIME_INFO;

/* B4. Create a study statement for Mary Smith. A study statement contains 
      unit code, unit name, semester and year study was attempted, the mark 
      and grade. */

SELECT 
--    (STU.STUDFNAME||' '||STU.STUDLNAME) AS STUDENT_NAME,
    ENROL.UNITCODE,
    UNT.UNITNAME,
    ENROL.SEMESTER,
    TO_CHAR(ENROL.OFYEAR,'YYYY') AS YEAR_OF_STUDY,
--    ENROL.STUDID,
    ENROL.MARK,
    ENROL.GRADE
    
FROM UNI.STUDENT STU
JOIN UNI.ENROLMENT ENROL
        ON STU.STUDID=ENROL.STUDID
JOIN UNI.UNIT UNT
        ON ENROL.UNITCODE=UNT.UNITCODE
        
WHERE (STU.STUDFNAME||' '||STU.STUDLNAME)='Mary Smith'
ORDER BY ENROL.UNITCODE, ENROL.OFYEAR, ENROL.SEMESTER;
    


/* B5. List the unit code and unit name of the pre-requisite units of 
      'Advanced Data Management' unit */

SELECT 
    UNIT2.UNITCODE,
    UNIT2.UNITNAME
    FROM UNI.PREREQ PR
    JOIN UNI.UNIT UNIT1
        ON PR.UNITCODE=UNIT1.UNITCODE
    JOIN UNI.UNIT UNIT2
        ON PR.HAS_PREREQ_OF=UNIT2.UNITCODE
    WHERE UNIT1.UNITNAME='Advanced Data Management';

/* B6. Find all students (list their id, firstname and surname) who 
       have a failed unit in the year 2013 */

SELECT
    STU.STUDID,
    STU.STUDFNAME,
    STU.STUDLNAME
    
    FROM UNI.STUDENT STU
    JOIN UNI.ENROLMENT ENR
    ON STU.STUDID=ENR.STUDID
    WHERE ENR.GRADE='N' AND TO_CHAR(ENR.OFYEAR,'YYYY')=2013;
    


/* B7.	List the student name, unit code, semester and year for those 
        students who do not have marks recorded */

SELECT
--    STU.STUDID,
    (STU.STUDFNAME||' '||STU.STUDLNAME) AS STU_NAME,
    ENR.UNITCODE,
    ENR.SEMESTER,
    TO_CHAR(ENR.OFYEAR,'YYYY') AS YEAR_INFO
    
    FROM UNI.STUDENT STU
    JOIN UNI.ENROLMENT ENR
    ON STU.STUDID=ENR.STUDID
    WHERE ENR.MARK IS NULL;

spool off;
set echo off;