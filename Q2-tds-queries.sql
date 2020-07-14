--****PLEASE ENTER YOUR DETAILS BELOW****
--Q2-tds-queries.sql
--Student ID: 31131867
--Student Name: Angel Das
--Tutorial No: 1 (Tue 12-2 pm)
--Last Modified: 12-Jun-2020

/* Comments for your marker:
No Comments
*/


/*
2(i) Query 1
*/
--PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE

SELECT
    dem_points        AS "Demerit Points",
    dem_description   AS "Demerit Description"
FROM
    demerit
WHERE
    dem_description LIKE '%heavy%'
    OR dem_description LIKE '%Heavy%'
    OR dem_description LIKE 'Exceed%'
    
ORDER BY dem_points, dem_description;

/*
2(ii) Query 2
*/
--PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE

--select distinct veh_modname from vehicle where veh_modname like '%Rover%' order by veh_modname;
--select * from vehicle;

SELECT
    veh_maincolor   AS "Main Colour",
    veh_vin         AS "VIN",
    to_char(veh_yrmanuf, 'YYYY') AS "Year Manufactured"
FROM
    vehicle
WHERE
    veh_modname IN (
        'Range Rover',
        'Range Rover Sport'
    )
    AND to_char(veh_yrmanuf, 'YYYY') IN (
        '2012',
        '2013',
        '2014'
    )
ORDER BY
    "Year Manufactured" DESC,
    veh_maincolor ASC;

/*
2(iii) Query 3
*/
--PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
SELECT
    drv.lic_no         AS "Licence No.",
    ( drv.lic_fname
      || ' '
      || drv.lic_lname ) AS "Driver Fullname",
    to_char(drv.lic_dob,'DD-MON-YYYY')        AS "DOB",
    ( drv.lic_street
      || ' '
      || drv.lic_town
      || ' '
      || drv.lic_postcode ) AS "Driver Address",
    spns.sus_date      AS "Suspended On",
    spns.sus_enddate   AS "Suspended Till"
FROM
    driver       drv
    JOIN suspension   spns ON drv.lic_no = spns.lic_no
                            AND months_between(to_date(sysdate, 'DD-Mon-YYYY'), spns.sus_date) <= 30
ORDER BY
    drv.lic_no ASC,
    spns.sus_date DESC;


/*
2(iv) Query 4
*/
--PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
SELECT
    dem.dem_code          AS "Demerit Code",
    dem.dem_description   AS "Demerit Description",
    COUNT(ofn.off_no) AS "Total Offences (All Months)",
    COUNT(
        CASE
            WHEN to_char(ofn.off_datetime, 'Mon') = 'Jan' THEN
                off_no
        END
    ) AS "Jan",
    COUNT(
        CASE
            WHEN to_char(ofn.off_datetime, 'Mon') = 'Feb' THEN
                off_no
        END
    ) AS "Feb",
    COUNT(
        CASE
            WHEN to_char(ofn.off_datetime, 'Mon') = 'Mar' THEN
                off_no
        END
    ) AS "Mar",
    COUNT(
        CASE
            WHEN to_char(ofn.off_datetime, 'Mon') = 'Apr' THEN
                off_no
        END
    ) AS "Apr",
    COUNT(
        CASE
            WHEN to_char(ofn.off_datetime, 'Mon') = 'May' THEN
                off_no
        END
    ) AS "May",
    COUNT(
        CASE
            WHEN to_char(ofn.off_datetime, 'Mon') = 'Jun' THEN
                off_no
        END
    ) AS "Jun",
    COUNT(
        CASE
            WHEN to_char(ofn.off_datetime, 'Mon') = 'Jul' THEN
                off_no
        END
    ) AS "Jul",
    COUNT(
        CASE
            WHEN to_char(ofn.off_datetime, 'Mon') = 'Aug' THEN
                off_no
        END
    ) AS "Aug",
    COUNT(
        CASE
            WHEN to_char(ofn.off_datetime, 'Mon') = 'Sep' THEN
                off_no
        END
    ) AS "Sep",
    COUNT(
        CASE
            WHEN to_char(ofn.off_datetime, 'Mon') = 'Oct' THEN
                off_no
        END
    ) AS "Oct",
    COUNT(
        CASE
            WHEN to_char(ofn.off_datetime, 'Mon') = 'Nov' THEN
                off_no
        END
    ) AS "Nov",
    COUNT(
        CASE
            WHEN to_char(ofn.off_datetime, 'Mon') = 'Dec' THEN
                off_no
        END
    ) AS "Dec"
FROM
    demerit   dem
    LEFT OUTER JOIN offence   ofn ON dem.dem_code = ofn.dem_code
GROUP BY
    dem.dem_code,
    dem.dem_description
ORDER BY
    "Total Offences (All Months)" DESC,
    dem.dem_code ASC;
/*
2(v) Query 5
*/

SELECT
    vf.veh_manufname AS "Manufacturer Name",
    SUM(dm.offence_cnt) AS "Total No. of Offences"
FROM
    vehicle vf
    JOIN (
        SELECT
            ofn.veh_vin,
            SUM(dem.dem_points) AS dem_pnt,
            COUNT(ofn.off_no) AS offence_cnt
        FROM
            offence   ofn
            JOIN demerit   dem ON ofn.dem_code = dem.dem_code
        GROUP BY
            ofn.veh_vin
        HAVING
            SUM(dem.dem_points) >= 2
    ) dm ON vf.veh_vin = dm.veh_vin
