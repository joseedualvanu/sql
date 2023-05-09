
-- set public key
ALTER USER <user_name> SET rsa_public_key='xxx';

-- newtork policy
CREATE NETWORK POLICY mypolicy2 ALLOWED_IP_LIST=('192.168.1.0','192.168.1.100');
DESC NETWORK POLICY mypolicy2;

-- alter
ALTER NEWTORK POLICY MICRO_AWS SET allowed_ip_list=('192.168.1.0/24','192.168.255.100')

-- drop
DROP NETWORK POLICY PRUEBA;