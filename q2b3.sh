SELECT team, AVG(elo1_post) AS avg_elo_rating
FROM (
    SELECT team1 AS team, elo1_post
    FROM your_dataset_table
    UNION ALL
    SELECT team2 AS team, elo2_post
    FROM your_dataset_table
) AS all_teams
GROUP BY team
ORDER BY avg_elo_rating DESC
LIMIT 1;
