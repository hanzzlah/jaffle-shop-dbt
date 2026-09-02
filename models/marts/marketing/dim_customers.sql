with customers as (
    select * from {{ ref('stg_jaffle_shop__customers') }}
),

orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

customer_orders as (

    select
        user_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(id) as number_of_orders

    from orders

    group by 1

),

customer_payments as (
    select 
        user_id, 
        sum(amount) as lifetime_value
    from {{ ref('fct_orders') }}
    group by 1
),

final as (

    select
        customers.user_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        coalesce(customer_payments.lifetime_value, 0) as lifetime_value

    from customers

    left join customer_orders using (user_id)
    left join customer_payments using (user_id)

)

select * from final