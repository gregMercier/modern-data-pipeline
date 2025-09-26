import dlt
from typing import Iterator, Dict, Any

@dlt.source
def amazon_products_source() -> Iterator[Dict[str, Any]]:
    """
    Source pour extraire les données Amazon Product Data
    """
    
    @dlt.resource(write_disposition="replace")
    def products():
        """Extraction des produits Amazon"""
        test_products = [
            {
                "product_id": "B08N5WRWNW", 
                "title": "Echo Dot (4th Gen)", 
                "price": 49.99,
                "category": "Electronics",
                "rating": 4.5,
                "reviews_count": 12847
            },
            {
                "product_id": "B07XJ8C8F5", 
                "title": "Fire TV Stick 4K", 
                "price": 39.99,
                "category": "Electronics", 
                "rating": 4.3,
                "reviews_count": 8934
            },
            {
                "product_id": "B094DBT4V4", 
                "title": "AirPods (3rd Gen)", 
                "price": 179.00,
                "category": "Electronics", 
                "rating": 4.4,
                "reviews_count": 5621
            }
        ]
        yield test_products
    
    @dlt.resource(write_disposition="replace")
    def reviews():
        """Extraction des reviews Amazon"""
        test_reviews = [
            {
                "review_id": "R1234567890",
                "product_id": "B08N5WRWNW",
                "rating": 5,
                "review_text": "Great product, works perfectly!",
                "reviewer_name": "John D.",
                "review_date": "2024-01-15"
            },
            {
                "review_id": "R0987654321", 
                "product_id": "B07XJ8C8F5",
                "rating": 4,
                "review_text": "Good value for money",
                "reviewer_name": "Sarah M.",
                "review_date": "2024-01-20"
            },
            {
                "review_id": "R1122334455", 
                "product_id": "B094DBT4V4",
                "rating": 5,
                "review_text": "Amazing sound quality",
                "reviewer_name": "Mike T.",
                "review_date": "2024-01-25"
            }
        ]
        yield test_reviews
    
    return products, reviews

if __name__ == "__main__":
    # Configuration du pipeline
    pipeline = dlt.pipeline(
        pipeline_name="amazon_products",
        destination="duckdb",
        dataset_name="amazon_raw"
    )
    
    # Chargement des données
    load_info = pipeline.run(amazon_products_source())
    print(load_info)
    print("✅ Données chargées avec succès dans DuckDB!")
