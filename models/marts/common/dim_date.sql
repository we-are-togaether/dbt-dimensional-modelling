with stg_date as (

    select *
    from {{ ref('stg_adventure__date') }}

)

select * from stg_date
