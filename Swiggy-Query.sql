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
        
-- Qus- 2. Average Price/dish:

	-- ##########		EXPLANATION		#########
    -- here, we need f_id, avg. price with food name. 
    -- so avg price we will get from the menu table only.
    -- but we not only need avg price from whole price column.
    -- we need the avg price from the all f_id.
		-- for that we will do group by on f_id for avg(price) from each f_id
	-- after that we should also mention food name along with f_id.
			-- for that we will use foodn table where we get the food name will use join.
select
	menu.f_id,
    food.f_name,
    avg(menu.price) as avg_f_price
from swiggy_fooddelivery.menu
	join swiggy_fooddelivery.food on menu.f_id = food.f_id 
		group by f_id
        order by avg_f_price desc;
        
        /*
        -- ANS: 
        --  f_id,		 	f_name, 				avg_f_price 
		--	  1			Non-veg Pizza				  450.0000
		--	  2				Veg Pizza				  400.0000
		--	  5			Chicken Popcorn			   	  300.0000
		--	  4			Chicken Wings				  230.0000
		--	 10			Schezwan Noodles			  220.0000
		--	  6				Rice Meal			      213.3333
		--	  8				Masala Dosa				  180.0000
		--	 11			Veg Manchurian				  180.0000
		--	  7				Roti meal				  140.0000
		--	  9				Rava Idli				  120.0000
		--	  3			Choco Lava cake				   98.3333
			*/
            
 -- QUS-3. Find the top restaurant in terms of the number of orders for a given month           

	/*
    -- #########		 EXPLANATION:		##########
    -- here, given month menas we can select any months from our dataset..
    -- as we have only 3 months in dataset- May, June, July
    -- we pick June month here..
    -- So, from month of June which restaurant in top in terms of the number of order..
		-- means which restaurants getting maximum food orders.
	-- we use restaurants table and orders table for our scripting.
   /* 
    -- this qus is related to date...
		-- here, we are extracting months first as we are using June month.
			-- for extracting the month we will write below script..
				(select 
					*,
                    monthname(date)
				from orders) # Will get one more column which will give months name
                
			-- now only extracting the june month:
				(select 
					*,
                    monthname(date) as 'Month'
				from orders
					where Month like 'June') # get the June data only
                */
	-- now, after extracting June month's data we only extract top restaurant....
    -- which got more orders from june month's data.


-- ##########		for Month of "JUNE"		#################

select 
	orders.r_id,
    count(*) as order_cnt_Mntwise,
	monthname(date) as Month,
    restaurants.r_name
from swiggy_fooddelivery.orders
	join swiggy_fooddelivery.restaurants on orders.r_id = restaurants.r_id
		where monthname(date) like "June"
        group by r_id
        order by order_cnt_Mntwise desc
        limit 1;
        
        -- ANS:
        -- # r_id			order_cnt_Mntwise			Month			r_name
		--	  2						3					June			kfc

-- ##########		for Month of "MAY"		#################

select 
	count(*) as order_cnt_Mntwise,
	monthname(date) as Month,
    restaurants.r_name
from swiggy_fooddelivery.orders
	join swiggy_fooddelivery.restaurants on orders.r_id = restaurants.r_id
		where monthname(date) like "May"
        group by orders.r_id
        order by order_cnt_Mntwise desc
        limit 1;

		-- ANS:
        -- # r_id		order_cnt_Mntwise		Month			r_name
		--#		4				3				May			  Dosa Plaza

-- ##########		for Month of "JULY"		#################

select 
	count(*) as order_cnt_Mntwise,
	restaurants.r_name
from swiggy_fooddelivery.orders
	join swiggy_fooddelivery.restaurants on orders.r_id = restaurants.r_id
		where monthname(date) like "July"
        group by orders.r_id
        order by order_cnt_Mntwise desc
        limit 1;
        
        -- ANS:
        -- # 	order_cnt_Mntwise			r_name
		--				3					  kfc

-- Qus-4. restaurants with monthly sales greater than x for.
	-- ############		EXPLANATION		##############
    -- same as above  for month extractions -- applying "June" month:
	-- we want monthly sales...
	-- monthly sales amt can be anything like 500, 1000, 100000 rs. 
		-- here, we will choose "500 rs" for x amount.
        -- so, get the name mof restaurants which sales is greater than 500 rs. 

select
	restaurants.r_name,
    sum(orders.amount) as 'Revenue'
from swiggy_fooddelivery.orders
	join swiggy_fooddelivery.restaurants on orders.r_id = restaurants.r_id
	where monthname(date) like "June"
    group by orders.r_id
    having revenue > 500
    order by revenue desc;
    
    -- ANS:
    -- #		r_name			Revenue
	--			 kfc			  990
	--			dominos			  950

-- QUS-5.
-- Show all orders with order details for a particular customer in a particular date range

