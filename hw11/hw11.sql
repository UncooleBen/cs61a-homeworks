CREATE TABLE parents AS
  SELECT "abraham" AS parent, "barack" AS child UNION
  SELECT "abraham"          , "clinton"         UNION
  SELECT "delano"           , "herbert"         UNION
  SELECT "fillmore"         , "abraham"         UNION
  SELECT "fillmore"         , "delano"          UNION
  SELECT "fillmore"         , "grover"          UNION
  SELECT "eisenhower"       , "fillmore";

CREATE TABLE dogs AS
  SELECT "abraham" AS name, "long" AS fur, 26 AS height UNION
  SELECT "barack"         , "short"      , 52           UNION
  SELECT "clinton"        , "long"       , 47           UNION
  SELECT "delano"         , "long"       , 46           UNION
  SELECT "eisenhower"     , "short"      , 35           UNION
  SELECT "fillmore"       , "curly"      , 32           UNION
  SELECT "grover"         , "short"      , 28           UNION
  SELECT "herbert"        , "curly"      , 31;

CREATE TABLE sizes AS
  SELECT "toy" AS size, 24 AS min, 28 AS max UNION
  SELECT "mini"       , 28       , 35        UNION
  SELECT "medium"     , 35       , 45        UNION
  SELECT "standard"   , 45       , 60;

-------------------------------------------------------------
-- PLEASE DO NOT CHANGE ANY SQL STATEMENTS ABOVE THIS LINE --
-------------------------------------------------------------

-- The size of each dog
CREATE TABLE size_of_dogs AS
  SELECT d.name AS name, s.size AS size FROM dogs AS d, sizes AS s
  WHERE d.height > s.min AND d.height <= s.max;

-- All dogs with parents ordered by decreasing height of their parent
CREATE TABLE by_parent_height AS
  SELECT d.name FROM dogs AS d, parents AS p, dogs AS h
  WHERE p.child = d.name AND p.parent = h.name
  ORDER BY h.height DESC;

-- Filling out this helper table is optional
CREATE TABLE siblings AS
  SELECT d1.name AS name1, d2.name AS name2, s1.size AS size
  FROM dogs AS d1, dogs AS d2, parents AS p1, parents AS p2, size_of_dogs AS s1, size_of_dogs AS s2
  WHERE p1.child = d1.name AND
  p2.child = d2.name AND
  p1.parent = p2.parent AND
  d1.name < d2.name AND
  s1.name = d1.name AND
  s2.name = d2.name AND
  s1.size = s2.size;

-- Sentences about siblings that are the same size
CREATE TABLE sentences AS
  SELECT printf('%s and %s are %s siblings', s.name1, s.name2, s.size) FROM siblings AS s;
  

-- Ways to stack 4 dogs to a height of at least 170, ordered by total height
CREATE TABLE stacks_helper(dogs, stack_height, last_height);

-- Add your INSERT INTOs here
INSERT INTO stacks_helper
SELECT d.name, d.height, d.height FROM dogs AS d;
INSERT INTO stacks_helper
SELECT sh.dogs||', '||d.name, sh.stack_height+d.height, d.height FROM stacks_helper AS sh, dogs AS d
WHERE d.height>sh.last_height;
INSERT INTO stacks_helper
SELECT sh.dogs||', '||d.name, sh.stack_height+d.height, d.height FROM stacks_helper AS sh, dogs AS d
WHERE d.height>sh.last_height;
INSERT INTO stacks_helper
SELECT sh.dogs||', '||d.name, sh.stack_height+d.height, d.height FROM stacks_helper AS sh, dogs AS d
WHERE d.height>sh.last_height;


CREATE TABLE stacks AS
SELECT sh.dogs, sh.stack_height
FROM stacks_helper AS sh
WHERE sh.stack_height >= 170
ORDER BY sh.stack_height ASC;
