
-- see date within last 24 hours
SELECT COUNT(*) 
FROM <table_name> at(offset => -60*60*6); -- seconds * minutes * hours
