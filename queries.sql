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