USE DATABASE linkedin;
USE SCHEMA raw;

-- Table job_postings
CREATE OR REPLACE TABLE job_postings (
  job_id                     VARCHAR,
  company_name               VARCHAR,
  title                      VARCHAR,
  description                TEXT,
  max_salary                 FLOAT,
  med_salary                 FLOAT,
  min_salary                 FLOAT,
  pay_period                 VARCHAR,
  formatted_work_type        VARCHAR,
  location                   VARCHAR,
  applies                    INT,
  original_listed_time       BIGINT,
  remote_allowed             BOOLEAN,
  views                      INT,
  job_posting_url            VARCHAR,
  application_url            VARCHAR,
  application_type           VARCHAR,
  expiry                     BIGINT,
  closed_time                BIGINT,
  formatted_experience_level VARCHAR,
  skills_desc                TEXT,
  listed_time                BIGINT,
  posting_domain             VARCHAR,
  sponsored                  BOOLEAN,
  work_type                  VARCHAR,
  currency                   VARCHAR,
  compensation_type          VARCHAR
);

-- Table benefits
CREATE OR REPLACE TABLE benefits (
  job_id   VARCHAR,
  inferred BOOLEAN,
  type     VARCHAR
);

-- Table companies
CREATE OR REPLACE TABLE companies (
  company_id   VARCHAR,
  name         VARCHAR,
  description  TEXT,
  company_size INT,
  state        VARCHAR,
  country      VARCHAR,
  city         VARCHAR,
  zip_code     VARCHAR,
  address      VARCHAR,
  url          VARCHAR
);

-- Table employee_counts
CREATE OR REPLACE TABLE employee_counts (
  company_id     VARCHAR,
  employee_count INT,
  follower_count INT,
  time_recorded  BIGINT
);

-- Table job_skills
CREATE OR REPLACE TABLE job_skills (
  job_id    VARCHAR,
  skill_abr VARCHAR
);

-- Table job_industries
CREATE OR REPLACE TABLE job_industries (
  job_id      VARCHAR,
  industry_id VARCHAR
);

-- Table company_specialities
CREATE OR REPLACE TABLE company_specialities (
  company_id VARCHAR,
  speciality VARCHAR
);

-- Table company_industries
CREATE OR REPLACE TABLE company_industries (
  company_id VARCHAR,
  industry   VARCHAR
);

SHOW TABLES;