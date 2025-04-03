with source as (

    select * from {{ source('adventure', 'product') }}

),

renamed as (

    select
        productid as product_id,
        name as product_name,
        safetystocklevel as safety_stock_level,
        finishedgoodsflag as finished_goods_flag,
        class,
        makeflag as make_flag,
        productnumber as product_number,
        reorderpoint as reorder_point,
        modifieddate as modified_date,
        rowguid as row_guid,
        productmodelid as product_model_id,
        weightunitmeasurecode as weight_unit_measure_code,
        standardcost as standard_cost,
        productsubcategoryid as product_subcategory_id,
        listprice as list_price,
        daystomanufacture as days_to_manufacture,
        productline as product_line,
        color,
        sellstartdate as sell_start_date,
        weight

    from source

)

select * from renamed