/*
	-- ##############		EXPLANATIONS		############
    -- In this qus. suppose we select any customer from users table like we choose Ankit..
	-- Now, We want to see all the orders of 'Ankit' in between 10 june to 10th July. 
	-- So, we will use order table.
    -- but we can't use user name direct with orders table...
	-- So, we need users table also for the users name. 
    -- we use user_id from users table and order table.

select 
*
from swiggy_fooddelivery.orders
	where user_id = (
		select
			user_id
		from swiggy_fooddelivery.users
			where  name like 'Ankit')

-- after that from given date. 
-- so we will add dates from 10th june, 2022 to 10th July, 2022.


select 
*
from swiggy_fooddelivery.orders
	where user_id = (
		select
			user_id
		from swiggy_fooddelivery.users
			where  name like 'Ankit')
	And (date > '2022-06-10' and date < date '2022-07-10')

-- now, we want deatils like from which restaurants he ordered in between that date.
-- also which items he ordered from that restaurants.
-- for that we need 'restaurant' table .
-- so we will join the 'restaiurant' table with 'orders' table.

select 
	orders.order_id,
    restaurants.r_name
from swiggy_fooddelivery.orders
	join swiggy_fooddelivery.restaurants on orders.r_id = restaurants.r_id
	where user_id = (
		select
			user_id
		from swiggy_fooddelivery.users
			where  name like 'Ankit')
	And (date > '2022-06-10' and date < date '2022-07-10')

-- after that what items he orders from that 2 restaurants..
-- we will get that details from the 'order_details' table:
-- from order_details table we get the f_id.
	-- orders --> restaurnats --> order_details 

select 
	orders.order_id,
    restaurants.r_name,
    order_details.f_id
from swiggy_fooddelivery.orders
	join swiggy_fooddelivery.restaurants on orders.r_id = restaurants.r_id
    join swiggy_fooddelivery.order_details on orders.order_id = order_details.order_id
	where user_id = (
		select
			user_id
		from swiggy_fooddelivery.users
			where  name like 'Ankit')
	And (date > '2022-06-10' and date < date '2022-07-10')

-- after getting the f_id we want food name.
-- which get it from food table.
-- so join the food table.....
	-- orders --> restaurants --> order_dertails --> food
*/

-- for User "Ankit":

select 
	orders.order_id,
    orders.date,
    restaurants.r_name,
    food.f_name
from swiggy_fooddelivery.orders
	join swiggy_fooddelivery.restaurants on orders.r_id = restaurants.r_id
    join swiggy_fooddelivery.order_details on orders.order_id = order_details.order_id
	join swiggy_fooddelivery.food on order_details.f_id = food.f_id
    where user_id = (
		select
			user_id
		from swiggy_fooddelivery.users
			where  name like 'Ankit')
	And (date > '2022-06-10' and date < date '2022-07-10');

	-- ANSWER:
    -- So. here we solve the query of users "Ankit"
    -- and the details of his orders from 10th june to 10th July, 2022.
    -- from which restaurants he ordered and what item he ordered with the date.
		-- # 	order_id			date			r_name			f_name
		--			1019		2022-06-30		China Town		Schezwan Noodles
		--			1018		2022-06-15		Dosa Plaza		Schezwan Noodles
		--			1019		2022-06-30		China Town		Veg Manchurian
		--			1018		2022-06-15		Dosa Plaza		Veg Manchurian

-- for useres "Vartika":

select 
	orders.order_id,
    orders.date,
    restaurants.r_name,
    food.f_name
from swiggy_fooddelivery.orders
	join swiggy_fooddelivery.restaurants on orders.r_id = restaurants.r_id
    join swiggy_fooddelivery.order_details on orders.order_id = order_details.order_id
	join swiggy_fooddelivery.food on order_details.f_id = food.f_id
    where user_id = (
		select
			user_id
		from swiggy_fooddelivery.users
			where  name like 'Vartika')
	And (date > '2022-06-10' and date < date '2022-07-10');

	-- ANSWER:
    --# 		order_id			date			r_name			f_name
	--				1015		2022-06-22				kfc			Chicken Wings
	--				1014		2022-06-11				kfc			Chicken Wings

-- QUS- 6. Find restaurants with max repeated customers.
	/*
	-- EXPLATIONS:
    -- here, we want Loyal customer means who order from that restaurant multiple times.
	-- So first preferance is 'order' table from there we get the total orders
    -- we will goup on 'user_id' and 'r_id' as we get the result of how many times users ordered..
	-- and from which restaurant he ordered.

select
	user_id,
	r_id,
    count(*) as 'Toatl_visit'
from swiggy_fooddelivery.orders
	group by user_id, r_id
    having Toatl_visit > 1
    order by Toatl_visit desc
    
    -- after that we will search 'loyal_customer' from restaurant, who got the order most.
	
select 
	r_id,
    count(*) as 'Loyal_Customer'
from (
	select
	user_id,
	r_id,
    count(*) as 'Toatl_visit'
from swiggy_fooddelivery.orders
	group by user_id, r_id
    having Toatl_visit > 1) as Total_visit
group by r_id
order by Loyal_Customer desc
limit 1

	-- we get the r_id and our "LOyal_customer".
    -- after that we need restaurant name.
	-- will use join for restaurant name.
 */
 
