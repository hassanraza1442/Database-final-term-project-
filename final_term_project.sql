-- Universities table 
CREATE TABLE universities (
    id SERIAL,
    university_shortname TEXT,
    university TEXT,
    university_city TEXT
);

-- Professors table 
CREATE TABLE professors (
    id SERIAL,
    firstname TEXT,
    lastname TEXT,
    university_shortname TEXT
);

-- Organizations table
CREATE TABLE organizations (
    id SERIAL,
    organization TEXT,
    organization_sector TEXT
);

-- Affiliations table 
CREATE TABLE affiliations (
    id SERIAL,
    professor_id INT,
    organization_id INT,
    function TEXT
);


INSERT INTO universities (university_shortname, university, university_city)
SELECT DISTINCT university_shortname, university, university_city
FROM university_professors;


INSERT INTO professors (firstname, lastname, university_shortname)
SELECT DISTINCT first_name , last_name, university_shortname
FROM university_professors;

INSERT INTO organizations (organization, organization_sector)
SELECT DISTINCT organization, organization_sector
FROM university_professors;

INSERT INTO affiliations (professor_id, organization_id, function)
SELECT
    p.id,
    o.id,
    up.function
FROM university_professors up
JOIN professors p 
  ON p.firstname = up.first_name AND p.lastname = up.last_name
JOIN organizations o 
  ON o.organization = up.organization;


-- Universities
ALTER TABLE universities
ALTER COLUMN university_shortname SET NOT NULL,
ALTER COLUMN university SET NOT NULL,
ADD CONSTRAINT pk_universities PRIMARY KEY (id),
ADD CONSTRAINT unique_university_shortname UNIQUE (university_shortname);

-- Professors
ALTER TABLE professors
ALTER COLUMN firstname SET NOT NULL,
ALTER COLUMN lastname SET NOT NULL,
ALTER COLUMN university_shortname SET NOT NULL,
ADD CONSTRAINT pk_professors PRIMARY KEY (id);

-- Organizations
ALTER TABLE organizations
ALTER COLUMN organization SET NOT NULL,
ADD CONSTRAINT pk_organizations PRIMARY KEY (id);

-- Affiliations
ALTER TABLE affiliations
ALTER COLUMN professor_id SET NOT NULL,
ALTER COLUMN organization_id SET NOT NULL,
ADD CONSTRAINT pk_affiliations PRIMARY KEY (id);


-- Professors → Universities
ALTER TABLE professors
ADD CONSTRAINT fk_professor_university
FOREIGN KEY (university_shortname)
REFERENCES universities (university_shortname);

-- Affiliations → Professors
ALTER TABLE affiliations
ADD CONSTRAINT fk_affiliation_professor
FOREIGN KEY (professor_id)
REFERENCES professors(id);

-- Affiliations → Organizations
ALTER TABLE affiliations
ADD CONSTRAINT fk_affiliation_organization
FOREIGN KEY (organization_id)
REFERENCES organizations(id);




select table_name, column_name, data_type
from information_schema.columns
where table_name = 'university_professors'





SELECT o.organization, COUNT(*) AS professor_count
FROM affiliations a
JOIN organizations o ON a.organization_id = o.id
GROUP BY o.organization
ORDER BY professor_count DESC
LIMIT 5;

UPDATE professors
SET firstname = 'John'
WHERE firstname = 'Jon';
