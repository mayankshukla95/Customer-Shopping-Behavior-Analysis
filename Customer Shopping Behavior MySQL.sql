use customer_behaviour;

Select * From customer;

-- Q1. What is the total revenue genereted by male vs. female customers?
Select
	gender,
	sum(purchase_amount) as Revenue_by_Gender
From customer
Group By gender;

-- Q2. Which customers used a discount but still spent more than the average purchase amount?
Select
	customer_id,
    purchase_amount
From customer
Where discount_applied = "Yes" and purchase_amount >= (	Select avg(purchase_amount) From customer);

-- Q3. Which are the top 5 products with the highest average review rating?
Select
	item_purchased,
    round(avg(review_rating), 2) as avg_review_rating
From customer
Group By item_purchased
Order BY avg_review_rating Desc
Limit 5;

-- Q4. Compare the average purchase amount between Standard and Express Shipping?
Select
	shipping_type,
    round(avg(purchase_amount), 2) as avg_purchase_amount
From customer
Where shipping_type In ("Standard","Express")
Group By shipping_type;

-- Q5. Do subscribed customers spend more? Compare average spend and total revenue between subscribes and non-subscribers.
Select
	subscription_status,
    Count(customer_id) as total_customers,
    round(avg(purchase_amount), 2) as avg_purchase_amount,
    sum(purchase_amount) as total_purchase_amount
From customer
Group By subscription_status;

-- Q6. Which 5 products have the highest percentage of purchases with discount applied?
Select
	item_purchased,
    Round(100 * Sum(Case When discount_applied = "Yes" Then 1 Else 0 End) / Count(*), 2) as discount_rate
From customer
Group By item_purchased
Order BY discount_rate desc
Limit 5;

-- Q7. Segment customers into New, returning and Loyal based on their number of previous purchases, and show the count of each segment.
With customer_type as (
Select
	customer_id,
    previous_purchases,
    Case
		When previous_purchases = 1 Then "New"
        When previous_purchases between 2 and 10 Then "Returning"
        Else "Loyal"
	End as customer_segment
From customer
)
Select
	customer_segment,
    Count(*) as "Number_of_Customers"
From customer_type
Group By customer_segment;

-- Q8. What are the top 3 most purchased products within each category?
With item_counts as (
Select
	category,
    item_purchased,
    count(customer_id) as total_orders,
    row_number() over (partition by category order by count(customer_id) Desc) as item_rank
From customer
Group BY category, item_purchased
)
Select
	item_rank,
    category,
    item_purchased,
    total_orders
From item_counts
Where item_rank <= 3;

-- Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
Select
	subscription_status,
    Count(*) as repeat_buyers
From customer
Where previous_purchases > 5
Group By subscription_status;

-- Q10. What is the revenue contribution of each age group?
Select 
	age_group,
    sum(purchase_amount) as revenue
From customer
Group By age_group
Order By revenue Desc;














