SELECT * FROM project.swiggy_data;

select * from swiggy_data 
where  state is  null;

select * from swiggy_data 
where  city is  null;

SELECT 
    count(CASE WHEN order_date  IS NULL THEN 1  END) AS Order_date_nulls,
    count(CASE WHEN Restaurant_name IS NULL THEN 1 END) AS Restaurant_name_nulls,
     count(CASE WHEN Location  IS NULL THEN 1  END) AS Location_nulls,
    count(CASE WHEN Category IS NULL THEN 1  END) AS Category_nulls,
    count(CASE WHEN dish_name  IS NULL THEN 1  END) AS dish_name_nulls,
    count(CASE WHEN price IS NULL THEN 1 END) AS price_nulls,
     count(CASE WHEN rating IS NULL THEN 1  END) AS rating_nulls,
    count(CASE WHEN rating_count IS NULL THEN 1 END) AS rating_count_nulls
    FROM swiggy_data;
    
    select count(state)  from swiggy_data
    where state = '';
     select count(city)  from swiggy_data
    where city = '';
     select count(order_date)  from swiggy_data
    where order_date = '';
    select count(restaurant_name)  from swiggy_data
    where rastaurant_name = '';
    select count(location)  from swiggy_data
    where location = '';
    select count(category)  from swiggy_data
    where Category = '';
    select count(Dish_name)  from swiggy_data
    where Dish_Name = '';
    select count(price)  from swiggy_data
    where price = '';
    select count(Rating)  from swiggy_data
    where  Rating = '';
    select count(Rating_count)  from swiggy_data
    where Rating_Count = '';
    
    select state ,city, order_date , Restaurant_name , Location , category , Dish_name ,Price ,Rating , Rating_count
    from swiggy_data
    group by state ,city, order_date , Restaurant_name , Location , category , Dish_name ,Price ,Rating , Rating_count
    having count(*) >1;
    
    -- Total Orders
SELECT COUNT(*) AS Total_Orders FROM swiggy_data;

-- Total Revenue
SELECT SUM(Price)/1000000 AS Revenue_Million FROM swiggy_data;

-- Average Price
SELECT AVG(Price) AS Avg_Price FROM swiggy_data;

-- Average Rating
SELECT AVG(Rating) AS Avg_Rating FROM swiggy_data;




