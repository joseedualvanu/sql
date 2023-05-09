
-- create user
CREATE  USER "<user_name>" PASSWORD 'XXX'
DEFAULT_ROLE = "<role_name>" 
DEFAULT_WAREHOUSE = '<wh>' 
MUST_CHANGE_PASSWORD = TRUE
COMMENT = 'team?'
FIRST_NAME = 'name'
LAST_NAME = 'surname'
email='email';

-- set timeout
ALTER USER "<user_name>" SET STATEMENT_TIMEOUT_IN_SECONDS = 600;