select 
	Total_visit.r_id,
    restaurants.r_name,
    count(*) as 'Loyal_Customer'
from (
	select
	user_id,
	r_id,
    count(*) as 'Toatl_visit'
from swiggy_fooddelivery.orders
	group by user_id, r_id
    having Toatl_visit > 1) as Total_visit
			join swiggy_fooddelivery.restaurants on Total_visit.r_id = restaurants.r_id
			group by Total_visit.r_id
			order by Loyal_Customer desc
			limit 1;
	
		-- ANSWER:
        -- # 	r_id			r_name		Loyal_Customer
		--		  2			      kfc			2

		-- So , KFC has 2 loyal customer 
        -- that menas only 2 customers who repeateed in KFC.

-- QUS- 7. Month over month revenue growth of swiggy.

	-- EXPLANATION:
    -- here we wnat revenue from all month.
    -- we have 3 months in our dataset.
    -- So, from all restaurants how much orders we got monthly that total is our revenue.
	-- for that we will use 'order' table first.
				/*
			-- at first we will fetch the months.

select 
	order_id,
    user_id,
    r_id,
    amount,
    monthname(date) as 'Month'
from swiggy_fooddelivery.orders
	
    -- So, we get the seprate column "Month'..
    -- NOw we will do group on month for monthly revenue.
    -- for monthly revenue amount we will sum the amount.
   
select 
	monthname(date) as 'Month',
    sum(amount) as 'Total_revenue'
from swiggy_fooddelivery.orders
	group by Month
	order by month(date)

	-- Now, main qus. MOnth over month what is the growth.
	-- means... Suppose your revenue in may month 100 rs. and in June it's 150.
			-- ... So how much you earn in June
            -- 		= (June 150 - May 100) / 150 (#June) = 0.33%  is growth. 
	-- for july growth we need June's growth..
		-- like july revenue is 250 rs. so growth will be....
			-- (june revenue - july revenue ) / July revenue
            -- 		= (250-150) / 250 = 0.4 %  is July month's growth.
	-- For that we will use "LAG Function" for downside window.
    -- will use "CTE: Comman Table Expression" function which stats with "With" function..
			...as we say to make "dummy table" 
	-- along with lag function:
     
    
     */
    -- ############		"LAG Function"		############ with     
	-- ############		"CTE"		#############
select 
	months, 
    ((total_revenue - Previous_mnt) / Previous_mnt) * 100 as 'revenue_growth_%'
from (
		with Sales as (
		select 
			monthname(date) as 'Months',
			sum(amount) as 'Total_revenue'
		from swiggy_fooddelivery.orders
			group by Months
			order by month(date)
			)
select 
	Months,
    Total_revenue,
    lag(Total_revenue, 1) 
		over(order by Total_revenue) as 'Previous_mnt'
from Sales
) t;

    -- ANSWER:
    -- # 		months				revenue_growth_%
	--				May					NULL
	--				June				32.7835
	--				July				50.4658
			-- EXPLNATION:
            -- as we can't get the first months revenue growth..
				-- ...as we needed prevoious growth 
                -- so it will be null for the first month growth.

-- QUS- 8. Customer - favorite food:

	-- Here, we need every customers name and his/ her fav. food's name.
    -- NOw, how we find fav. food so we can assume that..
		-- if users ordered "pizza" many times so "pizza" will be his fav. food.
	-- So, we will do gropup by on "users_id" with "f_id" for how many time users order that food.

with temp as (
select
	orders.user_id,
    order_details.f_id,
    count(*) as 'frequency'
from swiggy_fooddelivery.orders
	join swiggy_fooddelivery.order_details on orders.order_id = order_details.order_id
	group by orders.user_id, order_details.f_id
)
select 
	users.name,
    food.f_name,
    t1.frequency
from temp t1
	join swiggy_fooddelivery.users on t1.user_id = users.user_id
    join swiggy_fooddelivery.food on food.f_id = t1.f_id
	where t1.frequency = (
							select
								max(frequency)
							from temp t2
								where t2.user_id = t1.user_id);

		-- ANSWER:
        -- # 		name				f_name					frequency
--					Ankit			Schezwan Noodles				3
--					Ankit			Veg Manchurian					3
--					Khushboo		Choco Lava cake					3
--					Neha			Choco Lava cake					5
--					Nitish			Choco Lava cake					5
--					Vartika			Chicken Wings					3






































