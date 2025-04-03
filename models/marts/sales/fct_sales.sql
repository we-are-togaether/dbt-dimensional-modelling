with stg_salesorderheader as (

    select *
    from {{ ref('stg_adventure__salesorderheaders') }}

),

stg_salesorderdetail as (

    select *
    from {{ ref('stg_adventure__salesorderdetails') }}

)

select

    {{ dbt_utils.generate_surrogate_key(['sod.sales_order_id', 'sod.sales_order_detail_id']) }} as sales_key,
    {{ dbt_utils.generate_surrogate_key(['sod.product_id']) }} as product_key,
    {{ dbt_utils.generate_surrogate_key(['soh.customer_id']) }} as customer_key,
    {{ dbt_utils.generate_surrogate_key(['soh.ship_to_address_id']) }} as ship_to_address_key,
    {{ dbt_utils.generate_surrogate_key(['soh.bill_to_address_id']) }} as bill_to_address_key,
    sod.sales_order_id,
    sod.sales_order_detail_id,
    soh.customer_id,
    soh.ship_to_address_id,
    soh.bill_to_address_id,
    sod.product_id,
    soh.order_date,
    soh.order_status,
    sod.unit_price,
    sod.order_qty,
    sod.revenue,
    soh.due_date,
    soh.ship_date,
    soh.online_order_flag

from stg_salesorderdetail as sod
inner join stg_salesorderheader as soh
    on sod.sales_order_id = soh.sales_order_id
