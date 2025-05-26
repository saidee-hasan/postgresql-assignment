-- create table for rangers  
  CREATE Table rangers (
    ranger_id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
  );

  -- create table for species
  CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) DEFAULT 'Unknown'
  );

  -- crate table for sightings
  CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(species_id),
    ranger_id INT REFERENCES rangers(ranger_id),
    location VARCHAR(100) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT
);

-- insert data on rangers table
INSERT INTO rangers ( name, region) VALUES
('Elena Rodriguez', 'Wetland Reserve'),
('James Thompson', 'Desert Valley'),
('Sarah Chen', 'Tropical Forest'),
('Michael Brown', 'Alpine Meadows'),
('Lisa Johnson', 'Grassland Plains'),
('David Kumar', 'Mangrove Coast'),
('Anna Petrov', 'Boreal Forest');

-- insert data on species table
INSERT INTO species ( common_name, scientific_name, discovery_date, conservation_status) VALUES
('Giant Panda', 'Ailuropoda melanoleuca', '1869-03-11', 'Vulnerable'),
('Sumatran Orangutan', 'Pongo abelii', '1827-01-01', 'Critically Endangered'),
('Amur Leopard', 'Panthera pardus orientalis', '1857-01-01', 'Critically Endangered'),
('Javan Rhinoceros', 'Rhinoceros sondaicus', '1822-01-01', 'Critically Endangered'),
('Vaquita Porpoise', 'Phocoena sinus', '1958-01-01', 'Critically Endangered'),
('Mountain Gorilla', 'Gorilla beringei beringei', '1902-01-01', 'Critically Endangered'),
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Vulnerable'),
('Hawksbill Turtle', 'Eretmochelys imbricata', '1766-01-01', 'Critically Endangered'),
('African Wild Dog', 'Lycaon pictus', '1820-01-01', 'Endangered');




-- insert data  on sightings table
INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(4, 2, 'Panda Valley', '2024-06-01 08:15:00', 'Adult with cub observed'),
(5, 1, 'Canopy Bridge', '2024-06-02 14:30:00', 'Building nest in tall tree'),
(6, 1, 'Rocky Outcrop', '2024-06-03 19:45:00', 'Hunting behavior observed'),
(7, 3, 'Muddy Riverbank', '2024-06-04 06:20:00', 'Fresh tracks and wallowing signs'),
(8, 1, 'Coastal Waters', '2024-06-05 11:10:00', 'Spotted during boat patrol'),
(9, 4, 'Dense Undergrowth', '2024-06-06 16:40:00', 'Family group observed'),
(4, 1, 'Sandy Beach', '2024-06-08 22:15:00', 'Nesting activity detected');



-- Problem 1: Insert new ranger 'Derek Fox'
INSERT INTO rangers (name, region) VALUES('Derek Fox', 'Coastal Plains' );


-- Problem 2: Count the number of unique species sighted
SELECT  count(DISTINCT common_name) as unique_species_count  FROM species;


-- Problem 3: Find all sightings where location contains the word 'Pass'
SELECT * FROM sightings
WHERE location ILIKE '%Pass%';

-- Problem 4: Show total number of sightings made by each ranger
SELECT name, count(sighting_id) as total_sightings FROM rangers
join sightings ON rangers.ranger_id = sightings.ranger_id
GROUP BY name;


-- Problem 5: List species that have not been sighted yet
SELECT common_name FROM species
WHERE species_id NOT IN (
  SELECT DISTINCT species_id 
  FROM sightings
);

-- Problem 6: Show the latest 2 sightings with species name, time, and ranger name
SELECT common_name, sighting_time, name FROM sightings
JOIN rangers ON sightings.ranger_id = rangers.ranger_id
JOIN species ON sightings.species_id = species.species_id
ORDER BY sighting_time DESC
LIMIT 2;


-- Problem 7: Update conservation status to 'Historic' for species discovered before 1800
UPDATE species SET conservation_status = 'Historic' 
WHERE discovery_date < '1800-01-01';


-- Problem 8: Classify sightings into Morning, Afternoon, and Evening based on time
SELECT extract(HOUR FROM sighting_time) AS hour,
  CASE 
    WHEN extract(HOUR FROM sighting_time) < 12 THEN 'Morning'
    WHEN extract(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day
FROM sightings;


-- Problem 9: Delete rangers who have no recorded sightings
DELETE  FROM rangers
WHERE ranger_id NOT IN(
  SELECT DISTINCT ranger_id FROM sightings
);


-- Verification queries
SELECT * FROM rangers

SELECT * FROM sightings

SELECT * FROM species