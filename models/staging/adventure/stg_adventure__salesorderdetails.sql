with source as (

    select * from {{ source('adventure', 'salesorderdetail') }}

),

renamed as (

    select
        salesorderid as sales_order_id,
        orderqty as order_qty,
        salesorderdetailid as sales_order_detail_id,
        unitprice as unit_price,
        specialofferid as special_offer_id,
        productid as product_id,
        unitpricediscount as unit_price_discount,
        rowguid,
        modifieddate as modified_date,
        orderqty * unitprice as revenue

    from source

)

select * from renamed
