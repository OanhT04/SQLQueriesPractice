--1 CORRECT
-- For each part, report its number, its name, the part number of its parent part(s) and the parent part’s name.
--Order by the assembly part number and then by the component part number.  Returns 17 rows.  Note that this is a network of parts.
-- There may be more than one part that uses a given part as a component.  That is not the case here, but it could be.
SELECT DISTINCT p1.part_name AS componentName, p1.part_number AS componentNumber, p2.part_name AS assemblyName, p2.part_number AS assemblyNumber
FROM usages u
INNER JOIN parts p1 ON (p1.part_name = u.component_part_name)
INNER JOIN parts p2 ON (p2.part_name = u.assembly_parts_part_name)
ORDER BY p2.part_number, p1.part_number;


--2 CORRECT
--List the names of all pairs of parts that belong to the same assembly. Order by the first part name, then the second. 
--Be careful to make sure that you do not show any pair of parts twice.  We went over a way to do that in lecture.  Returns nine rows.
SELECT  u1.component_part_name AS componentPart1, u2.component_part_name AS componentPart2
FROM usages u1
LEFT JOIN usages u2
ON u1.assembly_parts_part_name = u2.assembly_parts_part_name
AND u1.component_part_name < u2.component_part_name
ORDER BY componentPart1, componentPart2;

--3
--Find the pairs of usages (one part uses another part) which have the same quantity used.  
--For each such pair, list the first usage’s assembly part number and name and number of the part that it is using, 
--the second usage’s assembly part number and name and part name and number of the part that the second assembly is using.  
--Order by the first usage’s assembly part number, and then by the second usage’s assembly part number.  
--Be careful not to show the same pair of part usages more than once.



SELECT
p.part_number AS assemblyNum1, u.assembly_parts_part_name AS assemblyName1,
p1.part_number AS componentNum1, u.component_part_name AS componentName1,
u.usage_quantity AS commonUsage,
p2.part_number AS assembly2Num, u2.assembly_parts_part_name AS assembly2Name,
p3.part_number AS component2Num, p3.part_name AS component2Name
FROM usages u
LEFT JOIN usages u2
ON u.usage_quantity = u2.usage_quantity
AND (u.assembly_parts_part_name < u2.assembly_parts_part_name)
AND (u.component_part_name < u2.component_part_name)
JOIN parts p  ON p.part_name = u.assembly_parts_part_name
JOIN parts p2 ON p2.part_name = u2.assembly_parts_part_name
JOIN parts p1 ON p1.part_name = u.component_part_name
JOIN parts p3 ON p3.part_name = u2.component_part_name
GROUP BY assemblyName1, assembly2Name, componentName1, p.part_number, p1.part_number, p2.part_number, component2Num, component2Name,
        commonUsage
ORDER BY p.part_number, p2.part_number;






--4 - CORRECT
--List the part number and part name of all the parts that are used directly by the Engine. 
--Pretend that you do not know the part number for Engine, and instead just know its name.  Order by the part’s name.  
--The observant among you will have noticed that all the parts that meet this requirement have a part number ‘X.Y’.  
--Do not rely on that, instead, follow the part-to-part associations up to Engine.  Returns three.

SELECT p.part_name AS partName, p.part_number AS partNumber
FROM usages u
INNER JOIN parts p ON (p.part_name = u.component_part_name)
WHERE u.assembly_parts_part_name = 'Engine'
ORDER BY partName;

--5 CORRECT
--List the part number and part name of all the parts that are used directly by a part that is used directly by the engine. 
--Again, pretend that you do not know what the part number is for the engine.  
--The clever among you will have noticed that there is a pattern to the naming. 
-- Do not use that to make your life easier.  Follow the recursive usage relationships instead.  Returns seven rows.

WITH assemblies1 AS (
    SELECT u.component_part_name AS engineComponentName, p.part_number as engineComponentNumber
    FROM usages u
    INNER JOIN parts p ON (u.component_part_name = p.part_name)
    WHERE u.assembly_parts_part_name = 'Engine'),
assemblies2 AS(
    SELECT DISTINCT u.component_part_name AS componentName, p.part_number AS componentNumber,
    u.assembly_parts_part_name AS assemblyName
    FROM usages u
    INNER JOIN parts p ON (u.component_part_name = p.part_name)
    INNER JOIN assemblies1 a ON a.engineComponentName = u.assembly_parts_part_name
)
SELECT DISTINCT componentNumber, componentName
FROM assemblies2
ORDER BY componentNumber;


