# Modern Data Pipeline 🚀


End-to-end projet data engineering 
 **dlt**, **dbt**, **DuckDB**, **GitHub Actions**.

## 🏗️ Architecture

```
Amazon Product Data → dlt → DuckDB → dbt → Analytics
                           ↓
                    GitHub Actions CI/CD
```

## 🛠️ Tech Stack

- **Data Ingestion**: dlt (data load tool)
- **Data Warehouse**: DuckDB 
- **Transformations**: dbt (data build tool)
- **CI/CD**: GitHub Actions
- **Language**: Python 3.11+

## 📊 Data Models

- **Staging**: stg_products, stg_reviews
- **Marts**: dim_products 
- **Analytics**: category_performance

## 🚀 Quick Start

```bash
git clone https://github.com/gregMercier/modern-data-pipeline.git
cd modern-data-pipeline
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Run pipeline
cd dlt_pipelines && python amazon_products_pipeline.py
cd ../dbt_project/amazon_analytics && dbt run
```

## ✨ Features

- ✅ Automated testing with GitHub Actions
- ✅ Data quality tests with dbt
- ✅ Production-ready CI/CD pipeline
- ✅ Optimized for Apple Silicon

Built with ❤️ by Greg Mercier for modern data teams
