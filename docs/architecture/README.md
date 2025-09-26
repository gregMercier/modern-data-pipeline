# Architecture Technique

## Vue d'ensemble

Notre pipeline data engineering suit une architecture moderne en couches, optimisée pour la performance et la maintenabilité.

```
┌─────────────────┐    ┌──────────────┐    ┌─────────────┐    ┌─────────────────┐
│   Amazon API    │───▶│     dlt      │───▶│   DuckDB    │───▶│      dbt        │
│ (Product Data)  │    │ (Ingestion)  │    │ (Storage)   │    │(Transformation) │
└─────────────────┘    └──────────────┘    └─────────────┘    └─────────────────┘
                                                │                       │
                                                ▼                       ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           GitHub Actions CI/CD                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐   │
│  │   Tests     │  │   Build     │  │   Deploy    │  │    Documentation    │   │
│  │   dbt/dlt   │  │   Docker    │  │   Pipeline  │  │     Generation      │   │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Composants Techniques

### 1. Couche d'Ingestion - dlt

**Responsabilités :**
- Extraction des données depuis les sources
- Normalisation automatique des schémas
- Gestion des erreurs et reprises
- Chargement incrémental

**Fichiers clés :**
```
dlt_pipelines/
├── amazon_products_pipeline.py    # Pipeline principal
├── .dlt/
│   ├── config.toml                # Configuration
│   └── secrets.toml               # Credentials (gitignored)
└── schemas/                       # Schémas auto-générés
```

**Configuration DuckDB :**
```toml
[destination.duckdb]
database_path = "~/data-warehouse/duckdb/amazon_data.duckdb"
```

### 2. Couche de Stockage - DuckDB

**Avantages techniques :**
- **Performance** : Optimisé pour l'analytique OLAP
- **Simplicité** : Fichier unique, pas de serveur
- **Compatibilité** : SQL standard + extensions analytiques
- **Compression** : Réduction ~70% de l'espace disque

**Structure des données :**
```sql
-- Schéma créé automatiquement par dlt
amazon_raw/
├── products           -- Table des produits
├── reviews           -- Table des avis clients
├── _dlt_loads        -- Métadonnées dlt
└── _dlt_version      -- Versioning des schémas
```

### 3. Couche de Transformation - dbt

**Architecture en couches :**

#### Staging Layer
```sql
-- models/staging/stg_products.sql
-- Nettoyage et normalisation des types
SELECT 
    product_id,
    TRIM(title) as title,
    CAST(price AS DECIMAL(10,2)) as price,
    UPPER(category) as category
FROM {{ source('amazon_raw', 'products') }}
```

#### Marts Layer
```sql
-- models/marts/dim_products.sql  
-- Logique métier et enrichissement
WITH product_metrics AS (
    SELECT 
        p.*,
        AVG(r.rating) as avg_review_rating,
        COUNT(r.review_id) as review_count
    FROM {{ ref('stg_products') }} p
    LEFT JOIN {{ ref('stg_reviews') }} r ON p.product_id = r.product_id
    GROUP BY 1,2,3,4
)
```

#### Analytics Layer
```sql
-- models/analytics/category_performance.sql
-- Métriques business et KPIs
SELECT 
    category,
    COUNT(*) as product_count,
    AVG(price) as avg_price,
    AVG(avg_review_rating) as category_rating
FROM {{ ref('dim_products') }}
GROUP BY category
```

### 4. Couche CI/CD - GitHub Actions

**Workflows automatisés :**

#### Pipeline Principal (`data-pipeline.yml`)
```yaml
trigger: [push, pull_request, schedule]
jobs:
  - lint_and_test
  - run_dlt_pipeline  
  - run_dbt_models
  - run_dbt_tests
  - deploy_documentation
```

#### Tests dbt (`dbt-tests.yml`)
```yaml
trigger: [pull_request sur dbt_project/]
jobs:
  - dbt_parse
  - dbt_compile
  - dbt_test --select source:*
```

## Flux de Données

### 1. Ingestion (dlt)
```python
# Chargement des données
@dlt.source
def amazon_products_source():
    @dlt.resource(write_disposition="replace")
    def products():
        # Extraction depuis API/fichiers
        yield product_data
    
    return products
```

### 2. Stockage (DuckDB)
```sql
-- Données stockées automatiquement par dlt
CREATE TABLE amazon_raw.products (
    product_id VARCHAR,
    title VARCHAR,
    price DOUBLE,
    _dlt_load_id VARCHAR,  -- Traçabilité
    _dlt_id VARCHAR        -- ID unique
);
```

### 3. Transformation (dbt)
```sql
-- Modèles dbt avec tests intégrés
{{ config(materialized='table') }}

SELECT * FROM {{ ref('stg_products') }}
WHERE price > 0  -- Règle métier
```

### 4. Tests et Qualité
```yaml
# schema.yml
models:
  - name: dim_products
    tests:
      - dbt_utils.unique_combination_of_columns:
          combination_of_columns: [product_id, load_date]
    columns:
      - name: product_id
        tests: [unique, not_null]
      - name: price
        tests:
          - dbt_utils.accepted_range:
              min_value: 0
              max_value: 10000
```

## Patterns et Bonnes Pratiques

### Naming Conventions
```
Staging:   stg_{source}_{table}
Marts:     dim_{entity} / fct_{process}
Analytics: {domain}_{metric}
Tests:     test_{model}_{test_type}
```

### Gestion des Environnements
```yaml
# profiles.yml
amazon_analytics:
  outputs:
    dev:    # Développement local
      type: duckdb
      path: ./dev_data.duckdb
    prod:   # Production
      type: duckdb  
      path: ./prod_data.duckdb
```

### Monitoring et Observabilité
- **dlt** : Logs automatiques + métadonnées dans `_dlt_loads`
- **dbt** : Logs d'exécution + tests de qualité
- **GitHub Actions** : Historique des déploiements
- **DuckDB** : Métriques de performance intégrées

## Scalabilité et Evolution

### Migration vers le Cloud
```python
# dlt supporte nativement BigQuery, Snowflake...
pipeline = dlt.pipeline(
    destination="bigquery",  # Au lieu de duckdb
    dataset_name="amazon_warehouse"
)
```

### Ajout d'Orchestration
```python
# Intégration Airflow future
from airflow import DAG
from airflow.operators.bash import BashOperator

dag = DAG('amazon_pipeline')
dlt_task = BashOperator(task_id='dlt', bash_command='python pipeline.py')
dbt_task = BashOperator(task_id='dbt', bash_command='dbt run')
dlt_task >> dbt_task
```

### Monitoring Avancé
- **Great Expectations** pour la qualité des données
- **Elementary** pour l'observabilité dbt
- **Prometheus + Grafana** pour les métriques système

## Sécurité

### Credentials Management
```bash
# Variables d'environnement pour la production
export AMAZON_API_KEY="..."
export DBT_PROFILES_DIR="/secure/profiles/"
```

### GitHub Secrets
```yaml
# .github/workflows/deploy.yml
env:
  AMAZON_API_KEY: ${{ secrets.AMAZON_API_KEY }}
  DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
```

Cette architecture garantit évolutivité, maintenabilité et observabilité du pipeline.