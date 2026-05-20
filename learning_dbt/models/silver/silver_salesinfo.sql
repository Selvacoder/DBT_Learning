WITH sales AS
(
    SELECT
        sales_id,
        product_sk,
        customer_sk,
        {{ multiply('unit_price', 'quantity') }} AS calculated_gross_amount,
        gross_amount,
        payment_method
    FROM
        {{ ref('bronze_sales') }}
),

products AS
(
    SELECT
        product_sk,
        product_name,
        category
    FROM
        {{ ref('bronze_product') }}
),

customers AS
(
    SELECT
        customer_sk,
        gender
    FROM
        {{ ref('bronze_customer') }}
),

joined_data AS
(
    SELECT 
        sales.sales_id,
        sales.gross_amount,
        sales.payment_method,
        products.category,
        customers.gender
    FROM 
        sales
    JOIN
        products ON sales.product_sk = products.product_sk
    JOIN
        customers ON sales.customer_sk = customers.customer_sk
)

SELECT
    category,
    gender,
    sum(gross_amount) AS total_gross_amount
FROM
    joined_data
GROUP BY
    category,
    gender
ORDER BY
    total_gross_amount DESC