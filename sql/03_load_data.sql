USE DATABASE linkedin;
USE SCHEMA raw;

-- 1. Chargement des CSV directs
COPY INTO job_postings
  FROM @linkedin_stage/job_postings.csv
  FILE_FORMAT = (FORMAT_NAME = 'csv_format')
  ON_ERROR = 'CONTINUE';

COPY INTO benefits
  FROM @linkedin_stage/benefits.csv
  FILE_FORMAT = (FORMAT_NAME = 'csv_format')
  ON_ERROR = 'CONTINUE';

COPY INTO employee_counts
  FROM @linkedin_stage/employee_counts.csv
  FILE_FORMAT = (FORMAT_NAME = 'csv_format')
  ON_ERROR = 'CONTINUE';

COPY INTO job_skills
  FROM @linkedin_stage/job_skills.csv
  FILE_FORMAT = (FORMAT_NAME = 'csv_format')
  ON_ERROR = 'CONTINUE';

-- vérification des resultats

SELECT COUNT(*) FROM job_postings;
SELECT COUNT(*) FROM benefits;
SELECT COUNT(*) FROM employee_counts;
SELECT COUNT(*) FROM job_skills;

-- 1. companies.json
CREATE OR REPLACE TEMP TABLE companies_raw (v VARIANT);
COPY INTO companies_raw
  FROM @linkedin_stage/companies.json
  FILE_FORMAT = (FORMAT_NAME = 'json_format');

INSERT INTO companies
SELECT
  v:company_id::VARCHAR,
  v:name::VARCHAR,
  v:description::TEXT,
  v:company_size::INT,
  v:state::VARCHAR,
  v:country::VARCHAR,
  v:city::VARCHAR,
  v:zip_code::VARCHAR,
  v:address::VARCHAR,
  v:url::VARCHAR
FROM companies_raw;

-- 2. company_industries.json
CREATE OR REPLACE TEMP TABLE ci_raw (v VARIANT);
COPY INTO ci_raw
  FROM @linkedin_stage/company_industries.json
  FILE_FORMAT = (FORMAT_NAME = 'json_format');

INSERT INTO company_industries
SELECT
  v:company_id::VARCHAR,
  v:industry::VARCHAR
FROM ci_raw;

-- 3. company_specialities.json
CREATE OR REPLACE TEMP TABLE cs_raw (v VARIANT);
COPY INTO cs_raw
  FROM @linkedin_stage/company_specialities.json
  FILE_FORMAT = (FORMAT_NAME = 'json_format');

INSERT INTO company_specialities
SELECT
  v:company_id::VARCHAR,
  v:speciality::VARCHAR
FROM cs_raw;

-- 4. job_industries.json
CREATE OR REPLACE TEMP TABLE ji_raw (v VARIANT);
COPY INTO ji_raw
  FROM @linkedin_stage/job_industries.json
  FILE_FORMAT = (FORMAT_NAME = 'json_format');

INSERT INTO job_industries
SELECT
  v:job_id::VARCHAR,
  v:industry_id::VARCHAR
FROM ji_raw;

-- vérification des resultats

SELECT COUNT(*) FROM companies;
SELECT COUNT(*) FROM company_industries;
SELECT COUNT(*) FROM company_specialities;
SELECT COUNT(*) FROM job_industries;