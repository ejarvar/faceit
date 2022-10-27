/* 
The following table is a snapshot of a table in our data warehouse which stores data for each match played on FACEIT
(the original table has millions of rows, and the below is a snapshot). Each row has a unique combination of
user_id/match_id, which together serve as the table’s primary key.
*/

CREATE TABLE faceit (
  user_id varchar,
  match_id varchar,
  game_id varchar,
  created_at timestamp,
  membership varchar,
  faction varchar,
  winner varchar
);

INSERT INTO faceit
values
('ab542a', 'e21887', 'csgo', '2018-01-02 18:45:25', 'free', 'faction1', 'faction1')
,( 'ef72da', 'df891f', 'dota2', '2018-01-02 08:20:01', 'free', 'faction2', 'faction1')
,( 'ef72da', 'df892', 'dota2', '2018-07-09 15:15:33', 'free', 'faction2', 'faction2')
,( 'ef72da', 'df892', 'dota2', '2018-01-03 08:20:01', 'free', 'faction2', 'faction2')
,('ab542a', 'we2341', 'csgo', '2018-01-03 18:45:26', 'free', 'faction1', 'faction1')
,('ab542a', 'hy23fr', 'csgo', '2018-01-03 19:20:00', 'free', 'faction1', 'faction2')
,('ab542a', 'uj46er', 'csgo', '2018-01-04 19:20:00', 'free', 'faction1', 'faction1')
,('ab542a', 'nm5grt', 'csgo', '2018-01-04 19:20:00', 'free', 'faction1', 'faction1')
,('f5c776', '1p5c47', 'wot_RU', '2017-12-30 15:25:25', 'free', 'faction1', 'faction2')
,('5a278a', 'af14e8', 'csgo', '2018-01-01 14:27:15', 'premium', 'faction2', 'faction2')
;

/*
Write a query which finds the list of all users who had at least one winning streak of 3 matches on the platform. A
streak here is defined as achieving three or more consecutive wins in the same game. If a user won a match then
his/her faction will be the same as the faction in the winner column.
*/
WITH user_streaks AS (
  SELECT
    user_id,
    match_id,
    game_id,
    created_at,
    iif (faction=winner, true, false) AS result_win,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) as user_order,
    ROW_NUMBER() OVER (PARTITION BY user_id, iif (faction=winner, true, false) ORDER BY created_at ASC) AS user_condition_order,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) - ROW_NUMBER() OVER (PARTITION BY user_id, iif (faction=winner, true, false) ORDER BY created_at ASC) AS streak_id
  FROM faceit
)
SELECT DISTINCT user_id
FROM user_streaks
WHERE result_win = true
GROUP BY user_id, streak_id
HAVING count(*) >= 1