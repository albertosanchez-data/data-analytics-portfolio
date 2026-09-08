-- Which customers are the most valuable to the business,
-- and which represent a growth opportunity?
with customer_metrics as (
	select 
		c.customerid,
		c.firstname,
		c.lastname,
		count(o.orderid) as total_orders,
		sum(o.sales) as total_sales,
		round(
			sum(o.sales) / count(o.orderid), 2
		) as average_order_value
	from sales.customers c 
	inner join sales.orders o 
		on c.customerid = o.customerid 
	group by 
		c.customerid,
		c.firstname,
		c.lastname
)
select 
	customerid,
	firstname,
	lastname,
	total_orders,
	total_sales,
	average_order_value,
		case 
			when total_sales >= 100
				and total_orders >= 3
				then 'High-Value Customer'
			when total_orders >= 3
				and average_order_value < 25
				then 'Growth Opportunity'
			else 'Lower Priority'
		end as customer_segment
from customer_metrics
order by 
	total_sales desc;