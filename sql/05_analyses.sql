USE DATABASE linkedin;
USE SCHEMA raw;


--Analyse 1 — Top 10 des titres les plus publiés par industrie :

SELECT
  ji.industry_id AS industry,
  jp.title,
  COUNT(*) AS nb_offres,
  ROW_NUMBER() OVER (PARTITION BY ji.industry_id ORDER BY COUNT(*) DESC) AS rang
FROM job_postings jp
JOIN job_industries ji ON jp.job_id = ji.job_id
GROUP BY ji.industry_id, jp.title
QUALIFY rang <= 10
ORDER BY ji.industry_id, rang;

--Analyse 2 — Top 10 des postes les mieux rémunérés par industrie

SELECT
  ji.industry_id AS industry,
  jp.title,
  ROUND(AVG(jp.max_salary), 0) AS avg_max_salary,
  ROW_NUMBER() OVER (PARTITION BY ji.industry_id ORDER BY AVG(jp.max_salary) DESC) AS rang
FROM job_postings jp
JOIN job_industries ji ON jp.job_id = ji.job_id
WHERE jp.pay_period = 'YEARLY'
AND jp.max_salary IS NOT NULL
GROUP BY ji.industry_id, jp.title
QUALIFY rang <= 10
ORDER BY ji.industry_id, rang;


--Analyse 3 — Répartition des offres par taille d'entreprise 

SELECT
  c.company_size,
  CASE c.company_size
    WHEN 0 THEN '0 - Très petite'
    WHEN 1 THEN '1 - Petite'
    WHEN 2 THEN '2 - Petite-Moyenne'
    WHEN 3 THEN '3 - Moyenne'
    WHEN 4 THEN '4 - Grande-Moyenne'
    WHEN 5 THEN '5 - Grande'
    WHEN 6 THEN '6 - Très grande'
    WHEN 7 THEN '7 - Géante'
  END AS taille_label,
  COUNT(jp.job_id) AS nb_offres
FROM job_postings jp
JOIN companies c 
  ON SPLIT_PART(jp.company_name, '.', 1) = c.company_id
GROUP BY c.company_size, taille_label
ORDER BY c.company_size;

-- Analyse 4 — Répartition des offres par secteur d'activité 

SELECT
  ji.industry_id AS industry,
  COUNT(DISTINCT jp.job_id) AS nb_offres
FROM job_postings jp
JOIN job_industries ji ON jp.job_id = ji.job_id
GROUP BY ji.industry_id
ORDER BY nb_offres DESC
LIMIT 20;

--Analyse 5 — Répartition des offres par type d'emploi
SELECT
  formatted_work_type AS type_emploi,
  COUNT(*) AS nb_offres,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pourcentage
FROM job_postings
WHERE formatted_work_type IS NOT NULL
GROUP BY formatted_work_type
ORDER BY nb_offres DESC;

