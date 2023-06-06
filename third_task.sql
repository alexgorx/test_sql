-- Вывести 3 самых активных (по кол-ву комментариев) пользователей (display
-- name) и их кол-во комментариев
-- PostgreSQL

SELECT 
  t1.DisplayName,
  t2.comment_count
FROM Users t1
JOIN 
  (SELECT 
    UserID,
    COUNT(Id) AS comment_count
  FROM comments
  GROUP BY UserID
  ORDER BY comment_count DESC
  LIMIT 3) t2
  ON t1.Id = t2.UserID
