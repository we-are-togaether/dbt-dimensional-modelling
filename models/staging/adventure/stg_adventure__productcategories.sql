with source as (

    select * from {{ source('adventure', 'productcategory') }}

),

renamed as (

    select
        productcategoryid as product_category_id,
        name as product_category_name,
        modifieddate as modified_date

    from source

)

select * from renamed
