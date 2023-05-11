/*
###################		Swiggy food delivery - Case Study		###############
*/

/*
Question:
Swiggy Case Study-

1. Find customers who have never ordered
2. Average Price/dish
3. Find the top restaurant in terms of the number of orders for a given month
4. restaurants with monthly sales greater than x for 
5. Show all orders with order details for a particular customer in a particular date range
6. Find restaurants with max repeated customers 
7. Month over month revenue growth of swiggy
8. Customer - favorite food

Homework
Find the most loyal customers for all restaurant
Month over month revenue growth of a restaurant
Most Paired Products
*/

-- Qus-1 : Find the customer who have never ordered.

select 
	users.user_id,
    users.name
from swiggy_fooddelivery.users
	where user_id not in 
		(select 
			user_id
		from orders);
        
        -- ANS:
        -- # user_id		 name
		--		6			Anupama
		--		7			Rishabh



































































































