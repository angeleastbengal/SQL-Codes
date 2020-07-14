--****PLEASE ENTER YOUR DETAILS BELOW****
--Q3-tds-mods.sql
--Student ID: 31131867
--Student Name: Angel Das
--Tutorial No: 1 (Tue 12-2 pm)
--Last Modified: 12-Jun-2020

/* Comments for your marker:
1. For new tables, comments and constraints are added
2. While capturing information pertaining to revokeinfo, officer id is stored as two officers with the same name
can have different ids
*/


/*
3(i) Changes to live database 1
*/
--PLEASE PLACE REQUIRED SQL STATEMENTS FOR THIS PART HERE

ALTER TABLE OFFICER
ADD booked_cases NUMBER(8) DEFAULT 0; --booked_cases are set to 0 initially

COMMENT ON COLUMN OFFICER.booked_cases IS
    'Total Booked Cases';


UPDATE officer ofcr
SET
    booked_cases = (
        SELECT
            booked_cases
        FROM
            (
                SELECT
                    ofc.officer_id,
                    COUNT(ofn.off_no) AS booked_cases
                FROM
                    officer   ofc
                    JOIN offence   ofn ON ofc.officer_id = ofn.officer_id
                GROUP BY
                    ofc.officer_id
            ) t2
        WHERE
            ofcr.officer_id = t2.officer_id
    )
WHERE
    ofcr.officer_id IN (
        SELECT
            t3.officer_id
        FROM
            (
                SELECT
                    ofc.officer_id,
                    COUNT(ofn.off_no) AS booked_cases
                FROM
                    officer   ofc
                    JOIN offence   ofn ON ofc.officer_id = ofn.officer_id
                GROUP BY
                    ofc.officer_id
            ) t3
    );

COMMIT;


/*
3(ii) Changes to live database 2
*/
--PLEASE PLACE REQUIRED SQL STATEMENTS FOR THIS PART HERE



ALTER TABLE offence ADD is_revoked VARCHAR(2) DEFAULT 'No';

COMMENT ON COLUMN offence.is_revoked IS
    'Offence revoked or not';

ALTER TABLE offence
    ADD CONSTRAINT revoke_const CHECK ( is_revoked IN (
        'Yes',
        'No'
    ) );

COMMIT;

--Adding a separate table for reovoke reasons and codes
DROP TABLE revokecodedesc CASCADE CONSTRAINTS;

CREATE TABLE revokecodedesc (
    revoke_reason_cd    CHAR(3),
    revoke_description VARCHAR(100) NOT NULL
);

COMMENT ON COLUMN revokecodedesc.revoke_reason_cd IS
    'Revoke Reason Code';
COMMENT ON COLUMN revokecodedesc.revoke_description IS
    'Revoke Reason Code Description';

ALTER TABLE revokecodedesc ADD CONSTRAINT revokecodedesc_pk PRIMARY KEY ( revoke_reason_cd );

ALTER TABLE revokecodedesc
    ADD CONSTRAINT reasonrevoke_const CHECK ( revoke_reason_cd IN (
        'FOS',
        'FEU',
        'DOU',
        'COH',
        'EIP'
    ) );

COMMIT;

-------Adding values to the revokecodedesc table----------------
INSERT INTO revokecodedesc VALUES ('FOS','First offence exceeding the speed limit by less than 10km/h');
INSERT INTO revokecodedesc VALUES ('FEU','Faulty equipment used');
INSERT INTO revokecodedesc VALUES ('DOU','Driver objection upheld');
INSERT INTO revokecodedesc VALUES ('COH','Court hearing');
INSERT INTO revokecodedesc VALUES ('EIP','Error in proceedings');

COMMIT;


--Adding a separate table for storing offence information that are revoked
DROP TABLE revokeinfo CASCADE CONSTRAINTS;

CREATE TABLE revokeinfo (
    off_no            NUMBER(8) NOT NULL,
    revoked_dt_tm     DATE,
    officer_id        NUMBER(8) NOT NULL,
    revokedby_fname   VARCHAR(30),
    revokedby_lname   VARCHAR(30),
    revoke_reason_cd     CHAR(3)
);

COMMENT ON COLUMN revokeinfo.off_no IS
    'Offence number';

COMMENT ON COLUMN revokeinfo.revoked_dt_tm IS
    'Date and time at which the offence is revoked';

COMMENT ON COLUMN revokeinfo.officer_id IS
    'Officer ID who revoked the offence';

COMMENT ON COLUMN revokeinfo.revokedby_fname IS
    'Officer first name who revoked the offence';

COMMENT ON COLUMN revokeinfo.revokedby_lname IS
    'Officer last name who revoked the offence';

COMMENT ON COLUMN revokeinfo.revoke_reason_cd IS
    'Reason Code for which the offence was revoked';

