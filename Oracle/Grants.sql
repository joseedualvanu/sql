-- grants table
GRANT SELECT, INSERT, DELETE ON <table_name> TO user; 

-- grant store procedure
GRANT EXECUTE ON <storeprocedure_name> TO user;
GRANT EXECUTE ON <storeprocedure_name> to OPS$user;