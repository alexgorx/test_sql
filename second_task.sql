--Написать запрос для вывода года, кол-ва постов за год и кол-во комментов за год.
-- PostgreSQL

SELECT
  t1.year AS year,
  t1.post_cnt, AS post_counts,
  t2.comment_cnt AS comment_counts
FROM
    (SELECT
      DATE_PART('year', CreationDate) AS year,
      COUNT(Id) AS post_cnt
    FROM posts
    WHERE CreationDate BETWEEN (current_date - '1 year'::interval) AND current_date
    GROUP BY year) t1
    JOIN
    (SELECT 
      DATE_PART('year', CreationDate) AS year,
      COUNT(Id) AS comment_cnt
    FROM comments
    WHERE CreationDate BETWEEN (current_date - '1 year'::interval) AND current_date
    GROUP BY year) t2
    ON t1.year = t2.year
  
  -- если предусматривать возможность отсутствия публикаций 
  -- или комментариев за указанный отрезок времени, запрос будет следующим:
  
  SELECT
  COALESCE(t1.year,t2.year) AS year,
  COALESCE(t1.post_cnt,0) AS post_counts,
  COALESCE(t2.comment_cnt,0) AS comment_counts
FROM
    (SELECT
      DATE_PART('year', CreationDate) AS year,
      COUNT(Id) AS post_cnt
    FROM posts
    WHERE CreationDate BETWEEN (current_date - '1 year'::interval) AND current_date
    GROUP BY year) t1
    FULL JOIN
    (SELECT 
      DATE_PART('year', CreationDate) AS year,
      COUNT(Id) AS comment_cnt
    FROM comments
    WHERE CreationDate BETWEEN (current_date - '1 year'::interval) AND current_date
    GROUP BY year) t2
    ON t1.year = t2.year
