-- Staging: Nettoyage des données reviews
{{ config(materialized='view') }}

SELECT 
    review_id,
    product_id,
    rating,
    review_text,
    reviewer_name,
    CAST(review_date AS DATE) as review_date,
    _dlt_load_id as load_id,
    _dlt_id as dlt_id
FROM {{ source('amazon_raw', 'reviews') }}
