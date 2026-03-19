USE DATABASE linkedin;
USE SCHEMA raw;

-- 1. Ajout d'une colonne date lisible dans job_postings
ALTER TABLE job_postings ADD COLUMN listed_date TIMESTAMP;

UPDATE job_postings
SET listed_date = TO_TIMESTAMP(listed_time / 1000);

-- 2. Standardisation du champ formatted_work_type
UPDATE job_postings
SET formatted_work_type = INITCAP(TRIM(formatted_work_type));

-- 3. Création d'une table employee_counts propre
-- (on garde uniquement l'entrée la plus récente par entreprise)
CREATE OR REPLACE TABLE employee_counts_clean AS
SELECT * FROM (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY company_id
      ORDER BY time_recorded DESC
    ) AS rn
  FROM employee_counts
)
WHERE rn = 1;


-- Vérifier la nouvelle colonne date
SELECT job_id, listed_time, listed_date
FROM job_postings
LIMIT 5;

-- Vérifier la standardisation work_type
SELECT DISTINCT formatted_work_type
FROM job_postings;

-- Vérifier la table nettoyée
SELECT COUNT(*) FROM employee_counts;
SELECT COUNT(*) FROM employee_counts_clean;
