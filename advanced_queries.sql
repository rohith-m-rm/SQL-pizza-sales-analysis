
-- Calculate the percentage contribution of each pizza type to total revenue.

-- here we use sum for each category and group by , second sum is total revenue where we dont use group by
select pizza_types.category,round(sum(order_details.quantity*pizzas.price)/ (SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) as total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id)*100,2) as revenue
from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category order by revenue desc;


-- Analyze the cumulative revenue generated over time.

select order_date, sum(revenue) over(order by order_date) as cummu_revenue from
(select orders.order_date,sum(order_details.quantity*pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id
join orders on orders.order_id=order_details.order_id
group by orders.order_date) as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select name,category,revenue,rank_ from
(select category,name,revenue,rank() over(partition by category order by revenue desc) as rank_ from
(SELECT 
    pizza_types.category,
    pizza_types.name,
    SUM((order_details.quantity) * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category , pizza_types.name) as a )as b
where rank_<=3;
 