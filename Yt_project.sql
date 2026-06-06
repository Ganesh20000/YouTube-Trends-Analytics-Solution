use yt;





select channel_name,count(*),max(views) as  max_views from trending_videos
group by channel_name
order by max_views DESC
limit 10;


-- Find top 10 most viewed videos.
select title, views from trending_videos
order by views desc
limit 10;


-- Get all videos where likes > 100000.
select title,likes,subscriber_count from trending_videos
where likes>100000;


-- count distinct category
select DISTINCT(count(category)) from trending_videos;


-- Count total number of videos per category.
select category,count(*) from trending_videos
group by category;

-- Find average views per category.
select category ,avg(views) from trending_videos 
group by category;

-- List videos published in 2024.
select * from trending_videos
where publish_date=2024;
-- Get videos with has_emoji_title = 1.

select * from trending_videos
where has_emoji_title=1;


-- Find videos where comments are disabled.
select * from trending_videos
where comments_enabled=0;



-- Show top 5 videos with highest engagement_score.

select title ,video_id, engagement_score from trending_videos
order by engagement_score desc
limit 5;
-- Find videos with duration more than 10 minutes.
select * from trending_videos
where duration_seconds >600;

-- Count how many videos are made for kids.;
select * from trending_videos
where made_for_kids=1;




--country wise total videos
SELECT v.trending_country, c.total_videos 
FROM trending_videos v
JOIN category_summary c
  ON v.category = c.category
  
LIMIT 10;



-- top 10 category with count 
select category,count(category) total_count from trending_videos
group by category
order by  total_count desc
limit 10  ;


-- Mid level question to do 

-- Find categories with more than 100 videos.
select category,count(*) counts from trending_videos 
group by category
having counts>500
order by counts desc;

-- Get average likes and comments per category.
select category ,round(avg(likes),2),round(avg(comments),2) from trending_videos
group by category;


-- Join videos table with category_summary and show category + avg_views.
select   c.category ,avg(v.views)  as avg_views from category_summary c
join trending_videos v
on c.category=v.category
group by c.category;

-- Find top 5 categories by avg_engagement.
select category, round(avg(engagement_score),2) from trending_videos
group by category;

-- Get videos where views are above category average.
SELECT title, category, views
FROM trending_videos v
WHERE views > (
    SELECT AVG(views)
    FROM trending_videos
    WHERE category = v.category
);


select * from trending_videos t
where views >(
select avg(views) from trending_videos
where category=t.category);

-- using join lets solve this 
select title,views,c.category from trending_videos v
join (
select category,avg(views) as avg_views 
from trending_videos
group by category  ) c
on c.category=v.category
where v.views>c.avg_views;

SELECT v.title, v.views, v.category
FROM trending_videos v
JOIN (
    SELECT category, AVG(views) AS avg_views 
    FROM trending_videos
    GROUP BY category
) c
ON v.category = c.category
WHERE v.views > c.avg_views;




group by category;


select * from trending_videos;
select channel_name, title,views,trending_country from trending_videos
where (channel_name ,views) in (
select channel_name, max(views) from trending_videos
group by channel_name);

show tables;

select c.category,c.total_videos,max(v.views),v.title from trending_videos V
join category_summary c
on v.category=c.category
group by c.category,c.total_videos,v.title;


use yt;


select * from (

select category,views,
rank() over(PARTITION BY category order by views desc) as ranks from trending_videos) t
where  t.ranks=1;



-- top videos with category and total videows by ranks
select * from (
select t.category,t.views,c.total_videos,
rank() over(PARTITION BY category order by views desc) as ranks from trending_videos t
join category_summary C
on c.category=t.category)t
where t.ranks=1;




-- select * from trending_videos;
-- select * from trending_videos;

-- select * from movies
 
-- select * from category_summary;

-- select * from yearly_trends;




-- CTE (WITH)
-- Use CTE to rank videos by views and get top 5

with tops as(

    select title,views ,rank() over( order by views desc ) as ranks
    from trending_videos
)
select title,views  from tops
where ranks<=5;
select * from top_5;


--- category wise top 5 views most

with tops_5 as(
    select title, category ,views ,
    rank() over(PARTITION BY category order by views desc) as ranks
    from trending_videos
)
select title,category,views,ranks
from tops_5
where ranks<=5;


-- Using CTE, calculate engagement difference from category average.
with eng as (
    select category ,ROUND(avg(engagement_score),3) as category_engagement from trending_videos
    group by category 
)
select v.title,v.category,e.category_engagement,v.engagement_score,round((v.engagement_score-e.category_engagement),2) as diffrence  from trending_videos v
join eng e
on v.category=e.category;
select * from trending_videos;




-- Window Functions
--Rank videos within each category based on views.

select category ,views ,
rank() over(PARTITION BY category  order by views desc) as ranks
from trending_videos;

use yt;
-- Find top 3 most liked videos per year.
select * from(
select title,publish_date ,likes ,
rank() over(PARTITION BY EXTRACT(year from publish_date) order by likes desc ) as top_3 from trending_videos ) e
where e.top_3<=3;


--Calculate running total of views per year.

select title, EXTRACT( year from publish_date),
sum(views) over(PARTITION BY EXTRACT(YEAR from publish_date)) as published_year
from trending_videos;

use yt;



-- Advanced Join Logic

-- Join videos + category_summary + yearly_trends

select * from trending_videos t
join category_summary c
on t.category=c.category
join yearly_trends y
on t.publish_date=y.year;



-- Show: video title, category avg_views, yearly avg_views
select t.title,y.year,sum(views) as views from trending_videos t
join category_summary c
on t.category=c.category
join yearly_trends y
on t.publish_date=y.year
group by t.title,y.year;



Find videos where:
views > category avg_views
AND views > yearly avg_views

--Find average engagement per year from yearly_trends.
select * from trending_videos;
select channel_name, title,views,trending_country from trending_videos
where (channel_name ,views) in (
select channel_name, max(views) from trending_videos
group by channel_name);



-- top videos with category and total videows by ranks
select * from (
select t.category,t.views,c.total_videos,
rank() over(PARTITION BY category order by views desc) as ranks from trending_videos t
join category_summary C
on c.category=t.category)t
where t.ranks=1;



-- -- Most views category wise video title 
select c.category,c.total_videos,max(v.views),v.title from trending_videos V
join category_summary c
on v.category=c.category
group by c.category,c.total_videos,v.title;





--trending country wise channel name and title 
select t.channel_name,t.views,t.trending_country,t.title from trending_videos t
join (
    select channel_name,max(views) as max_view from trending_videos
    group by channel_name
) sub
on t.channel_name=sub.channel_name
and t.views = sub.max_view ;