HAVING
    SUM(dm.offence_cnt) = (
        SELECT
            MAX(SUM(dm1.offence_cnt)) AS max_val
        FROM
            vehicle vf1
            JOIN (
                SELECT
                    ofn1.veh_vin,
                    SUM(dem1.dem_points) AS dem_pnt,
                    COUNT(ofn1.off_no) AS offence_cnt
                FROM
                    offence   ofn1
                    JOIN demerit   dem1 ON ofn1.dem_code = dem1.dem_code
                GROUP BY
                    ofn1.veh_vin
                HAVING
                    SUM(dem1.dem_points) >= 2
            ) dm1 ON vf1.veh_vin = dm1.veh_vin
        GROUP BY
            vf1.veh_manufname
    )
group BY vf.veh_manufname 
ORDER BY "Total No. of Offences" DESC, "Manufacturer Name";

/*
2(vi) Query 6
*/
--PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE

select 
outr.lic_no as "Licence No.",
(outr.lic_fname || ' ' || outr.lic_lname) as "Driver Name",
ofcr.officer_id as "Officer ID",
(ofcr.officer_fname || ' ' || ofcr.officer_lname) as "Officer Name"

from 
(select drv.lic_no, drv.lic_fname, drv.lic_lname, ofn.officer_id, ofn.dem_code, count(ofn.off_no) as offence_count 
from driver drv
join offence ofn
on drv.lic_no=ofn.lic_no
group by drv.lic_no, drv.lic_fname, drv.lic_lname, ofn.officer_id, ofn.dem_code
having count(ofn.off_no)>1
) outr
join officer ofcr
on outr.officer_id=ofcr.officer_id
where outr.lic_lname=ofcr.officer_lname
order by "Licence No.";


/*
2(vii) Query 7
*/
--PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE


select
otr.dem_code as "Demerit Code",
otr.dem_description as "Demerit Description",
otr.lic_no as "License No.",
otr.name_full as "Driver Fullname",
otr.cnt as "Total Times Booked"

from
(
select 
    dem.dem_code,
    dem.dem_description,
    dvr.lic_no,
    (dvr.lic_fname || ' ' || dvr.lic_lname) as name_full,
    count(ofn.off_no) as cnt
    
    from demerit dem
    join offence ofn
    on dem.dem_code=ofn.dem_code
    join driver dvr
    on ofn.lic_no=dvr.lic_no
    
    group by dem.dem_code, dem.dem_description, dvr.lic_no,(dvr.lic_fname || ' ' || dvr.lic_lname)
    order by dem_code,cnt desc
    ) otr
    
    where (otr.dem_code,otr.cnt) in (
    select ot_query.dem_code, max(ot_query.cnt) as cnt
    from
    (
    select 
    dem.dem_code,
    dem.dem_description,
    dvr.lic_no,
    (dvr.lic_fname || ' ' || dvr.lic_lname) as name_full,
    count(ofn.off_no) as cnt
    
    from demerit dem
    join offence ofn
    on dem.dem_code=ofn.dem_code
    join driver dvr
    on ofn.lic_no=dvr.lic_no
    
    group by dem.dem_code, dem.dem_description, dvr.lic_no,(dvr.lic_fname || ' ' || dvr.lic_lname)
    order by dem_code,cnt desc
    ) ot_query
    group by ot_query.dem_code
    )

order by "Demerit Code", "License No.";
    

/*
2(viii) Query 8
*/
--PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE

select *
from
(
select otr.Region as "Region", count(otr.veh_vin) as  "Total Vehicles Manufactured", 
    lpad(to_char(round(count(otr.veh_vin)/(select count(veh_vin) as tot from vehicle)*100,2),'990.99')||'%',30,' ') as "Percentage of Vehicles Manufactured"
from
(
select 
veh_vin,
case when substr(veh_vin,1,1) in ('A','B','C') then 'Africa'
    when substr(veh_vin,1,1) in ('J','K','L','M','N','O','P','Q','R') then 'Asia'
    when substr(veh_vin,1,1) in ('S','T','U','V','W','X','Y','Z') then 'Europe'
    when substr(veh_vin,1,1) in ('1','2','3','4','5') then 'North America'
    when substr(veh_vin,1,1) in ('6','7') then 'Oceania'
    when substr(veh_vin,1,1) in ('8','9') then 'South America'
    else 'Unknown' end as Region
from vehicle
) otr
group by otr.Region
order by "Total Vehicles Manufactured" asc
)
union all

select lpad(to_char('TOTAL'),8,' ') as "Region", sum(out_query.veh_manu) as "Total Vehicles Manufactured", 
lpad(to_char(sum(out_query.percentage),'990.99')||'%',30,' ') as "Percentage of Vehicles Manufactured"
from
(
select outer_q.Region, count(outer_q.veh_vin) as veh_manu, 
    round(count(outer_q.veh_vin)/(select count(veh_vin) as tot from vehicle)*100,2) as percentage
from
(
select 
veh_vin,
case when substr(veh_vin,1,1) in ('A','B','C') then 'Africa'
    when substr(veh_vin,1,1) in ('J','K','L','M','N','O','P','Q','R') then 'Asia'
    when substr(veh_vin,1,1) in ('S','T','U','V','W','X','Y','Z') then 'Europe'
    when substr(veh_vin,1,1) in ('1','2','3','4','5') then 'North America'
    when substr(veh_vin,1,1) in ('6','7') then 'Oceania'
    when substr(veh_vin,1,1) in ('8','9') then 'South America'
    else 'Unknown' end as Region
from vehicle
) outer_q
group by outer_q.Region
) out_query;

