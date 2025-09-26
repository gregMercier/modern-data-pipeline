-- Performance par catégorie de produits
{{ config(materialized='table') }}

SELECT 
    category,
    COUNT(*) as products_count,
    AVG(price) as avg_price,
    MIN(price) as min_price,
    MAX(price) as max_price,
    AVG(product_rating) as avg_product_rating,
    AVG(avg_review_rating) as avg_review_rating,
    SUM(actual_reviews_count) as total_reviews
    
FROM {{ ref('dim_products') }}
GROUP BY category
ORDER BY products_count DESC
