
-- delete spaces
TRIM ( [characters ] string )
-- SQL Server < 2017
SELECT LTRIM(RTRIM(' characters '));

-- case replaces
SELECT airport_code, airport_name, airport_city,
  CASE
    WHEN airport_state <>'Florida'THEN REPLACE(airport_state,'FL','Florida')
    ELSE airport_state
    END AS airport_state
FROM airports
ORDER BY airport_state;

SELECT
  airport_code, airport_name, airport_city,
  UPPER (REPLACE (airport_state,'Florida','FL') ) AS airport_state
FROM airports
ORDER BY airport_state;

-- find similar atributes with soundex
FROM airports A1
SELECT DISTINCT A1.airport_state
INNER JOIN airports A2
  ON SOUNDEX (A1.airport_state) = SOUNDEX(A2.airport_state)
  AND A1.airport_state <> A2.airport_state;

-- replace similar atributes
SELECT DISTINCT A1.airport_state, A2.airport_state
FROM airports A1
INNER JOIN airports A2
  ON DIFFERENCE(REPLACE(A1.airport_state,' ',''), REPLACE(A2.airport_state,' ','')) = 4
  AND A1.airport_state <> A2.airport_state;
