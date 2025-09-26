# Concepts Fondamentaux

## Qu'est-ce qu'un Pipeline Data Engineering ?

Un pipeline data engineering est un processus automatisé qui :
1. **Extrait** les données depuis des sources (APIs, bases de données)
2. **Transforme** les données (nettoyage, agrégations)
3. **Charge** les données dans un entrepôt pour l'analyse

## Les Outils Utilisés

### 🔧 dlt (Data Load Tool)
- **Rôle** : Ingestion des données
- **Avantages** : 
  - Gestion automatique des schemas
  - Chargement incrémental
  - Gestion des erreurs
- **Dans notre projet** : Charge les données Amazon vers DuckDB

### 🛠️ dbt (Data Build Tool)
- **Rôle** : Transformation des données
- **Avantages** :
  - SQL moderne avec Jinja2
  - Tests de qualité intégrés
  - Documentation automatique
  - Gestion des dépendances
- **Dans notre projet** : Crée les modèles analytiques

### 🗄️ DuckDB
- **Rôle** : Entrepôt de données analytique
- **Avantages** :
  - Performance excellente
  - Pas de serveur à gérer
  - Compatible avec pandas/SQL
  - Optimisé pour l'analytique
- **Dans notre projet** : Stocke et traite les données

### ⚙️ GitHub Actions
- **Rôle** : CI/CD et automatisation
- **Avantages** :
  - Gratuit pour projets publics
  - Intégration GitHub native
  - Workflows flexibles
- **Dans notre projet** : Tests automatiques et déploiement

## Architecture en Couches

### 1. Raw Layer (Données brutes)
- Données telles qu'extraites des sources
- Pas de transformation
- Table : `amazon_raw.products`, `amazon_raw.reviews`

### 2. Staging Layer (Nettoyage)
- Nettoyage et standardisation
- Types de données cohérents
- Modèles : `stg_products`, `stg_reviews`

### 3. Marts Layer (Métier)
- Logique métier appliquée
- Données prêtes pour l'analyse
- Modèles : `dim_products`

### 4. Analytics Layer (Agrégations)
- KPIs et métriques
- Données pour dashboards
- Modèles : `category_performance`

## Bonnes Pratiques

### Nomenclature
- `stg_` : Modèles staging
- `dim_` : Tables de dimension
- `fct_` : Tables de faits
- `rpt_` : Rapports

### Tests de Qualité
- `unique` : Valeurs uniques
- `not_null` : Pas de valeurs nulles
- `accepted_values` : Valeurs dans une liste
- `relationships` : Clés étrangères valides

### Gestion des Environnements
- `dev` : Développement local
- `staging` : Tests avant production
- `prod` : Production
