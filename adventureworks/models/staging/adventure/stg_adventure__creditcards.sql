with source as (

    select * from {{ source('adventure', 'creditcard') }}

),

renamed as (

    select
        creditcardid as credit_card_id,
        cardnumber as card_number,
        cardtype as card_type,
        expyear as exp_year,
        expmonth as exp_month,
        modifieddate as modified_date

    from source

)

select * from renamed
