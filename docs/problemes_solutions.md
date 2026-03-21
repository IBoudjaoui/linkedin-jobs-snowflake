# Problèmes rencontrés et solutions apportées

## 1. Erreur Git push — Permission denied (403)
**Problème** : `git push` retournait une erreur 403.  
**Cause** : Git n'était pas authentifié avec le compte GitHub.  
**Solution** : Génération d'un Personal Access Token sur GitHub et configuration de l'URL remote avec le token.

## 2. Dossiers vides non trackés par Git
**Problème** : Les dossiers créés n'apparaissaient pas sur GitHub.  
**Cause** : Git ne suit pas les dossiers vides.  
**Solution** : Création d'un fichier `.gitkeep` dans chaque dossier vide.

## 3. Analyse 1 — Jointure job_industries / company_industries vide
**Problème** : La requête Top 10 titres par industrie ne retournait aucun résultat.  
**Cause** : `job_industries.industry_id` contient des IDs numériques alors que `company_industries.industry` contient des noms texte — les deux colonnes ne sont pas compatibles.  
**Solution** : Utiliser uniquement `job_industries` sans jointure avec `company_industries`.

## 4. Analyse 3 — Jointure job_postings / companies vide
**Problème** : La répartition par taille d'entreprise ne retournait aucun résultat.  
**Cause** : `job_postings.company_name` contient des IDs numériques avec décimale (ex: 96654609.0) alors que `companies.company_id` contient des entiers (ex: 1526).  
**Solution** : Utilisation de `SPLIT_PART(jp.company_name, '.', 1)` pour supprimer la partie décimale avant la jointure.