--6. - CORRECT
-- List the part number and part name of all parts that are directly used by a part that is directly used 
-- by a part that is directly used by the engine.  Returns four rows.

WITH assemblies1 AS (
    SELECT u.component_part_name AS engineComponentName, p.part_number as engineComponentNumber
    FROM usages u
    INNER JOIN parts p ON (u.component_part_name = p.part_name)
    WHERE u.assembly_parts_part_name = 'Engine'),
assemblies2 AS(
    SELECT DISTINCT u.component_part_name AS componentName, p.part_number AS componentNumber,
    u.assembly_parts_part_name AS assemblyName
    FROM usages u
    INNER JOIN parts p ON (u.component_part_name = p.part_name)
    INNER JOIN assemblies1 a ON a.engineComponentName = u.assembly_parts_part_name
),
parts3 AS(
    SELECT DISTINCT u.component_part_name AS componentName, p.part_number AS componentNumber,
    u.assembly_parts_part_name AS assemblyName
    FROM usages u
    INNER JOIN parts p ON (u.component_part_name = p.part_name)
    INNER JOIN assemblies2 a ON a.componentName = u.assembly_parts_part_name
)
SELECT componentNumber, componentName
FROM parts3
ORDER BY componentNumber, componentName;

-- 7 CORRECT 
--Report out the assembly name, number,
-- and the number of components that directly go into that assembly,
-- but only for the assembly with the largest number of components.  
-- We are not interested in the quantity of parts that go into the assembly.  
--For instance, if an assembly needs 3 of one part and 5 of another, 
--there are just two parts going into that assembly.  Returns 2.

WITH componentCount AS(
    SELECT u.assembly_parts_part_name AS assemblyName, p.part_number AS assemblyNumber,
    COUNT(DISTINCT(u.component_part_name)) as numberOfComponents
    FROM usages u
    INNER JOIN parts p ON (p.part_name = u.assembly_parts_part_name)
    GROUP BY assemblyName, assemblyNumber 
)
SELECT assemblyName, assemblyNumber, numberOfComponents
FROM componentCount
WHERE numberOfComponents = (
    SELECT MAX(numberOfComponents) 
    FROM (SELECT * FROM componentCount) AS largest
)
ORDER BY assemblyNumber;

-- 8 CORRECT
--Report out the assembly name and part number for each assembly that
--has the greatest number of individual parts that go into it.
--In this case, if an assembly has two components, and one of those components
--has a quantity of 4 and the other component has a quantity of of 2 then the total quantity of parts for that assembly would be 6.
--Returns 2.
WITH usageCount AS(
    SELECT u.assembly_parts_part_name AS assemblyName, p.part_number AS assemblyNumber, SUM(u.usage_quantity) as totalUsageQuantity
    FROM usages u
    INNER JOIN parts p ON (p.part_name = u.assembly_parts_part_name)
    GROUP BY assemblyName, assemblyNumber
)
SELECT assemblyName, assemblyNumber, totalUsageQuantity
FROM usageCount
WHERE totalUsageQuantity = (
    SELECT MAX(totalUsageQuantity)
    FROM (SELECT * FROM usageCount) AS largest
)
ORDER BY assemblyNumber;

--9
--Find all parts that do not go into an assembly that directly 
-- goes into the transmission (be careful of the casing on this one).  
--Note that this particular part breakdown does not have any cases in which one part goes into more than one other part.  
--But generally speaking, a part breakdown structure is a network.  write your query accordingly.  Returns 14 rows.
-- EXCLUDES SPRING TORQUE ROLLERS



--EXCEPT CORRECT

SELECT p1.part_name, p1.part_number
FROM parts p1
EXCEPT
SELECT p.part_name, p.part_number
FROM parts p
JOIN usages u2
ON u2.component_part_name = p.part_name
WHERE u2.assembly_parts_part_name IN (
    SELECT u1.component_part_name
    FROM usages u1
    WHERE u1.assembly_parts_part_name = 'Transmission'
)
ORDER BY part_number;
-- not in CORRECT

WITH assemblies1 AS (
    SELECT u.component_part_name AS transmissionComponentName, p.part_number as transmissionComponentNumber
    FROM usages u
    INNER JOIN parts p ON (u.component_part_name = p.part_name)
    WHERE u.assembly_parts_part_name = 'Transmission')
SELECT p.part_name,  p.part_number
FROM parts p WHERE p.part_name NOT IN(
    SELECT DISTINCT u.component_part_name
    FROM  usages u
    INNER JOIN assemblies1 a
        ON (transmissionComponentName = u.assembly_parts_part_name)
)
ORDER BY p.part_number;


