#!/bin/bash

# Install mysql-server and python3-flask packages
echo "Please enter your sudo password:"
read -s password
echo $password | sudo -S apt-get install mysql-server python3-flask -y || { echo "Failed to install MySQL server"; exit 1; }

# Download the dataset
echo "Downloading dataset..."
wget -O nba_elo_latest.csv https://projects.fivethirtyeight.com/nba-model/nba_elo_latest.csv || { echo "Failed to download dataset"; exit 1; }

# Execute MySQL commands
echo "Entering MySQL server..."
sudo mysql --local-infile=1 <<EOF
CREATE DATABASE IF NOT EXISTS corin_database;
USE corin_database;

CREATE TABLE IF NOT EXISTS nba_elo_2023 (
    `date` DATE,
    season INT,
    neutral INT,
    playoff VARCHAR(1),
    team1 VARCHAR(255),
    team2 VARCHAR(255),
    elo1_pre DECIMAL(10,3),
    elo2_pre DECIMAL(10,3),
    elo_prob1 DECIMAL(10,3),
    elo_prob2 DECIMAL(10,3),
    elo1_post DECIMAL(10,3),
    elo2_post DECIMAL(10,3),
    `carm-elo1_pre` DECIMAL(10,3),
    `carm-elo2_pre` DECIMAL(10,3),
    `carm-elo_prob1` DECIMAL(10,3),
    `carm-elo_prob2` DECIMAL(10,3),
    `carm-elo1_post` DECIMAL(10,3),
    `carm-elo2_post` DECIMAL(10,3),
    raptor1_pre DECIMAL(10,3),
    raptor2_pre DECIMAL(10,3),
    raptor_prob1 DECIMAL(10,3),
    raptor_prob2 DECIMAL(10,3),
    score1 INT,
    score2 INT,
    quality DECIMAL(10,3),
    importance DECIMAL(10,3),
    total_rating DECIMAL(10,3)
);

-- Debugging messages
SELECT "Database and table created successfully" AS Message;

-- Enable local infile loading for the current session only
SET GLOBAL local_infile = 1;

-- Debugging messages
SHOW VARIABLES LIKE 'local_infile'; 

LOAD DATA LOCAL INFILE 'nba_elo_latest.csv'
INTO TABLE nba_elo_2023
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(`date`, season, neutral, playoff, team1, team2, elo1_pre, elo2_pre, elo_prob1, elo_prob2, elo1_post, elo2_post, `carm-elo1_pre`, `carm-elo2_pre`, `carm-elo_prob1`, `carm-elo_prob2`, `carm-elo1_post`, `carm-elo2_post`, raptor1_pre, raptor2_pre, raptor_prob1, raptor_prob2, score1, score2, quality, importance, total_rating)
SET 
    elo1_pre = ROUND(elo1_pre, 3),
    elo2_pre = ROUND(elo2_pre, 3),
    elo_prob1 = ROUND(elo_prob1, 3),
    elo_prob2 = ROUND(elo_prob2, 3),
    elo1_post = ROUND(elo1_post, 3),
    elo2_post = ROUND(elo2_post, 3),
    `carm-elo1_pre` = ROUND(`carm-elo1_pre`, 3),
    `carm-elo2_pre` = ROUND(`carm-elo2_pre`, 3),
    `carm-elo_prob1` = ROUND(`carm-elo_prob1`, 3),
    `carm-elo_prob2` = ROUND(`carm-elo_prob2`, 3),
    `carm-elo1_post` = ROUND(`carm-elo1_post`, 3),
    `carm-elo2_post` = ROUND(`carm-elo2_post`, 3),
    raptor1_pre = ROUND(raptor1_pre, 3),
    raptor2_pre = ROUND(raptor2_pre, 3),
    raptor_prob1 = ROUND(raptor_prob1, 3),
    raptor_prob2 = ROUND(raptor_prob2, 3),
    quality = ROUND(quality, 3),
    importance = ROUND(importance, 3),
    total_rating = ROUND(total_rating, 3);

-- Debugging messages
SELECT "Data loaded successfully" AS Message;

EOF

echo "MySQL commands executed successfully."

