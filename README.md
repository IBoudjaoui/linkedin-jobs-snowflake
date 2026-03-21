# 🧊 Analyse des Offres d'Emploi LinkedIn avec Snowflake

Analyse d'un dataset LinkedIn de plusieurs milliers d'offres d'emploi,
réalisée avec Snowflake et Streamlit.

**Réalisé par** : IBoudjaoui & [Prénom Nom de ton binôme]  
**Formation** : MBA Big Data & IA — MBA ESG

---

## 📁 Structure du projet
```
linkedin-jobs-snowflake/
├── sql/
│   ├── 01_setup.sql           # Création DB, stage, formats
│   ├── 02_create_tables.sql   # Création des 8 tables
│   ├── 03_load_data.sql       # Chargement CSV et JSON depuis S3
│   ├── 04_transformations.sql # Nettoyage et transformations
│   └── 05_analyses.sql        # 5 requêtes d'analyse
├── streamlit/
│   └── app.py                 # Application Streamlit
├── screenshots/               # Captures des visualisations
└── docs/
    └── problemes_solutions.md # Problèmes et solutions
```

---

## 🛠️ Prérequis

- Compte Snowflake (gratuit 120 jours)
- Accès au bucket S3 : `s3://snowflake-lab-bucket/`

---

## 🔧 Étapes d'exécution

### 1. Setup (01_setup.sql)
Création de la base `linkedin`, du schéma `raw`, du stage S3
et des formats de fichiers CSV et JSON.

### 2. Création des tables (02_create_tables.sql)
Création des 8 tables : `job_postings`, `benefits`, `companies`,
`employee_counts`, `job_skills`, `job_industries`,
`company_specialities`, `company_industries`.

### 3. Chargement des données (03_load_data.sql)
Chargement des fichiers CSV avec `COPY INTO` directement.
Chargement des fichiers JSON via des tables temporaires VARIANT
puis insertion avec parsing des champs.

### 4. Transformations (04_transformations.sql)
- Conversion des timestamps Unix en dates lisibles
- Standardisation du champ `formatted_work_type`
- Dédoublonnage de `employee_counts` → `employee_counts_clean`
  (15 000 lignes → 6 000 lignes)

### 5. Analyses (05_analyses.sql)

#### Analyse 1 — Top 10 titres par industrie
![Top 10 Titres](screenshots/01_top10_titres.png)

#### Analyse 2 — Top 10 salaires par industrie
![Top 10 Salaires](screenshots/02_top10_salaires.png)

#### Analyse 3 — Répartition par taille d'entreprise
![Taille Entreprise](screenshots/03_taille_entreprise.png)

#### Analyse 4 — Répartition par secteur d'activité
![Secteurs](screenshots/04_secteurs.png)

#### Analyse 5 — Répartition par type d'emploi
![Type Emploi](screenshots/05_type_emploi.png)

---

## 📊 Streamlit

L'application Streamlit est déployée directement dans Snowflake.
Elle contient 5 onglets correspondant aux 5 analyses,
chacun avec une visualisation interactive.

---

## ⚠️ Problèmes rencontrés

Voir le fichier [docs/problemes_solutions.md](docs/problemes_solutions.md)

---

## 👥 Répartition des tâches

| Tâche | Responsable |
|-------|-------------|
| Setup Snowflake + chargement données | IBoudjaoui |
| Transformations + analyses SQL | IBoudjaoui |
| Application Streamlit | IBoudjaoui |
| Documentation README | IBoudjaoui |