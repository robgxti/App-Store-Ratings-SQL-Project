CREATE TABLE AppleStore_description_combined AS

SELECT * from appleStore_description1

UNION ALL

SELECT * from appleStore_description2

UNION ALL

SELECT * from appleStore_description3

UNION ALL

SELECT * from appleStore_description4

**EXPLORATORY DATA ANALYSIS**

--check the number of unique apps in both tablesAppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore_description_combined

--check for any missing values in key fieldsAppleStore

SELECT COUNT(*) as MissingValues
from AppleStore
WHERE track_name is NULL or user_rating is NULL or prime_genre is NULL

SELECT COUNT(*) as MissingValues
from AppleStore_description_combined
WHERE app_desc is NULL

--Find out the number of apps per genre

SELECT prime_genre, COUNT(*) as NumApps
FROM AppleStore
GROUP BY prime_genre
Order by NumApps DESC

--Get an overview of app ratings

SELECT min(user_rating) AS MinRating,
	   max(user_rating) AS MaxRating,
       avg(user_rating) as AvgRating
From AppleStore

**DATA ANALYSIS**

--Determine whether paid apps have higher ratings than free apps AppleStore

SELECT CASE	
		WHEN price > 0 then 'Paid'
        else 'Free'
    End as App_Type,
    avg(user_rating) as Avg_Rating
From AppleStore
group by App_Type

--Check if apps that support more than one language have higher ratings AppleStore

SELECT CASE
		when lang_num < 10 then '<10 languages'
        when lang_num > 10 AND 30 then '10-30 languages'
        else '>30 languages' 
    End as language_bucket,
    avg(user_rating) as Avg_Rating
From AppleStore
Group By language_bucket
order by Avg_Rating DESC

--Check genres with low ratings 

SELECT prime_genre,
	   avg(user_rating) as Avg_Rating 
From AppleStore
Group by prime_genre
order by Avg_Rating ASC
LIMIT 10 

--Check if there is a correlation between the length of an app description and rating 

SELECT CASE	
			when length(b.app_desc) <500 then 'Short'
            when length(b.app_desc) BETWEEN 500 and 1000 then 'Medium'
            Else 'Long'
       END as description_length_bucket,
       avg(a.user_rating) as average_rating

FROM
	AppleStore as A
join
	AppleStore_description_combined as B
ON
	A.id = B.id
    
GROUP By description_length_bucket
Order by average_rating DESC

--Check the top rated apps for each genre 

SELECT
	prime_genre,
    track_name,
    user_rating
From (
  	  SELECT
  	  prime_genre,
  	  track_name,
  	  user_rating,
  	  RANK() OVER(PARTITION BY prime_genre order BY user_rating DESC, rating_count_tot desc) as rank
      FROM 
      AppleStore
      ) As a
WHERE 
a.rank = 1


**FINDINGS & SUPPORTING RECOMMENDATIONS**

--1. PAID APPS HAVE BETTER RATINGS
--2. APPS SUPPORTING BETWEEN 10 AND 30 LANGUAGES HAVE BETTER RATINGS 
--3. FINANCE AND BOOK APPS HAVE LOW RATINGS. POTENTIAL FOR OPPORTUNITY FOR NEW APPS
--4. APPS WITH LONGER DESCRIPTIONS HAVE BETTER RATINGS 
--5. AVERAGE RATINGS OF ALL APPS IS APPROX. 3.50/5
--6. GAMES AND ENTERTAINMENT HAVE HIGH COMPETITION 
