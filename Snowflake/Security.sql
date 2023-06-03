
-- set public key
ALTER USER <user_name> SET rsa_public_key='xxx';

-- newtork policy
CREATE NETWORK POLICY mypolicy ALLOWED_IP_LIST=('192.168.1.0','192.168.1.100');
DESC NETWORK POLICY mypolicy;

-- alter
ALTER NEWTORK POLICY <policy_name> SET allowed_ip_list=('192.168.1.0/24','192.168.255.100')

-- drop
DROP NETWORK POLICY <policy_name>;

-- set network policy
ALTER USER user_name SET NETWORK_POLICY = 'name';
ALTER USER user_name UNSET NETWORK_POLICY ;