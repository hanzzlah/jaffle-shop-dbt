select 
    o.id as order_id,
    o.user_id as user_id,
    p.amount as amount 
from 
    {{ ref('stg_jaffle_shop__orders') }} as o
    left join {{ ref('stg_stripe__payments') }} as p
    on o.id = p.orderid
where p.status <> 'fail'
