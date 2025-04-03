with source as (

    select * from {{ source('adventure', 'date') }}

),

renamed as (

    select
        date_day,
        prior_date_day,
        next_date_day,
        prior_year_date_day,
        prior_year_over_year_date_day,
        day_of_week,
        day_of_week_name,
        day_of_month,
        day_of_year,
        cast(strftime(date_day, '%Y%m%d') as int) as date_key,
        isodow(date_day) as iso_day_of_week,
        last_day(date_day) as last_day_of_month,
        monthname(date_day) as month_name,
        year(date_day) as year_numeric,
        isoyear(date_day) as iso_year,
        quarter(date_day) as quarter_of_year,
        weekofyear(date_day) as iso_week_of_year,
        concat(year(date_day), '-', strftime(date_day, '%m')) as year_and_month,
        concat(
            year(date_day), '-', strftime(date_day, '%b')
        ) as year_month_name,
        concat(year(date_day), '-', quarter(date_day)) as year_quarter,
        concat(isoyear(date_day), '-', strftime(date_day, '%V')) as year_week
    from source

)

select * from renamed
