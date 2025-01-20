with stg_product as (

    select *
    from {{ ref('stg_adventure__products') }}

),

stg_product_subcategory as (

    select *
    from {{ ref('stg_adventure__productsubcategories') }}

),

stg_product_category as (

    select *
    from {{ ref('stg_adventure__productcategories') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['P.product_id']) }} as product_key,
        p.product_id,
        p.product_name,
        p.safety_stock_level,
        p.finished_goods_flag,
        p.class,
        p.make_flag,
        p.product_number,
        p.reorder_point,
        p.standard_cost,
        p.list_price,
        p.product_line,
        p.color,
        p.sell_start_date,
        psc.product_subcategory_name,
        pc.product_category_name
    from stg_product p
    left join stg_product_subcategory psc
        on P.product_subcategory_id = psc.product_subcategory_id
    left join stg_product_category pc
        on psc.product_category_id = pc.product_category_id

)

select * from final
