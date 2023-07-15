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


--Who was the last animal seen by William Tatcher?
SELECT animl.name
FROM animals animl
JOIN visits v ON animl.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'William Tatcher'
ORDER BY v.visit_date DESC
FETCH FIRST 1 ROW ONLY;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT v.animal_id)
FROM visits v
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.
SELECT vt.name, COALESCE(string_agg(s.name, ', '), 'No Specialties') AS specialties
FROM vets vt
LEFT JOIN specializations sp ON sp.vet_id = vt.id
LEFT JOIN species s ON s.id = sp.specie_id
GROUP BY vt.name;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animl.name
FROM animals animl
JOIN visits v ON animl.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'Stephanie Mendez'
  AND v.visit_date >= '2020-04-01'
  AND v.visit_date <= '2020-08-30';

-- What animal has the most visits to vets?
SELECT animl.name, COUNT(v.animal_id) AS visit_count
FROM animals animl
JOIN visits v ON animl.id = v.animal_id
GROUP BY animl.name
ORDER BY visit_count DESC
FETCH FIRST 1 ROW ONLY;

-- Who was Maisy Smith's first visit?
SELECT animl.name
FROM animals animl
JOIN visits v ON animl.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'Maisy Smith'
ORDER BY v.visit_date ASC
FETCH FIRST 1 ROW ONLY;

-- Details for the most recent visit: animal information, vet information, and date of visit.
SELECT animl.name AS animal_name, vt.name AS vet_name, v.visit_date
FROM animals animl
JOIN visits v ON animl.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
ORDER BY v.visit_date DESC
FETCH FIRST 1 ROW ONLY;

--How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*)
FROM visits v
JOIN animals animl ON animl.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
LEFT JOIN specializations sp ON sp.vet_id = vt.id AND sp.specie_id = animl.species_id
WHERE sp.specie_id IS NULL;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name
FROM visits
JOIN vets ON visits.vet_id = vets.id
JOIN animals ON animals.id = visits.animal_id
JOIN species ON animals.species_id = species.id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY COUNT(species.name) DESC
FETCH FIRST 1 ROW ONLY;