-- count
SELECT COUNT(*)
FROM <table_name>
WHERE tiem_dia_id >= trunc(sysdate) -1;

-- first rows
SELECT *
FROM <table_name>
FETCH FIRST 100 ROWS ONLY;

-- delete
DELETE FROM <table_name>;

-- execute sp
BEGIN
	<storeprocedure_name>;
END;

-- dependes on the UI
COMMIT;
ROLLBACK;

-- update row
UPDATE <table_name>
SET column1 = value
WHERE columnX condition;