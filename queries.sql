-- queries.sql is a file that contains the queries to be run on the database.

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE EXTRACT(year FROM date_of_birth) BETWEEN 2016 AND 2019;
SELECT * FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


-- Added Updates and Queries
BEGIN WORK;
    UPDATE ANIMALS
    SET species = 'unspecified'
    SELECT * FROM animals;
ROLLBACK;

BEGIN WORK;
    UPDATE animals
    SET species = 'digimon'
    WHERE name LIKE '%mon';

    UPDATE animals
    SET species = 'pokemon'
    WHERE species IS NULL;
COMMIT WORK;
SELECT * FROM animals;

BEGIN WORK;
    DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN WORK;
SAVEPOINT sp1;
DELETE FROM animals WHERE date_of_birth > '2022/01/01';
SAVEPOINT sp2;
UPDATE animals SET weight_kg = weight_kg * -1;
SAVEPOINT SP3;
ROLLBACK TO SP2;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;
SELECT * FROM animals;


SELECT COUNT(*) AS animals_count FROM animals;
SELECT COUNT(*) AS escape_attempts_count FROM animals 
WHERE escape_attempts = 0; 
SELECT AVG(weight_kg) AS avg_weight FROM animals;
SELECT neutered, AVG(escape_attempts) FROM animals
GROUP BY neutered ORDER BY neutered DESC;
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;
SELECT species, AVG(escape_attempts) AS avg_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species



--  --JOIN QUERY
-- What animals belong to Melody Pond?
SELECT animl.name
FROM animals animl
JOIN owners ownr ON animl.owner_id = ownr.id
WHERE ownr.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animl.name
FROM animals animl
JOIN species sp ON animl.species_id = sp.id
WHERE sp.name = 'Pokemon';

-- List all owners and their animals, including those who don't own any animal.
SELECT ownr.full_name, animl.name
FROM owners ownr
LEFT JOIN animals animl ON ownr.id = animl.owner_id;

-- How many animals are there per species?
SELECT sp.name, COUNT(animl.id) AS animal_count
FROM species sp
LEFT JOIN animals animl ON sp.id = animl.species_id
GROUP BY sp.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT animl.name
FROM animals animl
JOIN species sp ON animl.species_id = sp.id
JOIN owners ownr ON animl.owner_id = ownr.id
WHERE sp.name = 'Digimon' AND ownr.full_name = 'Jennifer Orwell';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animl.name
FROM animals animl
JOIN owners ownr ON animl.owner_id = ownr.id
WHERE ownr.full_name = 'Dean Winchester' AND animl.escape_attempts = 0;

-- Who owns the most animals?
SELECT ownr.full_name, COUNT(animl.id) AS animal_count
FROM owners ownr
JOIN animals animl ON ownr.id = animl.owner_id
GROUP BY ownr.full_name
ORDER BY animal_count DESC;