--Расширить п.3, добавив процент кол-ва комментариев пользователя от общего кол-ва

SELECT 
  t1.DisplayName,
  t2.comment_count,
  CONCAT(ROUND(t2.comment_count * 100.0 / t2.total_count, 2)::VARCHAR, '%')  AS percentage_total
FROM users t1
JOIN 
    (SELECT 
      t1.UserId,
      COUNT(t1.id) AS comment_count,
      t1.total_count
    FROM
      -- считаю оконной функцией общее количество комментариев 
      -- для расчета процента от обшего кол-ва в главном запросе
      (SELECT 
         *,
         COUNT(Id) OVER () AS total_count
       FROM comments) t1
    GROUP BY t1.UserId, t1.total_count
    ORDER BY comment_count DESC 
    LIMIT 3) t2
    ON t1.Id = t2.UserID
    
    -- Другая вариация запроса
    
SELECT 
  t1.DisplayName,
  t2.comment_count,
  CONCAT(t2.percentage_total::VARCHAR, '%') AS percentage_total
FROM Users t1
JOIN 
  (SELECT 
    DISTINCT(UserID),
    COUNT(Id) OVER (PARTITION BY UserID) AS comment_count,
    ROUND(COUNT(Id) OVER (PARTITION BY UserID) * 100.0 
              / COUNT(Id) OVER (), 2) AS percentage_total
  FROM comments
  ORDER BY comment_count DESC
  LIMIT 3
    ) t2
  ON t1.Id = t2.UserID  
