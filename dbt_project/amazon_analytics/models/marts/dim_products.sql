-- Dimension produits avec métriques calculées
{{ config(materialized='table') }}

WITH product_metrics AS (
    SELECT 
        p.product_id,
        p.title,
        p.price,
        p.category,
        p.rating as product_rating,
        p.reviews_count,
        
        -- Métriques des reviews
        COUNT(r.review_id) as actual_reviews_count,
        AVG(r.rating::FLOAT) as avg_review_rating,
        MIN(r.review_date) as first_review_date,
        MAX(r.review_date) as last_review_date
        
    FROM {{ ref('stg_products') }} p
    LEFT JOIN {{ ref('stg_reviews') }} r 
        ON p.product_id = r.product_id
    GROUP BY 1,2,3,4,5,6
)

SELECT 
    product_id,
    title,
    price,
    category,
    product_rating,
    reviews_count,
    actual_reviews_count,
    avg_review_rating,
    
    -- Écart entre rating affiché et reviews réelles
    ROUND(product_rating - avg_review_rating, 2) as rating_difference,
    
    -- Classification de prix
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price < 150 THEN 'Mid-range'
        ELSE 'Premium'
    END as price_category,
    
    first_review_date,
    last_review_date
    
FROM product_metrics
