# FAQ et Dépannage

## Questions Fréquentes

### Q: Pourquoi DuckDB plutôt que PostgreSQL ?
**R:** DuckDB est optimisé pour l'analytique, ne nécessite pas de serveur, et offre d'excellentes performances sur Mac M1. Parfait pour le développement et les projets moyens.

### Q: Peut-on scaler ce pipeline ?
**R:** Oui ! Pour de gros volumes :
- Remplacer DuckDB par BigQuery/Snowflake
- Ajouter Airflow pour l'orchestration
- Utiliser Kubernetes pour le déploiement

### Q: Comment ajouter de nouvelles sources de données ?
**R:** 
1. Créer un nouveau pipeline dlt
2. Ajouter les modèles staging correspondants
3. Étendre les modèles marts si nécessaire

### Q: Quelle est la différence entre dlt et des ETL traditionnels ?
**R:** dlt est plus moderne :
- Gestion automatique des schemas
- Chargement incrémental natif
- Configuration déclarative
- Moins de code à maintenir

### Q: Pourquoi utiliser dbt plutôt que du SQL classique ?
**R:** dbt apporte :
- Gestion des dépendances entre modèles
- Tests de qualité intégrés
- Documentation automatique
- Réutilisabilité avec les macros
- Gestion des environnements (dev/prod)

### Q: Ce pipeline peut-il gérer des données temps réel ?
**R:** Partiellement. Pour du vrai temps réel :
- Utiliser Apache Kafka pour le streaming
- Remplacer dlt par Apache Spark Streaming
- Utiliser des bases orientées streaming (ClickHouse, Apache Druid)

## Problèmes Courants

### Erreur : "dlt command not found"
**Solution :** Activer l'environnement virtuel
```bash
source venv/bin/activate
```

### Erreur : "Table does not exist" dans dbt
**Solutions :**
1. Vérifier que dlt a bien chargé les données
```bash
cd dlt_pipelines
python amazon_products_pipeline.py
```
2. Vérifier le chemin dans profiles.yml
3. Vérifier que le schéma source existe

### GitHub Actions échouent
**Solutions :**
1. Vérifier les chemins dans les workflows
2. S'assurer que requirements.txt est à jour
3. Vérifier les permissions du repository
4. Regarder les logs dans l'onglet Actions

### Performance lente sur de gros datasets
**Solutions :**
1. Utiliser le chargement incrémental dlt
2. Optimiser les requêtes dbt avec des index
3. Partitionner les tables par date
4. Utiliser la matérialisation incremental dans dbt

### Erreur de mémoire avec DuckDB
**Solutions :**
1. Traiter les données par chunks
2. Utiliser des vues plutôt que des tables
3. Augmenter la mémoire disponible
4. Passer à PostgreSQL/BigQuery pour de gros volumes

### Problème de versions Python
**Solutions :**
1. Utiliser pyenv pour gérer les versions
2. Vérifier la compatibilité des packages
3. Recréer l'environnement virtuel si nécessaire

## Conseils de Développement

### Debugging dlt
```bash
# Mode verbose pour plus de logs
python amazon_products_pipeline.py --log-level DEBUG

# Vérifier la configuration
dlt pipeline info amazon_products
```

### Debugging dbt
```bash
# Compiler sans exécuter
dbt compile

# Exécuter un seul modèle
dbt run --select stg_products

# Tests sur un modèle spécifique
dbt test --select stg_products
```

### Monitoring
- Surveiller la taille des fichiers DuckDB
- Vérifier les logs des GitHub Actions
- Monitorer les temps d'exécution

## Améliorations Possibles

### Court terme (1-2 semaines)
- [ ] Ajouter plus de tests dbt
- [ ] Créer un dashboard Streamlit
- [ ] Connecter une vraie API Amazon
- [ ] Ajouter des alertes email sur les échecs

### Moyen terme (1-2 mois)
- [ ] Intégrer Airflow pour l'orchestration
- [ ] Ajouter Great Expectations pour la qualité
- [ ] Déployer sur le cloud (AWS/GCP)
- [ ] Implémenter le chargement incrémental

### Long terme (3-6 mois)
- [ ] Architecture microservices
- [ ] Data mesh avec plusieurs domaines
- [ ] ML ops pour du machine learning
- [ ] Streaming en temps réel avec Kafka

## Ressources Utiles

### Documentation officielle
- [dlt Documentation](https://dlthub.com/docs)
- [dbt Documentation](https://docs.getdbt.com)
- [DuckDB Documentation](https://duckdb.org/docs)

### Communautés
- [dbt Slack Community](https://community.getdbt.com)
- [Data Engineering Subreddit](https://reddit.com/r/dataengineering)

### Formations
- [dbt Fundamentals](https://courses.getdbt.com/courses/fundamentals)
- [Data Engineering Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp)