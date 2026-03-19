-- 1. Création de la base de données
CREATE DATABASE IF NOT EXISTS linkedin;

-- 2. Utiliser la base et créer le schéma
USE DATABASE linkedin;
CREATE SCHEMA IF NOT EXISTS raw;
USE SCHEMA raw;

-- 3. Création du stage externe pointant vers S3
CREATE OR REPLACE STAGE linkedin_stage
  URL = 's3://snowflake-lab-bucket/';

-- 4. Format pour les fichiers CSV
CREATE OR REPLACE FILE FORMAT csv_format
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
  NULL_IF = ('NULL', 'null', '')
  EMPTY_FIELD_AS_NULL = TRUE;

-- 5. Format pour les fichiers JSON
CREATE OR REPLACE FILE FORMAT json_format
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE;

-- Vérifier le stage
LIST @linkedin_stage;

-- Vérifier les formats
SHOW FILE FORMATS;
