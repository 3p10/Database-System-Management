CREATE ROLE trainee LOGIN PASSWORD 'trainee_password' VALID UNTIL '2023-05-30';

GRANT ALL (orderdate, shippeddate) ON orders TO trainee;