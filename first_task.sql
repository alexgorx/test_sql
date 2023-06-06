-- 1. Написать запрос для вывода пользователей, которые не создали ни одного
-- поста и не оставили ни одного коммента. (несколько вариантов запроса)
-- PostgreSQL

-- 1. Первый и самый неоптимальный вариант
SELECT 
  DisplayName
FROM users
WHERE Id NOT in (SELECT DISTINCT OwnerUserId FROM posts)
  AND Id NOT in (SELECT DISTINCT UserID FROM comments)

-- 2.
SELECT 
  DisplayName
FROM users t1
JOIN 
  (SELECT Id FROM users
  EXCEPT
  SELECT DISTINCT(OwnerUserId) AS Id FROM posts 
  EXCEPT
  SELECT DISTINCT(UserID) AS Id FROM comments) t2
  ON t1.Id = t2.id

-- 3.
SELECT 
  DisplayName
FROM users t1
WHERE NOT EXISTS (
    SELECT OwnerUserId
    FROM posts t2
    WHERE t1.Id = t2.OwnerUserId)
    AND NOT EXISTS
    (SELECT UserId
    FROM comments t3
    WHERE t1.Id = t3.UserID)
    
-- 4.
SELECT 
  DisplayName
FROM users t1
WHERE NOT EXISTS (
  SELECT DISTINCT(t2.Id)
  FROM 
     (SELECT 
        OwnerUserId AS Id
      FROM posts
      UNION ALL
      SELECT UserId AS Id
      FROM comments) t2
  WHERE t1.Id = t2.Id)

