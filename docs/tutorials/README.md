# Tutoriel Complet - Étape par Étape

## Prérequis

- MacBook avec Python 3.11+
- Docker Desktop
- Compte GitHub
- Git configuré

## Étape 1 : Configuration de l'environnement

### 1.1 Créer le projet
```bash
mkdir modern-data-pipeline
cd modern-data-pipeline
git init
git branch -M main
```

### 1.2 Environnement Python
```bash
python3 -m venv venv
source venv/bin/activate
```

### 1.3 Installer les dépendances
```bash
pip install dlt[duckdb] dbt-core dbt-duckdb pandas pyarrow
```

## Étape 2 : Pipeline d'ingestion avec dlt

### 2.1 Initialiser dlt
```bash
mkdir dlt_pipelines
cd dlt_pipelines
dlt init amazon_products duckdb
```

### 2.2 Créer le pipeline
Créer `amazon_products_pipeline.py` avec :
- Source de données de test
- Configuration DuckDB
- Resources pour produits et reviews

### 2.3 Exécuter le pipeline
```bash
python amazon_products_pipeline.py
```

**Résultat :** Données chargées dans `amazon_products.duckdb`

## Étape 3 : Transformations avec dbt

### 3.1 Initialiser dbt
```bash
cd ../dbt_project
dbt init amazon_analytics
```

### 3.2 Configurer la connexion
Éditer `~/.dbt/profiles.yml` pour pointer vers DuckDB

### 3.3 Créer les modèles

**Staging :**
- `stg_products.sql` : Nettoyage produits
- `stg_reviews.sql` : Nettoyage reviews

**Marts :**
- `dim_products.sql` : Dimension produits enrichie

**Analytics :**
- `category_performance.sql` : KPIs par catégorie

### 3.4 Exécuter dbt
```bash
dbt run
dbt test
```

## Étape 4 : CI/CD avec GitHub Actions

### 4.1 Créer les workflows
```bash
mkdir -p .github/workflows
```

Créer :
- `data-pipeline.yml` : Pipeline complet
- `dbt-tests.yml` : Tests dbt
- `deploy-prod.yml` : Déploiement production

### 4.2 Push vers GitHub
```bash
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/USERNAME/modern-data-pipeline.git
git push -u origin main
```

## Étape 5 : Validation

### 5.1 Vérifier GitHub Actions
- Aller dans l'onglet "Actions"
- Vérifier que les workflows passent

### 5.2 Tester les données
```bash
duckdb amazon_products.duckdb
SELECT * FROM amazon_raw.dim_products;
```

## Étape 6 : Documentation

### 6.1 Générer la doc dbt
```bash
dbt docs generate
dbt docs serve
```

### 6.2 README professionnel
Créer un README avec :
- Badges de statut
- Architecture
- Instructions d'installation
- Exemples d'usage

## Points Clés à Retenir

1. **dlt** gère l'ingestion automatiquement
2. **dbt** structure les transformations en couches
3. **DuckDB** offre d'excellentes performances
4. **GitHub Actions** automatise tout le processus
5. **Tests** garantissent la qualité des données

## Commandes Utiles

```bash
# Réactiver l'environnement
source venv/bin/activate

# Relancer le pipeline complet
cd dlt_pipelines && python amazon_products_pipeline.py
cd ../dbt_project/amazon_analytics && dbt run

# Voir les données
duckdb ../dlt_pipelines/amazon_products.duckdb
```