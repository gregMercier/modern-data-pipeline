-- Staging: Nettoyage des données produits
{{ config(materialized='view') }}

SELECT 
    product_id,
    title,
    price,
    category,
    rating,
    reviews_count,
    _dlt_load_id as load_id,
    _dlt_id as dlt_id
FROM {{ source('amazon_raw', 'products') }}