ALTER TABLE revokeinfo ADD CONSTRAINT revoke_info_pmkey PRIMARY KEY ( off_no );

ALTER TABLE revokeinfo
    ADD CONSTRAINT revoke_info_fokey FOREIGN KEY ( officer_id )
        REFERENCES officer ( officer_id );

ALTER TABLE revokeinfo
    ADD CONSTRAINT revoke_in_fokey FOREIGN KEY ( revoke_reason_cd )
        REFERENCES revokecodedesc ( revoke_reason_cd );

ALTER TABLE revokeinfo
    ADD CONSTRAINT reason_const CHECK ( revoke_reason_cd IN (
        'FOS',
        'FEU',
        'DOU',
        'COH',
        'EIP'
    ) );
COMMIT;


/*
3(iii) Changes to live database 3
*/
--PLEASE PLACE REQUIRED SQL STATEMENTS FOR THIS PART HERE

--Creating table to store color and color codes
DROP SEQUENCE color_seq;

CREATE SEQUENCE color_seq START WITH 1 INCREMENT BY 1;

DROP TABLE color_codes CASCADE CONSTRAINTS;

CREATE TABLE color_codes (
    color_code   NUMBER(8) NOT NULL,
    color_desc   VARCHAR(10) NOT NULL
);

COMMENT ON COLUMN color_codes.color_code IS
    'Color codes';

COMMENT ON COLUMN color_codes.color_desc IS
    'Color Description';

ALTER TABLE color_codes ADD CONSTRAINT color_pk PRIMARY KEY ( color_code );

INSERT INTO color_codes (
    color_code,
    color_desc
)
    SELECT
        color_seq.NEXTVAL AS code,
        veh_maincolor
    FROM
        (
            SELECT DISTINCT
                veh_maincolor
            FROM
                vehicle
        );

COMMIT;

---------------------------------------Extra color is added to color_codes table using the insert statement--------
INSERT INTO COLOR_CODES VALUES (color_seq.NEXTVAL,'Magenta');
COMMIT;

---------------------------------------Updating Color codes in Vehicle--------------------------
ALTER TABLE vehicle ADD color_code NUMBER(8); -- since table already exists can't put a not null constraint

COMMENT ON COLUMN vehicle.color_code IS
    'Color Codes';

ALTER TABLE vehicle
    ADD CONSTRAINT vehcl_fokey FOREIGN KEY ( color_code )
        REFERENCES color_codes ( color_code );
        
UPDATE vehicle veh
SET
    veh.color_code = (
        SELECT
            color_code
        FROM
            color_codes color
        WHERE
            veh.veh_maincolor = color.color_desc
    )
WHERE
    veh.veh_maincolor IN (
        SELECT
            color.color_desc
        FROM
            color_codes color
    );

ALTER TABLE vehicle DROP COLUMN veh_maincolor;

COMMIT;

DROP TABLE outerpartcolor CASCADE CONSTRAINTS;

CREATE TABLE outerpartcolor (
    veh_vin                 CHAR(17) NOT NULL,
    veh_out_body_cd         CHAR(2) NOT NULL,
    veh_out_body_color_cd   NUMERIC(8) NOT NULL
);

ALTER TABLE outerpartcolor
    ADD CHECK ( veh_out_body_cd IN (
        'SP',
        'BM',
        'GR'
    ) );

COMMENT ON COLUMN outerpartcolor.veh_vin IS
    'Vehicle identification number';

COMMENT ON COLUMN outerpartcolor.veh_out_body_cd IS
    'Body Part';

COMMENT ON COLUMN outerpartcolor.veh_out_body_color_cd IS
    'Vehicle other body parts color';

ALTER TABLE outerpartcolor ADD CONSTRAINT outr_vehicle_pk PRIMARY KEY ( veh_vin,
                                                                        veh_out_body_cd );

INSERT INTO outerpartcolor VALUES (
    'ZHWEF4ZF2LLA13803',
    'SP',
    (
        SELECT
            color_code
        FROM
            color_codes
        WHERE
            color_desc = 'Black'
    )
);

INSERT INTO outerpartcolor VALUES (
    'ZHWEF4ZF2LLA13803',
    'GR',
    (
        SELECT
            color_code
        FROM
            color_codes
        WHERE
            color_desc = 'Magenta'
    )
);

INSERT INTO outerpartcolor VALUES (
    'ZHWES4ZF8KLA12259',
    'SP',
    (
        SELECT
            color_code
        FROM
            color_codes
        WHERE
            color_desc = 'Yellow'
    )
);

INSERT INTO outerpartcolor VALUES (
    'ZHWES4ZF8KLA12259',
    'BM',
    (
        SELECT
            color_code
        FROM
            color_codes
        WHERE
            color_desc = 'Blue'
    )
);
COMMIT;
























