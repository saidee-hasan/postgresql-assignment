

-- creating  a databse ----------conservation_db---------------
CREATE DATABASE conservation_db


-- Create rangers table
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);

-- Create species table
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL UNIQUE,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) DEFAULT 'Unknown'
);

-- Create sightings table
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT,
    ranger_id INT,
    location VARCHAR(100) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT,
    FOREIGN KEY (species_id) REFERENCES species(species_id) ON DELETE CASCADE,
    FOREIGN KEY (ranger_id) REFERENCES rangers(ranger_id) ON DELETE SET NULL
);

-- Insert data into rangers table 
INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

-- Insert data into species table 
INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

-- Insert data into sightings table 
INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

-- Problem 1: Register a new ranger..........
INSERT INTO rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-- Problem 2: Count unique species ever sighted..............
SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;

-- Problem 3: Find all sightings where the location includes .............
SELECT *
FROM sightings
WHERE location ILIKE '%Pass%';

-- Problem 4: List each ranger's name and their total number of sightings...................
SELECT r.name, COUNT(s.sighting_id) AS total_sightings
FROM rangers r
JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY r.name
ORDER BY r.name;

-- Problem 5: List species that have never been sighted...........
SELECT sp.common_name
FROM species sp
WHERE sp.species_id NOT IN (SELECT DISTINCT s.species_id FROM sightings s);

-- Problem 6: Show the most recent 2 sightings...................
SELECT sp.common_name, s.sighting_time, r.name AS ranger_name
FROM sightings s
JOIN species sp ON s.species_id = sp.species_id
JOIN rangers r ON s.ranger_id = r.ranger_id
ORDER BY s.sighting_time DESC
LIMIT 2;

-- Problem 7: Update all species discovered before to have status ...........
UPDATE species
SET conservation_status = 'Historic'
WHERE EXTRACT(YEAR FROM discovery_date) < 1800;

-- Problem 8: Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'...............
SELECT
    sighting_id,
    CASE
        WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sighting_time) >= 12 AND EXTRACT(HOUR FROM sighting_time) <= 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings
ORDER BY sighting_id;

-- Problem 9: Delete rangers who have never sighted any species...................
DELETE FROM rangers
WHERE ranger_id NOT IN (SELECT DISTINCT ranger_id FROM sightings WHERE ranger_id IS NOT NULL);

-- Verification Queries .............................

SELECT * FROM rangers ORDER BY ranger_id;
SELECT * FROM species ORDER BY species_id;
SELECT * FROM sightings ORDER BY sighting_id;
