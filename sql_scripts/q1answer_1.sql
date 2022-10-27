SELECT game_id, count(*)
FROM (
      SELECT DISTINCT game_id, match_id
      FROM faceit
      WHERE membership = 'premium'
      -- AND YEAR(created_at) = 2018
      AND strftime('%Y', created_at) = 2018
      GROUP BY game_id, match_id
)
GROUP BY game_id


SELECT game_id, COUNT(*)
FROM (
    SELECT DISTINCT game_id, match_id
    FROM faceit
    WHERE membership = 'premium'
    -- AND YEAR(created_at) = 2018
    AND strftime('%Y', created_at) = 2018
    GROUP BY game_id, match_id, membership
    HAVING COUNT(*) >= 1
)
GROUP BY game_id