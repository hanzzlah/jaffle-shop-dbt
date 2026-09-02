select 
    o.order_id as order_id,
    o.customer_id as customer_id,
    p.amount as amount 
from 
    {{ ref('stg_jaffle_shop__orders') }} as o
    left join {{ ref('stg_stripe__payments') }} as p
    on o.order_id = p.orderid
where p.status <> 'fail'
