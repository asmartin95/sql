--  Before you try the code in this file from the psql client, you need to create your database NBA-xxx and copy data from NBA to it. For example,
--  createdb NBA-tuy
--  pg_dump -t player_rs_career NBA | psql NBA-tuy
--  Note that those should be done under the Linux console. Then you can log into NBA-xxx and try the following scripts.

--  The following line only needs to be executed once before you do anything at all with pgplsql functions
--  CREATE LANGUAGE 'plpgsql';


-- function 1 declaration

CREATE OR REPLACE FUNCTION fibonacci (lastN INTEGER) 
RETURNS int AS $$
DECLARE
  currentTotal integer;
  i integer;
  a integer = 0;
  b integer = 1;
BEGIN
	currentTotal = 0;
    
    --Check for bounds
    IF (lastN NOT BETWEEN 0 AND 1000) THEN
      RETURN -1;
    END IF;
      
    --Check if 0
    IF (lastN = 0) THEN
      RETURN 0;   
    END IF;
    
    --For loop to determine fibonacci number
    --a is the number at the current loop
    FOR i IN 1..lastN LOOP
      currentTotal = a + b;
      a = b;
      b = currentTotal;
    END LOOP;      
    RETURN a;    
END;
$$ LANGUAGE plpgsql;


-- function 2 declaration

CREATE OR REPLACE FUNCTION player_height_rank (firstname VARCHAR, lastname VARCHAR) RETURNS int AS $$
DECLARE
   fName VARCHAR;
   lName VARCHAR;
   minHeight integer;
   rank integer;
BEGIN
  fname = firstname;
  lName = lastname;

  --Select the height of the parameter player and set it as minHeight
  SELECT 12 * p.h_feet  + p.h_inches INTO minHeight FROM players p WHERE UPPER(p.firstname) = UPPER(fname) AND UPPER(p.lastname) = UPPER(lName);
  
  --Count the distinct rows with players heights > then the minHeight we just set and set this count to the rank
  SELECT count(p.height) INTO rank FROM (SELECT DISTINCT p.h_feet * 12 + p.h_inches AS height FROM players p) as p WHERE p.height > minHeight;
  
  RETURN rank + 1;

END;
$$ LANGUAGE plpgsql;

-- executing the above functions
-- select * from fibonacci(0);
-- select * from fibonacci(1);
-- select * from fibonacci(2);
-- select * from fibonacci(3);
-- select * from fibonacci(4);
-- select * from fibonacci(5);
-- select * from fibonacci(45);
-- select * from player_height_rank('Gheorghe', 'Muresan');
-- select * from player_height_rank('Manute', 'Bol');
-- select * from player_height_rank('Pavel', 'Podkolzine');
-- select * from player_height_rank('Yao', 'Ming');
-- select * from player_height_rank('Shawn', 'Bradley');
-- select * from player_height_rank('Slavko', 'Vranes');

